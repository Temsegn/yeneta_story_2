export const loadContent = (Model) => async (req, res, next) => {
  try {
    const content = await Model.findById(req.params.id);

    if (!content) {
      return res.status(404).json({
        message: "Content not found",
      });
    }

    req.content = content;
    next();
  } catch (error) {
    return res.status(500).json({
      message: "Failed to load content",
    });
  }
};
