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
      'data': [
        {
          'id': '7442',
          'attributes': {...attributes, ...changes},
        },
      ],
    };

void main() {
  test('it keys every anime of the answer by its identifier', () {
    final details = AnimeDetailsDto.fromJson(payloadWith(const {}));

    expect(details.keys, [7442]);
  });

  test('it reads what the Liste shows of an anime', () {
    final details = AnimeDetailsDto.fromJson(payloadWith(const {}))[7442]!;

    expect(details.format, 'Série TV');
    expect(details.year, 2013);
    expect(details.episodeCount, 25);
  });

  test('it keeps the small poster', () {
    final details = AnimeDetailsDto.fromJson(payloadWith(const {}))[7442]!;

    expect(
      details.posterUrl,
      'https://media.kitsu.app/anime/poster_images/7442/small.jpg',
    );
  });

  test('it falls back on the original poster', () {
    final details = AnimeDetailsDto.fromJson(
      payloadWith(const {
        'posterImage': {'original': 'https://media.kitsu.app/o.png'},
      }),
    )[7442]!;

    expect(details.posterUrl, 'https://media.kitsu.app/o.png');
  });

  test('an unknown format and missing counts stay readable', () {
    final details = AnimeDetailsDto.fromJson(
      payloadWith(const {
        'subtype': null,
        'startDate': null,
        'episodeCount': null,
        'posterImage': null,
      }),
    )[7442]!;

    expect(details.format, AnimeDetailsDto.unknownFormat);
    expect(details.year, 0);
    expect(details.episodeCount, 0);
    expect(details.posterUrl, isNull);
  });

  test('an empty answer gives nothing', () {
    expect(AnimeDetailsDto.fromJson(const {}), isEmpty);
  });
}
