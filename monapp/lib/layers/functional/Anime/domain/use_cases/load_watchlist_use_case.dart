import '../entities/anime.dart';
import '../entities/anime_details.dart';
import '../entities/watchlist_entry.dart';
import '../gateways/anime_details_cache.dart';
import '../gateways/anime_details_gateway.dart';
import '../gateways/watchlist_gateway.dart';

class LoadWatchlistUseCase {
  LoadWatchlistUseCase(this._gateway, this._watchlist, this._cache);

  final AnimeDetailsGateway _gateway;
  final WatchlistGateway _watchlist;
  final AnimeDetailsCache _cache;

  final Map<int, AnimeDetails> _known = {};
  final Map<int, AnimeDetails> _offline = {};

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

      await _fetch(unknown);
    }

    yield [for (final entry in entries) _anime(entry)];
  }

  Anime _anime(WatchlistEntry entry, {bool isAwaited = false}) {
    final details = _known[entry.id] ?? _offline[entry.id];

    return Anime(
      id: entry.id,
      title: entry.title,
      status: entry.status,
      episodesWatched: entry.watchedOf(details?.episodeCount ?? 0),
      details: details,
      isLoadingDetails: isAwaited && details == null,
    );
  }

  Future<void> _fetch(List<int> ids) async {
    try {
      final fetched = await _gateway.findAllByIds(ids);

      _known.addAll(fetched);
      _offline.removeWhere((id, _) => fetched.containsKey(id));
      _cache.saveAll(fetched);
    } on AnimeDetailsUnavailableException {
      _offline.addAll(_cache.findAll(ids));
    }
  }
}
