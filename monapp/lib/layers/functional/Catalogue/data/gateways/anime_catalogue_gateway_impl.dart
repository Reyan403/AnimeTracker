import 'dart:async';

import 'package:http/http.dart' as http;

import '../../../../technical/JikanApi/jikan_client.dart';
import '../../domain/entities/catalogue_anime.dart';
import '../../domain/gateways/anime_catalogue_gateway.dart';
import '../models/catalogue_anime_dto.dart';

class AnimeCatalogueGatewayImpl implements AnimeCatalogueGateway {
  const AnimeCatalogueGatewayImpl(this._client);

  static const int pageSize = 25;

  final JikanClient _client;

  @override
  Future<List<CatalogueAnime>> findMostPopular() =>
      _animesAt('top/anime?limit=$pageSize&sfw=true');

  @override
  Future<List<CatalogueAnime>> search(String query) => _animesAt(
        'anime?q=${Uri.encodeQueryComponent(query)}'
        '&limit=$pageSize&order_by=members&sort=desc&sfw=true',
      );

  Future<List<CatalogueAnime>> _animesAt(String path) async {
    try {
      final payload = await _client.getJson(path);
      final data = payload['data'] as List<dynamic>? ?? const [];

      return [
        for (final node in data)
          CatalogueAnimeDto.fromJson(node as Map<String, dynamic>),
      ];
    } on JikanRequestFailedException {
      throw const CatalogueUnavailableException();
    } on TimeoutException {
      throw const CatalogueUnavailableException();
    } on http.ClientException {
      throw const CatalogueUnavailableException();
    } on FormatException {
      throw const CatalogueUnavailableException();
    } on TypeError {
      throw const CatalogueUnavailableException();
    }
  }
}
