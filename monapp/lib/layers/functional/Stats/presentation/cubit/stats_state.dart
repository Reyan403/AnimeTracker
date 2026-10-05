import 'package:equatable/equatable.dart';

import '../../domain/entities/watch_stats.dart';

enum StatsStatus { loading, success, empty, failure }

class StatsState extends Equatable {
  const StatsState({this.status = StatsStatus.loading, this.stats});

  final StatsStatus status;
  final WatchStats? stats;

  @override
  List<Object?> get props => [status, stats];
}
