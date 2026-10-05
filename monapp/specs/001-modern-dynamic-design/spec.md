# Feature Specification: Refonte du design moderne et dynamique

**Feature Branch**: `001-modern-dynamic-design`

**Created**: 2026-10-05

**Status**: Draft

**Input**: User description: "Refonte du design de l'application monapp (suivi d'animes : écrans Ma liste, Catalogue et fiche anime) pour obtenir une interface propre, moderne et dynamique."

## User Scenarios & Testing *(mandatory)*

### User Story 1 - Identité visuelle moderne, claire et sombre (Priority: P1)

L'utilisateur ouvre l'application et découvre une interface cohérente : palette, typographie, formes et ombres modernes, identiques sur tous les écrans. L'apparence suit le réglage clair ou sombre de son appareil, et chaque écran reste lisible dans les deux modes.

**Why this priority**: c'est le socle visuel dont dépendent toutes les autres améliorations ; sans lui, les animations et cartes n'ont pas de langage commun.

**Independent Test**: lancer l'application en mode clair puis en mode sombre et parcourir Ma liste, Catalogue et une fiche anime : aucun écran ne présente de couleur illisible, de fond blanc isolé en mode sombre ni de style qui détonne.

**Acceptance Scenarios**:

1. **Given** un appareil réglé en mode sombre, **When** l'utilisateur ouvre l'application, **Then** tous les écrans s'affichent avec la palette sombre et un texte lisible.
2. **Given** l'application ouverte, **When** l'utilisateur change le réglage clair/sombre de son appareil, **Then** l'apparence bascule sans redémarrage.
3. **Given** n'importe quel écran, **When** l'utilisateur le compare aux autres, **Then** titres, textes, boutons et cartes partagent les mêmes styles.

---

### User Story 2 - Navigation et cartes redessinées avec affiches mises en valeur (Priority: P1)

L'utilisateur navigue entre Ma liste et Catalogue grâce à une barre de navigation modernisée. Les animes sont présentés sous forme de cartes où l'affiche est l'élément principal, avec titre, statut et informations clés clairement hiérarchisés.

**Why this priority**: la navigation et les cartes sont ce que l'utilisateur voit en permanence ; elles portent l'essentiel de l'impression de modernité.

**Independent Test**: depuis Ma liste puis Catalogue, vérifier que chaque anime s'affiche en carte avec affiche dominante, et que la barre de navigation indique clairement l'onglet actif.

**Acceptance Scenarios**:

1. **Given** Ma liste contenant des animes, **When** l'écran s'affiche, **Then** chaque anime apparaît dans une carte dont l'affiche est le visuel principal.
2. **Given** deux onglets de navigation, **When** l'utilisateur en sélectionne un, **Then** l'onglet actif est visuellement distinct et l'autre reste identifiable.
3. **Given** une affiche absente ou en échec de chargement, **When** la carte s'affiche, **Then** un visuel de remplacement soigné prend sa place.

---

### User Story 3 - Animations et micro-interactions (Priority: P2)

L'interface réagit aux actions : les transitions entre onglets et écrans sont fluides, les listes apparaissent progressivement, l'affiche glisse vers la fiche lors de l'ouverture d'un anime, et l'ajout à la liste ou le changement de statut donnent un retour visuel immédiat.

**Why this priority**: elle apporte le caractère dynamique demandé, mais repose sur les cartes et l'identité de la P1.

**Independent Test**: ouvrir une fiche depuis une carte, ajouter un anime à sa liste et changer son statut ; chaque action produit une animation perceptible et se termine en moins d'une seconde.

**Acceptance Scenarios**:

1. **Given** une carte d'anime, **When** l'utilisateur l'ouvre, **Then** l'affiche se prolonge visuellement vers la fiche au lieu d'apparaître brusquement.
2. **Given** un anime du catalogue, **When** l'utilisateur l'ajoute à sa liste, **Then** un retour visuel confirme l'ajout sur l'élément concerné.
3. **Given** un anime de la liste, **When** l'utilisateur change son statut, **Then** l'élément réagit visuellement à ce changement.
4. **Given** une liste qui se charge, **When** les résultats arrivent, **Then** les éléments apparaissent progressivement plutôt que d'un bloc.
5. **Given** un appareil configuré pour réduire les animations, **When** l'utilisateur utilise l'application, **Then** les animations décoratives sont supprimées ou réduites au minimum.

