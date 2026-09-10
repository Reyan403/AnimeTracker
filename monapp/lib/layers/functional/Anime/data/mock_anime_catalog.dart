import '../domain/entities/anime.dart';
import '../domain/entities/watch_status.dart';

abstract final class MockAnimeCatalog {
  static const List<Anime> watchlist = [
    Anime(
      title: 'Fullmetal Alchemist: Brotherhood',
      status: WatchStatus.watching,
    ),
    Anime(title: 'Vinland Saga', status: WatchStatus.watching),
    Anime(title: 'Jujutsu Kaisen', status: WatchStatus.watching),
    Anime(title: 'Cowboy Bebop', status: WatchStatus.toWatch),
    Anime(title: 'Spy x Family', status: WatchStatus.toWatch),
    Anime(title: 'Mob Psycho 100', status: WatchStatus.toWatch),
    Anime(title: "L'Attaque des Titans", status: WatchStatus.completed),
    Anime(title: 'Death Note', status: WatchStatus.completed),
  ];
}
