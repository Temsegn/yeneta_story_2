/// Chapa payment return URL — must match backend `FRONTEND_URL` / `CHAPA_RETURN_URL`.
class PaymentConfig {
  PaymentConfig._();

  static const String returnScheme = 'myapp';
  static const String returnHost = 'payment-result';

  /// Deep link Chapa redirects to after checkout (also sent via backend env).
  static const String chapaReturnUrl = '$returnScheme://$returnHost';

  /// Return URL with success hint for Chapa `return_url` field.
  static const String chapaReturnUrlSuccess =
      '$chapaReturnUrl?status=success';

  static bool isReturnUrl(String url) {
    final lower = url.toLowerCase();
    if (lower.startsWith('$returnScheme://')) return true;
    return lower.contains('payment-result') ||
        lower.contains('payment-return') ||
        lower.contains('payment-callback');
  }

  /// `success` | `failed` | `cancelled` | `unknown`
  static String statusFromReturnUrl(String url) {
    final lower = url.toLowerCase();
    final uri = Uri.tryParse(url);
    final queryStatus = uri?.queryParameters['status']?.toLowerCase();

    if (queryStatus == 'success' || queryStatus == 'successful') {
      return 'success';
    }
    if (queryStatus == 'failed' ||
        queryStatus == 'fail' ||
        queryStatus == 'cancelled' ||
        queryStatus == 'canceled') {
      return 'failed';
    }

    if (lower.contains('success') ||
        lower.contains('status=success') ||
        lower.contains('paid')) {
      return 'success';
    }

    if (lower.contains('fail') ||
        lower.contains('cancel') ||
        lower.contains('error')) {
      return 'failed';
    }

    return 'unknown';
  }
}
