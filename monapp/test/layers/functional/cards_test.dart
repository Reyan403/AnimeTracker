import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:monapp/layers/functional/Anime/domain/entities/anime.dart';
import 'package:monapp/layers/functional/Anime/domain/entities/anime_details.dart';
import 'package:monapp/layers/functional/Anime/domain/entities/watch_status.dart';
import 'package:monapp/layers/functional/Anime/presentation/widgets/anime_card.dart';
import 'package:monapp/layers/functional/Catalogue/domain/entities/catalogue_anime.dart';
import 'package:monapp/layers/functional/Catalogue/presentation/widgets/catalogue_card.dart';
import 'package:monapp/layers/technical/Theme/widgets/anime_plaque.dart';

import '../../support/pump_app.dart';

const anime = Anime(
  id: 1,
  title: 'Cowboy Bebop',
  status: WatchStatus.watching,
  details: AnimeDetails(format: 'TV', year: 1998, episodeCount: 26),
);

const catalogueAnime = CatalogueAnime(
  id: 2,
  title: 'Trigun',
  format: 'TV',
  year: 1998,
  episodeCount: 26,
);

void main() {
  group('AnimeCard', () {
    testWidgets('affiche titre, méta, statut et repli d affiche',
        (tester) async {
      await pumpApp(
        tester,
        AnimeCard(anime: anime, onTap: () {}, onStatusSelected: (_) {}),
      );

      expect(find.text('Cowboy Bebop'), findsOneWidget);
      expect(find.text('TV · 1998 · 26 épisodes'), findsOneWidget);
      expect(find.text('En cours'), findsOneWidget);
      expect(find.byType(AnimePlaque), findsOneWidget);
    });

    testWidgets('indique une fiche indisponible sans détails', (tester) async {
      await pumpApp(
        tester,
        AnimeCard(
          anime: const Anime(id: 3, title: 'X', status: WatchStatus.toWatch),
          onTap: () {},
          onStatusSelected: (_) {},
        ),
      );

      expect(find.text('Fiche indisponible'), findsOneWidget);
    });

    testWidgets('réagit au toucher et au changement de statut',
        (tester) async {
      var opened = false;
      WatchStatus? chosen;

      await pumpApp(
        tester,
        AnimeCard(
          anime: anime,
          onTap: () => opened = true,
          onStatusSelected: (status) => chosen = status,
        ),
      );

      await tester.tap(find.text('Cowboy Bebop'));
      expect(opened, isTrue);

      await tester.tap(find.byType(PopupMenuButton<WatchStatus>));
      await tester.pumpAndSettle();
      await tester.tap(
        find.widgetWithText(CheckedPopupMenuItem<WatchStatus>, 'Terminé'),
      );
      await tester.pumpAndSettle();

      expect(chosen, WatchStatus.completed);
    });

    testWidgets('reste affichable avec un texte agrandi', (tester) async {
      await pumpApp(
        tester,
        AnimeCard(anime: anime, onTap: () {}, onStatusSelected: (_) {}),
        textScale: 2,
      );

      expect(tester.takeException(), isNull);
    });

    testWidgets('s affiche en mode sombre', (tester) async {
      await pumpApp(
        tester,
        AnimeCard(anime: anime, onTap: () {}, onStatusSelected: (_) {}),
        themeMode: ThemeMode.dark,
      );

      expect(find.text('Cowboy Bebop'), findsOneWidget);
    });
  });

  group('CatalogueCard', () {
    testWidgets('le bouton d ajout est actif puis déclenche l ajout',
        (tester) async {
      var added = false;

      await pumpApp(
        tester,
        CatalogueCard(
          anime: catalogueAnime,
          isListed: false,
          onTap: () {},
          onAdd: () => added = true,
        ),
      );

      await tester.tap(find.byIcon(Icons.add));

      expect(added, isTrue);
    });

    testWidgets('le bouton est désactivé quand l anime est listé',
        (tester) async {
      await pumpApp(
        tester,
        CatalogueCard(
          anime: catalogueAnime,
          isListed: true,
          onTap: () {},
          onAdd: () {},
        ),
      );

      expect(find.byIcon(Icons.check), findsOneWidget);
      expect(
        tester.widget<IconButton>(find.byType(IconButton)).onPressed,
        isNull,
      );
    });

    testWidgets('l icône s anime au passage à l état ajouté', (tester) async {
      var isListed = false;
      late StateSetter update;

      await pumpApp(
        tester,
        StatefulBuilder(
          builder: (context, setState) {
            update = setState;

            return CatalogueCard(
              anime: catalogueAnime,
              isListed: isListed,
              onTap: () {},
              onAdd: () {},
            );
          },
        ),
      );

      update(() => isListed = true);
      await tester.pump(const Duration(milliseconds: 100));

      expect(find.byType(AnimatedSwitcher), findsOneWidget);

      await tester.pumpAndSettle();

      expect(find.byIcon(Icons.check), findsOneWidget);
    });
  });
}
