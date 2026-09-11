import '../entities/anime.dart';
import '../entities/anime_details.dart';
import '../entities/watchlist_entry.dart';
import '../gateways/anime_details_gateway.dart';

class LoadWatchlistUseCase {
  const LoadWatchlistUseCase(this._gateway);

  final AnimeDetailsGateway _gateway;

  Stream<List<Anime>> call(List<WatchlistEntry> entries) async* {
    final animes = [for (final entry in entries) _awaited(entry)];

    yield List.of(animes);

    final lookups = [
      for (var index = 0; index < entries.length; index++)
        _lookedUp(index, entries[index]),
    ];

    await for (final (index, anime) in Stream.fromFutures(lookups)) {
      animes[index] = anime;

      yield List.of(animes);
    }
  }

  static Anime _awaited(WatchlistEntry entry) => Anime(
        title: entry.title,
        status: entry.status,
        isLoadingDetails: true,
      );

  Future<(int, Anime)> _lookedUp(int index, WatchlistEntry entry) async => (
        index,
        Anime(
          title: entry.title,
          status: entry.status,
          details: await _detailsOrNull(entry.malId),
        ),
      );

  Future<AnimeDetails?> _detailsOrNull(int malId) async {
    try {
      return await _gateway.findByMalId(malId);
    } on AnimeDetailsUnavailableException {
      return null;
    }
  }
}
