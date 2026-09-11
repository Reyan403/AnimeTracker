import 'package:flutter_test/flutter_test.dart';
import 'package:monapp/layers/functional/Catalogue/data/models/catalogue_anime_dto.dart';

const payload = {
  'mal_id': 1,
  'title': 'Cowboy Bebop',
  'studios': [
    {'name': 'Sunrise'},
  ],
  'year': 1998,
  'episodes': 26,
};

void main() {
  test('it reads the fields Jikan returns for an anime', () {
    final anime = CatalogueAnimeDto.fromJson(payload);

    expect(anime.malId, 1);
    expect(anime.title, 'Cowboy Bebop');
    expect(anime.studio, 'Sunrise');
    expect(anime.year, 1998);
    expect(anime.episodeCount, 26);
  });

  test('an anime without studio falls back to an unknown one', () {
    final anime = CatalogueAnimeDto.fromJson({...payload, 'studios': []});

    expect(anime.studio, CatalogueAnimeDto.unknownStudio);
  });

  test('a running anime without year nor episode count stays readable', () {
    final anime = CatalogueAnimeDto.fromJson(
      {...payload, 'year': null, 'episodes': null},
    );

    expect(anime.year, 0);
    expect(anime.episodeCount, 0);
  });
}
