import 'package:equatable/equatable.dart';

import '../../../Anime/domain/entities/anime.dart';
import '../../../Anime/domain/entities/anime_genre.dart';

class EveningSuggestion extends Equatable {
  const EveningSuggestion({
    required this.anime,
    required this.matchedGenres,
    required this.isContinuing,
  });

  final Anime anime;
  final List<AnimeGenre> matchedGenres;
  final bool isContinuing;

  @override
  List<Object?> get props => [anime.id, matchedGenres, isContinuing];
}
