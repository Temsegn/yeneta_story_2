import { formatDate, truncate } from "@/lib/format";
import type { BookItem, StoryItem, VideoItem } from "@/lib/types";
import { Badge } from "@/components/ui/badge";
import { Card, CardHeader } from "@/components/ui/card";
import { EmptyState } from "@/components/ui/empty-state";

type Item = VideoItem | StoryItem | BookItem;

export function RecentContent({
  title,
  items,
  emptyTitle,
}: {
  title: string;
  items: Item[];
  emptyTitle: string;
}) {
  return (
    <Card className="h-full">
      <CardHeader title={title} subtitle="Latest items from the API" />
      <div className="space-y-3 p-5">
        {items.length === 0 ? (
          <EmptyState
            title={emptyTitle}
            description="Once content is uploaded through the admin API, it will appear here."
          />
        ) : (
          items.slice(0, 5).map((item) => (
            <div
              key={item._id}
              className="rounded-xl border border-border bg-muted/30 px-4 py-3"
            >
              <div className="flex items-start justify-between gap-3">
                <div>
                  <p className="font-semibold text-ink">{item.title}</p>
                  <p className="mt-1 text-sm text-muted-fg">
                    {truncate(item.description, 70)}
                  </p>
                </div>
                {item.isPremium ? <Badge tone="premium">Premium</Badge> : null}
              </div>
              <p className="mt-2 text-xs text-muted-fg">
                {formatDate(item.createdAt)}
              </p>
            </div>
          ))
        )}
      </div>
    </Card>
  );
}
