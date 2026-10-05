# Contrats des gateways : Animédex

**Feature**: `012-animedex-boosters` | **Date**: 2026-10-05

Les contrats abstraits sont dans `lib/layers/functional/Animedex/domain/gateways/` ; les implémentations dans `data/gateways/`. Les use cases ne connaissent que les contrats.

## BoosterCandidateGateway

Fichier : `booster_candidate_gateway.dart`.

```text
abstract interface class BoosterCandidateGateway
  Future<List<DexCard>> drawCandidates(
    int count, {
    required DateTime obtainedOn,
    Set<int> excludedIds,
  })

class BoosterUnavailableException implements Exception
```

- `count` : nombre de cartes souhaitées.
- `obtainedOn` : instant porté par chaque carte renvoyée.
- `excludedIds` : identifiants de personnages à ne pas renvoyer (vide par défaut).
- Retour : de 1 à `count` cartes aux `characterId` distincts et absents de `excludedIds` ; peut être plus court que `count`.
- Erreur : `BoosterUnavailableException` si le service est injoignable, répond en erreur, dépasse le délai, ne renvoie aucune carte exploitable ou si tout est exclu. Aucune autre exception ne sort du contrat.

### Implémentation : AniListBoosterCandidateGateway

Fichier : `data/gateways/ani_list_booster_candidate_gateway.dart`.

- Constructeur : `AniListBoosterCandidateGateway(AniListClient client, {Random? random, Duration requestTimeout = defaultTimeout})`.
- `defaultTimeout` : 4000 ms. `maxPlacementRetries` : 5.
- `static String buildQuery(List<int> pages)` : une requête GraphQL avec un alias `c{slot}: Page(page: {n}, perPage: 1) { characters(sort: FAVOURITES_DESC) { id name { full native } image { large } favourites media(perPage: 1, sort: POPULARITY_DESC) { nodes { title { romaji english } } } } }` par page.
- Choix des pages : par carte demandée, `RarityRule.roll` puis `RarityRule.pageIn` ; une page déjà utilisée est retirée jusqu'à 5 fois, puis abandonnée (le lot peut donc être plus court).
- Analyse : `AniListCharacterDto.fromJson(json, obtainedOn:)` ; l'exclusion et la déduplication s'appliquent après réception.

## DexCollectionGateway

Fichier : `dex_collection_gateway.dart`.

```text
abstract interface class DexCollectionGateway
  List<DexCard> get cards
  Future<void> addAll(List<DexCard> cards)
```

- `cards` : la collection courante ; liste non modifiable.
- `addAll` : ajoute les cartes dont le `characterId` est inconnu, ignore les autres, puis persiste.

### Implémentation : PreferencesDexCollectionGateway

Fichier : `data/gateways/preferences_dex_collection_gateway.dart`. Constructeur `PreferencesDexCollectionGateway(AppPreferences)`. DOIT être un singleton (cache mémoire chargé au premier accès, lecture tolérante via `DexCardDto.fromJson`). Clé : `PreferencesKey.dex`.

## BoosterScheduleGateway

Fichier : `booster_schedule_gateway.dart`.

```text
abstract interface class BoosterScheduleGateway
  String? get lastOpenedDay
  Future<void> markOpened(String day)
```

- `lastOpenedDay` : `yyyy-MM-dd` en fuseau local, ou `null` si aucun booster n'a jamais été ouvert.
- `markOpened(day)` : mémorise le jour.

### Implémentation : PreferencesBoosterScheduleGateway

Fichier : `data/gateways/preferences_booster_schedule_gateway.dart`. Constructeur `const PreferencesBoosterScheduleGateway(AppPreferences)`. Clé : `PreferencesKey.lastBoosterDay`.

## Enregistrement get_it

Dans `lib/layers/technical/Injection/injection.dart` :

| Type enregistré | Implémentation | Mode |
|-----------------|----------------|------|
| `DexCollectionGateway` | `PreferencesDexCollectionGateway(getIt())` | `registerLazySingleton` |
| `BoosterScheduleGateway` | `PreferencesBoosterScheduleGateway(getIt())` | `registerLazySingleton` |
| `BoosterCandidateGateway` | `AniListBoosterCandidateGateway(getIt())` | `registerLazySingleton` |

## Contrat d'API externe : AniList GraphQL

- Point d'entrée : `https://graphql.anilist.co`, POST JSON `{query, variables}`, via `AniListClient.query` (délai de 10 s côté client ; statut différent de 200 : `AniListRequestFailedException`, convertie ici en `BoosterUnavailableException`).
- Aucune authentification.
- Limite de débit d'AniList : de l'ordre de 30 à 90 requêtes par minute ; un booster coûte une requête, plus au plus trois requêtes de reprise en cas de doublon ou de réponse partielle.
