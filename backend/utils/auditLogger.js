import auditLog from "../models/auditlog_models.js";

/**
 * Log an action to the AuditLog collection
 * @param {Object} params
 * @param {string} params.user - User ID
 * @param {string} params.action - Action performed (e.g., 'LOGIN', 'CREATE_BOOK')
 * @param {string} [params.targetModel] - Model affected
 * @param {string} [params.targetId] - ID of the document affected
 * @param {string} [params.ipAddress] - Request IP address
 */
export const logAction = async ({ user, action, targetModel, targetId, ipAddress }) => {
  try {
    await auditLog.create({
      user,
      action,
      targetModel,
      targetId,
      ipAddress,
    });
  } catch (error) {
    console.error("Audit Logging Error:", error.message);
    // We usually don't want to break the main flow if logging fails
  }
};
