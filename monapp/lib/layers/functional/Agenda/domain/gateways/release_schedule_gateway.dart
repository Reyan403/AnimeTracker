import '../entities/upcoming_episode.dart';

abstract interface class ReleaseScheduleGateway {
  Future<List<UpcomingEpisode>> findForMalIds(List<int> malIds);

  Future<List<UpcomingEpisode>> findPopularAiring();
}

class ReleaseScheduleUnavailableException implements Exception {
  const ReleaseScheduleUnavailableException();

  @override
  String toString() => 'The release schedule is unavailable';
}
