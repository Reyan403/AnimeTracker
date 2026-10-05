# Feature Specification: Statistiques personnelles

**Created**: 2026-10-05

**Status**: Implemented

**Input**: "Stats personnelles : heures regardées, genres favoris."

## User Scenarios & Testing *(mandatory)*

### User Story 1 - Voir ce que j'ai regardé (Priority: P1)

Dans l'onglet Stats, l'utilisateur voit son temps de visionnage total, le nombre d'épisodes vus, le nombre d'animes terminés, la répartition de sa liste par statut et ses cinq genres favoris.

**Why this priority**: c'est un retour ludique et immédiat sur son usage.

**Independent Test**: marquer un épisode de 24 minutes comme vu : le temps total et le compteur d'épisodes augmentent aussitôt.

**Acceptance Scenarios**:

1. **Given** des animes avec progression, **When** l'onglet Stats s'ouvre, **Then** heures, épisodes et animes terminés sont affichés avec une animation de comptage.
2. **Given** des animes à voir, en cours et terminés, **When** les stats s'affichent, **Then** une barre montre leur répartition avec les effectifs.
3. **Given** des animes terminés et en cours, **When** les stats s'affichent, **Then** les cinq genres les plus fréquents sont classés avec leur effectif.
4. **Given** un épisode marqué comme vu, **When** l'utilisateur revient sur Stats, **Then** les chiffres sont à jour.
5. **Given** une liste vide, **When** Stats s'ouvre, **Then** un message invite à ajouter des animes.

### Edge Cases

- Durée d'épisode inconnue : l'épisode compte mais n'ajoute pas de temps.
- Les animes « À voir » ne comptent pas dans les genres favoris.
- Service indisponible : message d'erreur avec « Réessayer ».

## Requirements *(mandatory)*

### Functional Requirements

- **FR-001**: L'application MUST proposer un onglet Stats.
- **FR-002**: Le temps de visionnage MUST être le total des épisodes vus multiplié par la durée de chaque épisode.
- **FR-003**: Un anime terminé sans progression enregistrée MUST compter tous ses épisodes.
- **FR-004**: Les genres favoris MUST se limiter à cinq, classés par nombre d'animes en cours ou terminés.
- **FR-005**: Les chiffres MUST se mettre à jour quand la liste change.
- **FR-006**: L'écran MUST gérer les états chargement, vide et erreur.

### Key Entities

- **Statistiques**: minutes, épisodes, effectifs par statut, genres favoris.

## Success Criteria *(mandatory)*

- **SC-001**: Les statistiques reflètent la liste en moins d'une seconde après un changement.
- **SC-002**: Aucun calcul n'est faussé par une durée ou un total d'épisodes inconnu.

## Assumptions

- Usage personnel : les statistiques ne couvrent que cet appareil.
- Le partage d'un « bilan annuel » en image est hors périmètre.
