import '../entities/anime_extras.dart';

abstract interface class AnimeExtrasGateway {
  Future<List<StreamingLink>> findStreamingLinks(int animeId);

  Future<List<RelatedAnime>> findRelated(int animeId);
}

class AnimeExtrasUnavailableException implements Exception {
  const AnimeExtrasUnavailableException();

  @override
  String toString() => 'The anime extras are unavailable';
}
