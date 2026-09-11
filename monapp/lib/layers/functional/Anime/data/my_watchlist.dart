import '../domain/entities/watch_status.dart';
import '../domain/entities/watchlist_entry.dart';

abstract final class MyWatchlist {
  static const List<WatchlistEntry> entries = [
    WatchlistEntry(
      id: 46474,
      title: 'Frieren : Au-delà du voyage',
      status: WatchStatus.watching,
    ),
    WatchlistEntry(
      id: 41084,
      title: 'Vinland Saga',
      status: WatchStatus.watching,
    ),
    WatchlistEntry(
      id: 46320,
      title: 'Dungeon Meshi',
      status: WatchStatus.watching,
    ),
    WatchlistEntry(
      id: 1,
      title: 'Cowboy Bebop',
      status: WatchStatus.toWatch,
    ),
    WatchlistEntry(
      id: 11578,
      title: 'Mob Psycho 100',
      status: WatchStatus.toWatch,
    ),
    WatchlistEntry(
      id: 45398,
      title: 'Spy x Family',
      status: WatchStatus.toWatch,
    ),
    WatchlistEntry(
      id: 3936,
      title: 'Fullmetal Alchemist: Brotherhood',
      status: WatchStatus.completed,
    ),
    WatchlistEntry(
      id: 7442,
      title: "L'Attaque des Titans",
      status: WatchStatus.completed,
    ),
    WatchlistEntry(
      id: 42765,
      title: 'Jujutsu Kaisen',
      status: WatchStatus.completed,
    ),
    WatchlistEntry(
      id: 1376,
      title: 'Death Note',
      status: WatchStatus.completed,
    ),
  ];
}
