export const notFound = (req, res, next) => {
  res.status(404).json({ message: `Route ${req.originalUrl} not found` });
};

export const errorHandler = (err, req, res, next) => {
  console.error(err.stack);

  // Mongo duplicate key (e.g. blank email colliding as null)
  if (err?.code === 11000) {
    const field = Object.keys(err.keyPattern || err.keyValue || {})[0] || "field";
    const friendly =
      field === "email"
        ? "Email already registered"
        : field === "phoneNumber"
          ? "Phone number already registered"
          : `Duplicate ${field}`;
    return res.status(409).json({ message: friendly });
  }

  res.status(err.status || 500).json({
    message: err.message || "Internal Server Error",
  });
};