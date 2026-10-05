import 'package:equatable/equatable.dart';

import '../../domain/entities/evening_duration.dart';
import '../../domain/entities/evening_mood.dart';
import '../../domain/entities/evening_suggestion.dart';

enum EveningStatus { idle, loading, suggested, none, failure }

class EveningState extends Equatable {
  const EveningState({
    this.status = EveningStatus.idle,
    this.mood = EveningMood.any,
    this.duration = EveningDuration.unlimited,
    this.suggestion,
    this.shownIds = const {},
  });

  final EveningStatus status;
  final EveningMood mood;
  final EveningDuration duration;
  final EveningSuggestion? suggestion;
  final Set<int> shownIds;

  EveningState copyWith({
    EveningStatus? status,
    EveningMood? mood,
    EveningDuration? duration,
    EveningSuggestion? suggestion,
    Set<int>? shownIds,
  }) =>
      EveningState(
        status: status ?? this.status,
        mood: mood ?? this.mood,
        duration: duration ?? this.duration,
        suggestion: suggestion ?? this.suggestion,
        shownIds: shownIds ?? this.shownIds,
      );

  @override
  List<Object?> get props => [status, mood, duration, suggestion, shownIds];
}
