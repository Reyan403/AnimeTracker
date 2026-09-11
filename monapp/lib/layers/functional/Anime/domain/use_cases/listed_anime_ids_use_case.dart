import '../entities/watchlist_entry.dart';
import '../gateways/watchlist_gateway.dart';

class ListedAnimeIdsUseCase {
  const ListedAnimeIdsUseCase(this._watchlist);

  final WatchlistGateway _watchlist;

  Stream<Set<int>> call() async* {
    yield _idsOf(_watchlist.entries);

    yield* _watchlist.changes.map(_idsOf);
  }

  static Set<int> _idsOf(List<WatchlistEntry> entries) =>
      {for (final entry in entries) entry.id};
}
