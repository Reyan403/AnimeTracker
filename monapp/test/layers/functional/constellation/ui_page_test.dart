import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:monapp/layers/functional/Catalogue/presentation/anime_sheet_view.dart';
import 'package:monapp/layers/functional/Catalogue/presentation/cubit/anime_sheet_cubit.dart';
import 'package:monapp/layers/functional/Constellation/domain/entities/constellation.dart';
import 'package:monapp/layers/functional/Constellation/domain/entities/constellation_star.dart';
import 'package:monapp/layers/functional/Constellation/presentation/constellation_page.dart';
import 'package:monapp/layers/functional/Constellation/presentation/cubit/constellation_cubit.dart';
import 'package:monapp/layers/functional/Constellation/presentation/widgets/constellation_body.dart';
import 'package:monapp/layers/functional/Constellation/presentation/widgets/constellation_sky.dart';
import 'package:monapp/layers/functional/Constellation/presentation/widgets/genre_legend_chip.dart';
import 'package:monapp/layers/functional/Constellation/presentation/widgets/star_layout.dart';
import 'package:monapp/layers/technical/Injection/injection.dart';

import '../../../support/pump_app.dart';
import 'ui_support.dart';

void main() {
  late FakeBuildConstellation build;

  setUp(() async {
    await getIt.reset();
    getIt
      ..registerFactory<ConstellationCubit>(() => ConstellationCubit(build))
      ..registerFactory<AnimeSheetCubit>(FakeSheetCubit.new);
  });

  tearDown(() async => getIt.reset());

  Future<void> pumpPage(
    WidgetTester tester, {
    ThemeMode themeMode = ThemeMode.light,
    bool disableAnimations = false,
  }) async {
    await pumpApp(
      tester,
      const ConstellationPage(),
      themeMode: themeMode,
      disableAnimations: disableAnimations,
      settle: false,
    );
    await tester.pump(const Duration(milliseconds: 900));
  }

  Offset starPosition(WidgetTester tester, ConstellationStar star) {
    final sky = find.byType(ConstellationSky);

    return tester.getTopLeft(sky) +
        StarLayout.positionOf(
          star,
          tester.getSize(sky),
          ConstellationBody.skyInset(0),
        );
  }

  Future<void> tapStar(WidgetTester tester, ConstellationStar star) async {
    await tester.tapAt(starPosition(tester, star));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 400));
  }

  testWidgets('affiche le chargement tant que rien n est arrivé', (
    tester,
  ) async {
    final controller = StreamController<Constellation>();
    addTearDown(controller.close);
    build = FakeBuildConstellation(() => controller.stream);

    await pumpPage(tester);

    expect(find.text("Les étoiles s'allument…"), findsOneWidget);
    expect(find.text('Ma constellation'), findsOneWidget);
    expect(find.byType(ConstellationSky), findsNothing);
  });

  testWidgets('affiche le ciel et la légende des genres', (tester) async {
    build = FakeBuildConstellation(() => Stream.value(sampleConstellation));

    await pumpPage(tester);

    expect(find.byType(ConstellationSky), findsOneWidget);
    expect(find.widgetWithText(GenreLegendChip, 'Action'), findsOneWidget);
    expect(find.text('Drame'), findsOneWidget);
    expect(find.text('Ouvrir la fiche'), findsNothing);
  });

  testWidgets('traverse une étoile filante sans erreur', (tester) async {
    build = FakeBuildConstellation(() => Stream.value(sampleConstellation));
    await pumpPage(tester);

    for (var second = 0; second < 9; second++) {
      await tester.pump(const Duration(seconds: 1));
    }
    await tester.pump(const Duration(milliseconds: 450));

    expect(tester.takeException(), isNull);
    expect(find.byType(ConstellationSky), findsOneWidget);
  });

  testWidgets('affiche le ciel en thème sombre sans animations', (
    tester,
  ) async {
    build = FakeBuildConstellation(() => Stream.value(sampleConstellation));

    await pumpPage(tester, themeMode: ThemeMode.dark, disableAnimations: true);

    expect(find.byType(ConstellationSky), findsOneWidget);
  });

  testWidgets('affiche l invitation quand la liste est vide', (tester) async {
    build = FakeBuildConstellation(() => Stream.value(emptyConstellation));

    await pumpPage(tester);

    expect(
      find.text('Ajoute des animes à ta liste pour allumer ta constellation'),
      findsOneWidget,
    );
    expect(find.byType(ConstellationSky), findsNothing);
  });

  testWidgets('propose de réessayer après une erreur', (tester) async {
    build = FakeBuildConstellation(() => Stream.error(StateError('boom')));

    await pumpPage(tester);

    expect(find.text('Le ciel est voilé'), findsOneWidget);
    expect(find.textContaining('boom'), findsNothing);

    await tester.tap(find.text('Réessayer'));
    await tester.pump();

    expect(build.calls, 2);
  });

  testWidgets('toucher une étoile ouvre l aperçu puis le ferme', (
    tester,
  ) async {
    build = FakeBuildConstellation(() => Stream.value(sampleConstellation));
    await pumpPage(tester);

    await tapStar(tester, sampleConstellation.stars[1]);

    expect(find.text('Étoile en cours'), findsOneWidget);
    expect(find.text('Reliée à 2 animes'), findsOneWidget);
    expect(find.text('Ouvrir la fiche'), findsOneWidget);

    await tester.tap(find.byTooltip("Fermer l'aperçu"));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 400));

    expect(find.text('Ouvrir la fiche'), findsNothing);
  });

  testWidgets('toucher le vide désélectionne', (tester) async {
    build = FakeBuildConstellation(() => Stream.value(sampleConstellation));
    await pumpPage(tester);
    await tapStar(tester, sampleConstellation.stars[0]);
    expect(find.text('Ouvrir la fiche'), findsOneWidget);

    await tester.tapAt(
      tester.getTopLeft(find.byType(ConstellationSky)) + const Offset(380, 200),
    );
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 400));

    expect(find.text('Ouvrir la fiche'), findsNothing);
  });

  testWidgets('le filtre de genre masque les autres étoiles au toucher', (
    tester,
  ) async {
    build = FakeBuildConstellation(() => Stream.value(sampleConstellation));
    await pumpPage(tester);

    await tester.tap(find.widgetWithText(GenreLegendChip, 'Action'));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 300));
    await tapStar(tester, sampleConstellation.stars[1]);

    expect(find.text('Ouvrir la fiche'), findsNothing);

    await tapStar(tester, sampleConstellation.stars[0]);

    expect(find.text('Ouvrir la fiche'), findsOneWidget);

    await tester.tap(find.widgetWithText(GenreLegendChip, 'Action'));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 300));
    await tapStar(tester, sampleConstellation.stars[1]);

    expect(find.text('Étoile en cours'), findsOneWidget);
  });

  testWidgets('ouvre la fiche de l anime avec le bon héros', (tester) async {
    build = FakeBuildConstellation(() => Stream.value(sampleConstellation));
    await pumpPage(tester);
    await tapStar(tester, sampleConstellation.stars[0]);

    await tester.tap(find.text('Ouvrir la fiche'));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 500));

    final sheet = tester.widget<AnimeSheetView>(find.byType(AnimeSheetView));

    expect(sheet.animeId, 1);
    expect(sheet.heroTag, 'poster-constellation-1');
  });

  testWidgets('le bouton retour quitte la page', (tester) async {
    build = FakeBuildConstellation(() => Stream.value(sampleConstellation));
    await pumpApp(
      tester,
      Builder(
        builder: (context) => TextButton(
          onPressed: () => ConstellationPage.open(context),
          child: const Text('go'),
        ),
      ),
      settle: false,
    );

    await tester.tap(find.text('go'));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 500));
    expect(find.byType(ConstellationScaffold), findsOneWidget);

    await tester.tap(find.byTooltip('Retour'));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 500));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 500));

    expect(find.byType(ConstellationScaffold), findsNothing);
  });
}
