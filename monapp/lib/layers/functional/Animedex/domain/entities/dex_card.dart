import 'package:equatable/equatable.dart';

import '../../../Anime/domain/entities/anime_genre.dart';
import 'card_rarity.dart';

class DexCard extends Equatable {
  const DexCard({
    required this.animeId,
    required this.title,
    required this.rarity,
    required this.format,
    required this.year,
    required this.episodeCount,
    required this.obtainedOn,
    this.posterUrl,
    this.genres = const [],
  });

  final int animeId;
  final String title;
  final CardRarity rarity;
  final String format;
  final int year;
  final int episodeCount;
  final DateTime obtainedOn;
  final String? posterUrl;
  final List<AnimeGenre> genres;

  @override
  List<Object?> get props => [
        animeId,
        title,
        rarity,
        format,
        year,
        episodeCount,
        obtainedOn,
        posterUrl,
        genres,
      ];
}
