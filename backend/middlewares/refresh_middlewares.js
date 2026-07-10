import jwt from "jsonwebtoken";
import RefreshToken from "../models/refreshToken_models.js";

export const verifyRefreshToken = async (req, res, next) => {
  const { refreshToken } = req.body;

  if (!refreshToken) {
    return res.status(401).json({ message: "No refresh token provided" });
  }

  try {
    const decoded = jwt.verify(
      refreshToken,
      process.env.JWT_REFRESH_SECRET
    );

    const tokenDoc = await RefreshToken.findOne({
      token: refreshToken,
      user: decoded.id,
    });

    if (!tokenDoc) {
      return res.status(403).json({ message: "Invalid refresh token" });
    }

    req.userId = decoded.id;
    req.refreshToken = refreshToken;

    next();
  } catch (error) {
    return res.status(403).json({ message: "Refresh token expired or invalid" });
  }
};
