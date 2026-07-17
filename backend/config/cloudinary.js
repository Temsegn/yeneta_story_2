import { v2 as cloudinary } from "cloudinary";

const { CLOUDINARY_CLOUD_NAME, CLOUDINARY_API_KEY, CLOUDINARY_API_SECRET } =
  process.env;

if (
  CLOUDINARY_CLOUD_NAME &&
  CLOUDINARY_API_KEY &&
  CLOUDINARY_API_SECRET
) {
  cloudinary.config({
    cloud_name: CLOUDINARY_CLOUD_NAME,
    api_key: CLOUDINARY_API_KEY,
    api_secret: CLOUDINARY_API_SECRET,
    secure: true,
  });
}

export function assertCloudinaryConfigured() {
  if (!CLOUDINARY_CLOUD_NAME || !CLOUDINARY_API_KEY || !CLOUDINARY_API_SECRET) {
    const err = new Error(
      "Cloudinary is not configured. Set CLOUDINARY_CLOUD_NAME, CLOUDINARY_API_KEY, and CLOUDINARY_API_SECRET."
    );
    err.statusCode = 503;
    throw err;
  }
}

export async function uploadToCloudinary(filePath, { mimetype, originalname } = {}) {
  assertCloudinaryConfigured();

  const folder = process.env.CLOUDINARY_FOLDER || "yeneta";
  const isVideo = typeof mimetype === "string" && mimetype.startsWith("video/");
  const isAudio = typeof mimetype === "string" && mimetype.startsWith("audio/");
  const isPdf =
    mimetype === "application/pdf" ||
    (typeof originalname === "string" &&
      originalname.toLowerCase().endsWith(".pdf"));

  const resourceType = isVideo || isAudio || isPdf ? "auto" : "image";

  return cloudinary.uploader.upload(filePath, {
    folder,
    resource_type: resourceType,
    use_filename: true,
    unique_filename: true,
    overwrite: false,
  });
}

export default cloudinary;
