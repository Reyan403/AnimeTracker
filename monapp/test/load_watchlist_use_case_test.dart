import 'package:flutter_test/flutter_test.dart';
import 'package:monapp/layers/functional/Anime/domain/entities/anime_details.dart';
import 'package:monapp/layers/functional/Anime/domain/entities/watch_status.dart';
import 'package:monapp/layers/functional/Anime/domain/entities/watchlist_entry.dart';
import 'package:monapp/layers/functional/Anime/domain/use_cases/load_watchlist_use_case.dart';

import 'counting_anime_details_gateway.dart';
import 'fake_anime_details_gateway.dart';

const entries = [
  WatchlistEntry(malId: 1, title: 'Cowboy Bebop', status: WatchStatus.toWatch),
  WatchlistEntry(malId: 2, title: 'Introuvable', status: WatchStatus.watching),
];

const bebop = AnimeDetails(studio: 'Sunrise', year: 1998, episodeCount: 26);

void main() {
  test('it keeps the local title and status of every entry', () async {
    const useCase = LoadWatchlistUseCase(FakeAnimeDetailsGateway({1: bebop}));

    final animes = await useCase(entries);

    expect(animes.map((anime) => anime.title), ['Cowboy Bebop', 'Introuvable']);
    expect(animes.map((anime) => anime.status),
        [WatchStatus.toWatch, WatchStatus.watching]);
  });

  test('it fills the details fetched from the gateway', () async {
    const useCase = LoadWatchlistUseCase(FakeAnimeDetailsGateway({1: bebop}));

    final animes = await useCase(entries);

    expect(animes.first.details?.studio, 'Sunrise');
    expect(animes.first.details?.episodeCount, 26);
  });

  test('an entry whose lookup fails still comes back, without details',
      () async {
    const useCase = LoadWatchlistUseCase(FakeAnimeDetailsGateway({1: bebop}));

    final animes = await useCase(entries);

    expect(animes.last.title, 'Introuvable');
    expect(animes.last.details, isNull);
  });

  test('it asks for every entry at once instead of one after another',
      () async {
    final gateway = CountingAnimeDetailsGateway(
      bebop,
      answerDelay: const Duration(milliseconds: 20),
    );

    await LoadWatchlistUseCase(gateway)(entries);

    expect(gateway.mostPendingAtOnce, entries.length);
  });

  test('the animes come back in the order of the list', () async {
    final gateway = CountingAnimeDetailsGateway(
      bebop,
      answerDelay: const Duration(milliseconds: 5),
    );

    final animes = await LoadWatchlistUseCase(gateway)(entries);

    expect(animes.map((anime) => anime.title), ['Cowboy Bebop', 'Introuvable']);
  });
}
