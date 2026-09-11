import 'anime_details.dart';
import 'watch_status.dart';

class Anime {
  const Anime({
    required this.id,
    required this.title,
    required this.status,
    this.details,
    this.isLoadingDetails = false,
  });

  final int id;
  final String title;
  final WatchStatus status;
  final AnimeDetails? details;
  final bool isLoadingDetails;
}
