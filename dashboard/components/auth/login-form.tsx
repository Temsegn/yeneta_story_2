"use client";

import { FormEvent, useEffect, useState } from "react";
import { useRouter } from "next/navigation";
import { loginAdmin } from "@/lib/api";
import { getAccessToken, getStoredUser, saveSession } from "@/lib/auth";
import { normalizeEthiopianPhone } from "@/lib/phone";
import { isInternalRole, type AdminUser } from "@/lib/types";
import { Button } from "@/components/ui/button";
import { Input } from "@/components/ui/input";

export function LoginForm() {
  const router = useRouter();
  const [phoneNumber, setPhoneNumber] = useState("");
  const [password, setPassword] = useState("");
  const [error, setError] = useState("");
  const [loading, setLoading] = useState(false);

  useEffect(() => {
    const token = getAccessToken();
    const user = getStoredUser();
    if (token && isInternalRole(user?.role)) {
      router.replace("/dashboard");
    }
  }, [router]);

  const onSubmit = async (event: FormEvent) => {
    event.preventDefault();
    setError("");
    setLoading(true);

    try {
      const data = await loginAdmin(
        normalizeEthiopianPhone(phoneNumber),
        password
      );
      const user = data.user as AdminUser;

      if (!isInternalRole(user.role)) {
        throw new Error("Access denied. Yeneta staff account required.");
      }

      saveSession(user);
      router.replace("/dashboard");
    } catch (err) {
      setError(err instanceof Error ? err.message : "Unable to sign in");
    } finally {
      setLoading(false);
    }
  };

  return (
    <form onSubmit={onSubmit} className="space-y-5">
      {error ? (
        <div className="rounded-xl border border-coral/20 bg-coral/10 px-4 py-3 text-sm font-medium text-coral">
          {error}
        </div>
      ) : null}

      <Input
        label="Phone number"
        hint="Use 09…, 9…, 251…, or +251…"
        placeholder="0911234567"
        value={phoneNumber}
        onChange={(e) => setPhoneNumber(e.target.value)}
        required
      />
      <Input
        label="Password"
        type="password"
        placeholder="••••••••"
        value={password}
        onChange={(e) => setPassword(e.target.value)}
        required
      />

      <Button type="submit" className="w-full py-3" disabled={loading}>
        {loading ? "Signing in…" : "Enter studio"}
      </Button>
    </form>
  );
}
