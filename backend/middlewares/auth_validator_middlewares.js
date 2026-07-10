import { body } from "express-validator";
import { isValidEthiopianPhone } from "../utils/phoneNormalizer.js";

const phoneValidator = body("phoneNumber")
  .trim()
  .notEmpty()
  .withMessage("Phone number is required")
  .custom((value) => {
    if (!isValidEthiopianPhone(value)) {
      throw new Error(
        "Invalid phone number. Use 9 digits starting with 9 (e.g. 0912345678 or +251912345678)."
      );
    }
    return true;
  });

// Register
export const registerValidator = [
  body("fullName").trim().notEmpty().withMessage("Full name is required"),

  body("email")
    .optional({ values: "falsy" })
    .isEmail()
    .withMessage("Valid email is required")
    .normalizeEmail(),

  phoneValidator,

  body("password")
    .isLength({ min: 6 })
    .withMessage("Password must be at least 6 characters"),

  body("securityQuestion")
    .trim()
    .notEmpty()
    .withMessage("Security question is required")
    .isLength({ min: 5, max: 200 })
    .withMessage("Security question must be 5–200 characters"),

  body("securityAnswer")
    .trim()
    .notEmpty()
    .withMessage("Security answer is required")
    .isLength({ min: 2, max: 100 })
    .withMessage("Security answer must be 2–100 characters"),
];

// Login
export const loginValidator = [
  phoneValidator,

  body("password").notEmpty().withMessage("Password is required"),
];

export const forgotPasswordValidator = [phoneValidator];

export const resetPasswordValidator = [
  phoneValidator,

  body("securityAnswer")
    .trim()
    .notEmpty()
    .withMessage("Security answer is required"),

  body("newPassword")
    .isLength({ min: 6 })
    .withMessage("Password must be at least 6 characters"),
];

// Update Profile (partial updates allowed)
export const updateProfileValidator = [
  body("fullName")
    .optional()
    .trim()
    .notEmpty()
    .withMessage("Full name cannot be empty"),

  body("email")
    .optional({ values: "falsy" })
    .isEmail()
    .withMessage("Valid email is required")
    .normalizeEmail(),

  body("phoneNumber")
    .optional()
    .trim()
    .custom((value) => {
      if (!isValidEthiopianPhone(value)) {
        throw new Error(
          "Invalid phone number. Use 9 digits starting with 9 (e.g. 0912345678 or +251912345678)."
        );
      }
      return true;
    }),
];
