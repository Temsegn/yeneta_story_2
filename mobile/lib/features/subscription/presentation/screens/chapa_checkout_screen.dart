import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:kids_app/core/config/payment_config.dart';

/// Opens Chapa `checkout_url` in an in-app WebView.
/// Pops with status: `success` | `failed` | `cancelled`.
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
  InAppWebViewController? _webViewController;

  void _finish(String status) {
    if (_finished || !mounted) return;
    _finished = true;
    Navigator.of(context).pop(status);
  }

  void _handleUrl(String? url) {
    if (url == null || url.isEmpty) return;

    if (!PaymentConfig.isReturnUrl(url)) return;

    final status = PaymentConfig.statusFromReturnUrl(url);
    if (status == 'success') {
      _finish('success');
      return;
    }
    if (status == 'failed') {
      _finish('failed');
      return;
    }

    // Ambiguous deep link — parent verifies with backend using txRef.
    _finish('success');
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
            IconButton(
              icon: const Icon(Icons.refresh),
              tooltip: 'Reload checkout',
              onPressed: () {
                _webViewController?.reload();
              },
            ),
          ],
        ),
        body: Stack(
          children: [
            InAppWebView(
              initialUrlRequest: URLRequest(
                url: WebUri(widget.checkoutUrl),
              ),
              initialSettings: InAppWebViewSettings(
                javaScriptEnabled: true,
                domStorageEnabled: true,
                useShouldOverrideUrlLoading: true,
                mediaPlaybackRequiresUserGesture: false,
                allowsInlineMediaPlayback: true,
                supportMultipleWindows: true,
                javaScriptCanOpenWindowsAutomatically: true,
                useHybridComposition: true,
              ),
              onWebViewCreated: (controller) {
                _webViewController = controller;
              },
              onProgressChanged: (_, progress) {
                if (mounted) setState(() => _progress = progress / 100);
              },
              onLoadStart: (controller, url) {
                _handleUrl(url?.toString());
              },
              onLoadStop: (controller, url) {
                _handleUrl(url?.toString());
              },
              onUpdateVisitedHistory: (controller, url, __) {
                _handleUrl(url?.toString());
              },
              shouldOverrideUrlLoading: (controller, action) async {
                final url = action.request.url?.toString() ?? '';
                _handleUrl(url);

                if (url.toLowerCase().startsWith('${PaymentConfig.returnScheme}://')) {
                  return NavigationActionPolicy.CANCEL;
                }
                return NavigationActionPolicy.ALLOW;
              },
              onReceivedError: (controller, request, error) {
                debugPrint(
                  'Chapa WebView error: ${error.description} (${request.url})',
                );
              },
            ),
            if (_progress < 1.0)
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
