import 'package:equatable/equatable.dart';

import '../../domain/entities/scheduled_release.dart';

enum AgendaStatus { loading, success, empty, failure }

class AgendaState extends Equatable {
  const AgendaState({
    this.status = AgendaStatus.loading,
    this.releases = const [],
  });

  final AgendaStatus status;
  final List<ScheduledRelease> releases;

  @override
  List<Object?> get props => [status, releases];
}
