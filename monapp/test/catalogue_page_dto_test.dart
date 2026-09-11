import 'package:flutter_test/flutter_test.dart';
import 'package:monapp/layers/functional/Catalogue/data/models/catalogue_page_dto.dart';

const anime = {
  'id': '7442',
  'attributes': {
    'canonicalTitle': 'Naruto: Shippuuden',
    'subtype': 'TV',
    'startDate': '2007-02-15',
    'episodeCount': 500,
  },
};

const payload = {
  'data': [anime],
  'links': {'next': 'https://kitsu.app/api/edge/anime?page%5Boffset%5D=25'},
};

void main() {
  test('it reads the animes of the page', () {
    final page = CataloguePageDto.fromJson(payload);

    expect(page.animes.single.title, 'Naruto: Shippuuden');
  });

  test('a link to the next page keeps the browsing open', () {
    expect(CataloguePageDto.fromJson(payload).hasMore, isTrue);
  });

  test('the last page has no link to follow', () {
    final page = CataloguePageDto.fromJson(const {
      'data': [anime],
      'links': {'first': 'https://kitsu.app/api/edge/anime'},
    });

    expect(page.hasMore, isFalse);
  });

  test('a payload without data comes back empty', () {
    expect(CataloguePageDto.fromJson(const {}).animes, isEmpty);
  });
}
