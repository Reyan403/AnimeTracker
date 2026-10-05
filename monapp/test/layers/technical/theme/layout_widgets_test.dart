import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:monapp/layers/technical/Theme/widgets/anime_poster.dart';
import 'package:monapp/layers/technical/Theme/widgets/content_width.dart';
import 'package:monapp/layers/technical/Theme/widgets/fade_on_change.dart';
import 'package:monapp/layers/technical/Theme/widgets/plaque_row_skeleton.dart';
import 'package:monapp/layers/technical/Theme/widgets/responsive_card_sliver.dart';
import 'package:monapp/layers/technical/Theme/widgets/skeleton_bar.dart';
import 'package:monapp/layers/technical/Theme/widgets/skeleton_box.dart';
import 'package:monapp/layers/technical/Theme/widgets/sliver_content_padding.dart';

import '../../../support/pump_app.dart';

Widget cardList(int count) => CustomScrollView(
      slivers: [
        SliverContentPadding(
          sliver: ResponsiveCardSliver(
            itemCount: count,
            itemBuilder: (context, index) => SizedBox(
              height: 152,
              child: Text('carte $index'),
            ),
          ),
        ),
      ],
    );

void main() {
  testWidgets('une seule colonne sur un écran étroit', (tester) async {
    await pumpApp(tester, cardList(4));

    expect(find.byType(SliverList), findsOneWidget);
    expect(find.byType(SliverGrid), findsNothing);
  });

  testWidgets('une grille sur un écran large', (tester) async {
    await pumpApp(tester, cardList(4), size: const Size(1200, 800));

    expect(find.byType(SliverGrid), findsOneWidget);
    expect(find.byType(SliverList), findsNothing);
  });

  testWidgets('le contenu est borné en largeur', (tester) async {
    await pumpApp(
      tester,
      const ContentWidth(
        child: SizedBox(key: Key('box'), width: double.infinity, height: 40),
      ),
      size: const Size(1600, 800),
    );

    expect(tester.getSize(find.byKey(const Key('box'))).width, 720);
  });

  testWidgets('les squelettes se dessinent et animent', (tester) async {
    await pumpApp(
      tester,
      const Column(children: [PlaqueRowSkeleton(rowCount: 2)]),
      settle: false,
    );
    await tester.pump(const Duration(milliseconds: 500));

    expect(find.byType(SkeletonBox), findsWidgets);
    expect(find.byType(SkeletonBar), findsWidgets);
  });

  testWidgets('les squelettes sont figés si les animations sont réduites',
      (tester) async {
    await pumpApp(
      tester,
      const SkeletonBox(height: 20, width: 100),
      disableAnimations: true,
    );

    expect(tester.hasRunningAnimations, isFalse);
  });

  testWidgets('FadeOnChange rejoue le fondu quand le déclencheur change',
      (tester) async {
    var trigger = 0;
    late StateSetter update;

    await pumpApp(
      tester,
      StatefulBuilder(
        builder: (context, setState) {
          update = setState;

          return FadeOnChange(trigger: trigger, child: const Text('vue'));
        },
      ),
    );

    update(() => trigger = 1);
    await tester.pump(const Duration(milliseconds: 50));

    expect(tester.hasRunningAnimations, isTrue);

    await tester.pumpAndSettle();

    expect(find.text('vue'), findsOneWidget);
  });

  testWidgets('FadeOnChange ne s anime pas si les animations sont réduites',
      (tester) async {
    var trigger = 0;
    late StateSetter update;

    await pumpApp(
      tester,
      StatefulBuilder(
        builder: (context, setState) {
          update = setState;

          return FadeOnChange(trigger: trigger, child: const Text('vue'));
        },
      ),
      disableAnimations: true,
    );

    update(() => trigger = 1);
    await tester.pump();

    expect(tester.hasRunningAnimations, isFalse);
  });

  testWidgets('l affiche affiche le repli sans URL, avec Hero', (tester) async {
    await pumpApp(
      tester,
      const AnimePoster(title: 'Naruto', heroTag: 'poster-test-1'),
    );

    expect(find.text('NA'), findsOneWidget);
    expect(find.byType(Hero), findsOneWidget);
  });

  testWidgets('l affiche sans Hero ni image reste simple', (tester) async {
    await pumpApp(tester, const AnimePoster(title: 'One Piece'));

    expect(find.byType(Hero), findsNothing);
    expect(find.text('ON'), findsOneWidget);
  });

  testWidgets('l affiche bascule sur le repli en cas d échec réseau',
      (tester) async {
    await pumpApp(
      tester,
      const AnimePoster(
        title: 'Bleach',
        imageUrl: 'https://example.invalid/poster.jpg',
      ),
    );
    await tester.pump(const Duration(milliseconds: 100));

    expect(find.text('BL'), findsOneWidget);
  });

  test('les étiquettes Hero distinguent les origines', () {
    expect(
      AnimePoster.heroTagFor('list', 1),
      isNot(AnimePoster.heroTagFor('catalogue', 1)),
    );
  });
}
