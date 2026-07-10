"use client";

import { FormEvent, useEffect, useState } from "react";
import { useRouter } from "next/navigation";
import {
  createBook,
  createEducation,
  createStory,
  createVideo,
  fetchBook,
  fetchEducationItem,
  fetchStory,
  fetchVideo,
  updateBook,
  updateEducation,
  updateStory,
  updateVideo,
} from "@/lib/api";
import type { BookPage, ContentKind, StoryPage } from "@/lib/types";
import { Button } from "@/components/ui/button";
import { FileUpload } from "@/components/ui/file-upload";
import { Input } from "@/components/ui/input";
import { PageHeader } from "@/components/ui/confirm-dialog";

type Props = {
  kind: ContentKind;
  id?: string;
};

const titles: Record<ContentKind, string> = {
  videos: "Video",
  stories: "Story",
  books: "Book",
  education: "Education",
};

export function ContentForm({ kind, id }: Props) {
  const router = useRouter();
  const editing = Boolean(id);
  const [title, setTitle] = useState("");
  const [description, setDescription] = useState("");
  const [mediaUrl, setMediaUrl] = useState("");
  const [coverUrl, setCoverUrl] = useState("");
  const [duration, setDuration] = useState("");
  const [author, setAuthor] = useState("Yeneta");
  const [ageGroup, setAgeGroup] = useState("3-5");
  const [isPremium, setIsPremium] = useState(true);
  const [isVisible, setIsVisible] = useState(true);
  const [pages, setPages] = useState<Array<StoryPage | BookPage>>([]);
  const [error, setError] = useState("");
  const [loading, setLoading] = useState(false);
  const [booting, setBooting] = useState(editing);

  useEffect(() => {
    if (!id) return;
    let alive = true;
    (async () => {
      try {
        if (kind === "videos") {
          const item = await fetchVideo(id);
          if (!alive) return;
          setTitle(item.title);
          setDescription(item.description || "");
          setMediaUrl(item.videoUrl || "");
          setCoverUrl(item.thumbnail || "");
          setIsPremium(item.isPremium !== false);
          setIsVisible(item.isVisible !== false);
        } else if (kind === "stories") {
          const item = await fetchStory(id);
          if (!alive) return;
          setTitle(item.title);
          setDescription(item.description || "");
          setCoverUrl(item.coverImageUrl || "");
          setIsPremium(item.isPremium !== false);
          setIsVisible(item.isVisible !== false);
          setPages(item.pages || []);
        } else if (kind === "books") {
          const item = await fetchBook(id);
          if (!alive) return;
          setTitle(item.title);
          setDescription(item.description || "");
          setCoverUrl(item.coverImageUrl || "");
          setIsPremium(item.isPremium !== false);
          setIsVisible(item.isVisible !== false);
          setPages(item.pages || []);
        } else {
          const item = await fetchEducationItem(id);
          if (!alive) return;
          setTitle(item.title);
          setDescription(item.description || "");
          setMediaUrl(item.videoUrl || "");
          setCoverUrl(item.thumbnail || "");
          setDuration(item.duration || "");
          setAuthor(item.author || "Yeneta");
          setAgeGroup(item.ageGroup || "3-5");
          setIsPremium(item.isPremium !== false);
          setIsVisible(item.isVisible !== false);
        }
      } catch (err) {
        if (alive) {
          setError(err instanceof Error ? err.message : "Failed to load");
        }
      } finally {
        if (alive) setBooting(false);
      }
    })();
    return () => {
      alive = false;
    };
  }, [id, kind]);

  const addPage = () => {
    if (kind === "stories") {
      setPages((prev) => [
        ...prev,
        {
          pageNumber: prev.length + 1,
          title: `Page ${prev.length + 1}`,
          imageUrl: "",
          audioUrl: "",
          content: "",
        },
      ]);
    } else {
      setPages((prev) => [
        ...prev,
        {
          pageNumber: prev.length + 1,
          title: `Page ${prev.length + 1}`,
          imageUrl: "",
          content: "",
        },
      ]);
    }
  };

  const onSubmit = async (event: FormEvent) => {
    event.preventDefault();
    setLoading(true);
    setError("");
    try {
      if (kind === "videos") {
        const body = {
          title,
          description,
          videoUrl: mediaUrl,
          thumbnail: coverUrl,
          isPremium,
          isVisible,
        };
        if (editing && id) await updateVideo(id, body);
        else await createVideo(body);
        router.push("/videos");
      } else if (kind === "stories") {
        const body = {
          title,
          description,
          coverImageUrl: coverUrl,
          isPremium,
          isVisible,
          pages: pages as StoryPage[],
        };
        if (editing && id) await updateStory(id, body);
        else await createStory(body);
        router.push("/stories");
      } else if (kind === "books") {
        const body = {
          title,
          description,
          coverImageUrl: coverUrl,
          isPremium,
          isVisible,
          pages: pages as BookPage[],
        };
        if (editing && id) await updateBook(id, body);
        else await createBook(body);
        router.push("/books");
      } else {
        const body = {
          title,
          description,
          videoUrl: mediaUrl,
          thumbnail: coverUrl,
          duration,
          author,
          ageGroup,
          isPremium,
          isVisible,
        };
        if (editing && id) await updateEducation(id, body);
        else await createEducation(body);
        router.push("/education");
      }
    } catch (err) {
      setError(err instanceof Error ? err.message : "Save failed");
    } finally {
      setLoading(false);
    }
  };

  if (booting) {
    return <p className="text-muted-fg">Loading form…</p>;
  }

  return (
    <div className="space-y-6">
      <PageHeader
        title={`${editing ? "Edit" : "Create"} ${titles[kind]}`}
        subtitle="Upload media, set visibility, and publish to the app."
      />

      <form
        onSubmit={onSubmit}
        className="space-y-5 rounded-2xl border border-border bg-white p-6"
      >
        {error ? (
          <div className="rounded-xl border border-coral/20 bg-coral/10 px-4 py-3 text-sm text-coral">
            {error}
          </div>
        ) : null}

        <Input
          label="Title"
          value={title}
          onChange={(e) => setTitle(e.target.value)}
          required
        />
        <label className="block space-y-2">
          <span className="text-sm font-semibold text-ink">Description</span>
          <textarea
            className="min-h-28 w-full rounded-xl border border-border bg-white px-3.5 py-3 outline-none focus:border-orange focus:ring-4 focus:ring-orange/15"
            value={description}
            onChange={(e) => setDescription(e.target.value)}
            required
          />
        </label>

        {(kind === "videos" || kind === "education") && (
          <FileUpload
            label="Video file / URL"
            accept="video/*"
            value={mediaUrl}
            onUploaded={setMediaUrl}
          />
        )}

        <FileUpload
          label={kind === "videos" || kind === "education" ? "Thumbnail" : "Cover image"}
          accept="image/*"
          value={coverUrl}
          onUploaded={setCoverUrl}
        />

        {kind === "education" ? (
          <>
            <Input
              label="Duration"
              value={duration}
              onChange={(e) => setDuration(e.target.value)}
              placeholder="5:30"
            />
            <Input
              label="Author"
              value={author}
              onChange={(e) => setAuthor(e.target.value)}
            />
            <label className="block space-y-2">
              <span className="text-sm font-semibold text-ink">Age group</span>
              <select
                className="w-full rounded-xl border border-border bg-white px-3.5 py-3"
                value={ageGroup}
                onChange={(e) => setAgeGroup(e.target.value)}
              >
                <option value="3-5">3-5</option>
                <option value="5-8">5-8</option>
                <option value="8-11">8-11</option>
              </select>
            </label>
          </>
        ) : null}

        <div className="flex flex-wrap gap-4">
          <label className="flex items-center gap-2 text-sm font-semibold">
            <input
              type="checkbox"
              checked={isPremium}
              onChange={(e) => setIsPremium(e.target.checked)}
            />
            Premium
          </label>
          <label className="flex items-center gap-2 text-sm font-semibold">
            <input
              type="checkbox"
              checked={isVisible}
              onChange={(e) => setIsVisible(e.target.checked)}
            />
            Visible in app
          </label>
        </div>

        {(kind === "stories" || kind === "books") && (
          <div className="space-y-3">
            <div className="flex items-center justify-between">
              <h3 className="font-bold text-ink">Pages</h3>
              <Button type="button" variant="secondary" onClick={addPage}>
                Add page
              </Button>
            </div>
            {pages.map((page, index) => (
              <div
                key={index}
                className="space-y-3 rounded-xl border border-border bg-muted/30 p-4"
              >
                <Input
                  label={`Page ${index + 1} title`}
                  value={page.title || ""}
                  onChange={(e) => {
                    const next = [...pages];
                    next[index] = { ...next[index], title: e.target.value };
                    setPages(next);
                  }}
                />
                <label className="block space-y-2">
                  <span className="text-sm font-semibold text-ink">Content</span>
                  <textarea
                    className="min-h-20 w-full rounded-xl border border-border bg-white px-3.5 py-3"
                    value={page.content}
                    onChange={(e) => {
                      const next = [...pages];
                      next[index] = { ...next[index], content: e.target.value };
                      setPages(next);
                    }}
                    required
                  />
                </label>
                <FileUpload
                  label="Page image"
                  accept="image/*"
                  value={page.imageUrl}
                  onUploaded={(url) => {
                    const next = [...pages];
                    next[index] = { ...next[index], imageUrl: url };
                    setPages(next);
                  }}
                />
                {kind === "stories" ? (
                  <FileUpload
                    label="Page audio"
                    accept="audio/*"
                    value={(page as StoryPage).audioUrl}
                    onUploaded={(url) => {
                      const next = [...pages];
                      next[index] = {
                        ...(next[index] as StoryPage),
                        audioUrl: url,
                      };
                      setPages(next);
                    }}
                  />
                ) : null}
              </div>
            ))}
          </div>
        )}

        <div className="flex gap-3">
          <Button type="submit" disabled={loading}>
            {loading ? "Saving…" : editing ? "Update" : "Create"}
          </Button>
          <Button
            type="button"
            variant="secondary"
            onClick={() => router.push(`/${kind}`)}
          >
            Cancel
          </Button>
        </div>
      </form>
    </div>
  );
}
