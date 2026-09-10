import 'package:flutter_test/flutter_test.dart';

import 'package:monapp/layers/functional/Anime/data/mock_anime_catalog.dart';
import 'package:monapp/layers/functional/Anime/presentation/watch_status_display.dart';
import 'package:monapp/layers/functional/Anime/presentation/widgets/anime_poster.dart';
import 'package:monapp/main.dart';

void main() {
  testWidgets('the watchlist shows every anime title', (tester) async {
    await tester.pumpWidget(const AnimeTrackerApp());

    expect(find.text('Ma liste'), findsOneWidget);
    for (final anime in MockAnimeCatalog.watchlist) {
      expect(find.text(anime.title), findsOneWidget);
    }
  });

  testWidgets('each anime carries its watch status label', (tester) async {
    await tester.pumpWidget(const AnimeTrackerApp());

    for (final anime in MockAnimeCatalog.watchlist) {
      expect(
        find.text(anime.status.label),
        findsWidgets,
        reason: '${anime.title} should display ${anime.status.label}',
      );
    }
  });

  testWidgets('every anime gets a placeholder poster', (tester) async {
    await tester.pumpWidget(const AnimeTrackerApp());

    expect(
      find.byType(AnimePoster),
      findsNWidgets(MockAnimeCatalog.watchlist.length),
    );
  });
}
