import '../entities/watchlist_entry.dart';

abstract interface class WatchlistGateway {
  List<WatchlistEntry> get entries;

  Stream<List<WatchlistEntry>> get changes;

  void add(WatchlistEntry entry);
}
