import '../../domain/entities/upcoming_episode.dart';

abstract final class UpcomingEpisodeDto {
  static List<UpcomingEpisode> fromJson(Map<String, dynamic> json) {
    final data = json['data'] as Map<String, dynamic>? ?? const {};
    final page = data['Page'] as Map<String, dynamic>? ?? const {};
    final media = page['media'] as List<dynamic>? ?? const [];

    return [
      for (final node in media) ..._episodesOf(node as Map<String, dynamic>),
    ];
  }

  static List<UpcomingEpisode> _episodesOf(Map<String, dynamic> media) {
    final title = media['title'] as Map<String, dynamic>? ?? const {};
    final schedule = media['airingSchedule'] as Map<String, dynamic>?;
    final nodes = schedule?['nodes'] as List<dynamic>? ?? const [];

    return [
      for (final node in nodes)
        UpcomingEpisode(
          title: title['english'] as String? ??
              title['romaji'] as String? ??
              '',
          episode: (node as Map<String, dynamic>)['episode'] as int,
          airingAt: DateTime.fromMillisecondsSinceEpoch(
            (node['airingAt'] as int) * 1000,
            isUtc: true,
          ),
          malId: media['idMal'] as int?,
          coverUrl: (media['coverImage'] as Map<String, dynamic>?)?['large']
              as String?,
        ),
    ];
  }
}
