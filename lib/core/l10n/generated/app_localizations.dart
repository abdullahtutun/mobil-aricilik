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
  /// **'Mobil Arıcı'**
  String get appTitle;

  /// Joins the parts of a screen reader label, e.g. on a hive tile.
  ///
  /// In en, this message translates to:
  /// **', '**
  String get listSeparator;

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

  /// Bottom navigation tab: daily dashboard.
  ///
  /// In en, this message translates to:
  /// **'Today'**
  String get tabToday;

  /// Bottom navigation tab: apiaries and their hives.
  ///
  /// In en, this message translates to:
  /// **'Apiaries'**
  String get tabApiaries;

  /// Bottom navigation tab: reminders and to-dos.
  ///
  /// In en, this message translates to:
  /// **'Tasks'**
  String get tabTasks;

  /// Bottom navigation tab: less frequently used modules and settings.
  ///
  /// In en, this message translates to:
  /// **'More'**
  String get tabMore;

  /// No description provided for @todayEmptyTitle.
  ///
  /// In en, this message translates to:
  /// **'Nothing for today'**
  String get todayEmptyTitle;

  /// No description provided for @todayEmptyMessage.
  ///
  /// In en, this message translates to:
  /// **'Today\'s tasks, hives that need attention and the weather will gather here.'**
  String get todayEmptyMessage;

  /// No description provided for @apiariesEmptyTitle.
  ///
  /// In en, this message translates to:
  /// **'No apiaries yet'**
  String get apiariesEmptyTitle;

  /// No description provided for @apiariesEmptyMessage.
  ///
  /// In en, this message translates to:
  /// **'An apiary groups your hives by where they stand; add your first one to begin.'**
  String get apiariesEmptyMessage;

  /// No description provided for @apiariesAdd.
  ///
  /// In en, this message translates to:
  /// **'Add apiary'**
  String get apiariesAdd;

  /// No description provided for @apiariesAddFirst.
  ///
  /// In en, this message translates to:
  /// **'Add your first apiary'**
  String get apiariesAddFirst;

  /// No description provided for @apiariesLoadError.
  ///
  /// In en, this message translates to:
  /// **'Couldn\'t read your apiaries.'**
  String get apiariesLoadError;

  /// Active hives in an apiary, on the apiary list.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =0{No hives} =1{1 hive} other{{count} hives}}'**
  String apiaryHiveCount(int count);

  /// Date of the last visit to an apiary, on the apiary list.
  ///
  /// In en, this message translates to:
  /// **'Last visit {date}'**
  String apiaryLastVisit(String date);

  /// No description provided for @apiaryNoVisit.
  ///
  /// In en, this message translates to:
  /// **'No visits yet'**
  String get apiaryNoVisit;

  /// Second line of an apiary on the list: hive count and last visit.
  ///
  /// In en, this message translates to:
  /// **'{hives} · {visit}'**
  String apiaryListSubtitle(String hives, String visit);

  /// Label under the big hive count at the top of an apiary.
  ///
  /// In en, this message translates to:
  /// **'Active hives'**
  String get apiaryActiveHives;

  /// No description provided for @apiaryLastVisitLabel.
  ///
  /// In en, this message translates to:
  /// **'Last visit'**
  String get apiaryLastVisitLabel;

  /// Value of 'Last visit' when the apiary was never visited.
  ///
  /// In en, this message translates to:
  /// **'None yet'**
  String get apiaryVisitNone;

  /// No description provided for @apiaryEdit.
  ///
  /// In en, this message translates to:
  /// **'Edit'**
  String get apiaryEdit;

  /// No description provided for @apiaryNotFoundTitle.
  ///
  /// In en, this message translates to:
  /// **'Apiary not found'**
  String get apiaryNotFoundTitle;

  /// No description provided for @apiaryNotFoundMessage.
  ///
  /// In en, this message translates to:
  /// **'It may have been deleted or not reached this device yet.'**
  String get apiaryNotFoundMessage;

  /// No description provided for @apiaryFormNewTitle.
  ///
  /// In en, this message translates to:
  /// **'New apiary'**
  String get apiaryFormNewTitle;

  /// No description provided for @apiaryFormEditTitle.
  ///
  /// In en, this message translates to:
  /// **'Edit apiary'**
  String get apiaryFormEditTitle;

  /// No description provided for @apiaryFormName.
  ///
  /// In en, this message translates to:
  /// **'Apiary name'**
  String get apiaryFormName;

  /// No description provided for @apiaryFormNameHint.
  ///
  /// In en, this message translates to:
  /// **'e.g. Hilltop'**
  String get apiaryFormNameHint;

  /// No description provided for @apiaryFormLocation.
  ///
  /// In en, this message translates to:
  /// **'Location'**
  String get apiaryFormLocation;

  /// No description provided for @apiaryFormLocationNone.
  ///
  /// In en, this message translates to:
  /// **'No location yet. If you\'re at the apiary, take it from GPS; no internet needed.'**
  String get apiaryFormLocationNone;

  /// No description provided for @apiaryFormLocationTake.
  ///
  /// In en, this message translates to:
  /// **'Take location from GPS'**
  String get apiaryFormLocationTake;

  /// No description provided for @apiaryFormLocationRetake.
  ///
  /// In en, this message translates to:
  /// **'Take location again'**
  String get apiaryFormLocationRetake;

  /// No description provided for @apiaryFormLocationClear.
  ///
  /// In en, this message translates to:
  /// **'Remove location'**
  String get apiaryFormLocationClear;

  /// No description provided for @apiaryFormLocating.
  ///
  /// In en, this message translates to:
  /// **'Getting your location… It\'s quicker in the open.'**
  String get apiaryFormLocating;

  /// How precise the GPS location is, in meters.
  ///
  /// In en, this message translates to:
  /// **'Accuracy ±{meters} m'**
  String apiaryFormLocationAccuracy(int meters);

  /// No description provided for @apiaryFormLocationErrorServiceDisabled.
  ///
  /// In en, this message translates to:
  /// **'Location is turned off on this device. Turn it on and try again.'**
  String get apiaryFormLocationErrorServiceDisabled;

  /// No description provided for @apiaryFormLocationErrorPermissionDenied.
  ///
  /// In en, this message translates to:
  /// **'Location permission wasn\'t given. Allow it to take the location.'**
  String get apiaryFormLocationErrorPermissionDenied;

  /// No description provided for @apiaryFormLocationErrorPermissionDeniedForever.
  ///
  /// In en, this message translates to:
  /// **'Location permission is off. Allow location for this app in Settings.'**
  String get apiaryFormLocationErrorPermissionDeniedForever;

  /// No description provided for @apiaryFormLocationErrorTimeout.
  ///
  /// In en, this message translates to:
  /// **'Couldn\'t find your location. Try again in the open.'**
  String get apiaryFormLocationErrorTimeout;

  /// No description provided for @apiaryFormLocationErrorUnknown.
  ///
  /// In en, this message translates to:
  /// **'Couldn\'t get your location. Try again.'**
  String get apiaryFormLocationErrorUnknown;

  /// No description provided for @apiaryFormOpenSettings.
  ///
  /// In en, this message translates to:
  /// **'Open settings'**
  String get apiaryFormOpenSettings;

  /// No description provided for @apiaryFormLandownerName.
  ///
  /// In en, this message translates to:
  /// **'Landowner\'s name'**
  String get apiaryFormLandownerName;

  /// No description provided for @apiaryFormLandownerPhone.
  ///
  /// In en, this message translates to:
  /// **'Landowner\'s phone'**
  String get apiaryFormLandownerPhone;

  /// No description provided for @apiaryFormNotes.
  ///
  /// In en, this message translates to:
  /// **'Notes'**
  String get apiaryFormNotes;

  /// No description provided for @apiaryFormSave.
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get apiaryFormSave;

  /// No description provided for @tasksEmptyTitle.
  ///
  /// In en, this message translates to:
  /// **'No tasks yet'**
  String get tasksEmptyTitle;

  /// No description provided for @tasksEmptyMessage.
  ///
  /// In en, this message translates to:
  /// **'Your reminders and to-dos will be listed here by date.'**
  String get tasksEmptyMessage;

  /// No description provided for @moreEmptyTitle.
  ///
  /// In en, this message translates to:
  /// **'More modules on the way'**
  String get moreEmptyTitle;

  /// No description provided for @moreEmptyMessage.
  ///
  /// In en, this message translates to:
  /// **'Queens, harvest, stock, finance, documents and the knowledge base will live here.'**
  String get moreEmptyMessage;

  /// Label of the big center button in the bottom navigation and title of the scan screen it opens.
  ///
  /// In en, this message translates to:
  /// **'Scan'**
  String get scanTitle;

  /// Screen reader hint for long pressing the center Scan button; read after 'double tap and hold to'.
  ///
  /// In en, this message translates to:
  /// **'open the quick record menu'**
  String get scanLongPressHint;

  /// No description provided for @scanPlaceholderTitle.
  ///
  /// In en, this message translates to:
  /// **'Scan a hive'**
  String get scanPlaceholderTitle;

  /// No description provided for @scanPlaceholderMessage.
  ///
  /// In en, this message translates to:
  /// **'Scanning the QR code or NFC tag on a hive will open its hive card; scanning is coming soon.'**
  String get scanPlaceholderMessage;

  /// Menu opened by long pressing the center Scan button.
  ///
  /// In en, this message translates to:
  /// **'Quick record'**
  String get quickRecordTitle;

  /// No description provided for @quickRecordInspection.
  ///
  /// In en, this message translates to:
  /// **'Inspection'**
  String get quickRecordInspection;

  /// No description provided for @quickRecordFeeding.
  ///
  /// In en, this message translates to:
  /// **'Feeding'**
  String get quickRecordFeeding;

  /// Record of a medicine or varroa treatment.
  ///
  /// In en, this message translates to:
  /// **'Treatment'**
  String get quickRecordTreatment;

  /// No description provided for @quickRecordHarvest.
  ///
  /// In en, this message translates to:
  /// **'Harvest'**
  String get quickRecordHarvest;

  /// No description provided for @quickRecordNote.
  ///
  /// In en, this message translates to:
  /// **'Note'**
  String get quickRecordNote;

  /// No description provided for @quickRecordExpense.
  ///
  /// In en, this message translates to:
  /// **'Expense'**
  String get quickRecordExpense;

  /// No description provided for @quickRecordComingSoon.
  ///
  /// In en, this message translates to:
  /// **'This record type is coming soon.'**
  String get quickRecordComingSoon;

  /// No description provided for @signInTitle.
  ///
  /// In en, this message translates to:
  /// **'Sign in'**
  String get signInTitle;

  /// No description provided for @signInEmailMessage.
  ///
  /// In en, this message translates to:
  /// **'Enter your email and we\'ll send you a 6-digit code. No password needed.'**
  String get signInEmailMessage;

  /// No description provided for @signInEmailLabel.
  ///
  /// In en, this message translates to:
  /// **'Email'**
  String get signInEmailLabel;

  /// No description provided for @signInSendCode.
  ///
  /// In en, this message translates to:
  /// **'Send code'**
  String get signInSendCode;

  /// No description provided for @signInSending.
  ///
  /// In en, this message translates to:
  /// **'Sending…'**
  String get signInSending;

  /// No description provided for @signInCodeTitle.
  ///
  /// In en, this message translates to:
  /// **'Enter the code'**
  String get signInCodeTitle;

  /// No description provided for @signInCodeMessage.
  ///
  /// In en, this message translates to:
  /// **'We sent a 6-digit code to {email}.'**
  String signInCodeMessage(String email);

  /// Screen reader label of the code input; the digit boxes are not read separately.
  ///
  /// In en, this message translates to:
  /// **'6-digit code'**
  String get signInCodeFieldLabel;

  /// No description provided for @signInVerify.
  ///
  /// In en, this message translates to:
  /// **'Sign in'**
  String get signInVerify;

  /// No description provided for @signInVerifying.
  ///
  /// In en, this message translates to:
  /// **'Checking…'**
  String get signInVerifying;

  /// No description provided for @signInResend.
  ///
  /// In en, this message translates to:
  /// **'Resend code'**
  String get signInResend;

  /// Disabled resend button with the seconds left until a new code can be requested.
  ///
  /// In en, this message translates to:
  /// **'Resend code ({seconds} s)'**
  String signInResendIn(int seconds);

  /// No description provided for @signInCodeResent.
  ///
  /// In en, this message translates to:
  /// **'A new code is on its way.'**
  String get signInCodeResent;

  /// No description provided for @authErrorNetwork.
  ///
  /// In en, this message translates to:
  /// **'Couldn\'t connect. Check your internet and try again.'**
  String get authErrorNetwork;

  /// No description provided for @authErrorInvalidEmail.
  ///
  /// In en, this message translates to:
  /// **'Enter a valid email address.'**
  String get authErrorInvalidEmail;

  /// No description provided for @authErrorInvalidCode.
  ///
  /// In en, this message translates to:
  /// **'The code is wrong or has expired. Try again or request a new code.'**
  String get authErrorInvalidCode;

  /// No description provided for @authErrorTooManyRequests.
  ///
  /// In en, this message translates to:
  /// **'Too many attempts. Wait a little and try again.'**
  String get authErrorTooManyRequests;

  /// No description provided for @authErrorUnknown.
  ///
  /// In en, this message translates to:
  /// **'Something went wrong. Please try again.'**
  String get authErrorUnknown;

  /// No description provided for @settingsTitle.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settingsTitle;

  /// Choice that follows the device setting, for both language and theme.
  ///
  /// In en, this message translates to:
  /// **'System'**
  String get settingsSystemDefault;

  /// No description provided for @settingsLanguage.
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get settingsLanguage;

  /// Name of the Turkish language, always written in Turkish.
  ///
  /// In en, this message translates to:
  /// **'Türkçe'**
  String get languageTurkish;

  /// Name of the English language, always written in English.
  ///
  /// In en, this message translates to:
  /// **'English'**
  String get languageEnglish;

  /// No description provided for @settingsColorMode.
  ///
  /// In en, this message translates to:
  /// **'Theme'**
  String get settingsColorMode;

  /// No description provided for @settingsColorModeLight.
  ///
  /// In en, this message translates to:
  /// **'Light'**
  String get settingsColorModeLight;

  /// No description provided for @settingsColorModeDark.
  ///
  /// In en, this message translates to:
  /// **'Dark'**
  String get settingsColorModeDark;

  /// High contrast theme for bright sunlight.
  ///
  /// In en, this message translates to:
  /// **'Sun'**
  String get settingsColorModeSun;

  /// No description provided for @settingsAccount.
  ///
  /// In en, this message translates to:
  /// **'Account'**
  String get settingsAccount;

  /// No description provided for @settingsSignedInAs.
  ///
  /// In en, this message translates to:
  /// **'Signed in as {email}'**
  String settingsSignedInAs(String email);

  /// No description provided for @settingsSignOut.
  ///
  /// In en, this message translates to:
  /// **'Sign out'**
  String get settingsSignOut;

  /// No description provided for @settingsSignOutConfirmTitle.
  ///
  /// In en, this message translates to:
  /// **'Sign out?'**
  String get settingsSignOutConfirmTitle;

  /// No description provided for @settingsSignOutConfirmMessage.
  ///
  /// In en, this message translates to:
  /// **'To sign back in you\'ll need a new code sent to your email, which needs internet.'**
  String get settingsSignOutConfirmMessage;

  /// No description provided for @actionCancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get actionCancel;

  /// No description provided for @actionRetry.
  ///
  /// In en, this message translates to:
  /// **'Try again'**
  String get actionRetry;

  /// Progress in the first-run setup shown after sign-in.
  ///
  /// In en, this message translates to:
  /// **'Step {current} of {total}'**
  String onboardingStepCounter(int current, int total);

  /// No description provided for @onboardingContinue.
  ///
  /// In en, this message translates to:
  /// **'Continue'**
  String get onboardingContinue;

  /// No description provided for @onboardingFinish.
  ///
  /// In en, this message translates to:
  /// **'Set up business'**
  String get onboardingFinish;

  /// No description provided for @onboardingFinishing.
  ///
  /// In en, this message translates to:
  /// **'Setting up…'**
  String get onboardingFinishing;

  /// No description provided for @onboardingLanguageTitle.
  ///
  /// In en, this message translates to:
  /// **'Which language should we use?'**
  String get onboardingLanguageTitle;

  /// No description provided for @onboardingLanguageMessage.
  ///
  /// In en, this message translates to:
  /// **'You can change it later in Settings.'**
  String get onboardingLanguageMessage;

  /// No description provided for @onboardingCountryTitle.
  ///
  /// In en, this message translates to:
  /// **'Where is your business?'**
  String get onboardingCountryTitle;

  /// No description provided for @onboardingCountryMessage.
  ///
  /// In en, this message translates to:
  /// **'Your country sets the currency, units and region-specific modules.'**
  String get onboardingCountryMessage;

  /// No description provided for @onboardingCountrySearch.
  ///
  /// In en, this message translates to:
  /// **'Search countries'**
  String get onboardingCountrySearch;

  /// Heading above the country guessed from the device's language and region settings.
  ///
  /// In en, this message translates to:
  /// **'Suggested for your device'**
  String get onboardingCountrySuggested;

  /// No description provided for @onboardingCountryAll.
  ///
  /// In en, this message translates to:
  /// **'All countries'**
  String get onboardingCountryAll;

  /// No description provided for @onboardingCountryNoMatch.
  ///
  /// In en, this message translates to:
  /// **'No country matches your search.'**
  String get onboardingCountryNoMatch;

  /// No description provided for @onboardingNameTitle.
  ///
  /// In en, this message translates to:
  /// **'What\'s your business called?'**
  String get onboardingNameTitle;

  /// No description provided for @onboardingNameMessage.
  ///
  /// In en, this message translates to:
  /// **'This name appears on your records and reports.'**
  String get onboardingNameMessage;

  /// No description provided for @onboardingNameLabel.
  ///
  /// In en, this message translates to:
  /// **'Business name'**
  String get onboardingNameLabel;

  /// No description provided for @onboardingNameHint.
  ///
  /// In en, this message translates to:
  /// **'e.g. Golden Comb Apiaries'**
  String get onboardingNameHint;

  /// No description provided for @onboardingHiveCountTitle.
  ///
  /// In en, this message translates to:
  /// **'How many hives do you have?'**
  String get onboardingHiveCountTitle;

  /// No description provided for @onboardingHiveCountMessage.
  ///
  /// In en, this message translates to:
  /// **'A rough number is enough; we\'ll suggest how to track them. You\'ll add the hives themselves later.'**
  String get onboardingHiveCountMessage;

  /// No description provided for @hiveCountRangeNone.
  ///
  /// In en, this message translates to:
  /// **'None yet'**
  String get hiveCountRangeNone;

  /// No description provided for @hiveCountRangeUpTo10.
  ///
  /// In en, this message translates to:
  /// **'1–10'**
  String get hiveCountRangeUpTo10;

  /// No description provided for @hiveCountRangeUpTo50.
  ///
  /// In en, this message translates to:
  /// **'11–50'**
  String get hiveCountRangeUpTo50;

  /// No description provided for @hiveCountRangeUpTo200.
  ///
  /// In en, this message translates to:
  /// **'51–200'**
  String get hiveCountRangeUpTo200;

  /// No description provided for @hiveCountRangeOver200.
  ///
  /// In en, this message translates to:
  /// **'More than 200'**
  String get hiveCountRangeOver200;

  /// No description provided for @onboardingApiaryTitle.
  ///
  /// In en, this message translates to:
  /// **'Add your first apiary'**
  String get onboardingApiaryTitle;

  /// No description provided for @onboardingApiaryMessage.
  ///
  /// In en, this message translates to:
  /// **'An apiary is where your hives stand. Saving it needs no internet.'**
  String get onboardingApiaryMessage;

  /// No description provided for @onboardingApiarySave.
  ///
  /// In en, this message translates to:
  /// **'Save apiary'**
  String get onboardingApiarySave;

  /// No description provided for @onboardingApiarySkip.
  ///
  /// In en, this message translates to:
  /// **'Skip for now'**
  String get onboardingApiarySkip;

  /// Screen reader label of the spinner shown while the business is fetched after sign-in.
  ///
  /// In en, this message translates to:
  /// **'Loading your business'**
  String get onboardingLoading;

  /// No description provided for @onboardingLoadErrorTitle.
  ///
  /// In en, this message translates to:
  /// **'Couldn\'t load your business'**
  String get onboardingLoadErrorTitle;

  /// No description provided for @onboardingErrorNetwork.
  ///
  /// In en, this message translates to:
  /// **'Couldn\'t connect. Check your internet and try again.'**
  String get onboardingErrorNetwork;

  /// No description provided for @onboardingErrorUnknown.
  ///
  /// In en, this message translates to:
  /// **'Something went wrong. Please try again.'**
  String get onboardingErrorUnknown;

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
