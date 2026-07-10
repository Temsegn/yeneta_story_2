import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:kids_app/core/config/payment_config.dart';

/// Opens Chapa checkout in an in-app WebView, then returns to the app
/// when Chapa redirects to our HTTPS return page or `myapp://` deep link.
///
/// Pops with: `success` | `failed` | `cancelled` | `expired`
class ChapaCheckoutScreen extends StatefulWidget {
  final String checkoutUrl;
  final String txRef;

  const ChapaCheckoutScreen({
    super.key,
    required this.checkoutUrl,
    required this.txRef,
  });

  @override
  State<ChapaCheckoutScreen> createState() => _ChapaCheckoutScreenState();
}

class _ChapaCheckoutScreenState extends State<ChapaCheckoutScreen> {
  double _progress = 0;
  bool _finished = false;
  bool _sessionExpired = false;
  InAppWebViewController? _webViewController;

  void _finish(String status) {
    if (_finished || !mounted) return;
    _finished = true;
    Navigator.of(context).pop(status);
  }

  void _handleUrl(String? url) {
    if (url == null || url.isEmpty || _finished) return;

    debugPrint('Chapa WebView URL: $url');

    if (!PaymentConfig.isReturnUrl(url)) return;

    final status = PaymentConfig.statusFromReturnUrl(url);
    // Prefer explicit failed; otherwise treat return as success and verify
    // with the backend using txRef on the subscription screen.
    if (status == 'failed') {
      _finish('failed');
      return;
    }
    _finish('success');
  }

  void _markExpired() {
    if (_finished || !mounted) return;
    setState(() => _sessionExpired = true);
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, _) {
        if (!didPop) _finish('cancelled');
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Complete Payment'),
          backgroundColor: const Color(0xFF6B4CE6),
          foregroundColor: Colors.white,
          leading: IconButton(
            icon: const Icon(Icons.close),
            onPressed: () => _finish('cancelled'),
          ),
          actions: [
            if (!_sessionExpired)
              IconButton(
                icon: const Icon(Icons.refresh),
                tooltip: 'Reload checkout',
                onPressed: () => _webViewController?.reload(),
              ),
          ],
        ),
        body: Stack(
          children: [
            if (!_sessionExpired)
              InAppWebView(
                initialUrlRequest: URLRequest(
                  url: WebUri(widget.checkoutUrl),
                ),
                initialSettings: InAppWebViewSettings(
                  javaScriptEnabled: true,
                  domStorageEnabled: true,
                  thirdPartyCookiesEnabled: true,
                  useShouldOverrideUrlLoading: true,
                  mediaPlaybackRequiresUserGesture: false,
                  allowsInlineMediaPlayback: true,
                  supportMultipleWindows: !kIsWeb,
                  javaScriptCanOpenWindowsAutomatically: true,
                  useHybridComposition: true,
                  // Helps Chapa hosted checkout inside WebView.
                  allowsBackForwardNavigationGestures: true,
                ),
                onWebViewCreated: (controller) {
                  _webViewController = controller;
                },
                onProgressChanged: (_, progress) {
                  if (mounted) setState(() => _progress = progress / 100);
                },
                onLoadStart: (_, url) => _handleUrl(url?.toString()),
                onLoadStop: (_, url) => _handleUrl(url?.toString()),
                onUpdateVisitedHistory: (_, url, __) {
                  _handleUrl(url?.toString());
                },
                shouldOverrideUrlLoading: (controller, action) async {
                  final url = action.request.url?.toString() ?? '';
                  _handleUrl(url);

                  // Deep link back into the app — close WebView instead of navigating.
                  if (url
                      .toLowerCase()
                      .startsWith('${PaymentConfig.returnScheme}://')) {
                    return NavigationActionPolicy.CANCEL;
                  }

                  // HTTPS return page — finish and stay in the Flutter app.
                  if (PaymentConfig.isReturnUrl(url)) {
                    return NavigationActionPolicy.CANCEL;
                  }

                  return NavigationActionPolicy.ALLOW;
                },
                onCreateWindow: (controller, request) async {
                  // Open Chapa popups/windows inside the same WebView.
                  final url = request.request.url;
                  if (url != null) {
                    await controller.loadUrl(urlRequest: URLRequest(url: url));
                  }
                  return true;
                },
                onReceivedHttpError: (controller, request, errorResponse) {
                  final code = errorResponse.statusCode;
                  final url = request.url?.toString() ?? '';
                  // Don't treat our return page as expired.
                  if (PaymentConfig.isReturnUrl(url)) {
                    _handleUrl(url);
                    return;
                  }
                  if (code == 419 || code == 410) {
                    _markExpired();
                  }
                },
                onReceivedError: (controller, request, error) {
                  final url = request.url?.toString() ?? '';
                  if (PaymentConfig.isReturnUrl(url)) {
                    _handleUrl(url);
                    return;
                  }
                  debugPrint(
                    'Chapa WebView error: ${error.description} ($url)',
                  );
                },
              ),
            if (_sessionExpired)
              _ExpiredCheckoutPanel(
                onRetry: () => _finish('expired'),
                onCancel: () => _finish('cancelled'),
              ),
            if (!_sessionExpired && _progress < 1.0)
              LinearProgressIndicator(
                value: _progress > 0 ? _progress : null,
                color: const Color(0xFF6B4CE6),
                backgroundColor: Colors.grey.shade200,
              ),
          ],
        ),
      ),
    );
  }
}

class _ExpiredCheckoutPanel extends StatelessWidget {
  const _ExpiredCheckoutPanel({
    required this.onRetry,
    required this.onCancel,
  });

  final VoidCallback onRetry;
  final VoidCallback onCancel;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(28),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.timer_off_rounded, size: 64, color: Colors.orange.shade700),
            const SizedBox(height: 16),
            const Text(
              'Payment session expired',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w800,
                color: Color(0xFF2D3142),
              ),
            ),
            const SizedBox(height: 10),
            Text(
              'This checkout link is no longer valid. Start a new payment to continue.',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 15, color: Colors.grey.shade700),
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              height: 52,
              child: ElevatedButton(
                onPressed: onRetry,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF6B4CE6),
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                ),
                child: const Text(
                  'Try again',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
              ),
            ),
            TextButton(onPressed: onCancel, child: const Text('Cancel')),
          ],
        ),
      ),
    );
  }
}
