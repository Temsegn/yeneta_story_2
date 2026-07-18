import User from "../models/user_model.js";
import {
  getFirebaseMessaging,
  isFirebaseConfigured,
} from "../config/firebase.js";

/**
 * Register or refresh a device push token for a user.
 */
export async function registerDeviceToken(userId, token, platform = "other") {
  if (!token || typeof token !== "string") {
    throw Object.assign(new Error("token is required"), { statusCode: 400 });
  }

  const user = await User.findById(userId);
  if (!user) throw Object.assign(new Error("User not found"), { statusCode: 404 });

  const normalized = token.trim();
  // One FCM token belongs to one signed-in account at a time.
  await User.updateMany(
    { _id: { $ne: userId }, "deviceTokens.token": normalized },
    { $pull: { deviceTokens: { token: normalized } } }
  );

  const existing = (user.deviceTokens || []).find((t) => t.token === normalized);
  if (existing) {
    existing.platform = platform || existing.platform;
    existing.updatedAt = new Date();
  } else {
    user.deviceTokens.push({
      token: normalized,
      platform: platform || "other",
      updatedAt: new Date(),
    });
  }

  // Keep the newest 10 tokens per user.
  user.deviceTokens = user.deviceTokens
    .sort((a, b) => new Date(b.updatedAt) - new Date(a.updatedAt))
    .slice(0, 10);

  await user.save();
  return { message: "Device token registered", count: user.deviceTokens.length };
}

export async function removeDeviceToken(userId, token) {
  await User.updateOne(
    { _id: userId },
    { $pull: { deviceTokens: { token } } }
  );
  return { message: "Device token removed" };
}

/**
 * Send a push payload to a user's registered devices.
 * MongoDB owns users/notifications; Firebase Admin is delivery-only.
 */
export async function sendPushToUser(userId, { title, body, data = {} } = {}) {
  const user = await User.findById(userId).select("deviceTokens").lean();
  const tokens = (user?.deviceTokens || []).map((t) => t.token).filter(Boolean);
  if (!tokens.length) {
    return { sent: 0, skipped: true, reason: "no_device_tokens" };
  }

  if (!isFirebaseConfigured()) {
    console.log(
      `[push] Firebase Admin not configured — in-app notification saved for ${userId}, device push skipped`
    );
    return {
      sent: 0,
      skipped: true,
      reason: "firebase_admin_not_configured",
      tokens: tokens.length,
    };
  }

  const response = await getFirebaseMessaging().sendEachForMulticast({
    tokens,
    notification: { title, body },
    data: Object.fromEntries(
      Object.entries(data).map(([key, value]) => [
        key,
        String(value ?? ""),
      ])
    ),
    android: {
      priority: "high",
      notification: {
        channelId: "yeneta_alerts",
        sound: "default",
      },
    },
    apns: {
      payload: {
        aps: {
          sound: "default",
          badge: 1,
        },
      },
    },
  });

  const invalidTokens = [];
  response.responses.forEach((result, index) => {
    const code = result.error?.code;
    if (
      code === "messaging/registration-token-not-registered" ||
      code === "messaging/invalid-registration-token"
    ) {
      invalidTokens.push(tokens[index]);
    }
  });

  if (invalidTokens.length) {
    await User.updateOne(
      { _id: userId },
      { $pull: { deviceTokens: { token: { $in: invalidTokens } } } }
    );
  }

  return {
    sent: response.successCount,
    failed: response.failureCount,
    total: tokens.length,
  };
}
