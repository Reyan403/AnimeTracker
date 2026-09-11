class AnimeDetails {
  const AnimeDetails({
    required this.studio,
    required this.year,
    required this.episodeCount,
    this.posterUrl,
  });

  final String studio;
  final int year;
  final int episodeCount;
  final String? posterUrl;
}
