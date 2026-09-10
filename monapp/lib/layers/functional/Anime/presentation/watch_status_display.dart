import 'package:flutter/material.dart';

import '../domain/entities/watch_status.dart';

extension WatchStatusDisplay on WatchStatus {
  String get label => switch (this) {
        WatchStatus.toWatch => 'À regarder',
        WatchStatus.watching => 'En cours',
        WatchStatus.completed => 'Terminé',
      };

  IconData get icon => switch (this) {
        WatchStatus.toWatch => Icons.bookmark_outline,
        WatchStatus.watching => Icons.play_circle_outline,
        WatchStatus.completed => Icons.check_circle_outline,
      };

  Color color(ColorScheme scheme) => switch (this) {
        WatchStatus.toWatch => scheme.tertiary,
        WatchStatus.watching => scheme.primary,
        WatchStatus.completed => scheme.secondary,
      };
}
