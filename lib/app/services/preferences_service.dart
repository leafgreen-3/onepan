import 'package:shared_preferences/shared_preferences.dart';

class PreferencesService {
  PreferencesService();

  static const _countryKey = 'onboarding.country';
  static const _levelKey = 'onboarding.level';
  static const _dietKey = 'onboarding.diet';
  static const _completeKey = 'onboarding.complete';

  SharedPreferences? _cachedPreferences;

  Future<SharedPreferences> get _instance async {
    return _cachedPreferences ??=
        await SharedPreferences.getInstance();
  }

  Future<bool> isOnboardingComplete() async {
    final prefs = await _instance;
    return prefs.getBool(_completeKey) ?? false;
  }

  Future<void> saveOnboarding({
    required String country,
    required String level,
    required String diet,
  }) async {
    final prefs = await _instance;
    await prefs.setString(_countryKey, country);
    await prefs.setString(_levelKey, level);
    await prefs.setString(_dietKey, diet);
    await prefs.setBool(_completeKey, true);
  }

  Future<Map<String, String>?> readOnboarding() async {
    final prefs = await _instance;
    final isComplete = prefs.getBool(_completeKey) ?? false;
    if (!isComplete) {
      return null;
    }

    final country = prefs.getString(_countryKey);
    final level = prefs.getString(_levelKey);
    final diet = prefs.getString(_dietKey);

    if (country == null || level == null || diet == null) {
      return null;
    }

    if (country.isEmpty || level.isEmpty || diet.isEmpty) {
      return null;
    }

    return {
      'country': country,
      'level': level,
      'diet': diet,
    };
  }

  Future<void> clearOnboarding() async {
    final prefs = await _instance;
    await prefs.remove(_countryKey);
    await prefs.remove(_levelKey);
    await prefs.remove(_dietKey);
    await prefs.setBool(_completeKey, false);
  }
}
