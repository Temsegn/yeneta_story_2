/// Ethiopian mobile phone normalization.
/// Accepts: 9XXXXXXXX, 09XXXXXXXX, 2519XXXXXXXX, +2519XXXXXXXX
/// Canonical form: +2519XXXXXXXX
class EthiopianPhone {
  EthiopianPhone._();

  static const int localLength = 9;
  static const String localPrefix = '9';
  static const String countryCode = '251';

  /// Returns E.164 form (+2519XXXXXXXX) or null if invalid.
  static String? normalizeToE164(String input) {
    var digits = input.replaceAll(RegExp(r'[\s\-().]'), '');
    if (digits.startsWith('+')) digits = digits.substring(1);

    if (digits.startsWith(countryCode)) {
      digits = digits.substring(countryCode.length);
    } else if (digits.startsWith('0')) {
      digits = digits.substring(1);
    }

    if (!RegExp(r'^\d+$').hasMatch(digits)) return null;
    if (digits.length != localLength) return null;
    if (!digits.startsWith(localPrefix)) return null;

    return '+$countryCode$digits';
  }

  static bool isValid(String input) => normalizeToE164(input) != null;

  /// Returns null if valid, otherwise a short error token for l10n mapping.
  static String? validate(String? input) {
    if (input == null || input.trim().isEmpty) return 'required';
    if (normalizeToE164(input) == null) return 'invalid';
    return null;
  }
}
