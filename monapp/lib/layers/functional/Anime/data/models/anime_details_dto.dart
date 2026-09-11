import '../../domain/entities/anime_details.dart';

abstract final class AnimeDetailsDto {
  static const String unknownStudio = 'Studio inconnu';

  static AnimeDetails fromJson(Map<String, dynamic> json) {
    final studios = json['studios'] as List<dynamic>?;
    final firstStudio =
        studios == null || studios.isEmpty ? null : studios.first;

    return AnimeDetails(
      studio: firstStudio == null
          ? unknownStudio
          : (firstStudio as Map<String, dynamic>)['name'] as String,
      year: json['year'] as int? ?? 0,
      episodeCount: json['episodes'] as int? ?? 0,
      posterUrl: _posterOf(json),
    );
  }

  static String? _posterOf(Map<String, dynamic> json) {
    final images = json['images'] as Map<String, dynamic>?;
    final jpg = images?['jpg'] as Map<String, dynamic>?;

    return jpg?['image_url'] as String? ?? jpg?['large_image_url'] as String?;
  }
}
