import '../../../../technical/KitsuApi/kitsu_client.dart';
import '../../domain/entities/anime_sheet.dart';
import '../../domain/gateways/anime_catalogue_gateway.dart';
import '../../domain/gateways/anime_sheet_gateway.dart';
import '../models/anime_sheet_dto.dart';

class AnimeSheetGatewayImpl implements AnimeSheetGateway {
  const AnimeSheetGatewayImpl(this._client);

  final KitsuClient _client;

  @override
  Future<AnimeSheet> findById(int id) async {
    try {
      return AnimeSheetDto.fromJson(await _client.getJson('anime/$id'));
    } catch (_) {
      throw const CatalogueUnavailableException();
    }
  }
}
