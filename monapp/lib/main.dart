import 'package:flutter/material.dart';

import 'layers/functional/Anime/presentation/watchlist_view.dart';
import 'layers/technical/Theme/app_theme.dart';

void main() {
  runApp(AnimeTrackerApp(issueDate: DateTime.now()));
}

class AnimeTrackerApp extends StatelessWidget {
  const AnimeTrackerApp({required this.issueDate, super.key});

  final DateTime issueDate;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Anime Tracker',
      theme: AppTheme.editorial,
      home: WatchlistView(issueDate: issueDate),
    );
  }
}
