import '../entities/watch_status.dart';
import '../gateways/watchlist_gateway.dart';

class FindWatchStatusUseCase {
  const FindWatchStatusUseCase(this._watchlist);

  final WatchlistGateway _watchlist;

  WatchStatus? call(int animeId) {
    for (final entry in _watchlist.entries) {
      if (entry.id == animeId) {
        return entry.status;
      }
    }

    return null;
  }
}
