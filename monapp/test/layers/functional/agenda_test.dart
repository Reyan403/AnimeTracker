import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:monapp/l10n/app_localizations.dart';
import 'package:monapp/layers/functional/Agenda/data/gateways/anilist_release_schedule_gateway.dart';
import 'package:monapp/layers/functional/Agenda/data/models/upcoming_episode_dto.dart';
import 'package:monapp/layers/functional/Agenda/domain/entities/scheduled_release.dart';
import 'package:monapp/layers/functional/Agenda/domain/entities/upcoming_episode.dart';
import 'package:monapp/layers/functional/Agenda/domain/gateways/release_schedule_gateway.dart';
import 'package:monapp/layers/functional/Agenda/domain/use_cases/load_release_agenda_use_case.dart';
import 'package:monapp/layers/functional/Agenda/presentation/cubit/agenda_cubit.dart';
import 'package:monapp/layers/functional/Agenda/presentation/cubit/agenda_state.dart';
import 'package:monapp/layers/functional/Agenda/presentation/release_countdown.dart';
import 'package:monapp/layers/functional/Agenda/presentation/widgets/agenda_filter.dart';
import 'package:monapp/layers/functional/Agenda/presentation/widgets/agenda_results_sliver.dart';
import 'package:monapp/layers/functional/Agenda/presentation/widgets/release_card.dart';
import 'package:monapp/layers/functional/Anime/data/models/anime_details_dto.dart';
import 'package:monapp/layers/functional/Anime/domain/entities/watch_status.dart';
import 'package:monapp/layers/functional/Anime/domain/entities/watchlist_entry.dart';
import 'package:monapp/layers/technical/AniListApi/anilist_client.dart';

import '../../support/pump_app.dart';
import '../../support/watchlist_fixtures.dart';

final now = DateTime.utc(2026, 10, 5, 12);

UpcomingEpisode episodeOf(
  String title, {
  required int days,
  int? malId,
  int episode = 3,
}) =>
    UpcomingEpisode(
      title: title,
      episode: episode,
      airingAt: now.add(Duration(days: days)),
      malId: malId,
      coverUrl: 'https://example.invalid/$title.jpg',
    );

class FakeScheduleGateway implements ReleaseScheduleGateway {
  FakeScheduleGateway({
    this.listed = const [],
    this.popular = const [],
    this.fails = false,
  });

  final List<UpcomingEpisode> listed;
  final List<UpcomingEpisode> popular;
  final bool fails;
  int popularCalls = 0;
  List<int> requestedMalIds = const [];

  @override
  Future<List<UpcomingEpisode>> findForMalIds(List<int> malIds) async {
    requestedMalIds = malIds;

    if (fails) {
      throw const ReleaseScheduleUnavailableException();
    }

    return listed;
  }

  @override
  Future<List<UpcomingEpisode>> findPopularAiring() async {
    popularCalls++;

    if (fails) {
      throw const ReleaseScheduleUnavailableException();
    }

    return popular;
  }
}

const entries = [
  WatchlistEntry(id: 1, title: 'En cours', status: WatchStatus.watching),
  WatchlistEntry(id: 2, title: 'À voir', status: WatchStatus.toWatch),
  WatchlistEntry(id: 3, title: 'Fini', status: WatchStatus.completed),
];

LoadReleaseAgendaUseCase agendaOf(
  FakeScheduleGateway schedule, {
  List<WatchlistEntry> list = entries,
  bool detailsFail = false,
  DateTime? kitsuRelease,
}) =>
    LoadReleaseAgendaUseCase(
      watchlistOf(
        list,
        {
          1: detailsOf(malId: 100, nextRelease: kitsuRelease),
          2: detailsOf(malId: 200),
          3: detailsOf(malId: 300),
        },
        fails: detailsFail,
      ),
      schedule,
      clock: () => now,
    );

Future<List<ScheduledRelease>> firstAgenda(LoadReleaseAgendaUseCase useCase) =>
    useCase().first;

ScheduledRelease releaseIn(int days, {int? animeId = 1}) => ScheduledRelease(
      animeId: animeId,
      title: 'Monster',
      releaseAt: now.add(Duration(days: days)),
      episode: 4,
    );

