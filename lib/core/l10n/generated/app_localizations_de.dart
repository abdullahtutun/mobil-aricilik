// ignore: unused_import
import 'package:intl/intl.dart' as intl;

import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for German (`de`).
class AppLocalizationsDe extends AppLocalizations {
  AppLocalizationsDe([String locale = 'de']) : super(locale);

  @override
  String get appTitle => 'Mobil Arıcı';

  @override
  String get listSeparator => ',';

  @override
  String get stepperIncrease => 'Erhöhen';

  @override
  String get stepperDecrease => 'Verringern';

  @override
  String hiveTileLabel(String number) {
    return 'Volk $number';
  }

  @override
  String hiveTileStrength(int strength) {
    return 'Stärke $strength von 5';
  }

  @override
  String hiveTileQueenColor(String color) {
    String _temp0 = intl.Intl.selectLogic(color, {
      'white': 'weiß',
      'yellow': 'gelb',
      'red': 'rot',
      'green': 'grün',
      'blue': 'blau',
      'other': 'unbekannt',
    });
    return 'Königinnenfarbe $_temp0';
  }

  @override
  String get tabToday => 'Heute';

  @override
  String get tabApiaries => 'Stände';

  @override
  String get tabTasks => 'Aufgaben';

  @override
  String get tabMore => 'Mehr';

  @override
  String get todayEmptyTitle => 'Lege zuerst deinen Bienenstand an';

  @override
  String get todayEmptyMessage =>
      'In drei Schritten startklar: Bienenstand anlegen, Völker erstellen, erste Durchsicht machen.';

  @override
  String get apiariesEmptyTitle => 'Noch keine Bienenstände';

  @override
  String get apiariesEmptyMessage =>
      'Ein Bienenstand fasst deine Völker nach ihrem Standort zusammen; lege den ersten an, um zu beginnen.';

  @override
  String get apiariesAdd => 'Bienenstand anlegen';

  @override
  String get apiariesAddFirst => 'Ersten Bienenstand anlegen';

  @override
  String get apiariesLoadError =>
      'Deine Bienenstände konnten nicht gelesen werden.';

  @override
  String get apiariesViewList => 'Liste';

  @override
  String get apiariesViewMap => 'Karte';

  @override
  String get apiariesMapOfflineTitle => 'Karte nicht verfügbar';

  @override
  String get apiariesMapOfflineMessage =>
      'Die Karte braucht Internet. Deine Bienenstände stehen unten in der Liste.';

