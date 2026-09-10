import 'package:equatable/equatable.dart';

import '../../domain/entities/anime.dart';
import '../../domain/entities/watch_status.dart';

enum ViewStatus { loading, success, empty, failure }

class WatchlistState extends Equatable {
  const WatchlistState({
    this.status = ViewStatus.loading,
    this.animes = const [],
    this.selected = WatchStatus.watching,
  });

  final ViewStatus status;
  final List<Anime> animes;
  final WatchStatus selected;

  List<Anime> get visibleAnimes =>
      animes.where((anime) => anime.status == selected).toList();

  int countOf(WatchStatus status) =>
      animes.where((anime) => anime.status == status).length;

  WatchlistState copyWith({
    ViewStatus? status,
    List<Anime>? animes,
    WatchStatus? selected,
  }) =>
      WatchlistState(
        status: status ?? this.status,
        animes: animes ?? this.animes,
        selected: selected ?? this.selected,
      );

  @override
  List<Object?> get props => [status, animes, selected];
}
