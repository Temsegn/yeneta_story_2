"use client";

import Link from "next/link";
import { use, useEffect, useState } from "react";
import { fetchPayment } from "@/lib/api";
import { formatDate } from "@/lib/format";
import type { PaymentItem } from "@/lib/types";
import { Button } from "@/components/ui/button";
import { PageHeader } from "@/components/ui/confirm-dialog";

export default function TransactionDetailPage({
  params,
}: {
  params: Promise<{ id: string }>;
}) {
  const { id } = use(params);
  const [item, setItem] = useState<PaymentItem | null>(null);
  const [error, setError] = useState("");

  useEffect(() => {
    (async () => {
      try {
        setItem(await fetchPayment(id));
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
        title={`Payment ${item.amount} ETB`}
        subtitle={item.userId?.fullName || item._id}
        action={
          <Link href="/transactions">
            <Button variant="secondary">Back</Button>
          </Link>
        }
      />
      <div className="rounded-2xl border border-border bg-white p-5 space-y-2 text-sm">
        <p>Status: <strong>{item.status}</strong></p>
        <p>Method: {item.paymentMethod || "—"}</p>
        <p>Tx ref: {item.txRef || "—"}</p>
        <p>Transaction ID: {item.transactionId || "—"}</p>
        <p>Chapa ref: {item.chapaReference || "—"}</p>
        <p>Phone: {item.userId?.phoneNumber || "—"}</p>
        <p>Created: {formatDate(item.createdAt)}</p>
      </div>
    </div>
  );
}
