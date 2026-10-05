import 'package:flutter/material.dart';

import '../../../l10n/app_localizations.dart';

enum AppDestination { watchlist, catalogue, agenda }

extension AppDestinationDisplay on AppDestination {
  String labelOf(AppLocalizations l10n) => switch (this) {
        AppDestination.watchlist => l10n.navWatchlist,
        AppDestination.catalogue => l10n.navCatalogue,
        AppDestination.agenda => l10n.navAgenda,
      };

  IconData get icon => switch (this) {
        AppDestination.watchlist => Icons.bookmark_border,
        AppDestination.catalogue => Icons.explore_outlined,
        AppDestination.agenda => Icons.calendar_month_outlined,
      };

  IconData get selectedIcon => switch (this) {
        AppDestination.watchlist => Icons.bookmark,
        AppDestination.catalogue => Icons.explore,
        AppDestination.agenda => Icons.calendar_month,
      };
}
