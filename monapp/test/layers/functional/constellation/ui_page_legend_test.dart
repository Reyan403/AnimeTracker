import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:monapp/layers/functional/Catalogue/presentation/cubit/anime_sheet_cubit.dart';
import 'package:monapp/layers/functional/Constellation/domain/entities/constellation.dart';
import 'package:monapp/layers/functional/Constellation/presentation/constellation_page.dart';
import 'package:monapp/layers/functional/Constellation/presentation/cubit/constellation_cubit.dart';
import 'package:monapp/layers/functional/Constellation/presentation/widgets/constellation_body.dart';
import 'package:monapp/layers/functional/Constellation/presentation/widgets/constellation_sky.dart';
import 'package:monapp/layers/functional/Constellation/presentation/widgets/genre_legend.dart';
import 'package:monapp/layers/functional/Constellation/presentation/widgets/genre_legend_chip.dart';
import 'package:monapp/layers/functional/Constellation/presentation/widgets/star_layout.dart';
import 'package:monapp/layers/technical/Injection/injection.dart';

import '../../../support/pump_app.dart';
import 'ui_legend_test.dart';
import 'ui_support.dart';

void main() {
  late FakeBuildConstellation build;

  final crowded = Constellation(
    stars: sampleConstellation.stars,
    links: sampleConstellation.links,
    genres: tenGenres,
  );

  setUp(() async {
    await getIt.reset();
    getIt
      ..registerFactory<ConstellationCubit>(() => ConstellationCubit(build))
      ..registerFactory<AnimeSheetCubit>(FakeSheetCubit.new);
    build = FakeBuildConstellation(() => Stream.value(crowded));
  });

  tearDown(() async => getIt.reset());

  Future<void> pumpPage(WidgetTester tester, Size size) async {
    await pumpApp(
      tester,
      const ConstellationPage(),
      size: size,
      textScale: realisticTextScale,
      settle: false,
    );
    await tester.pump(const Duration(milliseconds: 900));
  }

  for (final size in const [Size(375, 812), Size(1200, 800)]) {
    testWidgets('10 genres et ciel utilisable à ${size.width.toInt()} px', (
      tester,
    ) async {
      await pumpPage(tester, size);

      expect(tester.takeException(), isNull);
      expect(find.byType(GenreLegendChip), findsNWidgets(tenGenres.length));
      final legend = tester.getRect(find.byType(GenreLegend));
      final sky = tester.getRect(find.byType(ConstellationSky));

      expect(legend.height, lessThanOrEqualTo(size.height / 3));
      expect(sky.top, greaterThanOrEqualTo(legend.bottom));
      expect(sky.height, greaterThan(size.height / 2));
    });
  }

  testWidgets('toucher une étoile fonctionne avec la légende complète', (
    tester,
  ) async {
    await pumpPage(tester, const Size(375, 812));
    final star = crowded.stars[1];
    final sky = find.byType(ConstellationSky);

    await tester.tapAt(
      tester.getTopLeft(sky) +
          StarLayout.positionOf(
            star,
            tester.getSize(sky),
            ConstellationBody.skyInset,
          ),
    );
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 400));

    expect(find.text('Étoile en cours'), findsOneWidget);
    expect(find.text('Ouvrir la fiche'), findsOneWidget);
  });

  testWidgets('une pastille de la légende filtre le ciel', (tester) async {
    await pumpPage(tester, const Size(375, 812));

    await tester.tap(find.widgetWithText(GenreLegendChip, 'Mystère'));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 300));

    final chip = tester.widget<GenreLegendChip>(
      find.widgetWithText(GenreLegendChip, 'Mystère'),
    );

    expect(chip.isSelected, isTrue);
  });

  testWidgets('une étoile sans genre Découvrir reste touchable', (
    tester,
  ) async {
    await pumpPage(tester, const Size(375, 812));
    final star = crowded.stars[2];
    final sky = find.byType(ConstellationSky);

    expect(star.genreSlug, isNull);
    await tester.tapAt(
      tester.getTopLeft(sky) +
          StarLayout.positionOf(
            star,
            tester.getSize(sky),
            ConstellationBody.skyInset,
          ),
    );
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 400));

    expect(find.text('Étoile solitaire'), findsOneWidget);
    expect(find.text('Ouvrir la fiche'), findsOneWidget);
  });
}
