"use client";

import Link from "next/link";
import { FormEvent, useEffect, useState } from "react";
import {
  createSubscription,
  deleteSubscription,
  fetchSubscriptions,
  updateSubscription,
} from "@/lib/api";
import { formatDate } from "@/lib/format";
import type { SubscriptionItem } from "@/lib/types";
import { Badge } from "@/components/ui/badge";
import { Button } from "@/components/ui/button";
import { Input } from "@/components/ui/input";
import { PageHeader } from "@/components/ui/confirm-dialog";

export default function SubscriptionsPage() {
  const [items, setItems] = useState<SubscriptionItem[]>([]);
  const [status, setStatus] = useState("");
  const [error, setError] = useState("");
  const [form, setForm] = useState({
    userId: "",
    plan: "premium_monthly",
    price: "499",
    status: "active",
    durationInDays: "30",
  });

  const load = async () => {
    try {
      const data = await fetchSubscriptions({
        page: "1",
        limit: "100",
        ...(status ? { status } : {}),
      });
      setItems(data.subscriptions || []);
    } catch (err) {
      setError(err instanceof Error ? err.message : "Failed to load");
    }
  };

  useEffect(() => {
    void load();
    // eslint-disable-next-line react-hooks/exhaustive-deps
  }, [status]);

  const onCreate = async (event: FormEvent) => {
    event.preventDefault();
    setError("");
    try {
      await createSubscription({
        userId: form.userId,
        plan: form.plan,
        price: Number(form.price),
        status: form.status,
        durationInDays: Number(form.durationInDays),
      });
      await load();
    } catch (err) {
      setError(err instanceof Error ? err.message : "Create failed");
    }
  };

  return (
    <div className="space-y-6">
      <PageHeader
        title="Subscriptions"
        subtitle="Grant, activate, deactivate, or remove user subscriptions."
      />

      <div className="flex flex-wrap gap-2">
        {["", "active", "inactive", "cancelled", "expired", "pending"].map(
          (value) => (
            <Button
              key={value || "all"}
              variant={status === value ? "primary" : "secondary"}
              className="px-3 py-2 text-xs"
              onClick={() => setStatus(value)}
            >
              {value || "All"}
            </Button>
          )
        )}
      </div>

      <form
        onSubmit={onCreate}
        className="grid gap-3 rounded-2xl border border-border bg-white p-5 md:grid-cols-3"
      >
        <Input
          label="User ID"
          value={form.userId}
          onChange={(e) => setForm({ ...form, userId: e.target.value })}
          required
        />
        <Input
          label="Plan key"
          value={form.plan}
          onChange={(e) => setForm({ ...form, plan: e.target.value })}
          required
        />
        <Input
          label="Price"
          value={form.price}
          onChange={(e) => setForm({ ...form, price: e.target.value })}
          required
        />
        <Input
          label="Duration days"
          value={form.durationInDays}
          onChange={(e) =>
            setForm({ ...form, durationInDays: e.target.value })
          }
        />
        <div className="flex items-end">
          <Button type="submit">Grant subscription</Button>
        </div>
      </form>

      {error ? (
        <div className="rounded-2xl border border-coral/20 bg-coral/10 px-4 py-3 text-sm text-coral">
          {error}
        </div>
      ) : null}

      <div className="overflow-hidden rounded-2xl border border-border bg-white divide-y divide-border">
        {items.map((item) => (
          <div
            key={item._id}
            className="flex flex-col gap-3 px-5 py-4 lg:flex-row lg:items-center lg:justify-between"
          >
            <div>
              <Link
                href={`/subscriptions/${item._id}`}
                className="font-semibold text-ink hover:text-orange"
              >
                {item.user?.fullName || "User"} · {item.plan}
              </Link>
              <p className="mt-1 text-sm text-muted-fg">
                {item.price} ETB · ends {formatDate(item.endDate)}
              </p>
            </div>
            <div className="flex flex-wrap items-center gap-2">
              <Badge
                tone={item.status === "active" ? "success" : "premium"}
              >
                {item.status}
              </Badge>
              {item.status === "active" ? (
                <Button
                  variant="secondary"
                  className="px-3 py-2 text-xs"
                  onClick={async () => {
                    await updateSubscription(item._id, { status: "inactive" });
                    await load();
                  }}
                >
                  Deactivate
                </Button>
              ) : (
                <Button
                  variant="secondary"
                  className="px-3 py-2 text-xs"
                  onClick={async () => {
                    await updateSubscription(item._id, { status: "active" });
                    await load();
                  }}
                >
                  Activate
                </Button>
              )}
              <Button
                variant="danger"
                className="px-3 py-2 text-xs"
                onClick={async () => {
                  try {
                    await deleteSubscription(item._id);
                    await load();
                  } catch (err) {
                    setError(
                      err instanceof Error ? err.message : "Delete blocked"
                    );
                  }
                }}
              >
                Delete
              </Button>
            </div>
          </div>
        ))}
      </div>
    </div>
  );
}
