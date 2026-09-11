import 'package:flutter_test/flutter_test.dart';
import 'package:monapp/layers/functional/Catalogue/data/models/catalogue_anime_dto.dart';

const payload = {
  'id': '7442',
  'attributes': {
    'canonicalTitle': 'Naruto: Shippuuden',
    'subtype': 'TV',
    'startDate': '2007-02-15',
    'episodeCount': 500,
    'posterImage': {
      'small': 'https://media.kitsu.app/anime/poster_images/7442/small.jpg',
      'original': 'https://media.kitsu.app/anime/poster_images/7442/original.png',
    },
  },
};

Map<String, dynamic> payloadWith(Map<String, dynamic> attributes) => {
      ...payload,
      'attributes': {
        ...payload['attributes']! as Map<String, dynamic>,
        ...attributes,
      },
    };

void main() {
  test('it reads the fields Kitsu returns for an anime', () {
    final anime = CatalogueAnimeDto.fromJson(payload);

    expect(anime.id, 7442);
    expect(anime.title, 'Naruto: Shippuuden');
    expect(anime.episodeCount, 500);
  });

  test('it keeps only the year of the release date', () {
    expect(CatalogueAnimeDto.fromJson(payload).year, 2007);
  });

  test('it says the format in French', () {
    expect(CatalogueAnimeDto.fromJson(payload).format, 'Série TV');
    expect(
      CatalogueAnimeDto.fromJson(payloadWith({'subtype': 'movie'})).format,
      'Film',
    );
  });

  test('an unknown format is shown as Kitsu named it', () {
    final anime = CatalogueAnimeDto.fromJson(payloadWith({'subtype': 'PV'}));

    expect(anime.format, 'PV');
  });

  test('an anime without date nor episode count stays readable', () {
    final anime = CatalogueAnimeDto.fromJson(
      payloadWith({'startDate': null, 'episodeCount': null, 'subtype': null}),
    );

    expect(anime.year, 0);
    expect(anime.episodeCount, 0);
    expect(anime.format, CatalogueAnimeDto.unknownFormat);
  });

  test('it keeps the small poster of the anime', () {
    final anime = CatalogueAnimeDto.fromJson(payload);

    expect(
      anime.posterUrl,
      'https://media.kitsu.app/anime/poster_images/7442/small.jpg',
    );
  });

  test('it falls back on the original poster', () {
    final anime = CatalogueAnimeDto.fromJson(
      payloadWith(const {
        'posterImage': {
          'original': 'https://media.kitsu.app/anime/poster_images/7442/original.png',
        },
      }),
    );

    expect(anime.posterUrl, endsWith('original.png'));
  });

  test('an anime without poster has none', () {
    final anime = CatalogueAnimeDto.fromJson(payloadWith(const {'posterImage': null}));

    expect(anime.posterUrl, isNull);
  });
}
