import '../../../Anime/domain/entities/anime.dart';
import '../../../Anime/domain/entities/anime_genre.dart';
import '../../../Anime/domain/entities/watch_status.dart';
import '../../../Anime/domain/use_cases/load_watchlist_use_case.dart';
import '../entities/watch_stats.dart';

class WatchStatsUnavailableException implements Exception {
  const WatchStatsUnavailableException();

  @override
  String toString() => 'The watch statistics are unavailable';
}

class ComputeWatchStatsUseCase {
  const ComputeWatchStatsUseCase(this._loadWatchlist);

  static const int topGenreCount = 5;

  final LoadWatchlistUseCase _loadWatchlist;

  Stream<WatchStats> call() => _loadWatchlist()
      .where((animes) => animes.every((anime) => !anime.isLoadingDetails))
      .map(_statsOf);

  WatchStats _statsOf(List<Anime> animes) {
    if (animes.isNotEmpty && animes.every((anime) => anime.details == null)) {
      throw const WatchStatsUnavailableException();
    }

    var minutes = 0;
    var episodes = 0;
    final counts = <String, int>{};
    final genres = <String, AnimeGenre>{};

    for (final anime in animes) {
      episodes += anime.episodesWatched;
      minutes += anime.episodesWatched * (anime.details?.episodeMinutes ?? 0);

      if (anime.status == WatchStatus.toWatch) {
        continue;
      }

      for (final genre in anime.details?.genres ?? const <AnimeGenre>[]) {
        counts.update(genre.slug, (count) => count + 1, ifAbsent: () => 1);
        genres[genre.slug] = genre;
      }
    }

    return WatchStats(
      minutesWatched: minutes,
      episodesWatched: episodes,
      toWatchCount: _countOf(animes, WatchStatus.toWatch),
      watchingCount: _countOf(animes, WatchStatus.watching),
      completedCount: _countOf(animes, WatchStatus.completed),
      topGenres: _top(counts, genres),
    );
  }

  static int _countOf(List<Anime> animes, WatchStatus status) =>
      animes.where((anime) => anime.status == status).length;

  static List<GenreShare> _top(
    Map<String, int> counts,
    Map<String, AnimeGenre> genres,
  ) {
    final ordered = counts.keys.toList()
      ..sort((a, b) {
        final byCount = counts[b]!.compareTo(counts[a]!);

        return byCount != 0 ? byCount : a.compareTo(b);
      });

    return [
      for (final slug in ordered.take(topGenreCount))
        GenreShare(genre: genres[slug]!, count: counts[slug]!),
    ];
  }
}
