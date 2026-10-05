import '../../../Anime/domain/entities/anime_genre.dart';
import '../../domain/entities/card_rarity.dart';
import '../../domain/entities/dex_card.dart';

abstract final class DexCardDto {
  static Map<String, dynamic> toJson(DexCard card) => {
    'id': card.animeId,
    'title': card.title,
    'rarity': card.rarity.name,
    'format': card.format,
    'year': card.year,
    'episodes': card.episodeCount,
    'obtainedOn': card.obtainedOn.toIso8601String(),
    'poster': card.posterUrl,
    'genres': [
      for (final genre in card.genres)
        {'slug': genre.slug, 'title': genre.title},
    ],
  };

  static DexCard? fromJson(Object? source) {
    if (source is! Map) {
      return null;
    }

    final id = source['id'];
    final title = source['title'];
    final obtainedOn = DateTime.tryParse('${source['obtainedOn']}');
    final rarity = CardRarity.values.asNameMap()[source['rarity']];

    if (id is! int ||
        title is! String ||
        obtainedOn == null ||
        rarity == null) {
      return null;
    }

    return DexCard(
      animeId: id,
      title: title,
      rarity: rarity,
      format: source['format'] is String ? source['format'] as String : '',
      year: source['year'] is int ? source['year'] as int : 0,
      episodeCount: source['episodes'] is int ? source['episodes'] as int : 0,
      obtainedOn: obtainedOn,
      posterUrl: source['poster'] is String ? source['poster'] as String : null,
      genres: _genresOf(source['genres']),
    );
  }

  static List<AnimeGenre> _genresOf(Object? source) => [
    if (source is List)
      for (final genre in source)
        if (genre is Map && genre['slug'] is String && genre['title'] is String)
          AnimeGenre(
            slug: genre['slug'] as String,
            title: genre['title'] as String,
          ),
  ];
}
