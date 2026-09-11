import 'package:flutter_test/flutter_test.dart';
import 'package:monapp/layers/functional/Anime/domain/entities/anime_details.dart';
import 'package:monapp/layers/functional/Anime/domain/entities/watch_status.dart';
import 'package:monapp/layers/functional/Anime/domain/entities/watchlist_entry.dart';
import 'package:monapp/layers/functional/Anime/domain/gateways/anime_details_gateway.dart';
import 'package:monapp/layers/functional/Anime/domain/use_cases/load_watchlist_use_case.dart';
import 'package:monapp/layers/functional/Anime/presentation/cubit/watchlist_cubit.dart';
import 'package:monapp/layers/functional/Catalogue/domain/use_cases/browse_catalogue_use_case.dart';
import 'package:monapp/layers/functional/Catalogue/presentation/cubit/catalogue_cubit.dart';
import 'package:monapp/layers/technical/Injection/injection.dart';
import 'package:monapp/layers/technical/Theme/widgets/plaque_row_skeleton.dart';
import 'package:monapp/main.dart';

import 'fake_anime_catalogue_gateway.dart';
import 'counting_anime_details_gateway.dart';
import 'fake_anime_details_gateway.dart';

const entries = [
  WatchlistEntry(id: 1, title: 'Cowboy Bebop', status: WatchStatus.toWatch),
  WatchlistEntry(id: 2, title: 'Vinland Saga', status: WatchStatus.watching),
  WatchlistEntry(id: 3, title: 'Death Note', status: WatchStatus.completed),
];

const bebop = AnimeDetails(format: 'Série TV', year: 1998, episodeCount: 26);
const vinland =
    AnimeDetails(format: 'Série TV', year: 2019, episodeCount: 24);

Future<void> pumpWith(WidgetTester tester, AnimeDetailsGateway gateway) async {
  await getIt.reset();
  getIt
    ..registerLazySingleton<LoadWatchlistUseCase>(
      () => LoadWatchlistUseCase(gateway),
    )
    ..registerFactory<CatalogueCubit>(
      () => CatalogueCubit(
        BrowseCatalogueUseCase(FakeAnimeCatalogueGateway()),
      ),
    )
    ..registerFactory<WatchlistCubit>(
      () => WatchlistCubit(getIt<LoadWatchlistUseCase>(), entries),
    );

  await tester.pumpWidget(const AnimeTrackerApp());
}

void main() {
  testWidgets('it shows a skeleton while the details are loading',
      (tester) async {
    await pumpWith(tester, const FakeAnimeDetailsGateway({1: bebop}));

    expect(find.byType(PlaqueRowSkeleton), findsOneWidget);

    await tester.pumpAndSettle();
    expect(find.byType(PlaqueRowSkeleton), findsNothing);
  });

  testWidgets('a loaded row shows the line coming from the gateway',
      (tester) async {
    await pumpWith(
      tester,
      const FakeAnimeDetailsGateway({1: bebop, 2: vinland}),
    );
    await tester.pumpAndSettle();

    expect(find.text('Vinland Saga'), findsOneWidget);
    expect(find.text('Série TV · 2019 · 24 épisodes'), findsOneWidget);
    expect(find.text('1 en cours · 1 en attente · 1 terminées'), findsOneWidget);
  });

  testWidgets('a row whose lookup failed says so instead of vanishing',
      (tester) async {
    await pumpWith(
      tester,
      const FakeAnimeDetailsGateway({1: bebop, 2: vinland}),
    );
    await tester.pumpAndSettle();

    await tester.tap(find.text('Terminé'));
    await tester.pumpAndSettle();

    expect(find.text('Death Note'), findsOneWidget);
    expect(find.text('Fiche indisponible'), findsOneWidget);
  });

  testWidgets('it offers a retry when every lookup failed', (tester) async {
    await pumpWith(tester, const FakeAnimeDetailsGateway({}, isDown: true));
    await tester.pumpAndSettle();

    expect(find.text('Impossible de charger les fiches'), findsOneWidget);
    expect(find.text('Réessayer'), findsOneWidget);
  });

  testWidgets('the titles show up before the details arrive', (tester) async {
    await pumpWith(
      tester,
      CountingAnimeDetailsGateway(
        bebop,
        answerDelay: const Duration(milliseconds: 300),
      ),
    );
    await tester.pump();
    await tester.pump();

    expect(find.text('Vinland Saga'), findsOneWidget);
    expect(find.text('Série TV · 1998 · 26 épisodes'), findsNothing);

    await tester.pump(const Duration(milliseconds: 400));
    await tester.pumpAndSettle();

    expect(find.text('Série TV · 1998 · 26 épisodes'), findsOneWidget);
  });
}
