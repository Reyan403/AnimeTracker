# Tasks: Refonte du design moderne et dynamique

**Input**: Design documents from `/specs/001-modern-dynamic-design/`
**Prerequisites**: plan.md, spec.md, research.md, data-model.md, quickstart.md

**Tests**: inclus, la constitution (principe VIII) impose des tests widget et unitaires avec 80 % de couverture des lignes ajoutées.

**Contraintes de la constitution** : aucun commentaire, fichiers < 200 lignes, un widget par fichier (pas de `_buildXxx`), thème lu via `Theme.of(context)`, textes via l10n, aucun changement de cubit, use case ou gateway.

## Format: `[ID] [P?] [Story] Description`

- **[P]** : exécutable en parallèle (fichiers différents, sans dépendance)
- **[Story]** : user story concernée (US1 à US5)

## Phase 1: Setup

- [x] T001 Ajouter `flutter_localizations` (sdk: flutter) et `intl` dans `pubspec.yaml`, activer `generate: true` dans la section `flutter`, puis lancer `flutter pub get`
- [x] T002 Créer `l10n.yaml` à la racine (`arb-dir: lib/l10n`, `template-arb-file: app_fr.arb`, `output-localization-file: app_localizations.dart`)
- [x] T003 [P] Créer `lib/l10n/app_fr.arb` avec les textes actuels des écrans : titres « Ma liste » et « Catalogue », libellés de navigation, statuts, états vide et erreur, « Synopsis », « En bref », « Réessayer », info-bulles et méta (`{count} épisodes`)
- [x] T004 [P] Créer le dossier `test/layers/` et un helper `test/support/pump_app.dart` qui monte un widget dans un `MaterialApp` avec les thèmes et les localisations

## Phase 2: Foundational (bloque toutes les user stories)

- [x] T005 [P] Créer `lib/layers/technical/Theme/app_motion.dart` : durées `fast` 150 ms, `standard` 300 ms, `stagger` 40 ms, courbe d'entrée, et `resolve(context, duration)` qui renvoie `Duration.zero` si `MediaQuery.disableAnimationsOf(context)`
- [x] T006 [P] Créer `lib/layers/technical/Theme/app_palette.dart` : `ThemeExtension` avec `cardSurface`, `posterFallback`, `posterFallbackInk`, `statusColors`, `skeletonBase`, `skeletonHighlight`, variantes claire et sombre, `copyWith` et `lerp`
- [x] T007 Mettre à jour `lib/layers/technical/Theme/app_spacing.dart` : ajouter rayons (`radiusSm`, `radiusMd`, `radiusLg`), tailles de zone tactile (`minTouchTarget` 48), largeur de contenu max 720 et seuil d'écran étendu 840 ; retirer `squareRadius`
- [x] T008 Réécrire `lib/layers/technical/Theme/app_theme.dart` : `AppTheme.light` et `AppTheme.dark` en Material 3 via `ColorScheme.fromSeed`, `AppPalette` en extension, `PageTransitionsTheme` fluide, thèmes de carte, bouton, champ de saisie et barre de navigation
- [x] T009 [P] Test unitaire `test/layers/technical/theme/app_theme_test.dart` : les deux thèmes existent, `AppPalette` est présente, et les paires texte/fond clés atteignent un contraste ≥ 4,5 pour les deux modes
- [x] T010 [P] Test unitaire `test/layers/technical/theme/app_motion_test.dart` : `resolve` renvoie `Duration.zero` quand la réduction des animations est active et la durée donnée sinon
- [x] T011 Mettre à jour `lib/main.dart` : `theme: AppTheme.light`, `darkTheme: AppTheme.dark`, `themeMode: ThemeMode.system`, `localizationsDelegates` et `supportedLocales` ; supprimer l'usage de `AppTheme.editorial`

**Checkpoint**: thèmes, mouvement, palette et l10n disponibles.

## Phase 3: User Story 1 - Identité visuelle moderne, claire et sombre (P1) 🎯 MVP

**Goal**: tous les écrans utilisent le thème unique et restent lisibles en clair et en sombre.
**Independent Test**: parcourir Ma liste, Catalogue et une fiche en mode clair puis sombre, sans couleur illisible.

- [x] T012 [P] [US1] Supprimer `lib/layers/technical/Theme/app_colors.dart` après avoir remplacé tous ses usages par `Theme.of(context).colorScheme` ou `AppPalette` (recherche des références `AppColors` dans `lib/`)
- [x] T013 [P] [US1] Remplacer les couleurs en dur de `lib/layers/technical/Theme/widgets/anime_plaque.dart` par `AppPalette` et un fond arrondi
- [x] T014 [P] [US1] Remplacer les couleurs en dur de `lib/layers/technical/Theme/widgets/skeleton_bar.dart` et `plaque_row_skeleton.dart` par `AppPalette.skeletonBase`
- [x] T015 [P] [US1] Remplacer les couleurs en dur de `lib/layers/functional/Anime/presentation/widgets/watch_status_tabs.dart` et `watch_status_tab.dart` par le thème
- [x] T016 [P] [US1] Remplacer les couleurs en dur de `lib/layers/functional/Catalogue/presentation/widgets/catalogue_row.dart` et `catalogue_search_field.dart` par le thème
- [x] T017 [US1] Test widget `test/layers/technical/theme/theme_modes_test.dart` : un écran de test s'affiche sans erreur dans les deux modes et utilise `colorScheme.surface` comme fond

