"use client";

import Link from "next/link";
import { FormEvent, useEffect, useState } from "react";
import {
  createUser,
  deleteUser,
  fetchUsers,
  updateUser,
} from "@/lib/api";
import { formatDate } from "@/lib/format";
import type { ManagedUser } from "@/lib/types";
import { Badge } from "@/components/ui/badge";
import { Button } from "@/components/ui/button";
import { Input } from "@/components/ui/input";
import { PageHeader } from "@/components/ui/confirm-dialog";

export default function UsersPage() {
  const [tab, setTab] = useState<"external" | "internal">("external");
  const [users, setUsers] = useState<ManagedUser[]>([]);
  const [error, setError] = useState("");
  const [loading, setLoading] = useState(true);
  const [showCreate, setShowCreate] = useState(false);
  const [form, setForm] = useState({
    fullName: "",
    phoneNumber: "",
    password: "",
    email: "",
    role: "parent",
    securityQuestion: "",
  });

  const load = async () => {
    setLoading(true);
    setError("");
    try {
      const data = await fetchUsers({
        page: "1",
        limit: "100",
        userType: tab === "external" ? "external" : "internal",
      });
      setUsers(data.users || []);
    } catch (err) {
      setError(err instanceof Error ? err.message : "Failed to load users");
    } finally {
      setLoading(false);
    }
  };

  useEffect(() => {
    void load();
    // eslint-disable-next-line react-hooks/exhaustive-deps
  }, [tab]);

  const onCreate = async (event: FormEvent) => {
    event.preventDefault();
    try {
      await createUser({
        ...form,
        role: tab === "external" ? "parent" : form.role,
      });
      setShowCreate(false);
      setForm({
        fullName: "",
        phoneNumber: "",
        password: "",
        email: "",
        role: tab === "external" ? "parent" : "content_manager",
        securityQuestion: "",
      });
      await load();
    } catch (err) {
      setError(err instanceof Error ? err.message : "Create failed");
    }
  };

  return (
    <div className="space-y-6">
      <PageHeader
        title="Users"
        subtitle="External clients (parents) and internal Yeneta staff."
        action={
          <Button onClick={() => setShowCreate((v) => !v)}>
            {showCreate ? "Close form" : "Add user"}
          </Button>
        }
      />

      <div className="flex gap-2">
        <Button
          variant={tab === "external" ? "primary" : "secondary"}
          onClick={() => setTab("external")}
        >
          External clients
        </Button>
        <Button
          variant={tab === "internal" ? "primary" : "secondary"}
          onClick={() => setTab("internal")}
        >
          Internal staff
        </Button>
      </div>

      {showCreate ? (
        <form
          onSubmit={onCreate}
          className="grid gap-3 rounded-2xl border border-border bg-white p-5 md:grid-cols-2"
        >
          <Input
            label="Full name"
            value={form.fullName}
            onChange={(e) => setForm({ ...form, fullName: e.target.value })}
            required
          />
          <Input
            label="Phone"
            value={form.phoneNumber}
            onChange={(e) => setForm({ ...form, phoneNumber: e.target.value })}
            required
          />
          <Input
            label="Password"
            type="password"
            value={form.password}
            onChange={(e) => setForm({ ...form, password: e.target.value })}
            required
          />
          <Input
            label="Email (optional)"
            value={form.email}
            onChange={(e) => setForm({ ...form, email: e.target.value })}
          />
          {tab === "internal" ? (
            <label className="block space-y-2">
              <span className="text-sm font-semibold text-ink">Role</span>
              <select
                className="w-full rounded-xl border border-border px-3.5 py-3"
                value={form.role}
                onChange={(e) => setForm({ ...form, role: e.target.value })}
              >
                <option value="admin">Admin</option>
                <option value="finance">Finance</option>
                <option value="content_manager">Content manager</option>
              </select>
            </label>
          ) : null}
          <Input
            label="Security question"
            value={form.securityQuestion}
            onChange={(e) =>
              setForm({ ...form, securityQuestion: e.target.value })
            }
          />
          <div className="md:col-span-2">
            <Button type="submit">Create user</Button>
          </div>
        </form>
      ) : null}

      {error ? (
        <div className="rounded-2xl border border-coral/20 bg-coral/10 px-4 py-3 text-sm text-coral">
          {error}
        </div>
      ) : null}

      {loading ? (
        <p className="text-muted-fg">Loading users…</p>
      ) : (
        <div className="overflow-hidden rounded-2xl border border-border bg-white">
          <div className="divide-y divide-border">
            {users.map((user) => (
              <div
                key={user._id}
                className="flex flex-col gap-3 px-5 py-4 sm:flex-row sm:items-center sm:justify-between"
              >
                <div>
                  <Link
                    href={`/users/${user._id}`}
                    className="font-semibold text-ink hover:text-orange"
                  >
                    {user.fullName}
                  </Link>
                  <p className="mt-1 text-sm text-muted-fg">
                    {user.phoneNumber} · {user.role} · {formatDate(user.createdAt)}
                  </p>
                </div>
                <div className="flex flex-wrap items-center gap-2">
                  <Badge tone={user.isActive === false ? "premium" : "success"}>
                    {user.isActive === false ? "Inactive" : "Active"}
                  </Badge>
                  <Button
                    variant="secondary"
                    className="px-3 py-2 text-xs"
                    onClick={async () => {
                      await updateUser(user._id, {
                        isActive: user.isActive === false,
                      });
                      await load();
                    }}
                  >
                    {user.isActive === false ? "Activate" : "Deactivate"}
                  </Button>
                  <Button
                    variant="danger"
                    className="px-3 py-2 text-xs"
                    onClick={async () => {
                      if (!window.confirm("Deactivate this user?")) return;
                      await deleteUser(user._id);
                      await load();
                    }}
                  >
                    Soft delete
                  </Button>
                </div>
              </div>
            ))}
          </div>
        </div>
      )}
    </div>
  );
}
