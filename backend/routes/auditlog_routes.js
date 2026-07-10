import express from "express";
import { listLogs,createLogController } from "../controllers/auditlog_controllers.js";
import { protect } from "../middlewares/auth_middlewares.js";
import { requireInternal } from "../middlewares/role_middlewares.js";
import e from "express";
const router = express.Router();

/**
 * @swagger
 * /api/v1/auditlogs:
 *   get:
 *     summary: List audit logs
 *     tags: [AuditLogs]
 *     security:
 *       - bearerAuth: []
 *     responses:
 *       200:
 *         description: List of audit logs
 */
router.get("/", protect, requireInternal, listLogs);

/**
 * @swagger
 * /api/v1/auditlogs:
 *   post:
 *     summary: Create an audit log
 *     tags: [AuditLogs]
 *     security:
 *       - bearerAuth: []
 *     requestBody:
 *       required: true
 *       content:
 *         application/json:
 *           schema:
 *             $ref: '#/components/schemas/AuditLog'
 *     responses:
 *       201:
 *         description: Log created
 */
router.post("/", protect, requireInternal, createLogController);
export default router;