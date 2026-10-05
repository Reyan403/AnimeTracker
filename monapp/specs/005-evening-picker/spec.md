# Feature Specification: Quoi regarder ce soir ?

**Created**: 2026-10-05

**Status**: Implemented

**Input**: "Quoi regarder ce soir ? avec mon humeur."

## User Scenarios & Testing *(mandatory)*

### User Story 1 - Obtenir une suggestion adaptée (Priority: P1)

Dans l'onglet Découvrir, l'utilisateur choisit une humeur (détente, action, émotion, mystère ou peu importe), puis touche « Surprends-moi ». L'application propose un anime de sa propre liste qui correspond.

**Why this priority**: elle résout le « je ne sais pas quoi regarder » avec ce que l'utilisateur possède déjà.

**Independent Test**: choisir « Action » : l'anime proposé appartient aux genres action ou aventure.

**Acceptance Scenarios**:

1. **Given** une liste variée, **When** l'utilisateur demande une suggestion, **Then** un anime non terminé qui correspond est proposé.
2. **Given** une suggestion affichée, **When** l'utilisateur touche « Une autre idée », **Then** un autre anime est proposé tant qu'il en reste.
3. **Given** toutes les suggestions déjà montrées, **When** l'utilisateur redemande, **Then** le tirage repart de zéro.
4. **Given** aucun anime ne correspond, **When** l'utilisateur demande une suggestion, **Then** un message l'invite à changer d'humeur.
5. **Given** un anime déjà commencé, **When** il est proposé, **Then** le message indique qu'il s'agit de le reprendre.

### Edge Cases

- Détails indisponibles pour toute la liste : message d'erreur avec « Réessayer ».
- Changer d'humeur efface la suggestion affichée.

## Requirements *(mandatory)*

### Functional Requirements

- **FR-001**: L'application MUST proposer un onglet Découvrir avec le sélecteur de soirée.
- **FR-002**: Les suggestions MUST venir uniquement des animes non terminés de la liste.
- **FR-003**: L'humeur MUST filtrer par genres associés ; « peu importe » ne filtre rien.
- **FR-004**: Les animes en cours MUST être plus souvent proposés que ceux à voir.
- **FR-005**: L'utilisateur MUST pouvoir demander une autre suggestion et ouvrir la fiche.

### Key Entities

- **Humeur**: ensemble de genres. **Suggestion**: anime, genres correspondants, reprise ou non.

## Success Criteria *(mandatory)*

- **SC-001**: Une suggestion s'affiche en un toucher une fois l'humeur choisie.
- **SC-002**: Aucune suggestion ne propose un anime terminé.

## Assumptions

- Les genres viennent de la source de données existante.
- Le tirage au sort par secousse du téléphone est hors périmètre.
