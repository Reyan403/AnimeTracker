import 'package:flutter_test/flutter_test.dart';
import 'package:monapp/layers/functional/Anime/data/models/anime_details_dto.dart';

const attributes = {
  'canonicalTitle': 'Attack on Titan',
  'subtype': 'TV',
  'startDate': '2013-04-07',
  'episodeCount': 25,
  'posterImage': {
    'small': 'https://media.kitsu.app/anime/poster_images/7442/small.jpg',
    'original': 'https://media.kitsu.app/anime/poster_images/7442/original.png',
  },
};

Map<String, dynamic> payloadWith(Map<String, dynamic> changes) => {
      'data': {
        'id': '7442',
        'attributes': {...attributes, ...changes},
      },
    };

void main() {
  test('it reads what the Liste shows of an anime', () {
    final details = AnimeDetailsDto.fromJson(payloadWith(const {}));

    expect(details.format, 'Série TV');
    expect(details.year, 2013);
    expect(details.episodeCount, 25);
  });

  test('it keeps the small poster', () {
    expect(
      AnimeDetailsDto.fromJson(payloadWith(const {})).posterUrl,
      'https://media.kitsu.app/anime/poster_images/7442/small.jpg',
    );
  });

  test('it falls back on the original poster', () {
    final details = AnimeDetailsDto.fromJson(
      payloadWith(const {
        'posterImage': {'original': 'https://media.kitsu.app/o.png'},
      }),
    );

    expect(details.posterUrl, 'https://media.kitsu.app/o.png');
  });

  test('an anime without poster has none', () {
    final details = AnimeDetailsDto.fromJson(
      payloadWith(const {'posterImage': null}),
    );

    expect(details.posterUrl, isNull);
  });

  test('an unknown format and missing counts stay readable', () {
    final details = AnimeDetailsDto.fromJson(
      payloadWith(const {
        'subtype': null,
        'startDate': null,
        'episodeCount': null,
      }),
    );

    expect(details.format, AnimeDetailsDto.unknownFormat);
    expect(details.year, 0);
    expect(details.episodeCount, 0);
  });
}
