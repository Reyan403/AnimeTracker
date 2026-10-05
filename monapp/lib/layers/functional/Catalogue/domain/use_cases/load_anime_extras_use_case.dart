import '../entities/anime_extras.dart';
import '../gateways/anime_extras_gateway.dart';

class LoadAnimeExtrasUseCase {
  LoadAnimeExtrasUseCase(this._gateway);

  final AnimeExtrasGateway _gateway;

  final Map<int, AnimeExtras> _loaded = {};

  Future<AnimeExtras> call(int animeId) async {
    final known = _loaded[animeId];

    if (known != null) {
      return known;
    }

    final links = _safely(() => _gateway.findStreamingLinks(animeId));
    final related = _safely(() => _gateway.findRelated(animeId));
    final extras = AnimeExtras(
      streamingLinks: await links,
      related: await related,
    );

    if (!extras.isEmpty) {
      _loaded[animeId] = extras;
    }

    return extras;
  }

  static Future<List<T>> _safely<T>(Future<List<T>> Function() load) async {
    try {
      return await load();
    } on AnimeExtrasUnavailableException {
      return const [];
    }
  }
}
