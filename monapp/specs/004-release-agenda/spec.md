# Feature Specification: Agenda des prochaines sorties

**Created**: 2026-10-05

**Status**: Implemented

**Input**: "Calendrier des prochaines sorties pour mes animes en cours."

## User Scenarios & Testing *(mandatory)*

### User Story 1 - Voir quand sort le prochain épisode (Priority: P1)

L'utilisateur ouvre l'onglet Agenda et voit, du plus proche au plus lointain, la prochaine sortie de chacun de ses animes non terminés, avec un compte à rebours (« Demain », « Dans 3 jours »), la date et l'épisode qu'il lui reste à voir.

**Why this priority**: savoir quand regarder la suite est le besoin quotidien d'un suivi d'animes.

**Independent Test**: avoir un anime en cours de diffusion dans sa liste : il apparaît dans l'Agenda avec sa date de sortie.

**Acceptance Scenarios**:

1. **Given** des animes dont la prochaine sortie est connue, **When** l'Agenda s'ouvre, **Then** ils sont triés par date croissante avec leur compte à rebours.
2. **Given** un anime terminé, **When** l'Agenda s'ouvre, **Then** il n'y figure pas.
3. **Given** aucun anime avec sortie à venir, **When** l'Agenda s'ouvre, **Then** un message explique comment en ajouter.
4. **Given** une sortie dont la date est déjà passée de peu, **When** l'Agenda s'ouvre, **Then** elle reste visible avec « Hier » ou « Il y a N jours ».
5. **Given** une carte de l'Agenda, **When** l'utilisateur la touche, **Then** la fiche de l'anime s'ouvre.

### Edge Cases

- Date de sortie plus ancienne que 14 jours : considérée périmée et masquée.
- Service indisponible : message d'erreur avec « Réessayer ».
- Chargement : squelettes à la place des cartes.

## Requirements *(mandatory)*

### Functional Requirements

- **FR-001**: L'application MUST proposer un onglet Agenda.
- **FR-002**: L'Agenda MUST lister les animes non terminés dont la prochaine sortie est connue, triés par date.
- **FR-003**: Chaque entrée MUST afficher un compte à rebours, la date, l'heure et le prochain épisode à voir.
- **FR-004**: Les sorties plus vieilles que 14 jours MUST être masquées.
- **FR-005**: L'Agenda MUST gérer les états chargement, vide et erreur.

### Key Entities

- **Sortie planifiée**: anime, date de sortie, prochain épisode à voir.

## Success Criteria *(mandatory)*

- **SC-001**: Les dates de sortie connues de la liste sont toutes présentes dans l'Agenda.
- **SC-002**: L'ordre est toujours chronologique.

## Assumptions

- La date de prochaine sortie vient de la source de données existante ; si elle est absente, l'anime n'apparaît pas.
- Les rappels par notification sont hors périmètre.
