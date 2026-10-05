# Feature Specification: Quoi regarder ce soir ?

**Created**: 2026-10-05

**Status**: Implemented

**Input**: "Quoi regarder ce soir ? avec mon humeur."

## User Scenarios & Testing *(mandatory)*

### User Story 1 - Obtenir une suggestion adaptée (Priority: P1)

Dans l'onglet Découvrir, l'utilisateur choisit une humeur (détente, action, émotion, mystère ou peu importe), puis touche « Surprends-moi ». L'application tire au hasard un anime dans tout le catalogue, parmi les titres suivis par au moins 2 000 personnes.

**Why this priority**: elle résout le « je ne sais pas quoi regarder » en faisant découvrir un anime au hasard.

**Independent Test**: choisir « Action » : l'anime proposé appartient aux genres action ou aventure.

**Acceptance Scenarios**:

1. **Given** le catalogue complet, **When** l'utilisateur demande une suggestion, **Then** un anime tiré au hasard, qui correspond à l'humeur, est proposé.
2. **Given** une suggestion affichée, **When** l'utilisateur touche « Une autre idée », **Then** un autre anime est proposé tant qu'il en reste.
3. **Given** une suggestion, **When** l'utilisateur touche « Ajouter à ma liste », **Then** l'anime rejoint « À voir » et la carte indique qu'il est dans sa liste.
4. **Given** aucun anime ne correspond, **When** l'utilisateur demande une suggestion, **Then** un message l'invite à changer d'humeur.
5. **Given** un anime terminé par l'utilisateur, **When** le tirage a lieu, **Then** il n'est jamais proposé.

### Edge Cases

- Détails indisponibles pour toute la liste : message d'erreur avec « Réessayer ».
- Changer d'humeur efface la suggestion affichée.

## Requirements *(mandatory)*

### Functional Requirements

- **FR-001**: L'application MUST proposer un onglet Découvrir avec le sélecteur de soirée.
- **FR-002**: Les suggestions MUST venir de l'ensemble du catalogue, sans jamais proposer un anime déjà terminé.
- **FR-003**: L'humeur MUST filtrer par genres associés ; « peu importe » ne filtre rien.
- **FR-004**: L'utilisateur MUST pouvoir ajouter la suggestion à sa liste.
- **FR-005**: L'utilisateur MUST pouvoir demander une autre suggestion et ouvrir la fiche.

### Key Entities

- **Humeur**: ensemble de genres. **Suggestion**: anime du catalogue, genres, déjà listé ou non.

## Success Criteria *(mandatory)*

- **SC-001**: Une suggestion s'affiche en un toucher une fois l'humeur choisie.
- **SC-002**: Aucune suggestion ne propose un anime terminé par l'utilisateur.

## Assumptions

- Le catalogue est celui de la source de données existante, limité aux titres suivis par au moins 2 000 personnes pour éviter les inconnus.
- Le tirage au sort par secousse du téléphone est hors périmètre.
