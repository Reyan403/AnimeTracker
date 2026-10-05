# Feature Specification: Anti-spoil et mode hors ligne

**Created**: 2026-10-05

**Status**: Implemented

**Input**: "Anti-spoil et mode hors ligne, faciles et utiles même seul."

## User Scenarios & Testing *(mandatory)*

### User Story 1 - Ne pas me faire spoiler (Priority: P1)

Sur la fiche de tout anime qu'il n'a pas terminé, qu'il soit dans sa liste ou seulement dans le catalogue, le synopsis apparaît flouté avec un bouton « Afficher ». Un réglage permet de désactiver cette protection.

**Why this priority**: évite de gâcher une série en cours en lisant son résumé.

**Independent Test**: ouvrir la fiche d'un anime « En cours » : le synopsis est flouté ; le toucher sur « Afficher » le révèle.

**Acceptance Scenarios**:

1. **Given** la protection active et un anime « À voir » ou « En cours », **When** la fiche s'ouvre, **Then** le synopsis est flouté et masqué aux lecteurs d'écran.
2. **Given** un synopsis flouté, **When** l'utilisateur touche « Afficher », **Then** le synopsis devient lisible.
3. **Given** un anime terminé, **When** la fiche s'ouvre, **Then** le synopsis est lisible directement.
4. **Given** un anime du catalogue absent de la liste, **When** la fiche s'ouvre, **Then** son synopsis est flouté comme les autres.
5. **Given** la protection désactivée dans les réglages, **When** une fiche s'ouvre, **Then** aucun synopsis n'est flouté.
6. **Given** un réglage modifié, **When** l'application est relancée, **Then** le réglage est conservé.

### User Story 2 - Consulter sans connexion (Priority: P2)

Sans connexion, la liste et les fiches déjà consultées restent affichées à partir des dernières données enregistrées, avec un bandeau « Hors ligne ».

**Why this priority**: l'application reste utile dans le train ou en cas de panne du service.

**Independent Test**: consulter la liste et une fiche en ligne, couper le réseau, relancer : liste et fiche s'affichent avec le bandeau.

**Acceptance Scenarios**:

1. **Given** des détails déjà chargés, **When** le service est injoignable, **Then** la liste s'affiche avec ses affiches et un bandeau hors ligne.
2. **Given** une fiche déjà consultée, **When** le service est injoignable, **Then** la fiche s'affiche avec un bandeau hors ligne.
3. **Given** une fiche jamais consultée, **When** le service est injoignable, **Then** l'erreur habituelle avec « Réessayer » s'affiche.
4. **Given** le retour de la connexion, **When** l'utilisateur recharge, **Then** les données fraîches remplacent les données enregistrées.

### Edge Cases

- Au plus 30 fiches sont conservées ; les plus anciennes sont écartées.
- Des données enregistrées illisibles sont ignorées sans erreur.

## Requirements *(mandatory)*

### Functional Requirements

- **FR-001**: Une protection anti-spoil MUST flouter le synopsis de tout anime non terminé, listé ou non, activée par défaut.
- **FR-002**: L'utilisateur MUST pouvoir révéler un synopsis flouté et désactiver la protection dans les réglages.
- **FR-003**: Le réglage MUST être conservé entre deux lancements.
- **FR-004**: Les détails de la liste et les fiches consultées MUST être enregistrés à chaque chargement réussi.
- **FR-005**: En cas d'échec réseau, l'application MUST utiliser les données enregistrées et l'indiquer par un bandeau.
- **FR-006**: Sans données enregistrées, l'état d'erreur MUST rester inchangé.

### Key Entities

- **Réglage anti-spoil**: booléen persistant. **Données enregistrées**: détails de liste et fiches complètes.

## Success Criteria *(mandatory)*

- **SC-001**: Aucun synopsis d'un anime non terminé n'est lisible sans action explicite quand la protection est active.
- **SC-002**: Une liste et des fiches déjà vues s'affichent en moins d'une seconde sans connexion, après le délai d'échec réseau.

## Assumptions

- Le catalogue complet et la recherche nécessitent toujours une connexion.
- Le synopsis français récupéré en ligne est enregistré avec la fiche.
