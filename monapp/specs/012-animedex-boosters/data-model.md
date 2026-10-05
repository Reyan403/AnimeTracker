# Data Model: Animédex et boosters quotidiens

**Feature**: `012-animedex-boosters` | **Date**: 2026-10-05

## Entités du domaine

Sous `lib/layers/functional/Animedex/domain/entities/`. Toutes sont immuables et comparées par valeur (`Equatable`).

### CardRarity (`card_rarity.dart`)

Énumération ordonnée de la plus faible à la plus forte : `common`, `rare`, `epic`, `legendary`. L'`index` sert au tri par rareté et au nombre d'étoiles affiché (`index + 1`).

### DexCard (`dex_card.dart`)

Un personnage collectionné.

| Champ | Type | Obligatoire | Règle |
|-------|------|-------------|-------|
| `characterId` | `int` | oui | identifiant AniList du personnage, clé d'unicité dans la collection |
| `name` | `String` | oui | nom complet (`name.full`), non vide après `trim` |
| `rarity` | `CardRarity` | oui | calculée par `RarityRule.of(favourites)` au tirage, puis figée |
| `favourites` | `int` | oui | nombre de favoris au moment du tirage ; 0 si inconnu |
| `obtainedOn` | `DateTime` | oui | instant du tirage (horloge injectable) |
| `nativeName` | `String?` | non | nom natif (`name.native`) |
| `imageUrl` | `String?` | non | `image.large` ; `null` si absent ou si l'URL contient `/default.` |
| `animeTitle` | `String?` | non | titre anglais de l'anime le plus populaire du personnage, sinon romaji |

### DrawnCard (`drawn_card.dart`)

Résultat d'un tirage : `card` (`DexCard`) et `isNew` (`bool`), vrai si le personnage n'était pas déjà dans la collection au moment de l'ouverture.

### BoosterAvailability (`booster_availability.dart`)

`isAvailable` (`bool`) : vrai si `lastOpenedDay` diffère du jour local courant ; `nextAt` (`DateTime`) : prochain minuit local.

## Règles et transitions

- **Tirage** : 5 cartes distinctes (`OpenBoosterUseCase.boosterSize`), 4 tentatives au plus (`maxAttempts`) pour compléter. Les identifiants déjà obtenus dans le tirage sont exclus des tentatives suivantes.
- **Ouverture** : `lastOpenedDay == jour courant` donne `BoosterAlreadyOpenedException` sans appel au gateway de tirage. Sinon : tirage, mélange des cartes, calcul de `isNew`, ajout des seules nouvelles cartes à la collection, puis `markOpened(jour)`. Un échec de tirage ne marque pas le jour.
- **Unicité** : la collection ne contient jamais deux cartes de même `characterId` ; la première carte obtenue est conservée, un doublon ultérieur est signalé mais n'est pas réécrit.
- **Tri de chargement** : `LoadDexUseCase` renvoie une copie triée par `rarity.index` décroissant, puis `obtainedOn` décroissant.

### Règle de rareté (`data/rules/rarity_rule.dart`)

| Rareté | Probabilité cible | Tranche de rang (inclusive) | Favoris |
|--------|------------------|-----------------------------|---------|
| légendaire | 3 % | 1 à 60 | 14 000 et plus |
| épique | 9 % | 61 à 300 | 5 400 à 13 999 |
| rare | 28 % | 301 à 1500 | 1 100 à 5 399 |
| commune | 60 % | 1501 à 5000 | moins de 1 100 |

`RarityRule.of(int)`, `RarityRule.roll(Random)` et `RarityRule.pageIn(CardRarity, Random)` sont des fonctions pures. `probabilities` totalise 1.

## Modèles de données (couche data)

### Stockage de la collection (`DexCardDto`)

Clé `PreferencesKey.dex`, valeur : tableau JSON d'objets.

| Clé JSON | Type | Remarque |
|----------|------|----------|
| `characterId` | entier | entrée ignorée si absent ou non entier (ancien format d'animés : clé `animeId`) |
| `name` | texte | entrée ignorée si absent ou non texte |
| `native` | texte ou null | |
| `rarity` | texte | nom de l'énumération ; entrée ignorée si inconnu |
| `favourites` | entier | 0 si absent ou invalide |
| `obtainedOn` | texte ISO 8601 | entrée ignorée si non analysable |
| `image` | texte ou null | |
| `anime` | texte ou null | |

Un contenu qui n'est pas du JSON (`FormatException`) ou pas une liste donne une collection vide.

### Stockage du jour (`PreferencesBoosterScheduleGateway`)

Clé `PreferencesKey.lastBoosterDay`, valeur : texte `yyyy-MM-dd` en fuseau local.

### Réponse AniList (`AniListCharacterDto`)

Entrée : `{"data": {"c0": {"characters": [ {id, name{full, native}, image{large}, favourites, media{nodes[{title{romaji, english}}]}} ]}, "c1": …}}`. Chaque alias donne au plus une carte ; les alias vides, mal formés ou sans identifiant entier ni nom sont ignorés.

## Modèle de présentation

Sous `presentation/cubit/`.

### DexState

| Champ | Type | Valeur initiale |
|-------|------|-----------------|
| `status` | `DexStatus` : `loading`, `success`, `empty`, `failure` | `loading` |
| `cards` | `List<DexCard>` | vide |
| `availability` | `BoosterAvailability?` | `null` |
| `tab` | `DexTab` : `booster`, `collection` | `booster` |
| `filter` | `DexFilter` | `DexFilter()` |

Dérivés : `isBoosterAvailable`, `countOf(rarity)`, `visibleCards` (filtre, recherche et tri appliqués), `latestCards` (cartes du jour d'obtention le plus récent).

### DexFilter

| Champ | Type | Valeur initiale |
|-------|------|-----------------|
| `query` | `String` | vide |
| `rarity` | `CardRarity?` | `null` (toutes) |
| `sort` | `DexSort` : `recent`, `rarity`, `name`, `favourites` | `recent` |

`isActive` est vrai si la recherche (après `trim`) n'est pas vide ou si une rareté est choisie. `cleared` efface recherche et rareté en gardant le tri.

### BoosterState

| Champ | Type | Valeur initiale |
|-------|------|-----------------|
| `status` | `BoosterStatus` : `idle`, `opening`, `revealed`, `alreadyOpened`, `failure` | `idle` |
| `cards` | `List<DrawnCard>` | vide |
| `revealedCount` | `int` | 0 |

Dérivés : `isComplete` (cartes non vides et toutes révélées), `newCount`, `duplicateCount`, `current` (dernière carte révélée).

## Relations

```text
DrawnCard 1 ── 1 DexCard
DexCollectionGateway 1 ── * DexCard        (unicité par characterId)
BoosterScheduleGateway 1 ── 0..1 jour      (yyyy-MM-dd)
DexState 1 ── * DexCard, 1 ── 1 DexFilter, 0..1 BoosterAvailability
BoosterState 1 ── * DrawnCard
```
