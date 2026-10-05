# Contrats du domaine : Constellation

**Feature**: `013-constellation` | **Date**: 2026-10-05

Dossier : `lib/layers/functional/Constellation/domain/use_cases/`. La fonctionnalité n'a ni gateway ni couche data : le seul contrat consommé est le use case existant `LoadWatchlistUseCase` (`lib/layers/functional/Anime/domain/use_cases/load_watchlist_use_case.dart`).

## BuildConstellationUseCase

Fichier : `build_constellation_use_case.dart`.

```text
const BuildConstellationUseCase(LoadWatchlistUseCase loadWatchlist)

static const double toWatchWeight = 0.35
static const double watchingBaseWeight = 0.55
static const double watchingProgressWeight = 0.45
static const double completedWeight = 1

Stream<Constellation> call()

static Set<EveningMood> moodsOf(Anime anime)
static double weightOf(Anime anime)

class ConstellationUnavailableException implements Exception
```

Comportement de `call()` :

1. S'abonne à `LoadWatchlistUseCase` et ignore toute émission où au moins un anime a `isLoadingDetails` vrai.
2. Pour chaque émission retenue : liste non vide dont aucun anime n'a de fiche : erreur `ConstellationUnavailableException` dans le flux ; sinon construction de la `Constellation`.
3. Construction : humeurs de chaque anime (`moodsOf`), ordre des humeurs par fréquence puis ordre alphabétique du nom, liens (`ConstellationLinksBuilder.build`), positions (`ConstellationLayout.positions`), étoiles dans l'ordre de la liste avec poids (`weightOf`), humeur principale (`genreSlug` égal au nom de l'humeur) et affiche.
4. Liste vide : `Constellation` sans étoile, sans lien et sans genre.

Erreurs : `ConstellationUnavailableException`, exception de domaine nommée ; les erreurs du flux de la liste sont transmises telles quelles et traitées par le cubit comme un échec.

## ConstellationLinksBuilder

Fichier : `constellation_links_builder.dart`. Classe à constructeur privé, fonction pure.

```text
static const int maxLinksPerStar = 3
static List<ConstellationLink> build(List<Anime> animes)
```

- Entrée : la liste des animes avec leurs genres Kitsu (`details.genres[].slug`).
- Sortie : liens `fromId < toId`, sans doublon, au plus 3 par étoile, les plus forts préférés (genres communs décroissants, puis mélange déterministe, puis identifiants), triés par `fromId` puis `toId`.
- Déterministe : indépendant de l'ordre de la liste.
- Un anime sans fiche ou sans genre n'a aucun lien.

## ConstellationLayout

Fichier : `constellation_layout.dart`. Classe à constructeur privé, fonction pure.

```text
static const double minBound = 0.06
static const double maxBound = 0.94

static Map<int, ConstellationPoint> positions(
  Iterable<int> animeIds,
  Iterable<ConstellationLink> links,
)

class ConstellationPoint { final double x; final double y }
```

- Aucun identifiant : table vide. Un identifiant : (0,5 ; 0,5).
- Plusieurs identifiants : amorçage déterministe, 140 itérations jusqu'à 60 étoiles et 80 au-delà, puis recadrage de chaque axe sur [0,06 ; 0,94].
- Les identifiants dupliqués comptent une fois ; les liens vers des identifiants inconnus ou d'une étoile vers elle-même sont ignorés.
- Performance : moins de 50 ms pour 100 animes.

## Enregistrement get_it

Dans `lib/layers/technical/Injection/injection.dart` :

| Type | Mode |
|------|------|
| `BuildConstellationUseCase(getIt<LoadWatchlistUseCase>())` | `registerLazySingleton` |
| `ConstellationCubit(getIt<BuildConstellationUseCase>())` | `registerFactory` |

## Consommation par le cubit

`ConstellationCubit(BuildConstellationUseCase)` (`presentation/cubit/constellation_cubit.dart`) :

- `Future<void> load()` : annule l'abonnement précédent, repasse en `loading`, s'abonne au flux ;
- `void select(int? animeId)` : retient l'étoile sélectionnée (ignoré hors `success`) ;
- `void filterByGenre(String? slug)` : retient le filtre d'humeur (ignoré hors `success`) ;
- `close()` annule l'abonnement.
