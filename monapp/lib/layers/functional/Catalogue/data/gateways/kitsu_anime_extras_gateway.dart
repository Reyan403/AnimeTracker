import '../../../../technical/KitsuApi/kitsu_client.dart';
import '../../domain/entities/anime_extras.dart';
import '../../domain/gateways/anime_extras_gateway.dart';
import '../models/anime_extras_dto.dart';

class KitsuAnimeExtrasGateway implements AnimeExtrasGateway {
  const KitsuAnimeExtrasGateway(this._client);

  static const int relationLimit = 20;

  final KitsuClient _client;

  @override
  Future<List<StreamingLink>> findStreamingLinks(int animeId) async {
    try {
      return AnimeExtrasDto.streamingLinksFrom(
        await _client.getJson(
          'anime/$animeId/streaming-links?include=streamer'
          '&fields%5Bstreamers%5D=siteName&fields%5BstreamingLinks%5D=url',
        ),
      );
    } catch (_) {
      throw const AnimeExtrasUnavailableException();
    }
  }

  @override
  Future<List<RelatedAnime>> findRelated(int animeId) async {
    try {
      return AnimeExtrasDto.relatedFrom(
        await _client.getJson(
          'anime/$animeId/media-relationships?include=destination'
          '&page%5Blimit%5D=$relationLimit'
          '&fields%5BmediaRelationships%5D=role,destination'
          '&fields%5Banime%5D=canonicalTitle,posterImage,subtype,startDate,'
          'episodeCount',
        ),
      );
    } catch (_) {
      throw const AnimeExtrasUnavailableException();
    }
  }
}
