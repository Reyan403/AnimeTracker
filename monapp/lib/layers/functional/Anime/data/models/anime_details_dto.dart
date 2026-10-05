import '../../domain/entities/anime_details.dart';
import '../../domain/entities/anime_genre.dart';

abstract final class AnimeDetailsDto {
  static const String unknownFormat = 'Format inconnu';

  static const Map<String, String> _formats = {
    'TV': 'Série TV',
    'movie': 'Film',
    'OVA': 'OVA',
    'ONA': 'ONA',
    'special': 'Épisode spécial',
    'music': 'Clip',
  };

  static Map<int, AnimeDetails> fromJson(Map<String, dynamic> json) {
    final data = json['data'] as List<dynamic>? ?? const [];
    final genres = _genresById(json['included'] as List<dynamic>? ?? const []);

    return {
      for (final node in data)
        int.parse((node as Map<String, dynamic>)['id'] as String): _detailsOf(
          node['attributes'] as Map<String, dynamic>? ?? const {},
          _genresOf(node, genres),
        ),
    };
  }

  static AnimeDetails _detailsOf(
    Map<String, dynamic> attributes,
    List<AnimeGenre> genres,
  ) =>
      AnimeDetails(
        format: _formats[attributes['subtype']] ?? unknownFormat,
        year: _yearOf(attributes['startDate'] as String?),
        episodeCount: attributes['episodeCount'] as int? ?? 0,
        posterUrl: _posterOf(attributes),
        nextRelease: DateTime.tryParse(
          attributes['nextRelease'] as String? ?? '',
        ),
        episodeMinutes: attributes['episodeLength'] as int? ?? 0,
        genres: genres,
      );

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

  static List<AnimeGenre> _genresOf(
    Map<String, dynamic> node,
    Map<String, AnimeGenre> genres,
  ) {
    final relationships = node['relationships'] as Map<String, dynamic>?;
    final categories = relationships?['categories'] as Map<String, dynamic>?;
    final linked = categories?['data'] as List<dynamic>? ?? const [];

    return [
      for (final link in linked)
        ?genres[(link as Map<String, dynamic>)['id'] as String],
    ];
  }

  static int _yearOf(String? startDate) {
    if (startDate == null || startDate.length < 4) {
      return 0;
    }

    return int.tryParse(startDate.substring(0, 4)) ?? 0;
  }

  static String? _posterOf(Map<String, dynamic> attributes) {
    final poster = attributes['posterImage'] as Map<String, dynamic>?;

    return poster?['small'] as String? ?? poster?['original'] as String?;
  }
}
