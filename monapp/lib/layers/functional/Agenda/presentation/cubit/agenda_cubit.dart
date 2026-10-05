import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/entities/scheduled_release.dart';
import '../../domain/use_cases/load_release_agenda_use_case.dart';
import 'agenda_state.dart';

class AgendaCubit extends Cubit<AgendaState> {
  AgendaCubit(this._loadAgenda) : super(const AgendaState());

  final LoadReleaseAgendaUseCase _loadAgenda;

  StreamSubscription<List<ScheduledRelease>>? _loading;

  Future<void> load() async {
    unawaited(_loading?.cancel());
    emit(AgendaState(onlyWatchlist: state.onlyWatchlist));

    _loading = _loadAgenda().listen(
      _show,
      onError: (_) => emit(state.copyWith(status: AgendaStatus.failure)),
    );
  }

  void selectFilter({required bool onlyWatchlist}) =>
      emit(state.copyWith(onlyWatchlist: onlyWatchlist));

  @override
  Future<void> close() async {
    unawaited(_loading?.cancel());

    return super.close();
  }

  void _show(List<ScheduledRelease> releases) {
    if (isClosed) {
      return;
    }

    emit(
      state.copyWith(
        status: releases.isEmpty ? AgendaStatus.empty : AgendaStatus.success,
        releases: releases,
      ),
    );
  }
}
