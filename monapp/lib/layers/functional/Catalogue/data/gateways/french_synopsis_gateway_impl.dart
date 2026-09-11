import '../../../../technical/TmdbApi/tmdb_client.dart';
import '../../domain/gateways/french_synopsis_gateway.dart';
import '../models/french_synopsis_dto.dart';

class FrenchSynopsisGatewayImpl implements FrenchSynopsisGateway {
  const FrenchSynopsisGatewayImpl(this._client);

  final TmdbClient _client;

  @override
  Future<String?> findFor(String title) async {
    if (!_client.isConfigured) {
      return null;
    }

    try {
      final payload = await _client.getJson('search/multi', {'query': title});

      return FrenchSynopsisDto.fromJson(payload);
    } catch (_) {
      return null;
    }
  }
}
