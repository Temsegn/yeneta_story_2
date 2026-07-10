"use client";

import { FormEvent, useEffect, useState } from "react";
import {
  createPlan,
  deletePlan,
  fetchPlans,
  updatePlan,
} from "@/lib/api";
import type { SubscriptionPlan } from "@/lib/types";
import { Button } from "@/components/ui/button";
import { Input } from "@/components/ui/input";
import { PageHeader, StatusToggle } from "@/components/ui/confirm-dialog";

export default function PlansPage() {
  const [plans, setPlans] = useState<SubscriptionPlan[]>([]);
  const [error, setError] = useState("");
  const [form, setForm] = useState({
    key: "premium_monthly",
    name: "",
    description: "",
    price: "499",
    durationInDays: "30",
  });

  const load = async () => {
    try {
      const data = await fetchPlans();
      setPlans(data.plans || []);
    } catch (err) {
      setError(err instanceof Error ? err.message : "Failed to load plans");
    }
  };

  useEffect(() => {
    void load();
  }, []);

  const onCreate = async (event: FormEvent) => {
    event.preventDefault();
    setError("");
    try {
      await createPlan({
        key: form.key,
        name: form.name,
        description: form.description,
        price: Number(form.price),
        durationInDays: Number(form.durationInDays),
        isVisible: true,
      });
      setForm({
        key: "premium_yearly",
        name: "",
        description: "",
        price: "4999",
        durationInDays: "365",
      });
      await load();
    } catch (err) {
      setError(err instanceof Error ? err.message : "Create failed");
    }
  };

  return (
    <div className="space-y-6">
      <PageHeader
        title="Subscription plans"
        subtitle="Activate/deactivate visibility. Delete only when no active subscribers."
      />

      {error ? (
        <div className="rounded-2xl border border-coral/20 bg-coral/10 px-4 py-3 text-sm text-coral">
          {error}
        </div>
      ) : null}

      <form
        onSubmit={onCreate}
        className="grid gap-3 rounded-2xl border border-border bg-white p-5 md:grid-cols-2"
      >
        <label className="block space-y-2">
          <span className="text-sm font-semibold text-ink">Plan key</span>
          <select
            className="w-full rounded-xl border border-border px-3.5 py-3"
            value={form.key}
            onChange={(e) => setForm({ ...form, key: e.target.value })}
          >
            <option value="premium_monthly">premium_monthly</option>
            <option value="premium_yearly">premium_yearly</option>
            <option value="monthly">monthly</option>
            <option value="yearly">yearly</option>
            <option value="semiannual">semiannual</option>
          </select>
        </label>
        <Input
          label="Name"
          value={form.name}
          onChange={(e) => setForm({ ...form, name: e.target.value })}
          required
        />
        <Input
          label="Price (ETB)"
          value={form.price}
          onChange={(e) => setForm({ ...form, price: e.target.value })}
          required
        />
        <Input
          label="Duration (days)"
          value={form.durationInDays}
          onChange={(e) => setForm({ ...form, durationInDays: e.target.value })}
          required
        />
        <Input
          label="Description"
          value={form.description}
          onChange={(e) => setForm({ ...form, description: e.target.value })}
        />
        <div className="flex items-end">
          <Button type="submit">Add plan</Button>
        </div>
      </form>

      <div className="overflow-hidden rounded-2xl border border-border bg-white divide-y divide-border">
        {plans.map((plan) => (
          <div
            key={plan._id}
            className="flex flex-col gap-3 px-5 py-4 sm:flex-row sm:items-center sm:justify-between"
          >
            <div>
              <p className="font-semibold text-ink">
                {plan.name}{" "}
                <span className="text-xs text-muted-fg">({plan.key})</span>
              </p>
              <p className="mt-1 text-sm text-muted-fg">
                {plan.price} ETB · {plan.durationInDays} days
              </p>
            </div>
            <div className="flex flex-wrap items-center gap-2">
              <StatusToggle
                checked={plan.isVisible}
                label={plan.isVisible ? "Visible" : "Hidden"}
                onChange={async (next) => {
                  await updatePlan(plan._id, { isVisible: next });
                  await load();
                }}
              />
              <Button
                variant="danger"
                className="px-3 py-2 text-xs"
                onClick={async () => {
                  try {
                    await deletePlan(plan._id);
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
