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
      'An apiary groups your hives by where they stand; add your first one to begin.';

  @override
  String get apiariesAdd => 'Add apiary';

  @override
  String get apiariesAddFirst => 'Add your first apiary';

  @override
  String get apiariesLoadError => 'Couldn\'t read your apiaries.';

  @override
  String apiaryHiveCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count hives',
      one: '1 hive',
      zero: 'No hives',
    );
    return '$_temp0';
  }

  @override
  String apiaryLastVisit(String date) {
    return 'Last visit $date';
  }

  @override
  String get apiaryNoVisit => 'No visits yet';

  @override
  String apiaryListSubtitle(String hives, String visit) {
    return '$hives · $visit';
  }

  @override
  String get apiaryActiveHives => 'Active hives';

  @override
  String get apiaryLastVisitLabel => 'Last visit';

  @override
  String get apiaryVisitNone => 'None yet';

  @override
  String get apiaryEdit => 'Edit';

  @override
  String get apiaryNotFoundTitle => 'Apiary not found';

  @override
  String get apiaryNotFoundMessage =>
      'It may have been deleted or not reached this device yet.';

  @override
  String get apiaryFormNewTitle => 'New apiary';

  @override
  String get apiaryFormEditTitle => 'Edit apiary';

  @override
  String get apiaryFormName => 'Apiary name';

  @override
  String get apiaryFormNameHint => 'e.g. Hilltop';

  @override
  String get apiaryFormLocation => 'Location';

  @override
  String get apiaryFormLocationNone =>
      'No location yet. If you\'re at the apiary, take it from GPS; no internet needed.';

  @override
  String get apiaryFormLocationTake => 'Take location from GPS';

  @override
  String get apiaryFormLocationRetake => 'Take location again';

  @override
  String get apiaryFormLocationClear => 'Remove location';

  @override
  String get apiaryFormLocating =>
      'Getting your location… It\'s quicker in the open.';

  @override
  String apiaryFormLocationAccuracy(int meters) {
    return 'Accuracy ±$meters m';
  }

  @override
  String get apiaryFormLocationErrorServiceDisabled =>
      'Location is turned off on this device. Turn it on and try again.';

  @override
  String get apiaryFormLocationErrorPermissionDenied =>
      'Location permission wasn\'t given. Allow it to take the location.';

  @override
  String get apiaryFormLocationErrorPermissionDeniedForever =>
      'Location permission is off. Allow location for this app in Settings.';

  @override
  String get apiaryFormLocationErrorTimeout =>
      'Couldn\'t find your location. Try again in the open.';

  @override
  String get apiaryFormLocationErrorUnknown =>
      'Couldn\'t get your location. Try again.';

  @override
  String get apiaryFormOpenSettings => 'Open settings';

  @override
  String get apiaryFormLandownerName => 'Landowner\'s name';

  @override
  String get apiaryFormLandownerPhone => 'Landowner\'s phone';

  @override
  String get apiaryFormNotes => 'Notes';

  @override
  String get apiaryFormSave => 'Save';

  @override
  String get apiaryHivesTitle => 'Hives';

  @override
  String get hiveLayoutGrid => 'Grid view';

  @override
  String get hiveLayoutList => 'List view';

  @override
  String get hivesEmptyTitle => 'No hives yet';

  @override
  String get hivesEmptyMessage =>
      'Add the hives standing in this apiary; you can create many at once.';

  @override
  String get hivesAdd => 'Add hives';

  @override
  String get hivesAddOne => 'One hive';

  @override
  String get hivesAddOneHint => 'Enter its number, type and source';

  @override
  String get hivesAddBulk => 'Many at once';

  @override
  String get hivesAddBulkHint => 'e.g. 20 hives starting at 101';

  @override
  String hivesInactiveTitle(int count) {
    return 'Not active ($count)';
  }

  @override
  String get hivesLoadError => 'Couldn\'t read the hives.';

  @override
  String hiveLabel(String number) {
    return 'Hive $number';
  }

  @override
  String hiveTypeAndSource(String type, String source) {
    return '$type · $source';
  }

  @override
  String get hiveTypeLangstroth => 'Langstroth';

  @override
  String get hiveTypeDadant => 'Dadant';

  @override
  String get hiveTypeLocal => 'Local';

  @override
  String get hiveTypeOther => 'Other';

  @override
  String get hiveStatusActive => 'Active';

  @override
  String get hiveStatusDead => 'Dead';

  @override
  String get hiveStatusMerged => 'Merged';

  @override
  String get hiveStatusSold => 'Sold';

  @override
  String get hiveStatusLost => 'Lost';

  @override
  String get hiveSourceSwarm => 'Swarm';

  @override
  String get hiveSourceSplit => 'Split';

  @override
  String get hiveSourcePurchase => 'Bought';

  @override
  String get hiveSourcePackage => 'Package bees';

  @override
  String get hiveFormNewTitle => 'New hive';

  @override
  String get hiveFormEditTitle => 'Edit hive';

  @override
  String get hiveFormNumber => 'Hive number';

  @override
  String get hiveFormNumberHint => 'e.g. 101';

  @override
  String get hiveFormType => 'Hive type';

  @override
  String get hiveFormStatus => 'Status';

  @override
  String get hiveFormSource => 'Source';

  @override
  String get hiveFormSave => 'Save';

  @override
  String get hiveBulkTitle => 'Create many hives';

  @override
  String get hiveBulkCount => 'How many hives';

  @override
  String get hiveBulkCountHint => 'e.g. 20';

  @override
  String hiveBulkCountTooMany(int max) {
    return 'At most $max at once';
  }

  @override
  String get hiveBulkStart => 'First number';

  @override
  String get hiveBulkStartHint => 'e.g. 101';

  @override
  String hiveBulkPreview(int count, String first, String last) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count hives will be created: $first to $last.',
      one: 'Hive $first will be created.',
    );
    return '$_temp0';
  }

  @override
  String get hiveBulkSave => 'Create hives';

  @override
  String hiveBulkCreated(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count hives created',
      one: '1 hive created',
    );
    return '$_temp0';
  }

  @override
  String get hiveNotFoundTitle => 'Hive not found';

  @override
  String get hiveNotFoundMessage =>
      'It may have been deleted or not reached this device yet.';

  @override
  String get hiveEdit => 'Edit';

  @override
  String hiveCardApiary(String name) {
    return 'Apiary: $name';
  }

  @override
  String get hiveQueenTitle => 'Queen';

  @override
  String get hiveQueenPlaceholder =>
      'No queen recorded yet. Queen cards are coming soon.';

  @override
  String get hiveMove => 'Move to another apiary';

  @override
  String hiveMoveTitle(String number) {
    return 'Move hive $number to';
  }

  @override
  String get hiveMoveNoOtherApiary =>
      'There\'s no other apiary to move it to. Add one from the Apiaries tab first.';

  @override
  String hiveMoved(String number, String apiary) {
    return 'Hive $number moved to $apiary';
  }

  @override
  String get hiveChangeStatus => 'Change status';

  @override
  String hiveStatusSheetTitle(String number) {
    return 'New status for hive $number';
  }

  @override
  String hiveStatusConfirmTitle(String status, String number) {
    String _temp0 = intl.Intl.selectLogic(status, {
      'dead': 'Record hive $number as dead?',
      'merged': 'Record hive $number as merged?',
      'sold': 'Record hive $number as sold?',
      'other': 'Record hive $number as lost?',
    });
    return '$_temp0';
  }

  @override
  String get hiveStatusConfirmMessage =>
      'It will no longer count among the apiary\'s active hives. You can make it active again later.';

  @override
  String get hiveStatusConfirm => 'Yes, record';

  @override
  String hiveStatusChanged(String number, String status) {
    return 'Hive $number: $status';
  }

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
  String get actionUndo => 'Undo';

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
  String get onboardingApiaryTitle => 'Add your first apiary';

  @override
  String get onboardingApiaryMessage =>
      'An apiary is where your hives stand. Saving it needs no internet.';

  @override
  String get onboardingApiarySave => 'Save apiary';

  @override
  String get onboardingApiarySkip => 'Skip for now';

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
