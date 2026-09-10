import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:monapp/layers/functional/Anime/presentation/widgets/anime_row.dart';
import 'package:monapp/main.dart';

const List<String> tabLabels = ['À voir', 'En cours', 'Terminé'];

void main() {
  testWidgets('no tab shows a second line under an anime title',
      (tester) async {
    await tester.pumpWidget(const AnimeTrackerApp());

    for (final label in tabLabels) {
      await tester.tap(find.text(label));
      await tester.pumpAndSettle();

      final rows = find.byType(AnimeRow);
      expect(rows, findsWidgets, reason: '$label should list animes');

      for (var index = 0; index < rows.evaluate().length; index++) {
        final texts = find.descendant(
          of: rows.at(index),
          matching: find.byType(Text),
        );
        expect(
          texts,
          findsNWidgets(3),
          reason: 'a $label row holds only its initials, title and studio line',
        );
      }
    }
  });
}
