# Tasks: Constellation

**Input**: Design documents from `/specs/013-constellation/`

**Prerequisites**: plan.md, spec.md, research.md, data-model.md, contracts/ (use-cases.md, ui.md)

**Tests**: livrés avec la fonctionnalité (constitution, principe VIII). Les fichiers de test sont sous `test/layers/functional/constellation/`.

**Organization**: tâches groupées par user story. Toutes sont réalisées (état au 2026-10-05).

## Format: `[ID] [P?] [Story] Description`

- **[P]**: peut s'exécuter en parallèle (fichiers différents, sans dépendance non terminée)
- **[Story]**: user story concernée (US1, US2)
- Chemins relatifs à `monapp/`. `Constellation/` désigne `lib/layers/functional/Constellation/`.

## Phase 1: Setup (Shared Infrastructure)

**Purpose**: câblage technique et dossiers

- [X] T001 [P] Ajouter les jetons `nebula` et `starGlow` (et réutiliser `rarityEpic`, `rarityRare`) dans `lib/layers/technical/Theme/app_palette.dart`
- [X] T002 [P] Créer l'arborescence `Constellation/{domain/{entities,use_cases},presentation/{cubit,widgets}}` et le dossier `test/layers/functional/constellation/`
- [X] T003 Ajouter les clés `constellation…` dans `lib/l10n/app_fr.arb` (12 clés, pluriels compris) puis exécuter `flutter gen-l10n`
- [X] T004 [P] Créer l'aide de test `test/layers/functional/constellation/star_logic_support.dart` (fixtures de liste et de fiches à partir de `test/support/watchlist_fixtures.dart`) et `test/layers/functional/constellation/ui_support.dart`

---

## Phase 2: Foundational (Blocking Prerequisites)

**Purpose**: entités du domaine dont dépendent toutes les user stories

**⚠️ CRITICAL**: aucune user story ne peut commencer avant la fin de cette phase

- [X] T005 [P] Créer `ConstellationStar` (`animeId`, `title`, `status`, `x`, `y`, `weight`, `genreSlug?`, `posterUrl?`) dans `Constellation/domain/entities/constellation_star.dart`
- [X] T006 [P] Créer `ConstellationLink` (`fromId`, `toId`, `sharedGenres`) dans `Constellation/domain/entities/constellation_link.dart`
- [X] T007 [P] Créer `Constellation` (`stars`, `links`, `genres` de type `List<EveningMood>`) dans `Constellation/domain/entities/constellation.dart`

**Checkpoint**: modèle prêt ; les user stories peuvent démarrer.

---

## Phase 3: User Story 1 - Voir ma liste comme un ciel étoilé (Priority: P1) 🎯 MVP

**Goal**: ouvrir depuis les statistiques une page plein écran où chaque anime est une étoile, reliée aux animes de genres communs, de taille croissante avec le statut, disposée de façon déterministe, avec les états chargement, vide et erreur.

**Independent Test**: avec une liste de plusieurs animes aux genres communs, la page affiche des étoiles reliées, identiques à chaque ouverture ; liste vide : invitation ; aucune fiche : message d'erreur avec « Réessayer ».

### Tests for User Story 1

