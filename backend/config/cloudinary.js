import fs from "fs";
import { v2 as cloudinary } from "cloudinary";

function getCloudinaryEnv() {
  return {
    cloudName: process.env.CLOUDINARY_CLOUD_NAME?.trim(),
    apiKey: process.env.CLOUDINARY_API_KEY?.trim(),
    apiSecret: process.env.CLOUDINARY_API_SECRET?.trim(),
  };
}

function configureCloudinary() {
  const { cloudName, apiKey, apiSecret } = getCloudinaryEnv();
  if (cloudName && apiKey && apiSecret) {
    cloudinary.config({
      cloud_name: cloudName,
      api_key: apiKey,
      api_secret: apiSecret,
      secure: true,
    });
  }
  return { cloudName, apiKey, apiSecret };
}

configureCloudinary();

export function assertCloudinaryConfigured() {
  const { cloudName, apiKey, apiSecret } = configureCloudinary();
  if (!cloudName || !apiKey || !apiSecret) {
    const err = new Error(
      "Cloudinary is not configured on the server. Add the Cloudinary environment variables in Render, then redeploy."
    );
    err.statusCode = 503;
    throw err;
  }
}

function detectKind(mimetype = "", originalname = "") {
  const name = String(originalname || "").toLowerCase();
  if (
    mimetype.startsWith("video/") ||
    /\.(mp4|webm|mov|m4v|mkv|avi)$/i.test(name)
  ) {
    return "video";
  }
  if (
    mimetype.startsWith("audio/") ||
    /\.(mp3|wav|m4a|aac|ogg)$/i.test(name)
  ) {
    return "audio";
  }
  if (mimetype === "application/pdf" || name.endsWith(".pdf")) {
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

/** Resolve a usable HTTPS delivery URL from a Cloudinary upload result. */
function resolveDeliveryUrl(uploaded, resourceType) {
  if (uploaded?.secure_url) return uploaded.secure_url;
  if (uploaded?.url) {
    return String(uploaded.url).replace(/^http:\/\//i, "https://");
  }
  if (uploaded?.public_id) {
    return deliveryUrl(uploaded.public_id, resourceType);
  }
  return null;
}

/**
 * upload_large may return a Promise or an UploadStream depending on SDK/input.
 * Normalize both to a resolved upload result object.
 */
function awaitUpload(resultOrStream) {
  if (
    resultOrStream &&
    typeof resultOrStream.then === "function"
  ) {
    return resultOrStream;
  }
  if (
    resultOrStream &&
    typeof resultOrStream.on === "function"
  ) {
    return new Promise((resolve, reject) => {
      resultOrStream.on("error", reject);
      // Some SDK builds emit the final payload on "end" / pipe finish.
      let settled = false;
      const finish = (payload) => {
        if (settled) return;
        settled = true;
        if (payload && (payload.secure_url || payload.public_id)) {
          resolve(payload);
        } else {
          reject(
            new Error(
              "Cloudinary video upload finished without a usable response payload."
            )
          );
        }
      };
      resultOrStream.on("end", () => finish(resultOrStream));
      // Newer SDK: promise-like helpers may attach .promise()
      if (typeof resultOrStream.promise === "function") {
        resultOrStream.promise().then(resolve).catch(reject);
      }
    });
  }
  return Promise.resolve(resultOrStream);
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
      delivery_url: resolveDeliveryUrl(uploaded, "image") || deliveryUrl(uploaded.public_id, "image"),
      kind,
    };
  }

  // Videos: use regular upload for typical sizes; chunked only for large files.
  // Do not rely on eager_async (it can omit secure_url). Poster is generated via URL.
  if (kind === "video") {
    let fileSize = 0;
    try {
      fileSize = fs.statSync(filePath).size;
    } catch (_) {
      fileSize = 0;
    }

    const LARGE_VIDEO_BYTES = 40 * 1024 * 1024; // 40MB
    let uploaded;
    if (fileSize > LARGE_VIDEO_BYTES) {
      uploaded = await awaitUpload(
        cloudinary.uploader.upload_large(filePath, {
          ...baseOptions,
          resource_type: "video",
          chunk_size: 6_000_000,
        })
      );
    } else {
      uploaded = await cloudinary.uploader.upload(filePath, {
        ...baseOptions,
        resource_type: "video",
      });
    }

    const delivery = resolveDeliveryUrl(uploaded, "video");
    if (!delivery) {
      const err = new Error(
        "Cloudinary video upload completed without a delivery URL."
      );
      err.statusCode = 502;
      err.details = {
        keys: uploaded ? Object.keys(uploaded) : [],
        public_id: uploaded?.public_id || null,
      };
      throw err;
    }

    return {
      ...uploaded,
      delivery_url: delivery,
      poster_url: uploaded.public_id
        ? videoPosterUrl(uploaded.public_id)
        : null,
      duration_label: formatDuration(uploaded.duration),
      kind,
    };
  }

  const uploaded = await cloudinary.uploader.upload(filePath, baseOptions);
  return {
    ...uploaded,
    delivery_url: resolveDeliveryUrl(uploaded, baseOptions.resource_type),
    kind,
  };
}

export default cloudinary;
