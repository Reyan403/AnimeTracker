# Contrats d'interface : Constellation

**Feature**: `013-constellation` | **Date**: 2026-10-05

## Écrans et routes

| Élément | Classe | Accès | Cubit |
|---------|--------|-------|-------|
| Carte d'entrée | `ConstellationEntryCard` (`presentation/constellation_entry_card.dart`) | insérée dans `lib/layers/functional/Stats/presentation/stats_view.dart`, entre le contenu des statistiques et l'interrupteur anti-spoil ; visible même sans liste | aucun |
| Page Constellation | `ConstellationPage` (`presentation/constellation_page.dart`) | `ConstellationPage.open(context)`, route `PageRouteBuilder` à fondu (durée `AppMotion.standard` résolue) | `ConstellationCubit` créé par `getIt<ConstellationCubit>()..load()` |
| Fiche de l'anime | `openAnimeSheet` (`Catalogue/presentation/anime_sheet_route.dart`) | bouton « Ouvrir la fiche » de l'aperçu | existant |

## Carte d'entrée

`PopCard` interactive : mini-ciel animé (`MiniSky`, 104 par 84 sur un dégradé `nebula`), titre « Ma constellation », sous-titre « Ta liste d'animes, étoile par étoile », chevron. Un toucher ouvre la page. Sémantique : bouton nommé « Ma constellation ».

## Page

`ConstellationScaffold` : fond `nebula`, `NightSkyBackground` (poussière d'étoiles), puis `ConstellationBody` selon `ConstellationStatus` :

| État | Contenu |
|------|---------|
| `loading` | `ConstellationLoading` : « Les étoiles s'allument… » |
| `empty` | `SkyMessage` : « Ton ciel est encore vide » et invitation à ajouter des animes |
| `failure` | `SkyMessage` : « Le ciel est voilé », message de service indisponible, bouton « Réessayer » (`ConstellationCubit.load`) |
| `success` | en-tête `SkyHeader` (retour, titre), `GenreLegend`, ciel `ConstellationSky` en `Expanded`, aperçu `StarPreviewPanel` |

L'en-tête (bouton « Retour ») est visible dans tous les états.

### Ciel (`ConstellationSky`)

- `InteractiveViewer` : zoom de 1 à 5, déplacement ; `GestureDetector` opaque ; `RepaintBoundary` et `CustomPaint` (`ConstellationPainter`) ; sémantique « Constellation de N anime(s) ».
- Toucher : `StarLayout.hitTest` parmi les étoiles allumées (tolérance 26 plus le rayon) ; toucher une étoile la sélectionne, toucher le vide désélectionne.
- Dessin : étoiles de rayon `3 + 6 * poids`, étincelle pour les animes terminés, liens plus marqués à 2 genres communs ou plus, étoiles et liens atténués (opacité 0,16) hors filtre, anneau pulsé autour de la sélection, étoile filante périodique, couleur de l'humeur via `StarPalette` ou `starGlow` sans humeur.
- Réduction des animations : horloge arrêtée, aucune animation ni étoile filante.

### Légende (`GenreLegend`)

- Reçoit `genres` (`List<EveningMood>`), `selectedSlug`, `onSelected(String?)`.
- Un `Wrap` de `GenreLegendChip` : pastille de couleur de l'humeur, libellé `labelOf(l10n)`, bordure renforcée si sélectionnée ; tout est visible, retour à la ligne, aucun défilement horizontal.
- Hauteur maximale : un tiers de l'écran (`maxHeightFraction`) ; défilement vertical au-delà seulement.
- Toucher une pastille sélectionne l'humeur ; toucher la pastille active retire le filtre. Sémantique : « Filtrer par genre », chaque pastille est un bouton sélectionnable.
- Liste vide : aucune pastille.

### Aperçu (`StarPreviewPanel`, `StarPreviewCard`)

Affiché en bas, centré, largeur maximale `AppSpacing.contentMaxWidth`, avec transition glissée. Contenu : affiche (`AnimePoster`, héros `AnimePoster.heroTagFor('constellation', id)`), titre sur 2 lignes au plus, bouton « Fermer l'aperçu », statut, humeur en `GenreTag`, « Étoile solitaire » ou « Reliée à N animes », bouton « Ouvrir la fiche ».

## Clés de traduction

Préfixe `constellation…` dans `lib/l10n/app_fr.arb` (12 clés) ; libellés d'humeurs `mood…` de l'onglet « Découvrir » ; `serviceUnavailable` et `retry` existants.
