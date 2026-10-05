import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:monapp/layers/functional/Anime/domain/entities/anime_genre.dart';
import 'package:monapp/layers/functional/Constellation/presentation/widgets/genre_legend.dart';
import 'package:monapp/layers/functional/Constellation/presentation/widgets/genre_legend_chip.dart';

import '../../../support/pump_app.dart';

const twelveGenres = [
  AnimeGenre(slug: 'action', title: 'Action'),
  AnimeGenre(slug: 'adventure', title: 'Aventure'),
  AnimeGenre(slug: 'comedy', title: 'Comédie'),
  AnimeGenre(slug: 'drama', title: 'Drame'),
  AnimeGenre(slug: 'fantasy', title: 'Fantastique'),
  AnimeGenre(slug: 'horror', title: 'Horreur'),
  AnimeGenre(slug: 'mystery', title: 'Mystère'),
  AnimeGenre(slug: 'romance', title: 'Romance'),
  AnimeGenre(slug: 'science-fiction', title: 'Science-fiction'),
  AnimeGenre(slug: 'slice-of-life', title: 'Tranche de vie'),
  AnimeGenre(slug: 'supernatural', title: 'Surnaturel'),
  AnimeGenre(slug: 'psychological', title: 'Psychologique'),
];

const realisticTextScale = 0.6;

void main() {
  Future<void> pumpLegend(
    WidgetTester tester,
    Size size, {
    List<AnimeGenre> genres = twelveGenres,
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

    expect(chips, findsNWidgets(twelveGenres.length));
    for (final chip in chips.evaluate()) {
      final rect =
          tester.getTopLeft(find.byWidget(chip.widget)) &
          tester.getSize(find.byWidget(chip.widget));

      expect(rect.left, greaterThanOrEqualTo(0));
      expect(rect.right, lessThanOrEqualTo(size.width));
    }
  }

  for (final size in const [Size(375, 812), Size(1200, 800)]) {
    testWidgets('affiche les 12 genres d un coup à ${size.width.toInt()} px', (
      tester,
    ) async {
      await pumpLegend(tester, size);

      expectEveryChipFullyVisible(tester, size);
      expect(tester.takeException(), isNull);
      expect(find.byType(ListView), findsNothing);
      expect(find.text('Psychologique'), findsOneWidget);
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
        AnimeGenre(slug: 'genre-$index', title: 'Genre numéro $index'),
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

    await tester.tap(find.widgetWithText(GenreLegendChip, 'Drame'));

    expect(picked, 'drama');
  });

  testWidgets('toucher la pastille active retire le filtre', (tester) async {
    String? picked = 'none';
    await pumpLegend(
      tester,
      const Size(375, 812),
      selectedSlug: 'drama',
      onSelected: (slug) => picked = slug,
    );

    await tester.tap(find.widgetWithText(GenreLegendChip, 'Drame'));

    expect(picked, isNull);
  });

  testWidgets('une liste vide ne montre aucune pastille', (tester) async {
    await pumpLegend(tester, const Size(375, 812), genres: const []);

    expect(find.byType(GenreLegendChip), findsNothing);
    expect(tester.takeException(), isNull);
  });
}
