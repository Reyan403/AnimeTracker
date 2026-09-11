import 'package:flutter_test/flutter_test.dart';
import 'package:monapp/layers/functional/Anime/domain/entities/anime.dart';
import 'package:monapp/layers/functional/Anime/domain/entities/anime_details.dart';
import 'package:monapp/layers/functional/Anime/domain/entities/watch_status.dart';
import 'package:monapp/layers/functional/Anime/domain/entities/watchlist_entry.dart';
import 'package:monapp/layers/functional/Anime/domain/use_cases/load_watchlist_use_case.dart';

import 'counting_anime_details_gateway.dart';
import 'fake_anime_details_gateway.dart';

const entries = [
  WatchlistEntry(id: 1, title: 'Cowboy Bebop', status: WatchStatus.toWatch),
  WatchlistEntry(id: 2, title: 'Introuvable', status: WatchStatus.watching),
];

const bebop = AnimeDetails(format: 'Série TV', year: 1998, episodeCount: 26);

Stream<List<Anime>> watchlistOf(FakeAnimeDetailsGateway gateway) =>
    LoadWatchlistUseCase(gateway)(entries);

void main() {
  test('it shows every entry at once, before the details answer', () async {
    final shown = await watchlistOf(const FakeAnimeDetailsGateway({})).first;

    expect(shown.map((anime) => anime.title), ['Cowboy Bebop', 'Introuvable']);
    expect(shown.every((anime) => anime.isLoadingDetails), isTrue);
  });

  test('it keeps the local title and status of every entry', () async {
    final animes =
        await watchlistOf(const FakeAnimeDetailsGateway({1: bebop})).last;

    expect(animes.map((anime) => anime.title), ['Cowboy Bebop', 'Introuvable']);
    expect(animes.map((anime) => anime.status),
        [WatchStatus.toWatch, WatchStatus.watching]);
  });

  test('it fills the details fetched from the gateway', () async {
    final animes =
        await watchlistOf(const FakeAnimeDetailsGateway({1: bebop})).last;

    expect(animes.first.details?.format, 'Série TV');
    expect(animes.first.details?.episodeCount, 26);
    expect(animes.first.isLoadingDetails, isFalse);
  });

  test('an entry the API ignores still comes back, without details', () async {
    final animes =
        await watchlistOf(const FakeAnimeDetailsGateway({1: bebop})).last;

    expect(animes.last.title, 'Introuvable');
    expect(animes.last.details, isNull);
  });

  test('an unreachable service leaves every entry without details', () async {
    final animes = await watchlistOf(
      const FakeAnimeDetailsGateway({1: bebop}, isDown: true),
    ).last;

    expect(animes.map((anime) => anime.title), ['Cowboy Bebop', 'Introuvable']);
    expect(animes.every((anime) => anime.details == null), isTrue);
  });

  test('it asks the API once for the whole list', () async {
    final gateway = CountingAnimeDetailsGateway(
      bebop,
      answerDelay: const Duration(milliseconds: 5),
    );

    await LoadWatchlistUseCase(gateway)(entries).last;

    expect(gateway.requests, 1);
  });
}
