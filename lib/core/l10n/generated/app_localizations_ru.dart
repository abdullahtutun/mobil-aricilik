// ignore: unused_import
import 'package:intl/intl.dart' as intl;

import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Russian (`ru`).
class AppLocalizationsRu extends AppLocalizations {
  AppLocalizationsRu([String locale = 'ru']) : super(locale);

  @override
  String get appTitle => 'Mobil Arıcı';

  @override
  String get listSeparator => ',';

  @override
  String get stepperIncrease => 'Увеличить';

  @override
  String get stepperDecrease => 'Уменьшить';

  @override
  String hiveTileLabel(String number) {
    return 'Улей $number';
  }

  @override
  String hiveTileStrength(int strength) {
    return 'Сила $strength из 5';
  }

  @override
  String hiveTileQueenColor(String color) {
    String _temp0 = intl.Intl.selectLogic(color, {
      'white': 'белый',
      'yellow': 'жёлтый',
      'red': 'красный',
      'green': 'зелёный',
      'blue': 'синий',
      'other': 'неизвестен',
    });
    return 'Цвет матки $_temp0';
  }

  @override
  String get tabToday => 'Сегодня';

  @override
  String get tabApiaries => 'Пасеки';

  @override
  String get tabTasks => 'Задачи';

  @override
  String get tabMore => 'Ещё';

  @override
  String get todayEmptyTitle => 'Начните с добавления пасеки';

  @override
  String get todayEmptyMessage =>
      'Три шага — и всё готово: добавьте пасеку, создайте ульи, проведите первый осмотр.';

  @override
  String get apiariesEmptyTitle => 'Пасек пока нет';

  @override
  String get apiariesEmptyMessage =>
      'Пасека объединяет ульи по месту, где они стоят; добавьте первую, чтобы начать.';

  @override
  String get apiariesAdd => 'Добавить пасеку';

  @override
  String get apiariesAddFirst => 'Добавьте первую пасеку';

  @override
  String get apiariesLoadError => 'Не удалось прочитать пасеки.';

  @override
  String get apiariesViewList => 'Список';

  @override
  String get apiariesViewMap => 'Карта';

  @override
  String get apiariesMapOfflineTitle => 'Карта недоступна';

  @override
  String get apiariesMapOfflineMessage =>
      'Для карты нужен интернет. Ваши пасеки перечислены ниже.';

