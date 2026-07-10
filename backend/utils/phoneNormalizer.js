/**
 * Ethiopian mobile phone normalization.
 * Accepts: 9XXXXXXXX, 09XXXXXXXX, 2519XXXXXXXX, +2519XXXXXXXX
 * Canonical storage: +2519XXXXXXXX (12 digits after +)
 */

const LOCAL_LENGTH = 9;
const LOCAL_PREFIX = "9";
const COUNTRY_CODE = "251";

/**
 * @param {string} input
 * @returns {string|null} E.164 form +2519XXXXXXXX or null if invalid
 */
export function normalizeEthiopianPhone(input) {
  if (!input || typeof input !== "string") return null;

  let digits = input.replace(/[\s\-().]/g, "");
  if (digits.startsWith("+")) digits = digits.slice(1);

  if (digits.startsWith(COUNTRY_CODE)) {
    digits = digits.slice(COUNTRY_CODE.length);
  } else if (digits.startsWith("0")) {
    digits = digits.slice(1);
  }

  if (!/^\d+$/.test(digits)) return null;
  if (digits.length !== LOCAL_LENGTH) return null;
  if (!digits.startsWith(LOCAL_PREFIX)) return null;

  return `+${COUNTRY_CODE}${digits}`;
}

/**
 * Chapa requires 10-digit local format: 09XXXXXXXX (not +251…).
 * @param {string} input
 * @returns {string|null}
 */
export function toChapaPhone(input) {
  const e164 = normalizeEthiopianPhone(input);
  if (!e164) return null;
  return `0${e164.slice(4)}`; // +2519… → 09…
}

/**
 * @param {string} input
 * @returns {boolean}
 */
export function isValidEthiopianPhone(input) {
  return normalizeEthiopianPhone(input) !== null;
}

/**
 * @param {string} input
 * @returns {string}
 */
export function assertEthiopianPhone(input) {
  const normalized = normalizeEthiopianPhone(input);
  if (!normalized) {
    throw new Error(
      "Invalid phone number. Use 9 digits starting with 9 (e.g. 0912345678 or +251912345678)."
    );
  }
  return normalized;
}
