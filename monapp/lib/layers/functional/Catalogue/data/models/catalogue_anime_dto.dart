import '../../domain/entities/catalogue_anime.dart';

abstract final class CatalogueAnimeDto {
  static const String unknownStudio = 'Studio inconnu';

  static CatalogueAnime fromJson(Map<String, dynamic> json) => CatalogueAnime(
        malId: json['mal_id'] as int,
        title: json['title'] as String,
        studio: _studioOf(json),
        year: json['year'] as int? ?? 0,
        episodeCount: json['episodes'] as int? ?? 0,
      );

  static String _studioOf(Map<String, dynamic> json) {
    final studios = json['studios'] as List<dynamic>?;

    if (studios == null || studios.isEmpty) {
      return unknownStudio;
    }

    final name = (studios.first as Map<String, dynamic>)['name'] as String?;

    return name ?? unknownStudio;
  }
}
