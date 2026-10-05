import '../../../Catalogue/domain/entities/catalogue_anime.dart';

abstract interface class RecommendationGateway {
  Future<List<CatalogueAnime>> findAcclaimedByGenre(String slug, int limit);
}

class RecommendationsUnavailableException implements Exception {
  const RecommendationsUnavailableException();

  @override
  String toString() => 'Recommendations are unavailable';
}
