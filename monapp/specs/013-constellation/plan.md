# Implementation Plan: Constellation

**Branch**: `013-constellation` | **Date**: 2026-10-05 | **Spec**: [spec.md](spec.md)

**Input**: Feature specification from `/specs/013-constellation/spec.md`

## Summary

Une carte du ciel de la liste de l'utilisateur : chaque anime est une étoile, reliée aux animes qui partagent des genres ; la taille suit le statut et la progression, la couleur suit l'humeur de l'onglet « Découvrir ». Le calcul est entièrement local et déterministe : `BuildConstellationUseCase` réutilise `LoadWatchlistUseCase` (comme les statistiques), `ConstellationLinksBuilder` relie les paires de genres communs (trois liens au plus par étoile) et `ConstellationLayout` place les étoiles par une relaxation de type force-dirigée amorcée par les identifiants, bornée en itérations. La page plein écran (route poussée depuis l'écran des statistiques) dessine le ciel dans un `CustomPaint` isolé, avec pan et zoom (`InteractiveViewer`), scintillement qui respecte la réduction des animations, légende des humeurs sur plusieurs lignes et aperçu de l'étoile touchée menant à la fiche de l'anime. Il n'y a ni couche data, ni requête réseau, ni stockage.

## Technical Context

**Language/Version**: Dart 3.13 (`sdk: ^3.13.3`), Flutter

**Primary Dependencies**: `flutter_bloc` 9 (cubit), `get_it` 9 (injection), `equatable`, `intl` et `flutter_localizations` (clés `constellation…` de `lib/l10n/app_fr.arb`). Aucune dépendance ajoutée. Réutilise `LoadWatchlistUseCase` (couche `Anime`), `EveningMood` et `evening_labels.dart` (couche `Discover`), `openAnimeSheet` (couche `Catalogue`), `AnimePoster`, `PopCard`, `GenreTag` (couche technique `Theme`).

**Storage**: N/A. Les genres viennent des fiches déjà chargées pour la liste ; aucune écriture.

**Testing**: `flutter_test` (unitaires et widget), fixtures de la liste dans `test/support/watchlist_fixtures.dart` (utilisées par `star_logic_support.dart` et `ui_support.dart`), helper `pumpApp` avec `settle: false` pour les animations infinies. 82 cas déclarés dans `test/layers/functional/constellation/` (`logic_*` et `ui_*`).

**Target Platform**: application Flutter multiplateforme ; validation manuelle sur le site web servi sur le port 5059.

**Project Type**: application mobile et web Flutter, architecture OSDD.

**Performance Goals**: calcul de la disposition de 100 animes en moins de 50 ms (test chronométré, meilleur de plusieurs essais) ; un seul `AnimationController` pour tout le ciel (`SkyClockBuilder`), `CustomPaint` dans un `RepaintBoundary`, aucun appel réseau pour afficher la page.

