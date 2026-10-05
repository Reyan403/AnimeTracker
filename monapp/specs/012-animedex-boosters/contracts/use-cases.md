# Contrats des use cases : Animédex

**Feature**: `012-animedex-boosters` | **Date**: 2026-10-05

Dossier : `lib/layers/functional/Animedex/domain/use_cases/`. Chaque use case expose une seule méthode `call()`. Les horloges et le hasard sont injectables.

## OpenBoosterUseCase

Fichier : `open_booster_use_case.dart`.

```text
OpenBoosterUseCase(
  BoosterCandidateGateway candidates,
  DexCollectionGateway collection,
  BoosterScheduleGateway schedule, {
  DateTime Function()? now,
  Random? random,
})

static const int boosterSize = 5
static const int maxAttempts = 4

Future<List<DrawnCard>> call()

class BoosterAlreadyOpenedException implements Exception
```

Comportement :

1. Lit l'instant et calcule le jour (`BoosterDay.keyOf`). Si `schedule.lastOpenedDay` est égal : lève `BoosterAlreadyOpenedException`, sans aucun appel au gateway de tirage.
2. Tire jusqu'à 5 cartes distinctes en au plus 4 tentatives ; à chaque tentative, demande le nombre de cartes manquantes en excluant les identifiants déjà retenus ; une `BoosterUnavailableException` d'une tentative interrompt la boucle sans perdre les cartes déjà obtenues.
3. Si aucune carte n'a été obtenue : lève `BoosterUnavailableException`.
4. Mélange les cartes avec le `Random` injecté, calcule `isNew` (identifiant absent de la collection), ajoute les nouvelles cartes à la collection, puis marque le jour. Le jour n'est jamais marqué avant le succès du tirage.

Erreurs : `BoosterAlreadyOpenedException` (déjà ouvert), `BoosterUnavailableException` (source indisponible). Les deux sont des exceptions de domaine nommées.

## LoadDexUseCase

Fichier : `load_dex_use_case.dart`.

```text
const LoadDexUseCase(DexCollectionGateway collection)
List<DexCard> call()
```

Renvoie une copie de la collection triée par rareté décroissante puis par `obtainedOn` décroissant. Synchrone, sans erreur propre (une collection illisible est déjà vide côté gateway).

## CheckBoosterAvailabilityUseCase

Fichier : `check_booster_availability_use_case.dart`.

```text
const CheckBoosterAvailabilityUseCase(BoosterScheduleGateway schedule, {DateTime Function()? now})
BoosterAvailability call()
```

`isAvailable` est vrai quand `lastOpenedDay` diffère du jour courant ; `nextAt` vaut le prochain minuit local. Synchrone.

## Utilitaire : BoosterDay

Fichier : `booster_day.dart`. Classe abstraite finale à deux fonctions pures :

- `static String keyOf(DateTime moment)` : `yyyy-MM-dd` en fuseau local ;
- `static DateTime midnightAfter(DateTime moment)` : minuit local du lendemain (correct aux changements de mois et d'année).

## Enregistrement get_it

| Type | Mode |
|------|------|
| `LoadDexUseCase` | `registerLazySingleton` |
| `CheckBoosterAvailabilityUseCase` | `registerLazySingleton` |
| `OpenBoosterUseCase` | `registerLazySingleton` |

## Consommation par les cubits

- `DexCubit(LoadDexUseCase, CheckBoosterAvailabilityUseCase)` : `load()` appelle les deux ; toute exception donne `DexStatus.failure`.
- `BoosterCubit(OpenBoosterUseCase)` : `open()` appelle `call()` ; `BoosterAlreadyOpenedException` donne `alreadyOpened`, toute autre erreur donne `failure`, un succès donne `revealed`.
