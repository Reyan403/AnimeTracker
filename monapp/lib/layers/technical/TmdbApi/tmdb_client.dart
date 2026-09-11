import 'dart:convert';

import 'package:http/http.dart' as http;

class TmdbRequestFailedException implements Exception {
  const TmdbRequestFailedException(this.path, this.statusCode);

  final String path;
  final int statusCode;

  @override
  String toString() => 'TMDB returned $statusCode for $path';
}

class TmdbClient {
  const TmdbClient(this._httpClient, {required this.apiKey});

  static const Duration timeout = Duration(seconds: 10);
  static const String language = 'fr-FR';

  static final Uri _baseUrl = Uri.parse('https://api.themoviedb.org/3/');

  final http.Client _httpClient;
  final String apiKey;

  bool get isConfigured => apiKey.isNotEmpty;

  Future<Map<String, dynamic>> getJson(
    String path,
    Map<String, String> query,
  ) async {
    final url = _baseUrl.resolve(path).replace(
      queryParameters: {...query, 'api_key': apiKey, 'language': language},
    );

    final response = await _httpClient.get(url).timeout(timeout);

    if (response.statusCode != 200) {
      throw TmdbRequestFailedException(path, response.statusCode);
    }

    return jsonDecode(utf8.decode(response.bodyBytes)) as Map<String, dynamic>;
  }
}
