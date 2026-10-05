# Feature Specification: Progression par épisode

**Created**: 2026-10-05

**Status**: Implemented

**Input**: "Progression par épisode avec « +1 » sur la carte."

## User Scenarios & Testing *(mandatory)*

### User Story 1 - Marquer un épisode comme vu (Priority: P1)

Depuis la carte d'un anime dans Ma liste, l'utilisateur touche « + » pour enregistrer qu'il vient de voir un épisode. Une barre et un texte indiquent où il en est.

**Why this priority**: c'est le geste le plus fréquent de l'application.

**Independent Test**: toucher « + » sur un anime « À voir » : il passe « En cours » avec 1 épisode vu ; la progression survit à un redémarrage.

**Acceptance Scenarios**:

1. **Given** un anime « À voir », **When** l'utilisateur marque un épisode, **Then** il passe « En cours » avec 1 épisode vu.
2. **Given** un anime à l'avant-dernier épisode, **When** l'utilisateur marque le suivant, **Then** il passe automatiquement « Terminé ».
3. **Given** un anime terminé, **When** la carte est affichée, **Then** le bouton « + » est désactivé.
4. **Given** un anime avec des épisodes vus, **When** l'utilisateur touche « − », **Then** le dernier épisode est annulé.
5. **Given** un anime à 1 épisode vu, **When** l'utilisateur touche « − », **Then** il repasse « À voir ».

### Edge Cases

- Nombre d'épisodes inconnu : le compteur augmente sans barre et ne termine jamais seul.
- Anime déjà « Terminé » sans progression enregistrée : il est considéré comme entièrement vu.
- Un « − » sur un anime terminé le repasse « En cours » à l'avant-dernier épisode.

## Requirements *(mandatory)*

### Functional Requirements

- **FR-001**: Chaque carte de Ma liste MUST afficher le nombre d'épisodes vus, avec une barre quand le total est connu.
- **FR-002**: L'utilisateur MUST pouvoir ajouter ou retirer un épisode vu depuis la carte.
- **FR-003**: Le premier épisode vu MUST faire passer un anime « À voir » à « En cours ».
- **FR-004**: Le dernier épisode vu MUST faire passer l'anime à « Terminé ».
- **FR-005**: La progression MUST être conservée entre deux lancements.

### Key Entities

- **Entrée de liste**: gagne un nombre d'épisodes vus.

## Success Criteria *(mandatory)*

- **SC-001**: Marquer un épisode prend un seul toucher.
- **SC-002**: 100 % des changements de progression sont présents après un redémarrage.

## Assumptions

- Les anciennes données enregistrées sans progression sont lues avec 0 épisode vu.
