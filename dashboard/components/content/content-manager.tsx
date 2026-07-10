"use client";

import Link from "next/link";
import { useCallback, useEffect, useState } from "react";
import {
  deleteBook,
  deleteEducation,
  deleteStory,
  deleteVideo,
  fetchBooks,
  fetchEducation,
  fetchStories,
  fetchVideos,
  updateBook,
  updateEducation,
  updateStory,
  updateVideo,
} from "@/lib/api";
import type {
  BookItem,
  ContentKind,
  EducationItem,
  StoryItem,
  VideoItem,
} from "@/lib/types";
import { ContentTable, type ContentRow } from "@/components/content/content-table";
import { Button } from "@/components/ui/button";
import { PageHeader } from "@/components/ui/confirm-dialog";

function toRows(
  items: Array<VideoItem | StoryItem | BookItem | EducationItem>
): ContentRow[] {
  return items.map((item) => ({
    id: item._id,
    title: item.title,
    description: item.description,
    isPremium: item.isPremium,
    isVisible: item.isVisible,
    createdAt: item.createdAt,
  }));
}

const copy: Record<
  ContentKind,
  { title: string; subtitle: string; search: string }
> = {
  videos: {
    title: "Videos",
    subtitle: "Create, edit, hide, or remove video lessons.",
    search: "Search videos…",
  },
  stories: {
    title: "Stories",
    subtitle: "Manage illustrated stories and page content.",
    search: "Search stories…",
  },
  books: {
    title: "Books",
    subtitle: "Manage books and reading pages.",
    search: "Search books…",
  },
  education: {
    title: "Education",
    subtitle: "Age-grouped learning videos for the education tab.",
    search: "Search education…",
  },
};

export function ContentManager({ kind }: { kind: ContentKind }) {
  const [rows, setRows] = useState<ContentRow[]>([]);
  const [total, setTotal] = useState(0);
  const [loading, setLoading] = useState(true);
  const [error, setError] = useState("");
  const meta = copy[kind];

  const load = useCallback(async () => {
    setLoading(true);
    setError("");
    try {
      if (kind === "videos") {
        const data = await fetchVideos(1, 100);
        setRows(toRows(data.videos || []));
        setTotal(data.total ?? data.videos?.length ?? 0);
      } else if (kind === "stories") {
        const data = await fetchStories(1, 100);
        setRows(toRows(data.stories || []));
        setTotal(data.total ?? data.stories?.length ?? 0);
      } else if (kind === "books") {
        const data = await fetchBooks(1, 100);
        setRows(toRows(data.books || []));
        setTotal(data.total ?? data.books?.length ?? 0);
      } else {
        const data = await fetchEducation(1, 100);
        setRows(toRows(data.education || []));
        setTotal(data.total ?? data.education?.length ?? 0);
      }
    } catch (err) {
      setError(err instanceof Error ? err.message : "Failed to load content");
      setRows([]);
      setTotal(0);
    } finally {
      setLoading(false);
    }
  }, [kind]);

  useEffect(() => {
    void load();
  }, [load]);

  const onDelete = async (id: string) => {
    if (kind === "videos") await deleteVideo(id);
    else if (kind === "stories") await deleteStory(id);
    else if (kind === "books") await deleteBook(id);
    else await deleteEducation(id);
    setRows((prev) => prev.filter((row) => row.id !== id));
    setTotal((prev) => Math.max(0, prev - 1));
  };

  const onToggleVisible = async (id: string, next: boolean) => {
    if (kind === "videos") await updateVideo(id, { isVisible: next });
    else if (kind === "stories") await updateStory(id, { isVisible: next });
    else if (kind === "books") await updateBook(id, { isVisible: next });
    else await updateEducation(id, { isVisible: next });
    setRows((prev) =>
      prev.map((row) => (row.id === id ? { ...row, isVisible: next } : row))
    );
  };

  return (
    <div className="space-y-6">
      <PageHeader
        title={meta.title}
        subtitle={meta.subtitle}
        action={
          <div className="flex items-center gap-3">
            <div className="rounded-2xl border border-border bg-white px-4 py-3 text-right">
              <p className="text-xs font-bold uppercase tracking-wide text-muted-fg">
                Total
              </p>
              <p className="text-2xl font-black text-ink">{total}</p>
            </div>
            <Link href={`/${kind}/new`}>
              <Button>Create {meta.title.slice(0, -1)}</Button>
            </Link>
          </div>
        }
      />

      {error ? (
        <div className="rounded-2xl border border-coral/20 bg-coral/10 px-4 py-3 text-sm text-coral">
          {error}
        </div>
      ) : null}

      <ContentTable
        rows={rows}
        loading={loading}
        onDelete={onDelete}
        onToggleVisible={onToggleVisible}
        detailHref={(id) => `/${kind}/${id}`}
        editHref={(id) => `/${kind}/${id}/edit`}
        searchPlaceholder={meta.search}
      />
    </div>
  );
}
