import 'dart:convert';

import 'package:http/http.dart' as http;

class KitsuRequestFailedException implements Exception {
  const KitsuRequestFailedException(this.path, this.statusCode);

  final String path;
  final int statusCode;

  @override
  String toString() => 'Kitsu returned $statusCode for $path';
}

class KitsuClient {
  const KitsuClient(this._httpClient);

  static const Duration timeout = Duration(seconds: 10);
  static const Map<String, String> _headers = {
    'Accept': 'application/vnd.api+json',
  };

  static final Uri _baseUrl = Uri.parse('https://kitsu.io/api/edge/');

  final http.Client _httpClient;

  Future<Map<String, dynamic>> getJson(String path) async {
    final response = await _httpClient
        .get(_baseUrl.resolve(path), headers: _headers)
        .timeout(timeout);

    if (response.statusCode != 200) {
      throw KitsuRequestFailedException(path, response.statusCode);
    }

    return jsonDecode(utf8.decode(response.bodyBytes)) as Map<String, dynamic>;
  }
}
