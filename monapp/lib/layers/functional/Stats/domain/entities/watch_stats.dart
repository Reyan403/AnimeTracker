import 'package:equatable/equatable.dart';

import '../../../Anime/domain/entities/anime_genre.dart';

class GenreShare extends Equatable {
  const GenreShare({required this.genre, required this.count});

  final AnimeGenre genre;
  final int count;

  @override
  List<Object?> get props => [genre, count];
}

class WatchStats extends Equatable {
  const WatchStats({
    required this.episodesWatched,
    required this.toWatchCount,
    required this.watchingCount,
    required this.completedCount,
    required this.topGenres,
  });

  final int episodesWatched;
  final int toWatchCount;
  final int watchingCount;
  final int completedCount;
  final List<GenreShare> topGenres;

  int get animeCount => toWatchCount + watchingCount + completedCount;

  bool get isEmpty => animeCount == 0;

  @override
  List<Object?> get props => [
        episodesWatched,
        toWatchCount,
        watchingCount,
        completedCount,
        topGenres,
      ];
}
