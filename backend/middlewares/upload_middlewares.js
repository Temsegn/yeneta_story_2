import fs from "fs";
import path from "path";
import multer from "multer";

// Temporary disk landing pad — files are uploaded to Cloudinary then deleted.
const uploadsDir = path.join(process.cwd(), "uploads");

if (!fs.existsSync(uploadsDir)) {
  fs.mkdirSync(uploadsDir, { recursive: true });
}

const storage = multer.diskStorage({
  destination: (_req, _file, cb) => cb(null, uploadsDir),
  filename: (_req, file, cb) => {
    const safe = file.originalname.replace(/[^a-zA-Z0-9._-]/g, "_");
    cb(null, `${Date.now()}-${safe}`);
  },
});

const allowed = new Set([
  "image/jpeg",
  "image/png",
  "image/webp",
  "image/gif",
  "video/mp4",
  "video/webm",
  "video/quicktime",
  "audio/mpeg",
  "audio/mp3",
  "audio/wav",
  "application/pdf",
]);

function fileFilter(_req, file, cb) {
  if (allowed.has(file.mimetype)) {
    cb(null, true);
    return;
  }
  // Some phones/apps send mp4 as octet-stream.
  const name = String(file.originalname || "").toLowerCase();
  if (
    (file.mimetype === "application/octet-stream" || !file.mimetype) &&
    /\.(mp4|webm|mov|m4v|png|jpe?g|webp|gif|mp3|wav|pdf)$/i.test(name)
  ) {
    cb(null, true);
    return;
  }
  cb(new Error(`Unsupported file type: ${file.mimetype}`));
}

export const uploadMiddleware = multer({
  storage,
  fileFilter,
  limits: {
    fileSize: 200 * 1024 * 1024, // 200MB
  },
});
