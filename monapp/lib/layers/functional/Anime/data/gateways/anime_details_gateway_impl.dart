import '../../../../technical/KitsuApi/kitsu_client.dart';
import '../../domain/entities/anime_details.dart';
import '../../domain/gateways/anime_details_gateway.dart';
import '../models/anime_details_dto.dart';

class AnimeDetailsGatewayImpl implements AnimeDetailsGateway {
  const AnimeDetailsGatewayImpl(this._client);

  static const int batchSize = 20;

  final KitsuClient _client;

  @override
  Future<Map<int, AnimeDetails>> findAllByIds(List<int> ids) async {
    final details = <int, AnimeDetails>{};

    for (var start = 0; start < ids.length; start += batchSize) {
      details.addAll(
        await _batched(ids.skip(start).take(batchSize).toList()),
      );
    }

    return details;
  }

  Future<Map<int, AnimeDetails>> _batched(List<int> ids) async {
    try {
      return AnimeDetailsDto.fromJson(
        await _client.getJson(
          'anime?filter%5Bid%5D=${ids.join(',')}&page%5Blimit%5D=$batchSize',
        ),
      );
    } catch (_) {
      throw const AnimeDetailsUnavailableException();
    }
  }
}
