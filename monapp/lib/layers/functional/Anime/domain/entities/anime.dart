import 'watch_status.dart';

class Anime {
  const Anime({
    required this.title,
    required this.originalTitle,
    required this.studio,
    required this.year,
    required this.episodeCount,
    required this.status,
  });

  final String title;
  final String originalTitle;
  final String studio;
  final int year;
  final int episodeCount;
  final WatchStatus status;
}
