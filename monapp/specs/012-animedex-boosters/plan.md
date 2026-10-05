# Implementation Plan: Animédex et boosters quotidiens

**Branch**: `012-animedex-boosters` | **Date**: 2026-10-05 | **Spec**: [spec.md](spec.md)

**Input**: Feature specification from `/specs/012-animedex-boosters/spec.md`

## Summary

Un booster de 5 cartes de personnages d'animés par jour calendaire local, une collection persistante (l'Animédex) et un écran à deux onglets (Booster, Collection). Les personnages viennent d'AniList : une seule requête GraphQL à cinq alias `Page(page: N, perPage: 1)` tire les cinq cartes, avec un rang choisi dans une tranche propre à chaque rareté (60 % commune, 28 % rare, 9 % épique, 3 % légendaire). La rareté affichée est recalculée par une règle pure à partir des favoris. La collection et le dernier jour d'ouverture sont stockés dans les préférences de l'appareil. L'ouverture est une page plein écran (paquet scellé, retournement des cartes, effet holographique dès la rareté « rare »). La Collection filtre, trie et recherche localement dans le cubit, sans use case supplémentaire.

## Technical Context

**Language/Version**: Dart 3.13 (`sdk: ^3.13.3`), Flutter

**Primary Dependencies**: `flutter_bloc` 9 (cubits), `get_it` 9 (injection), `http` (client AniList existant `AniListClient`), `equatable`, `intl` et `flutter_localizations` (i18n via `lib/l10n/app_fr.arb`, clés `dex…`). Aucune dépendance ajoutée.

**Storage**: `shared_preferences`, par l'abstraction `AppPreferences` et les clés `PreferencesKey.dex` (JSON de la collection) et `PreferencesKey.lastBoosterDay` (jour `yyyy-MM-dd`). Pas de synchronisation entre appareils.

**Testing**: `flutter_test` (unitaires et widget), `MockClient` de `package:http/testing.dart` pour AniList, fakes partagés dans `test/support/animedex_fakes.dart`, helper `pumpApp` de `test/support/pump_app.dart`. 132 cas déclarés dans `test/layers/functional/animedex/` (domain_data_* et ui_*).

**Target Platform**: application Flutter multiplateforme ; validation manuelle sur le site web servi sur le port 5059.

**Project Type**: application mobile et web Flutter, architecture OSDD (couches fonctionnelles et techniques).

**Performance Goals**: un booster = une requête réseau ; aucun appel réseau bloquant pour afficher l'écran (la collection est lue en mémoire) ; un seul `AnimationController` par widget animé, `RepaintBoundary` autour des surfaces animées.

**Constraints**: délai de la requête de tirage 4 s (`AniListBoosterCandidateGateway.defaultTimeout`), plafond du client `AniListClient.timeout` à 10 s ; limite d'AniList de l'ordre de 30 à 90 requêtes par minute ; jour consommé uniquement après un tirage réussi ; respect de `AppMotion.resolve` et de la réduction des animations.

**Scale/Scope**: 5 cartes par jour, collection pouvant atteindre plusieurs centaines de cartes (grille paresseuse), 5000 personnages candidats, 2 cubits, 3 use cases, 3 gateways, 1 règle pure.

## Constitution Check

*GATE: Must pass before Phase 0 research. Re-check after Phase 1 design.*

Constitution v1.0.0. Vérification faite sur le code livré (mesures du 2026-10-05).

