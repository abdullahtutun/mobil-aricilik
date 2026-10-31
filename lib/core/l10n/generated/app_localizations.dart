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
  /// **'Start by adding your apiary'**
  String get todayEmptyTitle;

  /// No description provided for @todayEmptyMessage.
  ///
  /// In en, this message translates to:
  /// **'Three steps and you\'re ready: add your apiary, create your hives, do your first inspection.'**
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

  /// No description provided for @apiariesViewList.
  ///
  /// In en, this message translates to:
  /// **'List'**
  String get apiariesViewList;

  /// No description provided for @apiariesViewMap.
  ///
  /// In en, this message translates to:
  /// **'Map'**
  String get apiariesViewMap;

  /// No description provided for @apiariesMapOfflineTitle.
  ///
  /// In en, this message translates to:
  /// **'Map unavailable'**
  String get apiariesMapOfflineTitle;

  /// No description provided for @apiariesMapOfflineMessage.
  ///
  /// In en, this message translates to:
  /// **'The map needs internet. Your apiaries are listed below.'**
  String get apiariesMapOfflineMessage;

  /// No description provided for @apiariesMapNoLocation.
  ///
  /// In en, this message translates to:
  /// **'No apiary has a location yet. Edit an apiary at its site to take the location from GPS.'**
  String get apiariesMapNoLocation;

  /// Map data credit, always visible on the map. Keep the names as they are.
  ///
  /// In en, this message translates to:
  /// **'© OpenFreeMap © OpenMapTiles © OpenStreetMap contributors'**
  String get apiariesMapAttribution;

  /// Screen reader label of an apiary pin on the map.
  ///
  /// In en, this message translates to:
  /// **'{name}, {hives}'**
  String apiaryMapPinLabel(String name, String hives);

  /// Warning on an apiary pin: queenless, weak, swarming or treatment-to-remove hives.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{1 hive needs attention} other{{count} hives need attention}}'**
  String apiaryMapPinAttention(int count);

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

  /// No description provided for @hiveQueenStripTitle.
  ///
  /// In en, this message translates to:
  /// **'Queen · {queen}'**
  String hiveQueenStripTitle(String queen);

  /// No description provided for @hiveStrengthBadge.
  ///
  /// In en, this message translates to:
  /// **'{level} · {strength}/5'**
  String hiveStrengthBadge(String level, int strength);

  /// No description provided for @hiveStrengthWeak.
  ///
  /// In en, this message translates to:
  /// **'Weak'**
  String get hiveStrengthWeak;

  /// No description provided for @hiveStrengthMedium.
  ///
  /// In en, this message translates to:
  /// **'Medium'**
  String get hiveStrengthMedium;

  /// No description provided for @hiveStrengthStrong.
  ///
  /// In en, this message translates to:
  /// **'Strong'**
  String get hiveStrengthStrong;

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

  /// No description provided for @moreSectionApiary.
  ///
  /// In en, this message translates to:
  /// **'Apiary'**
  String get moreSectionApiary;

  /// No description provided for @moreSectionBusiness.
  ///
  /// In en, this message translates to:
  /// **'Business'**
  String get moreSectionBusiness;

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

  /// No description provided for @syncTableMedia.
  ///
  /// In en, this message translates to:
  /// **'Photo or voice note'**
  String get syncTableMedia;

  /// No description provided for @mediaTakePhoto.
  ///
  /// In en, this message translates to:
  /// **'Take a photo'**
  String get mediaTakePhoto;

  /// No description provided for @mediaRecordVoice.
  ///
  /// In en, this message translates to:
  /// **'Record a voice note'**
  String get mediaRecordVoice;

  /// No description provided for @mediaStopRecording.
  ///
  /// In en, this message translates to:
  /// **'Stop recording'**
  String get mediaStopRecording;

  /// Shown while a voice note is being recorded.
  ///
  /// In en, this message translates to:
  /// **'Recording · {duration}'**
  String mediaRecording(String duration);

  /// No description provided for @mediaPhotoAdded.
  ///
  /// In en, this message translates to:
  /// **'Photo added to hive {number}'**
  String mediaPhotoAdded(String number);

  /// No description provided for @mediaVoiceAdded.
  ///
  /// In en, this message translates to:
  /// **'Voice note added to hive {number}'**
  String mediaVoiceAdded(String number);

  /// No description provided for @mediaCameraDenied.
  ///
  /// In en, this message translates to:
  /// **'No camera permission. You can allow it in the phone\'s settings.'**
  String get mediaCameraDenied;

  /// No description provided for @mediaMicrophoneDenied.
  ///
  /// In en, this message translates to:
  /// **'No microphone permission. You can allow it in the phone\'s settings.'**
  String get mediaMicrophoneDenied;

  /// No description provided for @mediaCaptureFailed.
  ///
  /// In en, this message translates to:
  /// **'Couldn\'t save. Try again.'**
  String get mediaCaptureFailed;

  /// No description provided for @mediaPhotoCount.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{1 photo} other{{count} photos}}'**
  String mediaPhotoCount(int count);

  /// No description provided for @mediaVoiceCount.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{1 voice note} other{{count} voice notes}}'**
  String mediaVoiceCount(int count);

  /// Photos and voice notes taken during the inspection, e.g. '2 photos, 1 voice note'.
  ///
  /// In en, this message translates to:
  /// **'Saved with the inspection: {items}'**
  String inspectionMediaAttached(String items);

  /// No description provided for @timelinePhoto.
  ///
  /// In en, this message translates to:
  /// **'Photo'**
  String get timelinePhoto;

  /// No description provided for @timelineVoiceNote.
  ///
  /// In en, this message translates to:
  /// **'Voice note'**
  String get timelineVoiceNote;

  /// No description provided for @mediaOpenPhoto.
  ///
  /// In en, this message translates to:
  /// **'Open photo'**
  String get mediaOpenPhoto;

  /// No description provided for @mediaDownloadPhoto.
  ///
  /// In en, this message translates to:
  /// **'Photo not on this phone. Tap to download.'**
  String get mediaDownloadPhoto;

  /// No description provided for @mediaPlay.
  ///
  /// In en, this message translates to:
  /// **'Play · {duration}'**
  String mediaPlay(String duration);

  /// No description provided for @mediaStopPlaying.
  ///
  /// In en, this message translates to:
  /// **'Stop'**
  String get mediaStopPlaying;

  /// No description provided for @mediaNotUploaded.
  ///
  /// In en, this message translates to:
  /// **'Not uploaded yet. It arrives when the phone that took it is online.'**
  String get mediaNotUploaded;

  /// No description provided for @mediaDownloadOffline.
  ///
  /// In en, this message translates to:
  /// **'Couldn\'t download. Check your internet connection.'**
  String get mediaDownloadOffline;

  /// No description provided for @mediaDownloadFailed.
  ///
  /// In en, this message translates to:
  /// **'Couldn\'t download.'**
  String get mediaDownloadFailed;

  /// No description provided for @mediaNotFound.
  ///
  /// In en, this message translates to:
  /// **'Photo not found'**
  String get mediaNotFound;

  /// No description provided for @settingsData.
  ///
  /// In en, this message translates to:
  /// **'Data'**
  String get settingsData;

  /// No description provided for @settingsMediaWifiOnly.
  ///
  /// In en, this message translates to:
  /// **'Upload photos on Wi‑Fi only'**
  String get settingsMediaWifiOnly;

  /// No description provided for @settingsMediaWifiOnlyHint.
  ///
  /// In en, this message translates to:
  /// **'Photos and voice notes won\'t use mobile data.'**
  String get settingsMediaWifiOnlyHint;

  /// No description provided for @settingsPendingUploads.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{1 file waiting to upload} other{{count} files waiting to upload}}'**
  String settingsPendingUploads(int count);

  /// On the hive card's queen strip when the hive has no queen record.
  ///
  /// In en, this message translates to:
  /// **'Not recorded'**
  String get hiveQueenNone;

  /// No description provided for @hiveQueenNoneHint.
  ///
  /// In en, this message translates to:
  /// **'Tap to add a queen'**
  String get hiveQueenNoneHint;

  /// Name of a queen's marking color.
  ///
  /// In en, this message translates to:
  /// **'{color, select, white{White} yellow{Yellow} red{Red} green{Green} blue{Blue} other{Unknown}}'**
  String queenMarkColorName(String color);

  /// No description provided for @queenYearUnknown.
  ///
  /// In en, this message translates to:
  /// **'Year unknown'**
  String get queenYearUnknown;

  /// Queen without a paint mark.
  ///
  /// In en, this message translates to:
  /// **'Unmarked'**
  String get queenUnmarked;

  /// Queen's age, from her year only.
  ///
  /// In en, this message translates to:
  /// **'{age, plural, =0{Under a year old} =1{1 year old} other{{age} years old}}'**
  String queenAge(int age);

  /// No description provided for @queenSourceOwnRearing.
  ///
  /// In en, this message translates to:
  /// **'Own rearing'**
  String get queenSourceOwnRearing;

  /// No description provided for @queenSourcePurchased.
  ///
  /// In en, this message translates to:
  /// **'Purchased'**
  String get queenSourcePurchased;

  /// No description provided for @queenSourceCertifiedBreeder.
  ///
  /// In en, this message translates to:
  /// **'Certified breeder'**
  String get queenSourceCertifiedBreeder;

  /// Where the queen came from.
  ///
  /// In en, this message translates to:
  /// **'Source'**
  String get queenSource;

  /// No description provided for @queenMother.
  ///
  /// In en, this message translates to:
  /// **'Mother queen'**
  String get queenMother;

  /// Option and value when the mother queen isn't known.
  ///
  /// In en, this message translates to:
  /// **'Unknown'**
  String get queenMotherUnknown;

  /// No description provided for @queenBreed.
  ///
  /// In en, this message translates to:
  /// **'Breed'**
  String get queenBreed;

  /// No description provided for @queenBreedHint.
  ///
  /// In en, this message translates to:
  /// **'E.g. Caucasian'**
  String get queenBreedHint;

  /// Breeding line within the breed.
  ///
  /// In en, this message translates to:
  /// **'Line'**
  String get queenBreedLine;

  /// No description provided for @queenBreedLineHint.
  ///
  /// In en, this message translates to:
  /// **'E.g. Artvin'**
  String get queenBreedLineHint;

  /// Whether the queen's wing is clipped.
  ///
  /// In en, this message translates to:
  /// **'Wing'**
  String get queenWing;

  /// No description provided for @queenWingClipped.
  ///
  /// In en, this message translates to:
  /// **'Clipped'**
  String get queenWingClipped;

  /// No description provided for @queenWingIntact.
  ///
  /// In en, this message translates to:
  /// **'Not clipped'**
  String get queenWingIntact;

  /// No description provided for @queenYear.
  ///
  /// In en, this message translates to:
  /// **'Year'**
  String get queenYear;

  /// No description provided for @queenYearHelper.
  ///
  /// In en, this message translates to:
  /// **'Year hatched or bought'**
  String get queenYearHelper;

  /// No description provided for @queenMark.
  ///
  /// In en, this message translates to:
  /// **'Mark color'**
  String get queenMark;

  /// International marking color of the selected year.
  ///
  /// In en, this message translates to:
  /// **'{year} color: {color}'**
  String queenMarkSuggestion(String year, String color);

  /// Queen card value for an empty field.
  ///
  /// In en, this message translates to:
  /// **'Not entered'**
  String get queenUnknown;

  /// No description provided for @queenEdit.
  ///
  /// In en, this message translates to:
  /// **'Edit queen'**
  String get queenEdit;

  /// No description provided for @queenReplace.
  ///
  /// In en, this message translates to:
  /// **'Replace queen'**
  String get queenReplace;

  /// Give a hive its queen record.
  ///
  /// In en, this message translates to:
  /// **'Add queen'**
  String get queenGive;

  /// No description provided for @queenNoneTitle.
  ///
  /// In en, this message translates to:
  /// **'No queen recorded'**
  String get queenNoneTitle;

  /// No description provided for @queenNoneMessage.
  ///
  /// In en, this message translates to:
  /// **'Record the queen you gave this hive; her year, color and lineage show here.'**
  String get queenNoneMessage;

  /// No description provided for @queenFormNewTitle.
  ///
  /// In en, this message translates to:
  /// **'New queen · Hive {number}'**
  String queenFormNewTitle(String number);

  /// No description provided for @queenFormEditTitle.
  ///
  /// In en, this message translates to:
  /// **'Edit queen'**
  String get queenFormEditTitle;

  /// No description provided for @queenFormSave.
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get queenFormSave;

  /// Undo snackbar after giving a hive a new queen.
  ///
  /// In en, this message translates to:
  /// **'Hive {number} has a new queen'**
  String queenGiven(String number);

  /// Queens in active hives that reached the replacement age.
  ///
  /// In en, this message translates to:
  /// **'Old queens'**
  String get oldQueensTitle;

  /// No description provided for @oldQueensIntro.
  ///
  /// In en, this message translates to:
  /// **'{age, plural, other{Queens in active hives that are {age} or older. Plan to replace them.}}'**
  String oldQueensIntro(int age);

  /// No description provided for @oldQueensEmptyTitle.
  ///
  /// In en, this message translates to:
  /// **'No old queens'**
  String get oldQueensEmptyTitle;

  /// No description provided for @oldQueensEmptyMessage.
  ///
  /// In en, this message translates to:
  /// **'{age, plural, other{Queens in active hives are younger than {age}, or have no year entered.}}'**
  String oldQueensEmptyMessage(int age);

  /// No description provided for @syncTableMiteCounts.
  ///
  /// In en, this message translates to:
  /// **'Varroa count'**
  String get syncTableMiteCounts;

  /// No description provided for @varroaMethodSugarRoll.
  ///
  /// In en, this message translates to:
  /// **'Sugar roll'**
  String get varroaMethodSugarRoll;

  /// No description provided for @varroaMethodAlcoholWash.
  ///
  /// In en, this message translates to:
  /// **'Alcohol wash'**
  String get varroaMethodAlcoholWash;

  /// No description provided for @varroaMethodStickyBoard.
  ///
  /// In en, this message translates to:
  /// **'Sticky board'**
  String get varroaMethodStickyBoard;

  /// No description provided for @varroaFormTitle.
  ///
  /// In en, this message translates to:
  /// **'Varroa · Hive {number}'**
  String varroaFormTitle(String number);

  /// No description provided for @varroaMethod.
  ///
  /// In en, this message translates to:
  /// **'Method'**
  String get varroaMethod;

  /// No description provided for @varroaSampleBees.
  ///
  /// In en, this message translates to:
  /// **'Sample bees'**
  String get varroaSampleBees;

  /// No description provided for @varroaBoardDays.
  ///
  /// In en, this message translates to:
  /// **'Days on board'**
  String get varroaBoardDays;

  /// No description provided for @varroaMites.
  ///
  /// In en, this message translates to:
  /// **'Mites counted'**
  String get varroaMites;

  /// No description provided for @varroaBoardMites.
  ///
  /// In en, this message translates to:
  /// **'Mites dropped'**
  String get varroaBoardMites;

  /// No description provided for @varroaSave.
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get varroaSave;

  /// No description provided for @varroaSaved.
  ///
  /// In en, this message translates to:
  /// **'Varroa count saved for hive {number}'**
  String varroaSaved(String number);

  /// Infestation as a percentage with one decimal, e.g. 3.0%.
  ///
  /// In en, this message translates to:
  /// **'{value}%'**
  String varroaPercent(double value);

  /// Daily mite drop on a sticky board, one decimal.
  ///
  /// In en, this message translates to:
  /// **'{value} mites/day'**
  String varroaPerDay(double value);

  /// No description provided for @varroaInfestation.
  ///
  /// In en, this message translates to:
  /// **'Infestation'**
  String get varroaInfestation;

  /// No description provided for @varroaDailyDrop.
  ///
  /// In en, this message translates to:
  /// **'Daily drop'**
  String get varroaDailyDrop;

  /// Shown when the result is at or above the threshold.
  ///
  /// In en, this message translates to:
  /// **'At threshold · plan treatment'**
  String get varroaReached;

  /// No description provided for @varroaBelow.
  ///
  /// In en, this message translates to:
  /// **'Below threshold'**
  String get varroaBelow;

  /// No description provided for @varroaThresholdNote.
  ///
  /// In en, this message translates to:
  /// **'Threshold {threshold} (from Settings).'**
  String varroaThresholdNote(String threshold);

  /// No description provided for @hiveVarroa.
  ///
  /// In en, this message translates to:
  /// **'Varroa'**
  String get hiveVarroa;

  /// No description provided for @hiveVarroaNone.
  ///
  /// In en, this message translates to:
  /// **'No count yet'**
  String get hiveVarroaNone;

  /// No description provided for @hiveVarroaReached.
  ///
  /// In en, this message translates to:
  /// **'Threshold reached'**
  String get hiveVarroaReached;

  /// No description provided for @hiveVarroaCount.
  ///
  /// In en, this message translates to:
  /// **'Count varroa'**
  String get hiveVarroaCount;

  /// No description provided for @varroaChartTitle.
  ///
  /// In en, this message translates to:
  /// **'{apiary} · recent counts'**
  String varroaChartTitle(String apiary);

  /// Label on the dashed threshold line of the chart.
  ///
  /// In en, this message translates to:
  /// **'threshold {threshold}'**
  String varroaChartThreshold(String threshold);

  /// No description provided for @varroaChartEmpty.
  ///
  /// In en, this message translates to:
  /// **'No sugar roll or alcohol wash counts yet. Add one from a hive card.'**
  String get varroaChartEmpty;

  /// Screen reader text for one bar of the varroa chart.
  ///
  /// In en, this message translates to:
  /// **'{day}: {value}'**
  String varroaChartBar(String day, String value);

  /// No description provided for @varroaChartSemantics.
  ///
  /// In en, this message translates to:
  /// **'Average infestation per day, threshold {threshold}: {bars}'**
  String varroaChartSemantics(String threshold, String bars);

  /// No description provided for @settingsVarroa.
  ///
  /// In en, this message translates to:
  /// **'Varroa'**
  String get settingsVarroa;

  /// No description provided for @settingsVarroaPercent.
  ///
  /// In en, this message translates to:
  /// **'Infestation threshold'**
  String get settingsVarroaPercent;

  /// No description provided for @settingsVarroaPerDay.
  ///
  /// In en, this message translates to:
  /// **'Sticky board threshold'**
  String get settingsVarroaPerDay;

  /// No description provided for @settingsVarroaHint.
  ///
  /// In en, this message translates to:
  /// **'A warning is shown when a count reaches the threshold. Saved on this phone only.'**
  String get settingsVarroaHint;

  /// No description provided for @syncTableRefDrugs.
  ///
  /// In en, this message translates to:
  /// **'Drug list'**
  String get syncTableRefDrugs;

  /// No description provided for @syncTableDrugs.
  ///
  /// In en, this message translates to:
  /// **'Drug'**
  String get syncTableDrugs;

  /// No description provided for @syncTableTreatments.
  ///
  /// In en, this message translates to:
  /// **'Treatment'**
  String get syncTableTreatments;

  /// No description provided for @syncTableFeedings.
  ///
  /// In en, this message translates to:
  /// **'Feeding'**
  String get syncTableFeedings;

  /// No description provided for @drugIngredientAmitraz.
  ///
  /// In en, this message translates to:
  /// **'Amitraz'**
  String get drugIngredientAmitraz;

  /// No description provided for @drugIngredientOxalicAcid.
  ///
  /// In en, this message translates to:
  /// **'Oxalic acid'**
  String get drugIngredientOxalicAcid;

  /// No description provided for @drugIngredientFormicAcid.
  ///
  /// In en, this message translates to:
  /// **'Formic acid'**
  String get drugIngredientFormicAcid;

  /// No description provided for @drugIngredientThymol.
  ///
  /// In en, this message translates to:
  /// **'Thymol'**
  String get drugIngredientThymol;

  /// No description provided for @drugIngredientFlumethrin.
  ///
  /// In en, this message translates to:
  /// **'Flumethrin'**
  String get drugIngredientFlumethrin;

  /// No description provided for @drugIngredientTauFluvalinate.
  ///
  /// In en, this message translates to:
  /// **'Tau-fluvalinate'**
  String get drugIngredientTauFluvalinate;

  /// No description provided for @drugIngredientCoumaphos.
  ///
  /// In en, this message translates to:
  /// **'Coumaphos'**
  String get drugIngredientCoumaphos;

  /// No description provided for @drugIngredientLacticAcid.
  ///
  /// In en, this message translates to:
  /// **'Lactic acid'**
  String get drugIngredientLacticAcid;

  /// No description provided for @drugIngredientOther.
  ///
  /// In en, this message translates to:
  /// **'Other'**
  String get drugIngredientOther;

  /// No description provided for @drugUnitStrip.
  ///
  /// In en, this message translates to:
  /// **'strip'**
  String get drugUnitStrip;

  /// No description provided for @drugUnitMl.
  ///
  /// In en, this message translates to:
  /// **'ml'**
  String get drugUnitMl;

  /// No description provided for @drugUnitG.
  ///
  /// In en, this message translates to:
  /// **'g'**
  String get drugUnitG;

  /// No description provided for @drugUnitDose.
  ///
  /// In en, this message translates to:
  /// **'dose'**
  String get drugUnitDose;

  /// No description provided for @hiveTreat.
  ///
  /// In en, this message translates to:
  /// **'Apply treatment'**
  String get hiveTreat;

  /// No description provided for @treatmentFormTitle.
  ///
  /// In en, this message translates to:
  /// **'Treatment'**
  String get treatmentFormTitle;

  /// No description provided for @treatmentScopeHive.
  ///
  /// In en, this message translates to:
  /// **'Hive {number}'**
  String treatmentScopeHive(String number);

  /// No description provided for @treatmentScopeApiary.
  ///
  /// In en, this message translates to:
  /// **'Whole apiary · {count}'**
  String treatmentScopeApiary(int count);

  /// No description provided for @treatmentChooseDrug.
  ///
  /// In en, this message translates to:
  /// **'Choose drug'**
  String get treatmentChooseDrug;

  /// No description provided for @treatmentChangeDrug.
  ///
  /// In en, this message translates to:
  /// **'Change'**
  String get treatmentChangeDrug;

  /// No description provided for @treatmentDrugIngredient.
  ///
  /// In en, this message translates to:
  /// **'Active ingredient: {ingredient}'**
  String treatmentDrugIngredient(String ingredient);

  /// No description provided for @treatmentDrugLicense.
  ///
  /// In en, this message translates to:
  /// **'licence {number}'**
  String treatmentDrugLicense(String number);

  /// No description provided for @treatmentDrugCustom.
  ///
  /// In en, this message translates to:
  /// **'your drug'**
  String get treatmentDrugCustom;

  /// No description provided for @treatmentAddDrug.
  ///
  /// In en, this message translates to:
  /// **'Add a new drug'**
  String get treatmentAddDrug;

  /// No description provided for @treatmentBatchNo.
  ///
  /// In en, this message translates to:
  /// **'Batch no'**
  String get treatmentBatchNo;

  /// No description provided for @treatmentStartedOn.
  ///
  /// In en, this message translates to:
  /// **'Start'**
  String get treatmentStartedOn;

  /// No description provided for @treatmentDose.
  ///
  /// In en, this message translates to:
  /// **'Dose per hive ({unit})'**
  String treatmentDose(String unit);

  /// No description provided for @treatmentDoseTotal.
  ///
  /// In en, this message translates to:
  /// **'Total {total} {unit}'**
  String treatmentDoseTotal(String total, String unit);

  /// No description provided for @treatmentWithdrawalDays.
  ///
  /// In en, this message translates to:
  /// **'Withdrawal period (days)'**
  String get treatmentWithdrawalDays;

  /// No description provided for @treatmentRemoval.
  ///
  /// In en, this message translates to:
  /// **'Removal'**
  String get treatmentRemoval;

  /// No description provided for @treatmentRemovalNone.
  ///
  /// In en, this message translates to:
  /// **'None'**
  String get treatmentRemovalNone;

  /// No description provided for @treatmentRemovalChange.
  ///
  /// In en, this message translates to:
  /// **'Reminder that morning; tap to change'**
  String get treatmentRemovalChange;

  /// No description provided for @treatmentRemovalSingle.
  ///
  /// In en, this message translates to:
  /// **'Single application; tap to set'**
  String get treatmentRemovalSingle;

  /// No description provided for @treatmentRemovalClear.
  ///
  /// In en, this message translates to:
  /// **'No removal (single application)'**
  String get treatmentRemovalClear;

  /// No description provided for @treatmentNoSuper.
  ///
  /// In en, this message translates to:
  /// **'No honey super'**
  String get treatmentNoSuper;

  /// No description provided for @treatmentNoSuperUntil.
  ///
  /// In en, this message translates to:
  /// **'Until {date}'**
  String treatmentNoSuperUntil(String date);

  /// No description provided for @treatmentNoSuperAfterRemoval.
  ///
  /// In en, this message translates to:
  /// **'{days, plural, =0{no withdrawal after removal} =1{removal + 1 day withdrawal} other{removal + {days} days withdrawal}}'**
  String treatmentNoSuperAfterRemoval(int days);

  /// No description provided for @treatmentNoSuperAfterStart.
  ///
  /// In en, this message translates to:
  /// **'{days, plural, =0{no withdrawal} =1{start + 1 day withdrawal} other{start + {days} days withdrawal}}'**
  String treatmentNoSuperAfterStart(int days);

  /// No description provided for @treatmentSave.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{Save} other{Save to {count} hives}}'**
  String treatmentSave(int count);

  /// No description provided for @treatmentSaved.
  ///
  /// In en, this message translates to:
  /// **'Treatment saved for hive {number}'**
  String treatmentSaved(String number);

  /// No description provided for @treatmentSavedMany.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{Treatment saved for 1 hive} other{Treatment saved for {count} hives}}'**
  String treatmentSavedMany(int count);

  /// No description provided for @drugFormTitle.
  ///
  /// In en, this message translates to:
  /// **'New drug'**
  String get drugFormTitle;

  /// No description provided for @drugName.
  ///
  /// In en, this message translates to:
  /// **'Name'**
  String get drugName;

  /// No description provided for @drugActiveIngredient.
  ///
  /// In en, this message translates to:
  /// **'Active ingredient'**
  String get drugActiveIngredient;

  /// No description provided for @drugDoseUnit.
  ///
  /// In en, this message translates to:
  /// **'Dose unit'**
  String get drugDoseUnit;

  /// No description provided for @drugWithdrawalDays.
  ///
  /// In en, this message translates to:
  /// **'Withdrawal period on the label (days)'**
  String get drugWithdrawalDays;

  /// No description provided for @drugSave.
  ///
  /// In en, this message translates to:
  /// **'Add drug'**
  String get drugSave;

  /// No description provided for @withdrawalLockTitle.
  ///
  /// In en, this message translates to:
  /// **'In withdrawal period.'**
  String get withdrawalLockTitle;

  /// No description provided for @withdrawalLockMessage.
  ///
  /// In en, this message translates to:
  /// **'Hive {number} is being treated with {product}. No honey super should be added before {date}; honey from this period may carry drug residue.'**
  String withdrawalLockMessage(String number, String product, String date);

  /// No description provided for @withdrawalDaysLeft.
  ///
  /// In en, this message translates to:
  /// **'Remaining'**
  String get withdrawalDaysLeft;

  /// No description provided for @withdrawalDays.
  ///
  /// In en, this message translates to:
  /// **'{days, plural, =1{1 day} other{{days} days}}'**
  String withdrawalDays(int days);

  /// No description provided for @withdrawalApplied.
  ///
  /// In en, this message translates to:
  /// **'Applied'**
  String get withdrawalApplied;

  /// No description provided for @withdrawalReasonPrompt.
  ///
  /// In en, this message translates to:
  /// **'To save anyway, choose a reason'**
  String get withdrawalReasonPrompt;

  /// No description provided for @withdrawalReasonRemovedEarly.
  ///
  /// In en, this message translates to:
  /// **'Drug removed early'**
  String get withdrawalReasonRemovedEarly;

  /// No description provided for @withdrawalReasonNotForSale.
  ///
  /// In en, this message translates to:
  /// **'Super won\'t be sold (own use/feed)'**
  String get withdrawalReasonNotForSale;

  /// No description provided for @withdrawalCancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel, don\'t add super'**
  String get withdrawalCancel;

  /// No description provided for @withdrawalProceed.
  ///
  /// In en, this message translates to:
  /// **'Save anyway'**
  String get withdrawalProceed;

  /// No description provided for @inspectionWithdrawalOverride.
  ///
  /// In en, this message translates to:
  /// **'Honey super added during the withdrawal period: {reason}'**
  String inspectionWithdrawalOverride(String reason);

  /// No description provided for @timelineTreatment.
  ///
  /// In en, this message translates to:
  /// **'Treatment · {product}'**
  String timelineTreatment(String product);

  /// No description provided for @timelineTreatmentBatch.
  ///
  /// In en, this message translates to:
  /// **'Batch {batch}'**
  String timelineTreatmentBatch(String batch);

  /// No description provided for @treatmentDoseValue.
  ///
  /// In en, this message translates to:
  /// **'{dose} {unit}'**
  String treatmentDoseValue(String dose, String unit);

  /// No description provided for @timelineTreatmentRemoval.
  ///
  /// In en, this message translates to:
  /// **'removal {date}'**
  String timelineTreatmentRemoval(String date);

  /// No description provided for @timelineTreatmentWithdrawal.
  ///
  /// In en, this message translates to:
  /// **'{days, plural, =1{1 day withdrawal} other{{days} days withdrawal}}'**
  String timelineTreatmentWithdrawal(int days);

  /// No description provided for @hiveActiveTreatment.
  ///
  /// In en, this message translates to:
  /// **'Active treatment'**
  String get hiveActiveTreatment;

  /// No description provided for @hiveActiveTreatmentNone.
  ///
  /// In en, this message translates to:
  /// **'None'**
  String get hiveActiveTreatmentNone;

  /// No description provided for @hiveActiveTreatmentLeft.
  ///
  /// In en, this message translates to:
  /// **'{days, plural, =1{1 day left} other{{days} days left}}'**
  String hiveActiveTreatmentLeft(int days);

  /// No description provided for @hiveActiveTreatmentDetail.
  ///
  /// In en, this message translates to:
  /// **'{ingredient} · no honey super'**
  String hiveActiveTreatmentDetail(String ingredient);

  /// No description provided for @treatmentRotationTitle.
  ///
  /// In en, this message translates to:
  /// **'Same active ingredient.'**
  String get treatmentRotationTitle;

  /// No description provided for @treatmentRotationMessage.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, other{The last {count} treatments in this apiary were also {ingredient}. Consider a different active ingredient to limit resistance.}}'**
  String treatmentRotationMessage(int count, String ingredient);

  /// No description provided for @treatmentPrescriptionAdd.
  ///
  /// In en, this message translates to:
  /// **'Add prescription / invoice photo'**
  String get treatmentPrescriptionAdd;

  /// No description provided for @treatmentPrescriptionAdded.
  ///
  /// In en, this message translates to:
  /// **'Prescription photo added'**
  String get treatmentPrescriptionAdded;

  /// No description provided for @treatmentPrescriptionRemove.
  ///
  /// In en, this message translates to:
  /// **'Remove'**
  String get treatmentPrescriptionRemove;

  /// No description provided for @reminderChannelName.
  ///
  /// In en, this message translates to:
  /// **'Reminders'**
  String get reminderChannelName;

  /// No description provided for @treatmentReminderDenied.
  ///
  /// In en, this message translates to:
  /// **'Notifications are off; no removal reminder was set.'**
  String get treatmentReminderDenied;

  /// No description provided for @hiveFeed.
  ///
  /// In en, this message translates to:
  /// **'Feed'**
  String get hiveFeed;

  /// No description provided for @feedingFormTitle.
  ///
  /// In en, this message translates to:
  /// **'Feeding'**
  String get feedingFormTitle;

  /// No description provided for @feedingScopeHive.
  ///
  /// In en, this message translates to:
  /// **'Hive {number}'**
  String feedingScopeHive(String number);

  /// No description provided for @feedingScopeApiary.
  ///
  /// In en, this message translates to:
  /// **'Whole apiary · {count}'**
  String feedingScopeApiary(int count);

  /// No description provided for @feedingKind.
  ///
  /// In en, this message translates to:
  /// **'Type'**
  String get feedingKind;

  /// No description provided for @feedingKindSyrup1to1.
  ///
  /// In en, this message translates to:
  /// **'Syrup 1:1 · stimulative'**
  String get feedingKindSyrup1to1;

  /// No description provided for @feedingKindSyrup2to1.
  ///
  /// In en, this message translates to:
  /// **'Syrup 2:1 · winter'**
  String get feedingKindSyrup2to1;

  /// No description provided for @feedingKindBeeCake.
  ///
  /// In en, this message translates to:
  /// **'Bee cake'**
  String get feedingKindBeeCake;

  /// No description provided for @feedingKindPollenSubstitute.
  ///
  /// In en, this message translates to:
  /// **'Pollen substitute'**
  String get feedingKindPollenSubstitute;

  /// No description provided for @feedingAmount.
  ///
  /// In en, this message translates to:
  /// **'Per hive ({unit})'**
  String feedingAmount(String unit);

  /// No description provided for @feedingSuperHiveTitle.
  ///
  /// In en, this message translates to:
  /// **'This hive has a honey super.'**
  String get feedingSuperHiveTitle;

  /// No description provided for @feedingSuperHiveMessage.
  ///
  /// In en, this message translates to:
  /// **'Syrup may get into the honey.'**
  String get feedingSuperHiveMessage;

  /// No description provided for @feedingSuperSkippedTitle.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{1 hive has a honey super} other{{count} hives have a honey super}}'**
  String feedingSuperSkippedTitle(int count);

  /// No description provided for @feedingSuperSkippedMessage.
  ///
  /// In en, this message translates to:
  /// **'({numbers}). Left out so the syrup doesn\'t get into the honey.'**
  String feedingSuperSkippedMessage(String numbers);

  /// No description provided for @feedingPrepare.
  ///
  /// In en, this message translates to:
  /// **'To prepare'**
  String get feedingPrepare;

  /// No description provided for @feedingPrepareCount.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{1 hive × {amount} {unit}} other{{count} hives × {amount} {unit}}}'**
  String feedingPrepareCount(int count, String amount, String unit);

  /// No description provided for @feedingTotalSyrup.
  ///
  /// In en, this message translates to:
  /// **'{amount} {unit} syrup'**
  String feedingTotalSyrup(String amount, String unit);

  /// No description provided for @feedingTotalBeeCake.
  ///
  /// In en, this message translates to:
  /// **'{amount} {unit} bee cake'**
  String feedingTotalBeeCake(String amount, String unit);

  /// No description provided for @feedingTotalPollenSubstitute.
  ///
  /// In en, this message translates to:
  /// **'{amount} {unit} pollen substitute'**
  String feedingTotalPollenSubstitute(String amount, String unit);

  /// No description provided for @feedingSugar.
  ///
  /// In en, this message translates to:
  /// **'Sugar'**
  String get feedingSugar;

  /// No description provided for @feedingWater.
  ///
  /// In en, this message translates to:
  /// **'Water'**
  String get feedingWater;

  /// No description provided for @feedingApprox.
  ///
  /// In en, this message translates to:
  /// **'≈ {amount} {unit}'**
  String feedingApprox(String amount, String unit);

  /// No description provided for @feedingSave.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =0{No hive to feed} =1{Save} other{Save to {count} hives}}'**
  String feedingSave(int count);

  /// No description provided for @feedingSaved.
  ///
  /// In en, this message translates to:
  /// **'Feeding saved for hive {number}'**
  String feedingSaved(String number);

  /// No description provided for @feedingSavedMany.
  ///
  /// In en, this message translates to:
  /// **'Feeding saved for {count} hives'**
  String feedingSavedMany(int count);

  /// No description provided for @unitLiter.
  ///
  /// In en, this message translates to:
  /// **'L'**
  String get unitLiter;

  /// No description provided for @unitGallon.
  ///
  /// In en, this message translates to:
  /// **'gal'**
  String get unitGallon;

  /// No description provided for @syncTableTasks.
  ///
  /// In en, this message translates to:
  /// **'Task'**
  String get syncTableTasks;

  /// No description provided for @tasksTabToday.
  ///
  /// In en, this message translates to:
  /// **'Today'**
  String get tasksTabToday;

  /// No description provided for @tasksTabWeek.
  ///
  /// In en, this message translates to:
  /// **'This week'**
  String get tasksTabWeek;

  /// No description provided for @tasksTabApiary.
  ///
  /// In en, this message translates to:
  /// **'By apiary'**
  String get tasksTabApiary;

  /// No description provided for @tasksAdd.
  ///
  /// In en, this message translates to:
  /// **'Add task'**
  String get tasksAdd;

  /// No description provided for @tasksOverdue.
  ///
  /// In en, this message translates to:
  /// **'Overdue · {count}'**
  String tasksOverdue(int count);

  /// No description provided for @tasksDayGroup.
  ///
  /// In en, this message translates to:
  /// **'{day} · {count}'**
  String tasksDayGroup(String day, int count);

  /// No description provided for @tasksToday.
  ///
  /// In en, this message translates to:
  /// **'Today'**
  String get tasksToday;

  /// No description provided for @tasksTomorrow.
  ///
  /// In en, this message translates to:
  /// **'Tomorrow'**
  String get tasksTomorrow;

  /// No description provided for @tasksNoApiary.
  ///
  /// In en, this message translates to:
  /// **'No apiary'**
  String get tasksNoApiary;

  /// No description provided for @tasksApiaryGroup.
  ///
  /// In en, this message translates to:
  /// **'{apiary} · {count}'**
  String tasksApiaryGroup(String apiary, int count);

  /// No description provided for @tasksEmptyTodayTitle.
  ///
  /// In en, this message translates to:
  /// **'Nothing to do today'**
  String get tasksEmptyTodayTitle;

  /// No description provided for @tasksEmptyWeekTitle.
  ///
  /// In en, this message translates to:
  /// **'No tasks this week'**
  String get tasksEmptyWeekTitle;

  /// No description provided for @tasksEmptyAddHint.
  ///
  /// In en, this message translates to:
  /// **'Add a new task with + at the top right.'**
  String get tasksEmptyAddHint;

  /// No description provided for @tasksLoadError.
  ///
  /// In en, this message translates to:
  /// **'Couldn\'t load tasks.'**
  String get tasksLoadError;

  /// No description provided for @tasksWeekDaySemantics.
  ///
  /// In en, this message translates to:
  /// **'{day}, {count, plural, =0{no tasks} =1{1 task} other{{count} tasks}}'**
  String tasksWeekDaySemantics(String day, int count);

  /// No description provided for @taskOverdueDays.
  ///
  /// In en, this message translates to:
  /// **'{days, plural, =1{1 day overdue} other{{days} days overdue}}'**
  String taskOverdueDays(int days);

  /// No description provided for @taskSourceInspection.
  ///
  /// In en, this message translates to:
  /// **'from inspection'**
  String get taskSourceInspection;

  /// No description provided for @taskSourceTreatment.
  ///
  /// In en, this message translates to:
  /// **'treatment'**
  String get taskSourceTreatment;

  /// No description provided for @taskInspectionTitle.
  ///
  /// In en, this message translates to:
  /// **'Hive {number} · check again'**
  String taskInspectionTitle(String number);

  /// No description provided for @taskInspectionTitleNoHive.
  ///
  /// In en, this message translates to:
  /// **'Check again'**
  String get taskInspectionTitleNoHive;

  /// No description provided for @taskTreatmentTitle.
  ///
  /// In en, this message translates to:
  /// **'Hive {number} · remove strips'**
  String taskTreatmentTitle(String number);

  /// No description provided for @taskTreatmentTitleApiary.
  ///
  /// In en, this message translates to:
  /// **'Remove strips'**
  String get taskTreatmentTitleApiary;

  /// No description provided for @taskReminderBody.
  ///
  /// In en, this message translates to:
  /// **'Your task is due.'**
  String get taskReminderBody;

  /// No description provided for @taskAssigneeMe.
  ///
  /// In en, this message translates to:
  /// **'Me'**
  String get taskAssigneeMe;

  /// No description provided for @taskAssignedTo.
  ///
  /// In en, this message translates to:
  /// **'Assigned to {name}'**
  String taskAssignedTo(String name);

  /// No description provided for @taskMemberNumbered.
  ///
  /// In en, this message translates to:
  /// **'{role} {index}'**
  String taskMemberNumbered(String role, int index);

  /// No description provided for @roleOwner.
  ///
  /// In en, this message translates to:
  /// **'Owner'**
  String get roleOwner;

  /// No description provided for @rolePartner.
  ///
  /// In en, this message translates to:
  /// **'Partner'**
  String get rolePartner;

  /// No description provided for @roleWorker.
  ///
  /// In en, this message translates to:
  /// **'Worker'**
  String get roleWorker;

  /// No description provided for @roleViewer.
  ///
  /// In en, this message translates to:
  /// **'Viewer'**
  String get roleViewer;

  /// No description provided for @taskCompleteAction.
  ///
  /// In en, this message translates to:
  /// **'Complete: {title}'**
  String taskCompleteAction(String title);

  /// No description provided for @taskCompleted.
  ///
  /// In en, this message translates to:
  /// **'Task completed'**
  String get taskCompleted;

  /// No description provided for @taskFormNewTitle.
  ///
  /// In en, this message translates to:
  /// **'New task'**
  String get taskFormNewTitle;

  /// No description provided for @taskFormEditTitle.
  ///
  /// In en, this message translates to:
  /// **'Edit task'**
  String get taskFormEditTitle;

  /// No description provided for @taskFormName.
  ///
  /// In en, this message translates to:
  /// **'Task'**
  String get taskFormName;

  /// No description provided for @taskFormNameHint.
  ///
  /// In en, this message translates to:
  /// **'e.g. Visit the upland apiary'**
  String get taskFormNameHint;

  /// No description provided for @taskFormDue.
  ///
  /// In en, this message translates to:
  /// **'Due'**
  String get taskFormDue;

  /// No description provided for @taskFormPickDate.
  ///
  /// In en, this message translates to:
  /// **'Other day'**
  String get taskFormPickDate;

  /// No description provided for @taskFormTime.
  ///
  /// In en, this message translates to:
  /// **'Time'**
  String get taskFormTime;

  /// No description provided for @taskFormApiary.
  ///
  /// In en, this message translates to:
  /// **'Apiary'**
  String get taskFormApiary;

  /// No description provided for @taskFormHive.
  ///
  /// In en, this message translates to:
  /// **'Hive'**
  String get taskFormHive;

  /// No description provided for @taskFormNone.
  ///
  /// In en, this message translates to:
  /// **'None'**
  String get taskFormNone;

  /// No description provided for @taskFormChooseApiary.
  ///
  /// In en, this message translates to:
  /// **'Choose apiary'**
  String get taskFormChooseApiary;

  /// No description provided for @taskFormChooseHive.
  ///
  /// In en, this message translates to:
  /// **'Choose hive'**
  String get taskFormChooseHive;

  /// No description provided for @taskFormAssignee.
  ///
  /// In en, this message translates to:
  /// **'Assigned to'**
  String get taskFormAssignee;

  /// No description provided for @taskFormUnassigned.
  ///
  /// In en, this message translates to:
  /// **'Unassigned'**
  String get taskFormUnassigned;

  /// No description provided for @taskFormCompleted.
  ///
  /// In en, this message translates to:
  /// **'Done'**
  String get taskFormCompleted;

  /// No description provided for @taskFormSave.
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get taskFormSave;

  /// No description provided for @taskFormDelete.
  ///
  /// In en, this message translates to:
  /// **'Delete task'**
  String get taskFormDelete;

  /// No description provided for @taskDeleteTitle.
  ///
  /// In en, this message translates to:
  /// **'Delete this task?'**
  String get taskDeleteTitle;

  /// No description provided for @taskDeleteMessage.
  ///
  /// In en, this message translates to:
  /// **'The task is removed from every phone.'**
  String get taskDeleteMessage;

  /// No description provided for @taskDeleteConfirm.
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get taskDeleteConfirm;

  /// No description provided for @taskSaved.
  ///
  /// In en, this message translates to:
  /// **'Task saved'**
  String get taskSaved;

  /// No description provided for @taskDeleted.
  ///
  /// In en, this message translates to:
  /// **'Task deleted'**
  String get taskDeleted;

  /// No description provided for @taskNotFound.
  ///
  /// In en, this message translates to:
  /// **'Task not found; it may have been deleted.'**
  String get taskNotFound;

  /// No description provided for @taskReminderDenied.
  ///
  /// In en, this message translates to:
  /// **'Notifications are off; the reminder won\'t ring.'**
  String get taskReminderDenied;

  /// No description provided for @exactAlarmTitle.
  ///
  /// In en, this message translates to:
  /// **'Ring reminders right on time?'**
  String get exactAlarmTitle;

  /// No description provided for @exactAlarmMessage.
  ///
  /// In en, this message translates to:
  /// **'Android may delay notifications by a few minutes to save battery. Allow Mobil Arıcı in the setting that opens and task reminders ring right on time. No internet needed.'**
  String get exactAlarmMessage;

  /// No description provided for @exactAlarmConfirm.
  ///
  /// In en, this message translates to:
  /// **'Open setting'**
  String get exactAlarmConfirm;

  /// No description provided for @settingsReminders.
  ///
  /// In en, this message translates to:
  /// **'Reminders'**
  String get settingsReminders;

  /// No description provided for @settingsExactAlarms.
  ///
  /// In en, this message translates to:
  /// **'Ring right on time'**
  String get settingsExactAlarms;

  /// No description provided for @settingsExactAlarmsOn.
  ///
  /// In en, this message translates to:
  /// **'On'**
  String get settingsExactAlarmsOn;

  /// No description provided for @settingsExactAlarmsOff.
  ///
  /// In en, this message translates to:
  /// **'Off · may be a few minutes late'**
  String get settingsExactAlarmsOff;

  /// WeatherAPI.com attribution shown wherever weather appears; keep this exact English text in every language.
  ///
  /// In en, this message translates to:
  /// **'Powered by WeatherAPI.com'**
  String get weatherAttribution;

  /// Temperature in the user's unit, without the unit letter.
  ///
  /// In en, this message translates to:
  /// **'{value}°'**
  String weatherTemperature(String value);

  /// No description provided for @weatherWind.
  ///
  /// In en, this message translates to:
  /// **'Wind {speed} km/h'**
  String weatherWind(String speed);

  /// Shown when the stored weather bundle is older than an hour (e.g. offline).
  ///
  /// In en, this message translates to:
  /// **'Forecast as of {time}'**
  String weatherForecastAsOf(String time);

  /// Green badge: weather is fine for opening hives.
  ///
  /// In en, this message translates to:
  /// **'Good to open'**
  String get hiveOpeningSuitable;

  /// No description provided for @hiveOpeningCautionRain.
  ///
  /// In en, this message translates to:
  /// **'Rain possible'**
  String get hiveOpeningCautionRain;

  /// No description provided for @hiveOpeningCautionWind.
  ///
  /// In en, this message translates to:
  /// **'Windy'**
  String get hiveOpeningCautionWind;

  /// No description provided for @hiveOpeningCautionCold.
  ///
  /// In en, this message translates to:
  /// **'Cool'**
  String get hiveOpeningCautionCold;

  /// No description provided for @hiveOpeningUnsuitableRain.
  ///
  /// In en, this message translates to:
  /// **'Raining'**
  String get hiveOpeningUnsuitableRain;

  /// No description provided for @hiveOpeningUnsuitableWind.
  ///
  /// In en, this message translates to:
  /// **'Strong wind'**
  String get hiveOpeningUnsuitableWind;

  /// No description provided for @hiveOpeningUnsuitableCold.
  ///
  /// In en, this message translates to:
  /// **'Too cold'**
  String get hiveOpeningUnsuitableCold;

  /// No description provided for @todayGreetingMorning.
  ///
  /// In en, this message translates to:
  /// **'Good morning'**
  String get todayGreetingMorning;

  /// No description provided for @todayGreetingAfternoon.
  ///
  /// In en, this message translates to:
  /// **'Good afternoon'**
  String get todayGreetingAfternoon;

  /// No description provided for @todayGreetingEvening.
  ///
  /// In en, this message translates to:
  /// **'Good evening'**
  String get todayGreetingEvening;

  /// No description provided for @todayAttentionTitle.
  ///
  /// In en, this message translates to:
  /// **'Needs attention'**
  String get todayAttentionTitle;

  /// No description provided for @todayAttentionHiveCount.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{1 hive} other{{count} hives}}'**
  String todayAttentionHiveCount(int count);

  /// No description provided for @todayAttentionNone.
  ///
  /// In en, this message translates to:
  /// **'No hives need attention'**
  String get todayAttentionNone;

  /// No description provided for @todayTasksTitle.
  ///
  /// In en, this message translates to:
  /// **'Today'**
  String get todayTasksTitle;

  /// No description provided for @todayTasksCount.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{1 task} other{{count} tasks}}'**
  String todayTasksCount(int count);

  /// No description provided for @todayTasksApiaryCount.
  ///
  /// In en, this message translates to:
  /// **'{apiary} · {count, plural, =1{1 task} other{{count} tasks}}'**
  String todayTasksApiaryCount(String apiary, int count);

  /// No description provided for @todaySetupProgress.
  ///
  /// In en, this message translates to:
  /// **'Setup {done}/{total}'**
  String todaySetupProgress(int done, int total);

  /// No description provided for @setupStepApiary.
  ///
  /// In en, this message translates to:
  /// **'Add your apiary'**
  String get setupStepApiary;

  /// No description provided for @setupStepHives.
  ///
  /// In en, this message translates to:
  /// **'Create your hives'**
  String get setupStepHives;

  /// No description provided for @setupStepInspection.
  ///
  /// In en, this message translates to:
  /// **'Do your first inspection'**
  String get setupStepInspection;

  /// No description provided for @setupStepDone.
  ///
  /// In en, this message translates to:
  /// **'{step}: done'**
  String setupStepDone(String step);

  /// No description provided for @attentionQueenless.
  ///
  /// In en, this message translates to:
  /// **'Queenless'**
  String get attentionQueenless;

  /// No description provided for @attentionWeak.
  ///
  /// In en, this message translates to:
  /// **'Weak'**
  String get attentionWeak;

  /// No description provided for @attentionSwarming.
  ///
  /// In en, this message translates to:
  /// **'Swarm signs'**
  String get attentionSwarming;

  /// No description provided for @attentionTreatmentRemoval.
  ///
  /// In en, this message translates to:
  /// **'Treatment to remove'**
  String get attentionTreatmentRemoval;

  /// No description provided for @attentionQueenlessTitle.
  ///
  /// In en, this message translates to:
  /// **'Queenless hives'**
  String get attentionQueenlessTitle;

  /// No description provided for @attentionWeakTitle.
  ///
  /// In en, this message translates to:
  /// **'Weak hives'**
  String get attentionWeakTitle;

  /// No description provided for @attentionSwarmingTitle.
  ///
  /// In en, this message translates to:
  /// **'Hives with swarm signs'**
  String get attentionSwarmingTitle;

  /// No description provided for @attentionTreatmentRemovalTitle.
  ///
  /// In en, this message translates to:
  /// **'Treatments to remove'**
  String get attentionTreatmentRemovalTitle;

  /// No description provided for @attentionQueenlessIntro.
  ///
  /// In en, this message translates to:
  /// **'Active hives whose last inspection found no queen and no eggs.'**
  String get attentionQueenlessIntro;

  /// No description provided for @attentionWeakIntro.
  ///
  /// In en, this message translates to:
  /// **'Active hives with strength {max}/5 or lower at their last inspection.'**
  String attentionWeakIntro(int max);

  /// No description provided for @attentionSwarmingIntro.
  ///
  /// In en, this message translates to:
  /// **'Active hives whose last inspection showed swarm signs or swarm cells.'**
  String get attentionSwarmingIntro;

  /// No description provided for @attentionTreatmentRemovalIntro.
  ///
  /// In en, this message translates to:
  /// **'Hives whose strip removal is due and the task isn\'t done yet.'**
  String get attentionTreatmentRemovalIntro;

  /// No description provided for @attentionEmpty.
  ///
  /// In en, this message translates to:
  /// **'No hives in this group.'**
  String get attentionEmpty;

  /// No description provided for @attentionLastInspection.
  ///
  /// In en, this message translates to:
  /// **'Last inspection: {date}'**
  String attentionLastInspection(String date);

  /// No description provided for @attentionRemovalDue.
  ///
  /// In en, this message translates to:
  /// **'Removal due: {date}'**
  String attentionRemovalDue(String date);

  /// No description provided for @syncTableHarvests.
  ///
  /// In en, this message translates to:
  /// **'Harvest'**
  String get syncTableHarvests;

  /// No description provided for @syncTableHarvestHives.
  ///
  /// In en, this message translates to:
  /// **'Harvested hive'**
  String get syncTableHarvestHives;

  /// No description provided for @withdrawalLockHarvestMessage.
  ///
  /// In en, this message translates to:
  /// **'Hive {number} is being treated with {product}. It shouldn\'t be harvested before {date}; honey from this period may carry drug residue.'**
  String withdrawalLockHarvestMessage(
    String number,
    String product,
    String date,
  );

  /// No description provided for @withdrawalReasonNotForSaleHarvest.
  ///
  /// In en, this message translates to:
  /// **'Honey won\'t be sold (own use/feed)'**
  String get withdrawalReasonNotForSaleHarvest;

  /// No description provided for @withdrawalHarvestCancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel, don\'t harvest'**
  String get withdrawalHarvestCancel;

  /// No description provided for @withdrawalHarvestProceed.
  ///
  /// In en, this message translates to:
  /// **'Harvest anyway'**
  String get withdrawalHarvestProceed;

  /// No description provided for @apiaryHarvest.
  ///
  /// In en, this message translates to:
  /// **'Harvest'**
  String get apiaryHarvest;

  /// No description provided for @harvestFormTitle.
  ///
  /// In en, this message translates to:
  /// **'Harvest · {apiary}'**
  String harvestFormTitle(String apiary);

  /// No description provided for @harvestSelectedCount.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =0{No hives selected} =1{1 hive selected} other{{count} hives selected}}'**
  String harvestSelectedCount(int count);

  /// No description provided for @harvestSelectedHint.
  ///
  /// In en, this message translates to:
  /// **'{numbers} · tap to change or scan to add'**
  String harvestSelectedHint(String numbers);

  /// No description provided for @harvestSelectedEmptyHint.
  ///
  /// In en, this message translates to:
  /// **'Tap to pick hives or scan them'**
  String get harvestSelectedEmptyHint;

  /// No description provided for @harvestScan.
  ///
  /// In en, this message translates to:
  /// **'Scan'**
  String get harvestScan;

  /// No description provided for @harvestLockedTitle.
  ///
  /// In en, this message translates to:
  /// **'{numbers} in withdrawal period.'**
  String harvestLockedTitle(String numbers);

  /// No description provided for @harvestLockedMessage.
  ///
  /// In en, this message translates to:
  /// **'Not harvested. To take one anyway, pick it in the hive list.'**
  String get harvestLockedMessage;

  /// No description provided for @harvestDate.
  ///
  /// In en, this message translates to:
  /// **'Date'**
  String get harvestDate;

  /// No description provided for @harvestToday.
  ///
  /// In en, this message translates to:
  /// **'Today'**
  String get harvestToday;

  /// No description provided for @harvestYesterday.
  ///
  /// In en, this message translates to:
  /// **'Yesterday'**
  String get harvestYesterday;

  /// No description provided for @harvestPickDate.
  ///
  /// In en, this message translates to:
  /// **'Other day'**
  String get harvestPickDate;

  /// No description provided for @harvestHoneyKind.
  ///
  /// In en, this message translates to:
  /// **'Honey type'**
  String get harvestHoneyKind;

  /// No description provided for @honeyKindPine.
  ///
  /// In en, this message translates to:
  /// **'Pine'**
  String get honeyKindPine;

  /// No description provided for @honeyKindFlower.
  ///
  /// In en, this message translates to:
  /// **'Flower'**
  String get honeyKindFlower;

  /// No description provided for @honeyKindChestnut.
  ///
  /// In en, this message translates to:
  /// **'Chestnut'**
  String get honeyKindChestnut;

  /// No description provided for @honeyKindCitrus.
  ///
  /// In en, this message translates to:
  /// **'Citrus'**
  String get honeyKindCitrus;

  /// No description provided for @honeyKindOther.
  ///
  /// In en, this message translates to:
  /// **'Other'**
  String get honeyKindOther;

  /// No description provided for @harvestUnit.
  ///
  /// In en, this message translates to:
  /// **'Taken as'**
  String get harvestUnit;

  /// No description provided for @harvestUnitSuper.
  ///
  /// In en, this message translates to:
  /// **'Supers'**
  String get harvestUnitSuper;

  /// No description provided for @harvestUnitFrame.
  ///
  /// In en, this message translates to:
  /// **'Frames'**
  String get harvestUnitFrame;

  /// No description provided for @harvestTakenSupers.
  ///
  /// In en, this message translates to:
  /// **'Supers taken'**
  String get harvestTakenSupers;

  /// No description provided for @harvestTakenFrames.
  ///
  /// In en, this message translates to:
  /// **'Frames taken'**
  String get harvestTakenFrames;

  /// No description provided for @harvestWeight.
  ///
  /// In en, this message translates to:
  /// **'Extracted honey ({unit})'**
  String harvestWeight(String unit);

  /// No description provided for @harvestWeightInvalid.
  ///
  /// In en, this message translates to:
  /// **'Enter a weight like 574 or 574.5'**
  String get harvestWeightInvalid;

  /// No description provided for @harvestWeightTooLarge.
  ///
  /// In en, this message translates to:
  /// **'At most {max} {unit}'**
  String harvestWeightTooLarge(String max, String unit);

  /// No description provided for @harvestPerHive.
  ///
  /// In en, this message translates to:
  /// **'Per hive'**
  String get harvestPerHive;

  /// No description provided for @harvestWeightValue.
  ///
  /// In en, this message translates to:
  /// **'{value} {unit}'**
  String harvestWeightValue(String value, String unit);

  /// No description provided for @harvestSave.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =0{No hives to harvest} other{Save harvest}}'**
  String harvestSave(int count);

  /// No description provided for @harvestSaved.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{Harvest saved for 1 hive} other{Harvest saved for {count} hives}}'**
  String harvestSaved(int count);

  /// No description provided for @harvestHivesTitle.
  ///
  /// In en, this message translates to:
  /// **'Hives to harvest'**
  String get harvestHivesTitle;

  /// No description provided for @harvestSelectAll.
  ///
  /// In en, this message translates to:
  /// **'Select all'**
  String get harvestSelectAll;

  /// No description provided for @harvestSelectNone.
  ///
  /// In en, this message translates to:
  /// **'Select none'**
  String get harvestSelectNone;

  /// No description provided for @harvestHiveLocked.
  ///
  /// In en, this message translates to:
  /// **'Withdrawal · {days, plural, =1{1 day} other{{days} days}} left'**
  String harvestHiveLocked(int days);

  /// No description provided for @harvestHiveOverridden.
  ///
  /// In en, this message translates to:
  /// **'Taken anyway: {reason}'**
  String harvestHiveOverridden(String reason);

  /// No description provided for @harvestHivesDone.
  ///
  /// In en, this message translates to:
  /// **'Done'**
  String get harvestHivesDone;

  /// No description provided for @harvestNoActiveHives.
  ///
  /// In en, this message translates to:
  /// **'This apiary has no active hives.'**
  String get harvestNoActiveHives;

  /// No description provided for @harvestScanTitle.
  ///
  /// In en, this message translates to:
  /// **'Scan for harvest'**
  String get harvestScanTitle;

  /// No description provided for @harvestScanAdded.
  ///
  /// In en, this message translates to:
  /// **'Hive {number} added'**
  String harvestScanAdded(String number);

  /// No description provided for @harvestScanAlready.
  ///
  /// In en, this message translates to:
  /// **'Hive {number} is already selected'**
  String harvestScanAlready(String number);

  /// No description provided for @harvestScanOtherApiary.
  ///
  /// In en, this message translates to:
  /// **'Hive {number} isn\'t in this apiary'**
  String harvestScanOtherApiary(String number);

  /// No description provided for @harvestScanInactive.
  ///
  /// In en, this message translates to:
  /// **'Hive {number} isn\'t active'**
  String harvestScanInactive(String number);

  /// No description provided for @harvestScanUnknown.
  ///
  /// In en, this message translates to:
  /// **'This label isn\'t linked to a hive'**
  String get harvestScanUnknown;

  /// No description provided for @harvestScanDone.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =0{Done} =1{Done · 1 hive} other{Done · {count} hives}}'**
  String harvestScanDone(int count);

  /// No description provided for @apiaryTourStart.
  ///
  /// In en, this message translates to:
  /// **'Start tour'**
  String get apiaryTourStart;

  /// No description provided for @apiaryTourResume.
  ///
  /// In en, this message translates to:
  /// **'Resume tour'**
  String get apiaryTourResume;

  /// No description provided for @tourReplaceTitle.
  ///
  /// In en, this message translates to:
  /// **'End the current tour?'**
  String get tourReplaceTitle;

  /// No description provided for @tourReplaceMessage.
  ///
  /// In en, this message translates to:
  /// **'The {apiary} tour is still running. Starting a new tour clears its progress; the inspections stay saved.'**
  String tourReplaceMessage(String apiary);

  /// No description provided for @tourReplaceConfirm.
  ///
  /// In en, this message translates to:
  /// **'Start new tour'**
  String get tourReplaceConfirm;

  /// No description provided for @tourTitle.
  ///
  /// In en, this message translates to:
  /// **'{apiary} tour'**
  String tourTitle(String apiary);

  /// No description provided for @tourFinish.
  ///
  /// In en, this message translates to:
  /// **'Finish tour'**
  String get tourFinish;

  /// No description provided for @tourProgress.
  ///
  /// In en, this message translates to:
  /// **'{done} / {total}'**
  String tourProgress(int done, int total);

  /// No description provided for @tourProgressLabel.
  ///
  /// In en, this message translates to:
  /// **'{done} of {total} hives done'**
  String tourProgressLabel(int done, int total);

  /// No description provided for @tourMinutes.
  ///
  /// In en, this message translates to:
  /// **'{minutes} min'**
  String tourMinutes(int minutes);

  /// No description provided for @tourHoursMinutes.
  ///
  /// In en, this message translates to:
  /// **'{hours} h {minutes} min'**
  String tourHoursMinutes(int hours, int minutes);

  /// No description provided for @tourElapsedLabel.
  ///
  /// In en, this message translates to:
  /// **'Time elapsed: {duration}'**
  String tourElapsedLabel(String duration);

  /// No description provided for @tourNext.
  ///
  /// In en, this message translates to:
  /// **'Next up'**
  String get tourNext;

  /// No description provided for @tourPreviousVisit.
  ///
  /// In en, this message translates to:
  /// **'Last time · {date}'**
  String tourPreviousVisit(String date);

  /// No description provided for @tourQueue.
  ///
  /// In en, this message translates to:
  /// **'Order'**
  String get tourQueue;

  /// No description provided for @tourSkippedCount.
  ///
  /// In en, this message translates to:
  /// **'{count} skipped'**
  String tourSkippedCount(int count);

  /// No description provided for @tourStateDone.
  ///
  /// In en, this message translates to:
  /// **'Done'**
  String get tourStateDone;

  /// No description provided for @tourStateSkipped.
  ///
  /// In en, this message translates to:
  /// **'Skipped'**
  String get tourStateSkipped;

  /// No description provided for @tourStatePending.
  ///
  /// In en, this message translates to:
  /// **'Waiting'**
  String get tourStatePending;

  /// No description provided for @tourStateNext.
  ///
  /// In en, this message translates to:
  /// **'Next'**
  String get tourStateNext;

  /// No description provided for @tourHiveSemantics.
  ///
  /// In en, this message translates to:
  /// **'Hive {number}, {state}'**
  String tourHiveSemantics(String number, String state);

  /// No description provided for @tourSkip.
  ///
  /// In en, this message translates to:
  /// **'Skip'**
  String get tourSkip;

  /// No description provided for @tourInspect.
  ///
  /// In en, this message translates to:
  /// **'Inspect {number}'**
  String tourInspect(String number);

  /// No description provided for @tourAllDone.
  ///
  /// In en, this message translates to:
  /// **'Every hive has been inspected.'**
  String get tourAllDone;

  /// No description provided for @tourSunSuggestion.
  ///
  /// In en, this message translates to:
  /// **'Sun mode makes the screen easier to read in bright light.'**
  String get tourSunSuggestion;

  /// No description provided for @tourSunOn.
  ///
  /// In en, this message translates to:
  /// **'Turn on sun mode'**
  String get tourSunOn;

  /// No description provided for @tourSunMode.
  ///
  /// In en, this message translates to:
  /// **'Sun mode'**
  String get tourSunMode;

  /// No description provided for @tourFinishTitle.
  ///
  /// In en, this message translates to:
  /// **'Finish the tour?'**
  String get tourFinishTitle;

  /// No description provided for @tourFinishMessage.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{1 hive hasn\'t been inspected; the summary counts it as skipped.} other{{count} hives haven\'t been inspected; the summary counts them as skipped.}}'**
  String tourFinishMessage(int count);

  /// No description provided for @tourNotFound.
  ///
  /// In en, this message translates to:
  /// **'There\'s no tour running in this apiary.'**
  String get tourNotFound;

  /// No description provided for @tourCompleteTitle.
  ///
  /// In en, this message translates to:
  /// **'Tour complete'**
  String get tourCompleteTitle;

  /// No description provided for @tourInspectedCount.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{1 hive inspected} other{{count} hives inspected}}'**
  String tourInspectedCount(int count);

  /// No description provided for @tourHealthy.
  ///
  /// In en, this message translates to:
  /// **'Strong / fair'**
  String get tourHealthy;

  /// No description provided for @tourTasksTitle.
  ///
  /// In en, this message translates to:
  /// **'Tasks'**
  String get tourTasksTitle;

  /// No description provided for @tourTaskRequeen.
  ///
  /// In en, this message translates to:
  /// **'Requeen: {numbers}'**
  String tourTaskRequeen(String numbers);

  /// No description provided for @tourTaskFeedWeak.
  ///
  /// In en, this message translates to:
  /// **'Feed 1:1 syrup: {numbers}'**
  String tourTaskFeedWeak(String numbers);

  /// No description provided for @tourTaskSwarmCheck.
  ///
  /// In en, this message translates to:
  /// **'Swarm check: {numbers}'**
  String tourTaskSwarmCheck(String numbers);

  /// No description provided for @tourTaskRevisit.
  ///
  /// In en, this message translates to:
  /// **'Check skipped hives: {numbers}'**
  String tourTaskRevisit(String numbers);

  /// No description provided for @tourTaskMoreNumbers.
  ///
  /// In en, this message translates to:
  /// **'{numbers} +{count}'**
  String tourTaskMoreNumbers(String numbers, int count);

  /// No description provided for @tourTaskDue.
  ///
  /// In en, this message translates to:
  /// **'{days, plural, =0{today} =1{tomorrow} other{in {days} days}}'**
  String tourTaskDue(int days);

  /// No description provided for @tourSaveTasks.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =0{Close} =1{Save task} other{Save tasks}}'**
  String tourSaveTasks(int count);

  /// No description provided for @tourTasksSaved.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{1 task saved} other{{count} tasks saved}}'**
  String tourTasksSaved(int count);

  /// No description provided for @tourNoTasks.
  ///
  /// In en, this message translates to:
  /// **'No tasks to suggest.'**
  String get tourNoTasks;

  /// No description provided for @reportsTitle.
  ///
  /// In en, this message translates to:
  /// **'Reports'**
  String get reportsTitle;

  /// No description provided for @reportTreatmentRegister.
  ///
  /// In en, this message translates to:
  /// **'Treatment register'**
  String get reportTreatmentRegister;

  /// No description provided for @reportTreatmentRegisterHint.
  ///
  /// In en, this message translates to:
  /// **'For inspections'**
  String get reportTreatmentRegisterHint;

  /// No description provided for @reportHiveHistory.
  ///
  /// In en, this message translates to:
  /// **'Hive history'**
  String get reportHiveHistory;

  /// No description provided for @reportHiveHistoryHint.
  ///
  /// In en, this message translates to:
  /// **'One hive or an apiary'**
  String get reportHiveHistoryHint;

  /// No description provided for @reportFrom.
  ///
  /// In en, this message translates to:
  /// **'From'**
  String get reportFrom;

  /// No description provided for @reportTo.
  ///
  /// In en, this message translates to:
  /// **'To'**
  String get reportTo;

  /// No description provided for @reportApiary.
  ///
  /// In en, this message translates to:
  /// **'Apiary'**
  String get reportApiary;

  /// No description provided for @reportAllApiaries.
  ///
  /// In en, this message translates to:
  /// **'All apiaries'**
  String get reportAllApiaries;

  /// No description provided for @reportHive.
  ///
  /// In en, this message translates to:
  /// **'Hive'**
  String get reportHive;

  /// No description provided for @reportAllHives.
  ///
  /// In en, this message translates to:
  /// **'All hives'**
  String get reportAllHives;

  /// No description provided for @reportLanguage.
  ///
  /// In en, this message translates to:
  /// **'PDF language'**
  String get reportLanguage;

  /// No description provided for @reportLanguageTurkish.
  ///
  /// In en, this message translates to:
  /// **'Türkçe'**
  String get reportLanguageTurkish;

  /// No description provided for @reportLanguageEnglish.
  ///
  /// In en, this message translates to:
  /// **'English'**
  String get reportLanguageEnglish;

  /// No description provided for @reportRegistrationNo.
  ///
  /// In en, this message translates to:
  /// **'Holding registration no.'**
  String get reportRegistrationNo;

  /// No description provided for @reportAksNo.
  ///
  /// In en, this message translates to:
  /// **'AKS no.'**
  String get reportAksNo;

  /// No description provided for @reportRecordNo.
  ///
  /// In en, this message translates to:
  /// **'Registration number'**
  String get reportRecordNo;

  /// No description provided for @reportNumbersHelper.
  ///
  /// In en, this message translates to:
  /// **'Printed in the PDF header only; not saved.'**
  String get reportNumbersHelper;

  /// No description provided for @reportShare.
  ///
  /// In en, this message translates to:
  /// **'Share'**
  String get reportShare;

  /// No description provided for @reportCreate.
  ///
  /// In en, this message translates to:
  /// **'Create PDF'**
  String get reportCreate;

  /// No description provided for @reportPreparing.
  ///
  /// In en, this message translates to:
  /// **'Preparing the PDF…'**
  String get reportPreparing;

  /// No description provided for @reportError.
  ///
  /// In en, this message translates to:
  /// **'Couldn\'t create the PDF. Try again.'**
  String get reportError;

  /// No description provided for @reportLoadError.
  ///
  /// In en, this message translates to:
  /// **'Couldn\'t read the records.'**
  String get reportLoadError;

  /// No description provided for @reportEmpty.
  ///
  /// In en, this message translates to:
  /// **'No records in this period.'**
  String get reportEmpty;

  /// No description provided for @reportTreatmentCount.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{1 treatment} other{{count} treatments}}'**
  String reportTreatmentCount(int count);

  /// No description provided for @reportHiveCount.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{1 hive} other{{count} hives}}'**
  String reportHiveCount(int count);

  /// No description provided for @reportRecordCount.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{1 record} other{{count} records}}'**
  String reportRecordCount(int count);

  /// No description provided for @reportNoValue.
  ///
  /// In en, this message translates to:
  /// **'—'**
  String get reportNoValue;

  /// No description provided for @pdfTreatmentRegisterTitle.
  ///
  /// In en, this message translates to:
  /// **'Treatment Register'**
  String get pdfTreatmentRegisterTitle;

  /// No description provided for @pdfHiveHistoryTitle.
  ///
  /// In en, this message translates to:
  /// **'Hive History'**
  String get pdfHiveHistoryTitle;

  /// No description provided for @pdfRegistrationNo.
  ///
  /// In en, this message translates to:
  /// **'Holding registration no. {number}'**
  String pdfRegistrationNo(String number);

  /// No description provided for @pdfAksNo.
  ///
  /// In en, this message translates to:
  /// **'AKS no. {number}'**
  String pdfAksNo(String number);

  /// No description provided for @pdfRecordNo.
  ///
  /// In en, this message translates to:
  /// **'Registration no. {number}'**
  String pdfRecordNo(String number);

  /// No description provided for @pdfPeriod.
  ///
  /// In en, this message translates to:
  /// **'Period: {from} – {to}'**
  String pdfPeriod(String from, String to);

  /// No description provided for @pdfApiary.
  ///
  /// In en, this message translates to:
  /// **'Apiary: {name}'**
  String pdfApiary(String name);

  /// No description provided for @pdfCreated.
  ///
  /// In en, this message translates to:
  /// **'Created {date}'**
  String pdfCreated(String date);

  /// No description provided for @pdfPage.
  ///
  /// In en, this message translates to:
  /// **'Page {page} of {pages}'**
  String pdfPage(int page, int pages);

  /// No description provided for @pdfColumnDate.
  ///
  /// In en, this message translates to:
  /// **'Date'**
  String get pdfColumnDate;

  /// No description provided for @pdfColumnApiary.
  ///
  /// In en, this message translates to:
  /// **'Apiary'**
  String get pdfColumnApiary;

  /// No description provided for @pdfColumnProduct.
  ///
  /// In en, this message translates to:
  /// **'Product / batch'**
  String get pdfColumnProduct;

  /// No description provided for @pdfColumnHives.
  ///
  /// In en, this message translates to:
  /// **'Hives'**
  String get pdfColumnHives;

  /// No description provided for @pdfColumnDose.
  ///
  /// In en, this message translates to:
  /// **'Dose per hive'**
  String get pdfColumnDose;

  /// No description provided for @pdfColumnRemoval.
  ///
  /// In en, this message translates to:
  /// **'Removal'**
  String get pdfColumnRemoval;

  /// No description provided for @pdfColumnWithdrawalEnd.
  ///
  /// In en, this message translates to:
  /// **'Withdrawal ends'**
  String get pdfColumnWithdrawalEnd;

  /// No description provided for @pdfColumnEvent.
  ///
  /// In en, this message translates to:
  /// **'Record'**
  String get pdfColumnEvent;

  /// No description provided for @pdfColumnDetails.
  ///
  /// In en, this message translates to:
  /// **'Details'**
  String get pdfColumnDetails;

  /// No description provided for @pdfEventFeeding.
  ///
  /// In en, this message translates to:
  /// **'Feeding'**
  String get pdfEventFeeding;

  /// No description provided for @pdfEventVarroa.
  ///
  /// In en, this message translates to:
  /// **'Varroa count'**
  String get pdfEventVarroa;

  /// No description provided for @pdfEventHarvest.
  ///
  /// In en, this message translates to:
  /// **'Harvest'**
  String get pdfEventHarvest;

  /// No description provided for @pdfHarvestTotal.
  ///
  /// In en, this message translates to:
  /// **'Whole harvest: {amount}'**
  String pdfHarvestTotal(String amount);

  /// No description provided for @pdfDocumentName.
  ///
  /// In en, this message translates to:
  /// **'{title} {from}–{to}'**
  String pdfDocumentName(String title, String from, String to);

  /// No description provided for @moreFeedback.
  ///
  /// In en, this message translates to:
  /// **'Send feedback'**
  String get moreFeedback;

  /// No description provided for @feedbackTitle.
  ///
  /// In en, this message translates to:
  /// **'Send feedback'**
  String get feedbackTitle;

  /// No description provided for @feedbackIntro.
  ///
  /// In en, this message translates to:
  /// **'We\'re building this app together with beekeepers. We read every message.'**
  String get feedbackIntro;

  /// No description provided for @feedbackKindLabel.
  ///
  /// In en, this message translates to:
  /// **'What is it about?'**
  String get feedbackKindLabel;

  /// No description provided for @feedbackKindBug.
  ///
  /// In en, this message translates to:
  /// **'Bug'**
  String get feedbackKindBug;

  /// No description provided for @feedbackKindSuggestion.
  ///
  /// In en, this message translates to:
  /// **'Suggestion'**
  String get feedbackKindSuggestion;

  /// No description provided for @feedbackKindMissingFeature.
  ///
  /// In en, this message translates to:
  /// **'Missing feature'**
  String get feedbackKindMissingFeature;

  /// No description provided for @feedbackKindThanks.
  ///
  /// In en, this message translates to:
  /// **'Thanks'**
  String get feedbackKindThanks;

  /// No description provided for @feedbackMessageLabel.
  ///
  /// In en, this message translates to:
  /// **'Your message'**
  String get feedbackMessageLabel;

  /// No description provided for @feedbackMessageHint.
  ///
  /// In en, this message translates to:
  /// **'What happened, and what did you expect?'**
  String get feedbackMessageHint;

  /// No description provided for @feedbackAddScreenshot.
  ///
  /// In en, this message translates to:
  /// **'Add screenshot'**
  String get feedbackAddScreenshot;

  /// No description provided for @feedbackScreenshotAttached.
  ///
  /// In en, this message translates to:
  /// **'Screenshot attached'**
  String get feedbackScreenshotAttached;

  /// No description provided for @feedbackRemoveScreenshot.
  ///
  /// In en, this message translates to:
  /// **'Remove'**
  String get feedbackRemoveScreenshot;

  /// No description provided for @feedbackScreenshotDenied.
  ///
  /// In en, this message translates to:
  /// **'Photo access wasn\'t allowed. To attach a screenshot, allow it in Settings.'**
  String get feedbackScreenshotDenied;

  /// No description provided for @feedbackIncludeDeviceInfo.
  ///
  /// In en, this message translates to:
  /// **'Include device and version info'**
  String get feedbackIncludeDeviceInfo;

  /// No description provided for @feedbackOfflineHint.
  ///
  /// In en, this message translates to:
  /// **'Without internet, the message is queued and sent once you\'re online.'**
  String get feedbackOfflineHint;

  /// No description provided for @feedbackSend.
  ///
  /// In en, this message translates to:
  /// **'Send'**
  String get feedbackSend;

  /// No description provided for @feedbackQueued.
  ///
  /// In en, this message translates to:
  /// **'Thank you! Your message is queued to be sent.'**
  String get feedbackQueued;

  /// No description provided for @settingsAnalytics.
  ///
  /// In en, this message translates to:
  /// **'Share usage data'**
  String get settingsAnalytics;

  /// No description provided for @settingsAnalyticsHint.
  ///
  /// In en, this message translates to:
  /// **'Numbers like inspection time, scan results and sync delay; your name, hives and location are never sent.'**
  String get settingsAnalyticsHint;

  /// No description provided for @teamTitle.
  ///
  /// In en, this message translates to:
  /// **'Team'**
  String get teamTitle;

  /// No description provided for @teamRoleOwner.
  ///
  /// In en, this message translates to:
  /// **'Owner'**
  String get teamRoleOwner;

  /// No description provided for @teamRolePartner.
  ///
  /// In en, this message translates to:
  /// **'Partner'**
  String get teamRolePartner;

  /// No description provided for @teamRoleWorker.
  ///
  /// In en, this message translates to:
  /// **'Worker'**
  String get teamRoleWorker;

  /// No description provided for @teamRoleViewer.
  ///
  /// In en, this message translates to:
  /// **'Advisor'**
  String get teamRoleViewer;

  /// No description provided for @teamRoleViewerSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Read only'**
  String get teamRoleViewerSubtitle;

  /// No description provided for @teamRoleHintPartner.
  ///
  /// In en, this message translates to:
  /// **'A partner enters records and sees finance.'**
  String get teamRoleHintPartner;

  /// No description provided for @teamRoleHintWorker.
  ///
  /// In en, this message translates to:
  /// **'A worker enters records but cannot see finance.'**
  String get teamRoleHintWorker;

  /// No description provided for @teamRoleHintViewer.
  ///
  /// In en, this message translates to:
  /// **'An advisor can only read and cannot enter records.'**
  String get teamRoleHintViewer;

  /// No description provided for @teamMemberSelf.
  ///
  /// In en, this message translates to:
  /// **'{name} (you)'**
  String teamMemberSelf(String name);

  /// No description provided for @teamMemberUnknown.
  ///
  /// In en, this message translates to:
  /// **'Team member'**
  String get teamMemberUnknown;

  /// No description provided for @teamMembersEmpty.
  ///
  /// In en, this message translates to:
  /// **'Members appear once sync finishes.'**
  String get teamMembersEmpty;

  /// No description provided for @teamInviteTitle.
  ///
  /// In en, this message translates to:
  /// **'Invite to the team'**
  String get teamInviteTitle;

  /// No description provided for @teamInviteHint.
  ///
  /// In en, this message translates to:
  /// **'Tell or send the code. It is valid for 48 hours.'**
  String get teamInviteHint;

  /// No description provided for @teamInviteGenerate.
  ///
  /// In en, this message translates to:
  /// **'Generate code'**
  String get teamInviteGenerate;

  /// No description provided for @teamInviteCopy.
  ///
  /// In en, this message translates to:
  /// **'Copy'**
  String get teamInviteCopy;

  /// No description provided for @teamInviteCopied.
  ///
  /// In en, this message translates to:
  /// **'Code copied.'**
  String get teamInviteCopied;

  /// No description provided for @teamInviteCodeSemantics.
  ///
  /// In en, this message translates to:
  /// **'Invite code {code}'**
  String teamInviteCodeSemantics(String code);

  /// No description provided for @teamHaveCode.
  ///
  /// In en, this message translates to:
  /// **'I have a code'**
  String get teamHaveCode;

  /// No description provided for @teamJoinTitle.
  ///
  /// In en, this message translates to:
  /// **'Join with a code'**
  String get teamJoinTitle;

  /// No description provided for @teamJoinHint.
  ///
  /// In en, this message translates to:
  /// **'Enter the 6-character code you were sent.'**
  String get teamJoinHint;

  /// No description provided for @teamJoinCodeLabel.
  ///
  /// In en, this message translates to:
  /// **'Invite code'**
  String get teamJoinCodeLabel;

  /// No description provided for @teamJoinAction.
  ///
  /// In en, this message translates to:
  /// **'Join'**
  String get teamJoinAction;

  /// No description provided for @teamJoinDone.
  ///
  /// In en, this message translates to:
  /// **'You joined the team.'**
  String get teamJoinDone;

  /// No description provided for @teamErrorOffline.
  ///
  /// In en, this message translates to:
  /// **'This needs an internet connection. Try again when you are online.'**
  String get teamErrorOffline;

  /// No description provided for @teamErrorInvalidCode.
  ///
  /// In en, this message translates to:
  /// **'The code is invalid, expired or already used.'**
  String get teamErrorInvalidCode;

  /// No description provided for @teamErrorAlreadyMember.
  ///
  /// In en, this message translates to:
  /// **'You are already a member of this team.'**
  String get teamErrorAlreadyMember;

  /// No description provided for @teamErrorForbidden.
  ///
  /// In en, this message translates to:
  /// **'You are not allowed to do this.'**
  String get teamErrorForbidden;

  /// No description provided for @teamErrorOwnerLocked.
  ///
  /// In en, this message translates to:
  /// **'The owner\'s role cannot be changed and the owner cannot be removed.'**
  String get teamErrorOwnerLocked;

  /// No description provided for @teamErrorUnknown.
  ///
  /// In en, this message translates to:
  /// **'That did not work. Try again in a moment.'**
  String get teamErrorUnknown;

  /// No description provided for @teamRemoveAction.
  ///
  /// In en, this message translates to:
  /// **'Remove from the team'**
  String get teamRemoveAction;

  /// No description provided for @teamRemoveTitle.
  ///
  /// In en, this message translates to:
  /// **'Remove from the team?'**
  String get teamRemoveTitle;

  /// No description provided for @teamRemoveMessage.
  ///
  /// In en, this message translates to:
  /// **'{name} will lose access to this business\'s records.'**
  String teamRemoveMessage(String name);

  /// No description provided for @teamRemoveConfirm.
  ///
  /// In en, this message translates to:
  /// **'Remove'**
  String get teamRemoveConfirm;

  /// No description provided for @teamRemoved.
  ///
  /// In en, this message translates to:
  /// **'{name} was removed from the team.'**
  String teamRemoved(String name);

  /// No description provided for @teamRoleChanged.
  ///
  /// In en, this message translates to:
  /// **'{name} is now {role}.'**
  String teamRoleChanged(String name, String role);

  /// No description provided for @teamActivityTitle.
  ///
  /// In en, this message translates to:
  /// **'Recent activity'**
  String get teamActivityTitle;

  /// No description provided for @teamActivityEmpty.
  ///
  /// In en, this message translates to:
  /// **'No activity yet.'**
  String get teamActivityEmpty;

  /// No description provided for @teamActivitySelf.
  ///
  /// In en, this message translates to:
  /// **'You'**
  String get teamActivitySelf;

  /// No description provided for @teamActivityInspection.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{entered 1 inspection} other{entered {count} inspections}}'**
  String teamActivityInspection(int count);

  /// No description provided for @teamActivityTreatment.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{treated 1 hive} other{treated {count} hives}}'**
  String teamActivityTreatment(int count);

  /// No description provided for @teamActivityFeeding.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{fed 1 hive} other{fed {count} hives}}'**
  String teamActivityFeeding(int count);

  /// No description provided for @teamActivityHarvest.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{recorded 1 harvest} other{recorded {count} harvests}}'**
  String teamActivityHarvest(int count);

  /// No description provided for @teamActivityMiteCount.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{entered 1 varroa count} other{entered {count} varroa counts}}'**
  String teamActivityMiteCount(int count);

  /// No description provided for @teamActivityTask.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{added 1 task} other{added {count} tasks}}'**
  String teamActivityTask(int count);

  /// No description provided for @teamActivityJustNow.
  ///
  /// In en, this message translates to:
  /// **'just now'**
  String get teamActivityJustNow;

  /// No description provided for @teamActivityMinutesAgo.
  ///
  /// In en, this message translates to:
  /// **'{count} min ago'**
  String teamActivityMinutesAgo(int count);

  /// No description provided for @teamActivityHoursAgo.
  ///
  /// In en, this message translates to:
  /// **'{count} h ago'**
  String teamActivityHoursAgo(int count);

  /// No description provided for @teamActivityYesterday.
  ///
  /// In en, this message translates to:
  /// **'yesterday'**
  String get teamActivityYesterday;

  /// No description provided for @teamActivityDaysAgo.
  ///
  /// In en, this message translates to:
  /// **'{count} days ago'**
  String teamActivityDaysAgo(int count);

  /// No description provided for @teamActivityLine.
  ///
  /// In en, this message translates to:
  /// **'{what}{where} · {when}'**
  String teamActivityLine(String what, String where, String when);

  /// No description provided for @teamActivitySemantics.
  ///
  /// In en, this message translates to:
  /// **'{who} {what}{where}, {when}'**
  String teamActivitySemantics(
    String who,
    String what,
    String where,
    String when,
  );

  /// No description provided for @settingsPush.
  ///
  /// In en, this message translates to:
  /// **'Task notifications'**
  String get settingsPush;

  /// No description provided for @settingsPushHint.
  ///
  /// In en, this message translates to:
  /// **'Get a notification when a task is assigned to you. Tap it to open the task.'**
  String get settingsPushHint;

  /// Document vault screen title and More tile.
  ///
  /// In en, this message translates to:
  /// **'Document vault'**
  String get documentsTitle;

  /// Add button tooltip on the vault.
  ///
  /// In en, this message translates to:
  /// **'Add document'**
  String get documentsAdd;

  /// Vault header when every file is on the phone.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, one{1 document} other{{count} documents}} · all open offline'**
  String documentsSummaryOffline(int count);

  /// Vault header when some files are not downloaded yet.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, one{1 document} other{{count} documents}} · {missing, plural, one{1 file} other{{missing} files}} not on this phone yet'**
  String documentsSummaryMissing(int count, int missing);

  /// Note under the vault list in the Türkiye profile.
  ///
  /// In en, this message translates to:
  /// **'Document types depend on the country. Outside Türkiye you create your own document types.'**
  String get documentsRegionNoteTr;

  /// Note under the vault list outside Türkiye.
  ///
  /// In en, this message translates to:
  /// **'You define the document types; the types you enter are suggested next time.'**
  String get documentsRegionNoteOther;

  /// Button that opens the full-screen road check mode.
  ///
  /// In en, this message translates to:
  /// **'Road check · show documents'**
  String get documentsRoadCheck;

  /// Empty vault title.
  ///
  /// In en, this message translates to:
  /// **'No documents yet'**
  String get documentsEmptyTitle;

  /// Empty vault message.
  ///
  /// In en, this message translates to:
  /// **'Add a photo or PDF of your permits and certificates. They open offline and you\'re reminded before they expire.'**
  String get documentsEmptyMessage;

  /// Vault load error.
  ///
  /// In en, this message translates to:
  /// **'Couldn\'t open the documents.'**
  String get documentsLoadError;

  /// File kind label on the document thumbnail.
  ///
  /// In en, this message translates to:
  /// **'PHOTO'**
  String get documentFileKindPhoto;

  /// File kind label on the document thumbnail.
  ///
  /// In en, this message translates to:
  /// **'PDF'**
  String get documentFileKindPdf;

  /// Document type (Türkiye).
  ///
  /// In en, this message translates to:
  /// **'Health report'**
  String get documentTypeHealthReport;

  /// Document type (Türkiye).
  ///
  /// In en, this message translates to:
  /// **'Transport permit'**
  String get documentTypeTransportPermit;

  /// Document type (Türkiye).
  ///
  /// In en, this message translates to:
  /// **'Migratory beekeeper certificate'**
  String get documentTypeMigratoryCertificate;

  /// Document type (Türkiye).
  ///
  /// In en, this message translates to:
  /// **'Business registration certificate'**
  String get documentTypeBusinessRegistration;

  /// Document type (Türkiye).
  ///
  /// In en, this message translates to:
  /// **'Land permit'**
  String get documentTypeLandPermit;

  /// Document type (Türkiye).
  ///
  /// In en, this message translates to:
  /// **'Analysis report'**
  String get documentTypeAnalysisReport;

  /// Badge: the document has no expiry date.
  ///
  /// In en, this message translates to:
  /// **'No expiry'**
  String get documentExpiryNone;

  /// Badge: the document has expired.
  ///
  /// In en, this message translates to:
  /// **'Expired'**
  String get documentExpiryExpired;

  /// Badge: today is the last valid day.
  ///
  /// In en, this message translates to:
  /// **'Ends today'**
  String get documentExpiryToday;

  /// Badge: days left until the document expires.
  ///
  /// In en, this message translates to:
  /// **'{days, plural, one{1 day} other{{days} days}}'**
  String documentExpiryDays(int days);

  /// Badge: months left until the document expires.
  ///
  /// In en, this message translates to:
  /// **'{months, plural, one{1 month} other{{months} months}}'**
  String documentExpiryMonths(int months);

  /// Last valid day of the document.
  ///
  /// In en, this message translates to:
  /// **'Valid until {date}'**
  String documentExpiresOn(String date);

  /// Add document form title.
  ///
  /// In en, this message translates to:
  /// **'Add document'**
  String get documentFormNewTitle;

  /// Edit document form title.
  ///
  /// In en, this message translates to:
  /// **'Edit document'**
  String get documentFormEditTitle;

  /// Form field label.
  ///
  /// In en, this message translates to:
  /// **'Document type'**
  String get documentFormType;

  /// Hint for a user-defined document type.
  ///
  /// In en, this message translates to:
  /// **'e.g. Insurance policy'**
  String get documentFormCustomTypeHint;

  /// Form field label.
  ///
  /// In en, this message translates to:
  /// **'Name'**
  String get documentFormName;

  /// Form field hint.
  ///
  /// In en, this message translates to:
  /// **'e.g. Health report 2026'**
  String get documentFormNameHint;

  /// Form field label.
  ///
  /// In en, this message translates to:
  /// **'Description'**
  String get documentFormDescription;

  /// Form field hint.
  ///
  /// In en, this message translates to:
  /// **'e.g. District office · 152 hives'**
  String get documentFormDescriptionHint;

  /// Form field label.
  ///
  /// In en, this message translates to:
  /// **'Valid until'**
  String get documentFormExpiry;

  /// Expiry choice: the document doesn't expire.
  ///
  /// In en, this message translates to:
  /// **'No expiry'**
  String get documentFormNoExpiry;

  /// Expiry choice that opens the date picker.
  ///
  /// In en, this message translates to:
  /// **'Pick a date'**
  String get documentFormPickDate;

  /// Helper under the expiry field.
  ///
  /// In en, this message translates to:
  /// **'You\'ll be reminded 30, 7 and 1 day before it expires.'**
  String get documentFormExpiryHelper;

  /// Form field label.
  ///
  /// In en, this message translates to:
  /// **'File'**
  String get documentFormFile;

  /// Button: photograph the document.
  ///
  /// In en, this message translates to:
  /// **'Take photo'**
  String get documentFormTakePhoto;

  /// Button: pick a photo of the document.
  ///
  /// In en, this message translates to:
  /// **'From gallery'**
  String get documentFormPickImage;

  /// Button: pick a PDF file.
  ///
  /// In en, this message translates to:
  /// **'Choose PDF'**
  String get documentFormPickPdf;

  /// Shown while no file is chosen.
  ///
  /// In en, this message translates to:
  /// **'Take a photo of the document or choose its PDF.'**
  String get documentFormNoFile;

  /// File size in kilobytes.
  ///
  /// In en, this message translates to:
  /// **'{size} KB'**
  String documentFileSizeKb(String size);

  /// File size in megabytes.
  ///
  /// In en, this message translates to:
  /// **'{size} MB'**
  String documentFileSizeMb(String size);

  /// Picked file is too large.
  ///
  /// In en, this message translates to:
  /// **'The file is larger than 20 MB; choose a smaller one.'**
  String get documentFileTooLarge;

  /// Picking or copying the file failed.
  ///
  /// In en, this message translates to:
  /// **'Couldn\'t get the file, try again.'**
  String get documentFileFailed;

  /// Camera/gallery/file permission denied.
  ///
  /// In en, this message translates to:
  /// **'Permission denied. To add a document, allow camera or file access for this app in Settings.'**
  String get documentFilePermissionDenied;

  /// Save button.
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get documentFormSave;

  /// Delete button in the edit form.
  ///
  /// In en, this message translates to:
  /// **'Delete document'**
  String get documentFormDelete;

  /// Snack bar after saving.
  ///
  /// In en, this message translates to:
  /// **'Document saved'**
  String get documentSaved;

  /// Snack bar when notification permission is denied.
  ///
  /// In en, this message translates to:
  /// **'Document saved. Expiry reminders won\'t ring without notification permission.'**
  String get documentReminderDenied;

  /// Delete confirmation title.
  ///
  /// In en, this message translates to:
  /// **'Delete this document?'**
  String get documentDeleteTitle;

  /// Delete confirmation message.
  ///
  /// In en, this message translates to:
  /// **'The document and its file are removed from every phone.'**
  String get documentDeleteMessage;

  /// Delete confirmation button.
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get documentDeleteConfirm;

  /// Snack bar after deleting.
  ///
  /// In en, this message translates to:
  /// **'Document deleted'**
  String get documentDeleted;

  /// Document missing.
  ///
  /// In en, this message translates to:
  /// **'Document not found; it may have been deleted.'**
  String get documentNotFound;

  /// Edit action on the document screen.
  ///
  /// In en, this message translates to:
  /// **'Edit'**
  String get documentEdit;

  /// Shown instead of the file when it hasn't been downloaded.
  ///
  /// In en, this message translates to:
  /// **'The file isn\'t on this phone yet. It downloads when you\'re online.'**
  String get documentFileMissing;

  /// PDF rendering failed.
  ///
  /// In en, this message translates to:
  /// **'Couldn\'t open the PDF.'**
  String get documentPdfFailed;

  /// Screen reader label of a PDF page.
  ///
  /// In en, this message translates to:
  /// **'Page {page} of {count}'**
  String documentPdfPage(int page, int count);

  /// Full-screen road check mode title.
  ///
  /// In en, this message translates to:
  /// **'Road check'**
  String get roadCheckTitle;

  /// Current document position in road check.
  ///
  /// In en, this message translates to:
  /// **'{index} / {count}'**
  String roadCheckPosition(int index, int count);

  /// Hint in road check mode.
  ///
  /// In en, this message translates to:
  /// **'Swipe sideways for the next document'**
  String get roadCheckSwipeHint;

  /// Road check button.
  ///
  /// In en, this message translates to:
  /// **'Previous document'**
  String get roadCheckPrevious;

  /// Road check button.
  ///
  /// In en, this message translates to:
  /// **'Next document'**
  String get roadCheckNext;

  /// Expiry reminder notification body.
  ///
  /// In en, this message translates to:
  /// **'Expires in {days, plural, one{1 day} other{{days} days}} · {date}'**
  String documentReminderBody(int days, String date);

  /// Record type name on the sync screen.
  ///
  /// In en, this message translates to:
  /// **'Document'**
  String get syncTableDocuments;

  /// Migration plans screen title and More tile.
  ///
  /// In en, this message translates to:
  /// **'Migration plans'**
  String get migrationsTitle;

  /// Add button tooltip and empty state action on migration plans.
  ///
  /// In en, this message translates to:
  /// **'New plan'**
  String get migrationsAdd;

  /// Empty migration plans title.
  ///
  /// In en, this message translates to:
  /// **'No migration plan yet'**
  String get migrationsEmptyTitle;

  /// Empty migration plans message.
  ///
  /// In en, this message translates to:
  /// **'Plan the year\'s route: each stop\'s dates, hive count and target apiary.'**
  String get migrationsEmptyMessage;

  /// Error while reading migration plans.
  ///
  /// In en, this message translates to:
  /// **'Couldn\'t open migration plans'**
  String get migrationsLoadError;

  /// Number of stops on a plan row.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =0{No stops} =1{1 stop} other{{count} stops}}'**
  String migrationStopCount(int count);

  /// Migration plan title: name and year, e.g. 'Migration plan 2026'.
  ///
  /// In en, this message translates to:
  /// **'{name} {year}'**
  String migrationTitle(String name, String year);

  /// Shown when the plan was deleted.
  ///
  /// In en, this message translates to:
  /// **'Migration plan not found'**
  String get migrationNotFound;

  /// App bar action that opens the document vault.
  ///
  /// In en, this message translates to:
  /// **'Documents'**
  String get migrationDocuments;

  /// App bar action tooltip.
  ///
  /// In en, this message translates to:
  /// **'Edit plan'**
  String get migrationEdit;

  /// Bottom button on the migration timeline.
  ///
  /// In en, this message translates to:
  /// **'Add stop'**
  String get migrationAddStop;

  /// Empty timeline title.
  ///
  /// In en, this message translates to:
  /// **'No stops yet'**
  String get migrationNoStopsTitle;

  /// Empty timeline message.
  ///
  /// In en, this message translates to:
  /// **'Add the route\'s stops in order: source, place, dates and hive count.'**
  String get migrationNoStopsMessage;

  /// Next move card heading: days until the move.
  ///
  /// In en, this message translates to:
  /// **'Next move · {days, plural, =0{today} =1{1 day} other{{days} days}}'**
  String migrationNextMoveIn(int days);

  /// Next move card heading when the planned start has passed.
  ///
  /// In en, this message translates to:
  /// **'Next move · {days, plural, =1{1 day late} other{{days} days late}}'**
  String migrationNextMoveLate(int days);

  /// Route from one stop or place to the next.
  ///
  /// In en, this message translates to:
  /// **'{from} → {to}'**
  String migrationRoute(String from, String to);

  /// Next move card: the document is valid on the move day.
  ///
  /// In en, this message translates to:
  /// **'{document} ready'**
  String migrationDocReady(String document);

  /// Next move card: the document expires in less than a week.
  ///
  /// In en, this message translates to:
  /// **'{document} {days, plural, =0{expires today} =1{1 day} other{{days} days}}'**
  String migrationDocDays(String document, int days);

  /// Next move card: the document expires before the move day.
  ///
  /// In en, this message translates to:
  /// **'{document} expires before the move'**
  String migrationDocBeforeMove(String document);

  /// Next move card: the document has expired.
  ///
  /// In en, this message translates to:
  /// **'{document} expired'**
  String migrationDocExpired(String document);

  /// Next move card: no document of this type in the vault.
  ///
  /// In en, this message translates to:
  /// **'{document} missing'**
  String migrationDocMissing(String document);

  /// Stop status choice.
  ///
  /// In en, this message translates to:
  /// **'Past'**
  String get migrationStopPast;

  /// Stop status choice.
  ///
  /// In en, this message translates to:
  /// **'Here now'**
  String get migrationStopCurrent;

  /// Stop status choice.
  ///
  /// In en, this message translates to:
  /// **'Planned'**
  String get migrationStopPlanned;

  /// Badge on the current stop.
  ///
  /// In en, this message translates to:
  /// **'You\'re here'**
  String get migrationStopHere;

  /// Planned stay as a month range, e.g. 'Mar–Apr'.
  ///
  /// In en, this message translates to:
  /// **'{start}–{end}'**
  String migrationStopDates(String start, String end);

  /// One past year's yield at the stop's target apiary.
  ///
  /// In en, this message translates to:
  /// **'{year}: {kg} kg/hive'**
  String migrationYield(String year, String kg);

  /// Past years' yields at the stop's target apiary.
  ///
  /// In en, this message translates to:
  /// **'Past yield · {values}'**
  String migrationYields(String values);

  /// Stop row when the target apiary has no harvest before the plan year.
  ///
  /// In en, this message translates to:
  /// **'No past harvest at this apiary'**
  String get migrationNoYield;

  /// Plan form title.
  ///
  /// In en, this message translates to:
  /// **'New migration plan'**
  String get migrationFormNewTitle;

  /// Plan form title.
  ///
  /// In en, this message translates to:
  /// **'Edit migration plan'**
  String get migrationFormEditTitle;

  /// Plan form field.
  ///
  /// In en, this message translates to:
  /// **'Year'**
  String get migrationFormYear;

  /// Plan form field.
  ///
  /// In en, this message translates to:
  /// **'Name'**
  String get migrationFormName;

  /// Default name of a new plan.
  ///
  /// In en, this message translates to:
  /// **'Migration plan'**
  String get migrationFormDefaultName;

  /// Plan and stop form save button.
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get migrationFormSave;

  /// Plan form delete button.
  ///
  /// In en, this message translates to:
  /// **'Delete plan'**
  String get migrationFormDelete;

  /// Delete plan dialog title.
  ///
  /// In en, this message translates to:
  /// **'Delete migration plan?'**
  String get migrationDeleteTitle;

  /// Delete plan dialog message.
  ///
  /// In en, this message translates to:
  /// **'The plan and all its stops will be deleted.'**
  String get migrationDeleteMessage;

  /// Delete dialogs' confirm button.
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get migrationDeleteConfirm;

  /// Snack bar after saving a plan.
  ///
  /// In en, this message translates to:
  /// **'Plan saved'**
  String get migrationSaved;

  /// Snack bar after deleting a plan.
  ///
  /// In en, this message translates to:
  /// **'Plan deleted'**
  String get migrationDeleted;

  /// Stop form title.
  ///
  /// In en, this message translates to:
  /// **'New stop'**
  String get stopFormNewTitle;

  /// Stop form title.
  ///
  /// In en, this message translates to:
  /// **'Edit stop'**
  String get stopFormEditTitle;

  /// Stop form field: the nectar source, e.g. Citrus.
  ///
  /// In en, this message translates to:
  /// **'Source'**
  String get stopFormName;

  /// Stop form source hint.
  ///
  /// In en, this message translates to:
  /// **'e.g. Citrus, Pine'**
  String get stopFormNameHint;

  /// Stop form field.
  ///
  /// In en, this message translates to:
  /// **'Place'**
  String get stopFormPlace;

  /// Stop form place hint.
  ///
  /// In en, this message translates to:
  /// **'e.g. Erdemli, Mersin'**
  String get stopFormPlaceHint;

  /// Stop form date row.
  ///
  /// In en, this message translates to:
  /// **'Planned start'**
  String get stopFormStart;

  /// Stop form date row.
  ///
  /// In en, this message translates to:
  /// **'Planned end'**
  String get stopFormEnd;

  /// Stop form row; past yields come from this apiary's harvests.
  ///
  /// In en, this message translates to:
  /// **'Target apiary'**
  String get stopFormApiary;

  /// Apiary picker title.
  ///
  /// In en, this message translates to:
  /// **'Choose target apiary'**
  String get stopFormChooseApiary;

  /// No target apiary.
  ///
  /// In en, this message translates to:
  /// **'None'**
  String get stopFormNone;

  /// Stop form stepper.
  ///
  /// In en, this message translates to:
  /// **'Hives'**
  String get stopFormHiveCount;

  /// Stop form stepper.
  ///
  /// In en, this message translates to:
  /// **'Order on the route'**
  String get stopFormPosition;

  /// Stop form status choice.
  ///
  /// In en, this message translates to:
  /// **'Status'**
  String get stopFormStatus;

  /// Stop form delete button.
  ///
  /// In en, this message translates to:
  /// **'Delete stop'**
  String get stopFormDelete;

  /// Delete stop dialog title.
  ///
  /// In en, this message translates to:
  /// **'Delete stop?'**
  String get stopDeleteTitle;

  /// Delete stop dialog message.
  ///
  /// In en, this message translates to:
  /// **'The stop will be removed from the plan.'**
  String get stopDeleteMessage;

  /// Snack bar after saving a stop.
  ///
  /// In en, this message translates to:
  /// **'Stop saved'**
  String get stopSaved;

  /// Snack bar after deleting a stop.
  ///
  /// In en, this message translates to:
  /// **'Stop deleted'**
  String get stopDeleted;

  /// Record type name on the sync screen.
  ///
  /// In en, this message translates to:
  /// **'Migration plan'**
  String get syncTableMigrations;

  /// Record type name on the sync screen.
  ///
  /// In en, this message translates to:
  /// **'Migration stop'**
  String get syncTableMigrationStops;

  /// Timeline button that opens the next move.
  ///
  /// In en, this message translates to:
  /// **'Start move'**
  String get moveStart;

  /// Move screen title, e.g. 'Move · Pine → Winter yard'.
  ///
  /// In en, this message translates to:
  /// **'Move · {route}'**
  String moveTitle(String route);

  /// Move screen when the plan has no planned stop left.
  ///
  /// In en, this message translates to:
  /// **'No upcoming move'**
  String get moveNone;

  /// More tab tile that opens the migration plans (migratory beekeeping).
  ///
  /// In en, this message translates to:
  /// **'Migratory'**
  String get moreMigratory;

  /// Record type name on the sync screen: a hive transport.
  ///
  /// In en, this message translates to:
  /// **'Move'**
  String get syncTableTransports;

  /// Record type name on the sync screen: a hive on a transport.
  ///
  /// In en, this message translates to:
  /// **'Moved hive'**
  String get syncTableTransportItems;

  /// Move step 1: pre-loading checklist.
  ///
  /// In en, this message translates to:
  /// **'Check'**
  String get moveStepCheck;

  /// Move step 2: loading hives onto vehicles.
  ///
  /// In en, this message translates to:
  /// **'Loading'**
  String get moveStepLoad;

  /// Move step 3: unloading hives at the destination.
  ///
  /// In en, this message translates to:
  /// **'Unloading'**
  String get moveStepUnload;

  /// Screen reader label for a finished move step.
  ///
  /// In en, this message translates to:
  /// **'{step}, done'**
  String moveStepDone(String step);

  /// Move screen when the next stop has no destination apiary.
  ///
  /// In en, this message translates to:
  /// **'The stop has no apiary'**
  String get moveNoDestinationTitle;

  /// Explains why the stop needs an apiary.
  ///
  /// In en, this message translates to:
  /// **'Pick a destination apiary for the stop so hive locations can update after unloading.'**
  String get moveNoDestinationMessage;

  /// Button that opens the stop form.
  ///
  /// In en, this message translates to:
  /// **'Edit stop'**
  String get moveEditStop;

  /// Label of the source apiary.
  ///
  /// In en, this message translates to:
  /// **'From'**
  String get moveFrom;

  /// Label of the destination apiary.
  ///
  /// In en, this message translates to:
  /// **'To'**
  String get moveTo;

  /// Active hive count of the source apiary.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =0{No active hives} =1{1 active hive} other{{count} active hives}}'**
  String moveSourceHives(int count);

  /// Section title of the pre-loading checklist.
  ///
  /// In en, this message translates to:
  /// **'Loading checklist'**
  String get moveChecklist;

  /// Checklist item.
  ///
  /// In en, this message translates to:
  /// **'Entrances closed'**
  String get moveCheckEntrances;

  /// Checklist item.
  ///
  /// In en, this message translates to:
  /// **'Ventilation open'**
  String get moveCheckVentilation;

  /// Checklist item.
  ///
  /// In en, this message translates to:
  /// **'Straps tight'**
  String get moveCheckStraps;

  /// Checklist item.
  ///
  /// In en, this message translates to:
  /// **'Water ready'**
  String get moveCheckWater;

  /// Section title of the vehicles list.
  ///
  /// In en, this message translates to:
  /// **'Vehicles'**
  String get moveVehicles;

  /// Default name of a new vehicle.
  ///
  /// In en, this message translates to:
  /// **'Truck {number}'**
  String moveVehicleDefault(int number);

  /// Button that adds a vehicle.
  ///
  /// In en, this message translates to:
  /// **'Add vehicle'**
  String get moveAddVehicle;

  /// Tooltip of the remove button next to a vehicle.
  ///
  /// In en, this message translates to:
  /// **'Remove {vehicle}'**
  String moveRemoveVehicle(String vehicle);

  /// Label of the vehicle name field.
  ///
  /// In en, this message translates to:
  /// **'Vehicle name'**
  String get moveVehicleName;

  /// Error when the vehicle name is taken.
  ///
  /// In en, this message translates to:
  /// **'A vehicle with this name exists'**
  String get moveVehicleExists;

  /// Button that finishes the checklist and starts loading.
  ///
  /// In en, this message translates to:
  /// **'Start loading'**
  String get moveStartLoading;

  /// Hint under the checklist while items are unticked.
  ///
  /// In en, this message translates to:
  /// **'Tick everything on the list to start loading.'**
  String get moveChecklistHint;

  /// Vehicle chip with its loaded hive count, e.g. 'Truck 1 · 72'.
  ///
  /// In en, this message translates to:
  /// **'{vehicle} · {count}'**
  String moveVehicleCount(String vehicle, int count);

  /// Counter title during loading.
  ///
  /// In en, this message translates to:
  /// **'Loaded'**
  String get moveLoaded;

  /// Counter title during unloading.
  ///
  /// In en, this message translates to:
  /// **'Unloaded'**
  String get moveUnloaded;

  /// Total next to the big counter, e.g. '/ 152'.
  ///
  /// In en, this message translates to:
  /// **'/ {total}'**
  String moveCountTotal(int total);

  /// Screen reader label of the big counter.
  ///
  /// In en, this message translates to:
  /// **'{count} of {total} hives'**
  String moveCountLabel(int count, int total);

  /// Number of the last scanned hive.
  ///
  /// In en, this message translates to:
  /// **'Last scanned: {number}'**
  String moveLastScanned(String number);

  /// Card with the number of hives still to scan.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{1 hive not scanned yet} other{{count} hives not scanned yet}}'**
  String moveNotScanned(int count);

  /// Card when every expected hive was scanned.
  ///
  /// In en, this message translates to:
  /// **'All scanned'**
  String get moveAllScanned;

  /// Opens the list of hives not scanned.
  ///
  /// In en, this message translates to:
  /// **'See list'**
  String get moveShowList;

  /// Title of the list of hives not scanned.
  ///
  /// In en, this message translates to:
  /// **'Hives not scanned'**
  String get moveMissingTitle;

  /// Hint on the loading step.
  ///
  /// In en, this message translates to:
  /// **'You\'ll scan again while unloading at the destination; I\'ll warn you if a hive is missing. Hive locations update after unloading.'**
  String get moveLoadingHint;

  /// Hint on the unloading step.
  ///
  /// In en, this message translates to:
  /// **'Scan each hive again as you unload. When you finish, unloaded hives move to {destination}.'**
  String moveUnloadingHint(String destination);

  /// Button that opens manual hive number entry.
  ///
  /// In en, this message translates to:
  /// **'Enter number'**
  String get moveEnterNumber;

  /// Label of the manual hive number field.
  ///
  /// In en, this message translates to:
  /// **'Hive number'**
  String get moveHiveNumber;

  /// Manual entry found no hive.
  ///
  /// In en, this message translates to:
  /// **'No hive numbered {number}'**
  String moveNumberNotFound(String number);

  /// Opens the continuous scanner.
  ///
  /// In en, this message translates to:
  /// **'Start scanning'**
  String get moveScanStart;

  /// Opens the continuous scanner after some hives were scanned.
  ///
  /// In en, this message translates to:
  /// **'Continue scanning'**
  String get moveScanContinue;

  /// Finishes loading.
  ///
  /// In en, this message translates to:
  /// **'Go to unloading'**
  String get moveToUnloading;

  /// Confirm dialog title when finishing loading with hives left.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{1 hive not scanned} other{{count} hives not scanned}}'**
  String moveToUnloadingTitle(int count);

  /// Confirm dialog message when finishing loading with hives left.
  ///
  /// In en, this message translates to:
  /// **'Hives not scanned stay out of this move and remain where they are.'**
  String get moveToUnloadingMessage;

  /// Finishes unloading.
  ///
  /// In en, this message translates to:
  /// **'Finish move'**
  String get moveFinish;

  /// Confirm dialog title when finishing with hives not unloaded.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{1 hive not unloaded} other{{count} hives not unloaded}}'**
  String moveFinishTitle(int count);

  /// Confirm dialog message when finishing with hives not unloaded.
  ///
  /// In en, this message translates to:
  /// **'Hives not unloaded keep their location at {source}. The missing list stays on the move.'**
  String moveFinishMessage(String source);

  /// Confirm button of the finish dialog.
  ///
  /// In en, this message translates to:
  /// **'Finish'**
  String get moveFinishConfirm;

  /// Title on the finished move.
  ///
  /// In en, this message translates to:
  /// **'Move finished'**
  String get moveDoneTitle;

  /// Counts on the finished move.
  ///
  /// In en, this message translates to:
  /// **'Loaded {loaded} · Unloaded {unloaded}'**
  String moveDoneSummary(int loaded, int unloaded);

  /// How many hives moved on the finished move.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =0{No hives moved.} =1{1 hive moved to {destination}.} other{{count} hives moved to {destination}.}}'**
  String moveDoneMoved(int count, String destination);

  /// Title of the missing list on the finished move.
  ///
  /// In en, this message translates to:
  /// **'Hives not unloaded'**
  String get moveDoneMissing;

  /// Scan result: hive loaded.
  ///
  /// In en, this message translates to:
  /// **'{number} loaded · {vehicle}'**
  String moveScanLoaded(String number, String vehicle);

  /// Scan result: loaded a hive from another apiary.
  ///
  /// In en, this message translates to:
  /// **'{number} loaded; this hive wasn\'t at this apiary'**
  String moveScanLoadedOther(String number);

  /// Scan result: hive already loaded.
  ///
  /// In en, this message translates to:
  /// **'{number} is already loaded'**
  String moveScanAlreadyLoaded(String number);

  /// Scan result: hive unloaded.
  ///
  /// In en, this message translates to:
  /// **'{number} unloaded'**
  String moveScanUnloaded(String number);

  /// Scan result: hive already unloaded.
  ///
  /// In en, this message translates to:
  /// **'{number} is already unloaded'**
  String moveScanAlreadyUnloaded(String number);

  /// Scan result: hive not on this transport.
  ///
  /// In en, this message translates to:
  /// **'{number} wasn\'t loaded on this move'**
  String moveScanNotLoaded(String number);

  /// Scan result: label matches no hive.
  ///
  /// In en, this message translates to:
  /// **'Unknown label'**
  String get moveScanUnknown;

  /// Closes the continuous scanner.
  ///
  /// In en, this message translates to:
  /// **'Done'**
  String get moveScanDone;
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
