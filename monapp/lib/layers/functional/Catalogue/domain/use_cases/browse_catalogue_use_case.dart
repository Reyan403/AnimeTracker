import '../entities/catalogue_anime.dart';
import '../gateways/anime_catalogue_gateway.dart';

class BrowseCatalogueUseCase {
  const BrowseCatalogueUseCase(this._gateway);

  static const int minimumQueryLength = 3;

  final AnimeCatalogueGateway _gateway;

  Future<List<CatalogueAnime>> call(String query) {
    final trimmed = query.trim();

    return trimmed.length < minimumQueryLength
        ? _gateway.findMostPopular()
        : _gateway.search(trimmed);
  }
}
