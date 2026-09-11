import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:monapp/layers/technical/TmdbApi/tmdb_client.dart';

http.Client respondingWith(
  String body, {
  int statusCode = 200,
  void Function(http.Request)? onRequest,
}) =>
    MockClient((request) async {
      onRequest?.call(request);

      return http.Response.bytes(utf8.encode(body), statusCode);
    });

void main() {
  test('it asks TMDB in French, with the key', () async {
    late Uri asked;
    final client = TmdbClient(
      respondingWith('{"results": []}', onRequest: (r) => asked = r.url),
      apiKey: 'a-key',
    );

    await client.getJson('search/multi', {'query': 'one piece'});

    expect(asked.path, '/3/search/multi');
    expect(asked.queryParameters, {
      'query': 'one piece',
      'api_key': 'a-key',
      'language': 'fr-FR',
    });
  });

  test('it decodes the payload as UTF-8', () async {
    final client = TmdbClient(
      respondingWith('{"overview": "Il était une fois…"}'),
      apiKey: 'a-key',
    );

    expect(await client.getJson('search/multi', const {}), {
      'overview': 'Il était une fois…',
    });
  });

  test('a refused request is reported', () async {
    final client = TmdbClient(respondingWith('{}', statusCode: 401),
        apiKey: 'a-key');

    expect(
      () => client.getJson('search/multi', const {}),
      throwsA(isA<TmdbRequestFailedException>()),
    );
  });

  test('without a key the client says it is not configured', () {
    expect(TmdbClient(respondingWith('{}'), apiKey: '').isConfigured, isFalse);
    expect(TmdbClient(respondingWith('{}'), apiKey: 'a').isConfigured, isTrue);
  });
}
