import '../../../Anime/domain/entities/anime_genre.dart';
import '../../../Catalogue/data/models/catalogue_anime_dto.dart';
import '../../domain/gateways/catalogue_suggestion_gateway.dart';

abstract final class CatalogueSuggestionDto {
  static int countFrom(Map<String, dynamic> json) =>
      (json['meta'] as Map<String, dynamic>?)?['count'] as int? ?? 0;

  static CatalogueSuggestion? fromJson(Map<String, dynamic> json) {
    final data = json['data'] as List<dynamic>? ?? const [];

    if (data.isEmpty) {
      return null;
    }

    final node = data.first as Map<String, dynamic>;
    final genres = _genresById(json['included'] as List<dynamic>? ?? const []);
    final relationships = node['relationships'] as Map<String, dynamic>?;
    final categories = relationships?['categories'] as Map<String, dynamic>?;

    return CatalogueSuggestion(
      anime: CatalogueAnimeDto.fromJson(node),
      genres: [
        for (final link in categories?['data'] as List<dynamic>? ?? const [])
          ?genres[(link as Map<String, dynamic>)['id'] as String],
      ],
    );
  }

  static Map<String, AnimeGenre> _genresById(List<dynamic> included) => {
        for (final node in included)
          if ((node as Map<String, dynamic>)['type'] == 'categories')
            node['id'] as String: AnimeGenre(
              slug: (node['attributes'] as Map<String, dynamic>)['slug']
                  as String,
              title: (node['attributes'] as Map<String, dynamic>)['title']
                  as String,
            ),
      };
}
