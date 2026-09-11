import '../../domain/entities/anime_sheet.dart';
import 'catalogue_anime_dto.dart';

abstract final class AnimeSheetDto {
  static const Map<String, String> _statuses = {
    'current': 'En cours de diffusion',
    'finished': 'Terminé',
    'tba': 'Date à annoncer',
    'unreleased': 'Inédit',
    'upcoming': 'À venir',
  };

  static const Map<String, String> _ageRatings = {
    'G': 'Tout public',
    'PG': 'Déconseillé aux moins de 13 ans',
    'R': 'Déconseillé aux moins de 17 ans',
    'R18': 'Interdit aux moins de 18 ans',
  };

  static AnimeSheet fromJson(Map<String, dynamic> json) {
    final data = json['data'] as Map<String, dynamic>? ?? const {};
    final attributes = data['attributes'] as Map<String, dynamic>? ?? const {};

    return AnimeSheet(
      id: int.parse(data['id'] as String),
      title: attributes['canonicalTitle'] as String? ?? '',
      format: CatalogueAnimeDto.formatOf(attributes['subtype'] as String?),
      synopsis: _textOf(attributes['synopsis']) ??
          _textOf(attributes['description']),
      status: _statuses[attributes['status']],
      startYear: _yearOrNull(attributes['startDate'] as String?),
      endYear: _yearOrNull(attributes['endDate'] as String?),
      episodeCount: attributes['episodeCount'] as int?,
      episodeMinutes: attributes['episodeLength'] as int?,
      totalMinutes: attributes['totalLength'] as int?,
      rating: _ratingOf(attributes['averageRating'] as String?),
      ratingRank: attributes['ratingRank'] as int?,
      popularityRank: attributes['popularityRank'] as int?,
      memberCount: attributes['userCount'] as int?,
      favoriteCount: attributes['favoritesCount'] as int?,
      ageRating: _ageRatings[attributes['ageRating']],
      posterUrl: CatalogueAnimeDto.posterOf(attributes),
      coverUrl: _coverOf(attributes),
    );
  }

  static String? _textOf(Object? value) {
    final text = value as String?;

    return text == null || text.isEmpty ? null : text;
  }

  static int? _yearOrNull(String? date) {
    final year = CatalogueAnimeDto.yearOf(date);

    return year == 0 ? null : year;
  }

  static int? _ratingOf(String? rating) =>
      rating == null ? null : double.tryParse(rating)?.round();

  static String? _coverOf(Map<String, dynamic> attributes) {
    final cover = attributes['coverImage'] as Map<String, dynamic>?;

    return cover?['large'] as String? ?? cover?['original'] as String?;
  }
}
