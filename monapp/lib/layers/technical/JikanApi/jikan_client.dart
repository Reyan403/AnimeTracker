import 'dart:convert';

import 'package:http/http.dart' as http;

class JikanRequestFailedException implements Exception {
  const JikanRequestFailedException(this.path, this.statusCode);

  final String path;
  final int statusCode;

  @override
  String toString() => 'Jikan returned $statusCode for $path';
}

class JikanClient {
  JikanClient(this._httpClient);

  static final Uri _baseUrl = Uri.parse('https://api.jikan.moe/v4/');
  static const Duration _timeout = Duration(seconds: 10);
  static const Duration _minimumInterval = Duration(milliseconds: 340);

  final http.Client _httpClient;

  Future<void> _pacing = Future<void>.value();

  Future<Map<String, dynamic>> getJson(String path) async {
    await _waitForSlot();

    final response = await _httpClient
        .get(_baseUrl.resolve(path))
        .timeout(_timeout);

    if (response.statusCode != 200) {
      throw JikanRequestFailedException(path, response.statusCode);
    }

    return jsonDecode(response.body) as Map<String, dynamic>;
  }

  Future<void> _waitForSlot() {
    final slot = _pacing;
    _pacing = slot.then((_) => Future<void>.delayed(_minimumInterval));
    return slot;
  }
}
