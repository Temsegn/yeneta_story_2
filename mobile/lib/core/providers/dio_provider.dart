import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../../features/auth/presentation/providers/auth_providers.dart';
import '../localization/locale_provider.dart';
import '../network/dio_client.dart';
import '../storage/token_storage.dart';

final secureStorageProvider = Provider<FlutterSecureStorage>((ref) {
  return const FlutterSecureStorage();
});

final tokenStorageProvider = Provider<TokenStorage>((ref) {
  final storage = ref.watch(secureStorageProvider);
  return TokenStorage(storage);
});

final dioClientProvider = Provider<DioClient>((ref) {
  final tokenStorage = ref.watch(tokenStorageProvider);
  return DioClient(
    tokenStorage,
    onSessionExpired: () async {
      await tokenStorage.clearTokens();
      ref.read(authStateProvider.notifier).state = null;
      ref.read(guestModeProvider.notifier).state = true;
      await ref.read(appPreferencesProvider).setGuestMode(true);
    },
  );
});
