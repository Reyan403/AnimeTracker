import '../../../Anime/domain/entities/anime.dart';
import '../../../Anime/domain/entities/anime_genre.dart';
import '../../../Anime/domain/entities/watch_status.dart';
import '../../../Anime/domain/use_cases/load_watchlist_use_case.dart';
import '../entities/constellation.dart';
import '../entities/constellation_star.dart';
import 'constellation_layout.dart';
import 'constellation_links_builder.dart';

class ConstellationUnavailableException implements Exception {
  const ConstellationUnavailableException();

  @override
  String toString() => 'The constellation is unavailable';
}

class BuildConstellationUseCase {
  const BuildConstellationUseCase(this._loadWatchlist);

  static const double toWatchWeight = 0.35;
  static const double watchingBaseWeight = 0.55;
  static const double watchingProgressWeight = 0.45;
  static const double completedWeight = 1;

  final LoadWatchlistUseCase _loadWatchlist;

  Stream<Constellation> call() => _loadWatchlist()
      .where((animes) => animes.every((anime) => !anime.isLoadingDetails))
      .map(_constellationOf);

  Constellation _constellationOf(List<Anime> animes) {
    if (animes.isNotEmpty && animes.every((anime) => anime.details == null)) {
      throw const ConstellationUnavailableException();
    }

    final counts = <String, int>{};
    final genres = <String, AnimeGenre>{};

    for (final anime in animes) {
      for (final genre in anime.details?.genres ?? const <AnimeGenre>[]) {
        counts.update(genre.slug, (count) => count + 1, ifAbsent: () => 1);
        genres.putIfAbsent(genre.slug, () => genre);
      }
    }

    final ordered = counts.keys.toList()
      ..sort((a, b) {
        final byCount = counts[b]!.compareTo(counts[a]!);

        return byCount != 0 ? byCount : a.compareTo(b);
      });
    final links = ConstellationLinksBuilder.build(animes);
    final points = ConstellationLayout.positions(
      animes.map((anime) => anime.id),
      links,
    );

    return Constellation(
      stars: [
        for (final anime in animes)
          if (points.containsKey(anime.id))
            _starOf(anime, points[anime.id]!, ordered),
      ],
      links: links,
      genres: [for (final slug in ordered) genres[slug]!],
    );
  }

  ConstellationStar _starOf(
    Anime anime,
    ConstellationPoint point,
    List<String> orderedSlugs,
  ) {
    final own = {
      for (final genre in anime.details?.genres ?? const <AnimeGenre>[])
        genre.slug,
    };
    final main = orderedSlugs.where(own.contains).firstOrNull;

    return ConstellationStar(
      animeId: anime.id,
      title: anime.title,
      status: anime.status,
      x: point.x,
      y: point.y,
      weight: weightOf(anime),
      genreSlug: main,
      posterUrl: anime.details?.posterUrl,
    );
  }

  static double weightOf(Anime anime) => switch (anime.status) {
    WatchStatus.toWatch => toWatchWeight,
    WatchStatus.completed => completedWeight,
    WatchStatus.watching =>
      watchingBaseWeight + watchingProgressWeight * (anime.progress ?? 0),
  };
}
