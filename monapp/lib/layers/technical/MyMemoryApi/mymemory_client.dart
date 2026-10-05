import 'dart:convert';

import 'package:http/http.dart' as http;

class MyMemoryRequestFailedException implements Exception {
  const MyMemoryRequestFailedException(this.statusCode);

  final int statusCode;

  @override
  String toString() => 'MyMemory returned $statusCode';
}

class MyMemoryClient {
  const MyMemoryClient(this._httpClient);

  static const Duration timeout = Duration(seconds: 10);

  static final Uri _endpoint = Uri.parse(
    'https://api.mymemory.translated.net/get',
  );

  final http.Client _httpClient;

  Future<Map<String, dynamic>> translate(
    String text, {
    required String from,
    required String to,
  }) async {
    final url = _endpoint.replace(
      queryParameters: {'q': text, 'langpair': '$from|$to'},
    );
    final response = await _httpClient.get(url).timeout(timeout);

    if (response.statusCode != 200) {
      throw MyMemoryRequestFailedException(response.statusCode);
    }

    return jsonDecode(utf8.decode(response.bodyBytes)) as Map<String, dynamic>;
  }
}
