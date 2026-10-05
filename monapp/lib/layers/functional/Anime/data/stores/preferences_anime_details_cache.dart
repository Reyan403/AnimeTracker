import 'dart:async';
import 'dart:convert';

import '../../../../technical/Preferences/app_preferences.dart';
import '../../../../technical/Preferences/preferences_key.dart';
import '../../domain/entities/anime_details.dart';
import '../../domain/gateways/anime_details_cache.dart';
import '../models/anime_details_cache_dto.dart';

class PreferencesAnimeDetailsCache implements AnimeDetailsCache {
  const PreferencesAnimeDetailsCache(this._preferences);

  final AppPreferences _preferences;

  @override
  Map<int, AnimeDetails> findAll(List<int> ids) {
    final stored = _read();

    return {
      for (final id in ids)
        if (stored['$id'] case final Map<String, dynamic> json)
          id: AnimeDetailsCacheDto.fromJson(json),
    };
  }

  @override
  void saveAll(Map<int, AnimeDetails> details) {
    final stored = _read();

    for (final entry in details.entries) {
      stored['${entry.key}'] = AnimeDetailsCacheDto.toJson(entry.value);
    }

    unawaited(
      _preferences.writeString(PreferencesKey.detailsCache, jsonEncode(stored)),
    );
  }

  Map<String, dynamic> _read() {
    final source = _preferences.readString(PreferencesKey.detailsCache);

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
