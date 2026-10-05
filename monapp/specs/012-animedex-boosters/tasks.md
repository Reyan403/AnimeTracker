# Tasks: Animédex et boosters quotidiens

**Input**: Design documents from `/specs/012-animedex-boosters/`

**Prerequisites**: plan.md, spec.md, research.md, data-model.md, contracts/ (gateways.md, use-cases.md, ui.md)

**Tests**: livrés avec la fonctionnalité (constitution, principe VIII). Les fichiers de test sont sous `test/layers/functional/animedex/`.

**Organization**: tâches groupées par user story. Toutes sont réalisées (état au 2026-10-05).

## Format: `[ID] [P?] [Story] Description`

- **[P]**: peut s'exécuter en parallèle (fichiers différents, sans dépendance non terminée)
- **[Story]**: user story concernée (US1 à US6)
- Chemins relatifs à `monapp/`. `Animedex/` désigne `lib/layers/functional/Animedex/`.

## Phase 1: Setup (Shared Infrastructure)

**Purpose**: câblage technique commun aux deux fonctionnalités et à l'Animédex

- [X] T001 Ajouter les clés `dex` et `lastBoosterDay` dans `lib/layers/technical/Preferences/preferences_key.dart`
- [X] T002 [P] Ajouter les jetons `rarityCommon`, `rarityRare`, `rarityEpic`, `rarityLegendary`, `nebula` et `starGlow` dans `lib/layers/technical/Theme/app_palette.dart`
- [X] T003 [P] Ajouter la destination `AppDestination.animedex` (libellé `navAnimedex`, icônes `style_outlined` et `style`) dans `lib/layers/technical/Navigation/app_destination.dart` et brancher `AnimedexView` dans `lib/layers/technical/Navigation/app_shell.dart`
- [X] T004 [P] Créer l'arborescence `Animedex/{domain/{entities,gateways,use_cases},data/{gateways,models,rules},presentation/{cubit,widgets,card,booster,detail}}` et les dossiers `test/layers/functional/animedex/` et `test/support/`
- [X] T005 Ajouter les clés `dex…` dans `lib/l10n/app_fr.arb` (53 clés, pluriels et paramètres compris) puis exécuter `flutter gen-l10n`

---

## Phase 2: Foundational (Blocking Prerequisites)

**Purpose**: entités, contrats et règles dont dépendent toutes les user stories

**⚠️ CRITICAL**: aucune user story ne peut commencer avant la fin de cette phase

- [X] T006 [P] Créer l'énumération `CardRarity` dans `Animedex/domain/entities/card_rarity.dart`
- [X] T007 [P] Créer `DexCard` (`characterId`, `name`, `rarity`, `favourites`, `obtainedOn`, `nativeName?`, `imageUrl?`, `animeTitle?`) dans `Animedex/domain/entities/dex_card.dart`
- [X] T008 [P] Créer `DrawnCard` dans `Animedex/domain/entities/drawn_card.dart` et `BoosterAvailability` dans `Animedex/domain/entities/booster_availability.dart`
- [X] T009 [P] Créer le contrat `BoosterCandidateGateway` et `BoosterUnavailableException` dans `Animedex/domain/gateways/booster_candidate_gateway.dart`
- [X] T010 [P] Créer les contrats `DexCollectionGateway` et `BoosterScheduleGateway` dans `Animedex/domain/gateways/dex_collection_gateway.dart` et `Animedex/domain/gateways/booster_schedule_gateway.dart`
- [X] T011 [P] Créer `BoosterDay` (`keyOf`, `midnightAfter`) dans `Animedex/domain/use_cases/booster_day.dart`
- [X] T012 Créer la règle pure `RarityRule` (`of`, `roll`, `pageIn`, seuils 14 000, 5 400 et 1 100, tranches 1 à 60, 61 à 300, 301 à 1500, 1501 à 5000, probabilités 0,60, 0,28, 0,09 et 0,03) dans `Animedex/data/rules/rarity_rule.dart`
- [X] T013 [P] Écrire les tests de la règle de rareté (seuils, probabilités, bornes de tranche, couverture des rangs 1 à 5000) dans `test/layers/functional/animedex/domain_data_rarity_rule_test.dart`
- [X] T014 Créer les fakes `buildDexCard`, `FakeDexCollectionGateway`, `FakeBoosterScheduleGateway` et `FakeBoosterCandidateGateway` dans `test/support/animedex_fakes.dart`

