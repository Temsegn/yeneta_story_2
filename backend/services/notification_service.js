import Notification from "../models/notification_models.js";

/**
 * Get user notifications
 */
export async function getUserNotifications(userId, { limit = 50, skip = 0 } = {}) {
  const notifications = await Notification.find({ user: userId })
    .sort({ createdAt: -1 })
    .limit(limit)
    .skip(skip);

  const unreadCount = await Notification.countDocuments({
    user: userId,
    isRead: false,
  });

  return {
    notifications,
    unreadCount,
    total: await Notification.countDocuments({ user: userId }),
  };
}

/**
 * Get single notification
 */
export async function getNotificationById(notificationId, userId) {
  const notification = await Notification.findOne({
    _id: notificationId,
    user: userId,
  });

  if (!notification) {
    throw new Error("Notification not found");
  }

  return notification;
}

/**
 * Mark notification as read
 */
export async function markNotificationAsRead(notificationId, userId) {
  const notification = await Notification.findOneAndUpdate(
    { _id: notificationId, user: userId },
    { isRead: true },
    { new: true }
  );

  if (!notification) {
    throw new Error("Notification not found");
  }

  return notification;
}

/**
 * Mark all notifications as read
 */
export async function markAllNotificationsAsRead(userId) {
  const result = await Notification.updateMany(
    { user: userId, isRead: false },
    { isRead: true }
  );

  return {
    message: "All notifications marked as read",
    modifiedCount: result.modifiedCount,
  };
}

/**
 * Delete notification
 */
export async function deleteNotification(notificationId, userId) {
  const notification = await Notification.findOneAndDelete({
    _id: notificationId,
    user: userId,
  });

  if (!notification) {
    throw new Error("Notification not found");
  }

  return { message: "Notification deleted successfully" };
}

/**
 * Create notification (internal use)
 */
export async function createNotification(data) {
  const notification = await Notification.create(data);
  return notification;
}

/**
 * Send welcome notification to new user
 */
export async function sendWelcomeNotification(userId) {
  await createNotification({
    user: userId,
    title: "Welcome to Kids Learning App!",
    message: "Start your 5-day free trial and explore premium content.",
    type: "system",
  });
}

/**
 * Send trial expiry reminder
 */
export async function sendTrialExpiryReminder(userId, daysLeft) {
  await createNotification({
    user: userId,
    title: "Trial Ending Soon",
    message: `Your free trial ends in ${daysLeft} days. Subscribe to continue enjoying premium content.`,
    type: "subscription",
    actionUrl: "/subscription",
  });
}

/**
 * Send subscription activated notification
 */
export async function sendSubscriptionActivatedNotification(userId, plan) {
  await createNotification({
    user: userId,
    title: "Subscription Activated!",
    message: `Your ${plan} subscription is now active. Enjoy unlimited access to all premium content.`,
    type: "subscription",
  });
}

/**
 * Send payment success notification
 */
export async function sendPaymentSuccessNotification(userId, amount, plan) {
  await createNotification({
    user: userId,
    title: "Payment Successful",
    message: `Your payment of ${amount} ETB for ${plan} subscription has been processed successfully.`,
    type: "payment",
  });
}

/**
 * Send new content notification
 */
export async function sendNewContentNotification(userId, contentTitle, contentType) {
  await createNotification({
    user: userId,
    title: `New ${contentType} Available`,
    message: `Check out "${contentTitle}" - a new adventure awaits!`,
    type: "content",
  });
}
