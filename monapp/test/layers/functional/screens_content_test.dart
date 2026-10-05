import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:monapp/layers/functional/Anime/domain/entities/anime.dart';
import 'package:monapp/layers/functional/Anime/domain/entities/watch_status.dart';
import 'package:monapp/layers/functional/Anime/presentation/cubit/watchlist_state.dart';
import 'package:monapp/layers/functional/Anime/presentation/widgets/watch_status_tabs.dart';
import 'package:monapp/layers/functional/Anime/presentation/widgets/watchlist_header.dart';
import 'package:monapp/layers/functional/Anime/presentation/widgets/watchlist_results_sliver.dart';
import 'package:monapp/layers/functional/Catalogue/domain/entities/anime_sheet.dart';
import 'package:monapp/layers/functional/Catalogue/domain/entities/catalogue_anime.dart';
import 'package:monapp/layers/functional/Catalogue/presentation/cubit/catalogue_state.dart';
import 'package:monapp/layers/functional/Catalogue/presentation/widgets/anime_sheet_body.dart';
import 'package:monapp/layers/functional/Catalogue/presentation/widgets/anime_sheet_cover.dart';
import 'package:monapp/layers/functional/Catalogue/presentation/widgets/catalogue_error.dart';
import 'package:monapp/layers/functional/Catalogue/presentation/widgets/catalogue_results_sliver.dart';
import 'package:monapp/layers/functional/Catalogue/presentation/widgets/catalogue_search_field.dart';

import '../../support/pump_app.dart';

Widget scroll(Widget sliver) => CustomScrollView(slivers: [sliver]);

WatchlistResultsSliver watchlistSliver(
  WatchlistState state, {
  VoidCallback? onRetry,
  void Function(int, String)? onSelected,
}) =>
    WatchlistResultsSliver(
      state: state,
      onRetry: onRetry ?? () {},
      onAnimeSelected: onSelected ?? (_, _) {},
      onStatusChanged: (_, _) {},
      onNextEpisode: (_) {},
      onPreviousEpisode: (_) {},
    );

CatalogueResultsSliver catalogueSliver(
  CatalogueState state, {
  VoidCallback? onRetry,
  ValueChanged<CatalogueAnime>? onAdd,
}) =>
    CatalogueResultsSliver(
      state: state,
      onRetry: onRetry ?? () {},
      onAnimeSelected: (_) {},
      onAdd: onAdd ?? (_) {},
    );

const tracked = Anime(id: 1, title: 'Monster', status: WatchStatus.watching);
const catalogued = CatalogueAnime(
  id: 9,
  title: 'Berserk',
  format: 'TV',
  year: 1997,
  episodeCount: 25,
);

