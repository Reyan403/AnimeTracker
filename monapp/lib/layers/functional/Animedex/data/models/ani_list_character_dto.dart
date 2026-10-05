import '../../domain/entities/dex_card.dart';
import '../rules/rarity_rule.dart';

abstract final class AniListCharacterDto {
  static const String defaultImageMarker = '/default.';

  static List<DexCard> fromJson(
    Map<String, dynamic> json, {
    required DateTime obtainedOn,
  }) {
    final data = json['data'];

    if (data is! Map) {
      return const [];
    }

    return [for (final page in data.values) ?_cardOf(page, obtainedOn)];
  }

  static DexCard? _cardOf(Object? page, DateTime obtainedOn) {
    final characters = page is Map ? page['characters'] : null;

    if (characters is! List || characters.isEmpty) {
      return null;
    }

    final character = characters.first;

    if (character is! Map) {
      return null;
    }

    final id = character['id'];
    final names = character['name'];
    final name = names is Map ? _textOf(names['full']) : null;

    if (id is! int || name == null) {
      return null;
    }

    final favourites = character['favourites'] is int
        ? character['favourites'] as int
        : 0;

    return DexCard(
      characterId: id,
      name: name,
      rarity: RarityRule.of(favourites),
      favourites: favourites,
      obtainedOn: obtainedOn,
      nativeName: names is Map ? _textOf(names['native']) : null,
      imageUrl: _imageOf(character['image']),
      animeTitle: _animeTitleOf(character['media']),
    );
  }

  static String? _imageOf(Object? image) {
    final url = image is Map ? _textOf(image['large']) : null;

    return url == null || url.contains(defaultImageMarker) ? null : url;
  }

  static String? _animeTitleOf(Object? media) {
    final nodes = media is Map ? media['nodes'] : null;

    if (nodes is! List || nodes.isEmpty || nodes.first is! Map) {
      return null;
    }

    final title = (nodes.first as Map)['title'];

    return title is Map
        ? _textOf(title['english']) ?? _textOf(title['romaji'])
        : null;
  }

  static String? _textOf(Object? value) {
    if (value is! String) {
      return null;
    }

    final trimmed = value.trim();

    return trimmed.isEmpty ? null : trimmed;
  }
}
