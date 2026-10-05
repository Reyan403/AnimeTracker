import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:monapp/l10n/app_localizations_fr.dart';
import 'package:monapp/layers/functional/Animedex/domain/entities/card_rarity.dart';
import 'package:monapp/layers/functional/Animedex/domain/entities/dex_card.dart';
import 'package:monapp/layers/functional/Animedex/presentation/card/favourites_format.dart';
import 'package:monapp/layers/functional/Animedex/presentation/card/holographic_card.dart';
import 'package:monapp/layers/functional/Animedex/presentation/detail/dex_card_dialog.dart';
import 'package:monapp/layers/functional/Animedex/presentation/widgets/dex_card_tile.dart';

import 'ui_support.dart';

final DexCard solo = DexCard(
  characterId: 7,
  name: 'Solo',
  rarity: CardRarity.common,
  favourites: 1000,
  obtainedOn: fixedNow,
);

Future<void> openDialogOn(WidgetTester tester, String name) async {
  await tester.tap(find.widgetWithText(DexCardTile, name));
  await tester.pump();
  await tester.pump(const Duration(seconds: 1));
}

Future<void> teardown(WidgetTester tester) =>
    tester.pumpWidget(const SizedBox());

void main() {
  group('FavouritesFormat', () {
    final l10n = AppLocalizationsFr();

    test('petits nombres tels quels', () {
      expect(FavouritesFormat.of(l10n, 0), '0');
      expect(FavouritesFormat.of(l10n, 999), '999');
    });

    test('milliers avec une décimale à la française', () {
      expect(FavouritesFormat.of(l10n, 1000), '1 k');
      expect(FavouritesFormat.of(l10n, 12345), '12,3 k');
      expect(FavouritesFormat.of(l10n, 12999), '12,9 k');
      expect(FavouritesFormat.of(l10n, 150000), '150 k');
    });
  });

  group('DexCardDialog', () {
    testWidgets('toucher une carte de la collection ouvre le détail', (
      tester,
    ) async {
      await pumpDex(
        tester,
        dexCubitOf(collection: MemoryCollection(sampleCollection)),
        size: tallScreen,
      );
      await tester.tap(find.text('Collection'));
      await tester.pump(const Duration(seconds: 1));
      await openDialogOn(tester, 'Naruto Uzumaki');

      expect(find.byType(DexCardDialog), findsOneWidget);
      expect(find.text('Naruto Uzumaki'), findsNWidgets(3));
      expect(find.text('うずまきナルト'), findsOneWidget);
      expect(find.text('Anime d\'origine'), findsOneWidget);
      expect(find.text('Naruto'), findsNWidgets(3));
      expect(find.text('5 k favoris'), findsOneWidget);
      expect(find.text('Obtenue le 3 octobre 2026'), findsOneWidget);
      expect(find.widgetWithText(FilledButton, 'Fermer'), findsOneWidget);
      await teardown(tester);
    });

    testWidgets('la carte du détail est en mode vivant', (tester) async {
      await pumpDex(
        tester,
        dexCubitOf(collection: MemoryCollection(sampleCollection)),
        size: tallScreen,
      );
      await openDialogOn(tester, 'Zoro');

      final live = find.descendant(
        of: find.byType(DexCardDialog),
        matching: find.byType(HolographicCard),
      );

      expect(tester.widget<HolographicCard>(live).isLive, isTrue);
      expect(tester.hasRunningAnimations, isTrue);
      await teardown(tester);
    });

    testWidgets('Fermer referme le dialogue sans quitter l\'écran', (
      tester,
    ) async {
      await pumpDex(
        tester,
        dexCubitOf(collection: MemoryCollection(sampleCollection)),
        size: tallScreen,
      );
      await openDialogOn(tester, 'Zoro');

      await tester.tap(find.text('Fermer'));
      await tester.pump();
      await tester.pump(const Duration(seconds: 1));

      expect(find.byType(DexCardDialog), findsNothing);
      expect(find.text('Dernières cartes obtenues'), findsOneWidget);
      await teardown(tester);
    });

    testWidgets('sans nom natif ni anime : seules les infos connues', (
      tester,
    ) async {
      await pumpDex(
        tester,
        dexCubitOf(collection: MemoryCollection([solo])),
        size: tallScreen,
      );
      await openDialogOn(tester, 'Solo');

      expect(find.text('Anime d\'origine'), findsNothing);
      expect(find.text('1 k favoris'), findsOneWidget);
      await teardown(tester);
    });
  });
}
