import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:monapp/layers/functional/Anime/data/gateways/local_watchlist_gateway.dart';
import 'package:monapp/layers/functional/Anime/data/models/watchlist_entry_dto.dart';
import 'package:monapp/layers/functional/Anime/domain/entities/anime.dart';
import 'package:monapp/layers/functional/Anime/domain/entities/anime_details.dart';
import 'package:monapp/layers/functional/Anime/domain/entities/watch_status.dart';
import 'package:monapp/layers/functional/Anime/domain/entities/watchlist_entry.dart';
import 'package:monapp/layers/functional/Anime/domain/use_cases/watch_next_episode_use_case.dart';
import 'package:monapp/layers/functional/Anime/domain/use_cases/watch_previous_episode_use_case.dart';
import 'package:monapp/layers/functional/Anime/presentation/widgets/episode_progress.dart';

import '../../../support/fake_watchlist_store.dart';
import '../../../support/pump_app.dart';

LocalWatchlistGateway gatewayWith(WatchlistEntry entry) =>
    LocalWatchlistGateway(FakeWatchlistStore([entry]), const []);

WatchlistEntry only(LocalWatchlistGateway gateway) => gateway.entries.single;

void main() {
  group('WatchNextEpisodeUseCase', () {
    test('démarre un anime à voir', () {
      final gateway = gatewayWith(
        const WatchlistEntry(id: 1, title: 'A', status: WatchStatus.toWatch),
      );

      WatchNextEpisodeUseCase(gateway)(1, totalEpisodes: 12);

      expect(only(gateway).episodesWatched, 1);
      expect(only(gateway).status, WatchStatus.watching);
    });

    test('termine l anime au dernier épisode', () {
      final gateway = gatewayWith(
        const WatchlistEntry(
          id: 1,
          title: 'A',
          status: WatchStatus.watching,
          episodesWatched: 11,
        ),
      );

      WatchNextEpisodeUseCase(gateway)(1, totalEpisodes: 12);

      expect(only(gateway).episodesWatched, 12);
      expect(only(gateway).status, WatchStatus.completed);
    });

    test('ne dépasse pas le total', () {
      final gateway = gatewayWith(
        const WatchlistEntry(
          id: 1,
          title: 'A',
          status: WatchStatus.completed,
          episodesWatched: 12,
        ),
      );

      WatchNextEpisodeUseCase(gateway)(1, totalEpisodes: 12);

      expect(only(gateway).episodesWatched, 12);
    });

    test('ne termine jamais seul sans total connu', () {
      final gateway = gatewayWith(
        const WatchlistEntry(
          id: 1,
          title: 'A',
          status: WatchStatus.watching,
          episodesWatched: 99,
        ),
      );

      WatchNextEpisodeUseCase(gateway)(1, totalEpisodes: 0);

      expect(only(gateway).episodesWatched, 100);
      expect(only(gateway).status, WatchStatus.watching);
    });

    test('ignore un anime absent de la liste', () {
      final gateway = gatewayWith(
        const WatchlistEntry(id: 1, title: 'A', status: WatchStatus.toWatch),
      );

      WatchNextEpisodeUseCase(gateway)(99, totalEpisodes: 12);

      expect(only(gateway).episodesWatched, 0);
    });
  });

  group('WatchPreviousEpisodeUseCase', () {
    test('annule le dernier épisode', () {
      final gateway = gatewayWith(
        const WatchlistEntry(
          id: 1,
          title: 'A',
          status: WatchStatus.watching,
          episodesWatched: 5,
        ),
      );

      WatchPreviousEpisodeUseCase(gateway)(1, totalEpisodes: 12);

      expect(only(gateway).episodesWatched, 4);
      expect(only(gateway).status, WatchStatus.watching);
    });

    test('repasse à voir quand plus aucun épisode n est vu', () {
      final gateway = gatewayWith(
        const WatchlistEntry(
          id: 1,
          title: 'A',
          status: WatchStatus.watching,
          episodesWatched: 1,
        ),
      );

      WatchPreviousEpisodeUseCase(gateway)(1, totalEpisodes: 12);

      expect(only(gateway).episodesWatched, 0);
      expect(only(gateway).status, WatchStatus.toWatch);
    });

    test('rouvre un anime terminé à l avant-dernier épisode', () {
      final gateway = gatewayWith(
        const WatchlistEntry(id: 1, title: 'A', status: WatchStatus.completed),
      );

      WatchPreviousEpisodeUseCase(gateway)(1, totalEpisodes: 12);

      expect(only(gateway).episodesWatched, 11);
      expect(only(gateway).status, WatchStatus.watching);
    });

    test('ne descend pas sous zéro', () {
      final gateway = gatewayWith(
        const WatchlistEntry(id: 1, title: 'A', status: WatchStatus.toWatch),
      );

      WatchPreviousEpisodeUseCase(gateway)(1, totalEpisodes: 12);

      expect(only(gateway).episodesWatched, 0);
    });

    test('ignore un anime absent de la liste', () {
      final gateway = gatewayWith(
        const WatchlistEntry(
          id: 1,
          title: 'A',
          status: WatchStatus.watching,
          episodesWatched: 3,
        ),
      );

      WatchPreviousEpisodeUseCase(gateway)(99, totalEpisodes: 12);

      expect(only(gateway).episodesWatched, 3);
    });
  });

  test('la progression est conservée par l encodage', () {
    final decoded = WatchlistEntryDto.decode(
      WatchlistEntryDto.encode(const [
        WatchlistEntry(
          id: 1,
          title: 'A',
          status: WatchStatus.watching,
          episodesWatched: 7,
        ),
      ]),
    )!;

    expect(decoded.single.episodesWatched, 7);
  });

  test('un ancien enregistrement sans progression vaut zéro', () {
    final decoded = WatchlistEntryDto.decode(
      '[{"id":1,"title":"A","status":"watching"}]',
    )!;

    expect(decoded.single.episodesWatched, 0);
  });

  test('le gateway ignore la mise à jour d un anime absent', () {
    final store = FakeWatchlistStore([
      const WatchlistEntry(id: 1, title: 'A', status: WatchStatus.toWatch),
    ]);
    final gateway = LocalWatchlistGateway(store, const []);

    gateway.update(
      const WatchlistEntry(id: 9, title: 'Z', status: WatchStatus.watching),
    );

    expect(store.writes, 0);
  });

  group('EpisodeProgress', () {
    const details = AnimeDetails(format: 'TV', year: 2020, episodeCount: 12);

    testWidgets('affiche la progression et réagit aux boutons',
        (tester) async {
      var next = 0;
      var previous = 0;

      await pumpApp(
        tester,
        EpisodeProgress(
          anime: const Anime(
            id: 1,
            title: 'A',
            status: WatchStatus.watching,
            episodesWatched: 3,
            details: details,
          ),
          onNext: () => next++,
          onPrevious: () => previous++,
        ),
      );

      expect(find.text('3/12 épisodes vus'), findsOneWidget);
      expect(find.byType(LinearProgressIndicator), findsOneWidget);

      await tester.tap(find.byIcon(Icons.add));
      await tester.tap(find.byIcon(Icons.remove));

      expect(next, 1);
      expect(previous, 1);
    });

    testWidgets('sans total connu, pas de barre', (tester) async {
      await pumpApp(
        tester,
        EpisodeProgress(
          anime: const Anime(
            id: 1,
            title: 'A',
            status: WatchStatus.watching,
            episodesWatched: 2,
          ),
          onNext: () {},
          onPrevious: () {},
        ),
      );

      expect(find.text('2 épisodes vus'), findsOneWidget);
      expect(find.byType(LinearProgressIndicator), findsNothing);
    });

    testWidgets('un anime terminé désactive le plus', (tester) async {
      await pumpApp(
        tester,
        EpisodeProgress(
          anime: const Anime(
            id: 1,
            title: 'A',
            status: WatchStatus.completed,
            episodesWatched: 12,
            details: details,
          ),
          onNext: () {},
          onPrevious: () {},
        ),
      );

      expect(
        tester
            .widget<IconButton>(
              find.ancestor(
                of: find.byIcon(Icons.add),
                matching: find.byType(IconButton),
              ),
            )
            .onPressed,
        isNull,
      );
    });

    testWidgets('un anime non commencé désactive le moins', (tester) async {
      await pumpApp(
        tester,
        EpisodeProgress(
          anime: const Anime(
            id: 1,
            title: 'A',
            status: WatchStatus.toWatch,
            details: details,
          ),
          onNext: () {},
          onPrevious: () {},
        ),
      );

      expect(find.text('0/12 épisodes vus'), findsOneWidget);
      expect(
        tester
            .widget<IconButton>(
              find.ancestor(
                of: find.byIcon(Icons.remove),
                matching: find.byType(IconButton),
              ),
            )
            .onPressed,
        isNull,
      );
    });
  });

  test('Anime calcule sa progression', () {
    const anime = Anime(
      id: 1,
      title: 'A',
      status: WatchStatus.watching,
      episodesWatched: 6,
      details: AnimeDetails(format: 'TV', year: 2020, episodeCount: 12),
    );

    expect(anime.progress, 0.5);
    expect(anime.isFinished, isFalse);
    expect(anime.totalEpisodes, 12);
  });
}
