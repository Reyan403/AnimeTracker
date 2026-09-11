import '../entities/catalogue_page.dart';

abstract interface class AnimeCatalogueGateway {
  Future<CataloguePage> findMostPopular(int page);

  Future<CataloguePage> search(String query, int page);
}

class CatalogueUnavailableException implements Exception {
  const CatalogueUnavailableException();

  @override
  String toString() => 'The anime catalogue is unavailable';
}
