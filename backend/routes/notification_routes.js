import express from "express";
import {
  getNotifications,
  getNotification,
  markAsRead,
  markAllAsRead,
  deleteNotificationController,
  getUnreadCount,
  saveDeviceToken,
  deleteDeviceToken,
} from "../controllers/notification_controllers.js";
import { protect } from "../middlewares/auth_middlewares.js";

const router = express.Router();

router.use(protect);

router.get("/", getNotifications);
router.get("/unread-count", getUnreadCount);
router.patch("/read-all", markAllAsRead);
router.post("/device-token", saveDeviceToken);
router.delete("/device-token", deleteDeviceToken);
router.get("/:id", getNotification);
router.patch("/:id/read", markAsRead);
router.delete("/:id", deleteNotificationController);

export default router;
