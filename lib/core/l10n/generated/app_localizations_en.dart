// ignore: unused_import
import 'package:intl/intl.dart' as intl;

import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'Mobil Arıcılık';

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
