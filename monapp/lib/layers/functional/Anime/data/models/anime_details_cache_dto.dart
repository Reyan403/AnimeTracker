import '../../domain/entities/anime_details.dart';
import '../../domain/entities/anime_genre.dart';

abstract final class AnimeDetailsCacheDto {
  static Map<String, dynamic> toJson(AnimeDetails details) => {
        'format': details.format,
        'year': details.year,
        'episodeCount': details.episodeCount,
        'posterUrl': details.posterUrl,
        'nextRelease': details.nextRelease?.toIso8601String(),
        'episodeMinutes': details.episodeMinutes,
        'genres': [
          for (final genre in details.genres)
            {'slug': genre.slug, 'title': genre.title},
        ],
      };

  static AnimeDetails fromJson(Map<String, dynamic> json) => AnimeDetails(
        format: json['format'] as String,
        year: json['year'] as int,
        episodeCount: json['episodeCount'] as int,
        posterUrl: json['posterUrl'] as String?,
        nextRelease: DateTime.tryParse(json['nextRelease'] as String? ?? ''),
        episodeMinutes: json['episodeMinutes'] as int? ?? 0,
        genres: [
          for (final genre in json['genres'] as List<dynamic>? ?? const [])
            AnimeGenre(
              slug: (genre as Map<String, dynamic>)['slug'] as String,
              title: genre['title'] as String,
            ),
        ],
        isCached: true,
      );
}