**Checkpoint**: contrats et règle de rareté prêts ; les user stories peuvent démarrer.

---

## Phase 3: User Story 1 - Ouvrir le booster du jour (Priority: P1) 🎯 MVP

**Goal**: tirer 5 personnages distincts depuis AniList, une fois par jour, sans consommer le jour en cas d'échec.

**Independent Test**: avec des fakes, `OpenBoosterUseCase` renvoie 5 cartes distinctes et marque le jour ; un second appel le même jour lève `BoosterAlreadyOpenedException` ; une source indisponible laisse le jour intact.

### Tests for User Story 1

- [X] T015 [P] [US1] Écrire les tests de l'analyse de la réponse (alias vides, image par défaut, titre anglais ou romaji, favoris absents) dans `test/layers/functional/animedex/domain_data_character_dto_test.dart`
- [X] T016 [P] [US1] Écrire les tests du gateway AniList avec `MockClient` (une seule requête à alias, tranches de rang, exclusions, réponse partielle, erreur HTTP, délai de 4 s) dans `test/layers/functional/animedex/domain_data_anilist_gateway_test.dart`, avec `test/layers/functional/animedex/domain_data_anilist_support.dart`
- [X] T017 [P] [US1] Écrire les tests de `OpenBoosterUseCase` (cinq cartes, doublons re-tirés, tirage partiel, jour non marqué en cas d'échec, refus le même jour) dans `test/layers/functional/animedex/domain_data_open_booster_test.dart`

### Implementation for User Story 1

- [X] T018 [P] [US1] Créer `AniListCharacterDto.fromJson` dans `Animedex/data/models/ani_list_character_dto.dart`
- [X] T019 [US1] Créer `AniListBoosterCandidateGateway` (requête unique à un alias par carte, `buildQuery`, délai 4 s, conversion des erreurs en `BoosterUnavailableException`) dans `Animedex/data/gateways/ani_list_booster_candidate_gateway.dart` (dépend de T012, T018)
- [X] T020 [US1] Créer `OpenBoosterUseCase` et `BoosterAlreadyOpenedException` (cinq cartes distinctes, quatre tentatives, mélange, `isNew`, ajout des nouvelles cartes, jour marqué en dernier) dans `Animedex/domain/use_cases/open_booster_use_case.dart` (dépend de T009, T010, T011)

**Checkpoint**: le tirage fonctionne et se teste sans interface.

---

## Phase 4: User Story 2 - Consulter l'Animédex (Priority: P1)

**Goal**: persister la collection, la charger triée et l'afficher, en tolérant les données corrompues et l'ancien format.

**Independent Test**: après un tirage, recréer le gateway sur les mêmes préférences : les cartes sont là, triées par rareté puis récence, sans doublon.

### Tests for User Story 2

- [X] T021 [P] [US2] Écrire les tests du stockage (aller-retour d'une carte, ancien format ignoré, JSON corrompu, entrées invalides écartées, liste non modifiable, persistance après réouverture) dans `test/layers/functional/animedex/domain_data_storage_test.dart`
- [X] T022 [P] [US2] Écrire les tests de `LoadDexUseCase` dans `test/layers/functional/animedex/domain_data_use_cases_test.dart`
- [X] T023 [P] [US2] Écrire les tests de `DexCubit` (chargement initial, vide, tri et comptage par rareté, échec) et de l'onglet Booster (dernières cartes, chargement par squelettes, erreur avec nouvel essai, toucher d'une tuile) dans `test/layers/functional/animedex/ui_dex_view_test.dart`, avec `test/layers/functional/animedex/ui_support.dart`

### Implementation for User Story 2

- [X] T024 [P] [US2] Créer `DexCardDto` (`toJson`, `fromJson` tolérant) dans `Animedex/data/models/dex_card_dto.dart`
- [X] T025 [US2] Créer `PreferencesDexCollectionGateway` (cache mémoire, unicité par `characterId`) dans `Animedex/data/gateways/preferences_dex_collection_gateway.dart` (dépend de T024)
- [X] T026 [P] [US2] Créer `LoadDexUseCase` dans `Animedex/domain/use_cases/load_dex_use_case.dart`
- [X] T027 [P] [US2] Créer `DexState` et `DexFilter` dans `Animedex/presentation/cubit/dex_state.dart` et `Animedex/presentation/cubit/dex_filter.dart`
- [X] T028 [US2] Créer `DexCubit` (`load`, statuts `loading`, `success`, `empty`, `failure`) dans `Animedex/presentation/cubit/dex_cubit.dart` (dépend de T026, T027)
- [X] T029 [P] [US2] Créer `HolographicCard`, `CardFace`, `CardCaption`, `CardFavourites`, `CardRarityLabel`, `RarityStars`, `RarityStyle`, `FavouritesFormat`, `CardMetrics`, `HoloShine`, `TiltSurface` et `SlideGradientTransform` dans `Animedex/presentation/card/`
- [X] T030 [P] [US2] Créer `DexCardTile`, `DexGrid`, `DexSkeletonGrid`, `DexFailureMessage` dans `Animedex/presentation/widgets/`
- [X] T031 [US2] Créer `AnimedexView` et `AnimedexScaffold` dans `Animedex/presentation/animedex_view.dart` (dépend de T028, T030)
- [X] T032 [P] [US2] Écrire les tests de la carte holographique (nom, anime d'origine, reflet selon la rareté, mode vivant, survol, inclinaison, réduction des animations, sémantique) et du format des favoris dans `test/layers/functional/animedex/ui_holographic_card_test.dart`

**Checkpoint**: l'Animédex se charge et se persiste ; US1 et US2 forment le socle fonctionnel.

---

## Phase 5: User Story 3 - Savoir quand revenir (Priority: P2)

**Goal**: indiquer la disponibilité du booster et le prochain minuit local.

**Independent Test**: avec `lastOpenedDay` égal au jour courant, `CheckBoosterAvailabilityUseCase` renvoie « indisponible » et le minuit suivant, y compris à un changement de mois ou d'année.

### Tests for User Story 3

- [X] T033 [P] [US3] Ajouter les tests de `CheckBoosterAvailabilityUseCase` (changement de mois et d'année compris) dans `test/layers/functional/animedex/domain_data_use_cases_test.dart`, et ceux de `CountdownText` et `ComebackHint` dans `test/layers/functional/animedex/ui_dex_view_test.dart`
- [X] T034 [P] [US3] Ajouter les tests du jour mémorisé (`PreferencesBoosterScheduleGateway`) dans `test/layers/functional/animedex/domain_data_storage_test.dart`

### Implementation for User Story 3

- [X] T035 [P] [US3] Créer `PreferencesBoosterScheduleGateway` dans `Animedex/data/gateways/preferences_booster_schedule_gateway.dart`
- [X] T036 [P] [US3] Créer `CheckBoosterAvailabilityUseCase` dans `Animedex/domain/use_cases/check_booster_availability_use_case.dart`
- [X] T037 [P] [US3] Créer `CountdownText` et `ComebackHint` dans `Animedex/presentation/widgets/countdown_text.dart` et `Animedex/presentation/widgets/comeback_hint.dart`
- [X] T038 [US3] Créer `BoosterBanner` (disponible ou compte à rebours, rechargement à zéro) dans `Animedex/presentation/widgets/booster_banner.dart` (dépend de T037)

**Checkpoint**: le rendez-vous quotidien est visible ; US1 à US3 indépendamment testables.

---

## Phase 6: User Story 4 - Révéler les cartes (Priority: P2)

**Goal**: page plein écran d'ouverture : paquet, révélation carte par carte, effet holographique, récapitulatif, états « déjà ouvert » et « échec ».

**Independent Test**: sur `BoosterPage` avec un use case fake, toucher le paquet puis cinq fois la carte : cinq cartes se révèlent, puis le récapitulatif s'affiche.

### Tests for User Story 4

- [X] T039 [P] [US4] Écrire les tests de `BoosterCubit` (tirage, état `opening`, révélation une à une, déjà ouvert, échec puis nouvel essai, reset) et de `BoosterScaffold` (paquet, révélation avec badges et récapitulatif, réduction des animations, déjà ouvert, échec sans consommer, fermeture) dans `test/layers/functional/animedex/ui_booster_test.dart`
- [X] T040 [P] [US4] Écrire le test du parcours complet de l'écran vers la page du booster et retour dans `test/layers/functional/animedex/ui_dex_flow_test.dart`

### Implementation for User Story 4

- [X] T041 [P] [US4] Créer `BoosterState` et `BoosterCubit` (`open`, `reveal`, `reset`) dans `Animedex/presentation/cubit/booster_state.dart` et `Animedex/presentation/cubit/booster_cubit.dart`
- [X] T042 [P] [US4] Créer `SealedPack`, `PackStage`, `CardBack` et `FlipReveal` dans `Animedex/presentation/booster/`
- [X] T043 [P] [US4] Créer `RarityBurst` et `BurstPainter` dans `Animedex/presentation/booster/rarity_burst.dart` et `Animedex/presentation/booster/burst_painter.dart`
- [X] T044 [P] [US4] Créer `RevealCard`, `RevealTray`, `TrayCard`, `DrawnBadge` et `RecapPanel` dans `Animedex/presentation/booster/`
- [X] T045 [US4] Créer `RevealStage`, `AlreadyOpenedPanel`, `BoosterFailurePanel` et `BoosterBody` dans `Animedex/presentation/booster/` (dépend de T041 à T044)
- [X] T046 [US4] Créer `BoosterPage` (`open`, `BoosterScaffold`) dans `Animedex/presentation/booster/booster_page.dart` et `BoosterLauncher` dans `Animedex/presentation/widgets/booster_launcher.dart` (dépend de T045)

**Checkpoint**: le tirage est jouable de bout en bout.

---

## Phase 7: User Story 5 - Parcourir la collection (Priority: P2)

**Goal**: deux onglets, recherche insensible aux accents, filtre de rareté, tri stable, états vide et sans résultat.

**Independent Test**: `DexCollectionView.apply` filtre, recherche et trie sans widget ; sur l'écran, saisir une recherche, choisir « Légendaire » puis un tri donne la grille attendue.

### Tests for User Story 5

- [X] T047 [P] [US5] Écrire les tests du filtre, de la recherche sans accents, des tris et de la stabilité (`DexCollectionView`, `DexFilter`, `DexCubit`) dans `test/layers/functional/animedex/ui_dex_filter_test.dart`
- [X] T048 [P] [US5] Écrire les tests de l'onglet Collection (compteurs, filtres, tri, vide, aucun résultat, réinitialisation) dans `test/layers/functional/animedex/ui_collection_test.dart`

### Implementation for User Story 5

- [X] T049 [P] [US5] Créer `TextFolding` et `DexCollectionView` dans `Animedex/presentation/cubit/text_folding.dart` et `Animedex/presentation/cubit/dex_collection_view.dart`
- [X] T050 [US5] Ajouter `selectTab`, `search`, `selectRarity`, `selectSort` et `resetFilters` à `DexCubit` dans `Animedex/presentation/cubit/dex_cubit.dart` (dépend de T028, T049)
- [X] T051 [P] [US5] Créer `DexTabs` et `DexTabButton` dans `Animedex/presentation/widgets/dex_tabs.dart` et `Animedex/presentation/widgets/dex_tab_button.dart`
- [X] T052 [P] [US5] Créer `DexSearchField`, `DexFilterChip`, `RarityFilterBar` et `DexSortMenu` dans `Animedex/presentation/widgets/`
- [X] T053 [P] [US5] Créer `CollectionSummary`, `RarityCountChip` et `RarityDistributionBar` dans `Animedex/presentation/widgets/`
- [X] T054 [P] [US5] Créer `DexEmptyCollection` et `DexNoResults` dans `Animedex/presentation/widgets/`
- [X] T055 [US5] Créer `CollectionControls`, `CollectionResults`, `CollectionTab` et `BoosterTab` (dernières cartes obtenues) dans `Animedex/presentation/widgets/` et brancher les onglets dans `Animedex/presentation/animedex_view.dart` (dépend de T050 à T054)

**Checkpoint**: la collection est navigable ; US1 à US5 fonctionnent.

---

## Phase 8: User Story 6 - Détail d'une carte (Priority: P3)

**Goal**: dialogue d'agrandissement avec l'effet holographique en continu et le détail du personnage.

**Independent Test**: toucher une carte ouvre le dialogue avec nom, anime d'origine, rareté, favoris et date ; « Fermer » le ferme.

### Tests for User Story 6

- [X] T056 [P] [US6] Écrire les tests du dialogue (champs optionnels omis, fermeture, ouverture depuis la grille) dans `test/layers/functional/animedex/ui_card_dialog_test.dart`

### Implementation for User Story 6

- [X] T057 [P] [US6] Créer `DexCardDetails` dans `Animedex/presentation/detail/dex_card_details.dart`
- [X] T058 [US6] Créer `DexCardDialog` dans `Animedex/presentation/detail/dex_card_dialog.dart` et relier `onCardTap` de `DexGrid` à `DexCardDialog.show` dans `Animedex/presentation/widgets/collection_results.dart` et `Animedex/presentation/widgets/booster_tab.dart` (dépend de T057)

**Checkpoint**: toutes les user stories sont fonctionnelles.

---

## Phase 9: Polish & Cross-Cutting Concerns

**Purpose**: finitions transverses et validation

- [X] T059 Enregistrer les gateways (singletons), les use cases et les cubits (`registerFactory`) dans `lib/layers/technical/Injection/injection.dart`
- [X] T060 [P] Vérifier l'absence de commentaires, de couleurs littérales et de méthodes `_buildXxx` dans `lib/layers/functional/Animedex/`
- [X] T061 [P] Vérifier que chaque fichier de `lib/layers/functional/Animedex/` fait moins de 200 lignes (maximum : 151, `booster/sealed_pack.dart`)
- [X] T062 Exécuter `flutter analyze lib/layers/functional/Animedex test/layers/functional/animedex` : aucun problème
- [X] T063 Exécuter `flutter test test/layers/functional/animedex --coverage` : tous les tests passent, couverture des lignes 98,5 %
- [X] T064 Rédiger `specs/012-animedex-boosters/spec.md` et passer son statut à « Implemented »
- [X] T065 Dérouler les scénarios de `specs/012-animedex-boosters/quickstart.md` sur le site du port 5059

---

## Dependencies & Execution Order

### Phase Dependencies

- **Setup (Phase 1)** : aucune dépendance. T001 à T004 sont indépendants ; T005 est réalisé avant les widgets.
- **Foundational (Phase 2)** : dépend du Setup ; BLOQUE toutes les user stories. T012 avant T013 et T019 ; T014 avant tous les tests qui utilisent les fakes.
- **User stories (Phases 3 à 8)** : dépendent de la phase Foundational.
- **Polish (Phase 9)** : dépend de toutes les user stories.

### User Story Dependencies

- **US1 (P1)** : après Foundational ; aucune dépendance vers les autres stories.
- **US2 (P1)** : après Foundational ; réutilise `DexCard` ; indépendante de US1 pour ses tests (fakes), complémentaire en usage.
- **US3 (P2)** : après Foundational ; indépendante ; `BoosterBanner` est ensuite intégré à l'écran de US2.
- **US4 (P2)** : dépend de US1 (use case d'ouverture) et de US2 (`HolographicCard`).
- **US5 (P2)** : dépend de US2 (`DexCubit`, `DexState`, grille).
- **US6 (P3)** : dépend de US2 (`HolographicCard`) et de US5 (grille de la Collection).

### Within Each User Story

- Les tests sont écrits avec le code qu'ils couvrent (fakes de T014).
- Entités et contrats avant use cases ; use cases avant cubits ; cubits avant écrans.

### Parallel Opportunities

- Setup : T002, T003, T004 en parallèle.
- Foundational : T006 à T011 en parallèle (fichiers distincts).
- US1 : T015, T016, T017 (tests) puis T018 en parallèle de T020.
- US2 : T021 à T023, T024, T026, T027, T029, T030 en parallèle.
- US3 et US4 peuvent avancer en parallèle après US2.
- US5 : T049, T051 à T054 en parallèle.

---

## Parallel Example: User Story 1

```text
Task: "Écrire les tests de l'analyse de la réponse dans test/layers/functional/animedex/domain_data_character_dto_test.dart"
Task: "Écrire les tests du gateway AniList dans test/layers/functional/animedex/domain_data_anilist_gateway_test.dart"
Task: "Écrire les tests de OpenBoosterUseCase dans test/layers/functional/animedex/domain_data_open_booster_test.dart"
Task: "Créer AniListCharacterDto.fromJson dans Animedex/data/models/ani_list_character_dto.dart"
```

## Parallel Example: User Story 5

```text
Task: "Créer TextFolding et DexCollectionView dans Animedex/presentation/cubit/"
Task: "Créer DexTabs et DexTabButton dans Animedex/presentation/widgets/"
Task: "Créer DexSearchField, DexFilterChip, RarityFilterBar et DexSortMenu dans Animedex/presentation/widgets/"
Task: "Créer DexEmptyCollection et DexNoResults dans Animedex/presentation/widgets/"
```

---

## Implementation Strategy

### MVP First (US1 + US2)

1. Phases 1 et 2 : socle.
2. Phase 3 : tirage (US1), vérifié sans interface.
3. Phase 4 : collection persistante (US2), `AnimedexView` minimale.
4. **STOP et valider** : ouvrir un booster, recharger, retrouver les cartes.

### Incremental Delivery

1. Ajouter US3 : compte à rebours et rendez-vous quotidien.
2. Ajouter US4 : cérémonie d'ouverture et effet holographique.
3. Ajouter US5 : onglets, recherche, filtres, tris (c'est la version « personnages + onglet Collection » livrée après la première version à cartes d'animés).
4. Ajouter US6 : détail d'une carte.
5. Chaque story s'appuie sur les précédentes sans casser leurs tests.

### Historique de livraison

- Première livraison : cartes d'animés tirées depuis Kitsu (remplacées depuis).
- Seconde livraison : cartes de personnages AniList, onglets Booster et Collection, dialogue de détail, gateway `AniListBoosterCandidateGateway` à la place de `KitsuBoosterCandidateGateway`.

---

## Notes

- Les tâches de test et d'implémentation d'une même story partagent la même phase pour être livrées ensemble.
- Aucune tâche n'ajoute de dépendance au `pubspec.yaml`.
- Écarts constitutionnels connus (voir plan.md) : `Image.network` via `AnimePoster` (XI) et cinq fichiers de test de plus de 200 lignes (IV). Aucune tâche ne les résorbe ici.
