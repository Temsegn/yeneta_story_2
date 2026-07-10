import express from "express";
import {
  register,
  login,
  getProfile,
  updateProfile,
} from "../controllers/auth_controllers.js";

import { protect } from "../middlewares/auth_middlewares.js";
import { validate } from "../middlewares/validation_middlewares.js";
import {
  registerValidator,
  loginValidator,
  updateProfileValidator,
} from "../middlewares/auth_validator_middlewares.js";

const router = express.Router();

/**
 * @swagger
 * /api/v1/auth/register:
 *   post:
 *     summary: Register a new user
 *     tags: [Auth]
 */
router.post(
  "/register",
  registerValidator,
  validate,
  register
);

/**
 * @swagger
 * /api/v1/auth/login:
 *   post:
 *     summary: Login user
 *     tags: [Auth]
 */
router.post(
  "/login",
  loginValidator,
  validate,
  login
);

/**
 * @swagger
 * /api/v1/auth/profile:
 *   get:
 *     summary: Get user profile
 *     tags: [Auth]
 */
router.get("/profile", protect, getProfile);

/**
 * @swagger
 * /api/v1/auth/profile:
 *   put:
 *     summary: Update user profile
 *     tags: [Auth]
 */
router.put(
  "/profile",
  protect,
  updateProfileValidator,
  validate,
  updateProfile
);

export default router;