class AnimeDetails {
  const AnimeDetails({
    required this.format,
    required this.year,
    required this.episodeCount,
    this.posterUrl,
    this.nextRelease,
  });

  final String format;
  final int year;
  final int episodeCount;
  final String? posterUrl;
  final DateTime? nextRelease;
}
