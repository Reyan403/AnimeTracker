import 'dart:convert';

import 'package:http/http.dart' as http;

class AniListRequestFailedException implements Exception {
  const AniListRequestFailedException(this.statusCode);

  final int statusCode;

  @override
  String toString() => 'AniList returned $statusCode';
}

class AniListClient {
  const AniListClient(this._httpClient);

  static const Duration timeout = Duration(seconds: 10);
  static const Map<String, String> _headers = {
    'Content-Type': 'application/json',
    'Accept': 'application/json',
  };

  static final Uri _endpoint = Uri.parse('https://graphql.anilist.co');

  final http.Client _httpClient;

  Future<Map<String, dynamic>> query(
    String query, {
    Map<String, dynamic> variables = const {},
  }) async {
    final response = await _httpClient
        .post(
          _endpoint,
          headers: _headers,
          body: jsonEncode({'query': query, 'variables': variables}),
        )
        .timeout(timeout);

    if (response.statusCode != 200) {
      throw AniListRequestFailedException(response.statusCode);
    }

    return jsonDecode(utf8.decode(response.bodyBytes)) as Map<String, dynamic>;
  }
}
