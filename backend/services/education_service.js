import Education from "../models/education_models.js";

export const createEducationService = async (data, userId) => {
  return Education.create({
    ...data,
    createdBy: userId,
  });
};

export const getAllEducationService = async ({
  page = 1,
  limit = 10,
  search = "",
  ageGroup,
  admin = false,
} = {}) => {
  const skip = (page - 1) * limit;
  const filter = {};

  if (!admin) filter.isVisible = true;
  if (ageGroup) filter.ageGroup = ageGroup;
  if (search) {
    filter.title = { $regex: search, $options: "i" };
  }

  const [items, total] = await Promise.all([
    Education.find(filter)
      .sort({ createdAt: -1 })
      .skip(skip)
      .limit(Number(limit))
      .populate("createdBy", "fullName email"),
    Education.countDocuments(filter),
  ]);

  return {
    page: Number(page),
    limit: Number(limit),
    total,
    totalPages: Math.ceil(total / limit) || 1,
    education: items,
  };
};

export const getEducationByIdService = async (id) => {
  const item = await Education.findById(id).populate(
    "createdBy",
    "fullName email"
  );
  if (!item) throw new Error("Education content not found");
  return item;
};

export const updateEducationService = async (id, data) => {
  const item = await Education.findByIdAndUpdate(id, data, {
    new: true,
  }).populate("createdBy", "fullName email");
  if (!item) throw new Error("Education content not found");
  return item;
};

export const deleteEducationService = async (id) => {
  const item = await Education.findByIdAndDelete(id);
  if (!item) throw new Error("Education content not found");
};