---

### User Story 4 - États de chargement, vide et erreur soignés (Priority: P2)

Quand les données se chargent, que la liste est vide ou qu'une erreur survient, l'utilisateur voit un état clair et cohérent avec le nouveau design : squelettes animés pendant le chargement, message illustré quand il n'y a rien, message d'erreur compréhensible avec possibilité de réessayer.

**Why this priority**: ces états sont fréquents et trahissent vite une interface inachevée.

**Independent Test**: provoquer un chargement lent, une liste vide et une erreur réseau sur chaque écran concerné ; chaque cas affiche un état dédié dans le style du nouveau design.

**Acceptance Scenarios**:

1. **Given** un chargement en cours, **When** l'écran s'affiche, **Then** des squelettes animés reprennent la forme des cartes.
2. **Given** une liste ou une recherche sans résultat, **When** l'écran s'affiche, **Then** un état vide explicite oriente l'utilisateur vers une action.
3. **Given** une erreur de chargement, **When** l'écran s'affiche, **Then** un message en langage courant et un bouton pour réessayer sont proposés, sans texte technique.

---

### User Story 5 - Accessibilité et adaptation mobile et web (Priority: P3)

L'interface reste confortable pour tous : contrastes suffisants, zones tactiles assez grandes, texte qui s'adapte à la taille choisie par l'utilisateur, et mise en page qui exploite l'espace disponible aussi bien sur un téléphone que sur une fenêtre de navigateur large.

**Why this priority**: indispensable à la qualité, mais s'appuie sur les écrans déjà redessinés.

**Independent Test**: parcourir l'application sur un écran de téléphone puis dans une large fenêtre de navigateur, avec le texte agrandi : rien n'est coupé, ne déborde ni ne devient inutilisable.

**Acceptance Scenarios**:

1. **Given** n'importe quel texte, **When** il s'affiche sur son fond, **Then** le contraste respecte le niveau AA des recommandations d'accessibilité.
2. **Given** n'importe quel élément interactif, **When** l'utilisateur le touche, **Then** sa zone tactile mesure au moins 48 par 48 points.
3. **Given** une fenêtre large, **When** l'écran s'affiche, **Then** le contenu s'organise sur plusieurs colonnes ou dans une largeur maximale lisible, sans étirement excessif.
4. **Given** une taille de texte système augmentée, **When** l'écran s'affiche, **Then** le contenu reste entièrement lisible sans débordement.

---

### Edge Cases

- Titre d'anime très long : il est tronqué proprement sans casser la carte.
- Affiche manquante ou dont le chargement échoue : un visuel de remplacement s'affiche à la place.
- Liste très longue : le défilement reste fluide et les animations d'apparition ne s'appliquent qu'aux éléments visibles.
- Réduction des animations activée : aucune animation décorative ne se joue, la navigation reste compréhensible.
- Bascule clair/sombre pendant qu'une fiche est ouverte : l'affichage s'adapte sans perte de position ni d'état.
- Fenêtre redimensionnée en cours d'utilisation : la mise en page s'adapte sans erreur d'affichage.
- Connexion perdue pendant une animation de chargement : l'état d'erreur remplace le chargement sans scintillement.

## Requirements *(mandatory)*

### Functional Requirements

