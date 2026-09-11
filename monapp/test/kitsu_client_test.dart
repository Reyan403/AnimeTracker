import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:monapp/layers/technical/KitsuApi/kitsu_client.dart';

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
  test('it asks Kitsu for the given path', () async {
    late Uri asked;
    final client = KitsuClient(
      respondingWith('{"data": []}', onRequest: (r) => asked = r.url),
    );

    await client.getJson('anime?page%5Blimit%5D=25');

    expect(asked.toString(),
        'https://kitsu.io/api/edge/anime?page%5Blimit%5D=25');
  });

  test('it decodes the payload as UTF-8', () async {
    final client = KitsuClient(respondingWith('{"title": "Frières été"}'));

    expect(await client.getJson('anime'), {'title': 'Frières été'});
  });

  test('a refused request is reported', () async {
    final client = KitsuClient(respondingWith('{}', statusCode: 503));

    expect(
      () => client.getJson('anime'),
      throwsA(isA<KitsuRequestFailedException>()),
    );
  });
}
