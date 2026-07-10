import {
  createStoryService,
  getAllStoriesService,
  getStoryByIdService,
  updateStoryService,
  deleteStoryService,
} from "../services/story_service.js";
import { logAction } from "../utils/auditLogger.js";
import { validationResult } from "express-validator";
import { isInternalRole } from "../middlewares/role_middlewares.js";

export const createStory = async (req, res) => {
  try {
    const errors = validationResult(req);
    if (!errors.isEmpty()) return res.status(400).json({ errors: errors.array() });

    const story = await createStoryService(req.body, req.user._id);
    res.status(201).json(story);

    await logAction({
      user: req.user._id,
      action: "CREATE_STORY",
      targetModel: "Story",
      targetId: story._id,
      ipAddress: req.ip,
    });
  } catch (error) {
    res.status(500).json({ message: "Failed to create story", error: error.message });
  }
};

export const getAllStories = async (req, res) => {
  try {
    const includeHidden =
      req.query.includeHidden === "true" &&
      req.user &&
      isInternalRole(req.user.role);
    const stories = await getAllStoriesService({
      ...req.query,
      includeHidden,
    });
    res.status(200).json(stories);
  } catch (error) {
    res.status(500).json({ message: "Failed to fetch stories", error: error.message });
  }
};

export const getStoryById = async (req, res) => {
  try {
    const story = await getStoryByIdService(req.params.id);
    res.status(200).json(story);
  } catch (error) {
    res.status(404).json({ message: error.message });
  }
};

export const updateStory = async (req, res) => {
  try {
    const errors = validationResult(req);
    if (!errors.isEmpty()) return res.status(400).json({ errors: errors.array() });

    const story = await updateStoryService(req.params.id, req.body);
    res.status(200).json(story);

    await logAction({
      user: req.user._id,
      action: "UPDATE_STORY",
      targetModel: "Story",
      targetId: req.params.id,
      ipAddress: req.ip,
    });
  } catch (error) {
    res.status(404).json({ message: error.message });
  }
};

export const deleteStory = async (req, res) => {
  try {
    await deleteStoryService(req.params.id);
    res.status(200).json({ message: "Story deleted" });

    await logAction({
      user: req.user._id,
      action: "DELETE_STORY",
      targetModel: "Story",
      targetId: req.params.id,
      ipAddress: req.ip,
    });
  } catch (error) {
    res.status(404).json({ message: error.message });
  }
};