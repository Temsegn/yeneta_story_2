"use client";

import Link from "next/link";
import { use, useEffect, useState } from "react";
import { fetchUser, updateUser } from "@/lib/api";
import { formatDate } from "@/lib/format";
import type { ManagedUser, PaymentItem, SubscriptionItem } from "@/lib/types";
import { Button } from "@/components/ui/button";
import { Input } from "@/components/ui/input";
import { PageHeader } from "@/components/ui/confirm-dialog";

export default function UserDetailPage({
  params,
}: {
  params: Promise<{ id: string }>;
}) {
  const { id } = use(params);
  const [user, setUser] = useState<ManagedUser | null>(null);
  const [subs, setSubs] = useState<SubscriptionItem[]>([]);
  const [payments, setPayments] = useState<PaymentItem[]>([]);
  const [password, setPassword] = useState("");
  const [securityQuestion, setSecurityQuestion] = useState("");
  const [error, setError] = useState("");
  const [message, setMessage] = useState("");

  const load = async () => {
    try {
      const data = await fetchUser(id);
      setUser(data.user);
      setSubs(data.subscriptions || []);
      setPayments(data.payments || []);
      setSecurityQuestion(data.user.securityQuestion || "");
    } catch (err) {
      setError(err instanceof Error ? err.message : "Failed to load user");
    }
  };

  useEffect(() => {
    void load();
    // eslint-disable-next-line react-hooks/exhaustive-deps
  }, [id]);

  if (error) {
    return (
      <div className="rounded-2xl border border-coral/20 bg-coral/10 px-4 py-3 text-sm text-coral">
        {error}
      </div>
    );
  }

  if (!user) return <p className="text-muted-fg">Loading…</p>;

  return (
    <div className="space-y-6">
      <PageHeader
        title={user.fullName}
        subtitle={`${user.role} · ${user.phoneNumber}`}
        action={
          <Link href="/users">
            <Button variant="secondary">Back</Button>
          </Link>
        }
      />

      {message ? (
        <div className="rounded-2xl border border-green/20 bg-green-soft px-4 py-3 text-sm text-green">
          {message}
        </div>
      ) : null}

      <div className="grid gap-4 rounded-2xl border border-border bg-white p-5 md:grid-cols-2">
        <Input
          label="Full name"
          value={user.fullName}
          onChange={(e) => setUser({ ...user, fullName: e.target.value })}
        />
        <Input
          label="Email"
          value={user.email || ""}
          onChange={(e) => setUser({ ...user, email: e.target.value })}
        />
        <Input
          label="Phone"
          value={user.phoneNumber || ""}
          onChange={(e) => setUser({ ...user, phoneNumber: e.target.value })}
        />
        <label className="block space-y-2">
          <span className="text-sm font-semibold text-ink">Role</span>
          <select
            className="w-full rounded-xl border border-border px-3.5 py-3"
            value={user.role}
            onChange={(e) => setUser({ ...user, role: e.target.value })}
          >
            <option value="parent">Parent (external)</option>
            <option value="admin">Admin</option>
            <option value="finance">Finance</option>
            <option value="content_manager">Content manager</option>
          </select>
        </label>
        <Input
          label="Security question"
          value={securityQuestion}
          onChange={(e) => setSecurityQuestion(e.target.value)}
        />
        <Input
          label="Reset password"
          type="password"
          value={password}
          onChange={(e) => setPassword(e.target.value)}
          hint="Leave blank to keep current password"
        />
        <div className="md:col-span-2">
          <Button
            onClick={async () => {
              try {
                await updateUser(id, {
                  fullName: user.fullName,
                  email: user.email,
                  phoneNumber: user.phoneNumber,
                  role: user.role,
                  securityQuestion,
                  ...(password ? { password } : {}),
                });
                setPassword("");
                setMessage("User updated");
                await load();
              } catch (err) {
                setError(err instanceof Error ? err.message : "Update failed");
              }
            }}
          >
            Save changes
          </Button>
        </div>
      </div>

      <section className="space-y-3">
        <h2 className="text-lg font-bold text-ink">Subscriptions</h2>
        <div className="rounded-2xl border border-border bg-white divide-y divide-border">
          {subs.length === 0 ? (
            <p className="px-4 py-6 text-sm text-muted-fg">No subscriptions</p>
          ) : (
            subs.map((sub) => (
              <div key={sub._id} className="px-4 py-3 text-sm">
                {sub.plan} · {sub.status} · {formatDate(sub.endDate)}
              </div>
            ))
          )}
        </div>
      </section>

      <section className="space-y-3">
        <h2 className="text-lg font-bold text-ink">Payments</h2>
        <div className="rounded-2xl border border-border bg-white divide-y divide-border">
          {payments.length === 0 ? (
            <p className="px-4 py-6 text-sm text-muted-fg">No payments</p>
          ) : (
            payments.map((p) => (
              <div key={p._id} className="px-4 py-3 text-sm">
                {p.amount} ETB · {p.status} · {formatDate(p.createdAt)}
              </div>
            ))
          )}
        </div>
      </section>
    </div>
  );
}
