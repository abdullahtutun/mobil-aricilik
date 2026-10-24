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

  /// Order of the hives in an apiary: lowest strength score first, unscored hives last.
  ///
  /// In en, this message translates to:
  /// **'Weakest first'**
  String get hiveSortWeakestFirst;

  /// No description provided for @hivesEmptyTitle.
  ///
  /// In en, this message translates to:
  /// **'No hives yet'**
  String get hivesEmptyTitle;

  /// No description provided for @hivesEmptyMessage.
  ///
  /// In en, this message translates to:
  /// **'Add the hives standing in this apiary; you can create many at once.'**
  String get hivesEmptyMessage;

  /// No description provided for @hivesAdd.
  ///
  /// In en, this message translates to:
  /// **'Add hives'**
  String get hivesAdd;

  /// No description provided for @hivesAddOne.
  ///
  /// In en, this message translates to:
  /// **'One hive'**
  String get hivesAddOne;

  /// No description provided for @hivesAddOneHint.
  ///
  /// In en, this message translates to:
  /// **'Enter its number, type and source'**
  String get hivesAddOneHint;

  /// No description provided for @hivesAddBulk.
  ///
  /// In en, this message translates to:
  /// **'Many at once'**
  String get hivesAddBulk;

  /// No description provided for @hivesAddBulkHint.
  ///
  /// In en, this message translates to:
  /// **'e.g. 20 hives starting at 101'**
  String get hivesAddBulkHint;

  /// Heading above the dead, merged, sold and lost hives of an apiary.
  ///
  /// In en, this message translates to:
  /// **'Not active ({count})'**
  String hivesInactiveTitle(int count);

  /// No description provided for @hivesLoadError.
  ///
  /// In en, this message translates to:
  /// **'Couldn\'t read the hives.'**
  String get hivesLoadError;

  /// A hive named by its number, in messages and dialogs.
  ///
  /// In en, this message translates to:
  /// **'Hive {number}'**
  String hiveLabel(String number);

  /// Second line of a hive on the hive list.
  ///
  /// In en, this message translates to:
  /// **'{type} · {source}'**
  String hiveTypeAndSource(String type, String source);

  /// No description provided for @hiveTypeLangstroth.
  ///
  /// In en, this message translates to:
  /// **'Langstroth'**
  String get hiveTypeLangstroth;

  /// No description provided for @hiveTypeDadant.
  ///
  /// In en, this message translates to:
  /// **'Dadant'**
  String get hiveTypeDadant;

  /// No description provided for @hiveTypeLocal.
  ///
  /// In en, this message translates to:
  /// **'Local'**
  String get hiveTypeLocal;

  /// No description provided for @hiveTypeOther.
  ///
  /// In en, this message translates to:
  /// **'Other'**
  String get hiveTypeOther;

  /// No description provided for @hiveStatusActive.
  ///
  /// In en, this message translates to:
  /// **'Active'**
  String get hiveStatusActive;

  /// No description provided for @hiveStatusDead.
  ///
  /// In en, this message translates to:
  /// **'Dead'**
  String get hiveStatusDead;

  /// No description provided for @hiveStatusMerged.
  ///
  /// In en, this message translates to:
  /// **'Merged'**
  String get hiveStatusMerged;

  /// No description provided for @hiveStatusSold.
  ///
  /// In en, this message translates to:
  /// **'Sold'**
  String get hiveStatusSold;

  /// Hive status: stolen, destroyed by animals or otherwise gone.
  ///
  /// In en, this message translates to:
  /// **'Lost'**
  String get hiveStatusLost;

  /// No description provided for @hiveSourceSwarm.
  ///
  /// In en, this message translates to:
  /// **'Swarm'**
  String get hiveSourceSwarm;

  /// No description provided for @hiveSourceSplit.
  ///
  /// In en, this message translates to:
  /// **'Split'**
  String get hiveSourceSplit;

  /// No description provided for @hiveSourcePurchase.
  ///
  /// In en, this message translates to:
  /// **'Bought'**
  String get hiveSourcePurchase;

  /// No description provided for @hiveSourcePackage.
  ///
  /// In en, this message translates to:
  /// **'Package bees'**
  String get hiveSourcePackage;

  /// No description provided for @hiveFormNewTitle.
  ///
  /// In en, this message translates to:
  /// **'New hive'**
  String get hiveFormNewTitle;

  /// No description provided for @hiveFormEditTitle.
  ///
  /// In en, this message translates to:
  /// **'Edit hive'**
  String get hiveFormEditTitle;

  /// No description provided for @hiveFormNumber.
  ///
  /// In en, this message translates to:
  /// **'Hive number'**
  String get hiveFormNumber;

  /// No description provided for @hiveFormNumberHint.
  ///
  /// In en, this message translates to:
  /// **'e.g. 101'**
  String get hiveFormNumberHint;

  /// No description provided for @hiveFormType.
  ///
  /// In en, this message translates to:
  /// **'Hive type'**
  String get hiveFormType;

  /// No description provided for @hiveFormStatus.
  ///
  /// In en, this message translates to:
  /// **'Status'**
  String get hiveFormStatus;

  /// No description provided for @hiveFormSource.
  ///
  /// In en, this message translates to:
  /// **'Source'**
  String get hiveFormSource;

  /// No description provided for @hiveFormSave.
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get hiveFormSave;

  /// No description provided for @hiveBulkTitle.
  ///
  /// In en, this message translates to:
  /// **'Create many hives'**
  String get hiveBulkTitle;

  /// No description provided for @hiveBulkCount.
  ///
  /// In en, this message translates to:
  /// **'How many hives'**
  String get hiveBulkCount;

  /// No description provided for @hiveBulkCountHint.
  ///
  /// In en, this message translates to:
  /// **'e.g. 20'**
  String get hiveBulkCountHint;

  /// No description provided for @hiveBulkCountTooMany.
  ///
  /// In en, this message translates to:
  /// **'At most {max} at once'**
  String hiveBulkCountTooMany(int max);

  /// No description provided for @hiveBulkStart.
  ///
  /// In en, this message translates to:
  /// **'First number'**
  String get hiveBulkStart;

  /// No description provided for @hiveBulkStartHint.
  ///
  /// In en, this message translates to:
  /// **'e.g. 101'**
  String get hiveBulkStartHint;

  /// Summary of the hives about to be created in bulk.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{Hive {first} will be created.} other{{count} hives will be created: {first} to {last}.}}'**
  String hiveBulkPreview(int count, String first, String last);

  /// No description provided for @hiveBulkSave.
  ///
  /// In en, this message translates to:
  /// **'Create hives'**
  String get hiveBulkSave;

  /// No description provided for @hiveBulkCreated.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{1 hive created} other{{count} hives created}}'**
  String hiveBulkCreated(int count);

  /// No description provided for @hiveNotFoundTitle.
  ///
  /// In en, this message translates to:
  /// **'Hive not found'**
  String get hiveNotFoundTitle;

  /// No description provided for @hiveNotFoundMessage.
  ///
  /// In en, this message translates to:
  /// **'It may have been deleted or not reached this device yet.'**
  String get hiveNotFoundMessage;

  /// No description provided for @hiveEdit.
  ///
  /// In en, this message translates to:
  /// **'Edit'**
  String get hiveEdit;

  /// Screen reader text for the apiary under the big hive number.
  ///
  /// In en, this message translates to:
  /// **'Apiary: {name}'**
  String hiveCardApiary(String name);

  /// No description provided for @hiveQueenTitle.
  ///
  /// In en, this message translates to:
  /// **'Queen'**
  String get hiveQueenTitle;

  /// No description provided for @hiveQueenPlaceholder.
  ///
  /// In en, this message translates to:
  /// **'No queen recorded yet. Queen cards are coming soon.'**
  String get hiveQueenPlaceholder;

  /// On the hive card when there's no inspection, or the last one has no count of frames with bees.
  ///
  /// In en, this message translates to:
  /// **'No strength score yet'**
  String get hiveStrengthNone;

  /// No description provided for @hiveTimelineTitle.
  ///
  /// In en, this message translates to:
  /// **'History'**
  String get hiveTimelineTitle;

  /// No description provided for @timelineInspection.
  ///
  /// In en, this message translates to:
  /// **'Inspection'**
  String get timelineInspection;

  /// History entry for the apiary a hive was first placed in; the apiary name is on the next line.
  ///
  /// In en, this message translates to:
  /// **'Added to apiary'**
  String get timelineAdded;

  /// No description provided for @timelineMoved.
  ///
  /// In en, this message translates to:
  /// **'Moved'**
  String get timelineMoved;

  /// Apiaries a hive was moved from and to.
  ///
  /// In en, this message translates to:
  /// **'{from} → {to}'**
  String timelineMoveRoute(String from, String to);

  /// Apiary name in the hive history when the apiary was deleted or hasn't reached this phone.
  ///
  /// In en, this message translates to:
  /// **'Unknown apiary'**
  String get timelineUnknownApiary;

  /// A recorded inspection field in the hive history, e.g. "Queen: Seen".
  ///
  /// In en, this message translates to:
  /// **'{label}: {value}'**
  String timelineField(String label, String value);

  /// No description provided for @timelineBeeFrames.
  ///
  /// In en, this message translates to:
  /// **'{count} with bees'**
  String timelineBeeFrames(int count);

  /// No description provided for @timelineBroodFrames.
  ///
  /// In en, this message translates to:
  /// **'{count} with brood'**
  String timelineBroodFrames(int count);

  /// No description provided for @timelineHoneyFrames.
  ///
  /// In en, this message translates to:
  /// **'{count} with honey'**
  String timelineHoneyFrames(int count);

  /// Label for the actions recorded in a past inspection, e.g. "Done: Fed, Super added".
  ///
  /// In en, this message translates to:
  /// **'Done'**
  String get timelineActions;

  /// No description provided for @hiveMove.
  ///
  /// In en, this message translates to:
  /// **'Move to another apiary'**
  String get hiveMove;

  /// Heading of the list of apiaries a hive can be moved to.
  ///
  /// In en, this message translates to:
  /// **'Move hive {number} to'**
  String hiveMoveTitle(String number);

  /// No description provided for @hiveMoveNoOtherApiary.
  ///
  /// In en, this message translates to:
  /// **'There\'s no other apiary to move it to. Add one from the Apiaries tab first.'**
  String get hiveMoveNoOtherApiary;

  /// No description provided for @hiveMoved.
  ///
  /// In en, this message translates to:
  /// **'Hive {number} moved to {apiary}'**
  String hiveMoved(String number, String apiary);

  /// No description provided for @hiveChangeStatus.
  ///
  /// In en, this message translates to:
  /// **'Change status'**
  String get hiveChangeStatus;

  /// No description provided for @hiveStatusSheetTitle.
  ///
  /// In en, this message translates to:
  /// **'New status for hive {number}'**
  String hiveStatusSheetTitle(String number);

  /// Asked before a hive stops counting as active. status is the server value: dead, merged, sold or lost.
  ///
  /// In en, this message translates to:
  /// **'{status, select, dead{Record hive {number} as dead?} merged{Record hive {number} as merged?} sold{Record hive {number} as sold?} other{Record hive {number} as lost?}}'**
  String hiveStatusConfirmTitle(String status, String number);

  /// No description provided for @hiveStatusConfirmMessage.
  ///
  /// In en, this message translates to:
  /// **'It will no longer count among the apiary\'s active hives. You can make it active again later.'**
  String get hiveStatusConfirmMessage;

  /// No description provided for @hiveStatusConfirm.
  ///
  /// In en, this message translates to:
  /// **'Yes, record'**
  String get hiveStatusConfirm;

  /// Shown with an Undo button after a hive's status changes.
  ///
  /// In en, this message translates to:
  /// **'Hive {number}: {status}'**
  String hiveStatusChanged(String number, String status);

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

  /// No description provided for @scanHint.
  ///
  /// In en, this message translates to:
  /// **'Fit the code on the hive label inside the frame.'**
  String get scanHint;

  /// No description provided for @scanAgain.
  ///
  /// In en, this message translates to:
  /// **'Scan again'**
  String get scanAgain;

  /// No description provided for @cameraErrorTitle.
  ///
  /// In en, this message translates to:
  /// **'Couldn\'t open the camera'**
  String get cameraErrorTitle;

  /// No description provided for @cameraErrorPermissionDenied.
  ///
  /// In en, this message translates to:
  /// **'Camera permission wasn\'t given. To scan labels, allow the camera for this app in Settings.'**
  String get cameraErrorPermissionDenied;

  /// No description provided for @cameraErrorUnsupported.
  ///
  /// In en, this message translates to:
  /// **'This device has no camera that can scan.'**
  String get cameraErrorUnsupported;

  /// No description provided for @cameraErrorUnknown.
  ///
  /// In en, this message translates to:
  /// **'Close this screen and try again.'**
  String get cameraErrorUnknown;

  /// Shown after scanning a code that is neither a Mobil Arıcı hive label nor a label assigned to a hive.
  ///
  /// In en, this message translates to:
  /// **'This code isn\'t linked to a hive'**
  String get labelUnknownTitle;

  /// No description provided for @labelUnknownMessage.
  ///
  /// In en, this message translates to:
  /// **'It isn\'t a Mobil Arıcı label, or it hasn\'t been assigned to a hive yet. If it\'s on a hive, assign it; scanning it will then open the hive card.'**
  String get labelUnknownMessage;

  /// Shown after scanning a Mobil Arıcı hive label whose hive isn't on this phone.
  ///
  /// In en, this message translates to:
  /// **'This label\'s hive wasn\'t found'**
  String get labelUnknownOwnTitle;

  /// No description provided for @labelUnknownOwnMessage.
  ///
  /// In en, this message translates to:
  /// **'The hive may have been deleted or not reached this phone yet. You can also assign the label to another hive.'**
  String get labelUnknownOwnMessage;

  /// The raw content of the scanned code.
  ///
  /// In en, this message translates to:
  /// **'Code: {code}'**
  String labelCode(String code);

  /// No description provided for @labelAssign.
  ///
  /// In en, this message translates to:
  /// **'Assign to a hive'**
  String get labelAssign;

  /// No description provided for @labelAssignTitle.
  ///
  /// In en, this message translates to:
  /// **'Assign label to a hive'**
  String get labelAssignTitle;

  /// No description provided for @labelAssignMessage.
  ///
  /// In en, this message translates to:
  /// **'Pick the hive the label is on. Scanning the label will then open that hive\'s card.'**
  String get labelAssignMessage;

  /// No description provided for @labelAssignSearch.
  ///
  /// In en, this message translates to:
  /// **'Hive number'**
  String get labelAssignSearch;

  /// No description provided for @labelAssignNoMatch.
  ///
  /// In en, this message translates to:
  /// **'No hive matches your search.'**
  String get labelAssignNoMatch;

  /// No description provided for @labelAssignNoHives.
  ///
  /// In en, this message translates to:
  /// **'No hives yet. Add hives from the Apiaries tab first.'**
  String get labelAssignNoHives;

  /// No description provided for @labelAssignHasOther.
  ///
  /// In en, this message translates to:
  /// **'Has another label'**
  String get labelAssignHasOther;

  /// No description provided for @labelReplaceTitle.
  ///
  /// In en, this message translates to:
  /// **'Replace the label of hive {number}?'**
  String labelReplaceTitle(String number);

  /// No description provided for @labelReplaceMessage.
  ///
  /// In en, this message translates to:
  /// **'This hive already has a label. The new one replaces it; the old label will no longer open this hive.'**
  String get labelReplaceMessage;

  /// No description provided for @labelReplaceConfirm.
  ///
  /// In en, this message translates to:
  /// **'Yes, replace'**
  String get labelReplaceConfirm;

  /// No description provided for @labelAssigned.
  ///
  /// In en, this message translates to:
  /// **'Label assigned: hive {number}'**
  String labelAssigned(String number);

  /// Screen for choosing hives and printing their QR labels on A4 label sheets; also the tooltip of the button opening it.
  ///
  /// In en, this message translates to:
  /// **'Print labels'**
  String get hiveLabelsTitle;

  /// No description provided for @hiveLabelsMessage.
  ///
  /// In en, this message translates to:
  /// **'Pick the hives to print labels for. An A4 page holds 24 labels (70 × 37 mm); print at 100% scale.'**
  String get hiveLabelsMessage;

  /// No description provided for @hiveLabelsNoHives.
  ///
  /// In en, this message translates to:
  /// **'This apiary has no hives to print labels for.'**
  String get hiveLabelsNoHives;

  /// No description provided for @hiveLabelsSelectAll.
  ///
  /// In en, this message translates to:
  /// **'Select all'**
  String get hiveLabelsSelectAll;

  /// No description provided for @hiveLabelsSelectNone.
  ///
  /// In en, this message translates to:
  /// **'Select none'**
  String get hiveLabelsSelectNone;

  /// No description provided for @hiveLabelsNoneSelected.
  ///
  /// In en, this message translates to:
  /// **'No hives selected'**
  String get hiveLabelsNoneSelected;

  /// No description provided for @hiveLabelsCount.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{1 label} other{{count} labels}}'**
  String hiveLabelsCount(int count);

  /// No description provided for @hiveLabelsPages.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{1 page} other{{count} pages}}'**
  String hiveLabelsPages(int count);

  /// Number of labels and pages to print, e.g. '20 labels · 1 page'.
  ///
  /// In en, this message translates to:
  /// **'{labels} · {pages}'**
  String hiveLabelsSummary(String labels, String pages);

  /// No description provided for @hiveLabelsPreparing.
  ///
  /// In en, this message translates to:
  /// **'Preparing the PDF…'**
  String get hiveLabelsPreparing;

  /// No description provided for @hiveLabelsPrint.
  ///
  /// In en, this message translates to:
  /// **'Print'**
  String get hiveLabelsPrint;

  /// No description provided for @hiveLabelsShare.
  ///
  /// In en, this message translates to:
  /// **'Share PDF'**
  String get hiveLabelsShare;

  /// Title of the label PDF; also its file name when shared.
  ///
  /// In en, this message translates to:
  /// **'Hive labels - {apiary}'**
  String hiveLabelsDocumentName(String apiary);

  /// No description provided for @hiveLabelsError.
  ///
  /// In en, this message translates to:
  /// **'Couldn\'t prepare the PDF. Try again.'**
  String get hiveLabelsError;

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

  /// No description provided for @actionUndo.
  ///
  /// In en, this message translates to:
  /// **'Undo'**
  String get actionUndo;

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

  /// No description provided for @galleryStrengthDots.
  ///
  /// In en, this message translates to:
  /// **'Strength dots'**
  String get galleryStrengthDots;

  /// No description provided for @galleryTimelineTile.
  ///
  /// In en, this message translates to:
  /// **'Timeline row'**
  String get galleryTimelineTile;

  /// Sample apiary name in the component gallery.
  ///
  /// In en, this message translates to:
  /// **'Hilltop'**
  String get gallerySampleApiaryHill;

  /// Sample apiary name in the component gallery.
  ///
  /// In en, this message translates to:
  /// **'Riverside'**
  String get gallerySampleApiaryPlain;

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

  /// No description provided for @gallerySnackBar.
  ///
  /// In en, this message translates to:
  /// **'Snackbar'**
  String get gallerySnackBar;

  /// No description provided for @galleryCriticalLockCard.
  ///
  /// In en, this message translates to:
  /// **'Critical lock card'**
  String get galleryCriticalLockCard;

  /// No description provided for @gallerySampleInspectionSaved.
  ///
  /// In en, this message translates to:
  /// **'Inspection saved'**
  String get gallerySampleInspectionSaved;

  /// No description provided for @gallerySampleWithdrawalTitle.
  ///
  /// In en, this message translates to:
  /// **'In withdrawal period.'**
  String get gallerySampleWithdrawalTitle;

  /// No description provided for @gallerySampleWithdrawalMessage.
  ///
  /// In en, this message translates to:
  /// **'Don\'t add a honey super to this hive for 12 more days.'**
  String get gallerySampleWithdrawalMessage;

  /// Sync icon in the app bar: every local record has reached the server.
  ///
  /// In en, this message translates to:
  /// **'Synced'**
  String get syncStatusSynced;

  /// Sync icon in the app bar: records waiting to be sent (e.g. offline).
  ///
  /// In en, this message translates to:
  /// **'{count} pending'**
  String syncStatusPending(int count);

  /// Sync icon in the app bar: the server rejected a record or the last sync failed.
  ///
  /// In en, this message translates to:
  /// **'Error'**
  String get syncStatusError;

  /// Screen reader label of the sync icon in the app bar.
  ///
  /// In en, this message translates to:
  /// **'Sync: {status}'**
  String syncStatusSemantics(String status);

  /// No description provided for @syncTitle.
  ///
  /// In en, this message translates to:
  /// **'Sync'**
  String get syncTitle;

  /// No description provided for @syncSyncedMessage.
  ///
  /// In en, this message translates to:
  /// **'Every record on this phone has reached the server.'**
  String get syncSyncedMessage;

  /// No description provided for @syncPendingMessage.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{1 record is waiting to be sent.} other{{count} records are waiting to be sent.}}'**
  String syncPendingMessage(int count);

  /// No description provided for @syncProblemOffline.
  ///
  /// In en, this message translates to:
  /// **'Couldn\'t reach the server. Sync will try again when you\'re back online.'**
  String get syncProblemOffline;

  /// No description provided for @syncProblemFailed.
  ///
  /// In en, this message translates to:
  /// **'Sync couldn\'t finish. Try again a little later.'**
  String get syncProblemFailed;

  /// No description provided for @syncProblemUpgrade.
  ///
  /// In en, this message translates to:
  /// **'This version can no longer sync. Update the app.'**
  String get syncProblemUpgrade;

  /// No description provided for @syncLastSynced.
  ///
  /// In en, this message translates to:
  /// **'Last synced {time}'**
  String syncLastSynced(String time);

  /// No description provided for @syncNow.
  ///
  /// In en, this message translates to:
  /// **'Sync now'**
  String get syncNow;

  /// No description provided for @syncRunning.
  ///
  /// In en, this message translates to:
  /// **'Syncing…'**
  String get syncRunning;

  /// No description provided for @syncRejectedTitle.
  ///
  /// In en, this message translates to:
  /// **'Couldn\'t be sent ({count})'**
  String syncRejectedTitle(int count);

  /// No description provided for @syncRejectedMessage.
  ///
  /// In en, this message translates to:
  /// **'The server didn\'t accept these records. Everything else keeps syncing.'**
  String get syncRejectedMessage;

  /// No description provided for @syncRejectedSubtitle.
  ///
  /// In en, this message translates to:
  /// **'{reason} · {date}'**
  String syncRejectedSubtitle(String reason, String date);

  /// No description provided for @syncRejectionForbidden.
  ///
  /// In en, this message translates to:
  /// **'You aren\'t allowed to change this record'**
  String get syncRejectionForbidden;

  /// No description provided for @syncRejectionConflict.
  ///
  /// In en, this message translates to:
  /// **'Conflicts with another record (e.g. the same label)'**
  String get syncRejectionConflict;

  /// No description provided for @syncRejectionMissingReference.
  ///
  /// In en, this message translates to:
  /// **'A record it belongs to is missing on the server'**
  String get syncRejectionMissingReference;

  /// No description provided for @syncRejectionUnsupported.
  ///
  /// In en, this message translates to:
  /// **'This kind of record isn\'t synced'**
  String get syncRejectionUnsupported;

  /// No description provided for @syncRejectionInvalid.
  ///
  /// In en, this message translates to:
  /// **'The record has invalid data'**
  String get syncRejectionInvalid;

  /// No description provided for @syncRejectionUnknown.
  ///
  /// In en, this message translates to:
  /// **'Unknown reason'**
  String get syncRejectionUnknown;

  /// Kind of a record that couldn't be sent.
  ///
  /// In en, this message translates to:
  /// **'Business'**
  String get syncTableOrganizations;

  /// No description provided for @syncTableMemberships.
  ///
  /// In en, this message translates to:
  /// **'Membership'**
  String get syncTableMemberships;

  /// No description provided for @syncTableApiaries.
  ///
  /// In en, this message translates to:
  /// **'Apiary'**
  String get syncTableApiaries;

  /// No description provided for @syncTableQueens.
  ///
  /// In en, this message translates to:
  /// **'Queen'**
  String get syncTableQueens;

  /// No description provided for @syncTableHives.
  ///
  /// In en, this message translates to:
  /// **'Hive'**
  String get syncTableHives;

  /// No description provided for @syncTableHiveLocationHistory.
  ///
  /// In en, this message translates to:
  /// **'Hive move'**
  String get syncTableHiveLocationHistory;

  /// No description provided for @initialSyncTitle.
  ///
  /// In en, this message translates to:
  /// **'Downloading your records'**
  String get initialSyncTitle;

  /// No description provided for @initialSyncMessage.
  ///
  /// In en, this message translates to:
  /// **'Your business\'s records are being downloaded to this phone. This happens only once; after that the app works without internet too.'**
  String get initialSyncMessage;

  /// No description provided for @initialSyncRows.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{1 record downloaded} other{{count} records downloaded}}'**
  String initialSyncRows(int count);

  /// No description provided for @initialSyncFailedTitle.
  ///
  /// In en, this message translates to:
  /// **'Download couldn\'t finish'**
  String get initialSyncFailedTitle;

  /// Caption and screen reader hint of a value suggested from the previous record (shown faded).
  ///
  /// In en, this message translates to:
  /// **'From the last record'**
  String get suggestedValue;

  /// Screen reader value of a stepper that has no value yet.
  ///
  /// In en, this message translates to:
  /// **'Not set'**
  String get stepperNoValue;

  /// No description provided for @hiveStartInspection.
  ///
  /// In en, this message translates to:
  /// **'Start inspection'**
  String get hiveStartInspection;

  /// No description provided for @inspectionTitle.
  ///
  /// In en, this message translates to:
  /// **'Inspect hive {number}'**
  String inspectionTitle(String number);

  /// No description provided for @inspectionPrevious.
  ///
  /// In en, this message translates to:
  /// **'Last inspection {date}'**
  String inspectionPrevious(String date);

  /// No description provided for @inspectionFirst.
  ///
  /// In en, this message translates to:
  /// **'First inspection'**
  String get inspectionFirst;

  /// No description provided for @inspectionSuggestedLegend.
  ///
  /// In en, this message translates to:
  /// **'Faded values are from the last inspection. Change what\'s different; the rest is saved as it is.'**
  String get inspectionSuggestedLegend;

  /// No description provided for @inspectionDraftSaved.
  ///
  /// In en, this message translates to:
  /// **'Kept as a draft on this phone'**
  String get inspectionDraftSaved;

  /// No description provided for @inspectionRestart.
  ///
  /// In en, this message translates to:
  /// **'Start over'**
  String get inspectionRestart;

  /// No description provided for @inspectionQueen.
  ///
  /// In en, this message translates to:
  /// **'Queen'**
  String get inspectionQueen;

  /// No description provided for @queenStateSeen.
  ///
  /// In en, this message translates to:
  /// **'Seen'**
  String get queenStateSeen;

  /// No description provided for @queenStateEggs.
  ///
  /// In en, this message translates to:
  /// **'Eggs seen'**
  String get queenStateEggs;

  /// No description provided for @queenStateNone.
  ///
  /// In en, this message translates to:
  /// **'None'**
  String get queenStateNone;

  /// No description provided for @inspectionFrames.
  ///
  /// In en, this message translates to:
  /// **'Frames'**
  String get inspectionFrames;

  /// No description provided for @inspectionBeeFrames.
  ///
  /// In en, this message translates to:
  /// **'With bees'**
  String get inspectionBeeFrames;

  /// No description provided for @inspectionBroodFrames.
  ///
  /// In en, this message translates to:
  /// **'With brood'**
  String get inspectionBroodFrames;

  /// No description provided for @inspectionHoneyFrames.
  ///
  /// In en, this message translates to:
  /// **'With honey'**
  String get inspectionHoneyFrames;

  /// No description provided for @inspectionTemperament.
  ///
  /// In en, this message translates to:
  /// **'Temperament'**
  String get inspectionTemperament;

  /// No description provided for @temperamentCalm.
  ///
  /// In en, this message translates to:
  /// **'Calm'**
  String get temperamentCalm;

  /// No description provided for @temperamentNervous.
  ///
  /// In en, this message translates to:
  /// **'Nervous'**
  String get temperamentNervous;

  /// No description provided for @inspectionSwarmSigns.
  ///
  /// In en, this message translates to:
  /// **'Swarm signs'**
  String get inspectionSwarmSigns;

  /// No description provided for @inspectionQueenCells.
  ///
  /// In en, this message translates to:
  /// **'Queen cells'**
  String get inspectionQueenCells;

  /// No description provided for @queenCellsNone.
  ///
  /// In en, this message translates to:
  /// **'None'**
  String get queenCellsNone;

  /// No description provided for @queenCellsSwarm.
  ///
  /// In en, this message translates to:
  /// **'Swarm'**
  String get queenCellsSwarm;

  /// No description provided for @queenCellsSupersedure.
  ///
  /// In en, this message translates to:
  /// **'Supersedure'**
  String get queenCellsSupersedure;

  /// No description provided for @queenCellsEmergency.
  ///
  /// In en, this message translates to:
  /// **'Emergency'**
  String get queenCellsEmergency;

  /// No description provided for @inspectionDisease.
  ///
  /// In en, this message translates to:
  /// **'Disease suspected'**
  String get inspectionDisease;

  /// Answer to swarm signs or disease suspicion.
  ///
  /// In en, this message translates to:
  /// **'No'**
  String get inspectionAnswerNo;

  /// No description provided for @inspectionAnswerYes.
  ///
  /// In en, this message translates to:
  /// **'Yes'**
  String get inspectionAnswerYes;

  /// No description provided for @inspectionActions.
  ///
  /// In en, this message translates to:
  /// **'Done today'**
  String get inspectionActions;

  /// No description provided for @inspectionActionSuperAdded.
  ///
  /// In en, this message translates to:
  /// **'Super added'**
  String get inspectionActionSuperAdded;

  /// No description provided for @inspectionActionSuperRemoved.
  ///
  /// In en, this message translates to:
  /// **'Super removed'**
  String get inspectionActionSuperRemoved;

  /// No description provided for @inspectionActionFramesAdded.
  ///
  /// In en, this message translates to:
  /// **'Frames added'**
  String get inspectionActionFramesAdded;

  /// No description provided for @inspectionActionFoundationAdded.
  ///
  /// In en, this message translates to:
  /// **'Foundation given'**
  String get inspectionActionFoundationAdded;

  /// No description provided for @inspectionActionFed.
  ///
  /// In en, this message translates to:
  /// **'Fed'**
  String get inspectionActionFed;

  /// No description provided for @inspectionActionExcluderFitted.
  ///
  /// In en, this message translates to:
  /// **'Excluder fitted'**
  String get inspectionActionExcluderFitted;

  /// No description provided for @inspectionActionEntranceReduced.
  ///
  /// In en, this message translates to:
  /// **'Entrance reduced'**
  String get inspectionActionEntranceReduced;

  /// No description provided for @inspectionActionPollenTrapFitted.
  ///
  /// In en, this message translates to:
  /// **'Pollen trap fitted'**
  String get inspectionActionPollenTrapFitted;

  /// No description provided for @inspectionSave.
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get inspectionSave;

  /// No description provided for @inspectionSaved.
  ///
  /// In en, this message translates to:
  /// **'Hive {number} inspection saved'**
  String inspectionSaved(String number);

  /// No description provided for @inspectionRemindPrompt.
  ///
  /// In en, this message translates to:
  /// **'Remind in'**
  String get inspectionRemindPrompt;

  /// No description provided for @inspectionRemindDays.
  ///
  /// In en, this message translates to:
  /// **'{days, plural, =1{1 day} other{{days} days}}'**
  String inspectionRemindDays(int days);

  /// No description provided for @inspectionLoadError.
  ///
  /// In en, this message translates to:
  /// **'The inspection couldn\'t be opened'**
  String get inspectionLoadError;

  /// No description provided for @syncTableInspections.
  ///
  /// In en, this message translates to:
  /// **'Inspection'**
  String get syncTableInspections;

  /// No description provided for @signInTagline.
  ///
  /// In en, this message translates to:
  /// **'Your apiary notebook, in your pocket. Works without internet.'**
  String get signInTagline;

  /// No description provided for @signInEmailLabelLong.
  ///
  /// In en, this message translates to:
  /// **'Your email address'**
  String get signInEmailLabelLong;

  /// No description provided for @signInEmailHelper.
  ///
  /// In en, this message translates to:
  /// **'No password. We\'ll send a 6-digit code to your address.'**
  String get signInEmailHelper;

  /// No description provided for @signInEmailHint.
  ///
  /// In en, this message translates to:
  /// **'name@example.com'**
  String get signInEmailHint;

  /// No description provided for @signInCodeHeading.
  ///
  /// In en, this message translates to:
  /// **'Enter the code from your email'**
  String get signInCodeHeading;

  /// No description provided for @signInPasteCode.
  ///
  /// In en, this message translates to:
  /// **'Paste code'**
  String get signInPasteCode;

  /// No description provided for @signInCodeSpamHint.
  ///
  /// In en, this message translates to:
  /// **'Not there? Check your spam folder. After signing in once, the app opens without internet too.'**
  String get signInCodeSpamHint;

  /// No description provided for @signInChangeEmail.
  ///
  /// In en, this message translates to:
  /// **'Change email'**
  String get signInChangeEmail;

  /// No description provided for @onboardingLanguageCountryTitle.
  ///
  /// In en, this message translates to:
  /// **'Language and country'**
  String get onboardingLanguageCountryTitle;

  /// No description provided for @onboardingAppLanguage.
  ///
  /// In en, this message translates to:
  /// **'App language'**
  String get onboardingAppLanguage;

  /// No description provided for @onboardingDeviceLanguage.
  ///
  /// In en, this message translates to:
  /// **'Device language'**
  String get onboardingDeviceLanguage;

  /// No description provided for @onboardingCountryLabel.
  ///
  /// In en, this message translates to:
  /// **'Country you keep bees in'**
  String get onboardingCountryLabel;

  /// No description provided for @onboardingCountryChoose.
  ///
  /// In en, this message translates to:
  /// **'Choose a country'**
  String get onboardingCountryChoose;

  /// No description provided for @onboardingRegionFeaturesTitle.
  ///
  /// In en, this message translates to:
  /// **'Turned on for {country}'**
  String onboardingRegionFeaturesTitle(String country);

  /// No description provided for @onboardingRegionDefaultsTitle.
  ///
  /// In en, this message translates to:
  /// **'Settings for {country}'**
  String onboardingRegionDefaultsTitle(String country);

  /// No description provided for @onboardingRegionDefaultsMessage.
  ///
  /// In en, this message translates to:
  /// **'Units and currency follow your country.'**
  String get onboardingRegionDefaultsMessage;

  /// No description provided for @onboardingBusinessTitle.
  ///
  /// In en, this message translates to:
  /// **'Tell us about your business'**
  String get onboardingBusinessTitle;

  /// No description provided for @regionFeatureAks.
  ///
  /// In en, this message translates to:
  /// **'AKS and business registration details'**
  String get regionFeatureAks;

  /// No description provided for @regionFeatureSubsidies.
  ///
  /// In en, this message translates to:
  /// **'hive subsidy reminders'**
  String get regionFeatureSubsidies;

  /// No description provided for @regionFeatureRegulations.
  ///
  /// In en, this message translates to:
  /// **'regulation summaries'**
  String get regionFeatureRegulations;

  /// No description provided for @regionFeatureTrDrugList.
  ///
  /// In en, this message translates to:
  /// **'licensed medicine list'**
  String get regionFeatureTrDrugList;

  /// No description provided for @regionFeatureTrFlora.
  ///
  /// In en, this message translates to:
  /// **'Türkiye flora calendar'**
  String get regionFeatureTrFlora;

  /// No description provided for @regionFeatureTrMigrationDocs.
  ///
  /// In en, this message translates to:
  /// **'migratory beekeeping documents'**
  String get regionFeatureTrMigrationDocs;

  /// No description provided for @unitKilogram.
  ///
  /// In en, this message translates to:
  /// **'kg'**
  String get unitKilogram;

  /// No description provided for @unitPound.
  ///
  /// In en, this message translates to:
  /// **'lb'**
  String get unitPound;

  /// No description provided for @unitCelsius.
  ///
  /// In en, this message translates to:
  /// **'°C'**
  String get unitCelsius;

  /// No description provided for @unitFahrenheit.
  ///
  /// In en, this message translates to:
  /// **'°F'**
  String get unitFahrenheit;

  /// No description provided for @hemisphereNorthern.
  ///
  /// In en, this message translates to:
  /// **'Northern hemisphere'**
  String get hemisphereNorthern;

  /// No description provided for @hemisphereSouthern.
  ///
  /// In en, this message translates to:
  /// **'Southern hemisphere'**
  String get hemisphereSouthern;

  /// No description provided for @relativeToday.
  ///
  /// In en, this message translates to:
  /// **'today'**
  String get relativeToday;

  /// No description provided for @relativeYesterday.
  ///
  /// In en, this message translates to:
  /// **'yesterday'**
  String get relativeYesterday;

  /// No description provided for @relativeDaysAgo.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{1 day ago} other{{count} days ago}}'**
  String relativeDaysAgo(int count);

  /// No description provided for @apiariesCount.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{1 apiary} other{{count} apiaries}}'**
  String apiariesCount(int count);

  /// No description provided for @apiariesSummary.
  ///
  /// In en, this message translates to:
  /// **'{apiaries} · {hives}'**
  String apiariesSummary(String apiaries, String hives);

  /// Unit under the big active hive count on an apiary card.
  ///
  /// In en, this message translates to:
  /// **'hives'**
  String get apiaryHiveCountUnit;

  /// No description provided for @hiveLayoutGridShort.
  ///
  /// In en, this message translates to:
  /// **'Grid'**
  String get hiveLayoutGridShort;

  /// No description provided for @hiveLayoutListShort.
  ///
  /// In en, this message translates to:
  /// **'List'**
  String get hiveLayoutListShort;

  /// No description provided for @apiaryDetailSubtitle.
  ///
  /// In en, this message translates to:
  /// **'{hives} · {visit}'**
  String apiaryDetailSubtitle(String hives, String visit);

  /// Small label above the big hive number on the hive card.
  ///
  /// In en, this message translates to:
  /// **'Hive'**
  String get hiveCardKind;

  /// No description provided for @hiveLastInspection.
  ///
  /// In en, this message translates to:
  /// **'Last inspection'**
  String get hiveLastInspection;

  /// No description provided for @hiveLastInspectionNone.
  ///
  /// In en, this message translates to:
  /// **'None yet'**
  String get hiveLastInspectionNone;

  /// No description provided for @hiveBulkPreviewTitle.
  ///
  /// In en, this message translates to:
  /// **'Preview'**
  String get hiveBulkPreviewTitle;

  /// No description provided for @hiveBulkSaveCount.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{Create 1 hive} other{Create {count} hives}}'**
  String hiveBulkSaveCount(int count);

  /// Stands for the skipped items between the first and last in a shortened list.
  ///
  /// In en, this message translates to:
  /// **'…'**
  String get listEllipsis;

  /// No description provided for @scanOfflineHint.
  ///
  /// In en, this message translates to:
  /// **'No internet needed · vibrates when read'**
  String get scanOfflineHint;

  /// Separates two parts of a title, e.g. 'Inspection · 104'.
  ///
  /// In en, this message translates to:
  /// **' · '**
  String get titleSeparator;

  /// No description provided for @settingsGeneral.
  ///
  /// In en, this message translates to:
  /// **'General'**
  String get settingsGeneral;

  /// No description provided for @settingsGloveMode.
  ///
  /// In en, this message translates to:
  /// **'Glove mode'**
  String get settingsGloveMode;

  /// No description provided for @settingsGloveModeHint.
  ///
  /// In en, this message translates to:
  /// **'Every touch target grows one step.'**
  String get settingsGloveModeHint;

  /// No description provided for @settingsCountry.
  ///
  /// In en, this message translates to:
  /// **'Country'**
  String get settingsCountry;

  /// No description provided for @settingsCountryValue.
  ///
  /// In en, this message translates to:
  /// **'{name} · {code}'**
  String settingsCountryValue(String name, String code);

  /// Section title on the More tab above Settings and Sync.
  ///
  /// In en, this message translates to:
  /// **'Help'**
  String get moreSectionHelp;

  /// No description provided for @galleryFormFields.
  ///
  /// In en, this message translates to:
  /// **'Form fields'**
  String get galleryFormFields;

  /// No description provided for @galleryRadioCardGroup.
  ///
  /// In en, this message translates to:
  /// **'Choice cards'**
  String get galleryRadioCardGroup;

  /// No description provided for @gallerySegmentedTabs.
  ///
  /// In en, this message translates to:
  /// **'View switcher'**
  String get gallerySegmentedTabs;

  /// No description provided for @galleryListGroup.
  ///
  /// In en, this message translates to:
  /// **'Grouped list'**
  String get galleryListGroup;

  /// No description provided for @galleryNoteCard.
  ///
  /// In en, this message translates to:
  /// **'Note card'**
  String get galleryNoteCard;

  /// No description provided for @gallerySummaryTile.
  ///
  /// In en, this message translates to:
  /// **'Summary tile'**
  String get gallerySummaryTile;

  /// No description provided for @galleryActionTile.
  ///
  /// In en, this message translates to:
  /// **'Action tiles'**
  String get galleryActionTile;

  /// No description provided for @galleryAppLogo.
  ///
  /// In en, this message translates to:
  /// **'Logo and honeycomb'**
  String get galleryAppLogo;

  /// No description provided for @gallerySampleApiaryName.
  ///
  /// In en, this message translates to:
  /// **'Apiary name'**
  String get gallerySampleApiaryName;

  /// No description provided for @gallerySampleFirstNumber.
  ///
  /// In en, this message translates to:
  /// **'First number'**
  String get gallerySampleFirstNumber;

  /// No description provided for @gallerySampleNoteHint.
  ///
  /// In en, this message translates to:
  /// **'No password. We\'ll send a 6-digit code to your address.'**
  String get gallerySampleNoteHint;

  /// No description provided for @gallerySampleGrid.
  ///
  /// In en, this message translates to:
  /// **'Grid'**
  String get gallerySampleGrid;

  /// No description provided for @gallerySampleList.
  ///
  /// In en, this message translates to:
  /// **'List'**
  String get gallerySampleList;

  /// No description provided for @gallerySampleMap.
  ///
  /// In en, this message translates to:
  /// **'Map'**
  String get gallerySampleMap;

  /// No description provided for @gallerySampleInspections.
  ///
  /// In en, this message translates to:
  /// **'Inspections'**
  String get gallerySampleInspections;

  /// No description provided for @gallerySampleNoteTitle.
  ///
  /// In en, this message translates to:
  /// **'Turned on for Türkiye'**
  String get gallerySampleNoteTitle;

  /// No description provided for @gallerySampleNoteMessage.
  ///
  /// In en, this message translates to:
  /// **'AKS and business registration details, regulation summaries and the licensed medicine list.'**
  String get gallerySampleNoteMessage;

  /// No description provided for @gallerySampleLastInspectionValue.
  ///
  /// In en, this message translates to:
  /// **'3 days ago'**
  String get gallerySampleLastInspectionValue;

  /// No description provided for @gallerySampleFrames.
  ///
  /// In en, this message translates to:
  /// **'8 bee frames · 5 brood'**
  String get gallerySampleFrames;

  /// No description provided for @gallerySampleActiveTreatment.
  ///
  /// In en, this message translates to:
  /// **'Active treatment'**
  String get gallerySampleActiveTreatment;

  /// No description provided for @gallerySampleDaysLeft.
  ///
  /// In en, this message translates to:
  /// **'12 days left'**
  String get gallerySampleDaysLeft;
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
