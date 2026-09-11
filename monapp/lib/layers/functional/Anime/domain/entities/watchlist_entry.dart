import 'watch_status.dart';

class WatchlistEntry {
  const WatchlistEntry({
    required this.id,
    required this.title,
    required this.status,
  });

  final int id;
  final String title;
  final WatchStatus status;

  WatchlistEntry withStatus(WatchStatus status) =>
      WatchlistEntry(id: id, title: title, status: status);
}
