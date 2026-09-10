import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:monapp/layers/functional/Anime/presentation/widgets/anime_plaque.dart';

Future<String> pumpInitials(WidgetTester tester, String title) async {
  await tester.pumpWidget(
    MaterialApp(home: Scaffold(body: AnimePlaque(title: title))),
  );
  return tester.widget<Text>(find.byType(Text)).data!;
}

void main() {
  testWidgets('a plaque shows the first two letters of the title',
      (tester) async {
    expect(await pumpInitials(tester, 'Frieren : Au-delà du voyage'), 'FR');
    expect(await pumpInitials(tester, 'Vinland Saga'), 'VI');
  });

  testWidgets('a plaque skips punctuation and digits', (tester) async {
    expect(await pumpInitials(tester, "L'Attaque des Titans"), 'LA');
    expect(await pumpInitials(tester, '86 Eighty-Six'), 'EI');
  });
}
