# Feature Specification: Calendrier des sorties des prochaines semaines

**Created**: 2026-10-05

**Status**: Implemented

**Input**: "Récupérer une API qui permet de voir les sorties dans les semaines à venir pour les inscrire dans l'agenda."

## User Scenarios & Testing *(mandatory)*

### User Story 1 - Voir les sorties des trois prochaines semaines (Priority: P1)

L'Agenda affiche, du plus proche au plus lointain, les épisodes qui sortent dans les 21 prochains jours : ceux des animes de la liste de l'utilisateur, repérés par un badge « Dans ma liste », et les nouveautés populaires du moment.

**Why this priority**: sans source fiable, l'Agenda restait vide pour la plupart des listes.

**Independent Test**: ouvrir l'Agenda avec une connexion : des épisodes à venir sont listés avec date, heure et numéro d'épisode.

**Acceptance Scenarios**:

1. **Given** un anime de la liste en cours de diffusion, **When** l'Agenda s'ouvre, **Then** ses prochains épisodes (jusqu'à 3) apparaissent avec le badge « Dans ma liste » et son titre de liste.
2. **Given** des séries populaires en cours de diffusion absentes de la liste, **When** l'Agenda s'ouvre, **Then** leur prochain épisode apparaît sans badge.
3. **Given** le filtre « Ma liste », **When** l'utilisateur le sélectionne, **Then** seules les sorties de ses animes restent affichées, avec un message si aucune.
4. **Given** une sortie d'un anime de la liste, **When** l'utilisateur la touche, **Then** la fiche s'ouvre ; une sortie externe n'ouvre rien.
5. **Given** un anime terminé de la liste, **When** l'Agenda se construit, **Then** il n'y figure pas et n'est pas non plus proposé comme nouveauté.

### Edge Cases

- Service de calendrier indisponible : l'Agenda utilise les dates déjà connues de la source principale, sans erreur bloquante.
- Les sorties au-delà de 21 jours ou passées depuis plus de 6 heures sont masquées.
- Les nouveautés populaires sont chargées une fois puis réutilisées ; un résultat vide est retenté.

## Requirements *(mandatory)*

### Functional Requirements

- **FR-001**: L'Agenda MUST afficher les épisodes des 21 prochains jours triés par date.
- **FR-002**: Les animes de la liste MUST être reconnus par leur identifiant MyAnimeList.
- **FR-003**: Les sorties de la liste MUST être distinguées par un badge.
- **FR-004**: L'utilisateur MUST pouvoir filtrer sur sa liste.
- **FR-005**: Une panne du service de calendrier MUST NOT empêcher l'affichage des autres sorties.

### Key Entities

- **Épisode à venir**: titre, numéro, date de diffusion, identifiant MyAnimeList, couverture.
- **Sortie planifiée**: épisode affiché dans l'Agenda, avec ou sans anime de la liste associé.

## Success Criteria *(mandatory)*

- **SC-001**: L'Agenda n'est plus vide tant que des séries populaires sont en cours de diffusion.
- **SC-002**: 100 % des sorties de la liste dont l'identifiant est connu sont rattachées au bon anime.

## Assumptions

- La source des horaires est l'API publique AniList (sans clé ni compte).
- Un anime de la liste sans correspondance MyAnimeList retombe sur la date de la source principale quand elle existe.
- Les rappels par notification restent hors périmètre.
