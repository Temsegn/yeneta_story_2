import express from "express";
import {
  initChapaPayment,
  verifyChapaPayment,
  chapaWebhook,
  checkAccess,
  cleanupPendingPayments,
  chapaReturnPage,
} from "../controllers/chapa_controllers.js";
import { protect } from "../middlewares/auth_middlewares.js";

const router = express.Router();

/**
 * @swagger
 * /api/v1/payments/chapa/init-payment:
 *   post:
 *     summary: Initialize Chapa payment for subscription
 *     tags: [Chapa Payments]
 *     security:
 *       - bearerAuth: []
 */
router.post("/init-payment", protect, initChapaPayment);

/**
 * @swagger
 * /api/v1/payments/chapa/verify/{tx_ref}:
 *   get:
 *     summary: Verify Chapa payment
 *     tags: [Chapa Payments]
 *     security:
 *       - bearerAuth: []
 */
router.get("/verify/:tx_ref", protect, verifyChapaPayment);

/**
 * @swagger
 * /api/v1/payments/chapa/webhook:
 *   post:
 *     summary: Chapa webhook endpoint
 *     tags: [Chapa Payments]
 */
router.post("/webhook", chapaWebhook);

/** HTTPS return page after hosted checkout (required by Chapa). */
router.get("/return", chapaReturnPage);

/**
 * @swagger
 * /api/v1/payments/chapa/check-access:
 *   get:
 *     summary: Check user subscription or trial access
 *     tags: [Chapa Payments]
 *     security:
 *       - bearerAuth: []
 */
router.get("/check-access", protect, checkAccess);

/**
 * @swagger
 * /api/v1/payments/chapa/cleanup-pending:
 *   delete:
 *     summary: Clean up old pending payments for current user
 *     tags: [Chapa Payments]
 *     security:
 *       - bearerAuth: []
 */
router.delete("/cleanup-pending", protect, cleanupPendingPayments);

export default router;
