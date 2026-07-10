import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:kids_app/core/auth/auth_gate.dart';
import 'package:kids_app/core/auth/auth_session.dart';
import 'package:kids_app/l10n/app_localizations.dart';
import '../../../../core/network/api_exception.dart';
import '../../data/models/subscription_models.dart';
import '../providers/subscription_providers.dart';
import 'chapa_checkout_screen.dart';

class SubscriptionScreen extends ConsumerStatefulWidget {
  const SubscriptionScreen({super.key});

  @override
  ConsumerState<SubscriptionScreen> createState() =>
      _SubscriptionScreenState();
}

class _SubscriptionScreenState extends ConsumerState<SubscriptionScreen> {
  bool _isProcessing = false;
  AccessInfo? _accessInfo;

  @override
  void initState() {
    super.initState();
    _loadAccessInfo();
  }

  Future<void> _loadAccessInfo() async {
    try {
      final dataSource = ref.read(subscriptionRemoteDataSourceProvider);
      final accessInfo = await dataSource.checkAccess();
      if (!mounted) return;
      setState(() => _accessInfo = accessInfo);
      ref.read(accessInfoProvider.notifier).state = accessInfo;
    } catch (e) {
      debugPrint('Error loading access info: $e');
    }
  }

  Future<void> _handleSubscribe(SubscriptionPlan plan) async {
    if (_isProcessing) return;

    final authed = await AuthGate.requireAuth(
      context,
      ref,
      message: AppLocalizations.of(context).loginToPay,
    );
    if (!authed) return;

    setState(() => _isProcessing = true);

    try {
      final dataSource = ref.read(subscriptionRemoteDataSourceProvider);

      // Step 1: Flutter sends planId only.
      final checkout = await dataSource.checkout(plan.planId);
      if (!mounted) return;

      // Step 5: Open Chapa checkout_url in WebView.
      final status = await Navigator.of(context).push<String>(
        MaterialPageRoute(
          builder: (_) => ChapaCheckoutScreen(
            checkoutUrl: checkout.data.checkoutUrl,
            txRef: checkout.data.txRef,
          ),
        ),
      );

      if (!mounted) return;

      if (status == null || status == 'cancelled') {
        _showPaymentResultModal(false, 'Payment was cancelled');
        return;
      }

      if (status == 'expired') {
        // Stale Chapa session — start a fresh checkout.
        setState(() => _isProcessing = false);
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Payment session expired. Starting a new checkout…'),
              behavior: SnackBarBehavior.floating,
            ),
          );
          _handleSubscribe(plan);
        }
        return;
      }

      // Step 7 (client side): verify with backend after WebView closes.
      try {
        final verify = await dataSource.verifyPayment(checkout.data.txRef);
        await _loadAccessInfo();
        _showPaymentResultModal(true, verify.message);
      } catch (e) {
        if (status == 'success') {
          // Webhook may still activate; refresh and show soft success.
          await _loadAccessInfo();
          final unlocked = ref.read(accessInfoProvider)?.isPremium == true ||
              ref.read(accessInfoProvider)?.hasAccess == true;
          _showPaymentResultModal(
            unlocked,
            unlocked
                ? 'Payment received. Premium unlocked!'
                : 'Payment submitted. Status will update shortly.',
          );
        } else {
          _showPaymentResultModal(false, _getErrorMessage(e));
        }
      }
    } on ApiException catch (e) {
      debugPrint('CHECKOUT ApiException: status=${e.statusCode} message=${e.message}');
      if (mounted) {
        if (e.statusCode == 401) {
          await AuthSession.clear(ref);
          if (!mounted) return;
          final retry = await AuthGate.requireAuth(
            context,
            ref,
            message: AppLocalizations.of(context).loginToPay,
          );
          if (retry) _handleSubscribe(plan);
          return;
        }
        _showPaymentResultModal(false, e.message);
      }
    } catch (e, st) {
      debugPrint('CHECKOUT unexpected error: $e\n$st');
      if (mounted) _showPaymentResultModal(false, _getErrorMessage(e));
    } finally {
      if (mounted) setState(() => _isProcessing = false);
    }
  }

  String _getErrorMessage(dynamic error) {
    if (error is ApiException) return error.message;
    final message = error.toString();
    if (message.startsWith('Exception: ')) return message.substring(11);
    if (message.isEmpty || message == '[object Object]') {
      return 'An error occurred. Please try again.';
    }
    return message;
  }

  /// Success/fail modal shown for 5 seconds, then vanishes and goes home.
  void _showPaymentResultModal(bool isSuccess, String message) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => PopScope(
        canPop: false,
        child: Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 80,
                  height: 80,
                  decoration: BoxDecoration(
                    color: (isSuccess ? Colors.green : Colors.red)
                        .withValues(alpha: 0.1),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    isSuccess ? Icons.check_circle : Icons.error,
                    size: 50,
                    color: isSuccess ? Colors.green : Colors.red,
                  ),
                ),
                const SizedBox(height: 20),
                Text(
                  isSuccess ? 'Payment Successful!' : 'Payment Failed',
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: isSuccess ? Colors.green : Colors.red,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 12),
                Text(
                  message,
                  style: const TextStyle(fontSize: 16, color: Colors.black87),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      'Powered by',
                      style: TextStyle(fontSize: 12, color: Colors.black54),
                    ),
                    const SizedBox(width: 6),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: const Color(0xFF1E88E5),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: const Text(
                        'CHAPA',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                          letterSpacing: 1.2,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );

    Future.delayed(const Duration(seconds: 5), () {
      if (!mounted) return;
      Navigator.of(context, rootNavigator: true).pop();
      context.go('/home');
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Subscribe'),
        backgroundColor: const Color(0xFF6B4CE6),
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (_accessInfo != null) ...[
                _buildAccessInfoCard(),
                const SizedBox(height: 24),
              ],
              const Text(
                'Choose Your Plan',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF2D3142),
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                'Unlock premium content and features',
                style: TextStyle(fontSize: 16, color: Colors.black54),
              ),
              const SizedBox(height: 32),
              _buildPlanCard(SubscriptionPlan.premiumYearly, isPopular: true),
              const SizedBox(height: 16),
              _buildPlanCard(SubscriptionPlan.premiumMonthly),
              const SizedBox(height: 32),
              _buildFeaturesList(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAccessInfoCard() {
    if (_accessInfo == null || !_accessInfo!.hasAccess) {
      return Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.orange.shade50,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.orange.shade200),
        ),
        child: Row(
          children: [
            Icon(Icons.info_outline, color: Colors.orange.shade700),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                _accessInfo?.message ??
                    'Subscribe to access premium content',
                style: TextStyle(
                  color: Colors.orange.shade900,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ],
        ),
      );
    }

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            const Color(0xFF6B4CE6).withValues(alpha: 0.1),
            const Color(0xFF9B6BFF).withValues(alpha: 0.1),
          ],
        ),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: const Color(0xFF6B4CE6).withValues(alpha: 0.3),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                _accessInfo!.accessType == 'trial'
                    ? Icons.timer_outlined
                    : Icons.check_circle_outline,
                color: const Color(0xFF6B4CE6),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  _accessInfo!.accessType == 'trial'
                      ? 'Free Trial Active'
                      : 'Subscription Active',
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF2D3142),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            '${_accessInfo!.daysLeft} days remaining',
            style: const TextStyle(fontSize: 16, color: Colors.black87),
          ),
        ],
      ),
    );
  }

  Widget _buildPlanCard(SubscriptionPlan plan, {bool isPopular = false}) {
    final hasActiveSubscription = _accessInfo?.isPremium == true ||
        (_accessInfo?.hasAccess == true &&
            _accessInfo?.accessType == 'subscription');
    final isCurrentPlan = hasActiveSubscription &&
        (_accessInfo?.plan?.toLowerCase() == plan.planId.toLowerCase());

    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isCurrentPlan
              ? Colors.green
              : isPopular
                  ? const Color(0xFF6B4CE6)
                  : Colors.grey.shade300,
          width: isCurrentPlan || isPopular ? 2 : 1,
        ),
      ),
      child: Column(
        children: [
          if (isCurrentPlan || isPopular)
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 8),
              decoration: BoxDecoration(
                color: isCurrentPlan
                    ? Colors.green
                    : const Color(0xFF6B4CE6),
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(14),
                  topRight: Radius.circular(14),
                ),
              ),
              child: Text(
                isCurrentPlan ? 'ACTIVE SUBSCRIPTION' : 'MOST POPULAR',
                textAlign: TextAlign.center,
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 12,
                ),
              ),
            ),
          Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  plan.displayName,
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF2D3142),
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  plan.description,
                  style: const TextStyle(fontSize: 14, color: Colors.black54),
                ),
                const SizedBox(height: 16),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      plan.priceText,
                      style: const TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF6B4CE6),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Padding(
                      padding: const EdgeInsets.only(bottom: 6),
                      child: Text(
                        plan.periodLabel,
                        style: const TextStyle(
                          fontSize: 16,
                          color: Colors.black54,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton(
                    onPressed: isCurrentPlan || _isProcessing
                        ? null
                        : () => _handleSubscribe(plan),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: isCurrentPlan
                          ? Colors.grey.shade400
                          : const Color(0xFF6B4CE6),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      elevation: 0,
                    ),
                    child: _isProcessing
                        ? const SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(
                              color: Colors.white,
                              strokeWidth: 2,
                            ),
                          )
                        : Text(
                            isCurrentPlan
                                ? 'Already Active'
                                : 'Subscribe · ${plan.priceText}',
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                  ),
                ),
                const SizedBox(height: 12),
                const Center(
                  child: Text(
                    'Secure checkout powered by CHAPA',
                    style: TextStyle(fontSize: 12, color: Colors.black54),
                  ),
                ),
                const SizedBox(height: 8),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: const Color(0xFFFFF7E6),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: const Color(0xFFFFD591)),
                  ),
                  child: const Text(
                    'Test mode: pick any payment method on Chapa. For mobile money '
                    'use phone 0900123456 (OTP 12345 only if asked).',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 12,
                      height: 1.35,
                      color: Color(0xFF8B5A00),
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFeaturesList() {
    const features = [
      'Unlimited access to all videos',
      'Unlimited access to all books',
      'Unlimited access to all stories',
      'Premium education content',
      'Ad-free experience',
      'Priority customer support',
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "What's Included",
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Color(0xFF2D3142),
          ),
        ),
        const SizedBox(height: 16),
        ...features.map(
          (feature) => Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: Row(
              children: [
                const Icon(Icons.check_circle, color: Color(0xFF6B4CE6), size: 24),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    feature,
                    style: const TextStyle(fontSize: 16, color: Colors.black87),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
