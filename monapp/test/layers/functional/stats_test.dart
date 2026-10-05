import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:monapp/layers/functional/Anime/domain/entities/anime_genre.dart';
import 'package:monapp/layers/functional/Anime/domain/entities/watch_status.dart';
import 'package:monapp/layers/functional/Anime/domain/entities/watchlist_entry.dart';
import 'package:monapp/layers/functional/Stats/domain/entities/watch_stats.dart';
import 'package:monapp/layers/functional/Stats/domain/use_cases/compute_watch_stats_use_case.dart';
import 'package:monapp/layers/functional/Stats/presentation/cubit/stats_cubit.dart';
import 'package:monapp/layers/functional/Stats/presentation/cubit/stats_state.dart';
import 'package:monapp/layers/functional/Stats/presentation/widgets/stats_content.dart';

import '../../support/pump_app.dart';
import '../../support/watchlist_fixtures.dart';

const entries = [
  WatchlistEntry(
    id: 1,
    title: 'Terminé',
    status: WatchStatus.completed,
  ),
  WatchlistEntry(
    id: 2,
    title: 'En cours',
    status: WatchStatus.watching,
    episodesWatched: 4,
  ),
  WatchlistEntry(id: 3, title: 'À voir', status: WatchStatus.toWatch),
];

ComputeWatchStatsUseCase useCase({
  List<WatchlistEntry> list = entries,
  bool fails = false,
}) =>
    ComputeWatchStatsUseCase(
      watchlistOf(
        list,
        {
          1: detailsOf(minutes: 20, episodes: 10, genres: ['action', 'drama']),
          2: detailsOf(minutes: 30, episodes: 12, genres: ['action']),
          3: detailsOf(minutes: 25, episodes: 12, genres: ['horror']),
        },
        fails: fails,
      ),
    );

