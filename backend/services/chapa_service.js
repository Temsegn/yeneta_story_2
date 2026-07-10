import axios from "axios";
import crypto from "crypto";
import mongoose from "mongoose";
import Payment from "../models/payment_models.js";
import Subscription from "../models/subscription_models.js";
import User from "../models/user_model.js";
import { logAction } from "../utils/auditLogger.js";
import { toChapaPhone } from "../utils/phoneNormalizer.js";
import {
  sendSubscriptionActivatedNotification,
  sendPaymentSuccessNotification,
} from "./notification_service.js";

const CHAPA_BASE_URL = "https://api.chapa.co/v1";
const CHAPA_SECRET_KEY = process.env.CHAPA_SECRET_KEY;
const CHAPA_WEBHOOK_SECRET = process.env.CHAPA_WEBHOOK_SECRET;

/**
 * Authoritative plan catalog — amount is NEVER taken from the client.
 */
export const SUBSCRIPTION_PLANS = {
  premium_monthly: {
    id: "premium_monthly",
    name: "Premium Monthly",
    price: 499,
    durationDays: 30,
  },
  premium_yearly: {
    id: "premium_yearly",
    name: "Premium Yearly",
    price: 4999,
    durationDays: 365,
  },
  // Legacy aliases kept for older clients.
  yearly: {
    id: "yearly",
    name: "Yearly",
    price: 1000,
    durationDays: 365,
  },
  semiannual: {
    id: "semiannual",
    name: "6-Month",
    price: 600,
    durationDays: 183,
  },
};

function generateTxRef(userId, planId) {
  const timestamp = Date.now();
  const randomString = crypto.randomBytes(4).toString("hex");
  const userIdShort = userId.toString().slice(-6);
  // Keep plan id readable but shorten prefixes for Chapa's 50-char limit.
  const planShort = String(planId).replace("premium_", "p");
  return `SUB_${userIdShort}_${planShort}_${timestamp}_${randomString}`;
}

function resolvePlanIdFromTxRef(txRef) {
  // SUB_user_plan_timestamp_random  OR  legacy user_plan_timestamp_random
  const parts = String(txRef).split("_");
  if (parts[0] === "SUB" && parts.length >= 4) {
    const short = parts[2];
    if (short === "pmonthly") return "premium_monthly";
    if (short === "pyearly") return "premium_yearly";
    return short;
  }
  if (parts.length >= 2) return parts[1];
  throw new Error("Invalid transaction reference format");
}

function splitName(fullName = "") {
  const parts = String(fullName).trim().split(/\s+/).filter(Boolean);
  const firstName = parts[0] || "User";
  const lastName = parts.length > 1 ? parts.slice(1).join(" ") : firstName;
  return { firstName, lastName };
}

/**
 * POST /subscriptions/checkout
 * Body: { planId } only — amount comes from SUBSCRIPTION_PLANS.
 * Creates a PENDING subscription, pending payment, then initializes Chapa.
 */
