import 'package:flutter/material.dart';

import '../../../l10n/app_localizations.dart';

enum AppDestination { watchlist, catalogue, discover, agenda }

extension AppDestinationDisplay on AppDestination {
  String labelOf(AppLocalizations l10n) => switch (this) {
        AppDestination.watchlist => l10n.navWatchlist,
        AppDestination.catalogue => l10n.navCatalogue,
        AppDestination.discover => l10n.navDiscover,
        AppDestination.agenda => l10n.navAgenda,
      };

  IconData get icon => switch (this) {
        AppDestination.watchlist => Icons.bookmark_border,
        AppDestination.catalogue => Icons.explore_outlined,
        AppDestination.discover => Icons.auto_awesome_outlined,
        AppDestination.agenda => Icons.calendar_month_outlined,
      };

  IconData get selectedIcon => switch (this) {
        AppDestination.watchlist => Icons.bookmark,
        AppDestination.catalogue => Icons.explore,
        AppDestination.discover => Icons.auto_awesome,
        AppDestination.agenda => Icons.calendar_month,
      };
}
