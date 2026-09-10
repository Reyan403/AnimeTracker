import 'package:flutter/material.dart';

import 'layers/functional/Anime/presentation/watchlist_view.dart';
import 'layers/technical/Theme/app_theme.dart';

void main() {
  runApp(const AnimeTrackerApp());
}

class AnimeTrackerApp extends StatelessWidget {
  const AnimeTrackerApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Anime Tracker',
      theme: AppTheme.editorial,
      home: const WatchlistView(),
    );
  }
}
