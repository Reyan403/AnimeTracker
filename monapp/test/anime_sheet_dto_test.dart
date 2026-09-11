import 'package:flutter_test/flutter_test.dart';
import 'package:monapp/layers/functional/Catalogue/data/models/anime_sheet_dto.dart';

const attributes = {
  'canonicalTitle': 'One Piece',
  'subtype': 'TV',
  'synopsis': 'Gol D. Roger était connu comme le Roi des Pirates.',
  'status': 'current',
  'startDate': '1999-10-20',
  'endDate': null,
  'episodeCount': 1000,
  'episodeLength': 24,
  'totalLength': 33624,
  'averageRating': '84.0',
  'ratingRank': 58,
  'popularityRank': 14,
  'userCount': 324212,
  'favoritesCount': 10749,
  'ageRating': 'PG',
  'posterImage': {'small': 'https://media.kitsu.app/anime/12/small.jpg'},
  'coverImage': {'large': 'https://media.kitsu.app/anime/12/cover.jpg'},
};

const payload = {
  'data': {'id': '12', 'attributes': attributes},
};

Map<String, dynamic> payloadWith(Map<String, dynamic> changes) => {
      'data': {
        'id': '12',
        'attributes': {...attributes, ...changes},
      },
    };

void main() {
  test('it reads what identifies the anime', () {
    final sheet = AnimeSheetDto.fromJson(payload);

    expect(sheet.id, 12);
    expect(sheet.title, 'One Piece');
    expect(sheet.format, 'Série TV');
    expect(sheet.synopsis, startsWith('Gol D. Roger'));
  });

  test('it says the status and the age rating in French', () {
    final sheet = AnimeSheetDto.fromJson(payload);

    expect(sheet.status, 'En cours de diffusion');
    expect(sheet.ageRating, 'Déconseillé aux moins de 13 ans');
  });

  test('it keeps the years of broadcast', () {
    final sheet = AnimeSheetDto.fromJson(payload);

    expect(sheet.startYear, 1999);
    expect(sheet.endYear, isNull);
  });

  test('it rounds the average rating', () {
    expect(AnimeSheetDto.fromJson(payload).rating, 84);
    expect(
      AnimeSheetDto.fromJson(payloadWith({'averageRating': '77.6'})).rating,
      78,
    );
  });

  test('it keeps the counts and the ranks', () {
    final sheet = AnimeSheetDto.fromJson(payload);

    expect(sheet.episodeCount, 1000);
    expect(sheet.episodeMinutes, 24);
    expect(sheet.totalMinutes, 33624);
    expect(sheet.ratingRank, 58);
    expect(sheet.popularityRank, 14);
    expect(sheet.memberCount, 324212);
    expect(sheet.favoriteCount, 10749);
  });

  test('it keeps the poster and the cover', () {
    final sheet = AnimeSheetDto.fromJson(payload);

    expect(sheet.posterUrl, endsWith('small.jpg'));
    expect(sheet.coverUrl, endsWith('cover.jpg'));
  });

  test('a sheet without synopsis falls back on the description', () {
    final sheet = AnimeSheetDto.fromJson(
      payloadWith(const {'synopsis': '', 'description': 'Une description.'}),
    );

    expect(sheet.synopsis, 'Une description.');
  });

  test('what the API does not know stays empty', () {
    final sheet = AnimeSheetDto.fromJson(const {
      'data': {
        'id': '12',
        'attributes': {'canonicalTitle': 'One Piece'},
      },
    });

    expect(sheet.synopsis, isNull);
    expect(sheet.status, isNull);
    expect(sheet.rating, isNull);
    expect(sheet.episodeCount, isNull);
    expect(sheet.ageRating, isNull);
    expect(sheet.posterUrl, isNull);
  });
}
