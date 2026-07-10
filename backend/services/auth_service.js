import User from "../models/user_model.js";
import bcrypt from "bcryptjs";
import { generateAccessToken, generateRefreshToken } from "../utils/generateToken.js";


export const registerUser = async ({ fullName, email, phoneNumber, password, role }) => {
  if (!fullName || !email || !phoneNumber || !password) {
    throw new Error("All fields are required");
  }

  const existingUser = await User.findOne({ email });
  if (existingUser) {
    throw new Error("User already exists");
  }

  const hashedPassword = await bcrypt.hash(password, 10);

  const user = await User.create({
    fullName,
    email,
    phoneNumber,
    password: hashedPassword,
    role:role==="admin" ? "admin" : "parent"
  });

  const accessToken = generateAccessToken(user);
  const refreshToken = generateRefreshToken(user);

  return { user, accessToken, refreshToken };
};

export const loginUser = async ({ email, password }) => {
  if (!email || !password) {
    throw new Error("Email and password required");
  }

  const user = await User.findOne({ email });
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

export const refreshTokenService = (token) => {
  if (!token) throw new Error("No refresh token");

  const decoded = jwt.verify(token, process.env.REFRESH_TOKEN_SECRET);

  const newAccessToken = generateAccessToken({
    _id: decoded.userId,
    role: decoded.role,
    email: decoded.email,
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

  user.fullName = data.fullName || user.fullName;
  user.email = data.email || user.email;
  user.phoneNumber = data.phoneNumber || user.phoneNumber;

  await user.save();

  return user;
};