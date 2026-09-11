import 'package:flutter_test/flutter_test.dart';
import 'package:monapp/layers/functional/Catalogue/data/models/french_synopsis_dto.dart';

const frenchSynopsis = 'Gol D. Roger était connu comme le Roi des Pirates.';

void main() {
  test('it takes the synopsis of the first result', () {
    final synopsis = FrenchSynopsisDto.fromJson(const {
      'results': [
        {'media_type': 'tv', 'name': 'One Piece', 'overview': frenchSynopsis},
      ],
    });

    expect(synopsis, frenchSynopsis);
  });

  test('it skips a result TMDB has not translated', () {
    final synopsis = FrenchSynopsisDto.fromJson(const {
      'results': [
        {'media_type': 'tv', 'overview': ''},
        {'media_type': 'movie', 'overview': frenchSynopsis},
      ],
    });

    expect(synopsis, frenchSynopsis);
  });

  test('it ignores what is neither a series nor a film', () {
    final synopsis = FrenchSynopsisDto.fromJson(const {
      'results': [
        {'media_type': 'person', 'overview': 'Un dessinateur.'},
        {'media_type': 'tv', 'overview': frenchSynopsis},
      ],
    });

    expect(synopsis, frenchSynopsis);
  });

  test('a search without result gives nothing', () {
    expect(FrenchSynopsisDto.fromJson(const {'results': []}), isNull);
    expect(FrenchSynopsisDto.fromJson(const {}), isNull);
  });
}
