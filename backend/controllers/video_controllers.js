import {
  createVideoService,
  getAllVideosService,
  getVideoByIdService,
  updateVideoService,
  deleteVideoService,
} from "../services/video_service.js";
import { logAction } from "../utils/auditLogger.js";
import { isInternalRole } from "../middlewares/role_middlewares.js";
import { notifyContentReleasedSafe } from "../services/notification_service.js";

export const createVideo = async (req, res) => {
  try {
    const { title, description, videoUrl, thumbnail } = req.body || {};
    if (!title?.trim() || !description?.trim()) {
      return res
        .status(400)
        .json({ message: "Title and description are required" });
    }
    if (!videoUrl?.trim() || !thumbnail?.trim()) {
      return res
        .status(400)
        .json({ message: "Video file and thumbnail are required" });
    }

    const video = await createVideoService(
      {
        ...req.body,
        title: title.trim(),
        description: description.trim(),
        videoUrl: videoUrl.trim(),
        thumbnail: thumbnail.trim(),
      },
      req.user._id
    );
    res.status(201).json(video);

    await logAction({
      user: req.user._id,
      action: "CREATE_VIDEO",
      targetModel: "Video",
      targetId: video._id,
      ipAddress: req.ip,
    });

    if (video.isVisible !== false) {
      notifyContentReleasedSafe(video.title, "Video", "/videos");
    }
  } catch (error) {
    res.status(500).json({ message: "Failed to create video", error: error.message });
  }
};

export const getAllVideos = async (req, res) => {
  try {
    const page = parseInt(req.query.page) || 1;
    const limit = parseInt(req.query.limit) || 10;
    const search = req.query.search || "";
    const includeHidden =
      req.query.includeHidden === "true" &&
      req.user &&
      isInternalRole(req.user.role);

    const videosData = await getAllVideosService({
      page,
      limit,
      search,
      includeHidden,
    });
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
    const previous = await getVideoByIdService(req.params.id);
    const wasHidden = previous.isVisible === false;
    const video = await updateVideoService(req.params.id, req.body);
    res.status(200).json(video);

    await logAction({
      user: req.user._id,
      action: "UPDATE_VIDEO",
      targetModel: "Video",
      targetId: req.params.id,
      ipAddress: req.ip,
    });

    if (wasHidden && video.isVisible !== false) {
      notifyContentReleasedSafe(video.title, "Video", "/videos");
    }
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
