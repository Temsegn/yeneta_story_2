import {
  getUserNotifications,
  getNotificationById,
  markNotificationAsRead,
  markAllNotificationsAsRead,
  deleteNotification,
  broadcastNotification,
} from "../services/notification_service.js";
import {
  registerDeviceToken,
  removeDeviceToken,
} from "../services/push_service.js";

/**
 * GET /api/v1/notifications
 */
export const getNotifications = async (req, res) => {
  try {
    const { limit = 50, skip = 0 } = req.query;
    const result = await getUserNotifications(req.user._id, {
      limit: parseInt(limit, 10),
      skip: parseInt(skip, 10),
    });

    res.status(200).json(result);
  } catch (error) {
    console.error("Get notifications error:", error);
    res.status(500).json({
      message: error.message || "Failed to fetch notifications",
    });
  }
};

/**
 * GET /api/v1/notifications/:id
 */
export const getNotification = async (req, res) => {
  try {
    const notification = await getNotificationById(req.params.id, req.user._id);
    res.status(200).json(notification);
  } catch (error) {
    console.error("Get notification error:", error);
    res.status(404).json({
      message: error.message || "Notification not found",
    });
  }
};

/**
 * PATCH /api/v1/notifications/:id/read
 */
export const markAsRead = async (req, res) => {
  try {
    const notification = await markNotificationAsRead(req.params.id, req.user._id);
    res.status(200).json({
      message: "Notification marked as read",
      notification,
    });
  } catch (error) {
    console.error("Mark as read error:", error);
    res.status(404).json({
      message: error.message || "Notification not found",
    });
  }
};

/**
 * PATCH /api/v1/notifications/read-all
 */
export const markAllAsRead = async (req, res) => {
  try {
    const result = await markAllNotificationsAsRead(req.user._id);
    res.status(200).json(result);
  } catch (error) {
    console.error("Mark all as read error:", error);
    res.status(500).json({
      message: error.message || "Failed to mark notifications as read",
    });
  }
};

/**
 * DELETE /api/v1/notifications/:id
 */
export const deleteNotificationController = async (req, res) => {
  try {
    const result = await deleteNotification(req.params.id, req.user._id);
    res.status(200).json(result);
  } catch (error) {
    console.error("Delete notification error:", error);
    res.status(404).json({
      message: error.message || "Notification not found",
    });
  }
};

/**
 * GET /api/v1/notifications/unread-count
 */
export const getUnreadCount = async (req, res) => {
  try {
    const result = await getUserNotifications(req.user._id, { limit: 0 });
    res.status(200).json({
      unreadCount: result.unreadCount,
    });
  } catch (error) {
    console.error("Get unread count error:", error);
    res.status(500).json({
      message: error.message || "Failed to get unread count",
    });
  }
};

/**
 * POST /api/v1/notifications/device-token
 * Body: { token, platform? }
 */
export const saveDeviceToken = async (req, res) => {
  try {
    const { token, platform } = req.body || {};
    const result = await registerDeviceToken(req.user._id, token, platform);
    res.status(200).json(result);
  } catch (error) {
    res.status(error.statusCode || 400).json({
      message: error.message || "Failed to register device token",
    });
  }
};

/**
 * DELETE /api/v1/notifications/device-token
 * Body: { token }
 */
export const deleteDeviceToken = async (req, res) => {
  try {
    const { token } = req.body || {};
    if (!token) {
      return res.status(400).json({ message: "token is required" });
    }
    const result = await removeDeviceToken(req.user._id, token);
    res.status(200).json(result);
  } catch (error) {
    res.status(400).json({
      message: error.message || "Failed to remove device token",
    });
  }
};

/**
 * POST /api/v1/admin/notifications/broadcast
 * Body: { title, message, type?, actionUrl?, userIds? }
 */
export const broadcast = async (req, res) => {
  try {
    const result = await broadcastNotification(req.body || {});
    res.status(201).json({
      message: "Notifications sent",
      ...result,
    });
  } catch (error) {
    res.status(error.statusCode || 400).json({
      message: error.message || "Broadcast failed",
    });
  }
};
