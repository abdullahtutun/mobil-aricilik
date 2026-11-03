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
  String get todayEmptyTitle => 'Start by adding your apiary';

  @override
  String get todayEmptyMessage =>
      'Three steps and you\'re ready: add your apiary, create your hives, do your first inspection.';

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
  String get apiariesViewList => 'List';

  @override
  String get apiariesViewMap => 'Map';

  @override
  String get apiariesMapOfflineTitle => 'Map unavailable';

  @override
  String get apiariesMapOfflineMessage =>
      'The map needs internet. Your apiaries are listed below.';

  @override
  String get apiariesMapNoLocation =>
      'No apiary has a location yet. Edit an apiary at its site to take the location from GPS.';

  @override
  String get apiariesMapAttribution =>
      '© OpenFreeMap © OpenMapTiles © OpenStreetMap contributors';

  @override
  String apiaryMapPinLabel(String name, String hives) {
    return '$name, $hives';
  }

  @override
  String apiaryMapPinAttention(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count hives need attention',
      one: '1 hive needs attention',
    );
    return '$_temp0';
  }

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
  String get hiveSortWeakestFirst => 'Weakest first';

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
  String hiveQueenStripTitle(String queen) {
    return 'Queen · $queen';
  }

  @override
  String hiveStrengthBadge(String level, int strength) {
    return '$level · $strength/5';
  }

  @override
  String get hiveStrengthWeak => 'Weak';

  @override
  String get hiveStrengthMedium => 'Medium';

  @override
  String get hiveStrengthStrong => 'Strong';

  @override
  String get hiveStrengthNone => 'No strength score yet';

  @override
  String get hiveTimelineTitle => 'History';

  @override
  String get timelineInspection => 'Inspection';

  @override
  String get timelineAdded => 'Added to apiary';

  @override
  String get timelineMoved => 'Moved';

  @override
  String timelineMoveRoute(String from, String to) {
    return '$from → $to';
  }

  @override
  String get timelineUnknownApiary => 'Unknown apiary';

  @override
  String timelineField(String label, String value) {
    return '$label: $value';
  }

  @override
  String timelineBeeFrames(int count) {
    return '$count with bees';
  }

  @override
  String timelineBroodFrames(int count) {
    return '$count with brood';
  }

  @override
  String timelineHoneyFrames(int count) {
    return '$count with honey';
  }

  @override
  String get timelineActions => 'Done';

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
  String get scanTitle => 'Scan';

  @override
  String get scanLongPressHint => 'open the quick record menu';

  @override
  String get scanHint => 'Fit the code on the hive label inside the frame.';

  @override
  String get scanAgain => 'Scan again';

  @override
  String get cameraErrorTitle => 'Couldn\'t open the camera';

  @override
  String get cameraErrorPermissionDenied =>
      'Camera permission wasn\'t given. To scan labels, allow the camera for this app in Settings.';

  @override
  String get cameraErrorUnsupported =>
      'This device has no camera that can scan.';

  @override
  String get cameraErrorUnknown => 'Close this screen and try again.';

  @override
  String get labelUnknownTitle => 'This code isn\'t linked to a hive';

  @override
  String get labelUnknownMessage =>
      'It isn\'t a Mobil Arıcı label, or it hasn\'t been assigned to a hive yet. If it\'s on a hive, assign it; scanning it will then open the hive card.';

  @override
  String get labelUnknownOwnTitle => 'This label\'s hive wasn\'t found';

  @override
  String get labelUnknownOwnMessage =>
      'The hive may have been deleted or not reached this phone yet. You can also assign the label to another hive.';

  @override
  String labelCode(String code) {
    return 'Code: $code';
  }

  @override
  String get labelAssign => 'Assign to a hive';

  @override
  String get labelAssignTitle => 'Assign label to a hive';

  @override
  String get labelAssignMessage =>
      'Pick the hive the label is on. Scanning the label will then open that hive\'s card.';

  @override
  String get labelAssignSearch => 'Hive number';

  @override
  String get labelAssignNoMatch => 'No hive matches your search.';

  @override
  String get labelAssignNoHives =>
      'No hives yet. Add hives from the Apiaries tab first.';

  @override
  String get labelAssignHasOther => 'Has another label';

  @override
  String labelReplaceTitle(String number) {
    return 'Replace the label of hive $number?';
  }

  @override
  String get labelReplaceMessage =>
      'This hive already has a label. The new one replaces it; the old label will no longer open this hive.';

  @override
  String get labelReplaceConfirm => 'Yes, replace';

  @override
  String labelAssigned(String number) {
    return 'Label assigned: hive $number';
  }

  @override
  String get hiveLabelsTitle => 'Print labels';

  @override
  String get hiveLabelsMessage =>
      'Pick the hives to print labels for. An A4 page holds 24 labels (70 × 37 mm); print at 100% scale.';

  @override
  String get hiveLabelsNoHives =>
      'This apiary has no hives to print labels for.';

  @override
  String get hiveLabelsSelectAll => 'Select all';

  @override
  String get hiveLabelsSelectNone => 'Select none';

  @override
  String get hiveLabelsNoneSelected => 'No hives selected';

  @override
  String hiveLabelsCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count labels',
      one: '1 label',
    );
    return '$_temp0';
  }

  @override
  String hiveLabelsPages(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count pages',
      one: '1 page',
    );
    return '$_temp0';
  }

  @override
  String hiveLabelsSummary(String labels, String pages) {
    return '$labels · $pages';
  }

  @override
  String get hiveLabelsPreparing => 'Preparing the PDF…';

  @override
  String get hiveLabelsPrint => 'Print';

  @override
  String get hiveLabelsShare => 'Share PDF';

  @override
  String hiveLabelsDocumentName(String apiary) {
    return 'Hive labels - $apiary';
  }

  @override
  String get hiveLabelsError => 'Couldn\'t prepare the PDF. Try again.';

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
  String get signInSendCode => 'Send code';

  @override
  String get signInSending => 'Sending…';

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
  String get onboardingCountrySearch => 'Search countries';

  @override
  String get onboardingCountrySuggested => 'Suggested for your device';

  @override
  String get onboardingCountryAll => 'All countries';

  @override
  String get onboardingCountryNoMatch => 'No country matches your search.';

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
  String get galleryStrengthDots => 'Strength dots';

  @override
  String get galleryTimelineTile => 'Timeline row';

  @override
  String get gallerySampleApiaryHill => 'Hilltop';

  @override
  String get gallerySampleApiaryPlain => 'Riverside';

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

  @override
  String get gallerySnackBar => 'Snackbar';

  @override
  String get galleryCriticalLockCard => 'Critical lock card';

  @override
  String get gallerySampleInspectionSaved => 'Inspection saved';

  @override
  String get gallerySampleWithdrawalTitle => 'In withdrawal period.';

  @override
  String get gallerySampleWithdrawalMessage =>
      'Don\'t add a honey super to this hive for 12 more days.';

  @override
  String get syncStatusSynced => 'Synced';

  @override
  String syncStatusPending(int count) {
    return '$count pending';
  }

  @override
  String get syncStatusError => 'Error';

  @override
  String syncStatusSemantics(String status) {
    return 'Sync: $status';
  }

  @override
  String get syncTitle => 'Sync';

  @override
  String get syncSyncedMessage =>
      'Every record on this phone has reached the server.';

  @override
  String syncPendingMessage(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count records are waiting to be sent.',
      one: '1 record is waiting to be sent.',
    );
    return '$_temp0';
  }

  @override
  String get syncProblemOffline =>
      'Couldn\'t reach the server. Sync will try again when you\'re back online.';

  @override
  String get syncProblemFailed =>
      'Sync couldn\'t finish. Try again a little later.';

  @override
  String get syncProblemUpgrade =>
      'This version can no longer sync. Update the app.';

  @override
  String syncLastSynced(String time) {
    return 'Last synced $time';
  }

  @override
  String get syncNow => 'Sync now';

  @override
  String get syncRunning => 'Syncing…';

  @override
  String syncRejectedTitle(int count) {
    return 'Couldn\'t be sent ($count)';
  }

  @override
  String get syncRejectedMessage =>
      'The server didn\'t accept these records. Everything else keeps syncing.';

  @override
  String syncRejectedSubtitle(String reason, String date) {
    return '$reason · $date';
  }

  @override
  String get syncRejectionForbidden =>
      'You aren\'t allowed to change this record';

  @override
  String get syncRejectionConflict =>
      'Conflicts with another record (e.g. the same label)';

  @override
  String get syncRejectionMissingReference =>
      'A record it belongs to is missing on the server';

  @override
  String get syncRejectionUnsupported => 'This kind of record isn\'t synced';

  @override
  String get syncRejectionInvalid => 'The record has invalid data';

  @override
  String get syncRejectionUnknown => 'Unknown reason';

  @override
  String get syncTableOrganizations => 'Business';

  @override
  String get syncTableMemberships => 'Membership';

  @override
  String get syncTableApiaries => 'Apiary';

  @override
  String get syncTableQueens => 'Queen';

  @override
  String get syncTableHives => 'Hive';

  @override
  String get syncTableHiveStatusEvents => 'Hive status change';

  @override
  String get syncTableHiveLocationHistory => 'Hive move';

  @override
  String get initialSyncTitle => 'Downloading your records';

  @override
  String get initialSyncMessage =>
      'Your business\'s records are being downloaded to this phone. This happens only once; after that the app works without internet too.';

  @override
  String initialSyncRows(int count) {
    final intl.NumberFormat countNumberFormat =
        intl.NumberFormat.decimalPattern(localeName);
    final String countString = countNumberFormat.format(count);

    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$countString records downloaded',
      one: '1 record downloaded',
    );
    return '$_temp0';
  }

  @override
  String get initialSyncFailedTitle => 'Download couldn\'t finish';

  @override
  String get suggestedValue => 'From the last record';

  @override
  String get stepperNoValue => 'Not set';

  @override
  String get hiveStartInspection => 'Start inspection';

  @override
  String inspectionTitle(String number) {
    return 'Inspect hive $number';
  }

  @override
  String inspectionPrevious(String date) {
    return 'Last inspection $date';
  }

  @override
  String get inspectionFirst => 'First inspection';

  @override
  String get inspectionSuggestedLegend =>
      'Faded values are from the last inspection. Change what\'s different; the rest is saved as it is.';

  @override
  String get inspectionDraftSaved => 'Kept as a draft on this phone';

  @override
  String get inspectionRestart => 'Start over';

  @override
  String get inspectionQueen => 'Queen';

  @override
  String get queenStateSeen => 'Seen';

  @override
  String get queenStateEggs => 'Eggs seen';

  @override
  String get queenStateNone => 'None';

  @override
  String get inspectionFrames => 'Frames';

  @override
  String get inspectionBeeFrames => 'With bees';

  @override
  String get inspectionBroodFrames => 'With brood';

  @override
  String get inspectionHoneyFrames => 'With honey';

  @override
  String get inspectionTemperament => 'Temperament';

  @override
  String get temperamentCalm => 'Calm';

  @override
  String get temperamentNervous => 'Nervous';

  @override
  String get inspectionSwarmSigns => 'Swarm signs';

  @override
  String get inspectionQueenCells => 'Queen cells';

  @override
  String get queenCellsNone => 'None';

  @override
  String get queenCellsSwarm => 'Swarm';

  @override
  String get queenCellsSupersedure => 'Supersedure';

  @override
  String get queenCellsEmergency => 'Emergency';

  @override
  String get inspectionDisease => 'Disease suspected';

  @override
  String get inspectionAnswerNo => 'No';

  @override
  String get inspectionAnswerYes => 'Yes';

  @override
  String get inspectionActions => 'Done today';

  @override
  String get inspectionActionSuperAdded => 'Super added';

  @override
  String get inspectionActionSuperRemoved => 'Super removed';

  @override
  String get inspectionActionFramesAdded => 'Frames added';

  @override
  String get inspectionActionFoundationAdded => 'Foundation given';

  @override
  String get inspectionActionFed => 'Fed';

  @override
  String get inspectionActionExcluderFitted => 'Excluder fitted';

  @override
  String get inspectionActionEntranceReduced => 'Entrance reduced';

  @override
  String get inspectionActionPollenTrapFitted => 'Pollen trap fitted';

  @override
  String get inspectionSave => 'Save';

  @override
  String inspectionSaved(String number) {
    return 'Hive $number inspection saved';
  }

  @override
  String get inspectionRemindPrompt => 'Remind in';

  @override
  String inspectionRemindDays(int days) {
    String _temp0 = intl.Intl.pluralLogic(
      days,
      locale: localeName,
      other: '$days days',
      one: '1 day',
    );
    return '$_temp0';
  }

  @override
  String get inspectionLoadError => 'The inspection couldn\'t be opened';

  @override
  String get syncTableInspections => 'Inspection';

  @override
  String get signInTagline =>
      'Your apiary notebook, in your pocket. Works without internet.';

  @override
  String get signInEmailLabelLong => 'Your email address';

  @override
  String get signInEmailHelper =>
      'No password. We\'ll send a 6-digit code to your address.';

  @override
  String get signInEmailHint => 'name@example.com';

  @override
  String get signInCodeHeading => 'Enter the code from your email';

  @override
  String get signInPasteCode => 'Paste code';

  @override
  String get signInCodeSpamHint =>
      'Not there? Check your spam folder. After signing in once, the app opens without internet too.';

  @override
  String get signInChangeEmail => 'Change email';

  @override
  String get onboardingLanguageCountryTitle => 'Language and country';

  @override
  String get onboardingAppLanguage => 'App language';

  @override
  String get onboardingDeviceLanguage => 'Device language';

  @override
  String get onboardingCountryLabel => 'Country you keep bees in';

  @override
  String get onboardingCountryChoose => 'Choose a country';

  @override
  String onboardingRegionFeaturesTitle(String country) {
    return 'Turned on for $country';
  }

  @override
  String onboardingRegionDefaultsTitle(String country) {
    return 'Settings for $country';
  }

  @override
  String get onboardingRegionDefaultsMessage =>
      'Units and currency follow your country.';

  @override
  String get onboardingBusinessTitle => 'Tell us about your business';

  @override
  String get regionFeatureAks => 'AKS and business registration details';

  @override
  String get regionFeatureSubsidies => 'hive subsidy reminders';

  @override
  String get regionFeatureRegulations => 'regulation summaries';

  @override
  String get regionFeatureTrDrugList => 'licensed medicine list';

  @override
  String get regionFeatureTrFlora => 'Türkiye flora calendar';

  @override
  String get regionFeatureTrMigrationDocs => 'migratory beekeeping documents';

  @override
  String get unitKilogram => 'kg';

  @override
  String get unitPound => 'lb';

  @override
  String get unitCelsius => '°C';

  @override
  String get unitFahrenheit => '°F';

  @override
  String get hemisphereNorthern => 'Northern hemisphere';

  @override
  String get hemisphereSouthern => 'Southern hemisphere';

  @override
  String get relativeToday => 'today';

  @override
  String get relativeYesterday => 'yesterday';

  @override
  String relativeDaysAgo(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count days ago',
      one: '1 day ago',
    );
    return '$_temp0';
  }

  @override
  String apiariesCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count apiaries',
      one: '1 apiary',
    );
    return '$_temp0';
  }

  @override
  String apiariesSummary(String apiaries, String hives) {
    return '$apiaries · $hives';
  }

  @override
  String get apiaryHiveCountUnit => 'hives';

  @override
  String get hiveLayoutGridShort => 'Grid';

  @override
  String get hiveLayoutListShort => 'List';

  @override
  String apiaryDetailSubtitle(String hives, String visit) {
    return '$hives · $visit';
  }

  @override
  String get hiveCardKind => 'Hive';

  @override
  String get hiveLastInspection => 'Last inspection';

  @override
  String get hiveLastInspectionNone => 'None yet';

  @override
  String get hiveBulkPreviewTitle => 'Preview';

  @override
  String hiveBulkSaveCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Create $count hives',
      one: 'Create 1 hive',
    );
    return '$_temp0';
  }

  @override
  String get listEllipsis => '…';

  @override
  String get scanOfflineHint => 'No internet needed · vibrates when read';

  @override
  String get titleSeparator => ' · ';

  @override
  String get settingsGeneral => 'General';

  @override
  String get settingsGloveMode => 'Glove mode';

  @override
  String get settingsGloveModeHint => 'Every touch target grows one step.';

  @override
  String get settingsCountry => 'Country';

  @override
  String settingsCountryValue(String name, String code) {
    return '$name · $code';
  }

  @override
  String get moreSectionApiary => 'Apiary';

  @override
  String get moreSectionBusiness => 'Business';

  @override
  String get moreSectionHelp => 'Help';

  @override
  String get galleryFormFields => 'Form fields';

  @override
  String get galleryRadioCardGroup => 'Choice cards';

  @override
  String get gallerySegmentedTabs => 'View switcher';

  @override
  String get galleryListGroup => 'Grouped list';

  @override
  String get galleryNoteCard => 'Note card';

  @override
  String get gallerySummaryTile => 'Summary tile';

  @override
  String get galleryActionTile => 'Action tiles';

  @override
  String get galleryAppLogo => 'Logo and honeycomb';

  @override
  String get gallerySampleApiaryName => 'Apiary name';

  @override
  String get gallerySampleFirstNumber => 'First number';

  @override
  String get gallerySampleNoteHint =>
      'No password. We\'ll send a 6-digit code to your address.';

  @override
  String get gallerySampleGrid => 'Grid';

  @override
  String get gallerySampleList => 'List';

  @override
  String get gallerySampleMap => 'Map';

  @override
  String get gallerySampleInspections => 'Inspections';

  @override
  String get gallerySampleNoteTitle => 'Turned on for Türkiye';

  @override
  String get gallerySampleNoteMessage =>
      'AKS and business registration details, regulation summaries and the licensed medicine list.';

  @override
  String get gallerySampleLastInspectionValue => '3 days ago';

  @override
  String get gallerySampleFrames => '8 bee frames · 5 brood';

  @override
  String get gallerySampleActiveTreatment => 'Active treatment';

  @override
  String get gallerySampleDaysLeft => '12 days left';

  @override
  String get syncTableMedia => 'Photo or voice note';

  @override
  String get mediaTakePhoto => 'Take a photo';

  @override
  String get mediaRecordVoice => 'Record a voice note';

  @override
  String get mediaStopRecording => 'Stop recording';

  @override
  String mediaRecording(String duration) {
    return 'Recording · $duration';
  }

  @override
  String mediaPhotoAdded(String number) {
    return 'Photo added to hive $number';
  }

  @override
  String mediaVoiceAdded(String number) {
    return 'Voice note added to hive $number';
  }

  @override
  String get mediaCameraDenied =>
      'No camera permission. You can allow it in the phone\'s settings.';

  @override
  String get mediaMicrophoneDenied =>
      'No microphone permission. You can allow it in the phone\'s settings.';

  @override
  String get mediaCaptureFailed => 'Couldn\'t save. Try again.';

  @override
  String mediaPhotoCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count photos',
      one: '1 photo',
    );
    return '$_temp0';
  }

  @override
  String mediaVoiceCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count voice notes',
      one: '1 voice note',
    );
    return '$_temp0';
  }

  @override
  String inspectionMediaAttached(String items) {
    return 'Saved with the inspection: $items';
  }

  @override
  String get timelinePhoto => 'Photo';

  @override
  String get timelineVoiceNote => 'Voice note';

  @override
  String get mediaOpenPhoto => 'Open photo';

  @override
  String get mediaDownloadPhoto => 'Photo not on this phone. Tap to download.';

  @override
  String mediaPlay(String duration) {
    return 'Play · $duration';
  }

  @override
  String get mediaStopPlaying => 'Stop';

  @override
  String get mediaNotUploaded =>
      'Not uploaded yet. It arrives when the phone that took it is online.';

  @override
  String get mediaDownloadOffline =>
      'Couldn\'t download. Check your internet connection.';

  @override
  String get mediaDownloadFailed => 'Couldn\'t download.';

  @override
  String get mediaNotFound => 'Photo not found';

  @override
  String get settingsData => 'Data';

  @override
  String get settingsMediaWifiOnly => 'Upload photos on Wi‑Fi only';

  @override
  String get settingsMediaWifiOnlyHint =>
      'Photos and voice notes won\'t use mobile data.';

  @override
  String settingsPendingUploads(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count files waiting to upload',
      one: '1 file waiting to upload',
    );
    return '$_temp0';
  }

  @override
  String get hiveQueenNone => 'Not recorded';

  @override
  String get hiveQueenNoneHint => 'Tap to add a queen';

  @override
  String queenMarkColorName(String color) {
    String _temp0 = intl.Intl.selectLogic(color, {
      'white': 'White',
      'yellow': 'Yellow',
      'red': 'Red',
      'green': 'Green',
      'blue': 'Blue',
      'other': 'Unknown',
    });
    return '$_temp0';
  }

  @override
  String get queenYearUnknown => 'Year unknown';

  @override
  String get queenUnmarked => 'Unmarked';

  @override
  String queenAge(int age) {
    String _temp0 = intl.Intl.pluralLogic(
      age,
      locale: localeName,
      other: '$age years old',
      one: '1 year old',
      zero: 'Under a year old',
    );
    return '$_temp0';
  }

  @override
  String get queenSourceOwnRearing => 'Own rearing';

  @override
  String get queenSourcePurchased => 'Purchased';

  @override
  String get queenSourceCertifiedBreeder => 'Certified breeder';

  @override
  String get queenSource => 'Source';

  @override
  String get queenMother => 'Mother queen';

  @override
  String get queenMotherUnknown => 'Unknown';

  @override
  String get queenBreed => 'Breed';

  @override
  String get queenBreedHint => 'E.g. Caucasian';

  @override
  String get queenBreedLine => 'Line';

  @override
  String get queenBreedLineHint => 'E.g. Artvin';

  @override
  String get queenWing => 'Wing';

  @override
  String get queenWingClipped => 'Clipped';

  @override
  String get queenWingIntact => 'Not clipped';

  @override
  String get queenYear => 'Year';

  @override
  String get queenYearHelper => 'Year hatched or bought';

  @override
  String get queenMark => 'Mark color';

  @override
  String queenMarkSuggestion(String year, String color) {
    return '$year color: $color';
  }

  @override
  String get queenUnknown => 'Not entered';

  @override
  String get queenEdit => 'Edit queen';

  @override
  String get queenReplace => 'Replace queen';

  @override
  String get queenGive => 'Add queen';

  @override
  String get queenNoneTitle => 'No queen recorded';

  @override
  String get queenNoneMessage =>
      'Record the queen you gave this hive; her year, color and lineage show here.';

  @override
  String queenFormNewTitle(String number) {
    return 'New queen · Hive $number';
  }

  @override
  String get queenFormEditTitle => 'Edit queen';

  @override
  String get queenFormSave => 'Save';

  @override
  String queenGiven(String number) {
    return 'Hive $number has a new queen';
  }

  @override
  String get oldQueensTitle => 'Old queens';

  @override
  String oldQueensIntro(int age) {
    String _temp0 = intl.Intl.pluralLogic(
      age,
      locale: localeName,
      other:
          'Queens in active hives that are $age or older. Plan to replace them.',
    );
    return '$_temp0';
  }

  @override
  String get oldQueensEmptyTitle => 'No old queens';

  @override
  String oldQueensEmptyMessage(int age) {
    String _temp0 = intl.Intl.pluralLogic(
      age,
      locale: localeName,
      other:
          'Queens in active hives are younger than $age, or have no year entered.',
    );
    return '$_temp0';
  }

  @override
  String get syncTableMiteCounts => 'Varroa count';

  @override
  String get varroaMethodSugarRoll => 'Sugar roll';

  @override
  String get varroaMethodAlcoholWash => 'Alcohol wash';

  @override
  String get varroaMethodStickyBoard => 'Sticky board';

  @override
  String varroaFormTitle(String number) {
    return 'Varroa · Hive $number';
  }

  @override
  String get varroaMethod => 'Method';

  @override
  String get varroaSampleBees => 'Sample bees';

  @override
  String get varroaBoardDays => 'Days on board';

  @override
  String get varroaMites => 'Mites counted';

  @override
  String get varroaBoardMites => 'Mites dropped';

  @override
  String get varroaSave => 'Save';

  @override
  String varroaSaved(String number) {
    return 'Varroa count saved for hive $number';
  }

  @override
  String varroaPercent(double value) {
    final intl.NumberFormat valueNumberFormat =
        intl.NumberFormat.decimalPatternDigits(
          locale: localeName,
          decimalDigits: 1,
        );
    final String valueString = valueNumberFormat.format(value);

    return '$valueString%';
  }

  @override
  String varroaPerDay(double value) {
    final intl.NumberFormat valueNumberFormat =
        intl.NumberFormat.decimalPatternDigits(
          locale: localeName,
          decimalDigits: 1,
        );
    final String valueString = valueNumberFormat.format(value);

    return '$valueString mites/day';
  }

  @override
  String get varroaInfestation => 'Infestation';

  @override
  String get varroaDailyDrop => 'Daily drop';

  @override
  String get varroaReached => 'At threshold · plan treatment';

  @override
  String get varroaBelow => 'Below threshold';

  @override
  String varroaThresholdNote(String threshold) {
    return 'Threshold $threshold (from Settings).';
  }

  @override
  String get hiveVarroa => 'Varroa';

  @override
  String get hiveVarroaNone => 'No count yet';

  @override
  String get hiveVarroaReached => 'Threshold reached';

  @override
  String get hiveVarroaCount => 'Count varroa';

  @override
  String varroaChartTitle(String apiary) {
    return '$apiary · recent counts';
  }

  @override
  String varroaChartThreshold(String threshold) {
    return 'threshold $threshold';
  }

  @override
  String get varroaChartEmpty =>
      'No sugar roll or alcohol wash counts yet. Add one from a hive card.';

  @override
  String varroaChartBar(String day, String value) {
    return '$day: $value';
  }

  @override
  String varroaChartSemantics(String threshold, String bars) {
    return 'Average infestation per day, threshold $threshold: $bars';
  }

  @override
  String get settingsVarroa => 'Varroa';

  @override
  String get settingsVarroaPercent => 'Infestation threshold';

  @override
  String get settingsVarroaPerDay => 'Sticky board threshold';

  @override
  String get settingsVarroaHint =>
      'A warning is shown when a count reaches the threshold. Saved on this phone only.';

  @override
  String get syncTableRefDrugs => 'Drug list';

  @override
  String get syncTableDrugs => 'Drug';

  @override
  String get syncTableTreatments => 'Treatment';

  @override
  String get syncTableFeedings => 'Feeding';

  @override
  String get drugIngredientAmitraz => 'Amitraz';

  @override
  String get drugIngredientOxalicAcid => 'Oxalic acid';

  @override
  String get drugIngredientFormicAcid => 'Formic acid';

  @override
  String get drugIngredientThymol => 'Thymol';

  @override
  String get drugIngredientFlumethrin => 'Flumethrin';

  @override
  String get drugIngredientTauFluvalinate => 'Tau-fluvalinate';

  @override
  String get drugIngredientCoumaphos => 'Coumaphos';

  @override
  String get drugIngredientLacticAcid => 'Lactic acid';

  @override
  String get drugIngredientOther => 'Other';

  @override
  String get drugUnitStrip => 'strip';

  @override
  String get drugUnitMl => 'ml';

  @override
  String get drugUnitG => 'g';

  @override
  String get drugUnitDose => 'dose';

  @override
  String get hiveTreat => 'Apply treatment';

  @override
  String get treatmentFormTitle => 'Treatment';

  @override
  String treatmentScopeHive(String number) {
    return 'Hive $number';
  }

  @override
  String treatmentScopeApiary(int count) {
    return 'Whole apiary · $count';
  }

  @override
  String get treatmentChooseDrug => 'Choose drug';

  @override
  String get treatmentChangeDrug => 'Change';

  @override
  String treatmentDrugIngredient(String ingredient) {
    return 'Active ingredient: $ingredient';
  }

  @override
  String treatmentDrugLicense(String number) {
    return 'licence $number';
  }

  @override
  String get treatmentDrugCustom => 'your drug';

  @override
  String get treatmentAddDrug => 'Add a new drug';

  @override
  String get drugInfoOpen => 'Drug information';

  @override
  String get drugInfoSourceTitle =>
      'Source: Ministry of Agriculture and Forestry of Türkiye';

  @override
  String get drugInfoSourceMessage =>
      'This is taken from the Ministry-approved product information and is shown in Turkish as published. Read the product label before use; ask a veterinarian if unsure.';

  @override
  String get drugInfoActiveIngredient => 'Active ingredient';

  @override
  String get drugInfoIndications => 'Used for';

  @override
  String get drugInfoUsage => 'Use and frequency';

  @override
  String get drugInfoUsageMethod => 'How to apply';

  @override
  String get drugInfoUsageMethodAndDose => 'How to apply and dose';

  @override
  String get drugInfoUsageDiagnosis => 'For diagnosis';

  @override
  String get drugInfoUsageDose => 'Dose';

  @override
  String get drugInfoUsageFrequency => 'Frequency';

  @override
  String get drugInfoUsageDuration => 'Duration';

  @override
  String get drugInfoUsageOther => 'Note';

  @override
  String get drugInfoSuitablePeriods => 'Suitable periods';

  @override
  String get drugInfoAvoidPeriods => 'Do not use';

  @override
  String get drugInfoWithdrawal => 'Withdrawal period';

  @override
  String get drugInfoWarnings => 'Warnings';

  @override
  String get drugInfoClose => 'Close';

  @override
  String get treatmentBatchNo => 'Batch no';

  @override
  String get treatmentStartedOn => 'Start';

  @override
  String treatmentDose(String unit) {
    return 'Dose per hive ($unit)';
  }

  @override
  String treatmentDoseTotal(String total, String unit) {
    return 'Total $total $unit';
  }

  @override
  String get treatmentWithdrawalDays => 'Withdrawal period (days)';

  @override
  String get treatmentRemoval => 'Removal';

  @override
  String get treatmentRemovalNone => 'None';

  @override
  String get treatmentRemovalChange => 'Reminder that morning; tap to change';

  @override
  String get treatmentRemovalSingle => 'Single application; tap to set';

  @override
  String get treatmentRemovalClear => 'No removal (single application)';

  @override
  String get treatmentNoSuper => 'No honey super';

  @override
  String treatmentNoSuperUntil(String date) {
    return 'Until $date';
  }

  @override
  String treatmentNoSuperAfterRemoval(int days) {
    String _temp0 = intl.Intl.pluralLogic(
      days,
      locale: localeName,
      other: 'removal + $days days withdrawal',
      one: 'removal + 1 day withdrawal',
      zero: 'no withdrawal after removal',
    );
    return '$_temp0';
  }

  @override
  String treatmentNoSuperAfterStart(int days) {
    String _temp0 = intl.Intl.pluralLogic(
      days,
      locale: localeName,
      other: 'start + $days days withdrawal',
      one: 'start + 1 day withdrawal',
      zero: 'no withdrawal',
    );
    return '$_temp0';
  }

  @override
  String treatmentSave(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Save to $count hives',
      one: 'Save',
    );
    return '$_temp0';
  }

  @override
  String treatmentSaved(String number) {
    return 'Treatment saved for hive $number';
  }

  @override
  String treatmentSavedMany(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Treatment saved for $count hives',
      one: 'Treatment saved for 1 hive',
    );
    return '$_temp0';
  }

  @override
  String get drugFormTitle => 'New drug';

  @override
  String get drugName => 'Name';

  @override
  String get drugActiveIngredient => 'Active ingredient';

  @override
  String get drugDoseUnit => 'Dose unit';

  @override
  String get drugWithdrawalDays => 'Withdrawal period on the label (days)';

  @override
  String get drugSave => 'Add drug';

  @override
  String get withdrawalLockTitle => 'In withdrawal period.';

  @override
  String withdrawalLockMessage(String number, String product, String date) {
    return 'Hive $number is being treated with $product. No honey super should be added before $date; honey from this period may carry drug residue.';
  }

  @override
  String get withdrawalDaysLeft => 'Remaining';

  @override
  String withdrawalDays(int days) {
    String _temp0 = intl.Intl.pluralLogic(
      days,
      locale: localeName,
      other: '$days days',
      one: '1 day',
    );
    return '$_temp0';
  }

  @override
  String get withdrawalApplied => 'Applied';

  @override
  String get withdrawalReasonPrompt => 'To save anyway, choose a reason';

  @override
  String get withdrawalReasonRemovedEarly => 'Drug removed early';

  @override
  String get withdrawalReasonNotForSale =>
      'Super won\'t be sold (own use/feed)';

  @override
  String get withdrawalCancel => 'Cancel, don\'t add super';

  @override
  String get withdrawalProceed => 'Save anyway';

  @override
  String inspectionWithdrawalOverride(String reason) {
    return 'Honey super added during the withdrawal period: $reason';
  }

  @override
  String timelineTreatment(String product) {
    return 'Treatment · $product';
  }

  @override
  String timelineTreatmentBatch(String batch) {
    return 'Batch $batch';
  }

  @override
  String treatmentDoseValue(String dose, String unit) {
    return '$dose $unit';
  }

  @override
  String timelineTreatmentRemoval(String date) {
    return 'removal $date';
  }

  @override
  String timelineTreatmentWithdrawal(int days) {
    String _temp0 = intl.Intl.pluralLogic(
      days,
      locale: localeName,
      other: '$days days withdrawal',
      one: '1 day withdrawal',
    );
    return '$_temp0';
  }

  @override
  String get hiveActiveTreatment => 'Active treatment';

  @override
  String get hiveActiveTreatmentNone => 'None';

  @override
  String hiveActiveTreatmentLeft(int days) {
    String _temp0 = intl.Intl.pluralLogic(
      days,
      locale: localeName,
      other: '$days days left',
      one: '1 day left',
    );
    return '$_temp0';
  }

  @override
  String hiveActiveTreatmentDetail(String ingredient) {
    return '$ingredient · no honey super';
  }

  @override
  String get treatmentRotationTitle => 'Same active ingredient.';

  @override
  String treatmentRotationMessage(int count, String ingredient) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other:
          'The last $count treatments in this apiary were also $ingredient. Consider a different active ingredient to limit resistance.',
    );
    return '$_temp0';
  }

  @override
  String get treatmentPrescriptionAdd => 'Add prescription / invoice photo';

  @override
  String get treatmentPrescriptionAdded => 'Prescription photo added';

  @override
  String get treatmentPrescriptionRemove => 'Remove';

  @override
  String get reminderChannelName => 'Reminders';

  @override
  String get treatmentReminderDenied =>
      'Notifications are off; no removal reminder was set.';

  @override
  String get hiveFeed => 'Feed';

  @override
  String get feedingFormTitle => 'Feeding';

  @override
  String feedingScopeHive(String number) {
    return 'Hive $number';
  }

  @override
  String feedingScopeApiary(int count) {
    return 'Whole apiary · $count';
  }

  @override
  String get feedingKind => 'Type';

  @override
  String get feedingKindSyrup1to1 => 'Syrup 1:1 · stimulative';

  @override
  String get feedingKindSyrup2to1 => 'Syrup 2:1 · winter';

  @override
  String get feedingKindBeeCake => 'Bee cake';

  @override
  String get feedingKindPollenSubstitute => 'Pollen substitute';

  @override
  String feedingAmount(String unit) {
    return 'Per hive ($unit)';
  }

  @override
  String get feedingSuperHiveTitle => 'This hive has a honey super.';

  @override
  String get feedingSuperHiveMessage => 'Syrup may get into the honey.';

  @override
  String feedingSuperSkippedTitle(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count hives have a honey super',
      one: '1 hive has a honey super',
    );
    return '$_temp0';
  }

  @override
  String feedingSuperSkippedMessage(String numbers) {
    return '($numbers). Left out so the syrup doesn\'t get into the honey.';
  }

  @override
  String get feedingPrepare => 'To prepare';

  @override
  String feedingPrepareCount(int count, String amount, String unit) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count hives × $amount $unit',
      one: '1 hive × $amount $unit',
    );
    return '$_temp0';
  }

  @override
  String feedingTotalSyrup(String amount, String unit) {
    return '$amount $unit syrup';
  }

  @override
  String feedingTotalBeeCake(String amount, String unit) {
    return '$amount $unit bee cake';
  }

  @override
  String feedingTotalPollenSubstitute(String amount, String unit) {
    return '$amount $unit pollen substitute';
  }

  @override
  String get feedingSugar => 'Sugar';

  @override
  String get feedingWater => 'Water';

  @override
  String feedingApprox(String amount, String unit) {
    return '≈ $amount $unit';
  }

  @override
  String feedingSave(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Save to $count hives',
      one: 'Save',
      zero: 'No hive to feed',
    );
    return '$_temp0';
  }

  @override
  String feedingSaved(String number) {
    return 'Feeding saved for hive $number';
  }

  @override
  String feedingSavedMany(int count) {
    return 'Feeding saved for $count hives';
  }

  @override
  String get unitLiter => 'L';

  @override
  String get unitGallon => 'gal';

  @override
  String get syncTableTasks => 'Task';

  @override
  String get tasksTabToday => 'Today';

  @override
  String get tasksTabWeek => 'This week';

  @override
  String get tasksTabApiary => 'By apiary';

  @override
  String get tasksAdd => 'Add task';

  @override
  String tasksOverdue(int count) {
    return 'Overdue · $count';
  }

  @override
  String tasksDayGroup(String day, int count) {
    return '$day · $count';
  }

  @override
  String get tasksToday => 'Today';

  @override
  String get tasksTomorrow => 'Tomorrow';

  @override
  String get tasksNoApiary => 'No apiary';

  @override
  String tasksApiaryGroup(String apiary, int count) {
    return '$apiary · $count';
  }

  @override
  String get tasksEmptyTodayTitle => 'Nothing to do today';

  @override
  String get tasksEmptyWeekTitle => 'No tasks this week';

  @override
  String get tasksEmptyAddHint => 'Add a new task with + at the top right.';

  @override
  String get tasksLoadError => 'Couldn\'t load tasks.';

  @override
  String tasksWeekDaySemantics(String day, int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count tasks',
      one: '1 task',
      zero: 'no tasks',
    );
    return '$day, $_temp0';
  }

  @override
  String taskOverdueDays(int days) {
    String _temp0 = intl.Intl.pluralLogic(
      days,
      locale: localeName,
      other: '$days days overdue',
      one: '1 day overdue',
    );
    return '$_temp0';
  }

  @override
  String get taskSourceInspection => 'from inspection';

  @override
  String get taskSourceTreatment => 'treatment';

  @override
  String taskInspectionTitle(String number) {
    return 'Hive $number · check again';
  }

  @override
  String get taskInspectionTitleNoHive => 'Check again';

  @override
  String taskTreatmentTitle(String number) {
    return 'Hive $number · remove strips';
  }

  @override
  String get taskTreatmentTitleApiary => 'Remove strips';

  @override
  String get taskReminderBody => 'Your task is due.';

  @override
  String get taskAssigneeMe => 'Me';

  @override
  String taskAssignedTo(String name) {
    return 'Assigned to $name';
  }

  @override
  String taskMemberNumbered(String role, int index) {
    return '$role $index';
  }

  @override
  String get roleOwner => 'Owner';

  @override
  String get rolePartner => 'Partner';

  @override
  String get roleWorker => 'Worker';

  @override
  String get roleViewer => 'Viewer';

  @override
  String taskCompleteAction(String title) {
    return 'Complete: $title';
  }

  @override
  String get taskCompleted => 'Task completed';

  @override
  String get taskFormNewTitle => 'New task';

  @override
  String get taskFormEditTitle => 'Edit task';

  @override
  String get taskFormName => 'Task';

  @override
  String get taskFormNameHint => 'e.g. Visit the upland apiary';

  @override
  String get taskFormDue => 'Due';

  @override
  String get taskFormPickDate => 'Other day';

  @override
  String get taskFormTime => 'Time';

  @override
  String get taskFormApiary => 'Apiary';

  @override
  String get taskFormHive => 'Hive';

  @override
  String get taskFormNone => 'None';

  @override
  String get taskFormChooseApiary => 'Choose apiary';

  @override
  String get taskFormChooseHive => 'Choose hive';

  @override
  String get taskFormAssignee => 'Assigned to';

  @override
  String get taskFormUnassigned => 'Unassigned';

  @override
  String get taskFormCompleted => 'Done';

  @override
  String get taskFormSave => 'Save';

  @override
  String get taskFormDelete => 'Delete task';

  @override
  String get taskDeleteTitle => 'Delete this task?';

  @override
  String get taskDeleteMessage => 'The task is removed from every phone.';

  @override
  String get taskDeleteConfirm => 'Delete';

  @override
  String get taskSaved => 'Task saved';

  @override
  String get taskDeleted => 'Task deleted';

  @override
  String get taskNotFound => 'Task not found; it may have been deleted.';

  @override
  String get taskReminderDenied =>
      'Notifications are off; the reminder won\'t ring.';

  @override
  String get exactAlarmTitle => 'Ring reminders right on time?';

  @override
  String get exactAlarmMessage =>
      'Android may delay notifications by a few minutes to save battery. Allow Mobil Arıcı in the setting that opens and task reminders ring right on time. No internet needed.';

  @override
  String get exactAlarmConfirm => 'Open setting';

  @override
  String get settingsReminders => 'Reminders';

  @override
  String get settingsExactAlarms => 'Ring right on time';

  @override
  String get settingsExactAlarmsOn => 'On';

  @override
  String get settingsExactAlarmsOff => 'Off · may be a few minutes late';

  @override
  String weatherTemperature(String value) {
    return '$value°';
  }

  @override
  String weatherForecastAsOf(String time) {
    return 'Forecast as of $time';
  }

  @override
  String weatherWind(String speed) {
    return 'Wind $speed';
  }

  @override
  String weatherSpeed(String value, String unit) {
    return '$value $unit';
  }

  @override
  String get unitKmh => 'km/h';

  @override
  String get unitMph => 'mph';

  @override
  String weatherPercent(String value) {
    return '$value%';
  }

  @override
  String weatherTemperatureRange(String max, String min) {
    return '$max / $min';
  }

  @override
  String get hiveOpeningRain => 'Rain';

  @override
  String get hiveOpeningWind => 'Windy';

  @override
  String get hiveOpeningCold => 'Cold';

  @override
  String get hiveOpeningDaySuitable => 'Open';

  @override
  String get weatherConditionSunny => 'Sunny';

  @override
  String get weatherConditionPartlyCloudy => 'Partly cloudy';

  @override
  String get weatherConditionCloudy => 'Cloudy';

  @override
  String get weatherConditionRainy => 'Rainy';

  @override
  String get weatherConditionWindy => 'Windy';

  @override
  String get weatherConditionOther => 'Snow, fog or storm';

  @override
  String weatherFeelsLike(String condition, String value) {
    return '$condition · feels like $value';
  }

  @override
  String get weatherWindLabel => 'Wind';

  @override
  String get weatherHumidityLabel => 'Humidity';

  @override
  String get weatherPrecipitationLabel => 'Rain';

  @override
  String get weatherScreenTitle => 'Apiary weather';

  @override
  String weatherScreenSubtitle(String place, String days) {
    return '$place · $days-day forecast';
  }

  @override
  String weatherScreenSubtitleNoPlace(String days) {
    return '$days-day forecast';
  }

  @override
  String weatherUpdatedAt(String time) {
    return 'Updated $time';
  }

  @override
  String get weatherNow => 'Now';

  @override
  String get weatherToday => 'Today';

  @override
  String get weatherColumnDay => 'Day';

  @override
  String get weatherColumnTemperature => 'Temp';

  @override
  String get weatherColumnPrecipitation => 'Rain';

  @override
  String get weatherColumnHive => 'Hives';

  @override
  String get weatherTodaySuitable => 'Good day to open hives';

  @override
  String get weatherTodayRain => 'Rain today; not a day to open hives';

  @override
  String get weatherTodayWind => 'Windy today; not a day to open hives';

  @override
  String get weatherTodayCold => 'Cold today; not a day to open hives';

  @override
  String weatherDayRange(String from, String to) {
    return '$from–$to';
  }

  @override
  String weatherPlanRain(String days) {
    return 'Rain on $days.';
  }

  @override
  String weatherPlanWind(String days) {
    return 'Windy on $days.';
  }

  @override
  String weatherPlanMove(String weekday) {
    String _temp0 = intl.Intl.selectLogic(weekday, {
      'monday': 'Move inspections to Monday.',
      'tuesday': 'Move inspections to Tuesday.',
      'wednesday': 'Move inspections to Wednesday.',
      'thursday': 'Move inspections to Thursday.',
      'friday': 'Move inspections to Friday.',
      'saturday': 'Move inspections to Saturday.',
      'other': 'Move inspections to Sunday.',
    });
    return '$_temp0';
  }

  @override
  String get weatherPlanAction => 'Plan';

  @override
  String weatherPlanTaskTitle(String apiary) {
    return 'Inspect $apiary';
  }

  @override
  String weatherThresholdsHint(
    String temperature,
    String wind,
    String precipitation,
  ) {
    return 'Good to open: above $temperature, wind under $wind, rain chance under $precipitation. You can change the thresholds in Settings.';
  }

  @override
  String get weatherEmptyTitle => 'No forecast yet';

  @override
  String get weatherEmptyMessage =>
      'This apiary\'s forecast hasn\'t been fetched yet. Refresh once you\'re online.';

  @override
  String get weatherNoLocationMessage =>
      'This apiary has no location. Add one to get a forecast.';

  @override
  String get weatherRefresh => 'Refresh';

  @override
  String get weatherRefreshFailed =>
      'Couldn\'t get the forecast. Check your internet connection.';

  @override
  String get weatherApiaryNotFound => 'Apiary not found';

  @override
  String get weatherAttributionPrefix => 'Powered by ';

  @override
  String get weatherAttributionLink => 'WeatherAPI.com';

  @override
  String get settingsHiveOpening => 'Hive opening thresholds';

  @override
  String get settingsHiveOpeningTemperature => 'Temperature';

  @override
  String settingsHiveOpeningTemperatureValue(String value) {
    return 'above $value';
  }

  @override
  String get settingsHiveOpeningWind => 'Wind';

  @override
  String get settingsHiveOpeningPrecipitation => 'Rain chance';

  @override
  String settingsHiveOpeningBelow(String value) {
    return 'under $value';
  }

  @override
  String get settingsHiveOpeningHint =>
      'The weather screen and Today cards say \"Open\" by these thresholds. Saved on this phone only.';

  @override
  String get hiveOpeningSuitable => 'Good to open';

  @override
  String get todayGreetingMorning => 'Good morning';

  @override
  String get todayGreetingAfternoon => 'Good afternoon';

  @override
  String get todayGreetingEvening => 'Good evening';

  @override
  String get todayAttentionTitle => 'Needs attention';

  @override
  String todayAttentionHiveCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count hives',
      one: '1 hive',
    );
    return '$_temp0';
  }

  @override
  String get todayAttentionNone => 'No hives need attention';

  @override
  String get todayTasksTitle => 'Today';

  @override
  String todayTasksCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count tasks',
      one: '1 task',
    );
    return '$_temp0';
  }

  @override
  String todayTasksApiaryCount(String apiary, int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count tasks',
      one: '1 task',
    );
    return '$apiary · $_temp0';
  }

  @override
  String todaySetupProgress(int done, int total) {
    return 'Setup $done/$total';
  }

  @override
  String get setupStepApiary => 'Add your apiary';

  @override
  String get setupStepHives => 'Create your hives';

  @override
  String get setupStepInspection => 'Do your first inspection';

  @override
  String setupStepDone(String step) {
    return '$step: done';
  }

  @override
  String get attentionQueenless => 'Queenless';

  @override
  String get attentionWeak => 'Weak';

  @override
  String get attentionSwarming => 'Swarm signs';

  @override
  String get attentionTreatmentRemoval => 'Treatment to remove';

  @override
  String get attentionQueenlessTitle => 'Queenless hives';

  @override
  String get attentionWeakTitle => 'Weak hives';

  @override
  String get attentionSwarmingTitle => 'Hives with swarm signs';

  @override
  String get attentionTreatmentRemovalTitle => 'Treatments to remove';

  @override
  String get attentionQueenlessIntro =>
      'Active hives whose last inspection found no queen and no eggs.';

  @override
  String attentionWeakIntro(int max) {
    return 'Active hives with strength $max/5 or lower at their last inspection.';
  }

  @override
  String get attentionSwarmingIntro =>
      'Active hives whose last inspection showed swarm signs or swarm cells.';

  @override
  String get attentionTreatmentRemovalIntro =>
      'Hives whose strip removal is due and the task isn\'t done yet.';

  @override
  String get attentionEmpty => 'No hives in this group.';

  @override
  String attentionLastInspection(String date) {
    return 'Last inspection: $date';
  }

  @override
  String attentionRemovalDue(String date) {
    return 'Removal due: $date';
  }

  @override
  String get syncTableHarvests => 'Harvest';

  @override
  String get syncTableHarvestHives => 'Harvested hive';

  @override
  String withdrawalLockHarvestMessage(
    String number,
    String product,
    String date,
  ) {
    return 'Hive $number is being treated with $product. It shouldn\'t be harvested before $date; honey from this period may carry drug residue.';
  }

  @override
  String get withdrawalReasonNotForSaleHarvest =>
      'Honey won\'t be sold (own use/feed)';

  @override
  String get withdrawalHarvestCancel => 'Cancel, don\'t harvest';

  @override
  String get withdrawalHarvestProceed => 'Harvest anyway';

  @override
  String get apiaryHarvest => 'Harvest';

  @override
  String harvestFormTitle(String apiary) {
    return 'Harvest · $apiary';
  }

  @override
  String harvestSelectedCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count hives selected',
      one: '1 hive selected',
      zero: 'No hives selected',
    );
    return '$_temp0';
  }

  @override
  String harvestSelectedHint(String numbers) {
    return '$numbers · tap to change or scan to add';
  }

  @override
  String get harvestSelectedEmptyHint => 'Tap to pick hives or scan them';

  @override
  String get harvestScan => 'Scan';

  @override
  String harvestLockedTitle(String numbers) {
    return '$numbers in withdrawal period.';
  }

  @override
  String get harvestLockedMessage =>
      'Not harvested. To take one anyway, pick it in the hive list.';

  @override
  String get harvestDate => 'Date';

  @override
  String get harvestToday => 'Today';

  @override
  String get harvestYesterday => 'Yesterday';

  @override
  String get harvestPickDate => 'Other day';

  @override
  String get harvestHoneyKind => 'Honey type';

  @override
  String get honeyKindPine => 'Pine';

  @override
  String get honeyKindFlower => 'Flower';

  @override
  String get honeyKindChestnut => 'Chestnut';

  @override
  String get honeyKindCitrus => 'Citrus';

  @override
  String get honeyKindOther => 'Other';

  @override
  String get harvestUnit => 'Taken as';

  @override
  String get harvestUnitSuper => 'Supers';

  @override
  String get harvestUnitFrame => 'Frames';

  @override
  String get harvestTakenSupers => 'Supers taken';

  @override
  String get harvestTakenFrames => 'Frames taken';

  @override
  String harvestWeight(String unit) {
    return 'Extracted honey ($unit)';
  }

  @override
  String get harvestWeightInvalid => 'Enter a weight like 574 or 574.5';

  @override
  String harvestWeightTooLarge(String max, String unit) {
    return 'At most $max $unit';
  }

  @override
  String get harvestPerHive => 'Per hive';

  @override
  String harvestWeightValue(String value, String unit) {
    return '$value $unit';
  }

  @override
  String harvestSave(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Save harvest',
      zero: 'No hives to harvest',
    );
    return '$_temp0';
  }

  @override
  String harvestSaved(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Harvest saved for $count hives',
      one: 'Harvest saved for 1 hive',
    );
    return '$_temp0';
  }

  @override
  String get harvestHivesTitle => 'Hives to harvest';

  @override
  String get harvestSelectAll => 'Select all';

  @override
  String get harvestSelectNone => 'Select none';

  @override
  String harvestHiveLocked(int days) {
    String _temp0 = intl.Intl.pluralLogic(
      days,
      locale: localeName,
      other: '$days days',
      one: '1 day',
    );
    return 'Withdrawal · $_temp0 left';
  }

  @override
  String harvestHiveOverridden(String reason) {
    return 'Taken anyway: $reason';
  }

  @override
  String get harvestHivesDone => 'Done';

  @override
  String get harvestNoActiveHives => 'This apiary has no active hives.';

  @override
  String get harvestScanTitle => 'Scan for harvest';

  @override
  String harvestScanAdded(String number) {
    return 'Hive $number added';
  }

  @override
  String harvestScanAlready(String number) {
    return 'Hive $number is already selected';
  }

  @override
  String harvestScanOtherApiary(String number) {
    return 'Hive $number isn\'t in this apiary';
  }

  @override
  String harvestScanInactive(String number) {
    return 'Hive $number isn\'t active';
  }

  @override
  String get harvestScanUnknown => 'This label isn\'t linked to a hive';

  @override
  String harvestScanDone(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Done · $count hives',
      one: 'Done · 1 hive',
      zero: 'Done',
    );
    return '$_temp0';
  }

  @override
  String get apiaryTourStart => 'Start tour';

  @override
  String get apiaryTourResume => 'Resume tour';

  @override
  String get tourReplaceTitle => 'End the current tour?';

  @override
  String tourReplaceMessage(String apiary) {
    return 'The $apiary tour is still running. Starting a new tour clears its progress; the inspections stay saved.';
  }

  @override
  String get tourReplaceConfirm => 'Start new tour';

  @override
  String tourTitle(String apiary) {
    return '$apiary tour';
  }

  @override
  String get tourFinish => 'Finish tour';

  @override
  String tourProgress(int done, int total) {
    return '$done / $total';
  }

  @override
  String tourProgressLabel(int done, int total) {
    return '$done of $total hives done';
  }

  @override
  String tourMinutes(int minutes) {
    return '$minutes min';
  }

  @override
  String tourHoursMinutes(int hours, int minutes) {
    return '$hours h $minutes min';
  }

  @override
  String tourElapsedLabel(String duration) {
    return 'Time elapsed: $duration';
  }

  @override
  String get tourNext => 'Next up';

  @override
  String tourPreviousVisit(String date) {
    return 'Last time · $date';
  }

  @override
  String get tourQueue => 'Order';

  @override
  String tourSkippedCount(int count) {
    return '$count skipped';
  }

  @override
  String get tourStateDone => 'Done';

  @override
  String get tourStateSkipped => 'Skipped';

  @override
  String get tourStatePending => 'Waiting';

  @override
  String get tourStateNext => 'Next';

  @override
  String tourHiveSemantics(String number, String state) {
    return 'Hive $number, $state';
  }

  @override
  String get tourSkip => 'Skip';

  @override
  String tourInspect(String number) {
    return 'Inspect $number';
  }

  @override
  String get tourAllDone => 'Every hive has been inspected.';

  @override
  String get tourSunSuggestion =>
      'Sun mode makes the screen easier to read in bright light.';

  @override
  String get tourSunOn => 'Turn on sun mode';

  @override
  String get tourSunMode => 'Sun mode';

  @override
  String get tourFinishTitle => 'Finish the tour?';

  @override
  String tourFinishMessage(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other:
          '$count hives haven\'t been inspected; the summary counts them as skipped.',
      one: '1 hive hasn\'t been inspected; the summary counts it as skipped.',
    );
    return '$_temp0';
  }

  @override
  String get tourNotFound => 'There\'s no tour running in this apiary.';

  @override
  String get tourCompleteTitle => 'Tour complete';

  @override
  String tourInspectedCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count hives inspected',
      one: '1 hive inspected',
    );
    return '$_temp0';
  }

  @override
  String get tourHealthy => 'Strong / fair';

  @override
  String get tourTasksTitle => 'Tasks';

  @override
  String tourTaskRequeen(String numbers) {
    return 'Requeen: $numbers';
  }

  @override
  String tourTaskFeedWeak(String numbers) {
    return 'Feed 1:1 syrup: $numbers';
  }

  @override
  String tourTaskSwarmCheck(String numbers) {
    return 'Swarm check: $numbers';
  }

  @override
  String tourTaskRevisit(String numbers) {
    return 'Check skipped hives: $numbers';
  }

  @override
  String tourTaskMoreNumbers(String numbers, int count) {
    return '$numbers +$count';
  }

  @override
  String tourTaskDue(int days) {
    String _temp0 = intl.Intl.pluralLogic(
      days,
      locale: localeName,
      other: 'in $days days',
      one: 'tomorrow',
      zero: 'today',
    );
    return '$_temp0';
  }

  @override
  String tourSaveTasks(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Save tasks',
      one: 'Save task',
      zero: 'Close',
    );
    return '$_temp0';
  }

  @override
  String tourTasksSaved(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count tasks saved',
      one: '1 task saved',
    );
    return '$_temp0';
  }

  @override
  String get tourNoTasks => 'No tasks to suggest.';

  @override
  String get reportsTitle => 'Reports';

  @override
  String get reportTreatmentRegister => 'Treatment register';

  @override
  String get reportTreatmentRegisterHint => 'For inspections';

  @override
  String get reportHiveHistory => 'Hive history';

  @override
  String get reportHiveHistoryHint => 'One hive or an apiary';

  @override
  String get reportFrom => 'From';

  @override
  String get reportTo => 'To';

  @override
  String get reportApiary => 'Apiary';

  @override
  String get reportAllApiaries => 'All apiaries';

  @override
  String get reportHive => 'Hive';

  @override
  String get reportAllHives => 'All hives';

  @override
  String get reportLanguage => 'PDF language';

  @override
  String get reportLanguageTurkish => 'Türkçe';

  @override
  String get reportLanguageEnglish => 'English';

  @override
  String get reportRegistrationNo => 'Holding registration no.';

  @override
  String get reportAksNo => 'AKS no.';

  @override
  String get reportRecordNo => 'Registration number';

  @override
  String get reportNumbersHelper =>
      'Printed in the PDF header only; not saved.';

  @override
  String get reportShare => 'Share';

  @override
  String get reportCreate => 'Create PDF';

  @override
  String get reportPreparing => 'Preparing the PDF…';

  @override
  String get reportError => 'Couldn\'t create the PDF. Try again.';

  @override
  String get reportLoadError => 'Couldn\'t read the records.';

  @override
  String get reportEmpty => 'No records in this period.';

  @override
  String reportTreatmentCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count treatments',
      one: '1 treatment',
    );
    return '$_temp0';
  }

  @override
  String reportHiveCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count hives',
      one: '1 hive',
    );
    return '$_temp0';
  }

  @override
  String reportRecordCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count records',
      one: '1 record',
    );
    return '$_temp0';
  }

  @override
  String get reportNoValue => '—';

  @override
  String get pdfTreatmentRegisterTitle => 'Treatment Register';

  @override
  String get pdfHiveHistoryTitle => 'Hive History';

  @override
  String pdfRegistrationNo(String number) {
    return 'Holding registration no. $number';
  }

  @override
  String pdfAksNo(String number) {
    return 'AKS no. $number';
  }

  @override
  String pdfRecordNo(String number) {
    return 'Registration no. $number';
  }

  @override
  String pdfPeriod(String from, String to) {
    return 'Period: $from – $to';
  }

  @override
  String pdfApiary(String name) {
    return 'Apiary: $name';
  }

  @override
  String pdfCreated(String date) {
    return 'Created $date';
  }

  @override
  String pdfPage(int page, int pages) {
    return 'Page $page of $pages';
  }

  @override
  String get pdfColumnDate => 'Date';

  @override
  String get pdfColumnApiary => 'Apiary';

  @override
  String get pdfColumnProduct => 'Product / batch';

  @override
  String get pdfColumnHives => 'Hives';

  @override
  String get pdfColumnDose => 'Dose per hive';

  @override
  String get pdfColumnRemoval => 'Removal';

  @override
  String get pdfColumnWithdrawalEnd => 'Withdrawal ends';

  @override
  String get pdfColumnEvent => 'Record';

  @override
  String get pdfColumnDetails => 'Details';

  @override
  String get pdfEventFeeding => 'Feeding';

  @override
  String get pdfEventVarroa => 'Varroa count';

  @override
  String get pdfEventHarvest => 'Harvest';

  @override
  String pdfHarvestTotal(String amount) {
    return 'Whole harvest: $amount';
  }

  @override
  String pdfDocumentName(String title, String from, String to) {
    return '$title $from–$to';
  }

  @override
  String get moreFeedback => 'Send feedback';

  @override
  String get feedbackTitle => 'Send feedback';

  @override
  String get feedbackIntro =>
      'We\'re building this app together with beekeepers. We read every message.';

  @override
  String get feedbackKindLabel => 'What is it about?';

  @override
  String get feedbackKindBug => 'Bug';

  @override
  String get feedbackKindSuggestion => 'Suggestion';

  @override
  String get feedbackKindMissingFeature => 'Missing feature';

  @override
  String get feedbackKindThanks => 'Thanks';

  @override
  String get feedbackMessageLabel => 'Your message';

  @override
  String get feedbackMessageHint => 'What happened, and what did you expect?';

  @override
  String get feedbackAddScreenshot => 'Add screenshot';

  @override
  String get feedbackScreenshotAttached => 'Screenshot attached';

  @override
  String get feedbackRemoveScreenshot => 'Remove';

  @override
  String get feedbackScreenshotDenied =>
      'Photo access wasn\'t allowed. To attach a screenshot, allow it in Settings.';

  @override
  String get feedbackIncludeDeviceInfo => 'Include device and version info';

  @override
  String get feedbackOfflineHint =>
      'Without internet, the message is queued and sent once you\'re online.';

  @override
  String get feedbackSend => 'Send';

  @override
  String get feedbackQueued => 'Thank you! Your message is queued to be sent.';

  @override
  String get settingsAnalytics => 'Share usage data';

  @override
  String get settingsAnalyticsHint =>
      'Numbers like inspection time, scan results and sync delay; your name, hives and location are never sent.';

  @override
  String get teamTitle => 'Team';

  @override
  String get teamRoleOwner => 'Owner';

  @override
  String get teamRolePartner => 'Partner';

  @override
  String get teamRoleWorker => 'Worker';

  @override
  String get teamRoleViewer => 'Advisor';

  @override
  String get teamRoleViewerSubtitle => 'Read only';

  @override
  String get teamRoleHintPartner =>
      'A partner enters records and sees finance.';

  @override
  String get teamRoleHintWorker =>
      'A worker enters records but cannot see finance.';

  @override
  String get teamRoleHintViewer =>
      'An advisor can only read and cannot enter records.';

  @override
  String teamMemberSelf(String name) {
    return '$name (you)';
  }

  @override
  String get teamMemberUnknown => 'Team member';

  @override
  String get teamMembersEmpty => 'Members appear once sync finishes.';

  @override
  String get teamInviteTitle => 'Invite to the team';

  @override
  String get teamInviteHint =>
      'Tell or send the code. It is valid for 48 hours.';

  @override
  String get teamInviteGenerate => 'Generate code';

  @override
  String get teamInviteCopy => 'Copy';

  @override
  String get teamInviteCopied => 'Code copied.';

  @override
  String teamInviteCodeSemantics(String code) {
    return 'Invite code $code';
  }

  @override
  String get teamHaveCode => 'I have a code';

  @override
  String get teamJoinTitle => 'Join with a code';

  @override
  String get teamJoinHint => 'Enter the 6-character code you were sent.';

  @override
  String get teamJoinCodeLabel => 'Invite code';

  @override
  String get teamJoinAction => 'Join';

  @override
  String get teamJoinDone => 'You joined the team.';

  @override
  String get teamErrorOffline =>
      'This needs an internet connection. Try again when you are online.';

  @override
  String get teamErrorInvalidCode =>
      'The code is invalid, expired or already used.';

  @override
  String get teamErrorAlreadyMember => 'You are already a member of this team.';

  @override
  String get teamErrorForbidden => 'You are not allowed to do this.';

  @override
  String get teamErrorOwnerLocked =>
      'The owner\'s role cannot be changed and the owner cannot be removed.';

  @override
  String get teamErrorUnknown => 'That did not work. Try again in a moment.';

  @override
  String get teamRemoveAction => 'Remove from the team';

  @override
  String get teamRemoveTitle => 'Remove from the team?';

  @override
  String teamRemoveMessage(String name) {
    return '$name will lose access to this business\'s records.';
  }

  @override
  String get teamRemoveConfirm => 'Remove';

  @override
  String teamRemoved(String name) {
    return '$name was removed from the team.';
  }

  @override
  String teamRoleChanged(String name, String role) {
    return '$name is now $role.';
  }

  @override
  String get teamActivityTitle => 'Recent activity';

  @override
  String get teamActivityEmpty => 'No activity yet.';

  @override
  String get teamActivitySelf => 'You';

  @override
  String teamActivityInspection(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'entered $count inspections',
      one: 'entered 1 inspection',
    );
    return '$_temp0';
  }

  @override
  String teamActivityTreatment(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'treated $count hives',
      one: 'treated 1 hive',
    );
    return '$_temp0';
  }

  @override
  String teamActivityFeeding(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'fed $count hives',
      one: 'fed 1 hive',
    );
    return '$_temp0';
  }

  @override
  String teamActivityHarvest(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'recorded $count harvests',
      one: 'recorded 1 harvest',
    );
    return '$_temp0';
  }

  @override
  String teamActivityMiteCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'entered $count varroa counts',
      one: 'entered 1 varroa count',
    );
    return '$_temp0';
  }

  @override
  String teamActivityTask(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'added $count tasks',
      one: 'added 1 task',
    );
    return '$_temp0';
  }

  @override
  String get teamActivityJustNow => 'just now';

  @override
  String teamActivityMinutesAgo(int count) {
    return '$count min ago';
  }

  @override
  String teamActivityHoursAgo(int count) {
    return '$count h ago';
  }

  @override
  String get teamActivityYesterday => 'yesterday';

  @override
  String teamActivityDaysAgo(int count) {
    return '$count days ago';
  }

  @override
  String teamActivityLine(String what, String where, String when) {
    return '$what$where · $when';
  }

  @override
  String teamActivitySemantics(
    String who,
    String what,
    String where,
    String when,
  ) {
    return '$who $what$where, $when';
  }

  @override
  String get settingsPush => 'Task notifications';

  @override
  String get settingsPushHint =>
      'Get a notification when a task is assigned to you. Tap it to open the task.';

  @override
  String get documentsTitle => 'Document vault';

  @override
  String get documentsAdd => 'Add document';

  @override
  String documentsSummaryOffline(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count documents',
      one: '1 document',
    );
    return '$_temp0 · all open offline';
  }

  @override
  String documentsSummaryMissing(int count, int missing) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count documents',
      one: '1 document',
    );
    String _temp1 = intl.Intl.pluralLogic(
      missing,
      locale: localeName,
      other: '$missing files',
      one: '1 file',
    );
    return '$_temp0 · $_temp1 not on this phone yet';
  }

  @override
  String get documentsRegionNoteTr =>
      'Document types depend on the country. Outside Türkiye you create your own document types.';

  @override
  String get documentsRegionNoteOther =>
      'You define the document types; the types you enter are suggested next time.';

  @override
  String get documentsRoadCheck => 'Road check · show documents';

  @override
  String get documentsEmptyTitle => 'No documents yet';

  @override
  String get documentsEmptyMessage =>
      'Add a photo or PDF of your permits and certificates. They open offline and you\'re reminded before they expire.';

  @override
  String get documentsLoadError => 'Couldn\'t open the documents.';

  @override
  String get documentFileKindPhoto => 'PHOTO';

  @override
  String get documentFileKindPdf => 'PDF';

  @override
  String get documentTypeHealthReport => 'Health report';

  @override
  String get documentTypeTransportPermit => 'Transport permit';

  @override
  String get documentTypeMigratoryCertificate =>
      'Migratory beekeeper certificate';

  @override
  String get documentTypeBusinessRegistration =>
      'Business registration certificate';

  @override
  String get documentTypeLandPermit => 'Land permit';

  @override
  String get documentTypeAnalysisReport => 'Analysis report';

  @override
  String get documentExpiryNone => 'No expiry';

  @override
  String get documentExpiryExpired => 'Expired';

  @override
  String get documentExpiryToday => 'Ends today';

  @override
  String documentExpiryDays(int days) {
    String _temp0 = intl.Intl.pluralLogic(
      days,
      locale: localeName,
      other: '$days days',
      one: '1 day',
    );
    return '$_temp0';
  }

  @override
  String documentExpiryMonths(int months) {
    String _temp0 = intl.Intl.pluralLogic(
      months,
      locale: localeName,
      other: '$months months',
      one: '1 month',
    );
    return '$_temp0';
  }

  @override
  String documentExpiresOn(String date) {
    return 'Valid until $date';
  }

  @override
  String get documentFormNewTitle => 'Add document';

  @override
  String get documentFormEditTitle => 'Edit document';

  @override
  String get documentFormType => 'Document type';

  @override
  String get documentFormCustomTypeHint => 'e.g. Insurance policy';

  @override
  String get documentFormName => 'Name';

  @override
  String get documentFormNameHint => 'e.g. Health report 2026';

  @override
  String get documentFormDescription => 'Description';

  @override
  String get documentFormDescriptionHint => 'e.g. District office · 152 hives';

  @override
  String get documentFormExpiry => 'Valid until';

  @override
  String get documentFormNoExpiry => 'No expiry';

  @override
  String get documentFormPickDate => 'Pick a date';

  @override
  String get documentFormExpiryHelper =>
      'You\'ll be reminded 30, 7 and 1 day before it expires.';

  @override
  String get documentFormFile => 'File';

  @override
  String get documentFormTakePhoto => 'Take photo';

  @override
  String get documentFormPickImage => 'From gallery';

  @override
  String get documentFormPickPdf => 'Choose PDF';

  @override
  String get documentFormNoFile =>
      'Take a photo of the document or choose its PDF.';

  @override
  String documentFileSizeKb(String size) {
    return '$size KB';
  }

  @override
  String documentFileSizeMb(String size) {
    return '$size MB';
  }

  @override
  String get documentFileTooLarge =>
      'The file is larger than 20 MB; choose a smaller one.';

  @override
  String get documentFileFailed => 'Couldn\'t get the file, try again.';

  @override
  String get documentFilePermissionDenied =>
      'Permission denied. To add a document, allow camera or file access for this app in Settings.';

  @override
  String get documentFormSave => 'Save';

  @override
  String get documentFormDelete => 'Delete document';

  @override
  String get documentSaved => 'Document saved';

  @override
  String get documentReminderDenied =>
      'Document saved. Expiry reminders won\'t ring without notification permission.';

  @override
  String get documentDeleteTitle => 'Delete this document?';

  @override
  String get documentDeleteMessage =>
      'The document and its file are removed from every phone.';

  @override
  String get documentDeleteConfirm => 'Delete';

  @override
  String get documentDeleted => 'Document deleted';

  @override
  String get documentNotFound =>
      'Document not found; it may have been deleted.';

  @override
  String get documentEdit => 'Edit';

  @override
  String get documentFileMissing =>
      'The file isn\'t on this phone yet. It downloads when you\'re online.';

  @override
  String get documentPdfFailed => 'Couldn\'t open the PDF.';

  @override
  String documentPdfPage(int page, int count) {
    return 'Page $page of $count';
  }

  @override
  String get roadCheckTitle => 'Road check';

  @override
  String roadCheckPosition(int index, int count) {
    return '$index / $count';
  }

  @override
  String get roadCheckSwipeHint => 'Swipe sideways for the next document';

  @override
  String get roadCheckPrevious => 'Previous document';

  @override
  String get roadCheckNext => 'Next document';

  @override
  String documentReminderBody(int days, String date) {
    String _temp0 = intl.Intl.pluralLogic(
      days,
      locale: localeName,
      other: '$days days',
      one: '1 day',
    );
    return 'Expires in $_temp0 · $date';
  }

  @override
  String get syncTableDocuments => 'Document';

  @override
  String get migrationsTitle => 'Migration plans';

  @override
  String get migrationsAdd => 'New plan';

  @override
  String get migrationsEmptyTitle => 'No migration plan yet';

  @override
  String get migrationsEmptyMessage =>
      'Plan the year\'s route: each stop\'s dates, hive count and target apiary.';

  @override
  String get migrationsLoadError => 'Couldn\'t open migration plans';

  @override
  String migrationStopCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count stops',
      one: '1 stop',
      zero: 'No stops',
    );
    return '$_temp0';
  }

  @override
  String migrationTitle(String name, String year) {
    return '$name $year';
  }

  @override
  String get migrationNotFound => 'Migration plan not found';

  @override
  String get migrationDocuments => 'Documents';

  @override
  String get migrationEdit => 'Edit plan';

  @override
  String get migrationAddStop => 'Add stop';

  @override
  String get migrationNoStopsTitle => 'No stops yet';

  @override
  String get migrationNoStopsMessage =>
      'Add the route\'s stops in order: source, place, dates and hive count.';

  @override
  String migrationNextMoveIn(int days) {
    String _temp0 = intl.Intl.pluralLogic(
      days,
      locale: localeName,
      other: '$days days',
      one: '1 day',
      zero: 'today',
    );
    return 'Next move · $_temp0';
  }

  @override
  String migrationNextMoveLate(int days) {
    String _temp0 = intl.Intl.pluralLogic(
      days,
      locale: localeName,
      other: '$days days late',
      one: '1 day late',
    );
    return 'Next move · $_temp0';
  }

  @override
  String migrationRoute(String from, String to) {
    return '$from → $to';
  }

  @override
  String migrationDocReady(String document) {
    return '$document ready';
  }

  @override
  String migrationDocDays(String document, int days) {
    String _temp0 = intl.Intl.pluralLogic(
      days,
      locale: localeName,
      other: '$days days',
      one: '1 day',
      zero: 'expires today',
    );
    return '$document $_temp0';
  }

  @override
  String migrationDocBeforeMove(String document) {
    return '$document expires before the move';
  }

  @override
  String migrationDocExpired(String document) {
    return '$document expired';
  }

  @override
  String migrationDocMissing(String document) {
    return '$document missing';
  }

  @override
  String get migrationStopPast => 'Past';

  @override
  String get migrationStopCurrent => 'Here now';

  @override
  String get migrationStopPlanned => 'Planned';

  @override
  String get migrationStopHere => 'You\'re here';

  @override
  String migrationStopDates(String start, String end) {
    return '$start–$end';
  }

  @override
  String migrationYield(String year, String kg) {
    return '$year: $kg kg/hive';
  }

  @override
  String migrationYields(String values) {
    return 'Past yield · $values';
  }

  @override
  String get migrationNoYield => 'No past harvest at this apiary';

  @override
  String get migrationFormNewTitle => 'New migration plan';

  @override
  String get migrationFormEditTitle => 'Edit migration plan';

  @override
  String get migrationFormYear => 'Year';

  @override
  String get migrationFormName => 'Name';

  @override
  String get migrationFormDefaultName => 'Migration plan';

  @override
  String get migrationFormSave => 'Save';

  @override
  String get migrationFormDelete => 'Delete plan';

  @override
  String get migrationDeleteTitle => 'Delete migration plan?';

  @override
  String get migrationDeleteMessage =>
      'The plan and all its stops will be deleted.';

  @override
  String get migrationDeleteConfirm => 'Delete';

  @override
  String get migrationSaved => 'Plan saved';

  @override
  String get migrationDeleted => 'Plan deleted';

  @override
  String get stopFormNewTitle => 'New stop';

  @override
  String get stopFormEditTitle => 'Edit stop';

  @override
  String get stopFormName => 'Source';

  @override
  String get stopFormNameHint => 'e.g. Citrus, Pine';

  @override
  String get stopFormPlace => 'Place';

  @override
  String get stopFormPlaceHint => 'e.g. Erdemli, Mersin';

  @override
  String get stopFormStart => 'Planned start';

  @override
  String get stopFormEnd => 'Planned end';

  @override
  String get stopFormApiary => 'Target apiary';

  @override
  String get stopFormChooseApiary => 'Choose target apiary';

  @override
  String get stopFormNone => 'None';

  @override
  String get stopFormHiveCount => 'Hives';

  @override
  String get stopFormPosition => 'Order on the route';

  @override
  String get stopFormStatus => 'Status';

  @override
  String get stopFormDelete => 'Delete stop';

  @override
  String get stopDeleteTitle => 'Delete stop?';

  @override
  String get stopDeleteMessage => 'The stop will be removed from the plan.';

  @override
  String get stopSaved => 'Stop saved';

  @override
  String get stopDeleted => 'Stop deleted';

  @override
  String get syncTableMigrations => 'Migration plan';

  @override
  String get syncTableMigrationStops => 'Migration stop';

  @override
  String get moveStart => 'Start move';

  @override
  String moveTitle(String route) {
    return 'Move · $route';
  }

  @override
  String get moveNone => 'No upcoming move';

  @override
  String get moreMigratory => 'Migratory';

  @override
  String get syncTableTransports => 'Move';

  @override
  String get syncTableTransportItems => 'Moved hive';

  @override
  String get moveStepCheck => 'Check';

  @override
  String get moveStepLoad => 'Loading';

  @override
  String get moveStepUnload => 'Unloading';

  @override
  String moveStepDone(String step) {
    return '$step, done';
  }

  @override
  String get moveNoDestinationTitle => 'The stop has no apiary';

  @override
  String get moveNoDestinationMessage =>
      'Pick a destination apiary for the stop so hive locations can update after unloading.';

  @override
  String get moveEditStop => 'Edit stop';

  @override
  String get moveFrom => 'From';

  @override
  String get moveTo => 'To';

  @override
  String moveSourceHives(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count active hives',
      one: '1 active hive',
      zero: 'No active hives',
    );
    return '$_temp0';
  }

  @override
  String get moveChecklist => 'Loading checklist';

  @override
  String get moveCheckEntrances => 'Entrances closed';

  @override
  String get moveCheckVentilation => 'Ventilation open';

  @override
  String get moveCheckStraps => 'Straps tight';

  @override
  String get moveCheckWater => 'Water ready';

  @override
  String get moveVehicles => 'Vehicles';

  @override
  String moveVehicleDefault(int number) {
    return 'Truck $number';
  }

  @override
  String get moveAddVehicle => 'Add vehicle';

  @override
  String moveRemoveVehicle(String vehicle) {
    return 'Remove $vehicle';
  }

  @override
  String get moveVehicleName => 'Vehicle name';

  @override
  String get moveVehicleExists => 'A vehicle with this name exists';

  @override
  String get moveStartLoading => 'Start loading';

  @override
  String get moveChecklistHint =>
      'Tick everything on the list to start loading.';

  @override
  String moveVehicleCount(String vehicle, int count) {
    return '$vehicle · $count';
  }

  @override
  String get moveLoaded => 'Loaded';

  @override
  String get moveUnloaded => 'Unloaded';

  @override
  String moveCountTotal(int total) {
    return '/ $total';
  }

  @override
  String moveCountLabel(int count, int total) {
    return '$count of $total hives';
  }

  @override
  String moveLastScanned(String number) {
    return 'Last scanned: $number';
  }

  @override
  String moveNotScanned(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count hives not scanned yet',
      one: '1 hive not scanned yet',
    );
    return '$_temp0';
  }

  @override
  String get moveAllScanned => 'All scanned';

  @override
  String get moveShowList => 'See list';

  @override
  String get moveMissingTitle => 'Hives not scanned';

  @override
  String get moveLoadingHint =>
      'You\'ll scan again while unloading at the destination; I\'ll warn you if a hive is missing. Hive locations update after unloading.';

  @override
  String moveUnloadingHint(String destination) {
    return 'Scan each hive again as you unload. When you finish, unloaded hives move to $destination.';
  }

  @override
  String get moveEnterNumber => 'Enter number';

  @override
  String get moveHiveNumber => 'Hive number';

  @override
  String moveNumberNotFound(String number) {
    return 'No hive numbered $number';
  }

  @override
  String get moveScanStart => 'Start scanning';

  @override
  String get moveScanContinue => 'Continue scanning';

  @override
  String get moveToUnloading => 'Go to unloading';

  @override
  String moveToUnloadingTitle(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count hives not scanned',
      one: '1 hive not scanned',
    );
    return '$_temp0';
  }

  @override
  String get moveToUnloadingMessage =>
      'Hives not scanned stay out of this move and remain where they are.';

  @override
  String get moveFinish => 'Finish move';

  @override
  String moveFinishTitle(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count hives not unloaded',
      one: '1 hive not unloaded',
    );
    return '$_temp0';
  }

  @override
  String moveFinishMessage(String source) {
    return 'Hives not unloaded keep their location at $source. The missing list stays on the move.';
  }

  @override
  String get moveFinishConfirm => 'Finish';

  @override
  String get moveDoneTitle => 'Move finished';

  @override
  String moveDoneSummary(int loaded, int unloaded) {
    return 'Loaded $loaded · Unloaded $unloaded';
  }

  @override
  String moveDoneMoved(int count, String destination) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count hives moved to $destination.',
      one: '1 hive moved to $destination.',
      zero: 'No hives moved.',
    );
    return '$_temp0';
  }

  @override
  String get moveDoneMissing => 'Hives not unloaded';

  @override
  String moveScanLoaded(String number, String vehicle) {
    return '$number loaded · $vehicle';
  }

  @override
  String moveScanLoadedOther(String number) {
    return '$number loaded; this hive wasn\'t at this apiary';
  }

  @override
  String moveScanAlreadyLoaded(String number) {
    return '$number is already loaded';
  }

  @override
  String moveScanUnloaded(String number) {
    return '$number unloaded';
  }

  @override
  String moveScanAlreadyUnloaded(String number) {
    return '$number is already unloaded';
  }

  @override
  String moveScanNotLoaded(String number) {
    return '$number wasn\'t loaded on this move';
  }

  @override
  String get moveScanUnknown => 'Unknown label';

  @override
  String get moveScanDone => 'Done';

  @override
  String get inventoryTitle => 'Supplies and stock';

  @override
  String get inventoryAdd => 'Add item';

  @override
  String get inventoryEmptyTitle => 'No stock items yet';

  @override
  String get inventoryEmptyMessage =>
      'Add supplies like sugar, foundation and jars. Items below their minimum are flagged.';

  @override
  String get inventoryCategoryEmpty => 'No items in this category';

  @override
  String get inventoryLoadError => 'Couldn\'t open stock.';

  @override
  String get inventoryNotFound => 'Item not found';

  @override
  String get inventoryCategoryConsumable => 'Supplies';

  @override
  String get inventoryCategoryEquipment => 'Equipment';

  @override
  String get inventoryCategoryComb => 'Comb';

  @override
  String get inventoryUnitKg => 'kg';

  @override
  String get inventoryUnitLiter => 'L';

  @override
  String get inventoryUnitPiece => 'pcs';

  @override
  String get inventoryUnitRoll => 'rolls';

  @override
  String get inventoryUnitPack => 'packs';

  @override
  String get inventoryUnitNameKg => 'Kilogram';

  @override
  String get inventoryUnitNameLiter => 'Liter';

  @override
  String get inventoryUnitNamePiece => 'Piece';

  @override
  String get inventoryUnitNameRoll => 'Roll';

  @override
  String get inventoryUnitNamePack => 'Pack';

  @override
  String inventoryQuantity(String quantity, String unit) {
    return '$quantity $unit';
  }

  @override
  String inventoryBelowThreshold(String threshold) {
    return 'Below minimum · at least $threshold';
  }

  @override
  String get inventoryMoveIn => 'In';

  @override
  String get inventoryMoveOut => 'Out';

  @override
  String get inventoryMoveCount => 'Count';

  @override
  String get inventoryMoveAdjustment => 'Correction';

  @override
  String inventoryInStock(String quantity) {
    return 'In stock: $quantity';
  }

  @override
  String inventoryAmountLabel(String unit) {
    return 'Amount ($unit)';
  }

  @override
  String inventoryCountedLabel(String unit) {
    return 'Counted amount ($unit)';
  }

  @override
  String get inventoryAmountInvalid => 'Enter a valid amount';

  @override
  String get inventoryAmountWhole => 'Use a whole number for this unit';

  @override
  String get inventorySaveIn => 'Add to stock';

  @override
  String get inventorySaveOut => 'Remove from stock';

  @override
  String get inventorySaveCount => 'Correct stock';

  @override
  String inventoryMovedIn(String quantity) {
    return '$quantity added';
  }

  @override
  String inventoryMovedOut(String quantity) {
    return '$quantity removed';
  }

  @override
  String inventoryAdjusted(String quantity) {
    return 'Stock is now $quantity';
  }

  @override
  String inventoryUnchanged(String quantity) {
    return 'Stock is already $quantity';
  }

  @override
  String get inventoryDetails => 'Details and history';

  @override
  String get inventoryHistory => 'History';

  @override
  String get inventoryHistoryEmpty => 'No movements yet';

  @override
  String inventoryThreshold(String threshold) {
    return 'Minimum: at least $threshold';
  }

  @override
  String get inventoryNoThreshold => 'No minimum';

  @override
  String get inventoryQuickMove => 'Add / remove';

  @override
  String get inventoryEdit => 'Edit item';

  @override
  String get inventoryFormNewTitle => 'New item';

  @override
  String get inventoryFormEditTitle => 'Edit item';

  @override
  String get inventoryFormName => 'Name';

  @override
  String get inventoryFormCategory => 'Category';

  @override
  String get inventoryFormUnit => 'Unit';

  @override
  String get inventoryFormLocation => 'Location';

  @override
  String get inventoryFormLocationHint => 'Storeroom, truck, office… Optional.';

  @override
  String get inventoryFormThreshold => 'Minimum';

  @override
  String get inventoryFormThresholdHint =>
      'You\'re warned when stock drops below this. Optional.';

  @override
  String get inventoryFormThresholdInvalid => 'Enter a valid minimum';

  @override
  String get inventoryFormSave => 'Save';

  @override
  String get inventoryFormDelete => 'Delete item';

  @override
  String get inventoryDeleteTitle => 'Delete this item?';

  @override
  String get inventoryDeleteMessage => 'The item and its stock leave the list.';

  @override
  String get inventoryDeleteConfirm => 'Delete';

  @override
  String get inventorySaved => 'Item saved';

  @override
  String get inventoryDeleted => 'Item deleted';

  @override
  String get syncTableInventoryItems => 'Stock item';

  @override
  String get syncTableInventoryMoves => 'Stock movement';

  @override
  String inventoryIncrease(String quantity) {
    return '+$quantity';
  }

  @override
  String inventoryFormThresholdUnit(String unit) {
    return 'Minimum ($unit)';
  }

  @override
  String get stockUseTitle => 'Deduct from stock';

  @override
  String get stockUseNone => 'Don\'t deduct';

  @override
  String stockUseValue(String item, String quantity) {
    return '$item · −$quantity';
  }

  @override
  String get stockUseChoose => 'Deduct from which item?';

  @override
  String get taskFormTreatment => 'Planned treatment';

  @override
  String get taskFormTreatmentUnknown => 'Drug not in the list';

  @override
  String get taskFormTreatmentNeedsApiary =>
      'Choose an apiary for the planned treatment';

  @override
  String taskTreatmentPlanTitle(String drug) {
    return 'Treatment · $drug';
  }

  @override
  String get shoppingTitle => 'Shopping list';

  @override
  String shoppingCardTitle(int count) {
    return 'Shopping list · $count';
  }

  @override
  String get shoppingEmptyTitle => 'Nothing to buy';

  @override
  String get shoppingEmptyMessage =>
      'Items below their threshold and the needs of planned treatments show up here.';

  @override
  String get shoppingShare => 'Share';

  @override
  String get shoppingLoadError => 'Couldn\'t open the shopping list';

  @override
  String shoppingReasonThreshold(String stock, String threshold) {
    return '$stock in stock · min $threshold';
  }

  @override
  String shoppingReasonPlanned(String quantity) {
    return 'Planned treatments $quantity';
  }

  @override
  String get shoppingReasonNoItem => 'Planned treatment · no stock item';

  @override
  String shoppingShareLine(String name, String quantity) {
    return '• $name: $quantity';
  }

  @override
  String get moreRearing => 'Queen rearing';

  @override
  String get rearingTitle => 'Queen rearing';

  @override
  String rearingBatchName(int number) {
    return 'Batch $number';
  }

  @override
  String rearingBatchTitle(int number) {
    return 'Queen rearing · Batch $number';
  }

  @override
  String get rearingAdd => 'Add batch';

  @override
  String get rearingEmptyTitle => 'No batches yet';

  @override
  String get rearingEmptyMessage =>
      'Enter the grafting day; the schedule from acceptance to the laying check and its reminders are set up for you.';

  @override
  String get rearingLoadError => 'Couldn\'t load batches';

  @override
  String get rearingNotFound => 'Batch not found';

  @override
  String rearingListGrafted(String date) {
    return 'grafted $date';
  }

  @override
  String get rearingEdit => 'Edit batch';

  @override
  String get rearingGraftedLabel => 'Grafted';

  @override
  String get rearingAcceptedLabel => 'Accepted';

  @override
  String get rearingNucsLabel => 'Nucs';

  @override
  String get rearingNotCounted => 'Not counted';

  @override
  String rearingAcceptedPercent(int percent) {
    return '$percent%';
  }

  @override
  String rearingMotherLine(String mother, String date) {
    return 'Mother: $mother · grafted $date';
  }

  @override
  String rearingMotherUnknownLine(String date) {
    return 'Mother unknown · grafted $date';
  }

  @override
  String rearingDay(int day) {
    return 'D$day';
  }

  @override
  String get rearingToday => 'Today';

  @override
  String get rearingStepGraft => 'Larva grafting';

  @override
  String get rearingStepAcceptance => 'Acceptance check';

  @override
  String get rearingStepCapped => 'Cells capped';

  @override
  String get rearingStepDistribution => 'Distribute cells';

  @override
  String get rearingStepEmergence => 'Queen emergence';

  @override
  String get rearingStepLayingCheck => 'Laying check';

  @override
  String rearingStepGraftDetail(int count) {
    return '$count larvae';
  }

  @override
  String rearingStepAcceptanceDetail(int count) {
    return '$count cells accepted';
  }

  @override
  String get rearingStepAcceptanceTodo => 'Count the accepted cells';

  @override
  String get rearingStepCappedDetail => 'Don\'t disturb';

  @override
  String rearingStepDistributionDetail(int count) {
    return 'Before emergence, to $count nucs';
  }

  @override
  String get rearingStepDistributionTodo => 'Before emergence, to the nucs';

  @override
  String get rearingStepEmergenceDetail => 'Check the nucs';

  @override
  String get rearingStepLayingCheckDetail => 'Mark mating success';

  @override
  String get rearingStepDone => 'done';

  @override
  String get rearingStepCurrent => 'next';

  @override
  String get rearingStepUpcoming => 'upcoming';

  @override
  String get rearingDistribute => 'Distribute cells to nucs';

  @override
  String get rearingDistributeApiary => 'Apiary';

  @override
  String get rearingDistributeCount => 'Nucs';

  @override
  String rearingDistributePlan(int reused, int created) {
    return 'Empty nucs reused: $reused · New nucs: $created';
  }

  @override
  String get rearingDistributeSave => 'Distribute';

  @override
  String get rearingDistributeNoApiary => 'Add an apiary first';

  @override
  String rearingDistributed(int count) {
    return 'Distributed to $count nucs';
  }

  @override
  String get rearingNucsSection => 'Mating nucs';

  @override
  String rearingNucTitle(String number) {
    return 'Nuc $number';
  }

  @override
  String get matingNucStatusEmpty => 'Empty';

  @override
  String get matingNucStatusCell => 'Cell';

  @override
  String get matingNucStatusVirgin => 'Virgin queen';

  @override
  String get matingNucStatusLaying => 'Laying';

  @override
  String get matingNucStatusFailed => 'Failed';

  @override
  String get matingNucStatusGiven => 'Given to a hive';

  @override
  String get rearingNucGive => 'Give to a hive';

  @override
  String get rearingNucChooseHive => 'Which hive?';

  @override
  String get rearingNucNoHives => 'No active hives';

  @override
  String get rearingFormNewTitle => 'New batch';

  @override
  String get rearingFormEditTitle => 'Edit batch';

  @override
  String get rearingFormGraftedOn => 'Grafting day';

  @override
  String get rearingFormGraftedCount => 'Grafted larvae';

  @override
  String get rearingFormAcceptedCount => 'Accepted cells';

  @override
  String get rearingFormAcceptedClear => 'Not counted yet';

  @override
  String get rearingFormScheduleHint =>
      'Acceptance, capping, distribution, emergence and laying check are added as tasks with reminders.';

  @override
  String get rearingFormSave => 'Save';

  @override
  String get rearingFormDelete => 'Delete batch';

  @override
  String get rearingDeleteTitle => 'Delete batch?';

  @override
  String get rearingDeleteMessage =>
      'Its tasks are deleted too. Nucs and given queens stay.';

  @override
  String get rearingDeleteConfirm => 'Delete';

  @override
  String get rearingDeleted => 'Batch deleted';

  @override
  String get rearingSaved => 'Batch saved';

  @override
  String get taskSourceQueenRearing => 'queen rearing';

  @override
  String get syncTableQueenRearingBatches => 'Queen rearing batch';

  @override
  String get syncTableMatingNucs => 'Mating nuc';

  @override
  String get lotsTitle => 'Harvest & lots';

  @override
  String get lotsEmptyTitle => 'No lots yet';

  @override
  String get lotsEmptyMessage =>
      'Add a harvest to a lot after saving it; lots are listed here.';

  @override
  String get lotsLoadError => 'Couldn\'t load lots';

  @override
  String get lotsInStock => 'In stock';

  @override
  String get lotsPerHive => 'Per hive';

  @override
  String lotNumber(String number) {
    return 'Lot $number';
  }

  @override
  String lotHoneyTitle(String kind) {
    return '$kind honey';
  }

  @override
  String get lotStatusOpen => 'Open';

  @override
  String get lotStatusClosed => 'Closed';

  @override
  String get lotWithdrawalBadge => 'In withdrawal';

  @override
  String lotMoistureValue(String value) {
    return 'Moisture $value%';
  }

  @override
  String get lotAnalyzed => 'Analysed ✓';

  @override
  String get lotAnalysisPending => 'Analysis pending';

  @override
  String lotStockValue(String weight) {
    return 'Stock $weight';
  }

  @override
  String get lotNotFound => 'Lot not found';

  @override
  String get lotEdit => 'Edit lot';

  @override
  String lotWithdrawalTitle(String hives) {
    return '$hives harvested during the withdrawal period.';
  }

  @override
  String get lotWithdrawalMessage =>
      'This lot may contain drug residue; get it analysed before selling.';

  @override
  String get lotStock => 'Stock';

  @override
  String get lotHarvested => 'Harvested';

  @override
  String get lotSold => 'Sold';

  @override
  String get lotInStock => 'In stock';

  @override
  String get lotSell => 'Record a sale';

  @override
  String get lotAnalyses => 'Analyses';

  @override
  String get lotAnalysesEmpty => 'No analyses yet';

  @override
  String get lotAddAnalysis => 'Add analysis';

  @override
  String get lotHarvests => 'Harvests';

  @override
  String get lotHarvestsEmpty => 'No harvests in this lot';

  @override
  String get lotTreatments => 'Hives\' last treatment';

  @override
  String get lotTreatmentsEmpty =>
      'No treatments recorded for this lot\'s hives';

  @override
  String lotTreatmentTitle(String hive, String product) {
    return 'Hive $hive · $product';
  }

  @override
  String lotTreatmentDetail(String date, String end) {
    return '$date · withdrawal ends $end';
  }

  @override
  String get lotPublicPage => 'Public page';

  @override
  String get lotPublish => 'Publish';

  @override
  String get lotPublishHint =>
      'Anyone who scans the QR sees the lot\'s page. Phone, address and location are never shown.';

  @override
  String get lotPublishOwnerOnly => 'Only the business owner can publish.';

  @override
  String get lotPublished => 'Published';

  @override
  String get lotNotPublished => 'Not published';

  @override
  String get lotPublicFields => 'Shown on the page';

  @override
  String get lotPublicProducer => 'Business name and hive count';

  @override
  String get lotPublicOrigin => 'Origin and harvest month';

  @override
  String get lotPublicLab => 'Analysis values';

  @override
  String get lotPublicReport => 'Analysis report';

  @override
  String get lotJarLabels => 'Jar labels (QR)';

  @override
  String get lotJarLabelsHint =>
      '24 labels per A4 page (70 × 37 mm); print at 100% scale.';

  @override
  String lotJarLabelsDocumentName(String number) {
    return 'Jar labels - $number';
  }

  @override
  String get lotSales => 'Sales';

  @override
  String get lotSalesEmpty => 'No sales recorded yet';

  @override
  String lotSaleValue(String weight) {
    return '−$weight';
  }

  @override
  String lotSaleAmount(String unit) {
    return 'Honey sold ($unit)';
  }

  @override
  String lotSaleTooMuch(String weight) {
    return 'Only $weight in stock';
  }

  @override
  String get lotSaleSave => 'Subtract from stock';

  @override
  String lotSaleSaved(String weight) {
    return '$weight sale recorded';
  }

  @override
  String get lotOrigin => 'Origin';

  @override
  String get lotOriginHint => 'E.g. Mountain pine';

  @override
  String get lotMoisture => 'Moisture %';

  @override
  String get lotMoistureHelper => 'Refractometer reading; optional';

  @override
  String get lotMoistureInvalid => 'Enter a value between 10 and 30, like 17.2';

  @override
  String lotEditTitle(String lot) {
    return 'Edit $lot';
  }

  @override
  String get lotStatus => 'Status';

  @override
  String get lotStatusHelper => 'Closed lots don\'t take new harvests';

  @override
  String get lotSave => 'Save';

  @override
  String get lotDelete => 'Delete lot';

  @override
  String lotDeleteTitle(String lot) {
    return 'Delete $lot?';
  }

  @override
  String get lotDeleteMessage =>
      'Analyses and sales are deleted too; harvests stay.';

  @override
  String get lotDeleted => 'Lot deleted';

  @override
  String labTitle(String lot) {
    return 'Analysis · $lot';
  }

  @override
  String get labDate => 'Analysis date';

  @override
  String get labHmf => 'HMF (mg/kg)';

  @override
  String get labDiastase => 'Diastase number';

  @override
  String get labProline => 'Proline (mg/kg)';

  @override
  String labHmfValue(String value) {
    return 'HMF $value';
  }

  @override
  String labDiastaseValue(String value) {
    return 'Diastase $value';
  }

  @override
  String labProlineValue(String value) {
    return 'Proline $value';
  }

  @override
  String labValueInvalid(String min, String max) {
    return 'Enter a value between $min and $max';
  }

  @override
  String get labResidue => 'Residue';

  @override
  String get labResidueNone => 'No residue';

  @override
  String get labResidueDetected => 'Residue detected';

  @override
  String get labReport => 'Report';

  @override
  String get labReportNone => 'No report';

  @override
  String get labReportEmpty => 'No analysis reports in the document vault';

  @override
  String get labReportAdd => 'Add report to document vault';

  @override
  String get labSave => 'Save analysis';

  @override
  String get labSaved => 'Analysis saved';

  @override
  String get harvestLotTitle => 'Add to lot';

  @override
  String harvestLotSaved(String weight, String kind) {
    return 'Harvest saved: $weight $kind';
  }

  @override
  String get harvestLotIntro =>
      'When honey goes into a lot, the hives\' last treatment dates are linked to it.';

  @override
  String get harvestLotNew => 'New lot';

  @override
  String harvestLotNewHint(String kind) {
    return '$kind · number assigned automatically';
  }

  @override
  String get harvestLotCreate => 'Create lot';

  @override
  String get harvestLotAdd => 'Add to lot';

  @override
  String get harvestLotSkip => 'Skip for now';

  @override
  String harvestLotCreated(String lot) {
    return '$lot created';
  }

  @override
  String harvestLotAdded(String lot) {
    return 'Harvest added to $lot';
  }

  @override
  String get harvestLotGone => 'Harvest was undone';

  @override
  String get harvestLotBack => 'Back to apiary';

  @override
  String get syncTableLots => 'Lot';

  @override
  String get syncTableLotHarvests => 'Lot harvest';

  @override
  String get syncTableLotTreatments => 'Lot treatment';

  @override
  String get syncTableLabResults => 'Lab result';

  @override
  String get syncTableLotSales => 'Lot sale';

  @override
  String get harvestLotGoneMessage =>
      'The harvest wasn\'t added to a lot. You can record it again from the apiary.';

  @override
  String get financeTitle => 'Finance';

  @override
  String financeYearTitle(String year) {
    return 'Finance · $year';
  }

  @override
  String get financeSeasonNet => 'Season net';

  @override
  String get financeIncome => 'Income';

  @override
  String get financeExpense => 'Expense';

  @override
  String get financeCostPerHive => 'Cost/hive';

  @override
  String get financeRecent => 'Recent entries';

  @override
  String get financeEmptyTitle => 'No entries yet';

  @override
  String get financeEmptyMessage =>
      'Record income and expenses with the buttons below; the season net is calculated here.';

  @override
  String get financeLoadError => 'Couldn\'t load entries';

  @override
  String get financeAddIncome => '+ Income';

  @override
  String get financeAddExpense => '− Expense';

  @override
  String financePlus(String amount) {
    return '+$amount';
  }

  @override
  String financeMinus(String amount) {
    return '−$amount';
  }

  @override
  String get financeReceiptAttached => 'receipt attached';

  @override
  String financeTransportRoute(String from, String to) {
    return '$from → $to';
  }

  @override
  String get financeFormIncomeTitle => 'Add income';

  @override
  String get financeFormExpenseTitle => 'Add expense';

  @override
  String financeFormAmount(String currency) {
    return 'Amount ($currency)';
  }

  @override
  String get financeFormAmountInvalid =>
      'Enter an amount above 0, like 17500 or 17.50';

  @override
  String get financeFormCategory => 'Category';

  @override
  String get financeFormDate => 'Date';

  @override
  String get financeFormDescription => 'Description';

  @override
  String get financeFormDescriptionHint => 'E.g. Sugar 500 kg';

  @override
  String get financeFormReceipt => 'Receipt / invoice';

  @override
  String get financeFormNoReceipt => 'No receipt';

  @override
  String get financeFormReceiptAdded => 'Receipt photo added';

  @override
  String get financeFormTakePhoto => 'Take photo';

  @override
  String get financeFormPickImage => 'From gallery';

  @override
  String get financeFormRemoveReceipt => 'Remove receipt';

  @override
  String get financeFormPhotoDenied =>
      'Permission denied. To add a receipt, allow camera or photo access for this app in Settings.';

  @override
  String get financeFormPhotoFailed => 'Couldn\'t get the photo, try again.';

  @override
  String get financeFormLinks => 'Linked record';

  @override
  String get financeFormApiary => 'Apiary';

  @override
  String get financeFormLot => 'Lot';

  @override
  String get financeFormTransport => 'Move';

  @override
  String get financeFormNone => 'None';

  @override
  String get financeFormChooseApiary => 'Choose apiary';

  @override
  String get financeFormChooseLot => 'Choose lot';

  @override
  String get financeFormChooseTransport => 'Choose move';

  @override
  String get financeFormNoLots => 'No lots yet';

  @override
  String get financeFormNoTransports => 'No moves yet';

  @override
  String financeFormSaleAmount(String unit) {
    return 'Honey sold ($unit)';
  }

  @override
  String get financeFormSaleHelper =>
      'Deducted from the lot\'s stock; leave empty to keep the stock';

  @override
  String get financeFormSave => 'Save';

  @override
  String get financeIncomeSaved => 'Income saved';

  @override
  String get financeExpenseSaved => 'Expense saved';

  @override
  String get financeNotFound => 'Entry not found';

  @override
  String get financeReceiptPending =>
      'The receipt hasn\'t reached this phone yet';

  @override
  String get financeDelete => 'Delete entry';

  @override
  String get financeDeleteTitle => 'Delete this entry?';

  @override
  String get financeDeleteMessage =>
      'If it\'s linked to a lot sale, the sale is deleted too and the stock comes back.';

  @override
  String get financeDeleteConfirm => 'Delete';

  @override
  String get financeDeleted => 'Entry deleted';

  @override
  String get financeCategoryFeeding => 'Feeding';

  @override
  String get financeCategoryTreatment => 'Medicine';

  @override
  String get financeCategoryEquipment => 'Equipment';

  @override
  String get financeCategoryFuelTransport => 'Fuel / transport';

  @override
  String get financeCategoryLandRent => 'Land rent';

  @override
  String get financeCategoryLabor => 'Labor';

  @override
  String get financeCategoryLabAnalysis => 'Lab analysis';

  @override
  String get financeCategoryHoney => 'Honey';

  @override
  String get financeCategoryPollen => 'Pollen';

  @override
  String get financeCategoryPropolis => 'Propolis';

  @override
  String get financeCategoryWax => 'Wax';

  @override
  String get financeCategoryNucs => 'Nucs';

  @override
  String get financeCategoryQueens => 'Queens';

  @override
  String get financeCategoryOther => 'Other';

  @override
  String get syncTableTransactions => 'Income/expense';

  @override
  String get customersTitle => 'Customer book';

  @override
  String get customersAdd => 'Add customer';

  @override
  String get customersEmptyTitle => 'No customers yet';

  @override
  String get customersEmptyMessage =>
      'Add customers to track their orders and what they owe.';

  @override
  String customerReceivableValue(String amount) {
    return '$amount owed';
  }

  @override
  String get customerNoReceivable => 'Nothing owed';

  @override
  String get customerNotFound => 'Customer not found';

  @override
  String get customerEdit => 'Edit customer';

  @override
  String get customerAddSale => 'Add sale';

  @override
  String get customerOrders => 'Orders';

  @override
  String get customerNoOrders => 'No sales to this customer yet.';

  @override
  String get customerPaid => 'Paid';

  @override
  String customerRemaining(String amount) {
    return '$amount left';
  }

  @override
  String get customerPaidAmount => 'Paid so far';

  @override
  String get customerMarkPaid => 'Mark as paid';

  @override
  String get customerMarkedPaid => 'Marked as paid';

  @override
  String get customerAddPayment => 'Record payment';

  @override
  String get customerSendWhatsApp => 'Send via WhatsApp';

  @override
  String get customerWhatsAppNoPhone =>
      'No phone; pick the contact in WhatsApp';

  @override
  String get customerWhatsAppFailed => 'Couldn\'t open WhatsApp';

  @override
  String get customerOpenTransaction => 'Open entry';

  @override
  String customerWhatsAppGreeting(String name) {
    return 'Hello $name,';
  }

  @override
  String get customerWhatsAppIntro => 'Your order summary:';

  @override
  String customerWhatsAppAmount(String amount) {
    return 'Total: $amount';
  }

  @override
  String customerWhatsAppPaid(String amount) {
    return 'Paid: $amount';
  }

  @override
  String customerWhatsAppRemaining(String amount) {
    return 'Remaining: $amount';
  }

  @override
  String get customerWhatsAppPaidInFull => 'Paid in full, thank you.';

  @override
  String customerWhatsAppAddress(String address) {
    return 'Shipping address: $address';
  }

  @override
  String get customerFormNewTitle => 'New customer';

  @override
  String get customerFormEditTitle => 'Edit customer';

  @override
  String get customerFormName => 'Name';

  @override
  String get customerFormPhone => 'Phone';

  @override
  String get customerFormPhoneHelper => 'For WhatsApp, e.g. +44 7700 900123';

  @override
  String get customerFormAddress => 'Shipping address';

  @override
  String get customerFormNotes => 'Note';

  @override
  String get customerFormSave => 'Save';

  @override
  String get customerSaved => 'Customer saved';

  @override
  String get customerDelete => 'Delete customer';

  @override
  String get customerDeleteTitle => 'Delete customer?';

  @override
  String get customerDeleteMessage =>
      'Their sales stay in your income entries.';

  @override
  String get customerDeleteConfirm => 'Delete';

  @override
  String get customerDeleted => 'Customer deleted';

  @override
  String get customerPaymentSave => 'Save payment';

  @override
  String get customerPaymentSaved => 'Payment saved';

  @override
  String customerPaymentTooMuch(String amount) {
    return 'Only $amount is left.';
  }

  @override
  String get financeFormCustomer => 'Customer';

  @override
  String get financeFormChooseCustomer => 'Choose customer';

  @override
  String get financeFormNoCustomers => 'No customers yet';

  @override
  String get financeFormPaidNow => 'Paid now';

  @override
  String get financeFormPaidNowHelper =>
      'Leave empty if the whole amount is owed.';

  @override
  String get financeFormPaidTooMuch => 'Can\'t be more than the amount.';

  @override
  String get financeProfitTitle => 'Profit by apiary';

  @override
  String get financeProfitUnknownApiary => 'Deleted apiary';

  @override
  String financeReceivables(String amount, int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count customers',
      one: '1 customer',
    );
    return '$amount owed · $_temp0';
  }

  @override
  String get syncTableCustomers => 'Customer';

  @override
  String get syncTableCustomerPayments => 'Payment';

  @override
  String get customerUnpaid => 'Unpaid';

  @override
  String customerPartiallyPaid(String paid, String remaining) {
    return '$paid paid, $remaining left';
  }

  @override
  String get taskAksUpdateTitle => 'Don\'t forget to update AKS';

  @override
  String get taskSourceAks => 'AKS';

  @override
  String get syncTableRefSupportPeriods => 'Support period';

  @override
  String get subsidiesTitle => 'Subsidies';

  @override
  String get subsidiesCheckTitle => 'Before you apply';

  @override
  String get subsidiesActiveHives => 'Active hives in the app';

  @override
  String get subsidiesDeclaredHives => 'Declared in AKS';

  @override
  String get subsidiesNotDeclared => 'Not entered';

  @override
  String get subsidiesCheckNotDeclared =>
      'Enter the hive count you declared in AKS; it is compared with the app before you apply.';

  @override
  String subsidiesCheckDiffers(String active, String declared) {
    return 'The app has $active active hives but $declared are declared in AKS. Update your AKS record before you apply.';
  }

  @override
  String get subsidiesCheckMatches => 'Counts match: the app and AKS agree.';

  @override
  String get subsidiesEditDeclared => 'Enter declared count';

  @override
  String get subsidiesDeclaredOwnerOnly =>
      'Only the owner can enter the declared count.';

  @override
  String get subsidiesPeriodsTitle => 'Application periods';

  @override
  String get subsidiesEmptyTitle => 'No support periods yet';

  @override
  String get subsidiesEmptyMessage =>
      'Application periods appear here as they are announced; you get a notification when one opens.';

  @override
  String get subsidiesPhaseOpen => 'Open';

  @override
  String get subsidiesPhaseUpcoming => 'Upcoming';

  @override
  String get subsidiesPhaseClosed => 'Closed';

  @override
  String subsidiesPeriodDates(String start, String end) {
    return '$start – $end';
  }

  @override
  String get subsidiesOpenSource => 'Open official notice';

  @override
  String get subsidiesOpenSourceFailed => 'Couldn\'t open the link';

  @override
  String get aksCountTitle => 'AKS hive count';

  @override
  String get aksCountLabel => 'Hive count declared in AKS';

  @override
  String get aksCountHelper => 'Leave empty to skip the check.';

  @override
  String get aksCountInvalid => 'Enter a number between 0 and 100,000';

  @override
  String get aksCountSave => 'Save';

  @override
  String get aksCountSaved => 'AKS hive count saved';

  @override
  String get aksCountNoOrganization =>
      'Business details haven\'t synced to this phone yet; wait for sync.';

  @override
  String get knowledgeTitle => 'Knowledge base';

  @override
  String get knowledgeSearchHint => 'Chalkbrood, introducing a queen…';

  @override
  String knowledgeMonthLabel(String month, String place) {
    return '$month · $place';
  }

  @override
  String get knowledgePlaceTurkey => 'Türkiye';

  @override
  String get knowledgePlaceNorthern => 'Northern hemisphere';

  @override
  String get knowledgePlaceSouthern => 'Southern hemisphere';

  @override
  String get knowledgeMonthTitle => 'To do this month';

  @override
  String get knowledgeDiagnosisTitle => 'Diagnosis helper';

  @override
  String get knowledgeDiagnosisSubtitle => 'Pick a sign, see possible causes';

  @override
  String get knowledgeAtlasTitle => 'Diseases and pests atlas';

  @override
  String knowledgeTopicCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count topics',
      one: '1 topic',
    );
    return '$_temp0';
  }

  @override
  String get knowledgeGuidesTitle => 'Technical guides';

  @override
  String get knowledgeGuidesSubtitle =>
      'Splits, queen introduction, uniting, wintering';

  @override
  String get knowledgeCalculatorsTitle => 'Calculators';

  @override
  String get knowledgeCalculatorsSubtitle =>
      'Syrup, drug dose, queen calendar, yield';

  @override
  String get knowledgeRegulationsTitle => 'Regulation summaries';

  @override
  String get knowledgeRegulationsSubtitle =>
      'Regulation, migratory beekeeping, honey communiqué';

  @override
  String get knowledgeTrBadge => 'TR';

  @override
  String get knowledgeFirstYearTitle => 'My first year';

  @override
  String get knowledgeFirstYearSubtitle => 'Step by step for beginners';

  @override
  String get knowledgeCalendarTitle => 'Seasonal calendar';

  @override
  String get knowledgeOffline => 'All content opens offline';

  @override
  String get knowledgeNoResultsTitle => 'No results';

  @override
  String get knowledgeNoResultsMessage => 'Try another word.';

  @override
  String get knowledgeCategoryEmptyTitle => 'No articles yet';

  @override
  String get knowledgeCategoryEmptyMessage =>
      'Content for this section will come with an update.';

  @override
  String get knowledgeArticleNotFound => 'Article not found';

  @override
  String get knowledgeLoadError => 'Couldn\'t open the knowledge base';

  @override
  String get knowledgeLinkFailed => 'Couldn\'t open the link';

  @override
  String get diagnosisSymptoms => 'Signs you see';

  @override
  String get diagnosisSymptomsHelper => 'You can pick more than one.';

  @override
  String get diagnosisResults => 'Possible diseases';

  @override
  String get diagnosisPickHint => 'Pick a sign to see possible diseases here.';

  @override
  String get diagnosisNoMatch => 'No disease matches the selected signs.';

  @override
  String diagnosisMatched(int matched, int total) {
    return 'Matching signs: $matched/$total';
  }

  @override
  String get diagnosisNotifiable => 'Notifiable';

  @override
  String get diagnosisDisclaimer =>
      'This is a first assessment; a vet or laboratory gives the final diagnosis.';

  @override
  String get diagnosisLoadError => 'Couldn\'t open the diagnosis table';

  @override
  String get diagnosisNotFound => 'Disease not found';

  @override
  String get diagnosisNotifiableTitle => 'Notifiable disease.';

  @override
  String get diagnosisNotifiableMessage =>
      'Report the suspicion to the authority; don\'t share this hive\'s equipment, frames or honey with other hives.';

  @override
  String get diagnosisAdvice => 'What to do';

  @override
  String get diagnosisAuthority => 'Authority';

  @override
  String diagnosisCall(String phone) {
    return 'Call $phone';
  }

  @override
  String get diagnosisCallFailed => 'Couldn\'t start the call';

  @override
  String get diagnosisQuarantine => 'Quarantine a hive';

  @override
  String get quarantinePickTitle => 'Hive to quarantine';

  @override
  String get quarantineSearchHint => 'Hive number';

  @override
  String get quarantineNoHivesTitle => 'No hives';

  @override
  String get quarantineNoHivesMessage => 'No active hive to quarantine.';

  @override
  String quarantineDone(String number) {
    return 'Hive $number quarantined';
  }

  @override
  String get hiveQuarantined => 'Quarantined';

  @override
  String hiveQuarantineDisease(String disease) {
    return 'Suspected: $disease';
  }

  @override
  String hiveQuarantineSince(String date) {
    return 'Since $date';
  }

  @override
  String get hiveQuarantineWarning =>
      'Don\'t share its equipment, frames or honey with other hives.';

  @override
  String get hiveQuarantineEnd => 'End quarantine';

  @override
  String hiveQuarantineEnded(String number) {
    return 'Hive $number is out of quarantine';
  }

  @override
  String get calculatorSyrup => 'Syrup';

  @override
  String get calculatorSyrupSubtitle => 'Sugar and water needed';

  @override
  String get calculatorDose => 'Treatment dose';

  @override
  String get calculatorDoseSubtitle => 'Total for your hive count';

  @override
  String get calculatorQueen => 'Queen calendar';

  @override
  String get calculatorQueenSubtitle => 'Step days from the grafting day';

  @override
  String get calculatorYield => 'Yield';

  @override
  String get calculatorYieldSubtitle => 'Honey per hive';

  @override
  String get calculatorOffline => 'Calculations work offline and save nothing.';

  @override
  String get calculatorNotFound => 'Calculator not found';

  @override
  String get calculatorHives => 'Number of hives';

  @override
  String get calculatorSyrupKind => 'Syrup type';

  @override
  String get calculatorFillHint => 'Enter the hive count and amount.';

  @override
  String get calculatorDosePerHive => 'Dose per hive';

  @override
  String get calculatorDoseUnit => 'Unit';

  @override
  String get calculatorTotal => 'Total';

  @override
  String calculatorDoseTotal(String unit, String total) {
    String _temp0 = intl.Intl.selectLogic(unit, {
      'strip': '$total strips',
      'ml': '$total ml',
      'g': '$total g',
      'other': '$total doses',
    });
    return '$_temp0';
  }

  @override
  String calculatorDoseCount(int count, String amount) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count hives × $amount',
      one: '1 hive × $amount',
    );
    return '$_temp0';
  }

  @override
  String calculatorYieldTotal(String unit) {
    return 'Total honey ($unit)';
  }

  @override
  String get calculatorYieldPerHive => 'Per hive';

  @override
  String calculatorYieldValue(String amount, String unit) {
    return '$amount $unit';
  }

  @override
  String get calculatorQueenSteps => 'Steps';

  @override
  String get hiveLossWintering => 'Wintering';

  @override
  String get hiveLossQueenless => 'Queenless';

  @override
  String get hiveLossVarroa => 'Varroa';

  @override
  String get hiveLossDisease => 'Disease';

  @override
  String get hiveLossStarvation => 'Starvation';

  @override
  String get hiveLossRobbing => 'Robbing';

  @override
  String get hiveLossPredator => 'Bear / animal';

  @override
  String get hiveLossPoisoning => 'Poisoning';

  @override
  String get hiveLossOther => 'Other';

  @override
  String get hiveLossUnspecified => 'Not specified';

  @override
  String hiveLossReasonTitle(String number) {
    return 'Why was hive $number lost?';
  }

  @override
  String get hiveLossSkip => 'Skip without a reason';

  @override
  String get hiveFormLossReason => 'Reason for the loss';

  @override
  String get hiveFormLossReasonHelper =>
      'Used in the season report; can be left empty.';

  @override
  String get seasonReportTile => 'Season report';

  @override
  String seasonTitle(String year) {
    return 'Season $year';
  }

  @override
  String get seasonPdf => 'PDF';

  @override
  String get seasonExportCsv => 'Export to Excel (CSV)';

  @override
  String get seasonExportError => 'The file could not be created. Try again.';

  @override
  String get seasonLoadError => 'The season report could not be loaded.';

  @override
  String get seasonHives => 'Hives';

  @override
  String seasonHiveChange(int start, int end) {
    return '$start → $end';
  }

  @override
  String seasonNetGain(int count) {
    return '+$count net';
  }

  @override
  String seasonNetLoss(int count) {
    return '−$count net';
  }

  @override
  String get seasonNetSame => 'No change';

  @override
  String get seasonWinterLoss => 'Winter loss';

  @override
  String get seasonWinterNotStarted => 'Winter has not started';

  @override
  String seasonPreviousWinter(String year) {
    return 'Winter loss $year';
  }

  @override
  String seasonPreviousWinterRate(String year, String rate) {
    return '$year: $rate';
  }

  @override
  String get seasonHoney => 'Total honey';

  @override
  String get seasonNewQueens => 'New queens';

  @override
  String seasonOwnReared(int count) {
    return 'own rearing $count';
  }

  @override
  String get seasonLossesTitle => 'Losses and causes';

  @override
  String get seasonNoLosses => 'No hives lost this season.';

  @override
  String seasonHiveCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count hives',
      one: '1 hive',
    );
    return '$_temp0';
  }

  @override
  String get seasonByTreatment => 'Winter loss · by treatment method';

  @override
  String get seasonByApiary => 'Winter loss · by apiary';

  @override
  String get seasonByQueenLine => 'Winter loss · by queen line';

  @override
  String get seasonTabTreatment => 'Treatment';

  @override
  String get seasonTabApiary => 'Apiary';

  @override
  String get seasonTabQueenLine => 'Queen line';

  @override
  String get seasonNoWinterData =>
      'No hives went into winter in your records yet.';

  @override
  String get seasonFewData => 'few data';

  @override
  String get seasonMisleadingNote =>
      'From your own records; may be misleading with few hives.';

  @override
  String get seasonUntreated => 'Not treated';

  @override
  String get seasonMethodSeparator => ' + ';

  @override
  String get seasonQueenLineUnknown => 'Unknown line';

  @override
  String get seasonFinanceTitle => 'Cost and profit';

  @override
  String get seasonProfit => 'Profit';

  @override
  String get seasonPdfFigure => 'Figure';

  @override
  String get seasonPdfValue => 'Value';

  @override
  String seasonPdfHiveChange(int start, int end, String net) {
    return '$start → $end ($net)';
  }

  @override
  String seasonPdfNewQueens(int count, int own) {
    return '$count (own rearing $own)';
  }

  @override
  String seasonPdfWinterLoss(String rate, int lost, int hives) {
    return '$rate ($lost of $hives hives)';
  }

  @override
  String get seasonPdfReason => 'Cause';

  @override
  String get seasonPdfHives => 'Hives';

  @override
  String get seasonPdfLost => 'Lost';

  @override
  String get seasonPdfRate => 'Loss';

  @override
  String get seasonPdfGroup => 'Group';

  @override
  String get seasonPdfTotal => 'Total';

  @override
  String get seasonCsvHive => 'Hive';

  @override
  String get seasonCsvApiary => 'Apiary';

  @override
  String get seasonCsvStartStatus => 'Status at season start';

  @override
  String get seasonCsvEndStatus => 'Status at season end';

  @override
  String get seasonCsvLossDate => 'Loss date';

  @override
  String get seasonCsvLossReason => 'Loss cause';

  @override
  String get seasonCsvInWinter => 'Went into winter';

  @override
  String get seasonCsvLostInWinter => 'Lost in winter';

  @override
  String get seasonCsvWinterApiary => 'Winter apiary';

  @override
  String get seasonCsvTreatment => 'Pre-winter treatment';

  @override
  String get seasonCsvQueenLine => 'Queen line';

  @override
  String get seasonCsvAddedInSeason => 'Added this season';

  @override
  String get seasonCsvYes => 'Yes';

  @override
  String get seasonCsvNo => 'No';

  @override
  String get offlineMapsTitle => 'Offline maps';

  @override
  String get offlineMapsIntro =>
      'Download the area around your apiaries; the map opens even without signal.';

  @override
  String offlineMapsMegabytes(String size) {
    return '$size MB';
  }

  @override
  String offlineMapsApproxSize(String size) {
    return '≈ $size';
  }

  @override
  String offlineMapsDownloaded(String size) {
    return 'Downloaded · $size';
  }

  @override
  String offlineMapsDownloadingWifi(String received, String total) {
    return 'Downloading on Wi‑Fi · $received / $total';
  }

  @override
  String offlineMapsDownloading(String received, String total) {
    return 'Downloading · $received / $total';
  }

  @override
  String offlineMapsDownload(String name) {
    return 'Download $name';
  }

  @override
  String get offlineMapsCancel => 'Stop download';

  @override
  String offlineMapsDelete(String name) {
    return 'Delete $name';
  }

  @override
  String offlineMapsDeleteTitle(String name) {
    return 'Delete $name?';
  }

  @override
  String get offlineMapsDeleteMessage =>
      'Without internet, the map around this apiary won\'t open. You can download it again any time.';

  @override
  String get offlineMapsDeleteConfirm => 'Delete';

  @override
  String get offlineMapsWifiOnly => 'Download on Wi‑Fi only';

  @override
  String get offlineMapsWifiOnlyHint =>
      'A few MB per apiary; no mobile data is used.';

  @override
  String offlineMapsStop(String name) {
    return '$name stop';
  }

  @override
  String offlineMapsDone(String name) {
    return 'Area around $name downloaded';
  }

  @override
  String offlineMapsFailed(String name) {
    return 'Couldn\'t download the area around $name. Check your connection and try again.';
  }

  @override
  String get offlineMapsNeedsWifi =>
      'Connect to Wi‑Fi or turn off \"Download on Wi‑Fi only\".';

  @override
  String get offlineMapsAttribution =>
      'Map data © OpenStreetMap contributors · OpenFreeMap';

  @override
  String get settingsOfflineMaps => 'Offline maps';

  @override
  String settingsOfflineMapsValue(int count, String size) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count apiaries · $size',
      one: '1 apiary · $size',
      zero: 'None',
    );
    return '$_temp0';
  }

  @override
  String get offlineMapsCoverage =>
      'Each apiary gets 6 km around it in detail and 40 km as an overview.';

  @override
  String offlineMapsDownloadedOn(String date) {
    return 'downloaded: $date';
  }

  @override
  String get offlineMapsToDownload => 'Apiaries to download';

  @override
  String get offlineMapsMoved => 'Apiary moved, download again';

  @override
  String get offlineMapsNoApiaries =>
      'No apiaries with a location. Add a location to an apiary and it shows up here.';

  @override
  String get offlineMapsAllDownloaded =>
      'All apiaries with a location are downloaded.';
}
