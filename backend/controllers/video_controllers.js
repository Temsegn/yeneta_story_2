import {
  createVideoService,
  getAllVideosService,
  getVideoByIdService,
  updateVideoService,
  deleteVideoService,
} from "../services/video_service.js";
import { logAction } from "../utils/auditLogger.js";

export const createVideo = async (req, res) => {
  try {
    const video = await createVideoService(req.body, req.user._id);
    res.status(201).json(video);

    await logAction({
      user: req.user._id,
      action: "CREATE_VIDEO",
      targetModel: "Video",
      targetId: video._id,
      ipAddress: req.ip,
    });
  } catch (error) {
    res.status(500).json({ message: "Failed to create video", error: error.message });
  }
};

export const getAllVideos = async (req, res) => {
  try {
    const page = parseInt(req.query.page) || 1;
    const limit = parseInt(req.query.limit) || 10;
    const search = req.query.search || "";

    const videosData = await getAllVideosService({ page, limit, search });
    res.status(200).json(videosData);
  } catch (error) {
    res.status(500).json({ message: "Failed to fetch videos", error: error.message });
  }
};

export const getVideoById = async (req, res) => {
  try {
    const video = await getVideoByIdService(req.params.id);
    res.status(200).json(video);
  } catch (error) {
    res.status(404).json({ message: error.message });
  }
};

export const updateVideo = async (req, res) => {
  try {
    const video = await updateVideoService(req.params.id, req.body);
    res.status(200).json(video);

    await logAction({
      user: req.user._id,
      action: "UPDATE_VIDEO",
      targetModel: "Video",
      targetId: req.params.id,
      ipAddress: req.ip,
    });
  } catch (error) {
    res.status(404).json({ message: error.message });
  }
};

export const deleteVideo = async (req, res) => {
  try {
    await deleteVideoService(req.params.id);
    res.status(200).json({ message: "Video deleted" });

    await logAction({
      user: req.user._id,
      action: "DELETE_VIDEO",
      targetModel: "Video",
      targetId: req.params.id,
      ipAddress: req.ip,
    });
  } catch (error) {
    res.status(404).json({ message: error.message });
  }
};