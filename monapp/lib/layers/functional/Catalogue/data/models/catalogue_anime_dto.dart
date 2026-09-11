import '../../domain/entities/catalogue_anime.dart';

abstract final class CatalogueAnimeDto {
  static const String unknownFormat = 'Format inconnu';

  static const Map<String, String> _formats = {
    'TV': 'Série TV',
    'movie': 'Film',
    'OVA': 'OVA',
    'ONA': 'ONA',
    'special': 'Épisode spécial',
    'music': 'Clip',
  };

  static CatalogueAnime fromJson(Map<String, dynamic> json) {
    final attributes = json['attributes'] as Map<String, dynamic>? ?? const {};

    return CatalogueAnime(
      id: int.parse(json['id'] as String),
      title: attributes['canonicalTitle'] as String? ?? '',
      format: formatOf(attributes['subtype'] as String?),
      year: yearOf(attributes['startDate'] as String?),
      episodeCount: attributes['episodeCount'] as int? ?? 0,
      posterUrl: posterOf(attributes),
    );
  }

  static String? posterOf(Map<String, dynamic> attributes) {
    final poster = attributes['posterImage'] as Map<String, dynamic>?;

    return poster?['small'] as String? ?? poster?['original'] as String?;
  }

  static String formatOf(String? subtype) =>
      _formats[subtype] ?? subtype ?? unknownFormat;

  static int yearOf(String? startDate) {
    if (startDate == null || startDate.length < 4) {
      return 0;
    }

    return int.tryParse(startDate.substring(0, 4)) ?? 0;
  }
}
