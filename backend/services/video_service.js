import Video from "../models/video_models.js";

export const createVideoService = async (data, userId) => {
  const video = await Video.create({
    ...data,
    createdBy: userId,
  });

  return video;
};

export const getAllVideosService = async ({ page = 1, limit = 10, search = "" }) => {
  const skip = (page - 1) * limit;

  const filter = search
    ? { title: { $regex: search, $options: "i" } }
    : {};

  const [videos, total] = await Promise.all([
    Video.find(filter)
      .sort({ createdAt: -1 })
      .skip(skip)
      .limit(limit)
      .populate("createdBy", "name email"),
    Video.countDocuments(filter),
  ]);

  return {
    page,
    limit,
    total,
    totalPages: Math.ceil(total / limit),
    videos,
  };
};

export const getVideoByIdService = async (id) => {
  const video = await Video.findById(id)
    .populate("createdBy", "fullName email");

  if (!video) throw new Error("Video not found");

  return video;
};

export const updateVideoService = async (id, data) => {
  const video = await Video.findByIdAndUpdate(id, data, {
    new: true,
  }).populate("createdBy", "fullName email");

  if (!video) throw new Error("Video not found");

  return video;
};

export const deleteVideoService = async (id) => {
  const video = await Video.findByIdAndDelete(id);

  if (!video) throw new Error("Video not found");

  return;
};