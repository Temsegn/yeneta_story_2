import { checkUserAccess } from "../services/chapa_service.js";

export const checkSubscription = async (req, res, next) => {
  try {
    const content = req.content;

    // Free content is always accessible (even after the trial ends).
    if (!content?.isPremium) {
      return next();
    }

    // Premium content: allowed during the 5-day free trial OR with an
    // active paid subscription. checkUserAccess covers both cases.
    const access = await checkUserAccess(req.user._id);

    if (!access.hasAccess) {
      return res.status(403).json({
        message:
          access.message ||
          "Your free trial has ended. Please subscribe to view premium content.",
        hasAccess: false,
        requiresPayment: true,
      });
    }

    req.userAccess = access;
    next();
  } catch (error) {
    return res.status(500).json({
      message: "Subscription check failed",
    });
  }
};
