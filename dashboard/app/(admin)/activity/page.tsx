"use client";

import { useEffect, useState } from "react";
import { fetchAuditLogs } from "@/lib/api";
import { formatDate } from "@/lib/format";
import type { AuditLogItem } from "@/lib/types";
import { EmptyState } from "@/components/ui/empty-state";
import { Topbar } from "@/components/layout/topbar";

function normalizeLogs(payload: unknown): AuditLogItem[] {
  if (Array.isArray(payload)) return payload as AuditLogItem[];
  if (
    payload &&
    typeof payload === "object" &&
    Array.isArray((payload as { logs?: unknown }).logs)
  ) {
    return (payload as { logs: AuditLogItem[] }).logs;
  }
  return [];
}

export default function ActivityPage() {
  const [logs, setLogs] = useState<AuditLogItem[]>([]);
  const [loading, setLoading] = useState(true);
  const [error, setError] = useState("");

  useEffect(() => {
    let alive = true;
    (async () => {
      try {
        const data = await fetchAuditLogs();
        if (!alive) return;
        setLogs(normalizeLogs(data));
      } catch (err) {
        if (!alive) return;
        setError(err instanceof Error ? err.message : "Failed to load activity");
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
        title="Activity"
        subtitle="Recent admin and system actions from the audit log."
      />

      {error ? (
        <div className="rounded-2xl border border-coral/20 bg-coral/10 px-4 py-3 text-sm text-coral">
          {error}
        </div>
      ) : null}

      {loading ? (
        <div className="rounded-2xl border border-border bg-white px-5 py-10 text-center text-muted-fg">
          Loading activity…
        </div>
      ) : logs.length === 0 ? (
        <EmptyState
          title="No activity yet"
          description="Audit events will show here after admin actions."
        />
      ) : (
        <div className="overflow-hidden rounded-2xl border border-border bg-white">
          <div className="divide-y divide-border">
            {logs.map((log) => (
              <div
                key={log._id}
                className="flex flex-col gap-2 px-5 py-4 sm:flex-row sm:items-center sm:justify-between"
              >
                <div>
                  <p className="font-semibold text-ink">
                    {log.action || "Action"}
                  </p>
                  <p className="mt-1 text-sm text-muted-fg">
                    {log.targetModel || "System"}
                    {log.user?.fullName ? ` · ${log.user.fullName}` : ""}
                  </p>
                </div>
                <p className="text-sm text-muted-fg">
                  {formatDate(log.createdAt)}
                </p>
              </div>
            ))}
          </div>
        </div>
      )}
    </div>
  );
}
