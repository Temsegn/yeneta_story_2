import cron from "node-cron";
import { getExpiringSubscriptions } from "../services/chapa_service.js";
import { sendTrialExpiryReminder } from "../services/notification_service.js";
import User from "../models/user_model.js";

/**
 * Check and update expired subscriptions
 * Runs daily at midnight
 */
export function startSubscriptionCron() {
  cron.schedule("0 0 * * *", async () => {
    console.log("Running subscription expiry check...");

    try {
      const now = new Date();

      const expiredUsers = await User.find({
        $or: [
          { hasActiveSubscription: true, subscriptionEndDate: { $lt: now } },
          { isPremium: true, premiumExpiresAt: { $lt: now } },
        ],
      });

      console.log(`Found ${expiredUsers.length} expired subscriptions`);

      for (const user of expiredUsers) {
        user.hasActiveSubscription = false;
        user.isPremium = false;
        user.premiumExpiresAt = user.premiumExpiresAt || user.subscriptionEndDate;
        user.currentPlan = "trial";
        await user.save();
        console.log(
          `Deactivated subscription for user: ${user.email || user.phoneNumber}`
        );
      }

      console.log("Subscription expiry check completed");
    } catch (error) {
      console.error("Subscription cron error:", error);
    }
  });

  // Reminder for subscriptions/trials expiring soon — daily 9 AM
  cron.schedule("0 9 * * *", async () => {
    console.log("Checking for expiring subscriptions/trials...");

    try {
      const expiringUsers = await getExpiringSubscriptions(7);
      console.log(
        `Found ${expiringUsers.length} subscriptions expiring in 7 days`
      );

      for (const user of expiringUsers) {
        const end = user.premiumExpiresAt || user.subscriptionEndDate;
        const daysLeft = Math.max(
          1,
          Math.ceil((new Date(end) - new Date()) / (1000 * 60 * 60 * 24))
        );
        await sendTrialExpiryReminder(user._id, daysLeft);
      }

      const now = new Date();
      const inThreeDays = new Date(now);
      inThreeDays.setDate(now.getDate() + 3);
      const trialUsers = await User.find({
        role: "parent",
        isPremium: { $ne: true },
        hasActiveSubscription: { $ne: true },
        trialEndDate: { $gte: now, $lte: inThreeDays },
      }).select("_id trialEndDate");

      for (const user of trialUsers) {
        const daysLeft = Math.max(
          1,
          Math.ceil((user.trialEndDate - now) / (1000 * 60 * 60 * 24))
        );
        await sendTrialExpiryReminder(user._id, daysLeft);
      }

      console.log("Expiring subscriptions check completed");
    } catch (error) {
      console.error("Expiring subscriptions cron error:", error);
    }
  });

  console.log("Subscription cron jobs started");
}
