import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:monapp/layers/functional/Discover/domain/entities/evening_mood.dart';
import 'package:monapp/layers/functional/Constellation/presentation/widgets/genre_legend.dart';
import 'package:monapp/layers/functional/Constellation/presentation/widgets/genre_legend_chip.dart';

import '../../../support/pump_app.dart';

const tenGenres = [
  EveningMood.relaxed,
  EveningMood.action,
  EveningMood.emotional,
  EveningMood.romance,
  EveningMood.mystery,
  EveningMood.fantasy,
  EveningMood.scienceFiction,
  EveningMood.supernatural,
  EveningMood.horror,
  EveningMood.sports,
];

const realisticTextScale = 0.6;

void main() {
  Future<void> pumpLegend(
    WidgetTester tester,
    Size size, {
    List<EveningMood> genres = tenGenres,
    String? selectedSlug,
    ValueChanged<String?>? onSelected,
    double textScale = realisticTextScale,
  }) => pumpApp(
    tester,
    Align(
      alignment: Alignment.topCenter,
      child: SizedBox(
        width: size.width,
        child: GenreLegend(
          genres: genres,
          selectedSlug: selectedSlug,
          onSelected: onSelected ?? (_) {},
        ),
      ),
    ),
    size: size,
    textScale: textScale,
  );

  void expectEveryChipFullyVisible(WidgetTester tester, Size size) {
    final chips = find.byType(GenreLegendChip);

    expect(chips, findsNWidgets(tenGenres.length));
    for (final chip in chips.evaluate()) {
      final rect =
          tester.getTopLeft(find.byWidget(chip.widget)) &
          tester.getSize(find.byWidget(chip.widget));

      expect(rect.left, greaterThanOrEqualTo(0));
      expect(rect.right, lessThanOrEqualTo(size.width));
    }
  }

  for (final size in const [Size(375, 812), Size(1200, 800)]) {
    testWidgets('affiche les 10 genres d un coup à ${size.width.toInt()} px', (
      tester,
    ) async {
      await pumpLegend(tester, size);

      expectEveryChipFullyVisible(tester, size);
      expect(tester.takeException(), isNull);
      expect(find.byType(ListView), findsNothing);
      expect(find.text('Sport'), findsOneWidget);
    });

    testWidgets('la légende reste sous un tiers de l écran à '
        '${size.width.toInt()} px', (tester) async {
      await pumpLegend(tester, size);

      final legendHeight = tester.getSize(find.byType(GenreLegend)).height;

      expect(legendHeight, lessThanOrEqualTo(size.height / 3));
      expect(find.byType(Scrollable), findsOneWidget);
      final scrollable = tester.state<ScrollableState>(find.byType(Scrollable));
      expect(scrollable.position.maxScrollExtent, 0);
    });
  }

  testWidgets('passe à la ligne sur mobile étroit', (tester) async {
    await pumpLegend(tester, const Size(375, 812));

    final tops = {
      for (final chip in find.byType(GenreLegendChip).evaluate())
        tester.getTopLeft(find.byWidget(chip.widget)).dy,
    };

    expect(tops.length, greaterThan(1));
  });

  testWidgets('police de test très large : aucun débordement, un tiers max', (
    tester,
  ) async {
    await pumpLegend(tester, const Size(375, 812), textScale: 1.3);

    expect(tester.takeException(), isNull);
    expectEveryChipFullyVisible(tester, const Size(375, 812));
    expect(
      tester.getSize(find.byType(GenreLegend)).height,
      lessThanOrEqualTo(812 / 3),
    );
  });

  testWidgets('défile verticalement seulement au-delà d un tiers d écran', (
    tester,
  ) async {
    final many = [
      for (var index = 0; index < 60; index++)
        EveningMood.values[1 + index % 10],
    ];

    await pumpLegend(tester, const Size(375, 812), genres: many);

    expect(
      tester.getSize(find.byType(GenreLegend)).height,
      lessThanOrEqualTo(812 / 3),
    );
    final scrollable = tester.state<ScrollableState>(find.byType(Scrollable));
    expect(scrollable.axisDirection, AxisDirection.down);
    expect(scrollable.position.maxScrollExtent, greaterThan(0));
  });

  testWidgets('toucher une pastille sélectionne son genre', (tester) async {
    String? picked = 'none';
    await pumpLegend(
      tester,
      const Size(375, 812),
      onSelected: (slug) => picked = slug,
    );

    await tester.tap(find.widgetWithText(GenreLegendChip, 'Émotion'));

    expect(picked, 'emotional');
  });

  testWidgets('toucher la pastille active retire le filtre', (tester) async {
    String? picked = 'none';
    await pumpLegend(
      tester,
      const Size(375, 812),
      selectedSlug: 'emotional',
      onSelected: (slug) => picked = slug,
    );

    await tester.tap(find.widgetWithText(GenreLegendChip, 'Émotion'));

    expect(picked, isNull);
  });

  testWidgets('une liste vide ne montre aucune pastille', (tester) async {
    await pumpLegend(tester, const Size(375, 812), genres: const []);

    expect(find.byType(GenreLegendChip), findsNothing);
    expect(tester.takeException(), isNull);
  });
}
