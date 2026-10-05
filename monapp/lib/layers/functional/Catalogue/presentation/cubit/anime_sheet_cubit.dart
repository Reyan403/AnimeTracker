import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../Anime/domain/entities/watch_status.dart';
import '../../../Anime/domain/use_cases/find_watch_status_use_case.dart';
import '../../../Settings/domain/use_cases/read_spoiler_guard_use_case.dart';
import '../../domain/use_cases/load_anime_sheet_use_case.dart';
import 'anime_sheet_state.dart';

class AnimeSheetCubit extends Cubit<AnimeSheetState> {
  AnimeSheetCubit(
    this._loadSheet,
    this._findWatchStatus,
    this._readSpoilerGuard,
  ) : super(const AnimeSheetState());

  final LoadAnimeSheetUseCase _loadSheet;
  final FindWatchStatusUseCase _findWatchStatus;
  final ReadSpoilerGuardUseCase _readSpoilerGuard;

  bool _isRevealed = false;

  Future<void> load(int id) async {
    _isRevealed = false;
    emit(const AnimeSheetState());

    try {
      await for (final sheet in _loadSheet(id)) {
        if (isClosed) {
          return;
        }

        emit(
          AnimeSheetState(
            status: AnimeSheetStatus.success,
            sheet: sheet,
            isSynopsisHidden: !_isRevealed && _shouldHideSynopsis(id),
          ),
        );
      }
    } catch (_) {
      if (!isClosed && state.sheet == null) {
        emit(const AnimeSheetState(status: AnimeSheetStatus.failure));
      }
    }
  }

  void revealSynopsis() {
    _isRevealed = true;
    emit(AnimeSheetState(status: state.status, sheet: state.sheet));
  }

  bool _shouldHideSynopsis(int id) =>
      _readSpoilerGuard() && _findWatchStatus(id) != WatchStatus.completed;
}
