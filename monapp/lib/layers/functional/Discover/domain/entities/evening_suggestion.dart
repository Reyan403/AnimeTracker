import 'package:equatable/equatable.dart';

import '../../../Anime/domain/entities/anime_genre.dart';
import '../../../Catalogue/domain/entities/catalogue_anime.dart';

class EveningSuggestion extends Equatable {
  const EveningSuggestion({
    required this.anime,
    required this.genres,
    required this.isListed,
  });

  final CatalogueAnime anime;
  final List<AnimeGenre> genres;
  final bool isListed;

  EveningSuggestion asListed() =>
      EveningSuggestion(anime: anime, genres: genres, isListed: true);

  @override
  List<Object?> get props => [anime, genres, isListed];
}
