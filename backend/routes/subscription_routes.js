import express from "express";
import {
  getMySubscription,
  checkMySubscription,
  registerSubscription,
  checkoutSubscription,
} from "../controllers/subscription_controllers.js";
import { protect } from "../middlewares/auth_middlewares.js";

const router = express.Router();

/**
 * @swagger
 * /api/v1/subscriptions/me:
 *   get:
 *     summary: Get current user's premium status
 *     tags: [Subscriptions]
 *     security:
 *       - bearerAuth: []
 */
router.get("/me", protect, getMySubscription);

/**
 * @swagger
 * /api/v1/subscriptions/checkout:
 *   post:
 *     summary: Start Chapa checkout for a plan (planId only)
 *     tags: [Subscriptions]
 *     security:
 *       - bearerAuth: []
 *     requestBody:
 *       required: true
 *       content:
 *         application/json:
 *           schema:
 *             type: object
 *             required: [planId]
 *             properties:
 *               planId:
 *                 type: string
 *                 enum: [premium_monthly, premium_yearly]
 */
router.post("/checkout", protect, checkoutSubscription);

/**
 * @swagger
 * /api/v1/subscriptions/register:
 *   post:
 *     summary: Register a subscription (admin/legacy)
 *     tags: [Subscriptions]
 *     security:
 *       - bearerAuth: []
 */
router.post("/register", protect, registerSubscription);

/**
 * @swagger
 * /api/v1/subscriptions/check:
 *   get:
 *     summary: Check subscription status
 *     tags: [Subscriptions]
 *     security:
 *       - bearerAuth: []
 */
router.get("/check", protect, checkMySubscription);

export default router;
