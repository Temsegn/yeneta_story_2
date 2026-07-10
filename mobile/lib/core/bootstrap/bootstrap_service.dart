import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:package_info_plus/package_info_plus.dart';
import '../../features/auth/data/models/auth_models.dart';
import '../../features/auth/presentation/providers/auth_providers.dart';
import '../../features/subscription/data/models/subscription_models.dart';
import '../../features/subscription/presentation/providers/subscription_providers.dart';
import '../network/api_config.dart';
import '../providers/dio_provider.dart';
import '../storage/app_preferences.dart';
import '../storage/onboarding_storage.dart';
import '../localization/locale_provider.dart';

enum BootstrapStep {
  loading,
  checkingVersion,
  checkingAuth,
  checkingPayment,
  ready,
  updateRequired,
}

class BootstrapResult {
  final BootstrapStep step;
  final String? nextRoute;
  final AccessInfo? accessInfo;
  final UserData? user;
  final bool isGuest;
  final String? updateMessage;

  const BootstrapResult({
    required this.step,
    this.nextRoute,
    this.accessInfo,
    this.user,
    this.isGuest = false,
    this.updateMessage,
  });
}

/// Professional app bootstrap: version → auth → payment status → route.
class BootstrapService {
  final Ref _ref;
  final OnboardingStorage _onboardingStorage;

  BootstrapService(this._ref, this._onboardingStorage);

  static const minSupportedVersion = '1.0.0';

  Future<BootstrapResult> run() async {
    final packageInfo = await PackageInfo.fromPlatform();
    if (_isVersionTooOld(packageInfo.version)) {
      return BootstrapResult(
        step: BootstrapStep.updateRequired,
        updateMessage: packageInfo.version,
      );
    }

    await Connectivity().checkConnectivity();

    final prefs = _ref.read(appPreferencesProvider);
    final tokenStorage = _ref.read(tokenStorageProvider);
    final accessToken = await tokenStorage.getAccessToken();
    final userData = await tokenStorage.getUserData();

    UserData? user;
    if (accessToken != null && userData != null) {
      try {
        user = UserData.fromJson(userData);
        _ref.read(authStateProvider.notifier).state = user;
        _ref.read(guestModeProvider.notifier).state = false;
        await prefs.setGuestMode(false);
      } catch (_) {
        await tokenStorage.clearTokens();
      }
    }

    AccessInfo? accessInfo;
    if (user != null) {
      try {
        final ds = _ref.read(subscriptionRemoteDataSourceProvider);
        accessInfo = await ds.checkAccess();
        _ref.read(accessInfoProvider.notifier).state = accessInfo;
      } catch (_) {}
    }

    if (user != null) {
      return BootstrapResult(
        step: BootstrapStep.ready,
        nextRoute: '/home',
        user: user,
        accessInfo: accessInfo,
        isGuest: false,
      );
    }

    _ref.read(guestModeProvider.notifier).state = true;
    await prefs.setGuestMode(true);

    final hasSeenOnboarding = await _onboardingStorage.hasSeenOnboarding();

    return BootstrapResult(
      step: BootstrapStep.ready,
      nextRoute: hasSeenOnboarding ? '/home' : '/onboarding',
      isGuest: true,
    );
  }

  Future<void> warmUpBackend() async {
    try {
      final dio = Dio(BaseOptions(
        baseUrl: ApiConfig.baseUrl.replaceAll('/api/v1', ''),
        connectTimeout: const Duration(seconds: 15),
        receiveTimeout: const Duration(seconds: 15),
      ));
      await dio.get('/health');
    } catch (_) {}
  }

  bool _isVersionTooOld(String current) {
    final currentParts = current.split('.').map(int.parse).toList();
    final minParts = minSupportedVersion.split('.').map(int.parse).toList();
    for (var i = 0; i < 3; i++) {
      final c = i < currentParts.length ? currentParts[i] : 0;
      final m = i < minParts.length ? minParts[i] : 0;
      if (c < m) return true;
      if (c > m) return false;
    }
    return false;
  }
}

final bootstrapServiceProvider = Provider<BootstrapService>((ref) {
  return BootstrapService(ref, OnboardingStorage());
});
