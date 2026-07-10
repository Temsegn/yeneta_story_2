import AuditLog from "../models/auditlog_models.js";
export async function createLog({ user, action, targetModel, targetId, ipAddress }) {
  const log = await AuditLog.create({
    user,
    action,
    targetModel,
    targetId,
    ipAddress,
  });
  return log;
}

export async function getLogs({ userId, action, targetModel, page = 1, limit = 20 }) {
  const filter = {};
  if (userId) filter.user = userId;
  if (action) filter.action = action;
  if (targetModel) filter.targetModel = targetModel;

  const logs = await AuditLog.find(filter)
    .populate("user", "fullName email")
    .sort({ createdAt: -1 })
    .skip((page - 1) * limit)
    .limit(limit);

  return logs;
}