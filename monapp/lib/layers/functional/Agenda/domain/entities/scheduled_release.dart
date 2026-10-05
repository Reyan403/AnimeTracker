import 'package:equatable/equatable.dart';

class ScheduledRelease extends Equatable {
  const ScheduledRelease({
    required this.animeId,
    required this.title,
    required this.releaseAt,
    required this.nextEpisodeToWatch,
    this.posterUrl,
  });

  final int animeId;
  final String title;
  final DateTime releaseAt;
  final int nextEpisodeToWatch;
  final String? posterUrl;

  int daysUntil(DateTime now) {
    final today = DateTime(now.year, now.month, now.day);
    final day = releaseAt.toLocal();

    return DateTime(day.year, day.month, day.day).difference(today).inDays;
  }

  @override
  List<Object?> get props =>
      [animeId, title, releaseAt, nextEpisodeToWatch, posterUrl];
}
