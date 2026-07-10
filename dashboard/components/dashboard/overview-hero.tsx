"use client";

import { getStoredUser } from "@/lib/auth";
import { Card } from "@/components/ui/card";

export function OverviewHero() {
  const user = getStoredUser();

  return (
    <Card className="overflow-hidden border-0 bg-gradient-to-br from-[#123526] via-[#1b4d36] to-[#f97316] p-6 text-white shadow-[0_20px_50px_rgba(15,31,23,0.28)] sm:p-8">
      <div className="max-w-2xl">
        <p className="text-sm font-semibold uppercase tracking-[0.2em] text-white/70">
          Welcome back
        </p>
        <h2 className="mt-2 text-3xl font-black tracking-tight sm:text-4xl">
          {user?.fullName ? `${user.fullName},` : "Admin,"} keep Yeneta Story
          magical.
        </h2>
        <p className="mt-3 text-sm leading-6 text-white/80 sm:text-base">
          Monitor videos, stories, and books from one calm studio. Content
          counts refresh from your live API.
        </p>
      </div>
    </Card>
  );
}
