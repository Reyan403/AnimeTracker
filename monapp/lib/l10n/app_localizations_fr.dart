// ignore: unused_import
import 'package:intl/intl.dart' as intl;

import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for French (`fr`).
class AppLocalizationsFr extends AppLocalizations {
  AppLocalizationsFr([String locale = 'fr']) : super(locale);

  @override
  String get appTitle => 'Anime Tracker';

  @override
  String get watchlistTitle => 'Ma liste';

  @override
  String get catalogueTitle => 'Catalogue';

  @override
  String get navWatchlist => 'Liste';

  @override
  String get navCatalogue => 'Catalogue';

  @override
  String get statusToWatch => 'À voir';

  @override
  String get statusWatching => 'En cours';

  @override
  String get statusCompleted => 'Terminé';

  @override
  String get changeCategoryTooltip => 'Changer de catégorie';

  @override
  String get addToWatchTooltip => 'Ajouter à « À voir »';

  @override
  String get alreadyListedTooltip => 'Déjà dans ma liste';

  @override
  String get sheetUnavailable => 'Fiche indisponible';

  @override
  String episodesCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count épisodes',
      one: '1 épisode',
    );
    return '$_temp0';
  }

  @override
  String episodesOfMinutes(int count, int minutes) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count épisodes de $minutes min',
      one: '1 épisode de $minutes min',
    );
    return '$_temp0';
  }

  @override
  String minutesPerEpisode(int minutes) {
    return '$minutes min par épisode';
  }

  @override
  String hoursTotal(int hours) {
    return '$hours h';
  }

  @override
  String rankOrdinal(int rank) {
    return '${rank}e';
  }

  @override
  String ratingPercent(int rating) {
    return '$rating %';
  }

  @override
  String episodeProgress(int watched, int total) {
    return '$watched/$total épisodes vus';
  }

  @override
  String episodeProgressOpen(int watched) {
    String _temp0 = intl.Intl.pluralLogic(
      watched,
      locale: localeName,
      other: '$watched épisodes vus',
      one: '1 épisode vu',
      zero: 'Pas encore commencé',
    );
    return '$_temp0';
  }

  @override
  String get watchNextTooltip => 'Marquer l\'épisode suivant comme vu';

  @override
  String get watchPreviousTooltip => 'Annuler le dernier épisode vu';

  @override
  String get navAgenda => 'Agenda';

  @override
  String get agendaTitle => 'Agenda';

  @override
  String get agendaEmpty => 'Aucune sortie à venir.';

  @override
  String get agendaEmptyHint =>
      'Aucune sortie annoncée pour les prochaines semaines.';

  @override
  String get agendaErrorTitle => 'Impossible de charger l\'agenda';

  @override
  String get releaseToday => 'Aujourd\'hui';

  @override
  String get releaseTomorrow => 'Demain';

  @override
  String releaseInDays(int days) {
    return 'Dans $days jours';
  }

  @override
  String get releaseYesterday => 'Hier';

  @override
  String releaseDaysAgo(int days) {
    return 'Il y a $days jours';
  }

  @override
  String get navDiscover => 'Découvrir';

  @override
  String get discoverTitle => 'Découvrir';

  @override
  String get eveningTitle => 'Quoi regarder ce soir ?';

  @override
  String get eveningMoodLabel => 'Mon humeur';

  @override
  String get moodAny => 'Peu importe';

  @override
  String get moodRelaxed => 'Détente';

  @override
  String get moodAction => 'Action';

  @override
  String get moodEmotional => 'Émotion';

  @override
  String get moodMystery => 'Mystère';

  @override
  String get eveningSuggestAction => 'Surprends-moi';

  @override
  String get eveningAnother => 'Une autre idée';

  @override
  String get eveningOpenSheet => 'Voir la fiche';

  @override
  String get eveningContinuing => 'Vous l\'avez commencé : reprenez-le.';

  @override
  String get eveningFromList => 'Dans votre liste « À voir ».';

  @override
  String get eveningNone => 'Rien ne correspond dans votre liste.';

  @override
  String get eveningNoneHint => 'Essayez une autre humeur ou plus de temps.';

  @override
  String get eveningErrorTitle => 'Impossible de composer une suggestion';

  @override
  String get genreAction => 'Action';

  @override
  String get genreAdventure => 'Aventure';

  @override
  String get genreComedy => 'Comédie';

  @override
  String get genreDrama => 'Drame';

  @override
  String get genreFantasy => 'Fantastique';

  @override
  String get genreHorror => 'Horreur';

  @override
  String get genreMystery => 'Mystère';

  @override
  String get genreRomance => 'Romance';

  @override
  String get genreScienceFiction => 'Science-fiction';

  @override
  String get genreSliceOfLife => 'Tranche de vie';

  @override
  String get genreSports => 'Sport';

  @override
  String get genreSupernatural => 'Surnaturel';

  @override
  String get genreThriller => 'Thriller';

  @override
  String get genrePsychological => 'Psychologique';

  @override
  String get genreMecha => 'Mecha';

  @override
  String get recoTitle => 'Pour toi';

  @override
  String recoBecauseOne(String first) {
    return 'Parce que vous aimez $first';
  }

  @override
  String recoBecauseTwo(String first, String second) {
    return 'Parce que vous aimez $first et $second';
  }

  @override
  String get recoEmpty => 'Pas encore de recommandation.';

  @override
  String get recoEmptyHint =>
      'Commencez ou terminez quelques animes pour que l\'application apprenne vos goûts.';

  @override
  String get recoErrorTitle => 'Impossible de charger les recommandations';

  @override
  String get navStats => 'Stats';

  @override
  String get statsTitle => 'Stats';

  @override
  String get statsEpisodes => 'Épisodes vus';

  @override
  String get statsCompleted => 'Animes terminés';

  @override
  String get statsGenresTitle => 'Genres favoris';

  @override
  String get statsEmpty => 'Rien à compter pour l\'instant.';

  @override
  String get statsEmptyHint =>
      'Ajoutez des animes à votre liste pour voir vos statistiques.';

  @override
  String get statsErrorTitle => 'Impossible de calculer vos statistiques';

  @override
  String get offlineNotice =>
      'Hors ligne : données enregistrées lors de votre dernière connexion.';

  @override
  String get spoilerHiddenHint => 'Synopsis masqué pour éviter les spoilers.';

  @override
  String get spoilerReveal => 'Afficher';

  @override
  String get settingsTitle => 'Réglages';

  @override
  String get spoilerGuardTitle => 'Masquer les spoilers';

  @override
  String get spoilerGuardSubtitle =>
      'Floute le synopsis des animes que vous n\'avez pas terminés.';

  @override
  String releaseEpisode(int number) {
    return 'Épisode $number';
  }

  @override
  String get inWatchlistBadge => 'Dans ma liste';

  @override
  String get retry => 'Réessayer';

  @override
  String get serviceUnavailable =>
      'Le service Kitsu ne répond pas pour le moment.';

  @override
  String get watchlistEmpty => 'Aucun animé dans cet onglet.';

  @override
  String get watchlistEmptyHint => 'Ajoutez un animé depuis le catalogue.';

  @override
  String get watchlistErrorTitle => 'Impossible de charger les fiches';

  @override
  String get catalogueEmpty => 'Le catalogue est vide pour le moment.';

  @override
  String get catalogueEmptySearch =>
      'Aucun animé ne correspond à cette recherche.';

  @override
  String get catalogueEmptySearchHint => 'Essayez un autre titre.';

  @override
  String get catalogueErrorTitle => 'Impossible de charger le catalogue';

  @override
  String get sheetErrorTitle => 'Impossible de charger la fiche';

  @override
  String get searchHint => 'Rechercher un animé';

  @override
  String get clearTooltip => 'Effacer';

  @override
  String get synopsis => 'Synopsis';

  @override
  String get inBrief => 'En bref';

  @override
  String get factFormat => 'Format';

  @override
  String get factStatus => 'Statut';

  @override
  String get factBroadcast => 'Diffusion';

  @override
  String get factEpisodes => 'Épisodes';

  @override
  String get factTotalDuration => 'Durée totale';

  @override
  String get factRating => 'Note moyenne';

  @override
  String get factRatingRank => 'Classement';

  @override
  String get factPopularity => 'Popularité';

  @override
  String get factMembers => 'Membres';

  @override
  String get factFavorites => 'Favoris';

  @override
  String get factAudience => 'Public';
}
