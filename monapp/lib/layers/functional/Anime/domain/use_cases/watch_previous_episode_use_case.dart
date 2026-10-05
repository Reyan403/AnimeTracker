import '../entities/watch_status.dart';
import '../gateways/watchlist_gateway.dart';

class WatchPreviousEpisodeUseCase {
  const WatchPreviousEpisodeUseCase(this._watchlist);

  final WatchlistGateway _watchlist;

  void call(int animeId, {required int totalEpisodes}) {
    final listed = _watchlist.entries.where((entry) => entry.id == animeId);

    if (listed.isEmpty) {
      return;
    }

    final entry = listed.first;
    final watched = entry.watchedOf(totalEpisodes);

    if (watched <= 0) {
      return;
    }

    final previous = watched - 1;

    _watchlist.update(
      entry.withProgress(
        episodesWatched: previous,
        status: previous == 0 ? WatchStatus.toWatch : WatchStatus.watching,
      ),
    );
  }
}
