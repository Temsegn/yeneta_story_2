"use client";

import Link from "next/link";
import { useEffect, useState } from "react";
import { fetchPayments } from "@/lib/api";
import { formatDate } from "@/lib/format";
import type { PaymentItem } from "@/lib/types";
import { Badge } from "@/components/ui/badge";
import { Button } from "@/components/ui/button";
import { PageHeader } from "@/components/ui/confirm-dialog";

export default function TransactionsPage() {
  const [items, setItems] = useState<PaymentItem[]>([]);
  const [status, setStatus] = useState("");
  const [error, setError] = useState("");

  useEffect(() => {
    (async () => {
      try {
        const data = await fetchPayments({
          page: "1",
          limit: "100",
          ...(status ? { status } : {}),
        });
        setItems(data.payments || []);
      } catch (err) {
        setError(err instanceof Error ? err.message : "Failed to load");
      }
    })();
  }, [status]);

  return (
    <div className="space-y-6">
      <PageHeader
        title="Transactions"
        subtitle="Payment history from Chapa and other methods (read-only)."
      />

      <div className="flex flex-wrap gap-2">
        {["", "completed", "pending", "failed"].map((value) => (
          <Button
            key={value || "all"}
            variant={status === value ? "primary" : "secondary"}
            className="px-3 py-2 text-xs"
            onClick={() => setStatus(value)}
          >
            {value || "All"}
          </Button>
        ))}
      </div>

      {error ? (
        <div className="rounded-2xl border border-coral/20 bg-coral/10 px-4 py-3 text-sm text-coral">
          {error}
        </div>
      ) : null}

      <div className="overflow-hidden rounded-2xl border border-border bg-white divide-y divide-border">
        {items.map((item) => (
          <div
            key={item._id}
            className="flex flex-col gap-2 px-5 py-4 sm:flex-row sm:items-center sm:justify-between"
          >
            <div>
              <Link
                href={`/transactions/${item._id}`}
                className="font-semibold text-ink hover:text-orange"
              >
                {item.userId?.fullName || "User"} · {item.amount} ETB
              </Link>
              <p className="mt-1 text-sm text-muted-fg">
                {item.paymentMethod || "payment"} · {item.txRef || item.transactionId || "—"} ·{" "}
                {formatDate(item.createdAt)}
              </p>
            </div>
            <Badge tone={item.status === "completed" ? "success" : "premium"}>
              {item.status}
            </Badge>
          </div>
        ))}
      </div>
    </div>
  );
}
