# Feature Specification: Recommandations « Pour toi »

**Created**: 2026-10-05

**Status**: Implemented

**Input**: "Recommandations tirées de ce que j'ai déjà terminé."

## User Scenarios & Testing *(mandatory)*

### User Story 1 - Découvrir des animes proches de mes goûts (Priority: P1)

Dans l'onglet Découvrir, la section « Pour toi » propose des animes bien notés dans les genres que l'utilisateur regarde le plus, avec une phrase qui explique pourquoi (« Parce que vous aimez Action et Drame »). Il peut ouvrir la fiche ou ajouter l'anime à sa liste.

**Why this priority**: elle fait découvrir de nouveaux animes sans effort de recherche.

**Independent Test**: avec des animes terminés d'un même genre dans la liste, la section propose des animes de ce genre qui ne sont pas déjà dans la liste.

**Acceptance Scenarios**:

1. **Given** des animes terminés et en cours, **When** Découvrir s'ouvre, **Then** jusqu'à 10 recommandations apparaissent avec les deux genres préférés en explication.
2. **Given** un anime déjà dans la liste, **When** les recommandations sont calculées, **Then** il n'est jamais proposé.
3. **Given** un anime qui correspond aux deux genres préférés, **When** les recommandations sont classées, **Then** il passe avant ceux qui n'en correspondent qu'à un.
4. **Given** une recommandation, **When** l'utilisateur touche « + », **Then** l'anime est ajouté à « À voir » et disparaît des recommandations.
5. **Given** une liste sans anime terminé ni en cours, **When** Découvrir s'ouvre, **Then** un message invite à commencer des animes.

### Edge Cases

- Un des deux genres ne peut pas être chargé : les recommandations de l'autre genre sont quand même affichées.
- Aucun genre ne peut être chargé : message d'erreur avec « Réessayer ».
- Les animes « À voir » ne comptent pas comme des goûts ; ceux terminés pèsent plus que ceux en cours.

## Requirements *(mandatory)*

### Functional Requirements

- **FR-001**: Les genres préférés MUST être calculés à partir des animes terminés (poids 3) et en cours (poids 2).
- **FR-002**: L'application MUST proposer des animes bien notés et suffisamment suivis dans ces genres.
- **FR-003**: Les animes déjà listés MUST être exclus.
- **FR-004**: Chaque ensemble MUST indiquer les genres qui l'expliquent.
- **FR-005**: L'utilisateur MUST pouvoir ajouter une recommandation à sa liste.

### Key Entities

- **Ensemble de recommandations**: genres de référence et animes proposés.

## Success Criteria *(mandatory)*

- **SC-001**: 100 % des recommandations sont absentes de la liste de l'utilisateur.
- **SC-002**: Chaque recommandation affichée est expliquée par au moins un genre.

## Assumptions

- Les notes et le nombre d'abonnés viennent de la source de données existante (minimum 20 000 abonnés pour éviter les titres confidentiels).
- Il s'agit d'une recommandation par genres, pas d'un modèle collaboratif.
