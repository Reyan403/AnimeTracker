abstract final class FrenchSynopsisDto {
  static const Set<String> _watchableMedia = {'tv', 'movie'};

  static String? fromJson(Map<String, dynamic> json) {
    final results = json['results'] as List<dynamic>? ?? const [];

    for (final result in results) {
      final synopsis = _synopsisOf(result as Map<String, dynamic>);

      if (synopsis != null) {
        return synopsis;
      }
    }

    return null;
  }

  static String? _synopsisOf(Map<String, dynamic> result) {
    final media = result['media_type'] as String?;

    if (media != null && !_watchableMedia.contains(media)) {
      return null;
    }

    final overview = result['overview'] as String?;

    return overview == null || overview.isEmpty ? null : overview;
  }
}
