"use client";

import Link from "next/link";
import { useMemo, useState } from "react";
import { formatDate, truncate } from "@/lib/format";
import { Badge } from "@/components/ui/badge";
import { Button } from "@/components/ui/button";
import { EmptyState } from "@/components/ui/empty-state";
import { Input } from "@/components/ui/input";
import { StatusToggle } from "@/components/ui/confirm-dialog";

export type ContentRow = {
  id: string;
  title: string;
  description?: string;
  isPremium?: boolean;
  isVisible?: boolean;
  createdAt?: string;
};

export function ContentTable({
  rows,
  loading,
  onDelete,
  onToggleVisible,
  detailHref,
  editHref,
  searchPlaceholder = "Search titles…",
}: {
  rows: ContentRow[];
  loading?: boolean;
  onDelete?: (id: string) => Promise<void> | void;
  onToggleVisible?: (id: string, next: boolean) => Promise<void> | void;
  detailHref?: (id: string) => string;
  editHref?: (id: string) => string;
  searchPlaceholder?: string;
}) {
  const [query, setQuery] = useState("");
  const [busyId, setBusyId] = useState<string | null>(null);

  const filtered = useMemo(() => {
    const q = query.trim().toLowerCase();
    if (!q) return rows;
    return rows.filter(
      (row) =>
        row.title.toLowerCase().includes(q) ||
        row.description?.toLowerCase().includes(q)
    );
  }, [query, rows]);

  const handleDelete = async (id: string) => {
    if (!onDelete) return;
    const ok = window.confirm("Delete this item permanently?");
    if (!ok) return;
    setBusyId(id);
    try {
      await onDelete(id);
    } finally {
      setBusyId(null);
    }
  };

  return (
    <div className="space-y-4">
      <Input
        label="Search"
        placeholder={searchPlaceholder}
        value={query}
        onChange={(e) => setQuery(e.target.value)}
      />

      {loading ? (
        <div className="rounded-2xl border border-border bg-white px-5 py-10 text-center text-muted-fg">
          Loading content…
        </div>
      ) : filtered.length === 0 ? (
        <EmptyState
          title="No matching content"
          description="Create new content or try another search."
        />
      ) : (
        <div className="overflow-hidden rounded-2xl border border-border bg-white">
          <div className="hidden grid-cols-[1.3fr_1.2fr_0.6fr_0.7fr_0.7fr_1fr] gap-3 border-b border-border bg-muted/50 px-4 py-3 text-xs font-bold uppercase tracking-wide text-muted-fg lg:grid">
            <span>Title</span>
            <span>Description</span>
            <span>Access</span>
            <span>Visible</span>
            <span>Created</span>
            <span>Actions</span>
          </div>
          <div className="divide-y divide-border">
            {filtered.map((row) => (
              <div
                key={row.id}
                className="grid gap-3 px-4 py-4 lg:grid-cols-[1.3fr_1.2fr_0.6fr_0.7fr_0.7fr_1fr] lg:items-center"
              >
                <div>
                  {detailHref ? (
                    <Link
                      href={detailHref(row.id)}
                      className="font-semibold text-ink hover:text-orange"
                    >
                      {row.title}
                    </Link>
                  ) : (
                    <p className="font-semibold text-ink">{row.title}</p>
                  )}
                </div>
                <p className="hidden text-sm text-muted-fg lg:block">
                  {truncate(row.description, 90)}
                </p>
                <div>
                  {row.isPremium ? (
                    <Badge tone="premium">Premium</Badge>
                  ) : (
                    <Badge tone="success">Free</Badge>
                  )}
                </div>
                <div>
                  {onToggleVisible ? (
                    <StatusToggle
                      checked={row.isVisible !== false}
                      label={row.isVisible !== false ? "Visible" : "Hidden"}
                      onChange={(next) => onToggleVisible(row.id, next)}
                    />
                  ) : (
                    <span className="text-sm text-muted-fg">
                      {row.isVisible !== false ? "Visible" : "Hidden"}
                    </span>
                  )}
                </div>
                <p className="text-sm text-muted-fg">{formatDate(row.createdAt)}</p>
                <div className="flex flex-wrap gap-2">
                  {editHref ? (
                    <Link href={editHref(row.id)}>
                      <Button variant="secondary" className="px-3 py-2 text-xs">
                        Edit
                      </Button>
                    </Link>
                  ) : null}
                  {onDelete ? (
                    <Button
                      variant="danger"
                      className="px-3 py-2 text-xs"
                      disabled={busyId === row.id}
                      onClick={() => handleDelete(row.id)}
                    >
                      {busyId === row.id ? "…" : "Delete"}
                    </Button>
                  ) : null}
                </div>
              </div>
            ))}
          </div>
        </div>
      )}
    </div>
  );
}
