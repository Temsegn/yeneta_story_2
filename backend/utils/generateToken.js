import jwt from "jsonwebtoken";

export const generateAccessToken = (user) =>
  jwt.sign(
    { userId: user._id, role: user.role },
    process.env.ACCESS_TOKEN_SECRET,
    { expiresIn: "5d" } // 5 days - matches the free-trial window
  );

export const generateRefreshToken = (user) =>
  jwt.sign(
    { userId: user._id, role: user.role},
    process.env.REFRESH_TOKEN_SECRET,
    { expiresIn: "30d" } // 30 days - matches access token
  );
