import {
  createEducationService,
  getAllEducationService,
  getEducationByIdService,
  updateEducationService,
  deleteEducationService,
} from "../services/education_service.js";
import { logAction } from "../utils/auditLogger.js";
import { isInternalRole } from "../middlewares/role_middlewares.js";
import { notifyContentReleasedSafe } from "../services/notification_service.js";

export const createEducation = async (req, res) => {
  try {
    const item = await createEducationService(req.body, req.user._id);
    res.status(201).json(item);
    await logAction({
      user: req.user._id,
      action: "CREATE_EDUCATION",
      targetModel: "Education",
      targetId: item._id,
      ipAddress: req.ip,
    });

    if (item.isVisible !== false) {
      notifyContentReleasedSafe(item.title, "Education", "/education");
    }
  } catch (error) {
    res.status(500).json({
      message: "Failed to create education content",
      error: error.message,
    });
  }
};

export const getAllEducation = async (req, res) => {
  try {
    const page = parseInt(req.query.page, 10) || 1;
    const limit = parseInt(req.query.limit, 10) || 10;
    const search = req.query.search || "";
    const ageGroup = req.query.ageGroup || "";
    const includeHidden =
      req.query.includeHidden === "true" &&
      req.user &&
      isInternalRole(req.user.role);

    const data = await getAllEducationService({
      page,
      limit,
      search,
      ageGroup,
      admin: includeHidden,
    });
    res.status(200).json(data);
  } catch (error) {
    res.status(500).json({
      message: "Failed to fetch education content",
      error: error.message,
    });
  }
};

export const getEducationById = async (req, res) => {
  try {
    const item = await getEducationByIdService(req.params.id);
    res.status(200).json(item);
  } catch (error) {
    res.status(404).json({ message: error.message });
  }
};

export const updateEducation = async (req, res) => {
  try {
    const previous = await getEducationByIdService(req.params.id);
    const wasHidden = previous.isVisible === false;
    const item = await updateEducationService(req.params.id, req.body);
    res.status(200).json(item);
    await logAction({
      user: req.user._id,
      action: "UPDATE_EDUCATION",
      targetModel: "Education",
      targetId: req.params.id,
      ipAddress: req.ip,
    });

    if (wasHidden && item.isVisible !== false) {
      notifyContentReleasedSafe(item.title, "Education", "/education");
    }
  } catch (error) {
    res.status(404).json({ message: error.message });
  }
};

export const deleteEducation = async (req, res) => {
  try {
    await deleteEducationService(req.params.id);
    res.status(200).json({ message: "Education content deleted" });
    await logAction({
      user: req.user._id,
      action: "DELETE_EDUCATION",
      targetModel: "Education",
      targetId: req.params.id,
      ipAddress: req.ip,
    });
  } catch (error) {
    res.status(404).json({ message: error.message });
  }
};
