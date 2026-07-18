import Notification from "../models/notification_models.js";
import User from "../models/user_model.js";
import { sendPushToUser } from "./push_service.js";

/**
 * Get user notifications
 */
export async function getUserNotifications(userId, { limit = 50, skip = 0 } = {}) {
  const [notifications, unreadCount, total] = await Promise.all([
    limit > 0
      ? Notification.find({ user: userId })
          .sort({ createdAt: -1 })
          .limit(limit)
          .skip(skip)
      : Promise.resolve([]),
    Notification.countDocuments({ user: userId, isRead: false }),
    Notification.countDocuments({ user: userId }),
  ]);

  return {
    notifications,
    unreadCount,
    total,
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
 * Create in-app notification and attempt a device push.
 */
export async function createNotification(data, { push = true } = {}) {
  const notification = await Notification.create(data);

  if (push) {
    try {
      await sendPushToUser(notification.user, {
        title: notification.title,
        body: notification.message,
        data: {
          notificationId: String(notification._id),
          type: notification.type,
          actionUrl: notification.actionUrl || "",
        },
      });
    } catch (err) {
      console.error("Push send failed:", err.message);
    }
  }

  return notification;
}

/**
 * Broadcast a notification to many users (or all parents).
 */
export async function broadcastNotification({
  title,
  message,
  type = "system",
  actionUrl,
  userIds,
} = {}) {
  if (!title || !message) {
    throw Object.assign(new Error("title and message are required"), {
      statusCode: 400,
    });
  }

  let targets = userIds;
  if (!targets?.length) {
    const users = await User.find({
      role: "parent",
      isActive: { $ne: false },
    })
      .select("_id")
      .lean();
    targets = users.map((u) => u._id);
  }

  const docs = targets.map((userId) => ({
    user: userId,
    title,
    message,
    type,
    actionUrl,
  }));

  if (!docs.length) {
    return { created: 0, pushed: 0 };
  }

  const created = await Notification.insertMany(docs);
  let pushed = 0;
  for (const n of created) {
    try {
      const result = await sendPushToUser(n.user, {
        title: n.title,
        body: n.message,
        data: {
          notificationId: String(n._id),
          type: n.type,
          actionUrl: n.actionUrl || "",
        },
      });
      pushed += result.sent || 0;
    } catch (_) {
      // keep going
    }
  }

  return { created: created.length, pushed };
}

export async function sendWelcomeNotification(userId) {
  await createNotification({
    user: userId,
    title: "Welcome to Yeneta Story!",
    message: "Start your 5-day free trial and explore premium stories, videos, and books.",
    type: "system",
  });
}

export async function sendTrialExpiryReminder(userId, daysLeft) {
  await createNotification({
    user: userId,
    title: "Trial Ending Soon",
    message: `Your free trial ends in ${daysLeft} day${daysLeft === 1 ? "" : "s"}. Subscribe to keep premium access.`,
    type: "subscription",
    actionUrl: "/subscription",
  });
}

export async function sendSubscriptionActivatedNotification(userId, plan) {
  await createNotification({
    user: userId,
    title: "Subscription Activated!",
    message: `Your ${plan} subscription is now active. Enjoy unlimited premium content.`,
    type: "subscription",
    actionUrl: "/subscription",
  });
}

export async function sendPaymentSuccessNotification(userId, amount, plan) {
  await createNotification({
    user: userId,
    title: "Payment Successful",
    message: `Your payment of ${amount} ETB for ${plan} has been processed successfully.`,
    type: "payment",
  });
}

export async function sendNewContentNotification(userId, contentTitle, contentType) {
  await createNotification({
    user: userId,
    title: `New ${contentType} Available`,
    message: `Check out "${contentTitle}" — a new adventure awaits!`,
    type: "content",
  });
}
