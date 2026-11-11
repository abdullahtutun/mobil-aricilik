// ignore: unused_import
import 'package:intl/intl.dart' as intl;

import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Ukrainian (`uk`).
class AppLocalizationsUk extends AppLocalizations {
  AppLocalizationsUk([String locale = 'uk']) : super(locale);

  @override
  String get appTitle => 'Mobil Arıcı';

  @override
  String get listSeparator => ',';

  @override
  String get stepperIncrease => 'Збільшити';

  @override
  String get stepperDecrease => 'Зменшити';

  @override
  String hiveTileLabel(String number) {
    return 'Вулик $number';
  }

  @override
  String hiveTileStrength(int strength) {
    return 'Сила $strength з 5';
  }

  @override
  String hiveTileQueenColor(String color) {
    String _temp0 = intl.Intl.selectLogic(color, {
      'white': 'білий',
      'yellow': 'жовтий',
      'red': 'червоний',
      'green': 'зелений',
      'blue': 'синій',
      'other': 'невідомий',
    });
    return 'Колір матки $_temp0';
  }

  @override
  String get tabToday => 'Сьогодні';

  @override
  String get tabApiaries => 'Пасіки';

  @override
  String get tabTasks => 'Завдання';

  @override
  String get tabMore => 'Ще';

  @override
  String get todayEmptyTitle => 'Почніть із додавання пасіки';

  @override
  String get todayEmptyMessage =>
      'Три кроки — і все готово: додайте пасіку, створіть вулики, проведіть перший огляд.';

  @override
  String get apiariesEmptyTitle => 'Пасік поки немає';

  @override
  String get apiariesEmptyMessage =>
      'Пасіка об\'єднує вулики за місцем, де вони стоять; додайте першу, щоб почати.';

  @override
  String get apiariesAdd => 'Додати пасіку';

  @override
  String get apiariesAddFirst => 'Додайте першу пасіку';

  @override
  String get apiariesLoadError => 'Не вдалося прочитати пасіки.';

  @override
  String get apiariesViewList => 'Список';

  @override
  String get apiariesViewMap => 'Мапа';

  @override
  String get apiariesMapOfflineTitle => 'Мапа недоступна';

  @override
  String get apiariesMapOfflineMessage =>
      'Для мапи потрібен інтернет. Ваші пасіки перелічено нижче.';