void main() {
  group('ComputeWatchStatsUseCase', () {
    test('additionne épisodes et minutes, terminé compris', () async {
      final stats = await useCase()().first;

      expect(stats.episodesWatched, 14);
      expect(stats.minutesWatched, 10 * 20 + 4 * 30);
      expect(stats.hoursWatched, 5);
    });

    test('compte les animes par statut', () async {
      final stats = await useCase()().first;

      expect(stats.toWatchCount, 1);
      expect(stats.watchingCount, 1);
      expect(stats.completedCount, 1);
      expect(stats.animeCount, 3);
    });

    test('classe les genres sans compter les animes à voir', () async {
      final stats = await useCase()().first;

      expect(stats.topGenres.first.genre.slug, 'action');
      expect(stats.topGenres.first.count, 2);
      expect(stats.topGenres.map((share) => share.genre.slug), isNot(contains('horror')));
    });

    test('limite aux cinq premiers genres', () async {
      final many = ComputeWatchStatsUseCase(
        watchlistOf(
          const [
            WatchlistEntry(id: 1, title: 'A', status: WatchStatus.completed),
          ],
          {
            1: detailsOf(
              genres: ['a', 'b', 'c', 'd', 'e', 'f', 'g'],
            ),
          },
        ),
      );

      expect((await many().first).topGenres.length, 5);
    });

    test('une liste vide donne des statistiques vides', () async {
      final stats = await useCase(list: const [])().first;

      expect(stats.isEmpty, isTrue);
    });

    test('échoue sans aucun détail', () {
      expect(
        useCase(fails: true)(),
        emitsError(isA<WatchStatsUnavailableException>()),
      );
    });

    test('exception lisible', () {
      expect(
        const WatchStatsUnavailableException().toString(),
        contains('unavailable'),
      );
    });
  });

  group('StatsCubit', () {
    StatsCubit cubitOf(ComputeWatchStatsUseCase useCase) {
      final cubit = StatsCubit(useCase);
      addTearDown(cubit.close);

      return cubit;
    }

    test('charge les statistiques', () async {
      final cubit = cubitOf(useCase());

      expect(cubit.state.status, StatsStatus.loading);

      await cubit.load();
      await Future<void>.delayed(Duration.zero);

      expect(cubit.state.status, StatsStatus.success);
      expect(cubit.state.stats?.completedCount, 1);
    });

    test('signale une liste vide', () async {
      final cubit = cubitOf(useCase(list: const []));

      await cubit.load();
      await Future<void>.delayed(Duration.zero);

      expect(cubit.state.status, StatsStatus.empty);
    });

    test('signale une erreur', () async {
      final cubit = cubitOf(useCase(fails: true));

      await cubit.load();
      await Future<void>.delayed(Duration.zero);

      expect(cubit.state.status, StatsStatus.failure);
    });
  });

  group('StatsContent', () {
    const stats = WatchStats(
      minutesWatched: 7500,
      episodesWatched: 312,
      toWatchCount: 3,
      watchingCount: 2,
      completedCount: 9,
      topGenres: [
        GenreShare(
          genre: AnimeGenre(slug: 'action', title: 'Action'),
          count: 6,
        ),
        GenreShare(
          genre: AnimeGenre(slug: 'drama', title: 'Drama'),
          count: 3,
        ),
      ],
    );

    testWidgets('affiche chiffres, répartition et genres', (tester) async {
      await pumpApp(
        tester,
        const SingleChildScrollView(
          child: StatsContent(
            state: StatsState(status: StatsStatus.success, stats: stats),
            onRetry: _noop,
          ),
        ),
        size: const Size(500, 1200),
      );
      await tester.pumpAndSettle(const Duration(seconds: 2));

      expect(find.text('125 h'), findsOneWidget);
      expect(find.text('312'), findsOneWidget);
      expect(find.text('9'), findsWidgets);
      expect(find.text('Genres favoris'), findsOneWidget);
      expect(find.text('Action'), findsOneWidget);
      expect(find.text('Drame'), findsOneWidget);
      expect(find.text('Terminé · 9'), findsOneWidget);
    });

    testWidgets('sans genre, la carte genres est absente', (tester) async {
      await pumpApp(
        tester,
        const SingleChildScrollView(
          child: StatsContent(
            state: StatsState(
              status: StatsStatus.success,
              stats: WatchStats(
                minutesWatched: 0,
                episodesWatched: 0,
                toWatchCount: 1,
                watchingCount: 0,
                completedCount: 0,
                topGenres: [],
              ),
            ),
            onRetry: _noop,
          ),
        ),
        size: const Size(500, 1200),
      );

      expect(find.text('Genres favoris'), findsNothing);
    });

    testWidgets('affiche les états chargement, vide et erreur',
        (tester) async {
      var retried = false;

      await pumpApp(
        tester,
        const StatsContent(state: StatsState(), onRetry: _noop),
        settle: false,
      );
      expect(find.byType(Card), findsWidgets);

      await pumpApp(
        tester,
        const StatsContent(
          state: StatsState(status: StatsStatus.empty),
          onRetry: _noop,
        ),
      );
      expect(find.text('Rien à compter pour l\'instant.'), findsOneWidget);

      await pumpApp(
        tester,
        StatsContent(
          state: const StatsState(status: StatsStatus.failure),
          onRetry: () => retried = true,
        ),
      );
      await tester.tap(find.text('Réessayer'));

      expect(retried, isTrue);
    });

    testWidgets('fournit un cubit via BlocProvider sans erreur',
        (tester) async {
      final cubit = StatsCubit(useCase());
      addTearDown(cubit.close);

      await pumpApp(
        tester,
        BlocProvider.value(
          value: cubit,
          child: BlocBuilder<StatsCubit, StatsState>(
            builder: (context, state) => Text(state.status.name),
          ),
        ),
      );

      expect(find.text('loading'), findsOneWidget);
    });

    test('hoursWatched arrondit à l heure inférieure', () {
      expect(
        const WatchStats(
          minutesWatched: 119,
          episodesWatched: 0,
          toWatchCount: 0,
          watchingCount: 0,
          completedCount: 0,
          topGenres: [],
        ).hoursWatched,
        1,
      );
    });
  });
}

void _noop() {}
