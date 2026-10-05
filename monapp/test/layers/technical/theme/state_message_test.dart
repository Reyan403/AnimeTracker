import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:monapp/layers/technical/Theme/widgets/state_message.dart';

import '../../../support/pump_app.dart';

void main() {
  testWidgets('affiche titre, description et action', (tester) async {
    var retried = false;

    await pumpApp(
      tester,
      StateMessage(
        icon: Icons.cloud_off,
        title: 'Titre',
        description: 'Description',
        actionLabel: 'Réessayer',
        onAction: () => retried = true,
      ),
    );

    expect(find.text('Titre'), findsOneWidget);
    expect(find.text('Description'), findsOneWidget);

    await tester.tap(find.text('Réessayer'));

    expect(retried, isTrue);
  });

  testWidgets('sans action ni description, seuls icône et titre restent',
      (tester) async {
    await pumpApp(
      tester,
      const StateMessage(icon: Icons.search_off, title: 'Vide'),
    );

    expect(find.text('Vide'), findsOneWidget);
    expect(find.byType(FilledButton), findsNothing);
  });
}
