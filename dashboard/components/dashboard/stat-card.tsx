import { formatCount } from "@/lib/format";
import { Card } from "@/components/ui/card";

export function StatCard({
  label,
  value,
  hint,
  accent,
}: {
  label: string;
  value: number;
  hint: string;
  accent: "orange" | "green" | "coral" | "ink";
}) {
  const accents = {
    orange: "from-orange/20 to-orange/5 text-orange-deep",
    green: "from-green/20 to-green/5 text-green",
    coral: "from-coral/20 to-coral/5 text-coral",
    ink: "from-ink/15 to-ink/5 text-ink",
  };

  return (
    <Card className="overflow-hidden p-5">
      <div
        className={`mb-4 inline-flex rounded-xl bg-gradient-to-br px-3 py-2 text-xs font-bold uppercase tracking-wide ${accents[accent]}`}
      >
        {label}
      </div>
      <p className="text-4xl font-black tracking-tight text-ink">
        {formatCount(value)}
      </p>
      <p className="mt-2 text-sm text-muted-fg">{hint}</p>
    </Card>
  );
}
