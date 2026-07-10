"use client";

import { useState } from "react";
import { uploadFile } from "@/lib/api";
import { Button } from "@/components/ui/button";

export function FileUpload({
  label,
  accept = "image/*,video/*,audio/*",
  value,
  onUploaded,
}: {
  label: string;
  accept?: string;
  value?: string;
  onUploaded: (url: string) => void;
}) {
  const [busy, setBusy] = useState(false);
  const [error, setError] = useState("");

  const onChange = async (file?: File | null) => {
    if (!file) return;
    setBusy(true);
    setError("");
    try {
      const result = await uploadFile(file);
      onUploaded(result.url);
    } catch (err) {
      setError(err instanceof Error ? err.message : "Upload failed");
    } finally {
      setBusy(false);
    }
  };

  return (
    <div className="space-y-2">
      <p className="text-sm font-semibold text-ink">{label}</p>
      {value ? (
        <p className="truncate rounded-xl border border-border bg-muted/40 px-3 py-2 text-xs text-muted-fg">
          {value}
        </p>
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
            {busy ? "Uploading…" : "Choose file"}
          </span>
        </label>
        {value ? (
          <Button
            type="button"
            variant="secondary"
            className="px-3 py-2 text-xs"
            onClick={() => onUploaded("")}
          >
            Clear
          </Button>
        ) : null}
      </div>
      {error ? <p className="text-xs text-coral">{error}</p> : null}
    </div>
  );
}