export async function checkoutSubscription(userId, planId) {
  const plan = SUBSCRIPTION_PLANS[planId];
  if (!plan) {
    throw new Error(
      "Invalid planId. Use 'premium_monthly' or 'premium_yearly'."
    );
  }

  const user = await User.findById(userId);
  if (!user) throw new Error("User not found");

  const now = new Date();
  const existingActive = await Subscription.findOne({
    user: userId,
    status: "active",
    endDate: { $gt: now },
  });
  if (existingActive || (user.isPremium && user.premiumExpiresAt > now)) {
    throw new Error("You already have an active subscription");
  }

  // Clean stale pending checkout attempts (>30 min).
  const thirtyMinutesAgo = new Date(Date.now() - 30 * 60 * 1000);
  await Subscription.updateMany(
    {
      user: userId,
      status: "pending",
      createdAt: { $lt: thirtyMinutesAgo },
    },
    { $set: { status: "failed" } }
  );
  await Payment.deleteMany({
    userId,
    status: "pending",
    createdAt: { $lt: thirtyMinutesAgo },
  });

  let txRef;
  for (let i = 0; i < 5; i++) {
    txRef = generateTxRef(userId, planId);
    const exists =
      (await Payment.findOne({ txRef })) ||
      (await Subscription.findOne({ txRef }));
    if (!exists) break;
    await new Promise((r) => setTimeout(r, 10));
  }

  const subscription = await Subscription.create({
    user: userId,
    plan: planId,
    price: plan.price,
    status: "pending",
    txRef,
    startDate: null,
    endDate: null,
  });

  const payment = await Payment.create({
    userId,
    amount: plan.price,
    paymentMethod: "chapa",
    status: "pending",
    txRef,
    subscription: subscription._id,
  });

  const { firstName, lastName } = splitName(user.fullName);
  const baseUrl = (
    process.env.CLIENT_URL || "https://yeneta-zq3w.onrender.com"
  ).replace(/\/$/, "");
  const callbackUrl =
    process.env.CHAPA_CALLBACK_URL ||
    `${baseUrl}/api/v1/payments/chapa/webhook`;

  // Chapa requires an https return_url. Custom schemes (myapp://) break the
  // hosted checkout page (often surfaces as a generic 419 error).
  const returnUrl =
    process.env.CHAPA_RETURN_URL?.startsWith("http")
      ? process.env.CHAPA_RETURN_URL
      : `${baseUrl}/api/v1/payments/chapa/return?status=success`;

  const isTestMode = String(CHAPA_SECRET_KEY || "").includes("TEST");
  // In test mode Chapa ONLY accepts official test phones — real numbers fail
  // on "Pay with test mode". See https://developer.chapa.co/test/testing-mobile
  const CHAPA_TEST_PHONE = "0900123456";
  const chapaPhone = isTestMode
    ? CHAPA_TEST_PHONE
    : toChapaPhone(user.phoneNumber) || CHAPA_TEST_PHONE;

  // Email is optional on our users; Chapa still expects a valid email when sent.
  const chapaEmail =
    user.email && String(user.email).includes("@")
      ? String(user.email).slice(0, 50)
      : `user${String(user._id).slice(-8)}@customers.yeneta.app`;

  try {
    const response = await axios.post(
      `${CHAPA_BASE_URL}/transaction/initialize`,
      {
        amount: plan.price.toString(),
        currency: "ETB",
        email: chapaEmail,
        first_name: firstName.slice(0, 35),
        last_name: lastName.slice(0, 35),
        phone_number: chapaPhone,
        tx_ref: txRef,
        callback_url: callbackUrl,
        return_url: returnUrl,
        customization: {
          title: plan.name.slice(0, 16),
          description: `Subscribe for ${plan.durationDays} days`.slice(0, 50),
        },
      },
      {
        headers: {
          Authorization: `Bearer ${CHAPA_SECRET_KEY}`,
          "Content-Type": "application/json",
        },
      }
    );

    if (response.data.status !== "success") {
      await Payment.findByIdAndDelete(payment._id);
      subscription.status = "failed";
      await subscription.save();
      throw new Error(response.data.message || "Payment initialization failed");
    }

    return {
      checkout_url: response.data.data.checkout_url,
      tx_ref: txRef,
      planId,
      amount: plan.price,
      currency: "ETB",
    };
  } catch (error) {
    await Payment.findByIdAndDelete(payment._id);
    subscription.status = "failed";
    await subscription.save();

    if (error.response) {
      throw new Error(
        error.response.data?.message ||
          error.response.data?.error ||
          "Chapa API error"
      );
    }
    throw error;
  }
}

/** Legacy alias used by /payments/chapa/init-payment */
export async function initializePayment(userId, data) {
  const planId = data.plan || data.planId;
  return checkoutSubscription(userId, planId);
}

export async function verifyPaymentWithChapa(txRef) {
  const response = await axios.get(
    `${CHAPA_BASE_URL}/transaction/verify/${txRef}`,
    {
      headers: { Authorization: `Bearer ${CHAPA_SECRET_KEY}` },
    }
  );

  if (response.data.status === "success") {
    return response.data.data;
  }
  throw new Error("Payment verification failed");
}

