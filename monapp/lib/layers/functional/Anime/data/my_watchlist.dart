import '../domain/entities/watch_status.dart';
import '../domain/entities/watchlist_entry.dart';

abstract final class MyWatchlist {
  static const List<WatchlistEntry> entries = [
    WatchlistEntry(
      malId: 52991,
      title: 'Frieren : Au-delà du voyage',
      status: WatchStatus.watching,
    ),
    WatchlistEntry(
      malId: 37521,
      title: 'Vinland Saga',
      status: WatchStatus.watching,
    ),
    WatchlistEntry(
      malId: 52701,
      title: 'Dungeon Meshi',
      status: WatchStatus.watching,
    ),
    WatchlistEntry(
      malId: 1,
      title: 'Cowboy Bebop',
      status: WatchStatus.toWatch,
    ),
    WatchlistEntry(
      malId: 32182,
      title: 'Mob Psycho 100',
      status: WatchStatus.toWatch,
    ),
    WatchlistEntry(
      malId: 50265,
      title: 'Spy x Family',
      status: WatchStatus.toWatch,
    ),
    WatchlistEntry(
      malId: 5114,
      title: 'Fullmetal Alchemist: Brotherhood',
      status: WatchStatus.completed,
    ),
    WatchlistEntry(
      malId: 16498,
      title: "L'Attaque des Titans",
      status: WatchStatus.completed,
    ),
    WatchlistEntry(
      malId: 40748,
      title: 'Jujutsu Kaisen',
      status: WatchStatus.completed,
    ),
    WatchlistEntry(
      malId: 1535,
      title: 'Death Note',
      status: WatchStatus.completed,
    ),
  ];
}
