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
