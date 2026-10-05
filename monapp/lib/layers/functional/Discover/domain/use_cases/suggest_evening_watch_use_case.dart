import 'dart:math';

import '../../../Anime/domain/entities/anime.dart';
import '../../../Anime/domain/entities/watch_status.dart';
import '../../../Anime/domain/use_cases/load_watchlist_use_case.dart';
import '../entities/evening_mood.dart';
import '../entities/evening_suggestion.dart';

class EveningSuggestionUnavailableException implements Exception {
  const EveningSuggestionUnavailableException();

  @override
  String toString() => 'The evening suggestion is unavailable';
}

class SuggestEveningWatchUseCase {
  SuggestEveningWatchUseCase(this._loadWatchlist, {Random? random})
      : _random = random ?? Random();

  static const int continuingWeight = 2;

  final LoadWatchlistUseCase _loadWatchlist;
  final Random _random;

  Future<EveningSuggestion?> call({
    required EveningMood mood,
    Set<int> excludedIds = const {},
  }) async {
    final animes = await _loadWatchlist()
        .firstWhere((list) => list.every((anime) => !anime.isLoadingDetails));

    if (animes.isNotEmpty && animes.every((anime) => anime.details == null)) {
      throw const EveningSuggestionUnavailableException();
    }

    final candidates = [
      for (final anime in animes)
        if (_fits(anime, mood) && !excludedIds.contains(anime.id))
          anime,
    ];

    if (candidates.isEmpty) {
      return null;
    }

    final picked = _pickWeighted(candidates);

    return EveningSuggestion(
      anime: picked,
      matchedGenres: [
        for (final genre in picked.details!.genres)
          if (mood.genreSlugs.contains(genre.slug)) genre,
      ],
      isContinuing: picked.status == WatchStatus.watching,
    );
  }

  static bool _fits(Anime anime, EveningMood mood) {
    final details = anime.details;

    if (details == null ||
        anime.status == WatchStatus.completed ||
        anime.isFinished) {
      return false;
    }

    return mood.genreSlugs.isEmpty || mood.genreSlugs.any(details.hasGenre);
  }

  Anime _pickWeighted(List<Anime> candidates) {
    final weights = [
      for (final anime in candidates)
        anime.status == WatchStatus.watching ? continuingWeight : 1,
    ];
    var ticket = _random.nextInt(weights.reduce((a, b) => a + b));

    for (var index = 0; index < candidates.length; index++) {
      ticket -= weights[index];

      if (ticket < 0) {
        return candidates[index];
      }
    }

    return candidates.last;
  }
}
