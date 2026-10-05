import '../../../../technical/AniListApi/anilist_client.dart';
import '../../domain/entities/upcoming_episode.dart';
import '../../domain/gateways/release_schedule_gateway.dart';
import '../models/upcoming_episode_dto.dart';

class AniListReleaseScheduleGateway implements ReleaseScheduleGateway {
  const AniListReleaseScheduleGateway(this._client);

  static const int listedPageSize = 50;
  static const int popularPageSize = 20;
  static const int episodesPerListedAnime = 3;

  static const String _fields = '''
idMal
title { romaji english }
coverImage { large }
''';

  static const String _listedQuery = '''
query (\$ids: [Int]) {
  Page(perPage: $listedPageSize) {
    media(idMal_in: \$ids, type: ANIME) {
      $_fields
      airingSchedule(notYetAired: true, perPage: $episodesPerListedAnime) {
        nodes { airingAt episode }
      }
    }
  }
}
''';

  static const String _popularQuery = '''
query {
  Page(perPage: $popularPageSize) {
    media(type: ANIME, status: RELEASING, sort: POPULARITY_DESC) {
      $_fields
      airingSchedule(notYetAired: true, perPage: 1) {
        nodes { airingAt episode }
      }
    }
  }
}
''';

  final AniListClient _client;

  @override
  Future<List<UpcomingEpisode>> findForMalIds(List<int> malIds) {
    if (malIds.isEmpty) {
      return Future.value(const []);
    }

    return _run(
      _listedQuery,
      {'ids': malIds.take(listedPageSize).toList()},
    );
  }

  @override
  Future<List<UpcomingEpisode>> findPopularAiring() =>
      _run(_popularQuery, const {});

  Future<List<UpcomingEpisode>> _run(
    String query,
    Map<String, dynamic> variables,
  ) async {
    try {
      return UpcomingEpisodeDto.fromJson(
        await _client.query(query, variables: variables),
      );
    } catch (_) {
      throw const ReleaseScheduleUnavailableException();
    }
  }
}
