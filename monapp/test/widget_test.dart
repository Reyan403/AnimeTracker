import 'package:flutter_test/flutter_test.dart';

import 'package:monapp/main.dart';

Future<void> pumpHome(WidgetTester tester) => tester.pumpWidget(
      AnimeTrackerApp(issueDate: DateTime(2026, 9, 10)),
    );

void main() {
  testWidgets('the masthead announces the issue and the counts',
      (tester) async {
    await pumpHome(tester);

    expect(find.text('SAISON'), findsOneWidget);
    expect(find.text('JEU. 10 SEPT. 2026'), findsOneWidget);
    expect(find.text('Ma liste'), findsOneWidget);
    expect(find.text('3 en cours · 3 en attente · 4 terminées'), findsOneWidget);
  });

  testWidgets('the home opens on the En cours tab', (tester) async {
    await pumpHome(tester);

    expect(find.text('Frieren : Au-delà du voyage'), findsOneWidget);
    expect(find.text('Wit Studio · 2019 · 24 épisodes'), findsOneWidget);
    expect(find.text('Fullmetal Alchemist: Brotherhood'), findsNothing);
  });

  testWidgets('selecting a tab swaps the listed animes', (tester) async {
    await pumpHome(tester);

    await tester.tap(find.text('Terminé'));
    await tester.pumpAndSettle();

    expect(find.text('Fullmetal Alchemist: Brotherhood'), findsOneWidget);
    expect(find.text('Frieren : Au-delà du voyage'), findsNothing);
  });

  testWidgets('a row carries the original title and the studio line',
      (tester) async {
    await pumpHome(tester);

    expect(find.text('Sousou no Frieren'), findsOneWidget);
    expect(find.text('Madhouse · 2023 · 28 épisodes'), findsOneWidget);
    expect(find.text('12 / 28'), findsOneWidget);
  });
}
