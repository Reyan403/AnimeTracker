# Research: Constellation

**Feature**: `013-constellation` | **Date**: 2026-10-05

Chaque décision porte sur ce qui a été réellement construit. Aucun point `NEEDS CLARIFICATION` ne subsiste.

## R-01 - Disposition déterministe par relaxation force-dirigée

- **Décision** : `ConstellationLayout.positions(animeIds, links)` place les étoiles en trois temps. (1) Amorçage : les identifiants sont dédupliqués et triés, chaque étoile est posée sur une spirale à angle d'or, avec un décalage venant de `math.Random(id * 7919 + 13)`. (2) Relaxation : 140 itérations jusqu'à 60 étoiles, 80 au-delà, avec une répulsion entre toutes les paires, une attraction le long des liens proportionnelle à `1 + 0,25 * (genres communs - 1)` (genres communs bornés de 1 à 5), une légère gravité vers le centre (0,3), et un déplacement limité par une « température » de 0,1 qui refroidit linéairement. (3) Normalisation : chaque axe est étiré sur [0,06 ; 0,94] (`_spread`), le centre 0,5 étant utilisé si l'étendue est négligeable.
- **Justification** : une même liste doit donner la même carte à chaque ouverture (SC-002), même si l'ordre des animes change : le tri des identifiants et la graine dérivée de l'identifiant suppriment toute source d'aléa non contrôlée. La relaxation rapproche les animes liés et éloigne les autres, ce qui rend les genres lisibles sans les afficher. Le nombre d'itérations plafonné et le coût O(n²) par itération tiennent sous 50 ms pour 100 animes (test chronométré dans `logic_layout_test.dart`, meilleur de plusieurs essais) ; baisser à 80 itérations au-delà de 60 animes garde cette marge.
- **Alternatives écartées** :
  - **Positions aléatoires graînées** (sans relaxation) : déterministes mais sans lien visuel avec les genres, le ciel ressemblerait à un nuage sans structure.
  - **Grille ou cercle** : lisible mais sans information ; ne ressemble pas à un ciel.
  - **Bibliothèque de graphes** : dépendance supplémentaire pour un calcul de quelques dizaines de lignes (`pubspec.yaml` est réservé).
  - **Simulation en continu à l'écran** (animation physique) : positions instables d'une ouverture à l'autre, coût de rendu permanent, contraire à SC-002.
  - **Calcul dans un isolat** : inutile au vu des 50 ms mesurés pour 100 animes.
- **Limite connue** : l'absence de superposition vient de la répulsion, non d'une contrainte dure ; le test vérifie une distance minimale supérieure à 0,02 pour 30 étoiles (`pas de chevauchement flagrant`). Les marges, elles, sont garanties par le recadrage final.

## R-02 - Liens : genres communs, trois par étoile au plus

