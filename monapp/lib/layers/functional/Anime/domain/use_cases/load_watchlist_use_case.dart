import '../entities/anime.dart';
import '../entities/anime_details.dart';
import '../entities/watchlist_entry.dart';
import '../gateways/anime_details_gateway.dart';

class LoadWatchlistUseCase {
  const LoadWatchlistUseCase(this._gateway);

  final AnimeDetailsGateway _gateway;

  Stream<List<Anime>> call(List<WatchlistEntry> entries) async* {
    yield [for (final entry in entries) _awaited(entry)];

    final details = await _detailsOf(entries);

    yield [
      for (final entry in entries)
        Anime(
          id: entry.id,
          title: entry.title,
          status: entry.status,
          details: details[entry.id],
        ),
    ];
  }

  static Anime _awaited(WatchlistEntry entry) => Anime(
        id: entry.id,
        title: entry.title,
        status: entry.status,
        isLoadingDetails: true,
      );

  Future<Map<int, AnimeDetails>> _detailsOf(List<WatchlistEntry> entries) async {
    try {
      return await _gateway.findAllByIds([
        for (final entry in entries) entry.id,
      ]);
    } on AnimeDetailsUnavailableException {
      return const {};
    }
  }
}
