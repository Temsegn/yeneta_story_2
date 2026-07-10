"use client";

import type { ReactNode } from "react";

export function Topbar({
  title,
  subtitle,
  action,
}: {
  title: string;
  subtitle?: string;
  action?: ReactNode;
}) {
  return (
    <div className="mb-6 flex flex-wrap items-end justify-between gap-4">
      <div>
        <p className="text-xs font-bold uppercase tracking-[0.18em] text-orange">
          Yeneta Studio
        </p>
        <h1 className="mt-1 text-3xl font-black tracking-tight text-ink">
          {title}
        </h1>
        {subtitle ? (
          <p className="mt-1 max-w-2xl text-sm text-muted-fg">{subtitle}</p>
        ) : null}
      </div>
      {action}
    </div>
  );
}
