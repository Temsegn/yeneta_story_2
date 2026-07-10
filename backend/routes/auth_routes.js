import express from "express";
import {
  register,
  login,
  refreshAccessToken,
  getProfile,
  updateProfile,
  forgotPassword,
  resetPassword,
} from "../controllers/auth_controllers.js";

import { protect } from "../middlewares/auth_middlewares.js";
import { validate } from "../middlewares/validation_middlewares.js";
import {
  registerValidator,
  loginValidator,
  updateProfileValidator,
  forgotPasswordValidator,
  resetPasswordValidator,
} from "../middlewares/auth_validator_middlewares.js";

const router = express.Router();

/**
 * @swagger
 * /api/v1/auth/register:
 *   post:
 *     summary: Register a new user (phone + password; email optional)
 *     tags: [Auth]
 */
router.post("/register", registerValidator, validate, register);

/**
 * @swagger
 * /api/v1/auth/login:
 *   post:
 *     summary: Login with phone number and password
 *     tags: [Auth]
 */
router.post("/login", loginValidator, validate, login);

router.post("/refresh", refreshAccessToken);

router.post(
  "/forgot-password",
  forgotPasswordValidator,
  validate,
  forgotPassword
);

router.post("/reset-password", resetPasswordValidator, validate, resetPassword);

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