**Checkpoint**: l'identité est unifiée en clair et sombre ; livrable seul.

## Phase 4: User Story 2 - Navigation et cartes redessinées (P1)

**Goal**: navigation moderne et cartes d'anime centrées sur l'affiche.
**Independent Test**: Ma liste et Catalogue montrent des cartes à affiche dominante ; l'onglet actif est distinct.

- [x] T018 [P] [US2] Réécrire `lib/layers/technical/Theme/widgets/anime_poster.dart` : affiche arrondie (`ClipRRect`), `AspectRatio` de poster, fondu à l'apparition, repli stylé via `AnimePlaque`, `Image.network` et `webHtmlElementStrategy.fallback` conservés
- [x] T019 [P] [US2] Créer `lib/layers/functional/Anime/presentation/widgets/anime_card.dart` : carte de Ma liste (affiche, titre, méta, statut), remplace `anime_row.dart` qui est supprimé
- [x] T020 [P] [US2] Créer `lib/layers/functional/Catalogue/presentation/widgets/catalogue_card.dart` : carte du catalogue (affiche, titre, méta, bouton d'ajout), remplace `catalogue_row.dart` qui est supprimé
- [x] T021 [P] [US2] Redessiner `lib/layers/functional/Anime/presentation/widgets/watch_status_tabs.dart` en segments modernes, zones tactiles ≥ 48 px
- [x] T022 [US2] Redessiner `lib/layers/technical/Navigation/app_navigation_bar.dart` et `app_navigation_item.dart` avec `NavigationBar` Material 3 et indicateur d'onglet actif
- [x] T023 [US2] Extraire de `lib/layers/functional/Catalogue/presentation/catalogue_view.dart` les méthodes privées `_row`, `_results` et `_openSheet` vers des widgets dédiés `catalogue_results.dart` et vers le shell, sans toucher au cubit
- [x] T024 [US2] Brancher `anime_card.dart` et `catalogue_card.dart` dans `lib/layers/functional/Anime/presentation/watchlist_view.dart` et `catalogue_view.dart`
- [x] T025 [P] [US2] Test widget `test/layers/functional/anime/anime_card_test.dart` : titre, méta et statut affichés, affiche de repli sans URL
- [x] T026 [P] [US2] Test widget `test/layers/functional/catalogue/catalogue_card_test.dart` : bouton d'ajout actif puis désactivé quand l'anime est déjà listé
- [x] T027 [P] [US2] Test widget `test/layers/technical/navigation/app_navigation_bar_test.dart` : l'onglet sélectionné est distinct et `onSelected` est appelé au toucher

**Checkpoint**: navigation et cartes redessinées.

## Phase 5: User Story 3 - Animations et micro-interactions (P2)

**Goal**: interface dynamique qui réagit aux actions.
**Independent Test**: ouvrir une fiche, ajouter un anime, changer un statut : animation perceptible sous 1 s.

- [x] T028 [P] [US3] Créer `lib/layers/technical/Theme/widgets/staggered_appear.dart` : fondu + glissement échelonné via `TweenAnimationBuilder`, délai plafonné, durée passée par `AppMotion.resolve`
- [x] T029 [US3] Envelopper les cartes de `watchlist_view.dart` et `catalogue_view.dart` dans `StaggeredAppear` en limitant l'animation aux premiers éléments visibles
- [x] T030 [US3] Ajouter un `Hero` (tag `poster-<id>`) autour de l'affiche dans `anime_poster.dart` et sur `lib/layers/functional/Catalogue/presentation/widgets/anime_sheet_cover.dart` et la fiche
- [x] T031 [US3] Remplacer les `MaterialPageRoute` d'ouverture de fiche par une transition fluide (shell et catalogue) en réutilisant `PageTransitionsTheme`
- [x] T032 [US3] Ajouter un retour visuel d'ajout dans `catalogue_card.dart` (`AnimatedSwitcher` + `AnimatedScale` du bouton, icône « + » vers « ✓ »)
- [x] T033 [US3] Ajouter un retour visuel de changement de statut dans `anime_card.dart` et `watch_status_menu.dart` (transition de la pastille de statut)
- [x] T034 [US3] Animer le changement d'onglet dans `lib/layers/technical/Navigation/app_shell.dart` avec `AnimatedSwitcher` (fondu) au lieu d'un `IndexedStack` brut tout en conservant l'état des vues
- [x] T035 [P] [US3] Test widget `test/layers/technical/theme/staggered_appear_test.dart` : les éléments deviennent visibles après `pumpAndSettle` et apparaissent immédiatement quand la réduction des animations est active
- [x] T036 [P] [US3] Test widget `test/layers/functional/catalogue/add_feedback_test.dart` : le bouton d'ajout passe à l'état « ajouté » avec animation

**Checkpoint**: interface dynamique, animations coupées si demandé.

## Phase 6: User Story 4 - États chargement, vide, erreur (P2)

**Goal**: états soignés et cohérents.
**Independent Test**: provoquer chargement, vide et erreur sur chaque écran.

- [x] T037 [P] [US4] Créer `lib/layers/technical/Theme/widgets/state_message.dart` : message avec icône, titre, description et action optionnelle (vide et erreur)
- [x] T038 [P] [US4] Ajouter un balayage lumineux (shimmer) à `skeleton_bar.dart` et faire reprendre à `plaque_row_skeleton.dart` la forme des nouvelles cartes
- [x] T039 [US4] Réécrire `watchlist_empty.dart`, `watchlist_error.dart`, `catalogue_empty.dart` et `catalogue_error.dart` à partir de `StateMessage`, avec message courant et bouton « Réessayer » pour les erreurs
- [x] T040 Fondu à l apparition des cartes et des états (StaggeredAppear sur les cartes, StateMessage statique) dans watchlist_view.dart, catalogue_view.dart et anime_sheet_view.dart ; pas de AnimatedSwitcher entre états car aucun équivalent sliver n existe dans le framework
- [x] T041 [P] [US4] Test widget `test/layers/technical/theme/state_message_test.dart` : titre, description et action affichés, action appelée au toucher
- [x] T042 [P] [US4] Test widget `test/layers/functional/catalogue/catalogue_states_test.dart` : vide avec et sans recherche, erreur avec « Réessayer »

**Checkpoint**: aucun écran blanc ni message technique.

## Phase 7: User Story 5 - Accessibilité et adaptation mobile et web (P3)

**Goal**: interface confortable, accessible et adaptative.
**Independent Test**: téléphone puis fenêtre large, texte agrandi : rien de coupé.

- [x] T043 [US5] Créer `lib/layers/technical/Navigation/app_navigation_rail.dart` (`NavigationRail`) et adapter `app_shell.dart` : barre basse sous 840 px, rail au-delà
- [x] T044 [US5] Créer `lib/layers/technical/Theme/widgets/content_width.dart` qui borne le contenu à 720 px et centre, utilisé par les trois écrans
- [x] T045 [US5] Afficher le catalogue et Ma liste en grille d'affiches sur écran étendu dans `catalogue_view.dart` et `watchlist_view.dart`
- [x] T046 [US5] Redessiner la fiche `anime_sheet_view.dart` avec en-tête immersif, hiérarchie claire et défilement adapté ; extraire `AnimeSheetBody` dans `lib/layers/functional/Catalogue/presentation/widgets/anime_sheet_body.dart`
- [x] T047 [US5] Vérifier les zones tactiles ≥ 48 px et les `Semantics` des boutons, cartes et onglets dans tous les widgets interactifs modifiés
- [x] T048 [P] [US5] Test widget `test/layers/technical/navigation/app_shell_adaptive_test.dart` : barre basse à 400 px de large, rail à 1000 px
- [x] T049 [P] [US5] Test widget `test/layers/technical/theme/text_scale_test.dart` : cartes et navigation s'affichent sans débordement avec `textScaler` à 2.0

## Phase 8: Polish & transverse

- [x] T050 Migrer vers `AppLocalizations` tous les textes restants des widgets touchés (`anime_sheet_facts.dart`, `watch_status_display.dart`, `watch_status_menu.dart`, `app_destination.dart`) et vérifier qu'aucune chaîne française ne reste dans `lib/layers/**/presentation` et `Navigation`
- [x] T051 Vérifier qu'aucun commentaire, aucun fichier de plus de 200 lignes et aucun `_buildXxx` ne subsiste dans les fichiers modifiés
- [x] T052 Lancer `flutter analyze`, corriger les avertissements, puis `flutter test --coverage` et vérifier ≥ 80 % de couverture des lignes ajoutées
- [ ] T053 Exécuter la validation de quickstart.md sur Chrome (clair, sombre, réduction des animations, texte agrandi, fenêtre large)

## Dependencies & Execution Order

- **Phase 1 → Phase 2 → user stories** : Setup puis Foundational bloquent tout le reste.
- **US1 (P1)** dépend de la Phase 2 seulement ; c'est le MVP.
- **US2 (P1)** dépend de US1 (couleurs du thème) pour le rendu, mais ses fichiers sont distincts.
- **US3 (P2)** dépend de US2 (cartes et affiches à animer).
- **US4 (P2)** dépend de US1 et peut avancer en parallèle de US3.
- **US5 (P3)** dépend de US2 et US3 ; **Polish** vient en dernier.

## Parallel Examples

- Phase 2 : T005, T006, T009 et T010 en parallèle.
- US1 : T012 à T016 touchent des fichiers différents.
- US2 : T018 à T021 en parallèle, puis T025 à T027.
- US4 : T037 et T038 en parallèle.

## Implementation Strategy

1. **MVP** : Phases 1 à 3 (US1) → thèmes clair et sombre unifiés ; commit.
2. **Incrément** : US2, puis US3 et US4, puis US5 ; un commit par user story terminée.
3. Valider chaque checkpoint avec `flutter analyze` et `flutter test` avant de continuer.
