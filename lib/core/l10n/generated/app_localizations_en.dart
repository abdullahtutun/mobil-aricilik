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
  String get hiveQueenPlaceholder =>
      'No queen recorded yet. Queen cards are coming soon.';

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
  String get moreEmptyTitle => 'More modules on the way';

  @override
  String get moreEmptyMessage =>
      'Queens, harvest, stock, finance, documents and the knowledge base will live here.';

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
}
