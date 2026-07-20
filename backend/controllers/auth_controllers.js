import {
  registerUser,
  loginUser,
  refreshTokenService,
  getUserProfile,
  updateUserProfile,
  getForgotPasswordQuestion,
  resetPasswordWithSecurityAnswer,
} from "../services/auth_service.js";
import { logAction } from "../utils/auditLogger.js";
import { sendWelcomeNotification } from "../services/notification_service.js";

const buildAuthUserPayload = (user, accessToken, refreshToken) => {
  const childProfiles =
    user.childProfiles && user.childProfiles.length > 0
      ? user.childProfiles
      : [
          {
            name: user.fullName,
            birthdate: null,
          },
        ];

  return {
    id: user._id,
    fullName: user.fullName,
    email: user.email || null,
    role: user.role,
    phoneNumber: user.phoneNumber,
    childProfiles,
    accessToken,
    refreshToken,
  };
};

export const register = async (req, res) => {
  try {
    const { user, accessToken, refreshToken } = await registerUser(req.body);

    res.cookie("accessToken", accessToken, {
      httpOnly: true,
      sameSite: "lax",
      secure: true,
    });

    res.cookie("refreshToken", refreshToken, {
      httpOnly: true,
      sameSite: "lax",
      secure: true,
    });

    res.status(201).json({
      message: "Signup successful",
      user: buildAuthUserPayload(user, accessToken, refreshToken),
    });

    await sendWelcomeNotification(user._id);

    await logAction({
      user: user._id,
      action: "REGISTER",
      targetModel: "User",
      targetId: user._id,
      ipAddress: req.ip,
    });
  } catch (err) {
    if (err?.code === 11000) {
      const field = Object.keys(err.keyPattern || err.keyValue || {})[0];
      return res.status(409).json({
        message:
          field === "email"
            ? "Email already registered"
            : field === "phoneNumber"
              ? "Phone number already registered"
              : err.message,
      });
    }
    res.status(400).json({ message: err.message });
  }
};

export const login = async (req, res) => {
  try {
    const { user, accessToken, refreshToken } = await loginUser(req.body);

    res.cookie("accessToken", accessToken, {
      httpOnly: true,
      sameSite: "lax",
      secure: true,
    });

    res.cookie("refreshToken", refreshToken, {
      httpOnly: true,
      sameSite: "lax",
      secure: true,
    });

    res.status(200).json({
      message: "Login successful",
      user: buildAuthUserPayload(user, accessToken, refreshToken),
    });

    await logAction({
      user: user._id,
      action: "LOGIN",
      targetModel: "User",
      targetId: user._id,
      ipAddress: req.ip,
    });
  } catch (err) {
    res.status(401).json({ message: err.message });
  }
};

export const forgotPassword = async (req, res) => {
  try {
    const result = await getForgotPasswordQuestion(req.body.phoneNumber);
    res.status(200).json(result);
  } catch (err) {
    const status = err.code === "SMS_RECOVERY_PENDING" ? 400 : 404;
    res.status(status).json({ message: err.message, code: err.code });
  }
};

export const resetPassword = async (req, res) => {
  try {
    const result = await resetPasswordWithSecurityAnswer(req.body);
    res.status(200).json(result);
  } catch (err) {
    const status =
      err.code === "SMS_RECOVERY_PENDING"
        ? 400
        : err.message === "Incorrect security answer"
          ? 401
          : 400;
    res.status(status).json({ message: err.message, code: err.code });
  }
};

export const logout = async (req, res) => {
  try {
    res.clearCookie("accessToken");
    res.clearCookie("refreshToken");

    res.status(200).json({ message: "Logout successful" });
  } catch (err) {
    res.status(500).json({ message: "Logout failed", error: err.message });
  }
};

export const refreshAccessToken = async (req, res) => {
  try {
    const token = req.body?.refreshToken || req.cookies.refreshToken;
    if (!token) {
      return res.status(401).json({ message: "No refresh token found" });
    }

    const newAccessToken = refreshTokenService(token);

    res.cookie("accessToken", newAccessToken, {
      httpOnly: true,
      sameSite: "lax",
      secure: true,
    });

    res.status(200).json({ accessToken: newAccessToken });
  } catch (err) {
    res.status(403).json({ message: err.message });
  }
};

export const getProfile = async (req, res) => {
  try {
    const user = await getUserProfile(req.user._id);
    res.status(200).json(user);
  } catch (err) {
    res.status(404).json({ message: err.message });
  }
};

export const updateProfile = async (req, res) => {
  try {
    const user = await updateUserProfile(req.user._id, req.body);

    res.status(200).json({
      message: "Profile updated",
      user: {
        id: user._id,
        fullName: user.fullName,
        email: user.email || null,
        phoneNumber: user.phoneNumber,
        role: user.role,
      },
    });

    await logAction({
      user: req.user._id,
      action: "UPDATE_PROFILE",
      targetModel: "User",
      targetId: user._id,
      ipAddress: req.ip,
    });
  } catch (err) {
    if (err?.code === 11000) {
      const field = Object.keys(err.keyPattern || err.keyValue || {})[0];
      return res.status(409).json({
        message:
          field === "email"
            ? "Email already registered"
            : field === "phoneNumber"
              ? "Phone number already registered"
              : err.message,
      });
    }
    res.status(400).json({ message: err.message });
  }
};
