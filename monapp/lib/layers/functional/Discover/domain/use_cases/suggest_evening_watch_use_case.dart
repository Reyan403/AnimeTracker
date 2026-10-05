import 'dart:math';

import '../../../Anime/domain/entities/watch_status.dart';
import '../../../Anime/domain/use_cases/find_watch_status_use_case.dart';
import '../entities/evening_mood.dart';
import '../entities/evening_suggestion.dart';
import '../gateways/catalogue_suggestion_gateway.dart';

class SuggestEveningWatchUseCase {
  SuggestEveningWatchUseCase(
    this._catalogue,
    this._findWatchStatus, {
    Random? random,
  }) : _random = random ?? Random();

  static const int maxAttempts = 6;

  final CatalogueSuggestionGateway _catalogue;
  final FindWatchStatusUseCase _findWatchStatus;
  final Random _random;

  final Map<String?, int> _counts = {};

  Future<EveningSuggestion?> call({
    required EveningMood mood,
    Set<int> excludedIds = const {},
  }) async {
    final genre = _genreFor(mood);
    final count = await _countOf(genre);

    for (var attempt = 0; attempt < maxAttempts && count > 0; attempt++) {
      final found = await _catalogue.findAt(genre, _random.nextInt(count));
      final status = found == null ? null : _findWatchStatus(found.anime.id);

      if (found == null ||
          excludedIds.contains(found.anime.id) ||
          status == WatchStatus.completed) {
        continue;
      }

      return EveningSuggestion(
        anime: found.anime,
        genres: found.genres,
        isListed: status != null,
      );
    }

    return null;
  }

  String? _genreFor(EveningMood mood) {
    final slugs = mood.genreSlugs.toList();

    return slugs.isEmpty ? null : slugs[_random.nextInt(slugs.length)];
  }

  Future<int> _countOf(String? genre) async {
    final known = _counts[genre];

    if (known != null) {
      return known;
    }

    return _counts[genre] = await _catalogue.countMatching(genre);
  }
}
