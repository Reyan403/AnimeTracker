import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_fr.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[Locale('fr')];

  /// No description provided for @appTitle.
  ///
  /// In fr, this message translates to:
  /// **'Anime Tracker'**
  String get appTitle;

  /// No description provided for @watchlistTitle.
  ///
  /// In fr, this message translates to:
  /// **'Ma liste'**
  String get watchlistTitle;

  /// No description provided for @catalogueTitle.
  ///
  /// In fr, this message translates to:
  /// **'Catalogue'**
  String get catalogueTitle;

  /// No description provided for @navWatchlist.
  ///
  /// In fr, this message translates to:
  /// **'Liste'**
  String get navWatchlist;

  /// No description provided for @navCatalogue.
  ///
  /// In fr, this message translates to:
  /// **'Catalogue'**
  String get navCatalogue;

  /// No description provided for @statusToWatch.
  ///
  /// In fr, this message translates to:
  /// **'À voir'**
  String get statusToWatch;

  /// No description provided for @statusWatching.
  ///
  /// In fr, this message translates to:
  /// **'En cours'**
  String get statusWatching;

  /// No description provided for @statusCompleted.
  ///
  /// In fr, this message translates to:
  /// **'Terminé'**
  String get statusCompleted;

  /// No description provided for @changeCategoryTooltip.
  ///
  /// In fr, this message translates to:
  /// **'Changer de catégorie'**
  String get changeCategoryTooltip;

  /// No description provided for @addToWatchTooltip.
  ///
  /// In fr, this message translates to:
  /// **'Ajouter à « À voir »'**
  String get addToWatchTooltip;

  /// No description provided for @alreadyListedTooltip.
  ///
  /// In fr, this message translates to:
  /// **'Déjà dans ma liste'**
  String get alreadyListedTooltip;

  /// No description provided for @sheetUnavailable.
  ///
  /// In fr, this message translates to:
  /// **'Fiche indisponible'**
  String get sheetUnavailable;

  /// No description provided for @episodesCount.
  ///
  /// In fr, this message translates to:
  /// **'{count, plural, =1{1 épisode} other{{count} épisodes}}'**
  String episodesCount(int count);

  /// No description provided for @episodesOfMinutes.
  ///
  /// In fr, this message translates to:
  /// **'{count, plural, =1{1 épisode de {minutes} min} other{{count} épisodes de {minutes} min}}'**
  String episodesOfMinutes(int count, int minutes);

  /// No description provided for @minutesPerEpisode.
  ///
  /// In fr, this message translates to:
  /// **'{minutes} min par épisode'**
  String minutesPerEpisode(int minutes);

  /// No description provided for @hoursTotal.
  ///
  /// In fr, this message translates to:
  /// **'{hours} h'**
  String hoursTotal(int hours);

  /// No description provided for @rankOrdinal.
  ///
  /// In fr, this message translates to:
  /// **'{rank}e'**
  String rankOrdinal(int rank);

  /// No description provided for @ratingPercent.
  ///
  /// In fr, this message translates to:
  /// **'{rating} %'**
  String ratingPercent(int rating);

  /// No description provided for @episodeProgress.
  ///
  /// In fr, this message translates to:
  /// **'{watched}/{total} épisodes vus'**
  String episodeProgress(int watched, int total);

  /// No description provided for @episodeProgressOpen.
  ///
  /// In fr, this message translates to:
  /// **'{watched, plural, =0{Pas encore commencé} =1{1 épisode vu} other{{watched} épisodes vus}}'**
  String episodeProgressOpen(int watched);

  /// No description provided for @watchNextTooltip.
  ///
  /// In fr, this message translates to:
  /// **'Marquer l\'épisode suivant comme vu'**
  String get watchNextTooltip;

  /// No description provided for @watchPreviousTooltip.
  ///
  /// In fr, this message translates to:
  /// **'Annuler le dernier épisode vu'**
  String get watchPreviousTooltip;

  /// No description provided for @navAgenda.
  ///
  /// In fr, this message translates to:
  /// **'Agenda'**
  String get navAgenda;

  /// No description provided for @agendaTitle.
  ///
  /// In fr, this message translates to:
  /// **'Agenda'**
  String get agendaTitle;

  /// No description provided for @agendaEmpty.
  ///
  /// In fr, this message translates to:
  /// **'Aucune sortie à venir.'**
  String get agendaEmpty;

  /// No description provided for @agendaEmptyHint.
  ///
  /// In fr, this message translates to:
  /// **'Ajoutez des animes en cours de diffusion depuis le catalogue.'**
  String get agendaEmptyHint;

  /// No description provided for @agendaErrorTitle.
  ///
  /// In fr, this message translates to:
  /// **'Impossible de charger l\'agenda'**
  String get agendaErrorTitle;

  /// No description provided for @releaseToday.
  ///
  /// In fr, this message translates to:
  /// **'Aujourd\'hui'**
  String get releaseToday;

  /// No description provided for @releaseTomorrow.
  ///
  /// In fr, this message translates to:
  /// **'Demain'**
  String get releaseTomorrow;

  /// No description provided for @releaseInDays.
  ///
  /// In fr, this message translates to:
  /// **'Dans {days} jours'**
  String releaseInDays(int days);

  /// No description provided for @releaseYesterday.
  ///
  /// In fr, this message translates to:
  /// **'Hier'**
  String get releaseYesterday;

  /// No description provided for @releaseDaysAgo.
  ///
  /// In fr, this message translates to:
  /// **'Il y a {days} jours'**
  String releaseDaysAgo(int days);

  /// No description provided for @nextEpisodeToWatch.
  ///
  /// In fr, this message translates to:
  /// **'Prochain à voir : épisode {number}'**
  String nextEpisodeToWatch(int number);

  /// No description provided for @navDiscover.
  ///
  /// In fr, this message translates to:
  /// **'Découvrir'**
  String get navDiscover;

  /// No description provided for @discoverTitle.
  ///
  /// In fr, this message translates to:
  /// **'Découvrir'**
  String get discoverTitle;

  /// No description provided for @eveningTitle.
  ///
  /// In fr, this message translates to:
  /// **'Quoi regarder ce soir ?'**
  String get eveningTitle;

  /// No description provided for @eveningMoodLabel.
  ///
  /// In fr, this message translates to:
  /// **'Mon humeur'**
  String get eveningMoodLabel;

  /// No description provided for @eveningTimeLabel.
  ///
  /// In fr, this message translates to:
  /// **'Mon temps'**
  String get eveningTimeLabel;

  /// No description provided for @moodAny.
  ///
  /// In fr, this message translates to:
  /// **'Peu importe'**
  String get moodAny;

  /// No description provided for @moodRelaxed.
  ///
  /// In fr, this message translates to:
  /// **'Détente'**
  String get moodRelaxed;

  /// No description provided for @moodAction.
  ///
  /// In fr, this message translates to:
  /// **'Action'**
  String get moodAction;

  /// No description provided for @moodEmotional.
  ///
  /// In fr, this message translates to:
  /// **'Émotion'**
  String get moodEmotional;

  /// No description provided for @moodMystery.
  ///
  /// In fr, this message translates to:
  /// **'Mystère'**
  String get moodMystery;

  /// No description provided for @durationShort.
  ///
  /// In fr, this message translates to:
  /// **'30 min'**
  String get durationShort;

  /// No description provided for @durationMedium.
  ///
  /// In fr, this message translates to:
  /// **'1 h'**
  String get durationMedium;

  /// No description provided for @durationLong.
  ///
  /// In fr, this message translates to:
  /// **'2 h'**
  String get durationLong;

  /// No description provided for @durationUnlimited.
  ///
  /// In fr, this message translates to:
  /// **'Toute la soirée'**
  String get durationUnlimited;

  /// No description provided for @eveningSuggestAction.
  ///
  /// In fr, this message translates to:
  /// **'Surprends-moi'**
  String get eveningSuggestAction;

  /// No description provided for @eveningAnother.
  ///
  /// In fr, this message translates to:
  /// **'Une autre idée'**
  String get eveningAnother;

  /// No description provided for @eveningOpenSheet.
  ///
  /// In fr, this message translates to:
  /// **'Voir la fiche'**
  String get eveningOpenSheet;

  /// No description provided for @eveningContinuing.
  ///
  /// In fr, this message translates to:
  /// **'Vous l\'avez commencé : reprenez-le.'**
  String get eveningContinuing;

  /// No description provided for @eveningFromList.
  ///
  /// In fr, this message translates to:
  /// **'Dans votre liste « À voir ».'**
  String get eveningFromList;

  /// No description provided for @eveningNone.
  ///
  /// In fr, this message translates to:
  /// **'Rien ne correspond dans votre liste.'**
  String get eveningNone;

  /// No description provided for @eveningNoneHint.
  ///
  /// In fr, this message translates to:
  /// **'Essayez une autre humeur ou plus de temps.'**
  String get eveningNoneHint;

  /// No description provided for @eveningErrorTitle.
  ///
  /// In fr, this message translates to:
  /// **'Impossible de composer une suggestion'**
  String get eveningErrorTitle;

  /// No description provided for @genreAction.
  ///
  /// In fr, this message translates to:
  /// **'Action'**
  String get genreAction;

  /// No description provided for @genreAdventure.
  ///
  /// In fr, this message translates to:
  /// **'Aventure'**
  String get genreAdventure;

  /// No description provided for @genreComedy.
  ///
  /// In fr, this message translates to:
  /// **'Comédie'**
  String get genreComedy;

  /// No description provided for @genreDrama.
  ///
  /// In fr, this message translates to:
  /// **'Drame'**
  String get genreDrama;

  /// No description provided for @genreFantasy.
  ///
  /// In fr, this message translates to:
  /// **'Fantastique'**
  String get genreFantasy;

  /// No description provided for @genreHorror.
  ///
  /// In fr, this message translates to:
  /// **'Horreur'**
  String get genreHorror;

  /// No description provided for @genreMystery.
  ///
  /// In fr, this message translates to:
  /// **'Mystère'**
  String get genreMystery;

  /// No description provided for @genreRomance.
  ///
  /// In fr, this message translates to:
  /// **'Romance'**
  String get genreRomance;

  /// No description provided for @genreScienceFiction.
  ///
  /// In fr, this message translates to:
  /// **'Science-fiction'**
  String get genreScienceFiction;

  /// No description provided for @genreSliceOfLife.
  ///
  /// In fr, this message translates to:
  /// **'Tranche de vie'**
  String get genreSliceOfLife;

  /// No description provided for @genreSports.
  ///
  /// In fr, this message translates to:
  /// **'Sport'**
  String get genreSports;

  /// No description provided for @genreSupernatural.
  ///
  /// In fr, this message translates to:
  /// **'Surnaturel'**
  String get genreSupernatural;

  /// No description provided for @genreThriller.
  ///
  /// In fr, this message translates to:
  /// **'Thriller'**
  String get genreThriller;

  /// No description provided for @genrePsychological.
  ///
  /// In fr, this message translates to:
  /// **'Psychologique'**
  String get genrePsychological;

  /// No description provided for @genreMecha.
  ///
  /// In fr, this message translates to:
  /// **'Mecha'**
  String get genreMecha;

  /// No description provided for @recoTitle.
  ///
  /// In fr, this message translates to:
  /// **'Pour toi'**
  String get recoTitle;

  /// No description provided for @recoBecauseOne.
  ///
  /// In fr, this message translates to:
  /// **'Parce que vous aimez {first}'**
  String recoBecauseOne(String first);

  /// No description provided for @recoBecauseTwo.
  ///
  /// In fr, this message translates to:
  /// **'Parce que vous aimez {first} et {second}'**
  String recoBecauseTwo(String first, String second);

  /// No description provided for @recoEmpty.
  ///
  /// In fr, this message translates to:
  /// **'Pas encore de recommandation.'**
  String get recoEmpty;

  /// No description provided for @recoEmptyHint.
  ///
  /// In fr, this message translates to:
  /// **'Commencez ou terminez quelques animes pour que l\'application apprenne vos goûts.'**
  String get recoEmptyHint;

  /// No description provided for @recoErrorTitle.
  ///
  /// In fr, this message translates to:
  /// **'Impossible de charger les recommandations'**
  String get recoErrorTitle;

  /// No description provided for @retry.
  ///
  /// In fr, this message translates to:
  /// **'Réessayer'**
  String get retry;

  /// No description provided for @serviceUnavailable.
  ///
  /// In fr, this message translates to:
  /// **'Le service Kitsu ne répond pas pour le moment.'**
  String get serviceUnavailable;

  /// No description provided for @watchlistEmpty.
  ///
  /// In fr, this message translates to:
  /// **'Aucun animé dans cet onglet.'**
  String get watchlistEmpty;

  /// No description provided for @watchlistEmptyHint.
  ///
  /// In fr, this message translates to:
  /// **'Ajoutez un animé depuis le catalogue.'**
  String get watchlistEmptyHint;

  /// No description provided for @watchlistErrorTitle.
  ///
  /// In fr, this message translates to:
  /// **'Impossible de charger les fiches'**
  String get watchlistErrorTitle;

  /// No description provided for @catalogueEmpty.
  ///
  /// In fr, this message translates to:
  /// **'Le catalogue est vide pour le moment.'**
  String get catalogueEmpty;

  /// No description provided for @catalogueEmptySearch.
  ///
  /// In fr, this message translates to:
  /// **'Aucun animé ne correspond à cette recherche.'**
  String get catalogueEmptySearch;

  /// No description provided for @catalogueEmptySearchHint.
  ///
  /// In fr, this message translates to:
  /// **'Essayez un autre titre.'**
  String get catalogueEmptySearchHint;

  /// No description provided for @catalogueErrorTitle.
  ///
  /// In fr, this message translates to:
  /// **'Impossible de charger le catalogue'**
  String get catalogueErrorTitle;

  /// No description provided for @sheetErrorTitle.
  ///
  /// In fr, this message translates to:
  /// **'Impossible de charger la fiche'**
  String get sheetErrorTitle;

  /// No description provided for @searchHint.
  ///
  /// In fr, this message translates to:
  /// **'Rechercher un animé'**
  String get searchHint;

  /// No description provided for @clearTooltip.
  ///
  /// In fr, this message translates to:
  /// **'Effacer'**
  String get clearTooltip;

  /// No description provided for @synopsis.
  ///
  /// In fr, this message translates to:
  /// **'Synopsis'**
  String get synopsis;

  /// No description provided for @inBrief.
  ///
  /// In fr, this message translates to:
  /// **'En bref'**
  String get inBrief;

  /// No description provided for @factFormat.
  ///
  /// In fr, this message translates to:
  /// **'Format'**
  String get factFormat;

  /// No description provided for @factStatus.
  ///
  /// In fr, this message translates to:
  /// **'Statut'**
  String get factStatus;

  /// No description provided for @factBroadcast.
  ///
  /// In fr, this message translates to:
  /// **'Diffusion'**
  String get factBroadcast;

  /// No description provided for @factEpisodes.
  ///
  /// In fr, this message translates to:
  /// **'Épisodes'**
  String get factEpisodes;

  /// No description provided for @factTotalDuration.
  ///
  /// In fr, this message translates to:
  /// **'Durée totale'**
  String get factTotalDuration;

  /// No description provided for @factRating.
  ///
  /// In fr, this message translates to:
  /// **'Note moyenne'**
  String get factRating;

  /// No description provided for @factRatingRank.
  ///
  /// In fr, this message translates to:
  /// **'Classement'**
  String get factRatingRank;

  /// No description provided for @factPopularity.
  ///
  /// In fr, this message translates to:
  /// **'Popularité'**
  String get factPopularity;

  /// No description provided for @factMembers.
  ///
  /// In fr, this message translates to:
  /// **'Membres'**
  String get factMembers;

  /// No description provided for @factFavorites.
  ///
  /// In fr, this message translates to:
  /// **'Favoris'**
  String get factFavorites;

  /// No description provided for @factAudience.
  ///
  /// In fr, this message translates to:
  /// **'Public'**
  String get factAudience;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['fr'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'fr':
      return AppLocalizationsFr();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
