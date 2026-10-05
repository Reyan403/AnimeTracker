import 'package:equatable/equatable.dart';

import '../../../Anime/domain/entities/watch_status.dart';

class ConstellationStar extends Equatable {
  const ConstellationStar({
    required this.animeId,
    required this.title,
    required this.status,
    required this.x,
    required this.y,
    required this.weight,
    this.genreSlug,
    this.posterUrl,
  });

  final int animeId;
  final String title;
  final WatchStatus status;
  final double x;
  final double y;
  final double weight;
  final String? genreSlug;
  final String? posterUrl;

  @override
  List<Object?> get props =>
      [animeId, title, status, x, y, weight, genreSlug, posterUrl];
}
