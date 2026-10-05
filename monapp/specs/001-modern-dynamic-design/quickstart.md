# Quickstart: validation de la refonte du design

## Prérequis

- SDK Flutter du dossier `C:\Users\Utilisateur\Documents\flutter` (`bin\flutter.bat`).
- Cible : Chrome (Windows desktop indisponible sans Visual Studio) ou un émulateur mobile.

## Vérifications automatiques

```powershell
flutter pub get
flutter gen-l10n
flutter analyze
flutter test --coverage
```

Résultat attendu : aucune erreur d'analyse, tous les tests verts, couverture des lignes
ajoutées ≥ 80 %.

## Validation manuelle

```powershell
flutter run -d chrome --dart-define-from-file=dart_defines.json
```

| Scénario | Résultat attendu | Spec |
|----------|------------------|------|
| Basculer l'appareil en mode sombre puis clair | l'apparence suit sans redémarrage, rien d'illisible | US1, FR-002, FR-003 |
| Parcourir Ma liste et Catalogue | cartes à affiche dominante, onglet actif nettement distinct | US2, FR-004, FR-005 |
| Ouvrir une fiche depuis une carte | l'affiche se prolonge vers la fiche | US3, FR-008 |
| Ajouter un anime, changer un statut | retour visuel immédiat sur l'élément | US3, FR-010 |
| Charger, vider, couper le réseau | squelettes animés, état vide, erreur avec « Réessayer » | US4, FR-011, FR-012 |
| Activer « réduire les animations » du système | aucune animation décorative | FR-013 |
| Agrandir le texte à 200 % | aucun contenu coupé | FR-016, SC-007 |
| Élargir la fenêtre au-delà de 840 px | rail latéral et grille d'affiches | FR-017 |
