import '../entities/anime_details.dart';

abstract interface class AnimeDetailsGateway {
  Future<Map<int, AnimeDetails>> findAllByIds(List<int> ids);
}

class AnimeDetailsUnavailableException implements Exception {
  const AnimeDetailsUnavailableException();

  @override
  String toString() => 'No details available for the watchlist';
}
