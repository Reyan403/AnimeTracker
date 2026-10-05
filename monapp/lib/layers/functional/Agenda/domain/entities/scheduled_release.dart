import 'package:equatable/equatable.dart';

class ScheduledRelease extends Equatable {
  const ScheduledRelease({
    required this.title,
    required this.releaseAt,
    this.animeId,
    this.episode,
    this.posterUrl,
  });

  final String title;
  final DateTime releaseAt;
  final int? animeId;
  final int? episode;
  final String? posterUrl;

  bool get isInWatchlist => animeId != null;

  int daysUntil(DateTime now) {
    final today = DateTime(now.year, now.month, now.day);
    final day = releaseAt.toLocal();

    return DateTime(day.year, day.month, day.day).difference(today).inDays;
  }

  @override
  List<Object?> get props => [title, releaseAt, animeId, episode, posterUrl];
}
