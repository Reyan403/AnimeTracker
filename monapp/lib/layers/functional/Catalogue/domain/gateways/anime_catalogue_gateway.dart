import '../entities/catalogue_anime.dart';

abstract interface class AnimeCatalogueGateway {
  Future<List<CatalogueAnime>> findMostPopular();

  Future<List<CatalogueAnime>> search(String query);
}

class CatalogueUnavailableException implements Exception {
  const CatalogueUnavailableException();

  @override
  String toString() => 'The anime catalogue is unavailable';
}
