import Story from "../models/story_models.js";

export const createStoryService = async (data, userId) => {
  const story = await Story.create({
    ...data,
    createdBy: userId,
  });
  return story;
};

export const getAllStoriesService = async ({
  page = 1,
  limit = 10,
  search = "",
  includeHidden = false,
} = {}) => {
  const skip = (page - 1) * limit;
  const filter = {};
  if (!includeHidden) filter.isVisible = true;
  if (search) filter.title = { $regex: search, $options: "i" };

  const [stories, total] = await Promise.all([
    Story.find(filter)
      .select("-pages")
      .populate("createdBy", "fullName email")
      .sort({ createdAt: -1 })
      .skip(skip)
      .limit(Number(limit)),
    Story.countDocuments(filter),
  ]);

  return {
    page: Number(page),
    limit: Number(limit),
    total,
    totalPages: Math.ceil(total / limit) || 1,
    stories,
  };
};

export const getStoryByIdService = async (id) => {
  const story = await Story.findById(id).populate("createdBy", "fullName email");
  if (!story) throw new Error("Story not found");
  return story;
};

export const updateStoryService = async (id, data) => {
  const story = await Story.findByIdAndUpdate(id, data, { new: true }).populate(
    "createdBy",
    "fullName email"
  );
  if (!story) throw new Error("Story not found");
  return story;
};

export const deleteStoryService = async (id) => {
  const story = await Story.findByIdAndDelete(id);
  if (!story) throw new Error("Story not found");
};
