import 'package:equatable/equatable.dart';

import '../../../Anime/domain/entities/anime_genre.dart';
import '../../../Catalogue/domain/entities/catalogue_anime.dart';

class CatalogueSuggestion extends Equatable {
  const CatalogueSuggestion({required this.anime, required this.genres});

  final CatalogueAnime anime;
  final List<AnimeGenre> genres;

  @override
  List<Object?> get props => [anime, genres];
}

abstract interface class CatalogueSuggestionGateway {
  Future<int> countMatching(String? genreSlug);

  Future<CatalogueSuggestion?> findAt(String? genreSlug, int offset);
}

class CatalogueSuggestionUnavailableException implements Exception {
  const CatalogueSuggestionUnavailableException();

  @override
  String toString() => 'The catalogue suggestion is unavailable';
}
