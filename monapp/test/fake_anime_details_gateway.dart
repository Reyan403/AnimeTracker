import 'package:monapp/layers/functional/Anime/domain/entities/anime_details.dart';
import 'package:monapp/layers/functional/Anime/domain/gateways/anime_details_gateway.dart';

class FakeAnimeDetailsGateway implements AnimeDetailsGateway {
  const FakeAnimeDetailsGateway(this.detailsById, {this.isDown = false});

  final Map<int, AnimeDetails> detailsById;
  final bool isDown;

  @override
  Future<Map<int, AnimeDetails>> findAllByIds(List<int> ids) async {
    if (isDown) {
      throw const AnimeDetailsUnavailableException();
    }

    return {
      for (final id in ids)
        if (detailsById[id] != null) id: detailsById[id]!,
    };
  }
}
