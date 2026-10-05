import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:monapp/l10n/app_localizations.dart';
import 'package:monapp/layers/functional/Anime/data/gateways/local_watchlist_gateway.dart';
import 'package:monapp/layers/functional/Anime/data/models/anime_details_dto.dart';
import 'package:monapp/layers/functional/Anime/domain/entities/anime_genre.dart';
import 'package:monapp/layers/functional/Anime/domain/entities/watch_status.dart';
import 'package:monapp/layers/functional/Anime/domain/entities/watchlist_entry.dart';
import 'package:monapp/layers/functional/Anime/domain/use_cases/add_to_watchlist_use_case.dart';
import 'package:monapp/layers/functional/Anime/domain/use_cases/find_watch_status_use_case.dart';
import 'package:monapp/layers/functional/Anime/presentation/anime_genre_label.dart';
import 'package:monapp/layers/functional/Catalogue/domain/entities/catalogue_anime.dart';
import 'package:monapp/layers/functional/Discover/data/gateways/kitsu_catalogue_suggestion_gateway.dart';
import 'package:monapp/layers/functional/Discover/domain/entities/evening_mood.dart';
import 'package:monapp/layers/functional/Discover/domain/gateways/catalogue_suggestion_gateway.dart';
import 'package:monapp/layers/functional/Discover/domain/use_cases/suggest_evening_watch_use_case.dart';
import 'package:monapp/layers/functional/Discover/presentation/cubit/evening_cubit.dart';
import 'package:monapp/layers/functional/Discover/presentation/cubit/evening_state.dart';
import 'package:monapp/layers/functional/Discover/presentation/widgets/evening_section.dart';
import 'package:monapp/layers/technical/KitsuApi/kitsu_client.dart';

import '../../support/fake_watchlist_store.dart';
import '../../support/pump_app.dart';
import '../../support/watchlist_fixtures.dart';

CatalogueAnime catalogued(int id, {String? title}) => CatalogueAnime(
      id: id,
      title: title ?? 'Anime $id',
      format: 'Série TV',
      year: 2015,
      episodeCount: 12,
    );

CatalogueSuggestion suggestionOf(int id, [List<String> genres = const []]) =>
    CatalogueSuggestion(
      anime: catalogued(id),
      genres: [for (final slug in genres) genre(slug)],
    );

class FakeSuggestionGateway implements CatalogueSuggestionGateway {
  FakeSuggestionGateway(this.catalogue, {this.fails = false});

  final List<CatalogueSuggestion?> catalogue;
  final bool fails;
  final List<String?> countedGenres = [];
  final List<String?> searchedGenres = [];

  @override
  Future<int> countMatching(String? genreSlug) async {
    countedGenres.add(genreSlug);

    if (fails) {
      throw const CatalogueSuggestionUnavailableException();
    }

    return catalogue.length;
  }

  @override
  Future<CatalogueSuggestion?> findAt(String? genreSlug, int offset) async {
    searchedGenres.add(genreSlug);

    return catalogue[offset];
  }
}

const watched = [
  WatchlistEntry(id: 1, title: 'En cours', status: WatchStatus.watching),
  WatchlistEntry(id: 2, title: 'Fini', status: WatchStatus.completed),
];

FindWatchStatusUseCase statusLookup([List<WatchlistEntry> entries = watched]) =>
    FindWatchStatusUseCase(
      LocalWatchlistGateway(FakeWatchlistStore(entries), const []),
    );

SuggestEveningWatchUseCase useCaseFor(
  FakeSuggestionGateway gateway, {
  int seed = 1,
}) =>
    SuggestEveningWatchUseCase(gateway, statusLookup(), random: Random(seed));

List<CatalogueSuggestion> many() => [
      for (var id = 10; id < 40; id++) suggestionOf(id),
    ];

