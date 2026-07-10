import {
  initializePayment,
  verifyPaymentWithChapa,
  processSuccessfulPayment,
  handleWebhook,
  checkUserAccess,
} from "../services/chapa_service.js";
import Payment from "../models/payment_models.js";

/**
 * Initialize Chapa payment
 * POST /api/v1/payments/chapa/init-payment
 */
export const initChapaPayment = async (req, res) => {
  try {
    // Prefer planId-only (new flow). Keep legacy field names as aliases.
    const planId = req.body.planId || req.body.plan;

    console.log("Init payment request:", { planId, userId: req.user?._id });

    if (!planId) {
      return res.status(400).json({
        message: "Missing required field: planId",
      });
    }

    if (!req.user || !req.user._id) {
      return res.status(401).json({
        message: "User not authenticated",
      });
    }

    const result = await initializePayment(req.user._id, { planId });

    console.log("Payment initialized successfully:", result.tx_ref);

    res.status(200).json({
      message: "Payment initialized successfully",
      data: result,
    });
  } catch (error) {
    console.error("Init payment error:", error);

    const errorMessage =
      typeof error.message === "string"
        ? error.message
        : JSON.stringify(error.message) || "Payment initialization failed";

    res.status(400).json({
      message: errorMessage,
    });
  }
};

/**
 * Verify payment
 * GET /api/v1/payments/chapa/verify/:tx_ref
 */
export const verifyChapaPayment = async (req, res) => {
  try {
    const { tx_ref } = req.params;

    if (!tx_ref) {
      return res.status(400).json({
        message: "Transaction reference is required",
      });
    }

    // Verify with Chapa
    const chapaData = await verifyPaymentWithChapa(tx_ref);

    // Process payment if successful
    if (chapaData.status === "success") {
      const result = await processSuccessfulPayment(tx_ref, chapaData);
      
      return res.status(200).json({
        message: "Payment verified and subscription activated",
        data: {
          payment: result.payment,
          subscription: result.subscription,
        },
      });
    } else {
      return res.status(400).json({
        message: "Payment verification failed",
        status: chapaData.status,
      });
    }
  } catch (error) {
    console.error("Verify payment error:", error);
    res.status(400).json({
      message: error.message || "Payment verification failed",
    });
  }
};

/**
 * Chapa webhook handler
 * POST /api/v1/payments/chapa/webhook
 */
export const chapaWebhook = async (req, res) => {
  try {
    const signature = req.headers["chapa-signature"] || req.headers["x-chapa-signature"];
    const payload = req.body;

    console.log("=== Webhook Received ===");
    console.log("Event:", payload.event);
    console.log("TX Ref:", payload.data?.tx_ref);
    console.log("Status:", payload.data?.status);
    console.log("Amount:", payload.data?.amount);
    console.log("Signature present:", !!signature);
    console.log("========================");

    const result = await handleWebhook(payload, signature);

    console.log("Webhook processed successfully:", result.message);

    // Always return 200 to acknowledge receipt
    res.status(200).json({
      message: "Webhook processed successfully",
      result,
    });
  } catch (error) {
    console.error("=== Webhook Error ===");
    console.error("Error:", error.message);
    console.error("Stack:", error.stack);
    console.error("=====================");
    
    // Still return 200 to prevent Chapa from retrying
    // Log the error for manual investigation
    res.status(200).json({
      message: "Webhook received but processing failed",
      error: error.message,
    });
  }
};

/**
 * Check user access (subscription or trial)
 * GET /api/v1/payments/chapa/check-access
 */
export const checkAccess = async (req, res) => {
  try {
    const result = await checkUserAccess(req.user._id);
    
    res.status(200).json(result);
  } catch (error) {
    console.error("Check access error:", error);
    res.status(400).json({
      message: error.message || "Failed to check access",
    });
  }
};

/**
 * Clean up old pending payments for current user
 * DELETE /api/v1/payments/chapa/cleanup-pending
 */
export const cleanupPendingPayments = async (req, res) => {
  try {
    const userId = req.user._id;
    
    // Delete all pending payments older than 5 minutes for this user
    const fiveMinutesAgo = new Date(Date.now() - 5 * 60 * 1000);
    const result = await Payment.deleteMany({
      userId,
      status: "pending",
      createdAt: { $lt: fiveMinutesAgo },
    });

    console.log(`Cleaned up ${result.deletedCount} pending payments for user ${userId}`);

    res.status(200).json({
      message: "Pending payments cleaned up successfully",
      deletedCount: result.deletedCount,
    });
  } catch (error) {
    console.error("Cleanup error:", error);
    res.status(400).json({
      message: error.message || "Failed to cleanup pending payments",
    });
  }
};
