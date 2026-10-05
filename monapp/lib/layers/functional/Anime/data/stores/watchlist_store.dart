import '../../domain/entities/watchlist_entry.dart';

abstract interface class WatchlistStore {
  List<WatchlistEntry>? read();

  Future<void> write(List<WatchlistEntry> entries);
}
