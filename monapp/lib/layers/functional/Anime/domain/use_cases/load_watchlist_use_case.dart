import '../entities/anime.dart';
import '../entities/anime_details.dart';
import '../entities/watchlist_entry.dart';
import '../gateways/anime_details_gateway.dart';

class LoadWatchlistUseCase {
  const LoadWatchlistUseCase(this._gateway);

  final AnimeDetailsGateway _gateway;

  Future<List<Anime>> call(List<WatchlistEntry> entries) =>
      Future.wait(entries.map(_loaded));

  Future<Anime> _loaded(WatchlistEntry entry) async => Anime(
        title: entry.title,
        status: entry.status,
        details: await _detailsOrNull(entry.malId),
      );

  Future<AnimeDetails?> _detailsOrNull(int malId) async {
    try {
      return await _gateway.findByMalId(malId);
    } on AnimeDetailsUnavailableException {
      return null;
    }
  }
}
