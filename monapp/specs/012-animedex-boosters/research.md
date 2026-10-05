# Research: Animédex et boosters quotidiens

**Feature**: `012-animedex-boosters` | **Date**: 2026-10-05

Chaque décision porte sur ce qui a été réellement construit. Aucun point `NEEDS CLARIFICATION` ne subsiste.

## R-01 - Source des cartes : personnages AniList plutôt qu'animés Kitsu

- **Décision** : les cartes sont des personnages issus de l'API GraphQL d'AniList (`https://graphql.anilist.co`), via le client technique existant `AniListClient`.
- **Justification** : une carte à collectionner est plus parlante avec un personnage (portrait, nom, anime d'origine, nombre de favoris). AniList expose le tri `FAVOURITES_DESC` sur `Page.characters`, ce qui donne un classement de popularité exploitable pour la rareté, avec le portrait (`image.large`), le nom (`name.full`, `name.native`) et l'anime le plus populaire du personnage (`media(perPage: 1, sort: POPULARITY_DESC)`). Le client est déjà utilisé par l'agenda des sorties (`Agenda/data/gateways/anilist_release_schedule_gateway.dart`), sans clé ni compte.
- **Alternatives écartées** :
  - **Kitsu, animés** (première version, `KitsuBoosterCandidateGateway`, supprimée) : des animés tirés par offset aléatoire sur `sort=-userCount`, rareté dérivée de `averageRating`, `ratingRank` ou `popularityRank`. Écartée car la demande porte sur des personnages ; la rareté y était moins mesurable et le tirage demandait plusieurs requêtes.
  - **Kitsu, personnages** : Kitsu était déjà intégré (`KitsuApi`), mais AniList donne directement, en une requête, le classement par favoris (`FAVOURITES_DESC`), le nombre de favoris et l'anime d'origine le plus populaire (`media(sort: POPULARITY_DESC)`) ; AniList a donc été retenu sans évaluer la source de personnages de Kitsu.
  - **Jikan (MyAnimeList)** : une API de plus à intégrer, avec un client technique à créer. Non évaluée en détail : AniList a été retenu car son client existait déjà.

## R-02 - Une seule requête avec un alias par carte

- **Décision** : `AniListBoosterCandidateGateway.buildQuery` produit `query { c0: Page(page: N0, perPage: 1) { characters(sort: FAVOURITES_DESC) { … } } c1: … }`, un alias par page choisie. `perPage: 1` rend « page N » équivalent à « rang N » du classement.
- **Justification** : AniList limite le débit (de l'ordre de 30 à 90 requêtes par minute) et un booster doit s'ouvrir en quelques secondes. Cinq requêtes séquentielles ou parallèles coûteraient cinq fois le quota et multiplieraient les risques d'échec ; une requête à alias en coûte une.
- **Alternatives écartées** : cinq requêtes en parallèle (quota consommé cinq fois) ; une page de 50 personnages tirée au hasard (distribution de rareté non maîtrisée, et la profondeur de pagination d'AniList reste de 5000 résultats) ; mise en cache d'un lot de candidats (données périmées, stockage supplémentaire).

## R-03 - Tranches de rang et seuils de rareté mesurés

- **Décision** : le tirage choisit d'abord une rareté selon les probabilités cibles (`RarityRule.roll` : commune 0,60, rare 0,28, épique 0,09, légendaire 0,03), puis un rang dans la tranche de cette rareté (`RarityRule.pageIn`) : légendaire 1 à 60, épique 61 à 300, rare 301 à 1500, commune 1501 à 5000. La rareté affichée est ensuite recalculée à partir des favoris réels (`RarityRule.of`) : légendaire à partir de 14 000 favoris, épique à partir de 5 400, rare à partir de 1 100, commune en dessous.
- **Mesures** (requêtes réelles `Page(page: N, perPage: 1)`, tri par favoris décroissants) :

  | Rang | Favoris | Seuil retenu |
  |------|---------|--------------|
  | 60 | 14 680 | légendaire dès 14 000 |
  | 300 | 5 435 | épique dès 5 400 |
  | 1500 | 1 080 | rare dès 1 100 |
  | 5000 | 229 | commune en dessous de 1 100 |

- **Justification** : les seuils sont arrondis juste sous les valeurs mesurées aux frontières de tranche, de sorte que la rareté d'une carte tirée dans une tranche coïncide avec sa tranche ; la règle `of` est pure et testable, et reste cohérente si les favoris évoluent (la carte est figée avec les favoris du jour du tirage).
- **Alternatives écartées** : seuils fixés sans mesure (écartés, le classement d'AniList est très asymétrique : 14 680 favoris au rang 60, 229 au rang 5000) ; rareté déduite uniquement du rang (le rang n'est pas stocké, la rareté serait invérifiable à partir de la carte) ; tirage uniforme sur les 5000 rangs (1,2 % de légendaires seulement, 60 rangs sur 5000, au lieu des 3 % visés, et 94 % de rares ou de communes).
- **Limite connue** : un rang proche d'une frontière peut donner, après dérive des favoris, une rareté voisine de celle visée ; la rareté affichée fait foi.

## R-04 - Profondeur de 5000 personnages

- **Décision** : le tirage couvre les 5000 premiers personnages par favoris.
- **Justification** : c'est la profondeur maximale de pagination de l'API ; au-delà, AniList ne répond plus de résultats. Le rang 5000 correspond à environ 229 favoris, soit un personnage encore connu.
- **Alternative écartée** : accéder à des rangs plus bas par d'autres tris (écarté, personnages peu connus, cartes sans valeur).

## R-05 - Fiabilité du tirage : doublons, réponses partielles, échec

- **Décision** : `OpenBoosterUseCase` tente jusqu'à 4 fois (`maxAttempts`) de compléter un booster de 5 cartes distinctes, en demandant à chaque tour le nombre de cartes manquantes et en excluant les identifiants déjà obtenus. Il se contente de ce qui a été obtenu si au moins une carte l'a été ; il lève `BoosterUnavailableException` sinon. Le jour n'est marqué qu'après l'ajout des cartes à la collection.
- **Justification** : la collision de deux alias sur la même page (au plus 5 tentatives de placement par alias, `maxPlacementRetries`) ou un alias vide donne moins de 5 cartes ; la reprise couvre ces cas sans perdre le booster. Ne marquer le jour qu'à la fin garantit qu'une panne n'en consomme jamais un (SC-003).
- **Alternatives écartées** : échouer dès qu'il manque une carte (booster perdu pour un alias vide) ; boucle sans limite (risque de dépasser le quota d'AniList) ; marquer le jour avant le tirage (un échec réseau consommerait le booster).

## R-06 - Délai de la requête

- **Décision** : `Future.timeout` de 4 s (`AniListBoosterCandidateGateway.defaultTimeout`) autour de l'appel, toute erreur (réseau, HTTP non 200, JSON invalide, délai) étant convertie en `BoosterUnavailableException`.
- **Justification** : l'ouverture doit rester vive ; le client AniList plafonne à 10 s, trop long pour un geste quotidien. Une erreur de domaine unique évite de faire remonter des exceptions techniques au cubit.
- **Alternative écartée** : relancer automatiquement après un échec (le bouton « Réessayer » de la page fait ce travail sans doubler le trafic).

## R-07 - Stockage dans les préférences, tolérant

- **Décision** : `PreferencesDexCollectionGateway` garde la collection en mémoire (singleton, chargée au premier accès) et réécrit tout le JSON à chaque ajout, sous `PreferencesKey.dex` ; `PreferencesBoosterScheduleGateway` stocke `yyyy-MM-dd` sous `PreferencesKey.lastBoosterDay`. `DexCardDto.fromJson` renvoie `null` pour toute entrée invalide, dont l'ancien format d'animés (clé `animeId` au lieu de `characterId`) ; un contenu qui n'est pas du JSON ou pas une liste donne une collection vide.
- **Justification** : volumes faibles (5 cartes par jour), pas de besoin relationnel ; les préférences existent déjà et sont injectables en test. Le cache mémoire évite de relire le JSON à chaque affichage ; il impose le singleton dans `get_it`.
- **Alternatives écartées** : `sqflite` (disproportionné, non présent dans les dépendances) ; stockage sécurisé (données non sensibles) ; migration de l'ancien format (les cartes d'animés n'ont plus de sens, la collection repart vide, voir spec).

## R-08 - Jour calendaire local et horloge injectable

- **Décision** : `BoosterDay.keyOf` formate l'instant en `yyyy-MM-dd` dans le fuseau local ; `midnightAfter` calcule `DateTime(year, month, day + 1)`, ce qui gère les changements de mois et d'année. Les use cases reçoivent `DateTime Function()? now` et `Random? random`.
- **Justification** : l'attente est « un booster par jour calendaire », pas « toutes les 24 h » ; l'injection rend les tests déterministes (FR-010).
- **Alternative écartée** : délai glissant de 24 h (l'utilisateur ne saurait pas à quelle heure revenir).

## R-09 - Filtre, tri et recherche locaux dans le cubit

- **Décision** : `DexCubit` porte `DexFilter` (recherche, rareté, tri) et calcule les cartes visibles par la fonction pure `DexCollectionView.apply`, avec `TextFolding.fold` pour ignorer accents et casse ; le tri est stable (l'index d'origine départage). Aucun use case ni appel réseau n'est ajouté. Le choix d'onglet est dans `DexState.tab` et n'est pas persisté.
- **Justification** : la collection est déjà en mémoire ; ces opérations n'ont aucune règle métier. Une fonction pure dans le dossier du cubit se teste sans widget.
- **Alternatives écartées** : un use case par action (aucun gain, rend la saisie asynchrone) ; un package de normalisation de texte (dépendance pour 35 remplacements de caractères) ; persister le filtre (non demandé).
- **Écart reconnu** : cette logique de filtrage reste dans la couche présentation (voir plan.md, principe II).

## R-10 - Effet holographique léger

- **Décision** : une seule surface animée par carte (`HolographicCard`, un `AnimationController`, `RepaintBoundary`), animée seulement pour les raretés rare et au-dessus, uniquement quand la carte est « vivante » (dialogue de détail) ou survolée ; une grille de cartes au repos n'anime rien. Inclinaison au toucher et au survol via `TiltSurface`. `MediaQuery.disableAnimationsOf` coupe le mouvement.
- **Justification** : la consigne de performance du site interdit les animations lourdes ; une grille de dizaines de cartes ne doit pas lancer des dizaines de boucles.
- **Alternative écartée** : animer toutes les cartes en permanence (coût de rendu proportionnel à la taille de la collection).

## R-11 - Portraits : `AnimePoster` existant

- **Décision** : les portraits utilisent `AnimePoster` avec `title` égal au nom du personnage ; un personnage sans portrait (URL absente ou image par défaut d'AniList contenant `/default.`) affiche la plaque de repli `AnimePlaque`.
- **Justification** : réutilise le composant commun (fondu, repli, `cacheWidth`).
- **Écart reconnu** : `AnimePoster` utilise `Image.network` et non `cached_network_image` (principe XI). La migration ne relève pas de cette fonctionnalité (voir plan.md, Complexity Tracking).

## R-12 - Révélation en trois étapes

- **Décision** : `BoosterCubit` expose `idle`, `opening`, `revealed`, `alreadyOpened`, `failure` et un compteur `revealedCount` ; la page affiche le paquet, puis chaque carte se retourne au toucher (`FlipReveal`), avec une explosion de particules (`RarityBurst`) pour les raretés holographiques et un plateau de miniatures (`RevealTray`). Les tirages sont mélangés (`shuffle` avec le `Random` injecté) pour que la rareté ne soit pas prévisible par la position.
- **Justification** : donne le suspense du tirage tout en gardant la logique dans le use case. L'état `alreadyOpened` couvre une ouverture tentée alors que le jour est déjà consommé.
- **Alternative écartée** : tout afficher d'un coup (perd l'effet recherché).
