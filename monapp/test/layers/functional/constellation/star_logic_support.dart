import 'package:monapp/layers/functional/Anime/domain/entities/anime_details.dart';
import 'package:monapp/layers/functional/Anime/domain/entities/watch_status.dart';
import 'package:monapp/layers/functional/Anime/domain/entities/watchlist_entry.dart';
import 'package:monapp/layers/functional/Constellation/domain/entities/constellation.dart';
import 'package:monapp/layers/functional/Constellation/domain/use_cases/build_constellation_use_case.dart';

import '../../../support/watchlist_fixtures.dart';

BuildConstellationUseCase useCaseOf(
  List<WatchlistEntry> entries,
  Map<int, AnimeDetails> details, {
  bool fails = false,
}) => BuildConstellationUseCase(watchlistOf(entries, details, fails: fails));

Future<Constellation> built(
  List<WatchlistEntry> entries,
  Map<int, AnimeDetails> details,
) => useCaseOf(entries, details)().first;

const entries = [
  WatchlistEntry(id: 1, title: 'Terminé', status: WatchStatus.completed),
  WatchlistEntry(
    id: 2,
    title: 'En cours',
    status: WatchStatus.watching,
    episodesWatched: 6,
  ),
  WatchlistEntry(id: 3, title: 'À voir', status: WatchStatus.toWatch),
];
