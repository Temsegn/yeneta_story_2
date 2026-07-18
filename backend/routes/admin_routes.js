import express from "express";
import { protect } from "../middlewares/auth_middlewares.js";
import {
  requireInternal,
  requireRoles,
  isAdmin,
} from "../middlewares/role_middlewares.js";
import { uploadMiddleware } from "../middlewares/upload_middlewares.js";
import {
  getAdminStats,
  listUsers,
  getUser,
  createUser,
  updateUser,
  deleteUser,
  listSubscriptions,
  getSubscription,
  createSubscription,
  updateSubscription,
  deleteSubscription,
  listPayments,
  getPayment,
  listPlans,
  getPlan,
  createPlan,
  updatePlan,
  deletePlan,
  uploadFile,
} from "../controllers/admin_controllers.js";
import { broadcast } from "../controllers/notification_controllers.js";

const router = express.Router();

router.use(protect, requireInternal);

router.get("/stats", getAdminStats);

// All staff can view users; finance/admin manage them
router.get("/users", listUsers);
router.post("/users", requireRoles("admin", "finance"), createUser);
router.get("/users/:id", getUser);
router.put("/users/:id", requireRoles("admin", "finance"), updateUser);
router.delete("/users/:id", isAdmin, deleteUser);

router.get("/subscriptions", requireRoles("admin", "finance"), listSubscriptions);
router.post("/subscriptions", requireRoles("admin", "finance"), createSubscription);
router.get("/subscriptions/:id", requireRoles("admin", "finance"), getSubscription);
router.put("/subscriptions/:id", requireRoles("admin", "finance"), updateSubscription);
router.delete("/subscriptions/:id", requireRoles("admin", "finance"), deleteSubscription);

router.get("/payments", requireRoles("admin", "finance"), listPayments);
router.get("/payments/:id", requireRoles("admin", "finance"), getPayment);

router.get("/plans", requireRoles("admin", "finance"), listPlans);
router.post("/plans", requireRoles("admin", "finance"), createPlan);
router.get("/plans/:id", requireRoles("admin", "finance"), getPlan);
router.put("/plans/:id", requireRoles("admin", "finance"), updatePlan);
router.delete("/plans/:id", requireRoles("admin", "finance"), deletePlan);

router.post(
  "/uploads",
  requireRoles("admin", "content_manager"),
  uploadMiddleware.single("file"),
  (req, res, next) => {
    uploadFile(req, res).catch(next);
  }
);

router.post(
  "/notifications/broadcast",
  requireRoles("admin", "content_manager"),
  broadcast
);

export default router;
