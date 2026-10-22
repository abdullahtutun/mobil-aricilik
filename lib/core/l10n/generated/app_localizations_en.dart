// ignore: unused_import
import 'package:intl/intl.dart' as intl;

import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'Mobil Arıcı';

  @override
  String get listSeparator => ', ';

  @override
  String get stepperIncrease => 'Increase';

  @override
  String get stepperDecrease => 'Decrease';

  @override
  String hiveTileLabel(String number) {
    return 'Hive $number';
  }

  @override
  String hiveTileStrength(int strength) {
    return 'Strength $strength of 5';
  }

  @override
  String hiveTileQueenColor(String color) {
    String _temp0 = intl.Intl.selectLogic(color, {
      'white': 'white',
      'yellow': 'yellow',
      'red': 'red',
      'green': 'green',
      'blue': 'blue',
      'other': 'unknown',
    });
    return 'Queen color $_temp0';
  }

  @override
  String get tabToday => 'Today';

  @override
  String get tabApiaries => 'Apiaries';

  @override
  String get tabTasks => 'Tasks';

  @override
  String get tabMore => 'More';

  @override
  String get todayEmptyTitle => 'Nothing for today';

  @override
  String get todayEmptyMessage =>
      'Today\'s tasks, hives that need attention and the weather will gather here.';

  @override
  String get apiariesEmptyTitle => 'No apiaries yet';

  @override
  String get apiariesEmptyMessage =>
      'An apiary groups your hives by where they stand; adding apiaries is coming soon.';

  @override
  String get tasksEmptyTitle => 'No tasks yet';

  @override
  String get tasksEmptyMessage =>
      'Your reminders and to-dos will be listed here by date.';

  @override
  String get moreEmptyTitle => 'More modules on the way';

  @override
  String get moreEmptyMessage =>
      'Queens, harvest, stock, finance, documents and the knowledge base will live here.';

  @override
  String get scanTitle => 'Scan';

  @override
  String get scanLongPressHint => 'open the quick record menu';

  @override
  String get scanPlaceholderTitle => 'Scan a hive';

  @override
  String get scanPlaceholderMessage =>
      'Scanning the QR code or NFC tag on a hive will open its hive card; scanning is coming soon.';

  @override
  String get quickRecordTitle => 'Quick record';

  @override
  String get quickRecordInspection => 'Inspection';

  @override
  String get quickRecordFeeding => 'Feeding';

  @override
  String get quickRecordTreatment => 'Treatment';

  @override
  String get quickRecordHarvest => 'Harvest';

  @override
  String get quickRecordNote => 'Note';

  @override
  String get quickRecordExpense => 'Expense';

  @override
  String get quickRecordComingSoon => 'This record type is coming soon.';

  @override
  String get signInTitle => 'Sign in';

  @override
  String get signInEmailMessage =>
      'Enter your email and we\'ll send you a 6-digit code. No password needed.';

  @override
  String get signInEmailLabel => 'Email';

  @override
  String get signInSendCode => 'Send code';

  @override
  String get signInSending => 'Sending…';

  @override
  String get signInCodeTitle => 'Enter the code';

  @override
  String signInCodeMessage(String email) {
    return 'We sent a 6-digit code to $email.';
  }

  @override
  String get signInCodeFieldLabel => '6-digit code';

  @override
  String get signInVerify => 'Sign in';

  @override
  String get signInVerifying => 'Checking…';

  @override
  String get signInResend => 'Resend code';

  @override
  String signInResendIn(int seconds) {
    return 'Resend code ($seconds s)';
  }

  @override
  String get signInCodeResent => 'A new code is on its way.';

  @override
  String get authErrorNetwork =>
      'Couldn\'t connect. Check your internet and try again.';

  @override
  String get authErrorInvalidEmail => 'Enter a valid email address.';

  @override
  String get authErrorInvalidCode =>
      'The code is wrong or has expired. Try again or request a new code.';

  @override
  String get authErrorTooManyRequests =>
      'Too many attempts. Wait a little and try again.';

  @override
  String get authErrorUnknown => 'Something went wrong. Please try again.';

  @override
  String get settingsTitle => 'Settings';

  @override
  String get settingsSystemDefault => 'System';

  @override
  String get settingsLanguage => 'Language';

  @override
  String get languageTurkish => 'Türkçe';

  @override
  String get languageEnglish => 'English';

  @override
  String get settingsColorMode => 'Theme';

  @override
  String get settingsColorModeLight => 'Light';

  @override
  String get settingsColorModeDark => 'Dark';

  @override
  String get settingsColorModeSun => 'Sun';

  @override
  String get settingsAccount => 'Account';

  @override
  String settingsSignedInAs(String email) {
    return 'Signed in as $email';
  }

  @override
  String get settingsSignOut => 'Sign out';

  @override
  String get settingsSignOutConfirmTitle => 'Sign out?';

  @override
  String get settingsSignOutConfirmMessage =>
      'To sign back in you\'ll need a new code sent to your email, which needs internet.';

  @override
  String get actionCancel => 'Cancel';

  @override
  String get actionRetry => 'Try again';

  @override
  String onboardingStepCounter(int current, int total) {
    return 'Step $current of $total';
  }

  @override
  String get onboardingContinue => 'Continue';

  @override
  String get onboardingFinish => 'Set up business';

  @override
  String get onboardingFinishing => 'Setting up…';

  @override
  String get onboardingLanguageTitle => 'Which language should we use?';

  @override
  String get onboardingLanguageMessage =>
      'You can change it later in Settings.';

  @override
  String get onboardingCountryTitle => 'Where is your business?';

  @override
  String get onboardingCountryMessage =>
      'Your country sets the currency, units and region-specific modules.';

  @override
  String get onboardingCountrySearch => 'Search countries';

  @override
  String get onboardingCountrySuggested => 'Suggested for your device';

  @override
  String get onboardingCountryAll => 'All countries';

  @override
  String get onboardingCountryNoMatch => 'No country matches your search.';

  @override
  String get onboardingNameTitle => 'What\'s your business called?';

  @override
  String get onboardingNameMessage =>
      'This name appears on your records and reports.';

  @override
  String get onboardingNameLabel => 'Business name';

  @override
  String get onboardingNameHint => 'e.g. Golden Comb Apiaries';

  @override
  String get onboardingHiveCountTitle => 'How many hives do you have?';

  @override
  String get onboardingHiveCountMessage =>
      'A rough number is enough; we\'ll suggest how to track them. You\'ll add the hives themselves later.';

  @override
  String get hiveCountRangeNone => 'None yet';

  @override
  String get hiveCountRangeUpTo10 => '1–10';

  @override
  String get hiveCountRangeUpTo50 => '11–50';

  @override
  String get hiveCountRangeUpTo200 => '51–200';

  @override
  String get hiveCountRangeOver200 => 'More than 200';

  @override
  String get onboardingLoading => 'Loading your business';

  @override
  String get onboardingLoadErrorTitle => 'Couldn\'t load your business';

  @override
  String get onboardingErrorNetwork =>
      'Couldn\'t connect. Check your internet and try again.';

  @override
  String get onboardingErrorUnknown =>
      'Something went wrong. Please try again.';

  @override
  String get devMenuTitle => 'Developer menu';

  @override
  String get componentGalleryTitle => 'Component gallery';

  @override
  String get componentGalleryDescription =>
      'Design system components in four themes';

  @override
  String get galleryThemeLight => 'Light';

  @override
  String get galleryThemeDark => 'Dark';

  @override
  String get galleryThemeSun => 'Sun';

  @override
  String get galleryThemeGlove => 'Glove';

  @override
  String get galleryBigButton => 'Big button';

  @override
  String get galleryChoiceChipGroup => 'Choice chips';

  @override
  String get galleryBigStepper => 'Big stepper';

  @override
  String get galleryStatusBadge => 'Status badge';

  @override
  String get galleryHiveTile => 'Hive tile';

  @override
  String get galleryEmptyState => 'Empty state';

  @override
  String get gallerySectionCard => 'Section card';

  @override
  String get gallerySampleStartInspection => 'Start inspection';

  @override
  String get gallerySampleAddPhoto => 'Add photo';

  @override
  String get gallerySampleSave => 'Save';

  @override
  String get gallerySampleQueen => 'Queen';

  @override
  String get gallerySampleQueenSeen => 'Seen';

  @override
  String get gallerySampleEggs => 'Eggs present';

  @override
  String get gallerySampleNone => 'None';

  @override
  String get gallerySampleActions => 'Actions taken';

  @override
  String get gallerySampleSuperAdded => 'Super added';

  @override
  String get gallerySampleFrameAdded => 'Frame added';

  @override
  String get gallerySampleFed => 'Fed';

  @override
  String get gallerySampleBeeFrames => 'Frames with bees';

  @override
  String get gallerySampleBroodFrames => 'Brood frames';

  @override
  String get gallerySampleStrong => 'Strong';

  @override
  String get gallerySampleWeak => 'Weak';

  @override
  String get gallerySampleQueenless => 'Queenless';

  @override
  String get gallerySampleTask => 'Task';

  @override
  String get gallerySampleNoApiaries => 'No apiaries yet';

  @override
  String get gallerySampleNoApiariesMessage =>
      'An apiary groups your hives by where they stand; add your first one to begin.';

  @override
  String get gallerySampleAddApiary => 'Add your first apiary';

  @override
  String get gallerySampleLastInspection => 'Last inspection';

  @override
  String get gallerySampleLastInspectionBody =>
      '3 days ago · 7 frames with bees · queen seen';

  @override
  String get gallerySampleUntitledCard =>
      'A card can also go without a title; the content starts right away.';
}
