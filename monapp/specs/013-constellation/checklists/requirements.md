# Specification Quality Checklist: Constellation

**Purpose**: valider la qualité de la spécification et sa conformité au code livré avant de la considérer comme terminée
**Created**: 2026-10-05
**Feature**: [spec.md](../spec.md)

**Note**: cette checklist est relue par le réviseur. `[x]` signifie que le critère a été vérifié (spec, code, tests ou mesure du 2026-10-05) ; `[ ]` signale un écart connu, expliqué en regard.

## Content Quality

- [x] CHK001 Aucun détail d'implémentation dans les scénarios utilisateur : les user stories parlent d'étoiles, de liens, de genres et de légende ; les noms de classes n'apparaissent que dans les exigences et les hypothèses
- [x] CHK002 Centrée sur la valeur pour l'utilisateur : une vue d'ensemble ludique de ses goûts
- [x] CHK003 Rédigée pour des lecteurs non techniques : scénarios Given/When/Then en français courant
- [x] CHK004 Toutes les sections obligatoires sont complétées (User Scenarios, Requirements, Success Criteria, Assumptions)

## Requirement Completeness

- [x] CHK005 Aucun marqueur `[NEEDS CLARIFICATION]` ne subsiste
- [x] CHK006 Les exigences sont testables et sans ambiguïté : FR-001 à FR-010 sont exercées par les tests `logic_*` et `ui_*` (poids, liens, humeurs, déterminisme, états, aperçu, réduction des animations) ; FR-011 par `ui_entry_card_test.dart` ; FR-012 par `ui_legend_test.dart` et `ui_page_legend_test.dart`
- [x] CHK007 Les critères de succès sont mesurables : 100 animes en moins de 50 ms (test chronométré), mêmes positions à deux ouvertures (test de déterminisme), deux touchers jusqu'à la fiche (test de la page)
- [x] CHK008 Les critères de succès ne dépendent pas de la technologie
- [x] CHK009 Tous les scénarios d'acceptation sont définis pour chaque user story (US1 et US2)
- [x] CHK010 Les cas limites sont identifiés : une seule étoile, anime sans fiche ni genre, genre très fréquent (trois liens au plus), marges de l'écran, liste modifiée pendant l'ouverture
- [x] CHK011 Le périmètre est borné : aucune requête réseau, aucun stockage, humeurs de Découvrir seulement pour la légende
- [x] CHK012 Les dépendances et hypothèses sont identifiées : fiches déjà chargées, injection et navigation dans la couche technique

## Consistency With The Delivered Code

- [x] CHK013 Les entités du spec correspondent à `Constellation`, `ConstellationStar` et `ConstellationLink` (champs vérifiés dans `lib/layers/functional/Constellation/domain/entities/`)
- [x] CHK014 Les poids (0,35 ; 0,55 à 1 ; 1) et les marges (0,06 à 0,94) sont ceux de `BuildConstellationUseCase` et `ConstellationLayout`
- [x] CHK015 Les humeurs de Découvrir sont les valeurs de `EveningMood` ; `EveningMood.any` n'apparaît jamais car son ensemble de genres est vide
- [x] CHK016 `Constellation.genres` ne contient que les humeurs présentes, par fréquence puis ordre alphabétique (tests « ordonne par fréquence puis alphabétique » et « ignore les genres hors Découvrir »)
- [x] CHK017 Les liens restent calculés sur tous les genres Kitsu communs (test « les liens restent calculés sur tous les genres communs »)
- [x] CHK018 La légende affiche toutes les humeurs sur plusieurs lignes et reste sous un tiers d'écran (tests à plusieurs largeurs et avec une police très large)
- [x] CHK019 `ConstellationUnavailableException` est levée pour une liste non vide sans fiche (test « échoue sans aucun détail »)
- [ ] CHK020 « Deux étoiles ne se superposent pas » : le spec a été reformulé car le code évite la superposition par répulsion, sans contrainte dure ; le test vérifie une distance minimale supérieure à 0,02 pour 30 étoiles seulement

## Feature Readiness

- [x] CHK021 Toutes les exigences fonctionnelles ont des critères d'acceptation, via les scénarios des deux user stories
- [x] CHK022 Les user stories couvrent les parcours principaux : voir le ciel, explorer
- [x] CHK023 `flutter analyze` sur le code et les tests de la fonctionnalité : aucun problème (2026-10-05)
- [x] CHK024 Les tests passent : `flutter test test/layers/functional/animedex test/layers/functional/constellation` donne 220 tests verts (2026-10-05)
- [x] CHK025 La couverture des lignes de `Constellation` mesurée est de 98,4 % (746 sur 758), au-dessus du seuil de 80 %

## Constitution Compliance (v1.0.0)

- [x] CHK026 I Architecture OSDD : `domain` et `presentation` sous `lib/layers/functional/Constellation` (pas de `data`, aucune source externe) ; dépendances vers `Anime`, `Discover` et `Catalogue` signalées dans plan.md
- [x] CHK027 II Cubit → use case → contrat : `ConstellationCubit` ne dépend que de `BuildConstellationUseCase`, lui-même branché sur `LoadWatchlistUseCase`, enregistrés dans `get_it`
- [x] CHK028 III Aucun commentaire ni TODO dans `lib/layers/functional/Constellation`
- [ ] CHK029 IV Fichiers courts : conforme pour `lib` (maximum 170 lignes) ; **écart** : `ui_page_test.dart` fait 238 lignes
- [x] CHK030 V Thème centralisé : aucune `Color(0x…)` ni `TextStyle(` littérale (constantes de dessin locales décrites dans plan.md)
- [x] CHK031 VI Internationalisation : 12 clés `constellation…`, libellés d'humeurs de Découvrir, aucun texte en dur
- [x] CHK032 VII Quatre états explicites (chargement, succès, vide, erreur) et aucun texte d'exception affiché
- [x] CHK033 VIII Tests livrés, couverture au-dessus de 80 %, aucune exclusion de couverture
- [x] CHK034 IX Aucun secret : aucun appel externe
- [x] CHK035 X Nommage et exception de domaine nommée (`ConstellationUnavailableException`), aucune exception générique levée
- [ ] CHK036 XI Images distantes : **écart** : l'affiche de l'aperçu passe par `AnimePoster`, qui utilise `Image.network` ; `cached_network_image` n'est pas dans `pubspec.yaml` ; placeholder et repli présents, sans cache disque (dérogation justifiée dans plan.md)

## Notes

- Les trois cases décochées (CHK020, CHK029, CHK036) sont des écarts assumés ; les deux derniers sont documentés dans Complexity Tracking de `plan.md`.
- La couverture lcov ne compte que les fichiers importés par les tests : l'insertion de la carte d'entrée dans `stats_view.dart` n'est pas couverte par un test de l'écran des statistiques.
