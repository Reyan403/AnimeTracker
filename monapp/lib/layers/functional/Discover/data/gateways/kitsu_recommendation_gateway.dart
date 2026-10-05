import '../../../../technical/KitsuApi/kitsu_client.dart';
import '../../../Catalogue/data/models/catalogue_page_dto.dart';
import '../../../Catalogue/domain/entities/catalogue_anime.dart';
import '../../domain/gateways/recommendation_gateway.dart';

class KitsuRecommendationGateway implements RecommendationGateway {
  const KitsuRecommendationGateway(this._client);

  static const int minimumFollowers = 20000;

  final KitsuClient _client;

  @override
  Future<List<CatalogueAnime>> findAcclaimedByGenre(
    String slug,
    int limit,
  ) async {
    try {
      return CataloguePageDto.fromJson(
        await _client.getJson(
          'anime?filter%5Bcategories%5D=${Uri.encodeQueryComponent(slug)}'
          '&filter%5BuserCount%5D=$minimumFollowers..'
          '&sort=-averageRating&page%5Blimit%5D=$limit',
        ),
      ).animes;
    } catch (_) {
      throw const RecommendationsUnavailableException();
    }
  }
}
