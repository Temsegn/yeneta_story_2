import mongoose from "mongoose";
import Payment from "../models/payment_models.js";
import Subscription from "../models/subscription_models.js";
import { logAction } from "../utils/auditLogger.js";

export async function createPaymentService(userId, data, ipAddress = null) {
  const { amount, paymentMethod, plan } = data;

  // Input validation
  if (!amount || !paymentMethod || !plan) throw new Error("amount, paymentMethod, and plan are required");
  if (!["monthly", "yearly"].includes(plan)) throw new Error("Invalid plan");
  if (!["telebirr", "credit_card", "paypal"].includes(paymentMethod)) throw new Error("Invalid payment method");

  const session = await mongoose.startSession();
  try {
    session.startTransaction();

    // Check for active subscription
    const existing = await Subscription.findOne({
      user: userId,
      status: "active",
      endDate: { $gt: new Date() },
    }).session(session);

    if (existing) throw new Error("You already have an active subscription");

    const startDate = new Date();
    const endDate = plan === "monthly"
      ? new Date(startDate.getTime() + 30 * 24 * 60 * 60 * 1000)
      : new Date(startDate.getTime() + 365 * 24 * 60 * 60 * 1000);

    // Create subscription
    const [subscription] = await Subscription.create(
      [{ user: userId, plan, price: amount, startDate, endDate, status: "active" }],
      { session }
    );

    // Create payment
    const [payment] = await Payment.create(
      [{ userId, amount, paymentMethod, subscription: subscription._id, status: "completed" }],
      { session }
    );

    // Audit log
    if (ipAddress) {
      await logAction({
        user: userId,
        action: "CREATE_PAYMENT",
        targetModel: "Payment",
        targetId: payment._id,
        ipAddress,
      });
    }

    await session.commitTransaction();
    session.endSession();

    // Populate for frontend
    const populatedPayment = await Payment.findById(payment._id)
      .populate("userId", "fullName email")
      .populate("subscription");

    return { payment: populatedPayment, subscription };
  } catch (error) {
    await session.abortTransaction();
    session.endSession();
    throw error;
  }
}

export async function verifyPaymentService(transactionId) {
  const session = await mongoose.startSession();
  try {
    session.startTransaction();

    const payment = await Payment.findOne({ transactionId }).session(session);
    if (!payment) throw new Error("Payment not found");
    if (payment.status === "completed") {
      await session.commitTransaction();
      session.endSession();
      return { message: "Payment already verified", payment };
    }

    payment.status = "completed";
    await payment.save({ session });

    const subscription = await Subscription.findById(payment.subscription).session(session);
    if (subscription) {
      subscription.status = "active";
      await subscription.save({ session });
    }

    // Audit log
    await logAction({
      user: payment.userId,
      action: "VERIFY_PAYMENT",
      targetModel: "Payment",
      targetId: payment._id,
    });

    await session.commitTransaction();
    session.endSession();

    return { message: "Payment verified successfully", payment, subscription };
  } catch (error) {
    await session.abortTransaction();
    session.endSession();
    throw error;
  }
}