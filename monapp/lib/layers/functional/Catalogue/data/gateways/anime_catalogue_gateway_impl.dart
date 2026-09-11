import 'dart:async';

import 'package:http/http.dart' as http;

import '../../../../technical/JikanApi/jikan_client.dart';
import '../../domain/entities/catalogue_page.dart';
import '../../domain/gateways/anime_catalogue_gateway.dart';
import '../models/catalogue_page_dto.dart';

class AnimeCatalogueGatewayImpl implements AnimeCatalogueGateway {
  const AnimeCatalogueGatewayImpl(this._client);

  static const int pageSize = 25;

  final JikanClient _client;

  @override
  Future<CataloguePage> findMostPopular(int page) =>
      _pageAt('top/anime?page=$page&limit=$pageSize');

  @override
  Future<CataloguePage> search(String query, int page) => _pageAt(
        'anime?q=${Uri.encodeQueryComponent(query)}'
        '&page=$page&limit=$pageSize',
      );

  Future<CataloguePage> _pageAt(String path) async {
    try {
      return CataloguePageDto.fromJson(await _client.getJson(path));
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
