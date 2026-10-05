# Data Model: Constellation

**Feature**: `013-constellation` | **Date**: 2026-10-05

Aucune donnée n'est stockée ni reçue d'un service : le modèle est calculé à chaque ouverture à partir de la liste de l'utilisateur et de ses fiches. Entités sous `lib/layers/functional/Constellation/domain/entities/`, toutes immuables et comparées par valeur (`Equatable`).

## Entrées (couches voisines)

| Source | Élément utilisé |
|--------|-----------------|
| `Anime/domain/entities/anime.dart` | `id`, `title`, `status`, `progress`, `isLoadingDetails`, `details` (genres, `posterUrl`) |
| `Anime/domain/entities/watch_status.dart` | `WatchStatus` : `toWatch`, `watching`, `completed` |
| `Discover/domain/entities/evening_mood.dart` | `EveningMood` et son ensemble `genreSlugs` de genres Kitsu |

## Constellation (`constellation.dart`)

| Champ | Type | Règle |
|-------|------|-------|
| `stars` | `List<ConstellationStar>` | une étoile par anime de la liste, tous statuts ; vide si la liste est vide |
| `links` | `List<ConstellationLink>` | liens retenus, triés par identifiants |
| `genres` | `List<EveningMood>` | humeurs de Découvrir présentes dans la liste, par fréquence décroissante puis ordre alphabétique du nom ; ne contient jamais `EveningMood.any` |

## ConstellationStar (`constellation_star.dart`)

| Champ | Type | Obligatoire | Règle |
|-------|------|-------------|-------|
| `animeId` | `int` | oui | identifiant de l'anime |
| `title` | `String` | oui | titre de l'anime |
| `status` | `WatchStatus` | oui | statut dans la liste |
| `x` | `double` | oui | position dans [0,06 ; 0,94] |
| `y` | `double` | oui | position dans [0,06 ; 0,94] |
| `weight` | `double` | oui | dans [0, 1] : 0,35 si `toWatch` ; `0,55 + 0,45 * progression` si `watching` (progression 0 si inconnue) ; 1 si `completed` |
| `genreSlug` | `String?` | non | nom de l'humeur principale (par exemple `action`), nul sans humeur |
| `posterUrl` | `String?` | non | affiche de la fiche, si disponible |

Un anime sans fiche reste une étoile, sans humeur ni affiche. Une étoile seule est placée au centre (0,5 ; 0,5).

## ConstellationLink (`constellation_link.dart`)

| Champ | Type | Règle |
|-------|------|-------|
| `fromId` | `int` | identifiant le plus petit de la paire |
| `toId` | `int` | identifiant le plus grand de la paire |
| `sharedGenres` | `int` | nombre de genres Kitsu communs, au moins 1 |

Une paire n'apparaît qu'une fois ; chaque étoile a au plus 3 liens (`ConstellationLinksBuilder.maxLinksPerStar`).

## Règles de calcul

- **Humeurs d'un anime** (`BuildConstellationUseCase.moodsOf`) : ensemble des `EveningMood` dont un des `genreSlugs` figure parmi les genres Kitsu de l'anime ; plusieurs genres d'une même humeur comptent une fois.
- **Humeur principale** : parmi les humeurs de l'anime, la première dans l'ordre de `Constellation.genres` (fréquence puis ordre alphabétique du nom).
- **Liens** : calculés sur tous les genres Kitsu communs, indépendamment des humeurs.
- **Positions** : `ConstellationLayout.positions` renvoie un `Map<int, ConstellationPoint>` ; même liste donc mêmes positions, quel que soit l'ordre des animes ; les identifiants dupliqués comptent une fois ; les liens vers des identifiants inconnus ou bouclés sont ignorés.
- **Constantes** : `toWatchWeight` 0,35, `watchingBaseWeight` 0,55, `watchingProgressWeight` 0,45, `completedWeight` 1 ; `minBound` 0,06, `maxBound` 0,94.

## ConstellationPoint (`constellation_layout.dart`)

Valeur simple `x`, `y` (`double`) produite par la disposition.

## Modèle de présentation : ConstellationState

Dans `presentation/cubit/constellation_state.dart`.

| Champ | Type | Valeur initiale |
|-------|------|-----------------|
| `status` | `ConstellationStatus` : `loading`, `success`, `empty`, `failure` | `loading` |
| `constellation` | `Constellation?` | `null` |
| `selectedStarId` | `int?` | `null` |
| `genreSlug` | `String?` | `null` (aucun filtre) |

Dérivés : `selectedStar`, `linkCountOf(animeId)` (liens dont l'étoile est une extrémité).

Transitions : `load()` repart de `loading` et s'abonne au flux ; un résultat sans étoile donne `empty`, sinon `success` ; une erreur du flux donne `failure`. `select` et `filterByGenre` ne s'appliquent qu'en `success`. Une réémission du flux garde la sélection si l'étoile existe encore, et garde le filtre.

## Exception

`ConstellationUnavailableException` (`build_constellation_use_case.dart`) : levée dans le flux quand la liste n'est pas vide et qu'aucun anime n'a de fiche.

## Relations

```text
Constellation 1 ── * ConstellationStar
Constellation 1 ── * ConstellationLink      (fromId, toId référencent animeId)
Constellation 1 ── * EveningMood             (humeurs présentes, ordonnées)
ConstellationStar * ── 0..1 EveningMood      (par genreSlug = EveningMood.name)
ConstellationState 1 ── 0..1 Constellation
```