  @override
  String get apiariesMapNoLocation =>
      'Noch kein Bienenstand hat einen Standort. Bearbeite einen Bienenstand, um den Standort per GPS zu übernehmen oder auf der Karte zu wählen.';

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
      other: '$count Völker brauchen Aufmerksamkeit',
      one: '1 Volk braucht Aufmerksamkeit',
    );
    return '$_temp0';
  }

  @override
  String get apiaryMapDirections => 'Route';

  @override
  String get apiaryMapShow => 'Anzeigen';

  @override
  String get apiaryMapDirectionsFailed =>
      'Keine Karten-App konnte geöffnet werden.';

  @override
  String get apiaryMapDirectionsChooseApp => 'Route planen mit';

  @override
  String apiaryHiveCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count Völker',
      one: '1 Volk',
      zero: 'Keine Völker',
    );
    return '$_temp0';
  }

  @override
  String apiaryLastVisit(String date) {
    return 'Letzter Besuch $date';
  }

  @override
  String get apiaryNoVisit => 'Noch kein Besuch';

  @override
  String get apiaryEdit => 'Bearbeiten';

  @override
  String get apiaryDelete => 'Bienenstand löschen';

  @override
  String get apiaryDeleteTitle => 'Diesen Bienenstand löschen?';

  @override
  String get apiaryDeleteMessage =>
      'Der Bienenstand wird von allen Telefonen entfernt.';

  @override
  String apiaryDeleteWithHivesMessage(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other:
          'Dieser Bienenstand hat $count Völker. Der Bienenstand und seine Völker werden von allen Telefonen entfernt.',
      one: 'Dieser Bienenstand hat 1 Volk. Der Bienenstand und sein Volk werden von allen Telefonen entfernt.',
    );
    return '$_temp0';
  }

  @override
  String get apiaryDeleted => 'Bienenstand gelöscht';

  @override
  String get apiaryNotFoundTitle => 'Bienenstand nicht gefunden';

  @override
  String get apiaryNotFoundMessage =>
      'Er wurde vielleicht gelöscht oder ist noch nicht auf diesem Gerät angekommen.';

  @override
  String get apiaryFormNewTitle => 'Neuer Bienenstand';

  @override
  String get apiaryFormEditTitle => 'Bienenstand bearbeiten';

  @override
  String get apiaryFormName => 'Name des Bienenstands';

  @override
  String get apiaryFormNameHint => 'z. B. Am Hang';

  @override
  String get apiaryFormLocation => 'Standort';

  @override
  String get apiaryFormLocationNone =>
      'Noch kein Standort. Wenn du am Bienenstand bist, übernimm ihn per GPS, ganz ohne Internet; sonst wähle ihn auf der Karte.';

  @override
  String get apiaryFormLocationTake => 'Standort per GPS übernehmen';

  @override
  String get apiaryFormLocationRetake => 'Standort neu übernehmen';

  @override
  String get apiaryFormLocationClear => 'Standort entfernen';

  @override
  String get apiaryFormLocationPickOnMap => 'Auf der Karte wählen';

  @override
  String get locationPickerTitle => 'Standort auf der Karte wählen';

  @override
  String get locationPickerSearchHint => 'Ort oder Gemeinde suchen';

  @override
  String get locationPickerSearch => 'Suchen';

  @override
  String get locationPickerHint =>
      'Verschiebe die Karte, bis die Nadel auf dem Bienenstand liegt.';

  @override
  String get locationPickerPinLabel => 'Gewählter Standort';

  @override
  String get locationPickerConfirm => 'Diesen Standort verwenden';

  @override
  String get locationPickerNoResults =>
      'Keine Orte gefunden. Versuche einen anderen Namen.';

  @override
  String get locationPickerSearchOffline =>
      'Suche nicht möglich. Die Suche braucht Internet.';

  @override
  String get locationPickerMapOfflineMessage =>
      'Die Karte braucht Internet. Wenn du am Bienenstand bist, übernimm den Standort per GPS.';

  @override
  String get apiaryFormLocating =>
      'Standort wird ermittelt … Unter freiem Himmel geht es schneller.';

  @override
  String apiaryFormLocationAccuracy(int meters) {
    return 'Genauigkeit ±$meters m';
  }

  @override
  String get apiaryFormLocationErrorServiceDisabled =>
      'Die Standortdienste sind auf diesem Gerät aus. Schalte sie ein und versuche es erneut.';

  @override
  String get apiaryFormLocationErrorPermissionDenied =>
      'Die Standortberechtigung wurde nicht erteilt. Erlaube sie, um den Standort zu übernehmen.';

  @override
  String get apiaryFormLocationErrorPermissionDeniedForever =>
      'Die Standortberechtigung ist aus. Erlaube den Standort für diese App in den Einstellungen.';

  @override
  String get apiaryFormLocationErrorTimeout =>
      'Standort nicht gefunden. Versuche es unter freiem Himmel erneut.';

  @override
  String get apiaryFormLocationErrorUnknown =>
      'Standort konnte nicht ermittelt werden. Versuche es erneut.';

  @override
  String get apiaryFormOpenSettings => 'Einstellungen öffnen';

  @override
  String get apiaryFormNotes => 'Notizen';

  @override
  String get apiaryFormSave => 'Speichern';

  @override
  String get hiveSortWeakestFirst => 'Schwächste zuerst';

  @override
  String get hivesEmptyTitle => 'Noch keine Völker';

  @override
  String get hivesEmptyMessage =>
      'Füge die Völker hinzu, die an diesem Stand stehen; du kannst viele auf einmal anlegen.';

  @override
  String get hivesAdd => 'Völker hinzufügen';

  @override
  String get hivesAddOne => 'Ein Volk';

  @override
  String get hivesAddOneHint => 'Nummer, Beutentyp und Herkunft eingeben';

  @override
  String get hivesAddBulk => 'Viele auf einmal';

  @override
  String get hivesAddBulkHint => 'z. B. 20 Völker ab 101';

  @override
  String hivesInactiveTitle(int count) {
    return 'Nicht aktiv ($count)';
  }

  @override
  String get hivesLoadError => 'Die Völker konnten nicht gelesen werden.';

  @override
  String hiveLabel(String number) {
    return 'Volk $number';
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
  String get hiveTypeLocal => 'Regional';

  @override
  String get hiveTypeOther => 'Andere';

  @override
  String get hiveStatusActive => 'Aktiv';

  @override
  String get hiveStatusDead => 'Eingegangen';

  @override
  String get hiveStatusMerged => 'Vereinigt';

  @override
  String get hiveStatusSold => 'Verkauft';

  @override
  String get hiveStatusLost => 'Verloren';

  @override
  String get hiveSourceSwarm => 'Schwarm';

  @override
  String get hiveSourceSplit => 'Ableger';

  @override
  String get hiveSourcePurchase => 'Gekauft';

  @override
  String get hiveSourcePackage => 'Paketbienen';

  @override
  String get hiveFormNewTitle => 'Neues Volk';

  @override
  String get hiveFormEditTitle => 'Volk bearbeiten';

  @override
  String get hiveFormNumber => 'Volksnummer';

  @override
  String get hiveFormNumberHint => 'z. B. 101';

  @override
  String get hiveFormType => 'Beutentyp';

  @override
  String get hiveFormStatus => 'Status';

  @override
  String get hiveFormSource => 'Herkunft';

  @override
  String get hiveFormSave => 'Speichern';

  @override
  String get hiveBulkTitle => 'Viele Völker anlegen';

  @override
  String get hiveBulkCount => 'Wie viele Völker';

  @override
  String get hiveBulkCountHint => 'z. B. 20';

  @override
  String hiveBulkCountTooMany(int max) {
    return 'Höchstens $max auf einmal';
  }

  @override
  String get hiveBulkStart => 'Erste Nummer';

  @override
  String get hiveBulkStartHint => 'z. B. 101';

  @override
  String hiveBulkPreview(int count, String first, String last) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count Völker werden angelegt: $first bis $last.',
      one: 'Volk $first wird angelegt.',
    );
    return '$_temp0';
  }

  @override
  String get hiveBulkSave => 'Völker anlegen';

  @override
  String hiveBulkCreated(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count Völker angelegt',
      one: '1 Volk angelegt',
    );
    return '$_temp0';
  }

  @override
  String get hiveNotFoundTitle => 'Volk nicht gefunden';

  @override
  String get hiveNotFoundMessage =>
      'Es wurde vielleicht gelöscht oder ist noch nicht auf diesem Gerät angekommen.';

  @override
  String get hiveEdit => 'Bearbeiten';

  @override
  String get hiveDelete => 'Volk löschen';

  @override
  String hiveDeleteTitle(String number) {
    return 'Volk $number löschen?';
  }

  @override
  String get hiveDeleteMessage =>
      'Das Volk und seine Einträge werden von allen Telefonen entfernt.';

  @override
  String hiveDeleted(String number) {
    return 'Volk $number gelöscht';
  }

  @override
  String hiveCardApiary(String name) {
    return 'Bienenstand: $name';
  }

  @override
  String get hiveQueenTitle => 'Königin';

  @override
  String hiveQueenStripTitle(String queen) {
    return 'Königin · $queen';
  }

  @override
  String hiveStrengthBadge(String level, int strength) {
    return '$level · $strength/5';
  }

  @override
  String get hiveStrengthWeak => 'Schwach';

  @override
  String get hiveStrengthMedium => 'Mittel';

  @override
  String get hiveStrengthStrong => 'Stark';

  @override
  String get hiveStrengthNone => 'Noch keine Stärkebewertung';

  @override
  String get hiveTimelineTitle => 'Verlauf';

  @override
  String get timelineInspection => 'Durchsicht';

  @override
  String get timelineAdded => 'Am Stand aufgestellt';

  @override
  String get timelineMoved => 'Umgestellt';

  @override
  String timelineMoveRoute(String from, String to) {
    return '$from → $to';
  }

  @override
  String get timelineUnknownApiary => 'Unbekannter Bienenstand';

  @override
  String timelineField(String label, String value) {
    return '$label: $value';
  }

  @override
  String timelineBeeFrames(int count) {
    return '$count mit Bienen';
  }

  @override
  String timelineBroodFrames(int count) {
    return '$count mit Brut';
  }

  @override
  String timelineHoneyFrames(int count) {
    return '$count mit Honig';
  }

  @override
  String get timelineActions => 'Erledigt';

  @override
  String get hiveMove => 'An einen anderen Stand umstellen';

  @override
  String hiveMoveTitle(String number) {
    return 'Volk $number umstellen nach';
  }

  @override
  String get hiveMoveNoOtherApiary =>
      'Es gibt keinen anderen Bienenstand zum Umstellen. Lege zuerst einen im Tab „Stände“ an.';

  @override
  String hiveMoved(String number, String apiary) {
    return 'Volk $number nach $apiary umgestellt';
  }

  @override
  String get hiveChangeStatus => 'Status ändern';

  @override
  String hiveStatusSheetTitle(String number) {
    return 'Neuer Status für Volk $number';
  }

  @override
  String hiveStatusConfirmTitle(String status, String number) {
    String _temp0 = intl.Intl.selectLogic(status, {
      'dead': 'Volk $number als eingegangen erfassen?',
      'merged': 'Volk $number als vereinigt erfassen?',
      'sold': 'Volk $number als verkauft erfassen?',
      'other': 'Volk $number als verloren erfassen?',
    });
    return '$_temp0';
  }

  @override
  String get hiveStatusConfirmMessage =>
      'Es zählt dann nicht mehr zu den aktiven Völkern des Standes. Du kannst es später wieder aktiv setzen.';

  @override
  String get hiveStatusConfirm => 'Ja, erfassen';

  @override
  String hiveStatusChanged(String number, String status) {
    return 'Volk $number: $status';
  }

  @override
  String get tasksEmptyTitle => 'Noch keine Aufgaben';

  @override
  String get tasksEmptyMessage =>
      'Deine Erinnerungen und Aufgaben erscheinen hier nach Datum.';

  @override
  String get scanTitle => 'Scannen';

  @override
  String get scanLongPressHint => 'das Schnellerfassungsmenü öffnen';

  @override
  String get scanHint => 'Bring den Code auf dem Beutenetikett in den Rahmen.';

  @override
  String get scanAgain => 'Erneut scannen';

  @override
  String get cameraErrorTitle => 'Kamera konnte nicht geöffnet werden';

  @override
  String get cameraErrorPermissionDenied =>
      'Die Kameraberechtigung wurde nicht erteilt. Um Etiketten zu scannen, erlaube die Kamera für diese App in den Einstellungen.';

  @override
  String get cameraErrorUnsupported =>
      'Dieses Gerät hat keine Kamera, die scannen kann.';

  @override
  String get cameraErrorUnknown =>
      'Schließe diesen Bildschirm und versuche es erneut.';

  @override
  String get labelUnknownTitle => 'Dieser Code ist keinem Volk zugeordnet';

  @override
  String get labelUnknownMessage =>
      'Es ist kein Mobil-Arıcı-Etikett oder es wurde noch keinem Volk zugeordnet. Wenn es an einer Beute klebt, ordne es zu; beim Scannen öffnet sich dann die Volkskarte.';

  @override
  String get labelUnknownOwnTitle =>
      'Das Volk zu diesem Etikett wurde nicht gefunden';

  @override
  String get labelUnknownOwnMessage =>
      'Das Volk wurde vielleicht gelöscht oder ist noch nicht auf diesem Telefon angekommen. Du kannst das Etikett auch einem anderen Volk zuordnen.';

  @override
  String labelCode(String code) {
    return 'Code: $code';
  }

  @override
  String get labelAssign => 'Einem Volk zuordnen';

  @override
  String get labelAssignTitle => 'Etikett einem Volk zuordnen';

  @override
  String get labelAssignMessage =>
      'Wähle das Volk, an dessen Beute das Etikett klebt. Beim Scannen öffnet sich dann seine Karte.';

  @override
  String get labelAssignSearch => 'Volksnummer';

  @override
  String get labelAssignNoMatch => 'Kein Volk passt zu deiner Suche.';

  @override
  String get labelAssignNoHives =>
      'Noch keine Völker. Füge zuerst Völker im Tab „Stände“ hinzu.';

  @override
  String get labelAssignHasOther => 'Hat ein anderes Etikett';

  @override
  String labelReplaceTitle(String number) {
    return 'Etikett von Volk $number ersetzen?';
  }

  @override
  String get labelReplaceMessage =>
      'Dieses Volk hat schon ein Etikett. Das neue ersetzt es; das alte öffnet dieses Volk nicht mehr.';

  @override
  String get labelReplaceConfirm => 'Ja, ersetzen';

  @override
  String labelAssigned(String number) {
    return 'Etikett zugeordnet: Volk $number';
  }

  @override
  String get hiveLabelsTitle => 'Etiketten drucken';

  @override
  String get hiveLabelsMessage =>
      'Wähle die Völker, für die Etiketten gedruckt werden sollen. Eine A4-Seite fasst 24 Etiketten (70 × 37 mm); drucke mit 100 % Skalierung.';

  @override
  String get hiveLabelsNoHives =>
      'An diesem Stand gibt es keine Völker für Etiketten.';

  @override
  String get hiveLabelsSelectAll => 'Alle auswählen';

  @override
  String get hiveLabelsSelectNone => 'Keine auswählen';

  @override
  String get hiveLabelsNoneSelected => 'Keine Völker ausgewählt';

  @override
  String hiveLabelsCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count Etiketten',
      one: '1 Etikett',
    );
    return '$_temp0';
  }

  @override
  String hiveLabelsPages(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count Seiten',
      one: '1 Seite',
    );
    return '$_temp0';
  }

  @override
  String hiveLabelsSummary(String labels, String pages) {
    return '$labels · $pages';
  }

  @override
  String get hiveLabelsPreparing => 'PDF wird erstellt …';

  @override
  String get hiveLabelsPrint => 'Drucken';

  @override
  String get hiveLabelsShare => 'PDF teilen';

  @override
  String hiveLabelsDocumentName(String apiary) {
    return 'Beutenetiketten - $apiary';
  }

  @override
  String get hiveLabelsError =>
      'Das PDF konnte nicht erstellt werden. Versuche es erneut.';

  @override
  String get quickRecordTitle => 'Schnellerfassung';

  @override
  String get quickRecordInspection => 'Durchsicht';

  @override
  String get quickRecordFeeding => 'Fütterung';

  @override
  String get quickRecordTreatment => 'Behandlung';

  @override
  String get quickRecordHarvest => 'Ernte';

  @override
  String get quickRecordNote => 'Notiz';

  @override
  String get quickRecordExpense => 'Ausgabe';

  @override
  String get quickRecordComingSoon => 'Diese Eintragsart kommt bald.';

  @override
  String get signInSendCode => 'Code senden';

  @override
  String get signInSending => 'Wird gesendet …';

  @override
  String signInCodeMessage(String email) {
    return 'Wir haben einen 6-stelligen Code an $email gesendet.';
  }

  @override
  String get signInCodeFieldLabel => '6-stelliger Code';

  @override
  String get signInVerify => 'Anmelden';

  @override
  String get signInVerifying => 'Wird geprüft …';

  @override
  String get signInResend => 'Code erneut senden';

  @override
  String signInResendIn(int seconds) {
    return 'Code erneut senden ($seconds s)';
  }

  @override
  String get signInCodeResent => 'Ein neuer Code ist unterwegs.';

  @override
  String get authErrorNetwork =>
      'Keine Verbindung. Prüfe dein Internet und versuche es erneut.';

  @override
  String get authErrorInvalidEmail => 'Gib eine gültige E-Mail-Adresse ein.';

  @override
  String get authErrorInvalidCode =>
      'Der Code ist falsch oder abgelaufen. Versuche es erneut oder fordere einen neuen Code an.';

  @override
  String get authErrorTooManyRequests =>
      'Zu viele Versuche. Warte kurz und versuche es erneut.';

  @override
  String get authErrorUnknown =>
      'Etwas ist schiefgelaufen. Bitte versuche es erneut.';

  @override
  String get settingsTitle => 'Einstellungen';

  @override
  String get settingsSystemDefault => 'System';

  @override
  String get settingsLanguage => 'Sprache';

  @override
  String get settingsColorMode => 'Design';

  @override
  String get settingsColorModeLight => 'Hell';

  @override
  String get settingsColorModeDark => 'Dunkel';

  @override
  String get settingsColorModeSun => 'Sonne';

  @override
  String get settingsAccount => 'Konto';

  @override
  String settingsSignedInAs(String email) {
    return 'Angemeldet als $email';
  }

  @override
  String get settingsPrivacyPolicy => 'Datenschutzerklärung';

  @override
  String settingsVersion(String version) {
    return 'Version $version';
  }

  @override
  String get settingsSignOut => 'Abmelden';

  @override
  String get settingsSignOutConfirmTitle => 'Abmelden?';

  @override
  String get settingsSignOutConfirmMessage =>
      'Um dich wieder anzumelden, brauchst du einen neuen Code per E-Mail, und dafür Internet.';

  @override
  String get actionCancel => 'Abbrechen';

  @override
  String get actionDelete => 'Löschen';

  @override
  String get actionRetry => 'Erneut versuchen';

  @override
  String get actionUndo => 'Rückgängig';

  @override
  String onboardingStepCounter(int current, int total) {
    return 'Schritt $current von $total';
  }

  @override
  String get onboardingContinue => 'Weiter';

  @override
  String get onboardingFinish => 'Betrieb einrichten';

  @override
  String get onboardingFinishing => 'Wird eingerichtet …';

  @override
  String get onboardingCountrySearch => 'Länder suchen';

  @override
  String get onboardingCountrySuggested => 'Vorschlag für dein Gerät';

  @override
  String get onboardingCountryAll => 'Alle Länder';

  @override
  String get onboardingCountryNoMatch => 'Kein Land passt zu deiner Suche.';

  @override
  String get onboardingNameMessage =>
      'Dieser Name erscheint auf deinen Einträgen und Berichten.';

  @override
  String get onboardingNameLabel => 'Name des Betriebs';

  @override
  String get onboardingNameHint => 'z. B. Imkerei Goldwabe';

  @override
  String get onboardingHiveCountTitle => 'Wie viele Völker hast du?';

  @override
  String get onboardingHiveCountMessage =>
      'Eine ungefähre Zahl genügt; wir schlagen vor, wie du sie verwaltest. Die Völker selbst fügst du später hinzu.';

  @override
  String get hiveCountRangeNone => 'Noch keine';

  @override
  String get hiveCountRangeUpTo10 => '1–10';

  @override
  String get hiveCountRangeUpTo50 => '11–50';

  @override
  String get hiveCountRangeUpTo200 => '51–200';

  @override
  String get hiveCountRangeOver200 => 'Mehr als 200';

  @override
  String get onboardingApiaryTitle => 'Lege deinen ersten Bienenstand an';

  @override
  String get onboardingApiaryMessage =>
      'Ein Bienenstand ist der Ort, an dem deine Völker stehen. Zum Speichern brauchst du kein Internet.';

  @override
  String get onboardingApiarySave => 'Bienenstand speichern';

  @override
  String get onboardingApiarySkip => 'Jetzt überspringen';

  @override
  String get onboardingLoading => 'Dein Betrieb wird geladen';

  @override
  String get onboardingLoadErrorTitle =>
      'Dein Betrieb konnte nicht geladen werden';

  @override
  String get onboardingErrorNetwork =>
      'Keine Verbindung. Prüfe dein Internet und versuche es erneut.';

  @override
  String get onboardingErrorUnknown =>
      'Etwas ist schiefgelaufen. Bitte versuche es erneut.';

  @override
  String get devMenuTitle => 'Entwicklermenü';

  @override
  String get componentGalleryTitle => 'Komponentengalerie';

  @override
  String get componentGalleryDescription =>
      'Komponenten des Designsystems in vier Designs';

  @override
  String get galleryThemeLight => 'Hell';

  @override
  String get galleryThemeDark => 'Dunkel';

  @override
  String get galleryThemeSun => 'Sonne';

  @override
  String get galleryThemeGlove => 'Handschuh';

  @override
  String get galleryBigButton => 'Großer Button';

  @override
  String get galleryChoiceChipGroup => 'Auswahlchips';

  @override
  String get galleryBigStepper => 'Großer Zähler';

  @override
  String get galleryStatusBadge => 'Statusabzeichen';

  @override
  String get galleryHiveTile => 'Volkskachel';

  @override
  String get galleryEmptyState => 'Leerzustand';

  @override
  String get gallerySectionCard => 'Abschnittskarte';

  @override
  String get galleryStrengthDots => 'Stärkepunkte';

  @override
  String get galleryTimelineTile => 'Verlaufszeile';

  @override
  String get gallerySampleApiaryHill => 'Am Hang';

  @override
  String get gallerySampleApiaryPlain => 'Am Fluss';

  @override
  String get gallerySampleStartInspection => 'Durchsicht starten';

  @override
  String get gallerySampleAddPhoto => 'Foto hinzufügen';

  @override
  String get gallerySampleSave => 'Speichern';

  @override
  String get gallerySampleQueen => 'Königin';

  @override
  String get gallerySampleQueenSeen => 'Gesehen';

  @override
  String get gallerySampleEggs => 'Stifte vorhanden';

  @override
  String get gallerySampleNone => 'Keine';

  @override
  String get gallerySampleActions => 'Maßnahmen';

  @override
  String get gallerySampleSuperAdded => 'Honigraum aufgesetzt';

  @override
  String get gallerySampleFrameAdded => 'Wabe zugegeben';

  @override
  String get gallerySampleFed => 'Gefüttert';

  @override
  String get gallerySampleBeeFrames => 'Besetzte Waben';

  @override
  String get gallerySampleBroodFrames => 'Brutwaben';

  @override
  String get gallerySampleStrong => 'Stark';

  @override
  String get gallerySampleWeak => 'Schwach';

  @override
  String get gallerySampleQueenless => 'Weisellos';

  @override
  String get gallerySampleTask => 'Aufgabe';

  @override
  String get gallerySampleNoApiaries => 'Noch keine Bienenstände';

  @override
  String get gallerySampleNoApiariesMessage =>
      'Ein Bienenstand fasst deine Völker nach ihrem Standort zusammen; lege den ersten an, um zu beginnen.';

  @override
  String get gallerySampleAddApiary => 'Ersten Bienenstand anlegen';

  @override
  String get gallerySampleLastInspection => 'Letzte Durchsicht';

  @override
  String get gallerySampleLastInspectionBody =>
      'vor 3 Tagen · 7 besetzte Waben · Königin gesehen';

  @override
  String get gallerySampleUntitledCard =>
      'Eine Karte kann auch ohne Titel sein; der Inhalt beginnt sofort.';

  @override
  String get gallerySnackBar => 'Snackbar';

  @override
  String get galleryCriticalLockCard => 'Kritische Sperrkarte';

  @override
  String get gallerySampleInspectionSaved => 'Durchsicht gespeichert';

  @override
  String get gallerySampleWithdrawalTitle => 'In der Wartezeit.';

  @override
  String get gallerySampleWithdrawalMessage =>
      'Setze diesem Volk noch 12 Tage keinen Honigraum auf.';

  @override
  String get syncStatusSynced => 'Synchron';

  @override
  String syncStatusPending(int count) {
    return '$count ausstehend';
  }

  @override
  String get syncStatusError => 'Fehler';

  @override
  String syncStatusSemantics(String status) {
    return 'Synchronisierung: $status';
  }

  @override
  String get syncTitle => 'Synchronisierung';

  @override
  String get syncSyncedMessage =>
      'Alle Einträge auf diesem Telefon sind auf dem Server angekommen.';

  @override
  String syncPendingMessage(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count Einträge warten auf das Senden.',
      one: '1 Eintrag wartet auf das Senden.',
    );
    return '$_temp0';
  }

  @override
  String get syncProblemOffline =>
      'Server nicht erreichbar. Die Synchronisierung versucht es erneut, sobald du wieder online bist.';

  @override
  String get syncProblemFailed =>
      'Die Synchronisierung konnte nicht abgeschlossen werden. Versuche es etwas später erneut.';

  @override
  String get syncProblemUpgrade =>
      'Diese Version kann nicht mehr synchronisieren. Aktualisiere die App.';

  @override
  String syncLastSynced(String time) {
    return 'Zuletzt synchronisiert $time';
  }

  @override
  String get syncNow => 'Jetzt synchronisieren';

  @override
  String get syncRunning => 'Wird synchronisiert …';

  @override
  String syncRejectedTitle(int count) {
    return 'Konnte nicht gesendet werden ($count)';
  }

  @override
  String get syncRejectedMessage =>
      'Der Server hat diese Einträge nicht angenommen. Alles andere wird weiter synchronisiert.';

  @override
  String syncRejectedSubtitle(String reason, String date) {
    return '$reason · $date';
  }

  @override
  String get syncRejectionForbidden => 'Du darfst diesen Eintrag nicht ändern';

  @override
  String get syncRejectionConflict =>
      'Kollidiert mit einem anderen Eintrag (z. B. dasselbe Etikett)';

  @override
  String get syncRejectionMissingReference =>
      'Ein zugehöriger Eintrag fehlt auf dem Server';

  @override
  String get syncRejectionUnsupported =>
      'Diese Eintragsart wird nicht synchronisiert';

  @override
  String get syncRejectionInvalid => 'Der Eintrag enthält ungültige Daten';

  @override
  String get syncRejectionUnknown => 'Unbekannter Grund';

  @override
  String get syncTableOrganizations => 'Betrieb';

  @override
  String get syncTableMemberships => 'Mitgliedschaft';

  @override
  String get syncTableApiaries => 'Bienenstand';

  @override
  String get syncTableQueens => 'Königin';

  @override
  String get syncTableHives => 'Volk';

  @override
  String get syncTableHiveStatusEvents => 'Statusänderung eines Volkes';

  @override
  String get syncTableHiveLocationHistory => 'Umstellung eines Volkes';

  @override
  String get initialSyncTitle => 'Deine Einträge werden geladen';

  @override
  String get initialSyncMessage =>
      'Die Einträge deines Betriebs werden auf dieses Telefon geladen. Das passiert nur einmal; danach funktioniert die App auch ohne Internet.';

  @override
  String initialSyncRows(int count) {
    final intl.NumberFormat countNumberFormat =
        intl.NumberFormat.decimalPattern(localeName);
    final String countString = countNumberFormat.format(count);

    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$countString Einträge geladen',
      one: '1 Eintrag geladen',
    );
    return '$_temp0';
  }

  @override
  String get initialSyncFailedTitle =>
      'Laden konnte nicht abgeschlossen werden';

  @override
  String get suggestedValue => 'Aus dem letzten Eintrag';

  @override
  String get stepperNoValue => 'Nicht festgelegt';

  @override
  String get hiveStartInspection => 'Durchsicht starten';

  @override
  String inspectionTitle(String number) {
    return 'Volk $number durchsehen';
  }

  @override
  String inspectionPrevious(String date) {
    return 'Letzte Durchsicht $date';
  }

  @override
  String get inspectionFirst => 'Erste Durchsicht';

  @override
  String get inspectionSuggestedLegend =>
      'Blasse Werte stammen aus der letzten Durchsicht. Ändere, was anders ist; der Rest wird so gespeichert.';

  @override
  String get inspectionDraftSaved =>
      'Als Entwurf auf diesem Telefon gespeichert';

  @override
  String get inspectionRestart => 'Neu beginnen';

  @override
  String get inspectionQueen => 'Königin';

  @override
  String get queenStateSeen => 'Gesehen';

  @override
  String get queenStateEggs => 'Stifte gesehen';

  @override
  String get queenStateNone => 'Keine';

  @override
  String get inspectionFrames => 'Waben';

  @override
  String get inspectionBeeFrames => 'Mit Bienen';

  @override
  String get inspectionBroodFrames => 'Mit Brut';

  @override
  String get inspectionHoneyFrames => 'Mit Honig';

  @override
  String get inspectionTemperament => 'Sanftmut';

  @override
  String get temperamentCalm => 'Sanft';

  @override
  String get temperamentNervous => 'Nervös';

  @override
  String get inspectionSwarmSigns => 'Schwarmanzeichen';

  @override
  String get inspectionQueenCells => 'Weiselzellen';

  @override
  String get queenCellsNone => 'Keine';

  @override
  String get queenCellsSwarm => 'Schwarmzellen';

  @override
  String get queenCellsSupersedure => 'Umweiselung';

  @override
  String get queenCellsEmergency => 'Nachschaffung';

  @override
  String get inspectionDisease => 'Krankheitsverdacht';

  @override
  String get inspectionAnswerNo => 'Nein';

  @override
  String get inspectionAnswerYes => 'Ja';

  @override
  String get inspectionActions => 'Heute erledigt';

  @override
  String get inspectionActionSuperAdded => 'Honigraum aufgesetzt';

  @override
  String get inspectionActionSuperRemoved => 'Honigraum abgenommen';

  @override
  String get inspectionActionFramesAdded => 'Waben zugegeben';

  @override
  String get inspectionActionFoundationAdded => 'Mittelwände gegeben';

  @override
  String get inspectionActionFed => 'Gefüttert';

  @override
  String get inspectionActionExcluderFitted => 'Absperrgitter eingelegt';

  @override
  String get inspectionActionEntranceReduced => 'Flugloch verengt';

  @override
  String get inspectionActionPollenTrapFitted => 'Pollenfalle angebracht';

  @override
  String get inspectionSave => 'Speichern';

  @override
  String inspectionSaved(String number) {
    return 'Durchsicht von Volk $number gespeichert';
  }

  @override
  String get inspectionRemindPrompt => 'Erinnern in';

  @override
  String inspectionRemindDays(int days) {
    String _temp0 = intl.Intl.pluralLogic(
      days,
      locale: localeName,
      other: '$days Tagen',
      one: '1 Tag',
    );
    return '$_temp0';
  }

  @override
  String get inspectionLoadError =>
      'Die Durchsicht konnte nicht geöffnet werden';

  @override
  String get syncTableInspections => 'Durchsicht';

  @override
  String get signInTagline =>
      'Dein Stockbuch in der Tasche. Funktioniert ohne Internet.';

  @override
  String get signInEmailLabelLong => 'Deine E-Mail-Adresse';

  @override
  String get signInEmailHelper =>
      'Kein Passwort. Wir senden einen 6-stelligen Code an deine Adresse.';

  @override
  String get signInEmailHint => 'name@beispiel.de';

  @override
  String get signInCodeHeading => 'Gib den Code aus deiner E-Mail ein';

  @override
  String get signInPasteCode => 'Code einfügen';

  @override
  String get signInCodeSpamHint =>
      'Nicht angekommen? Sieh im Spam-Ordner nach. Nach der ersten Anmeldung öffnet sich die App auch ohne Internet.';

  @override
  String get signInChangeEmail => 'E-Mail ändern';

  @override
  String get onboardingLanguageCountryTitle => 'Sprache und Land';

  @override
  String get onboardingAppLanguage => 'App-Sprache';

  @override
  String get onboardingDeviceLanguage => 'Gerätesprache';

  @override
  String get onboardingCountryLabel => 'Land, in dem du imkerst';

  @override
  String get onboardingCountryChoose => 'Land wählen';

  @override
  String onboardingRegionFeaturesTitle(String country) {
    return 'Eingeschaltet für $country';
  }

  @override
  String onboardingRegionDefaultsTitle(String country) {
    return 'Einstellungen für $country';
  }

  @override
  String get onboardingRegionDefaultsMessage =>
      'Einheiten und Währung richten sich nach deinem Land.';

  @override
  String get onboardingBusinessTitle => 'Erzähl uns von deinem Betrieb';

  @override
  String get regionFeatureAks => 'AKS- und Betriebsregisterdaten';

  @override
  String get regionFeatureSubsidies => 'Erinnerungen an Völkerförderung';

  @override
  String get regionFeatureRegulations => 'Zusammenfassungen der Vorschriften';

  @override
  String get regionFeatureTrDrugList => 'Liste zugelassener Tierarzneimittel';

  @override
  String get regionFeatureTrFlora => 'Trachtkalender Türkei';

  @override
  String get regionFeatureTrMigrationDocs => 'Unterlagen für Wanderimkerei';

  @override
  String get unitKilogram => 'kg';

  @override
  String get unitPound => 'lb';

  @override
  String get unitCelsius => '°C';

  @override
  String get unitFahrenheit => '°F';

  @override
  String get hemisphereNorthern => 'Nordhalbkugel';

  @override
  String get hemisphereSouthern => 'Südhalbkugel';

  @override
  String get relativeToday => 'heute';

  @override
  String get relativeYesterday => 'gestern';

  @override
  String relativeDaysAgo(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'vor $count Tagen',
      one: 'vor 1 Tag',
    );
    return '$_temp0';
  }

  @override
  String apiariesCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count Bienenstände',
      one: '1 Bienenstand',
    );
    return '$_temp0';
  }

  @override
  String apiariesSummary(String apiaries, String hives) {
    return '$apiaries · $hives';
  }

  @override
  String get apiaryHiveCountUnit => 'Völker';

  @override
  String get hiveLayoutGridShort => 'Raster';

  @override
  String get hiveLayoutListShort => 'Liste';

  @override
  String apiaryDetailSubtitle(String hives, String visit) {
    return '$hives · $visit';
  }

  @override
  String apiaryDetailSubtitlePlace(String hives, String visit, String place) {
    return '$hives · $visit · $place';
  }

  @override
  String get apiaryBulkFeed => 'Alle füttern';

  @override
  String get apiaryBulkTreat => 'Alle behandeln';

  @override
  String get hiveCardKind => 'Volk';

  @override
  String get hiveLastInspection => 'Letzte Durchsicht';

  @override
  String get hiveLastInspectionNone => 'Noch keine';

  @override
  String get hiveBulkPreviewTitle => 'Vorschau';

  @override
  String hiveBulkSaveCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count Völker anlegen',
      one: '1 Volk anlegen',
    );
    return '$_temp0';
  }

  @override
  String get listEllipsis => '…';

  @override
  String get scanOfflineHint => 'Kein Internet nötig · vibriert beim Erkennen';

  @override
  String get titleSeparator => ' ·';

  @override
  String get settingsGeneral => 'Allgemein';

  @override
  String get settingsGloveMode => 'Handschuhmodus';

  @override
  String get settingsGloveModeHint =>
      'Alle Tippflächen werden eine Stufe größer.';

  @override
  String get settingsCountry => 'Land';

  @override
  String settingsCountryValue(String name, String code) {
    return '$name · $code';
  }

  @override
  String get moreSectionApiary => 'Bienenstand';

  @override
  String get moreSectionBusiness => 'Betrieb';

  @override
  String get moreSectionHelp => 'Hilfe';

  @override
  String get galleryFormFields => 'Formularfelder';

  @override
  String get galleryRadioCardGroup => 'Auswahlkarten';

  @override
  String get gallerySegmentedTabs => 'Ansichtsumschalter';

  @override
  String get galleryListGroup => 'Gruppierte Liste';

  @override
  String get galleryNoteCard => 'Hinweiskarte';

  @override
  String get gallerySummaryTile => 'Übersichtskachel';

  @override
  String get galleryActionTile => 'Aktionskacheln';

  @override
  String get galleryAppLogo => 'Logo und Wabe';

  @override
  String get gallerySampleApiaryName => 'Name des Bienenstands';

  @override
  String get gallerySampleFirstNumber => 'Erste Nummer';

  @override
  String get gallerySampleNoteHint =>
      'Kein Passwort. Wir senden einen 6-stelligen Code an deine Adresse.';

  @override
  String get gallerySampleGrid => 'Raster';

  @override
  String get gallerySampleList => 'Liste';

  @override
  String get gallerySampleMap => 'Karte';

  @override
  String get gallerySampleInspections => 'Durchsichten';

  @override
  String get gallerySampleNoteTitle => 'Eingeschaltet für die Türkei';

  @override
  String get gallerySampleNoteMessage =>
      'AKS- und Betriebsregisterdaten, Zusammenfassungen der Vorschriften und die Liste zugelassener Tierarzneimittel.';

  @override
  String get gallerySampleLastInspectionValue => 'vor 3 Tagen';

  @override
  String get gallerySampleFrames => '8 besetzte Waben · 5 Brut';

  @override
  String get gallerySampleActiveTreatment => 'Laufende Behandlung';

  @override
  String get gallerySampleDaysLeft => 'noch 12 Tage';

  @override
  String get syncTableMedia => 'Foto oder Sprachnotiz';

  @override
  String get mediaTakePhoto => 'Foto aufnehmen';

  @override
  String get mediaRecordVoice => 'Sprachnotiz aufnehmen';

  @override
  String get mediaStopRecording => 'Aufnahme beenden';

  @override
  String mediaRecording(String duration) {
    return 'Aufnahme · $duration';
  }

  @override
  String mediaPhotoAdded(String number) {
    return 'Foto zu Volk $number hinzugefügt';
  }

  @override
  String mediaVoiceAdded(String number) {
    return 'Sprachnotiz zu Volk $number hinzugefügt';
  }

  @override
  String get mediaCameraDenied =>
      'Keine Kameraberechtigung. Du kannst sie in den Telefoneinstellungen erlauben.';

  @override
  String get mediaMicrophoneDenied =>
      'Keine Mikrofonberechtigung. Du kannst sie in den Telefoneinstellungen erlauben.';

  @override
  String get mediaCaptureFailed =>
      'Speichern nicht möglich. Versuche es erneut.';

  @override
  String mediaPhotoCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count Fotos',
      one: '1 Foto',
    );
    return '$_temp0';
  }

  @override
  String mediaVoiceCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count Sprachnotizen',
      one: '1 Sprachnotiz',
    );
    return '$_temp0';
  }

  @override
  String inspectionMediaAttached(String items) {
    return 'Mit der Durchsicht gespeichert: $items';
  }

  @override
  String get timelinePhoto => 'Foto';

  @override
  String get timelineVoiceNote => 'Sprachnotiz';

  @override
  String get mediaOpenPhoto => 'Foto öffnen';

  @override
  String get mediaDownloadPhoto =>
      'Foto nicht auf diesem Telefon. Zum Herunterladen tippen.';

  @override
  String mediaPlay(String duration) {
    return 'Abspielen · $duration';
  }

  @override
  String get mediaStopPlaying => 'Stopp';

  @override
  String get mediaNotUploaded =>
      'Noch nicht hochgeladen. Es kommt an, sobald das aufnehmende Telefon online ist.';

  @override
  String get mediaDownloadOffline =>
      'Herunterladen nicht möglich. Prüfe deine Internetverbindung.';

  @override
  String get mediaDownloadFailed => 'Herunterladen nicht möglich.';

  @override
  String get mediaNotFound => 'Foto nicht gefunden';

  @override
  String get settingsData => 'Daten';

  @override
  String get settingsMediaWifiOnly => 'Fotos nur über WLAN hochladen';

  @override
  String get settingsMediaWifiOnlyHint =>
      'Fotos und Sprachnotizen verbrauchen keine mobilen Daten.';

  @override
  String settingsPendingUploads(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count Dateien warten auf das Hochladen',
      one: '1 Datei wartet auf das Hochladen',
    );
    return '$_temp0';
  }

  @override
  String get hiveQueenNone => 'Nicht erfasst';

  @override
  String get hiveQueenNoneHint => 'Tippen, um eine Königin hinzuzufügen';

  @override
  String queenMarkColorName(String color) {
    String _temp0 = intl.Intl.selectLogic(color, {
      'white': 'Weiß',
      'yellow': 'Gelb',
      'red': 'Rot',
      'green': 'Grün',
      'blue': 'Blau',
      'other': 'Unbekannt',
    });
    return '$_temp0';
  }

  @override
  String get queenYearUnknown => 'Jahr unbekannt';

  @override
  String get queenUnmarked => 'Nicht gezeichnet';

  @override
  String queenAge(int age) {
    String _temp0 = intl.Intl.pluralLogic(
      age,
      locale: localeName,
      other: '$age Jahre alt',
      one: '1 Jahr alt',
      zero: 'Unter einem Jahr alt',
    );
    return '$_temp0';
  }

  @override
  String get queenSourceOwnRearing => 'Eigene Zucht';

  @override
  String get queenSourcePurchased => 'Gekauft';

  @override
  String get queenSourceCertifiedBreeder => 'Anerkannter Züchter';

  @override
  String get queenSource => 'Herkunft';

  @override
  String get queenMother => 'Mutterkönigin';

  @override
  String get queenMotherUnknown => 'Unbekannt';

  @override
  String get queenBreed => 'Rasse';

  @override
  String get queenBreedHint => 'z. B. Carnica';

  @override
  String get queenBreedLine => 'Linie';

  @override
  String get queenBreedLineHint => 'z. B. Troiseck';

  @override
  String get queenWing => 'Flügel';

  @override
  String get queenWingClipped => 'Beschnitten';

  @override
  String get queenWingIntact => 'Nicht beschnitten';

  @override
  String get queenYear => 'Jahr';

  @override
  String get queenYearHelper => 'Schlupf- oder Kaufjahr';

  @override
  String get queenMark => 'Zeichenfarbe';

  @override
  String queenMarkSuggestion(String year, String color) {
    return 'Farbe $year: $color';
  }

  @override
  String get queenUnknown => 'Nicht eingetragen';

  @override
  String get queenEdit => 'Königin bearbeiten';

  @override
  String get queenReplace => 'Königin ersetzen';

  @override
  String get queenGive => 'Königin hinzufügen';

  @override
  String get queenNoneTitle => 'Keine Königin erfasst';

  @override
  String get queenNoneMessage =>
      'Erfasse die Königin, die du diesem Volk gegeben hast; Jahr, Farbe und Abstammung erscheinen hier.';

  @override
  String queenFormNewTitle(String number) {
    return 'Neue Königin · Volk $number';
  }

  @override
  String get queenFormEditTitle => 'Königin bearbeiten';

  @override
  String get queenFormSave => 'Speichern';

  @override
  String queenGiven(String number) {
    return 'Volk $number hat eine neue Königin';
  }

  @override
  String get oldQueensTitle => 'Alte Königinnen';

  @override
  String oldQueensIntro(int age) {
    String _temp0 = intl.Intl.pluralLogic(
      age,
      locale: localeName,
      other:
          'Königinnen in aktiven Völkern, die $age Jahre oder älter sind. Plane ihren Austausch.',
    );
    return '$_temp0';
  }

  @override
  String get oldQueensEmptyTitle => 'Keine alten Königinnen';

  @override
  String oldQueensEmptyMessage(int age) {
    String _temp0 = intl.Intl.pluralLogic(
      age,
      locale: localeName,
      other:
          'Die Königinnen in aktiven Völkern sind jünger als $age Jahre oder haben kein Jahr eingetragen.',
    );
    return '$_temp0';
  }

  @override
  String get syncTableMiteCounts => 'Varroa-Zählung';

  @override
  String get varroaMethodSugarRoll => 'Puderzuckermethode';

  @override
  String get varroaMethodAlcoholWash => 'Alkoholauswaschung';

  @override
  String get varroaMethodStickyBoard => 'Gemülldiagnose';

  @override
  String varroaFormTitle(String number) {
    return 'Varroa · Volk $number';
  }

  @override
  String get varroaMethod => 'Methode';

  @override
  String get varroaSampleBees => 'Bienen in der Probe';

  @override
  String get varroaBoardDays => 'Tage mit Windel';

  @override
  String get varroaMites => 'Gezählte Milben';

  @override
  String get varroaBoardMites => 'Gefallene Milben';

  @override
  String get varroaSave => 'Speichern';

  @override
  String varroaSaved(String number) {
    return 'Varroa-Zählung für Volk $number gespeichert';
  }

  @override
  String varroaPercent(double value) {
    final intl.NumberFormat valueNumberFormat =
        intl.NumberFormat.decimalPatternDigits(
          locale: localeName,
          decimalDigits: 1,
        );
    final String valueString = valueNumberFormat.format(value);

    return '$valueString %';
  }

  @override
  String varroaPerDay(double value) {
    final intl.NumberFormat valueNumberFormat =
        intl.NumberFormat.decimalPatternDigits(
          locale: localeName,
          decimalDigits: 1,
        );
    final String valueString = valueNumberFormat.format(value);

    return '$valueString Milben/Tag';
  }

  @override
  String get varroaInfestation => 'Befall';

  @override
  String get varroaDailyDrop => 'Täglicher Fall';

  @override
  String get varroaReached => 'Schwelle erreicht · Behandlung planen';

  @override
  String get varroaBelow => 'Unter der Schwelle';

  @override
  String varroaThresholdNote(String threshold) {
    return 'Schwelle $threshold (aus den Einstellungen).';
  }

  @override
  String get hiveVarroa => 'Varroa';

  @override
  String get hiveVarroaNone => 'Noch keine Zählung';

  @override
  String get hiveVarroaReached => 'Schwelle erreicht';

  @override
  String get hiveVarroaCount => 'Varroa zählen';

  @override
  String varroaChartTitle(String apiary) {
    return '$apiary · letzte Zählungen';
  }

  @override
  String varroaChartThreshold(String threshold) {
    return 'Schwelle $threshold';
  }

  @override
  String get varroaChartEmpty =>
      'Noch keine Zählungen mit Puderzucker oder Alkohol. Füge eine über eine Volkskarte hinzu.';

  @override
  String varroaChartBar(String day, String value) {
    return '$day: $value';
  }

  @override
  String varroaChartSemantics(String threshold, String bars) {
    return 'Durchschnittlicher Befall pro Tag, Schwelle $threshold: $bars';
  }

  @override
  String get settingsVarroa => 'Varroa';

  @override
  String get settingsVarroaPercent => 'Befallsschwelle';

  @override
  String get settingsVarroaPerDay => 'Schwelle Gemülldiagnose';

  @override
  String get settingsVarroaHint =>
      'Eine Warnung erscheint, wenn eine Zählung die Schwelle erreicht. Nur auf diesem Telefon gespeichert.';

  @override
  String get syncTableRefDrugs => 'Arzneimittelliste';

  @override
  String get syncTableDrugs => 'Arzneimittel';

  @override
  String get syncTableTreatments => 'Behandlung';

  @override
  String get syncTableFeedings => 'Fütterung';

  @override
  String get drugIngredientAmitraz => 'Amitraz';

  @override
  String get drugIngredientOxalicAcid => 'Oxalsäure';

  @override
  String get drugIngredientFormicAcid => 'Ameisensäure';

  @override
  String get drugIngredientThymol => 'Thymol';

  @override
  String get drugIngredientFlumethrin => 'Flumethrin';

  @override
  String get drugIngredientTauFluvalinate => 'Tau-Fluvalinat';

  @override
  String get drugIngredientCoumaphos => 'Coumaphos';

  @override
  String get drugIngredientLacticAcid => 'Milchsäure';

  @override
  String get drugIngredientOther => 'Andere';

  @override
  String get drugUnitStrip => 'Streifen';

  @override
  String get drugUnitMl => 'ml';

  @override
  String get drugUnitG => 'g';

  @override
  String get drugUnitDose => 'Dosis';

  @override
  String get hiveTreat => 'Behandeln';

  @override
  String get treatmentFormTitle => 'Behandlung';

  @override
  String treatmentScopeHive(String number) {
    return 'Volk $number';
  }

  @override
  String treatmentScopeApiary(int count) {
    return 'Ganzer Stand · $count';
  }

  @override
  String get treatmentChooseDrug => 'Arzneimittel wählen';

  @override
  String get treatmentChangeDrug => 'Ändern';

  @override
  String treatmentDrugIngredient(String ingredient) {
    return 'Wirkstoff: $ingredient';
  }

  @override
  String treatmentDrugLicense(String number) {
    return 'Zulassung $number';
  }

  @override
  String get treatmentDrugCustom => 'dein Mittel';

  @override
  String get treatmentAddDrug => 'Neues Arzneimittel hinzufügen';

  @override
  String get drugInfoOpen => 'Arzneimittelinformation';

  @override
  String get drugInfoSourceTitle =>
      'Quelle: Ministerium für Landwirtschaft und Forsten der Türkei';

  @override
  String get drugInfoSourceMessage =>
      'Diese Angaben stammen aus der vom Ministerium genehmigten Produktinformation und werden wie veröffentlicht auf Türkisch gezeigt. Lies vor der Anwendung das Etikett; frag im Zweifel einen Tierarzt.';

  @override
  String get drugInfoActiveIngredient => 'Wirkstoff';

  @override
  String get drugInfoIndications => 'Anwendungsgebiet';

  @override
  String get drugInfoUsage => 'Anwendung und Häufigkeit';

  @override
  String get drugInfoUsageMethod => 'Art der Anwendung';

  @override
  String get drugInfoUsageMethodAndDose => 'Anwendung und Dosis';

  @override
  String get drugInfoUsageDiagnosis => 'Zur Diagnose';

  @override
  String get drugInfoUsageDose => 'Dosis';

  @override
  String get drugInfoUsageFrequency => 'Häufigkeit';

  @override
  String get drugInfoUsageDuration => 'Dauer';

  @override
  String get drugInfoUsageOther => 'Hinweis';

  @override
  String get drugInfoSuitablePeriods => 'Geeignete Zeiträume';

  @override
  String get drugInfoAvoidPeriods => 'Nicht anwenden';

  @override
  String get drugInfoWithdrawal => 'Wartezeit';

  @override
  String get drugInfoWarnings => 'Warnhinweise';

  @override
  String get drugInfoClose => 'Schließen';

  @override
  String get treatmentBatchNo => 'Chargennr.';

  @override
  String get treatmentStartedOn => 'Beginn';

  @override
  String treatmentDose(String unit) {
    return 'Dosis pro Volk ($unit)';
  }

  @override
  String treatmentDoseTotal(String total, String unit) {
    return 'Gesamt $total $unit';
  }

  @override
  String get treatmentWithdrawalDays => 'Wartezeit (Tage)';

  @override
  String get treatmentRemoval => 'Entnahme';

  @override
  String get treatmentRemovalNone => 'Keine';

  @override
  String get treatmentRemovalChange =>
      'Erinnerung an diesem Morgen; zum Ändern tippen';

  @override
  String get treatmentRemovalSingle =>
      'Einmalige Anwendung; zum Festlegen tippen';

  @override
  String get treatmentRemovalClear => 'Keine Entnahme (einmalige Anwendung)';

  @override
  String get treatmentNoSuper => 'Kein Honigraum';

  @override
  String treatmentNoSuperUntil(String date) {
    return 'Bis $date';
  }

  @override
  String treatmentNoSuperAfterRemoval(int days) {
    String _temp0 = intl.Intl.pluralLogic(
      days,
      locale: localeName,
      other: 'Entnahme + $days Tage Wartezeit',
      one: 'Entnahme + 1 Tag Wartezeit',
      zero: 'keine Wartezeit nach Entnahme',
    );
    return '$_temp0';
  }

  @override
  String treatmentNoSuperAfterStart(int days) {
    String _temp0 = intl.Intl.pluralLogic(
      days,
      locale: localeName,
      other: 'Beginn + $days Tage Wartezeit',
      one: 'Beginn + 1 Tag Wartezeit',
      zero: 'keine Wartezeit',
    );
    return '$_temp0';
  }

  @override
  String treatmentSave(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Für $count Völker speichern',
      one: 'Speichern',
    );
    return '$_temp0';
  }

  @override
  String treatmentSaved(String number) {
    return 'Behandlung für Volk $number gespeichert';
  }

  @override
  String treatmentSavedMany(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Behandlung für $count Völker gespeichert',
      one: 'Behandlung für 1 Volk gespeichert',
    );
    return '$_temp0';
  }

  @override
  String get drugFormTitle => 'Neues Arzneimittel';

  @override
  String get drugName => 'Name';

  @override
  String get drugActiveIngredient => 'Wirkstoff';

  @override
  String get drugDoseUnit => 'Dosiereinheit';

  @override
  String get drugWithdrawalDays => 'Wartezeit laut Etikett (Tage)';

  @override
  String get drugSave => 'Arzneimittel hinzufügen';

  @override
  String get withdrawalLockTitle => 'In der Wartezeit.';

  @override
  String withdrawalLockMessage(String number, String product, String date) {
    return 'Volk $number wird mit $product behandelt. Vor dem $date darf kein Honigraum aufgesetzt werden; Honig aus dieser Zeit kann Rückstände enthalten.';
  }

  @override
  String get withdrawalDaysLeft => 'Verbleibend';

  @override
  String withdrawalDays(int days) {
    String _temp0 = intl.Intl.pluralLogic(
      days,
      locale: localeName,
      other: '$days Tage',
      one: '1 Tag',
    );
    return '$_temp0';
  }

  @override
  String get withdrawalApplied => 'Angewendet';

  @override
  String get withdrawalReasonPrompt =>
      'Um trotzdem zu speichern, wähle einen Grund';

  @override
  String get withdrawalReasonRemovedEarly => 'Mittel früher entnommen';

  @override
  String get withdrawalReasonNotForSale =>
      'Honigraum wird nicht verkauft (Eigenbedarf/Futter)';

  @override
  String get withdrawalCancel => 'Abbrechen, keinen Honigraum aufsetzen';

  @override
  String get withdrawalProceed => 'Trotzdem speichern';

  @override
  String inspectionWithdrawalOverride(String reason) {
    return 'Honigraum in der Wartezeit aufgesetzt: $reason';
  }

  @override
  String timelineTreatment(String product) {
    return 'Behandlung · $product';
  }

  @override
  String timelineTreatmentBatch(String batch) {
    return 'Charge $batch';
  }

  @override
  String treatmentDoseValue(String dose, String unit) {
    return '$dose $unit';
  }

  @override
  String timelineTreatmentRemoval(String date) {
    return 'Entnahme $date';
  }

  @override
  String timelineTreatmentWithdrawal(int days) {
    String _temp0 = intl.Intl.pluralLogic(
      days,
      locale: localeName,
      other: '$days Tage Wartezeit',
      one: '1 Tag Wartezeit',
    );
    return '$_temp0';
  }

  @override
  String get hiveActiveTreatment => 'Laufende Behandlung';

  @override
  String get hiveActiveTreatmentNone => 'Keine';

  @override
  String hiveActiveTreatmentLeft(int days) {
    String _temp0 = intl.Intl.pluralLogic(
      days,
      locale: localeName,
      other: 'noch $days Tage',
      one: 'noch 1 Tag',
    );
    return '$_temp0';
  }

  @override
  String hiveActiveTreatmentDetail(String ingredient) {
    return '$ingredient · kein Honigraum';
  }

  @override
  String get treatmentRotationTitle => 'Gleicher Wirkstoff.';

  @override
  String treatmentRotationMessage(int count, String ingredient) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other:
          'Auch die letzten $count Behandlungen an diesem Stand waren $ingredient. Erwäge einen anderen Wirkstoff, um Resistenzen zu vermeiden.',
    );
    return '$_temp0';
  }

  @override
  String get treatmentPrescriptionAdd =>
      'Foto von Rezept / Rechnung hinzufügen';

  @override
  String get treatmentPrescriptionAdded => 'Rezeptfoto hinzugefügt';

  @override
  String get treatmentPrescriptionRemove => 'Entfernen';

  @override
  String get reminderChannelName => 'Erinnerungen';

  @override
  String get treatmentReminderDenied =>
      'Benachrichtigungen sind aus; es wurde keine Entnahme-Erinnerung gesetzt.';

  @override
  String get hiveFeed => 'Füttern';

  @override
  String get feedingFormTitle => 'Fütterung';

  @override
  String feedingScopeHive(String number) {
    return 'Volk $number';
  }

  @override
  String feedingScopeApiary(int count) {
    return 'Ganzer Stand · $count';
  }

  @override
  String get feedingKind => 'Art';

  @override
  String get feedingKindSyrup1to1 => 'Sirup 1:1 · Reizfütterung';

  @override
  String get feedingKindSyrup2to1 => 'Sirup 2:1 · Winterfutter';

  @override
  String get feedingKindBeeCake => 'Futterteig';

  @override
  String get feedingKindPollenSubstitute => 'Pollenersatz';

  @override
  String feedingAmount(String unit) {
    return 'Pro Volk ($unit)';
  }

  @override
  String get feedingSuperHiveTitle => 'Dieses Volk hat einen Honigraum.';

  @override
  String get feedingSuperHiveMessage => 'Sirup kann in den Honig gelangen.';

  @override
  String feedingSuperSkippedTitle(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count Völker haben einen Honigraum',
      one: '1 Volk hat einen Honigraum',
    );
    return '$_temp0';
  }

  @override
  String feedingSuperSkippedMessage(String numbers) {
    return '($numbers). Ausgelassen, damit kein Sirup in den Honig gelangt.';
  }

  @override
  String get feedingPrepare => 'Vorzubereiten';

  @override
  String feedingPrepareCount(int count, String amount, String unit) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count Völker × $amount $unit',
      one: '1 Volk × $amount $unit',
    );
    return '$_temp0';
  }

  @override
  String feedingTotalSyrup(String amount, String unit) {
    return '$amount $unit Sirup';
  }

  @override
  String feedingTotalBeeCake(String amount, String unit) {
    return '$amount $unit Futterteig';
  }

  @override
  String feedingTotalPollenSubstitute(String amount, String unit) {
    return '$amount $unit Pollenersatz';
  }

  @override
  String get feedingSugar => 'Zucker';

  @override
  String get feedingWater => 'Wasser';

  @override
  String feedingApprox(String amount, String unit) {
    return '≈ $amount $unit';
  }

  @override
  String feedingSave(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Für $count Völker speichern',
      one: 'Speichern',
      zero: 'Kein Volk zu füttern',
    );
    return '$_temp0';
  }

  @override
  String feedingSaved(String number) {
    return 'Fütterung für Volk $number gespeichert';
  }

  @override
  String feedingSavedMany(int count) {
    return 'Fütterung für $count Völker gespeichert';
  }

  @override
  String get unitLiter => 'L';

  @override
  String get unitGallon => 'gal';

  @override
  String get syncTableTasks => 'Aufgabe';

  @override
  String get tasksTabToday => 'Heute';

  @override
  String get tasksTabWeek => 'Diese Woche';

  @override
  String get tasksTabApiary => 'Nach Stand';

  @override
  String get tasksAdd => 'Aufgabe hinzufügen';

  @override
  String tasksOverdue(int count) {
    return 'Überfällig · $count';
  }

  @override
  String tasksDayGroup(String day, int count) {
    return '$day · $count';
  }

  @override
  String get tasksToday => 'Heute';

  @override
  String get tasksTomorrow => 'Morgen';

  @override
  String get tasksNoApiary => 'Kein Bienenstand';

  @override
  String tasksApiaryGroup(String apiary, int count) {
    return '$apiary · $count';
  }

  @override
  String get tasksEmptyTodayTitle => 'Heute nichts zu tun';

  @override
  String get tasksEmptyWeekTitle => 'Keine Aufgaben diese Woche';

  @override
  String get tasksEmptyAddHint =>
      'Füge oben rechts mit + eine neue Aufgabe hinzu.';

  @override
  String get tasksLoadError => 'Aufgaben konnten nicht geladen werden.';

  @override
  String tasksWeekDaySemantics(String day, int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count Aufgaben',
      one: '1 Aufgabe',
      zero: 'keine Aufgaben',
    );
    return '$day, $_temp0';
  }

  @override
  String taskOverdueDays(int days) {
    String _temp0 = intl.Intl.pluralLogic(
      days,
      locale: localeName,
      other: '$days Tage überfällig',
      one: '1 Tag überfällig',
    );
    return '$_temp0';
  }

  @override
  String get taskSourceInspection => 'aus Durchsicht';

  @override
  String get taskSourceTreatment => 'Behandlung';

  @override
  String taskInspectionTitle(String number) {
    return 'Volk $number · erneut prüfen';
  }

  @override
  String get taskInspectionTitleNoHive => 'Erneut prüfen';

  @override
  String taskTreatmentTitle(String number) {
    return 'Volk $number · Streifen entnehmen';
  }

  @override
  String get taskTreatmentTitleApiary => 'Streifen entnehmen';

  @override
  String get taskReminderBody => 'Deine Aufgabe ist fällig.';

  @override
  String get taskAssigneeMe => 'Ich';

  @override
  String taskAssignedTo(String name) {
    return 'Zugewiesen an $name';
  }

  @override
  String taskMemberNumbered(String role, int index) {
    return '$role $index';
  }

  @override
  String get roleOwner => 'Inhaber';

  @override
  String get rolePartner => 'Partner';

  @override
  String get roleWorker => 'Mitarbeiter';

  @override
  String get roleViewer => 'Betrachter';

  @override
  String taskCompleteAction(String title) {
    return 'Erledigen: $title';
  }

  @override
  String get taskCompleted => 'Aufgabe erledigt';

  @override
  String get taskFormNewTitle => 'Neue Aufgabe';

  @override
  String get taskFormEditTitle => 'Aufgabe bearbeiten';

  @override
  String get taskFormName => 'Aufgabe';

  @override
  String get taskFormNameHint => 'z. B. Stand am Berg besuchen';

  @override
  String get taskFormDue => 'Fällig';

  @override
  String get taskFormPickDate => 'Anderer Tag';

  @override
  String get taskFormTime => 'Uhrzeit';

  @override
  String get taskFormApiary => 'Bienenstand';

  @override
  String get taskFormHive => 'Volk';

  @override
  String get taskFormNone => 'Keine';

  @override
  String get taskFormChooseApiary => 'Bienenstand wählen';

  @override
  String get taskFormChooseHive => 'Volk wählen';

  @override
  String get taskFormAssignee => 'Zugewiesen an';

  @override
  String get taskFormUnassigned => 'Nicht zugewiesen';

  @override
  String get taskFormCompleted => 'Erledigt';

  @override
  String get taskFormSave => 'Speichern';

  @override
  String get taskFormDelete => 'Aufgabe löschen';

  @override
  String get taskDeleteTitle => 'Diese Aufgabe löschen?';

  @override
  String get taskDeleteMessage =>
      'Die Aufgabe wird von allen Telefonen entfernt.';

  @override
  String get taskDeleteConfirm => 'Löschen';

  @override
  String get taskSaved => 'Aufgabe gespeichert';

  @override
  String get taskDeleted => 'Aufgabe gelöscht';

  @override
  String get taskNotFound =>
      'Aufgabe nicht gefunden; sie wurde vielleicht gelöscht.';

  @override
  String get taskReminderDenied =>
      'Benachrichtigungen sind aus; die Erinnerung klingelt nicht.';

  @override
  String get exactAlarmTitle => 'Erinnerungen pünktlich klingeln lassen?';

  @override
  String get exactAlarmMessage =>
      'Android verzögert Benachrichtigungen manchmal um einige Minuten, um Akku zu sparen. Erlaube Mobil Arıcı in der folgenden Einstellung, dann klingeln Aufgabenerinnerungen pünktlich. Kein Internet nötig.';

  @override
  String get exactAlarmConfirm => 'Einstellung öffnen';

  @override
  String get settingsReminders => 'Erinnerungen';

  @override
  String get settingsExactAlarms => 'Pünktlich klingeln';

  @override
  String get settingsExactAlarmsOn => 'An';

  @override
  String get settingsExactAlarmsOff =>
      'Aus · kann einige Minuten später kommen';

  @override
  String weatherTemperature(String value) {
    return '$value°';
  }

  @override
  String weatherForecastAsOf(String time) {
    return 'Vorhersage von $time';
  }

  @override
  String get weatherNoLocationTitle => 'Kein Standort';

  @override
  String get weatherNoLocationAction => 'Standort für das Wetter hinzufügen';

  @override
  String get weatherPendingHint => 'Kommt, sobald du online bist';

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
    return '$value %';
  }

  @override
  String weatherTemperatureRange(String max, String min) {
    return '$max / $min';
  }

  @override
  String get hiveOpeningRain => 'Regen';

  @override
  String get hiveOpeningWind => 'Windig';

  @override
  String get hiveOpeningCold => 'Kalt';

  @override
  String get hiveOpeningDaySuitable => 'Öffnen';

  @override
  String get weatherConditionSunny => 'Sonnig';

  @override
  String get weatherConditionPartlyCloudy => 'Teils bewölkt';

  @override
  String get weatherConditionCloudy => 'Bewölkt';

  @override
  String get weatherConditionRainy => 'Regnerisch';

  @override
  String get weatherConditionWindy => 'Windig';

  @override
  String get weatherConditionOther => 'Schnee, Nebel oder Sturm';

  @override
  String get weatherConditionFog => 'Neblig';

  @override
  String get weatherConditionThunder => 'Gewitter';

  @override
  String get weatherConditionSleet => 'Schneeregen';

  @override
  String get weatherConditionSnow => 'Schnee';

  @override
  String weatherFeelsLike(String condition, String value) {
    return '$condition · gefühlt $value';
  }

  @override
  String get weatherWindLabel => 'Wind';

  @override
  String get weatherHumidityLabel => 'Luftfeuchte';

  @override
  String get weatherPrecipitationLabel => 'Regen';

  @override
  String get weatherScreenTitle => 'Wetter am Stand';

  @override
  String weatherScreenSubtitle(String place, String days) {
    return '$place · $days-Tage-Vorhersage';
  }

  @override
  String weatherScreenSubtitleNoPlace(String days) {
    return '$days-Tage-Vorhersage';
  }

  @override
  String weatherUpdatedAt(String time) {
    return 'Aktualisiert $time';
  }

  @override
  String get weatherNow => 'Jetzt';

  @override
  String get weatherToday => 'Heute';

  @override
  String get weatherColumnDay => 'Tag';

  @override
  String get weatherColumnTemperature => 'Temp.';

  @override
  String get weatherColumnPrecipitation => 'Regen';

  @override
  String get weatherColumnHive => 'Völker';

  @override
  String get weatherTodaySuitable => 'Guter Tag zum Öffnen der Völker';

  @override
  String get weatherTodayRain => 'Heute Regen; kein Tag zum Öffnen der Völker';

  @override
  String get weatherTodayWind => 'Heute windig; kein Tag zum Öffnen der Völker';

  @override
  String get weatherTodayCold => 'Heute kalt; kein Tag zum Öffnen der Völker';

  @override
  String weatherDayRange(String from, String to) {
    return '$from–$to';
  }

  @override
  String weatherPlanRain(String days) {
    return 'Regen am $days.';
  }

  @override
  String weatherPlanWind(String days) {
    return 'Windig am $days.';
  }

  @override
  String weatherPlanMove(String weekday) {
    String _temp0 = intl.Intl.selectLogic(weekday, {
      'monday': 'Durchsichten auf Montag verschieben.',
      'tuesday': 'Durchsichten auf Dienstag verschieben.',
      'wednesday': 'Durchsichten auf Mittwoch verschieben.',
      'thursday': 'Durchsichten auf Donnerstag verschieben.',
      'friday': 'Durchsichten auf Freitag verschieben.',
      'saturday': 'Durchsichten auf Samstag verschieben.',
      'other': 'Durchsichten auf Sonntag verschieben.',
    });
    return '$_temp0';
  }

  @override
  String get weatherPlanAction => 'Planen';

  @override
  String weatherPlanTaskTitle(String apiary) {
    return '$apiary durchsehen';
  }

  @override
  String weatherThresholdsHint(
    String temperature,
    String wind,
    String precipitation,
  ) {
    return 'Gut zum Öffnen: über $temperature, Wind unter $wind, Regenwahrscheinlichkeit unter $precipitation. Die Schwellen kannst du in den Einstellungen ändern.';
  }

  @override
  String get weatherEmptyTitle => 'Noch keine Vorhersage';

  @override
  String get weatherEmptyMessage =>
      'Die Vorhersage für diesen Stand wurde noch nicht geladen. Aktualisiere, sobald du online bist.';

  @override
  String get weatherNoLocationMessage =>
      'Dieser Stand hat keinen Standort. Füge einen hinzu, um eine Vorhersage zu erhalten.';

  @override
  String get weatherRefresh => 'Aktualisieren';

  @override
  String get weatherRefreshFailed =>
      'Vorhersage konnte nicht geladen werden. Prüfe deine Internetverbindung.';

  @override
  String get weatherApiaryNotFound => 'Bienenstand nicht gefunden';

  @override
  String get weatherAttributionPrefix => 'Powered by';

  @override
  String get weatherAttributionLink => 'WeatherAPI.com';

  @override
  String get settingsHiveOpening => 'Schwellen zum Öffnen';

  @override
  String get settingsHiveOpeningTemperature => 'Temperatur';

  @override
  String settingsHiveOpeningTemperatureValue(String value) {
    return 'über $value';
  }

  @override
  String get settingsHiveOpeningWind => 'Wind';

  @override
  String get settingsHiveOpeningPrecipitation => 'Regenwahrscheinlichkeit';

  @override
  String settingsHiveOpeningBelow(String value) {
    return 'unter $value';
  }

  @override
  String get settingsHiveOpeningHint =>
      'Wetterbildschirm und Heute-Karten zeigen „Öffnen“ nach diesen Schwellen. Nur auf diesem Telefon gespeichert.';

  @override
  String get hiveOpeningSuitable => 'Gut zum Öffnen';

  @override
  String get todayGreetingMorning => 'Guten Morgen';

  @override
  String get todayGreetingAfternoon => 'Guten Tag';

  @override
  String get todayGreetingEvening => 'Guten Abend';

  @override
  String get todayAttentionTitle => 'Braucht Aufmerksamkeit';

  @override
  String todayAttentionHiveCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count Völker',
      one: '1 Volk',
    );
    return '$_temp0';
  }

  @override
  String get todayAttentionNone => 'Kein Volk braucht Aufmerksamkeit';

  @override
  String get todayTasksTitle => 'Heute';

  @override
  String todayTasksCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count Aufgaben',
      one: '1 Aufgabe',
    );
    return '$_temp0';
  }

  @override
  String todayTasksApiaryCount(String apiary, int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count Aufgaben',
      one: '1 Aufgabe',
    );
    return '$apiary · $_temp0';
  }

  @override
  String todaySetupProgress(int done, int total) {
    return 'Einrichtung $done/$total';
  }

  @override
  String get setupStepApiary => 'Bienenstand anlegen';

  @override
  String get setupStepHives => 'Völker erstellen';

  @override
  String get setupStepInspection => 'Erste Durchsicht machen';

  @override
  String setupStepDone(String step) {
    return '$step: erledigt';
  }

  @override
  String get attentionQueenless => 'Weisellos';

  @override
  String get attentionWeak => 'Schwach';

  @override
  String get attentionSwarming => 'Schwarmanzeichen';

  @override
  String get attentionTreatmentRemoval => 'Behandlung entnehmen';

  @override
  String get attentionQueenlessTitle => 'Weisellose Völker';

  @override
  String get attentionWeakTitle => 'Schwache Völker';

  @override
  String get attentionSwarmingTitle => 'Völker mit Schwarmanzeichen';

  @override
  String get attentionTreatmentRemovalTitle => 'Zu entnehmende Behandlungen';

  @override
  String get attentionQueenlessIntro =>
      'Aktive Völker, bei deren letzter Durchsicht weder Königin noch Stifte gefunden wurden.';

  @override
  String attentionWeakIntro(int max) {
    return 'Aktive Völker mit Stärke $max/5 oder weniger bei der letzten Durchsicht.';
  }

  @override
  String get attentionSwarmingIntro =>
      'Aktive Völker, deren letzte Durchsicht Schwarmanzeichen oder Schwarmzellen zeigte.';

  @override
  String get attentionTreatmentRemovalIntro =>
      'Völker, bei denen die Streifenentnahme fällig ist und die Aufgabe noch offen ist.';

  @override
  String get attentionEmpty => 'Keine Völker in dieser Gruppe.';

  @override
  String attentionLastInspection(String date) {
    return 'Letzte Durchsicht: $date';
  }

  @override
  String attentionRemovalDue(String date) {
    return 'Entnahme fällig: $date';
  }

  @override
  String get syncTableHarvests => 'Ernte';

  @override
  String get syncTableHarvestHives => 'Geerntetes Volk';

  @override
  String withdrawalLockHarvestMessage(
    String number,
    String product,
    String date,
  ) {
    return 'Volk $number wird mit $product behandelt. Vor dem $date sollte nicht geerntet werden; Honig aus dieser Zeit kann Rückstände enthalten.';
  }

  @override
  String get withdrawalReasonNotForSaleHarvest =>
      'Honig wird nicht verkauft (Eigenbedarf/Futter)';

  @override
  String get withdrawalHarvestCancel => 'Abbrechen, nicht ernten';

  @override
  String get withdrawalHarvestProceed => 'Trotzdem ernten';

  @override
  String get apiaryHarvest => 'Ernte';

  @override
  String harvestFormTitle(String apiary) {
    return 'Ernte · $apiary';
  }

  @override
  String harvestSelectedCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count Völker ausgewählt',
      one: '1 Volk ausgewählt',
      zero: 'Keine Völker ausgewählt',
    );
    return '$_temp0';
  }

  @override
  String harvestSelectedHint(String numbers) {
    return '$numbers · tippen zum Ändern oder scannen zum Hinzufügen';
  }

  @override
  String get harvestSelectedEmptyHint =>
      'Tippen, um Völker zu wählen, oder scannen';

  @override
  String get harvestScan => 'Scannen';

  @override
  String harvestLockedTitle(String numbers) {
    return '$numbers in der Wartezeit.';
  }

  @override
  String get harvestLockedMessage =>
      'Nicht geerntet. Um trotzdem zu ernten, wähle das Volk in der Liste.';

  @override
  String get harvestDate => 'Datum';

  @override
  String get harvestToday => 'Heute';

  @override
  String get harvestYesterday => 'Gestern';

  @override
  String get harvestPickDate => 'Anderer Tag';

  @override
  String get harvestHoneyKind => 'Honigsorte';

  @override
  String get honeyKindPine => 'Pinienhonig';

  @override
  String get honeyKindFlower => 'Blütenhonig';

  @override
  String get honeyKindChestnut => 'Kastanienhonig';

  @override
  String get honeyKindCitrus => 'Zitrushonig';

  @override
  String get honeyKindOther => 'Sonstiger Honig';

  @override
  String get harvestUnit => 'Entnommen als';

  @override
  String get harvestUnitSuper => 'Zargen';

  @override
  String get harvestUnitFrame => 'Waben';

  @override
  String get harvestTakenSupers => 'Entnommene Zargen';

  @override
  String get harvestTakenFrames => 'Entnommene Waben';

  @override
  String harvestWeight(String unit) {
    return 'Geschleuderter Honig ($unit)';
  }

  @override
  String get harvestWeightInvalid => 'Gib ein Gewicht wie 574 oder 574,5 ein';

  @override
  String harvestWeightTooLarge(String max, String unit) {
    return 'Höchstens $max $unit';
  }

  @override
  String get harvestPerHive => 'Pro Volk';

  @override
  String harvestWeightValue(String value, String unit) {
    return '$value $unit';
  }

  @override
  String harvestSave(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Ernte speichern',
      zero: 'Keine Völker zu ernten',
    );
    return '$_temp0';
  }

  @override
  String harvestSaved(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Ernte für $count Völker gespeichert',
      one: 'Ernte für 1 Volk gespeichert',
    );
    return '$_temp0';
  }

  @override
  String get harvestHivesTitle => 'Zu erntende Völker';

  @override
  String get harvestSelectAll => 'Alle auswählen';

  @override
  String get harvestSelectNone => 'Keine auswählen';

  @override
  String harvestHiveLocked(int days) {
    String _temp0 = intl.Intl.pluralLogic(
      days,
      locale: localeName,
      other: '$days Tage',
      one: '1 Tag',
    );
    return 'Wartezeit · noch $_temp0';
  }

  @override
  String harvestHiveOverridden(String reason) {
    return 'Trotzdem entnommen: $reason';
  }

  @override
  String get harvestHivesDone => 'Fertig';

  @override
  String get harvestNoActiveHives =>
      'An diesem Stand gibt es keine aktiven Völker.';

  @override
  String get harvestScanTitle => 'Für die Ernte scannen';

  @override
  String harvestScanAdded(String number) {
    return 'Volk $number hinzugefügt';
  }

  @override
  String harvestScanAlready(String number) {
    return 'Volk $number ist bereits ausgewählt';
  }

  @override
  String harvestScanOtherApiary(String number) {
    return 'Volk $number steht nicht an diesem Stand';
  }

  @override
  String harvestScanInactive(String number) {
    return 'Volk $number ist nicht aktiv';
  }

  @override
  String get harvestScanUnknown => 'Dieses Etikett ist keinem Volk zugeordnet';

  @override
  String harvestScanDone(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Fertig · $count Völker',
      one: 'Fertig · 1 Volk',
      zero: 'Fertig',
    );
    return '$_temp0';
  }

  @override
  String get apiaryTourStart => 'Rundgang starten';

  @override
  String get apiaryTourResume => 'Rundgang fortsetzen';

  @override
  String get tourReplaceTitle => 'Laufenden Rundgang beenden?';

  @override
  String tourReplaceMessage(String apiary) {
    return 'Der Rundgang $apiary läuft noch. Ein neuer Rundgang löscht seinen Fortschritt; die Durchsichten bleiben gespeichert.';
  }

  @override
  String get tourReplaceConfirm => 'Neuen Rundgang starten';

  @override
  String tourTitle(String apiary) {
    return 'Rundgang $apiary';
  }

  @override
  String get tourFinish => 'Rundgang beenden';

  @override
  String tourProgress(int done, int total) {
    return '$done / $total';
  }

  @override
  String tourProgressLabel(int done, int total) {
    return '$done von $total Völkern erledigt';
  }

  @override
  String tourMinutes(int minutes) {
    return '$minutes Min.';
  }

  @override
  String tourHoursMinutes(int hours, int minutes) {
    return '$hours Std. $minutes Min.';
  }

  @override
  String tourElapsedLabel(String duration) {
    return 'Vergangene Zeit: $duration';
  }

  @override
  String get tourNext => 'Als Nächstes';

  @override
  String tourPreviousVisit(String date) {
    return 'Letztes Mal · $date';
  }

  @override
  String get tourQueue => 'Reihenfolge';

  @override
  String tourSkippedCount(int count) {
    return '$count übersprungen';
  }

  @override
  String get tourStateDone => 'Erledigt';

  @override
  String get tourStateSkipped => 'Übersprungen';

  @override
  String get tourStatePending => 'Wartet';

  @override
  String get tourStateNext => 'Nächstes';

  @override
  String tourHiveSemantics(String number, String state) {
    return 'Volk $number, $state';
  }

  @override
  String get tourSkip => 'Überspringen';

  @override
  String tourInspect(String number) {
    return '$number durchsehen';
  }

  @override
  String get tourAllDone => 'Alle Völker wurden durchgesehen.';

  @override
  String get tourSunSuggestion =>
      'Der Sonnenmodus macht den Bildschirm bei hellem Licht besser lesbar.';

  @override
  String get tourSunOn => 'Sonnenmodus einschalten';

  @override
  String get tourSunMode => 'Sonnenmodus';

  @override
  String get tourFinishTitle => 'Rundgang beenden?';

  @override
  String tourFinishMessage(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other:
          '$count Völker wurden nicht durchgesehen; die Zusammenfassung zählt sie als übersprungen.',
      one: '1 Volk wurde nicht durchgesehen; die Zusammenfassung zählt es als übersprungen.',
    );
    return '$_temp0';
  }

  @override
  String get tourNotFound => 'An diesem Stand läuft kein Rundgang.';

  @override
  String get tourCompleteTitle => 'Rundgang abgeschlossen';

  @override
  String tourInspectedCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count Völker durchgesehen',
      one: '1 Volk durchgesehen',
    );
    return '$_temp0';
  }

  @override
  String get tourHealthy => 'Stark / ordentlich';

  @override
  String get tourTasksTitle => 'Aufgaben';

  @override
  String tourTaskRequeen(String numbers) {
    return 'Umweiseln: $numbers';
  }

  @override
  String tourTaskFeedWeak(String numbers) {
    return 'Mit Sirup 1:1 füttern: $numbers';
  }

  @override
  String tourTaskSwarmCheck(String numbers) {
    return 'Schwarmkontrolle: $numbers';
  }

  @override
  String tourTaskRevisit(String numbers) {
    return 'Übersprungene Völker prüfen: $numbers';
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
      other: 'in $days Tagen',
      one: 'morgen',
      zero: 'heute',
    );
    return '$_temp0';
  }

  @override
  String tourSaveTasks(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Aufgaben speichern',
      one: 'Aufgabe speichern',
      zero: 'Schließen',
    );
    return '$_temp0';
  }

  @override
  String tourTasksSaved(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count Aufgaben gespeichert',
      one: '1 Aufgabe gespeichert',
    );
    return '$_temp0';
  }

  @override
  String get tourNoTasks => 'Keine Aufgaben vorzuschlagen.';

  @override
  String get reportsTitle => 'Berichte';

  @override
  String get reportTreatmentRegister => 'Behandlungsnachweis';

  @override
  String get reportTreatmentRegisterHint => 'Für Kontrollen';

  @override
  String get reportHiveHistory => 'Volksverlauf';

  @override
  String get reportHiveHistoryHint => 'Ein Volk oder ein Stand';

  @override
  String get reportFrom => 'Von';

  @override
  String get reportTo => 'Bis';

  @override
  String get reportApiary => 'Bienenstand';

  @override
  String get reportAllApiaries => 'Alle Bienenstände';

  @override
  String get reportHive => 'Volk';

  @override
  String get reportAllHives => 'Alle Völker';

  @override
  String get reportLanguage => 'PDF-Sprache';

  @override
  String get reportRegistrationNo => 'Registriernr. des Betriebs';

  @override
  String get reportAksNo => 'AKS-Nr.';

  @override
  String get reportRecordNo => 'Registriernummer';

  @override
  String get reportNumbersHelper =>
      'Wird nur im PDF-Kopf gedruckt, nicht gespeichert.';

  @override
  String get reportShare => 'Teilen';

  @override
  String get reportCreate => 'PDF erstellen';

  @override
  String get reportPreparing => 'PDF wird erstellt …';

  @override
  String get reportError =>
      'Das PDF konnte nicht erstellt werden. Versuche es erneut.';

  @override
  String get reportLoadError => 'Die Einträge konnten nicht gelesen werden.';

  @override
  String get reportEmpty => 'Keine Einträge in diesem Zeitraum.';

  @override
  String reportTreatmentCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count Behandlungen',
      one: '1 Behandlung',
    );
    return '$_temp0';
  }

  @override
  String reportHiveCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count Völker',
      one: '1 Volk',
    );
    return '$_temp0';
  }

  @override
  String reportRecordCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count Einträge',
      one: '1 Eintrag',
    );
    return '$_temp0';
  }

  @override
  String get reportNoValue => '—';

  @override
  String get pdfTreatmentRegisterTitle => 'Behandlungsnachweis';

  @override
  String get pdfHiveHistoryTitle => 'Volksverlauf';

  @override
  String pdfRegistrationNo(String number) {
    return 'Registriernr. des Betriebs $number';
  }

  @override
  String pdfAksNo(String number) {
    return 'AKS-Nr. $number';
  }

  @override
  String pdfRecordNo(String number) {
    return 'Registriernr. $number';
  }

  @override
  String pdfPeriod(String from, String to) {
    return 'Zeitraum: $from – $to';
  }

  @override
  String pdfApiary(String name) {
    return 'Bienenstand: $name';
  }

  @override
  String pdfCreated(String date) {
    return 'Erstellt am $date';
  }

  @override
  String pdfPage(int page, int pages) {
    return 'Seite $page von $pages';
  }

  @override
  String get pdfColumnDate => 'Datum';

  @override
  String get pdfColumnApiary => 'Bienenstand';

  @override
  String get pdfColumnProduct => 'Mittel / Charge';

  @override
  String get pdfColumnHives => 'Völker';

  @override
  String get pdfColumnDose => 'Dosis pro Volk';

  @override
  String get pdfColumnRemoval => 'Entnahme';

  @override
  String get pdfColumnWithdrawalEnd => 'Ende der Wartezeit';

  @override
  String get pdfColumnEvent => 'Eintrag';

  @override
  String get pdfColumnDetails => 'Details';

  @override
  String get pdfEventFeeding => 'Fütterung';

  @override
  String get pdfEventVarroa => 'Varroa-Zählung';

  @override
  String get pdfEventHarvest => 'Ernte';

  @override
  String pdfHarvestTotal(String amount) {
    return 'Gesamternte: $amount';
  }

  @override
  String pdfDocumentName(String title, String from, String to) {
    return '$title $from–$to';
  }

  @override
  String get moreFeedback => 'Feedback senden';

  @override
  String get feedbackTitle => 'Feedback senden';

  @override
  String get feedbackIntro =>
      'Wir entwickeln diese App gemeinsam mit Imkern. Wir lesen jede Nachricht.';

  @override
  String get feedbackKindLabel => 'Worum geht es?';

  @override
  String get feedbackKindBug => 'Fehler';

  @override
  String get feedbackKindSuggestion => 'Vorschlag';

  @override
  String get feedbackKindMissingFeature => 'Fehlende Funktion';

  @override
  String get feedbackKindThanks => 'Danke';

  @override
  String get feedbackMessageLabel => 'Deine Nachricht';

  @override
  String get feedbackMessageHint =>
      'Was ist passiert, und was hast du erwartet?';

  @override
  String get feedbackAddScreenshot => 'Bildschirmfoto hinzufügen';

  @override
  String get feedbackScreenshotAttached => 'Bildschirmfoto angehängt';

  @override
  String get feedbackRemoveScreenshot => 'Entfernen';

  @override
  String get feedbackScreenshotDenied =>
      'Der Fotozugriff wurde nicht erlaubt. Um ein Bildschirmfoto anzuhängen, erlaube ihn in den Einstellungen.';

  @override
  String get feedbackIncludeDeviceInfo => 'Geräte- und Versionsinfo mitsenden';

  @override
  String get feedbackOfflineHint =>
      'Ohne Internet wird die Nachricht vorgemerkt und gesendet, sobald du online bist.';

  @override
  String get feedbackSend => 'Senden';

  @override
  String get feedbackQueued =>
      'Danke! Deine Nachricht wird gesendet, sobald es geht.';

  @override
  String get settingsAnalytics => 'Nutzungsdaten teilen';

  @override
  String get settingsAnalyticsHint =>
      'Zahlen wie Durchsichtsdauer, Scanergebnisse und Synchronisierungsverzögerung; dein Name, deine Völker und Standorte werden nie gesendet.';

  @override
  String get teamTitle => 'Team';

  @override
  String get teamRoleOwner => 'Inhaber';

  @override
  String get teamRolePartner => 'Partner';

  @override
  String get teamRoleWorker => 'Mitarbeiter';

  @override
  String get teamRoleViewer => 'Berater';

  @override
  String get teamRoleViewerSubtitle => 'Nur lesen';

  @override
  String get teamRoleHintPartner =>
      'Ein Partner erfasst Einträge und sieht die Finanzen.';

  @override
  String get teamRoleHintWorker =>
      'Ein Mitarbeiter erfasst Einträge, sieht aber keine Finanzen.';

  @override
  String get teamRoleHintViewer =>
      'Ein Berater kann nur lesen und keine Einträge erfassen.';

  @override
  String teamMemberSelf(String name) {
    return '$name (du)';
  }

  @override
  String get teamMemberUnknown => 'Teammitglied';

  @override
  String get teamMembersEmpty =>
      'Mitglieder erscheinen nach der Synchronisierung.';

  @override
  String get teamInviteTitle => 'Ins Team einladen';

  @override
  String get teamInviteHint => 'Sag oder schick den Code. Er gilt 48 Stunden.';

  @override
  String get teamInviteGenerate => 'Code erzeugen';

  @override
  String get teamInviteCopy => 'Kopieren';

  @override
  String get teamInviteCopied => 'Code kopiert.';

  @override
  String teamInviteCodeSemantics(String code) {
    return 'Einladungscode $code';
  }

  @override
  String get teamHaveCode => 'Ich habe einen Code';

  @override
  String get teamJoinTitle => 'Mit einem Code beitreten';

  @override
  String get teamJoinHint =>
      'Gib den 6-stelligen Code ein, den du bekommen hast.';

  @override
  String get teamJoinCodeLabel => 'Einladungscode';

  @override
  String get teamJoinAction => 'Beitreten';

  @override
  String get teamJoinDone => 'Du bist dem Team beigetreten.';

  @override
  String get teamErrorOffline =>
      'Dafür ist eine Internetverbindung nötig. Versuche es erneut, wenn du online bist.';

  @override
  String get teamErrorInvalidCode =>
      'Der Code ist ungültig, abgelaufen oder schon benutzt.';

  @override
  String get teamErrorAlreadyMember => 'Du bist bereits Mitglied dieses Teams.';

  @override
  String get teamErrorForbidden => 'Das darfst du nicht.';

  @override
  String get teamErrorOwnerLocked =>
      'Die Rolle des Inhabers kann nicht geändert und der Inhaber nicht entfernt werden.';

  @override
  String get teamErrorUnknown =>
      'Das hat nicht geklappt. Versuche es gleich noch einmal.';

  @override
  String get teamRemoveAction => 'Aus dem Team entfernen';

  @override
  String get teamRemoveTitle => 'Aus dem Team entfernen?';

  @override
  String teamRemoveMessage(String name) {
    return '$name verliert den Zugriff auf die Einträge dieses Betriebs.';
  }

  @override
  String get teamRemoveConfirm => 'Entfernen';

  @override
  String teamRemoved(String name) {
    return '$name wurde aus dem Team entfernt.';
  }

  @override
  String teamRoleChanged(String name, String role) {
    return '$name ist jetzt $role.';
  }

  @override
  String get teamActivityTitle => 'Letzte Aktivitäten';

  @override
  String get teamActivityEmpty => 'Noch keine Aktivitäten.';

  @override
  String get teamActivitySelf => 'Du';

  @override
  String teamActivityInspection(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'hat $count Durchsichten erfasst',
      one: 'hat 1 Durchsicht erfasst',
    );
    return '$_temp0';
  }

  @override
  String teamActivityTreatment(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'hat $count Völker behandelt',
      one: 'hat 1 Volk behandelt',
    );
    return '$_temp0';
  }

  @override
  String teamActivityFeeding(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'hat $count Völker gefüttert',
      one: 'hat 1 Volk gefüttert',
    );
    return '$_temp0';
  }

  @override
  String teamActivityHarvest(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'hat $count Ernten erfasst',
      one: 'hat 1 Ernte erfasst',
    );
    return '$_temp0';
  }

  @override
  String teamActivityMiteCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'hat $count Varroa-Zählungen erfasst',
      one: 'hat 1 Varroa-Zählung erfasst',
    );
    return '$_temp0';
  }

  @override
  String teamActivityTask(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'hat $count Aufgaben hinzugefügt',
      one: 'hat 1 Aufgabe hinzugefügt',
    );
    return '$_temp0';
  }

  @override
  String get teamActivityJustNow => 'gerade eben';

  @override
  String teamActivityMinutesAgo(int count) {
    return 'vor $count Min.';
  }

  @override
  String teamActivityHoursAgo(int count) {
    return 'vor $count Std.';
  }

  @override
  String get teamActivityYesterday => 'gestern';

  @override
  String teamActivityDaysAgo(int count) {
    return 'vor $count Tagen';
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
  String get settingsPush => 'Aufgabenbenachrichtigungen';

  @override
  String get settingsPushHint =>
      'Erhalte eine Benachrichtigung, wenn dir eine Aufgabe zugewiesen wird. Tippe darauf, um die Aufgabe zu öffnen.';

  @override
  String get documentsTitle => 'Dokumentenmappe';

  @override
  String get documentsAdd => 'Dokument hinzufügen';

  @override
  String documentsSummaryOffline(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count Dokumente',
      one: '1 Dokument',
    );
    return '$_temp0 · alle offline verfügbar';
  }

  @override
  String documentsSummaryMissing(int count, int missing) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count Dokumente',
      one: '1 Dokument',
    );
    String _temp1 = intl.Intl.pluralLogic(
      missing,
      locale: localeName,
      other: '$missing Dateien',
      one: '1 Datei',
    );
    return '$_temp0 · $_temp1 noch nicht auf diesem Telefon';
  }

  @override
  String get documentsRegionNoteTr =>
      'Die Dokumentarten hängen vom Land ab. Außerhalb der Türkei legst du deine eigenen Dokumentarten an.';

  @override
  String get documentsRegionNoteOther =>
      'Du legst die Dokumentarten fest; eingegebene Arten werden beim nächsten Mal vorgeschlagen.';

  @override
  String get documentsRoadCheck => 'Verkehrskontrolle · Dokumente zeigen';

  @override
  String get documentsEmptyTitle => 'Noch keine Dokumente';

  @override
  String get documentsEmptyMessage =>
      'Füge ein Foto oder PDF deiner Genehmigungen und Bescheinigungen hinzu. Sie öffnen sich offline, und du wirst vor dem Ablauf erinnert.';

  @override
  String get documentsLoadError =>
      'Die Dokumente konnten nicht geöffnet werden.';

  @override
  String get documentFileKindPhoto => 'FOTO';

  @override
  String get documentFileKindPdf => 'PDF';

  @override
  String get documentTypeHealthReport => 'Gesundheitszeugnis';

  @override
  String get documentTypeTransportPermit => 'Transportgenehmigung';

  @override
  String get documentTypeMigratoryCertificate => 'Wanderimkerbescheinigung';

  @override
  String get documentTypeBusinessRegistration => 'Betriebsregistrierung';

  @override
  String get documentTypeLandPermit => 'Grundstückserlaubnis';

  @override
  String get documentTypeAnalysisReport => 'Analysebericht';

  @override
  String get documentExpiryNone => 'Ohne Ablauf';

  @override
  String get documentExpiryExpired => 'Abgelaufen';

  @override
  String get documentExpiryToday => 'Endet heute';

  @override
  String documentExpiryDays(int days) {
    String _temp0 = intl.Intl.pluralLogic(
      days,
      locale: localeName,
      other: '$days Tage',
      one: '1 Tag',
    );
    return '$_temp0';
  }

  @override
  String documentExpiryMonths(int months) {
    String _temp0 = intl.Intl.pluralLogic(
      months,
      locale: localeName,
      other: '$months Monate',
      one: '1 Monat',
    );
    return '$_temp0';
  }

  @override
  String documentExpiresOn(String date) {
    return 'Gültig bis $date';
  }

  @override
  String get documentFormNewTitle => 'Dokument hinzufügen';

  @override
  String get documentFormEditTitle => 'Dokument bearbeiten';

  @override
  String get documentFormType => 'Dokumentart';

  @override
  String get documentFormCustomTypeHint => 'z. B. Versicherungspolice';

  @override
  String get documentFormName => 'Name';

  @override
  String get documentFormNameHint => 'z. B. Gesundheitszeugnis 2026';

  @override
  String get documentFormDescription => 'Beschreibung';

  @override
  String get documentFormDescriptionHint => 'z. B. Veterinäramt · 152 Völker';

  @override
  String get documentFormExpiry => 'Gültig bis';

  @override
  String get documentFormNoExpiry => 'Ohne Ablauf';

  @override
  String get documentFormPickDate => 'Datum wählen';

  @override
  String get documentFormExpiryHelper =>
      'Du wirst 30, 7 und 1 Tag vor dem Ablauf erinnert.';

  @override
  String get documentFormFile => 'Datei';

  @override
  String get documentFormTakePhoto => 'Foto aufnehmen';

  @override
  String get documentFormPickImage => 'Aus der Galerie';

  @override
  String get documentFormPickPdf => 'PDF wählen';

  @override
  String get documentFormNoFile =>
      'Fotografiere das Dokument oder wähle sein PDF.';

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
      'Die Datei ist größer als 20 MB; wähle eine kleinere.';

  @override
  String get documentFileFailed =>
      'Die Datei konnte nicht übernommen werden, versuche es erneut.';

  @override
  String get documentFilePermissionDenied =>
      'Berechtigung verweigert. Um ein Dokument hinzuzufügen, erlaube Kamera- oder Dateizugriff für diese App in den Einstellungen.';

  @override
  String get documentFormSave => 'Speichern';

  @override
  String get documentFormDelete => 'Dokument löschen';

  @override
  String get documentSaved => 'Dokument gespeichert';

  @override
  String get documentReminderDenied =>
      'Dokument gespeichert. Ohne Benachrichtigungsberechtigung klingeln keine Ablauferinnerungen.';

  @override
  String get documentDeleteTitle => 'Dieses Dokument löschen?';

  @override
  String get documentDeleteMessage =>
      'Das Dokument und seine Datei werden von allen Telefonen entfernt.';

  @override
  String get documentDeleteConfirm => 'Löschen';

  @override
  String get documentDeleted => 'Dokument gelöscht';

  @override
  String get documentNotFound =>
      'Dokument nicht gefunden; es wurde vielleicht gelöscht.';

  @override
  String get documentEdit => 'Bearbeiten';

  @override
  String get documentFileMissing =>
      'Die Datei ist noch nicht auf diesem Telefon. Sie wird geladen, sobald du online bist.';

  @override
  String get documentPdfFailed => 'Das PDF konnte nicht geöffnet werden.';

  @override
  String documentPdfPage(int page, int count) {
    return 'Seite $page von $count';
  }

  @override
  String get roadCheckTitle => 'Verkehrskontrolle';

  @override
  String roadCheckPosition(int index, int count) {
    return '$index / $count';
  }

  @override
  String get roadCheckSwipeHint => 'Zur Seite wischen für das nächste Dokument';

  @override
  String get roadCheckPrevious => 'Vorheriges Dokument';

  @override
  String get roadCheckNext => 'Nächstes Dokument';

  @override
  String documentReminderBody(int days, String date) {
    String _temp0 = intl.Intl.pluralLogic(
      days,
      locale: localeName,
      other: '$days Tagen',
      one: '1 Tag',
    );
    return 'Läuft in $_temp0 ab · $date';
  }

  @override
  String get syncTableDocuments => 'Dokument';

  @override
  String get migrationsTitle => 'Wanderpläne';

  @override
  String get migrationsAdd => 'Neuer Plan';

  @override
  String get migrationsEmptyTitle => 'Noch kein Wanderplan';

  @override
  String get migrationsEmptyMessage =>
      'Plane die Route des Jahres: Termine, Völkerzahl und Zielstand jeder Station.';

  @override
  String get migrationsLoadError => 'Wanderpläne konnten nicht geöffnet werden';

  @override
  String migrationStopCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count Stationen',
      one: '1 Station',
      zero: 'Keine Stationen',
    );
    return '$_temp0';
  }

  @override
  String migrationTitle(String name, String year) {
    return '$name $year';
  }

  @override
  String get migrationNotFound => 'Wanderplan nicht gefunden';

  @override
  String get migrationDocuments => 'Dokumente';

  @override
  String get migrationEdit => 'Plan bearbeiten';

  @override
  String get migrationAddStop => 'Station hinzufügen';

  @override
  String get migrationNoStopsTitle => 'Noch keine Stationen';

  @override
  String get migrationNoStopsMessage =>
      'Füge die Stationen der Route der Reihe nach hinzu: Tracht, Ort, Termine und Völkerzahl.';

  @override
  String migrationNextMoveIn(int days) {
    String _temp0 = intl.Intl.pluralLogic(
      days,
      locale: localeName,
      other: 'in $days Tagen',
      one: 'in 1 Tag',
      zero: 'heute',
    );
    return 'Nächste Wanderung · $_temp0';
  }

  @override
  String migrationNextMoveLate(int days) {
    String _temp0 = intl.Intl.pluralLogic(
      days,
      locale: localeName,
      other: '$days Tage verspätet',
      one: '1 Tag verspätet',
    );
    return 'Nächste Wanderung · $_temp0';
  }

  @override
  String migrationRoute(String from, String to) {
    return '$from → $to';
  }

  @override
  String migrationDocReady(String document) {
    return '$document bereit';
  }

  @override
  String migrationDocDays(String document, int days) {
    String _temp0 = intl.Intl.pluralLogic(
      days,
      locale: localeName,
      other: '$days Tage',
      one: '1 Tag',
      zero: 'läuft heute ab',
    );
    return '$document $_temp0';
  }

  @override
  String migrationDocBeforeMove(String document) {
    return '$document läuft vor der Wanderung ab';
  }

  @override
  String migrationDocExpired(String document) {
    return '$document abgelaufen';
  }

  @override
  String migrationDocMissing(String document) {
    return '$document fehlt';
  }

  @override
  String get migrationStopPast => 'Vergangen';

  @override
  String get migrationStopCurrent => 'Jetzt hier';

  @override
  String get migrationStopPlanned => 'Geplant';

  @override
  String get migrationStopHere => 'Du bist hier';

  @override
  String migrationStopDates(String start, String end) {
    return '$start–$end';
  }

  @override
  String migrationYield(String year, String kg) {
    return '$year: $kg kg/Volk';
  }

  @override
  String migrationYields(String values) {
    return 'Frühere Erträge · $values';
  }

  @override
  String get migrationNoYield => 'Noch keine Ernte an diesem Stand';

  @override
  String get migrationFormNewTitle => 'Neuer Wanderplan';

  @override
  String get migrationFormEditTitle => 'Wanderplan bearbeiten';

  @override
  String get migrationFormYear => 'Jahr';

  @override
  String get migrationFormName => 'Name';

  @override
  String get migrationFormDefaultName => 'Wanderplan';

  @override
  String get migrationFormSave => 'Speichern';

  @override
  String get migrationFormDelete => 'Plan löschen';

  @override
  String get migrationDeleteTitle => 'Wanderplan löschen?';

  @override
  String get migrationDeleteMessage =>
      'Der Plan und alle seine Stationen werden gelöscht.';

  @override
  String get migrationDeleteConfirm => 'Löschen';

  @override
  String get migrationSaved => 'Plan gespeichert';

  @override
  String get migrationDeleted => 'Plan gelöscht';

  @override
  String get stopFormNewTitle => 'Neue Station';

  @override
  String get stopFormEditTitle => 'Station bearbeiten';

  @override
  String get stopFormName => 'Tracht';

  @override
  String get stopFormNameHint => 'z. B. Raps, Akazie';

  @override
  String get stopFormPlace => 'Ort';

  @override
  String get stopFormPlaceHint => 'z. B. Lüneburger Heide';

  @override
  String get stopFormStart => 'Geplanter Beginn';

  @override
  String get stopFormEnd => 'Geplantes Ende';

  @override
  String get stopFormApiary => 'Zielstand';

  @override
  String get stopFormChooseApiary => 'Zielstand wählen';

  @override
  String get stopFormNone => 'Keiner';

  @override
  String get stopFormHiveCount => 'Völker';

  @override
  String get stopFormPosition => 'Reihenfolge auf der Route';

  @override
  String get stopFormStatus => 'Status';

  @override
  String get stopFormDelete => 'Station löschen';

  @override
  String get stopDeleteTitle => 'Station löschen?';

  @override
  String get stopDeleteMessage => 'Die Station wird aus dem Plan entfernt.';

  @override
  String get stopSaved => 'Station gespeichert';

  @override
  String get stopDeleted => 'Station gelöscht';

  @override
  String get syncTableMigrations => 'Wanderplan';

  @override
  String get syncTableMigrationStops => 'Wanderstation';

  @override
  String get moveStart => 'Wanderung starten';

  @override
  String moveTitle(String route) {
    return 'Wanderung · $route';
  }

  @override
  String get moveNone => 'Keine anstehende Wanderung';

  @override
  String get moreMigratory => 'Wandern';

  @override
  String get syncTableTransports => 'Wanderung';

  @override
  String get syncTableTransportItems => 'Gewandertes Volk';

  @override
  String get moveStepCheck => 'Prüfen';

  @override
  String get moveStepLoad => 'Verladen';

  @override
  String get moveStepUnload => 'Abladen';

  @override
  String moveStepDone(String step) {
    return '$step, erledigt';
  }

  @override
  String get moveNoDestinationTitle => 'Die Station hat keinen Bienenstand';

  @override
  String get moveNoDestinationMessage =>
      'Wähle einen Zielstand für die Station, damit die Standorte der Völker nach dem Abladen aktualisiert werden.';

  @override
  String get moveEditStop => 'Station bearbeiten';

  @override
  String get moveFrom => 'Von';

  @override
  String get moveTo => 'Nach';

  @override
  String moveSourceHives(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count aktive Völker',
      one: '1 aktives Volk',
      zero: 'Keine aktiven Völker',
    );
    return '$_temp0';
  }

  @override
  String get moveChecklist => 'Checkliste zum Verladen';

  @override
  String get moveCheckEntrances => 'Fluglöcher geschlossen';

  @override
  String get moveCheckVentilation => 'Lüftung offen';

  @override
  String get moveCheckStraps => 'Gurte fest';

  @override
  String get moveCheckWater => 'Wasser bereit';

  @override
  String get moveVehicles => 'Fahrzeuge';

  @override
  String moveVehicleDefault(int number) {
    return 'Lkw $number';
  }

  @override
  String get moveAddVehicle => 'Fahrzeug hinzufügen';

  @override
  String moveRemoveVehicle(String vehicle) {
    return '$vehicle entfernen';
  }

  @override
  String get moveVehicleName => 'Fahrzeugname';

  @override
  String get moveVehicleExists => 'Ein Fahrzeug mit diesem Namen gibt es schon';

  @override
  String get moveStartLoading => 'Verladen starten';

  @override
  String get moveChecklistHint =>
      'Hake alles auf der Liste ab, um mit dem Verladen zu beginnen.';

  @override
  String moveVehicleCount(String vehicle, int count) {
    return '$vehicle · $count';
  }

  @override
  String get moveLoaded => 'Verladen';

  @override
  String get moveUnloaded => 'Abgeladen';

  @override
  String moveCountTotal(int total) {
    return '/ $total';
  }

  @override
  String moveCountLabel(int count, int total) {
    return '$count von $total Völkern';
  }

  @override
  String moveLastScanned(String number) {
    return 'Zuletzt gescannt: $number';
  }

  @override
  String moveNotScanned(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count Völker noch nicht gescannt',
      one: '1 Volk noch nicht gescannt',
    );
    return '$_temp0';
  }

  @override
  String get moveAllScanned => 'Alle gescannt';

  @override
  String get moveShowList => 'Liste ansehen';

  @override
  String get moveMissingTitle => 'Nicht gescannte Völker';

  @override
  String get moveLoadingHint =>
      'Beim Abladen am Ziel scannst du erneut; ich warne dich, wenn ein Volk fehlt. Die Standorte der Völker werden nach dem Abladen aktualisiert.';

  @override
  String moveUnloadingHint(String destination) {
    return 'Scanne jedes Volk beim Abladen erneut. Wenn du fertig bist, wechseln die abgeladenen Völker nach $destination.';
  }

  @override
  String get moveEnterNumber => 'Nummer eingeben';

  @override
  String get moveHiveNumber => 'Volksnummer';

  @override
  String moveNumberNotFound(String number) {
    return 'Kein Volk mit der Nummer $number';
  }

  @override
  String get moveScanStart => 'Scannen starten';

  @override
  String get moveScanContinue => 'Weiter scannen';

  @override
  String get moveToUnloading => 'Zum Abladen';

  @override
  String moveToUnloadingTitle(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count Völker nicht gescannt',
      one: '1 Volk nicht gescannt',
    );
    return '$_temp0';
  }

  @override
  String get moveToUnloadingMessage =>
      'Nicht gescannte Völker sind nicht Teil dieser Wanderung und bleiben, wo sie sind.';

  @override
  String get moveFinish => 'Wanderung abschließen';

  @override
  String moveFinishTitle(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count Völker nicht abgeladen',
      one: '1 Volk nicht abgeladen',
    );
    return '$_temp0';
  }

  @override
  String moveFinishMessage(String source) {
    return 'Nicht abgeladene Völker behalten ihren Standort $source. Die Fehlliste bleibt bei der Wanderung.';
  }

  @override
  String get moveFinishConfirm => 'Abschließen';

  @override
  String get moveDoneTitle => 'Wanderung abgeschlossen';

  @override
  String moveDoneSummary(int loaded, int unloaded) {
    return 'Verladen $loaded · Abgeladen $unloaded';
  }

  @override
  String moveDoneMoved(int count, String destination) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count Völker nach $destination gewandert.',
      one: '1 Volk nach $destination gewandert.',
      zero: 'Keine Völker gewandert.',
    );
    return '$_temp0';
  }

  @override
  String get moveDoneMissing => 'Nicht abgeladene Völker';

  @override
  String moveScanLoaded(String number, String vehicle) {
    return '$number verladen · $vehicle';
  }

  @override
  String moveScanLoadedOther(String number) {
    return '$number verladen; dieses Volk stand nicht an diesem Stand';
  }

  @override
  String moveScanAlreadyLoaded(String number) {
    return '$number ist bereits verladen';
  }

  @override
  String moveScanUnloaded(String number) {
    return '$number abgeladen';
  }

  @override
  String moveScanAlreadyUnloaded(String number) {
    return '$number ist bereits abgeladen';
  }

  @override
  String moveScanNotLoaded(String number) {
    return '$number wurde bei dieser Wanderung nicht verladen';
  }

  @override
  String get moveScanUnknown => 'Unbekanntes Etikett';

  @override
  String get moveScanDone => 'Fertig';

  @override
  String get inventoryTitle => 'Material und Lager';

  @override
  String get inventoryAdd => 'Artikel hinzufügen';

  @override
  String get inventoryEmptyTitle => 'Noch keine Lagerartikel';

  @override
  String get inventoryEmptyMessage =>
      'Füge Material wie Zucker, Mittelwände und Gläser hinzu. Artikel unter ihrem Mindestbestand werden markiert.';

  @override
  String get inventoryCategoryEmpty => 'Keine Artikel in dieser Kategorie';

  @override
  String get inventoryLoadError => 'Das Lager konnte nicht geöffnet werden.';

  @override
  String get inventoryNotFound => 'Artikel nicht gefunden';

  @override
  String get inventoryCategoryConsumable => 'Verbrauchsmaterial';

  @override
  String get inventoryCategoryEquipment => 'Ausrüstung';

  @override
  String get inventoryCategoryComb => 'Waben';

  @override
  String get inventoryUnitKg => 'kg';

  @override
  String get inventoryUnitLiter => 'L';

  @override
  String get inventoryUnitPiece => 'Stk.';

  @override
  String get inventoryUnitRoll => 'Rollen';

  @override
  String get inventoryUnitPack => 'Pck.';

  @override
  String get inventoryUnitNameKg => 'Kilogramm';

  @override
  String get inventoryUnitNameLiter => 'Liter';

  @override
  String get inventoryUnitNamePiece => 'Stück';

  @override
  String get inventoryUnitNameRoll => 'Rolle';

  @override
  String get inventoryUnitNamePack => 'Packung';

  @override
  String inventoryQuantity(String quantity, String unit) {
    return '$quantity $unit';
  }

  @override
  String inventoryBelowThreshold(String threshold) {
    return 'Unter Mindestbestand · mindestens $threshold';
  }

  @override
  String get inventoryMoveIn => 'Zugang';

  @override
  String get inventoryMoveOut => 'Abgang';

  @override
  String get inventoryMoveCount => 'Zählen';

  @override
  String get inventoryMoveAdjustment => 'Korrektur';

  @override
  String inventoryInStock(String quantity) {
    return 'Auf Lager: $quantity';
  }

  @override
  String inventoryAmountLabel(String unit) {
    return 'Menge ($unit)';
  }

  @override
  String inventoryCountedLabel(String unit) {
    return 'Gezählte Menge ($unit)';
  }

  @override
  String get inventoryAmountInvalid => 'Gib eine gültige Menge ein';

  @override
  String get inventoryAmountWhole =>
      'Verwende für diese Einheit eine ganze Zahl';

  @override
  String get inventorySaveIn => 'Zum Lager hinzufügen';

  @override
  String get inventorySaveOut => 'Vom Lager abziehen';

  @override
  String get inventorySaveCount => 'Bestand korrigieren';

  @override
  String inventoryMovedIn(String quantity) {
    return '$quantity hinzugefügt';
  }

  @override
  String inventoryMovedOut(String quantity) {
    return '$quantity abgezogen';
  }

  @override
  String inventoryAdjusted(String quantity) {
    return 'Bestand jetzt $quantity';
  }

  @override
  String inventoryUnchanged(String quantity) {
    return 'Bestand ist bereits $quantity';
  }

  @override
  String get inventoryDetails => 'Details und Verlauf';

  @override
  String get inventoryHistory => 'Verlauf';

  @override
  String get inventoryHistoryEmpty => 'Noch keine Bewegungen';

  @override
  String inventoryThreshold(String threshold) {
    return 'Mindestbestand: mindestens $threshold';
  }

  @override
  String get inventoryNoThreshold => 'Kein Mindestbestand';

  @override
  String get inventoryQuickMove => 'Hinzufügen / abziehen';

  @override
  String get inventoryEdit => 'Artikel bearbeiten';

  @override
  String get inventoryFormNewTitle => 'Neuer Artikel';

  @override
  String get inventoryFormEditTitle => 'Artikel bearbeiten';

  @override
  String get inventoryFormName => 'Name';

  @override
  String get inventoryFormCategory => 'Kategorie';

  @override
  String get inventoryFormUnit => 'Einheit';

  @override
  String get inventoryFormLocation => 'Lagerort';

  @override
  String get inventoryFormLocationHint => 'Lager, Fahrzeug, Büro … Optional.';

  @override
  String get inventoryFormThreshold => 'Mindestbestand';

  @override
  String get inventoryFormThresholdHint =>
      'Du wirst gewarnt, wenn der Bestand darunter fällt. Optional.';

  @override
  String get inventoryFormThresholdInvalid =>
      'Gib einen gültigen Mindestbestand ein';

  @override
  String get inventoryFormSave => 'Speichern';

  @override
  String get inventoryFormDelete => 'Artikel löschen';

  @override
  String get inventoryDeleteTitle => 'Diesen Artikel löschen?';

  @override
  String get inventoryDeleteMessage =>
      'Der Artikel und sein Bestand verschwinden aus der Liste.';

  @override
  String get inventoryDeleteConfirm => 'Löschen';

  @override
  String get inventorySaved => 'Artikel gespeichert';

  @override
  String get inventoryDeleted => 'Artikel gelöscht';

  @override
  String get syncTableInventoryItems => 'Lagerartikel';

  @override
  String get syncTableInventoryMoves => 'Lagerbewegung';

  @override
  String inventoryIncrease(String quantity) {
    return '+$quantity';
  }

  @override
  String inventoryFormThresholdUnit(String unit) {
    return 'Mindestbestand ($unit)';
  }

  @override
  String get stockUseTitle => 'Vom Lager abziehen';

  @override
  String get stockUseNone => 'Nicht abziehen';

  @override
  String stockUseValue(String item, String quantity) {
    return '$item · −$quantity';
  }

  @override
  String get stockUseChoose => 'Von welchem Artikel abziehen?';

  @override
  String get taskFormTreatment => 'Geplante Behandlung';

  @override
  String get taskFormTreatmentUnknown => 'Arzneimittel nicht in der Liste';

  @override
  String get taskFormTreatmentNeedsApiary =>
      'Wähle einen Bienenstand für die geplante Behandlung';

  @override
  String taskTreatmentPlanTitle(String drug) {
    return 'Behandlung · $drug';
  }

  @override
  String get shoppingTitle => 'Einkaufsliste';

  @override
  String shoppingCardTitle(int count) {
    return 'Einkaufsliste · $count';
  }

  @override
  String get shoppingEmptyTitle => 'Nichts zu kaufen';

  @override
  String get shoppingEmptyMessage =>
      'Artikel unter ihrem Mindestbestand und der Bedarf geplanter Behandlungen erscheinen hier.';

  @override
  String get shoppingShare => 'Teilen';

  @override
  String get shoppingLoadError =>
      'Die Einkaufsliste konnte nicht geöffnet werden';

  @override
  String shoppingReasonThreshold(String stock, String threshold) {
    return '$stock auf Lager · min. $threshold';
  }

  @override
  String shoppingReasonPlanned(String quantity) {
    return 'Geplante Behandlungen $quantity';
  }

  @override
  String get shoppingReasonNoItem => 'Geplante Behandlung · kein Lagerartikel';

  @override
  String shoppingShareLine(String name, String quantity) {
    return '• $name: $quantity';
  }

  @override
  String get moreRearing => 'Königinnenzucht';

  @override
  String get rearingTitle => 'Königinnenzucht';

  @override
  String rearingBatchName(int number) {
    return 'Serie $number';
  }

  @override
  String rearingBatchTitle(int number) {
    return 'Königinnenzucht · Serie $number';
  }

  @override
  String get rearingAdd => 'Serie hinzufügen';

  @override
  String get rearingEmptyTitle => 'Noch keine Serien';

  @override
  String get rearingEmptyMessage =>
      'Gib den Umlarvtag ein; der Zeitplan von der Annahme bis zur Eilagekontrolle und seine Erinnerungen werden für dich angelegt.';

  @override
  String get rearingLoadError => 'Serien konnten nicht geladen werden';

  @override
  String get rearingNotFound => 'Serie nicht gefunden';

  @override
  String rearingListGrafted(String date) {
    return 'umgelarvt $date';
  }

  @override
  String get rearingEdit => 'Serie bearbeiten';

  @override
  String get rearingGraftedLabel => 'Umgelarvt';

  @override
  String get rearingAcceptedLabel => 'Angenommen';

  @override
  String get rearingNucsLabel => 'Begattungsvölkchen';

  @override
  String get rearingNotCounted => 'Nicht gezählt';

  @override
  String rearingAcceptedPercent(int percent) {
    return '$percent %';
  }

  @override
  String rearingMotherLine(String mother, String date) {
    return 'Mutter: $mother · umgelarvt $date';
  }

  @override
  String rearingMotherUnknownLine(String date) {
    return 'Mutter unbekannt · umgelarvt $date';
  }

  @override
  String rearingDay(int day) {
    return 'T$day';
  }

  @override
  String get rearingToday => 'Heute';

  @override
  String get rearingStepGraft => 'Umlarven';

  @override
  String get rearingStepAcceptance => 'Annahmekontrolle';

  @override
  String get rearingStepCapped => 'Zellen verdeckelt';

  @override
  String get rearingStepDistribution => 'Zellen verteilen';

  @override
  String get rearingStepEmergence => 'Schlupf der Königinnen';

  @override
  String get rearingStepLayingCheck => 'Eilagekontrolle';

  @override
  String rearingStepGraftDetail(int count) {
    return '$count Larven';
  }

  @override
  String rearingStepAcceptanceDetail(int count) {
    return '$count Zellen angenommen';
  }

  @override
  String get rearingStepAcceptanceTodo => 'Angenommene Zellen zählen';

  @override
  String get rearingStepCappedDetail => 'Nicht stören';

  @override
  String rearingStepDistributionDetail(int count) {
    return 'Vor dem Schlupf, auf $count Begattungsvölkchen';
  }

  @override
  String get rearingStepDistributionTodo =>
      'Vor dem Schlupf, auf die Begattungsvölkchen';

  @override
  String get rearingStepEmergenceDetail => 'Begattungsvölkchen prüfen';

  @override
  String get rearingStepLayingCheckDetail => 'Begattungserfolg vermerken';

  @override
  String get rearingStepDone => 'erledigt';

  @override
  String get rearingStepCurrent => 'als Nächstes';

  @override
  String get rearingStepUpcoming => 'anstehend';

  @override
  String get rearingDistribute => 'Zellen auf Begattungsvölkchen verteilen';

  @override
  String get rearingDistributeApiary => 'Bienenstand';

  @override
  String get rearingDistributeCount => 'Begattungsvölkchen';

  @override
  String rearingDistributePlan(int reused, int created) {
    return 'Leere wiederverwendet: $reused · Neue: $created';
  }

  @override
  String get rearingDistributeSave => 'Verteilen';

  @override
  String get rearingDistributeNoApiary => 'Lege zuerst einen Bienenstand an';

  @override
  String rearingDistributed(int count) {
    return 'Auf $count Begattungsvölkchen verteilt';
  }

  @override
  String get rearingNucsSection => 'Begattungsvölkchen';

  @override
  String rearingNucTitle(String number) {
    return 'Begattungsvölkchen $number';
  }

  @override
  String get matingNucStatusEmpty => 'Leer';

  @override
  String get matingNucStatusCell => 'Zelle';

  @override
  String get matingNucStatusVirgin => 'Unbegattete Königin';

  @override
  String get matingNucStatusLaying => 'In Eilage';

  @override
  String get matingNucStatusFailed => 'Fehlgeschlagen';

  @override
  String get matingNucStatusGiven => 'An ein Volk gegeben';

  @override
  String get rearingNucGive => 'An ein Volk geben';

  @override
  String get rearingNucChooseHive => 'Welches Volk?';

  @override
  String get rearingNucNoHives => 'Keine aktiven Völker';

  @override
  String get rearingFormNewTitle => 'Neue Serie';

  @override
  String get rearingFormEditTitle => 'Serie bearbeiten';

  @override
  String get rearingFormGraftedOn => 'Umlarvtag';

  @override
  String get rearingFormGraftedCount => 'Umgelarvte Larven';

  @override
  String get rearingFormAcceptedCount => 'Angenommene Zellen';

  @override
  String get rearingFormAcceptedClear => 'Noch nicht gezählt';

  @override
  String get rearingFormScheduleHint =>
      'Annahme, Verdeckelung, Verteilung, Schlupf und Eilagekontrolle werden als Aufgaben mit Erinnerungen angelegt.';

  @override
  String get rearingFormSave => 'Speichern';

  @override
  String get rearingFormDelete => 'Serie löschen';

  @override
  String get rearingDeleteTitle => 'Serie löschen?';

  @override
  String get rearingDeleteMessage =>
      'Ihre Aufgaben werden ebenfalls gelöscht. Begattungsvölkchen und vergebene Königinnen bleiben.';

  @override
  String get rearingDeleteConfirm => 'Löschen';

  @override
  String get rearingDeleted => 'Serie gelöscht';

  @override
  String get rearingSaved => 'Serie gespeichert';

  @override
  String get taskSourceQueenRearing => 'Königinnenzucht';

  @override
  String get syncTableQueenRearingBatches => 'Zuchtserie';

  @override
  String get syncTableMatingNucs => 'Begattungsvölkchen';

  @override
  String get lotsTitle => 'Ernte & Chargen';

  @override
  String get lotsEmptyTitle => 'Noch keine Chargen';

  @override
  String get lotsEmptyMessage =>
      'Füge eine Ernte nach dem Speichern einer Charge hinzu; die Chargen stehen hier.';

  @override
  String get lotsLoadError => 'Chargen konnten nicht geladen werden';

  @override
  String get lotsInStock => 'Auf Lager';

  @override
  String get lotsPerHive => 'Pro Volk';

  @override
  String lotNumber(String number) {
    return 'Charge $number';
  }

  @override
  String lotHoneyTitle(String kind) {
    return '$kind';
  }

  @override
  String get lotStatusOpen => 'Offen';

  @override
  String get lotStatusClosed => 'Geschlossen';

  @override
  String get lotWithdrawalBadge => 'In der Wartezeit';

  @override
  String lotMoistureValue(String value) {
    return 'Wassergehalt $value %';
  }

  @override
  String get lotAnalyzed => 'Analysiert ✓';

  @override
  String get lotAnalysisPending => 'Analyse ausstehend';

  @override
  String lotStockValue(String weight) {
    return 'Bestand $weight';
  }

  @override
  String get lotNotFound => 'Charge nicht gefunden';

  @override
  String get lotEdit => 'Charge bearbeiten';

  @override
  String lotWithdrawalTitle(String hives) {
    return '$hives in der Wartezeit geerntet.';
  }

  @override
  String get lotWithdrawalMessage =>
      'Diese Charge kann Arzneimittelrückstände enthalten; lass sie vor dem Verkauf analysieren.';

  @override
  String get lotStock => 'Bestand';

  @override
  String get lotHarvested => 'Geerntet';

  @override
  String get lotSold => 'Verkauft';

  @override
  String get lotInStock => 'Auf Lager';

  @override
  String get lotSell => 'Verkauf erfassen';

  @override
  String get lotAnalyses => 'Analysen';

  @override
  String get lotAnalysesEmpty => 'Noch keine Analysen';

  @override
  String get lotAddAnalysis => 'Analyse hinzufügen';

  @override
  String get lotHarvests => 'Ernten';

  @override
  String get lotHarvestsEmpty => 'Keine Ernten in dieser Charge';

  @override
  String get lotTreatments => 'Letzte Behandlung der Völker';

  @override
  String get lotTreatmentsEmpty =>
      'Für die Völker dieser Charge sind keine Behandlungen erfasst';

  @override
  String lotTreatmentTitle(String hive, String product) {
    return 'Volk $hive · $product';
  }

  @override
  String lotTreatmentDetail(String date, String end) {
    return '$date · Wartezeit endet $end';
  }

  @override
  String get lotPublicPage => 'Öffentliche Seite';

  @override
  String get lotPublish => 'Veröffentlichen';

  @override
  String get lotPublishHint =>
      'Wer den QR-Code scannt, sieht die Seite der Charge. Telefon, Adresse und Standort werden nie gezeigt.';

  @override
  String get lotPublishOwnerOnly =>
      'Nur der Inhaber des Betriebs kann veröffentlichen.';

  @override
  String get lotPublished => 'Veröffentlicht';

  @override
  String get lotNotPublished => 'Nicht veröffentlicht';

  @override
  String get lotPublicFields => 'Auf der Seite gezeigt';

  @override
  String get lotPublicProducer => 'Betriebsname und Völkerzahl';

  @override
  String get lotPublicOrigin => 'Herkunft und Erntemonat';

  @override
  String get lotPublicLab => 'Analysewerte';

  @override
  String get lotPublicReport => 'Analysebericht';

  @override
  String get lotJarLabels => 'Glasetiketten (QR)';

  @override
  String get lotJarLabelsHint =>
      '24 Etiketten pro A4-Seite (70 × 37 mm); drucke mit 100 % Skalierung.';

  @override
  String lotJarLabelsDocumentName(String number) {
    return 'Glasetiketten - $number';
  }

  @override
  String get lotSales => 'Verkäufe';

  @override
  String get lotSalesEmpty => 'Noch keine Verkäufe erfasst';

  @override
  String lotSaleValue(String weight) {
    return '−$weight';
  }

  @override
  String lotSaleAmount(String unit) {
    return 'Verkaufter Honig ($unit)';
  }

  @override
  String lotSaleTooMuch(String weight) {
    return 'Nur $weight auf Lager';
  }

  @override
  String get lotSaleSave => 'Vom Bestand abziehen';

  @override
  String lotSaleSaved(String weight) {
    return 'Verkauf von $weight erfasst';
  }

  @override
  String get lotOrigin => 'Herkunft';

  @override
  String get lotOriginHint => 'z. B. Bergwald';

  @override
  String get lotMoisture => 'Wassergehalt %';

  @override
  String get lotMoistureHelper => 'Refraktometerwert; optional';

  @override
  String get lotMoistureInvalid =>
      'Gib einen Wert zwischen 10 und 30 ein, z. B. 17,2';

  @override
  String lotEditTitle(String lot) {
    return '$lot bearbeiten';
  }

  @override
  String get lotStatus => 'Status';

  @override
  String get lotStatusHelper =>
      'Geschlossene Chargen nehmen keine neuen Ernten auf';

  @override
  String get lotSave => 'Speichern';

  @override
  String get lotDelete => 'Charge löschen';

  @override
  String lotDeleteTitle(String lot) {
    return '$lot löschen?';
  }

  @override
  String get lotDeleteMessage =>
      'Analysen und Verkäufe werden ebenfalls gelöscht; Ernten bleiben.';

  @override
  String get lotDeleted => 'Charge gelöscht';

  @override
  String labTitle(String lot) {
    return 'Analyse · $lot';
  }

  @override
  String get labDate => 'Analysedatum';

  @override
  String get labHmf => 'HMF (mg/kg)';

  @override
  String get labDiastase => 'Diastasezahl';

  @override
  String get labProline => 'Prolin (mg/kg)';

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
    return 'Prolin $value';
  }

  @override
  String labValueInvalid(String min, String max) {
    return 'Gib einen Wert zwischen $min und $max ein';
  }

  @override
  String get labResidue => 'Rückstände';

  @override
  String get labResidueNone => 'Keine Rückstände';

  @override
  String get labResidueDetected => 'Rückstände nachgewiesen';

  @override
  String get labReport => 'Bericht';

  @override
  String get labReportNone => 'Kein Bericht';

  @override
  String get labReportEmpty => 'Keine Analyseberichte in der Dokumentenmappe';

  @override
  String get labReportAdd => 'Bericht zur Dokumentenmappe hinzufügen';

  @override
  String get labSave => 'Analyse speichern';

  @override
  String get labSaved => 'Analyse gespeichert';

  @override
  String get harvestLotTitle => 'Zur Charge hinzufügen';

  @override
  String harvestLotSaved(String weight, String kind) {
    return 'Ernte gespeichert: $weight $kind';
  }

  @override
  String get harvestLotIntro =>
      'Kommt Honig in eine Charge, werden die letzten Behandlungsdaten der Völker mit ihr verknüpft.';

  @override
  String get harvestLotNew => 'Neue Charge';

  @override
  String harvestLotNewHint(String kind) {
    return '$kind · Nummer wird automatisch vergeben';
  }

  @override
  String get harvestLotCreate => 'Charge anlegen';

  @override
  String get harvestLotAdd => 'Zur Charge hinzufügen';

  @override
  String get harvestLotSkip => 'Jetzt überspringen';

  @override
  String harvestLotCreated(String lot) {
    return '$lot angelegt';
  }

  @override
  String harvestLotAdded(String lot) {
    return 'Ernte zu $lot hinzugefügt';
  }

  @override
  String get harvestLotGone => 'Ernte wurde rückgängig gemacht';

  @override
  String get harvestLotBack => 'Zurück zum Bienenstand';

  @override
  String get syncTableLots => 'Charge';

  @override
  String get syncTableLotHarvests => 'Ernte einer Charge';

  @override
  String get syncTableLotTreatments => 'Behandlung einer Charge';

  @override
  String get syncTableLabResults => 'Laborergebnis';

  @override
  String get syncTableLotSales => 'Verkauf einer Charge';

  @override
  String get harvestLotGoneMessage =>
      'Die Ernte wurde keiner Charge hinzugefügt. Du kannst sie über den Bienenstand erneut erfassen.';

  @override
  String get financeTitle => 'Finanzen';

  @override
  String financeYearTitle(String year) {
    return 'Finanzen · $year';
  }

  @override
  String get financeSeasonNet => 'Saisonergebnis';

  @override
  String get financeIncome => 'Einnahmen';

  @override
  String get financeExpense => 'Ausgaben';

  @override
  String get financeCostPerHive => 'Kosten/Volk';

  @override
  String get financeRecent => 'Letzte Buchungen';

  @override
  String get financeEmptyTitle => 'Noch keine Buchungen';

  @override
  String get financeEmptyMessage =>
      'Erfasse Einnahmen und Ausgaben mit den Buttons unten; das Saisonergebnis wird hier berechnet.';

  @override
  String get financeLoadError => 'Buchungen konnten nicht geladen werden';

  @override
  String get financeAddIncome => '+ Einnahme';

  @override
  String get financeAddExpense => '− Ausgabe';

  @override
  String financePlus(String amount) {
    return '+$amount';
  }

  @override
  String financeMinus(String amount) {
    return '−$amount';
  }

  @override
  String get financeReceiptAttached => 'Beleg angehängt';

  @override
  String financeTransportRoute(String from, String to) {
    return '$from → $to';
  }

  @override
  String get financeFormIncomeTitle => 'Einnahme hinzufügen';

  @override
  String get financeFormExpenseTitle => 'Ausgabe hinzufügen';

  @override
  String financeFormAmount(String currency) {
    return 'Betrag ($currency)';
  }

  @override
  String get financeFormAmountInvalid =>
      'Gib einen Betrag über 0 ein, z. B. 17500 oder 17,50';

  @override
  String get financeFormCategory => 'Kategorie';

  @override
  String get financeFormDate => 'Datum';

  @override
  String get financeFormDescription => 'Beschreibung';

  @override
  String get financeFormDescriptionHint => 'z. B. Zucker 500 kg';

  @override
  String get financeFormReceipt => 'Beleg / Rechnung';

  @override
  String get financeFormNoReceipt => 'Kein Beleg';

  @override
  String get financeFormReceiptAdded => 'Belegfoto hinzugefügt';

  @override
  String get financeFormTakePhoto => 'Foto aufnehmen';

  @override
  String get financeFormPickImage => 'Aus der Galerie';

  @override
  String get financeFormRemoveReceipt => 'Beleg entfernen';

  @override
  String get financeFormPhotoDenied =>
      'Berechtigung verweigert. Um einen Beleg hinzuzufügen, erlaube Kamera- oder Fotozugriff für diese App in den Einstellungen.';

  @override
  String get financeFormPhotoFailed =>
      'Das Foto konnte nicht übernommen werden, versuche es erneut.';

  @override
  String get financeFormLinks => 'Verknüpfter Eintrag';

  @override
  String get financeFormApiary => 'Bienenstand';

  @override
  String get financeFormLot => 'Charge';

  @override
  String get financeFormTransport => 'Wanderung';

  @override
  String get financeFormNone => 'Keiner';

  @override
  String get financeFormChooseApiary => 'Bienenstand wählen';

  @override
  String get financeFormChooseLot => 'Charge wählen';

  @override
  String get financeFormChooseTransport => 'Wanderung wählen';

  @override
  String get financeFormNoLots => 'Noch keine Chargen';

  @override
  String get financeFormNoTransports => 'Noch keine Wanderungen';

  @override
  String financeFormSaleAmount(String unit) {
    return 'Verkaufter Honig ($unit)';
  }

  @override
  String get financeFormSaleHelper =>
      'Wird vom Bestand der Charge abgezogen; leer lassen, um den Bestand beizubehalten';

  @override
  String get financeFormSave => 'Speichern';

  @override
  String get financeIncomeSaved => 'Einnahme gespeichert';

  @override
  String get financeExpenseSaved => 'Ausgabe gespeichert';

  @override
  String get financeNotFound => 'Buchung nicht gefunden';

  @override
  String get financeReceiptPending =>
      'Der Beleg ist noch nicht auf diesem Telefon';

  @override
  String get financeDelete => 'Buchung löschen';

  @override
  String get financeDeleteTitle => 'Diese Buchung löschen?';

  @override
  String get financeDeleteMessage =>
      'Ist sie mit einem Chargenverkauf verknüpft, wird auch der Verkauf gelöscht und der Bestand kehrt zurück.';

  @override
  String get financeDeleteConfirm => 'Löschen';

  @override
  String get financeDeleted => 'Buchung gelöscht';

  @override
  String get financeCategoryFeeding => 'Fütterung';

  @override
  String get financeCategoryTreatment => 'Arzneimittel';

  @override
  String get financeCategoryEquipment => 'Ausrüstung';

  @override
  String get financeCategoryFuelTransport => 'Kraftstoff / Transport';

  @override
  String get financeCategoryLandRent => 'Pacht';

  @override
  String get financeCategoryLabor => 'Arbeitslohn';

  @override
  String get financeCategoryLabAnalysis => 'Laboranalyse';

  @override
  String get financeCategoryHoney => 'Honig';

  @override
  String get financeCategoryPollen => 'Pollen';

  @override
  String get financeCategoryPropolis => 'Propolis';

  @override
  String get financeCategoryWax => 'Wachs';

  @override
  String get financeCategoryNucs => 'Ableger';

  @override
  String get financeCategoryQueens => 'Königinnen';

  @override
  String get financeCategoryOther => 'Sonstiges';

  @override
  String get syncTableTransactions => 'Einnahme/Ausgabe';

  @override
  String get customersTitle => 'Kundenbuch';

  @override
  String get customersAdd => 'Kunde hinzufügen';

  @override
  String get customersEmptyTitle => 'Noch keine Kunden';

  @override
  String get customersEmptyMessage =>
      'Füge Kunden hinzu, um ihre Bestellungen und offenen Beträge zu verfolgen.';

  @override
  String customerReceivableValue(String amount) {
    return '$amount offen';
  }

  @override
  String get customerNoReceivable => 'Nichts offen';

  @override
  String get customerNotFound => 'Kunde nicht gefunden';

  @override
  String get customerEdit => 'Kunde bearbeiten';

  @override
  String get customerAddSale => 'Verkauf hinzufügen';

  @override
  String get customerOrders => 'Bestellungen';

  @override
  String get customerNoOrders => 'Noch keine Verkäufe an diesen Kunden.';

  @override
  String get customerPaid => 'Bezahlt';

  @override
  String customerRemaining(String amount) {
    return 'noch $amount';
  }

  @override
  String get customerPaidAmount => 'Bisher bezahlt';

  @override
  String get customerMarkPaid => 'Als bezahlt markieren';

  @override
  String get customerMarkedPaid => 'Als bezahlt markiert';

  @override
  String get customerAddPayment => 'Zahlung erfassen';

  @override
  String get customerSendWhatsApp => 'Per WhatsApp senden';

  @override
  String get customerWhatsAppNoPhone =>
      'Keine Telefonnummer; wähle den Kontakt in WhatsApp';

  @override
  String get customerWhatsAppFailed => 'WhatsApp konnte nicht geöffnet werden';

  @override
  String get customerOpenTransaction => 'Buchung öffnen';

  @override
  String customerWhatsAppGreeting(String name) {
    return 'Hallo $name,';
  }

  @override
  String get customerWhatsAppIntro => 'deine Bestellübersicht:';

  @override
  String customerWhatsAppAmount(String amount) {
    return 'Gesamt: $amount';
  }

  @override
  String customerWhatsAppPaid(String amount) {
    return 'Bezahlt: $amount';
  }

  @override
  String customerWhatsAppRemaining(String amount) {
    return 'Offen: $amount';
  }

  @override
  String get customerWhatsAppPaidInFull => 'Vollständig bezahlt, danke.';

  @override
  String customerWhatsAppAddress(String address) {
    return 'Lieferadresse: $address';
  }

  @override
  String get customerFormNewTitle => 'Neuer Kunde';

  @override
  String get customerFormEditTitle => 'Kunde bearbeiten';

  @override
  String get customerFormName => 'Name';

  @override
  String get customerFormPhone => 'Telefon';

  @override
  String get customerFormPhoneHelper => 'Für WhatsApp, z. B. +49 151 23456789';

  @override
  String get customerFormAddress => 'Lieferadresse';

  @override
  String get customerFormNotes => 'Notiz';

  @override
  String get customerFormSave => 'Speichern';

  @override
  String get customerSaved => 'Kunde gespeichert';

  @override
  String get customerDelete => 'Kunde löschen';

  @override
  String get customerDeleteTitle => 'Kunde löschen?';

  @override
  String get customerDeleteMessage =>
      'Die Verkäufe bleiben in deinen Einnahmen.';

  @override
  String get customerDeleteConfirm => 'Löschen';

  @override
  String get customerDeleted => 'Kunde gelöscht';

  @override
  String get customerPaymentSave => 'Zahlung speichern';

  @override
  String get customerPaymentSaved => 'Zahlung gespeichert';

  @override
  String customerPaymentTooMuch(String amount) {
    return 'Es sind nur noch $amount offen.';
  }

  @override
  String get financeFormCustomer => 'Kunde';

  @override
  String get financeFormChooseCustomer => 'Kunde wählen';

  @override
  String get financeFormNoCustomers => 'Noch keine Kunden';

  @override
  String get financeFormPaidNow => 'Jetzt bezahlt';

  @override
  String get financeFormPaidNowHelper =>
      'Leer lassen, wenn der ganze Betrag offen ist.';

  @override
  String get financeFormPaidTooMuch => 'Darf nicht höher als der Betrag sein.';

  @override
  String get financeProfitTitle => 'Gewinn nach Bienenstand';

  @override
  String get financeProfitUnknownApiary => 'Gelöschter Bienenstand';

  @override
  String financeReceivables(String amount, int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count Kunden',
      one: '1 Kunde',
    );
    return '$amount offen · $_temp0';
  }

  @override
  String get syncTableCustomers => 'Kunde';

  @override
  String get syncTableCustomerPayments => 'Zahlung';

  @override
  String get customerUnpaid => 'Unbezahlt';

  @override
  String customerPartiallyPaid(String paid, String remaining) {
    return '$paid bezahlt, $remaining offen';
  }

  @override
  String get taskAksUpdateTitle => 'AKS aktualisieren nicht vergessen';

  @override
  String get taskSourceAks => 'AKS';

  @override
  String get syncTableRefSupportPeriods => 'Förderzeitraum';

  @override
  String get subsidiesTitle => 'Förderungen';

  @override
  String get subsidiesCheckTitle => 'Vor der Antragstellung';

  @override
  String get subsidiesActiveHives => 'Aktive Völker in der App';

  @override
  String get subsidiesDeclaredHives => 'In AKS gemeldet';

  @override
  String get subsidiesNotDeclared => 'Nicht eingetragen';

  @override
  String get subsidiesCheckNotDeclared =>
      'Gib die in AKS gemeldete Völkerzahl ein; sie wird vor dem Antrag mit der App verglichen.';

  @override
  String subsidiesCheckDiffers(String active, String declared) {
    return 'Die App hat $active aktive Völker, in AKS sind aber $declared gemeldet. Aktualisiere deinen AKS-Eintrag vor dem Antrag.';
  }

  @override
  String get subsidiesCheckMatches =>
      'Die Zahlen stimmen: App und AKS passen zusammen.';

  @override
  String get subsidiesEditDeclared => 'Gemeldete Zahl eingeben';

  @override
  String get subsidiesDeclaredOwnerOnly =>
      'Nur der Inhaber kann die gemeldete Zahl eingeben.';

  @override
  String get subsidiesPeriodsTitle => 'Antragszeiträume';

  @override
  String get subsidiesEmptyTitle => 'Noch keine Förderzeiträume';

  @override
  String get subsidiesEmptyMessage =>
      'Antragszeiträume erscheinen hier, sobald sie bekanntgegeben werden; du wirst benachrichtigt, wenn einer beginnt.';

  @override
  String get subsidiesPhaseOpen => 'Offen';

  @override
  String get subsidiesPhaseUpcoming => 'Demnächst';

  @override
  String get subsidiesPhaseClosed => 'Beendet';

  @override
  String subsidiesPeriodDates(String start, String end) {
    return '$start – $end';
  }

  @override
  String get subsidiesOpenSource => 'Amtliche Bekanntmachung öffnen';

  @override
  String get subsidiesOpenSourceFailed =>
      'Der Link konnte nicht geöffnet werden';

  @override
  String get aksCountTitle => 'AKS-Völkerzahl';

  @override
  String get aksCountLabel => 'In AKS gemeldete Völkerzahl';

  @override
  String get aksCountHelper => 'Leer lassen, um den Abgleich zu überspringen.';

  @override
  String get aksCountInvalid => 'Gib eine Zahl zwischen 0 und 100.000 ein';

  @override
  String get aksCountSave => 'Speichern';

  @override
  String get aksCountSaved => 'AKS-Völkerzahl gespeichert';

  @override
  String get aksCountNoOrganization =>
      'Die Betriebsdaten sind noch nicht auf diesem Telefon; warte die Synchronisierung ab.';

  @override
  String get knowledgeTitle => 'Wissensbasis';

  @override
  String get knowledgeSearchHint => 'Wintervorrat, Varroa …';

  @override
  String knowledgeMonthLabel(String month, String place) {
    return '$month · $place';
  }

  @override
  String get knowledgePlaceTurkey => 'Türkei';

  @override
  String get knowledgePlaceNorthern => 'Nordhalbkugel';

  @override
  String get knowledgePlaceSouthern => 'Südhalbkugel';

  @override
  String get knowledgeMonthTitle => 'Diesen Monat zu tun';

  @override
  String get knowledgeDiagnosisTitle => 'Diagnosehilfe';

  @override
  String get knowledgeDiagnosisSubtitle =>
      'Anzeichen wählen, mögliche Ursachen sehen';

  @override
  String get knowledgeAtlasTitle => 'Atlas der Krankheiten und Schädlinge';

  @override
  String knowledgeTopicCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count Themen',
      one: '1 Thema',
    );
    return '$_temp0';
  }

  @override
  String get knowledgeGuidesTitle => 'Fachanleitungen';

  @override
  String get knowledgeGuidesSubtitle =>
      'Ableger, Zusetzen von Königinnen, Vereinigen, Einwintern';

  @override
  String get knowledgeCalculatorsTitle => 'Rechner';

  @override
  String get knowledgeCalculatorsSubtitle =>
      'Sirup, Arzneimitteldosis, Königinnenkalender, Ertrag';

  @override
  String get knowledgeRegulationsTitle => 'Zusammenfassungen der Vorschriften';

  @override
  String get knowledgeRegulationsSubtitle =>
      'Verordnung, Wanderimkerei, Honigverordnung';

  @override
  String get knowledgeTrBadge => 'TR';

  @override
  String get knowledgeFirstYearTitle => 'Mein erstes Jahr';

  @override
  String get knowledgeFirstYearSubtitle => 'Schritt für Schritt für Einsteiger';

  @override
  String get knowledgeCalendarTitle => 'Jahreskalender';

  @override
  String get knowledgeOffline => 'Alle Inhalte öffnen sich offline';

  @override
  String get knowledgeNoResultsTitle => 'Keine Ergebnisse';

  @override
  String get knowledgeNoResultsMessage => 'Versuche ein anderes Wort.';

  @override
  String get knowledgeCategoryEmptyTitle => 'Noch keine Artikel';

  @override
  String get knowledgeCategoryEmptyMessage =>
      'Inhalte für diesen Bereich kommen mit einem Update.';

  @override
  String get knowledgeArticleNotFound => 'Artikel nicht gefunden';

  @override
  String get knowledgeLoadError =>
      'Die Wissensbasis konnte nicht geöffnet werden';

  @override
  String get knowledgeLinkFailed => 'Der Link konnte nicht geöffnet werden';

  @override
  String get diagnosisSymptoms => 'Was du siehst';

  @override
  String get diagnosisSymptomsHelper => 'Du kannst mehrere wählen.';

  @override
  String get diagnosisResults => 'Mögliche Krankheiten';

  @override
  String get diagnosisPickHint =>
      'Wähle ein Anzeichen, um hier mögliche Krankheiten zu sehen.';

  @override
  String get diagnosisNoMatch =>
      'Keine Krankheit passt zu den gewählten Anzeichen.';

  @override
  String diagnosisMatched(int matched, int total) {
    return 'Passende Anzeichen: $matched/$total';
  }

  @override
  String get diagnosisNotifiable => 'Anzeigepflichtig';

  @override
  String get diagnosisDisclaimer =>
      'Dies ist eine erste Einschätzung; die endgültige Diagnose stellt ein Tierarzt oder ein Labor.';

  @override
  String get diagnosisLoadError =>
      'Die Diagnosetabelle konnte nicht geöffnet werden';

  @override
  String get diagnosisNotFound => 'Krankheit nicht gefunden';

  @override
  String get diagnosisNotifiableTitle => 'Anzeigepflichtige Krankheit.';

  @override
  String get diagnosisNotifiableMessage =>
      'Melde den Verdacht der Behörde; teile Geräte, Waben oder Honig dieses Volkes nicht mit anderen Völkern.';

  @override
  String get diagnosisAdvice => 'Was zu tun ist';

  @override
  String get diagnosisAuthority => 'Behörde';

  @override
  String diagnosisCall(String phone) {
    return '$phone anrufen';
  }

  @override
  String get diagnosisCallFailed => 'Der Anruf konnte nicht gestartet werden';

  @override
  String get diagnosisQuarantine => 'Volk unter Quarantäne stellen';

  @override
  String get quarantinePickTitle => 'Volk für die Quarantäne';

  @override
  String get quarantineSearchHint => 'Volksnummer';

  @override
  String get quarantineNoHivesTitle => 'Keine Völker';

  @override
  String get quarantineNoHivesMessage =>
      'Kein aktives Volk für die Quarantäne.';

  @override
  String quarantineDone(String number) {
    return 'Volk $number unter Quarantäne';
  }

  @override
  String get hiveQuarantined => 'Unter Quarantäne';

  @override
  String hiveQuarantineDisease(String disease) {
    return 'Verdacht: $disease';
  }

  @override
  String hiveQuarantineSince(String date) {
    return 'Seit $date';
  }

  @override
  String get hiveQuarantineWarning =>
      'Teile Geräte, Waben oder Honig nicht mit anderen Völkern.';

  @override
  String get hiveQuarantineEnd => 'Quarantäne beenden';

  @override
  String hiveQuarantineEnded(String number) {
    return 'Volk $number ist nicht mehr unter Quarantäne';
  }

  @override
  String get calculatorSyrup => 'Sirup';

  @override
  String get calculatorSyrupSubtitle => 'Benötigter Zucker und Wasser';

  @override
  String get calculatorDose => 'Behandlungsdosis';

  @override
  String get calculatorDoseSubtitle => 'Gesamtmenge für deine Völkerzahl';

  @override
  String get calculatorQueen => 'Königinnenkalender';

  @override
  String get calculatorQueenSubtitle => 'Arbeitstage ab dem Umlarvtag';

  @override
  String get calculatorYield => 'Ertrag';

  @override
  String get calculatorYieldSubtitle => 'Honig pro Volk';

  @override
  String get calculatorOffline =>
      'Die Rechner funktionieren offline und speichern nichts.';

  @override
  String get calculatorNotFound => 'Rechner nicht gefunden';

  @override
  String get calculatorHives => 'Anzahl der Völker';

  @override
  String get calculatorSyrupKind => 'Sirupart';

  @override
  String get calculatorFillHint => 'Gib die Völkerzahl und die Menge ein.';

  @override
  String get calculatorDosePerHive => 'Dosis pro Volk';

  @override
  String get calculatorDoseUnit => 'Einheit';

  @override
  String get calculatorTotal => 'Gesamt';

  @override
  String calculatorDoseTotal(String unit, String total) {
    String _temp0 = intl.Intl.selectLogic(unit, {
      'strip': '$total Streifen',
      'ml': '$total ml',
      'g': '$total g',
      'other': '$total Dosen',
    });
    return '$_temp0';
  }

  @override
  String calculatorDoseCount(int count, String amount) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count Völker × $amount',
      one: '1 Volk × $amount',
    );
    return '$_temp0';
  }

  @override
  String calculatorYieldTotal(String unit) {
    return 'Honig gesamt ($unit)';
  }

  @override
  String get calculatorYieldPerHive => 'Pro Volk';

  @override
  String calculatorYieldValue(String amount, String unit) {
    return '$amount $unit';
  }

  @override
  String get calculatorQueenSteps => 'Schritte';

  @override
  String get hiveLossWintering => 'Überwinterung';

  @override
  String get hiveLossQueenless => 'Weisellos';

  @override
  String get hiveLossVarroa => 'Varroa';

  @override
  String get hiveLossDisease => 'Krankheit';

  @override
  String get hiveLossStarvation => 'Verhungert';

  @override
  String get hiveLossRobbing => 'Räuberei';

  @override
  String get hiveLossPredator => 'Bär / Tier';

  @override
  String get hiveLossPoisoning => 'Vergiftung';

  @override
  String get hiveLossOther => 'Sonstiges';

  @override
  String get hiveLossUnspecified => 'Nicht angegeben';

  @override
  String hiveLossReasonTitle(String number) {
    return 'Warum ging Volk $number verloren?';
  }

  @override
  String get hiveLossSkip => 'Ohne Grund überspringen';

  @override
  String get hiveFormLossReason => 'Verlustursache';

  @override
  String get hiveFormLossReasonHelper =>
      'Wird im Saisonbericht verwendet; kann leer bleiben.';

  @override
  String get seasonReportTile => 'Saisonbericht';

  @override
  String seasonTitle(String year) {
    return 'Saison $year';
  }

  @override
  String get seasonPdf => 'PDF';

  @override
  String get seasonExportCsv => 'Nach Excel exportieren (CSV)';

  @override
  String get seasonExportError =>
      'Die Datei konnte nicht erstellt werden. Versuche es erneut.';

  @override
  String get seasonLoadError =>
      'Der Saisonbericht konnte nicht geladen werden.';

  @override
  String get seasonHives => 'Völker';

  @override
  String seasonHiveChange(int start, int end) {
    return '$start → $end';
  }

  @override
  String seasonNetGain(int count) {
    return '+$count netto';
  }

  @override
  String seasonNetLoss(int count) {
    return '−$count netto';
  }

  @override
  String get seasonNetSame => 'Keine Veränderung';

  @override
  String get seasonWinterLoss => 'Winterverlust';

  @override
  String get seasonWinterNotStarted => 'Der Winter hat noch nicht begonnen';

  @override
  String seasonPreviousWinter(String year) {
    return 'Winterverlust $year';
  }

  @override
  String seasonPreviousWinterRate(String year, String rate) {
    return '$year: $rate';
  }

  @override
  String get seasonHoney => 'Honig gesamt';

  @override
  String get seasonNewQueens => 'Neue Königinnen';

  @override
  String seasonOwnReared(int count) {
    return 'eigene Zucht $count';
  }

  @override
  String get seasonLossesTitle => 'Verluste und Ursachen';

  @override
  String get seasonNoLosses => 'In dieser Saison ging kein Volk verloren.';

  @override
  String seasonHiveCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count Völker',
      one: '1 Volk',
    );
    return '$_temp0';
  }

  @override
  String get seasonByTreatment => 'Winterverlust · nach Behandlungsmethode';

  @override
  String get seasonByApiary => 'Winterverlust · nach Bienenstand';

  @override
  String get seasonByQueenLine => 'Winterverlust · nach Königinnenlinie';

  @override
  String get seasonTabTreatment => 'Behandlung';

  @override
  String get seasonTabApiary => 'Bienenstand';

  @override
  String get seasonTabQueenLine => 'Königinnenlinie';

  @override
  String get seasonNoWinterData =>
      'In deinen Einträgen ist noch kein Volk in den Winter gegangen.';

  @override
  String get seasonFewData => 'wenige Daten';

  @override
  String get seasonMisleadingNote =>
      'Aus deinen eigenen Einträgen; bei wenigen Völkern evtl. irreführend.';

  @override
  String get seasonUntreated => 'Nicht behandelt';

  @override
  String get seasonMethodSeparator => ' +';

  @override
  String get seasonQueenLineUnknown => 'Unbekannte Linie';

  @override
  String get seasonFinanceTitle => 'Kosten und Gewinn';

  @override
  String get seasonProfit => 'Gewinn';

  @override
  String get seasonPdfFigure => 'Kennzahl';

  @override
  String get seasonPdfValue => 'Wert';

  @override
  String seasonPdfHiveChange(int start, int end, String net) {
    return '$start → $end ($net)';
  }

  @override
  String seasonPdfNewQueens(int count, int own) {
    return '$count (eigene Zucht $own)';
  }

  @override
  String seasonPdfWinterLoss(String rate, int lost, int hives) {
    return '$rate ($lost von $hives Völkern)';
  }

  @override
  String get seasonPdfReason => 'Ursache';

  @override
  String get seasonPdfHives => 'Völker';

  @override
  String get seasonPdfLost => 'Verloren';

  @override
  String get seasonPdfRate => 'Verlust';

  @override
  String get seasonPdfGroup => 'Gruppe';

  @override
  String get seasonPdfTotal => 'Gesamt';

  @override
  String get seasonCsvHive => 'Volk';

  @override
  String get seasonCsvApiary => 'Bienenstand';

  @override
  String get seasonCsvStartStatus => 'Status zu Saisonbeginn';

  @override
  String get seasonCsvEndStatus => 'Status zu Saisonende';

  @override
  String get seasonCsvLossDate => 'Verlustdatum';

  @override
  String get seasonCsvLossReason => 'Verlustursache';

  @override
  String get seasonCsvInWinter => 'In den Winter gegangen';

  @override
  String get seasonCsvLostInWinter => 'Im Winter verloren';

  @override
  String get seasonCsvWinterApiary => 'Winterstand';

  @override
  String get seasonCsvTreatment => 'Behandlung vor dem Winter';

  @override
  String get seasonCsvQueenLine => 'Königinnenlinie';

  @override
  String get seasonCsvAddedInSeason => 'In dieser Saison hinzugekommen';

  @override
  String get seasonCsvYes => 'Ja';

  @override
  String get seasonCsvNo => 'Nein';

  @override
  String get offlineMapsTitle => 'Offline-Karten';

  @override
  String get offlineMapsIntro =>
      'Lade die Umgebung deiner Bienenstände herunter; die Karte öffnet sich auch ohne Empfang.';

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
    return 'Heruntergeladen · $size';
  }

  @override
  String offlineMapsDownloadingWifi(String received, String total) {
    return 'Download über WLAN · $received / $total';
  }

  @override
  String offlineMapsDownloading(String received, String total) {
    return 'Download · $received / $total';
  }

  @override
  String offlineMapsDownload(String name) {
    return '$name herunterladen';
  }

  @override
  String get offlineMapsCancel => 'Download stoppen';

  @override
  String offlineMapsDelete(String name) {
    return '$name löschen';
  }

  @override
  String offlineMapsDeleteTitle(String name) {
    return '$name löschen?';
  }

  @override
  String get offlineMapsDeleteMessage =>
      'Ohne Internet öffnet sich die Karte um diesen Bienenstand dann nicht. Du kannst sie jederzeit erneut herunterladen.';

  @override
  String get offlineMapsDeleteConfirm => 'Löschen';

  @override
  String get offlineMapsWifiOnly => 'Nur über WLAN herunterladen';

  @override
  String get offlineMapsWifiOnlyHint =>
      'Einige MB pro Bienenstand; es werden keine mobilen Daten verbraucht.';

  @override
  String offlineMapsStop(String name) {
    return 'Station $name';
  }

  @override
  String offlineMapsDone(String name) {
    return 'Umgebung von $name heruntergeladen';
  }

  @override
  String offlineMapsFailed(String name) {
    return 'Die Umgebung von $name konnte nicht heruntergeladen werden. Prüfe deine Verbindung und versuche es erneut.';
  }

  @override
  String get offlineMapsNeedsWifi =>
      'Verbinde dich mit einem WLAN oder schalte „Nur über WLAN herunterladen“ aus.';

  @override
  String get offlineMapsAttribution =>
      'Kartendaten © OpenStreetMap contributors · OpenFreeMap';

  @override
  String get settingsOfflineMaps => 'Offline-Karten';

  @override
  String settingsOfflineMapsValue(int count, String size) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count Bienenstände · $size',
      one: '1 Bienenstand · $size',
      zero: 'Keine',
    );
    return '$_temp0';
  }

  @override
  String get offlineMapsCoverage =>
      'Jeder Bienenstand erhält 6 km Umgebung im Detail und 40 km als Übersicht.';

  @override
  String offlineMapsDownloadedOn(String date) {
    return 'heruntergeladen: $date';
  }

  @override
  String get offlineMapsToDownload => 'Herunterzuladende Bienenstände';

  @override
  String get offlineMapsMoved => 'Bienenstand verlegt, erneut herunterladen';

  @override
  String get offlineMapsNoApiaries =>
      'Keine Bienenstände mit Standort. Füge einem Bienenstand einen Standort hinzu, dann erscheint er hier.';

  @override
  String get offlineMapsAllDownloaded =>
      'Alle Bienenstände mit Standort sind heruntergeladen.';

  @override
  String get syncReminderTitle => 'Deine Einträge sind noch nicht gesichert';

  @override
  String syncReminderBody(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other:
          '$count Einträge haben den Server seit 3 Tagen nicht erreicht. Öffne die App, wenn du online bist.',
      one: '1 Eintrag hat den Server seit 3 Tagen nicht erreicht. Öffne die App, wenn du online bist.',
    );
    return '$_temp0';
  }

  @override
  String get syncOverdueTitle => 'Seit über 3 Tagen nicht gesichert';

  @override
  String syncOverdueMessage(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other:
          '$count Einträge sind nur auf diesem Telefon. Geht das Telefon verloren, sind sie auch weg. Verbinde dich mit dem Internet und synchronisiere.',
      one: '1 Eintrag ist nur auf diesem Telefon. Geht das Telefon verloren, ist er auch weg. Verbinde dich mit dem Internet und synchronisiere.',
    );
    return '$_temp0';
  }

  @override
  String syncDaysAgo(int days) {
    String _temp0 = intl.Intl.pluralLogic(
      days,
      locale: localeName,
      other: 'vor $days Tagen',
      one: 'gestern',
      zero: 'heute',
    );
    return '$_temp0';
  }

  @override
  String syncLastSyncedAgo(String ago, String when) {
    return 'Zuletzt synchronisiert $ago · $when';
  }

  @override
  String syncPendingTitle(int count) {
    return 'Warten auf das Senden · $count';
  }

  @override
  String settingsSignOutPendingMessage(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other:
          '$count Einträge wurden noch nicht an den Server gesendet und sind nur auf diesem Telefon. Wenn du dich abmeldest, werden sie nicht gesendet. Verbinde dich zuerst mit dem Internet und synchronisiere.',
      one: '1 Eintrag wurde noch nicht an den Server gesendet und ist nur auf diesem Telefon. Wenn du dich abmeldest, wird er nicht gesendet. Verbinde dich zuerst mit dem Internet und synchronisiere.',
    );
    return '$_temp0';
  }

  @override
  String get settingsSignOutAnyway => 'Trotzdem abmelden';

  @override
  String get settingsExport => 'Daten exportieren';

  @override
  String get settingsExportValue => 'Excel';

  @override
  String get settingsExportHint =>
      'Alle deine Einträge in einer Excel-Datei; teile oder speichere sie, wo du willst.';

  @override
  String get exportPreparing => 'Wird vorbereitet …';

  @override
  String get exportFailed =>
      'Die Datei konnte nicht erstellt werden. Versuche es erneut.';

  @override
  String exportFileName(String date) {
    return 'Mobil Arıcı $date';
  }

  @override
  String get exportYes => 'Ja';

  @override
  String get exportNo => 'Nein';

  @override
  String get exportSheetApiaries => 'Bienenstände';

  @override
  String get exportSheetHives => 'Völker';

  @override
  String get exportSheetQueens => 'Königinnen';

  @override
  String get exportSheetInspections => 'Durchsichten';

  @override
  String get exportSheetFeedings => 'Fütterungen';

  @override
  String get exportSheetTreatments => 'Behandlungen';

  @override
  String get exportSheetMiteCounts => 'Varroa-Zählungen';

  @override
  String get exportSheetHarvests => 'Ernten';

  @override
  String get exportSheetTasks => 'Aufgaben';

  @override
  String get exportSheetInventory => 'Lager';

  @override
  String get exportSheetFinance => 'Einnahmen und Ausgaben';

  @override
  String get exportColName => 'Name';

  @override
  String get exportColLatitude => 'Breitengrad';

  @override
  String get exportColLongitude => 'Längengrad';

  @override
  String get exportColAltitude => 'Höhe (m)';

  @override
  String get exportColWaterSource => 'Wasserquelle';

  @override
  String get exportColVehicleDistance => 'Entfernung zum Fahrzeug (m)';

  @override
  String get exportColRoadNotes => 'Hinweise zur Zufahrt';

  @override
  String get exportColNotes => 'Notizen';

  @override
  String get exportColActiveHives => 'Aktive Völker';

  @override
  String get exportColCreated => 'Hinzugefügt';

  @override
  String get exportColApiary => 'Bienenstand';

  @override
  String get exportColHive => 'Volk';

  @override
  String get exportColType => 'Typ';

  @override
  String get exportColStatus => 'Status';

  @override
  String get exportColBoxes => 'Zargen';

  @override
  String get exportColFrames => 'Waben';

  @override
  String get exportColSource => 'Herkunft';

  @override
  String get exportColMarking => 'Kennzeichnung';

  @override
  String get exportColTag => 'Etikettencode';

  @override
  String get exportColQuarantine => 'Quarantäne';

  @override
  String get exportColQueen => 'Königin';

  @override
  String get exportColYear => 'Jahr';

  @override
  String get exportColColor => 'Zeichenfarbe';

  @override
  String get exportColBreed => 'Rasse';

  @override
  String get exportColLine => 'Linie';

  @override
  String get exportColWingClipped => 'Flügel beschnitten';

  @override
  String get exportColDate => 'Datum';

  @override
  String get exportColQueenState => 'Königin';

  @override
  String get exportColBeeFrames => 'Besetzte Waben';

  @override
  String get exportColBroodFrames => 'Brutwaben';

  @override
  String get exportColHoneyFrames => 'Honigwaben';

  @override
  String get exportColTemperament => 'Sanftmut';

  @override
  String get exportColSwarmSigns => 'Schwarmanzeichen';

  @override
  String get exportColQueenCells => 'Weiselzellen';

  @override
  String get exportColDisease => 'Krankheitsverdacht';

  @override
  String get exportColActions => 'Erledigt';

  @override
  String get exportColAmount => 'Menge';

  @override
  String get exportColUnit => 'Einheit';

  @override
  String get exportColProduct => 'Mittel';

  @override
  String get exportColActiveIngredient => 'Wirkstoff';

  @override
  String get exportColDose => 'Dosis';

  @override
  String get exportColWithdrawal => 'Wartezeit (Tage)';

  @override
  String get exportColBatch => 'Chargennr.';

  @override
  String get exportColPlannedRemoval => 'Geplante Entnahme';

  @override
  String get exportColMethod => 'Methode';

  @override
  String get exportColMites => 'Milben';

  @override
  String get exportColSampleBees => 'Bienen in der Probe';

  @override
  String get exportColDays => 'Tage';

  @override
  String get exportColResult => 'Ergebnis';

  @override
  String get exportColHoneyKind => 'Honig';

  @override
  String get exportColUnitCount => 'Anzahl';

  @override
  String get exportColNetKg => 'Netto (kg)';

  @override
  String get exportColHiveCount => 'Völker';

  @override
  String get exportColDue => 'Fällig';

  @override
  String get exportColTitle => 'Titel';

  @override
  String get exportColCompleted => 'Erledigt';

  @override
  String get exportColCategory => 'Kategorie';

  @override
  String get exportColPlace => 'Ort';

  @override
  String get exportColStock => 'Auf Lager';

  @override
  String get exportColThreshold => 'Warnung unter';

  @override
  String get exportColCurrency => 'Währung';

  @override
  String get exportColDescription => 'Beschreibung';

  @override
  String get businessTitle => 'Betrieb';

  @override
  String get businessEdit => 'Bearbeiten';

  @override
  String get businessEditTitle => 'Betrieb bearbeiten';

  @override
  String get businessCancel => 'Abbrechen';

  @override
  String get businessSave => 'Speichern';

  @override
  String get businessSaveError =>
      'Speichern nicht möglich; der Betrieb ist noch nicht auf diesem Telefon.';

  @override
  String get businessMissingTitle => 'Keine Betriebsdaten';

  @override
  String get businessMissingMessage =>
      'Sie erscheinen hier, sobald der Betrieb auf diesem Telefon angekommen ist.';

  @override
  String businessPersonRole(String person, String role) {
    return '$person · $role';
  }

  @override
  String get businessDetailSeparator => ' ·';

  @override
  String businessRegionBadge(String country, String profile) {
    return '$country · $profile';
  }

  @override
  String get businessRegionTr => 'TR-Profil';

  @override
  String get businessRegionOther => 'Allgemeines Profil';

  @override
  String get businessPendingSync => 'Noch nicht synchronisiert';

  @override
  String businessCountHives(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Völker',
      one: 'Volk',
    );
    return '$_temp0';
  }

  @override
  String businessCountApiaries(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Bienenstände',
      one: 'Bienenstand',
    );
    return '$_temp0';
  }

  @override
  String businessCountInspections(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Durchsichten',
      one: 'Durchsicht',
    );
    return '$_temp0';
  }

  @override
  String get businessSectionBusiness => 'Betrieb';

  @override
  String get businessSectionAccount => 'Konto';

  @override
  String get businessType => 'Art';

  @override
  String get businessTypeMigratory => 'Wanderimkerei';

  @override
  String get businessTypeStationary => 'Standimkerei';

  @override
  String get businessTypeHelp =>
      'Bei Standimkerei werden Wanderpläne und Wanderungen ausgeblendet; Einträge werden nicht gelöscht.';

  @override
  String get businessCurrency => 'Währung';

  @override
  String get businessCurrencySearch => 'Code oder Land suchen';

  @override
  String get businessCurrencyNoMatch => 'Keine Währung passt zu deiner Suche.';

  @override
  String get businessCurrencyNote =>
      'Frühere Einträge werden nicht umgerechnet; die neue Währung gilt nur für künftige Einträge.';

  @override
  String businessTeamTitle(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Team · $count Personen',
      one: 'Team · 1 Person',
    );
    return '$_temp0';
  }

  @override
  String get businessTeamSolo => 'Noch keine Teammitglieder';

  @override
  String businessRoleCountOwner(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count Inhaber',
      one: '1 Inhaber',
    );
    return '$_temp0';
  }

  @override
  String businessRoleCountPartner(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count Partner',
      one: '1 Partner',
    );
    return '$_temp0';
  }

  @override
  String businessRoleCountWorker(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count Mitarbeiter',
      one: '1 Mitarbeiter',
    );
    return '$_temp0';
  }

  @override
  String businessRoleCountViewer(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count Berater',
      one: '1 Berater',
    );
    return '$_temp0';
  }

  @override
  String get businessEmail => 'Anmelde-E-Mail';

  @override
  String get businessEmailSoon => 'Das Ändern der E-Mail-Adresse kommt bald.';

  @override
  String get businessFirstRecord => 'Erster Eintrag';

  @override
  String businessFirstRecordValue(String date, int season) {
    return '$date · Saison $season';
  }

  @override
  String get businessSettingsShortcut => 'Sprache, Einheiten, Design und Daten';

  @override
  String get businessNameLabel => 'Name des Betriebs';

  @override
  String get businessAvatarLabel => 'Avatar';

  @override
  String get businessAvatarHelp =>
      'Ohne Logo erscheinen deine Initialen in der gewählten Farbe.';

  @override
  String get businessAvatarPine => 'Kiefer';

  @override
  String get businessAvatarHoney => 'Honig';

  @override
  String get businessAvatarSky => 'Himmel';

  @override
  String get businessAvatarSlate => 'Schiefer';

  @override
  String get businessLogoUpload => 'Logo hochladen';

  @override
  String get businessLogoRemove => 'Logo entfernen';

  @override
  String get businessDiscardTitle => 'Änderungen verwerfen?';

  @override
  String get businessDiscardMessage =>
      'Deine nicht gespeicherten Änderungen gehen verloren.';

  @override
  String get businessDiscardAction => 'Verwerfen';

  @override
  String get businessTypeConfirmTitle => 'Zur Standimkerei wechseln?';

  @override
  String businessTypeConfirmMessage(int plans, int stops) {
    String _temp0 = intl.Intl.pluralLogic(
      plans,
      locale: localeName,
      other: '$plans Wanderpläne',
      one: '1 Wanderplan',
    );
    String _temp1 = intl.Intl.pluralLogic(
      stops,
      locale: localeName,
      other: '$stops Stationen',
      one: '1 Station',
    );
    return '$_temp0 und $_temp1 werden ausgeblendet. Einträge werden nicht gelöscht; du kannst das rückgängig machen.';
  }

  @override
  String get businessTypeConfirmAction => 'Wechseln';

  @override
  String get businessReadOnly =>
      'Nur der Inhaber und Partner können die Betriebsdaten ändern.';

  @override
  String get financeOtherCurrencies => 'Andere Währungen';

  @override
  String financeOtherCurrencyLine(String currency, String amount) {
    return '$currency · netto $amount';
  }

  @override
  String get migratoryHiddenTitle => 'Modul Wanderimkerei ist aus';

  @override
  String get migratoryHiddenMessage =>
      'Dein Betrieb ist eine Standimkerei. Wanderpläne und Wanderungen werden nicht gelöscht; sie kommen zurück, wenn du zur Wanderimkerei wechselst.';

  @override
  String get onboardingMigratoryTitle => 'Wanderst du mit deinen Völkern?';

  @override
  String get onboardingMigratoryMessage =>
      'Wenn nicht, werden Wanderpläne und Wanderungen ausgeblendet; das kannst du jederzeit im Betriebsprofil ändern.';

  @override
  String get onboardingMigratoryYes => 'Ja';

  @override
  String get onboardingMigratoryNo => 'Nein, Standimkerei';

  @override
  String get settingsDeleteAccount => 'Mein Konto löschen';

  @override
  String get settingsDeleteAccountOffline =>
      'Zum Löschen deines Kontos brauchst du eine Internetverbindung; versuche es erneut, wenn du online bist.';

  @override
  String get deletionTitle => 'Mein Konto löschen';

  @override
  String deletionStepCounter(int current, int total) {
    return 'Schritt $current von $total';
  }

  @override
  String get deletionContinue => 'Weiter';

  @override
  String get deletionSoloTitle => 'Dein Konto und dein Betrieb werden gelöscht';

  @override
  String deletionSoloMessage(String organization) {
    return 'Du bist die einzige Person in $organization. Mit deinem Konto werden auch der Betrieb und alle seine Einträge gelöscht.';
  }

  @override
  String get deletionCountsLabel => 'Einträge, die gelöscht werden';

  @override
  String get deletionCountHives => 'Völker';

  @override
  String get deletionCountApiaries => 'Bienenstände';

  @override
  String get deletionCountInspections => 'Durchsichten';

  @override
  String get deletionCountHarvests => 'Ernten';

  @override
  String get deletionCountDocuments => 'Dokumente';

  @override
  String get deletionCountPhotos => 'Fotos';

  @override
  String get deletionLotWarningTitle =>
      'QR-Codes funktionieren dann nicht mehr.';

  @override
  String deletionLotWarningMessage(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other:
          '$count öffentliche Chargenseiten werden gelöscht, und die QR-Codes auf deinen Gläsern funktionieren nicht mehr.',
      one: '1 öffentliche Chargenseite wird gelöscht, und die QR-Codes auf deinen Gläsern funktionieren nicht mehr.',
    );
    return '$_temp0';
  }

  @override
  String get deletionTeamTitle =>
      'Du hast ein Team: Entscheide, was mit dem Betrieb geschieht';

  @override
  String deletionTeamMessage(int count, String organization) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other:
          'Dir gehört $organization, und $count weitere Personen sind im Team.',
      one: 'Dir gehört $organization, und 1 weitere Person ist im Team.',
    );
    return '$_temp0';
  }

  @override
  String get deletionChoiceTransfer => 'Inhaberschaft übertragen und gehen';

  @override
  String get deletionChoiceTransferHint =>
      'Der Betrieb und seine Einträge bleiben. Der gewählte Partner wird Inhaber; nur dein Konto wird gelöscht.';

  @override
  String get deletionChoiceDelete => 'Betrieb und alle Einträge löschen';

  @override
  String deletionChoiceDeleteHint(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other:
          'Die $count anderen Personen im Team verlieren ebenfalls den Zugriff.',
      one: 'Die andere Person im Team verliert ebenfalls den Zugriff.',
    );
    return '$_temp0';
  }

  @override
  String get deletionTransferPick => 'Neuer Inhaber';

  @override
  String get deletionTransferNoPartner =>
      'Für eine Übertragung muss jemand im Team Partner sein. Mache ein Mitglied im Team-Bildschirm zum Partner oder lösche den Betrieb.';

  @override
  String get deletionPartnerFallbackName => 'Partner';

  @override
  String get deletionMemberTitle => 'Nur dein Konto wird gelöscht';

  @override
  String deletionMemberMessage(String organization) {
    return '$organization und seine Einträge werden nicht gelöscht. Deine Einträge bleiben beim Betrieb; dein Name wird aus dem Team entfernt.';
  }

  @override
  String get deletionUnknownMessage =>
      'Deine Mitgliedschaft ist noch nicht auf diesem Telefon. Versuche es nach der Synchronisierung erneut.';

  @override
  String get deletionGraceNote =>
      'Die Löschung wird nach 7 Tagen endgültig; bis dahin kannst du dich anmelden und es dir anders überlegen.';

  @override
  String get deletionBackupTitle => 'Sichere zuerst deine Daten';

  @override
  String get deletionBackupMessage =>
      'Gelöschte Einträge lassen sich nicht wiederherstellen. Wir empfehlen, zuerst eine Kopie zu speichern.';

  @override
  String get deletionBackupReports => 'PDF-Berichte';

  @override
  String get deletionBackupReportsHint =>
      'Lade fertige Berichte als PDF herunter.';

  @override
  String get deletionBackupJson => 'Alle Einträge';

  @override
  String get deletionBackupJsonValue => 'JSON';

  @override
  String get deletionBackupJsonHint =>
      'Alle deine Einträge in einer Datei; speichere sie, wo du willst.';

  @override
  String get deletionBackupSaved => 'Gespeichert';

  @override
  String get deletionBackupDownload => 'Meine Einträge herunterladen';

  @override
  String get deletionBackupSkip => 'Überspringen';

  @override
  String deletionBackupFileName(String date) {
    return 'mobil-arici-eintraege-$date';
  }

  @override
  String get deletionVerifyTitle => 'Bestätige, dass du es bist';

  @override
  String get deletionVerifyButton => 'Code prüfen';

  @override
  String get deletionConfirmTitle => 'Letzte Bestätigung';

  @override
  String get deletionConfirmIntro => 'Wenn du bestätigst:';

  @override
  String deletionConsequenceAccount(String date) {
    return 'Dein Konto wird am $date endgültig gelöscht.';
  }

  @override
  String deletionConsequenceOrganization(String organization) {
    return '$organization und alle seine Einträge werden ebenfalls gelöscht.';
  }

  @override
  String deletionConsequenceTransfer(String name, String organization) {
    return '$name wird neuer Inhaber von $organization.';
  }

  @override
  String get deletionConsequenceRecordsStay =>
      'Die Einträge des Betriebs werden nicht gelöscht.';

  @override
  String deletionConsequenceLots(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other:
          '$count Chargenseiten werden geschlossen; ihre QR-Codes funktionieren nicht mehr.',
      one: '1 Chargenseite wird geschlossen; ihre QR-Codes funktionieren nicht mehr.',
    );
    return '$_temp0';
  }

  @override
  String get deletionConsequenceSignOut =>
      'Du wirst abgemeldet, und die Daten auf diesem Telefon werden entfernt.';

  @override
  String get deletionConsequenceCancel =>
      'Wenn du dich vorher anmeldest, kannst du die Löschung abbrechen.';

  @override
  String deletionConfirmTypeName(String organization) {
    return 'Gib zur Bestätigung den Namen des Betriebs ein: $organization';
  }

  @override
  String deletionConfirmTypeKeyword(String keyword) {
    return 'Gib zur Bestätigung $keyword ein';
  }

  @override
  String get deletionKeyword => 'LÖSCHEN';

  @override
  String get deletionConfirmButton => 'Mein Konto löschen';

  @override
  String get deletionConfirmButtonWithOrganization =>
      'Mein Konto und meinen Betrieb löschen';

  @override
  String get deletionSubmitting => 'Wird gesendet …';

  @override
  String get deletionFailureNetwork =>
      'Server nicht erreichbar. Prüfe deine Verbindung und versuche es erneut.';

  @override
  String get deletionFailureOwnerMustTransfer =>
      'Dir gehört noch ein weiterer Betrieb mit Team. Übertrage dort zuerst die Inhaberschaft.';

  @override
  String get deletionFailureInvalidTransfer =>
      'Die gewählte Person ist kein Partner mehr. Wähle einen anderen Partner.';

  @override
  String get deletionFailureRateLimited =>
      'Zu viele Versuche in kurzer Zeit. Versuche es morgen erneut.';

  @override
  String get deletionFailureForbidden =>
      'Deine Sitzung ist abgelaufen. Melde dich erneut an und versuche es noch einmal.';

  @override
  String get deletionFailureCodeRequired =>
      'Deine Bestätigung ist abgelaufen. Fordere einen neuen Code an und bestätige erneut.';

  @override
  String get deletionFailureUnknown =>
      'Die Anfrage konnte nicht gesendet werden. Versuche es in Kürze erneut.';

  @override
  String get deletionDoneTitle => 'Wir haben deine Anfrage erhalten';

  @override
  String deletionDoneDate(String date) {
    return 'Dein Konto wird am $date endgültig gelöscht.';
  }

  @override
  String get deletionDoneCancelHint =>
      'Wenn du es dir anders überlegst, melde dich vorher an, dann wird die Löschung abgebrochen.';

  @override
  String get deletionDoneEmail =>
      'Wir haben dir die Details auch per E-Mail geschickt.';

  @override
  String get deletionDoneClearing =>
      'Die Daten auf diesem Telefon werden entfernt …';

  @override
  String get deletionDoneSignedOut =>
      'Du wurdest abgemeldet, und die Daten auf diesem Telefon wurden entfernt.';

  @override
  String get deletionDoneAction => 'Fertig';

  @override
  String get deletionPendingTitle => 'Dein Konto wird bald gelöscht';

  @override
  String deletionPendingMessage(String date) {
    return 'Dein Konto wird am $date gelöscht. Wenn du fortfährst, wird die Löschung abgebrochen.';
  }

  @override
  String get deletionPendingContinue => 'Fortfahren und Konto behalten';

  @override
  String get deletionPendingSignOut => 'Abmelden und Löschung beibehalten';

  @override
  String get deletionPendingCancelled =>
      'Löschung abgebrochen. Willkommen zurück!';

  @override
  String get deletionPendingCancelFailed =>
      'Die Löschung konnte nicht abgebrochen werden. Prüfe deine Verbindung und versuche es erneut.';

  @override
  String teamMemberLeaving(String date) {
    return 'Löscht sein Konto · $date';
  }

  @override
  String get teamErrorMemberLeaving =>
      'Diese Person löscht gerade ihr Konto; während der Wartezeit kann ihre Rolle nicht geändert und sie nicht entfernt werden.';
}
