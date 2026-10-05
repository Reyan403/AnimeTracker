# Feature Specification: Animédex et boosters quotidiens

**Created**: 2026-10-05

**Status**: Implemented

**Input**: "Un booster de 5 cartes par jour, des cartes de personnages d'animés réels tirées au hasard avec une rareté, et un Animédex qui garde la collection."

## User Scenarios & Testing *(mandatory)*

### User Story 1 - Ouvrir le booster du jour (Priority: P1)

Chaque jour calendaire, l'utilisateur peut ouvrir un booster de 5 cartes. Chaque carte est un vrai personnage d'anime, issu d'AniList, tiré au hasard parmi les personnages les plus aimés, avec une rareté : commune, rare, épique ou légendaire.

**Why this priority**: c'est le geste quotidien qui fait revenir dans l'application.

**Independent Test**: ouvrir le booster un jour donné : 5 personnages différents apparaissent, puis le booster est indisponible jusqu'au lendemain.

**Acceptance Scenarios**:

1. **Given** aucun booster ouvert aujourd'hui, **When** l'utilisateur ouvre le booster, **Then** 5 personnages distincts sont tirés et chacun est marqué « nouveau » ou « déjà possédé ».
2. **Given** un booster déjà ouvert aujourd'hui, **When** l'utilisateur tente de l'ouvrir de nouveau, **Then** l'ouverture est refusée sans rien tirer.
3. **Given** un booster ouvert hier, **When** le jour calendaire local change, **Then** un nouveau booster est disponible.
4. **Given** AniList injoignable, **When** l'utilisateur ouvre le booster, **Then** aucune carte n'est ajoutée et le jour n'est pas consommé : il peut réessayer.
5. **Given** un tirage qui donne un doublon dans le même booster, **When** le booster s'ouvre, **Then** la carte en double est remplacée par un nouveau tirage.
6. **Given** un tirage partiel (la source répond avec moins de cartes que demandé), **When** au moins une carte a été obtenue, **Then** les cartes manquantes sont retirées, puis le booster s'ouvre avec ce qui a été obtenu.

### User Story 2 - Consulter l'Animédex (Priority: P1)

Les cartes nouvellement obtenues rejoignent l'Animédex, une collection de personnages qui persiste d'une session à l'autre. Le use case de chargement la fournit triée par rareté décroissante, puis par date d'obtention décroissante.

**Why this priority**: sans collection persistante, les cartes n'ont aucune valeur.

**Independent Test**: ouvrir un booster, fermer puis rouvrir l'application : les cartes obtenues sont toujours là, triées.

**Acceptance Scenarios**:

1. **Given** des cartes de raretés différentes, **When** l'Animédex se charge, **Then** les légendaires viennent d'abord, puis les épiques, rares et communes, les plus récentes en premier à rareté égale.
2. **Given** un personnage déjà dans l'Animédex, **When** il est tiré de nouveau, **Then** il n'est pas dupliqué dans la collection.
3. **Given** des données enregistrées corrompues, **When** l'Animédex se charge, **Then** les entrées invalides sont ignorées sans erreur.
4. **Given** une ancienne collection de cartes d'animés (format précédent), **When** l'Animédex se charge, **Then** ces entrées sont ignorées sans erreur et la collection repart vide.
5. **Given** un chargement qui échoue, **When** l'écran s'affiche, **Then** un message d'erreur traduit avec une action « Réessayer » apparaît, sans texte d'exception.

### User Story 3 - Savoir quand revenir (Priority: P2)

L'application indique si le booster du jour est disponible et, sinon, à quel moment le suivant sera prêt : le prochain minuit local, avec un compte à rebours et une indication « Reviens dans N h » ou « N min ».

**Why this priority**: le compte à rebours donne un rendez-vous quotidien.

**Independent Test**: après ouverture, l'heure du prochain booster est minuit local.

**Acceptance Scenarios**:

1. **Given** le booster du jour ouvert, **When** la disponibilité est consultée, **Then** elle est « indisponible » avec le prochain minuit local.
2. **Given** un changement de mois ou d'année, **When** la disponibilité est calculée, **Then** le prochain minuit est correct.
3. **Given** le compte à rebours arrivé à zéro, **When** l'écran est ouvert, **Then** la disponibilité est recalculée et le bouton d'ouverture apparaît.

### User Story 4 - Révéler les cartes (Priority: P2)

L'ouverture se fait sur une page plein écran : un paquet scellé se touche pour s'ouvrir, puis les cartes se révèlent une à une par retournement. Les cartes rares, épiques et légendaires ont un effet holographique et une explosion lumineuse à la révélation. Un récapitulatif indique le nombre de cartes nouvelles et de doublons.

**Why this priority**: c'est ce qui rend le tirage gratifiant ; la logique de tirage reste valable sans lui.

**Independent Test**: ouvrir le paquet, toucher cinq fois : cinq cartes se révèlent, puis le récapitulatif s'affiche.