  @override
  String get apiariesMapNoLocation =>
      'Ни у одной пасеки пока нет местоположения. Отредактируйте пасеку, чтобы взять местоположение по GPS или выбрать его на карте.';

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
      other: '$count улья требуют внимания',
      many: '$count ульев требуют внимания',
      few: '$count улья требуют внимания',
      one: '$count улей требует внимания',
    );
    return '$_temp0';
  }

  @override
  String get apiaryMapDirections => 'Маршрут';

  @override
  String get apiaryMapShow => 'Показать';

  @override
  String get apiaryMapDirectionsFailed => 'Не удалось открыть приложение карт.';

  @override
  String get apiaryMapDirectionsChooseApp => 'Построить маршрут в';

  @override
  String apiaryHiveCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count улья',
      many: '$count ульев',
      few: '$count улья',
      one: '$count улей',
      zero: 'Нет ульев',
    );
    return '$_temp0';
  }

  @override
  String apiaryLastVisit(String date) {
    return 'Последний визит $date';
  }

  @override
  String get apiaryNoVisit => 'Визитов пока не было';

  @override
  String get apiaryEdit => 'Изменить';

  @override
  String get apiaryDelete => 'Удалить пасеку';

  @override
  String get apiaryDeleteTitle => 'Удалить эту пасеку?';

  @override
  String get apiaryDeleteMessage => 'Пасека будет удалена со всех телефонов.';

  @override
  String apiaryDeleteWithHivesMessage(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other:
          'На этой пасеке $count улья. Пасека и её ульи будут удалены со всех телефонов.',
      many:
          'На этой пасеке $count ульев. Пасека и её ульи будут удалены со всех телефонов.',
      few:
          'На этой пасеке $count улья. Пасека и её ульи будут удалены со всех телефонов.',
      one:
          'На этой пасеке $count улей. Пасека и её ульи будут удалены со всех телефонов.',
    );
    return '$_temp0';
  }

  @override
  String get apiaryDeleted => 'Пасека удалена';

  @override
  String get apiaryNotFoundTitle => 'Пасека не найдена';

  @override
  String get apiaryNotFoundMessage =>
      'Возможно, она удалена или ещё не появилась на этом устройстве.';

  @override
  String get apiaryFormNewTitle => 'Новая пасека';

  @override
  String get apiaryFormEditTitle => 'Изменить пасеку';

  @override
  String get apiaryFormName => 'Название пасеки';

  @override
  String get apiaryFormNameHint => 'например, На холме';

  @override
  String get apiaryFormLocation => 'Местоположение';

  @override
  String get apiaryFormLocationNone =>
      'Местоположения пока нет. Если вы на пасеке, возьмите его по GPS — интернет не нужен; иначе выберите на карте.';

  @override
  String get apiaryFormLocationTake => 'Взять местоположение по GPS';

  @override
  String get apiaryFormLocationRetake => 'Взять местоположение заново';

  @override
  String get apiaryFormLocationClear => 'Удалить местоположение';

  @override
  String get apiaryFormLocationPickOnMap => 'Выбрать на карте';

  @override
  String get locationPickerTitle => 'Выбор места на карте';

  @override
  String get locationPickerSearchHint => 'Найти населённый пункт или место';

  @override
  String get locationPickerSearch => 'Найти';

  @override
  String get locationPickerHint =>
      'Сдвиньте карту, чтобы метка оказалась на пасеке.';

  @override
  String get locationPickerPinLabel => 'Выбранное место';

  @override
  String get locationPickerConfirm => 'Использовать это место';

  @override
  String get locationPickerNoResults =>
      'Ничего не найдено. Попробуйте другое название.';

  @override
  String get locationPickerSearchOffline =>
      'Не удалось выполнить поиск. Для поиска нужен интернет.';

  @override
  String get locationPickerMapOfflineMessage =>
      'Для карты нужен интернет. Если вы на пасеке, возьмите местоположение по GPS.';

  @override
  String get apiaryFormLocating =>
      'Определяем местоположение… На открытом месте быстрее.';

  @override
  String apiaryFormLocationAccuracy(int meters) {
    return 'Точность ±$meters м';
  }

  @override
  String get apiaryFormLocationErrorServiceDisabled =>
      'Геолокация на этом устройстве выключена. Включите её и попробуйте снова.';

  @override
  String get apiaryFormLocationErrorPermissionDenied =>
      'Нет разрешения на геолокацию. Разрешите её, чтобы взять местоположение.';

  @override
  String get apiaryFormLocationErrorPermissionDeniedForever =>
      'Разрешение на геолокацию выключено. Разрешите геолокацию для этого приложения в настройках.';

  @override
  String get apiaryFormLocationErrorTimeout =>
      'Не удалось определить местоположение. Попробуйте снова на открытом месте.';

  @override
  String get apiaryFormLocationErrorUnknown =>
      'Не удалось получить местоположение. Попробуйте снова.';

  @override
  String get apiaryFormOpenSettings => 'Открыть настройки';

  @override
  String get apiaryFormNotes => 'Заметки';

  @override
  String get apiaryFormSave => 'Сохранить';

  @override
  String get hiveSortWeakestFirst => 'Сначала слабые';

  @override
  String get hivesEmptyTitle => 'Ульев пока нет';

  @override
  String get hivesEmptyMessage =>
      'Добавьте ульи, которые стоят на этой пасеке; можно создать сразу много.';

  @override
  String get hivesAdd => 'Добавить ульи';

  @override
  String get hivesAddOne => 'Один улей';

  @override
  String get hivesAddOneHint => 'Укажите номер, тип и происхождение';

  @override
  String get hivesAddBulk => 'Сразу много';

  @override
  String get hivesAddBulkHint => 'например, 20 ульев начиная с 101';

  @override
  String hivesInactiveTitle(int count) {
    return 'Неактивные ($count)';
  }

  @override
  String get hivesLoadError => 'Не удалось прочитать ульи.';

  @override
  String hiveLabel(String number) {
    return 'Улей $number';
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
  String get hiveTypeLocal => 'Местный';

  @override
  String get hiveTypeOther => 'Другой';

  @override
  String get hiveStatusActive => 'Активен';

  @override
  String get hiveStatusDead => 'Погиб';

  @override
  String get hiveStatusMerged => 'Объединён';

  @override
  String get hiveStatusSold => 'Продан';

  @override
  String get hiveStatusLost => 'Утерян';

  @override
  String get hiveSourceSwarm => 'Рой';

  @override
  String get hiveSourceSplit => 'Отводок';

  @override
  String get hiveSourcePurchase => 'Куплен';

  @override
  String get hiveSourcePackage => 'Пчелопакет';

  @override
  String get hiveFormNewTitle => 'Новый улей';

  @override
  String get hiveFormEditTitle => 'Изменить улей';

  @override
  String get hiveFormNumber => 'Номер улья';

  @override
  String get hiveFormNumberHint => 'например, 101';

  @override
  String get hiveFormType => 'Тип улья';

  @override
  String get hiveFormStatus => 'Статус';

  @override
  String get hiveFormSource => 'Происхождение';

  @override
  String get hiveFormSave => 'Сохранить';

  @override
  String get hiveBulkTitle => 'Создать много ульев';

  @override
  String get hiveBulkCount => 'Сколько ульев';

  @override
  String get hiveBulkCountHint => 'например, 20';

  @override
  String hiveBulkCountTooMany(int max) {
    return 'Не больше $max за раз';
  }

  @override
  String get hiveBulkStart => 'Первый номер';

  @override
  String get hiveBulkStartHint => 'например, 101';

  @override
  String hiveBulkPreview(int count, String first, String last) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Будут созданы $count улья: с $first по $last.',
      many: 'Будут созданы $count ульев: с $first по $last.',
      few: 'Будут созданы $count улья: с $first по $last.',
      one: 'Будет создан $count улей: с $first по $last.',
    );
    return '$_temp0';
  }

  @override
  String get hiveBulkSave => 'Создать ульи';

  @override
  String hiveBulkCreated(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Создано $count улья',
      many: 'Создано $count ульев',
      few: 'Создано $count улья',
      one: 'Создан $count улей',
    );
    return '$_temp0';
  }

  @override
  String get hiveNotFoundTitle => 'Улей не найден';

  @override
  String get hiveNotFoundMessage =>
      'Возможно, он удалён или ещё не появился на этом устройстве.';

  @override
  String get hiveEdit => 'Изменить';

  @override
  String get hiveDelete => 'Удалить улей';

  @override
  String hiveDeleteTitle(String number) {
    return 'Удалить улей $number?';
  }

  @override
  String get hiveDeleteMessage =>
      'Улей и его записи будут удалены со всех телефонов.';

  @override
  String hiveDeleted(String number) {
    return 'Улей $number удалён';
  }

  @override
  String hiveCardApiary(String name) {
    return 'Пасека: $name';
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
  String get hiveStrengthWeak => 'Слабая';

  @override
  String get hiveStrengthMedium => 'Средняя';

  @override
  String get hiveStrengthStrong => 'Сильная';

  @override
  String get hiveStrengthNone => 'Оценки силы пока нет';

  @override
  String get hiveTimelineTitle => 'История';

  @override
  String get timelineInspection => 'Осмотр';

  @override
  String get timelineAdded => 'Поставлен на пасеку';

  @override
  String get timelineMoved => 'Перевезён';

  @override
  String timelineMoveRoute(String from, String to) {
    return '$from → $to';
  }

  @override
  String get timelineUnknownApiary => 'Неизвестная пасека';

  @override
  String timelineField(String label, String value) {
    return '$label: $value';
  }

  @override
  String timelineBeeFrames(int count) {
    return '$count с пчёлами';
  }

  @override
  String timelineBroodFrames(int count) {
    return '$count с расплодом';
  }

  @override
  String timelineHoneyFrames(int count) {
    return '$count с мёдом';
  }

  @override
  String get timelineActions => 'Сделано';

  @override
  String get hiveMove => 'Перевезти на другую пасеку';

  @override
  String hiveMoveTitle(String number) {
    return 'Перевезти улей $number на';
  }

  @override
  String get hiveMoveNoOtherApiary =>
      'Нет другой пасеки для перевозки. Сначала добавьте её на вкладке «Пасеки».';

  @override
  String hiveMoved(String number, String apiary) {
    return 'Улей $number перевезён на $apiary';
  }

  @override
  String get hiveChangeStatus => 'Изменить статус';

  @override
  String hiveStatusSheetTitle(String number) {
    return 'Новый статус улья $number';
  }

  @override
  String hiveStatusConfirmTitle(String status, String number) {
    String _temp0 = intl.Intl.selectLogic(status, {
      'dead': 'Записать улей $number как погибший?',
      'merged': 'Записать улей $number как объединённый?',
      'sold': 'Записать улей $number как проданный?',
      'other': 'Записать улей $number как утерянный?',
    });
    return '$_temp0';
  }

  @override
  String get hiveStatusConfirmMessage =>
      'Он перестанет учитываться среди активных ульев пасеки. Позже его можно снова сделать активным.';

  @override
  String get hiveStatusConfirm => 'Да, записать';

  @override
  String hiveStatusChanged(String number, String status) {
    return 'Улей $number: $status';
  }

  @override
  String get tasksEmptyTitle => 'Задач пока нет';

  @override
  String get tasksEmptyMessage =>
      'Здесь по датам будут ваши напоминания и задачи.';

  @override
  String get scanTitle => 'Сканировать';

  @override
  String get scanLongPressHint => 'открыть меню быстрой записи';

  @override
  String get scanHint => 'Поместите код с этикетки улья в рамку.';

  @override
  String get scanAgain => 'Сканировать снова';

  @override
  String get cameraErrorTitle => 'Не удалось открыть камеру';

  @override
  String get cameraErrorPermissionDenied =>
      'Нет разрешения на камеру. Чтобы сканировать этикетки, разрешите камеру для этого приложения в настройках.';

  @override
  String get cameraErrorUnsupported =>
      'На этом устройстве нет камеры, которая может сканировать.';

  @override
  String get cameraErrorUnknown => 'Закройте этот экран и попробуйте снова.';

  @override
  String get labelUnknownTitle => 'Этот код не привязан к улью';

  @override
  String get labelUnknownMessage =>
      'Это не этикетка Mobil Arıcı или она ещё не привязана к улью. Если она на улье, привяжите её; тогда при сканировании откроется карточка улья.';

  @override
  String get labelUnknownOwnTitle => 'Улей с этой этикеткой не найден';

  @override
  String get labelUnknownOwnMessage =>
      'Возможно, улей удалён или ещё не появился на этом телефоне. Этикетку можно привязать и к другому улью.';

  @override
  String labelCode(String code) {
    return 'Код: $code';
  }

  @override
  String get labelAssign => 'Привязать к улью';

  @override
  String get labelAssignTitle => 'Привязать этикетку к улью';

  @override
  String get labelAssignMessage =>
      'Выберите улей, на котором этикетка. Тогда при сканировании откроется карточка этого улья.';

  @override
  String get labelAssignSearch => 'Номер улья';

  @override
  String get labelAssignNoMatch => 'Ни один улей не подходит под поиск.';

  @override
  String get labelAssignNoHives =>
      'Ульев пока нет. Сначала добавьте ульи на вкладке «Пасеки».';

  @override
  String get labelAssignHasOther => 'Есть другая этикетка';

  @override
  String labelReplaceTitle(String number) {
    return 'Заменить этикетку улья $number?';
  }

  @override
  String get labelReplaceMessage =>
      'У этого улья уже есть этикетка. Новая заменит её; старая больше не будет открывать этот улей.';

  @override
  String get labelReplaceConfirm => 'Да, заменить';

  @override
  String labelAssigned(String number) {
    return 'Этикетка привязана: улей $number';
  }

  @override
  String get hiveLabelsTitle => 'Печать этикеток';

  @override
  String get hiveLabelsMessage =>
      'Выберите ульи, для которых нужно напечатать этикетки. На листе A4 помещается 24 этикетки (70 × 37 мм); печатайте в масштабе 100%.';

  @override
  String get hiveLabelsNoHives =>
      'На этой пасеке нет ульев для печати этикеток.';

  @override
  String get hiveLabelsSelectAll => 'Выбрать все';

  @override
  String get hiveLabelsSelectNone => 'Снять выбор';

  @override
  String get hiveLabelsNoneSelected => 'Ульи не выбраны';

  @override
  String hiveLabelsCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count этикетки',
      many: '$count этикеток',
      few: '$count этикетки',
      one: '$count этикетка',
    );
    return '$_temp0';
  }

  @override
  String hiveLabelsPages(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count страницы',
      many: '$count страниц',
      few: '$count страницы',
      one: '$count страница',
    );
    return '$_temp0';
  }

  @override
  String hiveLabelsSummary(String labels, String pages) {
    return '$labels · $pages';
  }

  @override
  String get hiveLabelsPreparing => 'Готовим PDF…';

  @override
  String get hiveLabelsPrint => 'Печать';

  @override
  String get hiveLabelsShare => 'Поделиться PDF';

  @override
  String hiveLabelsDocumentName(String apiary) {
    return 'Этикетки ульев - $apiary';
  }

  @override
  String get hiveLabelsError => 'Не удалось подготовить PDF. Попробуйте снова.';

  @override
  String get quickRecordTitle => 'Быстрая запись';

  @override
  String get quickRecordInspection => 'Осмотр';

  @override
  String get quickRecordFeeding => 'Подкормка';

  @override
  String get quickRecordTreatment => 'Обработка';

  @override
  String get quickRecordHarvest => 'Медосбор';

  @override
  String get quickRecordNote => 'Заметка';

  @override
  String get quickRecordExpense => 'Расход';

  @override
  String get quickRecordComingSoon => 'Этот тип записи скоро появится.';

  @override
  String get signInSendCode => 'Отправить код';

  @override
  String get signInSending => 'Отправляем…';

  @override
  String signInCodeMessage(String email) {
    return 'Мы отправили 6-значный код на $email.';
  }

  @override
  String get signInCodeFieldLabel => '6-значный код';

  @override
  String get signInVerify => 'Войти';

  @override
  String get signInVerifying => 'Проверяем…';

  @override
  String get signInResend => 'Отправить код ещё раз';

  @override
  String signInResendIn(int seconds) {
    return 'Отправить код ещё раз ($seconds с)';
  }

  @override
  String get signInCodeResent => 'Новый код уже в пути.';

  @override
  String get authErrorNetwork =>
      'Нет соединения. Проверьте интернет и попробуйте снова.';

  @override
  String get authErrorInvalidEmail => 'Введите корректный адрес эл. почты.';

  @override
  String get authErrorInvalidCode =>
      'Код неверный или устарел. Попробуйте снова или запросите новый код.';

  @override
  String get authErrorTooManyRequests =>
      'Слишком много попыток. Подождите немного и попробуйте снова.';

  @override
  String get authErrorUnknown => 'Что-то пошло не так. Попробуйте снова.';

  @override
  String get settingsTitle => 'Настройки';

  @override
  String get settingsSystemDefault => 'Как в системе';

  @override
  String get settingsLanguage => 'Язык';

  @override
  String get settingsColorMode => 'Тема';

  @override
  String get settingsColorModeLight => 'Светлая';

  @override
  String get settingsColorModeDark => 'Тёмная';

  @override
  String get settingsColorModeSun => 'Солнце';

  @override
  String get settingsAccount => 'Аккаунт';

  @override
  String settingsSignedInAs(String email) {
    return 'Вход выполнен: $email';
  }

  @override
  String get settingsPrivacyPolicy => 'Политика конфиденциальности';

  @override
  String settingsVersion(String version) {
    return 'Версия $version';
  }

  @override
  String get settingsSignOut => 'Выйти';

  @override
  String get settingsSignOutConfirmTitle => 'Выйти?';

  @override
  String get settingsSignOutConfirmMessage =>
      'Чтобы войти снова, понадобится новый код на почту, а для этого нужен интернет.';

  @override
  String get actionCancel => 'Отмена';

  @override
  String get actionDelete => 'Удалить';

  @override
  String get actionRetry => 'Повторить';

  @override
  String get actionUndo => 'Отменить';

  @override
  String onboardingStepCounter(int current, int total) {
    return 'Шаг $current из $total';
  }

  @override
  String get onboardingContinue => 'Продолжить';

  @override
  String get onboardingFinish => 'Создать хозяйство';

  @override
  String get onboardingFinishing => 'Настраиваем…';

  @override
  String get onboardingCountrySearch => 'Поиск страны';

  @override
  String get onboardingCountrySuggested => 'Предложено для вашего устройства';

  @override
  String get onboardingCountryAll => 'Все страны';

  @override
  String get onboardingCountryNoMatch =>
      'Ни одна страна не подходит под поиск.';

  @override
  String get onboardingNameMessage =>
      'Это название будет в ваших записях и отчётах.';

  @override
  String get onboardingNameLabel => 'Название хозяйства';

  @override
  String get onboardingNameHint => 'например, Пасека «Золотые соты»';

  @override
  String get onboardingHiveCountTitle => 'Сколько у вас ульев?';

  @override
  String get onboardingHiveCountMessage =>
      'Достаточно примерного числа; мы подскажем, как их вести. Сами ульи вы добавите позже.';

  @override
  String get hiveCountRangeNone => 'Пока нет';

  @override
  String get hiveCountRangeUpTo10 => '1–10';

  @override
  String get hiveCountRangeUpTo50 => '11–50';

  @override
  String get hiveCountRangeUpTo200 => '51–200';

  @override
  String get hiveCountRangeOver200 => 'Больше 200';

  @override
  String get onboardingApiaryTitle => 'Добавьте первую пасеку';

  @override
  String get onboardingApiaryMessage =>
      'Пасека — это место, где стоят ваши ульи. Для сохранения интернет не нужен.';

  @override
  String get onboardingApiarySave => 'Сохранить пасеку';

  @override
  String get onboardingApiarySkip => 'Пропустить пока';

  @override
  String get onboardingLoading => 'Загружаем ваше хозяйство';

  @override
  String get onboardingLoadErrorTitle => 'Не удалось загрузить хозяйство';

  @override
  String get onboardingErrorNetwork =>
      'Нет соединения. Проверьте интернет и попробуйте снова.';

  @override
  String get onboardingErrorUnknown => 'Что-то пошло не так. Попробуйте снова.';

  @override
  String get devMenuTitle => 'Меню разработчика';

  @override
  String get componentGalleryTitle => 'Галерея компонентов';

  @override
  String get componentGalleryDescription =>
      'Компоненты дизайн-системы в четырёх темах';

  @override
  String get galleryThemeLight => 'Светлая';

  @override
  String get galleryThemeDark => 'Тёмная';

  @override
  String get galleryThemeSun => 'Солнце';

  @override
  String get galleryThemeGlove => 'Перчатки';

  @override
  String get galleryBigButton => 'Большая кнопка';

  @override
  String get galleryChoiceChipGroup => 'Чипы выбора';

  @override
  String get galleryBigStepper => 'Большой счётчик';

  @override
  String get galleryStatusBadge => 'Значок статуса';

  @override
  String get galleryHiveTile => 'Плитка улья';

  @override
  String get galleryEmptyState => 'Пустое состояние';

  @override
  String get gallerySectionCard => 'Карточка раздела';

  @override
  String get galleryStrengthDots => 'Точки силы';

  @override
  String get galleryTimelineTile => 'Строка истории';

  @override
  String get gallerySampleApiaryHill => 'На холме';

  @override
  String get gallerySampleApiaryPlain => 'У реки';

  @override
  String get gallerySampleStartInspection => 'Начать осмотр';

  @override
  String get gallerySampleAddPhoto => 'Добавить фото';

  @override
  String get gallerySampleSave => 'Сохранить';

  @override
  String get gallerySampleQueen => 'Матка';

  @override
  String get gallerySampleQueenSeen => 'Видели';

  @override
  String get gallerySampleEggs => 'Есть яйца';

  @override
  String get gallerySampleNone => 'Нет';

  @override
  String get gallerySampleActions => 'Сделано';

  @override
  String get gallerySampleSuperAdded => 'Магазин поставлен';

  @override
  String get gallerySampleFrameAdded => 'Рамка добавлена';

  @override
  String get gallerySampleFed => 'Подкормлены';

  @override
  String get gallerySampleBeeFrames => 'Рамок с пчёлами';

  @override
  String get gallerySampleBroodFrames => 'Рамок с расплодом';

  @override
  String get gallerySampleStrong => 'Сильная';

  @override
  String get gallerySampleWeak => 'Слабая';

  @override
  String get gallerySampleQueenless => 'Безматочная';

  @override
  String get gallerySampleTask => 'Задача';

  @override
  String get gallerySampleNoApiaries => 'Пасек пока нет';

  @override
  String get gallerySampleNoApiariesMessage =>
      'Пасека объединяет ульи по месту, где они стоят; добавьте первую, чтобы начать.';

  @override
  String get gallerySampleAddApiary => 'Добавьте первую пасеку';

  @override
  String get gallerySampleLastInspection => 'Последний осмотр';

  @override
  String get gallerySampleLastInspectionBody =>
      '3 дня назад · 7 рамок с пчёлами · матку видели';

  @override
  String get gallerySampleUntitledCard =>
      'Карточка может быть и без заголовка; содержимое начинается сразу.';

  @override
  String get gallerySnackBar => 'Snackbar';

  @override
  String get galleryCriticalLockCard => 'Карточка критической блокировки';

  @override
  String get gallerySampleInspectionSaved => 'Осмотр сохранён';

  @override
  String get gallerySampleWithdrawalTitle => 'Идёт период ожидания.';

  @override
  String get gallerySampleWithdrawalMessage =>
      'Не ставьте магазин на этот улей ещё 12 дней.';

  @override
  String get syncStatusSynced => 'Синхронизировано';

  @override
  String syncStatusPending(int count) {
    return 'Ожидают: $count';
  }

  @override
  String get syncStatusError => 'Ошибка';

  @override
  String syncStatusSemantics(String status) {
    return 'Синхронизация: $status';
  }

  @override
  String get syncTitle => 'Синхронизация';

  @override
  String get syncSyncedMessage =>
      'Все записи с этого телефона дошли до сервера.';

  @override
  String syncPendingMessage(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count записи ждут отправки.',
      many: '$count записей ждут отправки.',
      few: '$count записи ждут отправки.',
      one: '$count запись ждёт отправки.',
    );
    return '$_temp0';
  }

  @override
  String get syncProblemOffline =>
      'Сервер недоступен. Синхронизация повторится, когда появится интернет.';

  @override
  String get syncProblemFailed =>
      'Синхронизация не завершилась. Попробуйте чуть позже.';

  @override
  String get syncProblemUpgrade =>
      'Эта версия больше не может синхронизироваться. Обновите приложение.';

  @override
  String syncLastSynced(String time) {
    return 'Последняя синхронизация $time';
  }

  @override
  String get syncNow => 'Синхронизировать';

  @override
  String get syncRunning => 'Синхронизация…';

  @override
  String syncRejectedTitle(int count) {
    return 'Не удалось отправить ($count)';
  }

  @override
  String get syncRejectedMessage =>
      'Сервер не принял эти записи. Всё остальное продолжает синхронизироваться.';

  @override
  String syncRejectedSubtitle(String reason, String date) {
    return '$reason · $date';
  }

  @override
  String get syncRejectionForbidden => 'У вас нет права изменять эту запись';

  @override
  String get syncRejectionConflict =>
      'Конфликт с другой записью (например, та же этикетка)';

  @override
  String get syncRejectionMissingReference =>
      'На сервере нет записи, к которой она относится';

  @override
  String get syncRejectionUnsupported => 'Этот тип записей не синхронизируется';

  @override
  String get syncRejectionInvalid => 'В записи неверные данные';

  @override
  String get syncRejectionUnknown => 'Неизвестная причина';

  @override
  String get syncTableOrganizations => 'Хозяйство';

  @override
  String get syncTableMemberships => 'Участие';

  @override
  String get syncTableApiaries => 'Пасека';

  @override
  String get syncTableQueens => 'Матка';

  @override
  String get syncTableHives => 'Улей';

  @override
  String get syncTableHiveStatusEvents => 'Смена статуса улья';

  @override
  String get syncTableHiveLocationHistory => 'Перевозка улья';

  @override
  String get initialSyncTitle => 'Загружаем ваши записи';

  @override
  String get initialSyncMessage =>
      'Записи хозяйства загружаются на этот телефон. Это происходит один раз; потом приложение работает и без интернета.';

  @override
  String initialSyncRows(int count) {
    final intl.NumberFormat countNumberFormat =
        intl.NumberFormat.decimalPattern(localeName);
    final String countString = countNumberFormat.format(count);

    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Загружено $countString записи',
      many: 'Загружено $countString записей',
      few: 'Загружено $countString записи',
      one: 'Загружена $countString запись',
    );
    return '$_temp0';
  }

  @override
  String get initialSyncFailedTitle => 'Загрузка не завершилась';

  @override
  String get suggestedValue => 'Из прошлой записи';

  @override
  String get stepperNoValue => 'Не задано';

  @override
  String get hiveStartInspection => 'Начать осмотр';

  @override
  String inspectionTitle(String number) {
    return 'Осмотр улья $number';
  }

  @override
  String inspectionPrevious(String date) {
    return 'Последний осмотр $date';
  }

  @override
  String get inspectionFirst => 'Первый осмотр';

  @override
  String get inspectionSuggestedLegend =>
      'Бледные значения — из прошлого осмотра. Измените то, что отличается; остальное сохранится как есть.';

  @override
  String get inspectionDraftSaved => 'Сохранено как черновик на этом телефоне';

  @override
  String get inspectionRestart => 'Начать заново';

  @override
  String get inspectionQueen => 'Матка';

  @override
  String get queenStateSeen => 'Видели';

  @override
  String get queenStateEggs => 'Видели яйца';

  @override
  String get queenStateNone => 'Нет';

  @override
  String get inspectionFrames => 'Рамки';

  @override
  String get inspectionBeeFrames => 'С пчёлами';

  @override
  String get inspectionBroodFrames => 'С расплодом';

  @override
  String get inspectionHoneyFrames => 'С мёдом';

  @override
  String get inspectionTemperament => 'Нрав';

  @override
  String get temperamentCalm => 'Спокойные';

  @override
  String get temperamentNervous => 'Нервные';

  @override
  String get inspectionSwarmSigns => 'Признаки роения';

  @override
  String get inspectionQueenCells => 'Маточники';

  @override
  String get queenCellsNone => 'Нет';

  @override
  String get queenCellsSwarm => 'Роевые';

  @override
  String get queenCellsSupersedure => 'Тихая смена';

  @override
  String get queenCellsEmergency => 'Свищевые';

  @override
  String get inspectionDisease => 'Подозрение на болезнь';

  @override
  String get inspectionAnswerNo => 'Нет';

  @override
  String get inspectionAnswerYes => 'Да';

  @override
  String get inspectionActions => 'Сделано сегодня';

  @override
  String get inspectionActionSuperAdded => 'Магазин поставлен';

  @override
  String get inspectionActionSuperRemoved => 'Магазин снят';

  @override
  String get inspectionActionFramesAdded => 'Рамки добавлены';

  @override
  String get inspectionActionFoundationAdded => 'Вощина дана';

  @override
  String get inspectionActionFed => 'Подкормлены';

  @override
  String get inspectionActionExcluderFitted => 'Разделительная решётка';

  @override
  String get inspectionActionEntranceReduced => 'Леток сужен';

  @override
  String get inspectionActionPollenTrapFitted => 'Пыльцеуловитель поставлен';

  @override
  String get inspectionSave => 'Сохранить';

  @override
  String inspectionSaved(String number) {
    return 'Осмотр улья $number сохранён';
  }

  @override
  String get inspectionRemindPrompt => 'Напомнить через';

  @override
  String inspectionRemindDays(int days) {
    String _temp0 = intl.Intl.pluralLogic(
      days,
      locale: localeName,
      other: '$days дня',
      many: '$days дней',
      few: '$days дня',
      one: '$days день',
    );
    return '$_temp0';
  }

  @override
  String get inspectionLoadError => 'Не удалось открыть осмотр';

  @override
  String get syncTableInspections => 'Осмотр';

  @override
  String get signInTagline =>
      'Пасечный журнал в кармане. Работает без интернета.';

  @override
  String get signInEmailLabelLong => 'Ваш адрес эл. почты';

  @override
  String get signInEmailHelper =>
      'Без пароля. Мы пришлём 6-значный код на вашу почту.';

  @override
  String get signInEmailHint => 'name@example.com';

  @override
  String get signInCodeHeading => 'Введите код из письма';

  @override
  String get signInPasteCode => 'Вставить код';

  @override
  String get signInCodeSpamHint =>
      'Не пришло? Проверьте папку «Спам». После первого входа приложение открывается и без интернета.';

  @override
  String get signInChangeEmail => 'Изменить адрес';

  @override
  String get onboardingLanguageCountryTitle => 'Язык и страна';

  @override
  String get onboardingAppLanguage => 'Язык приложения';

  @override
  String get onboardingDeviceLanguage => 'Язык устройства';

  @override
  String get onboardingCountryLabel => 'Страна, где вы держите пчёл';

  @override
  String get onboardingCountryChoose => 'Выберите страну';

  @override
  String onboardingRegionFeaturesTitle(String country) {
    return 'Включено для страны $country';
  }

  @override
  String onboardingRegionDefaultsTitle(String country) {
    return 'Настройки для страны $country';
  }

  @override
  String get onboardingRegionDefaultsMessage =>
      'Единицы и валюта зависят от страны.';

  @override
  String get onboardingBusinessTitle => 'Расскажите о хозяйстве';

  @override
  String get regionFeatureAks => 'данные AKS и регистрации хозяйства';

  @override
  String get regionFeatureSubsidies => 'напоминания о субсидиях на ульи';

  @override
  String get regionFeatureRegulations => 'обзоры законодательства';

  @override
  String get regionFeatureTrDrugList => 'список разрешённых препаратов';

  @override
  String get regionFeatureTrFlora => 'календарь медоносов Турции';

  @override
  String get regionFeatureTrMigrationDocs => 'документы для кочёвки';

  @override
  String get unitKilogram => 'кг';

  @override
  String get unitPound => 'фунт';

  @override
  String get unitCelsius => '°C';

  @override
  String get unitFahrenheit => '°F';

  @override
  String get hemisphereNorthern => 'Северное полушарие';

  @override
  String get hemisphereSouthern => 'Южное полушарие';

  @override
  String get relativeToday => 'сегодня';

  @override
  String get relativeYesterday => 'вчера';

  @override
  String relativeDaysAgo(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count дня назад',
      many: '$count дней назад',
      few: '$count дня назад',
      one: '$count день назад',
    );
    return '$_temp0';
  }

  @override
  String apiariesCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count пасеки',
      many: '$count пасек',
      few: '$count пасеки',
      one: '$count пасека',
    );
    return '$_temp0';
  }

  @override
  String apiariesSummary(String apiaries, String hives) {
    return '$apiaries · $hives';
  }

  @override
  String get apiaryHiveCountUnit => 'ульев';

  @override
  String get hiveLayoutGridShort => 'Сетка';

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
  String get apiaryBulkFeed => 'Подкормить все';

  @override
  String get apiaryBulkTreat => 'Обработать все';

  @override
  String get hiveCardKind => 'Улей';

  @override
  String get hiveLastInspection => 'Последний осмотр';

  @override
  String get hiveLastInspectionNone => 'Пока нет';

  @override
  String get hiveBulkPreviewTitle => 'Предпросмотр';

  @override
  String hiveBulkSaveCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Создать $count улья',
      many: 'Создать $count ульев',
      few: 'Создать $count улья',
      one: 'Создать $count улей',
    );
    return '$_temp0';
  }

  @override
  String get listEllipsis => '…';

  @override
  String get scanOfflineHint => 'Интернет не нужен · вибрирует при считывании';

  @override
  String get titleSeparator => ' ·';

  @override
  String get settingsGeneral => 'Общие';

  @override
  String get settingsGloveMode => 'Режим перчаток';

  @override
  String get settingsGloveModeHint =>
      'Все кнопки становятся на ступень крупнее.';

  @override
  String get settingsCountry => 'Страна';

  @override
  String settingsCountryValue(String name, String code) {
    return '$name · $code';
  }

  @override
  String get moreSectionApiary => 'Пасека';

  @override
  String get moreSectionBusiness => 'Хозяйство';

  @override
  String get moreSectionHelp => 'Помощь';

  @override
  String get galleryFormFields => 'Поля формы';

  @override
  String get galleryRadioCardGroup => 'Карточки выбора';

  @override
  String get gallerySegmentedTabs => 'Переключатель вида';

  @override
  String get galleryListGroup => 'Сгруппированный список';

  @override
  String get galleryNoteCard => 'Карточка заметки';

  @override
  String get gallerySummaryTile => 'Плитка сводки';

  @override
  String get galleryActionTile => 'Плитки действий';

  @override
  String get galleryAppLogo => 'Логотип и сота';

  @override
  String get gallerySampleApiaryName => 'Название пасеки';

  @override
  String get gallerySampleFirstNumber => 'Первый номер';

  @override
  String get gallerySampleNoteHint =>
      'Без пароля. Мы пришлём 6-значный код на вашу почту.';

  @override
  String get gallerySampleGrid => 'Сетка';

  @override
  String get gallerySampleList => 'Список';

  @override
  String get gallerySampleMap => 'Карта';

  @override
  String get gallerySampleInspections => 'Осмотры';

  @override
  String get gallerySampleNoteTitle => 'Включено для Турции';

  @override
  String get gallerySampleNoteMessage =>
      'Данные AKS и регистрации хозяйства, обзоры законодательства и список разрешённых препаратов.';

  @override
  String get gallerySampleLastInspectionValue => '3 дня назад';

  @override
  String get gallerySampleFrames => '8 рамок с пчёлами · 5 с расплодом';

  @override
  String get gallerySampleActiveTreatment => 'Идёт обработка';

  @override
  String get gallerySampleDaysLeft => 'осталось 12 дней';

  @override
  String get syncTableMedia => 'Фото или голосовая заметка';

  @override
  String get mediaTakePhoto => 'Сделать фото';

  @override
  String get mediaRecordVoice => 'Записать голосовую заметку';

  @override
  String get mediaStopRecording => 'Остановить запись';

  @override
  String mediaRecording(String duration) {
    return 'Запись · $duration';
  }

  @override
  String mediaPhotoAdded(String number) {
    return 'Фото добавлено к улью $number';
  }

  @override
  String mediaVoiceAdded(String number) {
    return 'Голосовая заметка добавлена к улью $number';
  }

  @override
  String get mediaCameraDenied =>
      'Нет разрешения на камеру. Его можно дать в настройках телефона.';

  @override
  String get mediaMicrophoneDenied =>
      'Нет разрешения на микрофон. Его можно дать в настройках телефона.';

  @override
  String get mediaCaptureFailed => 'Не удалось сохранить. Попробуйте снова.';

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
      other: '$count голосовой заметки',
      many: '$count голосовых заметок',
      few: '$count голосовые заметки',
      one: '$count голосовая заметка',
    );
    return '$_temp0';
  }

  @override
  String inspectionMediaAttached(String items) {
    return 'Сохранено с осмотром: $items';
  }

  @override
  String get timelinePhoto => 'Фото';

  @override
  String get timelineVoiceNote => 'Голосовая заметка';

  @override
  String get mediaOpenPhoto => 'Открыть фото';

  @override
  String get mediaDownloadPhoto =>
      'Фото нет на этом телефоне. Нажмите, чтобы скачать.';

  @override
  String mediaPlay(String duration) {
    return 'Слушать · $duration';
  }

  @override
  String get mediaStopPlaying => 'Стоп';

  @override
  String get mediaNotUploaded =>
      'Ещё не загружено. Появится, когда телефон, на который сняли, выйдет в сеть.';

  @override
  String get mediaDownloadOffline =>
      'Не удалось скачать. Проверьте подключение к интернету.';

  @override
  String get mediaDownloadFailed => 'Не удалось скачать.';

  @override
  String get mediaNotFound => 'Фото не найдено';

  @override
  String get settingsData => 'Данные';

  @override
  String get settingsMediaWifiOnly => 'Загружать фото только по Wi‑Fi';

  @override
  String get settingsMediaWifiOnlyHint =>
      'Фото и голосовые заметки не будут тратить мобильный трафик.';

  @override
  String settingsPendingUploads(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count файла ждут загрузки',
      many: '$count файлов ждут загрузки',
      few: '$count файла ждут загрузки',
      one: '$count файл ждёт загрузки',
    );
    return '$_temp0';
  }

  @override
  String get hiveQueenNone => 'Не записана';

  @override
  String get hiveQueenNoneHint => 'Нажмите, чтобы добавить матку';

  @override
  String queenMarkColorName(String color) {
    String _temp0 = intl.Intl.selectLogic(color, {
      'white': 'Белый',
      'yellow': 'Жёлтый',
      'red': 'Красный',
      'green': 'Зелёный',
      'blue': 'Синий',
      'other': 'Неизвестен',
    });
    return '$_temp0';
  }

  @override
  String get queenYearUnknown => 'Год неизвестен';

  @override
  String get queenUnmarked => 'Не помечена';

  @override
  String queenAge(int age) {
    String _temp0 = intl.Intl.pluralLogic(
      age,
      locale: localeName,
      other: '$age года',
      many: '$age лет',
      few: '$age года',
      one: '$age год',
      zero: 'Меньше года',
    );
    return '$_temp0';
  }

  @override
  String get queenSourceOwnRearing => 'Свой вывод';

  @override
  String get queenSourcePurchased => 'Куплена';

  @override
  String get queenSourceCertifiedBreeder => 'Сертифицированный матковод';

  @override
  String get queenSource => 'Происхождение';

  @override
  String get queenMother => 'Мать';

  @override
  String get queenMotherUnknown => 'Неизвестна';

  @override
  String get queenBreed => 'Порода';

  @override
  String get queenBreedHint => 'например, карника';

  @override
  String get queenBreedLine => 'Линия';

  @override
  String get queenBreedLineHint => 'например, Тройзек';

  @override
  String get queenWing => 'Крыло';

  @override
  String get queenWingClipped => 'Подрезано';

  @override
  String get queenWingIntact => 'Не подрезано';

  @override
  String get queenYear => 'Год';

  @override
  String get queenYearHelper => 'Год вывода или покупки';

  @override
  String get queenMark => 'Цвет метки';

  @override
  String queenMarkSuggestion(String year, String color) {
    return 'Цвет $year года: $color';
  }

  @override
  String get queenUnknown => 'Не указано';

  @override
  String get queenEdit => 'Изменить матку';

  @override
  String get queenReplace => 'Заменить матку';

  @override
  String get queenGive => 'Добавить матку';

  @override
  String get queenNoneTitle => 'Матка не записана';

  @override
  String get queenNoneMessage =>
      'Запишите матку, которую вы дали этому улью; её год, цвет и происхождение будут здесь.';

  @override
  String queenFormNewTitle(String number) {
    return 'Новая матка · Улей $number';
  }

  @override
  String get queenFormEditTitle => 'Изменить матку';

  @override
  String get queenFormSave => 'Сохранить';

  @override
  String queenGiven(String number) {
    return 'В улье $number новая матка';
  }

  @override
  String get oldQueensTitle => 'Старые матки';

  @override
  String oldQueensIntro(int age) {
    String _temp0 = intl.Intl.pluralLogic(
      age,
      locale: localeName,
      other:
          'Матки активных ульев в возрасте $age года и старше. Запланируйте замену.',
      many:
          'Матки активных ульев в возрасте $age лет и старше. Запланируйте замену.',
      few:
          'Матки активных ульев в возрасте $age года и старше. Запланируйте замену.',
      one:
          'Матки активных ульев в возрасте $age год и старше. Запланируйте замену.',
    );
    return '$_temp0';
  }

  @override
  String get oldQueensEmptyTitle => 'Старых маток нет';

  @override
  String oldQueensEmptyMessage(int age) {
    String _temp0 = intl.Intl.pluralLogic(
      age,
      locale: localeName,
      other: 'Матки активных ульев моложе $age лет или год не указан.',
      many: 'Матки активных ульев моложе $age лет или год не указан.',
      few: 'Матки активных ульев моложе $age лет или год не указан.',
      one: 'Матки активных ульев моложе $age года или год не указан.',
    );
    return '$_temp0';
  }

  @override
  String get syncTableMiteCounts => 'Подсчёт клеща';

  @override
  String get varroaMethodSugarRoll => 'Сахарная пудра';

  @override
  String get varroaMethodAlcoholWash => 'Спиртовая промывка';

  @override
  String get varroaMethodStickyBoard => 'Липкий вкладыш';

  @override
  String varroaFormTitle(String number) {
    return 'Варроа · Улей $number';
  }

  @override
  String get varroaMethod => 'Метод';

  @override
  String get varroaSampleBees => 'Пчёл в пробе';

  @override
  String get varroaBoardDays => 'Дней на вкладыше';

  @override
  String get varroaMites => 'Подсчитано клещей';

  @override
  String get varroaBoardMites => 'Опавших клещей';

  @override
  String get varroaSave => 'Сохранить';

  @override
  String varroaSaved(String number) {
    return 'Подсчёт клеща для улья $number сохранён';
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

    return '$valueString клещей/день';
  }

  @override
  String get varroaInfestation => 'Заражённость';

  @override
  String get varroaDailyDrop => 'Суточный опад';

  @override
  String get varroaReached => 'Порог достигнут · запланируйте обработку';

  @override
  String get varroaBelow => 'Ниже порога';

  @override
  String varroaThresholdNote(String threshold) {
    return 'Порог $threshold (из настроек).';
  }

  @override
  String get hiveVarroa => 'Варроа';

  @override
  String get hiveVarroaNone => 'Подсчётов пока нет';

  @override
  String get hiveVarroaReached => 'Порог достигнут';

  @override
  String get hiveVarroaCount => 'Подсчитать клеща';

  @override
  String varroaChartTitle(String apiary) {
    return '$apiary · последние подсчёты';
  }

  @override
  String varroaChartThreshold(String threshold) {
    return 'порог $threshold';
  }

  @override
  String get varroaChartEmpty =>
      'Подсчётов сахарной пудрой или спиртом пока нет. Добавьте подсчёт из карточки улья.';

  @override
  String varroaChartBar(String day, String value) {
    return '$day: $value';
  }

  @override
  String varroaChartSemantics(String threshold, String bars) {
    return 'Средняя заражённость по дням, порог $threshold: $bars';
  }

  @override
  String get settingsVarroa => 'Варроа';

  @override
  String get settingsVarroaPercent => 'Порог заражённости';

  @override
  String get settingsVarroaPerDay => 'Порог по вкладышу';

  @override
  String get settingsVarroaHint =>
      'Когда подсчёт достигает порога, показывается предупреждение. Хранится только на этом телефоне.';

  @override
  String get syncTableRefDrugs => 'Список препаратов';

  @override
  String get syncTableDrugs => 'Препарат';

  @override
  String get syncTableTreatments => 'Обработка';

  @override
  String get syncTableFeedings => 'Подкормка';

  @override
  String get drugIngredientAmitraz => 'Амитраз';

  @override
  String get drugIngredientOxalicAcid => 'Щавелевая кислота';

  @override
  String get drugIngredientFormicAcid => 'Муравьиная кислота';

  @override
  String get drugIngredientThymol => 'Тимол';

  @override
  String get drugIngredientFlumethrin => 'Флуметрин';

  @override
  String get drugIngredientTauFluvalinate => 'Тау-флювалинат';

  @override
  String get drugIngredientCoumaphos => 'Кумафос';

  @override
  String get drugIngredientLacticAcid => 'Молочная кислота';

  @override
  String get drugIngredientOther => 'Другое';

  @override
  String get drugUnitStrip => 'полоска';

  @override
  String get drugUnitMl => 'мл';

  @override
  String get drugUnitG => 'г';

  @override
  String get drugUnitDose => 'доза';

  @override
  String get hiveTreat => 'Обработать';

  @override
  String get treatmentFormTitle => 'Обработка';

  @override
  String treatmentScopeHive(String number) {
    return 'Улей $number';
  }

  @override
  String treatmentScopeApiary(int count) {
    return 'Вся пасека · $count';
  }

  @override
  String get treatmentChooseDrug => 'Выбрать препарат';

  @override
  String get treatmentChangeDrug => 'Изменить';

  @override
  String treatmentDrugIngredient(String ingredient) {
    return 'Действующее вещество: $ingredient';
  }

  @override
  String treatmentDrugLicense(String number) {
    return 'рег. № $number';
  }

  @override
  String get treatmentDrugCustom => 'ваш препарат';

  @override
  String get treatmentAddDrug => 'Добавить новый препарат';

  @override
  String get drugInfoOpen => 'Сведения о препарате';

  @override
  String get drugInfoSourceTitle =>
      'Источник: Министерство сельского и лесного хозяйства Турции';

  @override
  String get drugInfoSourceMessage =>
      'Это взято из одобренной министерством инструкции и показано на турецком, как опубликовано. Перед применением прочитайте этикетку; если сомневаетесь, спросите ветеринара.';

  @override
  String get drugInfoActiveIngredient => 'Действующее вещество';

  @override
  String get drugInfoIndications => 'Применяется при';

  @override
  String get drugInfoUsage => 'Применение и частота';

  @override
  String get drugInfoUsageMethod => 'Способ применения';

  @override
  String get drugInfoUsageMethodAndDose => 'Применение и доза';

  @override
  String get drugInfoUsageDiagnosis => 'Для диагностики';

  @override
  String get drugInfoUsageDose => 'Доза';

  @override
  String get drugInfoUsageFrequency => 'Частота';

  @override
  String get drugInfoUsageDuration => 'Длительность';

  @override
  String get drugInfoUsageOther => 'Примечание';

  @override
  String get drugInfoSuitablePeriods => 'Подходящие периоды';

  @override
  String get drugInfoAvoidPeriods => 'Не применять';

  @override
  String get drugInfoWithdrawal => 'Период ожидания';

  @override
  String get drugInfoWarnings => 'Предупреждения';

  @override
  String get drugInfoClose => 'Закрыть';

  @override
  String get treatmentBatchNo => '№ партии';

  @override
  String get treatmentStartedOn => 'Начало';

  @override
  String treatmentDose(String unit) {
    return 'Доза на улей ($unit)';
  }

  @override
  String treatmentDoseTotal(String total, String unit) {
    return 'Всего $total $unit';
  }

  @override
  String get treatmentWithdrawalDays => 'Период ожидания (дней)';

  @override
  String get treatmentRemoval => 'Снятие';

  @override
  String get treatmentRemovalNone => 'Нет';

  @override
  String get treatmentRemovalChange =>
      'Напоминание утром; нажмите, чтобы изменить';

  @override
  String get treatmentRemovalSingle =>
      'Однократное применение; нажмите, чтобы задать';

  @override
  String get treatmentRemovalClear => 'Без снятия (однократно)';

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
      other: 'снятие + $days дня ожидания',
      many: 'снятие + $days дней ожидания',
      few: 'снятие + $days дня ожидания',
      one: 'снятие + $days день ожидания',
      zero: 'без ожидания после снятия',
    );
    return '$_temp0';
  }

  @override
  String treatmentNoSuperAfterStart(int days) {
    String _temp0 = intl.Intl.pluralLogic(
      days,
      locale: localeName,
      other: 'начало + $days дня ожидания',
      many: 'начало + $days дней ожидания',
      few: 'начало + $days дня ожидания',
      one: 'начало + $days день ожидания',
      zero: 'без ожидания',
    );
    return '$_temp0';
  }

  @override
  String treatmentSave(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Сохранить для $count улья',
      many: 'Сохранить для $count ульев',
      few: 'Сохранить для $count ульев',
      one: 'Сохранить для $count улья',
    );
    return '$_temp0';
  }

  @override
  String treatmentSaved(String number) {
    return 'Обработка улья $number сохранена';
  }

  @override
  String treatmentSavedMany(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Обработка сохранена для $count улья',
      many: 'Обработка сохранена для $count ульев',
      few: 'Обработка сохранена для $count ульев',
      one: 'Обработка сохранена для $count улья',
    );
    return '$_temp0';
  }

  @override
  String get drugFormTitle => 'Новый препарат';

  @override
  String get drugName => 'Название';

  @override
  String get drugActiveIngredient => 'Действующее вещество';

  @override
  String get drugDoseUnit => 'Единица дозы';

  @override
  String get drugWithdrawalDays => 'Период ожидания по этикетке (дней)';

  @override
  String get drugSave => 'Добавить препарат';

  @override
  String get withdrawalLockTitle => 'Идёт период ожидания.';

  @override
  String withdrawalLockMessage(String number, String product, String date) {
    return 'Улей $number обрабатывается препаратом $product. Магазин нельзя ставить до $date; мёд этого периода может содержать остатки препарата.';
  }

  @override
  String get withdrawalDaysLeft => 'Осталось';

  @override
  String withdrawalDays(int days) {
    String _temp0 = intl.Intl.pluralLogic(
      days,
      locale: localeName,
      other: '$days дня',
      many: '$days дней',
      few: '$days дня',
      one: '$days день',
    );
    return '$_temp0';
  }

  @override
  String get withdrawalApplied => 'Применено';

  @override
  String get withdrawalReasonPrompt =>
      'Чтобы всё равно сохранить, выберите причину';

  @override
  String get withdrawalReasonRemovedEarly => 'Препарат снят раньше';

  @override
  String get withdrawalReasonNotForSale =>
      'Магазин не на продажу (для себя/на корм)';

  @override
  String get withdrawalCancel => 'Отмена, не ставить магазин';

  @override
  String get withdrawalProceed => 'Всё равно сохранить';

  @override
  String inspectionWithdrawalOverride(String reason) {
    return 'Магазин поставлен в период ожидания: $reason';
  }

  @override
  String timelineTreatment(String product) {
    return 'Обработка · $product';
  }

  @override
  String timelineTreatmentBatch(String batch) {
    return 'Партия $batch';
  }

  @override
  String treatmentDoseValue(String dose, String unit) {
    return '$dose $unit';
  }

  @override
  String timelineTreatmentRemoval(String date) {
    return 'снятие $date';
  }

  @override
  String timelineTreatmentWithdrawal(int days) {
    String _temp0 = intl.Intl.pluralLogic(
      days,
      locale: localeName,
      other: '$days дня ожидания',
      many: '$days дней ожидания',
      few: '$days дня ожидания',
      one: '$days день ожидания',
    );
    return '$_temp0';
  }

  @override
  String get hiveActiveTreatment => 'Идёт обработка';

  @override
  String get hiveActiveTreatmentNone => 'Нет';

  @override
  String hiveActiveTreatmentLeft(int days) {
    String _temp0 = intl.Intl.pluralLogic(
      days,
      locale: localeName,
      other: 'осталось $days дня',
      many: 'осталось $days дней',
      few: 'осталось $days дня',
      one: 'остался $days день',
    );
    return '$_temp0';
  }

  @override
  String hiveActiveTreatmentDetail(String ingredient) {
    return '$ingredient · без магазина';
  }

  @override
  String get treatmentRotationTitle => 'То же действующее вещество.';

  @override
  String treatmentRotationMessage(int count, String ingredient) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other:
          'Последние $count обработки на этой пасеке тоже были $ingredient. Подумайте о другом веществе, чтобы не вызвать устойчивость.',
      many:
          'Последние $count обработок на этой пасеке тоже были $ingredient. Подумайте о другом веществе, чтобы не вызвать устойчивость.',
      few:
          'Последние $count обработки на этой пасеке тоже были $ingredient. Подумайте о другом веществе, чтобы не вызвать устойчивость.',
      one:
          'Последняя $count обработка на этой пасеке тоже была $ingredient. Подумайте о другом веществе, чтобы не вызвать устойчивость.',
    );
    return '$_temp0';
  }

  @override
  String get treatmentPrescriptionAdd => 'Добавить фото рецепта / счёта';

  @override
  String get treatmentPrescriptionAdded => 'Фото рецепта добавлено';

  @override
  String get treatmentPrescriptionRemove => 'Удалить';

  @override
  String get reminderChannelName => 'Напоминания';

  @override
  String get treatmentReminderDenied =>
      'Уведомления выключены; напоминание о снятии не создано.';

  @override
  String get hiveFeed => 'Подкормить';

  @override
  String get feedingFormTitle => 'Подкормка';

  @override
  String feedingScopeHive(String number) {
    return 'Улей $number';
  }

  @override
  String feedingScopeApiary(int count) {
    return 'Вся пасека · $count';
  }

  @override
  String get feedingKind => 'Вид';

  @override
  String get feedingKindSyrup1to1 => 'Сироп 1:1 · стимулирующий';

  @override
  String get feedingKindSyrup2to1 => 'Сироп 2:1 · на зиму';

  @override
  String get feedingKindBeeCake => 'Канди';

  @override
  String get feedingKindPollenSubstitute => 'Заменитель перги';

  @override
  String feedingAmount(String unit) {
    return 'На улей ($unit)';
  }

  @override
  String get feedingSuperHiveTitle => 'На этом улье стоит магазин.';

  @override
  String get feedingSuperHiveMessage => 'Сироп может попасть в мёд.';

  @override
  String feedingSuperSkippedTitle(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'На $count улья стоят магазины',
      many: 'На $count ульях стоят магазины',
      few: 'На $count ульях стоят магазины',
      one: 'На $count улье стоит магазин',
    );
    return '$_temp0';
  }

  @override
  String feedingSuperSkippedMessage(String numbers) {
    return '($numbers). Пропущены, чтобы сироп не попал в мёд.';
  }

  @override
  String get feedingPrepare => 'Приготовить';

  @override
  String feedingPrepareCount(int count, String amount, String unit) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count улья × $amount $unit',
      many: '$count ульев × $amount $unit',
      few: '$count улья × $amount $unit',
      one: '$count улей × $amount $unit',
    );
    return '$_temp0';
  }

  @override
  String feedingTotalSyrup(String amount, String unit) {
    return '$amount $unit сиропа';
  }

  @override
  String feedingTotalBeeCake(String amount, String unit) {
    return '$amount $unit канди';
  }

  @override
  String feedingTotalPollenSubstitute(String amount, String unit) {
    return '$amount $unit заменителя перги';
  }

  @override
  String get feedingSugar => 'Сахар';

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
      other: 'Сохранить для $count улья',
      many: 'Сохранить для $count ульев',
      few: 'Сохранить для $count ульев',
      one: 'Сохранить для $count улья',
      zero: 'Нет ульев для подкормки',
    );
    return '$_temp0';
  }

  @override
  String feedingSaved(String number) {
    return 'Подкормка улья $number сохранена';
  }

  @override
  String feedingSavedMany(int count) {
    return 'Подкормка сохранена для ульев: $count';
  }

  @override
  String get unitLiter => 'л';

  @override
  String get unitGallon => 'гал';

  @override
  String get syncTableTasks => 'Задача';

  @override
  String get tasksTabToday => 'Сегодня';

  @override
  String get tasksTabWeek => 'Эта неделя';

  @override
  String get tasksTabApiary => 'По пасекам';

  @override
  String get tasksAdd => 'Добавить задачу';

  @override
  String tasksOverdue(int count) {
    return 'Просрочено · $count';
  }

  @override
  String tasksDayGroup(String day, int count) {
    return '$day · $count';
  }

  @override
  String get tasksToday => 'Сегодня';

  @override
  String get tasksTomorrow => 'Завтра';

  @override
  String get tasksNoApiary => 'Без пасеки';

  @override
  String tasksApiaryGroup(String apiary, int count) {
    return '$apiary · $count';
  }

  @override
  String get tasksEmptyTodayTitle => 'На сегодня дел нет';

  @override
  String get tasksEmptyWeekTitle => 'На этой неделе задач нет';

  @override
  String get tasksEmptyAddHint => 'Добавьте задачу кнопкой + справа вверху.';

  @override
  String get tasksLoadError => 'Не удалось загрузить задачи.';

  @override
  String tasksWeekDaySemantics(String day, int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count задачи',
      many: '$count задач',
      few: '$count задачи',
      one: '$count задача',
      zero: 'нет задач',
    );
    return '$day, $_temp0';
  }

  @override
  String taskOverdueDays(int days) {
    String _temp0 = intl.Intl.pluralLogic(
      days,
      locale: localeName,
      other: 'просрочено на $days дня',
      many: 'просрочено на $days дней',
      few: 'просрочено на $days дня',
      one: 'просрочено на $days день',
    );
    return '$_temp0';
  }

  @override
  String get taskSourceInspection => 'из осмотра';

  @override
  String get taskSourceTreatment => 'обработка';

  @override
  String taskInspectionTitle(String number) {
    return 'Улей $number · проверить снова';
  }

  @override
  String get taskInspectionTitleNoHive => 'Проверить снова';

  @override
  String taskTreatmentTitle(String number) {
    return 'Улей $number · снять полоски';
  }

  @override
  String get taskTreatmentTitleApiary => 'Снять полоски';

  @override
  String get taskReminderBody => 'Пора выполнить задачу.';

  @override
  String get taskAssigneeMe => 'Я';

  @override
  String taskAssignedTo(String name) {
    return 'Назначено: $name';
  }

  @override
  String taskMemberNumbered(String role, int index) {
    return '$role $index';
  }

  @override
  String get roleOwner => 'Владелец';

  @override
  String get rolePartner => 'Партнёр';

  @override
  String get roleWorker => 'Работник';

  @override
  String get roleViewer => 'Наблюдатель';

  @override
  String taskCompleteAction(String title) {
    return 'Выполнить: $title';
  }

  @override
  String get taskCompleted => 'Задача выполнена';

  @override
  String get taskFormNewTitle => 'Новая задача';

  @override
  String get taskFormEditTitle => 'Изменить задачу';

  @override
  String get taskFormName => 'Задача';

  @override
  String get taskFormNameHint => 'например, Съездить на горную пасеку';

  @override
  String get taskFormDue => 'Срок';

  @override
  String get taskFormPickDate => 'Другой день';

  @override
  String get taskFormTime => 'Время';

  @override
  String get taskFormApiary => 'Пасека';

  @override
  String get taskFormHive => 'Улей';

  @override
  String get taskFormNone => 'Нет';

  @override
  String get taskFormChooseApiary => 'Выбрать пасеку';

  @override
  String get taskFormChooseHive => 'Выбрать улей';

  @override
  String get taskFormAssignee => 'Исполнитель';

  @override
  String get taskFormUnassigned => 'Не назначено';

  @override
  String get taskFormCompleted => 'Выполнено';

  @override
  String get taskFormSave => 'Сохранить';

  @override
  String get taskFormDelete => 'Удалить задачу';

  @override
  String get taskDeleteTitle => 'Удалить эту задачу?';

  @override
  String get taskDeleteMessage => 'Задача будет удалена со всех телефонов.';

  @override
  String get taskDeleteConfirm => 'Удалить';

  @override
  String get taskSaved => 'Задача сохранена';

  @override
  String get taskDeleted => 'Задача удалена';

  @override
  String get taskNotFound => 'Задача не найдена; возможно, она удалена.';

  @override
  String get taskReminderDenied =>
      'Уведомления выключены; напоминание не сработает.';

  @override
  String get exactAlarmTitle => 'Напоминать точно в срок?';

  @override
  String get exactAlarmMessage =>
      'Android может откладывать уведомления на несколько минут ради экономии батареи. Разрешите Mobil Arıcı в открывшейся настройке, и напоминания о задачах будут приходить точно вовремя. Интернет не нужен.';

  @override
  String get exactAlarmConfirm => 'Открыть настройку';

  @override
  String get settingsReminders => 'Напоминания';

  @override
  String get settingsExactAlarms => 'Точно в срок';

  @override
  String get settingsExactAlarmsOn => 'Вкл.';

  @override
  String get settingsExactAlarmsOff =>
      'Выкл. · может опаздывать на несколько минут';

  @override
  String weatherTemperature(String value) {
    return '$value°';
  }

  @override
  String weatherForecastAsOf(String time) {
    return 'Прогноз на $time';
  }

  @override
  String get weatherNoLocationTitle => 'Нет местоположения';

  @override
  String get weatherNoLocationAction => 'Добавьте место для погоды';

  @override
  String get weatherPendingHint => 'Появится, когда будет интернет';

  @override
  String weatherWind(String speed) {
    return 'Ветер $speed';
  }

  @override
  String weatherSpeed(String value, String unit) {
    return '$value $unit';
  }

  @override
  String get unitKmh => 'км/ч';

  @override
  String get unitMph => 'миль/ч';

  @override
  String weatherPercent(String value) {
    return '$value%';
  }

  @override
  String weatherTemperatureRange(String max, String min) {
    return '$max / $min';
  }

  @override
  String get hiveOpeningRain => 'Дождь';

  @override
  String get hiveOpeningWind => 'Ветрено';

  @override
  String get hiveOpeningCold => 'Холодно';

  @override
  String get hiveOpeningDaySuitable => 'Можно';

  @override
  String get weatherConditionSunny => 'Солнечно';

  @override
  String get weatherConditionPartlyCloudy => 'Переменная облачность';

  @override
  String get weatherConditionCloudy => 'Облачно';

  @override
  String get weatherConditionRainy => 'Дождь';

  @override
  String get weatherConditionWindy => 'Ветрено';

  @override
  String get weatherConditionOther => 'Снег, туман или гроза';

  @override
  String get weatherConditionFog => 'Туман';

  @override
  String get weatherConditionThunder => 'Грозы';

  @override
  String get weatherConditionSleet => 'Мокрый снег';

  @override
  String get weatherConditionSnow => 'Снег';

  @override
  String weatherFeelsLike(String condition, String value) {
    return '$condition · ощущается как $value';
  }

  @override
  String get weatherWindLabel => 'Ветер';

  @override
  String get weatherHumidityLabel => 'Влажность';

  @override
  String get weatherPrecipitationLabel => 'Дождь';

  @override
  String get weatherScreenTitle => 'Погода на пасеке';

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
    return 'Обновлено $time';
  }

  @override
  String get weatherNow => 'Сейчас';

  @override
  String get weatherToday => 'Сегодня';

  @override
  String get weatherColumnDay => 'День';

  @override
  String get weatherColumnTemperature => 'Темп.';

  @override
  String get weatherColumnPrecipitation => 'Дождь';

  @override
  String get weatherColumnHive => 'Ульи';

  @override
  String get weatherTodaySuitable => 'Хороший день, чтобы открывать ульи';

  @override
  String get weatherTodayRain => 'Сегодня дождь; не день для осмотра';

  @override
  String get weatherTodayWind => 'Сегодня ветрено; не день для осмотра';

  @override
  String get weatherTodayCold => 'Сегодня холодно; не день для осмотра';

  @override
  String weatherDayRange(String from, String to) {
    return '$from–$to';
  }

  @override
  String weatherPlanRain(String days) {
    return 'Дождь: $days.';
  }

  @override
  String weatherPlanWind(String days) {
    return 'Ветер: $days.';
  }

  @override
  String weatherPlanMove(String weekday) {
    String _temp0 = intl.Intl.selectLogic(weekday, {
      'monday': 'Перенесите осмотры на понедельник.',
      'tuesday': 'Перенесите осмотры на вторник.',
      'wednesday': 'Перенесите осмотры на среду.',
      'thursday': 'Перенесите осмотры на четверг.',
      'friday': 'Перенесите осмотры на пятницу.',
      'saturday': 'Перенесите осмотры на субботу.',
      'other': 'Перенесите осмотры на воскресенье.',
    });
    return '$_temp0';
  }

  @override
  String get weatherPlanAction => 'Запланировать';

  @override
  String weatherPlanTaskTitle(String apiary) {
    return 'Осмотр: $apiary';
  }

  @override
  String weatherThresholdsHint(
    String temperature,
    String wind,
    String precipitation,
  ) {
    return 'Можно открывать: выше $temperature, ветер слабее $wind, вероятность дождя ниже $precipitation. Пороги можно изменить в настройках.';
  }

  @override
  String get weatherEmptyTitle => 'Прогноза пока нет';

  @override
  String get weatherEmptyMessage =>
      'Прогноз для этой пасеки ещё не загружен. Обновите, когда появится интернет.';

  @override
  String get weatherNoLocationMessage =>
      'У этой пасеки нет местоположения. Добавьте его, чтобы получать прогноз.';

  @override
  String get weatherRefresh => 'Обновить';

  @override
  String get weatherRefreshFailed =>
      'Не удалось получить прогноз. Проверьте подключение к интернету.';

  @override
  String get weatherApiaryNotFound => 'Пасека не найдена';

  @override
  String get weatherAttributionPrefix => 'Powered by';

  @override
  String get weatherAttributionLink => 'WeatherAPI.com';

  @override
  String get settingsHiveOpening => 'Пороги для осмотра ульев';

  @override
  String get settingsHiveOpeningTemperature => 'Температура';

  @override
  String settingsHiveOpeningTemperatureValue(String value) {
    return 'выше $value';
  }

  @override
  String get settingsHiveOpeningWind => 'Ветер';

  @override
  String get settingsHiveOpeningPrecipitation => 'Вероятность дождя';

  @override
  String settingsHiveOpeningBelow(String value) {
    return 'ниже $value';
  }

  @override
  String get settingsHiveOpeningHint =>
      'Экран погоды и карточки «Сегодня» пишут «Можно» по этим порогам. Хранится только на этом телефоне.';

  @override
  String get hiveOpeningSuitable => 'Можно открывать';

  @override
  String get todayGreetingMorning => 'Доброе утро';

  @override
  String get todayGreetingAfternoon => 'Добрый день';

  @override
  String get todayGreetingEvening => 'Добрый вечер';

  @override
  String get todayAttentionTitle => 'Требуют внимания';

  @override
  String todayAttentionHiveCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count улья',
      many: '$count ульев',
      few: '$count улья',
      one: '$count улей',
    );
    return '$_temp0';
  }

  @override
  String get todayAttentionNone => 'Ни один улей не требует внимания';

  @override
  String get todayTasksTitle => 'Сегодня';

  @override
  String todayTasksCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count задачи',
      many: '$count задач',
      few: '$count задачи',
      one: '$count задача',
    );
    return '$_temp0';
  }

  @override
  String todayTasksApiaryCount(String apiary, int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count задачи',
      many: '$count задач',
      few: '$count задачи',
      one: '$count задача',
    );
    return '$apiary · $_temp0';
  }

  @override
  String todaySetupProgress(int done, int total) {
    return 'Настройка $done/$total';
  }

  @override
  String get setupStepApiary => 'Добавьте пасеку';

  @override
  String get setupStepHives => 'Создайте ульи';

  @override
  String get setupStepInspection => 'Проведите первый осмотр';

  @override
  String setupStepDone(String step) {
    return '$step: готово';
  }

  @override
  String get attentionQueenless => 'Безматочные';

  @override
  String get attentionWeak => 'Слабые';

  @override
  String get attentionSwarming => 'Признаки роения';

  @override
  String get attentionTreatmentRemoval => 'Снять обработку';

  @override
  String get attentionQueenlessTitle => 'Безматочные ульи';

  @override
  String get attentionWeakTitle => 'Слабые ульи';

  @override
  String get attentionSwarmingTitle => 'Ульи с признаками роения';

  @override
  String get attentionTreatmentRemovalTitle => 'Обработки к снятию';

  @override
  String get attentionQueenlessIntro =>
      'Активные ульи, где при последнем осмотре не нашли ни матки, ни яиц.';

  @override
  String attentionWeakIntro(int max) {
    return 'Активные ульи с силой $max/5 или ниже на последнем осмотре.';
  }

  @override
  String get attentionSwarmingIntro =>
      'Активные ульи, где на последнем осмотре были признаки роения или роевые маточники.';

  @override
  String get attentionTreatmentRemovalIntro =>
      'Ульи, где пора снимать полоски, а задача ещё не выполнена.';

  @override
  String get attentionEmpty => 'В этой группе нет ульев.';

  @override
  String attentionLastInspection(String date) {
    return 'Последний осмотр: $date';
  }

  @override
  String attentionRemovalDue(String date) {
    return 'Снять до: $date';
  }

  @override
  String get syncTableHarvests => 'Медосбор';

  @override
  String get syncTableHarvestHives => 'Улей медосбора';

  @override
  String withdrawalLockHarvestMessage(
    String number,
    String product,
    String date,
  ) {
    return 'Улей $number обрабатывается препаратом $product. Отбирать мёд нельзя до $date; мёд этого периода может содержать остатки препарата.';
  }

  @override
  String get withdrawalReasonNotForSaleHarvest =>
      'Мёд не на продажу (для себя/на корм)';

  @override
  String get withdrawalHarvestCancel => 'Отмена, не отбирать';

  @override
  String get withdrawalHarvestProceed => 'Всё равно отобрать';

  @override
  String get apiaryHarvest => 'Медосбор';

  @override
  String harvestFormTitle(String apiary) {
    return 'Медосбор · $apiary';
  }

  @override
  String harvestSelectedCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Выбрано $count улья',
      many: 'Выбрано $count ульев',
      few: 'Выбрано $count улья',
      one: 'Выбран $count улей',
      zero: 'Ульи не выбраны',
    );
    return '$_temp0';
  }

  @override
  String harvestSelectedHint(String numbers) {
    return '$numbers · нажмите, чтобы изменить, или сканируйте, чтобы добавить';
  }

  @override
  String get harvestSelectedEmptyHint =>
      'Нажмите, чтобы выбрать ульи, или сканируйте';

  @override
  String get harvestScan => 'Сканировать';

  @override
  String harvestLockedTitle(String numbers) {
    return '$numbers: идёт период ожидания.';
  }

  @override
  String get harvestLockedMessage =>
      'Мёд не отобран. Чтобы всё же отобрать, выберите улей в списке.';

  @override
  String get harvestDate => 'Дата';

  @override
  String get harvestToday => 'Сегодня';

  @override
  String get harvestYesterday => 'Вчера';

  @override
  String get harvestPickDate => 'Другой день';

  @override
  String get harvestHoneyKind => 'Вид мёда';

  @override
  String get honeyKindPine => 'Сосновый';

  @override
  String get honeyKindFlower => 'Цветочный';

  @override
  String get honeyKindChestnut => 'Каштановый';

  @override
  String get honeyKindCitrus => 'Цитрусовый';

  @override
  String get honeyKindOther => 'Другой';

  @override
  String get harvestUnit => 'Отобрано';

  @override
  String get harvestUnitSuper => 'Магазинами';

  @override
  String get harvestUnitFrame => 'Рамками';

  @override
  String get harvestTakenSupers => 'Отобрано магазинов';

  @override
  String get harvestTakenFrames => 'Отобрано рамок';

  @override
  String harvestWeight(String unit) {
    return 'Откачано мёда ($unit)';
  }

  @override
  String get harvestWeightInvalid => 'Введите вес, например 574 или 574,5';

  @override
  String harvestWeightTooLarge(String max, String unit) {
    return 'Не больше $max $unit';
  }

  @override
  String get harvestPerHive => 'На улей';

  @override
  String harvestWeightValue(String value, String unit) {
    return '$value $unit';
  }

  @override
  String harvestSave(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Сохранить медосбор',
      many: 'Сохранить медосбор',
      few: 'Сохранить медосбор',
      one: 'Сохранить медосбор',
      zero: 'Нет ульев для отбора',
    );
    return '$_temp0';
  }

  @override
  String harvestSaved(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Медосбор сохранён для $count улья',
      many: 'Медосбор сохранён для $count ульев',
      few: 'Медосбор сохранён для $count ульев',
      one: 'Медосбор сохранён для $count улья',
    );
    return '$_temp0';
  }

  @override
  String get harvestHivesTitle => 'Ульи для отбора';

  @override
  String get harvestSelectAll => 'Выбрать все';

  @override
  String get harvestSelectNone => 'Снять выбор';

  @override
  String harvestHiveLocked(int days) {
    String _temp0 = intl.Intl.pluralLogic(
      days,
      locale: localeName,
      other: 'осталось $days дня',
      many: 'осталось $days дней',
      few: 'осталось $days дня',
      one: 'остался $days день',
    );
    return 'Ожидание · $_temp0';
  }

  @override
  String harvestHiveOverridden(String reason) {
    return 'Всё равно отобрано: $reason';
  }

  @override
  String get harvestHivesDone => 'Готово';

  @override
  String get harvestNoActiveHives => 'На этой пасеке нет активных ульев.';

  @override
  String get harvestScanTitle => 'Сканирование для медосбора';

  @override
  String harvestScanAdded(String number) {
    return 'Улей $number добавлен';
  }

  @override
  String harvestScanAlready(String number) {
    return 'Улей $number уже выбран';
  }

  @override
  String harvestScanOtherApiary(String number) {
    return 'Улей $number не на этой пасеке';
  }

  @override
  String harvestScanInactive(String number) {
    return 'Улей $number не активен';
  }

  @override
  String get harvestScanUnknown => 'Эта этикетка не привязана к улью';

  @override
  String harvestScanDone(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Готово · $count улья',
      many: 'Готово · $count ульев',
      few: 'Готово · $count улья',
      one: 'Готово · $count улей',
      zero: 'Готово',
    );
    return '$_temp0';
  }

  @override
  String get apiaryTourStart => 'Начать обход';

  @override
  String get apiaryTourResume => 'Продолжить обход';

  @override
  String get tourReplaceTitle => 'Завершить текущий обход?';

  @override
  String tourReplaceMessage(String apiary) {
    return 'Обход пасеки $apiary ещё идёт. Новый обход сбросит его прогресс; осмотры останутся сохранёнными.';
  }

  @override
  String get tourReplaceConfirm => 'Начать новый обход';

  @override
  String tourTitle(String apiary) {
    return 'Обход: $apiary';
  }

  @override
  String get tourFinish => 'Завершить обход';

  @override
  String tourProgress(int done, int total) {
    return '$done / $total';
  }

  @override
  String tourProgressLabel(int done, int total) {
    return 'Готово $done из $total ульев';
  }

  @override
  String tourMinutes(int minutes) {
    return '$minutes мин';
  }

  @override
  String tourHoursMinutes(int hours, int minutes) {
    return '$hours ч $minutes мин';
  }

  @override
  String tourElapsedLabel(String duration) {
    return 'Прошло времени: $duration';
  }

  @override
  String get tourNext => 'Следующий';

  @override
  String tourPreviousVisit(String date) {
    return 'В прошлый раз · $date';
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
  String get tourStateSkipped => 'Пропущен';

  @override
  String get tourStatePending => 'Ждёт';

  @override
  String get tourStateNext => 'Следующий';

  @override
  String tourHiveSemantics(String number, String state) {
    return 'Улей $number, $state';
  }

  @override
  String get tourSkip => 'Пропустить';

  @override
  String tourInspect(String number) {
    return 'Осмотреть $number';
  }

  @override
  String get tourAllDone => 'Все ульи осмотрены.';

  @override
  String get tourSunSuggestion =>
      'Режим «Солнце» делает экран читаемее при ярком свете.';

  @override
  String get tourSunOn => 'Включить режим «Солнце»';

  @override
  String get tourSunMode => 'Режим «Солнце»';

  @override
  String get tourFinishTitle => 'Завершить обход?';

  @override
  String tourFinishMessage(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count улья не осмотрены; в итогах они будут пропущенными.',
      many: '$count ульев не осмотрены; в итогах они будут пропущенными.',
      few: '$count улья не осмотрены; в итогах они будут пропущенными.',
      one: '$count улей не осмотрен; в итогах он будет пропущенным.',
    );
    return '$_temp0';
  }

  @override
  String get tourNotFound => 'На этой пасеке нет текущего обхода.';

  @override
  String get tourCompleteTitle => 'Обход завершён';

  @override
  String tourInspectedCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Осмотрено $count улья',
      many: 'Осмотрено $count ульев',
      few: 'Осмотрено $count улья',
      one: 'Осмотрен $count улей',
    );
    return '$_temp0';
  }

  @override
  String get tourHealthy => 'Сильные / средние';

  @override
  String get tourTasksTitle => 'Задачи';

  @override
  String tourTaskRequeen(String numbers) {
    return 'Заменить матку: $numbers';
  }

  @override
  String tourTaskFeedWeak(String numbers) {
    return 'Подкормить сиропом 1:1: $numbers';
  }

  @override
  String tourTaskSwarmCheck(String numbers) {
    return 'Проверить на роение: $numbers';
  }

  @override
  String tourTaskRevisit(String numbers) {
    return 'Проверить пропущенные ульи: $numbers';
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
      many: 'через $days дней',
      few: 'через $days дня',
      one: 'через $days день',
      zero: 'сегодня',
    );
    return '$_temp0';
  }

  @override
  String tourSaveTasks(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Сохранить задачи',
      many: 'Сохранить задачи',
      few: 'Сохранить задачи',
      one: 'Сохранить',
      zero: 'Закрыть',
    );
    return '$_temp0';
  }

  @override
  String tourTasksSaved(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Сохранено $count задачи',
      many: 'Сохранено $count задач',
      few: 'Сохранено $count задачи',
      one: 'Сохранена $count задача',
    );
    return '$_temp0';
  }

  @override
  String get tourNoTasks => 'Предложить нечего.';

  @override
  String get reportsTitle => 'Отчёты';

  @override
  String get reportTreatmentRegister => 'Журнал обработок';

  @override
  String get reportTreatmentRegisterHint => 'Для проверок';

  @override
  String get reportHiveHistory => 'История улья';

  @override
  String get reportHiveHistoryHint => 'Один улей или пасека';

  @override
  String get reportFrom => 'С';

  @override
  String get reportTo => 'По';

  @override
  String get reportApiary => 'Пасека';

  @override
  String get reportAllApiaries => 'Все пасеки';

  @override
  String get reportHive => 'Улей';

  @override
  String get reportAllHives => 'Все ульи';

  @override
  String get reportLanguage => 'Язык PDF';

  @override
  String get reportRegistrationNo => 'Рег. № хозяйства';

  @override
  String get reportAksNo => '№ AKS';

  @override
  String get reportRecordNo => 'Регистрационный номер';

  @override
  String get reportNumbersHelper =>
      'Печатается только в шапке PDF; не сохраняется.';

  @override
  String get reportShare => 'Поделиться';

  @override
  String get reportCreate => 'Создать PDF';

  @override
  String get reportPreparing => 'Готовим PDF…';

  @override
  String get reportError => 'Не удалось создать PDF. Попробуйте снова.';

  @override
  String get reportLoadError => 'Не удалось прочитать записи.';

  @override
  String get reportEmpty => 'За этот период записей нет.';

  @override
  String reportTreatmentCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count обработки',
      many: '$count обработок',
      few: '$count обработки',
      one: '$count обработка',
    );
    return '$_temp0';
  }

  @override
  String reportHiveCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count улья',
      many: '$count ульев',
      few: '$count улья',
      one: '$count улей',
    );
    return '$_temp0';
  }

  @override
  String reportRecordCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count записи',
      many: '$count записей',
      few: '$count записи',
      one: '$count запись',
    );
    return '$_temp0';
  }

  @override
  String get reportNoValue => '—';

  @override
  String get pdfTreatmentRegisterTitle => 'Журнал обработок';

  @override
  String get pdfHiveHistoryTitle => 'История улья';

  @override
  String pdfRegistrationNo(String number) {
    return 'Рег. № хозяйства $number';
  }

  @override
  String pdfAksNo(String number) {
    return '№ AKS $number';
  }

  @override
  String pdfRecordNo(String number) {
    return 'Рег. № $number';
  }

  @override
  String pdfPeriod(String from, String to) {
    return 'Период: $from – $to';
  }

  @override
  String pdfApiary(String name) {
    return 'Пасека: $name';
  }

  @override
  String pdfCreated(String date) {
    return 'Создано $date';
  }

  @override
  String pdfPage(int page, int pages) {
    return 'Стр. $page из $pages';
  }

  @override
  String get pdfColumnDate => 'Дата';

  @override
  String get pdfColumnApiary => 'Пасека';

  @override
  String get pdfColumnProduct => 'Препарат / партия';

  @override
  String get pdfColumnHives => 'Ульи';

  @override
  String get pdfColumnDose => 'Доза на улей';

  @override
  String get pdfColumnRemoval => 'Снятие';

  @override
  String get pdfColumnWithdrawalEnd => 'Конец ожидания';

  @override
  String get pdfColumnEvent => 'Запись';

  @override
  String get pdfColumnDetails => 'Подробности';

  @override
  String get pdfEventFeeding => 'Подкормка';

  @override
  String get pdfEventVarroa => 'Подсчёт клеща';

  @override
  String get pdfEventHarvest => 'Медосбор';

  @override
  String pdfHarvestTotal(String amount) {
    return 'Весь медосбор: $amount';
  }

  @override
  String pdfDocumentName(String title, String from, String to) {
    return '$title $from–$to';
  }

  @override
  String get moreFeedback => 'Отправить отзыв';

  @override
  String get feedbackTitle => 'Отправить отзыв';

  @override
  String get feedbackIntro =>
      'Мы делаем это приложение вместе с пчеловодами. Мы читаем каждое сообщение.';

  @override
  String get feedbackKindLabel => 'О чём это?';

  @override
  String get feedbackKindBug => 'Ошибка';

  @override
  String get feedbackKindSuggestion => 'Предложение';

  @override
  String get feedbackKindMissingFeature => 'Не хватает функции';

  @override
  String get feedbackKindThanks => 'Благодарность';

  @override
  String get feedbackMessageLabel => 'Ваше сообщение';

  @override
  String get feedbackMessageHint => 'Что произошло и чего вы ожидали?';

  @override
  String get feedbackAddScreenshot => 'Добавить скриншот';

  @override
  String get feedbackScreenshotAttached => 'Скриншот прикреплён';

  @override
  String get feedbackRemoveScreenshot => 'Удалить';

  @override
  String get feedbackScreenshotDenied =>
      'Доступ к фото не разрешён. Чтобы прикрепить скриншот, разрешите его в настройках.';

  @override
  String get feedbackIncludeDeviceInfo =>
      'Приложить сведения об устройстве и версии';

  @override
  String get feedbackOfflineHint =>
      'Без интернета сообщение встанет в очередь и уйдёт, когда появится сеть.';

  @override
  String get feedbackSend => 'Отправить';

  @override
  String get feedbackQueued => 'Спасибо! Сообщение в очереди на отправку.';

  @override
  String get settingsAnalytics => 'Делиться данными об использовании';

  @override
  String get settingsAnalyticsHint =>
      'Числа вроде времени осмотра, результатов сканирования и задержки синхронизации; ваше имя, ульи и местоположения никогда не отправляются.';

  @override
  String get teamTitle => 'Команда';

  @override
  String get teamRoleOwner => 'Владелец';

  @override
  String get teamRolePartner => 'Партнёр';

  @override
  String get teamRoleWorker => 'Работник';

  @override
  String get teamRoleViewer => 'Консультант';

  @override
  String get teamRoleViewerSubtitle => 'Только чтение';

  @override
  String get teamRoleHintPartner => 'Партнёр вносит записи и видит финансы.';

  @override
  String get teamRoleHintWorker =>
      'Работник вносит записи, но не видит финансы.';

  @override
  String get teamRoleHintViewer =>
      'Консультант может только читать и не вносит записи.';

  @override
  String teamMemberSelf(String name) {
    return '$name (вы)';
  }

  @override
  String get teamMemberUnknown => 'Участник команды';

  @override
  String get teamMembersEmpty => 'Участники появятся после синхронизации.';

  @override
  String get teamInviteTitle => 'Пригласить в команду';

  @override
  String get teamInviteHint =>
      'Скажите или отправьте код. Он действует 48 часов.';

  @override
  String get teamInviteGenerate => 'Создать код';

  @override
  String get teamInviteCopy => 'Копировать';

  @override
  String get teamInviteCopied => 'Код скопирован.';

  @override
  String teamInviteCodeSemantics(String code) {
    return 'Код приглашения $code';
  }

  @override
  String get teamHaveCode => 'У меня есть код';

  @override
  String get teamJoinTitle => 'Вступить по коду';

  @override
  String get teamJoinHint => 'Введите 6-значный код, который вам прислали.';

  @override
  String get teamJoinCodeLabel => 'Код приглашения';

  @override
  String get teamJoinAction => 'Вступить';

  @override
  String get teamJoinDone => 'Вы вступили в команду.';

  @override
  String get teamErrorOffline =>
      'Для этого нужен интернет. Попробуйте снова, когда будете в сети.';

  @override
  String get teamErrorInvalidCode =>
      'Код неверный, устарел или уже использован.';

  @override
  String get teamErrorAlreadyMember => 'Вы уже состоите в этой команде.';

  @override
  String get teamErrorForbidden => 'У вас нет права это делать.';

  @override
  String get teamErrorOwnerLocked =>
      'Роль владельца нельзя изменить, а самого владельца нельзя удалить.';

  @override
  String get teamErrorUnknown => 'Не получилось. Попробуйте чуть позже.';

  @override
  String get teamRemoveAction => 'Удалить из команды';

  @override
  String get teamRemoveTitle => 'Удалить из команды?';

  @override
  String teamRemoveMessage(String name) {
    return '$name потеряет доступ к записям этого хозяйства.';
  }

  @override
  String get teamRemoveConfirm => 'Удалить';

  @override
  String teamRemoved(String name) {
    return '$name удалён из команды.';
  }

  @override
  String teamRoleChanged(String name, String role) {
    return 'Теперь $name — $role.';
  }

  @override
  String get teamActivityTitle => 'Последние действия';

  @override
  String get teamActivityEmpty => 'Действий пока нет.';

  @override
  String get teamActivitySelf => 'Вы';

  @override
  String teamActivityInspection(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'внёс $count осмотра',
      many: 'внёс $count осмотров',
      few: 'внёс $count осмотра',
      one: 'внёс $count осмотр',
    );
    return '$_temp0';
  }

  @override
  String teamActivityTreatment(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'обработал $count улья',
      many: 'обработал $count ульев',
      few: 'обработал $count улья',
      one: 'обработал $count улей',
    );
    return '$_temp0';
  }

  @override
  String teamActivityFeeding(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'подкормил $count улья',
      many: 'подкормил $count ульев',
      few: 'подкормил $count улья',
      one: 'подкормил $count улей',
    );
    return '$_temp0';
  }

  @override
  String teamActivityHarvest(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'записал $count медосбора',
      many: 'записал $count медосборов',
      few: 'записал $count медосбора',
      one: 'записал $count медосбор',
    );
    return '$_temp0';
  }

  @override
  String teamActivityMiteCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'внёс $count подсчёта клеща',
      many: 'внёс $count подсчётов клеща',
      few: 'внёс $count подсчёта клеща',
      one: 'внёс $count подсчёт клеща',
    );
    return '$_temp0';
  }

  @override
  String teamActivityTask(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'добавил $count задачи',
      many: 'добавил $count задач',
      few: 'добавил $count задачи',
      one: 'добавил $count задачу',
    );
    return '$_temp0';
  }

  @override
  String get teamActivityJustNow => 'только что';

  @override
  String teamActivityMinutesAgo(int count) {
    return '$count мин назад';
  }

  @override
  String teamActivityHoursAgo(int count) {
    return '$count ч назад';
  }

  @override
  String get teamActivityYesterday => 'вчера';

  @override
  String teamActivityDaysAgo(int count) {
    return '$count дн. назад';
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
  String get settingsPush => 'Уведомления о задачах';

  @override
  String get settingsPushHint =>
      'Получайте уведомление, когда вам назначают задачу. Нажмите на него, чтобы открыть задачу.';

  @override
  String get documentsTitle => 'Папка документов';

  @override
  String get documentsAdd => 'Добавить документ';

  @override
  String documentsSummaryOffline(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count документа',
      many: '$count документов',
      few: '$count документа',
      one: '$count документ',
    );
    return '$_temp0 · все открываются без интернета';
  }

  @override
  String documentsSummaryMissing(int count, int missing) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count документа',
      many: '$count документов',
      few: '$count документа',
      one: '$count документ',
    );
    String _temp1 = intl.Intl.pluralLogic(
      missing,
      locale: localeName,
      other: '$missing файла',
      many: '$missing файлов',
      few: '$missing файлов',
      one: '$missing файла',
    );
    return '$_temp0 · $_temp1 ещё нет на этом телефоне';
  }

  @override
  String get documentsRegionNoteTr =>
      'Виды документов зависят от страны. Вне Турции вы создаёте свои виды документов.';

  @override
  String get documentsRegionNoteOther =>
      'Виды документов задаёте вы; введённые виды будут предлагаться в следующий раз.';

  @override
  String get documentsRoadCheck => 'Проверка на дороге · показать документы';

  @override
  String get documentsEmptyTitle => 'Документов пока нет';

  @override
  String get documentsEmptyMessage =>
      'Добавьте фото или PDF разрешений и свидетельств. Они открываются без интернета, а перед окончанием срока будет напоминание.';

  @override
  String get documentsLoadError => 'Не удалось открыть документы.';

  @override
  String get documentFileKindPhoto => 'ФОТО';

  @override
  String get documentFileKindPdf => 'PDF';

  @override
  String get documentTypeHealthReport => 'Ветеринарная справка';

  @override
  String get documentTypeTransportPermit => 'Разрешение на перевозку';

  @override
  String get documentTypeMigratoryCertificate =>
      'Свидетельство кочевого пчеловода';

  @override
  String get documentTypeBusinessRegistration =>
      'Свидетельство о регистрации хозяйства';

  @override
  String get documentTypeLandPermit => 'Разрешение на землю';

  @override
  String get documentTypeAnalysisReport => 'Протокол анализа';

  @override
  String get documentExpiryNone => 'Бессрочный';

  @override
  String get documentExpiryExpired => 'Истёк';

  @override
  String get documentExpiryToday => 'Истекает сегодня';

  @override
  String documentExpiryDays(int days) {
    String _temp0 = intl.Intl.pluralLogic(
      days,
      locale: localeName,
      other: '$days дня',
      many: '$days дней',
      few: '$days дня',
      one: '$days день',
    );
    return '$_temp0';
  }

  @override
  String documentExpiryMonths(int months) {
    String _temp0 = intl.Intl.pluralLogic(
      months,
      locale: localeName,
      other: '$months месяца',
      many: '$months месяцев',
      few: '$months месяца',
      one: '$months месяц',
    );
    return '$_temp0';
  }

  @override
  String documentExpiresOn(String date) {
    return 'Действует до $date';
  }

  @override
  String get documentFormNewTitle => 'Добавить документ';

  @override
  String get documentFormEditTitle => 'Изменить документ';

  @override
  String get documentFormType => 'Вид документа';

  @override
  String get documentFormCustomTypeHint => 'например, Страховой полис';

  @override
  String get documentFormName => 'Название';

  @override
  String get documentFormNameHint => 'например, Ветсправка 2026';

  @override
  String get documentFormDescription => 'Описание';

  @override
  String get documentFormDescriptionHint =>
      'например, Районная ветслужба · 152 улья';

  @override
  String get documentFormExpiry => 'Действует до';

  @override
  String get documentFormNoExpiry => 'Бессрочный';

  @override
  String get documentFormPickDate => 'Выбрать дату';

  @override
  String get documentFormExpiryHelper =>
      'Напомним за 30, 7 и 1 день до окончания срока.';

  @override
  String get documentFormFile => 'Файл';

  @override
  String get documentFormTakePhoto => 'Сфотографировать';

  @override
  String get documentFormPickImage => 'Из галереи';

  @override
  String get documentFormPickPdf => 'Выбрать PDF';

  @override
  String get documentFormNoFile =>
      'Сфотографируйте документ или выберите его PDF.';

  @override
  String documentFileSizeKb(String size) {
    return '$size КБ';
  }

  @override
  String documentFileSizeMb(String size) {
    return '$size МБ';
  }

  @override
  String get documentFileTooLarge => 'Файл больше 20 МБ; выберите поменьше.';

  @override
  String get documentFileFailed =>
      'Не удалось получить файл, попробуйте снова.';

  @override
  String get documentFilePermissionDenied =>
      'Доступ запрещён. Чтобы добавить документ, разрешите этому приложению доступ к камере или файлам в настройках.';

  @override
  String get documentFormSave => 'Сохранить';

  @override
  String get documentFormDelete => 'Удалить документ';

  @override
  String get documentSaved => 'Документ сохранён';

  @override
  String get documentReminderDenied =>
      'Документ сохранён. Без разрешения на уведомления напоминания о сроке не придут.';

  @override
  String get documentDeleteTitle => 'Удалить этот документ?';

  @override
  String get documentDeleteMessage =>
      'Документ и его файл будут удалены со всех телефонов.';

  @override
  String get documentDeleteConfirm => 'Удалить';

  @override
  String get documentDeleted => 'Документ удалён';

  @override
  String get documentNotFound => 'Документ не найден; возможно, он удалён.';

  @override
  String get documentEdit => 'Изменить';

  @override
  String get documentFileMissing =>
      'Файла пока нет на этом телефоне. Он загрузится, когда появится интернет.';

  @override
  String get documentPdfFailed => 'Не удалось открыть PDF.';

  @override
  String documentPdfPage(int page, int count) {
    return 'Страница $page из $count';
  }

  @override
  String get roadCheckTitle => 'Проверка на дороге';

  @override
  String roadCheckPosition(int index, int count) {
    return '$index / $count';
  }

  @override
  String get roadCheckSwipeHint =>
      'Проведите в сторону, чтобы открыть следующий документ';

  @override
  String get roadCheckPrevious => 'Предыдущий документ';

  @override
  String get roadCheckNext => 'Следующий документ';

  @override
  String documentReminderBody(int days, String date) {
    String _temp0 = intl.Intl.pluralLogic(
      days,
      locale: localeName,
      other: '$days дня',
      many: '$days дней',
      few: '$days дня',
      one: '$days день',
    );
    return 'Истекает через $_temp0 · $date';
  }

  @override
  String get syncTableDocuments => 'Документ';

  @override
  String get migrationsTitle => 'Планы кочёвки';

  @override
  String get migrationsAdd => 'Новый план';

  @override
  String get migrationsEmptyTitle => 'Плана кочёвки пока нет';

  @override
  String get migrationsEmptyMessage =>
      'Спланируйте маршрут на год: даты каждой стоянки, число ульев и пасеку назначения.';

  @override
  String get migrationsLoadError => 'Не удалось открыть планы кочёвки';

  @override
  String migrationStopCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count стоянки',
      many: '$count стоянок',
      few: '$count стоянки',
      one: '$count стоянка',
      zero: 'Нет стоянок',
    );
    return '$_temp0';
  }

  @override
  String migrationTitle(String name, String year) {
    return '$name $year';
  }

  @override
  String get migrationNotFound => 'План кочёвки не найден';

  @override
  String get migrationDocuments => 'Документы';

  @override
  String get migrationEdit => 'Изменить план';

  @override
  String get migrationAddStop => 'Добавить стоянку';

  @override
  String get migrationNoStopsTitle => 'Стоянок пока нет';

  @override
  String get migrationNoStopsMessage =>
      'Добавьте стоянки маршрута по порядку: медонос, место, даты и число ульев.';

  @override
  String migrationNextMoveIn(int days) {
    String _temp0 = intl.Intl.pluralLogic(
      days,
      locale: localeName,
      other: 'через $days дня',
      many: 'через $days дней',
      few: 'через $days дня',
      one: 'через $days день',
      zero: 'сегодня',
    );
    return 'Следующий переезд · $_temp0';
  }

  @override
  String migrationNextMoveLate(int days) {
    String _temp0 = intl.Intl.pluralLogic(
      days,
      locale: localeName,
      other: 'опоздание $days дня',
      many: 'опоздание $days дней',
      few: 'опоздание $days дня',
      one: 'опоздание $days день',
    );
    return 'Следующий переезд · $_temp0';
  }

  @override
  String migrationRoute(String from, String to) {
    return '$from → $to';
  }

  @override
  String migrationDocReady(String document) {
    return '$document готов';
  }

  @override
  String migrationDocDays(String document, int days) {
    String _temp0 = intl.Intl.pluralLogic(
      days,
      locale: localeName,
      other: '$days дня',
      many: '$days дней',
      few: '$days дня',
      one: '$days день',
      zero: 'истекает сегодня',
    );
    return '$document $_temp0';
  }

  @override
  String migrationDocBeforeMove(String document) {
    return '$document истечёт до переезда';
  }

  @override
  String migrationDocExpired(String document) {
    return '$document истёк';
  }

  @override
  String migrationDocMissing(String document) {
    return 'Нет документа: $document';
  }

  @override
  String get migrationStopPast => 'Пройдена';

  @override
  String get migrationStopCurrent => 'Сейчас здесь';

  @override
  String get migrationStopPlanned => 'Запланирована';

  @override
  String get migrationStopHere => 'Вы здесь';

  @override
  String migrationStopDates(String start, String end) {
    return '$start–$end';
  }

  @override
  String migrationYield(String year, String kg) {
    return '$year: $kg кг/улей';
  }

  @override
  String migrationYields(String values) {
    return 'Прошлый сбор · $values';
  }

  @override
  String get migrationNoYield => 'На этой пасеке раньше не было медосбора';

  @override
  String get migrationFormNewTitle => 'Новый план кочёвки';

  @override
  String get migrationFormEditTitle => 'Изменить план кочёвки';

  @override
  String get migrationFormYear => 'Год';

  @override
  String get migrationFormName => 'Название';

  @override
  String get migrationFormDefaultName => 'План кочёвки';

  @override
  String get migrationFormSave => 'Сохранить';

  @override
  String get migrationFormDelete => 'Удалить план';

  @override
  String get migrationDeleteTitle => 'Удалить план кочёвки?';

  @override
  String get migrationDeleteMessage => 'План и все его стоянки будут удалены.';

  @override
  String get migrationDeleteConfirm => 'Удалить';

  @override
  String get migrationSaved => 'План сохранён';

  @override
  String get migrationDeleted => 'План удалён';

  @override
  String get stopFormNewTitle => 'Новая стоянка';

  @override
  String get stopFormEditTitle => 'Изменить стоянку';

  @override
  String get stopFormName => 'Медонос';

  @override
  String get stopFormNameHint => 'например, Липа, Гречиха';

  @override
  String get stopFormPlace => 'Место';

  @override
  String get stopFormPlaceHint => 'например, Башкирия';

  @override
  String get stopFormStart => 'Плановое начало';

  @override
  String get stopFormEnd => 'Плановый конец';

  @override
  String get stopFormApiary => 'Пасека назначения';

  @override
  String get stopFormChooseApiary => 'Выбрать пасеку назначения';

  @override
  String get stopFormNone => 'Нет';

  @override
  String get stopFormHiveCount => 'Ульи';

  @override
  String get stopFormPosition => 'Порядок на маршруте';

  @override
  String get stopFormStatus => 'Статус';

  @override
  String get stopFormDelete => 'Удалить стоянку';

  @override
  String get stopDeleteTitle => 'Удалить стоянку?';

  @override
  String get stopDeleteMessage => 'Стоянка будет удалена из плана.';

  @override
  String get stopSaved => 'Стоянка сохранена';

  @override
  String get stopDeleted => 'Стоянка удалена';

  @override
  String get syncTableMigrations => 'План кочёвки';

  @override
  String get syncTableMigrationStops => 'Стоянка кочёвки';

  @override
  String get moveStart => 'Начать переезд';

  @override
  String moveTitle(String route) {
    return 'Переезд · $route';
  }

  @override
  String get moveNone => 'Ближайших переездов нет';

  @override
  String get moreMigratory => 'Кочёвка';

  @override
  String get syncTableTransports => 'Переезд';

  @override
  String get syncTableTransportItems => 'Перевезённый улей';

  @override
  String get moveStepCheck => 'Проверка';

  @override
  String get moveStepLoad => 'Погрузка';

  @override
  String get moveStepUnload => 'Выгрузка';

  @override
  String moveStepDone(String step) {
    return '$step, готово';
  }

  @override
  String get moveNoDestinationTitle => 'У стоянки нет пасеки';

  @override
  String get moveNoDestinationMessage =>
      'Выберите пасеку назначения для стоянки, чтобы после выгрузки обновилось местоположение ульев.';

  @override
  String get moveEditStop => 'Изменить стоянку';

  @override
  String get moveFrom => 'Откуда';

  @override
  String get moveTo => 'Куда';

  @override
  String moveSourceHives(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count активного улья',
      many: '$count активных ульев',
      few: '$count активных улья',
      one: '$count активный улей',
      zero: 'Нет активных ульев',
    );
    return '$_temp0';
  }

  @override
  String get moveChecklist => 'Чек-лист погрузки';

  @override
  String get moveCheckEntrances => 'Летки закрыты';

  @override
  String get moveCheckVentilation => 'Вентиляция открыта';

  @override
  String get moveCheckStraps => 'Ремни затянуты';

  @override
  String get moveCheckWater => 'Вода готова';

  @override
  String get moveVehicles => 'Машины';

  @override
  String moveVehicleDefault(int number) {
    return 'Грузовик $number';
  }

  @override
  String get moveAddVehicle => 'Добавить машину';

  @override
  String moveRemoveVehicle(String vehicle) {
    return 'Удалить $vehicle';
  }

  @override
  String get moveVehicleName => 'Название машины';

  @override
  String get moveVehicleExists => 'Машина с таким названием уже есть';

  @override
  String get moveStartLoading => 'Начать погрузку';

  @override
  String get moveChecklistHint => 'Отметьте все пункты, чтобы начать погрузку.';

  @override
  String moveVehicleCount(String vehicle, int count) {
    return '$vehicle · $count';
  }

  @override
  String get moveLoaded => 'Погружено';

  @override
  String get moveUnloaded => 'Выгружено';

  @override
  String moveCountTotal(int total) {
    return '/ $total';
  }

  @override
  String moveCountLabel(int count, int total) {
    return '$count из $total ульев';
  }

  @override
  String moveLastScanned(String number) {
    return 'Последний: $number';
  }

  @override
  String moveNotScanned(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count улья ещё не отсканированы',
      many: '$count ульев ещё не отсканированы',
      few: '$count улья ещё не отсканированы',
      one: '$count улей ещё не отсканирован',
    );
    return '$_temp0';
  }

  @override
  String get moveAllScanned => 'Все отсканированы';

  @override
  String get moveShowList => 'Показать список';

  @override
  String get moveMissingTitle => 'Неотсканированные ульи';

  @override
  String get moveLoadingHint =>
      'При выгрузке на месте вы отсканируете ульи снова; я предупрежу, если какого-то не хватит. Местоположение ульев обновится после выгрузки.';

  @override
  String moveUnloadingHint(String destination) {
    return 'Сканируйте каждый улей снова при выгрузке. Когда закончите, выгруженные ульи перейдут на $destination.';
  }

  @override
  String get moveEnterNumber => 'Ввести номер';

  @override
  String get moveHiveNumber => 'Номер улья';

  @override
  String moveNumberNotFound(String number) {
    return 'Улья с номером $number нет';
  }

  @override
  String get moveScanStart => 'Начать сканирование';

  @override
  String get moveScanContinue => 'Продолжить сканирование';

  @override
  String get moveToUnloading => 'К выгрузке';

  @override
  String moveToUnloadingTitle(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count улья не отсканированы',
      many: '$count ульев не отсканированы',
      few: '$count улья не отсканированы',
      one: '$count улей не отсканирован',
    );
    return '$_temp0';
  }

  @override
  String get moveToUnloadingMessage =>
      'Неотсканированные ульи не участвуют в этом переезде и остаются на месте.';

  @override
  String get moveFinish => 'Завершить переезд';

  @override
  String moveFinishTitle(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count улья не выгружены',
      many: '$count ульев не выгружены',
      few: '$count улья не выгружены',
      one: '$count улей не выгружен',
    );
    return '$_temp0';
  }

  @override
  String moveFinishMessage(String source) {
    return 'Невыгруженные ульи сохраняют местоположение: $source. Список недостающих остаётся в переезде.';
  }

  @override
  String get moveFinishConfirm => 'Завершить';

  @override
  String get moveDoneTitle => 'Переезд завершён';

  @override
  String moveDoneSummary(int loaded, int unloaded) {
    return 'Погружено $loaded · Выгружено $unloaded';
  }

  @override
  String moveDoneMoved(int count, String destination) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count улья перевезены на $destination.',
      many: '$count ульев перевезены на $destination.',
      few: '$count улья перевезены на $destination.',
      one: '$count улей перевезён на $destination.',
      zero: 'Ульи не перевезены.',
    );
    return '$_temp0';
  }

  @override
  String get moveDoneMissing => 'Невыгруженные ульи';

  @override
  String moveScanLoaded(String number, String vehicle) {
    return '$number погружен · $vehicle';
  }

  @override
  String moveScanLoadedOther(String number) {
    return '$number погружен; этот улей был не на этой пасеке';
  }

  @override
  String moveScanAlreadyLoaded(String number) {
    return '$number уже погружен';
  }

  @override
  String moveScanUnloaded(String number) {
    return '$number выгружен';
  }

  @override
  String moveScanAlreadyUnloaded(String number) {
    return '$number уже выгружен';
  }

  @override
  String moveScanNotLoaded(String number) {
    return '$number не грузили в этот переезд';
  }

  @override
  String get moveScanUnknown => 'Неизвестная этикетка';

  @override
  String get moveScanDone => 'Готово';

  @override
  String get inventoryTitle => 'Материалы и склад';

  @override
  String get inventoryAdd => 'Добавить позицию';

  @override
  String get inventoryEmptyTitle => 'Складских позиций пока нет';

  @override
  String get inventoryEmptyMessage =>
      'Добавьте материалы — сахар, вощину, банки. Позиции ниже минимума будут отмечены.';

  @override
  String get inventoryCategoryEmpty => 'В этой категории нет позиций';

  @override
  String get inventoryLoadError => 'Не удалось открыть склад.';

  @override
  String get inventoryNotFound => 'Позиция не найдена';

  @override
  String get inventoryCategoryConsumable => 'Расходники';

  @override
  String get inventoryCategoryEquipment => 'Инвентарь';

  @override
  String get inventoryCategoryComb => 'Соты';

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
  String get inventoryUnitNameKg => 'Килограмм';

  @override
  String get inventoryUnitNameLiter => 'Литр';

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
    return 'Ниже минимума · минимум $threshold';
  }

  @override
  String get inventoryMoveIn => 'Приход';

  @override
  String get inventoryMoveOut => 'Расход';

  @override
  String get inventoryMoveCount => 'Пересчёт';

  @override
  String get inventoryMoveAdjustment => 'Корректировка';

  @override
  String inventoryInStock(String quantity) {
    return 'На складе: $quantity';
  }

  @override
  String inventoryAmountLabel(String unit) {
    return 'Количество ($unit)';
  }

  @override
  String inventoryCountedLabel(String unit) {
    return 'Насчитано ($unit)';
  }

  @override
  String get inventoryAmountInvalid => 'Введите корректное количество';

  @override
  String get inventoryAmountWhole => 'Для этой единицы нужно целое число';

  @override
  String get inventorySaveIn => 'Оприходовать';

  @override
  String get inventorySaveOut => 'Списать';

  @override
  String get inventorySaveCount => 'Скорректировать остаток';

  @override
  String inventoryMovedIn(String quantity) {
    return 'Добавлено $quantity';
  }

  @override
  String inventoryMovedOut(String quantity) {
    return 'Списано $quantity';
  }

  @override
  String inventoryAdjusted(String quantity) {
    return 'Остаток теперь $quantity';
  }

  @override
  String inventoryUnchanged(String quantity) {
    return 'Остаток уже $quantity';
  }

  @override
  String get inventoryDetails => 'Подробности и история';

  @override
  String get inventoryHistory => 'История';

  @override
  String get inventoryHistoryEmpty => 'Движений пока нет';

  @override
  String inventoryThreshold(String threshold) {
    return 'Минимум: $threshold';
  }

  @override
  String get inventoryNoThreshold => 'Без минимума';

  @override
  String get inventoryQuickMove => 'Приход / расход';

  @override
  String get inventoryEdit => 'Изменить позицию';

  @override
  String get inventoryFormNewTitle => 'Новая позиция';

  @override
  String get inventoryFormEditTitle => 'Изменить позицию';

  @override
  String get inventoryFormName => 'Название';

  @override
  String get inventoryFormCategory => 'Категория';

  @override
  String get inventoryFormUnit => 'Единица';

  @override
  String get inventoryFormLocation => 'Место хранения';

  @override
  String get inventoryFormLocationHint => 'Склад, машина, офис… Необязательно.';

  @override
  String get inventoryFormThreshold => 'Минимум';

  @override
  String get inventoryFormThresholdHint =>
      'Предупредим, когда остаток опустится ниже. Необязательно.';

  @override
  String get inventoryFormThresholdInvalid => 'Введите корректный минимум';

  @override
  String get inventoryFormSave => 'Сохранить';

  @override
  String get inventoryFormDelete => 'Удалить позицию';

  @override
  String get inventoryDeleteTitle => 'Удалить эту позицию?';

  @override
  String get inventoryDeleteMessage =>
      'Позиция и её остаток исчезнут из списка.';

  @override
  String get inventoryDeleteConfirm => 'Удалить';

  @override
  String get inventorySaved => 'Позиция сохранена';

  @override
  String get inventoryDeleted => 'Позиция удалена';

  @override
  String get syncTableInventoryItems => 'Складская позиция';

  @override
  String get syncTableInventoryMoves => 'Движение по складу';

  @override
  String inventoryIncrease(String quantity) {
    return '+$quantity';
  }

  @override
  String inventoryFormThresholdUnit(String unit) {
    return 'Минимум ($unit)';
  }

  @override
  String get stockUseTitle => 'Списать со склада';

  @override
  String get stockUseNone => 'Не списывать';

  @override
  String stockUseValue(String item, String quantity) {
    return '$item · −$quantity';
  }

  @override
  String get stockUseChoose => 'С какой позиции списать?';

  @override
  String get taskFormTreatment => 'Плановая обработка';

  @override
  String get taskFormTreatmentUnknown => 'Препарата нет в списке';

  @override
  String get taskFormTreatmentNeedsApiary =>
      'Выберите пасеку для плановой обработки';

  @override
  String taskTreatmentPlanTitle(String drug) {
    return 'Обработка · $drug';
  }

  @override
  String get shoppingTitle => 'Список покупок';

  @override
  String shoppingCardTitle(int count) {
    return 'Список покупок · $count';
  }

  @override
  String get shoppingEmptyTitle => 'Покупать нечего';

  @override
  String get shoppingEmptyMessage =>
      'Здесь появятся позиции ниже минимума и то, что нужно для плановых обработок.';

  @override
  String get shoppingShare => 'Поделиться';

  @override
  String get shoppingLoadError => 'Не удалось открыть список покупок';

  @override
  String shoppingReasonThreshold(String stock, String threshold) {
    return 'На складе $stock · мин. $threshold';
  }

  @override
  String shoppingReasonPlanned(String quantity) {
    return 'Плановые обработки $quantity';
  }

  @override
  String get shoppingReasonNoItem =>
      'Плановая обработка · нет позиции на складе';

  @override
  String shoppingShareLine(String name, String quantity) {
    return '• $name: $quantity';
  }

  @override
  String get moreRearing => 'Вывод маток';

  @override
  String get rearingTitle => 'Вывод маток';

  @override
  String rearingBatchName(int number) {
    return 'Партия $number';
  }

  @override
  String rearingBatchTitle(int number) {
    return 'Вывод маток · Партия $number';
  }

  @override
  String get rearingAdd => 'Добавить партию';

  @override
  String get rearingEmptyTitle => 'Партий пока нет';

  @override
  String get rearingEmptyMessage =>
      'Укажите день прививки; график от проверки приёма до проверки засева и напоминания создадутся сами.';

  @override
  String get rearingLoadError => 'Не удалось загрузить партии';

  @override
  String get rearingNotFound => 'Партия не найдена';

  @override
  String rearingListGrafted(String date) {
    return 'прививка $date';
  }

  @override
  String get rearingEdit => 'Изменить партию';

  @override
  String get rearingGraftedLabel => 'Привито';

  @override
  String get rearingAcceptedLabel => 'Принято';

  @override
  String get rearingNucsLabel => 'Нуклеусы';

  @override
  String get rearingNotCounted => 'Не посчитано';

  @override
  String rearingAcceptedPercent(int percent) {
    return '$percent%';
  }

  @override
  String rearingMotherLine(String mother, String date) {
    return 'Мать: $mother · прививка $date';
  }

  @override
  String rearingMotherUnknownLine(String date) {
    return 'Мать неизвестна · прививка $date';
  }

  @override
  String rearingDay(int day) {
    return 'Д$day';
  }

  @override
  String get rearingToday => 'Сегодня';

  @override
  String get rearingStepGraft => 'Прививка личинок';

  @override
  String get rearingStepAcceptance => 'Проверка приёма';

  @override
  String get rearingStepCapped => 'Маточники запечатаны';

  @override
  String get rearingStepDistribution => 'Раздать маточники';

  @override
  String get rearingStepEmergence => 'Выход маток';

  @override
  String get rearingStepLayingCheck => 'Проверка засева';

  @override
  String rearingStepGraftDetail(int count) {
    return 'Личинок: $count';
  }

  @override
  String rearingStepAcceptanceDetail(int count) {
    return 'Принято маточников: $count';
  }

  @override
  String get rearingStepAcceptanceTodo => 'Посчитайте принятые маточники';

  @override
  String get rearingStepCappedDetail => 'Не беспокоить';

  @override
  String rearingStepDistributionDetail(int count) {
    return 'До выхода, в нуклеусы: $count';
  }

  @override
  String get rearingStepDistributionTodo => 'До выхода, в нуклеусы';

  @override
  String get rearingStepEmergenceDetail => 'Проверьте нуклеусы';

  @override
  String get rearingStepLayingCheckDetail => 'Отметьте успешное спаривание';

  @override
  String get rearingStepDone => 'готово';

  @override
  String get rearingStepCurrent => 'следующий';

  @override
  String get rearingStepUpcoming => 'предстоит';

  @override
  String get rearingDistribute => 'Раздать маточники по нуклеусам';

  @override
  String get rearingDistributeApiary => 'Пасека';

  @override
  String get rearingDistributeCount => 'Нуклеусы';

  @override
  String rearingDistributePlan(int reused, int created) {
    return 'Пустые нуклеусы снова: $reused · Новые: $created';
  }

  @override
  String get rearingDistributeSave => 'Раздать';

  @override
  String get rearingDistributeNoApiary => 'Сначала добавьте пасеку';

  @override
  String rearingDistributed(int count) {
    return 'Разданы по нуклеусам: $count';
  }

  @override
  String get rearingNucsSection => 'Нуклеусы для спаривания';

  @override
  String rearingNucTitle(String number) {
    return 'Нуклеус $number';
  }

  @override
  String get matingNucStatusEmpty => 'Пустой';

  @override
  String get matingNucStatusCell => 'Маточник';

  @override
  String get matingNucStatusVirgin => 'Неплодная матка';

  @override
  String get matingNucStatusLaying => 'Засевает';

  @override
  String get matingNucStatusFailed => 'Неудача';

  @override
  String get matingNucStatusGiven => 'Отдан в улей';

  @override
  String get rearingNucGive => 'Отдать в улей';

  @override
  String get rearingNucChooseHive => 'В какой улей?';

  @override
  String get rearingNucNoHives => 'Нет активных ульев';

  @override
  String get rearingFormNewTitle => 'Новая партия';

  @override
  String get rearingFormEditTitle => 'Изменить партию';

  @override
  String get rearingFormGraftedOn => 'День прививки';

  @override
  String get rearingFormGraftedCount => 'Привито личинок';

  @override
  String get rearingFormAcceptedCount => 'Принято маточников';

  @override
  String get rearingFormAcceptedClear => 'Ещё не посчитано';

  @override
  String get rearingFormScheduleHint =>
      'Приём, запечатывание, раздача, выход и проверка засева добавляются как задачи с напоминаниями.';

  @override
  String get rearingFormSave => 'Сохранить';

  @override
  String get rearingFormDelete => 'Удалить партию';

  @override
  String get rearingDeleteTitle => 'Удалить партию?';

  @override
  String get rearingDeleteMessage =>
      'Её задачи тоже удалятся. Нуклеусы и отданные матки останутся.';

  @override
  String get rearingDeleteConfirm => 'Удалить';

  @override
  String get rearingDeleted => 'Партия удалена';

  @override
  String get rearingSaved => 'Партия сохранена';

  @override
  String get taskSourceQueenRearing => 'вывод маток';

  @override
  String get syncTableQueenRearingBatches => 'Партия вывода маток';

  @override
  String get syncTableMatingNucs => 'Нуклеус для спаривания';

  @override
  String get lotsTitle => 'Медосбор и партии';

  @override
  String get lotsEmptyTitle => 'Партий пока нет';

  @override
  String get lotsEmptyMessage =>
      'Добавьте медосбор в партию после сохранения; партии появятся здесь.';

  @override
  String get lotsLoadError => 'Не удалось загрузить партии';

  @override
  String get lotsInStock => 'На складе';

  @override
  String get lotsPerHive => 'На улей';

  @override
  String lotNumber(String number) {
    return 'Партия $number';
  }

  @override
  String lotHoneyTitle(String kind) {
    return 'Мёд · $kind';
  }

  @override
  String get lotStatusOpen => 'Открыта';

  @override
  String get lotStatusClosed => 'Закрыта';

  @override
  String get lotWithdrawalBadge => 'В период ожидания';

  @override
  String lotMoistureValue(String value) {
    return 'Влажность $value%';
  }

  @override
  String get lotAnalyzed => 'Проанализирован ✓';

  @override
  String get lotAnalysisPending => 'Анализа ещё нет';

  @override
  String lotStockValue(String weight) {
    return 'Остаток $weight';
  }

  @override
  String get lotNotFound => 'Партия не найдена';

  @override
  String get lotEdit => 'Изменить партию';

  @override
  String lotWithdrawalTitle(String hives) {
    return '$hives: мёд отобран в период ожидания.';
  }

  @override
  String get lotWithdrawalMessage =>
      'В этой партии могут быть остатки препаратов; сдайте её на анализ перед продажей.';

  @override
  String get lotStock => 'Остаток';

  @override
  String get lotHarvested => 'Отобрано';

  @override
  String get lotSold => 'Продано';

  @override
  String get lotInStock => 'На складе';

  @override
  String get lotSell => 'Записать продажу';

  @override
  String get lotAnalyses => 'Анализы';

  @override
  String get lotAnalysesEmpty => 'Анализов пока нет';

  @override
  String get lotAddAnalysis => 'Добавить анализ';

  @override
  String get lotHarvests => 'Медосборы';

  @override
  String get lotHarvestsEmpty => 'В этой партии нет медосборов';

  @override
  String get lotTreatments => 'Последняя обработка ульев';

  @override
  String get lotTreatmentsEmpty =>
      'Для ульев этой партии обработок не записано';

  @override
  String lotTreatmentTitle(String hive, String product) {
    return 'Улей $hive · $product';
  }

  @override
  String lotTreatmentDetail(String date, String end) {
    return '$date · ожидание до $end';
  }

  @override
  String get lotPublicPage => 'Публичная страница';

  @override
  String get lotPublish => 'Опубликовать';

  @override
  String get lotPublishHint =>
      'Любой, кто отсканирует QR, увидит страницу партии. Телефон, адрес и местоположение никогда не показываются.';

  @override
  String get lotPublishOwnerOnly =>
      'Публиковать может только владелец хозяйства.';

  @override
  String get lotPublished => 'Опубликована';

  @override
  String get lotNotPublished => 'Не опубликована';

  @override
  String get lotPublicFields => 'Показывается на странице';

  @override
  String get lotPublicProducer => 'Название хозяйства и число ульев';

  @override
  String get lotPublicOrigin => 'Происхождение и месяц сбора';

  @override
  String get lotPublicLab => 'Показатели анализа';

  @override
  String get lotPublicReport => 'Протокол анализа';

  @override
  String get lotJarLabels => 'Этикетки на банки (QR)';

  @override
  String get lotJarLabelsHint =>
      '24 этикетки на листе A4 (70 × 37 мм); печатайте в масштабе 100%.';

  @override
  String lotJarLabelsDocumentName(String number) {
    return 'Этикетки на банки - $number';
  }

  @override
  String get lotSales => 'Продажи';

  @override
  String get lotSalesEmpty => 'Продаж пока нет';

  @override
  String lotSaleValue(String weight) {
    return '−$weight';
  }

  @override
  String lotSaleAmount(String unit) {
    return 'Продано мёда ($unit)';
  }

  @override
  String lotSaleTooMuch(String weight) {
    return 'На складе только $weight';
  }

  @override
  String get lotSaleSave => 'Списать со склада';

  @override
  String lotSaleSaved(String weight) {
    return 'Продажа $weight записана';
  }

  @override
  String get lotOrigin => 'Происхождение';

  @override
  String get lotOriginHint => 'например, Горная тайга';

  @override
  String get lotMoisture => 'Влажность %';

  @override
  String get lotMoistureHelper => 'По рефрактометру; необязательно';

  @override
  String get lotMoistureInvalid =>
      'Введите значение от 10 до 30, например 17,2';

  @override
  String lotEditTitle(String lot) {
    return 'Изменить: $lot';
  }

  @override
  String get lotStatus => 'Статус';

  @override
  String get lotStatusHelper => 'В закрытую партию нельзя добавлять медосборы';

  @override
  String get lotSave => 'Сохранить';

  @override
  String get lotDelete => 'Удалить партию';

  @override
  String lotDeleteTitle(String lot) {
    return 'Удалить $lot?';
  }

  @override
  String get lotDeleteMessage =>
      'Анализы и продажи тоже удалятся; медосборы останутся.';

  @override
  String get lotDeleted => 'Партия удалена';

  @override
  String labTitle(String lot) {
    return 'Анализ · $lot';
  }

  @override
  String get labDate => 'Дата анализа';

  @override
  String get labHmf => 'ГМФ (мг/кг)';

  @override
  String get labDiastase => 'Диастазное число';

  @override
  String get labProline => 'Пролин (мг/кг)';

  @override
  String labHmfValue(String value) {
    return 'ГМФ $value';
  }

  @override
  String labDiastaseValue(String value) {
    return 'Диастаза $value';
  }

  @override
  String labProlineValue(String value) {
    return 'Пролин $value';
  }

  @override
  String labValueInvalid(String min, String max) {
    return 'Введите значение от $min до $max';
  }

  @override
  String get labResidue => 'Остатки';

  @override
  String get labResidueNone => 'Остатков нет';

  @override
  String get labResidueDetected => 'Остатки обнаружены';

  @override
  String get labReport => 'Протокол';

  @override
  String get labReportNone => 'Без протокола';

  @override
  String get labReportEmpty => 'В папке документов нет протоколов анализа';

  @override
  String get labReportAdd => 'Добавить протокол в папку документов';

  @override
  String get labSave => 'Сохранить анализ';

  @override
  String get labSaved => 'Анализ сохранён';

  @override
  String get harvestLotTitle => 'Добавить в партию';

  @override
  String harvestLotSaved(String weight, String kind) {
    return 'Медосбор сохранён: $weight $kind';
  }

  @override
  String get harvestLotIntro =>
      'Когда мёд попадает в партию, к ней привязываются даты последних обработок ульев.';

  @override
  String get harvestLotNew => 'Новая партия';

  @override
  String harvestLotNewHint(String kind) {
    return '$kind · номер присвоится автоматически';
  }

  @override
  String get harvestLotCreate => 'Создать партию';

  @override
  String get harvestLotAdd => 'Добавить в партию';

  @override
  String get harvestLotSkip => 'Пропустить пока';

  @override
  String harvestLotCreated(String lot) {
    return '$lot создана';
  }

  @override
  String harvestLotAdded(String lot) {
    return 'Медосбор добавлен в $lot';
  }

  @override
  String get harvestLotGone => 'Медосбор отменён';

  @override
  String get harvestLotBack => 'Назад к пасеке';

  @override
  String get syncTableLots => 'Партия';

  @override
  String get syncTableLotHarvests => 'Медосбор партии';

  @override
  String get syncTableLotTreatments => 'Обработка партии';

  @override
  String get syncTableLabResults => 'Результат анализа';

  @override
  String get syncTableLotSales => 'Продажа партии';

  @override
  String get harvestLotGoneMessage =>
      'Медосбор не добавлен в партию. Его можно записать снова на пасеке.';

  @override
  String get financeTitle => 'Финансы';

  @override
  String financeYearTitle(String year) {
    return 'Финансы · $year';
  }

  @override
  String get financeSeasonNet => 'Итог сезона';

  @override
  String get financeIncome => 'Доходы';

  @override
  String get financeExpense => 'Расходы';

  @override
  String get financeCostPerHive => 'Затраты/улей';

  @override
  String get financeRecent => 'Последние записи';

  @override
  String get financeEmptyTitle => 'Записей пока нет';

  @override
  String get financeEmptyMessage =>
      'Записывайте доходы и расходы кнопками ниже; итог сезона считается здесь.';

  @override
  String get financeLoadError => 'Не удалось загрузить записи';

  @override
  String get financeAddIncome => '+ Доход';

  @override
  String get financeAddExpense => '− Расход';

  @override
  String financePlus(String amount) {
    return '+$amount';
  }

  @override
  String financeMinus(String amount) {
    return '−$amount';
  }

  @override
  String get financeReceiptAttached => 'чек приложен';

  @override
  String financeTransportRoute(String from, String to) {
    return '$from → $to';
  }

  @override
  String get financeFormIncomeTitle => 'Добавить доход';

  @override
  String get financeFormExpenseTitle => 'Добавить расход';

  @override
  String financeFormAmount(String currency) {
    return 'Сумма ($currency)';
  }

  @override
  String get financeFormAmountInvalid =>
      'Введите сумму больше 0, например 17500 или 17,50';

  @override
  String get financeFormCategory => 'Категория';

  @override
  String get financeFormDate => 'Дата';

  @override
  String get financeFormDescription => 'Описание';

  @override
  String get financeFormDescriptionHint => 'например, Сахар 500 кг';

  @override
  String get financeFormReceipt => 'Чек / счёт';

  @override
  String get financeFormNoReceipt => 'Без чека';

  @override
  String get financeFormReceiptAdded => 'Фото чека добавлено';

  @override
  String get financeFormTakePhoto => 'Сфотографировать';

  @override
  String get financeFormPickImage => 'Из галереи';

  @override
  String get financeFormRemoveReceipt => 'Удалить чек';

  @override
  String get financeFormPhotoDenied =>
      'Доступ запрещён. Чтобы добавить чек, разрешите этому приложению доступ к камере или фото в настройках.';

  @override
  String get financeFormPhotoFailed =>
      'Не удалось получить фото, попробуйте снова.';

  @override
  String get financeFormLinks => 'Связанная запись';

  @override
  String get financeFormApiary => 'Пасека';

  @override
  String get financeFormLot => 'Партия';

  @override
  String get financeFormTransport => 'Переезд';

  @override
  String get financeFormNone => 'Нет';

  @override
  String get financeFormChooseApiary => 'Выбрать пасеку';

  @override
  String get financeFormChooseLot => 'Выбрать партию';

  @override
  String get financeFormChooseTransport => 'Выбрать переезд';

  @override
  String get financeFormNoLots => 'Партий пока нет';

  @override
  String get financeFormNoTransports => 'Переездов пока нет';

  @override
  String financeFormSaleAmount(String unit) {
    return 'Продано мёда ($unit)';
  }

  @override
  String get financeFormSaleHelper =>
      'Спишется с остатка партии; оставьте пустым, чтобы не менять остаток';

  @override
  String get financeFormSave => 'Сохранить';

  @override
  String get financeIncomeSaved => 'Доход сохранён';

  @override
  String get financeExpenseSaved => 'Расход сохранён';

  @override
  String get financeNotFound => 'Запись не найдена';

  @override
  String get financeReceiptPending => 'Чек ещё не пришёл на этот телефон';

  @override
  String get financeDelete => 'Удалить запись';

  @override
  String get financeDeleteTitle => 'Удалить эту запись?';

  @override
  String get financeDeleteMessage =>
      'Если она связана с продажей партии, продажа тоже удалится, а остаток вернётся.';

  @override
  String get financeDeleteConfirm => 'Удалить';

  @override
  String get financeDeleted => 'Запись удалена';

  @override
  String get financeCategoryFeeding => 'Подкормка';

  @override
  String get financeCategoryTreatment => 'Препараты';

  @override
  String get financeCategoryEquipment => 'Инвентарь';

  @override
  String get financeCategoryFuelTransport => 'Топливо / транспорт';

  @override
  String get financeCategoryLandRent => 'Аренда земли';

  @override
  String get financeCategoryLabor => 'Оплата труда';

  @override
  String get financeCategoryLabAnalysis => 'Лабораторный анализ';

  @override
  String get financeCategoryHoney => 'Мёд';

  @override
  String get financeCategoryPollen => 'Пыльца';

  @override
  String get financeCategoryPropolis => 'Прополис';

  @override
  String get financeCategoryWax => 'Воск';

  @override
  String get financeCategoryNucs => 'Нуклеусы';

  @override
  String get financeCategoryQueens => 'Матки';

  @override
  String get financeCategoryOther => 'Прочее';

  @override
  String get syncTableTransactions => 'Доход/расход';

  @override
  String get customersTitle => 'Книга покупателей';

  @override
  String get customersAdd => 'Добавить покупателя';

  @override
  String get customersEmptyTitle => 'Покупателей пока нет';

  @override
  String get customersEmptyMessage =>
      'Добавляйте покупателей, чтобы следить за их заказами и долгами.';

  @override
  String customerReceivableValue(String amount) {
    return 'Долг $amount';
  }

  @override
  String get customerNoReceivable => 'Долга нет';

  @override
  String get customerNotFound => 'Покупатель не найден';

  @override
  String get customerEdit => 'Изменить покупателя';

  @override
  String get customerAddSale => 'Добавить продажу';

  @override
  String get customerOrders => 'Заказы';

  @override
  String get customerNoOrders => 'Продаж этому покупателю пока нет.';

  @override
  String get customerPaid => 'Оплачено';

  @override
  String customerRemaining(String amount) {
    return 'Осталось $amount';
  }

  @override
  String get customerPaidAmount => 'Оплачено на сейчас';

  @override
  String get customerMarkPaid => 'Отметить оплаченным';

  @override
  String get customerMarkedPaid => 'Отмечено как оплаченное';

  @override
  String get customerAddPayment => 'Записать оплату';

  @override
  String get customerSendWhatsApp => 'Отправить в WhatsApp';

  @override
  String get customerWhatsAppNoPhone =>
      'Нет телефона; выберите контакт в WhatsApp';

  @override
  String get customerWhatsAppFailed => 'Не удалось открыть WhatsApp';

  @override
  String get customerOpenTransaction => 'Открыть запись';

  @override
  String customerWhatsAppGreeting(String name) {
    return 'Здравствуйте, $name!';
  }

  @override
  String get customerWhatsAppIntro => 'Ваш заказ:';

  @override
  String customerWhatsAppAmount(String amount) {
    return 'Итого: $amount';
  }

  @override
  String customerWhatsAppPaid(String amount) {
    return 'Оплачено: $amount';
  }

  @override
  String customerWhatsAppRemaining(String amount) {
    return 'Осталось: $amount';
  }

  @override
  String get customerWhatsAppPaidInFull => 'Оплачено полностью, спасибо.';

  @override
  String customerWhatsAppAddress(String address) {
    return 'Адрес доставки: $address';
  }

  @override
  String get customerFormNewTitle => 'Новый покупатель';

  @override
  String get customerFormEditTitle => 'Изменить покупателя';

  @override
  String get customerFormName => 'Имя';

  @override
  String get customerFormPhone => 'Телефон';

  @override
  String get customerFormPhoneHelper =>
      'Для WhatsApp, например +7 912 345-67-89';

  @override
  String get customerFormAddress => 'Адрес доставки';

  @override
  String get customerFormNotes => 'Заметка';

  @override
  String get customerFormSave => 'Сохранить';

  @override
  String get customerSaved => 'Покупатель сохранён';

  @override
  String get customerDelete => 'Удалить покупателя';

  @override
  String get customerDeleteTitle => 'Удалить покупателя?';

  @override
  String get customerDeleteMessage => 'Его продажи останутся в ваших доходах.';

  @override
  String get customerDeleteConfirm => 'Удалить';

  @override
  String get customerDeleted => 'Покупатель удалён';

  @override
  String get customerPaymentSave => 'Сохранить оплату';

  @override
  String get customerPaymentSaved => 'Оплата сохранена';

  @override
  String customerPaymentTooMuch(String amount) {
    return 'Осталось только $amount.';
  }

  @override
  String get financeFormCustomer => 'Покупатель';

  @override
  String get financeFormChooseCustomer => 'Выбрать покупателя';

  @override
  String get financeFormNoCustomers => 'Покупателей пока нет';

  @override
  String get financeFormPaidNow => 'Оплачено сейчас';

  @override
  String get financeFormPaidNowHelper =>
      'Оставьте пустым, если вся сумма в долг.';

  @override
  String get financeFormPaidTooMuch => 'Не может быть больше суммы.';

  @override
  String get financeProfitTitle => 'Прибыль по пасекам';

  @override
  String get financeProfitUnknownApiary => 'Удалённая пасека';

  @override
  String financeReceivables(String amount, int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count покупателя',
      many: '$count покупателей',
      few: '$count покупателя',
      one: '$count покупатель',
    );
    return 'Долги $amount · $_temp0';
  }

  @override
  String get syncTableCustomers => 'Покупатель';

  @override
  String get syncTableCustomerPayments => 'Оплата';

  @override
  String get customerUnpaid => 'Не оплачено';

  @override
  String customerPartiallyPaid(String paid, String remaining) {
    return 'Оплачено $paid, осталось $remaining';
  }

  @override
  String get taskAksUpdateTitle => 'Не забудьте обновить AKS';

  @override
  String get taskSourceAks => 'AKS';

  @override
  String get syncTableRefSupportPeriods => 'Период субсидий';

  @override
  String get subsidiesTitle => 'Субсидии';

  @override
  String get subsidiesCheckTitle => 'Перед подачей заявки';

  @override
  String get subsidiesActiveHives => 'Активных ульев в приложении';

  @override
  String get subsidiesDeclaredHives => 'Заявлено в AKS';

  @override
  String get subsidiesNotDeclared => 'Не указано';

  @override
  String get subsidiesCheckNotDeclared =>
      'Введите число ульев, заявленное в AKS; перед подачей его сверят с приложением.';

  @override
  String subsidiesCheckDiffers(String active, String declared) {
    return 'В приложении $active активных ульев, а в AKS заявлено $declared. Обновите запись в AKS перед подачей заявки.';
  }

  @override
  String get subsidiesCheckMatches =>
      'Числа совпадают: приложение и AKS сходятся.';

  @override
  String get subsidiesEditDeclared => 'Ввести заявленное число';

  @override
  String get subsidiesDeclaredOwnerOnly =>
      'Вводить заявленное число может только владелец.';

  @override
  String get subsidiesPeriodsTitle => 'Периоды подачи заявок';

  @override
  String get subsidiesEmptyTitle => 'Периодов субсидий пока нет';

  @override
  String get subsidiesEmptyMessage =>
      'Периоды подачи появятся здесь, когда их объявят; когда период откроется, придёт уведомление.';

  @override
  String get subsidiesPhaseOpen => 'Открыт';

  @override
  String get subsidiesPhaseUpcoming => 'Скоро';

  @override
  String get subsidiesPhaseClosed => 'Закрыт';

  @override
  String subsidiesPeriodDates(String start, String end) {
    return '$start – $end';
  }

  @override
  String get subsidiesOpenSource => 'Открыть официальное объявление';

  @override
  String get subsidiesOpenSourceFailed => 'Не удалось открыть ссылку';

  @override
  String get aksCountTitle => 'Число ульев в AKS';

  @override
  String get aksCountLabel => 'Число ульев, заявленное в AKS';

  @override
  String get aksCountHelper => 'Оставьте пустым, чтобы пропустить сверку.';

  @override
  String get aksCountInvalid => 'Введите число от 0 до 100 000';

  @override
  String get aksCountSave => 'Сохранить';

  @override
  String get aksCountSaved => 'Число ульев в AKS сохранено';

  @override
  String get aksCountNoOrganization =>
      'Данные хозяйства ещё не синхронизированы с этим телефоном; дождитесь синхронизации.';

  @override
  String get knowledgeTitle => 'База знаний';

  @override
  String get knowledgeSearchHint => 'Зимние запасы, варроа…';

  @override
  String knowledgeMonthLabel(String month, String place) {
    return '$month · $place';
  }

  @override
  String get knowledgePlaceTurkey => 'Турция';

  @override
  String get knowledgePlaceNorthern => 'Северное полушарие';

  @override
  String get knowledgePlaceSouthern => 'Южное полушарие';

  @override
  String get knowledgeMonthTitle => 'Что сделать в этом месяце';

  @override
  String get knowledgeDiagnosisTitle => 'Помощник диагностики';

  @override
  String get knowledgeDiagnosisSubtitle =>
      'Выберите признак, увидите возможные причины';

  @override
  String get knowledgeAtlasTitle => 'Атлас болезней и вредителей';

  @override
  String knowledgeTopicCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count темы',
      many: '$count тем',
      few: '$count темы',
      one: '$count тема',
    );
    return '$_temp0';
  }

  @override
  String get knowledgeGuidesTitle => 'Технические руководства';

  @override
  String get knowledgeGuidesSubtitle =>
      'Отводки, подсадка маток, объединение, зимовка';

  @override
  String get knowledgeCalculatorsTitle => 'Калькуляторы';

  @override
  String get knowledgeCalculatorsSubtitle =>
      'Сироп, доза препарата, календарь маток, медосбор';

  @override
  String get knowledgeRegulationsTitle => 'Обзоры законодательства';

  @override
  String get knowledgeRegulationsSubtitle =>
      'Регламент, кочёвка, стандарт на мёд';

  @override
  String get knowledgeTrBadge => 'TR';

  @override
  String get knowledgeFirstYearTitle => 'Мой первый год';

  @override
  String get knowledgeFirstYearSubtitle => 'Шаг за шагом для начинающих';

  @override
  String get knowledgeCalendarTitle => 'Календарь сезона';

  @override
  String get knowledgeOffline => 'Всё открывается без интернета';

  @override
  String get knowledgeNoResultsTitle => 'Ничего не найдено';

  @override
  String get knowledgeNoResultsMessage => 'Попробуйте другое слово.';

  @override
  String get knowledgeCategoryEmptyTitle => 'Статей пока нет';

  @override
  String get knowledgeCategoryEmptyMessage =>
      'Материалы для этого раздела придут с обновлением.';

  @override
  String get knowledgeArticleNotFound => 'Статья не найдена';

  @override
  String get knowledgeLoadError => 'Не удалось открыть базу знаний';

  @override
  String get knowledgeLinkFailed => 'Не удалось открыть ссылку';

  @override
  String get diagnosisSymptoms => 'Что вы видите';

  @override
  String get diagnosisSymptomsHelper => 'Можно выбрать несколько.';

  @override
  String get diagnosisResults => 'Возможные болезни';

  @override
  String get diagnosisPickHint =>
      'Выберите признак, чтобы увидеть здесь возможные болезни.';

  @override
  String get diagnosisNoMatch =>
      'Ни одна болезнь не подходит под выбранные признаки.';

  @override
  String diagnosisMatched(int matched, int total) {
    return 'Совпадающих признаков: $matched/$total';
  }

  @override
  String get diagnosisNotifiable => 'Подлежит извещению';

  @override
  String get diagnosisDisclaimer =>
      'Это первичная оценка; окончательный диагноз ставит ветеринар или лаборатория.';

  @override
  String get diagnosisLoadError => 'Не удалось открыть таблицу диагностики';

  @override
  String get diagnosisNotFound => 'Болезнь не найдена';

  @override
  String get diagnosisNotifiableTitle => 'Болезнь, подлежащая извещению.';

  @override
  String get diagnosisNotifiableMessage =>
      'Сообщите о подозрении в ветслужбу; не передавайте инвентарь, рамки и мёд этого улья другим ульям.';

  @override
  String get diagnosisAdvice => 'Что делать';

  @override
  String get diagnosisAuthority => 'Куда обращаться';

  @override
  String diagnosisCall(String phone) {
    return 'Позвонить $phone';
  }

  @override
  String get diagnosisCallFailed => 'Не удалось начать звонок';

  @override
  String get diagnosisQuarantine => 'Поместить улей в карантин';

  @override
  String get quarantinePickTitle => 'Улей для карантина';

  @override
  String get quarantineSearchHint => 'Номер улья';

  @override
  String get quarantineNoHivesTitle => 'Нет ульев';

  @override
  String get quarantineNoHivesMessage => 'Нет активных ульев для карантина.';

  @override
  String quarantineDone(String number) {
    return 'Улей $number в карантине';
  }

  @override
  String get hiveQuarantined => 'На карантине';

  @override
  String hiveQuarantineDisease(String disease) {
    return 'Подозрение: $disease';
  }

  @override
  String hiveQuarantineSince(String date) {
    return 'С $date';
  }

  @override
  String get hiveQuarantineWarning =>
      'Не передавайте его инвентарь, рамки и мёд другим ульям.';

  @override
  String get hiveQuarantineEnd => 'Снять карантин';

  @override
  String hiveQuarantineEnded(String number) {
    return 'Карантин с улья $number снят';
  }

  @override
  String get calculatorSyrup => 'Сироп';

  @override
  String get calculatorSyrupSubtitle => 'Сколько нужно сахара и воды';

  @override
  String get calculatorDose => 'Доза препарата';

  @override
  String get calculatorDoseSubtitle => 'Всего на ваше число ульев';

  @override
  String get calculatorQueen => 'Календарь маток';

  @override
  String get calculatorQueenSubtitle => 'Дни этапов от прививки';

  @override
  String get calculatorYield => 'Медосбор';

  @override
  String get calculatorYieldSubtitle => 'Мёд на улей';

  @override
  String get calculatorOffline =>
      'Расчёты работают без интернета и ничего не сохраняют.';

  @override
  String get calculatorNotFound => 'Калькулятор не найден';

  @override
  String get calculatorHives => 'Число ульев';

  @override
  String get calculatorSyrupKind => 'Вид сиропа';

  @override
  String get calculatorFillHint => 'Введите число ульев и количество.';

  @override
  String get calculatorDosePerHive => 'Доза на улей';

  @override
  String get calculatorDoseUnit => 'Единица';

  @override
  String get calculatorTotal => 'Всего';

  @override
  String calculatorDoseTotal(String unit, String total) {
    String _temp0 = intl.Intl.selectLogic(unit, {
      'strip': '$total полос.',
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
      other: '$count улья × $amount',
      many: '$count ульев × $amount',
      few: '$count улья × $amount',
      one: '$count улей × $amount',
    );
    return '$_temp0';
  }

  @override
  String calculatorYieldTotal(String unit) {
    return 'Всего мёда ($unit)';
  }

  @override
  String get calculatorYieldPerHive => 'На улей';

  @override
  String calculatorYieldValue(String amount, String unit) {
    return '$amount $unit';
  }

  @override
  String get calculatorQueenSteps => 'Этапы';

  @override
  String get hiveLossWintering => 'Зимовка';

  @override
  String get hiveLossQueenless => 'Безматочность';

  @override
  String get hiveLossVarroa => 'Варроа';

  @override
  String get hiveLossDisease => 'Болезнь';

  @override
  String get hiveLossStarvation => 'Голод';

  @override
  String get hiveLossRobbing => 'Воровство';

  @override
  String get hiveLossPredator => 'Медведь / животное';

  @override
  String get hiveLossPoisoning => 'Отравление';

  @override
  String get hiveLossOther => 'Другое';

  @override
  String get hiveLossUnspecified => 'Не указано';

  @override
  String hiveLossReasonTitle(String number) {
    return 'Почему погиб улей $number?';
  }

  @override
  String get hiveLossSkip => 'Пропустить без причины';

  @override
  String get hiveFormLossReason => 'Причина потери';

  @override
  String get hiveFormLossReasonHelper =>
      'Используется в отчёте за сезон; можно не заполнять.';

  @override
  String get seasonReportTile => 'Отчёт за сезон';

  @override
  String seasonTitle(String year) {
    return 'Сезон $year';
  }

  @override
  String get seasonPdf => 'PDF';

  @override
  String get seasonExportCsv => 'Экспорт в Excel (CSV)';

  @override
  String get seasonExportError => 'Не удалось создать файл. Попробуйте снова.';

  @override
  String get seasonLoadError => 'Не удалось загрузить отчёт за сезон.';

  @override
  String get seasonHives => 'Ульи';

  @override
  String seasonHiveChange(int start, int end) {
    return '$start → $end';
  }

  @override
  String seasonNetGain(int count) {
    return '+$count чистыми';
  }

  @override
  String seasonNetLoss(int count) {
    return '−$count чистыми';
  }

  @override
  String get seasonNetSame => 'Без изменений';

  @override
  String get seasonWinterLoss => 'Зимние потери';

  @override
  String get seasonWinterNotStarted => 'Зима ещё не началась';

  @override
  String seasonPreviousWinter(String year) {
    return 'Зимние потери $year';
  }

  @override
  String seasonPreviousWinterRate(String year, String rate) {
    return '$year: $rate';
  }

  @override
  String get seasonHoney => 'Всего мёда';

  @override
  String get seasonNewQueens => 'Новые матки';

  @override
  String seasonOwnReared(int count) {
    return 'свой вывод $count';
  }

  @override
  String get seasonLossesTitle => 'Потери и причины';

  @override
  String get seasonNoLosses => 'В этом сезоне ульи не терялись.';

  @override
  String seasonHiveCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count улья',
      many: '$count ульев',
      few: '$count улья',
      one: '$count улей',
    );
    return '$_temp0';
  }

  @override
  String get seasonByTreatment => 'Зимние потери · по способу обработки';

  @override
  String get seasonByApiary => 'Зимние потери · по пасекам';

  @override
  String get seasonByQueenLine => 'Зимние потери · по линиям маток';

  @override
  String get seasonTabTreatment => 'Обработка';

  @override
  String get seasonTabApiary => 'Пасека';

  @override
  String get seasonTabQueenLine => 'Линия матки';

  @override
  String get seasonNoWinterData =>
      'В ваших записях пока нет ульев, ушедших в зиму.';

  @override
  String get seasonFewData => 'мало данных';

  @override
  String get seasonMisleadingNote =>
      'По вашим записям; при малом числе ульев может вводить в заблуждение.';

  @override
  String get seasonUntreated => 'Без обработки';

  @override
  String get seasonMethodSeparator => ' +';

  @override
  String get seasonQueenLineUnknown => 'Неизвестная линия';

  @override
  String get seasonFinanceTitle => 'Затраты и прибыль';

  @override
  String get seasonProfit => 'Прибыль';

  @override
  String get seasonPdfFigure => 'Показатель';

  @override
  String get seasonPdfValue => 'Значение';

  @override
  String seasonPdfHiveChange(int start, int end, String net) {
    return '$start → $end ($net)';
  }

  @override
  String seasonPdfNewQueens(int count, int own) {
    return '$count (свой вывод $own)';
  }

  @override
  String seasonPdfWinterLoss(String rate, int lost, int hives) {
    return '$rate ($lost из $hives ульев)';
  }

  @override
  String get seasonPdfReason => 'Причина';

  @override
  String get seasonPdfHives => 'Ульи';

  @override
  String get seasonPdfLost => 'Потеряно';

  @override
  String get seasonPdfRate => 'Потери';

  @override
  String get seasonPdfGroup => 'Группа';

  @override
  String get seasonPdfTotal => 'Итого';

  @override
  String get seasonCsvHive => 'Улей';

  @override
  String get seasonCsvApiary => 'Пасека';

  @override
  String get seasonCsvStartStatus => 'Статус в начале сезона';

  @override
  String get seasonCsvEndStatus => 'Статус в конце сезона';

  @override
  String get seasonCsvLossDate => 'Дата потери';

  @override
  String get seasonCsvLossReason => 'Причина потери';

  @override
  String get seasonCsvInWinter => 'Ушёл в зиму';

  @override
  String get seasonCsvLostInWinter => 'Погиб зимой';

  @override
  String get seasonCsvWinterApiary => 'Зимняя пасека';

  @override
  String get seasonCsvTreatment => 'Обработка перед зимой';

  @override
  String get seasonCsvQueenLine => 'Линия матки';

  @override
  String get seasonCsvAddedInSeason => 'Добавлен в этом сезоне';

  @override
  String get seasonCsvYes => 'Да';

  @override
  String get seasonCsvNo => 'Нет';

  @override
  String get offlineMapsTitle => 'Офлайн-карты';

  @override
  String get offlineMapsIntro =>
      'Скачайте окрестности пасек; карта откроется даже без связи.';

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
    return 'Скачано · $size';
  }

  @override
  String offlineMapsDownloadingWifi(String received, String total) {
    return 'Скачивание по Wi‑Fi · $received / $total';
  }

  @override
  String offlineMapsDownloading(String received, String total) {
    return 'Скачивание · $received / $total';
  }

  @override
  String offlineMapsDownload(String name) {
    return 'Скачать $name';
  }

  @override
  String get offlineMapsCancel => 'Остановить скачивание';

  @override
  String offlineMapsDelete(String name) {
    return 'Удалить $name';
  }

  @override
  String offlineMapsDeleteTitle(String name) {
    return 'Удалить $name?';
  }

  @override
  String get offlineMapsDeleteMessage =>
      'Без интернета карта вокруг этой пасеки не откроется. Её можно снова скачать в любое время.';

  @override
  String get offlineMapsDeleteConfirm => 'Удалить';

  @override
  String get offlineMapsWifiOnly => 'Скачивать только по Wi‑Fi';

  @override
  String get offlineMapsWifiOnlyHint =>
      'Несколько МБ на пасеку; мобильный трафик не тратится.';

  @override
  String offlineMapsStop(String name) {
    return 'Стоянка $name';
  }

  @override
  String offlineMapsDone(String name) {
    return 'Окрестности $name скачаны';
  }

  @override
  String offlineMapsFailed(String name) {
    return 'Не удалось скачать окрестности $name. Проверьте подключение и попробуйте снова.';
  }

  @override
  String get offlineMapsNeedsWifi =>
      'Подключитесь к Wi‑Fi или выключите «Скачивать только по Wi‑Fi».';

  @override
  String get offlineMapsAttribution =>
      'Картографические данные © OpenStreetMap contributors · OpenFreeMap';

  @override
  String get settingsOfflineMaps => 'Офлайн-карты';

  @override
  String settingsOfflineMapsValue(int count, String size) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count пасеки · $size',
      many: '$count пасек · $size',
      few: '$count пасеки · $size',
      one: '$count пасека · $size',
      zero: 'Нет',
    );
    return '$_temp0';
  }

  @override
  String get offlineMapsCoverage =>
      'Для каждой пасеки — 6 км вокруг подробно и 40 км обзорно.';

  @override
  String offlineMapsDownloadedOn(String date) {
    return 'скачано: $date';
  }

  @override
  String get offlineMapsToDownload => 'Пасеки для скачивания';

  @override
  String get offlineMapsMoved => 'Пасека перенесена, скачайте снова';

  @override
  String get offlineMapsNoApiaries =>
      'Нет пасек с местоположением. Добавьте пасеке местоположение, и она появится здесь.';

  @override
  String get offlineMapsAllDownloaded =>
      'Все пасеки с местоположением скачаны.';

  @override
  String get syncReminderTitle => 'Ваши записи ещё не сохранены на сервере';

  @override
  String syncReminderBody(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other:
          '$count записи уже 3 дня не доходят до сервера. Откройте приложение, когда будет интернет.',
      many:
          '$count записей уже 3 дня не доходят до сервера. Откройте приложение, когда будет интернет.',
      few:
          '$count записи уже 3 дня не доходят до сервера. Откройте приложение, когда будет интернет.',
      one:
          '$count запись уже 3 дня не доходит до сервера. Откройте приложение, когда будет интернет.',
    );
    return '$_temp0';
  }

  @override
  String get syncOverdueTitle => 'Больше 3 дней без резервной копии';

  @override
  String syncOverdueMessage(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other:
          '$count записи есть только на этом телефоне. Если телефон потеряется, они пропадут. Подключитесь к интернету и синхронизируйте.',
      many:
          '$count записей есть только на этом телефоне. Если телефон потеряется, они пропадут. Подключитесь к интернету и синхронизируйте.',
      few:
          '$count записи есть только на этом телефоне. Если телефон потеряется, они пропадут. Подключитесь к интернету и синхронизируйте.',
      one:
          '$count запись есть только на этом телефоне. Если телефон потеряется, она пропадёт. Подключитесь к интернету и синхронизируйте.',
    );
    return '$_temp0';
  }

  @override
  String syncDaysAgo(int days) {
    String _temp0 = intl.Intl.pluralLogic(
      days,
      locale: localeName,
      other: '$days дня назад',
      many: '$days дней назад',
      few: '$days дня назад',
      one: '$days день назад',
      zero: 'сегодня',
    );
    return '$_temp0';
  }

  @override
  String syncLastSyncedAgo(String ago, String when) {
    return 'Последняя синхронизация $ago · $when';
  }

  @override
  String syncPendingTitle(int count) {
    return 'Ждут отправки · $count';
  }

  @override
  String settingsSignOutPendingMessage(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other:
          '$count записи ещё не отправлены на сервер и есть только на этом телефоне. Если вы выйдете, они не отправятся. Сначала подключитесь к интернету и синхронизируйте.',
      many:
          '$count записей ещё не отправлены на сервер и есть только на этом телефоне. Если вы выйдете, они не отправятся. Сначала подключитесь к интернету и синхронизируйте.',
      few:
          '$count записи ещё не отправлены на сервер и есть только на этом телефоне. Если вы выйдете, они не отправятся. Сначала подключитесь к интернету и синхронизируйте.',
      one:
          '$count запись ещё не отправлена на сервер и есть только на этом телефоне. Если вы выйдете, она не отправится. Сначала подключитесь к интернету и синхронизируйте.',
    );
    return '$_temp0';
  }

  @override
  String get settingsSignOutAnyway => 'Всё равно выйти';

  @override
  String get settingsExport => 'Экспорт данных';

  @override
  String get settingsExportValue => 'Excel';

  @override
  String get settingsExportHint =>
      'Все ваши записи в одном файле Excel; поделитесь им или сохраните где угодно.';

  @override
  String get exportPreparing => 'Готовим…';

  @override
  String get exportFailed => 'Не удалось подготовить файл. Попробуйте снова.';

  @override
  String exportFileName(String date) {
    return 'Mobil Arıcı $date';
  }

  @override
  String get exportYes => 'Да';

  @override
  String get exportNo => 'Нет';

  @override
  String get exportSheetApiaries => 'Пасеки';

  @override
  String get exportSheetHives => 'Ульи';

  @override
  String get exportSheetQueens => 'Матки';

  @override
  String get exportSheetInspections => 'Осмотры';

  @override
  String get exportSheetFeedings => 'Подкормки';

  @override
  String get exportSheetTreatments => 'Обработки';

  @override
  String get exportSheetMiteCounts => 'Подсчёты клеща';

  @override
  String get exportSheetHarvests => 'Медосборы';

  @override
  String get exportSheetTasks => 'Задачи';

  @override
  String get exportSheetInventory => 'Склад';

  @override
  String get exportSheetFinance => 'Доходы и расходы';

  @override
  String get exportColName => 'Название';

  @override
  String get exportColLatitude => 'Широта';

  @override
  String get exportColLongitude => 'Долгота';

  @override
  String get exportColAltitude => 'Высота (м)';

  @override
  String get exportColWaterSource => 'Источник воды';

  @override
  String get exportColVehicleDistance => 'Расстояние до машины (м)';

  @override
  String get exportColRoadNotes => 'Заметки о дороге';

  @override
  String get exportColNotes => 'Заметки';

  @override
  String get exportColActiveHives => 'Активных ульев';

  @override
  String get exportColCreated => 'Добавлено';

  @override
  String get exportColApiary => 'Пасека';

  @override
  String get exportColHive => 'Улей';

  @override
  String get exportColType => 'Тип';

  @override
  String get exportColStatus => 'Статус';

  @override
  String get exportColBoxes => 'Корпуса';

  @override
  String get exportColFrames => 'Рамки';

  @override
  String get exportColSource => 'Происхождение';

  @override
  String get exportColMarking => 'Маркировка';

  @override
  String get exportColTag => 'Код этикетки';

  @override
  String get exportColQuarantine => 'Карантин';

  @override
  String get exportColQueen => 'Матка';

  @override
  String get exportColYear => 'Год';

  @override
  String get exportColColor => 'Цвет метки';

  @override
  String get exportColBreed => 'Порода';

  @override
  String get exportColLine => 'Линия';

  @override
  String get exportColWingClipped => 'Крыло подрезано';

  @override
  String get exportColDate => 'Дата';

  @override
  String get exportColQueenState => 'Матка';

  @override
  String get exportColBeeFrames => 'Рамок с пчёлами';

  @override
  String get exportColBroodFrames => 'Рамок с расплодом';

  @override
  String get exportColHoneyFrames => 'Рамок с мёдом';

  @override
  String get exportColTemperament => 'Нрав';

  @override
  String get exportColSwarmSigns => 'Признаки роения';

  @override
  String get exportColQueenCells => 'Маточники';

  @override
  String get exportColDisease => 'Подозрение на болезнь';

  @override
  String get exportColActions => 'Сделано';

  @override
  String get exportColAmount => 'Количество';

  @override
  String get exportColUnit => 'Единица';

  @override
  String get exportColProduct => 'Препарат';

  @override
  String get exportColActiveIngredient => 'Действующее вещество';

  @override
  String get exportColDose => 'Доза';

  @override
  String get exportColWithdrawal => 'Ожидание (дней)';

  @override
  String get exportColBatch => '№ партии';

  @override
  String get exportColPlannedRemoval => 'Плановое снятие';

  @override
  String get exportColMethod => 'Метод';

  @override
  String get exportColMites => 'Клещи';

  @override
  String get exportColSampleBees => 'Пчёл в пробе';

  @override
  String get exportColDays => 'Дни';

  @override
  String get exportColResult => 'Результат';

  @override
  String get exportColHoneyKind => 'Мёд';

  @override
  String get exportColUnitCount => 'Количество';

  @override
  String get exportColNetKg => 'Нетто (кг)';

  @override
  String get exportColHiveCount => 'Ульи';

  @override
  String get exportColDue => 'Срок';

  @override
  String get exportColTitle => 'Название';

  @override
  String get exportColCompleted => 'Выполнено';

  @override
  String get exportColCategory => 'Категория';

  @override
  String get exportColPlace => 'Место';

  @override
  String get exportColStock => 'На складе';

  @override
  String get exportColThreshold => 'Предупреждать ниже';

  @override
  String get exportColCurrency => 'Валюта';

  @override
  String get exportColDescription => 'Описание';

  @override
  String get businessTitle => 'Хозяйство';

  @override
  String get businessEdit => 'Изменить';

  @override
  String get businessEditTitle => 'Изменить хозяйство';

  @override
  String get businessCancel => 'Отмена';

  @override
  String get businessSave => 'Сохранить';

  @override
  String get businessSaveError =>
      'Не удалось сохранить; хозяйства ещё нет на этом телефоне.';

  @override
  String get businessMissingTitle => 'Нет данных хозяйства';

  @override
  String get businessMissingMessage =>
      'Они появятся здесь, когда хозяйство придёт на этот телефон.';

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
  String get businessRegionTr => 'Профиль TR';

  @override
  String get businessRegionOther => 'Общий профиль';

  @override
  String get businessPendingSync => 'Ещё не синхронизировано';

  @override
  String businessCountHives(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'улья',
      many: 'ульев',
      few: 'улья',
      one: 'улей',
    );
    return '$_temp0';
  }

  @override
  String businessCountApiaries(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'пасеки',
      many: 'пасек',
      few: 'пасеки',
      one: 'пасека',
    );
    return '$_temp0';
  }

  @override
  String businessCountInspections(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'осмотра',
      many: 'осмотров',
      few: 'осмотра',
      one: 'осмотр',
    );
    return '$_temp0';
  }

  @override
  String get businessSectionBusiness => 'Хозяйство';

  @override
  String get businessSectionAccount => 'Аккаунт';

  @override
  String get businessType => 'Тип';

  @override
  String get businessTypeMigratory => 'Кочевое';

  @override
  String get businessTypeStationary => 'Стационарное';

  @override
  String get businessTypeHelp =>
      'Для стационарного хозяйства планы кочёвки и переезды скрыты; записи не удаляются.';

  @override
  String get businessCurrency => 'Валюта';

  @override
  String get businessCurrencySearch => 'Поиск по коду или стране';

  @override
  String get businessCurrencyNoMatch => 'Ни одна валюта не подходит под поиск.';

  @override
  String get businessCurrencyNote =>
      'Прошлые записи не пересчитываются; новая валюта действует только для новых записей.';

  @override
  String businessTeamTitle(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Команда · $count человека',
      many: 'Команда · $count человек',
      few: 'Команда · $count человека',
      one: 'Команда · $count человек',
    );
    return '$_temp0';
  }

  @override
  String get businessTeamSolo => 'Участников команды пока нет';

  @override
  String businessRoleCountOwner(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count владельца',
      many: '$count владельцев',
      few: '$count владельца',
      one: '$count владелец',
    );
    return '$_temp0';
  }

  @override
  String businessRoleCountPartner(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count партнёра',
      many: '$count партнёров',
      few: '$count партнёра',
      one: '$count партнёр',
    );
    return '$_temp0';
  }

  @override
  String businessRoleCountWorker(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count работника',
      many: '$count работников',
      few: '$count работника',
      one: '$count работник',
    );
    return '$_temp0';
  }

  @override
  String businessRoleCountViewer(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count консультанта',
      many: '$count консультантов',
      few: '$count консультанта',
      one: '$count консультант',
    );
    return '$_temp0';
  }

  @override
  String get businessEmail => 'Почта для входа';

  @override
  String get businessEmailSoon => 'Смена почты скоро появится.';

  @override
  String get businessFirstRecord => 'Первая запись';

  @override
  String businessFirstRecordValue(String date, int season) {
    return '$date · сезон $season';
  }

  @override
  String get businessSettingsShortcut => 'Язык, единицы, тема и данные';

  @override
  String get businessNameLabel => 'Название хозяйства';

  @override
  String get businessAvatarLabel => 'Аватар';

  @override
  String get businessAvatarHelp =>
      'Без логотипа показываются ваши инициалы в выбранном цвете.';

  @override
  String get businessAvatarPine => 'Сосна';

  @override
  String get businessAvatarHoney => 'Мёд';

  @override
  String get businessAvatarSky => 'Небо';

  @override
  String get businessAvatarSlate => 'Сланец';

  @override
  String get businessLogoUpload => 'Загрузить логотип';

  @override
  String get businessLogoRemove => 'Удалить логотип';

  @override
  String get businessDiscardTitle => 'Отменить изменения?';

  @override
  String get businessDiscardMessage => 'Несохранённые изменения пропадут.';

  @override
  String get businessDiscardAction => 'Отменить';

  @override
  String get businessTypeConfirmTitle => 'Сделать хозяйство стационарным?';

  @override
  String businessTypeConfirmMessage(int plans, int stops) {
    String _temp0 = intl.Intl.pluralLogic(
      plans,
      locale: localeName,
      other: '$plans плана кочёвки',
      many: '$plans планов кочёвки',
      few: '$plans плана кочёвки',
      one: '$plans план кочёвки',
    );
    String _temp1 = intl.Intl.pluralLogic(
      stops,
      locale: localeName,
      other: '$stops стоянки',
      many: '$stops стоянок',
      few: '$stops стоянки',
      one: '$stops стоянка',
    );
    return 'Скроются $_temp0 и $_temp1. Записи не удаляются; это можно отменить.';
  }

  @override
  String get businessTypeConfirmAction => 'Сделать';

  @override
  String get businessReadOnly =>
      'Данные хозяйства могут менять только владелец и партнёры.';

  @override
  String get financeOtherCurrencies => 'Другие валюты';

  @override
  String financeOtherCurrencyLine(String currency, String amount) {
    return '$currency · итог $amount';
  }

  @override
  String get migratoryHiddenTitle => 'Модуль кочёвки выключен';

  @override
  String get migratoryHiddenMessage =>
      'Ваше хозяйство стационарное. Планы кочёвки и переезды не удалены; они вернутся, если вы переключитесь на кочевое.';

  @override
  String get onboardingMigratoryTitle => 'Вы кочуете с ульями?';

  @override
  String get onboardingMigratoryMessage =>
      'Если нет, планы кочёвки и переезды будут скрыты; это можно изменить в профиле хозяйства.';

  @override
  String get onboardingMigratoryYes => 'Да';

  @override
  String get onboardingMigratoryNo => 'Нет, стационарно';

  @override
  String get settingsDeleteAccount => 'Удалить мой аккаунт';

  @override
  String get settingsDeleteAccountOffline =>
      'Для удаления аккаунта нужен интернет; попробуйте снова, когда будете в сети.';

  @override
  String get deletionTitle => 'Удалить мой аккаунт';

  @override
  String deletionStepCounter(int current, int total) {
    return 'Шаг $current из $total';
  }

  @override
  String get deletionContinue => 'Продолжить';

  @override
  String get deletionSoloTitle => 'Будут удалены ваш аккаунт и хозяйство';

  @override
  String deletionSoloMessage(String organization) {
    return 'Вы единственный участник $organization. Вместе с аккаунтом удалятся хозяйство и все его записи.';
  }

  @override
  String get deletionCountsLabel => 'Будут удалены записи';

  @override
  String get deletionCountHives => 'Ульи';

  @override
  String get deletionCountApiaries => 'Пасеки';

  @override
  String get deletionCountInspections => 'Осмотры';

  @override
  String get deletionCountHarvests => 'Медосборы';

  @override
  String get deletionCountDocuments => 'Документы';

  @override
  String get deletionCountPhotos => 'Фото';

  @override
  String get deletionLotWarningTitle => 'QR-коды перестанут работать.';

  @override
  String deletionLotWarningMessage(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other:
          'Будут удалены $count публичной страницы партий, и QR-коды на ваших банках перестанут работать.',
      many:
          'Будут удалены $count публичных страниц партий, и QR-коды на ваших банках перестанут работать.',
      few:
          'Будут удалены $count публичные страницы партий, и QR-коды на ваших банках перестанут работать.',
      one:
          'Будет удалена $count публичная страница партии, и QR-коды на ваших банках перестанут работать.',
    );
    return '$_temp0';
  }

  @override
  String get deletionTeamTitle =>
      'У вас есть команда: выберите, что будет с хозяйством';

  @override
  String deletionTeamMessage(int count, String organization) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Вы владелец $organization, в команде есть ещё $count человека.',
      many: 'Вы владелец $organization, в команде есть ещё $count человек.',
      few: 'Вы владелец $organization, в команде есть ещё $count человека.',
      one: 'Вы владелец $organization, в команде есть ещё $count человек.',
    );
    return '$_temp0';
  }

  @override
  String get deletionChoiceTransfer => 'Передать владение и уйти';

  @override
  String get deletionChoiceTransferHint =>
      'Хозяйство и его записи остаются. Выбранный партнёр станет владельцем; удалится только ваш аккаунт.';

  @override
  String get deletionChoiceDelete => 'Удалить хозяйство и все записи';

  @override
  String deletionChoiceDeleteHint(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Ещё $count человека в команде тоже потеряют доступ.',
      many: 'Ещё $count человек в команде тоже потеряют доступ.',
      few: 'Ещё $count человека в команде тоже потеряют доступ.',
      one: 'Ещё $count человек в команде тоже потеряет доступ.',
    );
    return '$_temp0';
  }

  @override
  String get deletionTransferPick => 'Новый владелец';

  @override
  String get deletionTransferNoPartner =>
      'Для передачи кто-то в команде должен быть партнёром. Сделайте участника партнёром на экране «Команда» или удалите хозяйство.';

  @override
  String get deletionPartnerFallbackName => 'Партнёр';

  @override
  String get deletionMemberTitle => 'Будет удалён только ваш аккаунт';

  @override
  String deletionMemberMessage(String organization) {
    return '$organization и его записи не удаляются. Внесённые вами записи остаются в хозяйстве; ваше имя уберут из команды.';
  }

  @override
  String get deletionUnknownMessage =>
      'Ваше участие ещё не пришло на этот телефон. Попробуйте снова после синхронизации.';

  @override
  String get deletionGraceNote =>
      'Удаление станет окончательным через 7 дней; до этого можно войти и передумать.';

  @override
  String get deletionBackupTitle => 'Сначала сохраните данные';

  @override
  String get deletionBackupMessage =>
      'Удалённые записи нельзя восстановить. Советуем сначала сохранить копию.';

  @override
  String get deletionBackupReports => 'Отчёты PDF';

  @override
  String get deletionBackupReportsHint => 'Скачайте готовые отчёты в PDF.';

  @override
  String get deletionBackupJson => 'Все записи';

  @override
  String get deletionBackupJsonValue => 'JSON';

  @override
  String get deletionBackupJsonHint =>
      'Все ваши записи в одном файле; сохраните его где угодно.';

  @override
  String get deletionBackupSaved => 'Сохранено';

  @override
  String get deletionBackupDownload => 'Скачать мои записи';

  @override
  String get deletionBackupSkip => 'Пропустить';

  @override
  String deletionBackupFileName(String date) {
    return 'mobil-arici-zapisi-$date';
  }

  @override
  String get deletionVerifyTitle => 'Подтвердите, что это вы';

  @override
  String get deletionVerifyButton => 'Проверить код';

  @override
  String get deletionConfirmTitle => 'Последнее подтверждение';

  @override
  String get deletionConfirmIntro => 'Если вы подтвердите:';

  @override
  String deletionConsequenceAccount(String date) {
    return 'Ваш аккаунт будет окончательно удалён $date.';
  }

  @override
  String deletionConsequenceOrganization(String organization) {
    return '$organization и все его записи тоже удаляются.';
  }

  @override
  String deletionConsequenceTransfer(String name, String organization) {
    return '$name станет новым владельцем $organization.';
  }

  @override
  String get deletionConsequenceRecordsStay => 'Записи хозяйства не удаляются.';

  @override
  String deletionConsequenceLots(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other:
          'Закроются $count страницы партий; их QR-коды перестанут работать.',
      many: 'Закроются $count страниц партий; их QR-коды перестанут работать.',
      few: 'Закроются $count страницы партий; их QR-коды перестанут работать.',
      one: 'Закроется $count страница партии; её QR-коды перестанут работать.',
    );
    return '$_temp0';
  }

  @override
  String get deletionConsequenceSignOut =>
      'Вы выйдете, а данные на этом телефоне будут удалены.';

  @override
  String get deletionConsequenceCancel =>
      'Если войдёте до этого срока, удаление можно отменить.';

  @override
  String deletionConfirmTypeName(String organization) {
    return 'Для подтверждения введите название хозяйства: $organization';
  }

  @override
  String deletionConfirmTypeKeyword(String keyword) {
    return 'Для подтверждения введите $keyword';
  }

  @override
  String get deletionKeyword => 'УДАЛИТЬ';

  @override
  String get deletionConfirmButton => 'Удалить мой аккаунт';

  @override
  String get deletionConfirmButtonWithOrganization =>
      'Удалить аккаунт и хозяйство';

  @override
  String get deletionSubmitting => 'Отправляем…';

  @override
  String get deletionFailureNetwork =>
      'Сервер недоступен. Проверьте подключение и попробуйте снова.';

  @override
  String get deletionFailureOwnerMustTransfer =>
      'Вы также владеете другим хозяйством с командой. Сначала передайте владение там.';

  @override
  String get deletionFailureInvalidTransfer =>
      'Выбранный человек больше не партнёр. Выберите другого партнёра.';

  @override
  String get deletionFailureRateLimited =>
      'Слишком много попыток за короткое время. Попробуйте завтра.';

  @override
  String get deletionFailureForbidden =>
      'Сеанс завершён. Войдите снова и повторите.';

  @override
  String get deletionFailureCodeRequired =>
      'Подтверждение устарело. Запросите новый код и подтвердите снова.';

  @override
  String get deletionFailureUnknown =>
      'Не удалось отправить запрос. Попробуйте чуть позже.';

  @override
  String get deletionDoneTitle => 'Мы получили ваш запрос';

  @override
  String deletionDoneDate(String date) {
    return 'Ваш аккаунт будет окончательно удалён $date.';
  }

  @override
  String get deletionDoneCancelHint =>
      'Если передумаете, войдите до этой даты — удаление отменится.';

  @override
  String get deletionDoneEmail =>
      'Подробности мы также отправили на вашу почту.';

  @override
  String get deletionDoneClearing => 'Удаляем данные на этом телефоне…';

  @override
  String get deletionDoneSignedOut =>
      'Вы вышли, данные на этом телефоне удалены.';

  @override
  String get deletionDoneAction => 'Готово';

  @override
  String get deletionPendingTitle => 'Ваш аккаунт скоро будет удалён';

  @override
  String deletionPendingMessage(String date) {
    return 'Ваш аккаунт будет удалён $date. Если продолжите, удаление отменится.';
  }

  @override
  String get deletionPendingContinue => 'Продолжить и сохранить аккаунт';

  @override
  String get deletionPendingSignOut => 'Выйти и оставить удаление';

  @override
  String get deletionPendingCancelled => 'Удаление отменено. С возвращением!';

  @override
  String get deletionPendingCancelFailed =>
      'Не удалось отменить удаление. Проверьте подключение и попробуйте снова.';

  @override
  String teamMemberLeaving(String date) {
    return 'Удаляет аккаунт · $date';
  }

  @override
  String get teamErrorMemberLeaving =>
      'Этот человек удаляет свой аккаунт; в период ожидания его роль нельзя изменить, а самого его нельзя удалить из команды.';
}
