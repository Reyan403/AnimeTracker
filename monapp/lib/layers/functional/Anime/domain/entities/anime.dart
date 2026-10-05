import 'anime_details.dart';
import 'watch_status.dart';

class Anime {
  const Anime({
    required this.id,
    required this.title,
    required this.status,
    this.episodesWatched = 0,
    this.details,
    this.isLoadingDetails = false,
  });

  final int id;
  final String title;
  final WatchStatus status;
  final int episodesWatched;
  final AnimeDetails? details;
  final bool isLoadingDetails;

  int get totalEpisodes => details?.episodeCount ?? 0;

  bool get isFinished => totalEpisodes > 0 && episodesWatched >= totalEpisodes;

  double? get progress =>
      totalEpisodes > 0 ? (episodesWatched / totalEpisodes).clamp(0, 1) : null;
}
