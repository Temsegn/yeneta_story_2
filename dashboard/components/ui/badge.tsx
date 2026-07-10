export function Badge({
  children,
  tone = "neutral",
}: {
  children: string;
  tone?: "neutral" | "success" | "warn" | "premium";
}) {
  const tones = {
    neutral: "bg-muted text-muted-fg",
    success: "bg-green-soft text-green",
    warn: "bg-orange/10 text-orange-deep",
    premium: "bg-ink text-white",
  };

  return (
    <span
      className={`inline-flex items-center rounded-full px-2.5 py-1 text-xs font-semibold ${tones[tone]}`}
    >
      {children}
    </span>
  );
}
