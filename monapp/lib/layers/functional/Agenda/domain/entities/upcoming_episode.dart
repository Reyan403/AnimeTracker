import 'package:equatable/equatable.dart';

class UpcomingEpisode extends Equatable {
  const UpcomingEpisode({
    required this.title,
    required this.episode,
    required this.airingAt,
    this.malId,
    this.coverUrl,
  });

  final String title;
  final int episode;
  final DateTime airingAt;
  final int? malId;
  final String? coverUrl;

  @override
  List<Object?> get props => [title, episode, airingAt, malId, coverUrl];
}
