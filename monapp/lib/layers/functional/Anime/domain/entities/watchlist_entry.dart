import 'watch_status.dart';

class WatchlistEntry {
  const WatchlistEntry({
    required this.malId,
    required this.title,
    required this.status,
  });

  final int malId;
  final String title;
  final WatchStatus status;
}
