import '../entities/watch_status.dart';
import '../entities/watchlist_entry.dart';

abstract interface class WatchlistGateway {
  List<WatchlistEntry> get entries;

  Stream<List<WatchlistEntry>> get changes;

  void add(WatchlistEntry entry);

  void changeStatus(int animeId, WatchStatus status);
}
