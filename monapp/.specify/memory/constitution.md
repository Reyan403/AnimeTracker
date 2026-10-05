<!--
Sync Impact Report
Version change: template (non versionné) → 1.0.0
Principes modifiés : aucun (première ratification)
Principes ajoutés : I à XI
Sections ajoutées : Contraintes techniques, Workflow de développement et portes qualité
Sections supprimées : aucune
TODO différés : aucun
-->
# monapp Constitution

## Core Principles

### I. Architecture OSDD (NON-NEGOTIABLE)
Le code MUST être organisé en couches techniques réutilisables, séparées des couches
fonctionnelles propres à chaque domaine métier. Chaque couche MUST nommer le domaine ou la
préoccupation d'infrastructure unique dont elle est responsable. Les couches fourre-tout
(`core`, `common`, `shared`, `utils`, `helpers`, `base`, `misc`) sont interdites : un code
partagé va dans une couche fonctionnelle commune ou dans sa propre couche technique.

### II. Cubit → use case → contrat de gateway (NON-NEGOTIABLE)
Un cubit MUST dépendre uniquement de use cases. Il ne dépend jamais d'un gateway, d'un
repository, de Dio ni d'un stockage. Chaque action utilisateur MUST avoir son use case, avec
une seule méthode `call()`. Un use case ne référence que le contrat abstrait du domaine, jamais
son implémentation. Contrats, implémentations et use cases sont enregistrés dans `get_it`.

### III. Aucun commentaire
Le code MUST NOT contenir de commentaires, de TODO, de code commenté ni de bannières. Seul un
docblock sur une déclaration est toléré, trois lignes maximum, pour un contrat ou un risque que
la signature n'exprime pas. Le nom d'un symbole ou d'un test fait office de documentation.

### IV. Fichiers courts et widgets décomposés
Un fichier de code MUST rester sous 200 lignes. Chaque morceau d'UI MUST être une classe widget
dédiée dans son propre fichier ; les méthodes privées `_buildXxx` sont interdites. Il y a un
cubit par écran, avec un état découpé et une logique métier portée par les use cases.

### V. Thème centralisé
Couleurs, styles de texte et espacements MUST être définis dans la couche de thème et lus via
`Theme.of(context)`. Aucune `Color`, `TextStyle` ou valeur d'espacement ne peut être codée en
dur dans un widget. Si `xefi_flutter_ui_kit` est utilisé, son thème fait foi et un token local
n'est défini que pour ce qu'il ne couvre pas.

### VI. Internationalisation
Tout texte affiché à l'utilisateur MUST passer par l'i18n. Aucune chaîne utilisateur n'est
écrite en dur dans un widget, un cubit ou un use case.

### VII. États asynchrones explicites
Tout écran qui charge des données MUST rendre explicitement les quatre états : chargement,
succès, vide et erreur. Un écran blanc ou un contenu périmé est interdit. Le texte brut d'une
exception MUST NOT être affiché à l'utilisateur.

### VIII. Tests livrés avec la fonctionnalité
Chaque nouvelle fonctionnalité MUST être livrée avec ses tests unitaires et widget. Au moins
80 % des lignes ajoutées ou modifiées MUST être couvertes par un test de la même livraison.
Les annotations d'exclusion de couverture et les tests sans assertion sont interdits.

### IX. Aucun secret dans le code
Aucun secret, clé ou jeton ne MUST apparaître dans le code. La configuration passe par
`dart_defines.json`, qui reste hors du dépôt, et un fichier d'exemple sans valeur réelle
documente les clés attendues.

### X. Nommage et exceptions
Les fichiers MUST être en `snake_case`. Les classes portent leur rôle en suffixe (`Cubit`,
`State`, `UseCase`, `Gateway`). Les exceptions génériques (`Exception`, `Error`) MUST NOT être
levées directement : on définit et on lève une exception de domaine nommée.

### XI. Images distantes
Toute image distante MUST utiliser `cached_network_image`, avec un placeholder pendant le
chargement et un widget de repli en cas d'échec. `Image.network` est interdit.

## Contraintes techniques

- Cible : application Flutter avec gestion d'état par cubits et injection par `get_it`.
- Les appels HTTP passent par un client dédié qui porte l'URL de base, l'authentification, les
  délais et la gestion d'erreurs ; aucun appel brut depuis un consommateur.
- Les dépendances dépréciées ne sont pas introduites dans de nouveaux développements.

## Workflow de développement et portes qualité

- Chaque fonctionnalité suit le cycle spec-kit : spécification, plan, tâches, implémentation.
- Le plan MUST passer un contrôle de conformité à cette constitution avant d'être validé.
- Avant livraison : analyse statique sans erreur, tests verts, couverture des lignes ajoutées
  conforme au principe VIII.
- Les messages de commit suivent la convention du projet et ne portent aucune attribution à une
  IA.

## Governance

Cette constitution prime sur les autres pratiques du projet. Toute modification MUST être
documentée, relue et accompagnée d'un plan de migration si elle invalide du code existant. La
version suit le versionnement sémantique : MAJOR pour la suppression ou la redéfinition
incompatible d'un principe, MINOR pour l'ajout d'un principe ou d'une section, PATCH pour une
clarification. Chaque revue de code et chaque plan MUST vérifier la conformité ; toute
dérogation MUST être justifiée par écrit dans le plan concerné.

**Version**: 1.0.0 | **Ratified**: 2026-10-05 | **Last Amended**: 2026-10-05