- **FR-001**: L'application MUST proposer une identité visuelle unique (palette, typographie, formes, ombres) appliquée à tous les écrans : Ma liste, Catalogue et fiche anime.
- **FR-002**: L'application MUST proposer un mode clair et un mode sombre et suivre le réglage de l'appareil.
- **FR-003**: Chaque écran MUST rester pleinement lisible et utilisable dans les deux modes.
- **FR-004**: Les animes MUST être présentés sous forme de cartes mettant l'affiche en avant, avec titre et statut lisibles.
- **FR-005**: La navigation entre Ma liste et Catalogue MUST être redessinée et indiquer clairement l'onglet actif.
- **FR-006**: L'application MUST afficher un visuel de remplacement lorsqu'une affiche est absente ou ne se charge pas.
- **FR-007**: Les transitions entre onglets et entre écrans MUST être animées de façon fluide.
- **FR-008**: L'ouverture d'une fiche depuis une carte MUST prolonger visuellement l'affiche vers la fiche.
- **FR-009**: Les listes MUST apparaître progressivement lors de leur affichage.
- **FR-010**: L'ajout à la liste et le changement de statut MUST produire un retour visuel immédiat sur l'élément concerné.
- **FR-011**: Les écrans de données MUST afficher des états de chargement, vide et erreur distincts et cohérents avec le nouveau design.
- **FR-012**: L'état d'erreur MUST présenter un message compréhensible et une action pour réessayer, sans texte technique.
- **FR-013**: Quand l'appareil demande de réduire les animations, l'application MUST supprimer ou réduire les animations décoratives.
- **FR-014**: Les textes MUST respecter un contraste de niveau AA avec leur fond dans les deux modes.
- **FR-015**: Chaque élément interactif MUST offrir une zone tactile d'au moins 48 par 48 points.
- **FR-016**: Le contenu MUST s'adapter à la taille de texte choisie par l'utilisateur sans débordement.
- **FR-017**: La mise en page MUST s'adapter aux écrans de téléphone comme aux fenêtres de navigateur larges.
- **FR-018**: La refonte MUST NOT modifier le comportement métier, les sources de données ni la logique de gestion d'état existants.

### Key Entities *(include if feature involves data)*

- **Jeu de styles visuels**: l'ensemble des couleurs, styles de texte, espacements, formes et ombres partagés par tous les écrans, décliné en variantes claire et sombre.
- **Carte d'anime**: la présentation d'un anime (affiche, titre, statut, informations clés) utilisée dans Ma liste et dans le Catalogue.
- **État d'écran**: l'un des quatre états possibles d'un écran de données : chargement, contenu, vide ou erreur.

## Success Criteria *(mandatory)*

### Measurable Outcomes

- **SC-001**: 100 % des écrans (Ma liste, Catalogue, fiche anime) sont utilisables sans défaut de lisibilité en mode clair et en mode sombre.
- **SC-002**: 100 % des textes atteignent un contraste de niveau AA dans les deux modes.
- **SC-003**: 100 % des éléments interactifs ont une zone tactile d'au moins 48 par 48 points.
- **SC-004**: Chaque animation de transition ou de retour visuel se termine en moins d'une seconde et ne provoque aucun saccade perceptible sur un appareil courant.
- **SC-005**: Les trois écrans présentent chacun les états de chargement, vide et erreur dans le nouveau style, sans écran blanc.
- **SC-006**: Avec la réduction des animations activée, aucune animation décorative ne se joue.
- **SC-007**: Avec une taille de texte système agrandie jusqu'à 200 %, aucun contenu n'est coupé ni illisible.
- **SC-008**: Au moins 90 % des testeurs jugent la nouvelle interface plus moderne que l'ancienne lors d'une comparaison directe.

## Assumptions

- Le mode clair ou sombre suit le réglage de l'appareil ; aucun sélecteur manuel n'est ajouté dans cette version.
- Les deux onglets existants (Ma liste, Catalogue) et la fiche anime sont les seuls écrans concernés.
- Les données affichées (titres, affiches, synopsis, statuts) et leurs sources restent inchangées.
- La police serif actuelle peut être remplacée par une typographie plus moderne si elle ne convient pas au nouveau style.
- Les contraintes de la constitution du projet (thème centralisé, textes traduits, états asynchrones explicites, fichiers courts, tests livrés avec la fonctionnalité) s'appliquent à cette refonte.
- L'application cible les téléphones et les navigateurs ; une tablette ou un bureau natif bénéficie de la mise en page adaptative sans travail dédié.
