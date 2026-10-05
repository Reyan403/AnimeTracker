# Implementation Plan: Refonte du design moderne et dynamique

**Branch**: `001-modern-dynamic-design` | **Date**: 2026-10-05 | **Spec**: [spec.md](spec.md)

**Input**: Feature specification from `/specs/001-modern-dynamic-design/spec.md`

## Summary

Refondre la couche visuelle de monapp (Ma liste, Catalogue, fiche anime) sans toucher à la
logique métier : un thème Material 3 clair et sombre centralisé dans la couche technique
`Theme`, des cartes d'anime centrées sur l'affiche, une navigation adaptative (barre basse sur
mobile, rail latéral sur écran large), des animations natives Flutter (Hero, transitions de
page, apparition échelonnée, retours visuels) qui respectent la réduction des animations, et des
états chargement/vide/erreur redessinés. Aucune nouvelle dépendance visuelle : tout repose sur
les API du framework (`ColorScheme.fromSeed`, `ThemeExtension`, `Hero`, `AnimatedSwitcher`,
`TweenAnimationBuilder`). L'internationalisation est ajoutée pour les textes des écrans touchés.

## Technical Context

**Language/Version**: Dart ^3.13.3, Flutter (SDK du dossier `flutter` local, canal stable)

**Primary Dependencies**: flutter_bloc 9, get_it 9, equatable, http ; ajout de
`flutter_localizations` (SDK) et `intl` pour l'i18n

**Storage**: N/A (liste en mémoire, inchangée)

**Testing**: `flutter_test` (tests widget et unitaires) ; aucun test n'existe aujourd'hui

**Target Platform**: mobile (Android, iOS) et web ; Windows desktop non buildable sur cette
machine (toolchain Visual Studio absente)

**Project Type**: mobile-app Flutter organisée en couches OSDD (`lib/layers/technical`,
`lib/layers/functional`)

**Performance Goals**: 60 fps pendant les animations, chaque animation sous 1 s, aucun
saccade perceptible au défilement des listes

**Constraints**: aucun changement de cubit, de use case, de gateway ni de source de données ;
animations coupées si `MediaQuery.disableAnimations` ; zones tactiles ≥ 48 px ; contraste AA

**Scale/Scope**: 3 écrans, 2 onglets, ~25 fichiers de présentation et de thème concernés

## Constitution Check

*GATE: Must pass before Phase 0 research. Re-check after Phase 1 design.*

| Principe | Statut | Note |
|----------|--------|------|
| I. OSDD | Conforme | tout reste dans `technical/Theme`, `technical/Navigation` et les `presentation/` fonctionnelles ; aucune couche fourre-tout |
| II. Cubit → use case → gateway | Conforme | aucun cubit, use case ni gateway modifié |
| III. Aucun commentaire | Conforme | nouveau code sans commentaire |
| IV. Fichiers courts, widgets décomposés | Conforme | chaque widget dans son fichier ; les méthodes privées `_row`, `_results`, `_openSheet` des vues sont extraites en widgets |
| V. Thème centralisé | Conforme | `AppColors`/`AppSpacing` codés en dur dans les widgets remplacés par `Theme.of(context)` et une `ThemeExtension` |
| VI. i18n | Conforme après travail | les textes français en dur des écrans touchés migrent vers ARB (`fr`) |
| VII. États asynchrones | Conforme | quatre états déjà gérés par les cubits, redessinés |
| VIII. Tests | Conforme après travail | tests widget ajoutés pour chaque nouveau widget ; cible 80 % des lignes ajoutées |
| IX. Aucun secret | Conforme | non concerné |
| X. Nommage et exceptions | Conforme | aucune exception générique introduite |
| XI. Images distantes | Dérogation | voir Complexity Tracking |

Re-check après Phase 1 : aucune nouvelle violation ; une seule dérogation justifiée.

## Project Structure

### Documentation (this feature)

```text
specs/001-modern-dynamic-design/
├── plan.md
├── research.md
├── data-model.md
├── quickstart.md
└── tasks.md             # créé par /speckit-tasks
```

Pas de dossier `contracts/` : la refonte n'expose aucune interface externe.

### Source Code (repository root)

```text
lib/
├── main.dart                                   # thèmes clair/sombre, themeMode système, l10n
├── l10n/
│   └── app_fr.arb                              # textes des écrans (nouveau)
└── layers/
    ├── technical/
    │   ├── Theme/
    │   │   ├── app_theme.dart                  # light + dark, Material 3, transitions de page
    │   │   ├── app_palette.dart                # ThemeExtension : surfaces, accents, états (nouveau)
    │   │   ├── app_spacing.dart                # espacements, rayons, durées
    │   │   ├── app_motion.dart                 # durées, courbes, respect de la réduction (nouveau)
    │   │   └── widgets/
    │   │       ├── anime_poster.dart           # affiche arrondie, Hero, visuel de repli
    │   │       ├── anime_plaque.dart           # repli stylé
    │   │       ├── skeleton_bar.dart           # shimmer
    │   │       ├── plaque_row_skeleton.dart    # squelette de carte
    │   │       ├── staggered_appear.dart       # apparition échelonnée (nouveau)
    │   │       └── state_message.dart          # vide/erreur illustrés (nouveau)
    │   └── Navigation/
    │       ├── app_shell.dart                  # NavigationBar ou NavigationRail selon la largeur
    │       ├── app_navigation_bar.dart
    │       └── app_navigation_rail.dart        # (nouveau)
    └── functional/
        ├── Anime/presentation/                 # cartes de liste, onglets de statut, états
        └── Catalogue/presentation/             # cartes, recherche, fiche avec héros

test/
└── layers/                                     # tests widget miroirs de lib/layers
```

**Structure Decision**: structure OSDD existante conservée ; le design vit dans
`technical/Theme` et `technical/Navigation`, les cartes et états dans les `presentation/`
fonctionnelles.

## Complexity Tracking

| Violation | Why Needed | Simpler Alternative Rejected Because |
|-----------|------------|-------------------------------------|
| Principe XI : `Image.network` conservé dans `AnimePoster` | il utilise `webHtmlElementStrategy.fallback`, nécessaire pour afficher les affiches sur le web quand l'hôte d'images n'envoie pas d'en-têtes CORS | `cached_network_image` n'expose pas cette stratégie ; le remplacer casserait les affiches sur le web. Le placeholder et le repli d'erreur exigés par le principe sont conservés |
