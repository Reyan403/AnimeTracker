import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/entities/anime.dart';
import '../../domain/entities/watch_status.dart';
import '../../domain/entities/watchlist_entry.dart';
import '../../domain/use_cases/load_watchlist_use_case.dart';
import 'watchlist_state.dart';

class WatchlistCubit extends Cubit<WatchlistState> {
  WatchlistCubit(this._loadWatchlist, this._entries)
      : super(const WatchlistState());

  final LoadWatchlistUseCase _loadWatchlist;
  final List<WatchlistEntry> _entries;

  Future<void> load() async {
    emit(state.copyWith(status: ViewStatus.loading));

    try {
      final animes = await _loadWatchlist(_entries);
      emit(
        state.copyWith(
          animes: animes,
          status: _statusFor(animes, state.selected),
        ),
      );
    } catch (_) {
      emit(state.copyWith(status: ViewStatus.failure));
    }
  }

  void selectStatus(WatchStatus status) => emit(
        state.copyWith(
          selected: status,
          status: _statusFor(state.animes, status),
        ),
      );

  static ViewStatus _statusFor(List<Anime> animes, WatchStatus selected) {
    if (animes.isNotEmpty && animes.every((anime) => anime.details == null)) {
      return ViewStatus.failure;
    }

    return animes.any((anime) => anime.status == selected)
        ? ViewStatus.success
        : ViewStatus.empty;
  }
}
