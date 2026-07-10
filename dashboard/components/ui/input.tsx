import type { InputHTMLAttributes } from "react";

type Props = InputHTMLAttributes<HTMLInputElement> & {
  label: string;
  hint?: string;
};

export function Input({ label, hint, className = "", id, ...props }: Props) {
  const inputId = id || label.toLowerCase().replace(/\s+/g, "-");

  return (
    <label className="block space-y-2" htmlFor={inputId}>
      <span className="text-sm font-semibold text-ink">{label}</span>
      <input
        id={inputId}
        className={`w-full rounded-xl border border-border bg-white px-3.5 py-3 text-ink outline-none transition placeholder:text-muted-fg focus:border-orange focus:ring-4 focus:ring-orange/15 ${className}`}
        {...props}
      />
      {hint ? <span className="block text-xs text-muted-fg">{hint}</span> : null}
    </label>
  );
}