- [X] T008 [P] [US1] Écrire les tests de `ConstellationLayout` (liste vide, une étoile centrée, déterminisme, indépendance de l'ordre, marges 0,06 à 0,94, distance minimale, liens plus proches, identifiants inconnus ou dupliqués, moins de 50 ms pour 100 animes) dans `test/layers/functional/constellation/logic_layout_test.dart`
- [X] T009 [P] [US1] Écrire les tests de `ConstellationLinksBuilder` (genres partagés, comptage, trois liens au plus, pas de doublon, liens les plus forts, indépendance de l'ordre) dans `test/layers/functional/constellation/logic_links_test.dart`
- [X] T010 [P] [US1] Écrire les tests de `BuildConstellationUseCase` (liste vide, étoile seule, échec sans fiche, attente du chargement, positions stables, reprise du titre, du statut et de l'affiche) dans `test/layers/functional/constellation/logic_use_case_test.dart`
- [X] T011 [P] [US1] Écrire les tests de pondération (0,35, 0,55 à 1, 1) et d'humeurs (fréquence puis ordre alphabétique, genre principal, humeurs de Découvrir seulement, regroupement des genres Kitsu d'une même humeur, liens sur tous les genres communs) dans `test/layers/functional/constellation/logic_weights_test.dart`
- [X] T012 [P] [US1] Écrire les tests de `ConstellationCubit` (chargement, succès, vide, échec, relance, sélection conservée ou perdue) dans `test/layers/functional/constellation/ui_cubit_test.dart`
- [X] T013 [P] [US1] Écrire les tests de la carte d'entrée (titre, sous-titre, thème sombre sans animation, ouverture de la page) dans `test/layers/functional/constellation/ui_entry_card_test.dart`
- [X] T014 [P] [US1] Écrire les tests des états de la page (chargement, ciel, vide, erreur avec nouvel essai, thème sombre sans animation, étoile filante) dans `test/layers/functional/constellation/ui_page_test.dart`

### Implementation for User Story 1

- [X] T015 [P] [US1] Créer `ConstellationLinksBuilder` (`maxLinksPerStar` 3, tri par force puis mélange déterministe puis identifiants) dans `Constellation/domain/use_cases/constellation_links_builder.dart`
- [X] T016 [P] [US1] Créer `ConstellationLayout` et `ConstellationPoint` (spirale à angle d'or graînée par l'identifiant, relaxation 140 ou 80 itérations, recadrage sur [0,06 ; 0,94]) dans `Constellation/domain/use_cases/constellation_layout.dart`
- [X] T017 [US1] Créer `BuildConstellationUseCase` et `ConstellationUnavailableException` (flux dérivé de `LoadWatchlistUseCase`, attente de `!isLoadingDetails`, poids, humeurs de Découvrir, humeur principale) dans `Constellation/domain/use_cases/build_constellation_use_case.dart` (dépend de T005 à T007, T015, T016)
- [X] T018 [P] [US1] Créer `ConstellationState` et `ConstellationCubit` (`load`) dans `Constellation/presentation/cubit/constellation_state.dart` et `Constellation/presentation/cubit/constellation_cubit.dart` (dépend de T017)
- [X] T019 [P] [US1] Créer `StarPalette`, `StarMotion` et `SkyClockBuilder` (horloge unique, arrêtée si les animations sont réduites) dans `Constellation/presentation/widgets/star_palette.dart`, `Constellation/presentation/widgets/star_motion.dart` et `Constellation/presentation/widgets/sky_clock_builder.dart`
- [X] T020 [P] [US1] Créer `StarLayout` (position, rayon `3 + 6 * poids`) dans `Constellation/presentation/widgets/star_layout.dart`
- [X] T021 [P] [US1] Créer `StarDrawing`, `ShootingStarDrawing` et `ConstellationPainter` dans `Constellation/presentation/widgets/star_drawing.dart`, `Constellation/presentation/widgets/shooting_star_drawing.dart` et `Constellation/presentation/widgets/constellation_painter.dart` (dépend de T019, T020)
- [X] T022 [P] [US1] Créer `NightSkyBackground`, `ConstellationLoading`, `SkyHeader` et `SkyMessage` dans `Constellation/presentation/widgets/`
- [X] T023 [US1] Créer `ConstellationSky` (`RepaintBoundary`, `CustomPaint`) dans `Constellation/presentation/widgets/constellation_sky.dart` (dépend de T021)
- [X] T024 [US1] Créer `ConstellationBody` (états chargement, vide, erreur, succès) dans `Constellation/presentation/widgets/constellation_body.dart` (dépend de T018, T022, T023)
- [X] T025 [US1] Créer `ConstellationPage` et `ConstellationScaffold` (route à fondu, `ConstellationPage.open`) dans `Constellation/presentation/constellation_page.dart`
- [X] T026 [P] [US1] Créer `MiniSky` et `ConstellationEntryCard` dans `Constellation/presentation/widgets/mini_sky.dart` et `Constellation/presentation/constellation_entry_card.dart`
- [X] T027 [US1] Insérer `ConstellationEntryCard` entre le contenu des statistiques et l'interrupteur anti-spoil dans `lib/layers/functional/Stats/presentation/stats_view.dart` (dépend de T026)

**Checkpoint**: le ciel s'affiche, déterministe, avec ses quatre états ; US1 est utilisable seule.

---

## Phase 4: User Story 2 - Explorer le ciel (Priority: P2)

**Goal**: zoom et déplacement, légende des humeurs de Découvrir sur plusieurs lignes avec filtre, aperçu de l'étoile touchée menant à la fiche.

**Independent Test**: toucher une étoile puis « Ouvrir la fiche » ouvre la fiche de l'anime ; choisir une humeur atténue les autres étoiles ; la légende reste sous un tiers de l'écran.

### Tests for User Story 2

- [X] T028 [P] [US2] Écrire les tests de la géométrie (`StarLayout` : zone utile, taille, tolérance, étoile la plus proche ; `StarMotion` ; `StarPalette` ; `ShootingStarDrawing`) dans `test/layers/functional/constellation/ui_geometry_test.dart`
- [X] T029 [P] [US2] Écrire les tests de la légende (dix humeurs d'un coup à plusieurs largeurs, un tiers d'écran, retour à la ligne, police très large, défilement vertical au-delà, sélection, retrait du filtre, liste vide) dans `test/layers/functional/constellation/ui_legend_test.dart`
- [X] T030 [P] [US2] Écrire les tests de la page avec la légende complète (ciel utilisable à plusieurs largeurs, toucher d'une étoile, filtre du ciel, étoile sans humeur touchable) dans `test/layers/functional/constellation/ui_page_legend_test.dart`
- [X] T031 [P] [US2] Ajouter à `test/layers/functional/constellation/ui_page_test.dart` les tests de l'aperçu (ouverture et fermeture, toucher le vide, filtre masquant les autres étoiles, ouverture de la fiche avec le bon héros, bouton retour)

### Implementation for User Story 2

- [X] T032 [P] [US2] Créer `GenreLegendChip` (pastille compacte cliquable, sémantique de bouton sélectionnable) dans `Constellation/presentation/widgets/genre_legend_chip.dart`
- [X] T033 [US2] Créer `GenreLegend` (`Wrap`, plafond d'un tiers d'écran, défilement vertical au-delà, libellés `labelOf`) dans `Constellation/presentation/widgets/genre_legend.dart` (dépend de T032)
- [X] T034 [US2] Ajouter `select` et `filterByGenre` à `ConstellationCubit` et `selectedStar`, `linkCountOf` à `ConstellationState` dans `Constellation/presentation/cubit/` (dépend de T018)
- [X] T035 [US2] Ajouter à `ConstellationSky` le zoom et le déplacement (`InteractiveViewer`, échelle 1 à 5), le toucher par `StarLayout.hitTest` et le filtre d'humeur dans `Constellation/presentation/widgets/constellation_sky.dart` et `Constellation/presentation/widgets/constellation_painter.dart` (dépend de T020, T034)
- [X] T036 [P] [US2] Créer `StarPreviewCard` et `StarPreviewPanel` (affiche, titre, statut, humeur, nombre de liens, fermeture, « Ouvrir la fiche ») dans `Constellation/presentation/widgets/star_preview_card.dart` et `Constellation/presentation/widgets/star_preview_panel.dart`
- [X] T037 [US2] Brancher légende, ciel et aperçu dans `ConstellationBody` avec `openAnimeSheet` et le héros `AnimePoster.heroTagFor('constellation', id)` dans `Constellation/presentation/widgets/constellation_body.dart` (dépend de T033, T035, T036)

**Checkpoint**: la constellation est explorable ; US1 et US2 fonctionnent indépendamment.

---

## Phase 5: Polish & Cross-Cutting Concerns

**Purpose**: finitions transverses et validation

- [X] T038 Enregistrer `BuildConstellationUseCase` (singleton) et `ConstellationCubit` (`registerFactory`) dans `lib/layers/technical/Injection/injection.dart`
- [X] T039 [P] Limiter les genres de la constellation aux humeurs de `EveningMood` (Découvrir) dans `Constellation/domain/use_cases/build_constellation_use_case.dart` et `Constellation/domain/entities/constellation.dart`, avec les tests de `test/layers/functional/constellation/logic_weights_test.dart`
- [X] T040 [P] Faire passer la légende de pastilles à défilement horizontal à un `Wrap` plafonné à un tiers d'écran dans `Constellation/presentation/widgets/genre_legend.dart`, avec `test/layers/functional/constellation/ui_legend_test.dart` et `test/layers/functional/constellation/ui_page_legend_test.dart`
- [X] T041 [P] Vérifier l'absence de commentaires, de couleurs littérales et de méthodes `_buildXxx` dans `lib/layers/functional/Constellation/`
- [X] T042 [P] Vérifier que chaque fichier de `lib/layers/functional/Constellation/` fait moins de 200 lignes (maximum : 170, `widgets/constellation_painter.dart`)
- [X] T043 Exécuter `flutter analyze lib/layers/functional/Constellation test/layers/functional/constellation` : aucun problème
- [X] T044 Exécuter `flutter test test/layers/functional/constellation --coverage` : tous les tests passent, couverture des lignes 98,4 %
- [X] T045 Rédiger `specs/013-constellation/spec.md` et passer son statut à « Implemented »
- [X] T046 Dérouler les scénarios de `specs/013-constellation/quickstart.md` sur le site du port 5059

---

## Dependencies & Execution Order

### Phase Dependencies

- **Setup (Phase 1)** : aucune dépendance ; T001, T002, T004 en parallèle, T003 avant les widgets.
- **Foundational (Phase 2)** : dépend du Setup ; BLOQUE les user stories.
- **US1 (Phase 3)** : dépend de la phase Foundational.
- **US2 (Phase 4)** : dépend de US1 (le ciel, le cubit et le corps de page existent).
- **Polish (Phase 5)** : dépend de US1 et US2. T039 et T040 sont des révisions de livrables précédents, faites après la première livraison, et s'appuient sur T017 et T033.

### User Story Dependencies

- **US1 (P1)** : après Foundational ; aucune dépendance vers US2.
- **US2 (P2)** : étend le cubit, le ciel et le corps de page de US1 ; ses tests de logique de légende et de géométrie sont indépendants.

### Within Each User Story

- Entités avant fonctions pures (liens, disposition), fonctions pures avant use case, use case avant cubit, cubit avant page.
- Dessin (`StarPalette`, `StarMotion`, `StarLayout`) avant le painter, painter avant le ciel, ciel avant le corps de page.

### Parallel Opportunities

- Phase 2 : T005, T006, T007 en parallèle.
- US1 : tous les tests T008 à T014 en parallèle ; T015 et T016 en parallèle ; T019, T020, T022, T026 en parallèle.
- US2 : T028 à T031 en parallèle ; T032 et T036 en parallèle.
- Les aides de test (T004) précèdent les tests mais pas l'implémentation.

---

## Parallel Example: User Story 1

```text
Task: "Écrire les tests de ConstellationLayout dans test/layers/functional/constellation/logic_layout_test.dart"
Task: "Écrire les tests de ConstellationLinksBuilder dans test/layers/functional/constellation/logic_links_test.dart"
Task: "Créer ConstellationLinksBuilder dans Constellation/domain/use_cases/constellation_links_builder.dart"
Task: "Créer ConstellationLayout dans Constellation/domain/use_cases/constellation_layout.dart"
```

## Parallel Example: User Story 2

```text
Task: "Écrire les tests de la géométrie dans test/layers/functional/constellation/ui_geometry_test.dart"
Task: "Écrire les tests de la légende dans test/layers/functional/constellation/ui_legend_test.dart"
Task: "Créer GenreLegendChip dans Constellation/presentation/widgets/genre_legend_chip.dart"
Task: "Créer StarPreviewCard et StarPreviewPanel dans Constellation/presentation/widgets/"
```

---

## Implementation Strategy

### MVP First (User Story 1)

1. Phases 1 et 2 : socle et entités.
2. Phase 3 : domaine (liens, disposition, use case), puis cubit, dessin et page.
3. **STOP et valider** : ouvrir la page depuis les statistiques, vérifier que le ciel est identique à chaque ouverture.

### Incremental Delivery

1. Ajouter US2 : zoom, aperçu, légende et filtre.
2. Révision de la légende (T039, T040) : humeurs de Découvrir seulement, puis légende sur plusieurs lignes sans défilement horizontal.
3. Chaque étape garde les tests précédents verts.

### Historique de livraison

- Première livraison : ciel, liens, légende de genres Kitsu à défilement horizontal, aperçu.
- Deuxième livraison : légende en `Wrap` plafonnée à un tiers d'écran (T040).
- Troisième livraison : genres limités aux humeurs de Découvrir (T039).

---

## Notes

- Aucune tâche n'ajoute de dépendance au `pubspec.yaml`.
- Écarts constitutionnels connus (voir plan.md) : `Image.network` via `AnimePoster` pour l'affiche de l'aperçu (XI) et un fichier de test de 238 lignes (IV). Aucune tâche ne les résorbe ici.
