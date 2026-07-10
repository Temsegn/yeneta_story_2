export const INTERNAL_ROLES = ["admin", "finance", "content_manager"];
export const STAFF_ROLES = INTERNAL_ROLES;

export const isInternalRole = (role) => INTERNAL_ROLES.includes(role);

export const isAdmin = (req, res, next) => {
  if (!req.user) {
    return res.status(401).json({ message: "Not authenticated" });
  }
  if (req.user.role !== "admin") {
    return res.status(403).json({ message: "Access denied. Admins only." });
  }
  return next();
};

export const requireInternal = (req, res, next) => {
  if (!req.user) {
    return res.status(401).json({ message: "Not authenticated" });
  }
  if (!isInternalRole(req.user.role)) {
    return res.status(403).json({
      message: "Access denied. Yeneta staff only.",
    });
  }
  return next();
};

export const requireRoles = (...roles) => (req, res, next) => {
  if (!req.user) {
    return res.status(401).json({ message: "Not authenticated" });
  }
  if (!roles.includes(req.user.role)) {
    return res.status(403).json({
      message: `Access denied. Requires one of: ${roles.join(", ")}`,
    });
  }
  return next();
};
