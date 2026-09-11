import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/gateways/anime_sheet_gateway.dart';
import 'anime_sheet_state.dart';

class AnimeSheetCubit extends Cubit<AnimeSheetState> {
  AnimeSheetCubit(this._gateway) : super(const AnimeSheetState());

  final AnimeSheetGateway _gateway;

  Future<void> load(int id) async {
    emit(const AnimeSheetState());

    try {
      final sheet = await _gateway.findById(id);

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
