import 'package:flutter/material.dart';

enum AppDestination { watchlist, catalogue }

extension AppDestinationDisplay on AppDestination {
  String get label => switch (this) {
        AppDestination.watchlist => 'Liste',
        AppDestination.catalogue => 'Catalogue',
      };

  IconData get icon => switch (this) {
        AppDestination.watchlist => Icons.bookmark_border,
        AppDestination.catalogue => Icons.explore_outlined,
      };
}
