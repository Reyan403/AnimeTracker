import 'package:flutter/material.dart';

import '../../../l10n/app_localizations.dart';

enum AppDestination { watchlist, catalogue }

extension AppDestinationDisplay on AppDestination {
  String labelOf(AppLocalizations l10n) => switch (this) {
        AppDestination.watchlist => l10n.navWatchlist,
        AppDestination.catalogue => l10n.navCatalogue,
      };

  IconData get icon => switch (this) {
        AppDestination.watchlist => Icons.bookmark_border,
        AppDestination.catalogue => Icons.explore_outlined,
      };

  IconData get selectedIcon => switch (this) {
        AppDestination.watchlist => Icons.bookmark,
        AppDestination.catalogue => Icons.explore,
      };
}
