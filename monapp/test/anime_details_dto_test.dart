import 'package:flutter_test/flutter_test.dart';
import 'package:monapp/layers/functional/Anime/data/models/anime_details_dto.dart';

const payload = {
  'studios': [
    {'name': 'Toei Animation'},
  ],
  'year': 1999,
  'episodes': 1000,
  'images': {
    'jpg': {
      'image_url': 'https://cdn.myanimelist.net/images/anime/1244/138851.jpg',
      'large_image_url':
          'https://cdn.myanimelist.net/images/anime/1244/138851l.jpg',
    },
  },
};

void main() {
  test('it reads the fields Jikan returns for an anime', () {
    final details = AnimeDetailsDto.fromJson(payload);

    expect(details.studio, 'Toei Animation');
    expect(details.year, 1999);
    expect(details.episodeCount, 1000);
  });

  test('it keeps the poster of the anime', () {
    expect(
      AnimeDetailsDto.fromJson(payload).posterUrl,
      'https://cdn.myanimelist.net/images/anime/1244/138851.jpg',
    );
  });

  test('it falls back on the large poster', () {
    final details = AnimeDetailsDto.fromJson({
      ...payload,
      'images': {
        'jpg': {
          'large_image_url':
              'https://cdn.myanimelist.net/images/anime/1244/138851l.jpg',
        },
      },
    });

    expect(details.posterUrl, endsWith('138851l.jpg'));
  });

  test('an anime without image has no poster', () {
    final details = AnimeDetailsDto.fromJson({...payload, 'images': null});

    expect(details.posterUrl, isNull);
  });

  test('an anime without studio falls back to an unknown one', () {
    final details = AnimeDetailsDto.fromJson({...payload, 'studios': []});

    expect(details.studio, AnimeDetailsDto.unknownStudio);
  });
}
