# Feature Specification: Animédex et boosters quotidiens

**Created**: 2026-10-05

**Status**: Implemented

**Input**: "Un booster de 5 cartes par jour, des cartes de personnages d'animés réels tirées au hasard avec une rareté, et un Animédex qui garde la collection."

## User Scenarios & Testing *(mandatory)*

### User Story 1 - Ouvrir le booster du jour (Priority: P1)

Chaque jour calendaire, l'utilisateur peut ouvrir un booster de 5 cartes. Chaque carte est un vrai personnage d'anime tiré au hasard parmi les personnages les plus aimés, avec une rareté : commune, rare, épique ou légendaire.

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

Les cartes nouvellement obtenues rejoignent l'Animédex, une collection de personnages qui persiste d'une session à l'autre. Elle est triée par rareté décroissante, puis par date d'obtention décroissante.

**Why this priority**: sans collection persistante, les cartes n'ont aucune valeur.

**Independent Test**: ouvrir un booster, fermer puis rouvrir l'application : les cartes obtenues sont toujours là, triées.

**Acceptance Scenarios**:

1. **Given** des cartes de raretés différentes, **When** l'Animédex se charge, **Then** les légendaires viennent d'abord, puis les épiques, rares et communes, les plus récentes en premier à rareté égale.
2. **Given** un personnage déjà dans l'Animédex, **When** il est tiré de nouveau, **Then** il n'est pas dupliqué dans la collection.
3. **Given** des données enregistrées corrompues, **When** l'Animédex se charge, **Then** les entrées invalides sont ignorées sans erreur.
4. **Given** une ancienne collection de cartes d'animés (format précédent), **When** l'Animédex se charge, **Then** ces entrées sont ignorées sans erreur et la collection repart vide.

### User Story 3 - Savoir quand revenir (Priority: P2)

L'application indique si le booster du jour est disponible et, sinon, à quel moment le suivant sera prêt : le prochain minuit local.

**Why this priority**: le compte à rebours donne un rendez-vous quotidien.

**Independent Test**: après ouverture, l'heure du prochain booster est minuit local.

**Acceptance Scenarios**:

1. **Given** le booster du jour ouvert, **When** la disponibilité est consultée, **Then** elle est « indisponible » avec le prochain minuit local.
2. **Given** un changement de mois ou d'année, **When** la disponibilité est calculée, **Then** le prochain minuit est correct.

### Edge Cases

- Le jour est mémorisé au format `yyyy-MM-dd` dans le fuseau local, et seulement quand le tirage a réussi.
- Un personnage sans favoris connus est tiré avec la rareté commune.
- Un personnage sans portrait (image par défaut d'AniList) est conservé sans image.
- Le titre de l'anime d'origine est le titre anglais, sinon le titre romaji ; il peut être absent.
- Une requête de tirage plus lente que 4 secondes est abandonnée et le booster est indisponible.

## Requirements *(mandatory)*

### Functional Requirements

- **FR-001**: L'application MUST offrir un booster de 5 cartes par jour calendaire local.
- **FR-002**: Les 5 cartes d'un booster MUST être des personnages distincts.
- **FR-003**: Chaque carte MUST porter une rareté calculée par une règle pure à partir du nombre de favoris du personnage.
- **FR-004**: Les probabilités cibles de tirage MUST être : commune 60 %, rare 28 %, épique 9 %, légendaire 3 %.
- **FR-005**: Les cartes nouvelles MUST être ajoutées à l'Animédex ; un personnage déjà possédé MUST être signalé « déjà possédé » et ne MUST NOT être dupliqué.
- **FR-006**: Le jour MUST être marqué ouvert uniquement après un tirage réussi.
- **FR-007**: L'ouverture MUST échouer avec une exception de domaine nommée si le booster du jour est déjà ouvert, ou si AniList est indisponible.
- **FR-008**: Les 5 personnages MUST être demandés en une seule requête GraphQL (un alias par carte), avec un délai court.
- **FR-009**: L'Animédex MUST être persistée localement, tolérer des données corrompues et ignorer l'ancien format de cartes d'animés.
- **FR-010**: Le moment de référence et le hasard MUST être injectables pour les tests.

### Key Entities

- **Carte (DexCard)**: identifiant du personnage, nom, nom natif, rareté, nombre de favoris, date d'obtention, portrait, titre de l'anime d'origine.
- **Carte tirée (DrawnCard)**: une carte et son indicateur « nouvelle ».
- **Disponibilité du booster**: booléen et prochain minuit local.

## Success Criteria *(mandatory)*

- **SC-001**: Un booster s'ouvre en quelques secondes au plus : une seule requête réseau suffit.
- **SC-002**: Sur un grand nombre de tirages, la répartition des raretés reste proche des probabilités cibles.
- **SC-003**: Une panne d'AniList ne consomme jamais le booster du jour.

## Assumptions

- Le tirage passe par l'API GraphQL publique d'AniList, sans clé ni compte, parmi les 5000 personnages les plus aimés (profondeur maximale de pagination de l'API), triés par favoris décroissants avec une page d'un personnage par alias.
- Le tirage choisit d'abord une rareté selon les probabilités cibles, puis un rang dans la tranche correspondante : 1 à 60 légendaire, 61 à 300 épique, 301 à 1500 rare, 1501 à 5000 commune. Ces tranches ont été calibrées sur des mesures réelles (rang 60 : ~14 700 favoris, rang 300 : ~5 400, rang 1500 : ~1 080, rang 5000 : ~230).
- La rareté affichée est recalculée à partir des favoris : légendaire dès 14 000, épique dès 5 400, rare dès 1 100, commune en dessous.
- L'API limite le débit (de l'ordre de 30 à 90 requêtes par minute) : un booster coûte une requête.
- La collection est stockée dans les préférences de l'appareil (JSON) : elle n'est pas synchronisée entre appareils.
