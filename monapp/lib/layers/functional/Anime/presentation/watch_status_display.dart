import 'package:flutter/material.dart';

import '../../../../l10n/app_localizations.dart';
import '../../../technical/Theme/app_palette.dart';
import '../domain/entities/watch_status.dart';

extension WatchStatusDisplay on WatchStatus {
  String labelOf(AppLocalizations l10n) => switch (this) {
        WatchStatus.toWatch => l10n.statusToWatch,
        WatchStatus.watching => l10n.statusWatching,
        WatchStatus.completed => l10n.statusCompleted,
      };

  Color colorOf(AppPalette palette) => switch (this) {
        WatchStatus.toWatch => palette.toWatch,
        WatchStatus.watching => palette.watching,
        WatchStatus.completed => palette.completed,
      };
}
