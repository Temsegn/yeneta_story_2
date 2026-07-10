import {
  registerUser,
  loginUser,
  refreshTokenService,
  getUserProfile,
  updateUserProfile,
} from "../services/auth_service.js";
import { logAction } from "../utils/auditLogger.js";
import { sendWelcomeNotification } from "../services/notification_service.js";

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

    // If childProfiles is empty, use parent's name as fallback
    const childProfiles = user.childProfiles && user.childProfiles.length > 0
      ? user.childProfiles
      : [{
          name: user.fullName,
          birthdate: null
        }];

    res.status(201).json({
      message: "Signup successful",
      user: {
        id: user._id,
        fullName: user.fullName,
        email: user.email,
        role: user.role,
        phoneNumber: user.phoneNumber,
        childProfiles: childProfiles,
      },
    });

    // Send welcome notification
    await sendWelcomeNotification(user._id);

    // Audit Log
    await logAction({
      user: user._id,
      action: "REGISTER",
      targetModel: "User",
      targetId: user._id,
      ipAddress: req.ip,
    });
  } catch (err) {
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

    // If childProfiles is empty, use parent's name as fallback
    const childProfiles = user.childProfiles && user.childProfiles.length > 0
      ? user.childProfiles
      : [{
          name: user.fullName,
          birthdate: null
        }];

    res.status(200).json({
      message: "Login successful",
      user: {
        id: user._id,
        fullName: user.fullName,
        email: user.email,
        role: user.role,
        phoneNumber: user.phoneNumber,
        childProfiles: childProfiles,
        accessToken,
      },
    });

    // Audit Log
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
    const token = req.cookies.refreshToken;

    const newAccessToken = refreshTokenService(token);

    res.cookie("accessToken", newAccessToken, {
      httpOnly: true,
      sameSite: "lax",
      secure: true,
    });

    res.status(200).json({ message: "Access token refreshed" });
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
        email: user.email,
        role: user.role,
      },
    });

    // Audit Log
    await logAction({
      user: req.user._id,
      action: "UPDATE_PROFILE",
      targetModel: "User",
      targetId: user._id,
      ipAddress: req.ip,
    });
  } catch (err) {
    res.status(404).json({ message: err.message });
  }
};