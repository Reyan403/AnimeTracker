import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:monapp/l10n/app_localizations.dart';
import 'package:monapp/layers/functional/Agenda/domain/entities/scheduled_release.dart';
import 'package:monapp/layers/functional/Agenda/domain/use_cases/load_release_agenda_use_case.dart';
import 'package:monapp/layers/functional/Agenda/presentation/cubit/agenda_cubit.dart';
import 'package:monapp/layers/functional/Agenda/presentation/cubit/agenda_state.dart';
import 'package:monapp/layers/functional/Agenda/presentation/release_countdown.dart';
import 'package:monapp/layers/functional/Agenda/presentation/widgets/agenda_results_sliver.dart';
import 'package:monapp/layers/functional/Agenda/presentation/widgets/release_card.dart';
import 'package:monapp/layers/functional/Anime/data/gateways/local_watchlist_gateway.dart';
import 'package:monapp/layers/functional/Anime/data/models/anime_details_dto.dart';
import 'package:monapp/layers/functional/Anime/domain/entities/anime_details.dart';
import 'package:monapp/layers/functional/Anime/domain/entities/watch_status.dart';
import 'package:monapp/layers/functional/Anime/domain/entities/watchlist_entry.dart';
import 'package:monapp/layers/functional/Anime/domain/use_cases/load_watchlist_use_case.dart';

import '../../support/fake_details_gateway.dart';
import '../../support/fake_watchlist_store.dart';
import '../../support/pump_app.dart';

final now = DateTime(2026, 10, 5, 12);

AnimeDetails airing(DateTime? release) => AnimeDetails(
      format: 'TV',
      year: 2026,
      episodeCount: 12,
      nextRelease: release,
    );

LoadReleaseAgendaUseCase agendaOf(
  List<WatchlistEntry> entries,
  Map<int, AnimeDetails> details, {
  bool fails = false,
}) =>
    LoadReleaseAgendaUseCase(
      LoadWatchlistUseCase(
        FakeDetailsGateway(details, fails: fails),
        LocalWatchlistGateway(FakeWatchlistStore(entries), const []),
      ),
      clock: () => now,
    );

ScheduledRelease releaseIn(int days) => ScheduledRelease(
      animeId: 1,
      title: 'Monster',
      releaseAt: now.add(Duration(days: days)),
      nextEpisodeToWatch: 4,
    );

