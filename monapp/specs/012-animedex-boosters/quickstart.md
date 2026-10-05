# Quickstart: Animédex et boosters quotidiens

**Feature**: `012-animedex-boosters` | **Date**: 2026-10-05

Toutes les commandes se lancent depuis `monapp/` (le dossier du projet Flutter).

## Prérequis

- Flutter avec Dart 3.13 ou plus récent (`sdk: ^3.13.3`).
- Dépendances installées : `flutter pub get`.
- Textes générés : `flutter gen-l10n` (après toute modification de `lib/l10n/app_fr.arb`).
- Aucune clé d'API : AniList est public. Ne pas ouvrir ni afficher `dart_defines.json`.

## Analyse statique

```text
flutter analyze lib/layers/functional/Animedex test/layers/functional/animedex
```

Résultat attendu : `No issues found!`.

## Tests

```text
flutter test test/layers/functional/animedex
```

Résultat attendu : tous les tests passent (132 cas déclarés dans ce dossier). Sous-ensembles :

- logique et données : fichiers `domain_data_*` (règle de rareté, gateway AniList avec `MockClient`, DTO, stockage, use cases) ;
- interface : fichiers `ui_*` (onglets, collection, filtres, booster, carte holographique, dialogue).

Couverture :

```text
flutter test test/layers/functional/animedex --coverage
```

Mesure du 2026-10-05 : 1442 lignes couvertes sur 1464 pour `lib/layers/functional/Animedex`, soit 98,5 %.

## Lancer le site

Le site de développement est servi sur le port 5059.

```text
flutter run -d web-server --web-port 5059 --dart-define-from-file=dart_defines.json
```

Ouvrir `http://localhost:5059`. Si un serveur tourne déjà sur ce port, le réutiliser et recharger la page plutôt que d'en lancer un second.

## Scénarios de validation manuelle

Se placer sur la destination « Animédex » de la navigation.

### S1 - Ouvrir le booster du jour (US1, US4)

1. Onglet « Booster » : le bandeau indique « Ton booster du jour est prêt ! ».
2. Toucher « Ouvrir » : la page plein écran affiche le paquet scellé.
3. Toucher le paquet : « Ouverture en cours… » puis la première carte se prépare.
4. Toucher cinq fois : chaque carte se retourne avec « NOUVEAU » ou « Doublon » ; une carte rare, épique ou légendaire déclenche l'effet holographique et l'explosion lumineuse.
5. Le récapitulatif indique le nombre de nouvelles cartes et de doublons ; « Voir mes cartes » ferme la page.
6. Attendu : cinq personnages distincts ; le bandeau passe à « Prochain booster dans » avec un compte à rebours jusqu'à minuit local.

### S2 - Un seul booster par jour (US1, US3)

1. Après S1, le bouton « Ouvrir » n'existe plus.
2. Attendu : « Reviens dans N h » (ou « N min » sous une heure) ; la page du booster, si on l'atteint, affiche « Booster déjà ouvert aujourd'hui ».

### S3 - Panne réseau sans consommer le booster (US1)

1. Couper le réseau (outils du navigateur, mode hors ligne), puis ouvrir le booster.
2. Attendu : « Le booster n'a pas pu être tiré » et « Ton booster n'est pas consommé » avec « Réessayer ».
3. Rétablir le réseau et toucher « Réessayer » : le booster s'ouvre.

### S4 - Persistance (US2)

1. Recharger la page du site.
2. Attendu : l'onglet « Collection » affiche le même nombre de personnages ; les cartes d'un ancien format éventuel sont ignorées sans erreur.

### S5 - Parcourir la collection (US5)

1. Onglet « Collection » : compteur, répartition par rareté, recherche, filtres, tri.
2. Saisir « nar » : seuls les personnages ou animés contenant ces lettres restent ; saisir un nom avec ou sans accents donne le même résultat.
3. Choisir « Légendaire » : seules les légendaires restent ; « Toutes » rétablit.
4. Choisir le tri « Plus aimés » puis « Nom A → Z » : l'ordre change.
5. Saisir une recherche sans résultat : « Aucun personnage trouvé » ; « Réinitialiser les filtres » vide la recherche et la rareté.
6. Collection vide (effacer le stockage du site) : invitation à ouvrir le premier booster.

### S6 - Détail d'une carte (US6)

1. Toucher une carte : dialogue avec la carte agrandie et animée, le nom, le nom natif, l'anime d'origine, la rareté, les favoris et la date d'obtention.
2. « Fermer » ferme le dialogue.

### S7 - Réduction des animations (US4, US6)

1. Activer la réduction des animations dans le système.
2. Attendu : l'effet holographique ne boucle plus ; les transitions sont instantanées.

## Réinitialiser l'état local

Pour rejouer un booster le même jour, vider les données du site pour `localhost:5059` (outils du navigateur, stockage local) : les clés `dex` et `lastBoosterDay` des préférences sont supprimées.
