import '../../../../technical/KitsuApi/kitsu_client.dart';
import '../../domain/entities/anime_details.dart';
import '../../domain/gateways/anime_details_gateway.dart';
import '../models/anime_details_dto.dart';

class AnimeDetailsGatewayImpl implements AnimeDetailsGateway {
  const AnimeDetailsGatewayImpl(this._client);

  final KitsuClient _client;

  @override
  Future<AnimeDetails> findById(int id) async {
    try {
      return AnimeDetailsDto.fromJson(await _client.getJson('anime/$id'));
    } catch (_) {
      throw AnimeDetailsUnavailableException(id);
    }
  }
}
