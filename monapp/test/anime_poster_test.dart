import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:monapp/layers/technical/Theme/widgets/anime_plaque.dart';
import 'package:monapp/layers/technical/Theme/widgets/anime_poster.dart';

Future<void> pumpPoster(WidgetTester tester, String? imageUrl) =>
    tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: AnimePoster(title: 'Cowboy Bebop', imageUrl: imageUrl),
        ),
      ),
    );

void main() {
  testWidgets('an anime without poster keeps its initials', (tester) async {
    await pumpPoster(tester, null);

    expect(find.byType(AnimePlaque), findsOneWidget);
    expect(find.byType(Image), findsNothing);
    expect(find.text('CO'), findsOneWidget);
  });

  testWidgets('an empty address keeps the initials too', (tester) async {
    await pumpPoster(tester, '');

    expect(find.byType(AnimePlaque), findsOneWidget);
  });

  testWidgets('a poster is loaded from its address', (tester) async {
    await pumpPoster(tester, 'https://media.kitsu.app/anime/1/small.jpg');

    final image = tester.widget<Image>(find.byType(Image));

    expect((image.image as NetworkImage).url,
        'https://media.kitsu.app/anime/1/small.jpg');
  });

  testWidgets('the initials stand in while the poster is missing',
      (tester) async {
    await pumpPoster(tester, 'https://media.kitsu.app/anime/1/small.jpg');
    await tester.pump();

    expect(find.byType(AnimePlaque), findsOneWidget);
  });
}
