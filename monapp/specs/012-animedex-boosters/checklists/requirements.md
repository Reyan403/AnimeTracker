# Specification Quality Checklist: Animédex et boosters quotidiens

**Purpose**: valider la qualité de la spécification et sa conformité au code livré avant de la considérer comme terminée
**Created**: 2026-10-05
**Feature**: [spec.md](../spec.md)

**Note**: cette checklist est relue par le réviseur. `[x]` signifie que le critère a été vérifié (spec, code, tests ou mesure du 2026-10-05) ; `[ ]` signale un écart connu, expliqué en regard.

## Content Quality

- [x] CHK001 Aucun détail d'implémentation dans les scénarios utilisateur : les user stories parlent de cartes, de collection et de rareté ; les noms de classes n'apparaissent que dans les exigences et les hypothèses
- [x] CHK002 Centrée sur la valeur pour l'utilisateur : le rendez-vous quotidien, la collection, la découverte de personnages
- [x] CHK003 Rédigée pour des lecteurs non techniques : scénarios Given/When/Then en français courant
- [x] CHK004 Toutes les sections obligatoires sont complétées (User Scenarios, Requirements, Success Criteria, Assumptions)

## Requirement Completeness

- [x] CHK005 Aucun marqueur `[NEEDS CLARIFICATION]` ne subsiste
- [x] CHK006 Les exigences sont testables et sans ambiguïté : les exigences de comportement FR-001 à FR-016 sont exercées par des tests (tirage, rareté, stockage, filtres, dialogue) ; FR-017 (i18n) est vérifiée par la génération `gen-l10n` et l'analyse
- [x] CHK007 Les critères de succès sont mesurables : une requête par booster (test du gateway), répartition des raretés (test de `RarityRule`), jour non consommé en cas de panne (test du use case)
- [x] CHK008 Les critères de succès ne dépendent pas de la technologie, hors les chiffres de l'API assumés dans les hypothèses
- [x] CHK009 Tous les scénarios d'acceptation sont définis pour chaque user story (US1 à US6)
- [x] CHK010 Les cas limites sont identifiés : jour au format `yyyy-MM-dd`, favoris inconnus, portrait par défaut, titre absent, délai de 4 s, notation compacte, onglet non persisté
- [x] CHK011 Le périmètre est borné : pas de synchronisation entre appareils, pas de persistance du filtre, un personnage n'a pas de fiche d'anime
- [x] CHK012 Les dépendances et hypothèses sont identifiées : AniList public, 5000 personnages, tranches de rang et seuils mesurés (rang 60 : 14 680 favoris, rang 300 : 5 435, rang 1500 : 1 080, rang 5000 : 229)

## Consistency With The Delivered Code

- [x] CHK013 Les entités du spec correspondent à `DexCard`, `DrawnCard`, `BoosterAvailability` et `DexFilter` (champs vérifiés dans `lib/layers/functional/Animedex/`)
- [x] CHK014 Les probabilités (60 / 28 / 9 / 3 %), les tranches (1 à 60, 61 à 300, 301 à 1500, 1501 à 5000) et les seuils de favoris (14 000, 5 400, 1 100) sont identiques à `RarityRule`
- [x] CHK015 Les exceptions de domaine nommées (`BoosterAlreadyOpenedException`, `BoosterUnavailableException`) existent et sont levées aux endroits décrits
- [x] CHK016 Le comportement « jour marqué après un tirage réussi » est confirmé par le test « laisse passer l'indisponibilité sans marquer le jour »
- [x] CHK017 Les onglets Booster et Collection, la recherche sans accents, les filtres de rareté, les quatre tris et l'état « aucun résultat » du spec existent dans `DexCubit` et les widgets de collection
- [x] CHK018 Le spec ne parle plus d'animés ni de Kitsu : les cartes sont des personnages AniList

## Feature Readiness

- [x] CHK019 Toutes les exigences fonctionnelles ont des critères d'acceptation, via les scénarios des six user stories
- [x] CHK020 Les user stories couvrent les parcours principaux : ouvrir, consulter, savoir quand revenir, révéler, parcourir, détailler
- [x] CHK021 `flutter analyze` sur le code et les tests de la fonctionnalité : aucun problème (2026-10-05)
- [x] CHK022 Les tests passent : `flutter test test/layers/functional/animedex test/layers/functional/constellation` donne 220 tests verts (2026-10-05)
- [x] CHK023 La couverture des lignes d'`Animedex` mesurée est de 98,5 % (1442 sur 1464), au-dessus du seuil de 80 %

## Constitution Compliance (v1.0.0)

- [x] CHK024 I Architecture OSDD : `domain`, `data`, `presentation` sous `lib/layers/functional/Animedex`
- [x] CHK025 II Cubit → use case → contrat : les deux cubits ne dépendent que de use cases, enregistrés dans `get_it` (réserve : filtre local sans use case, voir plan.md)
- [x] CHK026 III Aucun commentaire ni TODO dans `lib/layers/functional/Animedex`
- [ ] CHK027 IV Fichiers courts : conforme pour `lib` (maximum 151 lignes) ; **écart** : 5 fichiers de test dépassent 200 lignes (`ui_booster_test.dart` 372, `ui_dex_view_test.dart` 228, `domain_data_storage_test.dart` 216, `domain_data_open_booster_test.dart` 204, `ui_collection_test.dart` 202)
- [x] CHK028 V Thème centralisé : aucune `Color(0x…)` ni `TextStyle(` littérale (écarts mineurs de dimensions de dessin décrits dans plan.md)
- [x] CHK029 VI Internationalisation : 53 clés `dex…`, aucun texte utilisateur en dur
- [x] CHK030 VII Quatre états explicites (chargement, succès, vide, erreur) et aucun texte d'exception affiché
- [x] CHK031 VIII Tests livrés, couverture au-dessus de 80 %, aucune exclusion de couverture
- [x] CHK032 IX Aucun secret : API publique, `dart_defines.json` non touché
- [x] CHK033 X Nommage et exceptions de domaine nommées, aucune exception générique levée
- [ ] CHK034 XI Images distantes : **écart** : `AnimePoster` utilise `Image.network` et `cached_network_image` n'est pas dans `pubspec.yaml` ; placeholder et repli présents, sans cache disque (dérogation justifiée dans plan.md)

## Notes

- Les deux cases décochées (CHK027, CHK034) sont des écarts assumés, documentés dans la section Complexity Tracking de `plan.md`.
- La couverture lcov ne compte que les fichiers importés par les tests ; l'insertion de la carte d'entrée dans les statistiques relève de la feature 013.
