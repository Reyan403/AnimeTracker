import 'package:equatable/equatable.dart';

import '../../domain/entities/scheduled_release.dart';

enum AgendaStatus { loading, success, empty, failure }

class AgendaState extends Equatable {
  const AgendaState({
    this.status = AgendaStatus.loading,
    this.releases = const [],
    this.onlyWatchlist = false,
  });

  final AgendaStatus status;
  final List<ScheduledRelease> releases;
  final bool onlyWatchlist;

  List<ScheduledRelease> get visibleReleases => onlyWatchlist
      ? [
          for (final release in releases)
            if (release.isInWatchlist) release,
        ]
      : releases;

  AgendaState copyWith({
    AgendaStatus? status,
    List<ScheduledRelease>? releases,
    bool? onlyWatchlist,
  }) =>
      AgendaState(
        status: status ?? this.status,
        releases: releases ?? this.releases,
        onlyWatchlist: onlyWatchlist ?? this.onlyWatchlist,
      );

  @override
  List<Object?> get props => [status, releases, onlyWatchlist];
}