**Acceptance Scenarios**:

1. **Given** la page du booster, **When** l'utilisateur touche le paquet, **Then** l'ouverture démarre et un état « Ouverture en cours » s'affiche.
2. **Given** un booster tiré, **When** l'utilisateur touche la carte, **Then** la carte suivante se révèle avec son badge « NOUVEAU » ou « Doublon ».
3. **Given** une carte de rareté rare ou supérieure, **When** elle se révèle, **Then** l'effet holographique et l'explosion lumineuse se déclenchent.
4. **Given** toutes les cartes révélées, **When** la dernière apparaît, **Then** le récapitulatif et le bouton « Voir mes cartes » s'affichent.
5. **Given** un booster déjà ouvert aujourd'hui ou un échec réseau, **When** la page s'ouvre ou se rafraîchit, **Then** un message adapté s'affiche (compte à rebours, ou « ton booster n'est pas consommé » avec « Réessayer »).
6. **Given** la réduction des animations activée sur l'appareil, **When** une carte est affichée, **Then** l'effet holographique n'est pas animé.

### User Story 5 - Parcourir la collection (Priority: P2)

L'écran Animédex est scindé en deux onglets : « Booster » (bandeau du booster du jour et dernières cartes obtenues) et « Collection » (tous les personnages). La Collection propose un compteur, la répartition par rareté, une recherche par nom (accents tolérés), des filtres de rareté (Toutes, Commune, Rare, Épique, Légendaire, un seul actif) et un tri (plus récentes, rareté, nom A→Z, plus aimés).

**Why this priority**: une collection qui grossit doit rester navigable.

**Independent Test**: avec une collection variée, taper une partie d'un nom, choisir « Légendaire » puis un tri : la grille ne montre que les cartes correspondantes, dans l'ordre choisi.

**Acceptance Scenarios**:

1. **Given** l'écran Animédex, **When** il s'ouvre, **Then** l'onglet « Booster » est actif et l'onglet « Collection » affiche le nombre de cartes.
2. **Given** des cartes obtenues le même jour, **When** l'onglet « Booster » s'affiche, **Then** « Dernières cartes obtenues » montre les cartes du jour d'obtention le plus récent.
3. **Given** une recherche, **When** l'utilisateur saisit un texte, **Then** seules les cartes dont le nom, le nom natif ou l'anime d'origine le contiennent, sans tenir compte des accents ni de la casse, restent affichées.
4. **Given** un filtre de rareté, **When** l'utilisateur en choisit un, **Then** seules les cartes de cette rareté restent ; choisir « Toutes » rétablit tout.
5. **Given** un tri, **When** l'utilisateur en choisit un, **Then** la grille est ordonnée en conséquence ; à égalité, l'ordre d'origine est conservé.
6. **Given** aucune carte ne correspond, **When** la grille se vide, **Then** un message « Aucun personnage trouvé » propose « Réinitialiser les filtres », qui efface la recherche et la rareté en gardant le tri.
7. **Given** une collection vide, **When** l'onglet « Collection » s'affiche, **Then** une invitation à ouvrir un premier booster apparaît si celui-ci est disponible, sinon l'indication que le prochain arrive bientôt.
8. **Given** un chargement en cours, **When** l'écran s'affiche, **Then** une grille de squelettes apparaît aussitôt.

### User Story 6 - Détail d'une carte (Priority: P3)

Toucher une carte, dans la Collection ou dans les dernières cartes obtenues, ouvre un dialogue qui l'agrandit avec l'effet holographique en continu et détaille le personnage : nom, nom natif, anime d'origine, rareté, nombre de favoris, date d'obtention.

**Why this priority**: un personnage n'a pas de fiche d'anime ; le détail lui en tient lieu.

**Independent Test**: toucher une carte : le dialogue montre ses informations et se ferme par « Fermer ».

**Acceptance Scenarios**:

1. **Given** une carte de la grille, **When** l'utilisateur la touche, **Then** un dialogue affiche la carte agrandie et ses informations.
2. **Given** un personnage sans nom natif ou sans anime d'origine, **When** le dialogue s'ouvre, **Then** ces lignes sont omises.
3. **Given** le dialogue ouvert, **When** l'utilisateur touche « Fermer », **Then** il revient à l'écran précédent.

### Edge Cases