| # | Principe | Verdict | Constat |
|---|----------|---------|---------|
| I | Architecture OSDD | Conforme | `lib/layers/functional/Animedex/{domain,data,presentation}` ; infrastructure réutilisée dans `lib/layers/technical/{AniListApi,Preferences,Theme,Injection,Navigation}`. Aucune couche fourre-tout. `TextFolding` et `DexCollectionView` (logique pure de présentation) vivent sous `presentation/cubit/` avec un nom explicite. |
| II | Cubit → use case → contrat | Conforme avec une réserve | `DexCubit(LoadDexUseCase, CheckBoosterAvailabilityUseCase)` et `BoosterCubit(OpenBoosterUseCase)` ne dépendent que de use cases ; chaque use case n'a que `call()` et ne nomme que les contrats abstraits ; contrats, implémentations, use cases et cubits sont dans `injection.dart`. Réserve : recherche, filtre et tri sont des actions utilisateur traitées dans `DexCubit` par la fonction pure `DexCollectionView.apply`, sans use case dédié (décision de périmètre : traitement purement local de présentation, voir research.md R-09). |
| III | Aucun commentaire | Conforme | Recherche `//`, `///` et TODO sur `lib/layers/functional/Animedex` : aucun résultat. |
| IV | Fichiers courts, widgets décomposés | Écart (tests) | Tous les fichiers de `lib` font moins de 200 lignes (maximum : `sealed_pack.dart`, 151). Aucune méthode `_buildXxx`. Un cubit par écran, état découpé (`DexState`, `DexFilter`, `DexCollectionView`, `BoosterState`). Écart : 5 fichiers de test dépassent 200 lignes, `ui_booster_test.dart` (372), `ui_dex_view_test.dart` (228), `domain_data_storage_test.dart` (216), `domain_data_open_booster_test.dart` (204) et `ui_collection_test.dart` (202). |
| V | Thème centralisé | Conforme avec écarts mineurs | Aucune `Color(0x…)` ni `TextStyle(` littérale ; couleurs lues via `AppPalette` (jetons `rarityCommon`, `rarityRare`, `rarityEpic`, `rarityLegendary`, `nebula`, `starGlow`), textes via `Theme.of(context).textTheme`, espacements via `AppSpacing`. Écarts : `Colors.transparent` (5 occurrences) ; quelques dimensions de dessin littérales (`Offset(3, 4)` et flou 8 ou 18 dans `card_face.dart`, bordures de 2,5 dans `dex_tabs.dart`, `dex_sort_menu.dart`, icône de 20) ; constantes de carte locales dans `CardMetrics` (rayon 18, bordure 3, tailles 17 et 11) qui ne sont pas des jetons du thème. |
| VI | Internationalisation | Conforme | 53 clés `dex…` dans `app_fr.arb` ; libellés de rareté, de tri, pluriels et favoris compacts (`dexFavouritesThousands`) traduits ; aucun texte utilisateur en dur ; les `toString()` des exceptions de domaine ne sont jamais affichés. |
| VII | États asynchrones explicites | Conforme | Écran : chargement (`DexSkeletonGrid`), succès, vide (`DexEmptyCollection`), erreur (`DexFailureMessage` avec « Réessayer »), plus « aucun résultat » (`DexNoResults`). Page du booster : `idle`, `opening`, `revealed`, `alreadyOpened`, `failure`. Aucun texte d'exception affiché. |
| VIII | Tests livrés | Conforme | 132 cas déclarés, 220 exécutés avec Constellation (`flutter test … --coverage`, 2026-10-05, tous verts). Couverture des lignes de `lib/layers/functional/Animedex` : 1442 sur 1464, soit 98,5 %, au-dessus du seuil de 80 %. Aucune annotation d'exclusion de couverture. Limite : la couverture lcov ne compte que les fichiers chargés par les tests. |
| IX | Aucun secret | Conforme | API publique sans clé ni compte ; `dart_defines.json` non lu ni modifié. |
| X | Nommage et exceptions | Conforme | Fichiers en `snake_case`, suffixes `Cubit`, `State`, `UseCase`, `Gateway` ; exceptions de domaine nommées `BoosterAlreadyOpenedException` et `BoosterUnavailableException` ; seules ces exceptions sont levées (`throw` recensés). |
| XI | Images distantes | Écart | Les portraits passent par `AnimePoster` (`lib/layers/technical/Theme/widgets/anime_poster.dart`), composant préexistant qui utilise `Image.network` ; `cached_network_image` n'est pas dans `pubspec.yaml`. Un repli (`AnimePlaque`) est bien affiché pendant le chargement et en cas d'échec, mais sans cache disque. |

