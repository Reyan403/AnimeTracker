# Feature Specification: Statistiques personnelles

**Created**: 2026-10-05

**Status**: Implemented

**Input**: "Stats personnelles : épisodes vus et genres favoris."

## User Scenarios & Testing *(mandatory)*

### User Story 1 - Voir ce que j'ai regardé (Priority: P1)

Dans l'onglet Stats, l'utilisateur voit le nombre d'épisodes vus, le nombre d'animes terminés et ses cinq genres favoris.

**Why this priority**: c'est un retour ludique et immédiat sur son usage.

**Independent Test**: marquer un épisode comme vu : le compteur d'épisodes augmente aussitôt.

**Acceptance Scenarios**:

1. **Given** des animes avec progression, **When** l'onglet Stats s'ouvre, **Then** épisodes vus et animes terminés sont affichés avec une animation de comptage.
2. **Given** des animes terminés et en cours, **When** les stats s'affichent, **Then** les cinq genres les plus fréquents sont classés avec leur effectif.
3. **Given** un épisode marqué comme vu, **When** l'utilisateur revient sur Stats, **Then** les chiffres sont à jour.
4. **Given** une liste vide, **When** Stats s'ouvre, **Then** un message invite à ajouter des animes.

### Edge Cases

- Les animes « À voir » ne comptent pas dans les genres favoris.
- Service indisponible : message d'erreur avec « Réessayer ».

## Requirements *(mandatory)*

### Functional Requirements

- **FR-001**: L'application MUST proposer un onglet Stats.
- **FR-002**: Les genres favoris MUST se limiter à cinq, classés par nombre d'animes en cours ou terminés.
- **FR-003**: Les chiffres MUST se mettre à jour quand la liste change.
- **FR-004**: L'écran MUST gérer les états chargement, vide et erreur.

### Key Entities

- **Statistiques**: épisodes vus, effectifs par statut, genres favoris.

## Success Criteria *(mandatory)*

- **SC-001**: Les statistiques reflètent la liste en moins d'une seconde après un changement.
- **SC-002**: Aucun calcul n'est faussé par un total d'épisodes inconnu.

## Assumptions

- Usage personnel : les statistiques ne couvrent que cet appareil.
- Le partage d'un « bilan annuel » en image est hors périmètre.