- **Décision** : `ConstellationLinksBuilder.build` calcule, pour chaque paire d'animes (identifiants triés, `fromId` inférieur à `toId`), le nombre de genres Kitsu en commun ; les paires de score positif sont triées par force décroissante, puis par un mélange déterministe `(fromId * 7919 + toId * 104729) % 1009`, puis par identifiants ; elles sont retenues tant que les deux extrémités ont moins de `maxLinksPerStar` (3) liens. Le résultat est rendu trié par identifiants.
- **Justification** : sans plafond, un genre très fréquent (comédie, action) relie des dizaines d'étoiles et noie le ciel. Le tri par force privilégie les affinités les plus fines ; le mélange déterministe évite de favoriser systématiquement les petits identifiants parmi des paires à égalité ; une paire n'est jamais reliée deux fois.
- **Alternatives écartées** : relier toutes les paires (illisible) ; ne relier que les paires de 2 genres communs ou plus (laisse des étoiles isolées alors qu'elles ont un genre en commun) ; plafond de 2 (trop de composantes séparées) ou de 5 (ciel chargé).
- **Choix assumé** : les liens utilisent tous les genres Kitsu communs, pas seulement les humeurs de Découvrir (FR-004b), pour garder des affinités plus fines que la légende.

## R-03 - Taille des étoiles selon le statut et la progression

- **Décision** : poids de 0,35 pour « à voir », `0,55 + 0,45 * progression` pour « en cours » (la progression est le rapport épisodes vus sur épisodes, 0 si inconnue) et 1 pour « terminé ». Rayon à l'écran `3 + 6 * poids`. Les étoiles terminées brillent en étincelle.
- **Justification** : le poids est dans [0, 1] pour tous les statuts ; une étoile « en cours » est toujours plus grosse qu'une étoile « à voir » (0,55 contre 0,35) et plus petite qu'une terminée tant que la progression est inférieure à 1.
- **Alternative écartée** : taille proportionnelle au nombre d'épisodes (compare des séries longues et courtes, sans rapport avec l'avancement de l'utilisateur).

## R-04 - Genres de la constellation limités aux humeurs de Découvrir

- **Décision** : les genres de la constellation sont les humeurs de `EveningMood` (Détente, Action, Émotion, Romance, Mystère, Fantastique, Science-fiction, Surnaturel, Horreur, Sport), avec les libellés de l'onglet « Découvrir » (`labelOf`). Un anime appartient à une humeur si l'un de ses genres Kitsu est dans `genreSlugs` de l'humeur (par exemple « comedy » et « slice-of-life » comptent pour Détente, une seule fois). Le genre principal d'une étoile, `genreSlug`, est le nom de l'humeur la plus fréquente de la liste parmi celles de l'anime, l'ordre alphabétique du nom départageant ; nul sans humeur. `Constellation.genres` ne contient que les humeurs présentes, par fréquence décroissante puis ordre alphabétique. `EveningMood.any`, dont l'ensemble de genres est vide, n'apparaît jamais.
- **Justification** : la première version affichait tous les genres Kitsu, jusqu'à des dizaines de pastilles (puis un plafond, puis un défilement horizontal). Les dix humeurs de Découvrir sont déjà connues de l'utilisateur, déjà traduites et en nombre fixe, ce qui donne une légende courte et cohérente avec le reste de l'application.
- **Alternatives écartées** : tous les genres Kitsu (légende trop longue) ; les N genres les plus fréquents seulement (certaines étoiles perdent leur couleur sans explication ; première correction, remplacée) ; créer un nouveau regroupement propre à la Constellation (divergerait des humeurs de Découvrir).
- **Étoiles sans humeur** : couleur neutre `starGlow`, touchables, non allumées quand un filtre est actif.

## R-05 - Légende sur plusieurs lignes, plafonnée à un tiers d'écran

- **Décision** : `GenreLegend` utilise un `Wrap` (espacement `AppSpacing.sm` et `xs`) de `GenreLegendChip` compacts, dans un `ConstrainedBox` limité à un tiers de la hauteur de l'écran (`maxHeightFraction = 1 / 3`) ; au-delà seulement, un défilement vertical apparaît. Le ciel occupe le reste (`Expanded`). Choisir la pastille active retire le filtre.
- **Justification** : la légende à défilement horizontal cachait des genres ; dix pastilles sur plusieurs lignes tiennent en dessous d'un tiers d'écran sur mobile, et le ciel reste utilisable. Les tests couvrent plusieurs largeurs d'écran, une police de test très large et la limite du tiers.
- **Alternatives écartées** : défilement horizontal (genres invisibles) ; légende repliée dans un menu (un geste de plus pour filtrer) ; superposition de la légende sur le ciel (masque des étoiles).

## R-06 - Construction : réutiliser la liste et attendre les fiches

- **Décision** : `BuildConstellationUseCase.call()` est un `Stream<Constellation>` dérivé de `LoadWatchlistUseCase` : il ignore les émissions où une fiche est encore en chargement (`isLoadingDetails`), puis construit la constellation ; liste vide donne zéro étoile ; une liste non vide sans aucune fiche donne `ConstellationUnavailableException` dans le flux.
- **Justification** : c'est le comportement des statistiques (`ComputeWatchStatsUseCase`) ; les genres viennent de fiches déjà chargées, donc aucune requête supplémentaire. Le flux permet de mettre le ciel à jour quand la liste change pendant que la page est ouverte.
- **Alternatives écartées** : appeler les fiches directement (dupliquerait le chargement et ses caches) ; construire avec des fiches partielles (le ciel bougerait à chaque fiche arrivée).

## R-07 - Dessin : une horloge, une couche isolée

- **Décision** : `SkyClockBuilder` fournit un unique `AnimationController` non borné (boucle de 3600 s) qui sert de `repaint` au `ConstellationPainter` ; le `CustomPaint` est dans un `RepaintBoundary`. Scintillement doux (`StarMotion.twinkle`), apparition progressive, anneau pulsé sur l'étoile sélectionnée, étoile filante périodique (cycle de 11 s). Avec la réduction des animations, l'horloge est arrêtée et le temps fixé à `StarMotion.restTime` (100) : étoiles visibles, sans scintillement ni étoile filante.
- **Justification** : un seul contrôleur pour tout le ciel, pas un par étoile ; le fond étoilé (`NightSkyBackground`) est séparé du ciel pour ne pas se redessiner avec lui.
- **Alternatives écartées** : un widget animé par étoile (coût proportionnel au nombre d'animes) ; images pré-rendues (pas de scintillement, mémoire).

## R-08 - Pan, zoom et sélection

- **Décision** : `InteractiveViewer` (échelle de 1 à 5) autour d'un `GestureDetector` ; le toucher est converti en étoile par `StarLayout.hitTest` (distance au centre inférieure à la tolérance de 26 plus le rayon de l'étoile, étoile la plus proche), en ne considérant que les étoiles allumées par le filtre. Toucher le vide désélectionne. `ConstellationCubit.select` conserve la sélection si l'étoile existe encore après une réémission du flux et la perd sinon.
- **Justification** : un `CustomPaint` n'a pas de widgets enfants à toucher ; le test de proximité manuel donne une zone de toucher confortable pour de petites étoiles (SC-003 : deux touchers jusqu'à la fiche).
- **Alternatives écartées** : un widget cliquable par étoile (coût et semantics multipliés) ; tolérance égale au rayon (étoiles de 3 à 9 px quasi impossibles à viser).

