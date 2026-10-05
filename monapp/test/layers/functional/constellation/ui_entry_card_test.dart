import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:monapp/layers/functional/Constellation/presentation/constellation_entry_card.dart';
import 'package:monapp/layers/functional/Constellation/presentation/constellation_page.dart';
import 'package:monapp/layers/functional/Constellation/presentation/cubit/constellation_cubit.dart';
import 'package:monapp/layers/technical/Injection/injection.dart';

import '../../../support/pump_app.dart';
import 'ui_support.dart';

void main() {
  setUp(() async {
    await getIt.reset();
    getIt.registerFactory<ConstellationCubit>(
      () => ConstellationCubit(
        FakeBuildConstellation(() => Stream.value(sampleConstellation)),
      ),
    );
  });

  tearDown(() async => getIt.reset());

  testWidgets('affiche le titre et le sous-titre', (tester) async {
    await pumpApp(tester, const ConstellationEntryCard(), settle: false);

    expect(find.text('Ma constellation'), findsOneWidget);
    expect(find.text("Ta liste d'animes, étoile par étoile"), findsOneWidget);
  });

  testWidgets('reste affichée sans animation en thème sombre', (tester) async {
    await pumpApp(
      tester,
      const ConstellationEntryCard(),
      themeMode: ThemeMode.dark,
      disableAnimations: true,
      settle: false,
    );
    await tester.pump(const Duration(seconds: 1));

    expect(find.byType(ConstellationEntryCard), findsOneWidget);
  });

  testWidgets('toucher la carte ouvre la constellation', (tester) async {
    await pumpApp(tester, const ConstellationEntryCard(), settle: false);

    await tester.tap(find.byType(ConstellationEntryCard));
    await tester.pump(const Duration(milliseconds: 500));
    await tester.pump(const Duration(milliseconds: 500));

    expect(find.byType(ConstellationPage), findsOneWidget);
  });
}
