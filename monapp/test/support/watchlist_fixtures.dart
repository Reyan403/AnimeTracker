import 'package:monapp/layers/functional/Anime/data/gateways/local_watchlist_gateway.dart';
import 'package:monapp/layers/functional/Anime/domain/entities/anime_details.dart';
import 'package:monapp/layers/functional/Anime/domain/entities/anime_genre.dart';
import 'package:monapp/layers/functional/Anime/domain/entities/watchlist_entry.dart';
import 'package:monapp/layers/functional/Anime/domain/use_cases/load_watchlist_use_case.dart';

import 'fake_caches.dart';
import 'fake_details_gateway.dart';
import 'fake_watchlist_store.dart';

AnimeGenre genre(String slug, [String? title]) =>
    AnimeGenre(slug: slug, title: title ?? slug);

AnimeDetails detailsOf({
  int minutes = 24,
  int episodes = 12,
  List<String> genres = const [],
  int? malId,
  DateTime? nextRelease,
}) =>
    AnimeDetails(
      format: 'TV',
      year: 2020,
      episodeCount: episodes,
      episodeMinutes: minutes,
      genres: [for (final slug in genres) genre(slug)],
      malId: malId,
      nextRelease: nextRelease,
    );

LoadWatchlistUseCase watchlistOf(
  List<WatchlistEntry> entries,
  Map<int, AnimeDetails> details, {
  bool fails = false,
  FakeDetailsCache? cache,
}) =>
    LoadWatchlistUseCase(
      FakeDetailsGateway(details, fails: fails),
      LocalWatchlistGateway(FakeWatchlistStore(entries), const []),
      cache ?? FakeDetailsCache(),
    );
