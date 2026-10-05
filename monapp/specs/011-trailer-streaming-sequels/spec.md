# Feature Specification: Bande-annonce, plateformes et suites

**Created**: 2026-10-05

**Status**: Implemented

**Input**: "Bande-annonce + où regarder + suites, sans ralentir le site."

## User Scenarios & Testing *(mandatory)*

### User Story 1 - Aller de la fiche à la bande-annonce ou au streaming (Priority: P1)

En bas de la fiche d'un anime, l'utilisateur voit un bouton « Bande-annonce » et les plateformes où le regarder. Toucher l'un d'eux ouvre le lien dans une application ou un onglet externe.

**Why this priority**: c'est le geste qui suit naturellement la lecture d'une fiche.

**Independent Test**: ouvrir la fiche d'un anime populaire : la bande-annonce et au moins une plateforme sont proposées, et un toucher ouvre la page correspondante.

**Acceptance Scenarios**:

1. **Given** une fiche avec bande-annonce, **When** elle s'affiche, **Then** le bouton « Bande-annonce » est disponible immédiatement, sans attendre d'autres données.
2. **Given** des plateformes connues, **When** elles sont chargées, **Then** chacune apparaît une seule fois comme bouton.
3. **Given** un lien impossible à ouvrir, **When** l'utilisateur le touche, **Then** un message l'en informe.
4. **Given** ni bande-annonce ni plateforme, **When** la fiche s'affiche, **Then** la zone « Où regarder » n'apparaît pas.

### User Story 2 - Trouver la suite ou la préquelle (Priority: P2)

La fiche propose les suites et préquelles de l'anime, sous forme d'affiches, préquelles en premier. Toucher une affiche ouvre sa fiche.

**Why this priority**: permet de suivre l'ordre de visionnage d'une franchise.

**Independent Test**: ouvrir la fiche d'une série à plusieurs saisons : les saisons voisines sont proposées et cliquables.

**Acceptance Scenarios**:

1. **Given** des suites ou préquelles connues, **When** elles sont chargées, **Then** elles s'affichent avec leur rôle (« Suite », « Préquelle »).
2. **Given** une relation qui n'est ni suite ni préquelle, ou qui concerne un manga, **When** les relations sont chargées, **Then** elle est ignorée.
3. **Given** une suite touchée, **When** la fiche s'ouvre, **Then** elle s'affiche avec les mêmes possibilités.

### Edge Cases

- Service indisponible : la fiche reste affichée sans ces zones, sans erreur.
- Les données déjà chargées pour un anime ne sont pas redemandées pendant la session.

## Requirements *(mandatory)*

### Functional Requirements

- **FR-001**: La fiche MUST afficher d'abord son contenu principal ; plateformes et suites se chargent ensuite, séparément.
- **FR-002**: La bande-annonce MUST être proposée sans requête supplémentaire.
- **FR-003**: Les plateformes et suites MUST être demandées uniquement à l'ouverture d'une fiche, avec le minimum de champs.
- **FR-004**: Une panne MUST NOT empêcher l'affichage de la fiche.
- **FR-005**: Aucune image ni vidéo de bande-annonce MUST être téléchargée avant le toucher de l'utilisateur.

### Key Entities

- **Plateforme de streaming**: nom du site et lien. **Anime lié**: anime et rôle (suite ou préquelle).

## Success Criteria *(mandatory)*

- **SC-001**: L'ajout de ces zones ne retarde pas l'affichage du contenu principal d'une fiche.
- **SC-002**: Un anime déjà consulté ne redéclenche aucune requête de plateformes ou de suites.

## Assumptions

- Les liens de streaming et les relations viennent de la source de données existante ; leur couverture n'est pas exhaustive pour les plateformes françaises.
- La bande-annonce s'ouvre sur YouTube.
