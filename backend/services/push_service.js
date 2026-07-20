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

function buildMulticastMessage(tokens, { title, body, data = {} }) {
  return {
    tokens,
    notification: { title, body },
    data: Object.fromEntries(
      Object.entries(data).map(([key, value]) => [key, String(value ?? "")])
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
  };
}

/**
 * Send a push payload to many FCM tokens (chunks of 500).
 */
export async function sendPushToTokens(tokens, payload = {}) {
  const unique = [...new Set((tokens || []).filter(Boolean))];
  if (!unique.length) {
    return { sent: 0, skipped: true, reason: "no_device_tokens" };
  }

  if (!isFirebaseConfigured()) {
    console.log(
      `[push] Firebase Admin not configured — device push skipped (${unique.length} tokens)`
    );
    return {
      sent: 0,
      skipped: true,
      reason: "firebase_admin_not_configured",
      tokens: unique.length,
    };
  }

  const messaging = getFirebaseMessaging();
  let sent = 0;
  let failed = 0;
  const invalidTokens = [];

  for (let i = 0; i < unique.length; i += 500) {
    const chunk = unique.slice(i, i + 500);
    const response = await messaging.sendEachForMulticast(
      buildMulticastMessage(chunk, payload)
    );
    sent += response.successCount;
    failed += response.failureCount;
    response.responses.forEach((result, index) => {
      const code = result.error?.code;
      if (
        code === "messaging/registration-token-not-registered" ||
        code === "messaging/invalid-registration-token"
      ) {
        invalidTokens.push(chunk[index]);
      }
    });
  }

  if (invalidTokens.length) {
    await User.updateMany(
      {},
      { $pull: { deviceTokens: { token: { $in: invalidTokens } } } }
    );
  }

  return { sent, failed, total: unique.length };
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

  return sendPushToTokens(tokens, { title, body, data });
}
