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
  /// **'Aucune sortie annoncée pour les prochaines semaines.'**
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
  /// **'Mon humeur ou mon genre'**
  String get eveningMoodLabel;

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

  /// No description provided for @moodRomance.
  ///
  /// In fr, this message translates to:
  /// **'Romance'**
  String get moodRomance;

  /// No description provided for @moodFantasy.
  ///
  /// In fr, this message translates to:
  /// **'Fantastique'**
  String get moodFantasy;

  /// No description provided for @moodScienceFiction.
  ///
  /// In fr, this message translates to:
  /// **'Science-fiction'**
  String get moodScienceFiction;

  /// No description provided for @moodSupernatural.
  ///
  /// In fr, this message translates to:
  /// **'Surnaturel'**
  String get moodSupernatural;

  /// No description provided for @moodHorror.
  ///
  /// In fr, this message translates to:
  /// **'Horreur'**
  String get moodHorror;

  /// No description provided for @moodSports.
  ///
  /// In fr, this message translates to:
  /// **'Sport'**
  String get moodSports;

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

  /// No description provided for @eveningFromCatalogue.
  ///
  /// In fr, this message translates to:
  /// **'Tiré au hasard dans tout le catalogue.'**
  String get eveningFromCatalogue;

  /// No description provided for @eveningAlreadyListed.
  ///
  /// In fr, this message translates to:
  /// **'Déjà dans votre liste.'**
  String get eveningAlreadyListed;

  /// No description provided for @eveningAddToList.
  ///
  /// In fr, this message translates to:
  /// **'Ajouter à ma liste'**
  String get eveningAddToList;

  /// No description provided for @eveningNone.
  ///
  /// In fr, this message translates to:
  /// **'Aucun anime trouvé.'**
  String get eveningNone;

  /// No description provided for @eveningNoneHint.
  ///
  /// In fr, this message translates to:
  /// **'Essayez une autre humeur.'**
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

  /// No description provided for @navStats.
  ///
  /// In fr, this message translates to:
  /// **'Stats'**
  String get navStats;

  /// No description provided for @navAnimedex.
  ///
  /// In fr, this message translates to:
  /// **'Animédex'**
  String get navAnimedex;

  /// No description provided for @statsTitle.
  ///
  /// In fr, this message translates to:
  /// **'Stats'**
  String get statsTitle;

  /// No description provided for @statsEpisodes.
  ///
  /// In fr, this message translates to:
  /// **'Épisodes vus'**
  String get statsEpisodes;

  /// No description provided for @statsCompleted.
  ///
  /// In fr, this message translates to:
  /// **'Animes terminés'**
  String get statsCompleted;

  /// No description provided for @statsGenresTitle.
  ///
  /// In fr, this message translates to:
  /// **'Genres favoris'**
  String get statsGenresTitle;

  /// No description provided for @statsEmpty.
  ///
  /// In fr, this message translates to:
  /// **'Rien à compter pour l\'instant.'**
  String get statsEmpty;

  /// No description provided for @statsEmptyHint.
  ///
  /// In fr, this message translates to:
  /// **'Ajoutez des animes à votre liste pour voir vos statistiques.'**
  String get statsEmptyHint;

  /// No description provided for @statsErrorTitle.
  ///
  /// In fr, this message translates to:
  /// **'Impossible de calculer vos statistiques'**
  String get statsErrorTitle;

  /// No description provided for @offlineNotice.
  ///
  /// In fr, this message translates to:
  /// **'Hors ligne : données enregistrées lors de votre dernière connexion.'**
  String get offlineNotice;

  /// No description provided for @spoilerHiddenHint.
  ///
  /// In fr, this message translates to:
  /// **'Synopsis masqué pour éviter les spoilers.'**
  String get spoilerHiddenHint;

  /// No description provided for @spoilerReveal.
  ///
  /// In fr, this message translates to:
  /// **'Afficher'**
  String get spoilerReveal;

  /// No description provided for @settingsTitle.
  ///
  /// In fr, this message translates to:
  /// **'Réglages'**
  String get settingsTitle;

  /// No description provided for @spoilerGuardTitle.
  ///
  /// In fr, this message translates to:
  /// **'Masquer les spoilers'**
  String get spoilerGuardTitle;

  /// No description provided for @spoilerGuardSubtitle.
  ///
  /// In fr, this message translates to:
  /// **'Floute le synopsis des animes que vous n\'avez pas terminés.'**
  String get spoilerGuardSubtitle;

  /// No description provided for @releaseEpisode.
  ///
  /// In fr, this message translates to:
  /// **'Épisode {number}'**
  String releaseEpisode(int number);

  /// No description provided for @inWatchlistBadge.
  ///
  /// In fr, this message translates to:
  /// **'Dans ma liste'**
  String get inWatchlistBadge;

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

  /// No description provided for @extrasTrailer.
  ///
  /// In fr, this message translates to:
  /// **'Bande-annonce'**
  String get extrasTrailer;

  /// No description provided for @extrasWatchOn.
  ///
  /// In fr, this message translates to:
  /// **'Où regarder'**
  String get extrasWatchOn;

  /// No description provided for @extrasRelated.
  ///
  /// In fr, this message translates to:
  /// **'Suites et préquelles'**
  String get extrasRelated;

  /// No description provided for @relationSequel.
  ///
  /// In fr, this message translates to:
  /// **'Suite'**
  String get relationSequel;

  /// No description provided for @relationPrequel.
  ///
  /// In fr, this message translates to:
  /// **'Préquelle'**
  String get relationPrequel;

  /// No description provided for @extrasLinkFailed.
  ///
  /// In fr, this message translates to:
  /// **'Impossible d\'ouvrir ce lien.'**
  String get extrasLinkFailed;

  /// No description provided for @synopsisTranslatedNotice.
  ///
  /// In fr, this message translates to:
  /// **'Traduit automatiquement de l\'anglais.'**
  String get synopsisTranslatedNotice;

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

  /// No description provided for @constellationTitle.
  ///
  /// In fr, this message translates to:
  /// **'Ma constellation'**
  String get constellationTitle;

  /// No description provided for @constellationEntrySubtitle.
  ///
  /// In fr, this message translates to:
  /// **'Ta liste d\'animes, étoile par étoile'**
  String get constellationEntrySubtitle;

  /// No description provided for @constellationBack.
  ///
  /// In fr, this message translates to:
  /// **'Retour'**
  String get constellationBack;

  /// No description provided for @constellationLoading.
  ///
  /// In fr, this message translates to:
  /// **'Les étoiles s\'allument…'**
  String get constellationLoading;

  /// No description provided for @constellationEmptyTitle.
  ///
  /// In fr, this message translates to:
  /// **'Ton ciel est encore vide'**
  String get constellationEmptyTitle;

  /// No description provided for @constellationEmptyHint.
  ///
  /// In fr, this message translates to:
  /// **'Ajoute des animes à ta liste pour allumer ta constellation'**
  String get constellationEmptyHint;

  /// No description provided for @constellationErrorTitle.
  ///
  /// In fr, this message translates to:
  /// **'Le ciel est voilé'**
  String get constellationErrorTitle;

  /// No description provided for @constellationOpenSheet.
  ///
  /// In fr, this message translates to:
  /// **'Ouvrir la fiche'**
  String get constellationOpenSheet;

  /// No description provided for @constellationClosePreview.
  ///
  /// In fr, this message translates to:
  /// **'Fermer l\'aperçu'**
  String get constellationClosePreview;

  /// No description provided for @constellationLinkedCount.
  ///
  /// In fr, this message translates to:
  /// **'{count, plural, =0{Étoile solitaire} =1{Reliée à 1 anime} other{Reliée à {count} animes}}'**
  String constellationLinkedCount(int count);

  /// No description provided for @constellationSkyLabel.
  ///
  /// In fr, this message translates to:
  /// **'{count, plural, =1{Constellation de 1 anime} other{Constellation de {count} animes}}'**
  String constellationSkyLabel(int count);

  /// No description provided for @constellationFilterHint.
  ///
  /// In fr, this message translates to:
  /// **'Filtrer par genre'**
  String get constellationFilterHint;

  /// No description provided for @dexTitle.
  ///
  /// In fr, this message translates to:
  /// **'Animédex'**
  String get dexTitle;

  /// No description provided for @dexCardCount.
  ///
  /// In fr, this message translates to:
  /// **'{count, plural, =0{Aucune carte} =1{1 carte} other{{count} cartes}}'**
  String dexCardCount(int count);

  /// No description provided for @dexRarityCommon.
  ///
  /// In fr, this message translates to:
  /// **'Commune'**
  String get dexRarityCommon;

  /// No description provided for @dexRarityRare.
  ///
  /// In fr, this message translates to:
  /// **'Rare'**
  String get dexRarityRare;

  /// No description provided for @dexRarityEpic.
  ///
  /// In fr, this message translates to:
  /// **'Épique'**
  String get dexRarityEpic;

  /// No description provided for @dexRarityLegendary.
  ///
  /// In fr, this message translates to:
  /// **'Légendaire'**
  String get dexRarityLegendary;

  /// No description provided for @dexBoosterReadyTitle.
  ///
  /// In fr, this message translates to:
  /// **'Ton booster du jour est prêt !'**
  String get dexBoosterReadyTitle;

  /// No description provided for @dexBoosterReadyHint.
  ///
  /// In fr, this message translates to:
  /// **'5 cartes d\'animes à découvrir.'**
  String get dexBoosterReadyHint;

  /// No description provided for @dexBoosterOpen.
  ///
  /// In fr, this message translates to:
  /// **'Ouvrir'**
  String get dexBoosterOpen;

  /// No description provided for @dexBoosterWaitTitle.
  ///
  /// In fr, this message translates to:
  /// **'Prochain booster dans'**
  String get dexBoosterWaitTitle;

  /// No description provided for @dexBoosterWaitHint.
  ///
  /// In fr, this message translates to:
  /// **'Reviens demain pour 5 nouvelles cartes.'**
  String get dexBoosterWaitHint;

  /// No description provided for @dexEmptyTitle.
  ///
  /// In fr, this message translates to:
  /// **'Ton Animédex est vide'**
  String get dexEmptyTitle;

  /// No description provided for @dexEmptyHint.
  ///
  /// In fr, this message translates to:
  /// **'Ouvre ton premier booster pour recevoir 5 cartes d\'animes.'**
  String get dexEmptyHint;

  /// No description provided for @dexEmptyWaitHint.
  ///
  /// In fr, this message translates to:
  /// **'Ton prochain booster arrive bientôt.'**
  String get dexEmptyWaitHint;

  /// No description provided for @dexOpenFirstBooster.
  ///
  /// In fr, this message translates to:
  /// **'Ouvrir mon premier booster'**
  String get dexOpenFirstBooster;

  /// No description provided for @dexErrorTitle.
  ///
  /// In fr, this message translates to:
  /// **'Impossible d\'afficher ton Animédex'**
  String get dexErrorTitle;

  /// No description provided for @dexErrorHint.
  ///
  /// In fr, this message translates to:
  /// **'Une erreur est survenue. Réessaie dans un instant.'**
  String get dexErrorHint;

  /// No description provided for @dexCardLabel.
  ///
  /// In fr, this message translates to:
  /// **'{title}, carte {rarity}'**
  String dexCardLabel(String title, String rarity);

  /// No description provided for @dexPackLabel.
  ///
  /// In fr, this message translates to:
  /// **'Booster'**
  String get dexPackLabel;

  /// No description provided for @dexPackTapHint.
  ///
  /// In fr, this message translates to:
  /// **'Touche le paquet pour l\'ouvrir'**
  String get dexPackTapHint;

  /// No description provided for @dexPackOpening.
  ///
  /// In fr, this message translates to:
  /// **'Ouverture en cours…'**
  String get dexPackOpening;

  /// No description provided for @dexRevealHint.
  ///
  /// In fr, this message translates to:
  /// **'Touche la carte pour la révéler'**
  String get dexRevealHint;

  /// No description provided for @dexRevealProgress.
  ///
  /// In fr, this message translates to:
  /// **'{shown} / {total}'**
  String dexRevealProgress(int shown, int total);

  /// No description provided for @dexBadgeNew.
  ///
  /// In fr, this message translates to:
  /// **'NOUVEAU'**
  String get dexBadgeNew;

  /// No description provided for @dexBadgeDuplicate.
  ///
  /// In fr, this message translates to:
  /// **'Doublon'**
  String get dexBadgeDuplicate;

  /// No description provided for @dexRecapTitle.
  ///
  /// In fr, this message translates to:
  /// **'Récap du booster'**
  String get dexRecapTitle;

  /// No description provided for @dexRecapNew.
  ///
  /// In fr, this message translates to:
  /// **'{count, plural, =0{Aucune nouvelle carte} =1{1 nouvelle carte} other{{count} nouvelles cartes}}'**
  String dexRecapNew(int count);

  /// No description provided for @dexRecapDuplicates.
  ///
  /// In fr, this message translates to:
  /// **'{count, plural, =0{aucun doublon} =1{1 doublon} other{{count} doublons}}'**
  String dexRecapDuplicates(int count);

  /// No description provided for @dexSeeDex.
  ///
  /// In fr, this message translates to:
  /// **'Voir mon Animédex'**
  String get dexSeeDex;

  /// No description provided for @dexAlreadyOpenedTitle.
  ///
  /// In fr, this message translates to:
  /// **'Booster déjà ouvert aujourd\'hui'**
  String get dexAlreadyOpenedTitle;

  /// No description provided for @dexAlreadyOpenedHint.
  ///
  /// In fr, this message translates to:
  /// **'Reviens demain pour tirer 5 nouvelles cartes.'**
  String get dexAlreadyOpenedHint;

  /// No description provided for @dexBoosterErrorTitle.
  ///
  /// In fr, this message translates to:
  /// **'Le booster n\'a pas pu être tiré'**
  String get dexBoosterErrorTitle;

  /// No description provided for @dexBoosterErrorHint.
  ///
  /// In fr, this message translates to:
  /// **'Ton booster n\'est pas consommé. Vérifie ta connexion et réessaie.'**
  String get dexBoosterErrorHint;

  /// No description provided for @dexClose.
  ///
  /// In fr, this message translates to:
  /// **'Fermer'**
  String get dexClose;
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
