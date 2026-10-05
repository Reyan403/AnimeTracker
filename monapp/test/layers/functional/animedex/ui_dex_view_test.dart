import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:monapp/layers/functional/Animedex/domain/entities/card_rarity.dart';
import 'package:monapp/layers/functional/Animedex/presentation/cubit/dex_state.dart';
import 'package:monapp/layers/functional/Animedex/presentation/widgets/countdown_text.dart';
import 'package:monapp/layers/functional/Animedex/presentation/widgets/dex_card_tile.dart';

import '../../../support/pump_app.dart';
import 'ui_support.dart';

Future<void> teardown(WidgetTester tester) =>
    tester.pumpWidget(const SizedBox());

void main() {
  group('DexCubit', () {
    test('commence en chargement sur l\'onglet Booster', () {
      final state = dexCubitOf().state;

      expect(state.status, DexStatus.loading);
      expect(state.tab, DexTab.booster);
    });

    test('collection vide : état vide, booster disponible', () {
      final cubit = dexCubitOf()..load();

      expect(cubit.state.status, DexStatus.empty);
      expect(cubit.state.isBoosterAvailable, isTrue);
    });

    test('cartes triées par rareté et comptées', () {
      final cubit = dexCubitOf(
        collection: MemoryCollection([
          cardOf(1),
          cardOf(2, rarity: CardRarity.legendary),
          cardOf(3, rarity: CardRarity.rare),
          cardOf(4),
        ]),
        openedToday: true,
      )..load();

      expect(cubit.state.status, DexStatus.success);
      expect(cubit.state.cards.first.characterId, 2);
      expect(cubit.state.countOf(CardRarity.common), 2);
      expect(cubit.state.countOf(CardRarity.epic), 0);
      expect(cubit.state.isBoosterAvailable, isFalse);
    });

    test('échec de lecture : état d\'erreur', () {
      final cubit = dexCubitOf(collection: ThrowingCollection())..load();

      expect(cubit.state.status, DexStatus.failure);
    });
  });

  group('CountdownText', () {
    test('formate heures, minutes et secondes', () {
      expect(
        CountdownText.format(const Duration(hours: 3, minutes: 4, seconds: 5)),
        '03:04:05',
      );
    });

    testWidgets('décompte chaque seconde puis prévient à zéro', (tester) async {
      var current = fixedNow;
      var elapsed = 0;

      await pumpApp(
        tester,
        CountdownText(
          target: fixedNow.add(const Duration(seconds: 2)),
          now: () => current,
          onElapsed: () => elapsed++,
        ),
        settle: false,
      );
      expect(find.text('00:00:02'), findsOneWidget);

      current = current.add(const Duration(seconds: 1));
      await tester.pump(const Duration(seconds: 1));
      expect(find.text('00:00:01'), findsOneWidget);
      expect(elapsed, 0);

      current = current.add(const Duration(seconds: 1));
      await tester.pump(const Duration(seconds: 1));
      expect(find.text('00:00:00'), findsOneWidget);
      expect(elapsed, 1);

      await teardown(tester);
    });

    testWidgets('prévient tout de suite si l\'échéance est passée', (
      tester,
    ) async {
      var elapsed = 0;

      await pumpApp(
        tester,
        CountdownText(
          target: fixedNow.subtract(const Duration(seconds: 1)),
          now: () => fixedNow,
          onElapsed: () => elapsed++,
        ),
        settle: false,
      );
      await tester.pump();

      expect(elapsed, 1);
      await teardown(tester);
    });
  });

  group('AnimedexScaffold, onglet Booster', () {
    testWidgets('titre, onglets et dernières cartes obtenues', (tester) async {
      await pumpDex(
        tester,
        dexCubitOf(collection: MemoryCollection(sampleCollection)),
      );

      expect(find.text('Animédex'), findsOneWidget);
      expect(find.text('Booster'), findsOneWidget);
      expect(find.text('Collection'), findsOneWidget);
      expect(find.text('Dernières cartes obtenues'), findsOneWidget);
      expect(tileNames(tester), ['Zoro', 'Light Yagami']);
      expect(find.byType(TextField), findsNothing);
      await teardown(tester);
    });

    testWidgets('booster disponible : bouton clair', (tester) async {
      await pumpDex(tester, dexCubitOf());

      expect(find.text('Ton booster du jour est prêt !'), findsOneWidget);
      expect(find.widgetWithText(FilledButton, 'Ouvrir'), findsOneWidget);
      expect(find.text('Dernières cartes obtenues'), findsNothing);
      await teardown(tester);
    });

    testWidgets('booster ouvert : compte à rebours jusqu\'à minuit', (
      tester,
    ) async {
      await pumpDex(tester, dexCubitOf(openedToday: true));

      expect(find.text('Prochain booster dans'), findsOneWidget);
      expect(find.text('03:29:45'), findsOneWidget);
      expect(find.widgetWithText(FilledButton, 'Ouvrir'), findsNothing);
      await teardown(tester);
    });

    testWidgets('état de chargement : squelettes', (tester) async {
      await pumpDex(tester, dexCubitOf(), load: false);

      expect(find.byType(DexCardTile), findsNothing);
      expect(find.text('Dernières cartes obtenues'), findsNothing);
      await teardown(tester);
    });

    testWidgets('état d\'erreur : message et réessai', (tester) async {
      await pumpDex(tester, dexCubitOf(collection: ThrowingCollection()));

      expect(find.text('Impossible d\'afficher ta collection'), findsOneWidget);
      expect(find.textContaining('broken'), findsNothing);
      expect(find.text('Réessayer'), findsOneWidget);
      await teardown(tester);
    });

    testWidgets('toucher une tuile appelle son action', (tester) async {
      var tapped = 0;

      await pumpApp(
        tester,
        SizedBox(
          width: 180,
          child: DexCardTile(card: cardOf(1), onTap: () => tapped++),
        ),
      );
      await tester.tap(find.byType(DexCardTile));

      expect(tapped, 1);
    });
  });
}
