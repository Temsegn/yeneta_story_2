"use client";

import Link from "next/link";
import { usePathname, useRouter } from "next/navigation";
import { clearSession, getStoredUser } from "@/lib/auth";
import { isInternalRole } from "@/lib/types";
import { Button } from "@/components/ui/button";

const links = [
  { href: "/dashboard", label: "Overview" },
  { href: "/videos", label: "Videos" },
  { href: "/stories", label: "Stories" },
  { href: "/books", label: "Books" },
  { href: "/education", label: "Education" },
  { href: "/users", label: "Users" },
  { href: "/plans", label: "Plans" },
  { href: "/subscriptions", label: "Subscriptions" },
  { href: "/transactions", label: "Transactions" },
  { href: "/notifications", label: "Notifications" },
  { href: "/activity", label: "Audit logs" },
];

export function Sidebar({ compact = false }: { compact?: boolean }) {
  const pathname = usePathname();
  const router = useRouter();
  const user = getStoredUser();

  const logout = () => {
    clearSession();
    router.replace("/login");
  };

  if (compact) {
    return (
      <div className="flex items-center gap-2 overflow-x-auto">
        <span className="mr-2 shrink-0 text-sm font-black text-ink">Yeneta</span>
        {links.map((link) => {
          const active =
            pathname === link.href || pathname.startsWith(`${link.href}/`);
          return (
            <Link
              key={link.href}
              href={link.href}
              className={`shrink-0 rounded-full px-3 py-1.5 text-xs font-semibold ${
                active
                  ? "bg-orange text-white"
                  : "bg-muted text-muted-fg hover:text-ink"
              }`}
            >
              {link.label}
            </Link>
          );
        })}
      </div>
    );
  }

  return (
    <aside className="flex h-full w-[260px] flex-col bg-sidebar text-sidebar-fg">
      <div className="border-b border-white/10 px-5 py-6">
        <div className="flex items-center gap-3">
          <div className="flex h-11 w-11 items-center justify-center rounded-2xl bg-gradient-to-br from-orange to-green text-lg font-black text-white">
            Y
          </div>
          <div>
            <p className="text-lg font-black tracking-tight">Yeneta Admin</p>
            <p className="text-xs text-sidebar-muted">Production studio</p>
          </div>
        </div>
      </div>

      <nav className="flex-1 space-y-1 overflow-y-auto px-3 py-4">
        {links.map((link) => {
          const active =
            pathname === link.href || pathname.startsWith(`${link.href}/`);
          return (
            <Link
              key={link.href}
              href={link.href}
              className={`flex items-center rounded-xl px-3 py-2.5 text-sm font-semibold transition ${
                active
                  ? "bg-white/12 text-white shadow-inner"
                  : "text-sidebar-muted hover:bg-white/8 hover:text-white"
              }`}
            >
              {link.label}
            </Link>
          );
        })}
      </nav>

      <div className="border-t border-white/10 p-4">
        <div className="mb-3 rounded-xl bg-white/8 px-3 py-3">
          <p className="text-sm font-semibold">{user?.fullName || "Staff"}</p>
          <p className="mt-1 truncate text-xs text-sidebar-muted">
            {user?.role || "internal"}
            {isInternalRole(user?.role) ? " · internal" : ""}
          </p>
          <p className="mt-1 truncate text-xs text-sidebar-muted">
            {user?.phoneNumber || user?.email || "Signed in"}
          </p>
        </div>
        <Button variant="ghost" className="w-full" onClick={logout}>
          Sign out
        </Button>
      </div>
    </aside>
  );
}
