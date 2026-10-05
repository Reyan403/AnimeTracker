import 'watch_status.dart';

class WatchlistEntry {
  const WatchlistEntry({
    required this.id,
    required this.title,
    required this.status,
    this.episodesWatched = 0,
  });

  final int id;
  final String title;
  final WatchStatus status;
  final int episodesWatched;

  int watchedOf(int totalEpisodes) =>
      status == WatchStatus.completed && totalEpisodes > 0
          ? totalEpisodes
          : episodesWatched;

  WatchlistEntry withStatus(WatchStatus status) => WatchlistEntry(
        id: id,
        title: title,
        status: status,
        episodesWatched: episodesWatched,
      );

  WatchlistEntry withProgress({
    required int episodesWatched,
    required WatchStatus status,
  }) =>
      WatchlistEntry(
        id: id,
        title: title,
        status: status,
        episodesWatched: episodesWatched,
      );
}
