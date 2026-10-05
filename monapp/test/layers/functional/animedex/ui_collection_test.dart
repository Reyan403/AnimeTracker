import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:monapp/layers/functional/Animedex/presentation/cubit/dex_cubit.dart';
import 'package:monapp/layers/functional/Animedex/presentation/cubit/dex_filter.dart';
import 'package:monapp/layers/functional/Animedex/presentation/cubit/dex_state.dart';
import 'package:monapp/layers/functional/Animedex/presentation/widgets/dex_card_tile.dart';
import 'package:monapp/layers/functional/Animedex/presentation/widgets/dex_filter_chip.dart';
import 'package:monapp/layers/functional/Animedex/presentation/widgets/rarity_count_chip.dart';
import 'package:monapp/layers/functional/Animedex/presentation/widgets/rarity_distribution_bar.dart';

import 'ui_support.dart';

Future<DexCubit> pumpCollection(
  WidgetTester tester, {
  DexCubit? cubit,
  bool load = true,
}) async {
  final dex =
      cubit ?? dexCubitOf(collection: MemoryCollection(sampleCollection));
  await pumpDex(tester, dex, load: load, size: tallScreen);
  await tester.tap(find.text('Collection'));
  await tester.pump(const Duration(seconds: 1));

  return dex;
}

Future<void> teardown(WidgetTester tester) =>
    tester.pumpWidget(const SizedBox());

void main() {
  group('onglet Collection', () {
    testWidgets('compteur, répartition par rareté, recherche et tri', (
      tester,
    ) async {
      final cubit = await pumpCollection(tester);

      expect(cubit.state.tab, DexTab.collection);
      expect(find.text('5 personnages'), findsNWidgets(2));
      expect(find.byType(RarityDistributionBar), findsOneWidget);
      expect(find.byType(RarityCountChip), findsNWidgets(4));
      expect(find.text('Rare 1'), findsOneWidget);
      expect(find.text('Légendaire 1'), findsOneWidget);
      expect(find.byType(TextField), findsOneWidget);
      expect(find.text('Plus récentes'), findsOneWidget);
      expect(find.byType(DexCardTile), findsNWidgets(5));
      expect(find.text('Dernières cartes obtenues'), findsNothing);
      await teardown(tester);
    });

    testWidgets('revenir sur l\'onglet Booster', (tester) async {
      final cubit = await pumpCollection(tester);

      await tester.tap(find.text('Booster'));
      await tester.pump(const Duration(seconds: 1));

      expect(cubit.state.tab, DexTab.booster);
      expect(find.byType(TextField), findsNothing);
      await teardown(tester);
    });

    testWidgets('la recherche filtre la grille sans tenir compte des accents', (
      tester,
    ) async {
      await pumpCollection(tester);

      await tester.enterText(find.byType(TextField), 'elise');
      await tester.pump(const Duration(seconds: 1));

      expect(tileNames(tester), ['Élise Moreau']);
      expect(find.text('1 personnage'), findsOneWidget);
      await teardown(tester);
    });

    testWidgets('filtre de rareté cliquable puis retour à Toutes', (
      tester,
    ) async {
      await pumpCollection(tester);

      await tester.tap(find.widgetWithText(DexFilterChip, 'Épique'));
      await tester.pump(const Duration(seconds: 1));
      expect(tileNames(tester), ['Light Yagami']);

      await tester.tap(find.widgetWithText(DexFilterChip, 'Toutes'));
      await tester.pump(const Duration(seconds: 1));
      expect(find.byType(DexCardTile), findsNWidgets(5));
      await teardown(tester);
    });

    testWidgets('le menu de tri réordonne la grille', (tester) async {
      final cubit = await pumpCollection(tester);

      await tester.tap(find.text('Plus récentes'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Nom A → Z').last);
      await tester.pumpAndSettle();

      expect(cubit.state.filter.sort, DexSort.name);
      expect(tileNames(tester).first, 'Élise Moreau');
      expect(find.text('Nom A → Z'), findsOneWidget);
      await teardown(tester);
    });

    testWidgets('aucun résultat : message et réinitialisation', (tester) async {
      final cubit = await pumpCollection(tester);

      await tester.enterText(find.byType(TextField), 'zzz');
      await tester.pump(const Duration(seconds: 1));

      expect(find.text('Aucun personnage trouvé'), findsOneWidget);
      expect(find.byType(DexCardTile), findsNothing);

      await tester.tap(find.text('Réinitialiser les filtres'));
      await tester.pump(const Duration(seconds: 1));

      expect(cubit.state.filter.isActive, isFalse);
      expect(find.byType(DexCardTile), findsNWidgets(5));
      expect(
        tester.widget<TextField>(find.byType(TextField)).controller?.text,
        '',
      );
      await teardown(tester);
    });

    testWidgets('la croix efface la recherche', (tester) async {
      final cubit = await pumpCollection(tester);

      await tester.enterText(find.byType(TextField), 'zoro');
      await tester.pump();
      await tester.tap(find.byTooltip('Effacer la recherche'));
      await tester.pump(const Duration(seconds: 1));

      expect(cubit.state.filter.query, '');
      expect(find.byType(DexCardTile), findsNWidgets(5));
      await teardown(tester);
    });

    testWidgets('collection vide : invitation à ouvrir un booster', (
      tester,
    ) async {
      await pumpCollection(tester, cubit: dexCubitOf());

      expect(find.text('Ta collection est vide'), findsOneWidget);
      expect(find.text('Ouvrir mon premier booster'), findsOneWidget);
      expect(find.byType(TextField), findsNothing);
      await teardown(tester);
    });

    testWidgets('collection vide sans booster : pas d\'invitation', (
      tester,
    ) async {
      await pumpCollection(tester, cubit: dexCubitOf(openedToday: true));

      expect(find.text('Ta collection est vide'), findsOneWidget);
      expect(find.text('Ouvrir mon premier booster'), findsNothing);
      await teardown(tester);
    });

    testWidgets('erreur : message et réessai', (tester) async {
      await pumpCollection(
        tester,
        cubit: dexCubitOf(collection: ThrowingCollection()),
      );

      expect(find.text('Impossible d\'afficher ta collection'), findsOneWidget);
      expect(find.text('Réessayer'), findsOneWidget);
      await teardown(tester);
    });

    testWidgets('chargement : squelettes', (tester) async {
      await pumpCollection(tester, cubit: dexCubitOf(), load: false);

      expect(find.byType(DexCardTile), findsNothing);
      await teardown(tester);
    });
  });
}
