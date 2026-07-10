import Link from "next/link";
import { Card, CardHeader } from "@/components/ui/card";

const actions = [
  { href: "/videos/new", title: "Upload video", description: "Add a new video lesson with thumbnail." },
  { href: "/stories/new", title: "Create story", description: "Build a multi-page illustrated story." },
  { href: "/books/new", title: "Create book", description: "Publish a book with page content." },
  { href: "/education/new", title: "Add education", description: "Age-grouped learning video." },
  { href: "/users", title: "Manage users", description: "Internal staff and external clients." },
  { href: "/plans", title: "Subscription plans", description: "Prices, visibility, and catalog." },
];

export function QuickActions() {
  return (
    <Card>
      <CardHeader
        title="Quick actions"
        subtitle="Jump into the most common studio workflows."
      />
      <div className="grid gap-3 p-5 md:grid-cols-3">
        {actions.map((action) => (
          <Link
            key={action.href}
            href={action.href}
            className="rounded-2xl border border-border bg-muted/40 p-4 transition hover:-translate-y-0.5 hover:border-orange/40 hover:bg-white"
          >
            <p className="font-bold text-ink">{action.title}</p>
            <p className="mt-1 text-sm text-muted-fg">{action.description}</p>
          </Link>
        ))}
      </div>
    </Card>
  );
}
