import '../../../Anime/domain/entities/anime.dart';
import '../entities/constellation_link.dart';

class ConstellationLinksBuilder {
  const ConstellationLinksBuilder._();

  static const int maxLinksPerStar = 3;

  static List<ConstellationLink> build(List<Anime> animes) {
    final slugs = {
      for (final anime in animes)
        anime.id: {
          for (final genre in anime.details?.genres ?? const []) genre.slug,
        },
    };
    final ids = slugs.keys.toList()..sort();
    final candidates = <ConstellationLink>[];

    for (var i = 0; i < ids.length; i++) {
      for (var j = i + 1; j < ids.length; j++) {
        final shared = slugs[ids[i]]!.intersection(slugs[ids[j]]!).length;

        if (shared > 0) {
          candidates.add(
            ConstellationLink(
              fromId: ids[i],
              toId: ids[j],
              sharedGenres: shared,
            ),
          );
        }
      }
    }

    candidates.sort(_byStrength);

    final degrees = <int, int>{};
    final kept = <ConstellationLink>[];

    for (final link in candidates) {
      final from = degrees[link.fromId] ?? 0;
      final to = degrees[link.toId] ?? 0;

      if (from < maxLinksPerStar && to < maxLinksPerStar) {
        kept.add(link);
        degrees[link.fromId] = from + 1;
        degrees[link.toId] = to + 1;
      }
    }

    kept.sort(_byIds);

    return kept;
  }

  static int _byStrength(ConstellationLink a, ConstellationLink b) {
    final byShared = b.sharedGenres.compareTo(a.sharedGenres);

    if (byShared != 0) {
      return byShared;
    }

    final byMix = _mix(a).compareTo(_mix(b));

    return byMix != 0 ? byMix : _byIds(a, b);
  }

  static int _mix(ConstellationLink link) =>
      (link.fromId * 7919 + link.toId * 104729) % 1009;

  static int _byIds(ConstellationLink a, ConstellationLink b) {
    final byFrom = a.fromId.compareTo(b.fromId);

    return byFrom != 0 ? byFrom : a.toId.compareTo(b.toId);
  }
}
