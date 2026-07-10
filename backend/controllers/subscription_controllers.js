import {
  getMySubscriptionService,
  checkMySubscriptionService,
  registerSubscriptionService,
  checkoutSubscriptionService,
} from "../services/subscription_service.js";

export const getMySubscription = async (req, res) => {
  try {
    const subscription = await getMySubscriptionService(req.user._id);
    res.status(200).json(subscription);
  } catch (error) {
    res.status(404).json({ message: error.message });
  }
};

export const checkMySubscription = async (req, res) => {
  try {
    const result = await checkMySubscriptionService(req.user._id);
    res.status(200).json(result);
  } catch (error) {
    res.status(500).json({ message: "Subscription check failed" });
  }
};

/**
 * POST /subscriptions/checkout
 * Body: { planId: "premium_monthly" | "premium_yearly" }
 */
export const checkoutSubscription = async (req, res) => {
  try {
    const planId = req.body.planId || req.body.plan;
    if (!planId) {
      return res.status(400).json({ message: "planId is required" });
    }

    const result = await checkoutSubscriptionService(req.user._id, planId);

    res.status(200).json({
      message: "Checkout initialized successfully",
      data: result,
    });
  } catch (error) {
    res.status(400).json({
      message:
        typeof error.message === "string"
          ? error.message
          : "Checkout initialization failed",
      code: "CHECKOUT_FAILED",
    });
  }
};

export const registerSubscription = async (req, res) => {
  try {
    const subscription = await registerSubscriptionService(
      req.user._id,
      req.body
    );
    res.status(201).json(subscription);
  } catch (error) {
    res.status(400).json({ message: error.message });
  }
};
