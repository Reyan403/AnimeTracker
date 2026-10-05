# Feature Specification: Animédex et boosters quotidiens

**Created**: 2026-10-05

**Status**: Implemented

**Input**: "Un booster de 5 cartes par jour, des cartes d'animes réels tirées au hasard avec une rareté, et un Animédex qui garde la collection."

## User Scenarios & Testing *(mandatory)*

### User Story 1 - Ouvrir le booster du jour (Priority: P1)

Chaque jour calendaire, l'utilisateur peut ouvrir un booster de 5 cartes. Chaque carte est un vrai anime tiré au hasard dans le catalogue, avec une rareté : commune, rare, épique ou légendaire.

**Why this priority**: c'est le geste quotidien qui fait revenir dans l'application.

**Independent Test**: ouvrir le booster un jour donné : 5 cartes différentes apparaissent, puis le booster est indisponible jusqu'au lendemain.

**Acceptance Scenarios**:

1. **Given** aucun booster ouvert aujourd'hui, **When** l'utilisateur ouvre le booster, **Then** 5 animés distincts sont tirés et chacun est marqué « nouveau » ou « déjà possédé ».
2. **Given** un booster déjà ouvert aujourd'hui, **When** l'utilisateur tente de l'ouvrir de nouveau, **Then** l'ouverture est refusée sans rien tirer.
3. **Given** un booster ouvert hier, **When** le jour calendaire local change, **Then** un nouveau booster est disponible.
4. **Given** le catalogue injoignable, **When** l'utilisateur ouvre le booster, **Then** aucune carte n'est ajoutée et le jour n'est pas consommé : il peut réessayer.
5. **Given** un tirage qui donne un doublon dans le même booster, **When** le booster s'ouvre, **Then** la carte en double est remplacée par un nouveau tirage.
6. **Given** un tirage partiel (le catalogue répond puis échoue), **When** au moins une carte a été obtenue, **Then** le booster s'ouvre avec les cartes obtenues.

### User Story 2 - Consulter l'Animédex (Priority: P1)

Les cartes nouvellement obtenues rejoignent l'Animédex, une collection qui persiste d'une session à l'autre. Elle est triée par rareté décroissante, puis par date d'obtention décroissante.

**Why this priority**: sans collection persistante, les cartes n'ont aucune valeur.

**Independent Test**: ouvrir un booster, fermer puis rouvrir l'application : les cartes obtenues sont toujours là, triées.

**Acceptance Scenarios**:

1. **Given** des cartes de raretés différentes, **When** l'Animédex se charge, **Then** les légendaires viennent d'abord, puis les épiques, rares et communes, les plus récentes en premier à rareté égale.
2. **Given** un anime déjà dans l'Animédex, **When** il est tiré de nouveau, **Then** il n'est pas dupliqué dans la collection.
3. **Given** des données enregistrées corrompues, **When** l'Animédex se charge, **Then** les entrées invalides sont ignorées sans erreur.

### User Story 3 - Savoir quand revenir (Priority: P2)

L'application indique si le booster du jour est disponible et, sinon, à quel moment le suivant sera prêt : le prochain minuit local.

**Why this priority**: le compte à rebours donne un rendez-vous quotidien.

**Independent Test**: après ouverture, l'heure du prochain booster est minuit local.

**Acceptance Scenarios**:

1. **Given** le booster du jour ouvert, **When** la disponibilité est consultée, **Then** elle est « indisponible » avec le prochain minuit local.
2. **Given** un changement de mois ou d'année, **When** la disponibilité est calculée, **Then** le prochain minuit est correct.

### Edge Cases

- Le jour est mémorisé au format `yyyy-MM-dd` dans le fuseau local, et seulement quand le tirage a réussi.
- Un anime sans note moyenne est tiré avec la rareté commune.
- Une requête de tirage plus lente que 4 secondes est abandonnée ; si toutes échouent, le booster est indisponible.

## Requirements *(mandatory)*

### Functional Requirements

- **FR-001**: L'application MUST offrir un booster de 5 cartes par jour calendaire local.
- **FR-002**: Les 5 cartes d'un booster MUST être des animés distincts.
- **FR-003**: Chaque carte MUST porter une rareté calculée par une règle pure à partir des données du catalogue (note moyenne, rang de popularité).
- **FR-004**: Les probabilités cibles de tirage MUST être : commune 60 %, rare 28 %, épique 9 %, légendaire 3 %.
- **FR-005**: Les cartes nouvelles MUST être ajoutées à l'Animédex ; un anime déjà possédé MUST être signalé « déjà possédé » et ne MUST NOT être dupliqué.
- **FR-006**: Le jour MUST être marqué ouvert uniquement après un tirage réussi.
- **FR-007**: L'ouverture MUST échouer avec une exception de domaine nommée si le booster du jour est déjà ouvert, ou si le catalogue est indisponible.
- **FR-008**: Les requêtes de tirage MUST être envoyées en parallèle, avec un délai court par requête.
- **FR-009**: L'Animédex MUST être persistée localement et tolérer des données corrompues.
- **FR-010**: Le moment de référence et le hasard MUST être injectables pour les tests.

### Key Entities

- **Carte (DexCard)**: identifiant de l'anime, titre, rareté, format, année, nombre d'épisodes, date d'obtention, affiche, genres.
- **Carte tirée (DrawnCard)**: une carte et son indicateur « nouvelle ».
- **Disponibilité du booster**: booléen et prochain minuit local.

## Success Criteria *(mandatory)*

- **SC-001**: Un booster s'ouvre en quelques secondes au plus : les 5 requêtes partent en parallèle.
- **SC-002**: Sur un grand nombre de tirages, la répartition des raretés reste proche des probabilités cibles.
- **SC-003**: Une panne du catalogue ne consomme jamais le booster du jour.

## Assumptions

- Le tirage passe par l'API publique de Kitsu, sans clé ni compte, parmi les animés de format série TV ou film suivis par au moins 2000 utilisateurs, soit environ 3300 titres.
- Les animés sont classés par rang de note ; le tirage choisit d'abord une rareté selon les probabilités cibles, puis un anime dans la tranche de classement correspondante (0 à 100 légendaire, 100 à 400 épique, 400 à 1500 rare, au-delà commune).
- La rareté affichée est recalculée à partir de la note moyenne (légendaire dès 82,3, épique dès 81,2, rare dès 73,5) ; un anime parmi les 20 plus populaires gagne une rareté.
- La collection est stockée dans les préférences de l'appareil (JSON) : elle n'est pas synchronisée entre appareils.
