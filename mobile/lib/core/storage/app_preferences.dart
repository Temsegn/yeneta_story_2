import 'package:shared_preferences/shared_preferences.dart';

/// Persists guest-mode flag and preferred locale.
class AppPreferences {
  static const _guestKey = 'is_guest_mode';
  static const _localeKey = 'app_locale';

  final SharedPreferences _prefs;

  AppPreferences(this._prefs);

  bool get isGuestMode => _prefs.getBool(_guestKey) ?? false;

  Future<void> setGuestMode(bool value) async {
    await _prefs.setBool(_guestKey, value);
  }

  String? get localeCode => _prefs.getString(_localeKey);

  Future<void> setLocaleCode(String code) async {
    await _prefs.setString(_localeKey, code);
  }

  Future<void> clearGuestMode() async {
    await _prefs.remove(_guestKey);
  }
}
