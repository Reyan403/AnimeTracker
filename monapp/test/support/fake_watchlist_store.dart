import 'package:monapp/layers/functional/Anime/data/stores/watchlist_store.dart';
import 'package:monapp/layers/functional/Anime/domain/entities/watchlist_entry.dart';

class FakeWatchlistStore implements WatchlistStore {
  FakeWatchlistStore([this.saved]);

  List<WatchlistEntry>? saved;
  int writes = 0;

  @override
  List<WatchlistEntry>? read() => saved;

  @override
  Future<void> write(List<WatchlistEntry> entries) async {
    saved = entries;
    writes++;
  }
}
