"use client";

import Link from "next/link";
import { use, useEffect, useState } from "react";
import { fetchSubscription, updateSubscription } from "@/lib/api";
import { formatDate } from "@/lib/format";
import type { SubscriptionItem } from "@/lib/types";
import { Button } from "@/components/ui/button";
import { PageHeader } from "@/components/ui/confirm-dialog";

export default function SubscriptionDetailPage({
  params,
}: {
  params: Promise<{ id: string }>;
}) {
  const { id } = use(params);
  const [item, setItem] = useState<SubscriptionItem | null>(null);
  const [error, setError] = useState("");

  useEffect(() => {
    (async () => {
      try {
        setItem(await fetchSubscription(id));
      } catch (err) {
        setError(err instanceof Error ? err.message : "Failed to load");
      }
    })();
  }, [id]);

  if (error) {
    return (
      <div className="rounded-2xl border border-coral/20 bg-coral/10 px-4 py-3 text-sm text-coral">
        {error}
      </div>
    );
  }
  if (!item) return <p className="text-muted-fg">Loading…</p>;

  return (
    <div className="space-y-6">
      <PageHeader
        title={`${item.plan} subscription`}
        subtitle={item.user?.fullName || item._id}
        action={
          <Link href="/subscriptions">
            <Button variant="secondary">Back</Button>
          </Link>
        }
      />
      <div className="rounded-2xl border border-border bg-white p-5 space-y-2 text-sm">
        <p>Status: <strong>{item.status}</strong></p>
        <p>Price: {item.price} ETB</p>
        <p>Start: {formatDate(item.startDate)}</p>
        <p>End: {formatDate(item.endDate)}</p>
        <p>Tx ref: {item.txRef || "—"}</p>
        <p>Phone: {item.user?.phoneNumber || "—"}</p>
      </div>
      <div className="flex gap-2">
        <Button
          onClick={async () => {
            const next = await updateSubscription(id, {
              status: item.status === "active" ? "inactive" : "active",
            });
            setItem(next);
          }}
        >
          {item.status === "active" ? "Deactivate" : "Activate"}
        </Button>
      </div>
    </div>
  );
}
