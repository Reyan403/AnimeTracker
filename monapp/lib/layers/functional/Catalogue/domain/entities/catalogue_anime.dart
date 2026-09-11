import 'package:equatable/equatable.dart';

class CatalogueAnime extends Equatable {
  const CatalogueAnime({
    required this.malId,
    required this.title,
    required this.studio,
    required this.year,
    required this.episodeCount,
  });

  final int malId;
  final String title;
  final String studio;
  final int year;
  final int episodeCount;

  @override
  List<Object?> get props => [malId, title, studio, year, episodeCount];
}
