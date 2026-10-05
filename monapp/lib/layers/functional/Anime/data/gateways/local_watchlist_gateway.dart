import 'dart:async';

import '../../domain/entities/watch_status.dart';
import '../../domain/entities/watchlist_entry.dart';
import '../../domain/gateways/watchlist_gateway.dart';
import '../stores/watchlist_store.dart';

class LocalWatchlistGateway implements WatchlistGateway {
  LocalWatchlistGateway(this._store, List<WatchlistEntry> initialEntries)
      : _entries = [...(_store.read() ?? initialEntries)] {
    if (_store.read() == null) {
      unawaited(_store.write(_entries));
    }
  }

  final WatchlistStore _store;
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
    _publish();
  }

  @override
  void changeStatus(int animeId, WatchStatus status) {
    final listed = _entries.indexWhere((entry) => entry.id == animeId);

    if (listed < 0) {
      return;
    }

    _entries[listed] = _entries[listed].withStatus(status);
    _publish();
  }

  @override
  void update(WatchlistEntry entry) {
    final listed = _entries.indexWhere((candidate) => candidate.id == entry.id);

    if (listed < 0) {
      return;
    }

    _entries[listed] = entry;
    _publish();
  }

  void _publish() {
    unawaited(_store.write(entries));
    _changes.add(entries);
  }
}
