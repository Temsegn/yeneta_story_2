import {
  getUserNotifications,
  getNotificationById,
  markNotificationAsRead,
  markAllNotificationsAsRead,
  deleteNotification,
} from "../services/notification_service.js";

/**
 * Get user notifications
 * GET /api/v1/notifications
 */
export const getNotifications = async (req, res) => {
  try {
    const { limit = 50, skip = 0 } = req.query;
    const result = await getUserNotifications(req.user._id, {
      limit: parseInt(limit),
      skip: parseInt(skip),
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
 * Get single notification
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
 * Mark notification as read
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
 * Mark all notifications as read
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
 * Delete notification
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
 * Get unread count
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
