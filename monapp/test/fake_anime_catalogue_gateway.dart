import 'dart:math';

import 'package:monapp/layers/functional/Catalogue/domain/entities/catalogue_anime.dart';
import 'package:monapp/layers/functional/Catalogue/domain/entities/catalogue_page.dart';
import 'package:monapp/layers/functional/Catalogue/domain/gateways/anime_catalogue_gateway.dart';

class FakeAnimeCatalogueGateway implements AnimeCatalogueGateway {
  FakeAnimeCatalogueGateway({
    this.mostPopular = const [],
    this.resultsByQuery = const {},
    this.pageSize = 25,
    this.isDown = false,
    this.failingPage,
    this.repeatsPages = false,
    this.crashingPage,
  });

  final List<CatalogueAnime> mostPopular;
  final Map<String, List<CatalogueAnime>> resultsByQuery;
  final int pageSize;
  final bool isDown;
  final int? failingPage;
  final bool repeatsPages;
  final int? crashingPage;
  final List<String> receivedQueries = [];
  final List<int> receivedPages = [];

  @override
  Future<CataloguePage> findMostPopular(int page) async =>
      _pageOf(mostPopular, '', page);

  @override
  Future<CataloguePage> search(String query, int page) async =>
      _pageOf(resultsByQuery[query] ?? const [], query, page);

  CataloguePage _pageOf(List<CatalogueAnime> animes, String query, int page) {
    receivedQueries.add(query);
    receivedPages.add(page);

    if (page == crashingPage) {
      throw StateError('the service answered something unexpected');
    }

    if (isDown || page == failingPage) {
      throw const CatalogueUnavailableException();
    }

    final start = repeatsPages ? 0 : (page - 1) * pageSize;

    if (start >= animes.length) {
      return CataloguePage.last;
    }

    final end = min(start + pageSize, animes.length);

    return CataloguePage(
      animes: animes.sublist(start, end),
      hasMore: end < animes.length,
    );
  }
}
