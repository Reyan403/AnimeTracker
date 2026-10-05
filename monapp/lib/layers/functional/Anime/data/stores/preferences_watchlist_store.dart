import '../../../../technical/Preferences/app_preferences.dart';
import '../../../../technical/Preferences/preferences_key.dart';
import '../../domain/entities/watchlist_entry.dart';
import '../models/watchlist_entry_dto.dart';
import 'watchlist_store.dart';

class PreferencesWatchlistStore implements WatchlistStore {
  const PreferencesWatchlistStore(this._preferences);

  final AppPreferences _preferences;

  @override
  List<WatchlistEntry>? read() => WatchlistEntryDto.decode(
        _preferences.readString(PreferencesKey.watchlist),
      );

  @override
  Future<void> write(List<WatchlistEntry> entries) => _preferences
      .writeString(PreferencesKey.watchlist, WatchlistEntryDto.encode(entries));
}
