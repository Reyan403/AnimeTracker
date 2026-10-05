# Quickstart: Constellation

**Feature**: `013-constellation` | **Date**: 2026-10-05

Toutes les commandes se lancent depuis `monapp/` (le dossier du projet Flutter).

## Prérequis

- Flutter avec Dart 3.13 ou plus récent (`sdk: ^3.13.3`).
- Dépendances installées : `flutter pub get`.
- Textes générés : `flutter gen-l10n` (après toute modification de `lib/l10n/app_fr.arb`).
- Aucun service externe, aucune clé : la constellation se calcule à partir de la liste et de ses fiches déjà chargées. Ne pas ouvrir ni afficher `dart_defines.json`.

## Analyse statique

```text
flutter analyze lib/layers/functional/Constellation test/layers/functional/constellation
```

Résultat attendu : `No issues found!`.

## Tests

```text
flutter test test/layers/functional/constellation
```

Résultat attendu : tous les tests passent (82 cas déclarés). Sous-ensembles :

- logique pure : fichiers `logic_*` (disposition, liens, use case, pondération et humeurs) ;
- interface : fichiers `ui_*` (cubit, carte d'entrée, page, géométrie du ciel, légende).

Le test chronométré de la disposition (`logic_layout_test.dart`, « moins de 50 ms pour 100 animes ») dépend de la machine : le relancer isolé en cas d'échec ponctuel.

Couverture :

```text
flutter test test/layers/functional/constellation --coverage
```

Mesure du 2026-10-05 : 746 lignes couvertes sur 758 pour `lib/layers/functional/Constellation`, soit 98,4 %.

## Lancer le site

Le site de développement est servi sur le port 5059.

```text
flutter run -d web-server --web-port 5059 --dart-define-from-file=dart_defines.json
```

Ouvrir `http://localhost:5059`. Si un serveur tourne déjà sur ce port, le réutiliser et recharger la page plutôt que d'en lancer un second.

## Scénarios de validation manuelle

Préparer une liste d'au moins une dizaine d'animes de statuts variés (à voir, en cours avec quelques épisodes vus, terminés) et de genres variés.

### S1 - Voir le ciel (US1)

1. Aller sur la destination « Statistiques » : sous les statistiques, la carte « Ma constellation » affiche un mini-ciel.
2. Toucher la carte : la page s'ouvre en fondu, un état de chargement « Les étoiles s'allument… » apparaît aussitôt.
3. Attendu : une étoile par anime, des traits entre animes de genres communs, les terminés plus grosses et étincelantes, les « à voir » plus petites.
4. Quitter avec « Retour », rouvrir : les étoiles occupent les mêmes positions.

### S2 - États vide et erreur (US1)

1. Avec une liste vide : « Ton ciel est encore vide » et l'invitation à ajouter des animes.
2. Hors ligne, avec une liste non vide dont aucune fiche n'est en cache : « Le ciel est voilé » avec « Réessayer », sans texte technique.

### S3 - Explorer (US2)

1. Pincer ou faire glisser (ou molette et glisser sur le site) : le ciel se zoome et se déplace.
2. Toucher une étoile : l'aperçu apparaît (affiche, titre, statut, humeur, « Reliée à N animes »), un anneau pulse autour de l'étoile.
3. Toucher « Ouvrir la fiche » : la fiche de l'anime s'ouvre avec la transition de l'affiche.
4. Toucher le vide ou la croix de l'aperçu : l'aperçu se ferme.

### S4 - Légende et filtre (US2)

1. La légende montre toutes les humeurs présentes (Détente, Action, Émotion…) sur plusieurs lignes, sans défilement horizontal, sans dépasser un tiers de l'écran.
2. Toucher une humeur : les autres étoiles s'atténuent et ne sont plus touchables ; une étoile sans humeur est atténuée aussi.
3. Toucher de nouveau la même humeur : tout le ciel se rallume.
4. Réduire la hauteur de la fenêtre : la légende ne dépasse pas un tiers de la hauteur.

### S5 - Réduction des animations (US2)

1. Activer la réduction des animations dans le système.
2. Attendu : les étoiles ne scintillent pas, aucune étoile filante ; le ciel reste utilisable.

### S6 - Mise à jour de la liste (US1)

La page étant plein écran, ce comportement se vérifie par les tests du cubit (`ui_cubit_test.dart`) : la sélection est conservée quand le flux réémet une constellation contenant encore l'étoile, et perdue quand l'étoile disparaît.