void main() {
  group('LoadReleaseAgendaUseCase', () {
    test('trie les sorties par date et ignore terminés et sans date',
        () async {
      final agenda = await agendaOf(
        const [
          WatchlistEntry(id: 1, title: 'Loin', status: WatchStatus.watching),
          WatchlistEntry(id: 2, title: 'Proche', status: WatchStatus.toWatch),
          WatchlistEntry(
            id: 3,
            title: 'Fini',
            status: WatchStatus.completed,
          ),
          WatchlistEntry(id: 4, title: 'Sans date', status: WatchStatus.watching),
        ],
        {
          1: airing(now.add(const Duration(days: 6))),
          2: airing(now.add(const Duration(days: 1))),
          3: airing(now.add(const Duration(days: 2))),
          4: airing(null),
        },
      )().first;

      expect(agenda.map((release) => release.title), ['Proche', 'Loin']);
    });

    test('masque les sorties périmées', () async {
      final agenda = await agendaOf(
        const [
          WatchlistEntry(id: 1, title: 'Vieux', status: WatchStatus.watching),
        ],
        {1: airing(now.subtract(const Duration(days: 30)))},
      )().first;

      expect(agenda, isEmpty);
    });

    test('indique le prochain épisode à voir', () async {
      final agenda = await agendaOf(
        const [
          WatchlistEntry(
            id: 1,
            title: 'A',
            status: WatchStatus.watching,
            episodesWatched: 4,
          ),
        ],
        {1: airing(now.add(const Duration(days: 1)))},
      )().first;

      expect(agenda.single.nextEpisodeToWatch, 5);
    });

    test('échoue quand aucun détail n est disponible', () async {
      final stream = agendaOf(
        const [
          WatchlistEntry(id: 1, title: 'A', status: WatchStatus.watching),
        ],
        const {},
        fails: true,
      )();

      expect(stream, emitsError(isA<ReleaseAgendaUnavailableException>()));
    });

    test('la liste vide donne un agenda vide', () async {
      expect(await agendaOf(const [], const {})().first, isEmpty);
    });

    test('exception lisible', () {
      expect(
        const ReleaseAgendaUnavailableException().toString(),
        contains('unavailable'),
      );
    });
  });

  group('AgendaCubit', () {
    test('passe de chargement à succès puis vide', () async {
      final cubit = AgendaCubit(
        agendaOf(
          const [
            WatchlistEntry(id: 1, title: 'A', status: WatchStatus.watching),
          ],
          {1: airing(now.add(const Duration(days: 1)))},
        ),
      );
      addTearDown(cubit.close);

      expect(cubit.state.status, AgendaStatus.loading);

      await cubit.load();
      await Future<void>.delayed(Duration.zero);

      expect(cubit.state.status, AgendaStatus.success);
    });

    test('signale un agenda vide', () async {
      final cubit = AgendaCubit(agendaOf(const [], const {}));
      addTearDown(cubit.close);

      await cubit.load();
      await Future<void>.delayed(Duration.zero);

      expect(cubit.state.status, AgendaStatus.empty);
    });

    test('signale une erreur', () async {
      final cubit = AgendaCubit(
        agendaOf(
          const [
            WatchlistEntry(id: 1, title: 'A', status: WatchStatus.watching),
          ],
          const {},
          fails: true,
        ),
      );
      addTearDown(cubit.close);

      await cubit.load();
      await Future<void>.delayed(Duration.zero);

      expect(cubit.state.status, AgendaStatus.failure);
    });
  });

  group('ScheduledRelease', () {
    test('compte les jours calendaires', () {
      expect(releaseIn(0).daysUntil(now), 0);
      expect(releaseIn(1).daysUntil(now), 1);
      expect(releaseIn(5).daysUntil(now), 5);
      expect(releaseIn(-1).daysUntil(now), -1);
    });
  });

  group('AnimeDetailsDto', () {
    test('lit la prochaine sortie', () {
      final details = AnimeDetailsDto.fromJson({
        'data': [
          {
            'id': '7',
            'attributes': {
              'subtype': 'TV',
              'startDate': '2026-01-01',
              'episodeCount': 12,
              'nextRelease': '2026-10-08T15:00:00.000Z',
            },
          },
        ],
      });

      expect(details[7]?.nextRelease, DateTime.utc(2026, 10, 8, 15));
    });

    test('tolère l absence de prochaine sortie', () {
      final details = AnimeDetailsDto.fromJson({
        'data': [
          {
            'id': '7',
            'attributes': {'subtype': 'TV'},
          },
        ],
      });

      expect(details[7]?.nextRelease, isNull);
    });
  });

  group('releaseCountdown', () {
    late AppLocalizations l10n;

    setUp(() async {
      l10n = await AppLocalizations.delegate.load(const Locale('fr'));
    });

    test('formule chaque cas', () {
      expect(releaseCountdown(l10n, releaseIn(0), now), 'Aujourd\'hui');
      expect(releaseCountdown(l10n, releaseIn(1), now), 'Demain');
      expect(releaseCountdown(l10n, releaseIn(4), now), 'Dans 4 jours');
      expect(releaseCountdown(l10n, releaseIn(-1), now), 'Hier');
      expect(releaseCountdown(l10n, releaseIn(-3), now), 'Il y a 3 jours');
    });
  });

  group('écran', () {
    testWidgets('la carte affiche compte à rebours, titre et épisode',
        (tester) async {
      var opened = false;

      await pumpApp(
        tester,
        ReleaseCard(
          release: releaseIn(1),
          now: now,
          onTap: () => opened = true,
        ),
      );

      expect(find.text('Demain'), findsOneWidget);
      expect(find.text('Monster'), findsOneWidget);
      expect(find.text('Prochain à voir : épisode 4'), findsOneWidget);

      await tester.tap(find.text('Monster'));

      expect(opened, isTrue);
    });

    for (final entry in {
      AgendaStatus.empty: 'Aucune sortie à venir.',
      AgendaStatus.failure: 'Impossible de charger l\'agenda',
    }.entries) {
      testWidgets('affiche l état ${entry.key.name}', (tester) async {
        await pumpApp(
          tester,
          CustomScrollView(
            slivers: [
              AgendaResultsSliver(
                state: AgendaState(status: entry.key),
                now: now,
                onRetry: () {},
                onAnimeSelected: (_, _) {},
              ),
            ],
          ),
        );

        expect(find.text(entry.value), findsOneWidget);
      });
    }

    testWidgets('affiche le chargement puis la liste', (tester) async {
      await pumpApp(
        tester,
        CustomScrollView(
          slivers: [
            AgendaResultsSliver(
              state: const AgendaState(),
              now: now,
              onRetry: () {},
              onAnimeSelected: (_, _) {},
            ),
          ],
        ),
        settle: false,
      );

      expect(find.byType(Card), findsWidgets);

      int? opened;

      await pumpApp(
        tester,
        CustomScrollView(
          slivers: [
            AgendaResultsSliver(
              state: AgendaState(
                status: AgendaStatus.success,
                releases: [releaseIn(2)],
              ),
              now: now,
              onRetry: () {},
              onAnimeSelected: (id, _) => opened = id,
            ),
          ],
        ),
      );
      await tester.tap(find.text('Monster'));

      expect(opened, 1);
      expect(find.text('Dans 2 jours'), findsOneWidget);
    });

    testWidgets('réessayer relance le chargement', (tester) async {
      var retried = false;

      await pumpApp(
        tester,
        CustomScrollView(
          slivers: [
            AgendaResultsSliver(
              state: const AgendaState(status: AgendaStatus.failure),
              now: now,
              onRetry: () => retried = true,
              onAnimeSelected: (_, _) {},
            ),
          ],
        ),
      );
      await tester.tap(find.text('Réessayer'));

      expect(retried, isTrue);
    });
  });
}
