import 'dart:async';

import '../../domain/entities/watch_status.dart';
import '../../domain/entities/watchlist_entry.dart';
import '../../domain/gateways/watchlist_gateway.dart';

class InMemoryWatchlistGateway implements WatchlistGateway {
  InMemoryWatchlistGateway(List<WatchlistEntry> entries)
      : _entries = [...entries];

  final List<WatchlistEntry> _entries;

  final StreamController<List<WatchlistEntry>> _changes =
      StreamController<List<WatchlistEntry>>.broadcast();

  @override
  List<WatchlistEntry> get entries => List.unmodifiable(_entries);

  @override
  Stream<List<WatchlistEntry>> get changes => _changes.stream;

  @override
  void add(WatchlistEntry entry) {
    if (_entries.any((listed) => listed.id == entry.id)) {
      return;
    }

    _entries.insert(0, entry);
    _changes.add(entries);
  }

  @override
  void changeStatus(int animeId, WatchStatus status) {
    final listed = _entries.indexWhere((entry) => entry.id == animeId);

    if (listed < 0) {
      return;
    }

    _entries[listed] = _entries[listed].withStatus(status);
    _changes.add(entries);
  }
}
