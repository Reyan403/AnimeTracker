# Feature Specification: Synopsis en français

**Created**: 2026-10-05

**Status**: Implemented

**Input**: "Traduire en français le texte récupéré (le synopsis)."

## User Scenarios & Testing *(mandatory)*

### User Story 1 - Lire le synopsis en français (Priority: P1)

Sur la fiche d'un anime, le synopsis s'affiche en français. S'il n'existe pas de version française officielle, la version anglaise est traduite automatiquement, avec la mention « Traduit automatiquement de l'anglais ».

**Why this priority**: la plupart des synopsis de la source sont en anglais.

**Independent Test**: ouvrir la fiche d'un anime sans synopsis français officiel : le résumé apparaît en français avec la mention.

**Acceptance Scenarios**:

1. **Given** un synopsis français officiel disponible, **When** la fiche s'ouvre, **Then** il est utilisé sans traduction ni mention.
2. **Given** aucun synopsis français officiel, **When** la fiche s'ouvre, **Then** le synopsis anglais est traduit et la mention s'affiche.
3. **Given** une traduction impossible (quota ou réseau), **When** la fiche s'ouvre, **Then** le synopsis anglais reste affiché sans erreur.
4. **Given** une fiche déjà traduite, **When** elle est rouverte, même hors ligne, **Then** la traduction enregistrée est réutilisée sans nouvel appel.
5. **Given** une fiche en cours de traduction, **When** elle s'ouvre, **Then** elle s'affiche d'abord avec le synopsis anglais, puis le synopsis traduit le remplace sans que l'écran ne se recharge.
6. **Given** un synopsis flouté par l'anti-spoil, **When** la fiche s'ouvre, **Then** la mention n'apparaît qu'une fois le synopsis révélé.

### Edge Cases

- Un long synopsis est traduit par morceaux de 450 caractères maximum, aux fins de phrases.
- Si un morceau échoue, aucune traduction partielle n'est affichée.
- Les paragraphes du synopsis sont conservés.

## Requirements *(mandatory)*

### Functional Requirements

- **FR-001**: La fiche MUST préférer le synopsis français officiel.
- **FR-002**: À défaut, l'application MUST traduire le synopsis anglais en français.
- **FR-003**: Une traduction automatique MUST être signalée à l'utilisateur.
- **FR-004**: Un échec de traduction MUST NOT empêcher l'affichage de la fiche.
- **FR-005**: La traduction MUST être enregistrée avec la fiche.
- **FR-006**: La fiche MUST s'afficher aussitôt ses données principales reçues ; le synopsis français ou traduit la met à jour ensuite, sans la bloquer.
- **FR-007**: Les morceaux d'une traduction MUST être demandés en parallèle.

### Key Entities

- **Fiche**: gagne un indicateur « synopsis traduit automatiquement ».

## Success Criteria *(mandatory)*

- **SC-001**: Chaque fiche ouverte au moins une fois en ligne affiche un synopsis en français quand le service de traduction répond.
- **SC-002**: Aucune fiche n'est bloquée par une panne du service de traduction.

## Assumptions

- La traduction passe par le service gratuit MyMemory, sans clé ni compte ; son quota quotidien limite le nombre de nouvelles fiches traduites par jour.
- La qualité est celle d'une traduction automatique.
