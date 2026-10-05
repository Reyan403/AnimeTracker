import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/entities/anime.dart';
import '../../domain/entities/watch_status.dart';
import '../../domain/use_cases/change_watch_status_use_case.dart';
import '../../domain/use_cases/load_watchlist_use_case.dart';
import '../../domain/use_cases/watch_next_episode_use_case.dart';
import '../../domain/use_cases/watch_previous_episode_use_case.dart';
import 'watchlist_state.dart';

class WatchlistCubit extends Cubit<WatchlistState> {
  WatchlistCubit(
    this._loadWatchlist,
    this._changeWatchStatus,
    this._watchNextEpisode,
    this._watchPreviousEpisode,
  ) : super(const WatchlistState());

  final LoadWatchlistUseCase _loadWatchlist;
  final ChangeWatchStatusUseCase _changeWatchStatus;
  final WatchNextEpisodeUseCase _watchNextEpisode;
  final WatchPreviousEpisodeUseCase _watchPreviousEpisode;

  StreamSubscription<List<Anime>>? _loading;

  Future<void> load() async {
    await _loading?.cancel();
    emit(state.copyWith(status: ViewStatus.loading));

    _loading = _loadWatchlist().listen(
      _show,
      onError: (_) => emit(state.copyWith(status: ViewStatus.failure)),
    );
  }

  void changeStatus(int animeId, WatchStatus status) =>
      _changeWatchStatus(animeId, status);

  void watchNextEpisode(Anime anime) =>
      _watchNextEpisode(anime.id, totalEpisodes: anime.totalEpisodes);

  void watchPreviousEpisode(Anime anime) =>
      _watchPreviousEpisode(anime.id, totalEpisodes: anime.totalEpisodes);

  void selectStatus(WatchStatus status) => emit(
        state.copyWith(
          selected: status,
          status: _statusFor(state.animes, status),
        ),
      );

  @override
  Future<void> close() async {
    await _loading?.cancel();

    return super.close();
  }

  void _show(List<Anime> animes) {
    if (isClosed) {
      return;
    }

    emit(
      state.copyWith(
        animes: animes,
        status: _statusFor(animes, state.selected),
      ),
    );
  }

  static ViewStatus _statusFor(List<Anime> animes, WatchStatus selected) {
    if (animes.isNotEmpty &&
        animes.every((anime) => anime.details == null && !anime.isLoadingDetails)) {
      return ViewStatus.failure;
    }

    return animes.any((anime) => anime.status == selected)
        ? ViewStatus.success
        : ViewStatus.empty;
  }
}
