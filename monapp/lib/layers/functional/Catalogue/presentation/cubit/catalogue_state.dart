import 'package:equatable/equatable.dart';

import '../../domain/entities/catalogue_anime.dart';

enum CatalogueStatus { loading, success, empty, failure }

class CatalogueState extends Equatable {
  const CatalogueState({
    this.status = CatalogueStatus.loading,
    this.animes = const [],
    this.query = '',
  });

  final CatalogueStatus status;
  final List<CatalogueAnime> animes;
  final String query;

  bool get isSearching => query.trim().isNotEmpty;

  CatalogueState copyWith({
    CatalogueStatus? status,
    List<CatalogueAnime>? animes,
    String? query,
  }) =>
      CatalogueState(
        status: status ?? this.status,
        animes: animes ?? this.animes,
        query: query ?? this.query,
      );

  @override
  List<Object?> get props => [status, animes, query];
}
