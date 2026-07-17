"use client";

import { useEffect, useMemo, useState } from "react";
import { uploadFile, type UploadResult } from "@/lib/api";
import { Button } from "@/components/ui/button";

function isImageUrl(url?: string, accept?: string) {
  if (!url) return false;
  if (accept && accept.startsWith("image")) return true;
  return (
    /\.(png|jpe?g|gif|webp|avif|svg)(\?|$)/i.test(url) ||
    /\/image\/upload\//i.test(url)
  );
}

function isVideoUrl(url?: string, accept?: string) {
  if (!url) return false;
  if (accept && accept.startsWith("video")) return true;
  return /\.(mp4|webm|mov|m4v)(\?|$)/i.test(url) || /\/video\/upload\//i.test(url);
}

function formatBytes(bytes?: number | null) {
  if (!bytes || bytes <= 0) return "";
  if (bytes < 1024) return `${bytes} B`;
  if (bytes < 1024 * 1024) return `${(bytes / 1024).toFixed(1)} KB`;
  return `${(bytes / (1024 * 1024)).toFixed(1)} MB`;
}

export function FileUpload({
  label,
  accept = "image/*,video/*,audio/*",
  value,
  onUploaded,
  onUploadComplete,
}: {
  label: string;
  accept?: string;
  value?: string;
  onUploaded: (url: string) => void;
  onUploadComplete?: (result: UploadResult) => void;
}) {
  const [busy, setBusy] = useState(false);
  const [progress, setProgress] = useState(0);
  const [error, setError] = useState("");
  const [localPreview, setLocalPreview] = useState("");
  const [meta, setMeta] = useState<{
    filename?: string;
    size?: number;
    width?: number | null;
    height?: number | null;
    duration?: string | null;
  }>({});

  useEffect(() => {
    return () => {
      if (localPreview) URL.revokeObjectURL(localPreview);
    };
  }, [localPreview]);

  const previewUrl = localPreview || value;
  const showImage = isImageUrl(previewUrl, accept);
  const showVideo = !showImage && isVideoUrl(previewUrl, accept);

  const details = useMemo(() => {
    const parts = [
      meta.filename,
      formatBytes(meta.size),
      meta.width && meta.height ? `${meta.width}×${meta.height}` : "",
      meta.duration ? `Duration ${meta.duration}` : "",
    ].filter(Boolean);
    return parts.join(" · ");
  }, [meta]);

  const onChange = async (file?: File | null) => {
    if (!file) return;
    setBusy(true);
    setError("");
    setProgress(0);
    setMeta({ filename: file.name, size: file.size });

    if (localPreview) URL.revokeObjectURL(localPreview);
    const preview = URL.createObjectURL(file);
    setLocalPreview(preview);

    try {
      const result = await uploadFile(file, setProgress);
      setMeta({
        filename: result.filename || file.name,
        size: result.bytes || result.size || file.size,
        width: result.width,
        height: result.height,
        duration: result.duration,
      });
      onUploaded(result.url);
      onUploadComplete?.(result);
      setProgress(100);
    } catch (err) {
      setError(err instanceof Error ? err.message : "Upload failed");
      setProgress(0);
    } finally {
      setBusy(false);
    }
  };

  const clear = () => {
    if (localPreview) URL.revokeObjectURL(localPreview);
    setLocalPreview("");
    setMeta({});
    setProgress(0);
    setError("");
    onUploaded("");
  };

  return (
    <div className="space-y-2">
      <p className="text-sm font-semibold text-ink">{label}</p>

      {previewUrl ? (
        <div className="overflow-hidden rounded-2xl border border-border bg-muted/30">
          {showImage ? (
            // eslint-disable-next-line @next/next/no-img-element
            <img
              src={previewUrl}
              alt={label}
              className="h-52 w-full object-cover"
            />
          ) : showVideo ? (
            <video
              src={previewUrl}
              controls
              className="h-52 w-full bg-black object-contain"
            />
          ) : (
            <p className="truncate px-3 py-2 text-xs text-muted-fg">{previewUrl}</p>
          )}
          <div className="space-y-1 border-t border-border px-3 py-2">
            {details ? (
              <p className="text-xs font-medium text-ink">{details}</p>
            ) : null}
            <p className="truncate text-[11px] text-muted-fg">{value || "Uploading…"}</p>
          </div>
        </div>
      ) : (
        <div className="flex h-36 items-center justify-center rounded-2xl border border-dashed border-border bg-muted/20 px-4 text-center text-sm text-muted-fg">
          Drop-in preview appears here after you choose a file
        </div>
      )}

      {busy ? (
        <div className="space-y-1">
          <div className="h-2 overflow-hidden rounded-full bg-muted">
            <div
              className="h-full rounded-full bg-orange transition-all duration-200"
              style={{ width: `${Math.max(progress, 8)}%` }}
            />
          </div>
          <p className="text-xs font-medium text-muted-fg">
            Uploading to Cloudinary… {progress}%
          </p>
        </div>
      ) : null}

      <div className="flex flex-wrap items-center gap-2">
        <label className="inline-flex cursor-pointer">
          <input
            type="file"
            accept={accept}
            className="hidden"
            disabled={busy}
            onChange={(e) => onChange(e.target.files?.[0])}
          />
          <span className="inline-flex items-center justify-center rounded-xl border border-border bg-white px-4 py-2.5 text-sm font-semibold text-ink hover:border-orange/40">
            {busy ? "Uploading…" : value ? "Replace file" : "Choose file"}
          </span>
        </label>
        {value || localPreview ? (
          <Button
            type="button"
            variant="secondary"
            className="px-3 py-2 text-xs"
            disabled={busy}
            onClick={clear}
          >
            Clear
          </Button>
        ) : null}
      </div>
      {error ? <p className="text-xs text-coral">{error}</p> : null}
    </div>
  );
}
