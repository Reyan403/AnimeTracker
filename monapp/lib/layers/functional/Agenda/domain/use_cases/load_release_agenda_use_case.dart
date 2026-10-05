import '../../../Anime/domain/entities/anime.dart';
import '../../../Anime/domain/entities/watch_status.dart';
import '../../../Anime/domain/use_cases/load_watchlist_use_case.dart';
import '../entities/scheduled_release.dart';

class ReleaseAgendaUnavailableException implements Exception {
  const ReleaseAgendaUnavailableException();

  @override
  String toString() => 'The release agenda is unavailable';
}

class LoadReleaseAgendaUseCase {
  const LoadReleaseAgendaUseCase(
    this._loadWatchlist, {
    DateTime Function()? clock,
  }) : _clock = clock ?? DateTime.now;

  static const Duration staleAfter = Duration(days: 14);

  final LoadWatchlistUseCase _loadWatchlist;
  final DateTime Function() _clock;

  Stream<List<ScheduledRelease>> call() => _loadWatchlist()
      .where((animes) => animes.every((anime) => !anime.isLoadingDetails))
      .map(_agendaOf);

  List<ScheduledRelease> _agendaOf(List<Anime> animes) {
    if (animes.isNotEmpty && animes.every((anime) => anime.details == null)) {
      throw const ReleaseAgendaUnavailableException();
    }

    final oldest = _clock().subtract(staleAfter);
    final releases = <ScheduledRelease>[];

    for (final anime in animes) {
      final releaseAt = anime.details?.nextRelease;

      if (anime.status == WatchStatus.completed ||
          releaseAt == null ||
          releaseAt.isBefore(oldest)) {
        continue;
      }

      releases.add(
        ScheduledRelease(
          animeId: anime.id,
          title: anime.title,
          releaseAt: releaseAt,
          nextEpisodeToWatch: anime.episodesWatched + 1,
          posterUrl: anime.details?.posterUrl,
        ),
      );
    }

    return releases..sort((a, b) => a.releaseAt.compareTo(b.releaseAt));
  }
}