/**
 * Activate PENDING subscription after Chapa success.
 */
export async function processSuccessfulPayment(txRef, chapaData) {
  const session = await mongoose.startSession();

  try {
    session.startTransaction();

    const payment = await Payment.findOne({ txRef }).session(session);
    if (!payment) throw new Error("Payment record not found");

    const planId =
      resolvePlanIdFromTxRef(txRef) ||
      (await Subscription.findById(payment.subscription).session(session))?.plan;

    const plan = SUBSCRIPTION_PLANS[planId];
    if (!plan) throw new Error(`Unknown plan for tx_ref: ${txRef}`);

    if (parseFloat(chapaData.amount) !== plan.price) {
      throw new Error("Amount mismatch");
    }

    if (payment.status === "completed") {
      await session.commitTransaction();
      session.endSession();
      return {
        message: "Payment already processed",
        payment,
        subscription: await Subscription.findById(payment.subscription),
      };
    }

    const startDate = new Date();
    const endDate = new Date();
    endDate.setDate(startDate.getDate() + plan.durationDays);

    let subscription = await Subscription.findOne({ txRef }).session(session);
    if (!subscription && payment.subscription) {
      subscription = await Subscription.findById(payment.subscription).session(
        session
      );
    }

    if (subscription) {
      subscription.status = "active";
      subscription.startDate = startDate;
      subscription.endDate = endDate;
      subscription.price = plan.price;
      subscription.plan = planId;
      subscription.txRef = txRef;
      await subscription.save({ session });
    } else {
      const [created] = await Subscription.create(
        [
          {
            user: payment.userId,
            plan: planId,
            price: plan.price,
            status: "active",
            txRef,
            startDate,
            endDate,
          },
        ],
        { session }
      );
      subscription = created;
    }

    payment.status = "completed";
    payment.subscription = subscription._id;
    payment.chapaReference = chapaData.reference;
    payment.transactionId = chapaData.trx_ref || txRef;
    await payment.save({ session });

    await User.findByIdAndUpdate(
      payment.userId,
      {
        hasActiveSubscription: true,
        subscriptionEndDate: endDate,
        isPremium: true,
        premiumExpiresAt: endDate,
        currentPlan: planId,
      },
      { session }
    );

    await logAction({
      user: payment.userId,
      action: "SUBSCRIPTION_ACTIVATED",
      targetModel: "Subscription",
      targetId: subscription._id,
    });

    await sendPaymentSuccessNotification(payment.userId, plan.price, planId);
    await sendSubscriptionActivatedNotification(payment.userId, planId);

    await session.commitTransaction();
    session.endSession();

    return {
      message: "Subscription activated successfully",
      payment,
      subscription,
    };
  } catch (error) {
    await session.abortTransaction();
    session.endSession();

    // Mark linked pending subscription as failed when verification fails hard.
    try {
      await Subscription.updateOne(
        { txRef, status: "pending" },
        { $set: { status: "failed" } }
      );
      await Payment.updateOne(
        { txRef, status: "pending" },
        { $set: { status: "failed" } }
      );
    } catch (_) {}

    throw error;
  }
}

export function verifyWebhookSignature(payload, signature) {
  if (!CHAPA_WEBHOOK_SECRET) {
    console.warn(
      "CHAPA_WEBHOOK_SECRET not set, skipping signature verification"
    );
    return true;
  }

  const hash = crypto
    .createHmac("sha256", CHAPA_WEBHOOK_SECRET)
    .update(JSON.stringify(payload))
    .digest("hex");

  return hash === signature;
}

