import 'package:flutter_test/flutter_test.dart';
import 'package:monapp/layers/functional/Anime/data/gateways/local_watchlist_gateway.dart';
import 'package:monapp/layers/functional/Anime/data/models/watchlist_entry_dto.dart';
import 'package:monapp/layers/functional/Anime/data/stores/preferences_watchlist_store.dart';
import 'package:monapp/layers/functional/Anime/domain/entities/watch_status.dart';
import 'package:monapp/layers/functional/Anime/domain/entities/watchlist_entry.dart';
import 'package:monapp/layers/technical/Preferences/app_preferences.dart';
import 'package:monapp/layers/technical/Preferences/preferences_key.dart';
import 'package:shared_preferences_platform_interface/in_memory_shared_preferences_async.dart';
import 'package:shared_preferences_platform_interface/shared_preferences_async_platform_interface.dart';

import '../../../support/fake_watchlist_store.dart';

const seed = [
  WatchlistEntry(id: 1, title: 'Cowboy Bebop', status: WatchStatus.toWatch),
  WatchlistEntry(id: 2, title: 'Trigun', status: WatchStatus.watching),
];

void main() {
  group('WatchlistEntryDto', () {
    test('encode puis decode redonne les mêmes entrées', () {
      final decoded = WatchlistEntryDto.decode(WatchlistEntryDto.encode(seed))!;

      expect(decoded.map((entry) => entry.id), [1, 2]);
      expect(decoded.map((entry) => entry.title), ['Cowboy Bebop', 'Trigun']);
      expect(
        decoded.map((entry) => entry.status),
        [WatchStatus.toWatch, WatchStatus.watching],
      );
    });

    test('decode renvoie null sans données', () {
      expect(WatchlistEntryDto.decode(null), isNull);
    });

    test('decode renvoie null pour des données illisibles', () {
      expect(WatchlistEntryDto.decode('pas du json'), isNull);
      expect(WatchlistEntryDto.decode('{"a":1}'), isNull);
    });

    test('decode ignore une entrée au statut inconnu', () {
      final decoded = WatchlistEntryDto.decode(
        '[{"id":1,"title":"A","status":"inconnu"},'
        '{"id":2,"title":"B","status":"completed"}]',
      )!;

      expect(decoded.map((entry) => entry.id), [2]);
    });
  });

  group('LocalWatchlistGateway', () {
    test('utilise la liste de départ au premier lancement et l enregistre',
        () {
      final store = FakeWatchlistStore();
      final gateway = LocalWatchlistGateway(store, seed);

      expect(gateway.entries.length, 2);
      expect(store.saved?.length, 2);
    });

    test('recharge la liste enregistrée plutôt que celle de départ', () {
      final store = FakeWatchlistStore([seed.last]);
      final gateway = LocalWatchlistGateway(store, seed);

      expect(gateway.entries.map((entry) => entry.id), [2]);
      expect(store.writes, 0);
    });

    test('enregistre et diffuse un ajout', () async {
      final store = FakeWatchlistStore([]);
      final gateway = LocalWatchlistGateway(store, seed);
      final published = gateway.changes.first;

      gateway.add(seed.first);

      expect((await published).single.id, 1);
      expect(store.saved?.single.id, 1);
    });

    test('ignore un anime déjà listé', () {
      final store = FakeWatchlistStore([seed.first]);
      final gateway = LocalWatchlistGateway(store, seed);

      gateway.add(seed.first);

      expect(gateway.entries.length, 1);
      expect(store.writes, 0);
    });

    test('enregistre un changement de statut', () {
      final store = FakeWatchlistStore([seed.first]);
      final gateway = LocalWatchlistGateway(store, seed);

      gateway.changeStatus(1, WatchStatus.completed);

      expect(store.saved?.single.status, WatchStatus.completed);
    });

    test('ignore un changement de statut sur un anime absent', () {
      final store = FakeWatchlistStore([seed.first]);
      final gateway = LocalWatchlistGateway(store, seed);

      gateway.changeStatus(99, WatchStatus.completed);

      expect(store.writes, 0);
    });
  });

  group('PreferencesWatchlistStore', () {
    setUp(() {
      SharedPreferencesAsyncPlatform.instance =
          InMemorySharedPreferencesAsync.empty();
    });

    test('survit à la réouverture des préférences', () async {
      final first = PreferencesWatchlistStore(await AppPreferences.open());
      await first.write(seed);

      final reopened = PreferencesWatchlistStore(await AppPreferences.open());

      expect(reopened.read()?.length, 2);
    });

    test('renvoie null quand rien n a été enregistré', () async {
      final store = PreferencesWatchlistStore(await AppPreferences.open());

      expect(store.read(), isNull);
    });

    test('lit et écrit des booléens', () async {
      final preferences = await AppPreferences.open();

      expect(
        preferences.readBool(PreferencesKey.spoilerGuard, fallback: true),
        isTrue,
      );

      await preferences.writeBool(PreferencesKey.spoilerGuard, value: false);

      expect(
        preferences.readBool(PreferencesKey.spoilerGuard, fallback: true),
        isFalse,
      );
    });
  });
}
