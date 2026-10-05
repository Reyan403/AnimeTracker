import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/entities/watch_stats.dart';
import '../../domain/use_cases/compute_watch_stats_use_case.dart';
import 'stats_state.dart';

class StatsCubit extends Cubit<StatsState> {
  StatsCubit(this._computeStats) : super(const StatsState());

  final ComputeWatchStatsUseCase _computeStats;

  StreamSubscription<WatchStats>? _computing;

  Future<void> load() async {
    unawaited(_computing?.cancel());
    emit(const StatsState());

    _computing = _computeStats().listen(
      _show,
      onError: (_) => emit(const StatsState(status: StatsStatus.failure)),
    );
  }

  @override
  Future<void> close() async {
    unawaited(_computing?.cancel());

    return super.close();
  }

  void _show(WatchStats stats) {
    if (isClosed) {
      return;
    }

    emit(
      StatsState(
        status: stats.isEmpty ? StatsStatus.empty : StatsStatus.success,
        stats: stats,
      ),
    );
  }
}
