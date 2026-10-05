# Research: Refonte du design moderne et dynamique

## Thème clair et sombre

- **Decision**: Material 3 avec `ColorScheme.fromSeed` (une couleur d'amorce pour le clair, la même pour le sombre via `brightness`), complété par une `ThemeExtension` (`AppPalette`) pour les tokens que `ColorScheme` ne couvre pas (surface des cartes, repli d'affiche, couleurs d'état de visionnage).
- **Rationale**: génère automatiquement des paires contrastées conformes AA, et `Theme.of(context)` reste l'unique source lue par les widgets (principe V).
- **Alternatives considered**: palette codée à la main dans `AppColors` (contrastes à vérifier un par un, déjà source de couleurs en dur) ; package de thème tiers (dépendance inutile).

## Typographie

- **Decision**: police sans-serif par défaut de la plateforme pour le corps et les titres, `SourceSerif` conservée uniquement pour les grands titres d'écran afin de garder une signature.
- **Rationale**: aucune nouvelle dépendance ni asset ; hiérarchie obtenue par les échelles `TextTheme` Material 3.
- **Alternatives considered**: `google_fonts` (téléchargement réseau au premier affichage, fonctionne mal hors ligne) ; embarquer une nouvelle police (poids d'assets pour peu de gain).

## Animations

- **Decision**: uniquement des API du framework : `PageTransitionsTheme` (transition de page fluide), `Hero` sur l'affiche, `AnimatedSwitcher` pour les changements d'état, `TweenAnimationBuilder` pour l'apparition échelonnée, `AnimatedScale`/`AnimatedSwitcher` pour le retour d'ajout et de changement de statut.
- **Rationale**: pas de dépendance, performances maîtrisées, testables avec `pumpAndSettle`.
- **Alternatives considered**: `flutter_animate` ou `animations` (dépendances de plus pour des effets réalisables nativement) ; Rive/Lottie (assets lourds).

## Réduction des animations

- **Decision**: un helper `AppMotion` lit `MediaQuery.disableAnimationsOf(context)` et renvoie une durée nulle ; tous les widgets animés passent par lui.
- **Rationale**: un seul point de contrôle garantit FR-013 sur toutes les animations décoratives.
- **Alternatives considered**: vérifier dans chaque widget (oubli probable).

## Navigation adaptative

- **Decision**: `NavigationBar` en dessous de 840 px de largeur, `NavigationRail` au-delà ; contenu des listes limité à une largeur maximale lisible (≈ 720 px) et affichage en grille d'affiches sur écran large.
- **Rationale**: suit les points de rupture Material 3 et couvre FR-005 et FR-017 sans package.
- **Alternatives considered**: barre basse partout (étirée et peu lisible sur le web) ; `flutter_adaptive_scaffold` (dépendance).

## Internationalisation

- **Decision**: `flutter_localizations` + `intl` avec génération native (`l10n.yaml`, `lib/l10n/app_fr.arb`), appliquée aux textes des écrans retouchés.
- **Rationale**: exigée par la constitution ; l'app n'a aujourd'hui que des chaînes françaises en dur.
- **Alternatives considered**: classe `AppStrings` de constantes (n'est pas de l'i18n) ; reporter l'i18n (viole le principe VI sur du code réécrit).

## Images distantes

- **Decision**: conserver `Image.network` avec `webHtmlElementStrategy.fallback`, en ajoutant arrondis, fondu à l'apparition et repli stylé.
- **Rationale**: voir Complexity Tracking du plan (compatibilité web/CORS).
- **Alternatives considered**: `cached_network_image` (conforme au principe XI mais risque d'affiches absentes sur le web).

## Tests

- **Decision**: tests widget par composant (carte, navigation adaptative, états, apparition échelonnée, réduction des animations) avec `flutter_test`, et un test de thème qui vérifie les contrastes des paires clés.
- **Rationale**: aucun test n'existe ; la constitution exige 80 % de couverture sur les lignes ajoutées.
- **Alternatives considered**: tests de capture d'écran (golden), fragiles entre plateformes.
