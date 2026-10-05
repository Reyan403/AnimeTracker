import 'dart:async';
import 'dart:convert';

import '../../../../technical/Preferences/app_preferences.dart';
import '../../../../technical/Preferences/preferences_key.dart';
import '../../domain/entities/anime_sheet.dart';
import '../../domain/gateways/anime_sheet_cache.dart';
import '../models/anime_sheet_cache_dto.dart';

class PreferencesAnimeSheetCache implements AnimeSheetCache {
  const PreferencesAnimeSheetCache(this._preferences);

  static const int capacity = 30;

  final AppPreferences _preferences;

  @override
  AnimeSheet? find(int id) {
    final json = _read()['$id'];

    return json is Map<String, dynamic>
        ? AnimeSheetCacheDto.fromJson(json)
        : null;
  }

  @override
  void save(AnimeSheet sheet) {
    final stored = _read()
      ..remove('${sheet.id}')
      ..['${sheet.id}'] = AnimeSheetCacheDto.toJson(sheet);

    while (stored.length > capacity) {
      stored.remove(stored.keys.first);
    }

    unawaited(
      _preferences.writeString(PreferencesKey.sheetCache, jsonEncode(stored)),
    );
  }

  Map<String, dynamic> _read() {
    final source = _preferences.readString(PreferencesKey.sheetCache);

    if (source == null) {
      return {};
    }

    try {
      return Map<String, dynamic>.from(jsonDecode(source) as Map);
    } on FormatException {
      return {};
    } on TypeError {
      return {};
    }
  }
}
