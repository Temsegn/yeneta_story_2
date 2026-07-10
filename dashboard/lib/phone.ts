/** Normalize Ethiopian mobile input for the Yeneta auth API. */
export function normalizeEthiopianPhone(input: string): string {
  const digits = input.replace(/\D/g, "");

  if (digits.startsWith("251") && digits.length === 12) {
    return `+${digits}`;
  }
  if (digits.startsWith("0") && digits.length === 10) {
    return `+251${digits.slice(1)}`;
  }
  if (digits.length === 9 && digits.startsWith("9")) {
    return `+251${digits}`;
  }
  if (input.trim().startsWith("+") && digits.startsWith("251")) {
    return `+${digits}`;
  }

  return input.trim();
}