**Constraints**: déterminisme (même liste, mêmes positions, quel que soit l'ordre des animes), positions dans [0,06 ; 0,94] sur chaque axe, au plus 3 liens par étoile, réduction des animations respectée (`MediaQuery.disableAnimationsOf`, `AppMotion.resolve`), légende plafonnée à un tiers de la hauteur de l'écran.

**Scale/Scope**: listes de quelques animes à plusieurs centaines ; disposition en O(n²) par itération, 140 itérations jusqu'à 60 animes et 80 au-delà ; 1 cubit, 1 use case, 2 fonctions pures de domaine, 1 page, 1 carte d'entrée.

## Constitution Check

*GATE: Must pass before Phase 0 research. Re-check after Phase 1 design.*

Constitution v1.0.0. Vérification faite sur le code livré (mesures du 2026-10-05).

| # | Principe | Verdict | Constat |
|---|----------|---------|---------|
| I | Architecture OSDD | Conforme avec une réserve | `lib/layers/functional/Constellation/{domain,presentation}` ; pas de `data` car il n'y a aucune source externe. Réserve : la couche dépend de couches fonctionnelles voisines (`Anime` pour la liste, `Discover` pour `EveningMood` et ses libellés, `Catalogue` pour la navigation vers la fiche). Le couplage avec `Discover` est voulu par la spec (FR-004 : mêmes humeurs et mêmes libellés) ; `EveningMood` n'est pas dans une couche commune. |
| II | Cubit → use case → contrat | Conforme | `ConstellationCubit(BuildConstellationUseCase)` ne dépend que d'un use case ; `BuildConstellationUseCase(LoadWatchlistUseCase)` n'a que `call()` et ne touche aucun gateway ni stockage ; enregistrés dans `get_it` (use case en singleton, cubit en `registerFactory`). `ConstellationLayout` et `ConstellationLinksBuilder` sont des fonctions pures statiques placées dans `domain/use_cases/` sans être des use cases : le dossier les héberge faute de couche dédiée. |
| III | Aucun commentaire | Conforme | Recherche `//`, `///` et TODO sur `lib/layers/functional/Constellation` : aucun résultat. |
| IV | Fichiers courts, widgets décomposés | Écart (test) | Tous les fichiers de `lib` font moins de 200 lignes (maximum : `constellation_painter.dart`, 170). Aucune méthode `_buildXxx`. Un cubit par écran, état découpé (`ConstellationState`). Écart : `test/layers/functional/constellation/ui_page_test.dart` fait 238 lignes. |
| V | Thème centralisé | Conforme avec écarts mineurs | Aucune `Color(0x…)` ni `TextStyle(` littérale ; couleurs via `AppPalette` (`nebula`, `starGlow`, `candy`, `sky`, `sun`, `rarityEpic`, `rarityRare`, `completed`, `watching`, `toWatch`) par `StarPalette`, `Color.lerp` entre jetons dans la carte d'entrée ; espacements via `AppSpacing`. Écarts : constantes de dessin locales (`StarLayout.minRadius` 3, `radiusRange` 6, `hitRadius` 26, `padding` 28 ; `NightSkyBackground.dustCount` 90 ; dimensions 104 par 84 de l'aperçu ; `AppSpacing.sm + 2` et `AppSpacing.xs + 2` dans `genre_legend_chip.dart` ; largeurs de trait et opacités des liens dans `constellation_painter.dart`) qui ne sont pas des jetons de thème. |
| VI | Internationalisation | Conforme | 12 clés `constellation…` (titre, sous-titre, chargement, vide, erreur, ouverture de la fiche, fermeture de l'aperçu, pluriels de liens et d'étoiles, indication du filtre, retour) ; libellés d'humeurs via `labelOf(l10n)` de `Discover` ; message d'erreur par la clé existante `serviceUnavailable`. Aucun texte en dur. |
| VII | États asynchrones explicites | Conforme | Chargement (`ConstellationLoading`), succès (ciel), vide (`SkyMessage` d'invitation), erreur (`SkyMessage` avec « Réessayer »). Aucun texte d'exception : `ConstellationUnavailableException` donne l'état d'erreur traduit. |
| VIII | Tests livrés | Conforme | 82 cas déclarés (220 exécutés avec Animédex, tous verts le 2026-10-05). Couverture des lignes de `lib/layers/functional/Constellation` : 746 sur 758, soit 98,4 %. Aucune annotation d'exclusion de couverture. Limite : lcov ne compte que les fichiers importés par les tests ; l'insertion de `ConstellationEntryCard` dans `Stats/presentation/stats_view.dart` n'a pas de test propre dans l'écran des statistiques (la carte d'entrée est testée seule). |
| IX | Aucun secret | Conforme | Aucun appel externe, aucune configuration. |
| X | Nommage et exceptions | Conforme | Fichiers en `snake_case`, suffixes `Cubit`, `State`, `UseCase` ; seule exception levée : `ConstellationUnavailableException`, de domaine et nommée. |
| XI | Images distantes | Écart | L'aperçu d'une étoile affiche l'affiche via `AnimePoster` (`lib/layers/technical/Theme/widgets/anime_poster.dart`), qui utilise `Image.network` ; `cached_network_image` n'est pas dans `pubspec.yaml`. Placeholder et repli (`AnimePlaque`) présents, sans cache disque. Le ciel lui-même ne charge aucune image. |

**Dérogations justifiées** (voir Complexity Tracking) : XI, IV (test). Le plan est validé avec ces écarts assumés.

## Project Structure

### Documentation (this feature)

```text
specs/013-constellation/
├── spec.md
├── plan.md
├── research.md
├── data-model.md
├── quickstart.md
├── contracts/
│   ├── use-cases.md
│   └── ui.md
├── checklists/
│   └── requirements.md
└── tasks.md
```

### Source Code (repository root)

```text
lib/layers/functional/Constellation/
├── domain/
│   ├── entities/        # constellation, constellation_star, constellation_link
│   └── use_cases/       # build_constellation_use_case, constellation_layout, constellation_links_builder
└── presentation/
    ├── constellation_page.dart
    ├── constellation_entry_card.dart
    ├── cubit/           # constellation_cubit, constellation_state
    └── widgets/         # constellation_body, constellation_sky, constellation_painter, star_layout,
                         # star_motion, star_palette, star_drawing, shooting_star_drawing, sky_clock_builder,
                         # night_sky_background, genre_legend, genre_legend_chip, star_preview_panel,
                         # star_preview_card, sky_header, sky_message, constellation_loading, mini_sky

lib/layers/functional/Stats/presentation/stats_view.dart   # carte d'entrée insérée sous les statistiques

lib/layers/technical/
├── Injection/injection.dart        # BuildConstellationUseCase (singleton), ConstellationCubit (fabrique)
└── Theme/app_palette.dart          # jetons nebula, starGlow, rarity*

lib/l10n/app_fr.arb                 # clés constellation…

test/layers/functional/constellation/   # logic_* et ui_*
```

**Structure Decision**: deux dossiers (domain, presentation) sous la couche fonctionnelle `Constellation`, sans `data` : tout le calcul repose sur la liste déjà chargée. La logique géométrique du dessin (`StarLayout`, `StarMotion`, `StarPalette`) reste en présentation car elle dépend de la taille d'écran et de la palette.

## Complexity Tracking

| Violation | Why Needed | Simpler Alternative Rejected Because |
|-----------|------------|-------------------------------------|
| XI : `Image.network` via `AnimePoster` | Composant partagé préexistant déjà utilisé dans toute l'application, avec plaque de repli et fondu | Introduire `cached_network_image` pour cet aperçu seul créerait deux composants d'image concurrents ; la migration se fait en une fois dans `AnimePoster` (modification de `pubspec.yaml`, réservée) |
| IV : `ui_page_test.dart` de 238 lignes | Les scénarios de la page (états, aperçu, filtre, navigation) partagent la même mise en place | Les scinder dupliquerait fixtures et `pumpApp` ; à découper en extrayant des groupes |
| I : dépendance vers `Discover` et `Anime` | La spec impose les humeurs et libellés de Découvrir et la liste de l'utilisateur | Dupliquer `EveningMood` et ses traductions les ferait diverger ; une couche commune d'humeurs est à envisager si une troisième fonctionnalité les utilise |
