import '../../domain/entities/anime_details.dart';

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

  static AnimeDetails fromJson(Map<String, dynamic> json) {
    final data = json['data'] as Map<String, dynamic>? ?? const {};
    final attributes = data['attributes'] as Map<String, dynamic>? ?? const {};

    return AnimeDetails(
      format: _formats[attributes['subtype']] ?? unknownFormat,
      year: _yearOf(attributes['startDate'] as String?),
      episodeCount: attributes['episodeCount'] as int? ?? 0,
      posterUrl: _posterOf(attributes),
    );
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
