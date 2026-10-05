import '../../../Anime/domain/entities/anime_genre.dart';
import '../../../Catalogue/data/models/catalogue_anime_dto.dart';
import '../../domain/entities/dex_card.dart';
import '../rules/rarity_rule.dart';

abstract final class BoosterCandidateDto {
  static DexCard? fromJson(
    Map<String, dynamic> json, {
    required DateTime obtainedOn,
  }) {
    final data = json['data'];

    if (data is! List || data.isEmpty) {
      return null;
    }

    final node = data.first as Map<String, dynamic>;
    final attributes = node['attributes'] as Map<String, dynamic>? ?? const {};
    final anime = CatalogueAnimeDto.fromJson(node);

    if (anime.title.isEmpty) {
      return null;
    }

    return DexCard(
      animeId: anime.id,
      title: anime.title,
      rarity: RarityRule.of(
        averageRating: double.tryParse('${attributes['averageRating']}'),
        popularityRank: attributes['popularityRank'] as int?,
      ),
      format: anime.format,
      year: anime.year,
      episodeCount: anime.episodeCount,
      obtainedOn: obtainedOn,
      posterUrl: anime.posterUrl,
      genres: _genresOf(node, json['included'] as List<dynamic>? ?? const []),
    );
  }

  static List<AnimeGenre> _genresOf(
    Map<String, dynamic> node,
    List<dynamic> included,
  ) {
    final byId = {
      for (final item in included)
        if ((item as Map<String, dynamic>)['type'] == 'categories')
          item['id'] as String: item['attributes'] as Map<String, dynamic>,
    };
    final relationships = node['relationships'] as Map<String, dynamic>?;
    final categories = relationships?['categories'] as Map<String, dynamic>?;
    final links = categories?['data'] as List<dynamic>? ?? const [];

    return [
      for (final link in links)
        if (byId[(link as Map<String, dynamic>)['id']] case final genre?)
          if (genre['slug'] is String && genre['title'] is String)
            AnimeGenre(
              slug: genre['slug'] as String,
              title: genre['title'] as String,
            ),
    ];
  }
}
