import 'dart:async';

import 'package:http/http.dart' as http;

import '../../domain/entities/anime_details.dart';
import '../../domain/gateways/anime_details_gateway.dart';
import '../../../../technical/JikanApi/jikan_client.dart';
import '../models/anime_details_dto.dart';

class AnimeDetailsGatewayImpl implements AnimeDetailsGateway {
  const AnimeDetailsGatewayImpl(this._client);

  final JikanClient _client;

  @override
  Future<AnimeDetails> findByMalId(int malId) async {
    try {
      final payload = await _client.getJson('anime/$malId');
      final data = payload['data'] as Map<String, dynamic>?;

      if (data == null) {
        throw AnimeDetailsUnavailableException(malId);
      }

      return AnimeDetailsDto.fromJson(data);
    } on JikanRequestFailedException {
      throw AnimeDetailsUnavailableException(malId);
    } on TimeoutException {
      throw AnimeDetailsUnavailableException(malId);
    } on http.ClientException {
      throw AnimeDetailsUnavailableException(malId);
    } on FormatException {
      throw AnimeDetailsUnavailableException(malId);
    }
  }
}
