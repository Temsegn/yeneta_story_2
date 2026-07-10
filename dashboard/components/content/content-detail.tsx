"use client";

import Link from "next/link";
import { useEffect, useState } from "react";
import {
  fetchBook,
  fetchEducationItem,
  fetchStory,
  fetchVideo,
} from "@/lib/api";
import { formatDate } from "@/lib/format";
import type {
  BookItem,
  ContentKind,
  EducationItem,
  StoryItem,
  VideoItem,
} from "@/lib/types";
import { Badge } from "@/components/ui/badge";
import { Button } from "@/components/ui/button";
import { PageHeader } from "@/components/ui/confirm-dialog";

export function ContentDetail({ kind, id }: { kind: ContentKind; id: string }) {
  const [item, setItem] = useState<
    VideoItem | StoryItem | BookItem | EducationItem | null
  >(null);
  const [error, setError] = useState("");
  const [loading, setLoading] = useState(true);

  useEffect(() => {
    let alive = true;
    (async () => {
      try {
        const data =
          kind === "videos"
            ? await fetchVideo(id)
            : kind === "stories"
              ? await fetchStory(id)
              : kind === "books"
                ? await fetchBook(id)
                : await fetchEducationItem(id);
        if (alive) setItem(data);
      } catch (err) {
        if (alive) {
          setError(err instanceof Error ? err.message : "Failed to load");
        }
      } finally {
        if (alive) setLoading(false);
      }
    })();
    return () => {
      alive = false;
    };
  }, [kind, id]);

  if (loading) return <p className="text-muted-fg">Loading detail…</p>;
  if (error || !item) {
    return (
      <div className="rounded-2xl border border-coral/20 bg-coral/10 px-4 py-3 text-sm text-coral">
        {error || "Not found"}
      </div>
    );
  }

  const cover =
    "thumbnail" in item
      ? item.thumbnail
      : "coverImageUrl" in item
        ? item.coverImageUrl
        : undefined;
  const media = "videoUrl" in item ? item.videoUrl : undefined;

  return (
    <div className="space-y-6">
      <PageHeader
        title={item.title}
        subtitle={`ID ${item._id} · ${formatDate(item.createdAt)}`}
        action={
          <div className="flex gap-2">
            <Link href={`/${kind}/${id}/edit`}>
              <Button>Edit</Button>
            </Link>
            <Link href={`/${kind}`}>
              <Button variant="secondary">Back</Button>
            </Link>
          </div>
        }
      />

      <div className="grid gap-6 lg:grid-cols-[1.1fr_0.9fr]">
        <div className="overflow-hidden rounded-2xl border border-border bg-white">
          {cover ? (
            // eslint-disable-next-line @next/next/no-img-element
            <img
              src={cover}
              alt={item.title}
              className="h-64 w-full object-cover"
            />
          ) : (
            <div className="flex h-64 items-center justify-center bg-muted text-muted-fg">
              No cover
            </div>
          )}
          {media ? (
            <div className="p-4">
              <video src={media} controls className="w-full rounded-xl" />
            </div>
          ) : null}
        </div>

        <div className="space-y-4 rounded-2xl border border-border bg-white p-5">
          <div className="flex flex-wrap gap-2">
            {item.isPremium ? (
              <Badge tone="premium">Premium</Badge>
            ) : (
              <Badge tone="success">Free</Badge>
            )}
            <Badge tone={item.isVisible !== false ? "success" : "premium"}>
              {item.isVisible !== false ? "Visible" : "Hidden"}
            </Badge>
          </div>
          <p className="text-sm leading-6 text-muted-fg">{item.description}</p>
          {"ageGroup" in item && item.ageGroup ? (
            <p className="text-sm font-semibold text-ink">
              Age group: {item.ageGroup}
            </p>
          ) : null}
          {"author" in item && item.author ? (
            <p className="text-sm text-muted-fg">Author: {item.author}</p>
          ) : null}
          {"duration" in item && item.duration ? (
            <p className="text-sm text-muted-fg">Duration: {item.duration}</p>
          ) : null}
        </div>
      </div>

      {"pages" in item && item.pages && item.pages.length > 0 ? (
        <div className="space-y-3">
          <h2 className="text-xl font-bold text-ink">Pages</h2>
          <div className="grid gap-3 md:grid-cols-2">
            {item.pages.map((page, index) => (
              <div
                key={index}
                className="rounded-2xl border border-border bg-white p-4"
              >
                <p className="font-semibold text-ink">
                  {page.pageNumber}. {page.title || "Untitled"}
                </p>
                <p className="mt-2 text-sm text-muted-fg">{page.content}</p>
                {page.imageUrl ? (
                  // eslint-disable-next-line @next/next/no-img-element
                  <img
                    src={page.imageUrl}
                    alt=""
                    className="mt-3 h-36 w-full rounded-xl object-cover"
                  />
                ) : null}
              </div>
            ))}
          </div>
        </div>
      ) : null}
    </div>
  );
}
