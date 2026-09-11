import '../entities/catalogue_page.dart';
import '../gateways/anime_catalogue_gateway.dart';

class BrowseCatalogueUseCase {
  const BrowseCatalogueUseCase(this._gateway);

  static const int minimumQueryLength = 3;
  static const int firstPage = 1;

  final AnimeCatalogueGateway _gateway;

  Future<CataloguePage> call(String query, {int page = firstPage}) {
    final trimmed = query.trim();

    return trimmed.length < minimumQueryLength
        ? _gateway.findMostPopular(page)
        : _gateway.search(trimmed, page);
  }
}