## R-09 - Aperçu et navigation vers la fiche

- **Décision** : `StarPreviewPanel` affiche en bas, avec une transition, `StarPreviewCard` (affiche via `AnimePoster`, titre, statut, humeur en `GenreTag`, nombre de liens, croix de fermeture, bouton « Ouvrir la fiche ») ; le bouton appelle `openAnimeSheet` avec `AnimePoster.heroTagFor('constellation', id)`.
- **Justification** : réutilise la fiche de l'application et sa transition en héros ; le nombre de liens (`ConstellationState.linkCountOf`) indique l'affinité de l'anime (« Reliée à N animes », « Étoile solitaire »).
- **Écart reconnu** : l'affiche passe par `AnimePoster` et `Image.network` (principe XI, voir plan.md).

## R-10 - Entrée depuis les statistiques

- **Décision** : `ConstellationEntryCard` est insérée dans `Stats/presentation/stats_view.dart` entre le contenu des statistiques et l'interrupteur anti-spoil ; elle montre un mini-ciel animé (`MiniSky`) et ouvre `ConstellationPage.open(context)`, route à fondu (`PageRouteBuilder`). Elle est visible même sans liste : les états vide et erreur sont gérés par la page.
- **Justification** : la carte donne un point d'entrée découvrable sans nouvelle destination de navigation ; l'état vide est une invitation, pas une carte absente.
- **Alternative écartée** : nouvelle destination de navigation (la barre compte déjà six destinations).
