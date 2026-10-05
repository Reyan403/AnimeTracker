import 'package:equatable/equatable.dart';

import '../../domain/entities/evening_mood.dart';
import '../../domain/entities/evening_suggestion.dart';

enum EveningStatus { idle, loading, suggested, none, failure }

class EveningState extends Equatable {
  const EveningState({
    this.status = EveningStatus.idle,
    this.mood = EveningMood.any,
    this.suggestion,
    this.shownIds = const {},
  });

  final EveningStatus status;
  final EveningMood mood;
  final EveningSuggestion? suggestion;
  final Set<int> shownIds;

  @override
  List<Object?> get props => [status, mood, suggestion, shownIds];
}
