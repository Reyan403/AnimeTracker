import 'package:equatable/equatable.dart';

class CatalogueAnime extends Equatable {
  const CatalogueAnime({
    required this.id,
    required this.title,
    required this.format,
    required this.year,
    required this.episodeCount,
    this.posterUrl,
  });

  final int id;
  final String title;
  final String format;
  final int year;
  final int episodeCount;
  final String? posterUrl;

  @override
  List<Object?> get props => [id, title, format, year, episodeCount, posterUrl];
}