void main() {
  group('LoadReleaseAgendaUseCase', () {
    test('rattache les épisodes aux animes de la liste par identifiant',
        () async {
      final agenda = await firstAgenda(
        agendaOf(
          FakeScheduleGateway(
            listed: [
              episodeOf('Autre titre', days: 2, malId: 100, episode: 7),
              episodeOf('Autre titre', days: 9, malId: 100, episode: 8),
            ],
          ),
        ),
      );

      expect(agenda.map((release) => release.animeId), [1, 1]);
      expect(agenda.map((release) => release.episode), [7, 8]);
      expect(agenda.first.title, 'En cours');
      expect(agenda.first.isInWatchlist, isTrue);
    });

    test('interroge uniquement les animes non terminés', () async {
      final schedule = FakeScheduleGateway();

      await firstAgenda(agendaOf(schedule));

      expect(schedule.requestedMalIds.toSet(), {100, 200});
    });

    test('ajoute les sorties populaires absentes de la liste', () async {
      final agenda = await firstAgenda(
        agendaOf(
          FakeScheduleGateway(
            popular: [
              episodeOf('Nouveau', days: 1, malId: 900),
              episodeOf('Déjà suivi', days: 2, malId: 100),
              episodeOf('Déjà vu', days: 3, malId: 300),
            ],
          ),
        ),
      );

      expect(agenda.map((release) => release.title), ['Nouveau']);
      expect(agenda.single.isInWatchlist, isFalse);
    });

    test('ignore les sorties au-delà de l horizon', () async {
      final agenda = await firstAgenda(
        agendaOf(
          FakeScheduleGateway(
            popular: [
              episodeOf('Proche', days: 5),
              episodeOf('Lointain', days: 40),
              episodeOf('Passé', days: -3),
            ],
          ),
        ),
      );

      expect(agenda.map((release) => release.title), ['Proche']);
    });

    test('trie par date', () async {
      final agenda = await firstAgenda(
        agendaOf(
          FakeScheduleGateway(
            listed: [episodeOf('X', days: 6, malId: 100)],
            popular: [
              episodeOf('Tôt', days: 1),
              episodeOf('Tard', days: 12),
            ],
          ),
        ),
      );

      expect(agenda.map((release) => release.title), ['Tôt', 'En cours', 'Tard']);
    });

    test('utilise la date Kitsu quand AniList ne connaît pas l anime',
        () async {
      final agenda = await firstAgenda(
        agendaOf(
          FakeScheduleGateway(),
          kitsuRelease: now.add(const Duration(days: 3)),
        ),
      );

      expect(agenda.single.animeId, 1);
      expect(agenda.single.episode, isNull);
    });

    test('ne double pas un anime déjà couvert par AniList', () async {
      final agenda = await firstAgenda(
        agendaOf(
          FakeScheduleGateway(listed: [episodeOf('X', days: 2, malId: 100)]),
          kitsuRelease: now.add(const Duration(days: 3)),
        ),
      );

      expect(agenda.length, 1);
      expect(agenda.single.episode, 3);
    });

    test('masque une date Kitsu périmée', () async {
      final agenda = await firstAgenda(
        agendaOf(
          FakeScheduleGateway(),
          kitsuRelease: now.subtract(const Duration(days: 30)),
        ),
      );

      expect(agenda, isEmpty);
    });

    test('reste utilisable quand AniList est indisponible', () async {
      final agenda = await firstAgenda(
        agendaOf(
          FakeScheduleGateway(fails: true),
          kitsuRelease: now.add(const Duration(days: 2)),
        ),
      );

      expect(agenda.single.animeId, 1);
    });

    test('ne recharge pas les sorties populaires à chaque changement',
        () async {
      final schedule = FakeScheduleGateway(
        popular: [episodeOf('Nouveau', days: 1)],
      );
      final useCase = agendaOf(schedule);

      await firstAgenda(useCase);
      await firstAgenda(useCase);

      expect(schedule.popularCalls, 1);
    });

    test('retente les sorties populaires après un résultat vide', () async {
      final schedule = FakeScheduleGateway();
      final useCase = agendaOf(schedule);

      await firstAgenda(useCase);
      await firstAgenda(useCase);

      expect(schedule.popularCalls, 2);
    });

    test('échoue quand aucun détail n est disponible', () {
      expect(
        agendaOf(FakeScheduleGateway(), detailsFail: true)(),
        emitsError(isA<ReleaseAgendaUnavailableException>()),
      );
    });

    test('une liste vide donne seulement les sorties populaires', () async {
      final agenda = await firstAgenda(
        agendaOf(
          FakeScheduleGateway(popular: [episodeOf('Nouveau', days: 1)]),
          list: const [],
        ),
      );

      expect(agenda.single.title, 'Nouveau');
    });

    test('exceptions lisibles', () {
      expect(
        const ReleaseAgendaUnavailableException().toString(),
        contains('unavailable'),
      );
      expect(
        const ReleaseScheduleUnavailableException().toString(),
        contains('unavailable'),
      );
    });
  });

  group('AgendaCubit', () {
    AgendaCubit cubitOf(FakeScheduleGateway schedule, {bool detailsFail = false}) {
      final cubit = AgendaCubit(agendaOf(schedule, detailsFail: detailsFail));
      addTearDown(cubit.close);

      return cubit;
    }

    Future<void> settle() => Future<void>.delayed(const Duration(milliseconds: 10));

    test('passe de chargement à succès', () async {
      final cubit = cubitOf(
        FakeScheduleGateway(popular: [episodeOf('Nouveau', days: 1)]),
      );

      expect(cubit.state.status, AgendaStatus.loading);

      await cubit.load();
      await settle();

      expect(cubit.state.status, AgendaStatus.success);
    });

    test('signale un agenda vide', () async {
      final cubit = cubitOf(FakeScheduleGateway());

      await cubit.load();
      await settle();

      expect(cubit.state.status, AgendaStatus.empty);
    });

    test('signale une erreur', () async {
      final cubit = cubitOf(FakeScheduleGateway(), detailsFail: true);

      await cubit.load();
      await settle();

      expect(cubit.state.status, AgendaStatus.failure);
    });

    test('le filtre ne garde que les animes de la liste', () async {
      final cubit = cubitOf(
        FakeScheduleGateway(
          listed: [episodeOf('X', days: 2, malId: 100)],
          popular: [episodeOf('Nouveau', days: 1)],
        ),
      );

      await cubit.load();
      await settle();

      expect(cubit.state.visibleReleases.length, 2);

      cubit.selectFilter(onlyWatchlist: true);

      expect(cubit.state.visibleReleases.single.title, 'En cours');

      await cubit.load();
      await settle();

      expect(cubit.state.onlyWatchlist, isTrue);
    });
  });

  group('ScheduledRelease', () {
    test('compte les jours calendaires', () {
      expect(releaseIn(0).daysUntil(now.toLocal()), 0);
      expect(releaseIn(1).daysUntil(now.toLocal()), 1);
      expect(releaseIn(5).daysUntil(now.toLocal()), 5);
      expect(releaseIn(-1).daysUntil(now.toLocal()), -1);
    });

    test('sait si l anime est dans la liste', () {
      expect(releaseIn(1).isInWatchlist, isTrue);
      expect(releaseIn(1, animeId: null).isInWatchlist, isFalse);
    });
  });

  group('AniList', () {
    const payload = {
      'data': {
        'Page': {
          'media': [
            {
              'idMal': 52991,
              'title': {'romaji': 'Sousou no Frieren', 'english': 'Frieren'},
              'coverImage': {'large': 'https://example.invalid/f.jpg'},
              'airingSchedule': {
                'nodes': [
                  {'airingAt': 1791203400, 'episode': 5},
                  {'airingAt': 1791808200, 'episode': 6},
                ],
              },
            },
            {
              'idMal': null,
              'title': {'romaji': 'Sans anglais', 'english': null},
              'coverImage': null,
              'airingSchedule': {
                'nodes': [
                  {'airingAt': 1791203400, 'episode': 1},
                ],
              },
            },
          ],
        },
      },
    };

    test('le DTO lit épisodes, titres et couvertures', () {
      final episodes = UpcomingEpisodeDto.fromJson(payload);

      expect(episodes.length, 3);
      expect(episodes.first.title, 'Frieren');
      expect(episodes.first.malId, 52991);
      expect(episodes.first.episode, 5);
      expect(episodes.first.airingAt.isUtc, isTrue);
      expect(episodes.first.airingAt.millisecondsSinceEpoch, 1791203400000);
      expect(episodes.last.title, 'Sans anglais');
      expect(episodes.last.coverUrl, isNull);
    });

    test('le DTO tolère une réponse vide', () {
      expect(UpcomingEpisodeDto.fromJson(const {}), isEmpty);
    });

    AniListReleaseScheduleGateway gatewayReplying(
      http.Response Function(http.Request request) reply, {
      List<http.Request>? seen,
    }) =>
        AniListReleaseScheduleGateway(
          AniListClient(
            MockClient((request) async {
              seen?.add(request);

              return reply(request);
            }),
          ),
        );

    test('interroge AniList avec les identifiants MyAnimeList', () async {
      final seen = <http.Request>[];
      final gateway = gatewayReplying(
        (_) => http.Response(jsonEncode(payload), 200),
        seen: seen,
      );

      final episodes = await gateway.findForMalIds([52991, 1]);

      expect(episodes.length, 3);
      expect(seen.single.url.host, 'graphql.anilist.co');
      final body = jsonDecode(seen.single.body) as Map<String, dynamic>;
      expect((body['variables'] as Map<String, dynamic>)['ids'], [52991, 1]);
      expect(body['query'], contains('idMal_in'));
    });

    test('ne contacte pas AniList sans identifiant', () async {
      final seen = <http.Request>[];
      final gateway = gatewayReplying(
        (_) => http.Response(jsonEncode(payload), 200),
        seen: seen,
      );

      expect(await gateway.findForMalIds(const []), isEmpty);
      expect(seen, isEmpty);
    });

    test('récupère les sorties populaires', () async {
      final seen = <http.Request>[];
      final gateway = gatewayReplying(
        (_) => http.Response(jsonEncode(payload), 200),
        seen: seen,
      );

      await gateway.findPopularAiring();

      expect(
        (jsonDecode(seen.single.body) as Map<String, dynamic>)['query'],
        contains('POPULARITY_DESC'),
      );
    });

    test('traduit un échec en indisponibilité', () {
      final gateway = gatewayReplying((_) => http.Response('', 500));

      expect(
        gateway.findPopularAiring(),
        throwsA(isA<ReleaseScheduleUnavailableException>()),
      );
      expect(
        const AniListRequestFailedException(500).toString(),
        contains('500'),
      );
    });
  });

  group('AnimeDetailsDto', () {
    test('lit la prochaine sortie et l identifiant MyAnimeList', () {
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
            'relationships': {
              'mappings': {
                'data': [
                  {'type': 'mappings', 'id': '1'},
                  {'type': 'mappings', 'id': '2'},
                ],
              },
            },
          },
        ],
        'included': [
          {
            'type': 'mappings',
            'id': '1',
            'attributes': {'externalSite': 'anidb', 'externalId': '999'},
          },
          {
            'type': 'mappings',
            'id': '2',
            'attributes': {
              'externalSite': 'myanimelist/anime',
              'externalId': '52991',
            },
          },
        ],
      });

      expect(details[7]?.nextRelease, DateTime.utc(2026, 10, 8, 15));
      expect(details[7]?.malId, 52991);
    });

    test('tolère l absence de prochaine sortie et de correspondance', () {
      final details = AnimeDetailsDto.fromJson({
        'data': [
          {
            'id': '7',
            'attributes': {'subtype': 'TV'},
          },
        ],
      });

      expect(details[7]?.nextRelease, isNull);
      expect(details[7]?.malId, isNull);
    });
  });

  group('releaseCountdown', () {
    late AppLocalizations l10n;

    setUp(() async {
      l10n = await AppLocalizations.delegate.load(const Locale('fr'));
    });

    test('formule chaque cas', () {
      final local = now.toLocal();

      expect(releaseCountdown(l10n, releaseIn(0), local), 'Aujourd\'hui');
      expect(releaseCountdown(l10n, releaseIn(1), local), 'Demain');
      expect(releaseCountdown(l10n, releaseIn(4), local), 'Dans 4 jours');
      expect(releaseCountdown(l10n, releaseIn(-1), local), 'Hier');
      expect(releaseCountdown(l10n, releaseIn(-3), local), 'Il y a 3 jours');
    });
  });

  group('écran', () {
    testWidgets('la carte d un anime de la liste est cliquable avec badge',
        (tester) async {
      var opened = false;

      await pumpApp(
        tester,
        ReleaseCard(
          release: releaseIn(1),
          now: now.toLocal(),
          onTap: () => opened = true,
        ),
      );

      expect(find.text('Demain'), findsOneWidget);
      expect(find.text('Dans ma liste'), findsOneWidget);
      expect(find.textContaining('Épisode 4'), findsOneWidget);

      await tester.tap(find.text('Monster'));

      expect(opened, isTrue);
    });

    testWidgets('la carte d une sortie externe n a pas de badge',
        (tester) async {
      await pumpApp(
        tester,
        ReleaseCard(release: releaseIn(2, animeId: null), now: now.toLocal()),
      );

      expect(find.text('Dans ma liste'), findsNothing);
    });

    testWidgets('sans numéro d épisode, la ligne ne montre que la date',
        (tester) async {
      await pumpApp(
        tester,
        ReleaseCard(
          release: ScheduledRelease(
            title: 'Sans numéro',
            releaseAt: now.add(const Duration(days: 2)),
          ),
          now: now.toLocal(),
        ),
      );

      expect(find.textContaining('Épisode'), findsNothing);
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
                now: now.toLocal(),
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
              now: now.toLocal(),
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
              now: now.toLocal(),
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

    testWidgets('une sortie externe ne déclenche aucune ouverture',
        (tester) async {
      int? opened;

      await pumpApp(
        tester,
        CustomScrollView(
          slivers: [
            AgendaResultsSliver(
              state: AgendaState(
                status: AgendaStatus.success,
                releases: [releaseIn(2, animeId: null)],
              ),
              now: now.toLocal(),
              onRetry: () {},
              onAnimeSelected: (id, _) => opened = id,
            ),
          ],
        ),
      );
      await tester.tap(find.text('Monster'));

      expect(opened, isNull);
    });

    testWidgets('explique l absence de sortie pour la liste', (tester) async {
      await pumpApp(
        tester,
        CustomScrollView(
          slivers: [
            AgendaResultsSliver(
              state: AgendaState(
                status: AgendaStatus.success,
                releases: [releaseIn(2, animeId: null)],
                onlyWatchlist: true,
              ),
              now: now.toLocal(),
              onRetry: () {},
              onAnimeSelected: (_, _) {},
            ),
          ],
        ),
      );

      expect(
        find.text('Aucune sortie pour les animes de votre liste.'),
        findsOneWidget,
      );
    });

    testWidgets('réessayer relance le chargement', (tester) async {
      var retried = false;

      await pumpApp(
        tester,
        CustomScrollView(
          slivers: [
            AgendaResultsSliver(
              state: const AgendaState(status: AgendaStatus.failure),
              now: now.toLocal(),
              onRetry: () => retried = true,
              onAnimeSelected: (_, _) {},
            ),
          ],
        ),
      );
      await tester.tap(find.text('Réessayer'));

      expect(retried, isTrue);
    });

    testWidgets('le filtre bascule entre toutes les sorties et ma liste',
        (tester) async {
      bool? chosen;

      await pumpApp(
        tester,
        AgendaFilter(onlyWatchlist: false, onChanged: (value) => chosen = value),
      );

      await tester.tap(find.text('Ma liste'));

      expect(chosen, isTrue);
      expect(find.text('Toutes les sorties'), findsOneWidget);
    });
  });
}
