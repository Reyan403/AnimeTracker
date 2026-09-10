import '../entities/anime_details.dart';

abstract interface class AnimeDetailsGateway {
  Future<AnimeDetails> findByMalId(int malId);
}

class AnimeDetailsUnavailableException implements Exception {
  const AnimeDetailsUnavailableException(this.malId);

  final int malId;

  @override
  String toString() => 'No details available for anime $malId';
}
