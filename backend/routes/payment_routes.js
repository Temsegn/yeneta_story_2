import express from "express";
import {
  createPayment,
  verifyPayment,
} from "../controllers/payment_controllers.js";
import { protect } from "../middlewares/auth_middlewares.js";

const router = express.Router();

/**
 * @swagger
 * /api/v1/payments:
 *   post:
 *     summary: Create a new payment
 *     tags: [Payments]
 *     security:
 *       - bearerAuth: []
 *     requestBody:
 *       required: true
 *       content:
 *         application/json:
 *           schema:
 *             type: object
 *             required: ["amount", "subscription", "paymentMethod"]
 *             properties:
 *               amount: { type: "number" }
 *               subscription: { type: "string" }
 *               paymentMethod: { type: "string", enum: ["telebirr", "credit_card", "paypal"] }
 *     responses:
 *       201:
 *         description: Payment created
 */
router.post("/", protect, createPayment);

/**
 * @swagger
 * /api/v1/payments/verify:
 *   post:
 *     summary: Verify a payment
 *     tags: [Payments]
 *     security:
 *       - bearerAuth: []
 *     requestBody:
 *       required: true
 *       content:
 *         application/json:
 *           schema:
 *             type: object
 *             properties:
 *               transactionId: { type: "string" }
 *     responses:
 *       200:
 *         description: Payment verified
 */
router.post("/verify", protect, verifyPayment);

export default router;
