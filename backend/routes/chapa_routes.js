import express from "express";
import {
  initChapaPayment,
  verifyChapaPayment,
  chapaWebhook,
  checkAccess,
  cleanupPendingPayments,
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
 *     requestBody:
 *       required: true
 *       content:
 *         application/json:
 *           schema:
 *             type: object
 *             required:
 *               - plan
 *               - email
 *               - firstName
 *               - lastName
 *               - phoneNumber
 *             properties:
 *               plan:
 *                 type: string
 *                 enum: [yearly, semiannual]
 *               email:
 *                 type: string
 *               firstName:
 *                 type: string
 *               lastName:
 *                 type: string
 *               phoneNumber:
 *                 type: string
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
 *     parameters:
 *       - in: path
 *         name: tx_ref
 *         required: true
 *         schema:
 *           type: string
 */
router.get("/verify/:tx_ref", protect, verifyChapaPayment);

/**
 * @swagger
 * /api/v1/payments/chapa/webhook:
 *   post:
 *     summary: Chapa webhook endpoint
 *     tags: [Chapa Payments]
 *     description: Receives payment notifications from Chapa
 */
router.post("/webhook", chapaWebhook);

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
