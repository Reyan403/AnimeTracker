# Data Model: Refonte du design moderne et dynamique

Aucune donnée métier n'est ajoutée ni modifiée : entités, DTO, cubits et use cases restent
identiques. Seuls des modèles de présentation sont introduits.

## AppPalette (ThemeExtension, couche `technical/Theme`)

Tokens non couverts par `ColorScheme`, déclinés en variantes claire et sombre.

| Champ | Rôle |
|-------|------|
| `cardSurface` | fond d'une carte d'anime |
| `posterFallback` | fond du visuel de repli d'une affiche |
| `posterFallbackInk` | initiales sur le visuel de repli |
| `statusColors` | une couleur par statut de visionnage (à voir, en cours, terminé, abandonné) |
| `skeletonBase` / `skeletonHighlight` | dégradé du squelette de chargement |

Règle : chaque couple texte/fond utilisé atteint un contraste AA dans les deux variantes.

## AppMotion (couche `technical/Theme`)

| Champ | Rôle |
|-------|------|
| `fast` | retours visuels (≈ 150 ms) |
| `standard` | transitions (≈ 300 ms) |
| `stagger` | délai entre deux éléments d'une liste (≈ 40 ms, plafonné) |
| `curve` | courbe d'entrée commune |
| `resolve(context, duration)` | renvoie `Duration.zero` si la réduction des animations est active |

## Largeurs d'écran

| Classe | Seuil | Mise en page |
|--------|-------|--------------|
| compacte | < 840 px | barre de navigation basse, liste verticale |
| étendue | ≥ 840 px | rail de navigation latéral, grille d'affiches, contenu borné |

## État d'écran (inchangé)

`ViewStatus` / `CatalogueStatus` / `AnimeSheetStatus` existants : chargement, succès, vide,
échec. La refonte ne change que leur rendu.
