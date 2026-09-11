import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:monapp/layers/functional/Catalogue/domain/entities/catalogue_anime.dart';
import 'package:monapp/layers/functional/Catalogue/domain/entities/anime_sheet.dart';
import 'package:monapp/layers/functional/Catalogue/domain/gateways/anime_catalogue_gateway.dart';
import 'package:monapp/layers/functional/Catalogue/domain/use_cases/browse_catalogue_use_case.dart';
import 'package:monapp/layers/functional/Catalogue/presentation/catalogue_view.dart';
import 'package:monapp/layers/functional/Catalogue/domain/use_cases/load_anime_sheet_use_case.dart';
import 'package:monapp/layers/functional/Catalogue/presentation/cubit/anime_sheet_cubit.dart';
import 'package:monapp/layers/functional/Catalogue/presentation/cubit/catalogue_cubit.dart';
import 'package:monapp/layers/technical/Injection/injection.dart';
import 'package:monapp/layers/technical/Theme/widgets/plaque_row_skeleton.dart';

import 'fake_anime_catalogue_gateway.dart';
import 'fake_anime_sheet_gateway.dart';
import 'fake_french_synopsis_gateway.dart';

const bebop = CatalogueAnime(
  id: 1,
  title: 'Cowboy Bebop',
  format: 'TV',
  year: 1998,
  episodeCount: 26,
);

const frieren = CatalogueAnime(
  id: 52991,
  title: 'Sousou no Frieren',
  format: 'TV',
  year: 2023,
  episodeCount: 28,
);

const mob = CatalogueAnime(
  id: 32182,
  title: 'Mob Psycho 100',
  format: 'TV',
  year: 2016,
  episodeCount: 12,
);

const bebopSheet = AnimeSheet(
  id: 1,
  title: 'Cowboy Bebop',
  format: 'Série TV',
  synopsis: 'Spike Spiegel chasse les primes à bord du Bebop.',
);

FakeAnimeCatalogueGateway stockedGateway() => FakeAnimeCatalogueGateway(
      mostPopular: const [bebop, mob],
      resultsByQuery: const {
        'frieren': [frieren],
      },
      pageSize: 1,
    );

Future<void> scrollToBottom(WidgetTester tester) async {
  await tester.drag(find.byType(ListView), const Offset(0, -600));
  await tester.pumpAndSettle();
}

Future<void> pumpWith(
  WidgetTester tester,
  AnimeCatalogueGateway gateway,
) async {
  await getIt.reset();
  getIt
    ..registerFactory<CatalogueCubit>(
      () => CatalogueCubit(BrowseCatalogueUseCase(gateway)),
    )
    ..registerFactory<AnimeSheetCubit>(
      () => AnimeSheetCubit(
        LoadAnimeSheetUseCase(
          FakeAnimeSheetGateway(sheetsById: const {1: bebopSheet}),
          FakeFrenchSynopsisGateway(),
        ),
      ),
    );

  await tester.pumpWidget(const MaterialApp(home: CatalogueView()));
}

Future<void> typeQuery(WidgetTester tester, String query) async {
  await tester.enterText(find.byType(TextField), query);
  await tester.pump(CatalogueCubit.typingPause);
  await tester.pumpAndSettle();
}

void main() {
  testWidgets('it shows a skeleton while the catalogue loads', (tester) async {
    await pumpWith(tester, stockedGateway());

    expect(find.byType(PlaqueRowSkeleton), findsOneWidget);

    await tester.pumpAndSettle();
    expect(find.byType(PlaqueRowSkeleton), findsNothing);
  });

  testWidgets('it lists the animes coming from the API', (tester) async {
    await pumpWith(tester, stockedGateway());
    await tester.pumpAndSettle();

    expect(find.text('Catalogue'), findsOneWidget);
    expect(find.text('Cowboy Bebop'), findsOneWidget);
    expect(find.text('TV · 1998 · 26 épisodes'), findsOneWidget);
  });

  testWidgets('a search replaces the list with its results', (tester) async {
    await pumpWith(tester, stockedGateway());
    await tester.pumpAndSettle();

    await typeQuery(tester, 'frieren');

    expect(find.text('Sousou no Frieren'), findsOneWidget);
    expect(find.text('Cowboy Bebop'), findsNothing);
  });

  testWidgets('clearing the search restores the popular animes',
      (tester) async {
    await pumpWith(tester, stockedGateway());
    await tester.pumpAndSettle();

    await typeQuery(tester, 'frieren');
    await tester.tap(find.byTooltip('Effacer'));
    await tester.pumpAndSettle();

    expect(find.text('frieren'), findsNothing);
    expect(find.text('Cowboy Bebop'), findsOneWidget);
  });

  testWidgets('a search without match says so', (tester) async {
    await pumpWith(tester, stockedGateway());
    await tester.pumpAndSettle();

    await typeQuery(tester, 'introuvable');

    expect(
      find.text('Aucun animé ne correspond à cette recherche.'),
      findsOneWidget,
    );
  });

  testWidgets('an unreachable service offers a retry', (tester) async {
    await pumpWith(tester, FakeAnimeCatalogueGateway(isDown: true));
    await tester.pumpAndSettle();

    expect(find.text('Impossible de charger le catalogue'), findsOneWidget);
    expect(find.text('Réessayer'), findsOneWidget);
  });

  testWidgets('reaching the bottom loads the next page', (tester) async {
    await pumpWith(tester, stockedGateway());
    await tester.pumpAndSettle();

    expect(find.text('Mob Psycho 100'), findsNothing);

    await scrollToBottom(tester);

    expect(find.text('Cowboy Bebop'), findsOneWidget);
    expect(find.text('Mob Psycho 100'), findsOneWidget);
  });

  testWidgets('it stops asking once the last page is shown', (tester) async {
    final gateway = stockedGateway();
    await pumpWith(tester, gateway);
    await tester.pumpAndSettle();

    await scrollToBottom(tester);
    await scrollToBottom(tester);

    expect(gateway.receivedPages, [1, 2]);
  });

  testWidgets('tapping an anime opens its sheet', (tester) async {
    await pumpWith(tester, stockedGateway());
    await tester.pumpAndSettle();

    await tester.tap(find.text('Cowboy Bebop'));
    await tester.pumpAndSettle();

    expect(find.text('Synopsis'), findsOneWidget);
    expect(
      find.text('Spike Spiegel chasse les primes à bord du Bebop.'),
      findsOneWidget,
    );
  });
}
