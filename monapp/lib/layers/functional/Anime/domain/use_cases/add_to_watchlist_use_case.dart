import '../entities/watch_status.dart';
import '../entities/watchlist_entry.dart';
import '../gateways/watchlist_gateway.dart';

class AddToWatchlistUseCase {
  const AddToWatchlistUseCase(this._watchlist);

  final WatchlistGateway _watchlist;

  void call(int animeId, String title) => _watchlist.add(
        WatchlistEntry(
          id: animeId,
          title: title,
          status: WatchStatus.toWatch,
        ),
      );
}
