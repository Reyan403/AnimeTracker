import '../../../Anime/domain/entities/anime.dart';
import '../../../Anime/domain/entities/watch_status.dart';
import '../../../Anime/domain/use_cases/load_watchlist_use_case.dart';
import '../entities/scheduled_release.dart';
import '../entities/upcoming_episode.dart';
import '../gateways/release_schedule_gateway.dart';

class ReleaseAgendaUnavailableException implements Exception {
  const ReleaseAgendaUnavailableException();

  @override
  String toString() => 'The release agenda is unavailable';
}

class LoadReleaseAgendaUseCase {
  LoadReleaseAgendaUseCase(
    this._loadWatchlist,
    this._schedule, {
    DateTime Function()? clock,
  }) : _clock = clock ?? DateTime.now;

  static const Duration staleAfter = Duration(days: 14);
  static const Duration horizon = Duration(days: 21);
  static const Duration grace = Duration(hours: 6);

  final LoadWatchlistUseCase _loadWatchlist;
  final ReleaseScheduleGateway _schedule;
  final DateTime Function() _clock;

  Future<List<UpcomingEpisode>>? _popular;

  Stream<List<ScheduledRelease>> call() => _loadWatchlist()
      .where((animes) => animes.every((anime) => !anime.isLoadingDetails))
      .asyncMap(_agendaOf);

  Future<List<ScheduledRelease>> _agendaOf(List<Anime> animes) async {
    if (animes.isNotEmpty && animes.every((anime) => anime.details == null)) {
      throw const ReleaseAgendaUnavailableException();
    }

    final now = _clock();
    final tracked = [
      for (final anime in animes)
        if (anime.status != WatchStatus.completed) anime,
    ];
    final byMalId = {
      for (final anime in tracked) ?anime.details?.malId: anime,
    };
    final listedMalIds = {
      for (final anime in animes) ?anime.details?.malId,
    };
    final upcoming = await _tryFind(
      () => _schedule.findForMalIds(byMalId.keys.toList()),
    );
    final popular = await _popularAiring();
    final covered = <int>{};
    final releases = <ScheduledRelease>[];

    for (final episode in upcoming) {
      final anime = byMalId[episode.malId];

      if (anime == null || !_isWithin(episode.airingAt, now)) {
        continue;
      }

      covered.add(anime.id);
      releases.add(
        ScheduledRelease(
          animeId: anime.id,
          title: anime.title,
          releaseAt: episode.airingAt,
          episode: episode.episode,
          posterUrl: anime.details?.posterUrl ?? episode.coverUrl,
        ),
      );
    }

    releases
      ..addAll(_fromKitsu(tracked, covered, now))
      ..addAll(_fromPopular(popular, listedMalIds, now));

    return releases..sort((a, b) => a.releaseAt.compareTo(b.releaseAt));
  }

  List<ScheduledRelease> _fromKitsu(
    List<Anime> tracked,
    Set<int> covered,
    DateTime now,
  ) {
    final oldest = now.subtract(staleAfter);

    final releases = <ScheduledRelease>[];

    for (final anime in tracked) {
      final releaseAt = anime.details?.nextRelease;

      if (covered.contains(anime.id) ||
          releaseAt == null ||
          releaseAt.isBefore(oldest)) {
        continue;
      }

      releases.add(
        ScheduledRelease(
          animeId: anime.id,
          title: anime.title,
          releaseAt: releaseAt,
          posterUrl: anime.details?.posterUrl,
        ),
      );
    }

    return releases;
  }

  List<ScheduledRelease> _fromPopular(
    List<UpcomingEpisode> popular,
    Set<int> listedMalIds,
    DateTime now,
  ) =>
      [
        for (final episode in popular)
          if (!listedMalIds.contains(episode.malId) &&
              _isWithin(episode.airingAt, now))
            ScheduledRelease(
              title: episode.title,
              releaseAt: episode.airingAt,
              episode: episode.episode,
              posterUrl: episode.coverUrl,
            ),
      ];

  bool _isWithin(DateTime airingAt, DateTime now) =>
      airingAt.isAfter(now.subtract(grace)) &&
      airingAt.isBefore(now.add(horizon));

  Future<List<UpcomingEpisode>> _popularAiring() async {
    final pending = _popular ??= _tryFind(_schedule.findPopularAiring);
    final found = await pending;

    if (found.isEmpty) {
      _popular = null;
    }

    return found;
  }

  static Future<List<UpcomingEpisode>> _tryFind(
    Future<List<UpcomingEpisode>> Function() find,
  ) async {
    try {
      return await find();
    } on ReleaseScheduleUnavailableException {
      return const [];
    }
  }
}