  @override
  String get apiariesMapNoLocation =>
      'Жодна пасіка ще не має розташування. Відредагуйте пасіку, щоб взяти розташування з GPS або вибрати його на мапі.';

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
      other: '$count вулика потребують уваги',
      many: '$count вуликів потребують уваги',
      few: '$count вулики потребують уваги',
      one: '$count вулик потребує уваги',
    );
    return '$_temp0';
  }

  @override
  String get apiaryMapDirections => 'Маршрут';

  @override
  String get apiaryMapShow => 'Показати';

  @override
  String get apiaryMapDirectionsFailed => 'Не вдалося відкрити застосунок мап.';

  @override
  String get apiaryMapDirectionsChooseApp => 'Прокласти маршрут у';

  @override
  String apiaryHiveCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count вулика',
      many: '$count вуликів',
      few: '$count вулики',
      one: '$count вулик',
      zero: 'Немає вуликів',
    );
    return '$_temp0';
  }

  @override
  String apiaryLastVisit(String date) {
    return 'Останній візит $date';
  }

  @override
  String get apiaryNoVisit => 'Візитів ще не було';

  @override
  String get apiaryEdit => 'Змінити';

  @override
  String get apiaryDelete => 'Видалити пасіку';

  @override
  String get apiaryDeleteTitle => 'Видалити цю пасіку?';

  @override
  String get apiaryDeleteMessage => 'Пасіку буде видалено з усіх телефонів.';

  @override
  String apiaryDeleteWithHivesMessage(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other:
          'На цій пасіці $count вулика. Пасіку та її вулики буде видалено з усіх телефонів.',
      many:
          'На цій пасіці $count вуликів. Пасіку та її вулики буде видалено з усіх телефонів.',
      few:
          'На цій пасіці $count вулики. Пасіку та її вулики буде видалено з усіх телефонів.',
      one:
          'На цій пасіці $count вулик. Пасіку та її вулики буде видалено з усіх телефонів.',
    );
    return '$_temp0';
  }

  @override
  String get apiaryDeleted => 'Пасіку видалено';

  @override
  String get apiaryNotFoundTitle => 'Пасіку не знайдено';

  @override
  String get apiaryNotFoundMessage =>
      'Можливо, її видалено або вона ще не з\'явилася на цьому пристрої.';

  @override
  String get apiaryFormNewTitle => 'Нова пасіка';

  @override
  String get apiaryFormEditTitle => 'Змінити пасіку';

  @override
  String get apiaryFormName => 'Назва пасіки';

  @override
  String get apiaryFormNameHint => 'наприклад, На пагорбі';

  @override
  String get apiaryFormLocation => 'Розташування';

  @override
  String get apiaryFormLocationNone =>
      'Розташування поки немає. Якщо ви на пасіці, візьміть його з GPS — інтернет не потрібен; інакше виберіть на мапі.';

  @override
  String get apiaryFormLocationTake => 'Взяти розташування з GPS';

  @override
  String get apiaryFormLocationRetake => 'Взяти розташування знову';

  @override
  String get apiaryFormLocationClear => 'Видалити розташування';

  @override
  String get apiaryFormLocationPickOnMap => 'Вибрати на мапі';

  @override
  String get locationPickerTitle => 'Вибір місця на мапі';

  @override
  String get locationPickerSearchHint => 'Знайти населений пункт або місце';

  @override
  String get locationPickerSearch => 'Знайти';

  @override
  String get locationPickerHint =>
      'Посуньте мапу, щоб позначка опинилася на пасіці.';

  @override
  String get locationPickerPinLabel => 'Вибране місце';

  @override
  String get locationPickerConfirm => 'Використати це місце';

  @override
  String get locationPickerNoResults =>
      'Нічого не знайдено. Спробуйте іншу назву.';

  @override
  String get locationPickerSearchOffline =>
      'Не вдалося виконати пошук. Для пошуку потрібен інтернет.';

  @override
  String get locationPickerMapOfflineMessage =>
      'Для мапи потрібен інтернет. Якщо ви на пасіці, візьміть розташування з GPS.';

  @override
  String get apiaryFormLocating =>
      'Визначаємо розташування… На відкритому місці швидше.';

  @override
  String apiaryFormLocationAccuracy(int meters) {
    return 'Точність ±$meters м';
  }

  @override
  String get apiaryFormLocationErrorServiceDisabled =>
      'Геолокацію на цьому пристрої вимкнено. Увімкніть її та спробуйте знову.';

  @override
  String get apiaryFormLocationErrorPermissionDenied =>
      'Немає дозволу на геолокацію. Дозвольте її, щоб взяти розташування.';

  @override
  String get apiaryFormLocationErrorPermissionDeniedForever =>
      'Дозвіл на геолокацію вимкнено. Дозвольте геолокацію для цього застосунку в налаштуваннях.';

  @override
  String get apiaryFormLocationErrorTimeout =>
      'Не вдалося визначити розташування. Спробуйте знову на відкритому місці.';

  @override
  String get apiaryFormLocationErrorUnknown =>
      'Не вдалося отримати розташування. Спробуйте знову.';

  @override
  String get apiaryFormOpenSettings => 'Відкрити налаштування';

  @override
  String get apiaryFormNotes => 'Нотатки';

  @override
  String get apiaryFormSave => 'Зберегти';

  @override
  String get hiveSortWeakestFirst => 'Спочатку слабкі';

  @override
  String get hivesEmptyTitle => 'Вуликів поки немає';

  @override
  String get hivesEmptyMessage =>
      'Додайте вулики, що стоять на цій пасіці; можна створити багато одразу.';

  @override
  String get hivesAdd => 'Додати вулики';

  @override
  String get hivesAddOne => 'Один вулик';

  @override
  String get hivesAddOneHint => 'Вкажіть номер, тип і походження';

  @override
  String get hivesAddBulk => 'Багато одразу';

  @override
  String get hivesAddBulkHint => 'наприклад, 20 вуликів починаючи з 101';

  @override
  String hivesInactiveTitle(int count) {
    return 'Неактивні ($count)';
  }

  @override
  String get hivesLoadError => 'Не вдалося прочитати вулики.';

  @override
  String hiveLabel(String number) {
    return 'Вулик $number';
  }

  @override
  String hiveTypeAndSource(String type, String source) {
    return '$type · $source';
  }

  @override
  String get hiveTypeLangstroth => 'Лангстрот';

  @override
  String get hiveTypeDadant => 'Дадан';

  @override
  String get hiveTypeLocal => 'Місцевий';

  @override
  String get hiveTypeOther => 'Інший';

  @override
  String get hiveStatusActive => 'Активний';

  @override
  String get hiveStatusDead => 'Загинув';

  @override
  String get hiveStatusMerged => 'Об\'єднаний';

  @override
  String get hiveStatusSold => 'Проданий';

  @override
  String get hiveStatusLost => 'Втрачений';

  @override
  String get hiveSourceSwarm => 'Рій';

  @override
  String get hiveSourceSplit => 'Відводок';

  @override
  String get hiveSourcePurchase => 'Куплений';

  @override
  String get hiveSourcePackage => 'Бджолопакет';

  @override
  String get hiveFormNewTitle => 'Новий вулик';

  @override
  String get hiveFormEditTitle => 'Змінити вулик';

  @override
  String get hiveFormNumber => 'Номер вулика';

  @override
  String get hiveFormNumberHint => 'наприклад, 101';

  @override
  String get hiveFormType => 'Тип вулика';

  @override
  String get hiveFormStatus => 'Статус';

  @override
  String get hiveFormSource => 'Походження';

  @override
  String get hiveFormSave => 'Зберегти';

  @override
  String get hiveBulkTitle => 'Створити багато вуликів';

  @override
  String get hiveBulkCount => 'Скільки вуликів';

  @override
  String get hiveBulkCountHint => 'наприклад, 20';

  @override
  String hiveBulkCountTooMany(int max) {
    return 'Не більше $max за раз';
  }

  @override
  String get hiveBulkStart => 'Перший номер';

  @override
  String get hiveBulkStartHint => 'наприклад, 101';

  @override
  String hiveBulkPreview(int count, String first, String last) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Буде створено $count вулика: з $first по $last.',
      many: 'Буде створено $count вуликів: з $first по $last.',
      few: 'Буде створено $count вулики: з $first по $last.',
      one: 'Буде створено $count вулик: з $first по $last.',
    );
    return '$_temp0';
  }

  @override
  String get hiveBulkSave => 'Створити вулики';

  @override
  String hiveBulkCreated(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Створено $count вулика',
      many: 'Створено $count вуликів',
      few: 'Створено $count вулики',
      one: 'Створено $count вулик',
    );
    return '$_temp0';
  }

  @override
  String get hiveNotFoundTitle => 'Вулик не знайдено';

  @override
  String get hiveNotFoundMessage =>
      'Можливо, його видалено або він ще не з\'явився на цьому пристрої.';

  @override
  String get hiveEdit => 'Змінити';

  @override
  String get hiveDelete => 'Видалити вулик';

  @override
  String hiveDeleteTitle(String number) {
    return 'Видалити вулик $number?';
  }

  @override
  String get hiveDeleteMessage =>
      'Вулик і його записи буде видалено з усіх телефонів.';

  @override
  String hiveDeleted(String number) {
    return 'Вулик $number видалено';
  }

  @override
  String hiveCardApiary(String name) {
    return 'Пасіка: $name';
  }

  @override
  String get hiveQueenTitle => 'Матка';

  @override
  String hiveQueenStripTitle(String queen) {
    return 'Матка · $queen';
  }

  @override
  String hiveStrengthBadge(String level, int strength) {
    return '$level · $strength/5';
  }

  @override
  String get hiveStrengthWeak => 'Слабка';

  @override
  String get hiveStrengthMedium => 'Середня';

  @override
  String get hiveStrengthStrong => 'Сильна';

  @override
  String get hiveStrengthNone => 'Оцінки сили поки немає';

  @override
  String get hiveTimelineTitle => 'Історія';

  @override
  String get timelineInspection => 'Огляд';

  @override
  String get timelineAdded => 'Поставлено на пасіку';

  @override
  String get timelineMoved => 'Перевезено';

  @override
  String timelineMoveRoute(String from, String to) {
    return '$from → $to';
  }

  @override
  String get timelineUnknownApiary => 'Невідома пасіка';

  @override
  String timelineField(String label, String value) {
    return '$label: $value';
  }

  @override
  String timelineBeeFrames(int count) {
    return '$count з бджолами';
  }

  @override
  String timelineBroodFrames(int count) {
    return '$count з розплодом';
  }

  @override
  String timelineHoneyFrames(int count) {
    return '$count з медом';
  }

  @override
  String get timelineActions => 'Зроблено';

  @override
  String get hiveMove => 'Перевезти на іншу пасіку';

  @override
  String hiveMoveTitle(String number) {
    return 'Перевезти вулик $number на';
  }

  @override
  String get hiveMoveNoOtherApiary =>
      'Немає іншої пасіки для перевезення. Спочатку додайте її на вкладці «Пасіки».';

  @override
  String hiveMoved(String number, String apiary) {
    return 'Вулик $number перевезено на $apiary';
  }

  @override
  String get hiveChangeStatus => 'Змінити статус';

  @override
  String hiveStatusSheetTitle(String number) {
    return 'Новий статус вулика $number';
  }

  @override
  String hiveStatusConfirmTitle(String status, String number) {
    String _temp0 = intl.Intl.selectLogic(status, {
      'dead': 'Записати вулик $number як загиблий?',
      'merged': 'Записати вулик $number як об\'єднаний?',
      'sold': 'Записати вулик $number як проданий?',
      'other': 'Записати вулик $number як втрачений?',
    });
    return '$_temp0';
  }

  @override
  String get hiveStatusConfirmMessage =>
      'Він більше не враховуватиметься серед активних вуликів пасіки. Пізніше його можна знову зробити активним.';

  @override
  String get hiveStatusConfirm => 'Так, записати';

  @override
  String hiveStatusChanged(String number, String status) {
    return 'Вулик $number: $status';
  }

  @override
  String get tasksEmptyTitle => 'Завдань поки немає';

  @override
  String get tasksEmptyMessage =>
      'Тут за датами будуть ваші нагадування та завдання.';

  @override
  String get scanTitle => 'Сканувати';

  @override
  String get scanLongPressHint => 'відкрити меню швидкого запису';

  @override
  String get scanHint => 'Помістіть код з етикетки вулика в рамку.';

  @override
  String get scanAgain => 'Сканувати знову';

  @override
  String get cameraErrorTitle => 'Не вдалося відкрити камеру';

  @override
  String get cameraErrorPermissionDenied =>
      'Немає дозволу на камеру. Щоб сканувати етикетки, дозвольте камеру для цього застосунку в налаштуваннях.';

  @override
  String get cameraErrorUnsupported =>
      'На цьому пристрої немає камери, яка може сканувати.';

  @override
  String get cameraErrorUnknown => 'Закрийте цей екран і спробуйте знову.';

  @override
  String get labelUnknownTitle => 'Цей код не прив\'язано до вулика';

  @override
  String get labelUnknownMessage =>
      'Це не етикетка Mobil Arıcı або її ще не прив\'язано до вулика. Якщо вона на вулику, прив\'яжіть її; тоді під час сканування відкриється картка вулика.';

  @override
  String get labelUnknownOwnTitle => 'Вулик із цією етикеткою не знайдено';

  @override
  String get labelUnknownOwnMessage =>
      'Можливо, вулик видалено або він ще не з\'явився на цьому телефоні. Етикетку можна прив\'язати й до іншого вулика.';

  @override
  String labelCode(String code) {
    return 'Код: $code';
  }

  @override
  String get labelAssign => 'Прив\'язати до вулика';

  @override
  String get labelAssignTitle => 'Прив\'язати етикетку до вулика';

  @override
  String get labelAssignMessage =>
      'Виберіть вулик, на якому етикетка. Тоді під час сканування відкриється картка цього вулика.';

  @override
  String get labelAssignSearch => 'Номер вулика';

  @override
  String get labelAssignNoMatch => 'Жоден вулик не відповідає пошуку.';

  @override
  String get labelAssignNoHives =>
      'Вуликів поки немає. Спочатку додайте вулики на вкладці «Пасіки».';

  @override
  String get labelAssignHasOther => 'Має іншу етикетку';

  @override
  String labelReplaceTitle(String number) {
    return 'Замінити етикетку вулика $number?';
  }

  @override
  String get labelReplaceMessage =>
      'Цей вулик уже має етикетку. Нова замінить її; стара більше не відкриватиме цей вулик.';

  @override
  String get labelReplaceConfirm => 'Так, замінити';

  @override
  String labelAssigned(String number) {
    return 'Етикетку прив\'язано: вулик $number';
  }

  @override
  String get hiveLabelsTitle => 'Друк етикеток';

  @override
  String get hiveLabelsMessage =>
      'Виберіть вулики, для яких треба надрукувати етикетки. На аркуші A4 вміщується 24 етикетки (70 × 37 мм); друкуйте в масштабі 100%.';

  @override
  String get hiveLabelsNoHives =>
      'На цій пасіці немає вуликів для друку етикеток.';

  @override
  String get hiveLabelsSelectAll => 'Вибрати всі';

  @override
  String get hiveLabelsSelectNone => 'Зняти вибір';

  @override
  String get hiveLabelsNoneSelected => 'Вулики не вибрано';

  @override
  String hiveLabelsCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count етикетки',
      many: '$count етикеток',
      few: '$count етикетки',
      one: '$count етикетка',
    );
    return '$_temp0';
  }

  @override
  String hiveLabelsPages(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count сторінки',
      many: '$count сторінок',
      few: '$count сторінки',
      one: '$count сторінка',
    );
    return '$_temp0';
  }

  @override
  String hiveLabelsSummary(String labels, String pages) {
    return '$labels · $pages';
  }

  @override
  String get hiveLabelsPreparing => 'Готуємо PDF…';

  @override
  String get hiveLabelsPrint => 'Друк';

  @override
  String get hiveLabelsShare => 'Поділитися PDF';

  @override
  String hiveLabelsDocumentName(String apiary) {
    return 'Етикетки вуликів - $apiary';
  }

  @override
  String get hiveLabelsError => 'Не вдалося підготувати PDF. Спробуйте знову.';

  @override
  String get quickRecordTitle => 'Швидкий запис';

  @override
  String get quickRecordInspection => 'Огляд';

  @override
  String get quickRecordFeeding => 'Підгодівля';

  @override
  String get quickRecordTreatment => 'Обробка';

  @override
  String get quickRecordHarvest => 'Медозбір';

  @override
  String get quickRecordNote => 'Нотатка';

  @override
  String get quickRecordExpense => 'Витрата';

  @override
  String get quickRecordComingSoon => 'Цей тип запису скоро з\'явиться.';

  @override
  String get signInSendCode => 'Надіслати код';

  @override
  String get signInSending => 'Надсилаємо…';

  @override
  String signInCodeMessage(String email) {
    return 'Ми надіслали 6-значний код на $email.';
  }

  @override
  String get signInCodeFieldLabel => '6-значний код';

  @override
  String get signInVerify => 'Увійти';

  @override
  String get signInVerifying => 'Перевіряємо…';

  @override
  String get signInResend => 'Надіслати код ще раз';

  @override
  String signInResendIn(int seconds) {
    return 'Надіслати код ще раз ($seconds с)';
  }

  @override
  String get signInCodeResent => 'Новий код уже в дорозі.';

  @override
  String get authErrorNetwork =>
      'Немає з\'єднання. Перевірте інтернет і спробуйте знову.';

  @override
  String get authErrorInvalidEmail => 'Введіть коректну адресу ел. пошти.';

  @override
  String get authErrorInvalidCode =>
      'Код неправильний або застарів. Спробуйте знову або запросіть новий код.';

  @override
  String get authErrorTooManyRequests =>
      'Забагато спроб. Зачекайте трохи й спробуйте знову.';

  @override
  String get authErrorUnknown => 'Щось пішло не так. Спробуйте знову.';

  @override
  String get settingsTitle => 'Налаштування';

  @override
  String get settingsSystemDefault => 'Як у системі';

  @override
  String get settingsLanguage => 'Мова';

  @override
  String get settingsColorMode => 'Тема';

  @override
  String get settingsColorModeLight => 'Світла';

  @override
  String get settingsColorModeDark => 'Темна';

  @override
  String get settingsColorModeSun => 'Сонце';

  @override
  String get settingsAccount => 'Обліковий запис';

  @override
  String settingsSignedInAs(String email) {
    return 'Ви увійшли як $email';
  }

  @override
  String get settingsPrivacyPolicy => 'Політика конфіденційності';

  @override
  String settingsVersion(String version) {
    return 'Версія $version';
  }

  @override
  String get settingsSignOut => 'Вийти';

  @override
  String get settingsSignOutConfirmTitle => 'Вийти?';

  @override
  String get settingsSignOutConfirmMessage =>
      'Щоб увійти знову, знадобиться новий код на пошту, а для цього потрібен інтернет.';

  @override
  String get actionCancel => 'Скасувати';

  @override
  String get actionDelete => 'Видалити';

  @override
  String get actionRetry => 'Повторити';

  @override
  String get actionUndo => 'Скасувати';

  @override
  String onboardingStepCounter(int current, int total) {
    return 'Крок $current з $total';
  }

  @override
  String get onboardingContinue => 'Продовжити';

  @override
  String get onboardingFinish => 'Створити господарство';

  @override
  String get onboardingFinishing => 'Налаштовуємо…';

  @override
  String get onboardingCountrySearch => 'Пошук країни';

  @override
  String get onboardingCountrySuggested => 'Запропоновано для вашого пристрою';

  @override
  String get onboardingCountryAll => 'Усі країни';

  @override
  String get onboardingCountryNoMatch => 'Жодна країна не відповідає пошуку.';

  @override
  String get onboardingNameMessage => 'Ця назва буде у ваших записах і звітах.';

  @override
  String get onboardingNameLabel => 'Назва господарства';

  @override
  String get onboardingNameHint => 'наприклад, Пасіка «Золоті стільники»';

  @override
  String get onboardingHiveCountTitle => 'Скільки у вас вуликів?';

  @override
  String get onboardingHiveCountMessage =>
      'Досить приблизного числа; ми підкажемо, як їх вести. Самі вулики ви додасте пізніше.';

  @override
  String get hiveCountRangeNone => 'Поки немає';

  @override
  String get hiveCountRangeUpTo10 => '1–10';

  @override
  String get hiveCountRangeUpTo50 => '11–50';

  @override
  String get hiveCountRangeUpTo200 => '51–200';

  @override
  String get hiveCountRangeOver200 => 'Понад 200';

  @override
  String get onboardingApiaryTitle => 'Додайте першу пасіку';

  @override
  String get onboardingApiaryMessage =>
      'Пасіка — це місце, де стоять ваші вулики. Для збереження інтернет не потрібен.';

  @override
  String get onboardingApiarySave => 'Зберегти пасіку';

  @override
  String get onboardingApiarySkip => 'Поки пропустити';

  @override
  String get onboardingLoading => 'Завантажуємо ваше господарство';

  @override
  String get onboardingLoadErrorTitle => 'Не вдалося завантажити господарство';

  @override
  String get onboardingErrorNetwork =>
      'Немає з\'єднання. Перевірте інтернет і спробуйте знову.';

  @override
  String get onboardingErrorUnknown => 'Щось пішло не так. Спробуйте знову.';

  @override
  String get devMenuTitle => 'Меню розробника';

  @override
  String get componentGalleryTitle => 'Галерея компонентів';

  @override
  String get componentGalleryDescription =>
      'Компоненти дизайн-системи в чотирьох темах';

  @override
  String get galleryThemeLight => 'Світла';

  @override
  String get galleryThemeDark => 'Темна';

  @override
  String get galleryThemeSun => 'Сонце';

  @override
  String get galleryThemeGlove => 'Рукавички';

  @override
  String get galleryBigButton => 'Велика кнопка';

  @override
  String get galleryChoiceChipGroup => 'Чипи вибору';

  @override
  String get galleryBigStepper => 'Великий лічильник';

  @override
  String get galleryStatusBadge => 'Значок статусу';

  @override
  String get galleryHiveTile => 'Плитка вулика';

  @override
  String get galleryEmptyState => 'Порожній стан';

  @override
  String get gallerySectionCard => 'Картка розділу';

  @override
  String get galleryStrengthDots => 'Точки сили';

  @override
  String get galleryTimelineTile => 'Рядок історії';

  @override
  String get gallerySampleApiaryHill => 'На пагорбі';

  @override
  String get gallerySampleApiaryPlain => 'Біля річки';

  @override
  String get gallerySampleStartInspection => 'Почати огляд';

  @override
  String get gallerySampleAddPhoto => 'Додати фото';

  @override
  String get gallerySampleSave => 'Зберегти';

  @override
  String get gallerySampleQueen => 'Матка';

  @override
  String get gallerySampleQueenSeen => 'Бачили';

  @override
  String get gallerySampleEggs => 'Є яйця';

  @override
  String get gallerySampleNone => 'Немає';

  @override
  String get gallerySampleActions => 'Зроблено';

  @override
  String get gallerySampleSuperAdded => 'Магазин поставлено';

  @override
  String get gallerySampleFrameAdded => 'Рамку додано';

  @override
  String get gallerySampleFed => 'Підгодовано';

  @override
  String get gallerySampleBeeFrames => 'Рамок із бджолами';

  @override
  String get gallerySampleBroodFrames => 'Рамок із розплодом';

  @override
  String get gallerySampleStrong => 'Сильна';

  @override
  String get gallerySampleWeak => 'Слабка';

  @override
  String get gallerySampleQueenless => 'Безматкова';

  @override
  String get gallerySampleTask => 'Завдання';

  @override
  String get gallerySampleNoApiaries => 'Пасік поки немає';

  @override
  String get gallerySampleNoApiariesMessage =>
      'Пасіка об\'єднує вулики за місцем, де вони стоять; додайте першу, щоб почати.';

  @override
  String get gallerySampleAddApiary => 'Додайте першу пасіку';

  @override
  String get gallerySampleLastInspection => 'Останній огляд';

  @override
  String get gallerySampleLastInspectionBody =>
      '3 дні тому · 7 рамок із бджолами · матку бачили';

  @override
  String get gallerySampleUntitledCard =>
      'Картка може бути й без заголовка; вміст починається одразу.';

  @override
  String get gallerySnackBar => 'Snackbar';

  @override
  String get galleryCriticalLockCard => 'Картка критичного блокування';

  @override
  String get gallerySampleInspectionSaved => 'Огляд збережено';

  @override
  String get gallerySampleWithdrawalTitle => 'Триває період очікування.';

  @override
  String get gallerySampleWithdrawalMessage =>
      'Не ставте магазин на цей вулик ще 12 днів.';

  @override
  String get syncStatusSynced => 'Синхронізовано';

  @override
  String syncStatusPending(int count) {
    return 'Очікують: $count';
  }

  @override
  String get syncStatusError => 'Помилка';

  @override
  String syncStatusSemantics(String status) {
    return 'Синхронізація: $status';
  }

  @override
  String get syncTitle => 'Синхронізація';

  @override
  String get syncSyncedMessage =>
      'Усі записи з цього телефона дійшли до сервера.';

  @override
  String syncPendingMessage(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count запису чекають на надсилання.',
      many: '$count записів чекають на надсилання.',
      few: '$count записи чекають на надсилання.',
      one: '$count запис чекає на надсилання.',
    );
    return '$_temp0';
  }

  @override
  String get syncProblemOffline =>
      'Сервер недоступний. Синхронізація повториться, коли з\'явиться інтернет.';

  @override
  String get syncProblemFailed =>
      'Синхронізація не завершилася. Спробуйте трохи пізніше.';

  @override
  String get syncProblemUpgrade =>
      'Ця версія більше не може синхронізуватися. Оновіть застосунок.';

  @override
  String syncLastSynced(String time) {
    return 'Остання синхронізація $time';
  }

  @override
  String get syncNow => 'Синхронізувати';

  @override
  String get syncRunning => 'Синхронізація…';

  @override
  String syncRejectedTitle(int count) {
    return 'Не вдалося надіслати ($count)';
  }

  @override
  String get syncRejectedMessage =>
      'Сервер не прийняв ці записи. Усе інше далі синхронізується.';

  @override
  String syncRejectedSubtitle(String reason, String date) {
    return '$reason · $date';
  }

  @override
  String get syncRejectionForbidden => 'Ви не маєте права змінювати цей запис';

  @override
  String get syncRejectionConflict =>
      'Конфлікт з іншим записом (наприклад, та сама етикетка)';

  @override
  String get syncRejectionMissingReference =>
      'На сервері немає запису, до якого він належить';

  @override
  String get syncRejectionUnsupported => 'Цей тип записів не синхронізується';

  @override
  String get syncRejectionInvalid => 'У записі неправильні дані';

  @override
  String get syncRejectionUnknown => 'Невідома причина';

  @override
  String get syncTableOrganizations => 'Господарство';

  @override
  String get syncTableMemberships => 'Участь';

  @override
  String get syncTableApiaries => 'Пасіка';

  @override
  String get syncTableQueens => 'Матка';

  @override
  String get syncTableHives => 'Вулик';

  @override
  String get syncTableHiveStatusEvents => 'Зміна статусу вулика';

  @override
  String get syncTableHiveLocationHistory => 'Перевезення вулика';

  @override
  String get initialSyncTitle => 'Завантажуємо ваші записи';

  @override
  String get initialSyncMessage =>
      'Записи господарства завантажуються на цей телефон. Це відбувається один раз; потім застосунок працює й без інтернету.';

  @override
  String initialSyncRows(int count) {
    final intl.NumberFormat countNumberFormat =
        intl.NumberFormat.decimalPattern(localeName);
    final String countString = countNumberFormat.format(count);

    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Завантажено $countString запису',
      many: 'Завантажено $countString записів',
      few: 'Завантажено $countString записи',
      one: 'Завантажено $countString запис',
    );
    return '$_temp0';
  }

  @override
  String get initialSyncFailedTitle => 'Завантаження не завершилося';

  @override
  String get suggestedValue => 'З минулого запису';

  @override
  String get stepperNoValue => 'Не задано';

  @override
  String get hiveStartInspection => 'Почати огляд';

  @override
  String inspectionTitle(String number) {
    return 'Огляд вулика $number';
  }

  @override
  String inspectionPrevious(String date) {
    return 'Останній огляд $date';
  }

  @override
  String get inspectionFirst => 'Перший огляд';

  @override
  String get inspectionSuggestedLegend =>
      'Бліді значення — з минулого огляду. Змініть те, що відрізняється; решта збережеться як є.';

  @override
  String get inspectionDraftSaved => 'Збережено як чернетку на цьому телефоні';

  @override
  String get inspectionRestart => 'Почати знову';

  @override
  String get inspectionQueen => 'Матка';

  @override
  String get queenStateSeen => 'Бачили';

  @override
  String get queenStateEggs => 'Бачили яйця';

  @override
  String get queenStateNone => 'Немає';

  @override
  String get inspectionFrames => 'Рамки';

  @override
  String get inspectionBeeFrames => 'З бджолами';

  @override
  String get inspectionBroodFrames => 'З розплодом';

  @override
  String get inspectionHoneyFrames => 'З медом';

  @override
  String get inspectionTemperament => 'Вдача';

  @override
  String get temperamentCalm => 'Спокійні';

  @override
  String get temperamentNervous => 'Нервові';

  @override
  String get inspectionSwarmSigns => 'Ознаки роїння';

  @override
  String get inspectionQueenCells => 'Маточники';

  @override
  String get queenCellsNone => 'Немає';

  @override
  String get queenCellsSwarm => 'Ройові';

  @override
  String get queenCellsSupersedure => 'Тиха заміна';

  @override
  String get queenCellsEmergency => 'Свищеві';

  @override
  String get inspectionDisease => 'Підозра на хворобу';

  @override
  String get inspectionAnswerNo => 'Ні';

  @override
  String get inspectionAnswerYes => 'Так';

  @override
  String get inspectionActions => 'Зроблено сьогодні';

  @override
  String get inspectionActionSuperAdded => 'Магазин поставлено';

  @override
  String get inspectionActionSuperRemoved => 'Магазин знято';

  @override
  String get inspectionActionFramesAdded => 'Рамки додано';

  @override
  String get inspectionActionFoundationAdded => 'Вощину дано';

  @override
  String get inspectionActionFed => 'Підгодовано';

  @override
  String get inspectionActionExcluderFitted =>
      'Розділювальну решітку поставлено';

  @override
  String get inspectionActionEntranceReduced => 'Льоток звужено';

  @override
  String get inspectionActionPollenTrapFitted => 'Пилковловлювач поставлено';

  @override
  String get inspectionSave => 'Зберегти';

  @override
  String inspectionSaved(String number) {
    return 'Огляд вулика $number збережено';
  }

  @override
  String get inspectionRemindPrompt => 'Нагадати через';

  @override
  String inspectionRemindDays(int days) {
    String _temp0 = intl.Intl.pluralLogic(
      days,
      locale: localeName,
      other: '$days дня',
      many: '$days днів',
      few: '$days дні',
      one: '$days день',
    );
    return '$_temp0';
  }

  @override
  String get inspectionLoadError => 'Не вдалося відкрити огляд';

  @override
  String get syncTableInspections => 'Огляд';

  @override
  String get signInTagline => 'Пасічний журнал у кишені. Працює без інтернету.';

  @override
  String get signInEmailLabelLong => 'Ваша адреса ел. пошти';

  @override
  String get signInEmailHelper =>
      'Без пароля. Ми надішлемо 6-значний код на вашу пошту.';

  @override
  String get signInEmailHint => 'name@example.com';

  @override
  String get signInCodeHeading => 'Введіть код із листа';

  @override
  String get signInPasteCode => 'Вставити код';

  @override
  String get signInCodeSpamHint =>
      'Не надійшло? Перевірте папку «Спам». Після першого входу застосунок відкривається й без інтернету.';

  @override
  String get signInChangeEmail => 'Змінити адресу';

  @override
  String get onboardingLanguageCountryTitle => 'Мова та країна';

  @override
  String get onboardingAppLanguage => 'Мова застосунку';

  @override
  String get onboardingDeviceLanguage => 'Мова пристрою';

  @override
  String get onboardingCountryLabel => 'Країна, де ви тримаєте бджіл';

  @override
  String get onboardingCountryChoose => 'Виберіть країну';

  @override
  String onboardingRegionFeaturesTitle(String country) {
    return 'Увімкнено для країни $country';
  }

  @override
  String onboardingRegionDefaultsTitle(String country) {
    return 'Налаштування для країни $country';
  }

  @override
  String get onboardingRegionDefaultsMessage =>
      'Одиниці та валюта залежать від країни.';

  @override
  String get onboardingBusinessTitle => 'Розкажіть про господарство';

  @override
  String get regionFeatureAks => 'дані AKS і реєстрації господарства';

  @override
  String get regionFeatureSubsidies => 'нагадування про субсидії на вулики';

  @override
  String get regionFeatureRegulations => 'огляди законодавства';

  @override
  String get regionFeatureTrDrugList => 'перелік дозволених препаратів';

  @override
  String get regionFeatureTrFlora => 'календар медоносів Туреччини';

  @override
  String get regionFeatureTrMigrationDocs => 'документи для кочівлі';

  @override
  String get unitKilogram => 'кг';

  @override
  String get unitPound => 'фунт';

  @override
  String get unitCelsius => '°C';

  @override
  String get unitFahrenheit => '°F';

  @override
  String get hemisphereNorthern => 'Північна півкуля';

  @override
  String get hemisphereSouthern => 'Південна півкуля';

  @override
  String get relativeToday => 'сьогодні';

  @override
  String get relativeYesterday => 'учора';

  @override
  String relativeDaysAgo(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count дня тому',
      many: '$count днів тому',
      few: '$count дні тому',
      one: '$count день тому',
    );
    return '$_temp0';
  }

  @override
  String apiariesCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count пасіки',
      many: '$count пасік',
      few: '$count пасіки',
      one: '$count пасіка',
    );
    return '$_temp0';
  }

  @override
  String apiariesSummary(String apiaries, String hives) {
    return '$apiaries · $hives';
  }

  @override
  String get apiaryHiveCountUnit => 'вуликів';

  @override
  String get hiveLayoutGridShort => 'Сітка';

  @override
  String get hiveLayoutListShort => 'Список';

  @override
  String apiaryDetailSubtitle(String hives, String visit) {
    return '$hives · $visit';
  }

  @override
  String apiaryDetailSubtitlePlace(String hives, String visit, String place) {
    return '$hives · $visit · $place';
  }

  @override
  String get apiaryBulkFeed => 'Підгодувати всі';

  @override
  String get apiaryBulkTreat => 'Обробити всі';

  @override
  String get hiveCardKind => 'Вулик';

  @override
  String get hiveLastInspection => 'Останній огляд';

  @override
  String get hiveLastInspectionNone => 'Поки немає';

  @override
  String get hiveBulkPreviewTitle => 'Попередній перегляд';

  @override
  String hiveBulkSaveCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Створити $count вулика',
      many: 'Створити $count вуликів',
      few: 'Створити $count вулики',
      one: 'Створити $count вулик',
    );
    return '$_temp0';
  }

  @override
  String get listEllipsis => '…';

  @override
  String get scanOfflineHint =>
      'Інтернет не потрібен · вібрує під час зчитування';

  @override
  String get titleSeparator => ' ·';

  @override
  String get settingsGeneral => 'Загальні';

  @override
  String get settingsGloveMode => 'Режим рукавичок';

  @override
  String get settingsGloveModeHint => 'Усі кнопки стають на крок більшими.';

  @override
  String get settingsCountry => 'Країна';

  @override
  String settingsCountryValue(String name, String code) {
    return '$name · $code';
  }

  @override
  String get moreSectionApiary => 'Пасіка';

  @override
  String get moreSectionBusiness => 'Господарство';

  @override
  String get moreSectionHelp => 'Допомога';

  @override
  String get galleryFormFields => 'Поля форми';

  @override
  String get galleryRadioCardGroup => 'Картки вибору';

  @override
  String get gallerySegmentedTabs => 'Перемикач вигляду';

  @override
  String get galleryListGroup => 'Згрупований список';

  @override
  String get galleryNoteCard => 'Картка нотатки';

  @override
  String get gallerySummaryTile => 'Плитка підсумку';

  @override
  String get galleryActionTile => 'Плитки дій';

  @override
  String get galleryAppLogo => 'Логотип і стільник';

  @override
  String get gallerySampleApiaryName => 'Назва пасіки';

  @override
  String get gallerySampleFirstNumber => 'Перший номер';

  @override
  String get gallerySampleNoteHint =>
      'Без пароля. Ми надішлемо 6-значний код на вашу пошту.';

  @override
  String get gallerySampleGrid => 'Сітка';

  @override
  String get gallerySampleList => 'Список';

  @override
  String get gallerySampleMap => 'Мапа';

  @override
  String get gallerySampleInspections => 'Огляди';

  @override
  String get gallerySampleNoteTitle => 'Увімкнено для Туреччини';

  @override
  String get gallerySampleNoteMessage =>
      'Дані AKS і реєстрації господарства, огляди законодавства та перелік дозволених препаратів.';

  @override
  String get gallerySampleLastInspectionValue => '3 дні тому';

  @override
  String get gallerySampleFrames => '8 рамок із бджолами · 5 із розплодом';

  @override
  String get gallerySampleActiveTreatment => 'Триває обробка';

  @override
  String get gallerySampleDaysLeft => 'лишилося 12 днів';

  @override
  String get syncTableMedia => 'Фото або голосова нотатка';

  @override
  String get mediaTakePhoto => 'Зробити фото';

  @override
  String get mediaRecordVoice => 'Записати голосову нотатку';

  @override
  String get mediaStopRecording => 'Зупинити запис';

  @override
  String mediaRecording(String duration) {
    return 'Запис · $duration';
  }

  @override
  String mediaPhotoAdded(String number) {
    return 'Фото додано до вулика $number';
  }

  @override
  String mediaVoiceAdded(String number) {
    return 'Голосову нотатку додано до вулика $number';
  }

  @override
  String get mediaCameraDenied =>
      'Немає дозволу на камеру. Його можна дати в налаштуваннях телефона.';

  @override
  String get mediaMicrophoneDenied =>
      'Немає дозволу на мікрофон. Його можна дати в налаштуваннях телефона.';

  @override
  String get mediaCaptureFailed => 'Не вдалося зберегти. Спробуйте знову.';

  @override
  String mediaPhotoCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count фото',
      many: '$count фото',
      few: '$count фото',
      one: '$count фото',
    );
    return '$_temp0';
  }

  @override
  String mediaVoiceCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count голосової нотатки',
      many: '$count голосових нотаток',
      few: '$count голосові нотатки',
      one: '$count голосова нотатка',
    );
    return '$_temp0';
  }

  @override
  String inspectionMediaAttached(String items) {
    return 'Збережено з оглядом: $items';
  }

  @override
  String get timelinePhoto => 'Фото';

  @override
  String get timelineVoiceNote => 'Голосова нотатка';

  @override
  String get mediaOpenPhoto => 'Відкрити фото';

  @override
  String get mediaDownloadPhoto =>
      'Фото немає на цьому телефоні. Торкніться, щоб завантажити.';

  @override
  String mediaPlay(String duration) {
    return 'Слухати · $duration';
  }

  @override
  String get mediaStopPlaying => 'Стоп';

  @override
  String get mediaNotUploaded =>
      'Ще не вивантажено. З\'явиться, коли телефон, яким знімали, вийде в мережу.';

  @override
  String get mediaDownloadOffline =>
      'Не вдалося завантажити. Перевірте підключення до інтернету.';

  @override
  String get mediaDownloadFailed => 'Не вдалося завантажити.';

  @override
  String get mediaNotFound => 'Фото не знайдено';

  @override
  String get settingsData => 'Дані';

  @override
  String get settingsMediaWifiOnly => 'Вивантажувати фото лише через Wi‑Fi';

  @override
  String get settingsMediaWifiOnlyHint =>
      'Фото й голосові нотатки не витрачатимуть мобільний трафік.';

  @override
  String settingsPendingUploads(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count файлу чекають на вивантаження',
      many: '$count файлів чекають на вивантаження',
      few: '$count файли чекають на вивантаження',
      one: '$count файл чекає на вивантаження',
    );
    return '$_temp0';
  }

  @override
  String get hiveQueenNone => 'Не записано';

  @override
  String get hiveQueenNoneHint => 'Торкніться, щоб додати матку';

  @override
  String queenMarkColorName(String color) {
    String _temp0 = intl.Intl.selectLogic(color, {
      'white': 'Білий',
      'yellow': 'Жовтий',
      'red': 'Червоний',
      'green': 'Зелений',
      'blue': 'Синій',
      'other': 'Невідомий',
    });
    return '$_temp0';
  }

  @override
  String get queenYearUnknown => 'Рік невідомий';

  @override
  String get queenUnmarked => 'Не позначена';

  @override
  String queenAge(int age) {
    String _temp0 = intl.Intl.pluralLogic(
      age,
      locale: localeName,
      other: '$age року',
      many: '$age років',
      few: '$age роки',
      one: '$age рік',
      zero: 'Менше року',
    );
    return '$_temp0';
  }

  @override
  String get queenSourceOwnRearing => 'Власне виведення';

  @override
  String get queenSourcePurchased => 'Куплена';

  @override
  String get queenSourceCertifiedBreeder => 'Сертифікований маткар';

  @override
  String get queenSource => 'Походження';

  @override
  String get queenMother => 'Мати';

  @override
  String get queenMotherUnknown => 'Невідома';

  @override
  String get queenBreed => 'Порода';

  @override
  String get queenBreedHint => 'наприклад, карпатська';

  @override
  String get queenBreedLine => 'Лінія';

  @override
  String get queenBreedLineHint => 'наприклад, Вучківська';

  @override
  String get queenWing => 'Крило';

  @override
  String get queenWingClipped => 'Підрізане';

  @override
  String get queenWingIntact => 'Не підрізане';

  @override
  String get queenYear => 'Рік';

  @override
  String get queenYearHelper => 'Рік виведення або купівлі';

  @override
  String get queenMark => 'Колір мітки';

  @override
  String queenMarkSuggestion(String year, String color) {
    return 'Колір $year року: $color';
  }

  @override
  String get queenUnknown => 'Не вказано';

  @override
  String get queenEdit => 'Змінити матку';

  @override
  String get queenReplace => 'Замінити матку';

  @override
  String get queenGive => 'Додати матку';

  @override
  String get queenNoneTitle => 'Матку не записано';

  @override
  String get queenNoneMessage =>
      'Запишіть матку, яку ви дали цьому вулику; її рік, колір і походження будуть тут.';

  @override
  String queenFormNewTitle(String number) {
    return 'Нова матка · Вулик $number';
  }

  @override
  String get queenFormEditTitle => 'Змінити матку';

  @override
  String get queenFormSave => 'Зберегти';

  @override
  String queenGiven(String number) {
    return 'У вулику $number нова матка';
  }

  @override
  String get oldQueensTitle => 'Старі матки';

  @override
  String oldQueensIntro(int age) {
    String _temp0 = intl.Intl.pluralLogic(
      age,
      locale: localeName,
      other:
          'Матки активних вуликів віком $age року і більше. Заплануйте заміну.',
      many:
          'Матки активних вуликів віком $age років і більше. Заплануйте заміну.',
      few:
          'Матки активних вуликів віком $age роки і більше. Заплануйте заміну.',
      one: 'Матки активних вуликів віком $age рік і більше. Заплануйте заміну.',
    );
    return '$_temp0';
  }

  @override
  String get oldQueensEmptyTitle => 'Старих маток немає';

  @override
  String oldQueensEmptyMessage(int age) {
    String _temp0 = intl.Intl.pluralLogic(
      age,
      locale: localeName,
      other: 'Матки активних вуликів молодші за $age року або рік не вказано.',
      many: 'Матки активних вуликів молодші за $age років або рік не вказано.',
      few: 'Матки активних вуликів молодші за $age роки або рік не вказано.',
      one: 'Матки активних вуликів молодші за $age рік або рік не вказано.',
    );
    return '$_temp0';
  }

  @override
  String get syncTableMiteCounts => 'Підрахунок кліща';

  @override
  String get varroaMethodSugarRoll => 'Цукрова пудра';

  @override
  String get varroaMethodAlcoholWash => 'Спиртове промивання';

  @override
  String get varroaMethodStickyBoard => 'Липкий вкладиш';

  @override
  String varroaFormTitle(String number) {
    return 'Варроа · Вулик $number';
  }

  @override
  String get varroaMethod => 'Метод';

  @override
  String get varroaSampleBees => 'Бджіл у пробі';

  @override
  String get varroaBoardDays => 'Днів на вкладиші';

  @override
  String get varroaMites => 'Підраховано кліщів';

  @override
  String get varroaBoardMites => 'Обпалих кліщів';

  @override
  String get varroaSave => 'Зберегти';

  @override
  String varroaSaved(String number) {
    return 'Підрахунок кліща для вулика $number збережено';
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

    return '$valueString кліщів/день';
  }

  @override
  String get varroaInfestation => 'Ураженість';

  @override
  String get varroaDailyDrop => 'Добовий обпад';

  @override
  String get varroaReached => 'Поріг досягнуто · заплануйте обробку';

  @override
  String get varroaBelow => 'Нижче порогу';

  @override
  String varroaThresholdNote(String threshold) {
    return 'Поріг $threshold (з налаштувань).';
  }

  @override
  String get hiveVarroa => 'Варроа';

  @override
  String get hiveVarroaNone => 'Підрахунків поки немає';

  @override
  String get hiveVarroaReached => 'Поріг досягнуто';

  @override
  String get hiveVarroaCount => 'Підрахувати кліща';

  @override
  String varroaChartTitle(String apiary) {
    return '$apiary · останні підрахунки';
  }

  @override
  String varroaChartThreshold(String threshold) {
    return 'поріг $threshold';
  }

  @override
  String get varroaChartEmpty =>
      'Підрахунків цукровою пудрою або спиртом поки немає. Додайте підрахунок із картки вулика.';

  @override
  String varroaChartBar(String day, String value) {
    return '$day: $value';
  }

  @override
  String varroaChartSemantics(String threshold, String bars) {
    return 'Середня ураженість за днями, поріг $threshold: $bars';
  }

  @override
  String get settingsVarroa => 'Варроа';

  @override
  String get settingsVarroaPercent => 'Поріг ураженості';

  @override
  String get settingsVarroaPerDay => 'Поріг за вкладишем';

  @override
  String get settingsVarroaHint =>
      'Коли підрахунок досягає порогу, з\'являється попередження. Зберігається лише на цьому телефоні.';

  @override
  String get syncTableRefDrugs => 'Перелік препаратів';

  @override
  String get syncTableDrugs => 'Препарат';

  @override
  String get syncTableTreatments => 'Обробка';

  @override
  String get syncTableFeedings => 'Підгодівля';

  @override
  String get drugIngredientAmitraz => 'Амітраз';

  @override
  String get drugIngredientOxalicAcid => 'Щавлева кислота';

  @override
  String get drugIngredientFormicAcid => 'Мурашина кислота';

  @override
  String get drugIngredientThymol => 'Тимол';

  @override
  String get drugIngredientFlumethrin => 'Флуметрин';

  @override
  String get drugIngredientTauFluvalinate => 'Тау-флувалінат';

  @override
  String get drugIngredientCoumaphos => 'Кумафос';

  @override
  String get drugIngredientLacticAcid => 'Молочна кислота';

  @override
  String get drugIngredientOther => 'Інше';

  @override
  String get drugUnitStrip => 'смужка';

  @override
  String get drugUnitMl => 'мл';

  @override
  String get drugUnitG => 'г';

  @override
  String get drugUnitDose => 'доза';

  @override
  String get hiveTreat => 'Обробити';

  @override
  String get treatmentFormTitle => 'Обробка';

  @override
  String treatmentScopeHive(String number) {
    return 'Вулик $number';
  }

  @override
  String treatmentScopeApiary(int count) {
    return 'Уся пасіка · $count';
  }

  @override
  String get treatmentChooseDrug => 'Вибрати препарат';

  @override
  String get treatmentChangeDrug => 'Змінити';

  @override
  String treatmentDrugIngredient(String ingredient) {
    return 'Діюча речовина: $ingredient';
  }

  @override
  String treatmentDrugLicense(String number) {
    return 'реєстр. № $number';
  }

  @override
  String get treatmentDrugCustom => 'ваш препарат';

  @override
  String get treatmentAddDrug => 'Додати новий препарат';

  @override
  String get drugInfoOpen => 'Відомості про препарат';

  @override
  String get drugInfoSourceTitle =>
      'Джерело: Міністерство сільського та лісового господарства Туреччини';

  @override
  String get drugInfoSourceMessage =>
      'Це взято зі схваленої міністерством інструкції й показано турецькою, як опубліковано. Перед застосуванням прочитайте етикетку; якщо сумніваєтеся, запитайте ветеринара.';

  @override
  String get drugInfoActiveIngredient => 'Діюча речовина';

  @override
  String get drugInfoIndications => 'Застосовується при';

  @override
  String get drugInfoUsage => 'Застосування та частота';

  @override
  String get drugInfoUsageMethod => 'Спосіб застосування';

  @override
  String get drugInfoUsageMethodAndDose => 'Застосування та доза';

  @override
  String get drugInfoUsageDiagnosis => 'Для діагностики';

  @override
  String get drugInfoUsageDose => 'Доза';

  @override
  String get drugInfoUsageFrequency => 'Частота';

  @override
  String get drugInfoUsageDuration => 'Тривалість';

  @override
  String get drugInfoUsageOther => 'Примітка';

  @override
  String get drugInfoSuitablePeriods => 'Придатні періоди';

  @override
  String get drugInfoAvoidPeriods => 'Не застосовувати';

  @override
  String get drugInfoWithdrawal => 'Період очікування';

  @override
  String get drugInfoWarnings => 'Застереження';

  @override
  String get drugInfoClose => 'Закрити';

  @override
  String get treatmentBatchNo => '№ партії';

  @override
  String get treatmentStartedOn => 'Початок';

  @override
  String treatmentDose(String unit) {
    return 'Доза на вулик ($unit)';
  }

  @override
  String treatmentDoseTotal(String total, String unit) {
    return 'Усього $total $unit';
  }

  @override
  String get treatmentWithdrawalDays => 'Період очікування (днів)';

  @override
  String get treatmentRemoval => 'Зняття';

  @override
  String get treatmentRemovalNone => 'Немає';

  @override
  String get treatmentRemovalChange =>
      'Нагадування вранці; торкніться, щоб змінити';

  @override
  String get treatmentRemovalSingle =>
      'Одноразове застосування; торкніться, щоб задати';

  @override
  String get treatmentRemovalClear => 'Без зняття (одноразово)';

  @override
  String get treatmentNoSuper => 'Без магазина';

  @override
  String treatmentNoSuperUntil(String date) {
    return 'До $date';
  }

  @override
  String treatmentNoSuperAfterRemoval(int days) {
    String _temp0 = intl.Intl.pluralLogic(
      days,
      locale: localeName,
      other: 'зняття + $days дня очікування',
      many: 'зняття + $days днів очікування',
      few: 'зняття + $days дні очікування',
      one: 'зняття + $days день очікування',
      zero: 'без очікування після зняття',
    );
    return '$_temp0';
  }

  @override
  String treatmentNoSuperAfterStart(int days) {
    String _temp0 = intl.Intl.pluralLogic(
      days,
      locale: localeName,
      other: 'початок + $days дня очікування',
      many: 'початок + $days днів очікування',
      few: 'початок + $days дні очікування',
      one: 'початок + $days день очікування',
      zero: 'без очікування',
    );
    return '$_temp0';
  }

  @override
  String treatmentSave(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Зберегти для $count вулика',
      many: 'Зберегти для $count вуликів',
      few: 'Зберегти для $count вуликів',
      one: 'Зберегти для $count вулика',
    );
    return '$_temp0';
  }

  @override
  String treatmentSaved(String number) {
    return 'Обробку вулика $number збережено';
  }

  @override
  String treatmentSavedMany(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Обробку збережено для $count вулика',
      many: 'Обробку збережено для $count вуликів',
      few: 'Обробку збережено для $count вуликів',
      one: 'Обробку збережено для $count вулика',
    );
    return '$_temp0';
  }

  @override
  String get drugFormTitle => 'Новий препарат';

  @override
  String get drugName => 'Назва';

  @override
  String get drugActiveIngredient => 'Діюча речовина';

  @override
  String get drugDoseUnit => 'Одиниця дози';

  @override
  String get drugWithdrawalDays => 'Період очікування за етикеткою (днів)';

  @override
  String get drugSave => 'Додати препарат';

  @override
  String get withdrawalLockTitle => 'Триває період очікування.';

  @override
  String withdrawalLockMessage(String number, String product, String date) {
    return 'Вулик $number обробляється препаратом $product. Магазин не можна ставити до $date; мед цього періоду може містити залишки препарату.';
  }

  @override
  String get withdrawalDaysLeft => 'Лишилося';

  @override
  String withdrawalDays(int days) {
    String _temp0 = intl.Intl.pluralLogic(
      days,
      locale: localeName,
      other: '$days дня',
      many: '$days днів',
      few: '$days дні',
      one: '$days день',
    );
    return '$_temp0';
  }

  @override
  String get withdrawalApplied => 'Застосовано';

  @override
  String get withdrawalReasonPrompt =>
      'Щоб усе одно зберегти, виберіть причину';

  @override
  String get withdrawalReasonRemovedEarly => 'Препарат знято раніше';

  @override
  String get withdrawalReasonNotForSale =>
      'Магазин не на продаж (для себе/на корм)';

  @override
  String get withdrawalCancel => 'Скасувати, не ставити магазин';

  @override
  String get withdrawalProceed => 'Усе одно зберегти';

  @override
  String inspectionWithdrawalOverride(String reason) {
    return 'Магазин поставлено в період очікування: $reason';
  }

  @override
  String timelineTreatment(String product) {
    return 'Обробка · $product';
  }

  @override
  String timelineTreatmentBatch(String batch) {
    return 'Партія $batch';
  }

  @override
  String treatmentDoseValue(String dose, String unit) {
    return '$dose $unit';
  }

  @override
  String timelineTreatmentRemoval(String date) {
    return 'зняття $date';
  }

  @override
  String timelineTreatmentWithdrawal(int days) {
    String _temp0 = intl.Intl.pluralLogic(
      days,
      locale: localeName,
      other: '$days дня очікування',
      many: '$days днів очікування',
      few: '$days дні очікування',
      one: '$days день очікування',
    );
    return '$_temp0';
  }

  @override
  String get hiveActiveTreatment => 'Триває обробка';

  @override
  String get hiveActiveTreatmentNone => 'Немає';

  @override
  String hiveActiveTreatmentLeft(int days) {
    String _temp0 = intl.Intl.pluralLogic(
      days,
      locale: localeName,
      other: 'лишилося $days дня',
      many: 'лишилося $days днів',
      few: 'лишилося $days дні',
      one: 'лишився $days день',
    );
    return '$_temp0';
  }

  @override
  String hiveActiveTreatmentDetail(String ingredient) {
    return '$ingredient · без магазина';
  }

  @override
  String get treatmentRotationTitle => 'Та сама діюча речовина.';

  @override
  String treatmentRotationMessage(int count, String ingredient) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other:
          'Останні $count обробки на цій пасіці теж були $ingredient. Подумайте про іншу речовину, щоб не спричинити стійкість.',
      many:
          'Останні $count обробок на цій пасіці теж були $ingredient. Подумайте про іншу речовину, щоб не спричинити стійкість.',
      few:
          'Останні $count обробки на цій пасіці теж були $ingredient. Подумайте про іншу речовину, щоб не спричинити стійкість.',
      one:
          'Остання $count обробка на цій пасіці теж була $ingredient. Подумайте про іншу речовину, щоб не спричинити стійкість.',
    );
    return '$_temp0';
  }

  @override
  String get treatmentPrescriptionAdd => 'Додати фото рецепта / рахунку';

  @override
  String get treatmentPrescriptionAdded => 'Фото рецепта додано';

  @override
  String get treatmentPrescriptionRemove => 'Видалити';

  @override
  String get reminderChannelName => 'Нагадування';

  @override
  String get treatmentReminderDenied =>
      'Сповіщення вимкнено; нагадування про зняття не створено.';

  @override
  String get hiveFeed => 'Підгодувати';

  @override
  String get feedingFormTitle => 'Підгодівля';

  @override
  String feedingScopeHive(String number) {
    return 'Вулик $number';
  }

  @override
  String feedingScopeApiary(int count) {
    return 'Уся пасіка · $count';
  }

  @override
  String get feedingKind => 'Вид';

  @override
  String get feedingKindSyrup1to1 => 'Сироп 1:1 · стимулювальний';

  @override
  String get feedingKindSyrup2to1 => 'Сироп 2:1 · на зиму';

  @override
  String get feedingKindBeeCake => 'Канді';

  @override
  String get feedingKindPollenSubstitute => 'Замінник перги';

  @override
  String feedingAmount(String unit) {
    return 'На вулик ($unit)';
  }

  @override
  String get feedingSuperHiveTitle => 'На цьому вулику стоїть магазин.';

  @override
  String get feedingSuperHiveMessage => 'Сироп може потрапити в мед.';

  @override
  String feedingSuperSkippedTitle(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'На $count вулика стоять магазини',
      many: 'На $count вуликах стоять магазини',
      few: 'На $count вуликах стоять магазини',
      one: 'На $count вулику стоїть магазин',
    );
    return '$_temp0';
  }

  @override
  String feedingSuperSkippedMessage(String numbers) {
    return '($numbers). Пропущено, щоб сироп не потрапив у мед.';
  }

  @override
  String get feedingPrepare => 'Приготувати';

  @override
  String feedingPrepareCount(int count, String amount, String unit) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count вулика × $amount $unit',
      many: '$count вуликів × $amount $unit',
      few: '$count вулики × $amount $unit',
      one: '$count вулик × $amount $unit',
    );
    return '$_temp0';
  }

  @override
  String feedingTotalSyrup(String amount, String unit) {
    return '$amount $unit сиропу';
  }

  @override
  String feedingTotalBeeCake(String amount, String unit) {
    return '$amount $unit канді';
  }

  @override
  String feedingTotalPollenSubstitute(String amount, String unit) {
    return '$amount $unit замінника перги';
  }

  @override
  String get feedingSugar => 'Цукор';

  @override
  String get feedingWater => 'Вода';

  @override
  String feedingApprox(String amount, String unit) {
    return '≈ $amount $unit';
  }

  @override
  String feedingSave(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Зберегти для $count вулика',
      many: 'Зберегти для $count вуликів',
      few: 'Зберегти для $count вуликів',
      one: 'Зберегти для $count вулика',
      zero: 'Немає вуликів для підгодівлі',
    );
    return '$_temp0';
  }

  @override
  String feedingSaved(String number) {
    return 'Підгодівлю вулика $number збережено';
  }

  @override
  String feedingSavedMany(int count) {
    return 'Підгодівлю збережено для вуликів: $count';
  }

  @override
  String get unitLiter => 'л';

  @override
  String get unitGallon => 'гал';

  @override
  String get syncTableTasks => 'Завдання';

  @override
  String get tasksTabToday => 'Сьогодні';

  @override
  String get tasksTabWeek => 'Цей тиждень';

  @override
  String get tasksTabApiary => 'За пасіками';

  @override
  String get tasksAdd => 'Додати завдання';

  @override
  String tasksOverdue(int count) {
    return 'Прострочено · $count';
  }

  @override
  String tasksDayGroup(String day, int count) {
    return '$day · $count';
  }

  @override
  String get tasksToday => 'Сьогодні';

  @override
  String get tasksTomorrow => 'Завтра';

  @override
  String get tasksNoApiary => 'Без пасіки';

  @override
  String tasksApiaryGroup(String apiary, int count) {
    return '$apiary · $count';
  }

  @override
  String get tasksEmptyTodayTitle => 'На сьогодні справ немає';

  @override
  String get tasksEmptyWeekTitle => 'Цього тижня завдань немає';

  @override
  String get tasksEmptyAddHint => 'Додайте завдання кнопкою + праворуч угорі.';

  @override
  String get tasksLoadError => 'Не вдалося завантажити завдання.';

  @override
  String tasksWeekDaySemantics(String day, int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count завдання',
      many: '$count завдань',
      few: '$count завдання',
      one: '$count завдання',
      zero: 'немає завдань',
    );
    return '$day, $_temp0';
  }

  @override
  String taskOverdueDays(int days) {
    String _temp0 = intl.Intl.pluralLogic(
      days,
      locale: localeName,
      other: 'прострочено на $days дня',
      many: 'прострочено на $days днів',
      few: 'прострочено на $days дні',
      one: 'прострочено на $days день',
    );
    return '$_temp0';
  }

  @override
  String get taskSourceInspection => 'з огляду';

  @override
  String get taskSourceTreatment => 'обробка';

  @override
  String taskInspectionTitle(String number) {
    return 'Вулик $number · перевірити знову';
  }

  @override
  String get taskInspectionTitleNoHive => 'Перевірити знову';

  @override
  String taskTreatmentTitle(String number) {
    return 'Вулик $number · зняти смужки';
  }

  @override
  String get taskTreatmentTitleApiary => 'Зняти смужки';

  @override
  String get taskReminderBody => 'Час виконати завдання.';

  @override
  String get taskAssigneeMe => 'Я';

  @override
  String taskAssignedTo(String name) {
    return 'Призначено: $name';
  }

  @override
  String taskMemberNumbered(String role, int index) {
    return '$role $index';
  }

  @override
  String get roleOwner => 'Власник';

  @override
  String get rolePartner => 'Партнер';

  @override
  String get roleWorker => 'Працівник';

  @override
  String get roleViewer => 'Спостерігач';

  @override
  String taskCompleteAction(String title) {
    return 'Виконати: $title';
  }

  @override
  String get taskCompleted => 'Завдання виконано';

  @override
  String get taskFormNewTitle => 'Нове завдання';

  @override
  String get taskFormEditTitle => 'Змінити завдання';

  @override
  String get taskFormName => 'Завдання';

  @override
  String get taskFormNameHint => 'наприклад, Поїхати на гірську пасіку';

  @override
  String get taskFormDue => 'Термін';

  @override
  String get taskFormPickDate => 'Інший день';

  @override
  String get taskFormTime => 'Час';

  @override
  String get taskFormApiary => 'Пасіка';

  @override
  String get taskFormHive => 'Вулик';

  @override
  String get taskFormNone => 'Немає';

  @override
  String get taskFormChooseApiary => 'Вибрати пасіку';

  @override
  String get taskFormChooseHive => 'Вибрати вулик';

  @override
  String get taskFormAssignee => 'Виконавець';

  @override
  String get taskFormUnassigned => 'Не призначено';

  @override
  String get taskFormCompleted => 'Виконано';

  @override
  String get taskFormSave => 'Зберегти';

  @override
  String get taskFormDelete => 'Видалити завдання';

  @override
  String get taskDeleteTitle => 'Видалити це завдання?';

  @override
  String get taskDeleteMessage => 'Завдання буде видалено з усіх телефонів.';

  @override
  String get taskDeleteConfirm => 'Видалити';

  @override
  String get taskSaved => 'Завдання збережено';

  @override
  String get taskDeleted => 'Завдання видалено';

  @override
  String get taskNotFound => 'Завдання не знайдено; можливо, його видалено.';

  @override
  String get taskReminderDenied =>
      'Сповіщення вимкнено; нагадування не спрацює.';

  @override
  String get exactAlarmTitle => 'Нагадувати точно вчасно?';

  @override
  String get exactAlarmMessage =>
      'Android може відкладати сповіщення на кілька хвилин, щоб заощадити батарею. Дозвольте Mobil Arıcı в налаштуванні, що відкриється, і нагадування про завдання надходитимуть точно вчасно. Інтернет не потрібен.';

  @override
  String get exactAlarmConfirm => 'Відкрити налаштування';

  @override
  String get settingsReminders => 'Нагадування';

  @override
  String get settingsExactAlarms => 'Точно вчасно';

  @override
  String get settingsExactAlarmsOn => 'Увімк.';

  @override
  String get settingsExactAlarmsOff =>
      'Вимк. · може запізнюватися на кілька хвилин';

  @override
  String weatherTemperature(String value) {
    return '$value°';
  }

  @override
  String weatherForecastAsOf(String time) {
    return 'Прогноз на $time';
  }

  @override
  String get weatherNoLocationTitle => 'Немає розташування';

  @override
  String get weatherNoLocationAction => 'Додайте місце для погоди';

  @override
  String get weatherPendingHint => 'З\'явиться, коли буде інтернет';

  @override
  String weatherWind(String speed) {
    return 'Вітер $speed';
  }

  @override
  String weatherSpeed(String value, String unit) {
    return '$value $unit';
  }

  @override
  String get unitKmh => 'км/год';

  @override
  String get unitMph => 'миль/год';

  @override
  String weatherPercent(String value) {
    return '$value%';
  }

  @override
  String weatherTemperatureRange(String max, String min) {
    return '$max / $min';
  }

  @override
  String get hiveOpeningRain => 'Дощ';

  @override
  String get hiveOpeningWind => 'Вітряно';

  @override
  String get hiveOpeningCold => 'Холодно';

  @override
  String get hiveOpeningDaySuitable => 'Можна';

  @override
  String get weatherConditionSunny => 'Сонячно';

  @override
  String get weatherConditionPartlyCloudy => 'Мінлива хмарність';

  @override
  String get weatherConditionCloudy => 'Хмарно';

  @override
  String get weatherConditionRainy => 'Дощ';

  @override
  String get weatherConditionWindy => 'Вітряно';

  @override
  String get weatherConditionOther => 'Сніг, туман або гроза';

  @override
  String get weatherConditionFog => 'Туман';

  @override
  String get weatherConditionThunder => 'Грози';

  @override
  String get weatherConditionSleet => 'Мокрий сніг';

  @override
  String get weatherConditionSnow => 'Сніг';

  @override
  String weatherFeelsLike(String condition, String value) {
    return '$condition · відчувається як $value';
  }

  @override
  String get weatherWindLabel => 'Вітер';

  @override
  String get weatherHumidityLabel => 'Вологість';

  @override
  String get weatherPrecipitationLabel => 'Дощ';

  @override
  String get weatherScreenTitle => 'Погода на пасіці';

  @override
  String weatherScreenSubtitle(String place, String days) {
    return '$place · прогноз на $days дн.';
  }

  @override
  String weatherScreenSubtitleNoPlace(String days) {
    return 'Прогноз на $days дн.';
  }

  @override
  String weatherUpdatedAt(String time) {
    return 'Оновлено $time';
  }

  @override
  String get weatherNow => 'Зараз';

  @override
  String get weatherToday => 'Сьогодні';

  @override
  String get weatherColumnDay => 'День';

  @override
  String get weatherColumnTemperature => 'Темп.';

  @override
  String get weatherColumnPrecipitation => 'Дощ';

  @override
  String get weatherColumnHive => 'Вулики';

  @override
  String get weatherTodaySuitable => 'Добрий день, щоб відкривати вулики';

  @override
  String get weatherTodayRain => 'Сьогодні дощ; не день для огляду';

  @override
  String get weatherTodayWind => 'Сьогодні вітряно; не день для огляду';

  @override
  String get weatherTodayCold => 'Сьогодні холодно; не день для огляду';

  @override
  String weatherDayRange(String from, String to) {
    return '$from–$to';
  }

  @override
  String weatherPlanRain(String days) {
    return 'Дощ: $days.';
  }

  @override
  String weatherPlanWind(String days) {
    return 'Вітер: $days.';
  }

  @override
  String weatherPlanMove(String weekday) {
    String _temp0 = intl.Intl.selectLogic(weekday, {
      'monday': 'Перенесіть огляди на понеділок.',
      'tuesday': 'Перенесіть огляди на вівторок.',
      'wednesday': 'Перенесіть огляди на середу.',
      'thursday': 'Перенесіть огляди на четвер.',
      'friday': 'Перенесіть огляди на п\'ятницю.',
      'saturday': 'Перенесіть огляди на суботу.',
      'other': 'Перенесіть огляди на неділю.',
    });
    return '$_temp0';
  }

  @override
  String get weatherPlanAction => 'Запланувати';

  @override
  String weatherPlanTaskTitle(String apiary) {
    return 'Огляд: $apiary';
  }

  @override
  String weatherThresholdsHint(
    String temperature,
    String wind,
    String precipitation,
  ) {
    return 'Можна відкривати: вище $temperature, вітер слабший за $wind, імовірність дощу нижче $precipitation. Пороги можна змінити в налаштуваннях.';
  }

  @override
  String get weatherEmptyTitle => 'Прогнозу поки немає';

  @override
  String get weatherEmptyMessage =>
      'Прогноз для цієї пасіки ще не завантажено. Оновіть, коли з\'явиться інтернет.';

  @override
  String get weatherNoLocationMessage =>
      'У цієї пасіки немає розташування. Додайте його, щоб отримувати прогноз.';

  @override
  String get weatherRefresh => 'Оновити';

  @override
  String get weatherRefreshFailed =>
      'Не вдалося отримати прогноз. Перевірте підключення до інтернету.';

  @override
  String get weatherApiaryNotFound => 'Пасіку не знайдено';

  @override
  String get weatherAttributionPrefix => 'Powered by';

  @override
  String get weatherAttributionLink => 'WeatherAPI.com';

  @override
  String get settingsHiveOpening => 'Пороги для огляду вуликів';

  @override
  String get settingsHiveOpeningTemperature => 'Температура';

  @override
  String settingsHiveOpeningTemperatureValue(String value) {
    return 'вище $value';
  }

  @override
  String get settingsHiveOpeningWind => 'Вітер';

  @override
  String get settingsHiveOpeningPrecipitation => 'Імовірність дощу';

  @override
  String settingsHiveOpeningBelow(String value) {
    return 'нижче $value';
  }

  @override
  String get settingsHiveOpeningHint =>
      'Екран погоди й картки «Сьогодні» пишуть «Можна» за цими порогами. Зберігається лише на цьому телефоні.';

  @override
  String get hiveOpeningSuitable => 'Можна відкривати';

  @override
  String get todayGreetingMorning => 'Доброго ранку';

  @override
  String get todayGreetingAfternoon => 'Добрий день';

  @override
  String get todayGreetingEvening => 'Добрий вечір';

  @override
  String get todayAttentionTitle => 'Потребують уваги';

  @override
  String todayAttentionHiveCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count вулика',
      many: '$count вуликів',
      few: '$count вулики',
      one: '$count вулик',
    );
    return '$_temp0';
  }

  @override
  String get todayAttentionNone => 'Жоден вулик не потребує уваги';

  @override
  String get todayTasksTitle => 'Сьогодні';

  @override
  String todayTasksCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count завдання',
      many: '$count завдань',
      few: '$count завдання',
      one: '$count завдання',
    );
    return '$_temp0';
  }

  @override
  String todayTasksApiaryCount(String apiary, int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count завдання',
      many: '$count завдань',
      few: '$count завдання',
      one: '$count завдання',
    );
    return '$apiary · $_temp0';
  }

  @override
  String todaySetupProgress(int done, int total) {
    return 'Налаштування $done/$total';
  }

  @override
  String get setupStepApiary => 'Додайте пасіку';

  @override
  String get setupStepHives => 'Створіть вулики';

  @override
  String get setupStepInspection => 'Проведіть перший огляд';

  @override
  String setupStepDone(String step) {
    return '$step: готово';
  }

  @override
  String get attentionQueenless => 'Безматкові';

  @override
  String get attentionWeak => 'Слабкі';

  @override
  String get attentionSwarming => 'Ознаки роїння';

  @override
  String get attentionTreatmentRemoval => 'Зняти обробку';

  @override
  String get attentionQueenlessTitle => 'Безматкові вулики';

  @override
  String get attentionWeakTitle => 'Слабкі вулики';

  @override
  String get attentionSwarmingTitle => 'Вулики з ознаками роїння';

  @override
  String get attentionTreatmentRemovalTitle => 'Обробки до зняття';

  @override
  String get attentionQueenlessIntro =>
      'Активні вулики, де під час останнього огляду не знайшли ні матки, ні яєць.';

  @override
  String attentionWeakIntro(int max) {
    return 'Активні вулики з силою $max/5 або нижче на останньому огляді.';
  }

  @override
  String get attentionSwarmingIntro =>
      'Активні вулики, де на останньому огляді були ознаки роїння або ройові маточники.';

  @override
  String get attentionTreatmentRemovalIntro =>
      'Вулики, де час знімати смужки, а завдання ще не виконано.';

  @override
  String get attentionEmpty => 'У цій групі немає вуликів.';

  @override
  String attentionLastInspection(String date) {
    return 'Останній огляд: $date';
  }

  @override
  String attentionRemovalDue(String date) {
    return 'Зняти до: $date';
  }

  @override
  String get syncTableHarvests => 'Медозбір';

  @override
  String get syncTableHarvestHives => 'Вулик медозбору';

  @override
  String withdrawalLockHarvestMessage(
    String number,
    String product,
    String date,
  ) {
    return 'Вулик $number обробляється препаратом $product. Відбирати мед не можна до $date; мед цього періоду може містити залишки препарату.';
  }

  @override
  String get withdrawalReasonNotForSaleHarvest =>
      'Мед не на продаж (для себе/на корм)';

  @override
  String get withdrawalHarvestCancel => 'Скасувати, не відбирати';

  @override
  String get withdrawalHarvestProceed => 'Усе одно відібрати';

  @override
  String get apiaryHarvest => 'Медозбір';

  @override
  String harvestFormTitle(String apiary) {
    return 'Медозбір · $apiary';
  }

  @override
  String harvestSelectedCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Вибрано $count вулика',
      many: 'Вибрано $count вуликів',
      few: 'Вибрано $count вулики',
      one: 'Вибрано $count вулик',
      zero: 'Вулики не вибрано',
    );
    return '$_temp0';
  }

  @override
  String harvestSelectedHint(String numbers) {
    return '$numbers · торкніться, щоб змінити, або скануйте, щоб додати';
  }

  @override
  String get harvestSelectedEmptyHint =>
      'Торкніться, щоб вибрати вулики, або скануйте';

  @override
  String get harvestScan => 'Сканувати';

  @override
  String harvestLockedTitle(String numbers) {
    return '$numbers: триває період очікування.';
  }

  @override
  String get harvestLockedMessage =>
      'Мед не відібрано. Щоб усе ж відібрати, виберіть вулик у списку.';

  @override
  String get harvestDate => 'Дата';

  @override
  String get harvestToday => 'Сьогодні';

  @override
  String get harvestYesterday => 'Учора';

  @override
  String get harvestPickDate => 'Інший день';

  @override
  String get harvestHoneyKind => 'Вид меду';

  @override
  String get honeyKindPine => 'Сосновий';

  @override
  String get honeyKindFlower => 'Квітковий';

  @override
  String get honeyKindChestnut => 'Каштановий';

  @override
  String get honeyKindCitrus => 'Цитрусовий';

  @override
  String get honeyKindOther => 'Інший';

  @override
  String get harvestUnit => 'Відібрано';

  @override
  String get harvestUnitSuper => 'Магазинами';

  @override
  String get harvestUnitFrame => 'Рамками';

  @override
  String get harvestTakenSupers => 'Відібрано магазинів';

  @override
  String get harvestTakenFrames => 'Відібрано рамок';

  @override
  String harvestWeight(String unit) {
    return 'Відкачано меду ($unit)';
  }

  @override
  String get harvestWeightInvalid => 'Введіть вагу, наприклад 574 або 574,5';

  @override
  String harvestWeightTooLarge(String max, String unit) {
    return 'Не більше $max $unit';
  }

  @override
  String get harvestPerHive => 'На вулик';

  @override
  String harvestWeightValue(String value, String unit) {
    return '$value $unit';
  }

  @override
  String harvestSave(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Зберегти медозбір',
      many: 'Зберегти медозбір',
      few: 'Зберегти медозбір',
      one: 'Зберегти медозбір',
      zero: 'Немає вуликів для відбору',
    );
    return '$_temp0';
  }

  @override
  String harvestSaved(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Медозбір збережено для $count вулика',
      many: 'Медозбір збережено для $count вуликів',
      few: 'Медозбір збережено для $count вуликів',
      one: 'Медозбір збережено для $count вулика',
    );
    return '$_temp0';
  }

  @override
  String get harvestHivesTitle => 'Вулики для відбору';

  @override
  String get harvestSelectAll => 'Вибрати всі';

  @override
  String get harvestSelectNone => 'Зняти вибір';

  @override
  String harvestHiveLocked(int days) {
    String _temp0 = intl.Intl.pluralLogic(
      days,
      locale: localeName,
      other: 'лишилося $days дня',
      many: 'лишилося $days днів',
      few: 'лишилося $days дні',
      one: 'лишився $days день',
    );
    return 'Очікування · $_temp0';
  }

  @override
  String harvestHiveOverridden(String reason) {
    return 'Усе одно відібрано: $reason';
  }

  @override
  String get harvestHivesDone => 'Готово';

  @override
  String get harvestNoActiveHives => 'На цій пасіці немає активних вуликів.';

  @override
  String get harvestScanTitle => 'Сканування для медозбору';

  @override
  String harvestScanAdded(String number) {
    return 'Вулик $number додано';
  }

  @override
  String harvestScanAlready(String number) {
    return 'Вулик $number уже вибрано';
  }

  @override
  String harvestScanOtherApiary(String number) {
    return 'Вулик $number не на цій пасіці';
  }

  @override
  String harvestScanInactive(String number) {
    return 'Вулик $number не активний';
  }

  @override
  String get harvestScanUnknown => 'Ця етикетка не прив\'язана до вулика';

  @override
  String harvestScanDone(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Готово · $count вулика',
      many: 'Готово · $count вуликів',
      few: 'Готово · $count вулики',
      one: 'Готово · $count вулик',
      zero: 'Готово',
    );
    return '$_temp0';
  }

  @override
  String get apiaryTourStart => 'Почати обхід';

  @override
  String get apiaryTourResume => 'Продовжити обхід';

  @override
  String get tourReplaceTitle => 'Завершити поточний обхід?';

  @override
  String tourReplaceMessage(String apiary) {
    return 'Обхід пасіки $apiary ще триває. Новий обхід скине його прогрес; огляди залишаться збереженими.';
  }

  @override
  String get tourReplaceConfirm => 'Почати новий обхід';

  @override
  String tourTitle(String apiary) {
    return 'Обхід: $apiary';
  }

  @override
  String get tourFinish => 'Завершити обхід';

  @override
  String tourProgress(int done, int total) {
    return '$done / $total';
  }

  @override
  String tourProgressLabel(int done, int total) {
    return 'Готово $done з $total вуликів';
  }

  @override
  String tourMinutes(int minutes) {
    return '$minutes хв';
  }

  @override
  String tourHoursMinutes(int hours, int minutes) {
    return '$hours год $minutes хв';
  }

  @override
  String tourElapsedLabel(String duration) {
    return 'Минуло часу: $duration';
  }

  @override
  String get tourNext => 'Наступний';

  @override
  String tourPreviousVisit(String date) {
    return 'Минулого разу · $date';
  }

  @override
  String get tourQueue => 'Порядок';

  @override
  String tourSkippedCount(int count) {
    return 'Пропущено: $count';
  }

  @override
  String get tourStateDone => 'Готово';

  @override
  String get tourStateSkipped => 'Пропущено';

  @override
  String get tourStatePending => 'Чекає';

  @override
  String get tourStateNext => 'Наступний';

  @override
  String tourHiveSemantics(String number, String state) {
    return 'Вулик $number, $state';
  }

  @override
  String get tourSkip => 'Пропустити';

  @override
  String tourInspect(String number) {
    return 'Оглянути $number';
  }

  @override
  String get tourAllDone => 'Усі вулики оглянуто.';

  @override
  String get tourSunSuggestion =>
      'Режим «Сонце» робить екран читабельнішим за яскравого світла.';

  @override
  String get tourSunOn => 'Увімкнути режим «Сонце»';

  @override
  String get tourSunMode => 'Режим «Сонце»';

  @override
  String get tourFinishTitle => 'Завершити обхід?';

  @override
  String tourFinishMessage(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count вулика не оглянуто; у підсумку вони будуть пропущеними.',
      many: '$count вуликів не оглянуто; у підсумку вони будуть пропущеними.',
      few: '$count вулики не оглянуто; у підсумку вони будуть пропущеними.',
      one: '$count вулик не оглянуто; у підсумку він буде пропущеним.',
    );
    return '$_temp0';
  }

  @override
  String get tourNotFound => 'На цій пасіці немає поточного обходу.';

  @override
  String get tourCompleteTitle => 'Обхід завершено';

  @override
  String tourInspectedCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Оглянуто $count вулика',
      many: 'Оглянуто $count вуликів',
      few: 'Оглянуто $count вулики',
      one: 'Оглянуто $count вулик',
    );
    return '$_temp0';
  }

  @override
  String get tourHealthy => 'Сильні / середні';

  @override
  String get tourTasksTitle => 'Завдання';

  @override
  String tourTaskRequeen(String numbers) {
    return 'Замінити матку: $numbers';
  }

  @override
  String tourTaskFeedWeak(String numbers) {
    return 'Підгодувати сиропом 1:1: $numbers';
  }

  @override
  String tourTaskSwarmCheck(String numbers) {
    return 'Перевірити на роїння: $numbers';
  }

  @override
  String tourTaskRevisit(String numbers) {
    return 'Перевірити пропущені вулики: $numbers';
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
      other: 'через $days дня',
      many: 'через $days днів',
      few: 'через $days дні',
      one: 'через $days день',
      zero: 'сьогодні',
    );
    return '$_temp0';
  }

  @override
  String tourSaveTasks(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Зберегти завдання',
      many: 'Зберегти завдання',
      few: 'Зберегти завдання',
      one: 'Зберегти завдання',
      zero: 'Закрити',
    );
    return '$_temp0';
  }

  @override
  String tourTasksSaved(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Збережено $count завдання',
      many: 'Збережено $count завдань',
      few: 'Збережено $count завдання',
      one: 'Збережено $count завдання',
    );
    return '$_temp0';
  }

  @override
  String get tourNoTasks => 'Пропонувати нічого.';

  @override
  String get reportsTitle => 'Звіти';

  @override
  String get reportTreatmentRegister => 'Журнал обробок';

  @override
  String get reportTreatmentRegisterHint => 'Для перевірок';

  @override
  String get reportHiveHistory => 'Історія вулика';

  @override
  String get reportHiveHistoryHint => 'Один вулик або пасіка';

  @override
  String get reportFrom => 'З';

  @override
  String get reportTo => 'По';

  @override
  String get reportApiary => 'Пасіка';

  @override
  String get reportAllApiaries => 'Усі пасіки';

  @override
  String get reportHive => 'Вулик';

  @override
  String get reportAllHives => 'Усі вулики';

  @override
  String get reportLanguage => 'Мова PDF';

  @override
  String get reportRegistrationNo => 'Реєстр. № господарства';

  @override
  String get reportAksNo => '№ AKS';

  @override
  String get reportRecordNo => 'Реєстраційний номер';

  @override
  String get reportNumbersHelper =>
      'Друкується лише в шапці PDF; не зберігається.';

  @override
  String get reportShare => 'Поділитися';

  @override
  String get reportCreate => 'Створити PDF';

  @override
  String get reportPreparing => 'Готуємо PDF…';

  @override
  String get reportError => 'Не вдалося створити PDF. Спробуйте знову.';

  @override
  String get reportLoadError => 'Не вдалося прочитати записи.';

  @override
  String get reportEmpty => 'За цей період записів немає.';

  @override
  String reportTreatmentCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count обробки',
      many: '$count обробок',
      few: '$count обробки',
      one: '$count обробка',
    );
    return '$_temp0';
  }

  @override
  String reportHiveCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count вулика',
      many: '$count вуликів',
      few: '$count вулики',
      one: '$count вулик',
    );
    return '$_temp0';
  }

  @override
  String reportRecordCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count запису',
      many: '$count записів',
      few: '$count записи',
      one: '$count запис',
    );
    return '$_temp0';
  }

  @override
  String get reportNoValue => '—';

  @override
  String get pdfTreatmentRegisterTitle => 'Журнал обробок';

  @override
  String get pdfHiveHistoryTitle => 'Історія вулика';

  @override
  String pdfRegistrationNo(String number) {
    return 'Реєстр. № господарства $number';
  }

  @override
  String pdfAksNo(String number) {
    return '№ AKS $number';
  }

  @override
  String pdfRecordNo(String number) {
    return 'Реєстр. № $number';
  }

  @override
  String pdfPeriod(String from, String to) {
    return 'Період: $from – $to';
  }

  @override
  String pdfApiary(String name) {
    return 'Пасіка: $name';
  }

  @override
  String pdfCreated(String date) {
    return 'Створено $date';
  }

  @override
  String pdfPage(int page, int pages) {
    return 'Стор. $page з $pages';
  }

  @override
  String get pdfColumnDate => 'Дата';

  @override
  String get pdfColumnApiary => 'Пасіка';

  @override
  String get pdfColumnProduct => 'Препарат / партія';

  @override
  String get pdfColumnHives => 'Вулики';

  @override
  String get pdfColumnDose => 'Доза на вулик';

  @override
  String get pdfColumnRemoval => 'Зняття';

  @override
  String get pdfColumnWithdrawalEnd => 'Кінець очікування';

  @override
  String get pdfColumnEvent => 'Запис';

  @override
  String get pdfColumnDetails => 'Подробиці';

  @override
  String get pdfEventFeeding => 'Підгодівля';

  @override
  String get pdfEventVarroa => 'Підрахунок кліща';

  @override
  String get pdfEventHarvest => 'Медозбір';

  @override
  String pdfHarvestTotal(String amount) {
    return 'Увесь медозбір: $amount';
  }

  @override
  String pdfDocumentName(String title, String from, String to) {
    return '$title $from–$to';
  }

  @override
  String get moreFeedback => 'Надіслати відгук';

  @override
  String get feedbackTitle => 'Надіслати відгук';

  @override
  String get feedbackIntro =>
      'Ми створюємо цей застосунок разом із пасічниками. Читаємо кожне повідомлення.';

  @override
  String get feedbackKindLabel => 'Про що це?';

  @override
  String get feedbackKindBug => 'Помилка';

  @override
  String get feedbackKindSuggestion => 'Пропозиція';

  @override
  String get feedbackKindMissingFeature => 'Бракує функції';

  @override
  String get feedbackKindThanks => 'Подяка';

  @override
  String get feedbackMessageLabel => 'Ваше повідомлення';

  @override
  String get feedbackMessageHint => 'Що сталося і чого ви очікували?';

  @override
  String get feedbackAddScreenshot => 'Додати знімок екрана';

  @override
  String get feedbackScreenshotAttached => 'Знімок екрана додано';

  @override
  String get feedbackRemoveScreenshot => 'Видалити';

  @override
  String get feedbackScreenshotDenied =>
      'Доступ до фото не дозволено. Щоб додати знімок, дозвольте його в налаштуваннях.';

  @override
  String get feedbackIncludeDeviceInfo =>
      'Додати відомості про пристрій і версію';

  @override
  String get feedbackOfflineHint =>
      'Без інтернету повідомлення стане в чергу й піде, коли з\'явиться мережа.';

  @override
  String get feedbackSend => 'Надіслати';

  @override
  String get feedbackQueued => 'Дякуємо! Повідомлення в черзі на надсилання.';

  @override
  String get settingsAnalytics => 'Ділитися даними про використання';

  @override
  String get settingsAnalyticsHint =>
      'Числа на кшталт часу огляду, результатів сканування й затримки синхронізації; ваше ім\'я, вулики та розташування ніколи не надсилаються.';

  @override
  String get teamTitle => 'Команда';

  @override
  String get teamRoleOwner => 'Власник';

  @override
  String get teamRolePartner => 'Партнер';

  @override
  String get teamRoleWorker => 'Працівник';

  @override
  String get teamRoleViewer => 'Консультант';

  @override
  String get teamRoleViewerSubtitle => 'Лише читання';

  @override
  String get teamRoleHintPartner => 'Партнер вносить записи й бачить фінанси.';

  @override
  String get teamRoleHintWorker =>
      'Працівник вносить записи, але не бачить фінансів.';

  @override
  String get teamRoleHintViewer =>
      'Консультант може лише читати й не вносить записів.';

  @override
  String teamMemberSelf(String name) {
    return '$name (ви)';
  }

  @override
  String get teamMemberUnknown => 'Учасник команди';

  @override
  String get teamMembersEmpty => 'Учасники з\'являться після синхронізації.';

  @override
  String get teamInviteTitle => 'Запросити до команди';

  @override
  String get teamInviteHint => 'Скажіть або надішліть код. Він діє 48 годин.';

  @override
  String get teamInviteGenerate => 'Створити код';

  @override
  String get teamInviteCopy => 'Копіювати';

  @override
  String get teamInviteCopied => 'Код скопійовано.';

  @override
  String teamInviteCodeSemantics(String code) {
    return 'Код запрошення $code';
  }

  @override
  String get teamHaveCode => 'Я маю код';

  @override
  String get teamJoinTitle => 'Приєднатися за кодом';

  @override
  String get teamJoinHint => 'Введіть 6-значний код, який вам надіслали.';

  @override
  String get teamJoinCodeLabel => 'Код запрошення';

  @override
  String get teamJoinAction => 'Приєднатися';

  @override
  String get teamJoinDone => 'Ви приєдналися до команди.';

  @override
  String get teamErrorOffline =>
      'Для цього потрібен інтернет. Спробуйте знову, коли будете в мережі.';

  @override
  String get teamErrorInvalidCode =>
      'Код неправильний, застарів або вже використаний.';

  @override
  String get teamErrorAlreadyMember => 'Ви вже є учасником цієї команди.';

  @override
  String get teamErrorForbidden => 'Ви не маєте права це робити.';

  @override
  String get teamErrorOwnerLocked =>
      'Роль власника не можна змінити, а самого власника не можна видалити.';

  @override
  String get teamErrorUnknown => 'Не вийшло. Спробуйте трохи згодом.';

  @override
  String get teamRemoveAction => 'Видалити з команди';

  @override
  String get teamRemoveTitle => 'Видалити з команди?';

  @override
  String teamRemoveMessage(String name) {
    return '$name втратить доступ до записів цього господарства.';
  }

  @override
  String get teamRemoveConfirm => 'Видалити';

  @override
  String teamRemoved(String name) {
    return '$name видалено з команди.';
  }

  @override
  String teamRoleChanged(String name, String role) {
    return 'Тепер $name — $role.';
  }

  @override
  String get teamActivityTitle => 'Останні дії';

  @override
  String get teamActivityEmpty => 'Дій поки немає.';

  @override
  String get teamActivitySelf => 'Ви';

  @override
  String teamActivityInspection(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'вніс $count огляду',
      many: 'вніс $count оглядів',
      few: 'вніс $count огляди',
      one: 'вніс $count огляд',
    );
    return '$_temp0';
  }

  @override
  String teamActivityTreatment(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'обробив $count вулика',
      many: 'обробив $count вуликів',
      few: 'обробив $count вулики',
      one: 'обробив $count вулик',
    );
    return '$_temp0';
  }

  @override
  String teamActivityFeeding(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'підгодував $count вулика',
      many: 'підгодував $count вуликів',
      few: 'підгодував $count вулики',
      one: 'підгодував $count вулик',
    );
    return '$_temp0';
  }

  @override
  String teamActivityHarvest(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'записав $count медозбору',
      many: 'записав $count медозборів',
      few: 'записав $count медозбори',
      one: 'записав $count медозбір',
    );
    return '$_temp0';
  }

  @override
  String teamActivityMiteCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'вніс $count підрахунку кліща',
      many: 'вніс $count підрахунків кліща',
      few: 'вніс $count підрахунки кліща',
      one: 'вніс $count підрахунок кліща',
    );
    return '$_temp0';
  }

  @override
  String teamActivityTask(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'додав $count завдання',
      many: 'додав $count завдань',
      few: 'додав $count завдання',
      one: 'додав $count завдання',
    );
    return '$_temp0';
  }

  @override
  String get teamActivityJustNow => 'щойно';

  @override
  String teamActivityMinutesAgo(int count) {
    return '$count хв тому';
  }

  @override
  String teamActivityHoursAgo(int count) {
    return '$count год тому';
  }

  @override
  String get teamActivityYesterday => 'учора';

  @override
  String teamActivityDaysAgo(int count) {
    return '$count дн. тому';
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
  String get settingsPush => 'Сповіщення про завдання';

  @override
  String get settingsPushHint =>
      'Отримуйте сповіщення, коли вам призначають завдання. Торкніться його, щоб відкрити завдання.';

  @override
  String get documentsTitle => 'Тека документів';

  @override
  String get documentsAdd => 'Додати документ';

  @override
  String documentsSummaryOffline(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count документа',
      many: '$count документів',
      few: '$count документи',
      one: '$count документ',
    );
    return '$_temp0 · усі відкриваються без інтернету';
  }

  @override
  String documentsSummaryMissing(int count, int missing) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count документа',
      many: '$count документів',
      few: '$count документи',
      one: '$count документ',
    );
    String _temp1 = intl.Intl.pluralLogic(
      missing,
      locale: localeName,
      other: '$missing файлу',
      many: '$missing файлів',
      few: '$missing файлів',
      one: '$missing файлу',
    );
    return '$_temp0 · $_temp1 ще немає на цьому телефоні';
  }

  @override
  String get documentsRegionNoteTr =>
      'Види документів залежать від країни. Поза Туреччиною ви створюєте власні види документів.';

  @override
  String get documentsRegionNoteOther =>
      'Види документів задаєте ви; введені види пропонуватимуться наступного разу.';

  @override
  String get documentsRoadCheck => 'Перевірка на дорозі · показати документи';

  @override
  String get documentsEmptyTitle => 'Документів поки немає';

  @override
  String get documentsEmptyMessage =>
      'Додайте фото або PDF дозволів і свідоцтв. Вони відкриваються без інтернету, а перед закінченням терміну буде нагадування.';

  @override
  String get documentsLoadError => 'Не вдалося відкрити документи.';

  @override
  String get documentFileKindPhoto => 'ФОТО';

  @override
  String get documentFileKindPdf => 'PDF';

  @override
  String get documentTypeHealthReport => 'Ветеринарна довідка';

  @override
  String get documentTypeTransportPermit => 'Дозвіл на перевезення';

  @override
  String get documentTypeMigratoryCertificate => 'Свідоцтво кочового пасічника';

  @override
  String get documentTypeBusinessRegistration =>
      'Свідоцтво про реєстрацію господарства';

  @override
  String get documentTypeLandPermit => 'Дозвіл на землю';

  @override
  String get documentTypeAnalysisReport => 'Протокол аналізу';

  @override
  String get documentExpiryNone => 'Безстроковий';

  @override
  String get documentExpiryExpired => 'Сплив';

  @override
  String get documentExpiryToday => 'Спливає сьогодні';

  @override
  String documentExpiryDays(int days) {
    String _temp0 = intl.Intl.pluralLogic(
      days,
      locale: localeName,
      other: '$days дня',
      many: '$days днів',
      few: '$days дні',
      one: '$days день',
    );
    return '$_temp0';
  }

  @override
  String documentExpiryMonths(int months) {
    String _temp0 = intl.Intl.pluralLogic(
      months,
      locale: localeName,
      other: '$months місяця',
      many: '$months місяців',
      few: '$months місяці',
      one: '$months місяць',
    );
    return '$_temp0';
  }

  @override
  String documentExpiresOn(String date) {
    return 'Дійсний до $date';
  }

  @override
  String get documentFormNewTitle => 'Додати документ';

  @override
  String get documentFormEditTitle => 'Змінити документ';

  @override
  String get documentFormType => 'Вид документа';

  @override
  String get documentFormCustomTypeHint => 'наприклад, Страховий поліс';

  @override
  String get documentFormName => 'Назва';

  @override
  String get documentFormNameHint => 'наприклад, Ветдовідка 2026';

  @override
  String get documentFormDescription => 'Опис';

  @override
  String get documentFormDescriptionHint =>
      'наприклад, Районна ветслужба · 152 вулики';

  @override
  String get documentFormExpiry => 'Дійсний до';

  @override
  String get documentFormNoExpiry => 'Безстроковий';

  @override
  String get documentFormPickDate => 'Вибрати дату';

  @override
  String get documentFormExpiryHelper =>
      'Нагадаємо за 30, 7 і 1 день до закінчення терміну.';

  @override
  String get documentFormFile => 'Файл';

  @override
  String get documentFormTakePhoto => 'Сфотографувати';

  @override
  String get documentFormPickImage => 'З галереї';

  @override
  String get documentFormPickPdf => 'Вибрати PDF';

  @override
  String get documentFormNoFile =>
      'Сфотографуйте документ або виберіть його PDF.';

  @override
  String documentFileSizeKb(String size) {
    return '$size КБ';
  }

  @override
  String documentFileSizeMb(String size) {
    return '$size МБ';
  }

  @override
  String get documentFileTooLarge => 'Файл більший за 20 МБ; виберіть менший.';

  @override
  String get documentFileFailed => 'Не вдалося отримати файл, спробуйте знову.';

  @override
  String get documentFilePermissionDenied =>
      'Доступ заборонено. Щоб додати документ, дозвольте цьому застосунку доступ до камери або файлів у налаштуваннях.';

  @override
  String get documentFormSave => 'Зберегти';

  @override
  String get documentFormDelete => 'Видалити документ';

  @override
  String get documentSaved => 'Документ збережено';

  @override
  String get documentReminderDenied =>
      'Документ збережено. Без дозволу на сповіщення нагадування про термін не надходитимуть.';

  @override
  String get documentDeleteTitle => 'Видалити цей документ?';

  @override
  String get documentDeleteMessage =>
      'Документ і його файл буде видалено з усіх телефонів.';

  @override
  String get documentDeleteConfirm => 'Видалити';

  @override
  String get documentDeleted => 'Документ видалено';

  @override
  String get documentNotFound =>
      'Документ не знайдено; можливо, його видалено.';

  @override
  String get documentEdit => 'Змінити';

  @override
  String get documentFileMissing =>
      'Файлу поки немає на цьому телефоні. Він завантажиться, коли з\'явиться інтернет.';

  @override
  String get documentPdfFailed => 'Не вдалося відкрити PDF.';

  @override
  String documentPdfPage(int page, int count) {
    return 'Сторінка $page з $count';
  }

  @override
  String get roadCheckTitle => 'Перевірка на дорозі';

  @override
  String roadCheckPosition(int index, int count) {
    return '$index / $count';
  }

  @override
  String get roadCheckSwipeHint =>
      'Проведіть убік, щоб відкрити наступний документ';

  @override
  String get roadCheckPrevious => 'Попередній документ';

  @override
  String get roadCheckNext => 'Наступний документ';

  @override
  String documentReminderBody(int days, String date) {
    String _temp0 = intl.Intl.pluralLogic(
      days,
      locale: localeName,
      other: '$days дня',
      many: '$days днів',
      few: '$days дні',
      one: '$days день',
    );
    return 'Спливає через $_temp0 · $date';
  }

  @override
  String get syncTableDocuments => 'Документ';

  @override
  String get migrationsTitle => 'Плани кочівлі';

  @override
  String get migrationsAdd => 'Новий план';

  @override
  String get migrationsEmptyTitle => 'Плану кочівлі поки немає';

  @override
  String get migrationsEmptyMessage =>
      'Сплануйте маршрут на рік: дати кожної стоянки, кількість вуликів і пасіку призначення.';

  @override
  String get migrationsLoadError => 'Не вдалося відкрити плани кочівлі';

  @override
  String migrationStopCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count стоянки',
      many: '$count стоянок',
      few: '$count стоянки',
      one: '$count стоянка',
      zero: 'Немає стоянок',
    );
    return '$_temp0';
  }

  @override
  String migrationTitle(String name, String year) {
    return '$name $year';
  }

  @override
  String get migrationNotFound => 'План кочівлі не знайдено';

  @override
  String get migrationDocuments => 'Документи';

  @override
  String get migrationEdit => 'Змінити план';

  @override
  String get migrationAddStop => 'Додати стоянку';

  @override
  String get migrationNoStopsTitle => 'Стоянок поки немає';

  @override
  String get migrationNoStopsMessage =>
      'Додайте стоянки маршруту по черзі: медонос, місце, дати й кількість вуликів.';

  @override
  String migrationNextMoveIn(int days) {
    String _temp0 = intl.Intl.pluralLogic(
      days,
      locale: localeName,
      other: 'через $days дня',
      many: 'через $days днів',
      few: 'через $days дні',
      one: 'через $days день',
      zero: 'сьогодні',
    );
    return 'Наступний переїзд · $_temp0';
  }

  @override
  String migrationNextMoveLate(int days) {
    String _temp0 = intl.Intl.pluralLogic(
      days,
      locale: localeName,
      other: 'запізнення $days дня',
      many: 'запізнення $days днів',
      few: 'запізнення $days дні',
      one: 'запізнення $days день',
    );
    return 'Наступний переїзд · $_temp0';
  }

  @override
  String migrationRoute(String from, String to) {
    return '$from → $to';
  }

  @override
  String migrationDocReady(String document) {
    return '$document готовий';
  }

  @override
  String migrationDocDays(String document, int days) {
    String _temp0 = intl.Intl.pluralLogic(
      days,
      locale: localeName,
      other: '$days дня',
      many: '$days днів',
      few: '$days дні',
      one: '$days день',
      zero: 'спливає сьогодні',
    );
    return '$document $_temp0';
  }

  @override
  String migrationDocBeforeMove(String document) {
    return '$document спливе до переїзду';
  }

  @override
  String migrationDocExpired(String document) {
    return '$document сплив';
  }

  @override
  String migrationDocMissing(String document) {
    return 'Немає документа: $document';
  }

  @override
  String get migrationStopPast => 'Пройдена';

  @override
  String get migrationStopCurrent => 'Зараз тут';

  @override
  String get migrationStopPlanned => 'Запланована';

  @override
  String get migrationStopHere => 'Ви тут';

  @override
  String migrationStopDates(String start, String end) {
    return '$start–$end';
  }

  @override
  String migrationYield(String year, String kg) {
    return '$year: $kg кг/вулик';
  }

  @override
  String migrationYields(String values) {
    return 'Минулий збір · $values';
  }

  @override
  String get migrationNoYield => 'На цій пасіці раніше не було медозбору';

  @override
  String get migrationFormNewTitle => 'Новий план кочівлі';

  @override
  String get migrationFormEditTitle => 'Змінити план кочівлі';

  @override
  String get migrationFormYear => 'Рік';

  @override
  String get migrationFormName => 'Назва';

  @override
  String get migrationFormDefaultName => 'План кочівлі';

  @override
  String get migrationFormSave => 'Зберегти';

  @override
  String get migrationFormDelete => 'Видалити план';

  @override
  String get migrationDeleteTitle => 'Видалити план кочівлі?';

  @override
  String get migrationDeleteMessage => 'План і всі його стоянки буде видалено.';

  @override
  String get migrationDeleteConfirm => 'Видалити';

  @override
  String get migrationSaved => 'План збережено';

  @override
  String get migrationDeleted => 'План видалено';

  @override
  String get stopFormNewTitle => 'Нова стоянка';

  @override
  String get stopFormEditTitle => 'Змінити стоянку';

  @override
  String get stopFormName => 'Медонос';

  @override
  String get stopFormNameHint => 'наприклад, Липа, Соняшник';

  @override
  String get stopFormPlace => 'Місце';

  @override
  String get stopFormPlaceHint => 'наприклад, Полтавщина';

  @override
  String get stopFormStart => 'Плановий початок';

  @override
  String get stopFormEnd => 'Плановий кінець';

  @override
  String get stopFormApiary => 'Пасіка призначення';

  @override
  String get stopFormChooseApiary => 'Вибрати пасіку призначення';

  @override
  String get stopFormNone => 'Немає';

  @override
  String get stopFormHiveCount => 'Вулики';

  @override
  String get stopFormPosition => 'Порядок на маршруті';

  @override
  String get stopFormStatus => 'Статус';

  @override
  String get stopFormDelete => 'Видалити стоянку';

  @override
  String get stopDeleteTitle => 'Видалити стоянку?';

  @override
  String get stopDeleteMessage => 'Стоянку буде видалено з плану.';

  @override
  String get stopSaved => 'Стоянку збережено';

  @override
  String get stopDeleted => 'Стоянку видалено';

  @override
  String get syncTableMigrations => 'План кочівлі';

  @override
  String get syncTableMigrationStops => 'Стоянка кочівлі';

  @override
  String get moveStart => 'Почати переїзд';

  @override
  String moveTitle(String route) {
    return 'Переїзд · $route';
  }

  @override
  String get moveNone => 'Найближчих переїздів немає';

  @override
  String get moreMigratory => 'Кочівля';

  @override
  String get syncTableTransports => 'Переїзд';

  @override
  String get syncTableTransportItems => 'Перевезений вулик';

  @override
  String get moveStepCheck => 'Перевірка';

  @override
  String get moveStepLoad => 'Завантаження';

  @override
  String get moveStepUnload => 'Розвантаження';

  @override
  String moveStepDone(String step) {
    return '$step, готово';
  }

  @override
  String get moveNoDestinationTitle => 'У стоянки немає пасіки';

  @override
  String get moveNoDestinationMessage =>
      'Виберіть пасіку призначення для стоянки, щоб після розвантаження оновилося розташування вуликів.';

  @override
  String get moveEditStop => 'Змінити стоянку';

  @override
  String get moveFrom => 'Звідки';

  @override
  String get moveTo => 'Куди';

  @override
  String moveSourceHives(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count активного вулика',
      many: '$count активних вуликів',
      few: '$count активні вулики',
      one: '$count активний вулик',
      zero: 'Немає активних вуликів',
    );
    return '$_temp0';
  }

  @override
  String get moveChecklist => 'Чек-лист завантаження';

  @override
  String get moveCheckEntrances => 'Льотки закрито';

  @override
  String get moveCheckVentilation => 'Вентиляцію відкрито';

  @override
  String get moveCheckStraps => 'Паси затягнуто';

  @override
  String get moveCheckWater => 'Воду приготовано';

  @override
  String get moveVehicles => 'Машини';

  @override
  String moveVehicleDefault(int number) {
    return 'Вантажівка $number';
  }

  @override
  String get moveAddVehicle => 'Додати машину';

  @override
  String moveRemoveVehicle(String vehicle) {
    return 'Видалити $vehicle';
  }

  @override
  String get moveVehicleName => 'Назва машини';

  @override
  String get moveVehicleExists => 'Машина з такою назвою вже є';

  @override
  String get moveStartLoading => 'Почати завантаження';

  @override
  String get moveChecklistHint =>
      'Позначте всі пункти, щоб почати завантаження.';

  @override
  String moveVehicleCount(String vehicle, int count) {
    return '$vehicle · $count';
  }

  @override
  String get moveLoaded => 'Завантажено';

  @override
  String get moveUnloaded => 'Розвантажено';

  @override
  String moveCountTotal(int total) {
    return '/ $total';
  }

  @override
  String moveCountLabel(int count, int total) {
    return '$count з $total вуликів';
  }

  @override
  String moveLastScanned(String number) {
    return 'Останній: $number';
  }

  @override
  String moveNotScanned(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count вулика ще не відскановано',
      many: '$count вуликів ще не відскановано',
      few: '$count вулики ще не відскановано',
      one: '$count вулик ще не відскановано',
    );
    return '$_temp0';
  }

  @override
  String get moveAllScanned => 'Усі відскановано';

  @override
  String get moveShowList => 'Показати список';

  @override
  String get moveMissingTitle => 'Невідскановані вулики';

  @override
  String get moveLoadingHint =>
      'Під час розвантаження на місці ви відскануєте вулики знову; я попереджу, якщо якогось бракуватиме. Розташування вуликів оновиться після розвантаження.';

  @override
  String moveUnloadingHint(String destination) {
    return 'Скануйте кожен вулик знову під час розвантаження. Коли закінчите, розвантажені вулики перейдуть на $destination.';
  }

  @override
  String get moveEnterNumber => 'Ввести номер';

  @override
  String get moveHiveNumber => 'Номер вулика';

  @override
  String moveNumberNotFound(String number) {
    return 'Вулика з номером $number немає';
  }

  @override
  String get moveScanStart => 'Почати сканування';

  @override
  String get moveScanContinue => 'Продовжити сканування';

  @override
  String get moveToUnloading => 'До розвантаження';

  @override
  String moveToUnloadingTitle(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count вулика не відскановано',
      many: '$count вуликів не відскановано',
      few: '$count вулики не відскановано',
      one: '$count вулик не відскановано',
    );
    return '$_temp0';
  }

  @override
  String get moveToUnloadingMessage =>
      'Невідскановані вулики не беруть участі в цьому переїзді й лишаються на місці.';

  @override
  String get moveFinish => 'Завершити переїзд';

  @override
  String moveFinishTitle(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count вулика не розвантажено',
      many: '$count вуликів не розвантажено',
      few: '$count вулики не розвантажено',
      one: '$count вулик не розвантажено',
    );
    return '$_temp0';
  }

  @override
  String moveFinishMessage(String source) {
    return 'Нерозвантажені вулики зберігають розташування: $source. Список відсутніх лишається в переїзді.';
  }

  @override
  String get moveFinishConfirm => 'Завершити';

  @override
  String get moveDoneTitle => 'Переїзд завершено';

  @override
  String moveDoneSummary(int loaded, int unloaded) {
    return 'Завантажено $loaded · Розвантажено $unloaded';
  }

  @override
  String moveDoneMoved(int count, String destination) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count вулика перевезено на $destination.',
      many: '$count вуликів перевезено на $destination.',
      few: '$count вулики перевезено на $destination.',
      one: '$count вулик перевезено на $destination.',
      zero: 'Вулики не перевезено.',
    );
    return '$_temp0';
  }

  @override
  String get moveDoneMissing => 'Нерозвантажені вулики';

  @override
  String moveScanLoaded(String number, String vehicle) {
    return '$number завантажено · $vehicle';
  }

  @override
  String moveScanLoadedOther(String number) {
    return '$number завантажено; цей вулик був не на цій пасіці';
  }

  @override
  String moveScanAlreadyLoaded(String number) {
    return '$number уже завантажено';
  }

  @override
  String moveScanUnloaded(String number) {
    return '$number розвантажено';
  }

  @override
  String moveScanAlreadyUnloaded(String number) {
    return '$number уже розвантажено';
  }

  @override
  String moveScanNotLoaded(String number) {
    return '$number не завантажували в цей переїзд';
  }

  @override
  String get moveScanUnknown => 'Невідома етикетка';

  @override
  String get moveScanDone => 'Готово';

  @override
  String get inventoryTitle => 'Матеріали та склад';

  @override
  String get inventoryAdd => 'Додати позицію';

  @override
  String get inventoryEmptyTitle => 'Складських позицій поки немає';

  @override
  String get inventoryEmptyMessage =>
      'Додайте матеріали — цукор, вощину, банки. Позиції нижче мінімуму буде позначено.';

  @override
  String get inventoryCategoryEmpty => 'У цій категорії немає позицій';

  @override
  String get inventoryLoadError => 'Не вдалося відкрити склад.';

  @override
  String get inventoryNotFound => 'Позицію не знайдено';

  @override
  String get inventoryCategoryConsumable => 'Витратні матеріали';

  @override
  String get inventoryCategoryEquipment => 'Інвентар';

  @override
  String get inventoryCategoryComb => 'Стільники';

  @override
  String get inventoryUnitKg => 'кг';

  @override
  String get inventoryUnitLiter => 'л';

  @override
  String get inventoryUnitPiece => 'шт.';

  @override
  String get inventoryUnitRoll => 'рул.';

  @override
  String get inventoryUnitPack => 'уп.';

  @override
  String get inventoryUnitNameKg => 'Кілограм';

  @override
  String get inventoryUnitNameLiter => 'Літр';

  @override
  String get inventoryUnitNamePiece => 'Штука';

  @override
  String get inventoryUnitNameRoll => 'Рулон';

  @override
  String get inventoryUnitNamePack => 'Упаковка';

  @override
  String inventoryQuantity(String quantity, String unit) {
    return '$quantity $unit';
  }

  @override
  String inventoryBelowThreshold(String threshold) {
    return 'Нижче мінімуму · мінімум $threshold';
  }

  @override
  String get inventoryMoveIn => 'Прихід';

  @override
  String get inventoryMoveOut => 'Витрата';

  @override
  String get inventoryMoveCount => 'Перерахунок';

  @override
  String get inventoryMoveAdjustment => 'Коригування';

  @override
  String inventoryInStock(String quantity) {
    return 'На складі: $quantity';
  }

  @override
  String inventoryAmountLabel(String unit) {
    return 'Кількість ($unit)';
  }

  @override
  String inventoryCountedLabel(String unit) {
    return 'Нараховано ($unit)';
  }

  @override
  String get inventoryAmountInvalid => 'Введіть коректну кількість';

  @override
  String get inventoryAmountWhole => 'Для цієї одиниці потрібне ціле число';

  @override
  String get inventorySaveIn => 'Оприбуткувати';

  @override
  String get inventorySaveOut => 'Списати';

  @override
  String get inventorySaveCount => 'Скоригувати залишок';

  @override
  String inventoryMovedIn(String quantity) {
    return 'Додано $quantity';
  }

  @override
  String inventoryMovedOut(String quantity) {
    return 'Списано $quantity';
  }

  @override
  String inventoryAdjusted(String quantity) {
    return 'Залишок тепер $quantity';
  }

  @override
  String inventoryUnchanged(String quantity) {
    return 'Залишок уже $quantity';
  }

  @override
  String get inventoryDetails => 'Подробиці та історія';

  @override
  String get inventoryHistory => 'Історія';

  @override
  String get inventoryHistoryEmpty => 'Рухів поки немає';

  @override
  String inventoryThreshold(String threshold) {
    return 'Мінімум: $threshold';
  }

  @override
  String get inventoryNoThreshold => 'Без мінімуму';

  @override
  String get inventoryQuickMove => 'Прихід / витрата';

  @override
  String get inventoryEdit => 'Змінити позицію';

  @override
  String get inventoryFormNewTitle => 'Нова позиція';

  @override
  String get inventoryFormEditTitle => 'Змінити позицію';

  @override
  String get inventoryFormName => 'Назва';

  @override
  String get inventoryFormCategory => 'Категорія';

  @override
  String get inventoryFormUnit => 'Одиниця';

  @override
  String get inventoryFormLocation => 'Місце зберігання';

  @override
  String get inventoryFormLocationHint =>
      'Склад, машина, офіс… Необов\'язково.';

  @override
  String get inventoryFormThreshold => 'Мінімум';

  @override
  String get inventoryFormThresholdHint =>
      'Попередимо, коли залишок опуститься нижче. Необов\'язково.';

  @override
  String get inventoryFormThresholdInvalid => 'Введіть коректний мінімум';

  @override
  String get inventoryFormSave => 'Зберегти';

  @override
  String get inventoryFormDelete => 'Видалити позицію';

  @override
  String get inventoryDeleteTitle => 'Видалити цю позицію?';

  @override
  String get inventoryDeleteMessage =>
      'Позиція та її залишок зникнуть зі списку.';

  @override
  String get inventoryDeleteConfirm => 'Видалити';

  @override
  String get inventorySaved => 'Позицію збережено';

  @override
  String get inventoryDeleted => 'Позицію видалено';

  @override
  String get syncTableInventoryItems => 'Складська позиція';

  @override
  String get syncTableInventoryMoves => 'Рух по складу';

  @override
  String inventoryIncrease(String quantity) {
    return '+$quantity';
  }

  @override
  String inventoryFormThresholdUnit(String unit) {
    return 'Мінімум ($unit)';
  }

  @override
  String get stockUseTitle => 'Списати зі складу';

  @override
  String get stockUseNone => 'Не списувати';

  @override
  String stockUseValue(String item, String quantity) {
    return '$item · −$quantity';
  }

  @override
  String get stockUseChoose => 'З якої позиції списати?';

  @override
  String get taskFormTreatment => 'Планова обробка';

  @override
  String get taskFormTreatmentUnknown => 'Препарату немає в переліку';

  @override
  String get taskFormTreatmentNeedsApiary =>
      'Виберіть пасіку для планової обробки';

  @override
  String taskTreatmentPlanTitle(String drug) {
    return 'Обробка · $drug';
  }

  @override
  String get shoppingTitle => 'Список покупок';

  @override
  String shoppingCardTitle(int count) {
    return 'Список покупок · $count';
  }

  @override
  String get shoppingEmptyTitle => 'Купувати нічого';

  @override
  String get shoppingEmptyMessage =>
      'Тут з\'являться позиції нижче мінімуму й те, що потрібно для планових обробок.';

  @override
  String get shoppingShare => 'Поділитися';

  @override
  String get shoppingLoadError => 'Не вдалося відкрити список покупок';

  @override
  String shoppingReasonThreshold(String stock, String threshold) {
    return 'На складі $stock · мін. $threshold';
  }

  @override
  String shoppingReasonPlanned(String quantity) {
    return 'Планові обробки $quantity';
  }

  @override
  String get shoppingReasonNoItem =>
      'Планова обробка · немає позиції на складі';

  @override
  String shoppingShareLine(String name, String quantity) {
    return '• $name: $quantity';
  }

  @override
  String get moreRearing => 'Виведення маток';

  @override
  String get rearingTitle => 'Виведення маток';

  @override
  String rearingBatchName(int number) {
    return 'Партія $number';
  }

  @override
  String rearingBatchTitle(int number) {
    return 'Виведення маток · Партія $number';
  }

  @override
  String get rearingAdd => 'Додати партію';

  @override
  String get rearingEmptyTitle => 'Партій поки немає';

  @override
  String get rearingEmptyMessage =>
      'Вкажіть день щеплення; графік від перевірки прийняття до перевірки засіву й нагадування створяться самі.';

  @override
  String get rearingLoadError => 'Не вдалося завантажити партії';

  @override
  String get rearingNotFound => 'Партію не знайдено';

  @override
  String rearingListGrafted(String date) {
    return 'щеплення $date';
  }

  @override
  String get rearingEdit => 'Змінити партію';

  @override
  String get rearingGraftedLabel => 'Щеплено';

  @override
  String get rearingAcceptedLabel => 'Прийнято';

  @override
  String get rearingNucsLabel => 'Нуклеуси';

  @override
  String get rearingNotCounted => 'Не пораховано';

  @override
  String rearingAcceptedPercent(int percent) {
    return '$percent%';
  }

  @override
  String rearingMotherLine(String mother, String date) {
    return 'Мати: $mother · щеплення $date';
  }

  @override
  String rearingMotherUnknownLine(String date) {
    return 'Мати невідома · щеплення $date';
  }

  @override
  String rearingDay(int day) {
    return 'Д$day';
  }

  @override
  String get rearingToday => 'Сьогодні';

  @override
  String get rearingStepGraft => 'Щеплення личинок';

  @override
  String get rearingStepAcceptance => 'Перевірка прийняття';

  @override
  String get rearingStepCapped => 'Маточники запечатано';

  @override
  String get rearingStepDistribution => 'Роздати маточники';

  @override
  String get rearingStepEmergence => 'Вихід маток';

  @override
  String get rearingStepLayingCheck => 'Перевірка засіву';

  @override
  String rearingStepGraftDetail(int count) {
    return 'Личинок: $count';
  }

  @override
  String rearingStepAcceptanceDetail(int count) {
    return 'Прийнято маточників: $count';
  }

  @override
  String get rearingStepAcceptanceTodo => 'Порахуйте прийняті маточники';

  @override
  String get rearingStepCappedDetail => 'Не турбувати';

  @override
  String rearingStepDistributionDetail(int count) {
    return 'До виходу, у нуклеуси: $count';
  }

  @override
  String get rearingStepDistributionTodo => 'До виходу, у нуклеуси';

  @override
  String get rearingStepEmergenceDetail => 'Перевірте нуклеуси';

  @override
  String get rearingStepLayingCheckDetail => 'Позначте вдале парування';

  @override
  String get rearingStepDone => 'готово';

  @override
  String get rearingStepCurrent => 'наступний';

  @override
  String get rearingStepUpcoming => 'попереду';

  @override
  String get rearingDistribute => 'Роздати маточники по нуклеусах';

  @override
  String get rearingDistributeApiary => 'Пасіка';

  @override
  String get rearingDistributeCount => 'Нуклеуси';

  @override
  String rearingDistributePlan(int reused, int created) {
    return 'Порожні нуклеуси знову: $reused · Нові: $created';
  }

  @override
  String get rearingDistributeSave => 'Роздати';

  @override
  String get rearingDistributeNoApiary => 'Спочатку додайте пасіку';

  @override
  String rearingDistributed(int count) {
    return 'Роздано по нуклеусах: $count';
  }

  @override
  String get rearingNucsSection => 'Нуклеуси для парування';

  @override
  String rearingNucTitle(String number) {
    return 'Нуклеус $number';
  }

  @override
  String get matingNucStatusEmpty => 'Порожній';

  @override
  String get matingNucStatusCell => 'Маточник';

  @override
  String get matingNucStatusVirgin => 'Неплідна матка';

  @override
  String get matingNucStatusLaying => 'Засіває';

  @override
  String get matingNucStatusFailed => 'Невдача';

  @override
  String get matingNucStatusGiven => 'Віддано у вулик';

  @override
  String get rearingNucGive => 'Віддати у вулик';

  @override
  String get rearingNucChooseHive => 'У який вулик?';

  @override
  String get rearingNucNoHives => 'Немає активних вуликів';

  @override
  String get rearingFormNewTitle => 'Нова партія';

  @override
  String get rearingFormEditTitle => 'Змінити партію';

  @override
  String get rearingFormGraftedOn => 'День щеплення';

  @override
  String get rearingFormGraftedCount => 'Щеплено личинок';

  @override
  String get rearingFormAcceptedCount => 'Прийнято маточників';

  @override
  String get rearingFormAcceptedClear => 'Ще не пораховано';

  @override
  String get rearingFormScheduleHint =>
      'Прийняття, запечатування, роздача, вихід і перевірка засіву додаються як завдання з нагадуваннями.';

  @override
  String get rearingFormSave => 'Зберегти';

  @override
  String get rearingFormDelete => 'Видалити партію';

  @override
  String get rearingDeleteTitle => 'Видалити партію?';

  @override
  String get rearingDeleteMessage =>
      'Її завдання теж видаляться. Нуклеуси й віддані матки залишаться.';

  @override
  String get rearingDeleteConfirm => 'Видалити';

  @override
  String get rearingDeleted => 'Партію видалено';

  @override
  String get rearingSaved => 'Партію збережено';

  @override
  String get taskSourceQueenRearing => 'виведення маток';

  @override
  String get syncTableQueenRearingBatches => 'Партія виведення маток';

  @override
  String get syncTableMatingNucs => 'Нуклеус для парування';

  @override
  String get lotsTitle => 'Медозбір і партії';

  @override
  String get lotsEmptyTitle => 'Партій поки немає';

  @override
  String get lotsEmptyMessage =>
      'Додайте медозбір до партії після збереження; партії з\'являться тут.';

  @override
  String get lotsLoadError => 'Не вдалося завантажити партії';

  @override
  String get lotsInStock => 'На складі';

  @override
  String get lotsPerHive => 'На вулик';

  @override
  String lotNumber(String number) {
    return 'Партія $number';
  }

  @override
  String lotHoneyTitle(String kind) {
    return 'Мед · $kind';
  }

  @override
  String get lotStatusOpen => 'Відкрита';

  @override
  String get lotStatusClosed => 'Закрита';

  @override
  String get lotWithdrawalBadge => 'У період очікування';

  @override
  String lotMoistureValue(String value) {
    return 'Вологість $value%';
  }

  @override
  String get lotAnalyzed => 'Проаналізовано ✓';

  @override
  String get lotAnalysisPending => 'Аналізу ще немає';

  @override
  String lotStockValue(String weight) {
    return 'Залишок $weight';
  }

  @override
  String get lotNotFound => 'Партію не знайдено';

  @override
  String get lotEdit => 'Змінити партію';

  @override
  String lotWithdrawalTitle(String hives) {
    return '$hives: мед відібрано в період очікування.';
  }

  @override
  String get lotWithdrawalMessage =>
      'У цій партії можуть бути залишки препаратів; здайте її на аналіз перед продажем.';

  @override
  String get lotStock => 'Залишок';

  @override
  String get lotHarvested => 'Відібрано';

  @override
  String get lotSold => 'Продано';

  @override
  String get lotInStock => 'На складі';

  @override
  String get lotSell => 'Записати продаж';

  @override
  String get lotAnalyses => 'Аналізи';

  @override
  String get lotAnalysesEmpty => 'Аналізів поки немає';

  @override
  String get lotAddAnalysis => 'Додати аналіз';

  @override
  String get lotHarvests => 'Медозбори';

  @override
  String get lotHarvestsEmpty => 'У цій партії немає медозборів';

  @override
  String get lotTreatments => 'Остання обробка вуликів';

  @override
  String get lotTreatmentsEmpty =>
      'Для вуликів цієї партії обробок не записано';

  @override
  String lotTreatmentTitle(String hive, String product) {
    return 'Вулик $hive · $product';
  }

  @override
  String lotTreatmentDetail(String date, String end) {
    return '$date · очікування до $end';
  }

  @override
  String get lotPublicPage => 'Публічна сторінка';

  @override
  String get lotPublish => 'Опублікувати';

  @override
  String get lotPublishHint =>
      'Будь-хто, хто відсканує QR, побачить сторінку партії. Телефон, адреса й розташування ніколи не показуються.';

  @override
  String get lotPublishOwnerOnly =>
      'Публікувати може лише власник господарства.';

  @override
  String get lotPublished => 'Опубліковано';

  @override
  String get lotNotPublished => 'Не опубліковано';

  @override
  String get lotPublicFields => 'Показується на сторінці';

  @override
  String get lotPublicProducer => 'Назва господарства й кількість вуликів';

  @override
  String get lotPublicOrigin => 'Походження й місяць збору';

  @override
  String get lotPublicLab => 'Показники аналізу';

  @override
  String get lotPublicReport => 'Протокол аналізу';

  @override
  String get lotJarLabels => 'Етикетки на банки (QR)';

  @override
  String get lotJarLabelsHint =>
      '24 етикетки на аркуші A4 (70 × 37 мм); друкуйте в масштабі 100%.';

  @override
  String lotJarLabelsDocumentName(String number) {
    return 'Етикетки на банки - $number';
  }

  @override
  String get lotSales => 'Продажі';

  @override
  String get lotSalesEmpty => 'Продажів поки немає';

  @override
  String lotSaleValue(String weight) {
    return '−$weight';
  }

  @override
  String lotSaleAmount(String unit) {
    return 'Продано меду ($unit)';
  }

  @override
  String lotSaleTooMuch(String weight) {
    return 'На складі лише $weight';
  }

  @override
  String get lotSaleSave => 'Списати зі складу';

  @override
  String lotSaleSaved(String weight) {
    return 'Продаж $weight записано';
  }

  @override
  String get lotOrigin => 'Походження';

  @override
  String get lotOriginHint => 'наприклад, Карпати';

  @override
  String get lotMoisture => 'Вологість %';

  @override
  String get lotMoistureHelper => 'За рефрактометром; необов\'язково';

  @override
  String get lotMoistureInvalid =>
      'Введіть значення від 10 до 30, наприклад 17,2';

  @override
  String lotEditTitle(String lot) {
    return 'Змінити: $lot';
  }

  @override
  String get lotStatus => 'Статус';

  @override
  String get lotStatusHelper =>
      'До закритої партії не можна додавати медозбори';

  @override
  String get lotSave => 'Зберегти';

  @override
  String get lotDelete => 'Видалити партію';

  @override
  String lotDeleteTitle(String lot) {
    return 'Видалити $lot?';
  }

  @override
  String get lotDeleteMessage =>
      'Аналізи й продажі теж видаляться; медозбори залишаться.';

  @override
  String get lotDeleted => 'Партію видалено';

  @override
  String labTitle(String lot) {
    return 'Аналіз · $lot';
  }

  @override
  String get labDate => 'Дата аналізу';

  @override
  String get labHmf => 'ГМФ (мг/кг)';

  @override
  String get labDiastase => 'Діастазне число';

  @override
  String get labProline => 'Пролін (мг/кг)';

  @override
  String labHmfValue(String value) {
    return 'ГМФ $value';
  }

  @override
  String labDiastaseValue(String value) {
    return 'Діастаза $value';
  }

  @override
  String labProlineValue(String value) {
    return 'Пролін $value';
  }

  @override
  String labValueInvalid(String min, String max) {
    return 'Введіть значення від $min до $max';
  }

  @override
  String get labResidue => 'Залишки';

  @override
  String get labResidueNone => 'Залишків немає';

  @override
  String get labResidueDetected => 'Залишки виявлено';

  @override
  String get labReport => 'Протокол';

  @override
  String get labReportNone => 'Без протоколу';

  @override
  String get labReportEmpty => 'У теці документів немає протоколів аналізу';

  @override
  String get labReportAdd => 'Додати протокол до теки документів';

  @override
  String get labSave => 'Зберегти аналіз';

  @override
  String get labSaved => 'Аналіз збережено';

  @override
  String get harvestLotTitle => 'Додати до партії';

  @override
  String harvestLotSaved(String weight, String kind) {
    return 'Медозбір збережено: $weight $kind';
  }

  @override
  String get harvestLotIntro =>
      'Коли мед потрапляє до партії, до неї прив\'язуються дати останніх обробок вуликів.';

  @override
  String get harvestLotNew => 'Нова партія';

  @override
  String harvestLotNewHint(String kind) {
    return '$kind · номер присвоїться автоматично';
  }

  @override
  String get harvestLotCreate => 'Створити партію';

  @override
  String get harvestLotAdd => 'Додати до партії';

  @override
  String get harvestLotSkip => 'Поки пропустити';

  @override
  String harvestLotCreated(String lot) {
    return '$lot створено';
  }

  @override
  String harvestLotAdded(String lot) {
    return 'Медозбір додано до $lot';
  }

  @override
  String get harvestLotGone => 'Медозбір скасовано';

  @override
  String get harvestLotBack => 'Назад до пасіки';

  @override
  String get syncTableLots => 'Партія';

  @override
  String get syncTableLotHarvests => 'Медозбір партії';

  @override
  String get syncTableLotTreatments => 'Обробка партії';

  @override
  String get syncTableLabResults => 'Результат аналізу';

  @override
  String get syncTableLotSales => 'Продаж партії';

  @override
  String get harvestLotGoneMessage =>
      'Медозбір не додано до партії. Його можна записати знову на пасіці.';

  @override
  String get financeTitle => 'Фінанси';

  @override
  String financeYearTitle(String year) {
    return 'Фінанси · $year';
  }

  @override
  String get financeSeasonNet => 'Підсумок сезону';

  @override
  String get financeIncome => 'Доходи';

  @override
  String get financeExpense => 'Витрати';

  @override
  String get financeCostPerHive => 'Витрати/вулик';

  @override
  String get financeRecent => 'Останні записи';

  @override
  String get financeEmptyTitle => 'Записів поки немає';

  @override
  String get financeEmptyMessage =>
      'Записуйте доходи й витрати кнопками нижче; підсумок сезону рахується тут.';

  @override
  String get financeLoadError => 'Не вдалося завантажити записи';

  @override
  String get financeAddIncome => '+ Дохід';

  @override
  String get financeAddExpense => '− Витрата';

  @override
  String financePlus(String amount) {
    return '+$amount';
  }

  @override
  String financeMinus(String amount) {
    return '−$amount';
  }

  @override
  String get financeReceiptAttached => 'чек додано';

  @override
  String financeTransportRoute(String from, String to) {
    return '$from → $to';
  }

  @override
  String get financeFormIncomeTitle => 'Додати дохід';

  @override
  String get financeFormExpenseTitle => 'Додати витрату';

  @override
  String financeFormAmount(String currency) {
    return 'Сума ($currency)';
  }

  @override
  String get financeFormAmountInvalid =>
      'Введіть суму більшу за 0, наприклад 17500 або 17,50';

  @override
  String get financeFormCategory => 'Категорія';

  @override
  String get financeFormDate => 'Дата';

  @override
  String get financeFormDescription => 'Опис';

  @override
  String get financeFormDescriptionHint => 'наприклад, Цукор 500 кг';

  @override
  String get financeFormReceipt => 'Чек / рахунок';

  @override
  String get financeFormNoReceipt => 'Без чека';

  @override
  String get financeFormReceiptAdded => 'Фото чека додано';

  @override
  String get financeFormTakePhoto => 'Сфотографувати';

  @override
  String get financeFormPickImage => 'З галереї';

  @override
  String get financeFormRemoveReceipt => 'Видалити чек';

  @override
  String get financeFormPhotoDenied =>
      'Доступ заборонено. Щоб додати чек, дозвольте цьому застосунку доступ до камери або фото в налаштуваннях.';

  @override
  String get financeFormPhotoFailed =>
      'Не вдалося отримати фото, спробуйте знову.';

  @override
  String get financeFormLinks => 'Пов\'язаний запис';

  @override
  String get financeFormApiary => 'Пасіка';

  @override
  String get financeFormLot => 'Партія';

  @override
  String get financeFormTransport => 'Переїзд';

  @override
  String get financeFormNone => 'Немає';

  @override
  String get financeFormChooseApiary => 'Вибрати пасіку';

  @override
  String get financeFormChooseLot => 'Вибрати партію';

  @override
  String get financeFormChooseTransport => 'Вибрати переїзд';

  @override
  String get financeFormNoLots => 'Партій поки немає';

  @override
  String get financeFormNoTransports => 'Переїздів поки немає';

  @override
  String financeFormSaleAmount(String unit) {
    return 'Продано меду ($unit)';
  }

  @override
  String get financeFormSaleHelper =>
      'Спишеться із залишку партії; залиште порожнім, щоб не змінювати залишок';

  @override
  String get financeFormSave => 'Зберегти';

  @override
  String get financeIncomeSaved => 'Дохід збережено';

  @override
  String get financeExpenseSaved => 'Витрату збережено';

  @override
  String get financeNotFound => 'Запис не знайдено';

  @override
  String get financeReceiptPending => 'Чек ще не надійшов на цей телефон';

  @override
  String get financeDelete => 'Видалити запис';

  @override
  String get financeDeleteTitle => 'Видалити цей запис?';

  @override
  String get financeDeleteMessage =>
      'Якщо він пов\'язаний із продажем партії, продаж теж видалиться, а залишок повернеться.';

  @override
  String get financeDeleteConfirm => 'Видалити';

  @override
  String get financeDeleted => 'Запис видалено';

  @override
  String get financeCategoryFeeding => 'Підгодівля';

  @override
  String get financeCategoryTreatment => 'Препарати';

  @override
  String get financeCategoryEquipment => 'Інвентар';

  @override
  String get financeCategoryFuelTransport => 'Пальне / транспорт';

  @override
  String get financeCategoryLandRent => 'Оренда землі';

  @override
  String get financeCategoryLabor => 'Оплата праці';

  @override
  String get financeCategoryLabAnalysis => 'Лабораторний аналіз';

  @override
  String get financeCategoryHoney => 'Мед';

  @override
  String get financeCategoryPollen => 'Пилок';

  @override
  String get financeCategoryPropolis => 'Прополіс';

  @override
  String get financeCategoryWax => 'Віск';

  @override
  String get financeCategoryNucs => 'Нуклеуси';

  @override
  String get financeCategoryQueens => 'Матки';

  @override
  String get financeCategoryOther => 'Інше';

  @override
  String get syncTableTransactions => 'Дохід/витрата';

  @override
  String get customersTitle => 'Книга покупців';

  @override
  String get customersAdd => 'Додати покупця';

  @override
  String get customersEmptyTitle => 'Покупців поки немає';

  @override
  String get customersEmptyMessage =>
      'Додавайте покупців, щоб стежити за їхніми замовленнями й боргами.';

  @override
  String customerReceivableValue(String amount) {
    return 'Борг $amount';
  }

  @override
  String get customerNoReceivable => 'Боргу немає';

  @override
  String get customerNotFound => 'Покупця не знайдено';

  @override
  String get customerEdit => 'Змінити покупця';

  @override
  String get customerAddSale => 'Додати продаж';

  @override
  String get customerOrders => 'Замовлення';

  @override
  String get customerNoOrders => 'Продажів цьому покупцеві поки немає.';

  @override
  String get customerPaid => 'Сплачено';

  @override
  String customerRemaining(String amount) {
    return 'Лишилося $amount';
  }

  @override
  String get customerPaidAmount => 'Сплачено на зараз';

  @override
  String get customerMarkPaid => 'Позначити сплаченим';

  @override
  String get customerMarkedPaid => 'Позначено як сплачене';

  @override
  String get customerAddPayment => 'Записати оплату';

  @override
  String get customerSendWhatsApp => 'Надіслати у WhatsApp';

  @override
  String get customerWhatsAppNoPhone =>
      'Немає телефона; виберіть контакт у WhatsApp';

  @override
  String get customerWhatsAppFailed => 'Не вдалося відкрити WhatsApp';

  @override
  String get customerOpenTransaction => 'Відкрити запис';

  @override
  String customerWhatsAppGreeting(String name) {
    return 'Доброго дня, $name!';
  }

  @override
  String get customerWhatsAppIntro => 'Ваше замовлення:';

  @override
  String customerWhatsAppAmount(String amount) {
    return 'Разом: $amount';
  }

  @override
  String customerWhatsAppPaid(String amount) {
    return 'Сплачено: $amount';
  }

  @override
  String customerWhatsAppRemaining(String amount) {
    return 'Лишилося: $amount';
  }

  @override
  String get customerWhatsAppPaidInFull => 'Сплачено повністю, дякуємо.';

  @override
  String customerWhatsAppAddress(String address) {
    return 'Адреса доставки: $address';
  }

  @override
  String get customerFormNewTitle => 'Новий покупець';

  @override
  String get customerFormEditTitle => 'Змінити покупця';

  @override
  String get customerFormName => 'Ім\'я';

  @override
  String get customerFormPhone => 'Телефон';

  @override
  String get customerFormPhoneHelper =>
      'Для WhatsApp, наприклад +380 67 123 4567';

  @override
  String get customerFormAddress => 'Адреса доставки';

  @override
  String get customerFormNotes => 'Нотатка';

  @override
  String get customerFormSave => 'Зберегти';

  @override
  String get customerSaved => 'Покупця збережено';

  @override
  String get customerDelete => 'Видалити покупця';

  @override
  String get customerDeleteTitle => 'Видалити покупця?';

  @override
  String get customerDeleteMessage =>
      'Його продажі залишаться у ваших доходах.';

  @override
  String get customerDeleteConfirm => 'Видалити';

  @override
  String get customerDeleted => 'Покупця видалено';

  @override
  String get customerPaymentSave => 'Зберегти оплату';

  @override
  String get customerPaymentSaved => 'Оплату збережено';

  @override
  String customerPaymentTooMuch(String amount) {
    return 'Лишилося лише $amount.';
  }

  @override
  String get financeFormCustomer => 'Покупець';

  @override
  String get financeFormChooseCustomer => 'Вибрати покупця';

  @override
  String get financeFormNoCustomers => 'Покупців поки немає';

  @override
  String get financeFormPaidNow => 'Сплачено зараз';

  @override
  String get financeFormPaidNowHelper =>
      'Залиште порожнім, якщо вся сума в борг.';

  @override
  String get financeFormPaidTooMuch => 'Не може бути більше за суму.';

  @override
  String get financeProfitTitle => 'Прибуток за пасіками';

  @override
  String get financeProfitUnknownApiary => 'Видалена пасіка';

  @override
  String financeReceivables(String amount, int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count покупця',
      many: '$count покупців',
      few: '$count покупці',
      one: '$count покупець',
    );
    return 'Борги $amount · $_temp0';
  }

  @override
  String get syncTableCustomers => 'Покупець';

  @override
  String get syncTableCustomerPayments => 'Оплата';

  @override
  String get customerUnpaid => 'Не сплачено';

  @override
  String customerPartiallyPaid(String paid, String remaining) {
    return 'Сплачено $paid, лишилося $remaining';
  }

  @override
  String get taskAksUpdateTitle => 'Не забудьте оновити AKS';

  @override
  String get taskSourceAks => 'AKS';

  @override
  String get syncTableRefSupportPeriods => 'Період субсидій';

  @override
  String get subsidiesTitle => 'Субсидії';

  @override
  String get subsidiesCheckTitle => 'Перед подачею заявки';

  @override
  String get subsidiesActiveHives => 'Активних вуликів у застосунку';

  @override
  String get subsidiesDeclaredHives => 'Заявлено в AKS';

  @override
  String get subsidiesNotDeclared => 'Не вказано';

  @override
  String get subsidiesCheckNotDeclared =>
      'Введіть кількість вуликів, заявлену в AKS; перед подачею її звірять із застосунком.';

  @override
  String subsidiesCheckDiffers(String active, String declared) {
    return 'У застосунку $active активних вуликів, а в AKS заявлено $declared. Оновіть запис в AKS перед подачею заявки.';
  }

  @override
  String get subsidiesCheckMatches =>
      'Числа збігаються: застосунок і AKS узгоджені.';

  @override
  String get subsidiesEditDeclared => 'Ввести заявлену кількість';

  @override
  String get subsidiesDeclaredOwnerOnly =>
      'Вводити заявлену кількість може лише власник.';

  @override
  String get subsidiesPeriodsTitle => 'Періоди подачі заявок';

  @override
  String get subsidiesEmptyTitle => 'Періодів субсидій поки немає';

  @override
  String get subsidiesEmptyMessage =>
      'Періоди подачі з\'являться тут, коли їх оголосять; коли період відкриється, надійде сповіщення.';

  @override
  String get subsidiesPhaseOpen => 'Відкрито';

  @override
  String get subsidiesPhaseUpcoming => 'Незабаром';

  @override
  String get subsidiesPhaseClosed => 'Закрито';

  @override
  String subsidiesPeriodDates(String start, String end) {
    return '$start – $end';
  }

  @override
  String get subsidiesOpenSource => 'Відкрити офіційне оголошення';

  @override
  String get subsidiesOpenSourceFailed => 'Не вдалося відкрити посилання';

  @override
  String get aksCountTitle => 'Кількість вуликів в AKS';

  @override
  String get aksCountLabel => 'Кількість вуликів, заявлена в AKS';

  @override
  String get aksCountHelper => 'Залиште порожнім, щоб пропустити звірку.';

  @override
  String get aksCountInvalid => 'Введіть число від 0 до 100 000';

  @override
  String get aksCountSave => 'Зберегти';

  @override
  String get aksCountSaved => 'Кількість вуликів в AKS збережено';

  @override
  String get aksCountNoOrganization =>
      'Дані господарства ще не синхронізовано з цим телефоном; дочекайтеся синхронізації.';

  @override
  String get knowledgeTitle => 'База знань';

  @override
  String get knowledgeSearchHint => 'Зимові запаси, варроа…';

  @override
  String knowledgeMonthLabel(String month, String place) {
    return '$month · $place';
  }

  @override
  String get knowledgePlaceTurkey => 'Туреччина';

  @override
  String get knowledgePlaceNorthern => 'Північна півкуля';

  @override
  String get knowledgePlaceSouthern => 'Південна півкуля';

  @override
  String get knowledgeMonthTitle => 'Що зробити цього місяця';

  @override
  String get knowledgeDiagnosisTitle => 'Помічник діагностики';

  @override
  String get knowledgeDiagnosisSubtitle =>
      'Виберіть ознаку, побачите можливі причини';

  @override
  String get knowledgeAtlasTitle => 'Атлас хвороб і шкідників';

  @override
  String knowledgeTopicCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count теми',
      many: '$count тем',
      few: '$count теми',
      one: '$count тема',
    );
    return '$_temp0';
  }

  @override
  String get knowledgeGuidesTitle => 'Технічні посібники';

  @override
  String get knowledgeGuidesSubtitle =>
      'Відводки, підсаджування маток, об\'єднання, зимівля';

  @override
  String get knowledgeCalculatorsTitle => 'Калькулятори';

  @override
  String get knowledgeCalculatorsSubtitle =>
      'Сироп, доза препарату, календар маток, медозбір';

  @override
  String get knowledgeRegulationsTitle => 'Огляди законодавства';

  @override
  String get knowledgeRegulationsSubtitle =>
      'Регламент, кочівля, стандарт на мед';

  @override
  String get knowledgeTrBadge => 'TR';

  @override
  String get knowledgeFirstYearTitle => 'Мій перший рік';

  @override
  String get knowledgeFirstYearSubtitle => 'Крок за кроком для початківців';

  @override
  String get knowledgeCalendarTitle => 'Календар сезону';

  @override
  String get knowledgeOffline => 'Усе відкривається без інтернету';

  @override
  String get knowledgeNoResultsTitle => 'Нічого не знайдено';

  @override
  String get knowledgeNoResultsMessage => 'Спробуйте інше слово.';

  @override
  String get knowledgeCategoryEmptyTitle => 'Статей поки немає';

  @override
  String get knowledgeCategoryEmptyMessage =>
      'Матеріали для цього розділу надійдуть з оновленням.';

  @override
  String get knowledgeArticleNotFound => 'Статтю не знайдено';

  @override
  String get knowledgeLoadError => 'Не вдалося відкрити базу знань';

  @override
  String get knowledgeLinkFailed => 'Не вдалося відкрити посилання';

  @override
  String get diagnosisSymptoms => 'Що ви бачите';

  @override
  String get diagnosisSymptomsHelper => 'Можна вибрати кілька.';

  @override
  String get diagnosisResults => 'Можливі хвороби';

  @override
  String get diagnosisPickHint =>
      'Виберіть ознаку, щоб побачити тут можливі хвороби.';

  @override
  String get diagnosisNoMatch =>
      'Жодна хвороба не відповідає вибраним ознакам.';

  @override
  String diagnosisMatched(int matched, int total) {
    return 'Збіжних ознак: $matched/$total';
  }

  @override
  String get diagnosisNotifiable => 'Підлягає повідомленню';

  @override
  String get diagnosisDisclaimer =>
      'Це первинна оцінка; остаточний діагноз ставить ветеринар або лабораторія.';

  @override
  String get diagnosisLoadError => 'Не вдалося відкрити таблицю діагностики';

  @override
  String get diagnosisNotFound => 'Хворобу не знайдено';

  @override
  String get diagnosisNotifiableTitle => 'Хвороба, що підлягає повідомленню.';

  @override
  String get diagnosisNotifiableMessage =>
      'Повідомте про підозру ветслужбу; не передавайте інвентар, рамки й мед цього вулика іншим вуликам.';

  @override
  String get diagnosisAdvice => 'Що робити';

  @override
  String get diagnosisAuthority => 'Куди звертатися';

  @override
  String diagnosisCall(String phone) {
    return 'Зателефонувати $phone';
  }

  @override
  String get diagnosisCallFailed => 'Не вдалося почати дзвінок';

  @override
  String get diagnosisQuarantine => 'Помістити вулик на карантин';

  @override
  String get quarantinePickTitle => 'Вулик для карантину';

  @override
  String get quarantineSearchHint => 'Номер вулика';

  @override
  String get quarantineNoHivesTitle => 'Немає вуликів';

  @override
  String get quarantineNoHivesMessage =>
      'Немає активних вуликів для карантину.';

  @override
  String quarantineDone(String number) {
    return 'Вулик $number на карантині';
  }

  @override
  String get hiveQuarantined => 'На карантині';

  @override
  String hiveQuarantineDisease(String disease) {
    return 'Підозра: $disease';
  }

  @override
  String hiveQuarantineSince(String date) {
    return 'З $date';
  }

  @override
  String get hiveQuarantineWarning =>
      'Не передавайте його інвентар, рамки й мед іншим вуликам.';

  @override
  String get hiveQuarantineEnd => 'Зняти карантин';

  @override
  String hiveQuarantineEnded(String number) {
    return 'Карантин із вулика $number знято';
  }

  @override
  String get calculatorSyrup => 'Сироп';

  @override
  String get calculatorSyrupSubtitle => 'Скільки потрібно цукру й води';

  @override
  String get calculatorDose => 'Доза препарату';

  @override
  String get calculatorDoseSubtitle => 'Усього на вашу кількість вуликів';

  @override
  String get calculatorQueen => 'Календар маток';

  @override
  String get calculatorQueenSubtitle => 'Дні етапів від щеплення';

  @override
  String get calculatorYield => 'Медозбір';

  @override
  String get calculatorYieldSubtitle => 'Мед на вулик';

  @override
  String get calculatorOffline =>
      'Розрахунки працюють без інтернету й нічого не зберігають.';

  @override
  String get calculatorNotFound => 'Калькулятор не знайдено';

  @override
  String get calculatorHives => 'Кількість вуликів';

  @override
  String get calculatorSyrupKind => 'Вид сиропу';

  @override
  String get calculatorFillHint => 'Введіть кількість вуликів і кількість.';

  @override
  String get calculatorDosePerHive => 'Доза на вулик';

  @override
  String get calculatorDoseUnit => 'Одиниця';

  @override
  String get calculatorTotal => 'Усього';

  @override
  String calculatorDoseTotal(String unit, String total) {
    String _temp0 = intl.Intl.selectLogic(unit, {
      'strip': '$total смуж.',
      'ml': '$total мл',
      'g': '$total г',
      'other': '$total доз',
    });
    return '$_temp0';
  }

  @override
  String calculatorDoseCount(int count, String amount) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count вулика × $amount',
      many: '$count вуликів × $amount',
      few: '$count вулики × $amount',
      one: '$count вулик × $amount',
    );
    return '$_temp0';
  }

  @override
  String calculatorYieldTotal(String unit) {
    return 'Усього меду ($unit)';
  }

  @override
  String get calculatorYieldPerHive => 'На вулик';

  @override
  String calculatorYieldValue(String amount, String unit) {
    return '$amount $unit';
  }

  @override
  String get calculatorQueenSteps => 'Етапи';

  @override
  String get hiveLossWintering => 'Зимівля';

  @override
  String get hiveLossQueenless => 'Безматковість';

  @override
  String get hiveLossVarroa => 'Варроа';

  @override
  String get hiveLossDisease => 'Хвороба';

  @override
  String get hiveLossStarvation => 'Голод';

  @override
  String get hiveLossRobbing => 'Крадіжка';

  @override
  String get hiveLossPredator => 'Ведмідь / тварина';

  @override
  String get hiveLossPoisoning => 'Отруєння';

  @override
  String get hiveLossOther => 'Інше';

  @override
  String get hiveLossUnspecified => 'Не вказано';

  @override
  String hiveLossReasonTitle(String number) {
    return 'Чому загинув вулик $number?';
  }

  @override
  String get hiveLossSkip => 'Пропустити без причини';

  @override
  String get hiveFormLossReason => 'Причина втрати';

  @override
  String get hiveFormLossReasonHelper =>
      'Використовується у звіті за сезон; можна не заповнювати.';

  @override
  String get seasonReportTile => 'Звіт за сезон';

  @override
  String seasonTitle(String year) {
    return 'Сезон $year';
  }

  @override
  String get seasonPdf => 'PDF';

  @override
  String get seasonExportCsv => 'Експорт в Excel (CSV)';

  @override
  String get seasonExportError => 'Не вдалося створити файл. Спробуйте знову.';

  @override
  String get seasonLoadError => 'Не вдалося завантажити звіт за сезон.';

  @override
  String get seasonHives => 'Вулики';

  @override
  String seasonHiveChange(int start, int end) {
    return '$start → $end';
  }

  @override
  String seasonNetGain(int count) {
    return '+$count чисто';
  }

  @override
  String seasonNetLoss(int count) {
    return '−$count чисто';
  }

  @override
  String get seasonNetSame => 'Без змін';

  @override
  String get seasonWinterLoss => 'Зимові втрати';

  @override
  String get seasonWinterNotStarted => 'Зима ще не почалася';

  @override
  String seasonPreviousWinter(String year) {
    return 'Зимові втрати $year';
  }

  @override
  String seasonPreviousWinterRate(String year, String rate) {
    return '$year: $rate';
  }

  @override
  String get seasonHoney => 'Усього меду';

  @override
  String get seasonNewQueens => 'Нові матки';

  @override
  String seasonOwnReared(int count) {
    return 'власне виведення $count';
  }

  @override
  String get seasonLossesTitle => 'Втрати й причини';

  @override
  String get seasonNoLosses => 'Цього сезону вулики не втрачалися.';

  @override
  String seasonHiveCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count вулика',
      many: '$count вуликів',
      few: '$count вулики',
      one: '$count вулик',
    );
    return '$_temp0';
  }

  @override
  String get seasonByTreatment => 'Зимові втрати · за способом обробки';

  @override
  String get seasonByApiary => 'Зимові втрати · за пасіками';

  @override
  String get seasonByQueenLine => 'Зимові втрати · за лініями маток';

  @override
  String get seasonTabTreatment => 'Обробка';

  @override
  String get seasonTabApiary => 'Пасіка';

  @override
  String get seasonTabQueenLine => 'Лінія матки';

  @override
  String get seasonNoWinterData =>
      'У ваших записах поки немає вуликів, що пішли в зиму.';

  @override
  String get seasonFewData => 'мало даних';

  @override
  String get seasonMisleadingNote =>
      'За вашими записами; за малої кількості вуликів може вводити в оману.';

  @override
  String get seasonUntreated => 'Без обробки';

  @override
  String get seasonMethodSeparator => ' +';

  @override
  String get seasonQueenLineUnknown => 'Невідома лінія';

  @override
  String get seasonFinanceTitle => 'Витрати й прибуток';

  @override
  String get seasonProfit => 'Прибуток';

  @override
  String get seasonPdfFigure => 'Показник';

  @override
  String get seasonPdfValue => 'Значення';

  @override
  String seasonPdfHiveChange(int start, int end, String net) {
    return '$start → $end ($net)';
  }

  @override
  String seasonPdfNewQueens(int count, int own) {
    return '$count (власне виведення $own)';
  }

  @override
  String seasonPdfWinterLoss(String rate, int lost, int hives) {
    return '$rate ($lost з $hives вуликів)';
  }

  @override
  String get seasonPdfReason => 'Причина';

  @override
  String get seasonPdfHives => 'Вулики';

  @override
  String get seasonPdfLost => 'Втрачено';

  @override
  String get seasonPdfRate => 'Втрати';

  @override
  String get seasonPdfGroup => 'Група';

  @override
  String get seasonPdfTotal => 'Разом';

  @override
  String get seasonCsvHive => 'Вулик';

  @override
  String get seasonCsvApiary => 'Пасіка';

  @override
  String get seasonCsvStartStatus => 'Статус на початку сезону';

  @override
  String get seasonCsvEndStatus => 'Статус наприкінці сезону';

  @override
  String get seasonCsvLossDate => 'Дата втрати';

  @override
  String get seasonCsvLossReason => 'Причина втрати';

  @override
  String get seasonCsvInWinter => 'Пішов у зиму';

  @override
  String get seasonCsvLostInWinter => 'Загинув узимку';

  @override
  String get seasonCsvWinterApiary => 'Зимова пасіка';

  @override
  String get seasonCsvTreatment => 'Обробка перед зимою';

  @override
  String get seasonCsvQueenLine => 'Лінія матки';

  @override
  String get seasonCsvAddedInSeason => 'Додано цього сезону';

  @override
  String get seasonCsvYes => 'Так';

  @override
  String get seasonCsvNo => 'Ні';

  @override
  String get offlineMapsTitle => 'Офлайн-мапи';

  @override
  String get offlineMapsIntro =>
      'Завантажте околиці пасік; мапа відкриється навіть без зв\'язку.';

  @override
  String offlineMapsMegabytes(String size) {
    return '$size МБ';
  }

  @override
  String offlineMapsApproxSize(String size) {
    return '≈ $size';
  }

  @override
  String offlineMapsDownloaded(String size) {
    return 'Завантажено · $size';
  }

  @override
  String offlineMapsDownloadingWifi(String received, String total) {
    return 'Завантаження через Wi‑Fi · $received / $total';
  }

  @override
  String offlineMapsDownloading(String received, String total) {
    return 'Завантаження · $received / $total';
  }

  @override
  String offlineMapsDownload(String name) {
    return 'Завантажити $name';
  }

  @override
  String get offlineMapsCancel => 'Зупинити завантаження';

  @override
  String offlineMapsDelete(String name) {
    return 'Видалити $name';
  }

  @override
  String offlineMapsDeleteTitle(String name) {
    return 'Видалити $name?';
  }

  @override
  String get offlineMapsDeleteMessage =>
      'Без інтернету мапа довкола цієї пасіки не відкриється. Її можна знову завантажити будь-коли.';

  @override
  String get offlineMapsDeleteConfirm => 'Видалити';

  @override
  String get offlineMapsWifiOnly => 'Завантажувати лише через Wi‑Fi';

  @override
  String get offlineMapsWifiOnlyHint =>
      'Кілька МБ на пасіку; мобільний трафік не витрачається.';

  @override
  String offlineMapsStop(String name) {
    return 'Стоянка $name';
  }

  @override
  String offlineMapsDone(String name) {
    return 'Околиці $name завантажено';
  }

  @override
  String offlineMapsFailed(String name) {
    return 'Не вдалося завантажити околиці $name. Перевірте підключення й спробуйте знову.';
  }

  @override
  String get offlineMapsNeedsWifi =>
      'Підключіться до Wi‑Fi або вимкніть «Завантажувати лише через Wi‑Fi».';

  @override
  String get offlineMapsAttribution =>
      'Картографічні дані © OpenStreetMap contributors · OpenFreeMap';

  @override
  String get settingsOfflineMaps => 'Офлайн-мапи';

  @override
  String settingsOfflineMapsValue(int count, String size) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count пасіки · $size',
      many: '$count пасік · $size',
      few: '$count пасіки · $size',
      one: '$count пасіка · $size',
      zero: 'Немає',
    );
    return '$_temp0';
  }

  @override
  String get offlineMapsCoverage =>
      'Для кожної пасіки — 6 км довкола детально й 40 км оглядово.';

  @override
  String offlineMapsDownloadedOn(String date) {
    return 'завантажено: $date';
  }

  @override
  String get offlineMapsToDownload => 'Пасіки для завантаження';

  @override
  String get offlineMapsMoved => 'Пасіку перенесено, завантажте знову';

  @override
  String get offlineMapsNoApiaries =>
      'Немає пасік із розташуванням. Додайте пасіці розташування, і вона з\'явиться тут.';

  @override
  String get offlineMapsAllDownloaded =>
      'Усі пасіки з розташуванням завантажено.';

  @override
  String get syncReminderTitle => 'Ваші записи ще не збережено на сервері';

  @override
  String syncReminderBody(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other:
          '$count запису уже 3 дні не доходять до сервера. Відкрийте застосунок, коли буде інтернет.',
      many:
          '$count записів уже 3 дні не доходять до сервера. Відкрийте застосунок, коли буде інтернет.',
      few:
          '$count записи уже 3 дні не доходять до сервера. Відкрийте застосунок, коли буде інтернет.',
      one:
          '$count запис уже 3 дні не доходить до сервера. Відкрийте застосунок, коли буде інтернет.',
    );
    return '$_temp0';
  }

  @override
  String get syncOverdueTitle => 'Понад 3 дні без резервної копії';

  @override
  String syncOverdueMessage(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other:
          '$count запису є лише на цьому телефоні. Якщо телефон загубиться, вони пропадуть. Підключіться до інтернету й синхронізуйте.',
      many:
          '$count записів є лише на цьому телефоні. Якщо телефон загубиться, вони пропадуть. Підключіться до інтернету й синхронізуйте.',
      few:
          '$count записи є лише на цьому телефоні. Якщо телефон загубиться, вони пропадуть. Підключіться до інтернету й синхронізуйте.',
      one:
          '$count запис є лише на цьому телефоні. Якщо телефон загубиться, він пропаде. Підключіться до інтернету й синхронізуйте.',
    );
    return '$_temp0';
  }

  @override
  String syncDaysAgo(int days) {
    String _temp0 = intl.Intl.pluralLogic(
      days,
      locale: localeName,
      other: '$days дня тому',
      many: '$days днів тому',
      few: '$days дні тому',
      one: '$days день тому',
      zero: 'сьогодні',
    );
    return '$_temp0';
  }

  @override
  String syncLastSyncedAgo(String ago, String when) {
    return 'Остання синхронізація $ago · $when';
  }

  @override
  String syncPendingTitle(int count) {
    return 'Чекають на надсилання · $count';
  }

  @override
  String settingsSignOutPendingMessage(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other:
          '$count запису ще не надіслано на сервер, і вони є лише на цьому телефоні. Якщо ви вийдете, їх не буде надіслано. Спочатку підключіться до інтернету й синхронізуйте.',
      many:
          '$count записів ще не надіслано на сервер, і вони є лише на цьому телефоні. Якщо ви вийдете, їх не буде надіслано. Спочатку підключіться до інтернету й синхронізуйте.',
      few:
          '$count записи ще не надіслано на сервер, і вони є лише на цьому телефоні. Якщо ви вийдете, їх не буде надіслано. Спочатку підключіться до інтернету й синхронізуйте.',
      one:
          '$count запис ще не надіслано на сервер, і він є лише на цьому телефоні. Якщо ви вийдете, його не буде надіслано. Спочатку підключіться до інтернету й синхронізуйте.',
    );
    return '$_temp0';
  }

  @override
  String get settingsSignOutAnyway => 'Усе одно вийти';

  @override
  String get settingsExport => 'Експорт даних';

  @override
  String get settingsExportValue => 'Excel';

  @override
  String get settingsExportHint =>
      'Усі ваші записи в одному файлі Excel; поділіться ним або збережіть будь-де.';

  @override
  String get exportPreparing => 'Готуємо…';

  @override
  String get exportFailed => 'Не вдалося підготувати файл. Спробуйте знову.';

  @override
  String exportFileName(String date) {
    return 'Mobil Arıcı $date';
  }

  @override
  String get exportYes => 'Так';

  @override
  String get exportNo => 'Ні';

  @override
  String get exportSheetApiaries => 'Пасіки';

  @override
  String get exportSheetHives => 'Вулики';

  @override
  String get exportSheetQueens => 'Матки';

  @override
  String get exportSheetInspections => 'Огляди';

  @override
  String get exportSheetFeedings => 'Підгодівлі';

  @override
  String get exportSheetTreatments => 'Обробки';

  @override
  String get exportSheetMiteCounts => 'Підрахунки кліща';

  @override
  String get exportSheetHarvests => 'Медозбори';

  @override
  String get exportSheetTasks => 'Завдання';

  @override
  String get exportSheetInventory => 'Склад';

  @override
  String get exportSheetFinance => 'Доходи й витрати';

  @override
  String get exportColName => 'Назва';

  @override
  String get exportColLatitude => 'Широта';

  @override
  String get exportColLongitude => 'Довгота';

  @override
  String get exportColAltitude => 'Висота (м)';

  @override
  String get exportColWaterSource => 'Джерело води';

  @override
  String get exportColVehicleDistance => 'Відстань до машини (м)';

  @override
  String get exportColRoadNotes => 'Нотатки про дорогу';

  @override
  String get exportColNotes => 'Нотатки';

  @override
  String get exportColActiveHives => 'Активних вуликів';

  @override
  String get exportColCreated => 'Додано';

  @override
  String get exportColApiary => 'Пасіка';

  @override
  String get exportColHive => 'Вулик';

  @override
  String get exportColType => 'Тип';

  @override
  String get exportColStatus => 'Статус';

  @override
  String get exportColBoxes => 'Корпуси';

  @override
  String get exportColFrames => 'Рамки';

  @override
  String get exportColSource => 'Походження';

  @override
  String get exportColMarking => 'Маркування';

  @override
  String get exportColTag => 'Код етикетки';

  @override
  String get exportColQuarantine => 'Карантин';

  @override
  String get exportColQueen => 'Матка';

  @override
  String get exportColYear => 'Рік';

  @override
  String get exportColColor => 'Колір мітки';

  @override
  String get exportColBreed => 'Порода';

  @override
  String get exportColLine => 'Лінія';

  @override
  String get exportColWingClipped => 'Крило підрізане';

  @override
  String get exportColDate => 'Дата';

  @override
  String get exportColQueenState => 'Матка';

  @override
  String get exportColBeeFrames => 'Рамок із бджолами';

  @override
  String get exportColBroodFrames => 'Рамок із розплодом';

  @override
  String get exportColHoneyFrames => 'Рамок із медом';

  @override
  String get exportColTemperament => 'Вдача';

  @override
  String get exportColSwarmSigns => 'Ознаки роїння';

  @override
  String get exportColQueenCells => 'Маточники';

  @override
  String get exportColDisease => 'Підозра на хворобу';

  @override
  String get exportColActions => 'Зроблено';

  @override
  String get exportColAmount => 'Кількість';

  @override
  String get exportColUnit => 'Одиниця';

  @override
  String get exportColProduct => 'Препарат';

  @override
  String get exportColActiveIngredient => 'Діюча речовина';

  @override
  String get exportColDose => 'Доза';

  @override
  String get exportColWithdrawal => 'Очікування (днів)';

  @override
  String get exportColBatch => '№ партії';

  @override
  String get exportColPlannedRemoval => 'Планове зняття';

  @override
  String get exportColMethod => 'Метод';

  @override
  String get exportColMites => 'Кліщі';

  @override
  String get exportColSampleBees => 'Бджіл у пробі';

  @override
  String get exportColDays => 'Дні';

  @override
  String get exportColResult => 'Результат';

  @override
  String get exportColHoneyKind => 'Мед';

  @override
  String get exportColUnitCount => 'Кількість';

  @override
  String get exportColNetKg => 'Нетто (кг)';

  @override
  String get exportColHiveCount => 'Вулики';

  @override
  String get exportColDue => 'Термін';

  @override
  String get exportColTitle => 'Назва';

  @override
  String get exportColCompleted => 'Виконано';

  @override
  String get exportColCategory => 'Категорія';

  @override
  String get exportColPlace => 'Місце';

  @override
  String get exportColStock => 'На складі';

  @override
  String get exportColThreshold => 'Попереджати нижче';

  @override
  String get exportColCurrency => 'Валюта';

  @override
  String get exportColDescription => 'Опис';

  @override
  String get businessTitle => 'Господарство';

  @override
  String get businessEdit => 'Змінити';

  @override
  String get businessEditTitle => 'Змінити господарство';

  @override
  String get businessCancel => 'Скасувати';

  @override
  String get businessSave => 'Зберегти';

  @override
  String get businessSaveError =>
      'Не вдалося зберегти; господарства ще немає на цьому телефоні.';

  @override
  String get businessMissingTitle => 'Немає даних господарства';

  @override
  String get businessMissingMessage =>
      'Вони з\'являться тут, коли господарство надійде на цей телефон.';

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
  String get businessRegionTr => 'Профіль TR';

  @override
  String get businessRegionOther => 'Загальний профіль';

  @override
  String get businessPendingSync => 'Ще не синхронізовано';

  @override
  String businessCountHives(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'вулика',
      many: 'вуликів',
      few: 'вулики',
      one: 'вулик',
    );
    return '$_temp0';
  }

  @override
  String businessCountApiaries(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'пасіки',
      many: 'пасік',
      few: 'пасіки',
      one: 'пасіка',
    );
    return '$_temp0';
  }

  @override
  String businessCountInspections(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'огляду',
      many: 'оглядів',
      few: 'огляди',
      one: 'огляд',
    );
    return '$_temp0';
  }

  @override
  String get businessSectionBusiness => 'Господарство';

  @override
  String get businessSectionAccount => 'Обліковий запис';

  @override
  String get businessType => 'Тип';

  @override
  String get businessTypeMigratory => 'Кочове';

  @override
  String get businessTypeStationary => 'Стаціонарне';

  @override
  String get businessTypeHelp =>
      'Для стаціонарного господарства плани кочівлі й переїзди приховано; записи не видаляються.';

  @override
  String get businessCurrency => 'Валюта';

  @override
  String get businessCurrencySearch => 'Пошук за кодом або країною';

  @override
  String get businessCurrencyNoMatch => 'Жодна валюта не відповідає пошуку.';

  @override
  String get businessCurrencyNote =>
      'Минулі записи не перераховуються; нова валюта діє лише для нових записів.';

  @override
  String businessTeamTitle(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Команда · $count людини',
      many: 'Команда · $count людей',
      few: 'Команда · $count людини',
      one: 'Команда · $count людина',
    );
    return '$_temp0';
  }

  @override
  String get businessTeamSolo => 'Учасників команди поки немає';

  @override
  String businessRoleCountOwner(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count власника',
      many: '$count власників',
      few: '$count власники',
      one: '$count власник',
    );
    return '$_temp0';
  }

  @override
  String businessRoleCountPartner(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count партнера',
      many: '$count партнерів',
      few: '$count партнери',
      one: '$count партнер',
    );
    return '$_temp0';
  }

  @override
  String businessRoleCountWorker(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count працівника',
      many: '$count працівників',
      few: '$count працівники',
      one: '$count працівник',
    );
    return '$_temp0';
  }

  @override
  String businessRoleCountViewer(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count консультанта',
      many: '$count консультантів',
      few: '$count консультанти',
      one: '$count консультант',
    );
    return '$_temp0';
  }

  @override
  String get businessEmail => 'Пошта для входу';

  @override
  String get businessEmailSoon => 'Зміна пошти незабаром з\'явиться.';

  @override
  String get businessFirstRecord => 'Перший запис';

  @override
  String businessFirstRecordValue(String date, int season) {
    return '$date · сезон $season';
  }

  @override
  String get businessSettingsShortcut => 'Мова, одиниці, тема й дані';

  @override
  String get businessNameLabel => 'Назва господарства';

  @override
  String get businessAvatarLabel => 'Аватар';

  @override
  String get businessAvatarHelp =>
      'Без логотипа показуються ваші ініціали у вибраному кольорі.';

  @override
  String get businessAvatarPine => 'Сосна';

  @override
  String get businessAvatarHoney => 'Мед';

  @override
  String get businessAvatarSky => 'Небо';

  @override
  String get businessAvatarSlate => 'Сланець';

  @override
  String get businessLogoUpload => 'Завантажити логотип';

  @override
  String get businessLogoRemove => 'Видалити логотип';

  @override
  String get businessDiscardTitle => 'Скасувати зміни?';

  @override
  String get businessDiscardMessage => 'Незбережені зміни буде втрачено.';

  @override
  String get businessDiscardAction => 'Скасувати';

  @override
  String get businessTypeConfirmTitle => 'Зробити господарство стаціонарним?';

  @override
  String businessTypeConfirmMessage(int plans, int stops) {
    String _temp0 = intl.Intl.pluralLogic(
      plans,
      locale: localeName,
      other: '$plans плану кочівлі',
      many: '$plans планів кочівлі',
      few: '$plans плани кочівлі',
      one: '$plans план кочівлі',
    );
    String _temp1 = intl.Intl.pluralLogic(
      stops,
      locale: localeName,
      other: '$stops стоянки',
      many: '$stops стоянок',
      few: '$stops стоянки',
      one: '$stops стоянку',
    );
    return 'Буде приховано $_temp0 і $_temp1. Записи не видаляються; це можна скасувати.';
  }

  @override
  String get businessTypeConfirmAction => 'Зробити';

  @override
  String get businessReadOnly =>
      'Дані господарства можуть змінювати лише власник і партнери.';

  @override
  String get financeOtherCurrencies => 'Інші валюти';

  @override
  String financeOtherCurrencyLine(String currency, String amount) {
    return '$currency · підсумок $amount';
  }

  @override
  String get migratoryHiddenTitle => 'Модуль кочівлі вимкнено';

  @override
  String get migratoryHiddenMessage =>
      'Ваше господарство стаціонарне. Плани кочівлі й переїзди не видалено; вони повернуться, якщо ви перемкнетеся на кочове.';

  @override
  String get onboardingMigratoryTitle => 'Ви кочуєте з вуликами?';

  @override
  String get onboardingMigratoryMessage =>
      'Якщо ні, плани кочівлі й переїзди буде приховано; це можна змінити в профілі господарства.';

  @override
  String get onboardingMigratoryYes => 'Так';

  @override
  String get onboardingMigratoryNo => 'Ні, стаціонарно';

  @override
  String get settingsDeleteAccount => 'Видалити мій обліковий запис';

  @override
  String get settingsDeleteAccountOffline =>
      'Для видалення облікового запису потрібен інтернет; спробуйте знову, коли будете в мережі.';

  @override
  String get deletionTitle => 'Видалити мій обліковий запис';

  @override
  String deletionStepCounter(int current, int total) {
    return 'Крок $current з $total';
  }

  @override
  String get deletionContinue => 'Продовжити';

  @override
  String get deletionSoloTitle =>
      'Буде видалено ваш обліковий запис і господарство';

  @override
  String deletionSoloMessage(String organization) {
    return 'Ви єдиний учасник $organization. Разом з обліковим записом видаляться господарство й усі його записи.';
  }

  @override
  String get deletionCountsLabel => 'Буде видалено записи';

  @override
  String get deletionCountHives => 'Вулики';

  @override
  String get deletionCountApiaries => 'Пасіки';

  @override
  String get deletionCountInspections => 'Огляди';

  @override
  String get deletionCountHarvests => 'Медозбори';

  @override
  String get deletionCountDocuments => 'Документи';

  @override
  String get deletionCountPhotos => 'Фото';

  @override
  String get deletionLotWarningTitle => 'QR-коди перестануть працювати.';

  @override
  String deletionLotWarningMessage(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other:
          'Буде видалено $count публічної сторінки партій, і QR-коди на ваших банках перестануть працювати.',
      many:
          'Буде видалено $count публічних сторінок партій, і QR-коди на ваших банках перестануть працювати.',
      few:
          'Буде видалено $count публічні сторінки партій, і QR-коди на ваших банках перестануть працювати.',
      one:
          'Буде видалено $count публічну сторінку партії, і QR-коди на ваших банках перестануть працювати.',
    );
    return '$_temp0';
  }

  @override
  String get deletionTeamTitle =>
      'У вас є команда: виберіть, що буде з господарством';

  @override
  String deletionTeamMessage(int count, String organization) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Ви власник $organization, у команді є ще $count людини.',
      many: 'Ви власник $organization, у команді є ще $count людей.',
      few: 'Ви власник $organization, у команді є ще $count людини.',
      one: 'Ви власник $organization, у команді є ще $count людина.',
    );
    return '$_temp0';
  }

  @override
  String get deletionChoiceTransfer => 'Передати власність і піти';

  @override
  String get deletionChoiceTransferHint =>
      'Господарство та його записи залишаються. Вибраний партнер стане власником; видалиться лише ваш обліковий запис.';

  @override
  String get deletionChoiceDelete => 'Видалити господарство й усі записи';

  @override
  String deletionChoiceDeleteHint(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Ще $count людини в команді теж втратять доступ.',
      many: 'Ще $count людей у команді теж втратять доступ.',
      few: 'Ще $count людини в команді теж втратять доступ.',
      one: 'Ще $count людина в команді теж втратить доступ.',
    );
    return '$_temp0';
  }

  @override
  String get deletionTransferPick => 'Новий власник';

  @override
  String get deletionTransferNoPartner =>
      'Для передачі хтось у команді має бути партнером. Зробіть учасника партнером на екрані «Команда» або видаліть господарство.';

  @override
  String get deletionPartnerFallbackName => 'Партнер';

  @override
  String get deletionMemberTitle => 'Буде видалено лише ваш обліковий запис';

  @override
  String deletionMemberMessage(String organization) {
    return '$organization і його записи не видаляються. Внесені вами записи залишаються в господарстві; ваше ім\'я приберуть із команди.';
  }

  @override
  String get deletionUnknownMessage =>
      'Ваша участь ще не надійшла на цей телефон. Спробуйте знову після синхронізації.';

  @override
  String get deletionGraceNote =>
      'Видалення стане остаточним через 7 днів; до того можна увійти й передумати.';

  @override
  String get deletionBackupTitle => 'Спочатку збережіть дані';

  @override
  String get deletionBackupMessage =>
      'Видалені записи не можна відновити. Радимо спочатку зберегти копію.';

  @override
  String get deletionBackupReports => 'Звіти PDF';

  @override
  String get deletionBackupReportsHint => 'Завантажте готові звіти в PDF.';

  @override
  String get deletionBackupJson => 'Усі записи';

  @override
  String get deletionBackupJsonValue => 'JSON';

  @override
  String get deletionBackupJsonHint =>
      'Усі ваші записи в одному файлі; збережіть його будь-де.';

  @override
  String get deletionBackupSaved => 'Збережено';

  @override
  String get deletionBackupDownload => 'Завантажити мої записи';

  @override
  String get deletionBackupSkip => 'Пропустити';

  @override
  String deletionBackupFileName(String date) {
    return 'mobil-arici-zapysy-$date';
  }

  @override
  String get deletionVerifyTitle => 'Підтвердьте, що це ви';

  @override
  String get deletionVerifyButton => 'Перевірити код';

  @override
  String get deletionConfirmTitle => 'Останнє підтвердження';

  @override
  String get deletionConfirmIntro => 'Якщо ви підтвердите:';

  @override
  String deletionConsequenceAccount(String date) {
    return 'Ваш обліковий запис буде остаточно видалено $date.';
  }

  @override
  String deletionConsequenceOrganization(String organization) {
    return '$organization і всі його записи теж видаляються.';
  }

  @override
  String deletionConsequenceTransfer(String name, String organization) {
    return '$name стане новим власником $organization.';
  }

  @override
  String get deletionConsequenceRecordsStay =>
      'Записи господарства не видаляються.';

  @override
  String deletionConsequenceLots(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other:
          'Закриються $count сторінки партій; їхні QR-коди перестануть працювати.',
      many:
          'Закриються $count сторінок партій; їхні QR-коди перестануть працювати.',
      few:
          'Закриються $count сторінки партій; їхні QR-коди перестануть працювати.',
      one:
          'Закриється $count сторінка партії; її QR-коди перестануть працювати.',
    );
    return '$_temp0';
  }

  @override
  String get deletionConsequenceSignOut =>
      'Ви вийдете, а дані на цьому телефоні буде видалено.';

  @override
  String get deletionConsequenceCancel =>
      'Якщо ввійдете до цього терміну, видалення можна скасувати.';

  @override
  String deletionConfirmTypeName(String organization) {
    return 'Для підтвердження введіть назву господарства: $organization';
  }

  @override
  String deletionConfirmTypeKeyword(String keyword) {
    return 'Для підтвердження введіть $keyword';
  }

  @override
  String get deletionKeyword => 'ВИДАЛИТИ';

  @override
  String get deletionConfirmButton => 'Видалити мій обліковий запис';

  @override
  String get deletionConfirmButtonWithOrganization =>
      'Видалити обліковий запис і господарство';

  @override
  String get deletionSubmitting => 'Надсилаємо…';

  @override
  String get deletionFailureNetwork =>
      'Сервер недоступний. Перевірте підключення й спробуйте знову.';

  @override
  String get deletionFailureOwnerMustTransfer =>
      'Ви також власник іншого господарства з командою. Спочатку передайте власність там.';

  @override
  String get deletionFailureInvalidTransfer =>
      'Вибрана людина вже не партнер. Виберіть іншого партнера.';

  @override
  String get deletionFailureRateLimited =>
      'Забагато спроб за короткий час. Спробуйте завтра.';

  @override
  String get deletionFailureForbidden =>
      'Сеанс завершено. Увійдіть знову й повторіть.';

  @override
  String get deletionFailureCodeRequired =>
      'Підтвердження застаріло. Запросіть новий код і підтвердьте знову.';

  @override
  String get deletionFailureUnknown =>
      'Не вдалося надіслати запит. Спробуйте трохи згодом.';

  @override
  String get deletionDoneTitle => 'Ми отримали ваш запит';

  @override
  String deletionDoneDate(String date) {
    return 'Ваш обліковий запис буде остаточно видалено $date.';
  }

  @override
  String get deletionDoneCancelHint =>
      'Якщо передумаєте, увійдіть до цієї дати — видалення скасується.';

  @override
  String get deletionDoneEmail => 'Подробиці ми також надіслали на вашу пошту.';

  @override
  String get deletionDoneClearing => 'Видаляємо дані на цьому телефоні…';

  @override
  String get deletionDoneSignedOut =>
      'Ви вийшли, дані на цьому телефоні видалено.';

  @override
  String get deletionDoneAction => 'Готово';

  @override
  String get deletionPendingTitle =>
      'Ваш обліковий запис незабаром буде видалено';

  @override
  String deletionPendingMessage(String date) {
    return 'Ваш обліковий запис буде видалено $date. Якщо продовжите, видалення скасується.';
  }

  @override
  String get deletionPendingContinue => 'Продовжити й зберегти обліковий запис';

  @override
  String get deletionPendingSignOut => 'Вийти й залишити видалення';

  @override
  String get deletionPendingCancelled => 'Видалення скасовано. З поверненням!';

  @override
  String get deletionPendingCancelFailed =>
      'Не вдалося скасувати видалення. Перевірте підключення й спробуйте знову.';

  @override
  String teamMemberLeaving(String date) {
    return 'Видаляє обліковий запис · $date';
  }

  @override
  String get teamErrorMemberLeaving =>
      'Ця людина видаляє свій обліковий запис; у період очікування її роль не можна змінити, а саму її не можна видалити з команди.';

  @override
  String get teamErrorTooManyAttempts =>
      'Забагато спроб введення коду. Зачекайте хвилину й спробуйте знову.';
}
