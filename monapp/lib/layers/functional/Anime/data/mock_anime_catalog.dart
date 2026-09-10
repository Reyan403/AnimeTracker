import '../domain/entities/anime.dart';
import '../domain/entities/watch_status.dart';

abstract final class MockAnimeCatalog {
  static const List<Anime> watchlist = [
    Anime(
      title: 'Frieren : Au-delà du voyage',
      originalTitle: 'Sousou no Frieren',
      studio: 'Madhouse',
      year: 2023,
      episodeCount: 28,
      status: WatchStatus.watching,
    ),
    Anime(
      title: 'Vinland Saga',
      originalTitle: 'Vinland Saga',
      studio: 'Wit Studio',
      year: 2019,
      episodeCount: 24,
      status: WatchStatus.watching,
    ),
    Anime(
      title: 'Dungeon Meshi',
      originalTitle: 'Delicious in Dungeon',
      studio: 'Trigger',
      year: 2024,
      episodeCount: 24,
      status: WatchStatus.watching,
    ),
    Anime(
      title: 'Cowboy Bebop',
      originalTitle: 'Cowboy Bebop',
      studio: 'Sunrise',
      year: 1998,
      episodeCount: 26,
      status: WatchStatus.toWatch,
    ),
    Anime(
      title: 'Mob Psycho 100',
      originalTitle: 'Mob Psycho 100',
      studio: 'Bones',
      year: 2016,
      episodeCount: 37,
      status: WatchStatus.toWatch,
    ),
    Anime(
      title: 'Spy x Family',
      originalTitle: 'Spy x Family',
      studio: 'Wit Studio',
      year: 2022,
      episodeCount: 25,
      status: WatchStatus.toWatch,
    ),
    Anime(
      title: 'Fullmetal Alchemist: Brotherhood',
      originalTitle: 'Hagane no Renkinjutsushi',
      studio: 'Bones',
      year: 2009,
      episodeCount: 64,
      status: WatchStatus.completed,
    ),
    Anime(
      title: "L'Attaque des Titans",
      originalTitle: 'Shingeki no Kyojin',
      studio: 'Wit Studio',
      year: 2013,
      episodeCount: 87,
      status: WatchStatus.completed,
    ),
    Anime(
      title: 'Jujutsu Kaisen',
      originalTitle: 'Jujutsu Kaisen',
      studio: 'MAPPA',
      year: 2020,
      episodeCount: 47,
      status: WatchStatus.completed,
    ),
    Anime(
      title: 'Death Note',
      originalTitle: 'Death Note',
      studio: 'Madhouse',
      year: 2006,
      episodeCount: 37,
      status: WatchStatus.completed,
    ),
  ];
}