void main() {
  group('SuggestEveningWatchUseCase', () {
    test('tire un anime du catalogue sans filtre de genre', () async {
      final gateway = FakeSuggestionGateway([suggestionOf(10)]);

      final suggestion = await useCaseFor(gateway)(mood: EveningMood.any);

      expect(suggestion?.anime.id, 10);
      expect(suggestion?.isListed, isFalse);
      expect(gateway.countedGenres, [null]);
    });

    test('filtre par un genre de l humeur', () async {
      final gateway = FakeSuggestionGateway([suggestionOf(10)]);

      await useCaseFor(gateway)(mood: EveningMood.action);

      expect(
        EveningMood.action.genreSlugs,
        contains(gateway.countedGenres.single),
      );
    });

    test('chaque humeur filtre sur ses propres genres', () async {
      for (final mood in EveningMood.values) {
        final gateway = FakeSuggestionGateway([suggestionOf(10)]);

        await useCaseFor(gateway)(mood: mood);

        if (mood.genreSlugs.isEmpty) {
          expect(gateway.countedGenres, [null]);
        } else {
          expect(mood.genreSlugs, contains(gateway.countedGenres.single));
        }
      }
    });

    test('la romance est un choix à part entière', () async {
      final gateway = FakeSuggestionGateway([suggestionOf(10)]);

      await useCaseFor(gateway)(mood: EveningMood.romance);

      expect(gateway.countedGenres, ['romance']);
      expect(EveningMood.emotional.genreSlugs, isNot(contains('romance')));
    });

    test('signale les animes déjà dans la liste', () async {
      final gateway = FakeSuggestionGateway([suggestionOf(1)]);

      final suggestion = await useCaseFor(gateway)(mood: EveningMood.any);

      expect(suggestion?.isListed, isTrue);
    });

    test('ne propose jamais un anime terminé', () async {
      final gateway =
          FakeSuggestionGateway([suggestionOf(2), suggestionOf(10)]);

      for (var seed = 0; seed < 20; seed++) {
        final suggestion = await useCaseFor(gateway, seed: seed)(
          mood: EveningMood.any,
        );

        expect(suggestion?.anime.id, anyOf(10, isNull));
      }
    });

    test('exclut les animes déjà montrés', () async {
      final gateway = FakeSuggestionGateway([suggestionOf(10)]);

      final suggestion = await useCaseFor(gateway)(
        mood: EveningMood.any,
        excludedIds: {10},
      );

      expect(suggestion, isNull);
    });

    test('ignore une entrée introuvable', () async {
      final gateway = FakeSuggestionGateway([null]);

      expect(await useCaseFor(gateway)(mood: EveningMood.any), isNull);
    });

    test('un catalogue vide ne donne rien', () async {
      final gateway = FakeSuggestionGateway(const []);

      expect(await useCaseFor(gateway)(mood: EveningMood.any), isNull);
    });

    test('mémorise le nombre d animes par genre', () async {
      final gateway = FakeSuggestionGateway([suggestionOf(10)]);
      final useCase = useCaseFor(gateway);

      await useCase(mood: EveningMood.any);
      await useCase(mood: EveningMood.any);

      expect(gateway.countedGenres.length, 1);
    });

    test('couvre le catalogue de façon aléatoire', () async {
      final gateway = FakeSuggestionGateway(many());
      final seen = <int>{};

      for (var seed = 0; seed < 40; seed++) {
        final suggestion = await useCaseFor(gateway, seed: seed)(
          mood: EveningMood.any,
        );

        seen.add(suggestion!.anime.id);
      }

      expect(seen.length, greaterThan(10));
    });

    test('propage une indisponibilité', () {
      final gateway = FakeSuggestionGateway(const [], fails: true);

      expect(
        useCaseFor(gateway)(mood: EveningMood.any),
        throwsA(isA<CatalogueSuggestionUnavailableException>()),
      );
      expect(
        const CatalogueSuggestionUnavailableException().toString(),
        contains('unavailable'),
      );
    });
  });

  group('EveningCubit', () {
    late LocalWatchlistGateway watchlist;

    EveningCubit cubitFor(FakeSuggestionGateway gateway) {
      watchlist = LocalWatchlistGateway(FakeWatchlistStore(watched), const []);
      final created = EveningCubit(
        SuggestEveningWatchUseCase(
          gateway,
          FindWatchStatusUseCase(watchlist),
          random: Random(3),
        ),
        AddToWatchlistUseCase(watchlist),
      );
      addTearDown(created.close);

      return created;
    }

    test('suggère puis propose une autre idée', () async {
      final evening = cubitFor(FakeSuggestionGateway(many()));

      await evening.suggest();
      final first = evening.state.suggestion!.anime.id;

      expect(evening.state.status, EveningStatus.suggested);

      await evening.suggestAnother();

      expect(evening.state.suggestion!.anime.id, isNot(first));
    });

    test('signale l absence de résultat', () async {
      final evening = cubitFor(FakeSuggestionGateway(const []));

      await evening.suggest();

      expect(evening.state.status, EveningStatus.none);
    });

    test('signale une erreur', () async {
      final evening = cubitFor(FakeSuggestionGateway(const [], fails: true));

      await evening.suggest();

      expect(evening.state.status, EveningStatus.failure);
    });

    test('changer d humeur efface la suggestion', () async {
      final evening = cubitFor(FakeSuggestionGateway([suggestionOf(10)]));

      await evening.suggest();
      evening.selectMood(EveningMood.relaxed);

      expect(evening.state.status, EveningStatus.idle);
      expect(evening.state.suggestion, isNull);
      expect(evening.state.mood, EveningMood.relaxed);
    });

    test('ajouter la suggestion l inscrit dans la liste', () async {
      final evening = cubitFor(FakeSuggestionGateway([suggestionOf(10)]));

      await evening.suggest();
      evening.addSuggestionToWatchlist();

      expect(watchlist.entries.map((entry) => entry.id), contains(10));
      expect(evening.state.suggestion?.isListed, isTrue);

      evening.addSuggestionToWatchlist();

      expect(watchlist.entries.where((entry) => entry.id == 10).length, 1);
    });

    test('ajouter sans suggestion ne fait rien', () {
      final evening = cubitFor(FakeSuggestionGateway(const []));

      evening.addSuggestionToWatchlist();

      expect(watchlist.entries.length, watched.length);
    });
  });

  group('KitsuCatalogueSuggestionGateway', () {
    const page = '''
{
  "data": [{
    "id": "77",
    "attributes": {
      "canonicalTitle": "Trigun",
      "subtype": "TV",
      "startDate": "1998-04-01",
      "episodeCount": 26
    },
    "relationships": {
      "categories": {"data": [{"type": "categories", "id": "5"}]}
    }
  }],
  "included": [
    {"type": "categories", "id": "5",
     "attributes": {"title": "Action", "slug": "action"}}
  ],
  "meta": {"count": 321}
}
''';

    KitsuCatalogueSuggestionGateway gatewayReplying(
      http.Response Function(http.Request request) reply, {
      List<Uri>? seen,
    }) =>
        KitsuCatalogueSuggestionGateway(
          KitsuClient(
            MockClient((request) async {
              seen?.add(request.url);

              return reply(request);
            }),
          ),
        );

    test('compte les animes d un genre', () async {
      final seen = <Uri>[];
      final gateway =
          gatewayReplying((_) => http.Response(page, 200), seen: seen);

      expect(await gateway.countMatching('action'), 321);
      expect(seen.single.query, contains('filter%5Bcategories%5D=action'));
      expect(seen.single.query, contains('filter%5BuserCount%5D=5000..'));
      expect(seen.single.query, contains('filter%5Bsubtype%5D=TV,movie'));
    });

    test('compte tout le catalogue sans genre', () async {
      final seen = <Uri>[];
      final gateway =
          gatewayReplying((_) => http.Response(page, 200), seen: seen);

      await gateway.countMatching(null);

      expect(seen.single.query, isNot(contains('categories')));
    });

    test('lit l anime à une position avec ses genres', () async {
      final seen = <Uri>[];
      final gateway =
          gatewayReplying((_) => http.Response(page, 200), seen: seen);

      final found = await gateway.findAt('action', 42);

      expect(found?.anime.id, 77);
      expect(found?.anime.title, 'Trigun');
      expect(found?.genres.single.slug, 'action');
      expect(seen.single.query, contains('page%5Boffset%5D=42'));
      expect(seen.single.query, contains('sort=-userCount'));
    });

    test('renvoie null quand la position est vide', () async {
      final gateway = gatewayReplying(
        (_) => http.Response('{"data": [], "meta": {"count": 0}}', 200),
      );

      expect(await gateway.findAt(null, 5), isNull);
      expect(await gateway.countMatching(null), 0);
    });

    test('traduit un échec en indisponibilité', () {
      final gateway = gatewayReplying((_) => http.Response('', 500));

      expect(
        gateway.countMatching(null),
        throwsA(isA<CatalogueSuggestionUnavailableException>()),
      );
      expect(
        gateway.findAt(null, 0),
        throwsA(isA<CatalogueSuggestionUnavailableException>()),
      );
    });
  });

  group('EveningSection', () {
    Future<LocalWatchlistGateway> pumpSection(
      WidgetTester tester,
      FakeSuggestionGateway gateway, {
      void Function(int, String)? onSelected,
    }) async {
      final watchlist =
          LocalWatchlistGateway(FakeWatchlistStore(watched), const []);
      final evening = EveningCubit(
        SuggestEveningWatchUseCase(
          gateway,
          FindWatchStatusUseCase(watchlist),
          random: Random(3),
        ),
        AddToWatchlistUseCase(watchlist),
      );
      addTearDown(evening.close);

      await pumpApp(
        tester,
        BlocProvider.value(
          value: evening,
          child: SingleChildScrollView(
            child: EveningSection(onAnimeSelected: onSelected ?? (_, _) {}),
          ),
        ),
        size: const Size(500, 1400),
      );

      return watchlist;
    }

    testWidgets('propose humeur et genres, sans choix de temps',
        (tester) async {
      await pumpSection(tester, FakeSuggestionGateway(const []));

      expect(find.text('Quoi regarder ce soir ?'), findsOneWidget);
      expect(find.text('Mon humeur ou mon genre'), findsOneWidget);
      expect(find.text('Mon temps'), findsNothing);
    });

    testWidgets('affiche une suggestion et ouvre la fiche', (tester) async {
      int? opened;

      await pumpSection(
        tester,
        FakeSuggestionGateway([
          suggestionOf(10, ['action']),
        ]),
        onSelected: (id, _) => opened = id,
      );

      await tester.tap(find.text('Surprends-moi'));
      await tester.pumpAndSettle();

      expect(find.text('Anime 10'), findsOneWidget);
      expect(
        find.text('Tiré au hasard dans tout le catalogue.'),
        findsOneWidget,
      );

      await tester.tap(find.text('Voir la fiche'));

      expect(opened, 10);
    });

    testWidgets('ajoute la suggestion à la liste', (tester) async {
      final watchlist = await pumpSection(
        tester,
        FakeSuggestionGateway([suggestionOf(10)]),
      );

      await tester.tap(find.text('Surprends-moi'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Ajouter à ma liste'));
      await tester.pumpAndSettle();

      expect(watchlist.entries.map((entry) => entry.id), contains(10));
      expect(find.text('Déjà dans votre liste.'), findsOneWidget);
      expect(find.text('Ajouter à ma liste'), findsNothing);
    });

    testWidgets('propose une autre idée', (tester) async {
      await pumpSection(tester, FakeSuggestionGateway(many()));

      await tester.tap(find.text('Surprends-moi'));
      await tester.pumpAndSettle();
      final first = tester
          .widgetList<Text>(find.textContaining('Anime '))
          .map((text) => text.data)
          .first;

      await tester.tap(find.text('Une autre idée'));
      await tester.pumpAndSettle();

      expect(find.text(first!), findsNothing);
    });

    testWidgets('explique quand rien n est trouvé', (tester) async {
      await pumpSection(tester, FakeSuggestionGateway(const []));

      await tester.tap(find.text('Surprends-moi'));
      await tester.pumpAndSettle();

      expect(find.text('Aucun anime trouvé.'), findsOneWidget);
    });

    testWidgets('affiche l erreur et permet de réessayer', (tester) async {
      await pumpSection(tester, FakeSuggestionGateway(const [], fails: true));

      await tester.tap(find.text('Surprends-moi'));
      await tester.pumpAndSettle();

      expect(
        find.text('Impossible de composer une suggestion'),
        findsOneWidget,
      );
      expect(find.text('Réessayer'), findsOneWidget);
    });
  });

  group('genres', () {
    test('le DTO lit les genres inclus', () {
      final details = AnimeDetailsDto.fromJson({
        'data': [
          {
            'id': '5',
            'attributes': {'subtype': 'TV', 'episodeLength': 24},
            'relationships': {
              'categories': {
                'data': [
                  {'type': 'categories', 'id': '10'},
                  {'type': 'categories', 'id': '99'},
                ],
              },
            },
          },
        ],
        'included': [
          {
            'type': 'categories',
            'id': '10',
            'attributes': {'title': 'Action', 'slug': 'action'},
          },
          {'type': 'people', 'id': '1', 'attributes': <String, dynamic>{}},
        ],
      });

      expect(details[5]?.genres.single.slug, 'action');
      expect(details[5]?.episodeMinutes, 24);
      expect(details[5]?.hasGenre('action'), isTrue);
      expect(details[5]?.hasGenre('drama'), isFalse);
    });

    test('les libellés sont traduits avec repli sur le titre', () async {
      final l10n = await AppLocalizations.delegate.load(const Locale('fr'));

      expect(genreLabel(l10n, genre('comedy')), 'Comédie');
      expect(genreLabel(l10n, genre('slice-of-life')), 'Tranche de vie');
      expect(genreLabel(l10n, genre('unknown', 'Étrange')), 'Étrange');

      for (final slug in [
        'action',
        'adventure',
        'drama',
        'fantasy',
        'horror',
        'mystery',
        'romance',
        'science-fiction',
        'sports',
        'supernatural',
        'thriller',
        'psychological',
        'mecha',
      ]) {
        expect(genreLabel(l10n, genre(slug)), isNot(slug));
      }
    });

    test('un genre se compare par ses valeurs', () {
      expect(
        const AnimeGenre(slug: 'a', title: 'A'),
        const AnimeGenre(slug: 'a', title: 'A'),
      );
    });
  });
}
