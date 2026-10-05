import 'package:monapp/layers/functional/Anime/domain/entities/anime_details.dart';
import 'package:monapp/layers/functional/Anime/domain/gateways/anime_details_gateway.dart';

class FakeDetailsGateway implements AnimeDetailsGateway {
  FakeDetailsGateway(this.details, {this.fails = false});

  final Map<int, AnimeDetails> details;
  bool fails;
  int calls = 0;

  @override
  Future<Map<int, AnimeDetails>> findAllByIds(List<int> ids) async {
    calls++;

    if (fails) {
      throw const AnimeDetailsUnavailableException();
    }

    return {
      for (final id in ids)
        if (details.containsKey(id)) id: details[id]!,
    };
  }
}
