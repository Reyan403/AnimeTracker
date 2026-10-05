import 'anime_genre.dart';

class AnimeDetails {
  const AnimeDetails({
    required this.format,
    required this.year,
    required this.episodeCount,
    this.posterUrl,
    this.nextRelease,
    this.episodeMinutes = 0,
    this.genres = const [],
  });

  final String format;
  final int year;
  final int episodeCount;
  final String? posterUrl;
  final DateTime? nextRelease;
  final int episodeMinutes;
  final List<AnimeGenre> genres;

  bool hasGenre(String slug) => genres.any((genre) => genre.slug == slug);
}
