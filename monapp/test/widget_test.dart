import 'package:flutter_test/flutter_test.dart';

import 'package:monapp/main.dart';

void main() {
  testWidgets('the header states the title and the counts', (tester) async {
    await tester.pumpWidget(const AnimeTrackerApp());

    expect(find.text('Ma liste'), findsOneWidget);
    expect(find.text('3 en cours · 3 en attente · 4 terminées'), findsOneWidget);
  });

  testWidgets('the home opens on the En cours tab', (tester) async {
    await tester.pumpWidget(const AnimeTrackerApp());

    expect(find.text('Frieren : Au-delà du voyage'), findsOneWidget);
    expect(find.text('Wit Studio · 2019 · 24 épisodes'), findsOneWidget);
    expect(find.text('Fullmetal Alchemist: Brotherhood'), findsNothing);
  });

  testWidgets('selecting a tab swaps the listed animes', (tester) async {
    await tester.pumpWidget(const AnimeTrackerApp());

    await tester.tap(find.text('Terminé'));
    await tester.pumpAndSettle();

    expect(find.text('Fullmetal Alchemist: Brotherhood'), findsOneWidget);
    expect(find.text('Frieren : Au-delà du voyage'), findsNothing);
  });

  testWidgets('an original title shows only when it differs from the title',
      (tester) async {
    await tester.pumpWidget(const AnimeTrackerApp());

    expect(find.text('Sousou no Frieren'), findsOneWidget);
    expect(find.text('Vinland Saga'), findsOneWidget);
  });
}
