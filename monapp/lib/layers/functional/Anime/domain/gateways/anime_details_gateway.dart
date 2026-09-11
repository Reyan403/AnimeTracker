import '../entities/anime_details.dart';

abstract interface class AnimeDetailsGateway {
  Future<AnimeDetails> findById(int id);
}

class AnimeDetailsUnavailableException implements Exception {
  const AnimeDetailsUnavailableException(this.id);

  final int id;

  @override
  String toString() => 'No details available for anime $id';
}
