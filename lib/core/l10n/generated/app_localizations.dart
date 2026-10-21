import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_tr.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'generated/app_localizations.dart';
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
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('tr'),
  ];

  /// App name. The brand name stays Turkish in every language.
  ///
  /// In en, this message translates to:
  /// **'Mobil Arıcılık'**
  String get appTitle;

  /// Screen reader label and tooltip of the stepper's + button.
  ///
  /// In en, this message translates to:
  /// **'Increase'**
  String get stepperIncrease;

  /// Screen reader label and tooltip of the stepper's − button.
  ///
  /// In en, this message translates to:
  /// **'Decrease'**
  String get stepperDecrease;

  /// Screen reader label of a hive tile.
  ///
  /// In en, this message translates to:
  /// **'Hive {number}'**
  String hiveTileLabel(String number);

  /// Screen reader text for the 1–5 strength dots of a hive tile.
  ///
  /// In en, this message translates to:
  /// **'Strength {strength} of 5'**
  String hiveTileStrength(int strength);

  /// Screen reader text for the queen marking color dot of a hive tile.
  ///
  /// In en, this message translates to:
  /// **'Queen color {color, select, white{white} yellow{yellow} red{red} green{green} blue{blue} other{unknown}}'**
  String hiveTileQueenColor(String color);

  /// Developer menu, only in the dev flavor.
  ///
  /// In en, this message translates to:
  /// **'Developer menu'**
  String get devMenuTitle;

  /// Dev-only screen showing design system components.
  ///
  /// In en, this message translates to:
  /// **'Component gallery'**
  String get componentGalleryTitle;

  /// No description provided for @componentGalleryDescription.
  ///
  /// In en, this message translates to:
  /// **'Design system components in four themes'**
  String get componentGalleryDescription;

  /// No description provided for @galleryThemeLight.
  ///
  /// In en, this message translates to:
  /// **'Light'**
  String get galleryThemeLight;

  /// No description provided for @galleryThemeDark.
  ///
  /// In en, this message translates to:
  /// **'Dark'**
  String get galleryThemeDark;

  /// No description provided for @galleryThemeSun.
  ///
  /// In en, this message translates to:
  /// **'Sun'**
  String get galleryThemeSun;

  /// No description provided for @galleryThemeGlove.
  ///
  /// In en, this message translates to:
  /// **'Glove'**
  String get galleryThemeGlove;

  /// No description provided for @galleryBigButton.
  ///
  /// In en, this message translates to:
  /// **'Big button'**
  String get galleryBigButton;

  /// No description provided for @galleryChoiceChipGroup.
  ///
  /// In en, this message translates to:
  /// **'Choice chips'**
  String get galleryChoiceChipGroup;

  /// No description provided for @galleryBigStepper.
  ///
  /// In en, this message translates to:
  /// **'Big stepper'**
  String get galleryBigStepper;

  /// No description provided for @galleryStatusBadge.
  ///
  /// In en, this message translates to:
  /// **'Status badge'**
  String get galleryStatusBadge;

  /// No description provided for @galleryHiveTile.
  ///
  /// In en, this message translates to:
  /// **'Hive tile'**
  String get galleryHiveTile;

  /// No description provided for @galleryEmptyState.
  ///
  /// In en, this message translates to:
  /// **'Empty state'**
  String get galleryEmptyState;

  /// No description provided for @gallerySectionCard.
  ///
  /// In en, this message translates to:
  /// **'Section card'**
  String get gallerySectionCard;

  /// No description provided for @gallerySampleStartInspection.
  ///
  /// In en, this message translates to:
  /// **'Start inspection'**
  String get gallerySampleStartInspection;

  /// No description provided for @gallerySampleAddPhoto.
  ///
  /// In en, this message translates to:
  /// **'Add photo'**
  String get gallerySampleAddPhoto;

  /// No description provided for @gallerySampleSave.
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get gallerySampleSave;

  /// No description provided for @gallerySampleQueen.
  ///
  /// In en, this message translates to:
  /// **'Queen'**
  String get gallerySampleQueen;

  /// No description provided for @gallerySampleQueenSeen.
  ///
  /// In en, this message translates to:
  /// **'Seen'**
  String get gallerySampleQueenSeen;

  /// No description provided for @gallerySampleEggs.
  ///
  /// In en, this message translates to:
  /// **'Eggs present'**
  String get gallerySampleEggs;

  /// No description provided for @gallerySampleNone.
  ///
  /// In en, this message translates to:
  /// **'None'**
  String get gallerySampleNone;

  /// No description provided for @gallerySampleActions.
  ///
  /// In en, this message translates to:
  /// **'Actions taken'**
  String get gallerySampleActions;

  /// No description provided for @gallerySampleSuperAdded.
  ///
  /// In en, this message translates to:
  /// **'Super added'**
  String get gallerySampleSuperAdded;

  /// No description provided for @gallerySampleFrameAdded.
  ///
  /// In en, this message translates to:
  /// **'Frame added'**
  String get gallerySampleFrameAdded;

  /// No description provided for @gallerySampleFed.
  ///
  /// In en, this message translates to:
  /// **'Fed'**
  String get gallerySampleFed;

  /// No description provided for @gallerySampleBeeFrames.
  ///
  /// In en, this message translates to:
  /// **'Frames with bees'**
  String get gallerySampleBeeFrames;

  /// No description provided for @gallerySampleBroodFrames.
  ///
  /// In en, this message translates to:
  /// **'Brood frames'**
  String get gallerySampleBroodFrames;

  /// No description provided for @gallerySampleStrong.
  ///
  /// In en, this message translates to:
  /// **'Strong'**
  String get gallerySampleStrong;

  /// No description provided for @gallerySampleWeak.
  ///
  /// In en, this message translates to:
  /// **'Weak'**
  String get gallerySampleWeak;

  /// No description provided for @gallerySampleQueenless.
  ///
  /// In en, this message translates to:
  /// **'Queenless'**
  String get gallerySampleQueenless;

  /// No description provided for @gallerySampleTask.
  ///
  /// In en, this message translates to:
  /// **'Task'**
  String get gallerySampleTask;

  /// No description provided for @gallerySampleNoApiaries.
  ///
  /// In en, this message translates to:
  /// **'No apiaries yet'**
  String get gallerySampleNoApiaries;

  /// No description provided for @gallerySampleNoApiariesMessage.
  ///
  /// In en, this message translates to:
  /// **'An apiary groups your hives by where they stand; add your first one to begin.'**
  String get gallerySampleNoApiariesMessage;

  /// No description provided for @gallerySampleAddApiary.
  ///
  /// In en, this message translates to:
  /// **'Add your first apiary'**
  String get gallerySampleAddApiary;

  /// No description provided for @gallerySampleLastInspection.
  ///
  /// In en, this message translates to:
  /// **'Last inspection'**
  String get gallerySampleLastInspection;

  /// No description provided for @gallerySampleLastInspectionBody.
  ///
  /// In en, this message translates to:
  /// **'3 days ago · 7 frames with bees · queen seen'**
  String get gallerySampleLastInspectionBody;

  /// No description provided for @gallerySampleUntitledCard.
  ///
  /// In en, this message translates to:
  /// **'A card can also go without a title; the content starts right away.'**
  String get gallerySampleUntitledCard;
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
      <String>['en', 'tr'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'tr':
      return AppLocalizationsTr();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
