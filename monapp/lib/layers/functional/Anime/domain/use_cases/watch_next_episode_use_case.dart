import '../entities/watch_status.dart';
import '../gateways/watchlist_gateway.dart';

class WatchNextEpisodeUseCase {
  const WatchNextEpisodeUseCase(this._watchlist);

  final WatchlistGateway _watchlist;

  void call(int animeId, {required int totalEpisodes}) {
    final listed = _watchlist.entries.where((entry) => entry.id == animeId);

    if (listed.isEmpty) {
      return;
    }

    final entry = listed.first;
    final watched = entry.watchedOf(totalEpisodes);

    if (totalEpisodes > 0 && watched >= totalEpisodes) {
      return;
    }

    final next = watched + 1;
    final isLast = totalEpisodes > 0 && next >= totalEpisodes;

    _watchlist.update(
      entry.withProgress(
        episodesWatched: next,
        status: isLast ? WatchStatus.completed : WatchStatus.watching,
      ),
    );
  }
}
