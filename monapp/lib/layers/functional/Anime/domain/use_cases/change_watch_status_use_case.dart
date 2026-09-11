import '../entities/watch_status.dart';
import '../gateways/watchlist_gateway.dart';

class ChangeWatchStatusUseCase {
  const ChangeWatchStatusUseCase(this._watchlist);

  final WatchlistGateway _watchlist;

  void call(int animeId, WatchStatus status) =>
      _watchlist.changeStatus(animeId, status);
}
