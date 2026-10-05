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
