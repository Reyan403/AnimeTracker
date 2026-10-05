import '../../domain/entities/anime_extras.dart';
import 'catalogue_anime_dto.dart';

abstract final class AnimeExtrasDto {
  static const Map<String, RelationRole> _roles = {
    'prequel': RelationRole.prequel,
    'sequel': RelationRole.sequel,
  };

  static List<StreamingLink> streamingLinksFrom(Map<String, dynamic> json) {
    final streamers = {
      for (final node in _list(json['included']))
        if (node['type'] == 'streamers')
          node['id'] as String: _attributes(node)['siteName'] as String?,
    };
    final links = <StreamingLink>[];
    final seen = <String>{};

    for (final node in _list(json['data'])) {
      final url = _attributes(node)['url'] as String?;
      final streamerId = _relationId(node, 'streamer');
      final siteName = streamers[streamerId];

      if (url != null && siteName != null && seen.add(siteName)) {
        links.add(StreamingLink(siteName: siteName, url: url));
      }
    }

    return links;
  }

  static List<RelatedAnime> relatedFrom(Map<String, dynamic> json) {
    final animes = {
      for (final node in _list(json['included']))
        if (node['type'] == 'anime') node['id'] as String: node,
    };
    final related = <RelatedAnime>[];

    for (final node in _list(json['data'])) {
      final role = _roles[_attributes(node)['role']];
      final destination = animes[_relationId(node, 'destination')];

      if (role != null && destination != null) {
        related.add(
          RelatedAnime(
            anime: CatalogueAnimeDto.fromJson(destination),
            role: role,
          ),
        );
      }
    }

    return related
      ..sort((a, b) => a.role.index.compareTo(b.role.index));
  }

  static List<Map<String, dynamic>> _list(Object? value) => [
        for (final node in value as List<dynamic>? ?? const [])
          node as Map<String, dynamic>,
      ];

  static Map<String, dynamic> _attributes(Map<String, dynamic> node) =>
      node['attributes'] as Map<String, dynamic>? ?? const {};

  static String? _relationId(Map<String, dynamic> node, String name) {
    final relationships = node['relationships'] as Map<String, dynamic>?;
    final relation = relationships?[name] as Map<String, dynamic>?;
    final data = relation?['data'] as Map<String, dynamic>?;

    return data?['id'] as String?;
  }
}
