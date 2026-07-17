import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../storage/app_preferences.dart';

final sharedPreferencesProvider = Provider<SharedPreferences>((ref) {
  throw UnimplementedError('SharedPreferences must be overridden in main()');
});

final appPreferencesProvider = Provider<AppPreferences>((ref) {
  return AppPreferences(ref.watch(sharedPreferencesProvider));
});

/// True when the user is browsing without an account.
final guestModeProvider = StateProvider<bool>((ref) => false);

/// Current app locale (en or am). Defaults to English.
final localeProvider = StateNotifierProvider<LocaleNotifier, Locale>((ref) {
  return LocaleNotifier(ref.watch(appPreferencesProvider));
});

class LocaleNotifier extends StateNotifier<Locale> {
  final AppPreferences _prefs;

  LocaleNotifier(this._prefs)
      : super(Locale(_prefs.localeCode ?? 'en'));

  Future<void> setLocale(Locale locale) async {
    state = locale;
    await _prefs.setLocaleCode(locale.languageCode);
  }

  void toggleLocale() {
    final next = state.languageCode == 'am'
        ? const Locale('en')
        : const Locale('am');
    setLocale(next);
  }
}
