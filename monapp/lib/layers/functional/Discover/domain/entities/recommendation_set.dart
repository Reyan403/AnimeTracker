import 'package:equatable/equatable.dart';

import '../../../Anime/domain/entities/anime_genre.dart';
import '../../../Catalogue/domain/entities/catalogue_anime.dart';

class RecommendationSet extends Equatable {
  const RecommendationSet({required this.basedOn, required this.animes});

  static const RecommendationSet none =
      RecommendationSet(basedOn: [], animes: []);

  final List<AnimeGenre> basedOn;
  final List<CatalogueAnime> animes;

  bool get isEmpty => animes.isEmpty;

  @override
  List<Object?> get props => [basedOn, animes];
}
