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
  String get settingsCountry => 'Country';

  @override
  String get settingsCountryTemporaryNote =>
      'Chosen here for now; it will later come from your business profile.';

  @override
  String settingsCountryOption(String countryCode, String currencyCode) {
    return '$countryCode · $currencyCode';
  }

  @override
  String get settingsCountryPickerTitle => 'Choose country';

  @override
  String get settingsColorMode => 'Theme';

  @override
  String get settingsColorModeLight => 'Light';

  @override
  String get settingsColorModeDark => 'Dark';

  @override
  String get settingsColorModeSun => 'Sun';

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
