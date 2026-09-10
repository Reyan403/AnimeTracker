import 'package:flutter/material.dart';

import 'layers/technical/Injection/injection.dart';
import 'layers/technical/Navigation/app_shell.dart';
import 'layers/technical/Theme/app_theme.dart';

void main() {
  initializeDependencies();
  runApp(const AnimeTrackerApp());
}

class AnimeTrackerApp extends StatelessWidget {
  const AnimeTrackerApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Anime Tracker',
      theme: AppTheme.editorial,
      home: const AppShell(),
    );
  }
}
