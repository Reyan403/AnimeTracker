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
    );
  }
}
