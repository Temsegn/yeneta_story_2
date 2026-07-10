import {
  normalizeEthiopianPhone,
  isValidEthiopianPhone,
  toChapaPhone,
} from "../utils/phoneNormalizer.js";

describe("phoneNormalizer", () => {
  it.each([
    ["0912345678", "+251912345678"],
    ["912345678", "+251912345678"],
    ["251912345678", "+251912345678"],
    ["+251912345678", "+251912345678"],
    ["+251 91 234 5678", "+251912345678"],
    ["09-123-45678", "+251912345678"],
  ])("normalizes %s to %s", (input, expected) => {
    expect(normalizeEthiopianPhone(input)).toBe(expected);
  });

  it("converts to Chapa 09 format", () => {
    expect(toChapaPhone("+251912345678")).toBe("0912345678");
    expect(toChapaPhone("912345678")).toBe("0912345678");
  });

  it.each(["12345", "0812345678", "91234567", "9123456789", "", null])(
    "rejects invalid input %s",
    (input) => {
      expect(isValidEthiopianPhone(input)).toBe(false);
    }
  );
});
