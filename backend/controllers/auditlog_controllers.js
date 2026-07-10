import { createLog, getLogs } from "../services/auditlog_service.js";
export async function listLogs(req, res) {
  try {
    const { userId, action, targetModel, page, limit } = req.query;

    const logs = await getLogs({
      userId,
      action,
      targetModel,
      page: parseInt(page) || 1,
      limit: parseInt(limit) || 20,
    });

    res.status(200).json({ logs });
  } catch (err) {
    console.error(err);
    res.status(500).json({ message: "Failed to fetch logs", error: err.message });
  }
}

export async function createLogController(req, res) {
  try {
    const { action, targetModel, targetId } = req.body;

    const log = await createLog({
      user: req.user._id,
      action,
      targetModel,
      targetId,
      ipAddress: req.ip,
    });

    res.status(201).json(log);
  } catch (err) {
    console.error(err);
    res.status(500).json({ message: "Failed to create log", error: err.message });
  }
}