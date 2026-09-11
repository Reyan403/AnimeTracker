import 'package:equatable/equatable.dart';

import '../../domain/entities/catalogue_anime.dart';
import '../../domain/use_cases/browse_catalogue_use_case.dart';

enum CatalogueStatus { loading, success, empty, failure }

class CatalogueState extends Equatable {
  const CatalogueState({
    this.status = CatalogueStatus.loading,
    this.animes = const [],
    this.query = '',
    this.page = BrowseCatalogueUseCase.firstPage,
    this.hasMore = false,
    this.isAppending = false,
    this.listedIds = const {},
  });

  final CatalogueStatus status;
  final List<CatalogueAnime> animes;
  final String query;
  final int page;
  final bool hasMore;
  final bool isAppending;
  final Set<int> listedIds;

  bool get isSearching => query.trim().isNotEmpty;

  bool isListed(CatalogueAnime anime) => listedIds.contains(anime.id);

  CatalogueState copyWith({
    CatalogueStatus? status,
    List<CatalogueAnime>? animes,
    String? query,
    int? page,
    bool? hasMore,
    bool? isAppending,
    Set<int>? listedIds,
  }) =>
      CatalogueState(
        status: status ?? this.status,
        animes: animes ?? this.animes,
        query: query ?? this.query,
        page: page ?? this.page,
        hasMore: hasMore ?? this.hasMore,
        isAppending: isAppending ?? this.isAppending,
        listedIds: listedIds ?? this.listedIds,
      );

  @override
  List<Object?> get props =>
      [status, animes, query, page, hasMore, isAppending, listedIds];
}
