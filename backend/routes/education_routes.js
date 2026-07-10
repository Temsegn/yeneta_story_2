import express from "express";
import { protect, optionalProtect } from "../middlewares/auth_middlewares.js";
import { requireRoles } from "../middlewares/role_middlewares.js";
import { loadContent } from "../middlewares/load_content_middlewares.js";
import { checkSubscription } from "../middlewares/subscription_middlewares.js";
import Education from "../models/education_models.js";
import {
  createEducation,
  getAllEducation,
  getEducationById,
  updateEducation,
  deleteEducation,
} from "../controllers/education_controllers.js";

const router = express.Router();

router.get("/", optionalProtect, getAllEducation);
router.get(
  "/:id",
  protect,
  loadContent(Education),
  checkSubscription,
  getEducationById
);
router.post("/", protect, requireRoles("admin", "content_manager"), createEducation);
router.put("/:id", protect, requireRoles("admin", "content_manager"), updateEducation);
router.delete(
  "/:id",
  protect,
  requireRoles("admin", "content_manager"),
  deleteEducation
);

export default router;
