import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:monapp/layers/functional/Anime/data/gateways/local_watchlist_gateway.dart';
import 'package:monapp/layers/functional/Anime/domain/entities/watch_status.dart';
import 'package:monapp/layers/functional/Anime/domain/entities/watchlist_entry.dart';
import 'package:monapp/layers/functional/Anime/domain/use_cases/add_to_watchlist_use_case.dart';
import 'package:monapp/layers/functional/Catalogue/domain/entities/catalogue_anime.dart';
import 'package:monapp/layers/functional/Discover/data/gateways/kitsu_recommendation_gateway.dart';
import 'package:monapp/layers/functional/Discover/domain/gateways/recommendation_gateway.dart';
import 'package:monapp/layers/functional/Discover/domain/use_cases/recommend_anime_use_case.dart';
import 'package:monapp/layers/functional/Discover/presentation/cubit/recommendations_cubit.dart';
import 'package:monapp/layers/functional/Discover/presentation/cubit/recommendations_state.dart';
import 'package:monapp/layers/functional/Discover/presentation/widgets/recommendations_section.dart';
import 'package:monapp/layers/technical/KitsuApi/kitsu_client.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';

import '../../support/fake_watchlist_store.dart';
import '../../support/pump_app.dart';
import '../../support/watchlist_fixtures.dart';

CatalogueAnime catalogued(int id) => CatalogueAnime(
      id: id,
      title: 'Reco $id',
      format: 'TV',
      year: 2020,
      episodeCount: 12,
    );

class FakeRecommendationGateway implements RecommendationGateway {
  FakeRecommendationGateway(this.byGenre, {this.failingGenres = const {}});

  final Map<String, List<CatalogueAnime>> byGenre;
  final Set<String> failingGenres;
  final List<String> requested = [];

  @override
  Future<List<CatalogueAnime>> findAcclaimedByGenre(
    String slug,
    int limit,
  ) async {
    requested.add(slug);

    if (failingGenres.contains(slug)) {
      throw const RecommendationsUnavailableException();
    }

    return byGenre[slug] ?? const [];
  }
}

const entries = [
  WatchlistEntry(id: 1, title: 'Fini A', status: WatchStatus.completed),
  WatchlistEntry(id: 2, title: 'Fini B', status: WatchStatus.completed),
  WatchlistEntry(id: 3, title: 'En cours', status: WatchStatus.watching),
  WatchlistEntry(id: 4, title: 'À voir', status: WatchStatus.toWatch),
];

RecommendAnimeUseCase useCase(
  FakeRecommendationGateway gateway, {
  List<WatchlistEntry> list = entries,
  bool fails = false,
}) =>
    RecommendAnimeUseCase(
      watchlistOf(
        list,
        {
          1: detailsOf(genres: ['action', 'drama']),
          2: detailsOf(genres: ['action', 'drama']),
          3: detailsOf(genres: ['drama', 'comedy']),
          4: detailsOf(genres: ['horror']),
        },
        fails: fails,
      ),
      gateway,
    );

