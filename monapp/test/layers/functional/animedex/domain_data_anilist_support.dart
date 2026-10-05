import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:monapp/layers/technical/AniListApi/anilist_client.dart';

Map<String, dynamic> characterPage({
  required int id,
  String name = 'Spike Spiegel',
  int? favourites = 20000,
  String? english = 'Cowboy Bebop (EN)',
  String? romaji = 'Cowboy Bebop',
  String? image,
}) => {
  'characters': [
    {
      'id': id,
      'name': {'full': name, 'native': 'スパイク'},
      'image': {'large': image ?? 'https://img/$id.png'},
      'favourites': favourites,
      'media': {
        'nodes': [
          {
            'title': {'romaji': romaji, 'english': english},
          },
        ],
      },
    },
  ],
};

Map<String, dynamic> characterResponse(List<Map<String, dynamic>> pages) => {
  'data': {
    for (var slot = 0; slot < pages.length; slot++) 'c$slot': pages[slot],
  },
};

AniListClient clientReplying(
  Future<http.Response> Function(http.Request request) handler,
) => AniListClient(MockClient(handler));

http.Response jsonResponse(Map<String, dynamic> body, {int status = 200}) =>
    http.Response(
      jsonEncode(body),
      status,
      headers: {'content-type': 'application/json; charset=utf-8'},
    );
