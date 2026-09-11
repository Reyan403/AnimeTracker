import 'package:monapp/layers/functional/Catalogue/domain/entities/catalogue_anime.dart';
import 'package:monapp/layers/functional/Catalogue/domain/gateways/anime_catalogue_gateway.dart';

class FakeAnimeCatalogueGateway implements AnimeCatalogueGateway {
  FakeAnimeCatalogueGateway({
    this.mostPopular = const [],
    this.resultsByQuery = const {},
    this.isDown = false,
  });

  final List<CatalogueAnime> mostPopular;
  final Map<String, List<CatalogueAnime>> resultsByQuery;
  final bool isDown;
  final List<String> receivedQueries = [];

  @override
  Future<List<CatalogueAnime>> findMostPopular() async {
    receivedQueries.add('');

    if (isDown) {
      throw const CatalogueUnavailableException();
    }

    return mostPopular;
  }

  @override
  Future<List<CatalogueAnime>> search(String query) async {
    receivedQueries.add(query);

    if (isDown) {
      throw const CatalogueUnavailableException();
    }

    return resultsByQuery[query] ?? const [];
  }
}
