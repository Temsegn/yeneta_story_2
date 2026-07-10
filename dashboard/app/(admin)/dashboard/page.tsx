"use client";

import { useEffect, useState } from "react";
import {
  fetchAdminStats,
  fetchAuditLogs,
  fetchBooks,
  fetchStories,
  fetchVideos,
} from "@/lib/api";
import type { BookItem, DashboardStats, StoryItem, VideoItem } from "@/lib/types";
import { OverviewHero } from "@/components/dashboard/overview-hero";
import { QuickActions } from "@/components/dashboard/quick-actions";
import { RecentContent } from "@/components/dashboard/recent-content";
import { StatCard } from "@/components/dashboard/stat-card";
import { Topbar } from "@/components/layout/topbar";

export default function DashboardPage() {
  const [stats, setStats] = useState<DashboardStats>({
    users: 0,
    admins: 0,
    videos: 0,
    stories: 0,
    books: 0,
    activeSubscriptions: 0,
    payments: 0,
    revenue: 0,
  });
  const [videos, setVideos] = useState<VideoItem[]>([]);
  const [stories, setStories] = useState<StoryItem[]>([]);
  const [books, setBooks] = useState<BookItem[]>([]);
  const [activity, setActivity] = useState(0);
  const [error, setError] = useState("");
  const [loading, setLoading] = useState(true);

  useEffect(() => {
    let alive = true;
    (async () => {
      try {
        const [statsRes, videosRes, storiesRes, booksRes, logsRes] =
          await Promise.all([
            fetchAdminStats().catch(() => null),
            fetchVideos(1, 8),
            fetchStories(1, 8),
            fetchBooks(1, 8),
            fetchAuditLogs().catch(() => []),
          ]);

        if (!alive) return;

        const videoItems = videosRes.videos || [];
        const storyItems = storiesRes.stories || [];
        const bookItems = booksRes.books || [];
        const logs = Array.isArray(logsRes)
          ? logsRes
          : Array.isArray((logsRes as { logs?: unknown }).logs)
            ? (logsRes as { logs: unknown[] }).logs
            : [];

        setVideos(videoItems);
        setStories(storyItems);
        setBooks(bookItems);
        setActivity(logs.length);

        if (statsRes) {
          setStats(statsRes);
        } else {
          setStats((prev) => ({
            ...prev,
            videos: videosRes.total ?? videoItems.length,
            stories: storiesRes.total ?? storyItems.length,
            books: booksRes.total ?? bookItems.length,
          }));
        }
      } catch (err) {
        if (!alive) return;
        setError(err instanceof Error ? err.message : "Failed to load dashboard");
      } finally {
        if (alive) setLoading(false);
      }
    })();
    return () => {
      alive = false;
    };
  }, []);

  return (
    <div className="space-y-6">
      <Topbar
        title="Overview"
        subtitle="Live production snapshot of Yeneta Story."
      />
      <OverviewHero />
      {error ? (
        <div className="rounded-2xl border border-coral/20 bg-coral/10 px-4 py-3 text-sm text-coral">
          {error}
        </div>
      ) : null}
      <div className="grid gap-4 sm:grid-cols-2 xl:grid-cols-4">
        <StatCard
          label="Users"
          value={stats.users}
          hint={loading ? "Loading…" : "Registered accounts"}
          accent="ink"
        />
        <StatCard
          label="Videos"
          value={stats.videos}
          hint={loading ? "Loading…" : "Video catalog"}
          accent="orange"
        />
        <StatCard
          label="Active subs"
          value={stats.activeSubscriptions}
          hint={loading ? "Loading…" : "Paying subscribers"}
          accent="green"
        />
        <StatCard
          label="Revenue"
          value={stats.revenue}
          hint={loading ? "Loading…" : `Payments ${stats.payments} · activity ${activity}`}
          accent="coral"
        />
      </div>
      <QuickActions />
      <div className="grid gap-4 xl:grid-cols-3">
        <RecentContent title="Recent videos" items={videos} emptyTitle="No videos yet" />
        <RecentContent title="Recent stories" items={stories} emptyTitle="No stories yet" />
        <RecentContent title="Recent books" items={books} emptyTitle="No books yet" />
      </div>
    </div>
  );
}