void main() {
  group('Ma liste', () {
    testWidgets('affiche les squelettes pendant le chargement',
        (tester) async {
      await pumpApp(
        tester,
        scroll(watchlistSliver(const WatchlistState())),
        settle: false,
      );

      expect(find.byType(Card), findsWidgets);
    });

    testWidgets('affiche l état vide', (tester) async {
      await pumpApp(
        tester,
        scroll(
          watchlistSliver(const WatchlistState(status: ViewStatus.empty)),
        ),
      );

      expect(find.text('Aucun animé dans cet onglet.'), findsOneWidget);
    });

    testWidgets('affiche l erreur et permet de réessayer', (tester) async {
      var retried = false;

      await pumpApp(
        tester,
        scroll(
          watchlistSliver(
            const WatchlistState(status: ViewStatus.failure),
            onRetry: () => retried = true,
          ),
        ),
      );
      await tester.tap(find.text('Réessayer'));

      expect(retried, isTrue);
    });

    testWidgets('affiche les cartes et ouvre la fiche', (tester) async {
      int? opened;

      await pumpApp(
        tester,
        scroll(
          watchlistSliver(
            const WatchlistState(
              status: ViewStatus.success,
              animes: [tracked],
            ),
            onSelected: (id, _) => opened = id,
          ),
        ),
      );
      await tester.tap(find.text('Monster'));

      expect(opened, 1);
    });

    testWidgets('les onglets comptent et changent de statut', (tester) async {
      WatchStatus? chosen;

      await pumpApp(
        tester,
        WatchStatusTabs(
          state: const WatchlistState(animes: [tracked]),
          onSelected: (status) => chosen = status,
        ),
      );
      await tester.tap(find.text('Terminé'));

      expect(chosen, WatchStatus.completed);
      expect(find.text('1'), findsOneWidget);
    });

    testWidgets('le titre de l écran est affiché', (tester) async {
      await pumpApp(tester, const WatchlistHeader());

      expect(find.text('Ma liste'), findsOneWidget);
    });
  });

  group('Catalogue', () {
    testWidgets('affiche les squelettes pendant le chargement',
        (tester) async {
      await pumpApp(
        tester,
        scroll(catalogueSliver(const CatalogueState())),
        settle: false,
      );

      expect(find.byType(Card), findsWidgets);
    });

    testWidgets('affiche le catalogue vide puis la recherche vide',
        (tester) async {
      await pumpApp(
        tester,
        scroll(
          catalogueSliver(
            const CatalogueState(status: CatalogueStatus.empty),
          ),
        ),
      );
      expect(find.text('Le catalogue est vide pour le moment.'), findsOneWidget);

      await pumpApp(
        tester,
        scroll(
          catalogueSliver(
            const CatalogueState(status: CatalogueStatus.empty, query: 'zzz'),
          ),
        ),
      );
      expect(
        find.text('Aucun animé ne correspond à cette recherche.'),
        findsOneWidget,
      );
    });

    testWidgets('affiche l erreur et permet de réessayer', (tester) async {
      var retried = false;

      await pumpApp(
        tester,
        scroll(
          catalogueSliver(
            const CatalogueState(status: CatalogueStatus.failure),
            onRetry: () => retried = true,
          ),
        ),
      );
      await tester.tap(find.text('Réessayer'));

      expect(retried, isTrue);
    });

    testWidgets('affiche les cartes et ajoute à la liste', (tester) async {
      CatalogueAnime? added;

      await pumpApp(
        tester,
        scroll(
          catalogueSliver(
            const CatalogueState(
              status: CatalogueStatus.success,
              animes: [catalogued],
            ),
            onAdd: (anime) => added = anime,
          ),
        ),
      );
      await tester.tap(find.byIcon(Icons.add));

      expect(added, catalogued);
    });

    testWidgets('la recherche relaie la saisie et se vide', (tester) async {
      final controller = TextEditingController();
      addTearDown(controller.dispose);
      String? typed;
      var cleared = false;

      await pumpApp(
        tester,
        CatalogueSearchField(
          controller: controller,
          onChanged: (value) => typed = value,
          onCleared: () => cleared = true,
        ),
      );
      await tester.enterText(find.byType(TextField), 'bleach');
      await tester.pump();

      expect(typed, 'bleach');

      await tester.tap(find.byIcon(Icons.close));

      expect(cleared, isTrue);
    });

    testWidgets('l erreur accepte un titre personnalisé', (tester) async {
      await pumpApp(
        tester,
        CatalogueError(onRetry: () {}, title: 'Titre perso'),
      );

      expect(find.text('Titre perso'), findsOneWidget);
    });
  });

  group('Fiche anime', () {
    const sheet = AnimeSheet(
      id: 4,
      title: 'Vinland Saga',
      format: 'TV',
      synopsis: 'Une saga viking.',
      status: 'Terminé',
      startYear: 2019,
      endYear: 2023,
      episodeCount: 48,
      episodeMinutes: 24,
      totalMinutes: 1152,
      rating: 87,
      ratingRank: 12,
      popularityRank: 30,
      memberCount: 120000,
      favoriteCount: 4500,
      ageRating: 'R',
    );

    testWidgets('affiche synopsis et faits clés', (tester) async {
      await pumpApp(
        tester,
        const AnimeSheetBody(sheet: sheet, heroTag: 'poster-test-4'),
      );

      expect(find.text('Vinland Saga'), findsOneWidget);
      expect(find.text('Une saga viking.'), findsOneWidget);
      expect(find.text('48 épisodes de 24 min'), findsOneWidget);
      expect(find.text('2019 – 2023'), findsOneWidget);
      expect(find.text('19 h'), findsOneWidget);
      expect(find.text('87 %'), findsOneWidget);
      expect(find.text('12e'), findsOneWidget);
      expect(find.text('120 000'), findsOneWidget);
    });

    testWidgets('gère une fiche minimale sans synopsis', (tester) async {
      await pumpApp(
        tester,
        const AnimeSheetBody(
          sheet: AnimeSheet(id: 5, title: 'Court', format: 'OVA'),
          heroTag: 'poster-test-5',
        ),
      );

      expect(find.text('Synopsis'), findsNothing);
      expect(find.text('OVA'), findsOneWidget);
    });

    testWidgets('gère durée seule et année de diffusion unique',
        (tester) async {
      await pumpApp(
        tester,
        const AnimeSheetBody(
          sheet: AnimeSheet(
            id: 6,
            title: 'Film',
            format: 'Film',
            startYear: 2016,
            episodeMinutes: 107,
            totalMinutes: 30,
          ),
          heroTag: 'poster-test-6',
        ),
      );

      expect(find.text('107 min par épisode'), findsOneWidget);
      expect(find.text('2016'), findsOneWidget);
      expect(find.text('Durée totale'), findsNothing);
    });

    testWidgets('la couverture est absente sans URL', (tester) async {
      await pumpApp(tester, const AnimeSheetCover(imageUrl: null));

      expect(find.byType(Image), findsNothing);
    });

    testWidgets('la couverture se replie en cas d échec réseau',
        (tester) async {
      await pumpApp(
        tester,
        const AnimeSheetCover(imageUrl: 'https://example.invalid/cover.jpg'),
      );
      await tester.pump(const Duration(milliseconds: 100));

      expect(find.byType(ColoredBox), findsWidgets);
    });
  });
}
