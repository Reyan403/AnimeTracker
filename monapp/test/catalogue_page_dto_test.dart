import 'package:flutter_test/flutter_test.dart';
import 'package:monapp/layers/functional/Catalogue/data/models/catalogue_page_dto.dart';

const anime = {
  'mal_id': 1,
  'title': 'Cowboy Bebop',
  'studios': [
    {'name': 'Sunrise'},
  ],
  'year': 1998,
  'episodes': 26,
};

const payload = {
  'pagination': {'has_next_page': true, 'current_page': 1},
  'data': [anime],
};

void main() {
  test('it reads the animes of the page', () {
    final page = CataloguePageDto.fromJson(payload);

    expect(page.animes.single.title, 'Cowboy Bebop');
  });

  test('it keeps the announcement of a following page', () {
    expect(CataloguePageDto.fromJson(payload).hasMore, isTrue);
  });

  test('the last page announces nothing more', () {
    final page = CataloguePageDto.fromJson({
      ...payload,
      'pagination': const {'has_next_page': false},
    });

    expect(page.hasMore, isFalse);
  });

  test('a payload without pagination stops the browsing', () {
    final page = CataloguePageDto.fromJson(const {
      'data': [anime],
    });

    expect(page.hasMore, isFalse);
  });
}
