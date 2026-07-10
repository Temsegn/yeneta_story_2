import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';

/// Opens Chapa checkout_url in an in-app WebView.
/// Pops with status: 'success' | 'failed' | 'cancelled'.
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

  void _finish(String status) {
    if (_finished || !mounted) return;
    _finished = true;
    Navigator.of(context).pop(status);
  }

  void _handleUrl(String url) {
    final lower = url.toLowerCase();

    // Deep-link / return URL patterns used by backend FRONTEND_URL / CHAPA_RETURN_URL.
    final looksLikeReturn = lower.contains('payment-result') ||
        lower.contains('payment-return') ||
        lower.contains('payment-callback') ||
        lower.startsWith('myapp://');

    if (!looksLikeReturn) return;

    if (lower.contains('success') ||
        lower.contains('status=success') ||
        lower.contains('paid')) {
      _finish('success');
      return;
    }

    if (lower.contains('fail') ||
        lower.contains('cancel') ||
        lower.contains('error')) {
      _finish('failed');
      return;
    }

    // Ambiguous return — treat as success candidate; parent will verify with backend.
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
        ),
        body: Stack(
          children: [
            InAppWebView(
              initialUrlRequest: URLRequest(url: WebUri(widget.checkoutUrl)),
              initialSettings: InAppWebViewSettings(
                javaScriptEnabled: true,
                useShouldOverrideUrlLoading: true,
                mediaPlaybackRequiresUserGesture: false,
              ),
              onProgressChanged: (_, progress) {
                if (mounted) setState(() => _progress = progress / 100);
              },
              onLoadStart: (_, url) {
                if (url != null) _handleUrl(url.toString());
              },
              onLoadStop: (_, url) {
                if (url != null) _handleUrl(url.toString());
              },
              shouldOverrideUrlLoading: (controller, action) async {
                final url = action.request.url?.toString() ?? '';
                _handleUrl(url);
                if (url.startsWith('myapp://')) {
                  return NavigationActionPolicy.CANCEL;
                }
                return NavigationActionPolicy.ALLOW;
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
