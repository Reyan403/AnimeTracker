import '../domain/entities/watch_status.dart';

extension WatchStatusDisplay on WatchStatus {
  String get tabLabel => switch (this) {
        WatchStatus.toWatch => 'À voir',
        WatchStatus.watching => 'En cours',
        WatchStatus.completed => 'Terminé',
      };

  String get countLabel => switch (this) {
        WatchStatus.toWatch => 'en attente',
        WatchStatus.watching => 'en cours',
        WatchStatus.completed => 'terminées',
      };
}
