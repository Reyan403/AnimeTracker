import '../../../../technical/KitsuApi/kitsu_client.dart';
import '../../domain/gateways/catalogue_suggestion_gateway.dart';
import '../models/catalogue_suggestion_dto.dart';

class KitsuCatalogueSuggestionGateway implements CatalogueSuggestionGateway {
  const KitsuCatalogueSuggestionGateway(this._client);

  static const int minimumFollowers = 5000;

  final KitsuClient _client;

  @override
  Future<int> countMatching(String? genreSlug) async {
    try {
      return CatalogueSuggestionDto.countFrom(
        await _client.getJson(
          '${_base(genreSlug)}&page%5Blimit%5D=1'
          '&fields%5Banime%5D=canonicalTitle',
        ),
      );
    } catch (_) {
      throw const CatalogueSuggestionUnavailableException();
    }
  }

  @override
  Future<CatalogueSuggestion?> findAt(String? genreSlug, int offset) async {
    try {
      return CatalogueSuggestionDto.fromJson(
        await _client.getJson(
          '${_base(genreSlug)}&sort=-userCount&page%5Blimit%5D=1'
          '&page%5Boffset%5D=$offset&include=categories'
          '&fields%5Bcategories%5D=title,slug',
        ),
      );
    } catch (_) {
      throw const CatalogueSuggestionUnavailableException();
    }
  }

  static String _base(String? genreSlug) {
    final genre = genreSlug == null
        ? ''
        : '&filter%5Bcategories%5D=${Uri.encodeQueryComponent(genreSlug)}';

    return 'anime?filter%5BuserCount%5D=$minimumFollowers..'
        '&filter%5Bsubtype%5D=TV,movie$genre';
  }
}
