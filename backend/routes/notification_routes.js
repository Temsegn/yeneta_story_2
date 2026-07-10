import express from "express";
import {
  getNotifications,
  getNotification,
  markAsRead,
  markAllAsRead,
  deleteNotificationController,
  getUnreadCount,
} from "../controllers/notification_controllers.js";
import { protect } from "../middlewares/auth_middlewares.js";

const router = express.Router();

/**
 * @swagger
 * /api/v1/notifications:
 *   get:
 *     summary: Get user notifications
 *     tags: [Notifications]
 *     security:
 *       - bearerAuth: []
 */
router.get("/", protect, getNotifications);

/**
 * @swagger
 * /api/v1/notifications/unread-count:
 *   get:
 *     summary: Get unread notification count
 *     tags: [Notifications]
 *     security:
 *       - bearerAuth: []
 */
router.get("/unread-count", protect, getUnreadCount);

/**
 * @swagger
 * /api/v1/notifications/read-all:
 *   patch:
 *     summary: Mark all notifications as read
 *     tags: [Notifications]
 *     security:
 *       - bearerAuth: []
 */
router.patch("/read-all", protect, markAllAsRead);

/**
 * @swagger
 * /api/v1/notifications/:id:
 *   get:
 *     summary: Get single notification
 *     tags: [Notifications]
 *     security:
 *       - bearerAuth: []
 */
router.get("/:id", protect, getNotification);

/**
 * @swagger
 * /api/v1/notifications/:id/read:
 *   patch:
 *     summary: Mark notification as read
 *     tags: [Notifications]
 *     security:
 *       - bearerAuth: []
 */
router.patch("/:id/read", protect, markAsRead);

/**
 * @swagger
 * /api/v1/notifications/:id:
 *   delete:
 *     summary: Delete notification
 *     tags: [Notifications]
 *     security:
 *       - bearerAuth: []
 */
router.delete("/:id", protect, deleteNotificationController);

export default router;
