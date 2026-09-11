import '../entities/anime.dart';
import '../entities/anime_details.dart';
import '../entities/watchlist_entry.dart';
import '../gateways/anime_details_gateway.dart';
import '../gateways/watchlist_gateway.dart';

class LoadWatchlistUseCase {
  LoadWatchlistUseCase(this._gateway, this._watchlist);

  final AnimeDetailsGateway _gateway;
  final WatchlistGateway _watchlist;

  final Map<int, AnimeDetails> _known = {};

  Stream<List<Anime>> call() async* {
    yield* _animesOf(_watchlist.entries);

    await for (final entries in _watchlist.changes) {
      yield* _animesOf(entries);
    }
  }

  Stream<List<Anime>> _animesOf(List<WatchlistEntry> entries) async* {
    final unknown = [
      for (final entry in entries)
        if (!_known.containsKey(entry.id)) entry.id,
    ];

    if (unknown.isNotEmpty) {
      yield [for (final entry in entries) _anime(entry, isAwaited: true)];

      _known.addAll(await _detailsOf(unknown));
    }

    yield [for (final entry in entries) _anime(entry)];
  }

  Anime _anime(WatchlistEntry entry, {bool isAwaited = false}) => Anime(
        id: entry.id,
        title: entry.title,
        status: entry.status,
        details: _known[entry.id],
        isLoadingDetails: isAwaited && !_known.containsKey(entry.id),
      );

  Future<Map<int, AnimeDetails>> _detailsOf(List<int> ids) async {
    try {
      return await _gateway.findAllByIds(ids);
    } on AnimeDetailsUnavailableException {
      return const {};
    }
  }
}
