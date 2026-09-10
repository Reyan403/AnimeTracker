import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:monapp/layers/functional/Catalogue/presentation/catalogue_view.dart';

Future<void> pumpCatalogue(WidgetTester tester) =>
    tester.pumpWidget(const MaterialApp(home: CatalogueView()));

void main() {
  testWidgets('it offers a search field', (tester) async {
    await pumpCatalogue(tester);

    expect(find.text('Catalogue'), findsOneWidget);
    expect(find.widgetWithText(TextField, 'Rechercher un animé'),
        findsOneWidget);
    expect(find.text('Cherche un animé à ajouter à ta liste.'), findsOneWidget);
  });

  testWidgets('the clear button appears only once something is typed',
      (tester) async {
    await pumpCatalogue(tester);

    expect(find.byTooltip('Effacer'), findsNothing);

    await tester.enterText(find.byType(TextField), 'frieren');
    await tester.pump();

    expect(find.byTooltip('Effacer'), findsOneWidget);
  });

  testWidgets('clearing empties the field and restores the prompt',
      (tester) async {
    await pumpCatalogue(tester);

    await tester.enterText(find.byType(TextField), 'frieren');
    await tester.pump();
    await tester.tap(find.byTooltip('Effacer'));
    await tester.pump();

    expect(find.text('frieren'), findsNothing);
    expect(find.text('Cherche un animé à ajouter à ta liste.'), findsOneWidget);
    expect(find.byTooltip('Effacer'), findsNothing);
  });
}
