import cron from "node-cron";
import { getExpiringSubscriptions } from "../services/chapa_service.js";
import User from "../models/user_model.js";

/**
 * Check and update expired subscriptions
 * Runs daily at midnight
 */
export function startSubscriptionCron() {
  // Run every day at midnight (00:00)
  cron.schedule("0 0 * * *", async () => {
    console.log("Running subscription expiry check...");
    
    try {
      const now = new Date();
      
      // Find users with expired subscriptions
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
        
        console.log(`Deactivated subscription for user: ${user.email}`);
      }

      console.log("Subscription expiry check completed");
    } catch (error) {
      console.error("Subscription cron error:", error);
    }
  });

  // Check for subscriptions expiring in 7 days
  // Runs daily at 9 AM
  cron.schedule("0 9 * * *", async () => {
    console.log("Checking for expiring subscriptions...");
    
    try {
      const expiringUsers = await getExpiringSubscriptions(7);
      
      console.log(`Found ${expiringUsers.length} subscriptions expiring in 7 days`);

      for (const user of expiringUsers) {
        const daysLeft = Math.ceil(
          (user.subscriptionEndDate - new Date()) / (1000 * 60 * 60 * 24)
        );
        
        console.log(
          `User ${user.email} subscription expires in ${daysLeft} days`
        );
        
        // TODO: Send reminder email/push notification
        // await sendEmail(user.email, "Subscription Expiring Soon", ...);
        // await sendPushNotification(user._id, "Your subscription expires in " + daysLeft + " days");
      }

      console.log("Expiring subscriptions check completed");
    } catch (error) {
      console.error("Expiring subscriptions cron error:", error);
    }
  });

  console.log("Subscription cron jobs started");
}

/**
 * Send email notification (placeholder)
 * Integrate with your email service (SendGrid, AWS SES, etc.)
 */
async function sendEmail(to, subject, body) {
  // TODO: Implement email sending
  console.log(`Email to ${to}: ${subject}`);
}

/**
 * Send push notification (placeholder)
 * Integrate with FCM or your push notification service
 */
async function sendPushNotification(userId, message) {
  // TODO: Implement push notification
  console.log(`Push to user ${userId}: ${message}`);
}
