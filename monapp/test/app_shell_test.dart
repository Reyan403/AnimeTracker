import 'package:flutter_test/flutter_test.dart';
import 'package:monapp/layers/functional/Anime/domain/entities/watch_status.dart';
import 'package:monapp/layers/functional/Anime/domain/entities/watchlist_entry.dart';
import 'package:monapp/layers/functional/Anime/domain/use_cases/load_watchlist_use_case.dart';
import 'package:monapp/layers/functional/Anime/presentation/cubit/watchlist_cubit.dart';
import 'package:monapp/layers/functional/Catalogue/domain/entities/catalogue_anime.dart';
import 'package:monapp/layers/functional/Catalogue/domain/use_cases/browse_catalogue_use_case.dart';
import 'package:monapp/layers/functional/Catalogue/presentation/cubit/catalogue_cubit.dart';
import 'package:monapp/layers/technical/Injection/injection.dart';
import 'package:monapp/main.dart';

import 'fake_anime_catalogue_gateway.dart';
import 'fake_anime_details_gateway.dart';

const entries = [
  WatchlistEntry(id: 1, title: 'Cowboy Bebop', status: WatchStatus.toWatch),
];

const frieren = CatalogueAnime(
  id: 52991,
  title: 'Sousou no Frieren',
  format: 'TV',
  year: 2023,
  episodeCount: 28,
);

Future<void> pumpShell(WidgetTester tester) async {
  await getIt.reset();
  getIt
    ..registerLazySingleton<LoadWatchlistUseCase>(
      () => const LoadWatchlistUseCase(FakeAnimeDetailsGateway({})),
    )
    ..registerFactory<WatchlistCubit>(
      () => WatchlistCubit(getIt<LoadWatchlistUseCase>(), entries),
    )
    ..registerFactory<CatalogueCubit>(
      () => CatalogueCubit(
        BrowseCatalogueUseCase(
          FakeAnimeCatalogueGateway(mostPopular: const [frieren]),
        ),
      ),
    );

  await tester.pumpWidget(const AnimeTrackerApp());
  await tester.pumpAndSettle();
}

void main() {
  testWidgets('both menus are reachable from the bottom bar', (tester) async {
    await pumpShell(tester);

    expect(find.text('Liste'), findsOneWidget);
    expect(find.text('Catalogue'), findsWidgets);
  });

  testWidgets('the app opens on the Liste menu', (tester) async {
    await pumpShell(tester);

    expect(find.text('Ma liste'), findsOneWidget);
  });

  testWidgets('tapping Catalogue shows the animes of the API', (tester) async {
    await pumpShell(tester);

    await tester.tap(find.text('Catalogue').last);
    await tester.pumpAndSettle();

    expect(find.text('Sousou no Frieren'), findsOneWidget);
  });

  testWidgets('coming back to Liste keeps it loaded', (tester) async {
    await pumpShell(tester);

    await tester.tap(find.text('Catalogue').last);
    await tester.pumpAndSettle();
    await tester.tap(find.text('Liste'));
    await tester.pumpAndSettle();

    expect(find.text('Ma liste'), findsOneWidget);
  });
}
