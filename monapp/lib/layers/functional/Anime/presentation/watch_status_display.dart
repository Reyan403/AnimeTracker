import '../domain/entities/watch_status.dart';

extension WatchStatusDisplay on WatchStatus {
  String get tabLabel => switch (this) {
        WatchStatus.toWatch => 'À voir',
        WatchStatus.watching => 'En cours',
        WatchStatus.completed => 'Terminé',
      };
}
