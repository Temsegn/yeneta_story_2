export function formatDate(value?: string) {
  if (!value) return "—";
  const date = new Date(value);
  if (Number.isNaN(date.getTime())) return "—";
  return date.toLocaleDateString(undefined, {
    year: "numeric",
    month: "short",
    day: "numeric",
  });
}

export function formatCount(value: number) {
  return new Intl.NumberFormat().format(value);
}

export function truncate(text: string | undefined, max = 80) {
  if (!text) return "No description";
  if (text.length <= max) return text;
  return `${text.slice(0, max).trim()}…`;
}
