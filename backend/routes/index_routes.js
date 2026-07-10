import express from "express";
import authRoutes from "./auth_routes.js";
import videoRoutes from "./video_routes.js";
import subscriptionRoutes from "./subscription_routes.js";
import paymentRoutes from "./payment_routes.js";
import bookRoutes from "./book_routes.js";
import storyRoutes from "./story_routes.js";
import auditlogRoutes from "./auditlog_routes.js";
import chapaRoutes from "./chapa_routes.js";
import notificationRoutes from "./notification_routes.js";
import adminRoutes from "./admin_routes.js";
import educationRoutes from "./education_routes.js";

const router = express.Router();
router.use("/auth", authRoutes);
router.use("/videos", videoRoutes);
router.use("/subscriptions", subscriptionRoutes);
router.use("/payments", paymentRoutes);
router.use("/payments/chapa", chapaRoutes);
router.use("/books", bookRoutes);
router.use("/auditlogs", auditlogRoutes);
router.use("/stories", storyRoutes);
router.use("/notifications", notificationRoutes);
router.use("/admin", adminRoutes);
router.use("/education", educationRoutes);

export default router;