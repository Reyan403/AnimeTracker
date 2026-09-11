import 'package:equatable/equatable.dart';

import 'catalogue_anime.dart';

class CataloguePage extends Equatable {
  const CataloguePage({required this.animes, required this.hasMore});

  static const CataloguePage last = CataloguePage(animes: [], hasMore: false);

  final List<CatalogueAnime> animes;
  final bool hasMore;

  @override
  List<Object?> get props => [animes, hasMore];
}
