import { checkUserAccess } from "../services/chapa_service.js";

/**
 * Middleware to check if user has access to premium content
 * Can be used on video, book, and story routes
 */
export const checkPremiumAccess = async (req, res, next) => {
  try {
    const accessInfo = await checkUserAccess(req.user._id);

    if (!accessInfo.hasAccess) {
      return res.status(403).json({
        message: accessInfo.message || "Access denied. Please subscribe to view premium content.",
        hasAccess: false,
        accessType: null,
      });
    }

    // Attach access info to request for use in controllers
    req.userAccess = accessInfo;
    next();
  } catch (error) {
    console.error("Premium access check error:", error);
    res.status(500).json({
      message: "Failed to verify access",
    });
  }
};

/**
 * Middleware to check access and attach info without blocking
 * Useful for endpoints that show both free and premium content
 */
export const attachAccessInfo = async (req, res, next) => {
  try {
    const accessInfo = await checkUserAccess(req.user._id);
    req.userAccess = accessInfo;
    next();
  } catch (error) {
    console.error("Access info attachment error:", error);
    req.userAccess = {
      hasAccess: false,
      accessType: null,
      plan: null,
      daysLeft: 0,
    };
    next();
  }
};
