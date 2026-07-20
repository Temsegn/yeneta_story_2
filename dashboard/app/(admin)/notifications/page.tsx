"use client";

import { FormEvent, useState } from "react";
import { broadcastNotification } from "@/lib/api";
import { Button } from "@/components/ui/button";
import { Input } from "@/components/ui/input";
import { PageHeader } from "@/components/ui/confirm-dialog";

export default function NotificationsPage() {
  const [title, setTitle] = useState("");
  const [message, setMessage] = useState("");
  const [type, setType] = useState("system");
  const [busy, setBusy] = useState(false);
  const [result, setResult] = useState("");
  const [error, setError] = useState("");

  const onSubmit = async (event: FormEvent) => {
    event.preventDefault();
    setBusy(true);
    setError("");
    setResult("");
    try {
      const data = await broadcastNotification({ title, message, type });
      setResult(
        `Sent to ${data.created} users` +
          (data.pushed ? ` · ${data.pushed} device pushes delivered` : "")
      );
      setTitle("");
      setMessage("");
    } catch (err) {
      setError(err instanceof Error ? err.message : "Broadcast failed");
    } finally {
      setBusy(false);
    }
  };

  return (
    <div className="space-y-6">
      <PageHeader
        title="Release notification"
        subtitle="Broadcast in-app + push alerts to all parents. New videos, stories, books, and education also notify automatically when published."
      />

      <form
        onSubmit={onSubmit}
        className="max-w-2xl space-y-4 rounded-2xl border border-border bg-white p-6"
      >
        {error ? (
          <div className="rounded-xl border border-coral/20 bg-coral/10 px-4 py-3 text-sm text-coral">
            {error}
          </div>
        ) : null}
        {result ? (
          <div className="rounded-xl border border-green/20 bg-green/10 px-4 py-3 text-sm text-ink">
            {result}
          </div>
        ) : null}

        <Input
          label="Title"
          value={title}
          onChange={(e) => setTitle(e.target.value)}
          required
          placeholder="New story available"
        />
        <label className="block space-y-2">
          <span className="text-sm font-semibold text-ink">Message</span>
          <textarea
            className="min-h-28 w-full rounded-xl border border-border bg-white px-3.5 py-3 outline-none focus:border-orange focus:ring-4 focus:ring-orange/15"
            value={message}
            onChange={(e) => setMessage(e.target.value)}
            required
            placeholder="Check out the latest Yeneta adventure…"
          />
        </label>
        <label className="block space-y-2">
          <span className="text-sm font-semibold text-ink">Type</span>
          <select
            className="w-full rounded-xl border border-border bg-white px-3.5 py-3"
            value={type}
            onChange={(e) => setType(e.target.value)}
          >
            <option value="system">System</option>
            <option value="content">Content</option>
            <option value="subscription">Subscription</option>
            <option value="payment">Payment</option>
          </select>
        </label>
        <Button type="submit" disabled={busy}>
          {busy ? "Releasing…" : "Release notification"}
        </Button>
      </form>
    </div>
  );
}
