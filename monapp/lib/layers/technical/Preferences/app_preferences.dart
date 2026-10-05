import 'package:shared_preferences/shared_preferences.dart';

import 'preferences_key.dart';

class AppPreferences {
  const AppPreferences(this._prefs);

  final SharedPreferencesWithCache _prefs;

  static Future<AppPreferences> open() async => AppPreferences(
        await SharedPreferencesWithCache.create(
          cacheOptions: const SharedPreferencesWithCacheOptions(),
        ),
      );

  String? readString(PreferencesKey key) => _prefs.getString(key.name);

  Future<void> writeString(PreferencesKey key, String value) =>
      _prefs.setString(key.name, value);

  bool readBool(PreferencesKey key, {required bool fallback}) =>
      _prefs.getBool(key.name) ?? fallback;

  Future<void> writeBool(PreferencesKey key, {required bool value}) =>
      _prefs.setBool(key.name, value);
}
