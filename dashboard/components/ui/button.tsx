import type { ButtonHTMLAttributes, ReactNode } from "react";

type Variant = "primary" | "secondary" | "ghost" | "danger";

const styles: Record<Variant, string> = {
  primary:
    "bg-gradient-to-r from-orange to-orange-deep text-white shadow-[0_10px_24px_rgba(249,115,22,0.28)] hover:brightness-105",
  secondary:
    "bg-white text-ink border border-border hover:border-orange/40 hover:bg-orange/5",
  ghost: "bg-transparent text-sidebar-muted hover:bg-white/10 hover:text-white",
  danger: "bg-coral text-white hover:brightness-110",
};

type Props = ButtonHTMLAttributes<HTMLButtonElement> & {
  variant?: Variant;
  children: ReactNode;
};

export function Button({
  variant = "primary",
  className = "",
  children,
  ...props
}: Props) {
  return (
    <button
      className={`inline-flex items-center justify-center gap-2 rounded-xl px-4 py-2.5 text-sm font-semibold transition disabled:cursor-not-allowed disabled:opacity-55 ${styles[variant]} ${className}`}
      {...props}
    >
      {children}
    </button>
  );
}
