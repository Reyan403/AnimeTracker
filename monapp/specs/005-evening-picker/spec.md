# Feature Specification: Quoi regarder ce soir ?

**Created**: 2026-10-05

**Status**: Implemented

**Input**: "Quoi regarder ce soir ? avec mon humeur et mon temps disponible."

## User Scenarios & Testing *(mandatory)*

### User Story 1 - Obtenir une suggestion adaptée (Priority: P1)

Dans l'onglet Découvrir, l'utilisateur choisit une humeur (détente, action, émotion, mystère ou peu importe) et le temps dont il dispose (30 min, 1 h, 2 h ou toute la soirée), puis touche « Surprends-moi ». L'application propose un anime de sa propre liste qui correspond.

**Why this priority**: elle résout le « je ne sais pas quoi regarder » avec ce que l'utilisateur possède déjà.

**Independent Test**: choisir « Action » et « 30 min » : l'anime proposé a des épisodes de 30 minutes ou moins et appartient aux genres action ou aventure.

**Acceptance Scenarios**:

1. **Given** une liste variée, **When** l'utilisateur demande une suggestion, **Then** un anime non terminé qui correspond à l'humeur et au temps est proposé.
2. **Given** une suggestion affichée, **When** l'utilisateur touche « Une autre idée », **Then** un autre anime est proposé tant qu'il en reste.
3. **Given** toutes les suggestions déjà montrées, **When** l'utilisateur redemande, **Then** le tirage repart de zéro.
4. **Given** aucun anime ne correspond, **When** l'utilisateur demande une suggestion, **Then** un message l'invite à changer d'humeur ou de durée.
5. **Given** un anime déjà commencé, **When** il est proposé, **Then** le message indique qu'il s'agit de le reprendre.

### Edge Cases

- Durée d'épisode inconnue : l'anime reste éligible.
- Détails indisponibles pour toute la liste : message d'erreur avec « Réessayer ».
- Changer d'humeur ou de durée efface la suggestion affichée.

## Requirements *(mandatory)*

### Functional Requirements

- **FR-001**: L'application MUST proposer un onglet Découvrir avec le sélecteur de soirée.
- **FR-002**: Les suggestions MUST venir uniquement des animes non terminés de la liste.
- **FR-003**: L'humeur MUST filtrer par genres associés ; « peu importe » n'filtre rien.
- **FR-004**: La durée MUST exclure les animes dont l'épisode dépasse le temps disponible.
- **FR-005**: Les animes en cours MUST être plus souvent proposés que ceux à voir.
- **FR-006**: L'utilisateur MUST pouvoir demander une autre suggestion et ouvrir la fiche.

### Key Entities

- **Humeur**: ensemble de genres. **Durée**: minutes disponibles. **Suggestion**: anime, genres correspondants, reprise ou non.

## Success Criteria *(mandatory)*

- **SC-001**: Une suggestion s'affiche en un toucher une fois humeur et durée choisies.
- **SC-002**: Aucune suggestion ne propose un anime terminé.

## Assumptions

- Les genres viennent de la source de données existante.
- Le tirage au sort par secousse du téléphone est hors périmètre.
