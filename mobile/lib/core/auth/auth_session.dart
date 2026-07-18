import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../features/auth/presentation/providers/auth_providers.dart';
import '../../features/notification/presentation/providers/notification_provider.dart';
import '../../features/subscription/presentation/providers/subscription_providers.dart';
import '../localization/locale_provider.dart';
import '../providers/dio_provider.dart';

/// Helpers for checking and clearing the persisted auth session.
class AuthSession {
  AuthSession._();

  static Future<bool> hasStoredAccessToken(WidgetRef ref) async {
    final token = await ref.read(tokenStorageProvider).getAccessToken();
    return token != null && token.isNotEmpty;
  }

  static Future<void> clear(WidgetRef ref) async {
    await ref.read(notificationProvider.notifier).unregisterDevice();
    await ref.read(tokenStorageProvider).clearTokens();
    ref.read(authStateProvider.notifier).state = null;
    ref.read(accessInfoProvider.notifier).state = null;
    ref.read(notificationProvider.notifier).clear();
    ref.read(guestModeProvider.notifier).state = true;
    await ref.read(appPreferencesProvider).setGuestMode(true);
  }
}
