import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:monapp/layers/functional/Anime/presentation/widgets/anime_poster.dart';

Future<String> pumpInitials(WidgetTester tester, String title) async {
  await tester.pumpWidget(
    MaterialApp(home: Scaffold(body: AnimePoster(title: title))),
  );
  return tester.widget<Text>(find.byType(Text)).data!;
}

void main() {
  testWidgets('initials skip lowercase articles and standalone letters',
      (tester) async {
    expect(await pumpInitials(tester, "L'Attaque des Titans"), 'LT');
    expect(await pumpInitials(tester, 'Spy x Family'), 'SF');
  });

  testWidgets('initials skip digits and punctuation between words',
      (tester) async {
    expect(await pumpInitials(tester, 'Mob Psycho 100'), 'MP');
    expect(
      await pumpInitials(tester, 'Fullmetal Alchemist: Brotherhood'),
      'FA',
    );
  });

  testWidgets('a fully lowercase title still yields initials', (tester) async {
    expect(await pumpInitials(tester, 'bocchi the rock'), 'BT');
  });
}