- Le jour est mémorisé au format `yyyy-MM-dd` dans le fuseau local, et seulement quand le tirage a réussi.
- Un personnage sans favoris connus est tiré avec la rareté commune.
- Un personnage sans portrait (image par défaut d'AniList) est conservé sans image ; la carte affiche alors une plaque de repli.
- Le titre de l'anime d'origine est le titre anglais, sinon le titre romaji ; il peut être absent.
- Une requête de tirage plus lente que 4 secondes est abandonnée et le booster est indisponible.
- Les nombres de favoris sont affichés en notation compacte (« 12,3 k »).
- Le choix d'onglet, la recherche, le filtre et le tri ne sont pas persistés : ils repartent de zéro à chaque ouverture de l'écran.

## Requirements *(mandatory)*

### Functional Requirements

- **FR-001**: L'application MUST offrir un booster de 5 cartes par jour calendaire local.
- **FR-002**: Les 5 cartes d'un booster MUST être des personnages distincts.
- **FR-003**: Chaque carte MUST porter une rareté calculée par une règle pure à partir du nombre de favoris du personnage.
- **FR-004**: Les probabilités cibles de tirage MUST être : commune 60 %, rare 28 %, épique 9 %, légendaire 3 %.
- **FR-005**: Les cartes nouvelles MUST être ajoutées à l'Animédex ; un personnage déjà possédé MUST être signalé « déjà possédé » et ne MUST NOT être dupliqué.
- **FR-006**: Le jour MUST être marqué ouvert uniquement après un tirage réussi.
- **FR-007**: L'ouverture MUST échouer avec une exception de domaine nommée si le booster du jour est déjà ouvert (`BoosterAlreadyOpenedException`), ou si AniList est indisponible (`BoosterUnavailableException`).
- **FR-008**: Les personnages d'un tirage MUST être demandés en une seule requête GraphQL (un alias par carte), avec un délai court de 4 secondes.
- **FR-009**: L'Animédex MUST être persistée localement, tolérer des données corrompues et ignorer l'ancien format de cartes d'animés.
- **FR-010**: Le moment de référence et le hasard MUST être injectables pour les tests.
- **FR-011**: L'écran Animédex MUST proposer deux onglets, « Booster » et « Collection », et rendre les états chargement, succès, vide et erreur sans texte d'exception.
- **FR-012**: La Collection MUST offrir une recherche locale insensible aux accents et à la casse sur le nom, le nom natif et l'anime d'origine.
- **FR-013**: La Collection MUST offrir un filtre de rareté à choix unique, avec le nombre de cartes de chaque rareté, et un tri : plus récentes, rareté, nom A→Z, plus aimés ; la recherche, le filtre et le tri MUST s'exécuter localement, sans requête réseau ni use case supplémentaire.
- **FR-014**: Un tri MUST être stable : à critère égal, l'ordre de la collection est conservé.
- **FR-015**: Une carte MUST pouvoir être ouverte dans un dialogue de détail avec l'effet holographique en continu ; les cartes rares et supérieures MUST avoir un effet holographique, désactivé quand la réduction des animations est activée.
- **FR-016**: La page du booster MUST révéler les cartes une à une, signaler chaque carte « nouvelle » ou « doublon » et terminer par un récapitulatif.
- **FR-017**: Tous les textes MUST passer par l'i18n (clés `dex…`).

### Key Entities

- **Carte (DexCard)**: identifiant du personnage, nom, nom natif, rareté, nombre de favoris, date d'obtention, portrait, titre de l'anime d'origine.
- **Carte tirée (DrawnCard)**: une carte et son indicateur « nouvelle ».
- **Disponibilité du booster**: booléen et prochain minuit local.
- **Filtre de collection (DexFilter)**: recherche, rareté facultative, tri.

## Success Criteria *(mandatory)*

- **SC-001**: Un booster s'ouvre en quelques secondes au plus : une seule requête réseau suffit.
- **SC-002**: Sur un grand nombre de tirages, la répartition des raretés reste proche des probabilités cibles.
- **SC-003**: Une panne d'AniList ne consomme jamais le booster du jour.
- **SC-004**: La recherche, le filtre et le tri de la Collection répondent sans attente perceptible, sans appel réseau.

## Assumptions

- Le tirage passe par l'API GraphQL publique d'AniList, sans clé ni compte, parmi les 5000 personnages les plus aimés (profondeur maximale de pagination de l'API), triés par favoris décroissants avec une page d'un personnage par alias.
- Le tirage choisit d'abord une rareté selon les probabilités cibles, puis un rang dans la tranche correspondante : 1 à 60 légendaire, 61 à 300 épique, 301 à 1500 rare, 1501 à 5000 commune. Ces tranches ont été calibrées sur des mesures réelles (rang 60 : ~14 700 favoris, rang 300 : ~5 400, rang 1500 : ~1 080, rang 5000 : ~230).
- La rareté affichée est recalculée à partir des favoris : légendaire dès 14 000, épique dès 5 400, rare dès 1 100, commune en dessous.
- L'API limite le débit (de l'ordre de 30 à 90 requêtes par minute) : un booster coûte une requête, et au plus quelques requêtes de complément en cas de doublons ou de réponse partielle.
- La collection est stockée dans les préférences de l'appareil (JSON) : elle n'est pas synchronisée entre appareils.
- Un personnage n'a pas de fiche d'anime : toucher une carte ouvre un dialogue de détail local, pas une navigation.
