import type { ReactNode } from "react";
import { AdminShell } from "@/components/layout/admin-shell";

export default function AdminSectionLayout({
  children,
}: {
  children: ReactNode;
}) {
  return <AdminShell>{children}</AdminShell>;
}
