import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:kids_app/l10n/app_localizations.dart';
import '../../features/auth/presentation/providers/auth_providers.dart';
import '../../features/notification/presentation/providers/notification_provider.dart';
import '../../features/subscription/presentation/providers/subscription_providers.dart';
import '../auth/auth_gate.dart';
import '../localization/locale_provider.dart';

/// Persistent banner on home when payment is required or user is a guest.
class PaymentPromptBanner extends ConsumerWidget {
  const PaymentPromptBanner({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final isGuest = ref.watch(guestModeProvider);
    final user = ref.watch(authStateProvider);
    final accessInfo = ref.watch(accessInfoProvider);

    String message = '';
    bool showBanner = false;

    if (isGuest || user == null) {
      message = l10n.guestPaymentBanner;
      showBanner = true;
    } else if (accessInfo?.requiresPayment == true) {
      message = l10n.paymentRequiredBanner;
      showBanner = true;
    } else if (accessInfo?.accessType == 'trial' &&
        accessInfo!.daysLeft <= 2) {
      message = l10n.trialBanner(accessInfo.daysLeft);
      showBanner = true;
    }

    if (!showBanner) return const SizedBox.shrink();

    Future<void> onSubscribe() async {
      // Never launch Chapa from here.
      // Guests → register/login first. Logged-in users → plan selection only.
      if (AuthGate.isGuest(ref)) {
        await AuthGate.requireAuth(
          context,
          ref,
          message: l10n.loginToPay,
        );
        return;
      }
      if (context.mounted) {
        context.push('/subscription');
      }
    }

    // Top margin clears the floating language/notification/profile icons.
    return Container(
      margin: const EdgeInsets.only(top: 52, bottom: 12),
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF6B4CE6), Color(0xFFFF6B9D)],
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF6B4CE6).withValues(alpha: 0.3),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          const Icon(Icons.star_rounded, color: Colors.white, size: 28),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              message,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w600,
                fontSize: 13,
                height: 1.35,
              ),
            ),
          ),
          const SizedBox(width: 6),
          // Small one-line text button.
          TextButton(
            onPressed: onSubscribe,
            style: TextButton.styleFrom(
              foregroundColor: Colors.white,
              minimumSize: const Size(0, 32),
              padding: const EdgeInsets.symmetric(horizontal: 8),
              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  l10n.subscribeNow,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 13,
                    decoration: TextDecoration.underline,
                    decorationColor: Colors.white,
                  ),
                ),
                const Icon(Icons.arrow_forward_rounded,
                    size: 15, color: Colors.white),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// Loads access info when a logged-in user opens home.
final homeAccessLoaderProvider = FutureProvider<void>((ref) async {
  final user = ref.watch(authStateProvider);
  final isGuest = ref.watch(guestModeProvider);
  if (user == null || isGuest) return;

  try {
    final ds = ref.read(subscriptionRemoteDataSourceProvider);
    final info = await ds.checkAccess();
    ref.read(accessInfoProvider.notifier).state = info;
  } catch (_) {}
});

/// Loads in-app notifications + triggers device alerts for new unread items.
final homeNotificationLoaderProvider = FutureProvider<void>((ref) async {
  final user = ref.watch(authStateProvider);
  final isGuest = ref.watch(guestModeProvider);
  if (user == null || isGuest) return;

  final notifier = ref.read(notificationProvider.notifier);
  await notifier.registerDevice();
  await notifier.refresh(notifyDevice: true);
});
