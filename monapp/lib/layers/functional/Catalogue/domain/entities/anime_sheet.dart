import 'package:equatable/equatable.dart';

class AnimeSheet extends Equatable {
  const AnimeSheet({
    required this.id,
    required this.title,
    required this.format,
    this.synopsis,
    this.status,
    this.startYear,
    this.endYear,
    this.episodeCount,
    this.episodeMinutes,
    this.totalMinutes,
    this.rating,
    this.ratingRank,
    this.popularityRank,
    this.memberCount,
    this.favoriteCount,
    this.ageRating,
    this.posterUrl,
    this.coverUrl,
    this.isCached = false,
  });

  final int id;
  final String title;
  final String format;
  final String? synopsis;
  final String? status;
  final int? startYear;
  final int? endYear;
  final int? episodeCount;
  final int? episodeMinutes;
  final int? totalMinutes;
  final int? rating;
  final int? ratingRank;
  final int? popularityRank;
  final int? memberCount;
  final int? favoriteCount;
  final String? ageRating;
  final String? posterUrl;
  final String? coverUrl;
  final bool isCached;

  AnimeSheet withSynopsis(String synopsis) => _copy(synopsis: synopsis);

  AnimeSheet asCached() => _copy(isCached: true);

  AnimeSheet _copy({String? synopsis, bool? isCached}) => AnimeSheet(
        id: id,
        title: title,
        format: format,
        synopsis: synopsis ?? this.synopsis,
        status: status,
        startYear: startYear,
        endYear: endYear,
        episodeCount: episodeCount,
        episodeMinutes: episodeMinutes,
        totalMinutes: totalMinutes,
        rating: rating,
        ratingRank: ratingRank,
        popularityRank: popularityRank,
        memberCount: memberCount,
        favoriteCount: favoriteCount,
        ageRating: ageRating,
        posterUrl: posterUrl,
        coverUrl: coverUrl,
        isCached: isCached ?? this.isCached,
      );

  @override
  List<Object?> get props => [
        id,
        title,
        format,
        synopsis,
        status,
        startYear,
        endYear,
        episodeCount,
        episodeMinutes,
        totalMinutes,
        rating,
        ratingRank,
        popularityRank,
        memberCount,
        favoriteCount,
        ageRating,
        posterUrl,
        coverUrl,
        isCached,
      ];
}
