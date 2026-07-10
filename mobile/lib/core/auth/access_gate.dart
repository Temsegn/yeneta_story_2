import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:kids_app/l10n/app_localizations.dart';
import '../localization/locale_provider.dart';
import '../../features/auth/presentation/providers/auth_providers.dart';
import '../../features/subscription/presentation/providers/subscription_providers.dart';
import 'auth_gate.dart';

/// Gates free vs premium content.
/// Free content is always allowed. Premium requires an active trial or
/// paid subscription. Payment itself is never launched from here — guests
/// are sent to sign-in/register, logged-in users to the subscription plans.
class AccessGate {
  AccessGate._();

  /// True when the user can open premium content (active trial or subscription).
  static bool hasPremiumAccess(WidgetRef ref) {
    if (AuthGate.isGuest(ref)) return false;
    final access = ref.read(accessInfoProvider);
    if (access == null) return false;
    // Paid premium OR active free trial both unlock premium features.
    if (access.isPremium) return true;
    return access.hasAccess &&
        (access.accessType == 'trial' || access.accessType == 'subscription');
  }

  /// Allow free content always. For premium, return true only if unlocked.
  /// Otherwise show a dialog and route to register or plans (never direct pay).
  static Future<bool> canOpenPremium(
    BuildContext context,
    WidgetRef ref, {
    required bool isPremium,
  }) async {
    if (!isPremium) return true;
    if (hasPremiumAccess(ref)) return true;

    final l10n = AppLocalizations.of(context);
    final isGuest = AuthGate.isGuest(ref);

    final goNext = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: const Color(0xFF6B4CE6).withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Icon(Icons.lock_rounded, color: Color(0xFF6B4CE6)),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                l10n.premiumLockedTitle,
                style: const TextStyle(fontSize: 18),
              ),
            ),
          ],
        ),
        content: Text(
          isGuest ? l10n.premiumLockedGuestMessage : l10n.premiumLockedPayMessage,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: Text(l10n.cancel),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(ctx, true),
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF6B4CE6),
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: Text(
              isGuest ? l10n.loginOrRegister : l10n.viewPlans,
            ),
          ),
        ],
      ),
    );

    if (goNext != true || !context.mounted) return false;

    if (isGuest) {
      // Not direct payment — register/login first.
      ref.read(guestModeProvider.notifier).state = false;
      context.push('/signin');
      return false;
    }

    // Logged in but no access — show plans only (user chooses, then pays).
    context.push('/subscription');
    return false;
  }
}

/// Small lock badge used on premium cards when the viewer cannot unlock yet.
class PremiumLockBadge extends ConsumerWidget {
  final bool isPremium;

  const PremiumLockBadge({super.key, required this.isPremium});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    if (!isPremium || AccessGate.hasPremiumAccess(ref)) {
      return const SizedBox.shrink();
    }

    final l10n = AppLocalizations.of(context);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: Colors.black.withValues(alpha: 0.65),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.amber.shade300),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.lock_rounded, size: 14, color: Colors.amber.shade300),
          const SizedBox(width: 4),
          Text(
            l10n.premium,
            style: TextStyle(
              color: Colors.amber.shade300,
              fontSize: 11,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}
