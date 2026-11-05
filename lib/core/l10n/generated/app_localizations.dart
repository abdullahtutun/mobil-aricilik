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
  /// **'No apiary has a location yet. Edit an apiary to take the location from GPS or pick it on the map.'**
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

  /// No description provided for @apiaryMapDirections.
  ///
  /// In en, this message translates to:
  /// **'Directions'**
  String get apiaryMapDirections;

  /// No description provided for @apiaryMapShow.
  ///
  /// In en, this message translates to:
  /// **'Show'**
  String get apiaryMapShow;

  /// No description provided for @apiaryMapDirectionsFailed.
  ///
  /// In en, this message translates to:
  /// **'Couldn\'t open a maps app.'**
  String get apiaryMapDirectionsFailed;

  /// No description provided for @apiaryMapDirectionsChooseApp.
  ///
  /// In en, this message translates to:
  /// **'Get directions with'**
  String get apiaryMapDirectionsChooseApp;

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

  /// No description provided for @apiaryDelete.
  ///
  /// In en, this message translates to:
  /// **'Delete apiary'**
  String get apiaryDelete;

  /// No description provided for @apiaryDeleteTitle.
  ///
  /// In en, this message translates to:
  /// **'Delete this apiary?'**
  String get apiaryDeleteTitle;

  /// No description provided for @apiaryDeleteMessage.
  ///
  /// In en, this message translates to:
  /// **'The apiary will be removed from every phone.'**
  String get apiaryDeleteMessage;

  /// No description provided for @apiaryDeleteWithHivesMessage.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{This apiary has 1 hive. The apiary and its hive will be removed from every phone.} other{This apiary has {count} hives. The apiary and its hives will be removed from every phone.}}'**
  String apiaryDeleteWithHivesMessage(int count);

  /// No description provided for @apiaryDeleted.
  ///
  /// In en, this message translates to:
  /// **'Apiary deleted'**
  String get apiaryDeleted;

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
  /// **'No location yet. If you\'re at the apiary, take it from GPS, no internet needed; otherwise pick it on the map.'**
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

  /// No description provided for @apiaryFormLocationPickOnMap.
  ///
  /// In en, this message translates to:
  /// **'Pick on map'**
  String get apiaryFormLocationPickOnMap;

  /// No description provided for @locationPickerTitle.
  ///
  /// In en, this message translates to:
  /// **'Pick location on map'**
  String get locationPickerTitle;

  /// No description provided for @locationPickerSearchHint.
  ///
  /// In en, this message translates to:
  /// **'Search for a town or place'**
  String get locationPickerSearchHint;

  /// No description provided for @locationPickerSearch.
  ///
  /// In en, this message translates to:
  /// **'Search'**
  String get locationPickerSearch;

  /// No description provided for @locationPickerHint.
  ///
  /// In en, this message translates to:
  /// **'Move the map to put the pin on the apiary.'**
  String get locationPickerHint;

  /// No description provided for @locationPickerPinLabel.
  ///
  /// In en, this message translates to:
  /// **'Selected location'**
  String get locationPickerPinLabel;

  /// No description provided for @locationPickerConfirm.
  ///
  /// In en, this message translates to:
  /// **'Use this location'**
  String get locationPickerConfirm;

  /// No description provided for @locationPickerNoResults.
  ///
  /// In en, this message translates to:
  /// **'No places found. Try another name.'**
  String get locationPickerNoResults;

  /// No description provided for @locationPickerSearchOffline.
  ///
  /// In en, this message translates to:
  /// **'Couldn\'t search. Search needs internet.'**
  String get locationPickerSearchOffline;

  /// No description provided for @locationPickerMapOfflineMessage.
  ///
  /// In en, this message translates to:
  /// **'The map needs internet. If you\'re at the apiary, take the location from GPS.'**
  String get locationPickerMapOfflineMessage;

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

  /// No description provided for @hiveDelete.
  ///
  /// In en, this message translates to:
  /// **'Delete hive'**
  String get hiveDelete;

  /// No description provided for @hiveDeleteTitle.
  ///
  /// In en, this message translates to:
  /// **'Delete hive {number}?'**
  String hiveDeleteTitle(String number);

  /// No description provided for @hiveDeleteMessage.
  ///
  /// In en, this message translates to:
  /// **'The hive and its records will be removed from every phone.'**
  String get hiveDeleteMessage;

  /// No description provided for @hiveDeleted.
  ///
  /// In en, this message translates to:
  /// **'Hive {number} deleted'**
  String hiveDeleted(String number);

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

  /// No description provided for @actionDelete.
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get actionDelete;

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

  /// No description provided for @syncTableHiveStatusEvents.
  ///
  /// In en, this message translates to:
  /// **'Hive status change'**
  String get syncTableHiveStatusEvents;

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

  /// No description provided for @apiaryDetailSubtitlePlace.
  ///
  /// In en, this message translates to:
  /// **'{hives} · {visit} · {place}'**
  String apiaryDetailSubtitlePlace(String hives, String visit, String place);

  /// Button on the apiary detail: feed every active hive in the apiary.
  ///
  /// In en, this message translates to:
  /// **'Bulk feeding'**
  String get apiaryBulkFeed;

  /// Button on the apiary detail: apply a treatment to every active hive in the apiary.
  ///
  /// In en, this message translates to:
  /// **'Bulk treatment'**
  String get apiaryBulkTreat;

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

  /// No description provided for @drugInfoOpen.
  ///
  /// In en, this message translates to:
  /// **'Drug information'**
  String get drugInfoOpen;

  /// No description provided for @drugInfoSourceTitle.
  ///
  /// In en, this message translates to:
  /// **'Source: Ministry of Agriculture and Forestry of Türkiye'**
  String get drugInfoSourceTitle;

  /// No description provided for @drugInfoSourceMessage.
  ///
  /// In en, this message translates to:
  /// **'This is taken from the Ministry-approved product information and is shown in Turkish as published. Read the product label before use; ask a veterinarian if unsure.'**
  String get drugInfoSourceMessage;

  /// No description provided for @drugInfoActiveIngredient.
  ///
  /// In en, this message translates to:
  /// **'Active ingredient'**
  String get drugInfoActiveIngredient;

  /// No description provided for @drugInfoIndications.
  ///
  /// In en, this message translates to:
  /// **'Used for'**
  String get drugInfoIndications;

  /// No description provided for @drugInfoUsage.
  ///
  /// In en, this message translates to:
  /// **'Use and frequency'**
  String get drugInfoUsage;

  /// No description provided for @drugInfoUsageMethod.
  ///
  /// In en, this message translates to:
  /// **'How to apply'**
  String get drugInfoUsageMethod;

  /// No description provided for @drugInfoUsageMethodAndDose.
  ///
  /// In en, this message translates to:
  /// **'How to apply and dose'**
  String get drugInfoUsageMethodAndDose;

  /// No description provided for @drugInfoUsageDiagnosis.
  ///
  /// In en, this message translates to:
  /// **'For diagnosis'**
  String get drugInfoUsageDiagnosis;

  /// No description provided for @drugInfoUsageDose.
  ///
  /// In en, this message translates to:
  /// **'Dose'**
  String get drugInfoUsageDose;

  /// No description provided for @drugInfoUsageFrequency.
  ///
  /// In en, this message translates to:
  /// **'Frequency'**
  String get drugInfoUsageFrequency;

  /// No description provided for @drugInfoUsageDuration.
  ///
  /// In en, this message translates to:
  /// **'Duration'**
  String get drugInfoUsageDuration;

  /// No description provided for @drugInfoUsageOther.
  ///
  /// In en, this message translates to:
  /// **'Note'**
  String get drugInfoUsageOther;

  /// No description provided for @drugInfoSuitablePeriods.
  ///
  /// In en, this message translates to:
  /// **'Suitable periods'**
  String get drugInfoSuitablePeriods;

  /// No description provided for @drugInfoAvoidPeriods.
  ///
  /// In en, this message translates to:
  /// **'Do not use'**
  String get drugInfoAvoidPeriods;

  /// No description provided for @drugInfoWithdrawal.
  ///
  /// In en, this message translates to:
  /// **'Withdrawal period'**
  String get drugInfoWithdrawal;

  /// No description provided for @drugInfoWarnings.
  ///
  /// In en, this message translates to:
  /// **'Warnings'**
  String get drugInfoWarnings;

  /// No description provided for @drugInfoClose.
  ///
  /// In en, this message translates to:
  /// **'Close'**
  String get drugInfoClose;

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

  /// Temperature in the user's unit, without the unit letter.
  ///
  /// In en, this message translates to:
  /// **'{value}°'**
  String weatherTemperature(String value);

  /// Shown when the stored weather bundle is older than an hour (e.g. offline).
  ///
  /// In en, this message translates to:
  /// **'Forecast as of {time}'**
  String weatherForecastAsOf(String time);

  /// Weather strip on Today: card of an apiary without a location.
  ///
  /// In en, this message translates to:
  /// **'No location'**
  String get weatherNoLocationTitle;

  /// On the no-location card; tapping opens the apiary edit form.
  ///
  /// In en, this message translates to:
  /// **'Add a location for weather'**
  String get weatherNoLocationAction;

  /// Weather strip on Today: apiary has a location but its forecast hasn't arrived yet.
  ///
  /// In en, this message translates to:
  /// **'Arrives once you\'re online'**
  String get weatherPendingHint;

  /// No description provided for @weatherWind.
  ///
  /// In en, this message translates to:
  /// **'Wind {speed}'**
  String weatherWind(String speed);

  /// No description provided for @weatherSpeed.
  ///
  /// In en, this message translates to:
  /// **'{value} {unit}'**
  String weatherSpeed(String value, String unit);

  /// Wind speed unit, kilometres per hour.
  ///
  /// In en, this message translates to:
  /// **'km/h'**
  String get unitKmh;

  /// Wind speed unit, miles per hour.
  ///
  /// In en, this message translates to:
  /// **'mph'**
  String get unitMph;

  /// No description provided for @weatherPercent.
  ///
  /// In en, this message translates to:
  /// **'{value}%'**
  String weatherPercent(String value);

  /// No description provided for @weatherTemperatureRange.
  ///
  /// In en, this message translates to:
  /// **'{max} / {min}'**
  String weatherTemperatureRange(String max, String min);

  /// Badge: rain chance is over the hive opening threshold.
  ///
  /// In en, this message translates to:
  /// **'Rain'**
  String get hiveOpeningRain;

  /// Badge: wind is over the hive opening threshold.
  ///
  /// In en, this message translates to:
  /// **'Windy'**
  String get hiveOpeningWind;

  /// Badge: temperature is under the hive opening threshold.
  ///
  /// In en, this message translates to:
  /// **'Cold'**
  String get hiveOpeningCold;

  /// Short badge in the daily list: hives can be opened that day.
  ///
  /// In en, this message translates to:
  /// **'Open'**
  String get hiveOpeningDaySuitable;

  /// No description provided for @weatherConditionSunny.
  ///
  /// In en, this message translates to:
  /// **'Sunny'**
  String get weatherConditionSunny;

  /// No description provided for @weatherConditionPartlyCloudy.
  ///
  /// In en, this message translates to:
  /// **'Partly cloudy'**
  String get weatherConditionPartlyCloudy;

  /// No description provided for @weatherConditionCloudy.
  ///
  /// In en, this message translates to:
  /// **'Cloudy'**
  String get weatherConditionCloudy;

  /// No description provided for @weatherConditionRainy.
  ///
  /// In en, this message translates to:
  /// **'Rainy'**
  String get weatherConditionRainy;

  /// No description provided for @weatherConditionWindy.
  ///
  /// In en, this message translates to:
  /// **'Windy'**
  String get weatherConditionWindy;

  /// Any other sky condition (snow, sleet, fog, thunder).
  ///
  /// In en, this message translates to:
  /// **'Snow, fog or storm'**
  String get weatherConditionOther;

  /// No description provided for @weatherConditionFog.
  ///
  /// In en, this message translates to:
  /// **'Foggy'**
  String get weatherConditionFog;

  /// No description provided for @weatherConditionThunder.
  ///
  /// In en, this message translates to:
  /// **'Thunderstorms'**
  String get weatherConditionThunder;

  /// No description provided for @weatherConditionSleet.
  ///
  /// In en, this message translates to:
  /// **'Sleet'**
  String get weatherConditionSleet;

  /// No description provided for @weatherConditionSnow.
  ///
  /// In en, this message translates to:
  /// **'Snow'**
  String get weatherConditionSnow;

  /// No description provided for @weatherFeelsLike.
  ///
  /// In en, this message translates to:
  /// **'{condition} · feels like {value}'**
  String weatherFeelsLike(String condition, String value);

  /// No description provided for @weatherWindLabel.
  ///
  /// In en, this message translates to:
  /// **'Wind'**
  String get weatherWindLabel;

  /// No description provided for @weatherHumidityLabel.
  ///
  /// In en, this message translates to:
  /// **'Humidity'**
  String get weatherHumidityLabel;

  /// No description provided for @weatherPrecipitationLabel.
  ///
  /// In en, this message translates to:
  /// **'Rain'**
  String get weatherPrecipitationLabel;

  /// No description provided for @weatherScreenTitle.
  ///
  /// In en, this message translates to:
  /// **'Apiary weather'**
  String get weatherScreenTitle;

  /// No description provided for @weatherScreenSubtitle.
  ///
  /// In en, this message translates to:
  /// **'{place} · {days}-day forecast'**
  String weatherScreenSubtitle(String place, String days);

  /// No description provided for @weatherScreenSubtitleNoPlace.
  ///
  /// In en, this message translates to:
  /// **'{days}-day forecast'**
  String weatherScreenSubtitleNoPlace(String days);

  /// When the shown forecast was fetched.
  ///
  /// In en, this message translates to:
  /// **'Updated {time}'**
  String weatherUpdatedAt(String time);

  /// No description provided for @weatherNow.
  ///
  /// In en, this message translates to:
  /// **'Now'**
  String get weatherNow;

  /// No description provided for @weatherToday.
  ///
  /// In en, this message translates to:
  /// **'Today'**
  String get weatherToday;

  /// No description provided for @weatherColumnDay.
  ///
  /// In en, this message translates to:
  /// **'Day'**
  String get weatherColumnDay;

  /// No description provided for @weatherColumnTemperature.
  ///
  /// In en, this message translates to:
  /// **'Temp'**
  String get weatherColumnTemperature;

  /// No description provided for @weatherColumnPrecipitation.
  ///
  /// In en, this message translates to:
  /// **'Rain'**
  String get weatherColumnPrecipitation;

  /// No description provided for @weatherColumnHive.
  ///
  /// In en, this message translates to:
  /// **'Hives'**
  String get weatherColumnHive;

  /// No description provided for @weatherTodaySuitable.
  ///
  /// In en, this message translates to:
  /// **'Good day to open hives'**
  String get weatherTodaySuitable;

  /// No description provided for @weatherTodayRain.
  ///
  /// In en, this message translates to:
  /// **'Rain today; not a day to open hives'**
  String get weatherTodayRain;

  /// No description provided for @weatherTodayWind.
  ///
  /// In en, this message translates to:
  /// **'Windy today; not a day to open hives'**
  String get weatherTodayWind;

  /// No description provided for @weatherTodayCold.
  ///
  /// In en, this message translates to:
  /// **'Cold today; not a day to open hives'**
  String get weatherTodayCold;

  /// No description provided for @weatherDayRange.
  ///
  /// In en, this message translates to:
  /// **'{from}–{to}'**
  String weatherDayRange(String from, String to);

  /// No description provided for @weatherPlanRain.
  ///
  /// In en, this message translates to:
  /// **'Rain on {days}.'**
  String weatherPlanRain(String days);

  /// No description provided for @weatherPlanWind.
  ///
  /// In en, this message translates to:
  /// **'Windy on {days}.'**
  String weatherPlanWind(String days);

  /// Suggested day for inspections; weekday is monday to sunday.
  ///
  /// In en, this message translates to:
  /// **'{weekday, select, monday{Move inspections to Monday.} tuesday{Move inspections to Tuesday.} wednesday{Move inspections to Wednesday.} thursday{Move inspections to Thursday.} friday{Move inspections to Friday.} saturday{Move inspections to Saturday.} other{Move inspections to Sunday.}}'**
  String weatherPlanMove(String weekday);

  /// Opens the new task form on the suggested day.
  ///
  /// In en, this message translates to:
  /// **'Plan'**
  String get weatherPlanAction;

  /// No description provided for @weatherPlanTaskTitle.
  ///
  /// In en, this message translates to:
  /// **'Inspect {apiary}'**
  String weatherPlanTaskTitle(String apiary);

  /// No description provided for @weatherThresholdsHint.
  ///
  /// In en, this message translates to:
  /// **'Good to open: above {temperature}, wind under {wind}, rain chance under {precipitation}. You can change the thresholds in Settings.'**
  String weatherThresholdsHint(
    String temperature,
    String wind,
    String precipitation,
  );

  /// No description provided for @weatherEmptyTitle.
  ///
  /// In en, this message translates to:
  /// **'No forecast yet'**
  String get weatherEmptyTitle;

  /// No description provided for @weatherEmptyMessage.
  ///
  /// In en, this message translates to:
  /// **'This apiary\'s forecast hasn\'t been fetched yet. Refresh once you\'re online.'**
  String get weatherEmptyMessage;

  /// No description provided for @weatherNoLocationMessage.
  ///
  /// In en, this message translates to:
  /// **'This apiary has no location. Add one to get a forecast.'**
  String get weatherNoLocationMessage;

  /// No description provided for @weatherRefresh.
  ///
  /// In en, this message translates to:
  /// **'Refresh'**
  String get weatherRefresh;

  /// No description provided for @weatherRefreshFailed.
  ///
  /// In en, this message translates to:
  /// **'Couldn\'t get the forecast. Check your internet connection.'**
  String get weatherRefreshFailed;

  /// No description provided for @weatherApiaryNotFound.
  ///
  /// In en, this message translates to:
  /// **'Apiary not found'**
  String get weatherApiaryNotFound;

  /// Text before the WeatherAPI.com link; keep this exact English text in every language.
  ///
  /// In en, this message translates to:
  /// **'Powered by '**
  String get weatherAttributionPrefix;

  /// Linked provider name; keep as is.
  ///
  /// In en, this message translates to:
  /// **'WeatherAPI.com'**
  String get weatherAttributionLink;

  /// No description provided for @settingsHiveOpening.
  ///
  /// In en, this message translates to:
  /// **'Hive opening thresholds'**
  String get settingsHiveOpening;

  /// No description provided for @settingsHiveOpeningTemperature.
  ///
  /// In en, this message translates to:
  /// **'Temperature'**
  String get settingsHiveOpeningTemperature;

  /// No description provided for @settingsHiveOpeningTemperatureValue.
  ///
  /// In en, this message translates to:
  /// **'above {value}'**
  String settingsHiveOpeningTemperatureValue(String value);

  /// No description provided for @settingsHiveOpeningWind.
  ///
  /// In en, this message translates to:
  /// **'Wind'**
  String get settingsHiveOpeningWind;

  /// No description provided for @settingsHiveOpeningPrecipitation.
  ///
  /// In en, this message translates to:
  /// **'Rain chance'**
  String get settingsHiveOpeningPrecipitation;

  /// No description provided for @settingsHiveOpeningBelow.
  ///
  /// In en, this message translates to:
  /// **'under {value}'**
  String settingsHiveOpeningBelow(String value);

  /// No description provided for @settingsHiveOpeningHint.
  ///
  /// In en, this message translates to:
  /// **'The weather screen and Today cards say \"Open\" by these thresholds. Saved on this phone only.'**
  String get settingsHiveOpeningHint;

  /// Green badge: weather is fine for opening hives.
  ///
  /// In en, this message translates to:
  /// **'Good to open'**
  String get hiveOpeningSuitable;

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

  /// Supplies and stock screen title; also its tile on More.
  ///
  /// In en, this message translates to:
  /// **'Supplies and stock'**
  String get inventoryTitle;

  /// Adds a stock item.
  ///
  /// In en, this message translates to:
  /// **'Add item'**
  String get inventoryAdd;

  /// Stock screen with no items: title.
  ///
  /// In en, this message translates to:
  /// **'No stock items yet'**
  String get inventoryEmptyTitle;

  /// Stock screen with no items: message.
  ///
  /// In en, this message translates to:
  /// **'Add supplies like sugar, foundation and jars. Items below their minimum are flagged.'**
  String get inventoryEmptyMessage;

  /// Selected category tab has no items.
  ///
  /// In en, this message translates to:
  /// **'No items in this category'**
  String get inventoryCategoryEmpty;

  /// Stock could not be read.
  ///
  /// In en, this message translates to:
  /// **'Couldn\'t open stock.'**
  String get inventoryLoadError;

  /// Stock item missing or deleted.
  ///
  /// In en, this message translates to:
  /// **'Item not found'**
  String get inventoryNotFound;

  /// Stock category: consumables (sugar, jars, labels).
  ///
  /// In en, this message translates to:
  /// **'Supplies'**
  String get inventoryCategoryConsumable;

  /// Stock category: equipment (boxes, frames, smoker).
  ///
  /// In en, this message translates to:
  /// **'Equipment'**
  String get inventoryCategoryEquipment;

  /// Stock category: drawn comb and foundation.
  ///
  /// In en, this message translates to:
  /// **'Comb'**
  String get inventoryCategoryComb;

  /// Short unit after a quantity: kilograms.
  ///
  /// In en, this message translates to:
  /// **'kg'**
  String get inventoryUnitKg;

  /// Short unit after a quantity: liters.
  ///
  /// In en, this message translates to:
  /// **'L'**
  String get inventoryUnitLiter;

  /// Short unit after a quantity: pieces.
  ///
  /// In en, this message translates to:
  /// **'pcs'**
  String get inventoryUnitPiece;

  /// Short unit after a quantity: rolls.
  ///
  /// In en, this message translates to:
  /// **'rolls'**
  String get inventoryUnitRoll;

  /// Short unit after a quantity: packs.
  ///
  /// In en, this message translates to:
  /// **'packs'**
  String get inventoryUnitPack;

  /// Unit choice in the item form.
  ///
  /// In en, this message translates to:
  /// **'Kilogram'**
  String get inventoryUnitNameKg;

  /// Unit choice in the item form.
  ///
  /// In en, this message translates to:
  /// **'Liter'**
  String get inventoryUnitNameLiter;

  /// Unit choice in the item form.
  ///
  /// In en, this message translates to:
  /// **'Piece'**
  String get inventoryUnitNamePiece;

  /// Unit choice in the item form.
  ///
  /// In en, this message translates to:
  /// **'Roll'**
  String get inventoryUnitNameRoll;

  /// Unit choice in the item form.
  ///
  /// In en, this message translates to:
  /// **'Pack'**
  String get inventoryUnitNamePack;

  /// A stock quantity with its short unit.
  ///
  /// In en, this message translates to:
  /// **'{quantity} {unit}'**
  String inventoryQuantity(String quantity, String unit);

  /// Item stock is below its minimum.
  ///
  /// In en, this message translates to:
  /// **'Below minimum · at least {threshold}'**
  String inventoryBelowThreshold(String threshold);

  /// Stock movement kind: stock added.
  ///
  /// In en, this message translates to:
  /// **'In'**
  String get inventoryMoveIn;

  /// Stock movement kind: stock used or removed.
  ///
  /// In en, this message translates to:
  /// **'Out'**
  String get inventoryMoveOut;

  /// Quick movement tab: enter the counted stock.
  ///
  /// In en, this message translates to:
  /// **'Count'**
  String get inventoryMoveCount;

  /// Stock movement kind in history: correction after a count.
  ///
  /// In en, this message translates to:
  /// **'Correction'**
  String get inventoryMoveAdjustment;

  /// Current stock in the quick movement sheet.
  ///
  /// In en, this message translates to:
  /// **'In stock: {quantity}'**
  String inventoryInStock(String quantity);

  /// Quick movement amount field.
  ///
  /// In en, this message translates to:
  /// **'Amount ({unit})'**
  String inventoryAmountLabel(String unit);

  /// Quick movement field when counting stock.
  ///
  /// In en, this message translates to:
  /// **'Counted amount ({unit})'**
  String inventoryCountedLabel(String unit);

  /// Amount is not a valid number.
  ///
  /// In en, this message translates to:
  /// **'Enter a valid amount'**
  String get inventoryAmountInvalid;

  /// Amount has decimals but the unit counts pieces.
  ///
  /// In en, this message translates to:
  /// **'Use a whole number for this unit'**
  String get inventoryAmountWhole;

  /// Saves a stock-in movement.
  ///
  /// In en, this message translates to:
  /// **'Add to stock'**
  String get inventorySaveIn;

  /// Saves a stock-out movement.
  ///
  /// In en, this message translates to:
  /// **'Remove from stock'**
  String get inventorySaveOut;

  /// Saves the counted stock as a correction.
  ///
  /// In en, this message translates to:
  /// **'Correct stock'**
  String get inventorySaveCount;

  /// Undo message after a stock-in.
  ///
  /// In en, this message translates to:
  /// **'{quantity} added'**
  String inventoryMovedIn(String quantity);

  /// Undo message after a stock-out.
  ///
  /// In en, this message translates to:
  /// **'{quantity} removed'**
  String inventoryMovedOut(String quantity);

  /// Undo message after a count correction.
  ///
  /// In en, this message translates to:
  /// **'Stock is now {quantity}'**
  String inventoryAdjusted(String quantity);

  /// Counted stock equals current stock; nothing saved.
  ///
  /// In en, this message translates to:
  /// **'Stock is already {quantity}'**
  String inventoryUnchanged(String quantity);

  /// Opens the item's detail and movement history.
  ///
  /// In en, this message translates to:
  /// **'Details and history'**
  String get inventoryDetails;

  /// Section title: item's movements.
  ///
  /// In en, this message translates to:
  /// **'History'**
  String get inventoryHistory;

  /// Item has no movements.
  ///
  /// In en, this message translates to:
  /// **'No movements yet'**
  String get inventoryHistoryEmpty;

  /// Item's minimum stock on the detail screen.
  ///
  /// In en, this message translates to:
  /// **'Minimum: at least {threshold}'**
  String inventoryThreshold(String threshold);

  /// Item has no minimum stock.
  ///
  /// In en, this message translates to:
  /// **'No minimum'**
  String get inventoryNoThreshold;

  /// Opens the quick stock movement sheet.
  ///
  /// In en, this message translates to:
  /// **'Add / remove'**
  String get inventoryQuickMove;

  /// Opens the item form.
  ///
  /// In en, this message translates to:
  /// **'Edit item'**
  String get inventoryEdit;

  /// Item form title when adding.
  ///
  /// In en, this message translates to:
  /// **'New item'**
  String get inventoryFormNewTitle;

  /// Item form title when editing.
  ///
  /// In en, this message translates to:
  /// **'Edit item'**
  String get inventoryFormEditTitle;

  /// Item form: name field.
  ///
  /// In en, this message translates to:
  /// **'Name'**
  String get inventoryFormName;

  /// Item form: category choice.
  ///
  /// In en, this message translates to:
  /// **'Category'**
  String get inventoryFormCategory;

  /// Item form: unit choice.
  ///
  /// In en, this message translates to:
  /// **'Unit'**
  String get inventoryFormUnit;

  /// Item form: where the item is kept.
  ///
  /// In en, this message translates to:
  /// **'Location'**
  String get inventoryFormLocation;

  /// Item form: location helper.
  ///
  /// In en, this message translates to:
  /// **'Storeroom, truck, office… Optional.'**
  String get inventoryFormLocationHint;

  /// Item form: minimum stock field.
  ///
  /// In en, this message translates to:
  /// **'Minimum'**
  String get inventoryFormThreshold;

  /// Item form: minimum helper.
  ///
  /// In en, this message translates to:
  /// **'You\'re warned when stock drops below this. Optional.'**
  String get inventoryFormThresholdHint;

  /// Item form: minimum is not a valid number.
  ///
  /// In en, this message translates to:
  /// **'Enter a valid minimum'**
  String get inventoryFormThresholdInvalid;

  /// Saves the item form.
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get inventoryFormSave;

  /// Deletes the item from the edit form.
  ///
  /// In en, this message translates to:
  /// **'Delete item'**
  String get inventoryFormDelete;

  /// Delete item confirmation title.
  ///
  /// In en, this message translates to:
  /// **'Delete this item?'**
  String get inventoryDeleteTitle;

  /// Delete item confirmation message.
  ///
  /// In en, this message translates to:
  /// **'The item and its stock leave the list.'**
  String get inventoryDeleteMessage;

  /// Delete item confirmation button.
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get inventoryDeleteConfirm;

  /// Message after saving an edited item.
  ///
  /// In en, this message translates to:
  /// **'Item saved'**
  String get inventorySaved;

  /// Message after deleting an item.
  ///
  /// In en, this message translates to:
  /// **'Item deleted'**
  String get inventoryDeleted;

  /// Sync screen record type: stock item.
  ///
  /// In en, this message translates to:
  /// **'Stock item'**
  String get syncTableInventoryItems;

  /// Sync screen record type: stock movement.
  ///
  /// In en, this message translates to:
  /// **'Stock movement'**
  String get syncTableInventoryMoves;

  /// A stock increase in the movement history, with its sign.
  ///
  /// In en, this message translates to:
  /// **'+{quantity}'**
  String inventoryIncrease(String quantity);

  /// Item form: minimum stock field once a unit is chosen.
  ///
  /// In en, this message translates to:
  /// **'Minimum ({unit})'**
  String inventoryFormThresholdUnit(String unit);

  /// Form row: which stock item the feeding or treatment is deducted from.
  ///
  /// In en, this message translates to:
  /// **'Deduct from stock'**
  String get stockUseTitle;

  /// Stock row value / option: nothing is deducted.
  ///
  /// In en, this message translates to:
  /// **'Don\'t deduct'**
  String get stockUseNone;

  /// Stock row value: item name and the amount to deduct.
  ///
  /// In en, this message translates to:
  /// **'{item} · −{quantity}'**
  String stockUseValue(String item, String quantity);

  /// Title of the stock item picker.
  ///
  /// In en, this message translates to:
  /// **'Deduct from which item?'**
  String get stockUseChoose;

  /// Task form row: drug planned for this task.
  ///
  /// In en, this message translates to:
  /// **'Planned treatment'**
  String get taskFormTreatment;

  /// Planned drug is no longer in the drug list.
  ///
  /// In en, this message translates to:
  /// **'Drug not in the list'**
  String get taskFormTreatmentUnknown;

  /// Hint: a planned treatment needs an apiary.
  ///
  /// In en, this message translates to:
  /// **'Choose an apiary for the planned treatment'**
  String get taskFormTreatmentNeedsApiary;

  /// Default title of a planned treatment task.
  ///
  /// In en, this message translates to:
  /// **'Treatment · {drug}'**
  String taskTreatmentPlanTitle(String drug);

  /// Shopping list screen title and shared text heading.
  ///
  /// In en, this message translates to:
  /// **'Shopping list'**
  String get shoppingTitle;

  /// Stock screen card: shopping list with item count.
  ///
  /// In en, this message translates to:
  /// **'Shopping list · {count}'**
  String shoppingCardTitle(int count);

  /// Empty shopping list title.
  ///
  /// In en, this message translates to:
  /// **'Nothing to buy'**
  String get shoppingEmptyTitle;

  /// Empty shopping list message.
  ///
  /// In en, this message translates to:
  /// **'Items below their threshold and the needs of planned treatments show up here.'**
  String get shoppingEmptyMessage;

  /// Button: share the shopping list as text.
  ///
  /// In en, this message translates to:
  /// **'Share'**
  String get shoppingShare;

  /// Shopping list load error.
  ///
  /// In en, this message translates to:
  /// **'Couldn\'t open the shopping list'**
  String get shoppingLoadError;

  /// Why an item is on the list: stock and threshold.
  ///
  /// In en, this message translates to:
  /// **'{stock} in stock · min {threshold}'**
  String shoppingReasonThreshold(String stock, String threshold);

  /// Why an item is on the list: planned treatment needs.
  ///
  /// In en, this message translates to:
  /// **'Planned treatments {quantity}'**
  String shoppingReasonPlanned(String quantity);

  /// A planned drug with no stock item linked.
  ///
  /// In en, this message translates to:
  /// **'Planned treatment · no stock item'**
  String get shoppingReasonNoItem;

  /// One line of the shared shopping list text.
  ///
  /// In en, this message translates to:
  /// **'• {name}: {quantity}'**
  String shoppingShareLine(String name, String quantity);

  /// More screen tile: queen rearing.
  ///
  /// In en, this message translates to:
  /// **'Queen rearing'**
  String get moreRearing;

  /// Queen rearing batches list title.
  ///
  /// In en, this message translates to:
  /// **'Queen rearing'**
  String get rearingTitle;

  /// Name of a queen rearing batch.
  ///
  /// In en, this message translates to:
  /// **'Batch {number}'**
  String rearingBatchName(int number);

  /// Batch screen title.
  ///
  /// In en, this message translates to:
  /// **'Queen rearing · Batch {number}'**
  String rearingBatchTitle(int number);

  /// Button: add a queen rearing batch.
  ///
  /// In en, this message translates to:
  /// **'Add batch'**
  String get rearingAdd;

  /// Empty batches list title.
  ///
  /// In en, this message translates to:
  /// **'No batches yet'**
  String get rearingEmptyTitle;

  /// Empty batches list message.
  ///
  /// In en, this message translates to:
  /// **'Enter the grafting day; the schedule from acceptance to the laying check and its reminders are set up for you.'**
  String get rearingEmptyMessage;

  /// Error loading batches.
  ///
  /// In en, this message translates to:
  /// **'Couldn\'t load batches'**
  String get rearingLoadError;

  /// Batch was deleted or does not exist.
  ///
  /// In en, this message translates to:
  /// **'Batch not found'**
  String get rearingNotFound;

  /// Batch row subtitle: grafting day.
  ///
  /// In en, this message translates to:
  /// **'grafted {date}'**
  String rearingListGrafted(String date);

  /// Tooltip: edit batch.
  ///
  /// In en, this message translates to:
  /// **'Edit batch'**
  String get rearingEdit;

  /// Summary tile: grafted larvae.
  ///
  /// In en, this message translates to:
  /// **'Grafted'**
  String get rearingGraftedLabel;

  /// Summary tile: accepted cells.
  ///
  /// In en, this message translates to:
  /// **'Accepted'**
  String get rearingAcceptedLabel;

  /// Summary tile: mating nucs of the batch.
  ///
  /// In en, this message translates to:
  /// **'Nucs'**
  String get rearingNucsLabel;

  /// Accepted cells were not counted yet.
  ///
  /// In en, this message translates to:
  /// **'Not counted'**
  String get rearingNotCounted;

  /// Acceptance rate.
  ///
  /// In en, this message translates to:
  /// **'{percent}%'**
  String rearingAcceptedPercent(int percent);

  /// Batch mother queen and grafting day.
  ///
  /// In en, this message translates to:
  /// **'Mother: {mother} · grafted {date}'**
  String rearingMotherLine(String mother, String date);

  /// Batch without mother queen.
  ///
  /// In en, this message translates to:
  /// **'Mother unknown · grafted {date}'**
  String rearingMotherUnknownLine(String date);

  /// Schedule day after grafting.
  ///
  /// In en, this message translates to:
  /// **'D{day}'**
  String rearingDay(int day);

  /// Step date is today.
  ///
  /// In en, this message translates to:
  /// **'Today'**
  String get rearingToday;

  /// Schedule step D0.
  ///
  /// In en, this message translates to:
  /// **'Larva grafting'**
  String get rearingStepGraft;

  /// Schedule step D1.
  ///
  /// In en, this message translates to:
  /// **'Acceptance check'**
  String get rearingStepAcceptance;

  /// Schedule step D5.
  ///
  /// In en, this message translates to:
  /// **'Cells capped'**
  String get rearingStepCapped;

  /// Schedule step D10.
  ///
  /// In en, this message translates to:
  /// **'Distribute cells'**
  String get rearingStepDistribution;

  /// Schedule step D12.
  ///
  /// In en, this message translates to:
  /// **'Queen emergence'**
  String get rearingStepEmergence;

  /// Schedule step D24.
  ///
  /// In en, this message translates to:
  /// **'Laying check'**
  String get rearingStepLayingCheck;

  /// D0 detail.
  ///
  /// In en, this message translates to:
  /// **'{count} larvae'**
  String rearingStepGraftDetail(int count);

  /// D1 detail when counted.
  ///
  /// In en, this message translates to:
  /// **'{count} cells accepted'**
  String rearingStepAcceptanceDetail(int count);

  /// D1 detail when not counted.
  ///
  /// In en, this message translates to:
  /// **'Count the accepted cells'**
  String get rearingStepAcceptanceTodo;

  /// D5 detail.
  ///
  /// In en, this message translates to:
  /// **'Don\'t disturb'**
  String get rearingStepCappedDetail;

  /// D10 detail.
  ///
  /// In en, this message translates to:
  /// **'Before emergence, to {count} nucs'**
  String rearingStepDistributionDetail(int count);

  /// D10 detail without count.
  ///
  /// In en, this message translates to:
  /// **'Before emergence, to the nucs'**
  String get rearingStepDistributionTodo;

  /// D12 detail.
  ///
  /// In en, this message translates to:
  /// **'Check the nucs'**
  String get rearingStepEmergenceDetail;

  /// D24 detail.
  ///
  /// In en, this message translates to:
  /// **'Mark mating success'**
  String get rearingStepLayingCheckDetail;

  /// Screen reader: step done.
  ///
  /// In en, this message translates to:
  /// **'done'**
  String get rearingStepDone;

  /// Screen reader: current step.
  ///
  /// In en, this message translates to:
  /// **'next'**
  String get rearingStepCurrent;

  /// Screen reader: upcoming step.
  ///
  /// In en, this message translates to:
  /// **'upcoming'**
  String get rearingStepUpcoming;

  /// Button: distribute cells to mating nucs.
  ///
  /// In en, this message translates to:
  /// **'Distribute cells to nucs'**
  String get rearingDistribute;

  /// Distribute sheet: apiary.
  ///
  /// In en, this message translates to:
  /// **'Apiary'**
  String get rearingDistributeApiary;

  /// Distribute sheet: number of nucs.
  ///
  /// In en, this message translates to:
  /// **'Nucs'**
  String get rearingDistributeCount;

  /// Distribute sheet: reused and new nucs.
  ///
  /// In en, this message translates to:
  /// **'Empty nucs reused: {reused} · New nucs: {created}'**
  String rearingDistributePlan(int reused, int created);

  /// Distribute sheet save.
  ///
  /// In en, this message translates to:
  /// **'Distribute'**
  String get rearingDistributeSave;

  /// Distribute sheet without apiaries.
  ///
  /// In en, this message translates to:
  /// **'Add an apiary first'**
  String get rearingDistributeNoApiary;

  /// Message after distributing.
  ///
  /// In en, this message translates to:
  /// **'Distributed to {count} nucs'**
  String rearingDistributed(int count);

  /// Batch screen section.
  ///
  /// In en, this message translates to:
  /// **'Mating nucs'**
  String get rearingNucsSection;

  /// Mating nuc name.
  ///
  /// In en, this message translates to:
  /// **'Nuc {number}'**
  String rearingNucTitle(String number);

  /// Nuc status.
  ///
  /// In en, this message translates to:
  /// **'Empty'**
  String get matingNucStatusEmpty;

  /// Nuc status.
  ///
  /// In en, this message translates to:
  /// **'Cell'**
  String get matingNucStatusCell;

  /// Nuc status.
  ///
  /// In en, this message translates to:
  /// **'Virgin queen'**
  String get matingNucStatusVirgin;

  /// Nuc status.
  ///
  /// In en, this message translates to:
  /// **'Laying'**
  String get matingNucStatusLaying;

  /// Nuc status.
  ///
  /// In en, this message translates to:
  /// **'Failed'**
  String get matingNucStatusFailed;

  /// Nuc status.
  ///
  /// In en, this message translates to:
  /// **'Given to a hive'**
  String get matingNucStatusGiven;

  /// Nuc action: give the laying queen to a hive.
  ///
  /// In en, this message translates to:
  /// **'Give to a hive'**
  String get rearingNucGive;

  /// Hive picker title.
  ///
  /// In en, this message translates to:
  /// **'Which hive?'**
  String get rearingNucChooseHive;

  /// Hive picker empty.
  ///
  /// In en, this message translates to:
  /// **'No active hives'**
  String get rearingNucNoHives;

  /// Batch form title (new).
  ///
  /// In en, this message translates to:
  /// **'New batch'**
  String get rearingFormNewTitle;

  /// Batch form title (edit).
  ///
  /// In en, this message translates to:
  /// **'Edit batch'**
  String get rearingFormEditTitle;

  /// Batch form: grafting day.
  ///
  /// In en, this message translates to:
  /// **'Grafting day'**
  String get rearingFormGraftedOn;

  /// Batch form: grafted count.
  ///
  /// In en, this message translates to:
  /// **'Grafted larvae'**
  String get rearingFormGraftedCount;

  /// Batch form: accepted count.
  ///
  /// In en, this message translates to:
  /// **'Accepted cells'**
  String get rearingFormAcceptedCount;

  /// Batch form: clear accepted count.
  ///
  /// In en, this message translates to:
  /// **'Not counted yet'**
  String get rearingFormAcceptedClear;

  /// Batch form hint.
  ///
  /// In en, this message translates to:
  /// **'Acceptance, capping, distribution, emergence and laying check are added as tasks with reminders.'**
  String get rearingFormScheduleHint;

  /// Batch form save.
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get rearingFormSave;

  /// Batch form delete.
  ///
  /// In en, this message translates to:
  /// **'Delete batch'**
  String get rearingFormDelete;

  /// Delete dialog title.
  ///
  /// In en, this message translates to:
  /// **'Delete batch?'**
  String get rearingDeleteTitle;

  /// Delete dialog message.
  ///
  /// In en, this message translates to:
  /// **'Its tasks are deleted too. Nucs and given queens stay.'**
  String get rearingDeleteMessage;

  /// Delete dialog confirm.
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get rearingDeleteConfirm;

  /// Message after deleting.
  ///
  /// In en, this message translates to:
  /// **'Batch deleted'**
  String get rearingDeleted;

  /// Message after saving an edited batch.
  ///
  /// In en, this message translates to:
  /// **'Batch saved'**
  String get rearingSaved;

  /// Task context: created by queen rearing schedule.
  ///
  /// In en, this message translates to:
  /// **'queen rearing'**
  String get taskSourceQueenRearing;

  /// Sync screen record type.
  ///
  /// In en, this message translates to:
  /// **'Queen rearing batch'**
  String get syncTableQueenRearingBatches;

  /// Sync screen record type.
  ///
  /// In en, this message translates to:
  /// **'Mating nuc'**
  String get syncTableMatingNucs;

  /// Lots list title and More tile.
  ///
  /// In en, this message translates to:
  /// **'Harvest & lots'**
  String get lotsTitle;

  /// Empty lots list title.
  ///
  /// In en, this message translates to:
  /// **'No lots yet'**
  String get lotsEmptyTitle;

  /// Empty lots list message.
  ///
  /// In en, this message translates to:
  /// **'Add a harvest to a lot after saving it; lots are listed here.'**
  String get lotsEmptyMessage;

  /// Lots load error.
  ///
  /// In en, this message translates to:
  /// **'Couldn\'t load lots'**
  String get lotsLoadError;

  /// Overview tile: honey in stock.
  ///
  /// In en, this message translates to:
  /// **'In stock'**
  String get lotsInStock;

  /// Overview tile: this year's yield per hive.
  ///
  /// In en, this message translates to:
  /// **'Per hive'**
  String get lotsPerHive;

  /// Lot number label.
  ///
  /// In en, this message translates to:
  /// **'Lot {number}'**
  String lotNumber(String number);

  /// Lot title from honey kind.
  ///
  /// In en, this message translates to:
  /// **'{kind} honey'**
  String lotHoneyTitle(String kind);

  /// Lot status: harvests can be added.
  ///
  /// In en, this message translates to:
  /// **'Open'**
  String get lotStatusOpen;

  /// Lot status: no more harvests.
  ///
  /// In en, this message translates to:
  /// **'Closed'**
  String get lotStatusClosed;

  /// Badge: harvested during drug withdrawal period.
  ///
  /// In en, this message translates to:
  /// **'In withdrawal'**
  String get lotWithdrawalBadge;

  /// Moisture tag.
  ///
  /// In en, this message translates to:
  /// **'Moisture {value}%'**
  String lotMoistureValue(String value);

  /// Tag: lot has a lab analysis.
  ///
  /// In en, this message translates to:
  /// **'Analysed ✓'**
  String get lotAnalyzed;

  /// Tag: lot has no lab analysis yet.
  ///
  /// In en, this message translates to:
  /// **'Analysis pending'**
  String get lotAnalysisPending;

  /// Stock tag.
  ///
  /// In en, this message translates to:
  /// **'Stock {weight}'**
  String lotStockValue(String weight);

  /// Lot missing or deleted.
  ///
  /// In en, this message translates to:
  /// **'Lot not found'**
  String get lotNotFound;

  /// Edit action tooltip.
  ///
  /// In en, this message translates to:
  /// **'Edit lot'**
  String get lotEdit;

  /// Withdrawal violation card title.
  ///
  /// In en, this message translates to:
  /// **'{hives} harvested during the withdrawal period.'**
  String lotWithdrawalTitle(String hives);

  /// Withdrawal violation card message.
  ///
  /// In en, this message translates to:
  /// **'This lot may contain drug residue; get it analysed before selling.'**
  String get lotWithdrawalMessage;

  /// Section label.
  ///
  /// In en, this message translates to:
  /// **'Stock'**
  String get lotStock;

  /// Stock row: total harvested.
  ///
  /// In en, this message translates to:
  /// **'Harvested'**
  String get lotHarvested;

  /// Stock row: total sold.
  ///
  /// In en, this message translates to:
  /// **'Sold'**
  String get lotSold;

  /// Stock row: remaining.
  ///
  /// In en, this message translates to:
  /// **'In stock'**
  String get lotInStock;

  /// Button: subtract sold honey from stock.
  ///
  /// In en, this message translates to:
  /// **'Record a sale'**
  String get lotSell;

  /// Section label.
  ///
  /// In en, this message translates to:
  /// **'Analyses'**
  String get lotAnalyses;

  /// Empty analyses.
  ///
  /// In en, this message translates to:
  /// **'No analyses yet'**
  String get lotAnalysesEmpty;

  /// Button: add lab result.
  ///
  /// In en, this message translates to:
  /// **'Add analysis'**
  String get lotAddAnalysis;

  /// Section label.
  ///
  /// In en, this message translates to:
  /// **'Harvests'**
  String get lotHarvests;

  /// Empty harvests.
  ///
  /// In en, this message translates to:
  /// **'No harvests in this lot'**
  String get lotHarvestsEmpty;

  /// Section label.
  ///
  /// In en, this message translates to:
  /// **'Hives\' last treatment'**
  String get lotTreatments;

  /// Empty treatments.
  ///
  /// In en, this message translates to:
  /// **'No treatments recorded for this lot\'s hives'**
  String get lotTreatmentsEmpty;

  /// Treatment row title.
  ///
  /// In en, this message translates to:
  /// **'Hive {hive} · {product}'**
  String lotTreatmentTitle(String hive, String product);

  /// Treatment row detail.
  ///
  /// In en, this message translates to:
  /// **'{date} · withdrawal ends {end}'**
  String lotTreatmentDetail(String date, String end);

  /// Lot screen section for the public QR page.
  ///
  /// In en, this message translates to:
  /// **'Public page'**
  String get lotPublicPage;

  /// Switch that publishes the lot's public page.
  ///
  /// In en, this message translates to:
  /// **'Publish'**
  String get lotPublish;

  /// Explains what publishing a lot does.
  ///
  /// In en, this message translates to:
  /// **'Anyone who scans the QR sees the lot\'s page. Phone, address and location are never shown.'**
  String get lotPublishHint;

  /// Shown to non-owners under the publish state.
  ///
  /// In en, this message translates to:
  /// **'Only the business owner can publish.'**
  String get lotPublishOwnerOnly;

  /// Lot page is public.
  ///
  /// In en, this message translates to:
  /// **'Published'**
  String get lotPublished;

  /// Lot page is not public.
  ///
  /// In en, this message translates to:
  /// **'Not published'**
  String get lotNotPublished;

  /// Heading for the public page field switches.
  ///
  /// In en, this message translates to:
  /// **'Shown on the page'**
  String get lotPublicFields;

  /// Public page field.
  ///
  /// In en, this message translates to:
  /// **'Business name and hive count'**
  String get lotPublicProducer;

  /// Public page field.
  ///
  /// In en, this message translates to:
  /// **'Origin and harvest month'**
  String get lotPublicOrigin;

  /// Public page field.
  ///
  /// In en, this message translates to:
  /// **'Analysis values'**
  String get lotPublicLab;

  /// Public page field.
  ///
  /// In en, this message translates to:
  /// **'Analysis report'**
  String get lotPublicReport;

  /// Section and title for the lot's jar label PDF.
  ///
  /// In en, this message translates to:
  /// **'Jar labels (QR)'**
  String get lotJarLabels;

  /// Jar label sheet explanation.
  ///
  /// In en, this message translates to:
  /// **'24 labels per A4 page (70 × 37 mm); print at 100% scale.'**
  String get lotJarLabelsHint;

  /// Jar label PDF name.
  ///
  /// In en, this message translates to:
  /// **'Jar labels - {number}'**
  String lotJarLabelsDocumentName(String number);

  /// Section label.
  ///
  /// In en, this message translates to:
  /// **'Sales'**
  String get lotSales;

  /// Empty sales.
  ///
  /// In en, this message translates to:
  /// **'No sales recorded yet'**
  String get lotSalesEmpty;

  /// Sale row amount.
  ///
  /// In en, this message translates to:
  /// **'−{weight}'**
  String lotSaleValue(String weight);

  /// Sale amount field label.
  ///
  /// In en, this message translates to:
  /// **'Honey sold ({unit})'**
  String lotSaleAmount(String unit);

  /// Sale exceeds stock.
  ///
  /// In en, this message translates to:
  /// **'Only {weight} in stock'**
  String lotSaleTooMuch(String weight);

  /// Sale save button.
  ///
  /// In en, this message translates to:
  /// **'Subtract from stock'**
  String get lotSaleSave;

  /// Message after recording a sale.
  ///
  /// In en, this message translates to:
  /// **'{weight} sale recorded'**
  String lotSaleSaved(String weight);

  /// Lot origin field.
  ///
  /// In en, this message translates to:
  /// **'Origin'**
  String get lotOrigin;

  /// Origin hint.
  ///
  /// In en, this message translates to:
  /// **'E.g. Mountain pine'**
  String get lotOriginHint;

  /// Moisture field.
  ///
  /// In en, this message translates to:
  /// **'Moisture %'**
  String get lotMoisture;

  /// Moisture helper.
  ///
  /// In en, this message translates to:
  /// **'Refractometer reading; optional'**
  String get lotMoistureHelper;

  /// Moisture invalid.
  ///
  /// In en, this message translates to:
  /// **'Enter a value between 10 and 30, like 17.2'**
  String get lotMoistureInvalid;

  /// Lot edit title.
  ///
  /// In en, this message translates to:
  /// **'Edit {lot}'**
  String lotEditTitle(String lot);

  /// Lot status field.
  ///
  /// In en, this message translates to:
  /// **'Status'**
  String get lotStatus;

  /// Status helper.
  ///
  /// In en, this message translates to:
  /// **'Closed lots don\'t take new harvests'**
  String get lotStatusHelper;

  /// Lot save button.
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get lotSave;

  /// Delete button.
  ///
  /// In en, this message translates to:
  /// **'Delete lot'**
  String get lotDelete;

  /// Delete dialog title.
  ///
  /// In en, this message translates to:
  /// **'Delete {lot}?'**
  String lotDeleteTitle(String lot);

  /// Delete dialog message.
  ///
  /// In en, this message translates to:
  /// **'Analyses and sales are deleted too; harvests stay.'**
  String get lotDeleteMessage;

  /// Message after deleting.
  ///
  /// In en, this message translates to:
  /// **'Lot deleted'**
  String get lotDeleted;

  /// Lab result form title.
  ///
  /// In en, this message translates to:
  /// **'Analysis · {lot}'**
  String labTitle(String lot);

  /// Date row.
  ///
  /// In en, this message translates to:
  /// **'Analysis date'**
  String get labDate;

  /// HMF field.
  ///
  /// In en, this message translates to:
  /// **'HMF (mg/kg)'**
  String get labHmf;

  /// Diastase field.
  ///
  /// In en, this message translates to:
  /// **'Diastase number'**
  String get labDiastase;

  /// Proline field.
  ///
  /// In en, this message translates to:
  /// **'Proline (mg/kg)'**
  String get labProline;

  /// HMF in result row.
  ///
  /// In en, this message translates to:
  /// **'HMF {value}'**
  String labHmfValue(String value);

  /// Diastase in result row.
  ///
  /// In en, this message translates to:
  /// **'Diastase {value}'**
  String labDiastaseValue(String value);

  /// Proline in result row.
  ///
  /// In en, this message translates to:
  /// **'Proline {value}'**
  String labProlineValue(String value);

  /// Lab value invalid.
  ///
  /// In en, this message translates to:
  /// **'Enter a value between {min} and {max}'**
  String labValueInvalid(String min, String max);

  /// Residue field.
  ///
  /// In en, this message translates to:
  /// **'Residue'**
  String get labResidue;

  /// Residue: none.
  ///
  /// In en, this message translates to:
  /// **'No residue'**
  String get labResidueNone;

  /// Residue: detected.
  ///
  /// In en, this message translates to:
  /// **'Residue detected'**
  String get labResidueDetected;

  /// Report row and icon label.
  ///
  /// In en, this message translates to:
  /// **'Report'**
  String get labReport;

  /// No report selected.
  ///
  /// In en, this message translates to:
  /// **'No report'**
  String get labReportNone;

  /// Report picker empty.
  ///
  /// In en, this message translates to:
  /// **'No analysis reports in the document vault'**
  String get labReportEmpty;

  /// Button to document vault.
  ///
  /// In en, this message translates to:
  /// **'Add report to document vault'**
  String get labReportAdd;

  /// Save button.
  ///
  /// In en, this message translates to:
  /// **'Save analysis'**
  String get labSave;

  /// Message after saving.
  ///
  /// In en, this message translates to:
  /// **'Analysis saved'**
  String get labSaved;

  /// Harvest lot step title.
  ///
  /// In en, this message translates to:
  /// **'Add to lot'**
  String get harvestLotTitle;

  /// Harvest lot step summary.
  ///
  /// In en, this message translates to:
  /// **'Harvest saved: {weight} {kind}'**
  String harvestLotSaved(String weight, String kind);

  /// Harvest lot step intro.
  ///
  /// In en, this message translates to:
  /// **'When honey goes into a lot, the hives\' last treatment dates are linked to it.'**
  String get harvestLotIntro;

  /// Option: create a new lot.
  ///
  /// In en, this message translates to:
  /// **'New lot'**
  String get harvestLotNew;

  /// New lot hint.
  ///
  /// In en, this message translates to:
  /// **'{kind} · number assigned automatically'**
  String harvestLotNewHint(String kind);

  /// Create lot button.
  ///
  /// In en, this message translates to:
  /// **'Create lot'**
  String get harvestLotCreate;

  /// Add to existing lot button.
  ///
  /// In en, this message translates to:
  /// **'Add to lot'**
  String get harvestLotAdd;

  /// Skip lot step.
  ///
  /// In en, this message translates to:
  /// **'Skip for now'**
  String get harvestLotSkip;

  /// Message after creating lot.
  ///
  /// In en, this message translates to:
  /// **'{lot} created'**
  String harvestLotCreated(String lot);

  /// Message after adding to lot.
  ///
  /// In en, this message translates to:
  /// **'Harvest added to {lot}'**
  String harvestLotAdded(String lot);

  /// Harvest lot step: harvest deleted.
  ///
  /// In en, this message translates to:
  /// **'Harvest was undone'**
  String get harvestLotGone;

  /// Back button.
  ///
  /// In en, this message translates to:
  /// **'Back to apiary'**
  String get harvestLotBack;

  /// Sync screen record type.
  ///
  /// In en, this message translates to:
  /// **'Lot'**
  String get syncTableLots;

  /// Sync screen record type.
  ///
  /// In en, this message translates to:
  /// **'Lot harvest'**
  String get syncTableLotHarvests;

  /// Sync screen record type.
  ///
  /// In en, this message translates to:
  /// **'Lot treatment'**
  String get syncTableLotTreatments;

  /// Sync screen record type.
  ///
  /// In en, this message translates to:
  /// **'Lab result'**
  String get syncTableLabResults;

  /// Sync screen record type.
  ///
  /// In en, this message translates to:
  /// **'Lot sale'**
  String get syncTableLotSales;

  /// Harvest lot step: harvest deleted message.
  ///
  /// In en, this message translates to:
  /// **'The harvest wasn\'t added to a lot. You can record it again from the apiary.'**
  String get harvestLotGoneMessage;

  /// Finance screen and More tile title.
  ///
  /// In en, this message translates to:
  /// **'Finance'**
  String get financeTitle;

  /// Finance screen app bar with season year.
  ///
  /// In en, this message translates to:
  /// **'Finance · {year}'**
  String financeYearTitle(String year);

  /// Finance summary card label.
  ///
  /// In en, this message translates to:
  /// **'Season net'**
  String get financeSeasonNet;

  /// Finance summary: income.
  ///
  /// In en, this message translates to:
  /// **'Income'**
  String get financeIncome;

  /// Finance summary: expense.
  ///
  /// In en, this message translates to:
  /// **'Expense'**
  String get financeExpense;

  /// Finance summary: expense per active hive.
  ///
  /// In en, this message translates to:
  /// **'Cost/hive'**
  String get financeCostPerHive;

  /// Finance section label.
  ///
  /// In en, this message translates to:
  /// **'Recent entries'**
  String get financeRecent;

  /// Finance empty state title.
  ///
  /// In en, this message translates to:
  /// **'No entries yet'**
  String get financeEmptyTitle;

  /// Finance empty state message.
  ///
  /// In en, this message translates to:
  /// **'Record income and expenses with the buttons below; the season net is calculated here.'**
  String get financeEmptyMessage;

  /// Finance load error.
  ///
  /// In en, this message translates to:
  /// **'Couldn\'t load entries'**
  String get financeLoadError;

  /// Add income button.
  ///
  /// In en, this message translates to:
  /// **'+ Income'**
  String get financeAddIncome;

  /// Add expense button.
  ///
  /// In en, this message translates to:
  /// **'− Expense'**
  String get financeAddExpense;

  /// Positive amount.
  ///
  /// In en, this message translates to:
  /// **'+{amount}'**
  String financePlus(String amount);

  /// Negative amount.
  ///
  /// In en, this message translates to:
  /// **'−{amount}'**
  String financeMinus(String amount);

  /// Entry subtitle when a receipt photo is attached.
  ///
  /// In en, this message translates to:
  /// **'receipt attached'**
  String get financeReceiptAttached;

  /// Transport source and destination apiaries.
  ///
  /// In en, this message translates to:
  /// **'{from} → {to}'**
  String financeTransportRoute(String from, String to);

  /// Income form title.
  ///
  /// In en, this message translates to:
  /// **'Add income'**
  String get financeFormIncomeTitle;

  /// Expense form title.
  ///
  /// In en, this message translates to:
  /// **'Add expense'**
  String get financeFormExpenseTitle;

  /// Amount field label with currency symbol.
  ///
  /// In en, this message translates to:
  /// **'Amount ({currency})'**
  String financeFormAmount(String currency);

  /// Invalid amount warning.
  ///
  /// In en, this message translates to:
  /// **'Enter an amount above 0, like 17500 or 17.50'**
  String get financeFormAmountInvalid;

  /// Category field label.
  ///
  /// In en, this message translates to:
  /// **'Category'**
  String get financeFormCategory;

  /// Date row label.
  ///
  /// In en, this message translates to:
  /// **'Date'**
  String get financeFormDate;

  /// Description field label.
  ///
  /// In en, this message translates to:
  /// **'Description'**
  String get financeFormDescription;

  /// Description hint.
  ///
  /// In en, this message translates to:
  /// **'E.g. Sugar 500 kg'**
  String get financeFormDescriptionHint;

  /// Receipt section label.
  ///
  /// In en, this message translates to:
  /// **'Receipt / invoice'**
  String get financeFormReceipt;

  /// No receipt photo yet.
  ///
  /// In en, this message translates to:
  /// **'No receipt'**
  String get financeFormNoReceipt;

  /// Receipt photo taken.
  ///
  /// In en, this message translates to:
  /// **'Receipt photo added'**
  String get financeFormReceiptAdded;

  /// Receipt camera button.
  ///
  /// In en, this message translates to:
  /// **'Take photo'**
  String get financeFormTakePhoto;

  /// Receipt gallery button.
  ///
  /// In en, this message translates to:
  /// **'From gallery'**
  String get financeFormPickImage;

  /// Remove receipt button.
  ///
  /// In en, this message translates to:
  /// **'Remove receipt'**
  String get financeFormRemoveReceipt;

  /// Receipt permission denied.
  ///
  /// In en, this message translates to:
  /// **'Permission denied. To add a receipt, allow camera or photo access for this app in Settings.'**
  String get financeFormPhotoDenied;

  /// Receipt photo failed.
  ///
  /// In en, this message translates to:
  /// **'Couldn\'t get the photo, try again.'**
  String get financeFormPhotoFailed;

  /// Linked records section label.
  ///
  /// In en, this message translates to:
  /// **'Linked record'**
  String get financeFormLinks;

  /// Linked apiary row.
  ///
  /// In en, this message translates to:
  /// **'Apiary'**
  String get financeFormApiary;

  /// Linked lot row.
  ///
  /// In en, this message translates to:
  /// **'Lot'**
  String get financeFormLot;

  /// Linked transport row.
  ///
  /// In en, this message translates to:
  /// **'Move'**
  String get financeFormTransport;

  /// No linked record.
  ///
  /// In en, this message translates to:
  /// **'None'**
  String get financeFormNone;

  /// Apiary picker title.
  ///
  /// In en, this message translates to:
  /// **'Choose apiary'**
  String get financeFormChooseApiary;

  /// Lot picker title.
  ///
  /// In en, this message translates to:
  /// **'Choose lot'**
  String get financeFormChooseLot;

  /// Transport picker title.
  ///
  /// In en, this message translates to:
  /// **'Choose move'**
  String get financeFormChooseTransport;

  /// Lot picker empty.
  ///
  /// In en, this message translates to:
  /// **'No lots yet'**
  String get financeFormNoLots;

  /// Transport picker empty.
  ///
  /// In en, this message translates to:
  /// **'No moves yet'**
  String get financeFormNoTransports;

  /// Sold honey field with mass unit.
  ///
  /// In en, this message translates to:
  /// **'Honey sold ({unit})'**
  String financeFormSaleAmount(String unit);

  /// Sold honey helper.
  ///
  /// In en, this message translates to:
  /// **'Deducted from the lot\'s stock; leave empty to keep the stock'**
  String get financeFormSaleHelper;

  /// Save button.
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get financeFormSave;

  /// Snackbar after saving income.
  ///
  /// In en, this message translates to:
  /// **'Income saved'**
  String get financeIncomeSaved;

  /// Snackbar after saving expense.
  ///
  /// In en, this message translates to:
  /// **'Expense saved'**
  String get financeExpenseSaved;

  /// Transaction not found.
  ///
  /// In en, this message translates to:
  /// **'Entry not found'**
  String get financeNotFound;

  /// Receipt file not downloaded yet.
  ///
  /// In en, this message translates to:
  /// **'The receipt hasn\'t reached this phone yet'**
  String get financeReceiptPending;

  /// Delete button.
  ///
  /// In en, this message translates to:
  /// **'Delete entry'**
  String get financeDelete;

  /// Delete confirmation title.
  ///
  /// In en, this message translates to:
  /// **'Delete this entry?'**
  String get financeDeleteTitle;

  /// Delete confirmation message.
  ///
  /// In en, this message translates to:
  /// **'If it\'s linked to a lot sale, the sale is deleted too and the stock comes back.'**
  String get financeDeleteMessage;

  /// Delete confirmation button.
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get financeDeleteConfirm;

  /// Snackbar after delete.
  ///
  /// In en, this message translates to:
  /// **'Entry deleted'**
  String get financeDeleted;

  /// Expense category.
  ///
  /// In en, this message translates to:
  /// **'Feeding'**
  String get financeCategoryFeeding;

  /// Expense category.
  ///
  /// In en, this message translates to:
  /// **'Medicine'**
  String get financeCategoryTreatment;

  /// Expense category.
  ///
  /// In en, this message translates to:
  /// **'Equipment'**
  String get financeCategoryEquipment;

  /// Expense category.
  ///
  /// In en, this message translates to:
  /// **'Fuel / transport'**
  String get financeCategoryFuelTransport;

  /// Expense category.
  ///
  /// In en, this message translates to:
  /// **'Land rent'**
  String get financeCategoryLandRent;

  /// Expense category.
  ///
  /// In en, this message translates to:
  /// **'Labor'**
  String get financeCategoryLabor;

  /// Expense category.
  ///
  /// In en, this message translates to:
  /// **'Lab analysis'**
  String get financeCategoryLabAnalysis;

  /// Income category.
  ///
  /// In en, this message translates to:
  /// **'Honey'**
  String get financeCategoryHoney;

  /// Income category.
  ///
  /// In en, this message translates to:
  /// **'Pollen'**
  String get financeCategoryPollen;

  /// Income category.
  ///
  /// In en, this message translates to:
  /// **'Propolis'**
  String get financeCategoryPropolis;

  /// Income category.
  ///
  /// In en, this message translates to:
  /// **'Wax'**
  String get financeCategoryWax;

  /// Income category.
  ///
  /// In en, this message translates to:
  /// **'Nucs'**
  String get financeCategoryNucs;

  /// Income and expense category.
  ///
  /// In en, this message translates to:
  /// **'Queens'**
  String get financeCategoryQueens;

  /// Income and expense category.
  ///
  /// In en, this message translates to:
  /// **'Other'**
  String get financeCategoryOther;

  /// Sync screen record type.
  ///
  /// In en, this message translates to:
  /// **'Income/expense'**
  String get syncTableTransactions;

  /// Customer list title; link on finance screen.
  ///
  /// In en, this message translates to:
  /// **'Customer book'**
  String get customersTitle;

  /// App bar add button.
  ///
  /// In en, this message translates to:
  /// **'Add customer'**
  String get customersAdd;

  /// Empty customer list title.
  ///
  /// In en, this message translates to:
  /// **'No customers yet'**
  String get customersEmptyTitle;

  /// Empty customer list message.
  ///
  /// In en, this message translates to:
  /// **'Add customers to track their orders and what they owe.'**
  String get customersEmptyMessage;

  /// Receivable of a customer.
  ///
  /// In en, this message translates to:
  /// **'{amount} owed'**
  String customerReceivableValue(String amount);

  /// No receivable.
  ///
  /// In en, this message translates to:
  /// **'Nothing owed'**
  String get customerNoReceivable;

  /// Missing customer.
  ///
  /// In en, this message translates to:
  /// **'Customer not found'**
  String get customerNotFound;

  /// Edit button tooltip.
  ///
  /// In en, this message translates to:
  /// **'Edit customer'**
  String get customerEdit;

  /// Opens income form for this customer.
  ///
  /// In en, this message translates to:
  /// **'Add sale'**
  String get customerAddSale;

  /// Section label for customer sales.
  ///
  /// In en, this message translates to:
  /// **'Orders'**
  String get customerOrders;

  /// Empty orders.
  ///
  /// In en, this message translates to:
  /// **'No sales to this customer yet.'**
  String get customerNoOrders;

  /// Sale fully paid badge.
  ///
  /// In en, this message translates to:
  /// **'Paid'**
  String get customerPaid;

  /// Unpaid remainder of a sale.
  ///
  /// In en, this message translates to:
  /// **'{amount} left'**
  String customerRemaining(String amount);

  /// Paid amount row.
  ///
  /// In en, this message translates to:
  /// **'Paid so far'**
  String get customerPaidAmount;

  /// Order action: pays the remainder.
  ///
  /// In en, this message translates to:
  /// **'Mark as paid'**
  String get customerMarkPaid;

  /// Snackbar after marking paid.
  ///
  /// In en, this message translates to:
  /// **'Marked as paid'**
  String get customerMarkedPaid;

  /// Order action and payment form title.
  ///
  /// In en, this message translates to:
  /// **'Record payment'**
  String get customerAddPayment;

  /// Order action: sends order summary.
  ///
  /// In en, this message translates to:
  /// **'Send via WhatsApp'**
  String get customerSendWhatsApp;

  /// Hint when customer has no phone.
  ///
  /// In en, this message translates to:
  /// **'No phone; pick the contact in WhatsApp'**
  String get customerWhatsAppNoPhone;

  /// Launch failure.
  ///
  /// In en, this message translates to:
  /// **'Couldn\'t open WhatsApp'**
  String get customerWhatsAppFailed;

  /// Order action: open transaction.
  ///
  /// In en, this message translates to:
  /// **'Open entry'**
  String get customerOpenTransaction;

  /// Order summary first line.
  ///
  /// In en, this message translates to:
  /// **'Hello {name},'**
  String customerWhatsAppGreeting(String name);

  /// Order summary intro.
  ///
  /// In en, this message translates to:
  /// **'Your order summary:'**
  String get customerWhatsAppIntro;

  /// Order summary total.
  ///
  /// In en, this message translates to:
  /// **'Total: {amount}'**
  String customerWhatsAppAmount(String amount);

  /// Order summary paid.
  ///
  /// In en, this message translates to:
  /// **'Paid: {amount}'**
  String customerWhatsAppPaid(String amount);

  /// Order summary remaining.
  ///
  /// In en, this message translates to:
  /// **'Remaining: {amount}'**
  String customerWhatsAppRemaining(String amount);

  /// Order summary when paid.
  ///
  /// In en, this message translates to:
  /// **'Paid in full, thank you.'**
  String get customerWhatsAppPaidInFull;

  /// Order summary address.
  ///
  /// In en, this message translates to:
  /// **'Shipping address: {address}'**
  String customerWhatsAppAddress(String address);

  /// Customer form title.
  ///
  /// In en, this message translates to:
  /// **'New customer'**
  String get customerFormNewTitle;

  /// Customer form title.
  ///
  /// In en, this message translates to:
  /// **'Edit customer'**
  String get customerFormEditTitle;

  /// Customer name field.
  ///
  /// In en, this message translates to:
  /// **'Name'**
  String get customerFormName;

  /// Customer phone field.
  ///
  /// In en, this message translates to:
  /// **'Phone'**
  String get customerFormPhone;

  /// Phone field helper.
  ///
  /// In en, this message translates to:
  /// **'For WhatsApp, e.g. +44 7700 900123'**
  String get customerFormPhoneHelper;

  /// Customer address field.
  ///
  /// In en, this message translates to:
  /// **'Shipping address'**
  String get customerFormAddress;

  /// Customer note field.
  ///
  /// In en, this message translates to:
  /// **'Note'**
  String get customerFormNotes;

  /// Customer form save.
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get customerFormSave;

  /// Snackbar after save.
  ///
  /// In en, this message translates to:
  /// **'Customer saved'**
  String get customerSaved;

  /// Delete button.
  ///
  /// In en, this message translates to:
  /// **'Delete customer'**
  String get customerDelete;

  /// Confirm title.
  ///
  /// In en, this message translates to:
  /// **'Delete customer?'**
  String get customerDeleteTitle;

  /// Confirm message.
  ///
  /// In en, this message translates to:
  /// **'Their sales stay in your income entries.'**
  String get customerDeleteMessage;

  /// Confirm button.
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get customerDeleteConfirm;

  /// Snackbar after delete.
  ///
  /// In en, this message translates to:
  /// **'Customer deleted'**
  String get customerDeleted;

  /// Payment form save.
  ///
  /// In en, this message translates to:
  /// **'Save payment'**
  String get customerPaymentSave;

  /// Snackbar after payment.
  ///
  /// In en, this message translates to:
  /// **'Payment saved'**
  String get customerPaymentSaved;

  /// Payment over remainder.
  ///
  /// In en, this message translates to:
  /// **'Only {amount} is left.'**
  String customerPaymentTooMuch(String amount);

  /// Income customer link.
  ///
  /// In en, this message translates to:
  /// **'Customer'**
  String get financeFormCustomer;

  /// Customer picker title.
  ///
  /// In en, this message translates to:
  /// **'Choose customer'**
  String get financeFormChooseCustomer;

  /// Customer picker empty.
  ///
  /// In en, this message translates to:
  /// **'No customers yet'**
  String get financeFormNoCustomers;

  /// Upfront payment field.
  ///
  /// In en, this message translates to:
  /// **'Paid now'**
  String get financeFormPaidNow;

  /// Upfront payment helper.
  ///
  /// In en, this message translates to:
  /// **'Leave empty if the whole amount is owed.'**
  String get financeFormPaidNowHelper;

  /// Upfront payment over amount.
  ///
  /// In en, this message translates to:
  /// **'Can\'t be more than the amount.'**
  String get financeFormPaidTooMuch;

  /// Profitability card title.
  ///
  /// In en, this message translates to:
  /// **'Profit by apiary'**
  String get financeProfitTitle;

  /// Profit row for deleted apiary.
  ///
  /// In en, this message translates to:
  /// **'Deleted apiary'**
  String get financeProfitUnknownApiary;

  /// Receivables summary.
  ///
  /// In en, this message translates to:
  /// **'{amount} owed · {count, plural, =1{1 customer} other{{count} customers}}'**
  String financeReceivables(String amount, int count);

  /// Sync screen record type.
  ///
  /// In en, this message translates to:
  /// **'Customer'**
  String get syncTableCustomers;

  /// Sync screen record type.
  ///
  /// In en, this message translates to:
  /// **'Payment'**
  String get syncTableCustomerPayments;

  /// Sale with no payment yet; recent entries subtitle.
  ///
  /// In en, this message translates to:
  /// **'Unpaid'**
  String get customerUnpaid;

  /// Partly paid sale; recent entries subtitle.
  ///
  /// In en, this message translates to:
  /// **'{paid} paid, {remaining} left'**
  String customerPartiallyPaid(String paid, String remaining);

  /// Auto task title: hive count or apiary location changed (TR only).
  ///
  /// In en, this message translates to:
  /// **'Don\'t forget to update AKS'**
  String get taskAksUpdateTitle;

  /// Task context label for the AKS update task.
  ///
  /// In en, this message translates to:
  /// **'AKS'**
  String get taskSourceAks;

  /// Record type on the sync screen: support application period.
  ///
  /// In en, this message translates to:
  /// **'Support period'**
  String get syncTableRefSupportPeriods;

  /// Subsidies screen title and More tile (TR only).
  ///
  /// In en, this message translates to:
  /// **'Subsidies'**
  String get subsidiesTitle;

  /// Section label for the hive count check.
  ///
  /// In en, this message translates to:
  /// **'Before you apply'**
  String get subsidiesCheckTitle;

  /// Summary tile label: active hive count in the app.
  ///
  /// In en, this message translates to:
  /// **'Active hives in the app'**
  String get subsidiesActiveHives;

  /// Summary tile label: hive count declared in AKS.
  ///
  /// In en, this message translates to:
  /// **'Declared in AKS'**
  String get subsidiesDeclaredHives;

  /// Declared hive count is empty.
  ///
  /// In en, this message translates to:
  /// **'Not entered'**
  String get subsidiesNotDeclared;

  /// Check message when no declared count.
  ///
  /// In en, this message translates to:
  /// **'Enter the hive count you declared in AKS; it is compared with the app before you apply.'**
  String get subsidiesCheckNotDeclared;

  /// Warning when counts differ.
  ///
  /// In en, this message translates to:
  /// **'The app has {active} active hives but {declared} are declared in AKS. Update your AKS record before you apply.'**
  String subsidiesCheckDiffers(String active, String declared);

  /// Check message when counts match.
  ///
  /// In en, this message translates to:
  /// **'Counts match: the app and AKS agree.'**
  String get subsidiesCheckMatches;

  /// Button opening the declared count form.
  ///
  /// In en, this message translates to:
  /// **'Enter declared count'**
  String get subsidiesEditDeclared;

  /// Note for non-owners.
  ///
  /// In en, this message translates to:
  /// **'Only the owner can enter the declared count.'**
  String get subsidiesDeclaredOwnerOnly;

  /// Section label for support periods.
  ///
  /// In en, this message translates to:
  /// **'Application periods'**
  String get subsidiesPeriodsTitle;

  /// Empty state title.
  ///
  /// In en, this message translates to:
  /// **'No support periods yet'**
  String get subsidiesEmptyTitle;

  /// Empty state message.
  ///
  /// In en, this message translates to:
  /// **'Application periods appear here as they are announced; you get a notification when one opens.'**
  String get subsidiesEmptyMessage;

  /// Period status: applications open.
  ///
  /// In en, this message translates to:
  /// **'Open'**
  String get subsidiesPhaseOpen;

  /// Period status: not started.
  ///
  /// In en, this message translates to:
  /// **'Upcoming'**
  String get subsidiesPhaseUpcoming;

  /// Period status: ended.
  ///
  /// In en, this message translates to:
  /// **'Closed'**
  String get subsidiesPhaseClosed;

  /// Application period date range.
  ///
  /// In en, this message translates to:
  /// **'{start} – {end}'**
  String subsidiesPeriodDates(String start, String end);

  /// Button opening the period source link.
  ///
  /// In en, this message translates to:
  /// **'Open official notice'**
  String get subsidiesOpenSource;

  /// Snack bar when the link fails.
  ///
  /// In en, this message translates to:
  /// **'Couldn\'t open the link'**
  String get subsidiesOpenSourceFailed;

  /// Declared hive count form title.
  ///
  /// In en, this message translates to:
  /// **'AKS hive count'**
  String get aksCountTitle;

  /// Declared hive count field label.
  ///
  /// In en, this message translates to:
  /// **'Hive count declared in AKS'**
  String get aksCountLabel;

  /// Declared hive count field helper.
  ///
  /// In en, this message translates to:
  /// **'Leave empty to skip the check.'**
  String get aksCountHelper;

  /// Declared hive count validation error.
  ///
  /// In en, this message translates to:
  /// **'Enter a number between 0 and 100,000'**
  String get aksCountInvalid;

  /// Declared hive count save button.
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get aksCountSave;

  /// Snack bar after saving.
  ///
  /// In en, this message translates to:
  /// **'AKS hive count saved'**
  String get aksCountSaved;

  /// Snack bar when local organization row is missing.
  ///
  /// In en, this message translates to:
  /// **'Business details haven\'t synced to this phone yet; wait for sync.'**
  String get aksCountNoOrganization;

  /// Knowledge base screen title and More tile.
  ///
  /// In en, this message translates to:
  /// **'Knowledge base'**
  String get knowledgeTitle;

  /// Knowledge base search field hint.
  ///
  /// In en, this message translates to:
  /// **'Winter stores, varroa…'**
  String get knowledgeSearchHint;

  /// Overline of the this-month card, e.g. NOVEMBER · TÜRKİYE.
  ///
  /// In en, this message translates to:
  /// **'{month} · {place}'**
  String knowledgeMonthLabel(String month, String place);

  /// Place in the this-month card for the TR profile.
  ///
  /// In en, this message translates to:
  /// **'Türkiye'**
  String get knowledgePlaceTurkey;

  /// Place in the this-month card outside TR, northern hemisphere.
  ///
  /// In en, this message translates to:
  /// **'Northern hemisphere'**
  String get knowledgePlaceNorthern;

  /// Place in the this-month card outside TR, southern hemisphere.
  ///
  /// In en, this message translates to:
  /// **'Southern hemisphere'**
  String get knowledgePlaceSouthern;

  /// This-month card title.
  ///
  /// In en, this message translates to:
  /// **'To do this month'**
  String get knowledgeMonthTitle;

  /// Diagnosis helper card title.
  ///
  /// In en, this message translates to:
  /// **'Diagnosis helper'**
  String get knowledgeDiagnosisTitle;

  /// Diagnosis helper card subtitle.
  ///
  /// In en, this message translates to:
  /// **'Pick a sign, see possible causes'**
  String get knowledgeDiagnosisSubtitle;

  /// Atlas category title.
  ///
  /// In en, this message translates to:
  /// **'Diseases and pests atlas'**
  String get knowledgeAtlasTitle;

  /// Number of articles in a category.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{1 topic} other{{count} topics}}'**
  String knowledgeTopicCount(int count);

  /// Guides category title.
  ///
  /// In en, this message translates to:
  /// **'Technical guides'**
  String get knowledgeGuidesTitle;

  /// Guides category subtitle.
  ///
  /// In en, this message translates to:
  /// **'Splits, queen introduction, uniting, wintering'**
  String get knowledgeGuidesSubtitle;

  /// Calculators row title.
  ///
  /// In en, this message translates to:
  /// **'Calculators'**
  String get knowledgeCalculatorsTitle;

  /// Calculators row subtitle.
  ///
  /// In en, this message translates to:
  /// **'Syrup, drug dose, queen calendar, yield'**
  String get knowledgeCalculatorsSubtitle;

  /// Regulations category title (TR only).
  ///
  /// In en, this message translates to:
  /// **'Regulation summaries'**
  String get knowledgeRegulationsTitle;

  /// Regulations category subtitle.
  ///
  /// In en, this message translates to:
  /// **'Regulation, migratory beekeeping, honey communiqué'**
  String get knowledgeRegulationsSubtitle;

  /// Badge marking Türkiye-only content.
  ///
  /// In en, this message translates to:
  /// **'TR'**
  String get knowledgeTrBadge;

  /// First year category title.
  ///
  /// In en, this message translates to:
  /// **'My first year'**
  String get knowledgeFirstYearTitle;

  /// First year category subtitle.
  ///
  /// In en, this message translates to:
  /// **'Step by step for beginners'**
  String get knowledgeFirstYearSubtitle;

  /// Calendar category title (search results and category screen).
  ///
  /// In en, this message translates to:
  /// **'Seasonal calendar'**
  String get knowledgeCalendarTitle;

  /// Footer note on the knowledge base screen.
  ///
  /// In en, this message translates to:
  /// **'All content opens offline'**
  String get knowledgeOffline;

  /// Empty search results title.
  ///
  /// In en, this message translates to:
  /// **'No results'**
  String get knowledgeNoResultsTitle;

  /// Empty search results message.
  ///
  /// In en, this message translates to:
  /// **'Try another word.'**
  String get knowledgeNoResultsMessage;

  /// Empty category title.
  ///
  /// In en, this message translates to:
  /// **'No articles yet'**
  String get knowledgeCategoryEmptyTitle;

  /// Empty category message.
  ///
  /// In en, this message translates to:
  /// **'Content for this section will come with an update.'**
  String get knowledgeCategoryEmptyMessage;

  /// Shown when the article id does not exist.
  ///
  /// In en, this message translates to:
  /// **'Article not found'**
  String get knowledgeArticleNotFound;

  /// Shown when content cannot be read.
  ///
  /// In en, this message translates to:
  /// **'Couldn\'t open the knowledge base'**
  String get knowledgeLoadError;

  /// Snack bar when a link in an article cannot be opened.
  ///
  /// In en, this message translates to:
  /// **'Couldn\'t open the link'**
  String get knowledgeLinkFailed;

  /// Symptom chips label.
  ///
  /// In en, this message translates to:
  /// **'Signs you see'**
  String get diagnosisSymptoms;

  /// Helper under symptom chips.
  ///
  /// In en, this message translates to:
  /// **'You can pick more than one.'**
  String get diagnosisSymptomsHelper;

  /// Results section label.
  ///
  /// In en, this message translates to:
  /// **'Possible diseases'**
  String get diagnosisResults;

  /// Shown before any symptom is selected.
  ///
  /// In en, this message translates to:
  /// **'Pick a sign to see possible diseases here.'**
  String get diagnosisPickHint;

  /// Shown when nothing matches.
  ///
  /// In en, this message translates to:
  /// **'No disease matches the selected signs.'**
  String get diagnosisNoMatch;

  /// How many of the disease's signs were selected.
  ///
  /// In en, this message translates to:
  /// **'Matching signs: {matched}/{total}'**
  String diagnosisMatched(int matched, int total);

  /// Badge on a notifiable disease.
  ///
  /// In en, this message translates to:
  /// **'Notifiable'**
  String get diagnosisNotifiable;

  /// Note on the diagnosis screens.
  ///
  /// In en, this message translates to:
  /// **'This is a first assessment; a vet or laboratory gives the final diagnosis.'**
  String get diagnosisDisclaimer;

  /// Shown when the rules file cannot be read.
  ///
  /// In en, this message translates to:
  /// **'Couldn\'t open the diagnosis table'**
  String get diagnosisLoadError;

  /// Shown for an unknown disease id.
  ///
  /// In en, this message translates to:
  /// **'Disease not found'**
  String get diagnosisNotFound;

  /// Bold start of the notifiable warning.
  ///
  /// In en, this message translates to:
  /// **'Notifiable disease.'**
  String get diagnosisNotifiableTitle;

  /// Notifiable warning text.
  ///
  /// In en, this message translates to:
  /// **'Report the suspicion to the authority; don\'t share this hive\'s equipment, frames or honey with other hives.'**
  String get diagnosisNotifiableMessage;

  /// Advice section label.
  ///
  /// In en, this message translates to:
  /// **'What to do'**
  String get diagnosisAdvice;

  /// Authority section label.
  ///
  /// In en, this message translates to:
  /// **'Authority'**
  String get diagnosisAuthority;

  /// Button that calls the authority.
  ///
  /// In en, this message translates to:
  /// **'Call {phone}'**
  String diagnosisCall(String phone);

  /// Snack bar when the phone app cannot be opened.
  ///
  /// In en, this message translates to:
  /// **'Couldn\'t start the call'**
  String get diagnosisCallFailed;

  /// Button on a notifiable disease.
  ///
  /// In en, this message translates to:
  /// **'Quarantine a hive'**
  String get diagnosisQuarantine;

  /// Hive picker title.
  ///
  /// In en, this message translates to:
  /// **'Hive to quarantine'**
  String get quarantinePickTitle;

  /// Search field hint in the hive picker.
  ///
  /// In en, this message translates to:
  /// **'Hive number'**
  String get quarantineSearchHint;

  /// Empty hive picker title.
  ///
  /// In en, this message translates to:
  /// **'No hives'**
  String get quarantineNoHivesTitle;

  /// Empty hive picker message.
  ///
  /// In en, this message translates to:
  /// **'No active hive to quarantine.'**
  String get quarantineNoHivesMessage;

  /// Snack bar after quarantining.
  ///
  /// In en, this message translates to:
  /// **'Hive {number} quarantined'**
  String quarantineDone(String number);

  /// Quarantine status word.
  ///
  /// In en, this message translates to:
  /// **'Quarantined'**
  String get hiveQuarantined;

  /// Suspected disease on the hive card.
  ///
  /// In en, this message translates to:
  /// **'Suspected: {disease}'**
  String hiveQuarantineDisease(String disease);

  /// When the quarantine started.
  ///
  /// In en, this message translates to:
  /// **'Since {date}'**
  String hiveQuarantineSince(String date);

  /// Equipment sharing warning on the hive card.
  ///
  /// In en, this message translates to:
  /// **'Don\'t share its equipment, frames or honey with other hives.'**
  String get hiveQuarantineWarning;

  /// Button that ends the quarantine.
  ///
  /// In en, this message translates to:
  /// **'End quarantine'**
  String get hiveQuarantineEnd;

  /// Snack bar after ending the quarantine.
  ///
  /// In en, this message translates to:
  /// **'Hive {number} is out of quarantine'**
  String hiveQuarantineEnded(String number);

  /// Syrup calculator title.
  ///
  /// In en, this message translates to:
  /// **'Syrup'**
  String get calculatorSyrup;

  /// Syrup calculator subtitle.
  ///
  /// In en, this message translates to:
  /// **'Sugar and water needed'**
  String get calculatorSyrupSubtitle;

  /// Dose calculator title.
  ///
  /// In en, this message translates to:
  /// **'Treatment dose'**
  String get calculatorDose;

  /// Dose calculator subtitle.
  ///
  /// In en, this message translates to:
  /// **'Total for your hive count'**
  String get calculatorDoseSubtitle;

  /// Queen calendar calculator title.
  ///
  /// In en, this message translates to:
  /// **'Queen calendar'**
  String get calculatorQueen;

  /// Queen calendar calculator subtitle.
  ///
  /// In en, this message translates to:
  /// **'Step days from the grafting day'**
  String get calculatorQueenSubtitle;

  /// Yield calculator title.
  ///
  /// In en, this message translates to:
  /// **'Yield'**
  String get calculatorYield;

  /// Yield calculator subtitle.
  ///
  /// In en, this message translates to:
  /// **'Honey per hive'**
  String get calculatorYieldSubtitle;

  /// Note at the bottom of the calculators list.
  ///
  /// In en, this message translates to:
  /// **'Calculations work offline and save nothing.'**
  String get calculatorOffline;

  /// Shown for an unknown calculator.
  ///
  /// In en, this message translates to:
  /// **'Calculator not found'**
  String get calculatorNotFound;

  /// Hive count field.
  ///
  /// In en, this message translates to:
  /// **'Number of hives'**
  String get calculatorHives;

  /// Syrup kind chips label.
  ///
  /// In en, this message translates to:
  /// **'Syrup type'**
  String get calculatorSyrupKind;

  /// Shown while the inputs are empty or invalid.
  ///
  /// In en, this message translates to:
  /// **'Enter the hive count and amount.'**
  String get calculatorFillHint;

  /// Dose per hive field.
  ///
  /// In en, this message translates to:
  /// **'Dose per hive'**
  String get calculatorDosePerHive;

  /// Dose unit chips label.
  ///
  /// In en, this message translates to:
  /// **'Unit'**
  String get calculatorDoseUnit;

  /// Result card label.
  ///
  /// In en, this message translates to:
  /// **'Total'**
  String get calculatorTotal;

  /// Total treatment amount.
  ///
  /// In en, this message translates to:
  /// **'{unit, select, strip{{total} strips} ml{{total} ml} g{{total} g} other{{total} doses}}'**
  String calculatorDoseTotal(String unit, String total);

  /// Dose calculation line.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{1 hive × {amount}} other{{count} hives × {amount}}}'**
  String calculatorDoseCount(int count, String amount);

  /// Total honey field.
  ///
  /// In en, this message translates to:
  /// **'Total honey ({unit})'**
  String calculatorYieldTotal(String unit);

  /// Yield result card label.
  ///
  /// In en, this message translates to:
  /// **'Per hive'**
  String get calculatorYieldPerHive;

  /// Yield per hive value.
  ///
  /// In en, this message translates to:
  /// **'{amount} {unit}'**
  String calculatorYieldValue(String amount, String unit);

  /// Queen calendar steps label.
  ///
  /// In en, this message translates to:
  /// **'Steps'**
  String get calculatorQueenSteps;

  /// No description provided for @hiveLossWintering.
  ///
  /// In en, this message translates to:
  /// **'Wintering'**
  String get hiveLossWintering;

  /// No description provided for @hiveLossQueenless.
  ///
  /// In en, this message translates to:
  /// **'Queenless'**
  String get hiveLossQueenless;

  /// No description provided for @hiveLossVarroa.
  ///
  /// In en, this message translates to:
  /// **'Varroa'**
  String get hiveLossVarroa;

  /// No description provided for @hiveLossDisease.
  ///
  /// In en, this message translates to:
  /// **'Disease'**
  String get hiveLossDisease;

  /// No description provided for @hiveLossStarvation.
  ///
  /// In en, this message translates to:
  /// **'Starvation'**
  String get hiveLossStarvation;

  /// No description provided for @hiveLossRobbing.
  ///
  /// In en, this message translates to:
  /// **'Robbing'**
  String get hiveLossRobbing;

  /// No description provided for @hiveLossPredator.
  ///
  /// In en, this message translates to:
  /// **'Bear / animal'**
  String get hiveLossPredator;

  /// No description provided for @hiveLossPoisoning.
  ///
  /// In en, this message translates to:
  /// **'Poisoning'**
  String get hiveLossPoisoning;

  /// No description provided for @hiveLossOther.
  ///
  /// In en, this message translates to:
  /// **'Other'**
  String get hiveLossOther;

  /// No description provided for @hiveLossUnspecified.
  ///
  /// In en, this message translates to:
  /// **'Not specified'**
  String get hiveLossUnspecified;

  /// No description provided for @hiveLossReasonTitle.
  ///
  /// In en, this message translates to:
  /// **'Why was hive {number} lost?'**
  String hiveLossReasonTitle(String number);

  /// No description provided for @hiveLossSkip.
  ///
  /// In en, this message translates to:
  /// **'Skip without a reason'**
  String get hiveLossSkip;

  /// No description provided for @hiveFormLossReason.
  ///
  /// In en, this message translates to:
  /// **'Reason for the loss'**
  String get hiveFormLossReason;

  /// No description provided for @hiveFormLossReasonHelper.
  ///
  /// In en, this message translates to:
  /// **'Used in the season report; can be left empty.'**
  String get hiveFormLossReasonHelper;

  /// No description provided for @seasonReportTile.
  ///
  /// In en, this message translates to:
  /// **'Season report'**
  String get seasonReportTile;

  /// No description provided for @seasonTitle.
  ///
  /// In en, this message translates to:
  /// **'Season {year}'**
  String seasonTitle(String year);

  /// No description provided for @seasonPdf.
  ///
  /// In en, this message translates to:
  /// **'PDF'**
  String get seasonPdf;

  /// No description provided for @seasonExportCsv.
  ///
  /// In en, this message translates to:
  /// **'Export to Excel (CSV)'**
  String get seasonExportCsv;

  /// No description provided for @seasonExportError.
  ///
  /// In en, this message translates to:
  /// **'The file could not be created. Try again.'**
  String get seasonExportError;

  /// No description provided for @seasonLoadError.
  ///
  /// In en, this message translates to:
  /// **'The season report could not be loaded.'**
  String get seasonLoadError;

  /// No description provided for @seasonHives.
  ///
  /// In en, this message translates to:
  /// **'Hives'**
  String get seasonHives;

  /// No description provided for @seasonHiveChange.
  ///
  /// In en, this message translates to:
  /// **'{start} → {end}'**
  String seasonHiveChange(int start, int end);

  /// No description provided for @seasonNetGain.
  ///
  /// In en, this message translates to:
  /// **'+{count} net'**
  String seasonNetGain(int count);

  /// No description provided for @seasonNetLoss.
  ///
  /// In en, this message translates to:
  /// **'−{count} net'**
  String seasonNetLoss(int count);

  /// No description provided for @seasonNetSame.
  ///
  /// In en, this message translates to:
  /// **'No change'**
  String get seasonNetSame;

  /// No description provided for @seasonWinterLoss.
  ///
  /// In en, this message translates to:
  /// **'Winter loss'**
  String get seasonWinterLoss;

  /// No description provided for @seasonWinterNotStarted.
  ///
  /// In en, this message translates to:
  /// **'Winter has not started'**
  String get seasonWinterNotStarted;

  /// No description provided for @seasonPreviousWinter.
  ///
  /// In en, this message translates to:
  /// **'Winter loss {year}'**
  String seasonPreviousWinter(String year);

  /// No description provided for @seasonPreviousWinterRate.
  ///
  /// In en, this message translates to:
  /// **'{year}: {rate}'**
  String seasonPreviousWinterRate(String year, String rate);

  /// No description provided for @seasonHoney.
  ///
  /// In en, this message translates to:
  /// **'Total honey'**
  String get seasonHoney;

  /// No description provided for @seasonNewQueens.
  ///
  /// In en, this message translates to:
  /// **'New queens'**
  String get seasonNewQueens;

  /// No description provided for @seasonOwnReared.
  ///
  /// In en, this message translates to:
  /// **'own rearing {count}'**
  String seasonOwnReared(int count);

  /// No description provided for @seasonLossesTitle.
  ///
  /// In en, this message translates to:
  /// **'Losses and causes'**
  String get seasonLossesTitle;

  /// No description provided for @seasonNoLosses.
  ///
  /// In en, this message translates to:
  /// **'No hives lost this season.'**
  String get seasonNoLosses;

  /// No description provided for @seasonHiveCount.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{1 hive} other{{count} hives}}'**
  String seasonHiveCount(int count);

  /// No description provided for @seasonByTreatment.
  ///
  /// In en, this message translates to:
  /// **'Winter loss · by treatment method'**
  String get seasonByTreatment;

  /// No description provided for @seasonByApiary.
  ///
  /// In en, this message translates to:
  /// **'Winter loss · by apiary'**
  String get seasonByApiary;

  /// No description provided for @seasonByQueenLine.
  ///
  /// In en, this message translates to:
  /// **'Winter loss · by queen line'**
  String get seasonByQueenLine;

  /// No description provided for @seasonTabTreatment.
  ///
  /// In en, this message translates to:
  /// **'Treatment'**
  String get seasonTabTreatment;

  /// No description provided for @seasonTabApiary.
  ///
  /// In en, this message translates to:
  /// **'Apiary'**
  String get seasonTabApiary;

  /// No description provided for @seasonTabQueenLine.
  ///
  /// In en, this message translates to:
  /// **'Queen line'**
  String get seasonTabQueenLine;

  /// No description provided for @seasonNoWinterData.
  ///
  /// In en, this message translates to:
  /// **'No hives went into winter in your records yet.'**
  String get seasonNoWinterData;

  /// No description provided for @seasonFewData.
  ///
  /// In en, this message translates to:
  /// **'few data'**
  String get seasonFewData;

  /// No description provided for @seasonMisleadingNote.
  ///
  /// In en, this message translates to:
  /// **'From your own records; may be misleading with few hives.'**
  String get seasonMisleadingNote;

  /// No description provided for @seasonUntreated.
  ///
  /// In en, this message translates to:
  /// **'Not treated'**
  String get seasonUntreated;

  /// No description provided for @seasonMethodSeparator.
  ///
  /// In en, this message translates to:
  /// **' + '**
  String get seasonMethodSeparator;

  /// No description provided for @seasonQueenLineUnknown.
  ///
  /// In en, this message translates to:
  /// **'Unknown line'**
  String get seasonQueenLineUnknown;

  /// No description provided for @seasonFinanceTitle.
  ///
  /// In en, this message translates to:
  /// **'Cost and profit'**
  String get seasonFinanceTitle;

  /// No description provided for @seasonProfit.
  ///
  /// In en, this message translates to:
  /// **'Profit'**
  String get seasonProfit;

  /// No description provided for @seasonPdfFigure.
  ///
  /// In en, this message translates to:
  /// **'Figure'**
  String get seasonPdfFigure;

  /// No description provided for @seasonPdfValue.
  ///
  /// In en, this message translates to:
  /// **'Value'**
  String get seasonPdfValue;

  /// No description provided for @seasonPdfHiveChange.
  ///
  /// In en, this message translates to:
  /// **'{start} → {end} ({net})'**
  String seasonPdfHiveChange(int start, int end, String net);

  /// No description provided for @seasonPdfNewQueens.
  ///
  /// In en, this message translates to:
  /// **'{count} (own rearing {own})'**
  String seasonPdfNewQueens(int count, int own);

  /// No description provided for @seasonPdfWinterLoss.
  ///
  /// In en, this message translates to:
  /// **'{rate} ({lost} of {hives} hives)'**
  String seasonPdfWinterLoss(String rate, int lost, int hives);

  /// No description provided for @seasonPdfReason.
  ///
  /// In en, this message translates to:
  /// **'Cause'**
  String get seasonPdfReason;

  /// No description provided for @seasonPdfHives.
  ///
  /// In en, this message translates to:
  /// **'Hives'**
  String get seasonPdfHives;

  /// No description provided for @seasonPdfLost.
  ///
  /// In en, this message translates to:
  /// **'Lost'**
  String get seasonPdfLost;

  /// No description provided for @seasonPdfRate.
  ///
  /// In en, this message translates to:
  /// **'Loss'**
  String get seasonPdfRate;

  /// No description provided for @seasonPdfGroup.
  ///
  /// In en, this message translates to:
  /// **'Group'**
  String get seasonPdfGroup;

  /// No description provided for @seasonPdfTotal.
  ///
  /// In en, this message translates to:
  /// **'Total'**
  String get seasonPdfTotal;

  /// No description provided for @seasonCsvHive.
  ///
  /// In en, this message translates to:
  /// **'Hive'**
  String get seasonCsvHive;

  /// No description provided for @seasonCsvApiary.
  ///
  /// In en, this message translates to:
  /// **'Apiary'**
  String get seasonCsvApiary;

  /// No description provided for @seasonCsvStartStatus.
  ///
  /// In en, this message translates to:
  /// **'Status at season start'**
  String get seasonCsvStartStatus;

  /// No description provided for @seasonCsvEndStatus.
  ///
  /// In en, this message translates to:
  /// **'Status at season end'**
  String get seasonCsvEndStatus;

  /// No description provided for @seasonCsvLossDate.
  ///
  /// In en, this message translates to:
  /// **'Loss date'**
  String get seasonCsvLossDate;

  /// No description provided for @seasonCsvLossReason.
  ///
  /// In en, this message translates to:
  /// **'Loss cause'**
  String get seasonCsvLossReason;

  /// No description provided for @seasonCsvInWinter.
  ///
  /// In en, this message translates to:
  /// **'Went into winter'**
  String get seasonCsvInWinter;

  /// No description provided for @seasonCsvLostInWinter.
  ///
  /// In en, this message translates to:
  /// **'Lost in winter'**
  String get seasonCsvLostInWinter;

  /// No description provided for @seasonCsvWinterApiary.
  ///
  /// In en, this message translates to:
  /// **'Winter apiary'**
  String get seasonCsvWinterApiary;

  /// No description provided for @seasonCsvTreatment.
  ///
  /// In en, this message translates to:
  /// **'Pre-winter treatment'**
  String get seasonCsvTreatment;

  /// No description provided for @seasonCsvQueenLine.
  ///
  /// In en, this message translates to:
  /// **'Queen line'**
  String get seasonCsvQueenLine;

  /// No description provided for @seasonCsvAddedInSeason.
  ///
  /// In en, this message translates to:
  /// **'Added this season'**
  String get seasonCsvAddedInSeason;

  /// No description provided for @seasonCsvYes.
  ///
  /// In en, this message translates to:
  /// **'Yes'**
  String get seasonCsvYes;

  /// No description provided for @seasonCsvNo.
  ///
  /// In en, this message translates to:
  /// **'No'**
  String get seasonCsvNo;

  /// No description provided for @offlineMapsTitle.
  ///
  /// In en, this message translates to:
  /// **'Offline maps'**
  String get offlineMapsTitle;

  /// No description provided for @offlineMapsIntro.
  ///
  /// In en, this message translates to:
  /// **'Download the area around your apiaries; the map opens even without signal.'**
  String get offlineMapsIntro;

  /// Size of a map pack in megabytes.
  ///
  /// In en, this message translates to:
  /// **'{size} MB'**
  String offlineMapsMegabytes(String size);

  /// Approximate size before download, e.g. ≈ 72 MB.
  ///
  /// In en, this message translates to:
  /// **'≈ {size}'**
  String offlineMapsApproxSize(String size);

  /// Badge of a downloaded apiary area with its size.
  ///
  /// In en, this message translates to:
  /// **'Downloaded · {size}'**
  String offlineMapsDownloaded(String size);

  /// Progress line while downloading on Wi‑Fi only.
  ///
  /// In en, this message translates to:
  /// **'Downloading on Wi‑Fi · {received} / {total}'**
  String offlineMapsDownloadingWifi(String received, String total);

  /// Progress line while downloading.
  ///
  /// In en, this message translates to:
  /// **'Downloading · {received} / {total}'**
  String offlineMapsDownloading(String received, String total);

  /// Tooltip of the button that downloads the area around an apiary.
  ///
  /// In en, this message translates to:
  /// **'Download {name}'**
  String offlineMapsDownload(String name);

  /// No description provided for @offlineMapsCancel.
  ///
  /// In en, this message translates to:
  /// **'Stop download'**
  String get offlineMapsCancel;

  /// Tooltip of the delete button of a downloaded apiary area.
  ///
  /// In en, this message translates to:
  /// **'Delete {name}'**
  String offlineMapsDelete(String name);

  /// No description provided for @offlineMapsDeleteTitle.
  ///
  /// In en, this message translates to:
  /// **'Delete {name}?'**
  String offlineMapsDeleteTitle(String name);

  /// No description provided for @offlineMapsDeleteMessage.
  ///
  /// In en, this message translates to:
  /// **'Without internet, the map around this apiary won\'t open. You can download it again any time.'**
  String get offlineMapsDeleteMessage;

  /// No description provided for @offlineMapsDeleteConfirm.
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get offlineMapsDeleteConfirm;

  /// No description provided for @offlineMapsWifiOnly.
  ///
  /// In en, this message translates to:
  /// **'Download on Wi‑Fi only'**
  String get offlineMapsWifiOnly;

  /// No description provided for @offlineMapsWifiOnlyHint.
  ///
  /// In en, this message translates to:
  /// **'A few MB per apiary; no mobile data is used.'**
  String get offlineMapsWifiOnlyHint;

  /// Migration plan stop linked to the apiary; name is the forage source, e.g. Citrus stop.
  ///
  /// In en, this message translates to:
  /// **'{name} stop'**
  String offlineMapsStop(String name);

  /// No description provided for @offlineMapsDone.
  ///
  /// In en, this message translates to:
  /// **'Area around {name} downloaded'**
  String offlineMapsDone(String name);

  /// No description provided for @offlineMapsFailed.
  ///
  /// In en, this message translates to:
  /// **'Couldn\'t download the area around {name}. Check your connection and try again.'**
  String offlineMapsFailed(String name);

  /// No description provided for @offlineMapsNeedsWifi.
  ///
  /// In en, this message translates to:
  /// **'Connect to Wi‑Fi or turn off \"Download on Wi‑Fi only\".'**
  String get offlineMapsNeedsWifi;

  /// Map data credit under the offline maps list. Keep the names as they are.
  ///
  /// In en, this message translates to:
  /// **'Map data © OpenStreetMap contributors · OpenFreeMap'**
  String get offlineMapsAttribution;

  /// No description provided for @settingsOfflineMaps.
  ///
  /// In en, this message translates to:
  /// **'Offline maps'**
  String get settingsOfflineMaps;

  /// Settings row value: number of downloaded apiary areas and total size.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =0{None} =1{1 apiary · {size}} other{{count} apiaries · {size}}}'**
  String settingsOfflineMapsValue(int count, String size);

  /// No description provided for @offlineMapsCoverage.
  ///
  /// In en, this message translates to:
  /// **'Each apiary gets 6 km around it in detail and 40 km as an overview.'**
  String get offlineMapsCoverage;

  /// Date the area around an apiary was downloaded.
  ///
  /// In en, this message translates to:
  /// **'downloaded: {date}'**
  String offlineMapsDownloadedOn(String date);

  /// No description provided for @offlineMapsToDownload.
  ///
  /// In en, this message translates to:
  /// **'Apiaries to download'**
  String get offlineMapsToDownload;

  /// No description provided for @offlineMapsMoved.
  ///
  /// In en, this message translates to:
  /// **'Apiary moved, download again'**
  String get offlineMapsMoved;

  /// No description provided for @offlineMapsNoApiaries.
  ///
  /// In en, this message translates to:
  /// **'No apiaries with a location. Add a location to an apiary and it shows up here.'**
  String get offlineMapsNoApiaries;

  /// No description provided for @offlineMapsAllDownloaded.
  ///
  /// In en, this message translates to:
  /// **'All apiaries with a location are downloaded.'**
  String get offlineMapsAllDownloaded;

  /// No description provided for @syncReminderTitle.
  ///
  /// In en, this message translates to:
  /// **'Your records aren\'t backed up yet'**
  String get syncReminderTitle;

  /// No description provided for @syncReminderBody.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{1 record hasn\'t reached the server for 3 days. Open the app when you\'re online.} other{{count} records haven\'t reached the server for 3 days. Open the app when you\'re online.}}'**
  String syncReminderBody(int count);

  /// No description provided for @syncOverdueTitle.
  ///
  /// In en, this message translates to:
  /// **'Not backed up for 3+ days'**
  String get syncOverdueTitle;

  /// No description provided for @syncOverdueMessage.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{1 record is only on this phone. If the phone is lost, it\'s lost too. Connect to the internet and sync.} other{{count} records are only on this phone. If the phone is lost, they\'re lost too. Connect to the internet and sync.}}'**
  String syncOverdueMessage(int count);

  /// No description provided for @syncDaysAgo.
  ///
  /// In en, this message translates to:
  /// **'{days, plural, =0{today} =1{yesterday} other{{days} days ago}}'**
  String syncDaysAgo(int days);

  /// No description provided for @syncLastSyncedAgo.
  ///
  /// In en, this message translates to:
  /// **'Last synced {ago} · {when}'**
  String syncLastSyncedAgo(String ago, String when);

  /// No description provided for @syncPendingTitle.
  ///
  /// In en, this message translates to:
  /// **'Waiting to be sent · {count}'**
  String syncPendingTitle(int count);

  /// No description provided for @settingsSignOutPendingMessage.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{1 record hasn\'t been sent to the server yet and is only on this phone. If you sign out, it won\'t be sent. Connect to the internet and sync first.} other{{count} records haven\'t been sent to the server yet and are only on this phone. If you sign out, they won\'t be sent. Connect to the internet and sync first.}}'**
  String settingsSignOutPendingMessage(int count);

  /// No description provided for @settingsSignOutAnyway.
  ///
  /// In en, this message translates to:
  /// **'Sign out anyway'**
  String get settingsSignOutAnyway;

  /// No description provided for @settingsExport.
  ///
  /// In en, this message translates to:
  /// **'Export data'**
  String get settingsExport;

  /// No description provided for @settingsExportValue.
  ///
  /// In en, this message translates to:
  /// **'Excel'**
  String get settingsExportValue;

  /// No description provided for @settingsExportHint.
  ///
  /// In en, this message translates to:
  /// **'All your records in one Excel file; share or save it anywhere.'**
  String get settingsExportHint;

  /// No description provided for @exportPreparing.
  ///
  /// In en, this message translates to:
  /// **'Preparing…'**
  String get exportPreparing;

  /// No description provided for @exportFailed.
  ///
  /// In en, this message translates to:
  /// **'Couldn\'t prepare the file. Try again.'**
  String get exportFailed;

  /// No description provided for @exportFileName.
  ///
  /// In en, this message translates to:
  /// **'Mobil Arıcı {date}'**
  String exportFileName(String date);

  /// No description provided for @exportYes.
  ///
  /// In en, this message translates to:
  /// **'Yes'**
  String get exportYes;

  /// No description provided for @exportNo.
  ///
  /// In en, this message translates to:
  /// **'No'**
  String get exportNo;

  /// No description provided for @exportSheetApiaries.
  ///
  /// In en, this message translates to:
  /// **'Apiaries'**
  String get exportSheetApiaries;

  /// No description provided for @exportSheetHives.
  ///
  /// In en, this message translates to:
  /// **'Hives'**
  String get exportSheetHives;

  /// No description provided for @exportSheetQueens.
  ///
  /// In en, this message translates to:
  /// **'Queens'**
  String get exportSheetQueens;

  /// No description provided for @exportSheetInspections.
  ///
  /// In en, this message translates to:
  /// **'Inspections'**
  String get exportSheetInspections;

  /// No description provided for @exportSheetFeedings.
  ///
  /// In en, this message translates to:
  /// **'Feedings'**
  String get exportSheetFeedings;

  /// No description provided for @exportSheetTreatments.
  ///
  /// In en, this message translates to:
  /// **'Treatments'**
  String get exportSheetTreatments;

  /// No description provided for @exportSheetMiteCounts.
  ///
  /// In en, this message translates to:
  /// **'Varroa counts'**
  String get exportSheetMiteCounts;

  /// No description provided for @exportSheetHarvests.
  ///
  /// In en, this message translates to:
  /// **'Harvests'**
  String get exportSheetHarvests;

  /// No description provided for @exportSheetTasks.
  ///
  /// In en, this message translates to:
  /// **'Tasks'**
  String get exportSheetTasks;

  /// No description provided for @exportSheetInventory.
  ///
  /// In en, this message translates to:
  /// **'Stock'**
  String get exportSheetInventory;

  /// No description provided for @exportSheetFinance.
  ///
  /// In en, this message translates to:
  /// **'Income and expenses'**
  String get exportSheetFinance;

  /// No description provided for @exportColName.
  ///
  /// In en, this message translates to:
  /// **'Name'**
  String get exportColName;

  /// No description provided for @exportColLatitude.
  ///
  /// In en, this message translates to:
  /// **'Latitude'**
  String get exportColLatitude;

  /// No description provided for @exportColLongitude.
  ///
  /// In en, this message translates to:
  /// **'Longitude'**
  String get exportColLongitude;

  /// No description provided for @exportColAltitude.
  ///
  /// In en, this message translates to:
  /// **'Altitude (m)'**
  String get exportColAltitude;

  /// No description provided for @exportColLandowner.
  ///
  /// In en, this message translates to:
  /// **'Landowner'**
  String get exportColLandowner;

  /// No description provided for @exportColLandownerPhone.
  ///
  /// In en, this message translates to:
  /// **'Landowner phone'**
  String get exportColLandownerPhone;

  /// No description provided for @exportColWaterSource.
  ///
  /// In en, this message translates to:
  /// **'Water source'**
  String get exportColWaterSource;

  /// No description provided for @exportColVehicleDistance.
  ///
  /// In en, this message translates to:
  /// **'Distance from vehicle (m)'**
  String get exportColVehicleDistance;

  /// No description provided for @exportColRoadNotes.
  ///
  /// In en, this message translates to:
  /// **'Road notes'**
  String get exportColRoadNotes;

  /// No description provided for @exportColNotes.
  ///
  /// In en, this message translates to:
  /// **'Notes'**
  String get exportColNotes;

  /// No description provided for @exportColActiveHives.
  ///
  /// In en, this message translates to:
  /// **'Active hives'**
  String get exportColActiveHives;

  /// No description provided for @exportColCreated.
  ///
  /// In en, this message translates to:
  /// **'Added'**
  String get exportColCreated;

  /// No description provided for @exportColApiary.
  ///
  /// In en, this message translates to:
  /// **'Apiary'**
  String get exportColApiary;

  /// No description provided for @exportColHive.
  ///
  /// In en, this message translates to:
  /// **'Hive'**
  String get exportColHive;

  /// No description provided for @exportColType.
  ///
  /// In en, this message translates to:
  /// **'Type'**
  String get exportColType;

  /// No description provided for @exportColStatus.
  ///
  /// In en, this message translates to:
  /// **'Status'**
  String get exportColStatus;

  /// No description provided for @exportColBoxes.
  ///
  /// In en, this message translates to:
  /// **'Boxes'**
  String get exportColBoxes;

  /// No description provided for @exportColFrames.
  ///
  /// In en, this message translates to:
  /// **'Frames'**
  String get exportColFrames;

  /// No description provided for @exportColSource.
  ///
  /// In en, this message translates to:
  /// **'Source'**
  String get exportColSource;

  /// No description provided for @exportColMarking.
  ///
  /// In en, this message translates to:
  /// **'Marking'**
  String get exportColMarking;

  /// No description provided for @exportColTag.
  ///
  /// In en, this message translates to:
  /// **'Label code'**
  String get exportColTag;

  /// No description provided for @exportColQuarantine.
  ///
  /// In en, this message translates to:
  /// **'Quarantine'**
  String get exportColQuarantine;

  /// No description provided for @exportColQueen.
  ///
  /// In en, this message translates to:
  /// **'Queen'**
  String get exportColQueen;

  /// No description provided for @exportColYear.
  ///
  /// In en, this message translates to:
  /// **'Year'**
  String get exportColYear;

  /// No description provided for @exportColColor.
  ///
  /// In en, this message translates to:
  /// **'Mark color'**
  String get exportColColor;

  /// No description provided for @exportColBreed.
  ///
  /// In en, this message translates to:
  /// **'Breed'**
  String get exportColBreed;

  /// No description provided for @exportColLine.
  ///
  /// In en, this message translates to:
  /// **'Line'**
  String get exportColLine;

  /// No description provided for @exportColWingClipped.
  ///
  /// In en, this message translates to:
  /// **'Wing clipped'**
  String get exportColWingClipped;

  /// No description provided for @exportColDate.
  ///
  /// In en, this message translates to:
  /// **'Date'**
  String get exportColDate;

  /// No description provided for @exportColQueenState.
  ///
  /// In en, this message translates to:
  /// **'Queen'**
  String get exportColQueenState;

  /// No description provided for @exportColBeeFrames.
  ///
  /// In en, this message translates to:
  /// **'Frames of bees'**
  String get exportColBeeFrames;

  /// No description provided for @exportColBroodFrames.
  ///
  /// In en, this message translates to:
  /// **'Brood frames'**
  String get exportColBroodFrames;

  /// No description provided for @exportColHoneyFrames.
  ///
  /// In en, this message translates to:
  /// **'Honey frames'**
  String get exportColHoneyFrames;

  /// No description provided for @exportColTemperament.
  ///
  /// In en, this message translates to:
  /// **'Temperament'**
  String get exportColTemperament;

  /// No description provided for @exportColSwarmSigns.
  ///
  /// In en, this message translates to:
  /// **'Swarm signs'**
  String get exportColSwarmSigns;

  /// No description provided for @exportColQueenCells.
  ///
  /// In en, this message translates to:
  /// **'Queen cells'**
  String get exportColQueenCells;

  /// No description provided for @exportColDisease.
  ///
  /// In en, this message translates to:
  /// **'Disease suspected'**
  String get exportColDisease;

  /// No description provided for @exportColActions.
  ///
  /// In en, this message translates to:
  /// **'Done'**
  String get exportColActions;

  /// No description provided for @exportColAmount.
  ///
  /// In en, this message translates to:
  /// **'Amount'**
  String get exportColAmount;

  /// No description provided for @exportColUnit.
  ///
  /// In en, this message translates to:
  /// **'Unit'**
  String get exportColUnit;

  /// No description provided for @exportColProduct.
  ///
  /// In en, this message translates to:
  /// **'Product'**
  String get exportColProduct;

  /// No description provided for @exportColActiveIngredient.
  ///
  /// In en, this message translates to:
  /// **'Active ingredient'**
  String get exportColActiveIngredient;

  /// No description provided for @exportColDose.
  ///
  /// In en, this message translates to:
  /// **'Dose'**
  String get exportColDose;

  /// No description provided for @exportColWithdrawal.
  ///
  /// In en, this message translates to:
  /// **'Withdrawal (days)'**
  String get exportColWithdrawal;

  /// No description provided for @exportColBatch.
  ///
  /// In en, this message translates to:
  /// **'Batch no.'**
  String get exportColBatch;

  /// No description provided for @exportColPlannedRemoval.
  ///
  /// In en, this message translates to:
  /// **'Planned removal'**
  String get exportColPlannedRemoval;

  /// No description provided for @exportColMethod.
  ///
  /// In en, this message translates to:
  /// **'Method'**
  String get exportColMethod;

  /// No description provided for @exportColMites.
  ///
  /// In en, this message translates to:
  /// **'Mites'**
  String get exportColMites;

  /// No description provided for @exportColSampleBees.
  ///
  /// In en, this message translates to:
  /// **'Sample bees'**
  String get exportColSampleBees;

  /// No description provided for @exportColDays.
  ///
  /// In en, this message translates to:
  /// **'Days'**
  String get exportColDays;

  /// No description provided for @exportColResult.
  ///
  /// In en, this message translates to:
  /// **'Result'**
  String get exportColResult;

  /// No description provided for @exportColHoneyKind.
  ///
  /// In en, this message translates to:
  /// **'Honey'**
  String get exportColHoneyKind;

  /// No description provided for @exportColUnitCount.
  ///
  /// In en, this message translates to:
  /// **'Count'**
  String get exportColUnitCount;

  /// No description provided for @exportColNetKg.
  ///
  /// In en, this message translates to:
  /// **'Net (kg)'**
  String get exportColNetKg;

  /// No description provided for @exportColHiveCount.
  ///
  /// In en, this message translates to:
  /// **'Hives'**
  String get exportColHiveCount;

  /// No description provided for @exportColDue.
  ///
  /// In en, this message translates to:
  /// **'Due'**
  String get exportColDue;

  /// No description provided for @exportColTitle.
  ///
  /// In en, this message translates to:
  /// **'Title'**
  String get exportColTitle;

  /// No description provided for @exportColCompleted.
  ///
  /// In en, this message translates to:
  /// **'Completed'**
  String get exportColCompleted;

  /// No description provided for @exportColCategory.
  ///
  /// In en, this message translates to:
  /// **'Category'**
  String get exportColCategory;

  /// No description provided for @exportColPlace.
  ///
  /// In en, this message translates to:
  /// **'Place'**
  String get exportColPlace;

  /// No description provided for @exportColStock.
  ///
  /// In en, this message translates to:
  /// **'In stock'**
  String get exportColStock;

  /// No description provided for @exportColThreshold.
  ///
  /// In en, this message translates to:
  /// **'Alert below'**
  String get exportColThreshold;

  /// No description provided for @exportColCurrency.
  ///
  /// In en, this message translates to:
  /// **'Currency'**
  String get exportColCurrency;

  /// No description provided for @exportColDescription.
  ///
  /// In en, this message translates to:
  /// **'Description'**
  String get exportColDescription;
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
