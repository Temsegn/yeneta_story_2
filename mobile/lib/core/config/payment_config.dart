/// Chapa payment return URL — must match backend `CHAPA_RETURN_URL`.
class PaymentConfig {
  PaymentConfig._();

  static const String returnScheme = 'myapp';
  static const String returnHost = 'payment-result';

  /// Deep link used by the native app after the HTTPS return page.
  static const String chapaReturnUrl = '$returnScheme://$returnHost';

  static const String chapaReturnUrlSuccess =
      '$chapaReturnUrl?status=success';

  /// Backend HTTPS return page (what Chapa actually redirects to).
  static const String httpsReturnPath = '/api/v1/payments/chapa/return';

  static bool isReturnUrl(String url) {
    final lower = url.toLowerCase();
    if (lower.startsWith('$returnScheme://')) return true;
    if (lower.contains(httpsReturnPath)) return true;
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
