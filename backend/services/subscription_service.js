import Subscription from "../models/subscription_models.js";
import {
  checkoutSubscription,
  getSubscriptionMe,
} from "./chapa_service.js";

export const getMySubscriptionService = async (userId) => {
  return getSubscriptionMe(userId);
};

export const checkMySubscriptionService = async (userId) => {
  const me = await getSubscriptionMe(userId);
  return {
    active: !!me.hasAccess,
    isPremium: !!me.isPremium,
    plan: me.plan,
    expiresAt: me.expiresAt,
  };
};

export const checkoutSubscriptionService = async (userId, planId) => {
  if (!planId) throw new Error("planId is required");
  return checkoutSubscription(userId, planId);
};

export const registerSubscriptionService = async (userId, data) => {
  const { plan, durationInDays, price, endDate: reqEndDate } = data;

  if (!plan || price === undefined) {
    throw new Error("plan and price are required");
  }
  if (!durationInDays && !reqEndDate) {
    throw new Error("Either durationInDays or endDate must be provided");
  }

  const existing = await Subscription.findOne({
    user: userId,
    status: "active",
    endDate: { $gt: new Date() },
  });

  if (existing) {
    throw new Error("You already have an active subscription");
  }

  const startDate = new Date();
  let endDate;

  if (reqEndDate) {
    endDate = new Date(reqEndDate);
  } else {
    endDate = new Date();
    endDate.setDate(startDate.getDate() + Number(durationInDays));
  }

  if (isNaN(endDate.getTime())) {
    throw new Error("Invalid date provided");
  }

  const subscription = await Subscription.create({
    user: userId,
    plan,
    price,
    status: "active",
    startDate,
    endDate,
  });

  return subscription;
};
