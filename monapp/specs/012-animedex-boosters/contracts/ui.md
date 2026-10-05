# Contrats d'interface : Animédex

**Feature**: `012-animedex-boosters` | **Date**: 2026-10-05

## Écrans et routes

| Écran | Classe | Accès | Cubit |
|-------|--------|-------|-------|
| Animédex (deux onglets) | `AnimedexView` (`presentation/animedex_view.dart`) | destination `AppDestination.animedex` de la navigation (`app_shell.dart`), onglet du `IndexedStack` | `DexCubit` créé par `getIt<DexCubit>()..load()` |
| Booster (plein écran) | `BoosterPage` (`presentation/booster/booster_page.dart`) | `BoosterPage.open(context)`, route `MaterialPageRoute` en `fullscreenDialog` | `BoosterCubit` créé par `getIt<BoosterCubit>()` |
| Détail d'une carte | `DexCardDialog` (`presentation/detail/dex_card_dialog.dart`) | `DexCardDialog.show(context, card)`, `showDialog` | aucun |

`BoosterLauncher.open(context)` (`widgets/booster_launcher.dart`) ouvre la page du booster puis relance `DexCubit.load()` au retour.

## Écran Animédex

Un `CustomScrollView` : titre (`PopTitle`), onglets (`DexTabs`, deux `DexTabButton` dont « Collection » porte le nombre de cartes), puis l'onglet actif.

### Onglet Booster (`BoosterTab`)

- Bandeau `BoosterBanner` : disponible (icône, « Ton booster du jour est prêt ! », bouton « Ouvrir ») ou indisponible (« Prochain booster dans », `CountdownText`, `ComebackHint` « Reviens dans N h » ou « N min »). À zéro, le bandeau déclenche `DexCubit.load`.
- États : chargement (`DexSkeletonGrid`), erreur (`DexFailureMessage` avec « Réessayer »), succès avec « Dernières cartes obtenues » (`DexGrid` des `latestCards`).

### Onglet Collection (`CollectionTab`)

| État | Contenu |
|------|---------|
| chargement | `DexSkeletonGrid` |
| erreur | `DexFailureMessage` + « Réessayer » (`DexCubit.load`) |
| vide | `DexEmptyCollection` : invitation ; bouton « Ouvrir mon premier booster » si le booster est disponible, sinon « Ton prochain booster arrive bientôt. » |
| succès | `CollectionControls` puis `DexGrid`, ou `DexNoResults` si aucune carte ne correspond |

`CollectionControls` : `CollectionSummary` (compteur, `RarityDistributionBar`, `RarityCountChip`), `DexSearchField` (avec effacement), `RarityFilterBar` (Toutes, Commune, Rare, Épique, Légendaire, avec compteurs, un seul actif), compteur de résultats (« N personnages ») et `DexSortMenu` (Plus récentes, Rareté, Nom A → Z, Plus aimés).

Interactions du cubit : `selectTab(DexTab)`, `search(String)`, `selectRarity(CardRarity?)`, `selectSort(DexSort)`, `resetFilters()`, `load()`.

Toucher une tuile (`DexCardTile`) ouvre `DexCardDialog`.

## Page du booster

`BoosterBody` choisit la scène selon `BoosterStatus`, avec une transition animée :

| Statut | Scène |
|--------|-------|
| `idle`, `opening` | `PackStage` : paquet scellé (`SealedPack`), « Touche le paquet pour l'ouvrir », puis « Ouverture en cours… » |
| `revealed` | `RevealStage` : progression « n / 5 », carte retournable (`RevealCard`, `FlipReveal`), badge `DrawnBadge` « NOUVEAU » ou « Doublon », explosion `RarityBurst` pour les raretés holographiques, plateau `RevealTray` ; une fois tout révélé, `RecapPanel` (« Récap du booster », nombre de nouvelles cartes et de doublons, « Voir mes cartes ») |
| `alreadyOpened` | `AlreadyOpenedPanel` : « Booster déjà ouvert aujourd'hui », compte à rebours, « Voir mes cartes » ; à zéro, retour à `idle` |
| `failure` | `BoosterFailurePanel` : « Le booster n'a pas pu être tiré », « Ton booster n'est pas consommé… », « Réessayer » |

Un bouton de fermeture (info-bulle « Fermer ») est toujours présent en haut à gauche. Les interactions du cubit sont `open()` (ignoré pendant `opening`), `reveal()` et `reset()`. Un retour haptique léger accompagne chaque révélation.

## Carte

`HolographicCard(card, {isLive, compact})` : surface au ratio 0,68, `CardFace` (portrait plein cadre via `AnimePoster`, étiquette de rareté, favoris compacts, légende avec nom, anime d'origine et étoiles), `HoloShine` pour les raretés rare et au-dessus, `TiltSurface` (inclinaison au toucher si `isLive`, au survol sinon). Étiquette d'accessibilité : « {nom}, carte {rareté} ».

## Clés de traduction

Préfixe `dex…` dans `lib/l10n/app_fr.arb` (53 clés : titre, onglets, recherche, filtres, tris, états, détails, booster, récapitulatif, raretés).
