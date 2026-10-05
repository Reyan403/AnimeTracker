# Feature Specification: Constellation

**Created**: 2026-10-05

**Status**: Implemented

**Input**: "Une carte du ciel de ma liste : chaque anime est une étoile, reliée aux animes qui partagent des genres."

## User Scenarios & Testing *(mandatory)*

### User Story 1 - Voir ma liste comme un ciel étoilé (Priority: P1)

Depuis l'écran des statistiques, une carte « Ma constellation » ouvre une page plein écran. Chaque anime de la liste y est une étoile scintillante. Les animes qui partagent au moins un genre sont reliés par un trait. Les animes terminés sont les étoiles les plus grosses, les animes en cours grossissent avec leur progression, les animes à voir sont les plus petites.

**Why this priority**: c'est le cœur de la fonctionnalité, une vue d'ensemble ludique de ses goûts.

**Independent Test**: avec une liste de plusieurs animes aux genres communs, ouvrir la page : un ciel d'étoiles reliées s'affiche, avec la même disposition à chaque ouverture.

**Acceptance Scenarios**:

1. **Given** une liste contenant des animes aux genres communs, **When** la page s'ouvre, **Then** chaque anime est une étoile et les animes partageant un genre sont reliés.
2. **Given** des animes à voir, en cours et terminés, **When** le ciel s'affiche, **Then** la taille des étoiles croît du statut « à voir » au statut « terminé », la progression faisant grossir les animes en cours.
3. **Given** la même liste, **When** la page est rouverte, **Then** les étoiles occupent les mêmes positions.
4. **Given** une liste vide, **When** la page s'ouvre, **Then** un message invite à ajouter des animes, sans erreur.
5. **Given** aucune fiche disponible (réseau et cache absents), **When** la page s'ouvre, **Then** un message d'erreur lisible avec une action de nouvel essai s'affiche, sans texte d'exception.
6. **Given** un chargement en cours, **When** la page s'ouvre, **Then** un état de chargement s'affiche aussitôt.

### User Story 2 - Explorer le ciel (Priority: P2)

Le ciel se déplace et se zoome au doigt. Une légende liste les genres les plus fréquents, chacun avec sa couleur, et permet de n'allumer que les étoiles d'un genre. Toucher une étoile ouvre un aperçu (affiche, titre, statut, nombre de liens) avec un bouton « Ouvrir la fiche » qui ouvre la fiche de l'anime.

**Why this priority**: l'exploration donne de la valeur à la carte, mais le ciel reste lisible sans elle.

**Independent Test**: toucher une étoile puis « Ouvrir la fiche » affiche la fiche de l'anime ; choisir un genre dans la légende atténue les autres étoiles.

**Acceptance Scenarios**:

1. **Given** le ciel affiché, **When** l'utilisateur pince ou fait glisser, **Then** le ciel se zoome et se déplace.
2. **Given** le ciel affiché, **When** l'utilisateur touche une étoile, **Then** un aperçu de l'anime apparaît avec « Ouvrir la fiche ».
3. **Given** un aperçu ouvert, **When** l'utilisateur touche « Ouvrir la fiche », **Then** la fiche de l'anime s'ouvre.
4. **Given** la légende des genres, **When** l'utilisateur choisit un genre, **Then** seules les étoiles de ce genre restent allumées ; le choisir de nouveau rétablit tout le ciel.
5. **Given** la réduction des animations activée sur l'appareil, **When** le ciel s'affiche, **Then** les étoiles ne scintillent pas.

### Edge Cases

- Un seul anime : une unique étoile, centrée, sans lien.
- Un anime sans fiche ni genre : étoile présente, sans lien ni couleur de genre.
- Beaucoup d'animes partageant un même genre : chaque étoile n'est reliée qu'à trois autres au plus pour garder le ciel lisible.
- Aucune étoile ne sort des marges de l'écran (positions entre 6 % et 94 % de chaque axe) et deux étoiles ne se superposent pas.
- Une liste modifiée pendant que la page est ouverte met le ciel à jour.

## Requirements *(mandatory)*

### Functional Requirements

- **FR-001**: Chaque anime de la liste, tous statuts confondus, MUST apparaître comme une étoile.
- **FR-002**: Deux étoiles MUST être reliées si leurs animes partagent au moins un genre ; une étoile MUST avoir au plus trois liens, les plus forts (nombre de genres communs) étant préférés, et une paire MUST NOT être reliée deux fois.
- **FR-003**: Le poids d'une étoile MUST croître avec l'avancement : 0,35 pour « à voir », de 0,55 à 1 pour « en cours » selon les épisodes vus, 1 pour « terminé ».
- **FR-004**: Le genre principal d'une étoile MUST être le plus fréquent de la liste parmi ses genres, l'ordre alphabétique départageant ; la liste des genres de la constellation MUST être ordonnée par fréquence puis alphabétique.
- **FR-005**: La disposition MUST être déterministe : une même liste produit les mêmes positions, indépendamment de l'ordre des animes ; elle repose sur une relaxation de type force-dirigée amorcée par les identifiants, bornée en nombre d'itérations.
- **FR-006**: Le calcul de la disposition MUST rester inférieur à 50 ms pour 100 animes.
- **FR-007**: La construction MUST attendre que les fiches soient chargées, comme les statistiques, et MUST signaler une indisponibilité (`ConstellationUnavailableException`) si aucune fiche n'est disponible pour une liste non vide.
- **FR-008**: La page MUST rendre les quatre états : chargement, succès, vide, erreur, avec des textes traduits et sans texte d'exception.
- **FR-009**: Le ciel MUST pouvoir être zoomé et déplacé ; toucher une étoile MUST ouvrir un aperçu menant à la fiche de l'anime.
- **FR-010**: La page MUST respecter la réduction des animations et dessiner le ciel dans une couche isolée pour rester fluide.
- **FR-011**: L'écran des statistiques MUST proposer une carte d'entrée vers la constellation, visible même sans liste.

### Key Entities

- **Constellation**: étoiles, liens et genres ordonnés par fréquence.
- **Étoile**: un anime, avec statut, position dans [0, 1] × [0, 1], poids dans [0, 1], genre principal et affiche.
- **Lien**: deux étoiles et le nombre de genres qu'elles partagent.

## Success Criteria *(mandatory)*

- **SC-001**: Le ciel de 100 animes se calcule en moins de 50 ms et s'affiche sans bloquer l'écran.
- **SC-002**: Deux ouvertures successives avec la même liste donnent exactement la même carte.
- **SC-003**: Une étoile touchée mène à la fiche de son anime en deux touchers.

## Assumptions

- Les genres viennent des fiches déjà chargées pour la liste ; aucune requête supplémentaire n'est nécessaire.
- La logique métier se trouve dans `BuildConstellationUseCase`, `ConstellationLayout` et `ConstellationLinksBuilder` ; la page, le cubit, le dessin et l'entrée dans les statistiques relèvent de la présentation.
- L'architecte câble l'injection et la navigation.
