import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:monapp/layers/functional/Animedex/domain/entities/card_rarity.dart';
import 'package:monapp/layers/functional/Animedex/domain/entities/dex_card.dart';
import 'package:monapp/layers/functional/Animedex/presentation/card/holo_shine.dart';
import 'package:monapp/layers/functional/Animedex/presentation/card/holographic_card.dart';

import '../../../support/pump_app.dart';
import 'ui_support.dart';

Finder get shine => find.byType(HoloShine);

Widget cardWith(CardRarity rarity, {bool isLive = false}) => Center(
  child: SizedBox(
    width: 200,
    child: HolographicCard(
      card: cardOf(1, rarity: rarity, name: 'Naruto'),
      isLive: isLive,
    ),
  ),
);

void main() {
  group('HolographicCard', () {
    testWidgets('affiche nom, anime d\'origine, rareté et favoris', (
      tester,
    ) async {
      await pumpApp(tester, cardWith(CardRarity.epic));

      expect(find.text('Naruto'), findsOneWidget);
      expect(find.text('Anime 1'), findsOneWidget);
      expect(find.text('Épique'), findsOneWidget);
      expect(find.text('1 k'), findsOneWidget);
      expect(find.byIcon(Icons.favorite_rounded), findsOneWidget);
      expect(find.byIcon(Icons.star_rounded), findsNWidgets(3));
    });

    testWidgets('sans anime d\'origine : la ligne disparaît', (tester) async {
      await pumpApp(
        tester,
        Center(
          child: SizedBox(
            width: 200,
            child: HolographicCard(
              card: DexCard(
                characterId: 9,
                name: 'Inconnu',
                rarity: CardRarity.common,
                favourites: 12,
                obtainedOn: fixedNow,
              ),
            ),
          ),
        ),
      );

      expect(find.text('Inconnu'), findsOneWidget);
      expect(find.text('12'), findsOneWidget);
      expect(find.textContaining('Anime'), findsNothing);
    });

    testWidgets('pas de reflet pour une carte commune', (tester) async {
      await pumpApp(tester, cardWith(CardRarity.common));

      expect(shine, findsNothing);
    });

    for (final rarity in [
      CardRarity.rare,
      CardRarity.epic,
      CardRarity.legendary,
    ]) {
      testWidgets('reflet holographique pour ${rarity.name}', (tester) async {
        await pumpApp(tester, cardWith(rarity));

        expect(shine, findsOneWidget);
      });
    }

    testWidgets('reflet figé hors page booster', (tester) async {
      await pumpApp(tester, cardWith(CardRarity.legendary));

      expect(tester.hasRunningAnimations, isFalse);
    });

    testWidgets('reflet animé en mode vivant', (tester) async {
      await pumpApp(
        tester,
        cardWith(CardRarity.legendary, isLive: true),
        settle: false,
      );
      await tester.pump(const Duration(milliseconds: 500));

      expect(tester.hasRunningAnimations, isTrue);
    });

    testWidgets('réduction des animations : aucun reflet animé', (
      tester,
    ) async {
      await pumpApp(
        tester,
        cardWith(CardRarity.legendary, isLive: true),
        disableAnimations: true,
      );

      expect(tester.hasRunningAnimations, isFalse);
    });

    testWidgets('le survol anime puis arrête le reflet', (tester) async {
      await pumpApp(tester, cardWith(CardRarity.rare));
      final mouse = await tester.createGesture(kind: PointerDeviceKind.mouse);
      addTearDown(mouse.removePointer);

      await mouse.addPointer(location: Offset.zero);
      await mouse.moveTo(tester.getCenter(find.byType(HolographicCard)));
      await tester.pump(const Duration(milliseconds: 300));
      expect(tester.hasRunningAnimations, isTrue);

      await mouse.moveTo(const Offset(5, 5));
      await tester.pumpAndSettle();
      expect(tester.hasRunningAnimations, isFalse);
    });

    testWidgets('incline la carte au toucher en mode vivant', (tester) async {
      await pumpApp(
        tester,
        cardWith(CardRarity.epic, isLive: true),
        settle: false,
      );
      final center = tester.getCenter(find.byType(HolographicCard));
      final gesture = await tester.startGesture(center);

      await gesture.moveBy(const Offset(40, 20));
      await tester.pump();
      final tilted = tester.widget<Transform>(
        find
            .descendant(
              of: find.byType(HolographicCard),
              matching: find.byType(Transform),
            )
            .first,
      );

      expect(tilted.transform.storage[1], isNot(0));
      await gesture.up();
      await tester.pump();
    });

    testWidgets('sémantique : nom et rareté lus ensemble', (tester) async {
      final handle = tester.ensureSemantics();
      await pumpApp(tester, cardWith(CardRarity.rare));

      expect(find.bySemanticsLabel('Naruto, carte Rare'), findsOneWidget);
      handle.dispose();
    });
  });
}
