import jwt from "jsonwebtoken";
import User from "../models/user_model.js";

export const protect = async (req, res, next) => {
  try {
    // Check for token in cookies (web) or Authorization header (mobile)
    let token = req.cookies.accessToken;
    
    if (!token && req.headers.authorization) {
      // Check Authorization header for Bearer token
      const authHeader = req.headers.authorization;
      if (authHeader.startsWith('Bearer ')) {
        token = authHeader.substring(7);
      }
    }

    if (!token) {
      console.log("auth_middleware: No access token found in cookies or headers");
      return res.status(401).json({ message: "No access token found" });
    }

    const decoded = jwt.verify(token, process.env.ACCESS_TOKEN_SECRET);
    const user = await User.findById(decoded.userId).select("-password");

    if (!user) {
      console.log("auth_middleware: User not found for token");
      return res.status(401).json({ message: "User not found" });
    }
    req.user = user;
    next();
  } catch (err) {
    console.error("auth_middleware Error:", err.message);
    return res.status(401).json({ message: "Invalid access token" });
  }
};

/** Attach user when a valid token is present; never fail the request. */
export const optionalProtect = async (req, _res, next) => {
  try {
    let token = req.cookies.accessToken;
    if (!token && req.headers.authorization?.startsWith("Bearer ")) {
      token = req.headers.authorization.substring(7);
    }
    if (!token) return next();

    const decoded = jwt.verify(token, process.env.ACCESS_TOKEN_SECRET);
    const user = await User.findById(decoded.userId).select("-password");
    if (user) req.user = user;
  } catch {
    // ignore invalid tokens for public list endpoints
  }
  return next();
};

export const isAdmin = (req, res, next) => {
  if (req.user.role !== "admin") {
    return res.status(403).json({ message: "Access denied: Admins only" });
  }
  next();
};