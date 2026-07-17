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

function detectKind(mimetype = "", originalname = "") {
  if (mimetype.startsWith("video/")) return "video";
  if (mimetype.startsWith("audio/")) return "audio";
  if (mimetype === "application/pdf" || originalname.toLowerCase().endsWith(".pdf")) {
    return "raw";
  }
  return "image";
}

function formatDuration(seconds) {
  if (!Number.isFinite(seconds) || seconds < 0) return "";
  const total = Math.round(seconds);
  const m = Math.floor(total / 60);
  const s = total % 60;
  return `${String(m).padStart(2, "0")}:${String(s).padStart(2, "0")}`;
}

/** Fast CDN delivery URL with consistent cover sizing for images. */
export function deliveryUrl(publicId, resourceType = "image", opts = {}) {
  assertCloudinaryConfigured();

  if (resourceType === "image") {
    return cloudinary.url(publicId, {
      secure: true,
      resource_type: "image",
      transformation: [
        {
          width: opts.width || 1280,
          height: opts.height || 720,
          crop: "fill",
          gravity: "auto",
        },
        { quality: "auto", fetch_format: "auto" },
      ],
    });
  }

  if (resourceType === "video") {
    return cloudinary.url(publicId, {
      secure: true,
      resource_type: "video",
      transformation: [{ quality: "auto" }],
    });
  }

  return cloudinary.url(publicId, {
    secure: true,
    resource_type: resourceType,
  });
}

/** Poster frame from a Cloudinary video — same size as image covers. */
export function videoPosterUrl(publicId) {
  assertCloudinaryConfigured();
  return cloudinary.url(publicId, {
    secure: true,
    resource_type: "video",
    format: "jpg",
    transformation: [
      { width: 1280, height: 720, crop: "fill", gravity: "auto", start_offset: "0" },
      { quality: "auto" },
    ],
  });
}

export async function uploadToCloudinary(filePath, { mimetype, originalname } = {}) {
  assertCloudinaryConfigured();

  const kind = detectKind(mimetype, originalname || "");
  const root = process.env.CLOUDINARY_FOLDER || "yeneta";
  const folder =
    kind === "video"
      ? `${root}/videos`
      : kind === "audio"
        ? `${root}/audio`
        : kind === "raw"
          ? `${root}/files`
          : `${root}/images`;

  const baseOptions = {
    folder,
    resource_type: kind === "image" ? "image" : kind === "video" ? "video" : "auto",
    use_filename: true,
    unique_filename: true,
    overwrite: false,
  };

  // Images: normalize to a consistent kids-content cover size on upload.
  if (kind === "image") {
    const uploaded = await cloudinary.uploader.upload(filePath, {
      ...baseOptions,
      transformation: [
        { width: 1280, height: 720, crop: "fill", gravity: "auto" },
        { quality: "auto:good", fetch_format: "auto" },
      ],
    });

    return {
      ...uploaded,
      delivery_url: deliveryUrl(uploaded.public_id, "image"),
      kind,
    };
  }

  // Large videos: chunked upload is faster/more reliable on Render.
  if (kind === "video") {
    const uploaded = await cloudinary.uploader.upload_large(filePath, {
      ...baseOptions,
      chunk_size: 6_000_000,
      eager: [
        {
          width: 1280,
          height: 720,
          crop: "fill",
          gravity: "auto",
          start_offset: "0",
          format: "jpg",
          quality: "auto",
        },
      ],
      eager_async: true,
    });

    return {
      ...uploaded,
      delivery_url: uploaded.secure_url,
      poster_url: videoPosterUrl(uploaded.public_id),
      duration_label: formatDuration(uploaded.duration),
      kind,
    };
  }

  const uploaded = await cloudinary.uploader.upload(filePath, baseOptions);
  return {
    ...uploaded,
    delivery_url: uploaded.secure_url,
    kind,
  };
}

export default cloudinary;