export async function handleWebhook(payload, signature) {
  if (!verifyWebhookSignature(payload, signature)) {
    throw new Error("Invalid webhook signature");
  }

  const { event, data } = payload;
  if (event !== "charge.success") {
    return { message: "Event ignored", event };
  }

  const { tx_ref, status, amount, reference } = data;
  if (!tx_ref || !status || !amount || !reference) {
    throw new Error("Invalid webhook payload: missing required fields");
  }

  if (status !== "success") {
    await Subscription.updateOne(
      { txRef: tx_ref, status: "pending" },
      { $set: { status: "failed" } }
    );
    await Payment.updateOne(
      { txRef: tx_ref, status: "pending" },
      { $set: { status: "failed" } }
    );
    return { message: "Payment not successful", status };
  }

  // Prefer live verification over trusting webhook alone.
  const verified = await verifyPaymentWithChapa(tx_ref);
  return processSuccessfulPayment(tx_ref, {
    amount: verified.amount ?? amount,
    reference: verified.reference ?? reference,
    trx_ref: verified.trx_ref || tx_ref,
  });
}

/**
 * Premium access: paid subscription OR active free trial.
 */
export async function checkUserAccess(userId) {
  const user = await User.findById(userId);
  if (!user) throw new Error("User not found");

  const now = new Date();

  const premiumUntil =
    user.premiumExpiresAt || user.subscriptionEndDate || null;
  const isPremiumNow =
    (user.isPremium || user.hasActiveSubscription) &&
    premiumUntil &&
    premiumUntil > now;

  if (isPremiumNow) {
    const daysLeft = Math.ceil(
      (premiumUntil - now) / (1000 * 60 * 60 * 24)
    );
    return {
      hasAccess: true,
      isPremium: true,
      accessType: "subscription",
      plan: user.currentPlan,
      daysLeft,
      expiresAt: premiumUntil,
      requiresPayment: false,
      fullName: user.fullName,
    };
  }

  if (user.trialEndDate && user.trialEndDate > now) {
    const daysLeft = Math.ceil(
      (user.trialEndDate - now) / (1000 * 60 * 60 * 24)
    );
    return {
      hasAccess: true,
      isPremium: false,
      accessType: "trial",
      plan: "trial",
      daysLeft,
      expiresAt: user.trialEndDate,
      requiresPayment: false,
      fullName: user.fullName,
    };
  }

  return {
    hasAccess: false,
    isPremium: false,
    accessType: null,
    plan: null,
    daysLeft: 0,
    expiresAt: null,
    requiresPayment: true,
    fullName: user.fullName,
    message:
      "Your free trial has ended. Please subscribe to unlock premium content.",
  };
}

/**
 * GET /subscriptions/me shape for Flutter.
 */
export async function getSubscriptionMe(userId) {
  const access = await checkUserAccess(userId);
  const active = await Subscription.findOne({
    user: userId,
    status: "active",
    endDate: { $gt: new Date() },
  }).sort({ endDate: -1 });

  return {
    isPremium: !!access.isPremium || access.accessType === "trial",
    hasAccess: access.hasAccess,
    accessType: access.accessType,
    plan: active?.plan || access.plan,
    expiresAt: active?.endDate || access.expiresAt,
    daysLeft: access.daysLeft,
    requiresPayment: access.requiresPayment,
    fullName: access.fullName,
    message: access.message,
    plans: Object.values(SUBSCRIPTION_PLANS)
      .filter((p) => p.id.startsWith("premium_"))
      .map((p) => ({
        planId: p.id,
        name: p.name,
        price: p.price,
        durationDays: p.durationDays,
        currency: "ETB",
      })),
  };
}

export async function getExpiringSubscriptions(daysBeforeExpiry = 7) {
  const now = new Date();
  const targetDate = new Date();
  targetDate.setDate(now.getDate() + daysBeforeExpiry);

  return User.find({
    $or: [
      {
        isPremium: true,
        premiumExpiresAt: { $gte: now, $lte: targetDate },
      },
      {
        hasActiveSubscription: true,
        subscriptionEndDate: { $gte: now, $lte: targetDate },
      },
    ],
  }).select(
    "fullName email subscriptionEndDate premiumExpiresAt currentPlan isPremium"
  );
}

