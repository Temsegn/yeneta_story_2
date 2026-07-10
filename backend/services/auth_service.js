import jwt from "jsonwebtoken";
import User from "../models/user_model.js";
import bcrypt from "bcryptjs";
import {
  generateAccessToken,
  generateRefreshToken,
} from "../utils/generateToken.js";
import { assertEthiopianPhone } from "../utils/phoneNormalizer.js";

const normalizeSecurityAnswer = (answer) =>
  String(answer || "")
    .trim()
    .toLowerCase()
    .replace(/\s+/g, " ");

export const registerUser = async ({
  fullName,
  email,
  phoneNumber,
  password,
  role,
  securityQuestion,
  securityAnswer,
}) => {
  if (!fullName || !phoneNumber || !password) {
    throw new Error("Full name, phone number, and password are required");
  }
  if (!securityQuestion?.trim() || !securityAnswer?.trim()) {
    throw new Error("Security question and answer are required");
  }

  const normalizedPhone = assertEthiopianPhone(phoneNumber);
  const normalizedEmail =
    email && String(email).trim() ? String(email).trim().toLowerCase() : null;

  const existingByPhone = await User.findOne({ phoneNumber: normalizedPhone });
  if (existingByPhone) {
    throw new Error("User already exists with this phone number");
  }

  if (normalizedEmail) {
    const existingByEmail = await User.findOne({ email: normalizedEmail });
    if (existingByEmail) {
      throw new Error("User already exists with this email");
    }
  }

  const hashedPassword = await bcrypt.hash(password, 10);
  const securityAnswerHash = await bcrypt.hash(
    normalizeSecurityAnswer(securityAnswer),
    10
  );

  const userPayload = {
    fullName,
    phoneNumber: normalizedPhone,
    password: hashedPassword,
    securityQuestion: securityQuestion.trim(),
    securityAnswerHash,
    role: role === "admin" ? "admin" : "parent",
  };
  if (normalizedEmail) {
    userPayload.email = normalizedEmail;
  }

  const user = await User.create(userPayload);

  const accessToken = generateAccessToken(user);
  const refreshToken = generateRefreshToken(user);

  return { user, accessToken, refreshToken };
};

export const loginUser = async ({ phoneNumber, password }) => {
  if (!phoneNumber || !password) {
    throw new Error("Phone number and password required");
  }

  const normalizedPhone = assertEthiopianPhone(phoneNumber);
  const user = await User.findOne({ phoneNumber: normalizedPhone });
  if (!user) {
    throw new Error("Invalid credentials");
  }

  const isMatch = await bcrypt.compare(password, user.password);
  if (!isMatch) {
    throw new Error("Invalid credentials");
  }

  const accessToken = generateAccessToken(user);
  const refreshToken = generateRefreshToken(user);

  return { user, accessToken, refreshToken };
};

export const getForgotPasswordQuestion = async (phoneNumber) => {
  const normalizedPhone = assertEthiopianPhone(phoneNumber);
  const user = await User.findOne({ phoneNumber: normalizedPhone });
  if (!user) {
    throw new Error("No account found with this phone number");
  }

  if (!user.email) {
    const err = new Error(
      "SMS recovery is coming soon. Password reset currently requires an email on your account."
    );
    err.code = "SMS_RECOVERY_PENDING";
    throw err;
  }

  if (!user.securityQuestion) {
    throw new Error(
      "No security question is set for this account. Please contact support."
    );
  }

  return {
    phoneNumber: normalizedPhone,
    securityQuestion: user.securityQuestion,
  };
};

export const resetPasswordWithSecurityAnswer = async ({
  phoneNumber,
  securityAnswer,
  newPassword,
}) => {
  if (!securityAnswer?.trim() || !newPassword) {
    throw new Error("Security answer and new password are required");
  }
  if (newPassword.length < 6) {
    throw new Error("Password must be at least 6 characters");
  }

  const normalizedPhone = assertEthiopianPhone(phoneNumber);
  const user = await User.findOne({ phoneNumber: normalizedPhone }).select(
    "+securityAnswerHash"
  );
  if (!user) {
    throw new Error("No account found with this phone number");
  }

  if (!user.email) {
    const err = new Error(
      "SMS recovery is coming soon. Password reset currently requires an email on your account."
    );
    err.code = "SMS_RECOVERY_PENDING";
    throw err;
  }

  if (!user.securityAnswerHash) {
    throw new Error("Security answer is not configured for this account");
  }

  const isMatch = await bcrypt.compare(
    normalizeSecurityAnswer(securityAnswer),
    user.securityAnswerHash
  );
  if (!isMatch) {
    throw new Error("Incorrect security answer");
  }

  user.password = await bcrypt.hash(newPassword, 10);
  await user.save();

  return { message: "Password reset successful" };
};

export const refreshTokenService = (token) => {
  if (!token) throw new Error("No refresh token");

  const decoded = jwt.verify(token, process.env.REFRESH_TOKEN_SECRET);

  const newAccessToken = generateAccessToken({
    _id: decoded.userId,
    role: decoded.role,
  });

  return newAccessToken;
};

export const getUserProfile = async (userId) => {
  const user = await User.findById(userId).select("-password");
  if (!user) throw new Error("User not found");
  return user;
};

export const updateUserProfile = async (userId, data) => {
  const user = await User.findById(userId);
  if (!user) throw new Error("User not found");

  if (data.fullName) user.fullName = data.fullName;

  if (data.email !== undefined) {
    const normalizedEmail =
      data.email && String(data.email).trim()
        ? String(data.email).trim().toLowerCase()
        : null;
    if (normalizedEmail) {
      const existing = await User.findOne({
        email: normalizedEmail,
        _id: { $ne: userId },
      });
      if (existing) throw new Error("Email already in use");
      user.email = normalizedEmail;
    } else {
      user.email = undefined;
    }
  }

  if (data.phoneNumber) {
    const normalizedPhone = assertEthiopianPhone(data.phoneNumber);
    const existing = await User.findOne({
      phoneNumber: normalizedPhone,
      _id: { $ne: userId },
    });
    if (existing) throw new Error("Phone number already in use");
    user.phoneNumber = normalizedPhone;
  }

  await user.save();
  return user;
};
