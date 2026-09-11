import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/use_cases/load_anime_sheet_use_case.dart';
import 'anime_sheet_state.dart';

class AnimeSheetCubit extends Cubit<AnimeSheetState> {
  AnimeSheetCubit(this._loadSheet) : super(const AnimeSheetState());

  final LoadAnimeSheetUseCase _loadSheet;

  Future<void> load(int id) async {
    emit(const AnimeSheetState());

    try {
      final sheet = await _loadSheet(id);

      if (isClosed) {
        return;
      }

      emit(AnimeSheetState(status: AnimeSheetStatus.success, sheet: sheet));
    } catch (_) {
      if (isClosed) {
        return;
      }

      emit(const AnimeSheetState(status: AnimeSheetStatus.failure));
    }
  }
}
