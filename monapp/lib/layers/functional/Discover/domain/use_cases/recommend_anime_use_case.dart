import '../../../Anime/domain/entities/anime.dart';
import '../../../Anime/domain/entities/anime_genre.dart';
import '../../../Anime/domain/entities/watch_status.dart';
import '../../../Anime/domain/use_cases/load_watchlist_use_case.dart';
import '../../../Catalogue/domain/entities/catalogue_anime.dart';
import '../entities/recommendation_set.dart';
import '../gateways/recommendation_gateway.dart';

class RecommendAnimeUseCase {
  const RecommendAnimeUseCase(this._loadWatchlist, this._gateway);

  static const int favouriteGenreCount = 2;
  static const int perGenre = 12;
  static const int maxRecommendations = 10;
  static const Map<WatchStatus, int> _weights = {
    WatchStatus.completed: 3,
    WatchStatus.watching: 2,
  };

  final LoadWatchlistUseCase _loadWatchlist;
  final RecommendationGateway _gateway;

  Future<RecommendationSet> call() async {
    final animes = await _loadWatchlist()
        .firstWhere((list) => list.every((anime) => !anime.isLoadingDetails));

    if (animes.isNotEmpty && animes.every((anime) => anime.details == null)) {
      throw const RecommendationsUnavailableException();
    }

    final favourites = _favouriteGenres(animes);

    if (favourites.isEmpty) {
      return RecommendationSet.none;
    }

    final listed = {for (final anime in animes) anime.id};
    final fetched = await _fetch(favourites);

    return RecommendationSet(
      basedOn: favourites,
      animes: _ranked(fetched, listed),
    );
  }

  static List<AnimeGenre> _favouriteGenres(List<Anime> animes) {
    final scores = <String, int>{};
    final genres = <String, AnimeGenre>{};

    for (final anime in animes) {
      final weight = _weights[anime.status];

      if (weight == null) {
        continue;
      }

      for (final genre in anime.details?.genres ?? const <AnimeGenre>[]) {
        scores.update(genre.slug, (score) => score + weight,
            ifAbsent: () => weight);
        genres[genre.slug] = genre;
      }
    }

    final ordered = scores.keys.toList()
      ..sort((a, b) {
        final byScore = scores[b]!.compareTo(scores[a]!);

        return byScore != 0 ? byScore : a.compareTo(b);
      });

    return [for (final slug in ordered.take(favouriteGenreCount)) genres[slug]!];
  }

  Future<List<List<CatalogueAnime>>> _fetch(List<AnimeGenre> genres) async {
    final lists = <List<CatalogueAnime>>[];

    for (final genre in genres) {
      try {
        lists.add(await _gateway.findAcclaimedByGenre(genre.slug, perGenre));
      } on RecommendationsUnavailableException {
        continue;
      }
    }

    if (lists.isEmpty) {
      throw const RecommendationsUnavailableException();
    }

    return lists;
  }

  static List<CatalogueAnime> _ranked(
    List<List<CatalogueAnime>> lists,
    Set<int> listed,
  ) {
    final matches = <int, int>{};
    final order = <int, int>{};
    final byId = <int, CatalogueAnime>{};

    for (final list in lists) {
      for (var index = 0; index < list.length; index++) {
        final anime = list[index];

        if (listed.contains(anime.id)) {
          continue;
        }

        matches.update(anime.id, (count) => count + 1, ifAbsent: () => 1);
        order.update(anime.id, (rank) => rank < index ? rank : index,
            ifAbsent: () => index);
        byId[anime.id] = anime;
      }
    }

    final ids = byId.keys.toList()
      ..sort((a, b) {
        final byMatches = matches[b]!.compareTo(matches[a]!);

        return byMatches != 0 ? byMatches : order[a]!.compareTo(order[b]!);
      });

    return [for (final id in ids.take(maxRecommendations)) byId[id]!];
  }
}
