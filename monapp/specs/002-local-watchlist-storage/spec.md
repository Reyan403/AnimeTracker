# Feature Specification: Sauvegarde locale de la liste

**Feature Branch**: `001-modern-dynamic-design` (poursuivie)

**Created**: 2026-10-05

**Status**: Implemented

**Input**: "Sauvegarde locale : un simple stockage sur l'appareil, sans compte."

## User Scenarios & Testing *(mandatory)*

### User Story 1 - Retrouver sa liste après fermeture (Priority: P1)

L'utilisateur ajoute des animes et change des statuts. Il ferme l'application, la rouvre, et retrouve sa liste exactement dans l'état où il l'a laissée.

**Why this priority**: sans persistance, toute modification est perdue ; c'est le socle des autres idées.

**Independent Test**: ajouter un anime depuis le catalogue, fermer et relancer l'application : l'anime est toujours dans « À voir ».

**Acceptance Scenarios**:

1. **Given** une liste modifiée, **When** l'application est relancée, **Then** les animes et leurs statuts sont identiques.
2. **Given** un premier lancement sans données enregistrées, **When** l'application démarre, **Then** la liste de départ habituelle est présentée puis enregistrée.
3. **Given** des données enregistrées illisibles, **When** l'application démarre, **Then** elle repart de la liste de départ au lieu de planter.

### Edge Cases

- Un statut inconnu dans les données enregistrées : l'entrée concernée est ignorée.
- Une écriture qui échoue : l'utilisation continue, la liste reste correcte à l'écran.

## Requirements *(mandatory)*

### Functional Requirements

- **FR-001**: L'application MUST enregistrer la liste sur l'appareil après chaque ajout ou changement de statut.
- **FR-002**: L'application MUST recharger cette liste au démarrage.
- **FR-003**: Au premier lancement, l'application MUST utiliser la liste de départ puis l'enregistrer.
- **FR-004**: Des données enregistrées invalides MUST NOT empêcher le démarrage.
- **FR-005**: Aucun compte ni service distant MUST être requis.

### Key Entities

- **Entrée de liste**: identifiant de l'anime, titre, statut de visionnage.

## Success Criteria *(mandatory)*

- **SC-001**: 100 % des ajouts et changements de statut sont présents après un redémarrage.
- **SC-002**: Le démarrage avec des données corrompues réussit dans 100 % des cas.

## Assumptions

- Usage personnel sur un seul appareil : pas de synchronisation.
- La liste reste petite (quelques dizaines d'animes), un stockage clé/valeur suffit, ce qui fonctionne aussi sur le web.