**Dérogations justifiées** (voir Complexity Tracking) : XI et IV (tests). Le plan est validé avec ces écarts assumés ; ils sont à résorber dans une évolution dédiée.

## Project Structure

### Documentation (this feature)

```text
specs/012-animedex-boosters/
├── spec.md
├── plan.md
├── research.md
├── data-model.md
├── quickstart.md
├── contracts/
│   ├── gateways.md
│   ├── use-cases.md
│   └── ui.md
├── checklists/
│   └── requirements.md
└── tasks.md
```

### Source Code (repository root)

```text
lib/layers/functional/Animedex/
├── domain/
│   ├── entities/        # card_rarity, dex_card, drawn_card, booster_availability
│   ├── gateways/        # booster_candidate_gateway, dex_collection_gateway, booster_schedule_gateway
│   └── use_cases/       # open_booster_use_case, load_dex_use_case, check_booster_availability_use_case, booster_day
├── data/
│   ├── gateways/        # ani_list_booster_candidate_gateway, preferences_dex_collection_gateway, preferences_booster_schedule_gateway
│   ├── models/          # ani_list_character_dto, dex_card_dto
│   └── rules/           # rarity_rule
└── presentation/
    ├── animedex_view.dart
    ├── cubit/           # dex_cubit, dex_state, dex_filter, dex_collection_view, text_folding, booster_cubit, booster_state
    ├── widgets/         # onglets, bandeau, collection (recherche, filtres, tri, grille, états)
    ├── card/            # holographic_card, card_face, holo_shine, rarity_style, tilt_surface…
    ├── booster/         # booster_page, sealed_pack, flip_reveal, rarity_burst, recap_panel…
    └── detail/          # dex_card_dialog, dex_card_details

lib/layers/technical/
├── AniListApi/anilist_client.dart          # existant, réutilisé
├── Injection/injection.dart                # enregistrements get_it
├── Navigation/{app_destination,app_shell}.dart   # 5e destination « Animédex »
├── Preferences/preferences_key.dart        # clés dex et lastBoosterDay
└── Theme/app_palette.dart                  # jetons rarity*, nebula, starGlow

lib/l10n/app_fr.arb                         # clés dex…

test/layers/functional/animedex/            # domain_data_* et ui_*
test/support/animedex_fakes.dart            # fakes et buildDexCard
```

**Structure Decision**: structure OSDD à trois dossiers (domain, data, presentation) sous la couche fonctionnelle `Animedex`, comme `Discover` et `Stats`. Le client HTTP AniList reste dans la couche technique `AniListApi` et est injecté dans le gateway de tirage.

## Complexity Tracking

| Violation | Why Needed | Simpler Alternative Rejected Because |
|-----------|------------|-------------------------------------|
| XI : `Image.network` via `AnimePoster` | Composant partagé préexistant, utilisé par les autres écrans (liste, catalogue, Découvrir, Constellation) ; il fournit déjà la plaque de repli, le fondu et `cacheWidth` | Ajouter `cached_network_image` pour cette seule fonctionnalité créerait deux composants d'image concurrents ; la migration doit se faire d'un coup dans `AnimePoster` (modification de `pubspec.yaml`, réservée) |
| IV : 5 fichiers de test > 200 lignes | Les scénarios d'un même écran ou d'un même gateway partagent leurs fixtures et leur mise en place | Découper en fichiers plus courts dupliquerait la mise en place ; à reprendre en extrayant des groupes dans des fichiers dédiés |
| II : filtre, tri et recherche sans use case | Logique locale pure, sans gateway ni règle métier | Un use case par action déplacerait du code d'affichage vers le domaine sans gain, et rendrait chaque frappe asynchrone |
| V : constantes de dessin de carte | Valeurs propres au rendu holographique (ombre, tilt, rayon) | Les jetons de thème ne couvrent pas ce rendu ; à promouvoir si d'autres cartes en ont besoin |
