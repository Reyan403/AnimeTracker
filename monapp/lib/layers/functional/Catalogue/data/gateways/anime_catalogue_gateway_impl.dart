import 'dart:async';

import 'package:http/http.dart' as http;

import '../../../../technical/KitsuApi/kitsu_client.dart';
import '../../domain/entities/catalogue_page.dart';
import '../../domain/gateways/anime_catalogue_gateway.dart';
import '../models/catalogue_page_dto.dart';

class AnimeCatalogueGatewayImpl implements AnimeCatalogueGateway {
  const AnimeCatalogueGatewayImpl(this._client);

  static const int pageSize = 25;

  final KitsuClient _client;

  @override
  Future<CataloguePage> findMostPopular(int page) =>
      _pageAt('anime?sort=-userCount&${_slice(page)}');

  @override
  Future<CataloguePage> search(String query, int page) => _pageAt(
        'anime?filter%5Btext%5D=${Uri.encodeQueryComponent(query)}'
        '&${_slice(page)}',
      );

  static String _slice(int page) =>
      'page%5Blimit%5D=$pageSize&page%5Boffset%5D=${(page - 1) * pageSize}';

  Future<CataloguePage> _pageAt(String path) async {
    try {
      return CataloguePageDto.fromJson(await _client.getJson(path));
    } on KitsuRequestFailedException {
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
