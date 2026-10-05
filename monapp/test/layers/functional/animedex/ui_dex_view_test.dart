import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:monapp/layers/functional/Animedex/domain/entities/card_rarity.dart';
import 'package:monapp/layers/functional/Animedex/presentation/animedex_view.dart';
import 'package:monapp/layers/functional/Animedex/presentation/cubit/dex_cubit.dart';
import 'package:monapp/layers/functional/Animedex/presentation/cubit/dex_state.dart';
import 'package:monapp/layers/functional/Animedex/presentation/widgets/countdown_text.dart';
import 'package:monapp/layers/functional/Animedex/presentation/widgets/dex_card_tile.dart';

import '../../../support/pump_app.dart';
import 'ui_support.dart';

Future<DexCubit> pumpDex(
  WidgetTester tester,
  DexCubit cubit, {
  bool load = true,
}) async {
  if (load) {
    cubit.load();
  }

  await pumpApp(
    tester,
    BlocProvider.value(
      value: cubit,
      child: AnimedexScaffold(now: () => fixedNow),
    ),
    settle: false,
  );
  await tester.pump(const Duration(seconds: 1));

  return cubit;
}

Future<void> teardown(WidgetTester tester) =>
    tester.pumpWidget(const SizedBox());

void main() {
  group('DexCubit', () {
    test('commence en chargement', () {
      expect(dexCubitOf().state.status, DexStatus.loading);
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
      expect(cubit.state.cards.first.animeId, 2);
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

  group('AnimedexScaffold', () {
    testWidgets('affiche le titre, le compteur et les cartes', (tester) async {
      await pumpDex(
        tester,
        dexCubitOf(
          collection: MemoryCollection([
            cardOf(1, title: 'Naruto'),
            cardOf(2, rarity: CardRarity.rare, title: 'Bleach'),
          ]),
        ),
      );

      expect(find.text('Animédex'), findsOneWidget);
      expect(find.text('2 cartes'), findsOneWidget);
      expect(find.text('Naruto'), findsOneWidget);
      expect(find.text('Bleach'), findsOneWidget);
      expect(find.text('Rare 1'), findsOneWidget);
      expect(find.text('Légendaire 0'), findsOneWidget);
      expect(find.byType(DexCardTile), findsNWidgets(2));
      await teardown(tester);
    });

    testWidgets('booster disponible : bouton clair', (tester) async {
      await pumpDex(tester, dexCubitOf());

      expect(find.text('Ton booster du jour est prêt !'), findsOneWidget);
      expect(find.widgetWithText(FilledButton, 'Ouvrir'), findsOneWidget);
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
      expect(find.text('Ton Animédex est vide'), findsNothing);
      await teardown(tester);
    });

    testWidgets('état vide : invitation à ouvrir le premier booster', (
      tester,
    ) async {
      await pumpDex(tester, dexCubitOf());

      expect(find.text('Ton Animédex est vide'), findsOneWidget);
      expect(find.text('Ouvrir mon premier booster'), findsOneWidget);
      await teardown(tester);
    });

    testWidgets('état vide sans booster : pas d\'invitation', (tester) async {
      await pumpDex(tester, dexCubitOf(openedToday: true));

      expect(find.text('Ton Animédex est vide'), findsOneWidget);
      expect(find.text('Ouvrir mon premier booster'), findsNothing);
      await teardown(tester);
    });

    testWidgets('état d\'erreur : message et réessai', (tester) async {
      await pumpDex(tester, dexCubitOf(collection: ThrowingCollection()));

      expect(find.text('Impossible d\'afficher ton Animédex'), findsOneWidget);
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
