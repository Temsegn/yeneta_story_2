import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:kids_app/l10n/app_localizations.dart';
import '../localization/locale_provider.dart';
import '../../features/auth/presentation/providers/auth_providers.dart';
import 'auth_session.dart';

/// Prompts guest users to sign in or register before protected actions
/// (payment, profile, child profiles, etc.).
class AuthGate {
  AuthGate._();

  static bool isGuest(WidgetRef ref) {
    final user = ref.read(authStateProvider);
    final guest = ref.read(guestModeProvider);
    return guest || user == null;
  }

  /// Returns true if the user has a stored access token; otherwise shows a dialog.
  static Future<bool> requireAuth(
    BuildContext context,
    WidgetRef ref, {
    String? message,
  }) async {
    final hasToken = await AuthSession.hasStoredAccessToken(ref);
    if (!isGuest(ref) && hasToken) return true;

    // UI shows logged-in but no JWT in storage (expired session or old API).
    if (!isGuest(ref) && !hasToken) {
      await AuthSession.clear(ref);
    }
    if (!context.mounted) return false;

    final l10n = AppLocalizations.of(context);
    final result = await showDialog<bool>(
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
              child: const Icon(Icons.lock_outline, color: Color(0xFF6B4CE6)),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                l10n.createAccountToContinue,
                style: const TextStyle(fontSize: 18),
              ),
            ),
          ],
        ),
        content: Text(message ?? l10n.loginToPay),
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
            child: Text(l10n.loginOrRegister),
          ),
        ],
      ),
    );

    if (result == true && context.mounted) {
      ref.read(guestModeProvider.notifier).state = false;
      context.push('/signin');
    }
    return false;
  }
}