void main() {
  group('RecommendAnimeUseCase', () {
    test('interroge les deux genres préférés pondérés par statut', () async {
      final gateway = FakeRecommendationGateway({});

      final result = await useCase(gateway)();

      expect(result.basedOn.map((genre) => genre.slug), ['drama', 'action']);
      expect(gateway.requested, ['drama', 'action']);
    });

    test('ignore les animes à voir dans le calcul des goûts', () async {
      final gateway = FakeRecommendationGateway({});

      await useCase(gateway)();

      expect(gateway.requested, isNot(contains('horror')));
    });

    test('classe d abord ce qui correspond aux deux genres', () async {
      final gateway = FakeRecommendationGateway({
        'drama': [catalogued(10), catalogued(11), catalogued(12)],
        'action': [catalogued(12), catalogued(13)],
      });

      final result = await useCase(gateway)();

      expect(result.animes.first.id, 12);
      expect(result.animes.map((anime) => anime.id).toSet(), {10, 11, 12, 13});
    });

    test('exclut les animes déjà dans la liste', () async {
      final gateway = FakeRecommendationGateway({
        'drama': [catalogued(1), catalogued(4), catalogued(10)],
      });

      final result = await useCase(gateway)();

      expect(result.animes.map((anime) => anime.id), [10]);
    });

    test('limite le nombre de recommandations', () async {
      final gateway = FakeRecommendationGateway({
        'drama': [for (var id = 100; id < 120; id++) catalogued(id)],
      });

      final result = await useCase(gateway)();

      expect(result.animes.length, RecommendAnimeUseCase.maxRecommendations);
    });

    test('continue quand un genre échoue', () async {
      final gateway = FakeRecommendationGateway(
        {
          'action': [catalogued(20)],
        },
        failingGenres: {'drama'},
      );

      final result = await useCase(gateway)();

      expect(result.animes.single.id, 20);
    });

    test('échoue quand tous les genres échouent', () {
      final gateway = FakeRecommendationGateway(
        const {},
        failingGenres: {'drama', 'action'},
      );

      expect(
        useCase(gateway)(),
        throwsA(isA<RecommendationsUnavailableException>()),
      );
    });

    test('échoue quand aucun détail n est disponible', () {
      expect(
        useCase(FakeRecommendationGateway({}), fails: true)(),
        throwsA(isA<RecommendationsUnavailableException>()),
      );
    });

    test('ne recommande rien sans goût connu', () async {
      final result = await useCase(
        FakeRecommendationGateway({}),
        list: const [
          WatchlistEntry(id: 4, title: 'À voir', status: WatchStatus.toWatch),
        ],
      )();

      expect(result.isEmpty, isTrue);
      expect(result.basedOn, isEmpty);
    });

    test('exception lisible', () {
      expect(
        const RecommendationsUnavailableException().toString(),
        contains('unavailable'),
      );
    });
  });

  group('KitsuRecommendationGateway', () {
    test('interroge la catégorie triée par note', () async {
      Uri? requested;
      final client = KitsuClient(
        MockClient((request) async {
          requested = request.url;

          return http.Response(
            '{"data":[{"id":"7","attributes":{"canonicalTitle":"X",'
            '"subtype":"TV","episodeCount":12}}],"links":{}}',
            200,
          );
        }),
      );

      final animes =
          await KitsuRecommendationGateway(client).findAcclaimedByGenre(
        'drama',
        12,
      );

      expect(animes.single.id, 7);
      expect(requested?.query, contains('filter%5Bcategories%5D=drama'));
      expect(requested?.query, contains('sort=-averageRating'));
    });

    test('traduit un échec en indisponibilité', () {
      final client = KitsuClient(
        MockClient((_) async => http.Response('', 500)),
      );

      expect(
        KitsuRecommendationGateway(client).findAcclaimedByGenre('drama', 12),
        throwsA(isA<RecommendationsUnavailableException>()),
      );
    });
  });

  group('RecommendationsCubit', () {
    RecommendationsCubit cubitFor(
      FakeRecommendationGateway gateway, {
      LocalWatchlistGateway? target,
    }) {
      final watchlist =
          target ?? LocalWatchlistGateway(FakeWatchlistStore([]), const []);
      final cubit = RecommendationsCubit(
        useCase(gateway),
        AddToWatchlistUseCase(watchlist),
      );
      addTearDown(cubit.close);

      return cubit;
    }

    test('charge puis expose les recommandations', () async {
      final cubit = cubitFor(
        FakeRecommendationGateway({
          'drama': [catalogued(10)],
        }),
      );

      expect(cubit.state.status, RecommendationsStatus.loading);

      await cubit.load();

      expect(cubit.state.status, RecommendationsStatus.success);
    });

    test('signale un résultat vide', () async {
      final cubit = cubitFor(FakeRecommendationGateway({}));

      await cubit.load();

      expect(cubit.state.status, RecommendationsStatus.empty);
    });

    test('signale une erreur', () async {
      final cubit = cubitFor(
        FakeRecommendationGateway(
          const {},
          failingGenres: {'drama', 'action'},
        ),
      );

      await cubit.load();

      expect(cubit.state.status, RecommendationsStatus.failure);
    });

    test('ajouter retire la recommandation et l ajoute à la liste', () async {
      final watchlist =
          LocalWatchlistGateway(FakeWatchlistStore([]), const []);
      final cubit = cubitFor(
        FakeRecommendationGateway({
          'drama': [catalogued(10), catalogued(11)],
        }),
        target: watchlist,
      );

      await cubit.load();
      cubit.add(catalogued(10));

      expect(watchlist.entries.single.id, 10);
      expect(cubit.state.recommendations.animes.map((anime) => anime.id), [11]);

      cubit.add(catalogued(11));

      expect(cubit.state.status, RecommendationsStatus.empty);
    });
  });

  group('RecommendationsSection', () {
    RecommendationsCubit sectionCubit(FakeRecommendationGateway gateway) {
      final cubit = RecommendationsCubit(
        useCase(gateway),
        AddToWatchlistUseCase(
          LocalWatchlistGateway(FakeWatchlistStore([]), const []),
        ),
      );
      addTearDown(cubit.close);

      return cubit;
    }

    Future<RecommendationsCubit> pumpSection(
      WidgetTester tester,
      FakeRecommendationGateway gateway, {
      void Function(int, String)? onSelected,
      bool settle = true,
    }) async {
      final cubit = sectionCubit(gateway);

      await pumpApp(
        tester,
        BlocProvider.value(
          value: cubit,
          child: SingleChildScrollView(
            child: RecommendationsSection(
              onAnimeSelected: onSelected ?? (_, _) {},
            ),
          ),
        ),
        size: const Size(500, 900),
        settle: false,
      );

      if (settle) {
        await cubit.load();
        await tester.pumpAndSettle();
      }

      return cubit;
    }

    testWidgets('affiche l explication et les tuiles', (tester) async {
      int? opened;

      await pumpSection(
        tester,
        FakeRecommendationGateway({
          'drama': [catalogued(10)],
          'action': [catalogued(11)],
        }),
        onSelected: (id, _) => opened = id,
      );

      expect(find.text('Pour toi'), findsOneWidget);
      expect(
        find.text('Parce que vous aimez Drame et Action'),
        findsOneWidget,
      );

      await tester.tap(find.text('Reco 10'));

      expect(opened, 10);
    });

    testWidgets('ajoute une recommandation à la liste', (tester) async {
      await pumpSection(
        tester,
        FakeRecommendationGateway({
          'drama': [catalogued(10)],
        }),
      );

      await tester.tap(find.byIcon(Icons.add));
      await tester.pumpAndSettle();

      expect(find.text('Reco 10'), findsNothing);
      expect(find.text('Pas encore de recommandation.'), findsOneWidget);
    });

    testWidgets('affiche le squelette pendant le chargement', (tester) async {
      await pumpSection(
        tester,
        FakeRecommendationGateway({}),
        settle: false,
      );

      expect(find.text('Pour toi'), findsOneWidget);
    });

    testWidgets('affiche l erreur et relance le chargement', (tester) async {
      await pumpSection(
        tester,
        FakeRecommendationGateway(
          const {},
          failingGenres: {'drama', 'action'},
        ),
      );

      expect(find.text('Impossible de charger les recommandations'),
          findsOneWidget);

      await tester.tap(find.text('Réessayer'));
      await tester.pumpAndSettle();

      expect(find.text('Réessayer'), findsOneWidget);
    });

    testWidgets('affiche une explication avec un seul genre', (tester) async {
      final cubit = RecommendationsCubit(
        RecommendAnimeUseCase(
          watchlistOf(
            const [
              WatchlistEntry(
                id: 1,
                title: 'A',
                status: WatchStatus.completed,
              ),
            ],
            {1: detailsOf(genres: ['mecha'])},
          ),
          FakeRecommendationGateway({
            'mecha': [catalogued(30)],
          }),
        ),
        AddToWatchlistUseCase(
          LocalWatchlistGateway(FakeWatchlistStore([]), const []),
        ),
      );
      addTearDown(cubit.close);

      await pumpApp(
        tester,
        BlocProvider.value(
          value: cubit,
          child: SingleChildScrollView(
            child: RecommendationsSection(onAnimeSelected: (_, _) {}),
          ),
        ),
        size: const Size(500, 900),
        settle: false,
      );
      await cubit.load();
      await tester.pumpAndSettle();

      expect(find.text('Parce que vous aimez Mecha'), findsOneWidget);
    });
  });
}
