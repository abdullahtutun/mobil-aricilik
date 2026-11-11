// ignore: unused_import
import 'package:intl/intl.dart' as intl;

import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Persian (`fa`).
class AppLocalizationsFa extends AppLocalizations {
  AppLocalizationsFa([String locale = 'fa']) : super(locale);

  @override
  String get appTitle => 'Mobil Arıcı';

  @override
  String get listSeparator => '،';

  @override
  String get stepperIncrease => 'افزایش';

  @override
  String get stepperDecrease => 'کاهش';

  @override
  String hiveTileLabel(String number) {
    return 'کندو $number';
  }

  @override
  String hiveTileStrength(int strength) {
    return 'قدرت $strength از 5';
  }

  @override
  String hiveTileQueenColor(String color) {
    String _temp0 = intl.Intl.selectLogic(color, {
      'white': 'سفید',
      'yellow': 'زرد',
      'red': 'قرمز',
      'green': 'سبز',
      'blue': 'آبی',
      'other': 'نامشخص',
    });
    return 'رنگ ملکه $_temp0';
  }

  @override
  String get tabToday => 'امروز';

  @override
  String get tabApiaries => 'زنبورستان‌ها';

  @override
  String get tabTasks => 'کارها';

  @override
  String get tabMore => 'بیشتر';

  @override
  String get todayEmptyTitle => 'با افزودن زنبورستان شروع کنید';

  @override
  String get todayEmptyMessage =>
      'سه قدم تا آماده شدن: زنبورستان را اضافه کنید، کندوها را بسازید، اولین بازدید را انجام دهید.';

  @override
  String get apiariesEmptyTitle => 'هنوز زنبورستانی ندارید';

  @override
  String get apiariesEmptyMessage =>
      'زنبورستان کندوها را بر اساس محل قرارگیری گروه‌بندی می‌کند؛ برای شروع اولی را اضافه کنید.';

  @override
  String get apiariesAdd => 'افزودن زنبورستان';

  @override
  String get apiariesAddFirst => 'اولین زنبورستان را اضافه کنید';

  @override
  String get apiariesLoadError => 'خواندن زنبورستان‌ها ممکن نشد.';

  @override
  String get apiariesViewList => 'فهرست';

  @override
  String get apiariesViewMap => 'نقشه';

  @override
  String get apiariesMapOfflineTitle => 'نقشه در دسترس نیست';

  @override
  String get apiariesMapOfflineMessage =>
      'نقشه به اینترنت نیاز دارد. زنبورستان‌هایتان در فهرست زیر هستند.';

  @override
  String get apiariesMapNoLocation =>
      'هیچ زنبورستانی هنوز موقعیت ندارد. زنبورستانی را ویرایش کنید تا موقعیت را از GPS بگیرید یا روی نقشه انتخاب کنید.';

  @override
  String get apiariesMapAttribution =>
      '© OpenFreeMap © OpenMapTiles © OpenStreetMap contributors';

  @override
  String apiaryMapPinLabel(String name, String hives) {
    return '$name، $hives';
  }

  @override
  String apiaryMapPinAttention(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count کندو به توجه نیاز دارند',
      one: '1 کندو به توجه نیاز دارد',
    );
    return '$_temp0';
  }

  @override
  String get apiaryMapDirections => 'مسیریابی';

  @override
  String get apiaryMapShow => 'نمایش';

  @override
  String get apiaryMapDirectionsFailed => 'باز کردن برنامه نقشه ممکن نشد.';

  @override
  String get apiaryMapDirectionsChooseApp => 'مسیریابی با';

  @override
  String apiaryHiveCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count کندو',
      one: '1 کندو',
      zero: 'بدون کندو',
    );
    return '$_temp0';
  }

  @override
  String apiaryLastVisit(String date) {
    return 'آخرین بازدید $date';
  }

  @override
  String get apiaryNoVisit => 'هنوز بازدیدی نشده';

  @override
  String get apiaryEdit => 'ویرایش';

  @override
  String get apiaryDelete => 'حذف زنبورستان';

  @override
  String get apiaryDeleteTitle => 'این زنبورستان حذف شود؟';

  @override
  String get apiaryDeleteMessage => 'زنبورستان از همه گوشی‌ها حذف می‌شود.';

  @override
  String apiaryDeleteWithHivesMessage(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other:
          'این زنبورستان $count کندو دارد. زنبورستان و کندوهای آن از همه گوشی‌ها حذف می‌شوند.',
      one: 'این زنبورستان 1 کندو دارد. زنبورستان و کندوی آن از همه گوشی‌ها حذف می‌شوند.',
    );
    return '$_temp0';
  }

  @override
  String get apiaryDeleted => 'زنبورستان حذف شد';

  @override
  String get apiaryNotFoundTitle => 'زنبورستان پیدا نشد';

  @override
  String get apiaryNotFoundMessage =>
      'ممکن است حذف شده یا هنوز به این دستگاه نرسیده باشد.';

  @override
  String get apiaryFormNewTitle => 'زنبورستان جدید';

  @override
  String get apiaryFormEditTitle => 'ویرایش زنبورستان';

  @override
  String get apiaryFormName => 'نام زنبورستان';

  @override
  String get apiaryFormNameHint => 'مثلاً تپه';

  @override
  String get apiaryFormLocation => 'موقعیت';

  @override
  String get apiaryFormLocationNone =>
      'هنوز موقعیتی ثبت نشده. اگر در زنبورستان هستید، آن را از GPS بگیرید، بدون نیاز به اینترنت؛ وگرنه روی نقشه انتخاب کنید.';

  @override
  String get apiaryFormLocationTake => 'گرفتن موقعیت از GPS';

  @override
  String get apiaryFormLocationRetake => 'گرفتن دوباره موقعیت';

  @override
  String get apiaryFormLocationClear => 'حذف موقعیت';

  @override
  String get apiaryFormLocationPickOnMap => 'انتخاب روی نقشه';

  @override
  String get locationPickerTitle => 'انتخاب موقعیت روی نقشه';

  @override
  String get locationPickerSearchHint => 'جستجوی شهر یا مکان';

  @override
  String get locationPickerSearch => 'جستجو';

  @override
  String get locationPickerHint =>
      'نقشه را جابه‌جا کنید تا نشانگر روی زنبورستان قرار گیرد.';

  @override
  String get locationPickerPinLabel => 'موقعیت انتخاب‌شده';

  @override
  String get locationPickerConfirm => 'استفاده از این موقعیت';

  @override
  String get locationPickerNoResults =>
      'مکانی پیدا نشد. نام دیگری را امتحان کنید.';

  @override
  String get locationPickerSearchOffline =>
      'جستجو ممکن نشد. جستجو به اینترنت نیاز دارد.';

  @override
  String get locationPickerMapOfflineMessage =>
      'نقشه به اینترنت نیاز دارد. اگر در زنبورستان هستید، موقعیت را از GPS بگیرید.';

  @override
  String get apiaryFormLocating =>
      'در حال یافتن موقعیت… در فضای باز سریع‌تر است.';

  @override
  String apiaryFormLocationAccuracy(int meters) {
    return 'دقت ±$meters متر';
  }

  @override
  String get apiaryFormLocationErrorServiceDisabled =>
      'موقعیت‌یابی در این دستگاه خاموش است. آن را روشن کنید و دوباره تلاش کنید.';

  @override
  String get apiaryFormLocationErrorPermissionDenied =>
      'اجازه موقعیت‌یابی داده نشد. برای گرفتن موقعیت آن را مجاز کنید.';

  @override
  String get apiaryFormLocationErrorPermissionDeniedForever =>
      'اجازه موقعیت‌یابی خاموش است. در تنظیمات، موقعیت‌یابی را برای این برنامه مجاز کنید.';

  @override
  String get apiaryFormLocationErrorTimeout =>
      'موقعیت پیدا نشد. در فضای باز دوباره تلاش کنید.';

  @override
  String get apiaryFormLocationErrorUnknown =>
      'گرفتن موقعیت ممکن نشد. دوباره تلاش کنید.';

  @override
  String get apiaryFormOpenSettings => 'باز کردن تنظیمات';

  @override
  String get apiaryFormNotes => 'یادداشت‌ها';

  @override
  String get apiaryFormSave => 'ذخیره';

  @override
  String get hiveSortWeakestFirst => 'ضعیف‌ترین‌ها اول';

  @override
  String get hivesEmptyTitle => 'هنوز کندویی ندارید';

  @override
  String get hivesEmptyMessage =>
      'کندوهایی را که در این زنبورستان هستند اضافه کنید؛ می‌توانید چندتا را یک‌جا بسازید.';

  @override
  String get hivesAdd => 'افزودن کندو';

  @override
  String get hivesAddOne => 'یک کندو';

  @override
  String get hivesAddOneHint => 'شماره، نوع و منشأ را وارد کنید';

  @override
  String get hivesAddBulk => 'چندتا یک‌جا';

  @override
  String get hivesAddBulkHint => 'مثلاً 20 کندو از 101';

  @override
  String hivesInactiveTitle(int count) {
    return 'غیرفعال ($count)';
  }

  @override
  String get hivesLoadError => 'خواندن کندوها ممکن نشد.';

  @override
  String hiveLabel(String number) {
    return 'کندو $number';
  }

  @override
  String hiveTypeAndSource(String type, String source) {
    return '$type · $source';
  }

  @override
  String get hiveTypeLangstroth => 'لانگستروث';

  @override
  String get hiveTypeDadant => 'دادان';

  @override
  String get hiveTypeLocal => 'محلی';

  @override
  String get hiveTypeOther => 'دیگر';

  @override
  String get hiveStatusActive => 'فعال';

  @override
  String get hiveStatusDead => 'تلف‌شده';

  @override
  String get hiveStatusMerged => 'ادغام‌شده';

  @override
  String get hiveStatusSold => 'فروخته‌شده';

  @override
  String get hiveStatusLost => 'از دست رفته';

  @override
  String get hiveSourceSwarm => 'بچه‌کندو';

  @override
  String get hiveSourceSplit => 'تقسیم';

  @override
  String get hiveSourcePurchase => 'خریداری‌شده';

  @override
  String get hiveSourcePackage => 'بسته زنبور';

  @override
  String get hiveFormNewTitle => 'کندوی جدید';

  @override
  String get hiveFormEditTitle => 'ویرایش کندو';

  @override
  String get hiveFormNumber => 'شماره کندو';

  @override
  String get hiveFormNumberHint => 'مثلاً 101';

  @override
  String get hiveFormType => 'نوع کندو';

  @override
  String get hiveFormStatus => 'وضعیت';

  @override
  String get hiveFormSource => 'منشأ';

  @override
  String get hiveFormSave => 'ذخیره';

  @override
  String get hiveBulkTitle => 'ساخت چند کندو';

  @override
  String get hiveBulkCount => 'چند کندو';

  @override
  String get hiveBulkCountHint => 'مثلاً 20';

  @override
  String hiveBulkCountTooMany(int max) {
    return 'حداکثر $max در هر بار';
  }

  @override
  String get hiveBulkStart => 'شماره اول';

  @override
  String get hiveBulkStartHint => 'مثلاً 101';

  @override
  String hiveBulkPreview(int count, String first, String last) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count کندو ساخته می‌شود: از $first تا $last.',
      one: 'کندوی $first ساخته می‌شود.',
    );
    return '$_temp0';
  }

  @override
  String get hiveBulkSave => 'ساخت کندوها';

  @override
  String hiveBulkCreated(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count کندو ساخته شد',
      one: '1 کندو ساخته شد',
    );
    return '$_temp0';
  }

  @override
  String get hiveNotFoundTitle => 'کندو پیدا نشد';

  @override
  String get hiveNotFoundMessage =>
      'ممکن است حذف شده یا هنوز به این دستگاه نرسیده باشد.';

  @override
  String get hiveEdit => 'ویرایش';

  @override
  String get hiveDelete => 'حذف کندو';

  @override
  String hiveDeleteTitle(String number) {
    return 'کندوی $number حذف شود؟';
  }

  @override
  String get hiveDeleteMessage => 'کندو و سوابق آن از همه گوشی‌ها حذف می‌شوند.';

  @override
  String hiveDeleted(String number) {
    return 'کندوی $number حذف شد';
  }

  @override
  String hiveCardApiary(String name) {
    return 'زنبورستان: $name';
  }

  @override
  String get hiveQueenTitle => 'ملکه';

  @override
  String hiveQueenStripTitle(String queen) {
    return 'ملکه · $queen';
  }

  @override
  String hiveStrengthBadge(String level, int strength) {
    return '$level · $strength/5';
  }

  @override
  String get hiveStrengthWeak => 'ضعیف';

  @override
  String get hiveStrengthMedium => 'متوسط';

  @override
  String get hiveStrengthStrong => 'قوی';

  @override
  String get hiveStrengthNone => 'هنوز امتیاز قدرت ندارد';

  @override
  String get hiveTimelineTitle => 'تاریخچه';

  @override
  String get timelineInspection => 'بازدید';

  @override
  String get timelineAdded => 'در زنبورستان قرار گرفت';

  @override
  String get timelineMoved => 'جابه‌جا شد';

  @override
  String timelineMoveRoute(String from, String to) {
    return '$from ← $to';
  }

  @override
  String get timelineUnknownApiary => 'زنبورستان نامشخص';

  @override
  String timelineField(String label, String value) {
    return '$label: $value';
  }

  @override
  String timelineBeeFrames(int count) {
    return '$count با زنبور';
  }

  @override
  String timelineBroodFrames(int count) {
    return '$count با نوزاد';
  }

  @override
  String timelineHoneyFrames(int count) {
    return '$count با عسل';
  }

  @override
  String get timelineActions => 'انجام‌شده';

  @override
  String get hiveMove => 'انتقال به زنبورستان دیگر';

  @override
  String hiveMoveTitle(String number) {
    return 'انتقال کندوی $number به';
  }

  @override
  String get hiveMoveNoOtherApiary =>
      'زنبورستان دیگری برای انتقال وجود ندارد. ابتدا از برگه زنبورستان‌ها یکی اضافه کنید.';

  @override
  String hiveMoved(String number, String apiary) {
    return 'کندوی $number به $apiary منتقل شد';
  }

  @override
  String get hiveChangeStatus => 'تغییر وضعیت';

  @override
  String hiveStatusSheetTitle(String number) {
    return 'وضعیت جدید کندوی $number';
  }

  @override
  String hiveStatusConfirmTitle(String status, String number) {
    String _temp0 = intl.Intl.selectLogic(status, {
      'dead': 'کندوی $number تلف‌شده ثبت شود؟',
      'merged': 'کندوی $number ادغام‌شده ثبت شود؟',
      'sold': 'کندوی $number فروخته‌شده ثبت شود؟',
      'other': 'کندوی $number از دست رفته ثبت شود؟',
    });
    return '$_temp0';
  }

  @override
  String get hiveStatusConfirmMessage =>
      'دیگر جزو کندوهای فعال زنبورستان شمرده نمی‌شود. بعداً می‌توانید دوباره فعالش کنید.';

  @override
  String get hiveStatusConfirm => 'بله، ثبت شود';

  @override
  String hiveStatusChanged(String number, String status) {
    return 'کندوی $number: $status';
  }

  @override
  String get tasksEmptyTitle => 'هنوز کاری ندارید';

  @override
  String get tasksEmptyMessage =>
      'یادآورها و کارهایتان اینجا بر اساس تاریخ فهرست می‌شوند.';

  @override
  String get scanTitle => 'اسکن';

  @override
  String get scanLongPressHint => 'باز کردن منوی ثبت سریع';

  @override
  String get scanHint => 'کد روی برچسب کندو را در کادر قرار دهید.';

  @override
  String get scanAgain => 'اسکن دوباره';

  @override
  String get cameraErrorTitle => 'باز کردن دوربین ممکن نشد';

  @override
  String get cameraErrorPermissionDenied =>
      'اجازه دوربین داده نشد. برای اسکن برچسب‌ها، در تنظیمات دوربین را برای این برنامه مجاز کنید.';

  @override
  String get cameraErrorUnsupported => 'این دستگاه دوربینی برای اسکن ندارد.';

  @override
  String get cameraErrorUnknown => 'این صفحه را ببندید و دوباره تلاش کنید.';

  @override
  String get labelUnknownTitle => 'این کد به هیچ کندویی وصل نیست';

  @override
  String get labelUnknownMessage =>
      'این برچسب Mobil Arıcı نیست یا هنوز به کندویی اختصاص داده نشده. اگر روی کندوست، اختصاصش دهید؛ آن‌وقت اسکن آن کارت کندو را باز می‌کند.';

  @override
  String get labelUnknownOwnTitle => 'کندوی این برچسب پیدا نشد';

  @override
  String get labelUnknownOwnMessage =>
      'ممکن است کندو حذف شده یا هنوز به این گوشی نرسیده باشد. می‌توانید برچسب را به کندوی دیگری هم اختصاص دهید.';

  @override
  String labelCode(String code) {
    return 'کد: $code';
  }

  @override
  String get labelAssign => 'اختصاص به کندو';

  @override
  String get labelAssignTitle => 'اختصاص برچسب به کندو';

  @override
  String get labelAssignMessage =>
      'کندویی را که برچسب روی آن است انتخاب کنید. سپس اسکن برچسب کارت همان کندو را باز می‌کند.';

  @override
  String get labelAssignSearch => 'شماره کندو';

  @override
  String get labelAssignNoMatch => 'هیچ کندویی با جستجوی شما جور نیست.';

  @override
  String get labelAssignNoHives =>
      'هنوز کندویی ندارید. ابتدا از برگه زنبورستان‌ها کندو اضافه کنید.';

  @override
  String get labelAssignHasOther => 'برچسب دیگری دارد';

  @override
  String labelReplaceTitle(String number) {
    return 'برچسب کندوی $number جایگزین شود؟';
  }

  @override
  String get labelReplaceMessage =>
      'این کندو از قبل برچسب دارد. برچسب جدید جایگزین آن می‌شود؛ برچسب قبلی دیگر این کندو را باز نمی‌کند.';

  @override
  String get labelReplaceConfirm => 'بله، جایگزین شود';

  @override
  String labelAssigned(String number) {
    return 'برچسب اختصاص یافت: کندوی $number';
  }

  @override
  String get hiveLabelsTitle => 'چاپ برچسب';

  @override
  String get hiveLabelsMessage =>
      'کندوهایی را که برایشان برچسب می‌خواهید انتخاب کنید. هر صفحه A4 جای 24 برچسب (70 × 37 میلی‌متر) دارد؛ با مقیاس 100% چاپ کنید.';

  @override
  String get hiveLabelsNoHives => 'این زنبورستان کندویی برای چاپ برچسب ندارد.';

  @override
  String get hiveLabelsSelectAll => 'انتخاب همه';

  @override
  String get hiveLabelsSelectNone => 'لغو انتخاب همه';

  @override
  String get hiveLabelsNoneSelected => 'هیچ کندویی انتخاب نشده';

  @override
  String hiveLabelsCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count برچسب',
      one: '1 برچسب',
    );
    return '$_temp0';
  }

  @override
  String hiveLabelsPages(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count صفحه',
      one: '1 صفحه',
    );
    return '$_temp0';
  }

  @override
  String hiveLabelsSummary(String labels, String pages) {
    return '$labels · $pages';
  }

  @override
  String get hiveLabelsPreparing => 'در حال آماده‌سازی PDF…';

  @override
  String get hiveLabelsPrint => 'چاپ';

  @override
  String get hiveLabelsShare => 'اشتراک‌گذاری PDF';

  @override
  String hiveLabelsDocumentName(String apiary) {
    return 'برچسب‌های کندو - $apiary';
  }

  @override
  String get hiveLabelsError => 'آماده‌سازی PDF ممکن نشد. دوباره تلاش کنید.';

  @override
  String get quickRecordTitle => 'ثبت سریع';

  @override
  String get quickRecordInspection => 'بازدید';

  @override
  String get quickRecordFeeding => 'تغذیه';

  @override
  String get quickRecordTreatment => 'درمان';

  @override
  String get quickRecordHarvest => 'برداشت';

  @override
  String get quickRecordNote => 'یادداشت';

  @override
  String get quickRecordExpense => 'هزینه';

  @override
  String get quickRecordComingSoon => 'این نوع ثبت به‌زودی می‌آید.';

  @override
  String get signInSendCode => 'ارسال کد';

  @override
  String get signInSending => 'در حال ارسال…';

  @override
  String signInCodeMessage(String email) {
    return 'یک کد 6 رقمی به $email فرستادیم.';
  }

  @override
  String get signInCodeFieldLabel => 'کد 6 رقمی';

  @override
  String get signInVerify => 'ورود';

  @override
  String get signInVerifying => 'در حال بررسی…';

  @override
  String get signInResend => 'ارسال دوباره کد';

  @override
  String signInResendIn(int seconds) {
    return 'ارسال دوباره کد ($seconds ث)';
  }

  @override
  String get signInCodeResent => 'کد جدید در راه است.';

  @override
  String get authErrorNetwork =>
      'اتصال برقرار نشد. اینترنت را بررسی کنید و دوباره تلاش کنید.';

  @override
  String get authErrorInvalidEmail => 'یک نشانی ایمیل معتبر وارد کنید.';

  @override
  String get authErrorInvalidCode =>
      'کد اشتباه است یا منقضی شده. دوباره تلاش کنید یا کد جدید بخواهید.';

  @override
  String get authErrorTooManyRequests =>
      'تلاش‌ها بیش از حد است. کمی صبر کنید و دوباره تلاش کنید.';

  @override
  String get authErrorUnknown => 'مشکلی پیش آمد. لطفاً دوباره تلاش کنید.';

  @override
  String get settingsTitle => 'تنظیمات';

  @override
  String get settingsSystemDefault => 'مطابق سیستم';

  @override
  String get settingsLanguage => 'زبان';

  @override
  String get settingsColorMode => 'پوسته';

  @override
  String get settingsColorModeLight => 'روشن';

  @override
  String get settingsColorModeDark => 'تیره';

  @override
  String get settingsColorModeSun => 'آفتاب';

  @override
  String get settingsAccount => 'حساب';

  @override
  String settingsSignedInAs(String email) {
    return 'وارد شده با $email';
  }

  @override
  String get settingsPrivacyPolicy => 'سیاست حریم خصوصی';

  @override
  String settingsVersion(String version) {
    return 'نسخه $version';
  }

  @override
  String get settingsSignOut => 'خروج';

  @override
  String get settingsSignOutConfirmTitle => 'خارج می‌شوید؟';

  @override
  String get settingsSignOutConfirmMessage =>
      'برای ورود دوباره به کد جدیدی که به ایمیلتان فرستاده می‌شود نیاز دارید و این به اینترنت نیاز دارد.';

  @override
  String get actionCancel => 'لغو';

  @override
  String get actionDelete => 'حذف';

  @override
  String get actionRetry => 'تلاش دوباره';

  @override
  String get actionUndo => 'واگرد';

  @override
  String onboardingStepCounter(int current, int total) {
    return 'مرحله $current از $total';
  }

  @override
  String get onboardingContinue => 'ادامه';

  @override
  String get onboardingFinish => 'راه‌اندازی کسب‌وکار';

  @override
  String get onboardingFinishing => 'در حال راه‌اندازی…';

  @override
  String get onboardingCountrySearch => 'جستجوی کشور';

  @override
  String get onboardingCountrySuggested => 'پیشنهاد برای دستگاه شما';

  @override
  String get onboardingCountryAll => 'همه کشورها';

  @override
  String get onboardingCountryNoMatch => 'هیچ کشوری با جستجوی شما جور نیست.';

  @override
  String get onboardingNameMessage =>
      'این نام در سوابق و گزارش‌هایتان نمایش داده می‌شود.';

  @override
  String get onboardingNameLabel => 'نام کسب‌وکار';

  @override
  String get onboardingNameHint => 'مثلاً زنبورستان شان طلایی';

  @override
  String get onboardingHiveCountTitle => 'چند کندو دارید؟';

  @override
  String get onboardingHiveCountMessage =>
      'یک عدد تقریبی کافی است؛ پیشنهاد می‌دهیم چطور پیگیرشان باشید. خود کندوها را بعداً اضافه می‌کنید.';

  @override
  String get hiveCountRangeNone => 'هنوز هیچ';

  @override
  String get hiveCountRangeUpTo10 => '1–10';

  @override
  String get hiveCountRangeUpTo50 => '11–50';

  @override
  String get hiveCountRangeUpTo200 => '51–200';

  @override
  String get hiveCountRangeOver200 => 'بیش از 200';

  @override
  String get onboardingApiaryTitle => 'اولین زنبورستان را اضافه کنید';

  @override
  String get onboardingApiaryMessage =>
      'زنبورستان جایی است که کندوهایتان در آن قرار دارند. ذخیره آن به اینترنت نیاز ندارد.';

  @override
  String get onboardingApiarySave => 'ذخیره زنبورستان';

  @override
  String get onboardingApiarySkip => 'فعلاً رد شوید';

  @override
  String get onboardingLoading => 'در حال بارگیری کسب‌وکار شما';

  @override
  String get onboardingLoadErrorTitle => 'بارگیری کسب‌وکار ممکن نشد';

  @override
  String get onboardingErrorNetwork =>
      'اتصال برقرار نشد. اینترنت را بررسی کنید و دوباره تلاش کنید.';

  @override
  String get onboardingErrorUnknown => 'مشکلی پیش آمد. لطفاً دوباره تلاش کنید.';

  @override
  String get devMenuTitle => 'منوی توسعه‌دهنده';

  @override
  String get componentGalleryTitle => 'گالری اجزا';

  @override
  String get componentGalleryDescription => 'اجزای سیستم طراحی در چهار پوسته';

  @override
  String get galleryThemeLight => 'روشن';

  @override
  String get galleryThemeDark => 'تیره';

  @override
  String get galleryThemeSun => 'آفتاب';

  @override
  String get galleryThemeGlove => 'دستکش';

  @override
  String get galleryBigButton => 'دکمه بزرگ';

  @override
  String get galleryChoiceChipGroup => 'تراشه‌های انتخاب';

  @override
  String get galleryBigStepper => 'شمارنده بزرگ';

  @override
  String get galleryStatusBadge => 'نشان وضعیت';

  @override
  String get galleryHiveTile => 'کاشی کندو';

  @override
  String get galleryEmptyState => 'حالت خالی';

  @override
  String get gallerySectionCard => 'کارت بخش';

  @override
  String get galleryStrengthDots => 'نقطه‌های قدرت';

  @override
  String get galleryTimelineTile => 'ردیف تاریخچه';

  @override
  String get gallerySampleApiaryHill => 'تپه';

  @override
  String get gallerySampleApiaryPlain => 'کنار رود';

  @override
  String get gallerySampleStartInspection => 'شروع بازدید';

  @override
  String get gallerySampleAddPhoto => 'افزودن عکس';

  @override
  String get gallerySampleSave => 'ذخیره';

  @override
  String get gallerySampleQueen => 'ملکه';

  @override
  String get gallerySampleQueenSeen => 'دیده شد';

  @override
  String get gallerySampleEggs => 'تخم هست';

  @override
  String get gallerySampleNone => 'هیچ';

  @override
  String get gallerySampleActions => 'کارهای انجام‌شده';

  @override
  String get gallerySampleSuperAdded => 'طبقه عسل اضافه شد';

  @override
  String get gallerySampleFrameAdded => 'قاب اضافه شد';

  @override
  String get gallerySampleFed => 'تغذیه شد';

  @override
  String get gallerySampleBeeFrames => 'قاب‌های پوشیده از زنبور';

  @override
  String get gallerySampleBroodFrames => 'قاب‌های نوزاد';

  @override
  String get gallerySampleStrong => 'قوی';

  @override
  String get gallerySampleWeak => 'ضعیف';

  @override
  String get gallerySampleQueenless => 'بی‌ملکه';

  @override
  String get gallerySampleTask => 'کار';

  @override
  String get gallerySampleNoApiaries => 'هنوز زنبورستانی ندارید';

  @override
  String get gallerySampleNoApiariesMessage =>
      'زنبورستان کندوها را بر اساس محل قرارگیری گروه‌بندی می‌کند؛ برای شروع اولی را اضافه کنید.';

  @override
  String get gallerySampleAddApiary => 'اولین زنبورستان را اضافه کنید';

  @override
  String get gallerySampleLastInspection => 'آخرین بازدید';

  @override
  String get gallerySampleLastInspectionBody =>
      '3 روز پیش · 7 قاب با زنبور · ملکه دیده شد';

  @override
  String get gallerySampleUntitledCard =>
      'کارت می‌تواند بدون عنوان هم باشد؛ محتوا بلافاصله شروع می‌شود.';

  @override
  String get gallerySnackBar => 'اسنک‌بار';

  @override
  String get galleryCriticalLockCard => 'کارت قفل حیاتی';

  @override
  String get gallerySampleInspectionSaved => 'بازدید ذخیره شد';

  @override
  String get gallerySampleWithdrawalTitle => 'در دوره انتظار.';

  @override
  String get gallerySampleWithdrawalMessage =>
      'تا 12 روز دیگر روی این کندو طبقه عسل نگذارید.';

  @override
  String get syncStatusSynced => 'همگام';

  @override
  String syncStatusPending(int count) {
    return '$count در انتظار';
  }

  @override
  String get syncStatusError => 'خطا';

  @override
  String syncStatusSemantics(String status) {
    return 'همگام‌سازی: $status';
  }

  @override
  String get syncTitle => 'همگام‌سازی';

  @override
  String get syncSyncedMessage => 'همه سوابق این گوشی به سرور رسیده‌اند.';

  @override
  String syncPendingMessage(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count سابقه در انتظار ارسال است.',
      one: '1 سابقه در انتظار ارسال است.',
    );
    return '$_temp0';
  }

  @override
  String get syncProblemOffline =>
      'دسترسی به سرور ممکن نشد. وقتی دوباره آنلاین شوید، همگام‌سازی دوباره تلاش می‌کند.';

  @override
  String get syncProblemFailed =>
      'همگام‌سازی تمام نشد. کمی بعد دوباره تلاش کنید.';

  @override
  String get syncProblemUpgrade =>
      'این نسخه دیگر نمی‌تواند همگام‌سازی کند. برنامه را به‌روز کنید.';

  @override
  String syncLastSynced(String time) {
    return 'آخرین همگام‌سازی $time';
  }

  @override
  String get syncNow => 'همگام‌سازی اکنون';

  @override
  String get syncRunning => 'در حال همگام‌سازی…';

  @override
  String syncRejectedTitle(int count) {
    return 'ارسال نشد ($count)';
  }

  @override
  String get syncRejectedMessage =>
      'سرور این سوابق را نپذیرفت. بقیه همچنان همگام می‌شوند.';

  @override
  String syncRejectedSubtitle(String reason, String date) {
    return '$reason · $date';
  }

  @override
  String get syncRejectionForbidden => 'اجازه تغییر این سابقه را ندارید';

  @override
  String get syncRejectionConflict =>
      'با سابقه دیگری تداخل دارد (مثلاً همان برچسب)';

  @override
  String get syncRejectionMissingReference =>
      'سابقه‌ای که به آن تعلق دارد در سرور نیست';

  @override
  String get syncRejectionUnsupported => 'این نوع سابقه همگام نمی‌شود';

  @override
  String get syncRejectionInvalid => 'سابقه داده نامعتبر دارد';

  @override
  String get syncRejectionUnknown => 'دلیل نامشخص';

  @override
  String get syncTableOrganizations => 'کسب‌وکار';

  @override
  String get syncTableMemberships => 'عضویت';

  @override
  String get syncTableApiaries => 'زنبورستان';

  @override
  String get syncTableQueens => 'ملکه';

  @override
  String get syncTableHives => 'کندو';

  @override
  String get syncTableHiveStatusEvents => 'تغییر وضعیت کندو';

  @override
  String get syncTableHiveLocationHistory => 'جابه‌جایی کندو';

  @override
  String get initialSyncTitle => 'در حال دریافت سوابق شما';

  @override
  String get initialSyncMessage =>
      'سوابق کسب‌وکارتان در حال دریافت روی این گوشی است. این فقط یک بار انجام می‌شود؛ پس از آن برنامه بدون اینترنت هم کار می‌کند.';

  @override
  String initialSyncRows(int count) {
    final intl.NumberFormat countNumberFormat =
        intl.NumberFormat.decimalPattern(localeName);
    final String countString = countNumberFormat.format(count);

    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$countString سابقه دریافت شد',
      one: '1 سابقه دریافت شد',
    );
    return '$_temp0';
  }

  @override
  String get initialSyncFailedTitle => 'دریافت تمام نشد';

  @override
  String get suggestedValue => 'از آخرین سابقه';

  @override
  String get stepperNoValue => 'تعیین نشده';

  @override
  String get hiveStartInspection => 'شروع بازدید';

  @override
  String inspectionTitle(String number) {
    return 'بازدید کندوی $number';
  }

  @override
  String inspectionPrevious(String date) {
    return 'آخرین بازدید $date';
  }

  @override
  String get inspectionFirst => 'اولین بازدید';

  @override
  String get inspectionSuggestedLegend =>
      'مقدارهای کم‌رنگ از آخرین بازدید هستند. آنچه فرق کرده را تغییر دهید؛ بقیه همان‌طور ذخیره می‌شود.';

  @override
  String get inspectionDraftSaved =>
      'به‌صورت پیش‌نویس روی این گوشی نگه داشته شد';

  @override
  String get inspectionRestart => 'شروع دوباره';

  @override
  String get inspectionQueen => 'ملکه';

  @override
  String get queenStateSeen => 'دیده شد';

  @override
  String get queenStateEggs => 'تخم دیده شد';

  @override
  String get queenStateNone => 'هیچ';

  @override
  String get inspectionFrames => 'قاب‌ها';

  @override
  String get inspectionBeeFrames => 'با زنبور';

  @override
  String get inspectionBroodFrames => 'با نوزاد';

  @override
  String get inspectionHoneyFrames => 'با عسل';

  @override
  String get inspectionTemperament => 'رفتار';

  @override
  String get temperamentCalm => 'آرام';

  @override
  String get temperamentNervous => 'عصبی';

  @override
  String get inspectionSwarmSigns => 'نشانه‌های بچه‌دهی';

  @override
  String get inspectionQueenCells => 'شان ملکه';

  @override
  String get queenCellsNone => 'هیچ';

  @override
  String get queenCellsSwarm => 'بچه‌دهی';

  @override
  String get queenCellsSupersedure => 'جایگزینی آرام';

  @override
  String get queenCellsEmergency => 'اضطراری';

  @override
  String get inspectionDisease => 'مشکوک به بیماری';

  @override
  String get inspectionAnswerNo => 'خیر';

  @override
  String get inspectionAnswerYes => 'بله';

  @override
  String get inspectionActions => 'کارهای امروز';

  @override
  String get inspectionActionSuperAdded => 'طبقه عسل اضافه شد';

  @override
  String get inspectionActionSuperRemoved => 'طبقه عسل برداشته شد';

  @override
  String get inspectionActionFramesAdded => 'قاب اضافه شد';

  @override
  String get inspectionActionFoundationAdded => 'موم آج‌دار داده شد';

  @override
  String get inspectionActionFed => 'تغذیه شد';

  @override
  String get inspectionActionExcluderFitted => 'صفحه ملکه‌گیر گذاشته شد';

  @override
  String get inspectionActionEntranceReduced => 'دریچه پرواز تنگ شد';

  @override
  String get inspectionActionPollenTrapFitted => 'تله گرده گذاشته شد';

  @override
  String get inspectionSave => 'ذخیره';

  @override
  String inspectionSaved(String number) {
    return 'بازدید کندوی $number ذخیره شد';
  }

  @override
  String get inspectionRemindPrompt => 'یادآوری پس از';

  @override
  String inspectionRemindDays(int days) {
    String _temp0 = intl.Intl.pluralLogic(
      days,
      locale: localeName,
      other: '$days روز',
      one: '1 روز',
    );
    return '$_temp0';
  }

  @override
  String get inspectionLoadError => 'باز کردن بازدید ممکن نشد';

  @override
  String get syncTableInspections => 'بازدید';

  @override
  String get signInTagline =>
      'دفترچه زنبورداری‌تان در جیب. بدون اینترنت کار می‌کند.';

  @override
  String get signInEmailLabelLong => 'نشانی ایمیل شما';

  @override
  String get signInEmailHelper =>
      'بدون رمز عبور. یک کد 6 رقمی به نشانی شما می‌فرستیم.';

  @override
  String get signInEmailHint => 'name@example.com';

  @override
  String get signInCodeHeading => 'کد ایمیل را وارد کنید';

  @override
  String get signInPasteCode => 'چسباندن کد';

  @override
  String get signInCodeSpamHint =>
      'نرسید؟ پوشه هرزنامه را ببینید. پس از یک بار ورود، برنامه بدون اینترنت هم باز می‌شود.';

  @override
  String get signInChangeEmail => 'تغییر ایمیل';

  @override
  String get onboardingLanguageCountryTitle => 'زبان و کشور';

  @override
  String get onboardingAppLanguage => 'زبان برنامه';

  @override
  String get onboardingDeviceLanguage => 'زبان دستگاه';

  @override
  String get onboardingCountryLabel => 'کشوری که در آن زنبورداری می‌کنید';

  @override
  String get onboardingCountryChoose => 'انتخاب کشور';

  @override
  String onboardingRegionFeaturesTitle(String country) {
    return 'فعال‌شده برای $country';
  }

  @override
  String onboardingRegionDefaultsTitle(String country) {
    return 'تنظیمات برای $country';
  }

  @override
  String get onboardingRegionDefaultsMessage =>
      'واحدها و ارز از کشور شما پیروی می‌کنند.';

  @override
  String get onboardingBusinessTitle => 'درباره کسب‌وکارتان بگویید';

  @override
  String get regionFeatureAks => 'اطلاعات AKS و ثبت کسب‌وکار';

  @override
  String get regionFeatureSubsidies => 'یادآور یارانه کندو';

  @override
  String get regionFeatureRegulations => 'خلاصه مقررات';

  @override
  String get regionFeatureTrDrugList => 'فهرست داروهای مجاز';

  @override
  String get regionFeatureTrFlora => 'تقویم گل‌دهی ترکیه';

  @override
  String get regionFeatureTrMigrationDocs => 'مدارک زنبورداری کوچ‌رو';

  @override
  String get unitKilogram => 'کیلوگرم';

  @override
  String get unitPound => 'پوند';

  @override
  String get unitCelsius => '°C';

  @override
  String get unitFahrenheit => '°F';

  @override
  String get hemisphereNorthern => 'نیمکره شمالی';

  @override
  String get hemisphereSouthern => 'نیمکره جنوبی';

  @override
  String get relativeToday => 'امروز';

  @override
  String get relativeYesterday => 'دیروز';

  @override
  String relativeDaysAgo(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count روز پیش',
      one: '1 روز پیش',
    );
    return '$_temp0';
  }

  @override
  String apiariesCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count زنبورستان',
      one: '1 زنبورستان',
    );
    return '$_temp0';
  }

  @override
  String apiariesSummary(String apiaries, String hives) {
    return '$apiaries · $hives';
  }

  @override
  String get apiaryHiveCountUnit => 'کندو';

  @override
  String get hiveLayoutGridShort => 'شبکه';

  @override
  String get hiveLayoutListShort => 'فهرست';

  @override
  String apiaryDetailSubtitle(String hives, String visit) {
    return '$hives · $visit';
  }

  @override
  String apiaryDetailSubtitlePlace(String hives, String visit, String place) {
    return '$hives · $visit · $place';
  }

  @override
  String get apiaryBulkFeed => 'تغذیه همه';

  @override
  String get apiaryBulkTreat => 'درمان همه';

  @override
  String get hiveCardKind => 'کندو';

  @override
  String get hiveLastInspection => 'آخرین بازدید';

  @override
  String get hiveLastInspectionNone => 'هنوز نه';

  @override
  String get hiveBulkPreviewTitle => 'پیش‌نمایش';

  @override
  String hiveBulkSaveCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'ساخت $count کندو',
      one: 'ساخت 1 کندو',
    );
    return '$_temp0';
  }

  @override
  String get listEllipsis => '…';

  @override
  String get scanOfflineHint => 'بدون نیاز به اینترنت · هنگام خواندن می‌لرزد';

  @override
  String get titleSeparator => ' ·';

  @override
  String get settingsGeneral => 'عمومی';

  @override
  String get settingsGloveMode => 'حالت دستکش';

  @override
  String get settingsGloveModeHint => 'همه اهداف لمسی یک پله بزرگ‌تر می‌شوند.';

  @override
  String get settingsCountry => 'کشور';

  @override
  String settingsCountryValue(String name, String code) {
    return '$name · $code';
  }

  @override
  String get moreSectionApiary => 'زنبورستان';

  @override
  String get moreSectionBusiness => 'کسب‌وکار';

  @override
  String get moreSectionHelp => 'راهنما';

  @override
  String get galleryFormFields => 'فیلدهای فرم';

  @override
  String get galleryRadioCardGroup => 'کارت‌های انتخاب';

  @override
  String get gallerySegmentedTabs => 'تغییر نما';

  @override
  String get galleryListGroup => 'فهرست گروه‌بندی‌شده';

  @override
  String get galleryNoteCard => 'کارت یادداشت';

  @override
  String get gallerySummaryTile => 'کاشی خلاصه';

  @override
  String get galleryActionTile => 'کاشی‌های عملیات';

  @override
  String get galleryAppLogo => 'نشان و شان';

  @override
  String get gallerySampleApiaryName => 'نام زنبورستان';

  @override
  String get gallerySampleFirstNumber => 'شماره اول';

  @override
  String get gallerySampleNoteHint =>
      'بدون رمز عبور. یک کد 6 رقمی به نشانی شما می‌فرستیم.';

  @override
  String get gallerySampleGrid => 'شبکه';

  @override
  String get gallerySampleList => 'فهرست';

  @override
  String get gallerySampleMap => 'نقشه';

  @override
  String get gallerySampleInspections => 'بازدیدها';

  @override
  String get gallerySampleNoteTitle => 'فعال‌شده برای ترکیه';

  @override
  String get gallerySampleNoteMessage =>
      'اطلاعات AKS و ثبت کسب‌وکار، خلاصه مقررات و فهرست داروهای مجاز.';

  @override
  String get gallerySampleLastInspectionValue => '3 روز پیش';

  @override
  String get gallerySampleFrames => '8 قاب زنبور · 5 نوزاد';

  @override
  String get gallerySampleActiveTreatment => 'درمان جاری';

  @override
  String get gallerySampleDaysLeft => '12 روز مانده';

  @override
  String get syncTableMedia => 'عکس یا یادداشت صوتی';

  @override
  String get mediaTakePhoto => 'گرفتن عکس';

  @override
  String get mediaRecordVoice => 'ضبط یادداشت صوتی';

  @override
  String get mediaStopRecording => 'توقف ضبط';

  @override
  String mediaRecording(String duration) {
    return 'در حال ضبط · $duration';
  }

  @override
  String mediaPhotoAdded(String number) {
    return 'عکس به کندوی $number اضافه شد';
  }

  @override
  String mediaVoiceAdded(String number) {
    return 'یادداشت صوتی به کندوی $number اضافه شد';
  }

  @override
  String get mediaCameraDenied =>
      'اجازه دوربین ندارید. می‌توانید آن را در تنظیمات گوشی مجاز کنید.';

  @override
  String get mediaMicrophoneDenied =>
      'اجازه میکروفون ندارید. می‌توانید آن را در تنظیمات گوشی مجاز کنید.';

  @override
  String get mediaCaptureFailed => 'ذخیره ممکن نشد. دوباره تلاش کنید.';

  @override
  String mediaPhotoCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count عکس',
      one: '1 عکس',
    );
    return '$_temp0';
  }

  @override
  String mediaVoiceCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count یادداشت صوتی',
      one: '1 یادداشت صوتی',
    );
    return '$_temp0';
  }

  @override
  String inspectionMediaAttached(String items) {
    return 'همراه بازدید ذخیره شد: $items';
  }

  @override
  String get timelinePhoto => 'عکس';

  @override
  String get timelineVoiceNote => 'یادداشت صوتی';

  @override
  String get mediaOpenPhoto => 'باز کردن عکس';

  @override
  String get mediaDownloadPhoto =>
      'عکس روی این گوشی نیست. برای دریافت لمس کنید.';

  @override
  String mediaPlay(String duration) {
    return 'پخش · $duration';
  }

  @override
  String get mediaStopPlaying => 'توقف';

  @override
  String get mediaNotUploaded =>
      'هنوز بارگذاری نشده. وقتی گوشی‌ای که آن را گرفته آنلاین شود، می‌رسد.';

  @override
  String get mediaDownloadOffline =>
      'دریافت ممکن نشد. اتصال اینترنت را بررسی کنید.';

  @override
  String get mediaDownloadFailed => 'دریافت ممکن نشد.';

  @override
  String get mediaNotFound => 'عکس پیدا نشد';

  @override
  String get settingsData => 'داده‌ها';

  @override
  String get settingsMediaWifiOnly => 'بارگذاری عکس فقط با Wi‑Fi';

  @override
  String get settingsMediaWifiOnlyHint =>
      'عکس‌ها و یادداشت‌های صوتی از داده همراه استفاده نمی‌کنند.';

  @override
  String settingsPendingUploads(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count فایل در انتظار بارگذاری',
      one: '1 فایل در انتظار بارگذاری',
    );
    return '$_temp0';
  }

  @override
  String get hiveQueenNone => 'ثبت نشده';

  @override
  String get hiveQueenNoneHint => 'برای افزودن ملکه لمس کنید';

  @override
  String queenMarkColorName(String color) {
    String _temp0 = intl.Intl.selectLogic(color, {
      'white': 'سفید',
      'yellow': 'زرد',
      'red': 'قرمز',
      'green': 'سبز',
      'blue': 'آبی',
      'other': 'نامشخص',
    });
    return '$_temp0';
  }

  @override
  String get queenYearUnknown => 'سال نامشخص';

  @override
  String get queenUnmarked => 'بدون علامت';

  @override
  String queenAge(int age) {
    String _temp0 = intl.Intl.pluralLogic(
      age,
      locale: localeName,
      other: '$age ساله',
      one: '1 ساله',
      zero: 'کمتر از یک سال',
    );
    return '$_temp0';
  }

  @override
  String get queenSourceOwnRearing => 'پرورش خودی';

  @override
  String get queenSourcePurchased => 'خریداری‌شده';

  @override
  String get queenSourceCertifiedBreeder => 'پرورش‌دهنده دارای گواهی';

  @override
  String get queenSource => 'منشأ';

  @override
  String get queenMother => 'ملکه مادر';

  @override
  String get queenMotherUnknown => 'نامشخص';

  @override
  String get queenBreed => 'نژاد';

  @override
  String get queenBreedHint => 'مثلاً کارنیکا';

  @override
  String get queenBreedLine => 'لاین';

  @override
  String get queenBreedLineHint => 'مثلاً بوکفست';

  @override
  String get queenWing => 'بال';

  @override
  String get queenWingClipped => 'چیده‌شده';

  @override
  String get queenWingIntact => 'چیده‌نشده';

  @override
  String get queenYear => 'سال';

  @override
  String get queenYearHelper => 'سال تولد یا خرید';

  @override
  String get queenMark => 'رنگ علامت';

  @override
  String queenMarkSuggestion(String year, String color) {
    return 'رنگ $year: $color';
  }

  @override
  String get queenUnknown => 'وارد نشده';

  @override
  String get queenEdit => 'ویرایش ملکه';

  @override
  String get queenReplace => 'تعویض ملکه';

  @override
  String get queenGive => 'افزودن ملکه';

  @override
  String get queenNoneTitle => 'ملکه‌ای ثبت نشده';

  @override
  String get queenNoneMessage =>
      'ملکه‌ای را که به این کندو داده‌اید ثبت کنید؛ سال، رنگ و تبار آن اینجا نمایش داده می‌شود.';

  @override
  String queenFormNewTitle(String number) {
    return 'ملکه جدید · کندو $number';
  }

  @override
  String get queenFormEditTitle => 'ویرایش ملکه';

  @override
  String get queenFormSave => 'ذخیره';

  @override
  String queenGiven(String number) {
    return 'کندوی $number ملکه جدید دارد';
  }

  @override
  String get oldQueensTitle => 'ملکه‌های پیر';

  @override
  String oldQueensIntro(int age) {
    String _temp0 = intl.Intl.pluralLogic(
      age,
      locale: localeName,
      other:
          'ملکه‌های کندوهای فعال که $age سال یا بیشتر دارند. تعویضشان را برنامه‌ریزی کنید.',
    );
    return '$_temp0';
  }

  @override
  String get oldQueensEmptyTitle => 'ملکه پیری نیست';

  @override
  String oldQueensEmptyMessage(int age) {
    String _temp0 = intl.Intl.pluralLogic(
      age,
      locale: localeName,
      other:
          'ملکه‌های کندوهای فعال کمتر از $age سال دارند یا سالشان وارد نشده.',
    );
    return '$_temp0';
  }

  @override
  String get syncTableMiteCounts => 'شمارش واروآ';

  @override
  String get varroaMethodSugarRoll => 'پودر قند';

  @override
  String get varroaMethodAlcoholWash => 'شست‌وشو با الکل';

  @override
  String get varroaMethodStickyBoard => 'سینی چسبنده';

  @override
  String varroaFormTitle(String number) {
    return 'واروآ · کندو $number';
  }

  @override
  String get varroaMethod => 'روش';

  @override
  String get varroaSampleBees => 'زنبورهای نمونه';

  @override
  String get varroaBoardDays => 'روزهای سینی';

  @override
  String get varroaMites => 'کنه‌های شمرده‌شده';

  @override
  String get varroaBoardMites => 'کنه‌های ریخته';

  @override
  String get varroaSave => 'ذخیره';

  @override
  String varroaSaved(String number) {
    return 'شمارش واروآی کندوی $number ذخیره شد';
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

    return '$valueString کنه/روز';
  }

  @override
  String get varroaInfestation => 'آلودگی';

  @override
  String get varroaDailyDrop => 'ریزش روزانه';

  @override
  String get varroaReached => 'به آستانه رسید · درمان را برنامه‌ریزی کنید';

  @override
  String get varroaBelow => 'زیر آستانه';

  @override
  String varroaThresholdNote(String threshold) {
    return 'آستانه $threshold (از تنظیمات).';
  }

  @override
  String get hiveVarroa => 'واروآ';

  @override
  String get hiveVarroaNone => 'هنوز شمارشی نشده';

  @override
  String get hiveVarroaReached => 'به آستانه رسید';

  @override
  String get hiveVarroaCount => 'شمارش واروآ';

  @override
  String varroaChartTitle(String apiary) {
    return '$apiary · شمارش‌های اخیر';
  }

  @override
  String varroaChartThreshold(String threshold) {
    return 'آستانه $threshold';
  }

  @override
  String get varroaChartEmpty =>
      'هنوز شمارشی با پودر قند یا الکل نیست. از کارت یک کندو اضافه کنید.';

  @override
  String varroaChartBar(String day, String value) {
    return '$day: $value';
  }

  @override
  String varroaChartSemantics(String threshold, String bars) {
    return 'میانگین آلودگی روزانه، آستانه $threshold: $bars';
  }

  @override
  String get settingsVarroa => 'واروآ';

  @override
  String get settingsVarroaPercent => 'آستانه آلودگی';

  @override
  String get settingsVarroaPerDay => 'آستانه سینی چسبنده';

  @override
  String get settingsVarroaHint =>
      'وقتی شمارشی به آستانه برسد هشدار نمایش داده می‌شود. فقط روی این گوشی ذخیره می‌شود.';

  @override
  String get syncTableRefDrugs => 'فهرست داروها';

  @override
  String get syncTableDrugs => 'دارو';

  @override
  String get syncTableTreatments => 'درمان';

  @override
  String get syncTableFeedings => 'تغذیه';

  @override
  String get drugIngredientAmitraz => 'آمیتراز';

  @override
  String get drugIngredientOxalicAcid => 'اسید اگزالیک';

  @override
  String get drugIngredientFormicAcid => 'اسید فرمیک';

  @override
  String get drugIngredientThymol => 'تیمول';

  @override
  String get drugIngredientFlumethrin => 'فلومترین';

  @override
  String get drugIngredientTauFluvalinate => 'تاو-فلوالینات';

  @override
  String get drugIngredientCoumaphos => 'کومافوس';

  @override
  String get drugIngredientLacticAcid => 'اسید لاکتیک';

  @override
  String get drugIngredientOther => 'دیگر';

  @override
  String get drugUnitStrip => 'نوار';

  @override
  String get drugUnitMl => 'میلی‌لیتر';

  @override
  String get drugUnitG => 'گرم';

  @override
  String get drugUnitDose => 'دوز';

  @override
  String get hiveTreat => 'انجام درمان';

  @override
  String get treatmentFormTitle => 'درمان';

  @override
  String treatmentScopeHive(String number) {
    return 'کندو $number';
  }

  @override
  String treatmentScopeApiary(int count) {
    return 'کل زنبورستان · $count';
  }

  @override
  String get treatmentChooseDrug => 'انتخاب دارو';

  @override
  String get treatmentChangeDrug => 'تغییر';

  @override
  String treatmentDrugIngredient(String ingredient) {
    return 'ماده مؤثر: $ingredient';
  }

  @override
  String treatmentDrugLicense(String number) {
    return 'مجوز $number';
  }

  @override
  String get treatmentDrugCustom => 'داروی شما';

  @override
  String get treatmentAddDrug => 'افزودن داروی جدید';

  @override
  String get drugInfoOpen => 'اطلاعات دارو';

  @override
  String get drugInfoSourceTitle => 'منبع: وزارت کشاورزی و جنگلداری ترکیه';

  @override
  String get drugInfoSourceMessage =>
      'این اطلاعات از بروشور تأییدشده وزارتخانه گرفته شده و همان‌طور که منتشر شده به ترکی نمایش داده می‌شود. پیش از مصرف برچسب را بخوانید؛ اگر مطمئن نیستید از دامپزشک بپرسید.';

  @override
  String get drugInfoActiveIngredient => 'ماده مؤثر';

  @override
  String get drugInfoIndications => 'موارد مصرف';

  @override
  String get drugInfoUsage => 'مصرف و دفعات';

  @override
  String get drugInfoUsageMethod => 'روش مصرف';

  @override
  String get drugInfoUsageMethodAndDose => 'روش مصرف و دوز';

  @override
  String get drugInfoUsageDiagnosis => 'برای تشخیص';

  @override
  String get drugInfoUsageDose => 'دوز';

  @override
  String get drugInfoUsageFrequency => 'دفعات';

  @override
  String get drugInfoUsageDuration => 'مدت';

  @override
  String get drugInfoUsageOther => 'یادداشت';

  @override
  String get drugInfoSuitablePeriods => 'دوره‌های مناسب';

  @override
  String get drugInfoAvoidPeriods => 'مصرف نکنید';

  @override
  String get drugInfoWithdrawal => 'دوره انتظار';

  @override
  String get drugInfoWarnings => 'هشدارها';

  @override
  String get drugInfoClose => 'بستن';

  @override
  String get treatmentBatchNo => 'شماره سری';

  @override
  String get treatmentStartedOn => 'شروع';

  @override
  String treatmentDose(String unit) {
    return 'دوز برای هر کندو ($unit)';
  }

  @override
  String treatmentDoseTotal(String total, String unit) {
    return 'مجموع $total $unit';
  }

  @override
  String get treatmentWithdrawalDays => 'دوره انتظار (روز)';

  @override
  String get treatmentRemoval => 'برداشتن';

  @override
  String get treatmentRemovalNone => 'هیچ';

  @override
  String get treatmentRemovalChange => 'یادآوری همان صبح؛ برای تغییر لمس کنید';

  @override
  String get treatmentRemovalSingle => 'مصرف یک‌باره؛ برای تعیین لمس کنید';

  @override
  String get treatmentRemovalClear => 'بدون برداشتن (مصرف یک‌باره)';

  @override
  String get treatmentNoSuper => 'بدون طبقه عسل';

  @override
  String treatmentNoSuperUntil(String date) {
    return 'تا $date';
  }

  @override
  String treatmentNoSuperAfterRemoval(int days) {
    String _temp0 = intl.Intl.pluralLogic(
      days,
      locale: localeName,
      other: 'برداشتن + $days روز انتظار',
      one: 'برداشتن + 1 روز انتظار',
      zero: 'بدون انتظار پس از برداشتن',
    );
    return '$_temp0';
  }

  @override
  String treatmentNoSuperAfterStart(int days) {
    String _temp0 = intl.Intl.pluralLogic(
      days,
      locale: localeName,
      other: 'شروع + $days روز انتظار',
      one: 'شروع + 1 روز انتظار',
      zero: 'بدون انتظار',
    );
    return '$_temp0';
  }

  @override
  String treatmentSave(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'ذخیره برای $count کندو',
      one: 'ذخیره',
    );
    return '$_temp0';
  }

  @override
  String treatmentSaved(String number) {
    return 'درمان کندوی $number ذخیره شد';
  }

  @override
  String treatmentSavedMany(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'درمان برای $count کندو ذخیره شد',
      one: 'درمان برای 1 کندو ذخیره شد',
    );
    return '$_temp0';
  }

  @override
  String get drugFormTitle => 'داروی جدید';

  @override
  String get drugName => 'نام';

  @override
  String get drugActiveIngredient => 'ماده مؤثر';

  @override
  String get drugDoseUnit => 'واحد دوز';

  @override
  String get drugWithdrawalDays => 'دوره انتظار روی برچسب (روز)';

  @override
  String get drugSave => 'افزودن دارو';

  @override
  String get withdrawalLockTitle => 'در دوره انتظار.';

  @override
  String withdrawalLockMessage(String number, String product, String date) {
    return 'کندوی $number با $product درمان می‌شود. پیش از $date نباید طبقه عسل گذاشته شود؛ عسل این دوره ممکن است بقایای دارو داشته باشد.';
  }

  @override
  String get withdrawalDaysLeft => 'مانده';

  @override
  String withdrawalDays(int days) {
    String _temp0 = intl.Intl.pluralLogic(
      days,
      locale: localeName,
      other: '$days روز',
      one: '1 روز',
    );
    return '$_temp0';
  }

  @override
  String get withdrawalApplied => 'مصرف‌شده';

  @override
  String get withdrawalReasonPrompt =>
      'برای ذخیره با این حال، دلیلی انتخاب کنید';

  @override
  String get withdrawalReasonRemovedEarly => 'دارو زودتر برداشته شد';

  @override
  String get withdrawalReasonNotForSale =>
      'طبقه عسل فروخته نمی‌شود (مصرف شخصی/تغذیه)';

  @override
  String get withdrawalCancel => 'لغو، طبقه عسل نگذارید';

  @override
  String get withdrawalProceed => 'با این حال ذخیره شود';

  @override
  String inspectionWithdrawalOverride(String reason) {
    return 'طبقه عسل در دوره انتظار گذاشته شد: $reason';
  }

  @override
  String timelineTreatment(String product) {
    return 'درمان · $product';
  }

  @override
  String timelineTreatmentBatch(String batch) {
    return 'سری $batch';
  }

  @override
  String treatmentDoseValue(String dose, String unit) {
    return '$dose $unit';
  }

  @override
  String timelineTreatmentRemoval(String date) {
    return 'برداشتن $date';
  }

  @override
  String timelineTreatmentWithdrawal(int days) {
    String _temp0 = intl.Intl.pluralLogic(
      days,
      locale: localeName,
      other: '$days روز انتظار',
      one: '1 روز انتظار',
    );
    return '$_temp0';
  }

  @override
  String get hiveActiveTreatment => 'درمان جاری';

  @override
  String get hiveActiveTreatmentNone => 'هیچ';

  @override
  String hiveActiveTreatmentLeft(int days) {
    String _temp0 = intl.Intl.pluralLogic(
      days,
      locale: localeName,
      other: '$days روز مانده',
      one: '1 روز مانده',
    );
    return '$_temp0';
  }

  @override
  String hiveActiveTreatmentDetail(String ingredient) {
    return '$ingredient · بدون طبقه عسل';
  }

  @override
  String get treatmentRotationTitle => 'همان ماده مؤثر.';

  @override
  String treatmentRotationMessage(int count, String ingredient) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other:
          '$count درمان آخر این زنبورستان هم با $ingredient بوده‌اند. برای محدود کردن مقاومت، ماده مؤثر دیگری را در نظر بگیرید.',
    );
    return '$_temp0';
  }

  @override
  String get treatmentPrescriptionAdd => 'افزودن عکس نسخه / فاکتور';

  @override
  String get treatmentPrescriptionAdded => 'عکس نسخه اضافه شد';

  @override
  String get treatmentPrescriptionRemove => 'حذف';

  @override
  String get reminderChannelName => 'یادآورها';

  @override
  String get treatmentReminderDenied =>
      'اعلان‌ها خاموش است؛ یادآور برداشتن تنظیم نشد.';

  @override
  String get hiveFeed => 'تغذیه';

  @override
  String get feedingFormTitle => 'تغذیه';

  @override
  String feedingScopeHive(String number) {
    return 'کندو $number';
  }

  @override
  String feedingScopeApiary(int count) {
    return 'کل زنبورستان · $count';
  }

  @override
  String get feedingKind => 'نوع';

  @override
  String get feedingKindSyrup1to1 => 'شربت 1:1 · تحریکی';

  @override
  String get feedingKindSyrup2to1 => 'شربت 2:1 · زمستانی';

  @override
  String get feedingKindBeeCake => 'خمیر قندی';

  @override
  String get feedingKindPollenSubstitute => 'جایگزین گرده';

  @override
  String feedingAmount(String unit) {
    return 'برای هر کندو ($unit)';
  }

  @override
  String get feedingSuperHiveTitle => 'این کندو طبقه عسل دارد.';

  @override
  String get feedingSuperHiveMessage => 'ممکن است شربت به عسل راه یابد.';

  @override
  String feedingSuperSkippedTitle(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count کندو طبقه عسل دارند',
      one: '1 کندو طبقه عسل دارد',
    );
    return '$_temp0';
  }

  @override
  String feedingSuperSkippedMessage(String numbers) {
    return '($numbers). کنار گذاشته شدند تا شربت به عسل راه نیابد.';
  }

  @override
  String get feedingPrepare => 'برای آماده‌سازی';

  @override
  String feedingPrepareCount(int count, String amount, String unit) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count کندو × $amount $unit',
      one: '1 کندو × $amount $unit',
    );
    return '$_temp0';
  }

  @override
  String feedingTotalSyrup(String amount, String unit) {
    return '$amount $unit شربت';
  }

  @override
  String feedingTotalBeeCake(String amount, String unit) {
    return '$amount $unit خمیر قندی';
  }

  @override
  String feedingTotalPollenSubstitute(String amount, String unit) {
    return '$amount $unit جایگزین گرده';
  }

  @override
  String get feedingSugar => 'شکر';

  @override
  String get feedingWater => 'آب';

  @override
  String feedingApprox(String amount, String unit) {
    return '≈ $amount $unit';
  }

  @override
  String feedingSave(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'ذخیره برای $count کندو',
      one: 'ذخیره',
      zero: 'کندویی برای تغذیه نیست',
    );
    return '$_temp0';
  }

  @override
  String feedingSaved(String number) {
    return 'تغذیه کندوی $number ذخیره شد';
  }

  @override
  String feedingSavedMany(int count) {
    return 'تغذیه برای $count کندو ذخیره شد';
  }

  @override
  String get unitLiter => 'لیتر';

  @override
  String get unitGallon => 'گالن';

  @override
  String get syncTableTasks => 'کار';

  @override
  String get tasksTabToday => 'امروز';

  @override
  String get tasksTabWeek => 'این هفته';

  @override
  String get tasksTabApiary => 'بر اساس زنبورستان';

  @override
  String get tasksAdd => 'افزودن کار';

  @override
  String tasksOverdue(int count) {
    return 'عقب‌افتاده · $count';
  }

  @override
  String tasksDayGroup(String day, int count) {
    return '$day · $count';
  }

  @override
  String get tasksToday => 'امروز';

  @override
  String get tasksTomorrow => 'فردا';

  @override
  String get tasksNoApiary => 'بدون زنبورستان';

  @override
  String tasksApiaryGroup(String apiary, int count) {
    return '$apiary · $count';
  }

  @override
  String get tasksEmptyTodayTitle => 'امروز کاری نیست';

  @override
  String get tasksEmptyWeekTitle => 'این هفته کاری نیست';

  @override
  String get tasksEmptyAddHint => 'کار جدید را با + در گوشه بالا اضافه کنید.';

  @override
  String get tasksLoadError => 'بارگیری کارها ممکن نشد.';

  @override
  String tasksWeekDaySemantics(String day, int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count کار',
      one: '1 کار',
      zero: 'بدون کار',
    );
    return '$day، $_temp0';
  }

  @override
  String taskOverdueDays(int days) {
    String _temp0 = intl.Intl.pluralLogic(
      days,
      locale: localeName,
      other: '$days روز عقب‌افتاده',
      one: '1 روز عقب‌افتاده',
    );
    return '$_temp0';
  }

  @override
  String get taskSourceInspection => 'از بازدید';

  @override
  String get taskSourceTreatment => 'درمان';

  @override
  String taskInspectionTitle(String number) {
    return 'کندو $number · بررسی دوباره';
  }

  @override
  String get taskInspectionTitleNoHive => 'بررسی دوباره';

  @override
  String taskTreatmentTitle(String number) {
    return 'کندو $number · برداشتن نوارها';
  }

  @override
  String get taskTreatmentTitleApiary => 'برداشتن نوارها';

  @override
  String get taskReminderBody => 'موعد کارتان رسیده است.';

  @override
  String get taskAssigneeMe => 'من';

  @override
  String taskAssignedTo(String name) {
    return 'واگذارشده به $name';
  }

  @override
  String taskMemberNumbered(String role, int index) {
    return '$role $index';
  }

  @override
  String get roleOwner => 'مالک';

  @override
  String get rolePartner => 'شریک';

  @override
  String get roleWorker => 'کارگر';

  @override
  String get roleViewer => 'بیننده';

  @override
  String taskCompleteAction(String title) {
    return 'انجام: $title';
  }

  @override
  String get taskCompleted => 'کار انجام شد';

  @override
  String get taskFormNewTitle => 'کار جدید';

  @override
  String get taskFormEditTitle => 'ویرایش کار';

  @override
  String get taskFormName => 'کار';

  @override
  String get taskFormNameHint => 'مثلاً سر زدن به زنبورستان ییلاق';

  @override
  String get taskFormDue => 'موعد';

  @override
  String get taskFormPickDate => 'روز دیگر';

  @override
  String get taskFormTime => 'ساعت';

  @override
  String get taskFormApiary => 'زنبورستان';

  @override
  String get taskFormHive => 'کندو';

  @override
  String get taskFormNone => 'هیچ';

  @override
  String get taskFormChooseApiary => 'انتخاب زنبورستان';

  @override
  String get taskFormChooseHive => 'انتخاب کندو';

  @override
  String get taskFormAssignee => 'واگذارشده به';

  @override
  String get taskFormUnassigned => 'واگذارنشده';

  @override
  String get taskFormCompleted => 'انجام‌شده';

  @override
  String get taskFormSave => 'ذخیره';

  @override
  String get taskFormDelete => 'حذف کار';

  @override
  String get taskDeleteTitle => 'این کار حذف شود؟';

  @override
  String get taskDeleteMessage => 'کار از همه گوشی‌ها حذف می‌شود.';

  @override
  String get taskDeleteConfirm => 'حذف';

  @override
  String get taskSaved => 'کار ذخیره شد';

  @override
  String get taskDeleted => 'کار حذف شد';

  @override
  String get taskNotFound => 'کار پیدا نشد؛ ممکن است حذف شده باشد.';

  @override
  String get taskReminderDenied =>
      'اعلان‌ها خاموش است؛ یادآور به صدا درنمی‌آید.';

  @override
  String get exactAlarmTitle => 'یادآورها دقیقاً سر وقت به صدا درآیند؟';

  @override
  String get exactAlarmMessage =>
      'اندروید ممکن است برای صرفه‌جویی در باتری، اعلان‌ها را چند دقیقه عقب بیندازد. در تنظیماتی که باز می‌شود Mobil Arıcı را مجاز کنید تا یادآور کارها دقیقاً سر وقت به صدا درآیند. اینترنت لازم نیست.';

  @override
  String get exactAlarmConfirm => 'باز کردن تنظیمات';

  @override
  String get settingsReminders => 'یادآورها';

  @override
  String get settingsExactAlarms => 'دقیقاً سر وقت';

  @override
  String get settingsExactAlarmsOn => 'روشن';

  @override
  String get settingsExactAlarmsOff => 'خاموش · ممکن است چند دقیقه دیر شود';

  @override
  String weatherTemperature(String value) {
    return '$value°';
  }

  @override
  String weatherForecastAsOf(String time) {
    return 'پیش‌بینی ساعت $time';
  }

  @override
  String get weatherNoLocationTitle => 'بدون موقعیت';

  @override
  String get weatherNoLocationAction => 'برای آب‌وهوا موقعیت اضافه کنید';

  @override
  String get weatherPendingHint => 'وقتی آنلاین شوید می‌رسد';

  @override
  String weatherWind(String speed) {
    return 'باد $speed';
  }

  @override
  String weatherSpeed(String value, String unit) {
    return '$value $unit';
  }

  @override
  String get unitKmh => 'کیلومتر/ساعت';

  @override
  String get unitMph => 'مایل/ساعت';

  @override
  String weatherPercent(String value) {
    return '$value%';
  }

  @override
  String weatherTemperatureRange(String max, String min) {
    return '$max / $min';
  }

  @override
  String get hiveOpeningRain => 'باران';

  @override
  String get hiveOpeningWind => 'بادی';

  @override
  String get hiveOpeningCold => 'سرد';

  @override
  String get hiveOpeningDaySuitable => 'مناسب';

  @override
  String get weatherConditionSunny => 'آفتابی';

  @override
  String get weatherConditionPartlyCloudy => 'نیمه‌ابری';

  @override
  String get weatherConditionCloudy => 'ابری';

  @override
  String get weatherConditionRainy => 'بارانی';

  @override
  String get weatherConditionWindy => 'بادی';

  @override
  String get weatherConditionOther => 'برف، مه یا طوفان';

  @override
  String get weatherConditionFog => 'مه‌آلود';

  @override
  String get weatherConditionThunder => 'رعدوبرق';

  @override
  String get weatherConditionSleet => 'برف و باران';

  @override
  String get weatherConditionSnow => 'برف';

  @override
  String weatherFeelsLike(String condition, String value) {
    return '$condition · احساس $value';
  }

  @override
  String get weatherWindLabel => 'باد';

  @override
  String get weatherHumidityLabel => 'رطوبت';

  @override
  String get weatherPrecipitationLabel => 'باران';

  @override
  String get weatherScreenTitle => 'آب‌وهوای زنبورستان';

  @override
  String weatherScreenSubtitle(String place, String days) {
    return '$place · پیش‌بینی $days روزه';
  }

  @override
  String weatherScreenSubtitleNoPlace(String days) {
    return 'پیش‌بینی $days روزه';
  }

  @override
  String weatherUpdatedAt(String time) {
    return 'به‌روز شده $time';
  }

  @override
  String get weatherNow => 'اکنون';

  @override
  String get weatherToday => 'امروز';

  @override
  String get weatherColumnDay => 'روز';

  @override
  String get weatherColumnTemperature => 'دما';

  @override
  String get weatherColumnPrecipitation => 'باران';

  @override
  String get weatherColumnHive => 'کندوها';

  @override
  String get weatherTodaySuitable => 'روز خوبی برای باز کردن کندوهاست';

  @override
  String get weatherTodayRain => 'امروز باران است؛ روز باز کردن کندو نیست';

  @override
  String get weatherTodayWind => 'امروز باد است؛ روز باز کردن کندو نیست';

  @override
  String get weatherTodayCold => 'امروز سرد است؛ روز باز کردن کندو نیست';

  @override
  String weatherDayRange(String from, String to) {
    return '$from–$to';
  }

  @override
  String weatherPlanRain(String days) {
    return 'باران در $days.';
  }

  @override
  String weatherPlanWind(String days) {
    return 'باد در $days.';
  }

  @override
  String weatherPlanMove(String weekday) {
    String _temp0 = intl.Intl.selectLogic(weekday, {
      'monday': 'بازدیدها را به دوشنبه منتقل کنید.',
      'tuesday': 'بازدیدها را به سه‌شنبه منتقل کنید.',
      'wednesday': 'بازدیدها را به چهارشنبه منتقل کنید.',
      'thursday': 'بازدیدها را به پنجشنبه منتقل کنید.',
      'friday': 'بازدیدها را به جمعه منتقل کنید.',
      'saturday': 'بازدیدها را به شنبه منتقل کنید.',
      'other': 'بازدیدها را به یکشنبه منتقل کنید.',
    });
    return '$_temp0';
  }

  @override
  String get weatherPlanAction => 'برنامه‌ریزی';

  @override
  String weatherPlanTaskTitle(String apiary) {
    return 'بازدید $apiary';
  }

  @override
  String weatherThresholdsHint(
    String temperature,
    String wind,
    String precipitation,
  ) {
    return 'مناسب برای باز کردن: بالای $temperature، باد زیر $wind، احتمال باران زیر $precipitation. آستانه‌ها را در تنظیمات می‌توانید تغییر دهید.';
  }

  @override
  String get weatherEmptyTitle => 'هنوز پیش‌بینی نیست';

  @override
  String get weatherEmptyMessage =>
      'پیش‌بینی این زنبورستان هنوز دریافت نشده. وقتی آنلاین شدید به‌روز کنید.';

  @override
  String get weatherNoLocationMessage =>
      'این زنبورستان موقعیت ندارد. برای دریافت پیش‌بینی یکی اضافه کنید.';

  @override
  String get weatherRefresh => 'به‌روزرسانی';

  @override
  String get weatherRefreshFailed =>
      'دریافت پیش‌بینی ممکن نشد. اتصال اینترنت را بررسی کنید.';

  @override
  String get weatherApiaryNotFound => 'زنبورستان پیدا نشد';

  @override
  String get weatherAttributionPrefix => 'Powered by';

  @override
  String get weatherAttributionLink => 'WeatherAPI.com';

  @override
  String get settingsHiveOpening => 'آستانه‌های باز کردن کندو';

  @override
  String get settingsHiveOpeningTemperature => 'دما';

  @override
  String settingsHiveOpeningTemperatureValue(String value) {
    return 'بالای $value';
  }

  @override
  String get settingsHiveOpeningWind => 'باد';

  @override
  String get settingsHiveOpeningPrecipitation => 'احتمال باران';

  @override
  String settingsHiveOpeningBelow(String value) {
    return 'زیر $value';
  }

  @override
  String get settingsHiveOpeningHint =>
      'صفحه آب‌وهوا و کارت‌های امروز بر اساس این آستانه‌ها «مناسب» می‌گویند. فقط روی این گوشی ذخیره می‌شود.';

  @override
  String get hiveOpeningSuitable => 'مناسب برای باز کردن';

  @override
  String get todayGreetingMorning => 'صبح بخیر';

  @override
  String get todayGreetingAfternoon => 'روز بخیر';

  @override
  String get todayGreetingEvening => 'عصر بخیر';

  @override
  String get todayAttentionTitle => 'نیازمند توجه';

  @override
  String todayAttentionHiveCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count کندو',
      one: '1 کندو',
    );
    return '$_temp0';
  }

  @override
  String get todayAttentionNone => 'هیچ کندویی نیازمند توجه نیست';

  @override
  String get todayTasksTitle => 'امروز';

  @override
  String todayTasksCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count کار',
      one: '1 کار',
    );
    return '$_temp0';
  }

  @override
  String todayTasksApiaryCount(String apiary, int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count کار',
      one: '1 کار',
    );
    return '$apiary · $_temp0';
  }

  @override
  String todaySetupProgress(int done, int total) {
    return 'راه‌اندازی $done/$total';
  }

  @override
  String get setupStepApiary => 'زنبورستان را اضافه کنید';

  @override
  String get setupStepHives => 'کندوها را بسازید';

  @override
  String get setupStepInspection => 'اولین بازدید را انجام دهید';

  @override
  String setupStepDone(String step) {
    return '$step: انجام شد';
  }

  @override
  String get attentionQueenless => 'بی‌ملکه';

  @override
  String get attentionWeak => 'ضعیف';

  @override
  String get attentionSwarming => 'نشانه بچه‌دهی';

  @override
  String get attentionTreatmentRemoval => 'درمانِ برداشتنی';

  @override
  String get attentionQueenlessTitle => 'کندوهای بی‌ملکه';

  @override
  String get attentionWeakTitle => 'کندوهای ضعیف';

  @override
  String get attentionSwarmingTitle => 'کندوهای دارای نشانه بچه‌دهی';

  @override
  String get attentionTreatmentRemovalTitle => 'درمان‌های برداشتنی';

  @override
  String get attentionQueenlessIntro =>
      'کندوهای فعالی که در آخرین بازدید نه ملکه و نه تخم در آن‌ها دیده شد.';

  @override
  String attentionWeakIntro(int max) {
    return 'کندوهای فعال با قدرت $max/5 یا کمتر در آخرین بازدید.';
  }

  @override
  String get attentionSwarmingIntro =>
      'کندوهای فعالی که در آخرین بازدید نشانه بچه‌دهی یا شان ملکه بچه‌دهی داشتند.';

  @override
  String get attentionTreatmentRemovalIntro =>
      'کندوهایی که موعد برداشتن نوارهایشان رسیده و کار هنوز انجام نشده.';

  @override
  String get attentionEmpty => 'در این گروه کندویی نیست.';

  @override
  String attentionLastInspection(String date) {
    return 'آخرین بازدید: $date';
  }

  @override
  String attentionRemovalDue(String date) {
    return 'موعد برداشتن: $date';
  }

  @override
  String get syncTableHarvests => 'برداشت';

  @override
  String get syncTableHarvestHives => 'کندوی برداشت‌شده';

  @override
  String withdrawalLockHarvestMessage(
    String number,
    String product,
    String date,
  ) {
    return 'کندوی $number با $product درمان می‌شود. پیش از $date نباید برداشت شود؛ عسل این دوره ممکن است بقایای دارو داشته باشد.';
  }

  @override
  String get withdrawalReasonNotForSaleHarvest =>
      'عسل فروخته نمی‌شود (مصرف شخصی/تغذیه)';

  @override
  String get withdrawalHarvestCancel => 'لغو، برداشت نکنید';

  @override
  String get withdrawalHarvestProceed => 'با این حال برداشت شود';

  @override
  String get apiaryHarvest => 'برداشت';

  @override
  String harvestFormTitle(String apiary) {
    return 'برداشت · $apiary';
  }

  @override
  String harvestSelectedCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count کندو انتخاب شده',
      one: '1 کندو انتخاب شده',
      zero: 'کندویی انتخاب نشده',
    );
    return '$_temp0';
  }

  @override
  String harvestSelectedHint(String numbers) {
    return '$numbers · برای تغییر لمس کنید یا برای افزودن اسکن کنید';
  }

  @override
  String get harvestSelectedEmptyHint =>
      'برای انتخاب کندوها لمس کنید یا اسکن کنید';

  @override
  String get harvestScan => 'اسکن';

  @override
  String harvestLockedTitle(String numbers) {
    return '$numbers در دوره انتظار.';
  }

  @override
  String get harvestLockedMessage =>
      'برداشت نشدند. برای برداشت با این حال، آن را در فهرست کندوها انتخاب کنید.';

  @override
  String get harvestDate => 'تاریخ';

  @override
  String get harvestToday => 'امروز';

  @override
  String get harvestYesterday => 'دیروز';

  @override
  String get harvestPickDate => 'روز دیگر';

  @override
  String get harvestHoneyKind => 'نوع عسل';

  @override
  String get honeyKindPine => 'کاج';

  @override
  String get honeyKindFlower => 'گل';

  @override
  String get honeyKindChestnut => 'شاه‌بلوط';

  @override
  String get honeyKindCitrus => 'مرکبات';

  @override
  String get honeyKindOther => 'دیگر';

  @override
  String get harvestUnit => 'برداشت به صورت';

  @override
  String get harvestUnitSuper => 'طبقه';

  @override
  String get harvestUnitFrame => 'قاب';

  @override
  String get harvestTakenSupers => 'طبقه‌های برداشت‌شده';

  @override
  String get harvestTakenFrames => 'قاب‌های برداشت‌شده';

  @override
  String harvestWeight(String unit) {
    return 'عسل استخراج‌شده ($unit)';
  }

  @override
  String get harvestWeightInvalid => 'وزنی مانند 574 یا 574.5 وارد کنید';

  @override
  String harvestWeightTooLarge(String max, String unit) {
    return 'حداکثر $max $unit';
  }

  @override
  String get harvestPerHive => 'برای هر کندو';

  @override
  String harvestWeightValue(String value, String unit) {
    return '$value $unit';
  }

  @override
  String harvestSave(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'ذخیره برداشت',
      zero: 'کندویی برای برداشت نیست',
    );
    return '$_temp0';
  }

  @override
  String harvestSaved(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'برداشت برای $count کندو ذخیره شد',
      one: 'برداشت برای 1 کندو ذخیره شد',
    );
    return '$_temp0';
  }

  @override
  String get harvestHivesTitle => 'کندوهای برداشت';

  @override
  String get harvestSelectAll => 'انتخاب همه';

  @override
  String get harvestSelectNone => 'لغو انتخاب همه';

  @override
  String harvestHiveLocked(int days) {
    String _temp0 = intl.Intl.pluralLogic(
      days,
      locale: localeName,
      other: '$days روز',
      one: '1 روز',
    );
    return 'انتظار · $_temp0 مانده';
  }

  @override
  String harvestHiveOverridden(String reason) {
    return 'با این حال برداشت شد: $reason';
  }

  @override
  String get harvestHivesDone => 'تمام';

  @override
  String get harvestNoActiveHives => 'این زنبورستان کندوی فعال ندارد.';

  @override
  String get harvestScanTitle => 'اسکن برای برداشت';

  @override
  String harvestScanAdded(String number) {
    return 'کندوی $number اضافه شد';
  }

  @override
  String harvestScanAlready(String number) {
    return 'کندوی $number از قبل انتخاب شده';
  }

  @override
  String harvestScanOtherApiary(String number) {
    return 'کندوی $number در این زنبورستان نیست';
  }

  @override
  String harvestScanInactive(String number) {
    return 'کندوی $number فعال نیست';
  }

  @override
  String get harvestScanUnknown => 'این برچسب به هیچ کندویی وصل نیست';

  @override
  String harvestScanDone(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'تمام · $count کندو',
      one: 'تمام · 1 کندو',
      zero: 'تمام',
    );
    return '$_temp0';
  }

  @override
  String get apiaryTourStart => 'شروع گشت';

  @override
  String get apiaryTourResume => 'ادامه گشت';

  @override
  String get tourReplaceTitle => 'گشت جاری تمام شود؟';

  @override
  String tourReplaceMessage(String apiary) {
    return 'گشت $apiary هنوز در جریان است. شروع گشت جدید پیشرفت آن را پاک می‌کند؛ بازدیدها ذخیره می‌مانند.';
  }

  @override
  String get tourReplaceConfirm => 'شروع گشت جدید';

  @override
  String tourTitle(String apiary) {
    return 'گشت $apiary';
  }

  @override
  String get tourFinish => 'پایان گشت';

  @override
  String tourProgress(int done, int total) {
    return '$done / $total';
  }

  @override
  String tourProgressLabel(int done, int total) {
    return '$done از $total کندو انجام شد';
  }

  @override
  String tourMinutes(int minutes) {
    return '$minutes دقیقه';
  }

  @override
  String tourHoursMinutes(int hours, int minutes) {
    return '$hours ساعت $minutes دقیقه';
  }

  @override
  String tourElapsedLabel(String duration) {
    return 'زمان گذشته: $duration';
  }

  @override
  String get tourNext => 'بعدی';

  @override
  String tourPreviousVisit(String date) {
    return 'دفعه قبل · $date';
  }

  @override
  String get tourQueue => 'ترتیب';

  @override
  String tourSkippedCount(int count) {
    return '$count رد شد';
  }

  @override
  String get tourStateDone => 'انجام‌شده';

  @override
  String get tourStateSkipped => 'ردشده';

  @override
  String get tourStatePending => 'در انتظار';

  @override
  String get tourStateNext => 'بعدی';

  @override
  String tourHiveSemantics(String number, String state) {
    return 'کندو $number، $state';
  }

  @override
  String get tourSkip => 'رد شدن';

  @override
  String tourInspect(String number) {
    return 'بازدید $number';
  }

  @override
  String get tourAllDone => 'همه کندوها بازدید شدند.';

  @override
  String get tourSunSuggestion =>
      'حالت آفتاب خواندن صفحه را در نور شدید آسان‌تر می‌کند.';

  @override
  String get tourSunOn => 'روشن کردن حالت آفتاب';

  @override
  String get tourSunMode => 'حالت آفتاب';

  @override
  String get tourFinishTitle => 'گشت تمام شود؟';

  @override
  String tourFinishMessage(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count کندو بازدید نشده‌اند؛ در خلاصه ردشده حساب می‌شوند.',
      one: '1 کندو بازدید نشده؛ در خلاصه ردشده حساب می‌شود.',
    );
    return '$_temp0';
  }

  @override
  String get tourNotFound => 'در این زنبورستان گشتی در جریان نیست.';

  @override
  String get tourCompleteTitle => 'گشت کامل شد';

  @override
  String tourInspectedCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count کندو بازدید شد',
      one: '1 کندو بازدید شد',
    );
    return '$_temp0';
  }

  @override
  String get tourHealthy => 'قوی / متوسط';

  @override
  String get tourTasksTitle => 'کارها';

  @override
  String tourTaskRequeen(String numbers) {
    return 'تعویض ملکه: $numbers';
  }

  @override
  String tourTaskFeedWeak(String numbers) {
    return 'تغذیه با شربت 1:1: $numbers';
  }

  @override
  String tourTaskSwarmCheck(String numbers) {
    return 'بررسی بچه‌دهی: $numbers';
  }

  @override
  String tourTaskRevisit(String numbers) {
    return 'بررسی کندوهای ردشده: $numbers';
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
      other: '$days روز دیگر',
      one: 'فردا',
      zero: 'امروز',
    );
    return '$_temp0';
  }

  @override
  String tourSaveTasks(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'ذخیره کارها',
      one: 'ذخیره کار',
      zero: 'بستن',
    );
    return '$_temp0';
  }

  @override
  String tourTasksSaved(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count کار ذخیره شد',
      one: '1 کار ذخیره شد',
    );
    return '$_temp0';
  }

  @override
  String get tourNoTasks => 'کاری برای پیشنهاد نیست.';

  @override
  String get reportsTitle => 'گزارش‌ها';

  @override
  String get reportTreatmentRegister => 'دفتر درمان';

  @override
  String get reportTreatmentRegisterHint => 'برای بازرسی‌ها';

  @override
  String get reportHiveHistory => 'تاریخچه کندو';

  @override
  String get reportHiveHistoryHint => 'یک کندو یا یک زنبورستان';

  @override
  String get reportFrom => 'از';

  @override
  String get reportTo => 'تا';

  @override
  String get reportApiary => 'زنبورستان';

  @override
  String get reportAllApiaries => 'همه زنبورستان‌ها';

  @override
  String get reportHive => 'کندو';

  @override
  String get reportAllHives => 'همه کندوها';

  @override
  String get reportLanguage => 'زبان PDF';

  @override
  String get reportRegistrationNo => 'شماره ثبت واحد';

  @override
  String get reportAksNo => 'شماره AKS';

  @override
  String get reportRecordNo => 'شماره ثبت';

  @override
  String get reportNumbersHelper =>
      'فقط در سربرگ PDF چاپ می‌شود؛ ذخیره نمی‌شود.';

  @override
  String get reportShare => 'اشتراک‌گذاری';

  @override
  String get reportCreate => 'ساخت PDF';

  @override
  String get reportPreparing => 'در حال آماده‌سازی PDF…';

  @override
  String get reportError => 'ساخت PDF ممکن نشد. دوباره تلاش کنید.';

  @override
  String get reportLoadError => 'خواندن سوابق ممکن نشد.';

  @override
  String get reportEmpty => 'در این دوره سابقه‌ای نیست.';

  @override
  String reportTreatmentCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count درمان',
      one: '1 درمان',
    );
    return '$_temp0';
  }

  @override
  String reportHiveCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count کندو',
      one: '1 کندو',
    );
    return '$_temp0';
  }

  @override
  String reportRecordCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count سابقه',
      one: '1 سابقه',
    );
    return '$_temp0';
  }

  @override
  String get reportNoValue => '—';

  @override
  String get pdfTreatmentRegisterTitle => 'دفتر درمان';

  @override
  String get pdfHiveHistoryTitle => 'تاریخچه کندو';

  @override
  String pdfRegistrationNo(String number) {
    return 'شماره ثبت واحد $number';
  }

  @override
  String pdfAksNo(String number) {
    return 'شماره AKS $number';
  }

  @override
  String pdfRecordNo(String number) {
    return 'شماره ثبت $number';
  }

  @override
  String pdfPeriod(String from, String to) {
    return 'دوره: $from – $to';
  }

  @override
  String pdfApiary(String name) {
    return 'زنبورستان: $name';
  }

  @override
  String pdfCreated(String date) {
    return 'ساخته‌شده در $date';
  }

  @override
  String pdfPage(int page, int pages) {
    return 'صفحه $page از $pages';
  }

  @override
  String get pdfColumnDate => 'تاریخ';

  @override
  String get pdfColumnApiary => 'زنبورستان';

  @override
  String get pdfColumnProduct => 'فراورده / سری';

  @override
  String get pdfColumnHives => 'کندوها';

  @override
  String get pdfColumnDose => 'دوز هر کندو';

  @override
  String get pdfColumnRemoval => 'برداشتن';

  @override
  String get pdfColumnWithdrawalEnd => 'پایان انتظار';

  @override
  String get pdfColumnEvent => 'سابقه';

  @override
  String get pdfColumnDetails => 'جزئیات';

  @override
  String get pdfEventFeeding => 'تغذیه';

  @override
  String get pdfEventVarroa => 'شمارش واروآ';

  @override
  String get pdfEventHarvest => 'برداشت';

  @override
  String pdfHarvestTotal(String amount) {
    return 'کل برداشت: $amount';
  }

  @override
  String pdfDocumentName(String title, String from, String to) {
    return '$title $from–$to';
  }

  @override
  String get moreFeedback => 'ارسال بازخورد';

  @override
  String get feedbackTitle => 'ارسال بازخورد';

  @override
  String get feedbackIntro =>
      'این برنامه را همراه زنبورداران می‌سازیم. همه پیام‌ها را می‌خوانیم.';

  @override
  String get feedbackKindLabel => 'درباره چیست؟';

  @override
  String get feedbackKindBug => 'اشکال';

  @override
  String get feedbackKindSuggestion => 'پیشنهاد';

  @override
  String get feedbackKindMissingFeature => 'قابلیت کم';

  @override
  String get feedbackKindThanks => 'تشکر';

  @override
  String get feedbackMessageLabel => 'پیام شما';

  @override
  String get feedbackMessageHint => 'چه اتفاقی افتاد و چه انتظاری داشتید؟';

  @override
  String get feedbackAddScreenshot => 'افزودن تصویر صفحه';

  @override
  String get feedbackScreenshotAttached => 'تصویر صفحه پیوست شد';

  @override
  String get feedbackRemoveScreenshot => 'حذف';

  @override
  String get feedbackScreenshotDenied =>
      'اجازه دسترسی به عکس‌ها داده نشد. برای پیوست تصویر صفحه، آن را در تنظیمات مجاز کنید.';

  @override
  String get feedbackIncludeDeviceInfo => 'پیوست اطلاعات دستگاه و نسخه';

  @override
  String get feedbackOfflineHint =>
      'بدون اینترنت، پیام در صف می‌ماند و وقتی آنلاین شوید فرستاده می‌شود.';

  @override
  String get feedbackSend => 'ارسال';

  @override
  String get feedbackQueued => 'سپاس! پیام شما در صف ارسال است.';

  @override
  String get settingsAnalytics => 'اشتراک داده‌های استفاده';

  @override
  String get settingsAnalyticsHint =>
      'اعدادی مانند زمان بازدید، نتیجه اسکن و تأخیر همگام‌سازی؛ نام، کندوها و موقعیت‌های شما هرگز فرستاده نمی‌شوند.';

  @override
  String get teamTitle => 'تیم';

  @override
  String get teamRoleOwner => 'مالک';

  @override
  String get teamRolePartner => 'شریک';

  @override
  String get teamRoleWorker => 'کارگر';

  @override
  String get teamRoleViewer => 'مشاور';

  @override
  String get teamRoleViewerSubtitle => 'فقط خواندن';

  @override
  String get teamRoleHintPartner =>
      'شریک سوابق را ثبت می‌کند و امور مالی را می‌بیند.';

  @override
  String get teamRoleHintWorker =>
      'کارگر سوابق را ثبت می‌کند اما امور مالی را نمی‌بیند.';

  @override
  String get teamRoleHintViewer =>
      'مشاور فقط می‌تواند بخواند و سابقه ثبت نمی‌کند.';

  @override
  String teamMemberSelf(String name) {
    return '$name (شما)';
  }

  @override
  String get teamMemberUnknown => 'عضو تیم';

  @override
  String get teamMembersEmpty =>
      'اعضا پس از پایان همگام‌سازی نمایش داده می‌شوند.';

  @override
  String get teamInviteTitle => 'دعوت به تیم';

  @override
  String get teamInviteHint => 'کد را بگویید یا بفرستید. 48 ساعت اعتبار دارد.';

  @override
  String get teamInviteGenerate => 'ساخت کد';

  @override
  String get teamInviteCopy => 'کپی';

  @override
  String get teamInviteCopied => 'کد کپی شد.';

  @override
  String teamInviteCodeSemantics(String code) {
    return 'کد دعوت $code';
  }

  @override
  String get teamHaveCode => 'کد دارم';

  @override
  String get teamJoinTitle => 'پیوستن با کد';

  @override
  String get teamJoinHint =>
      'کد 6 نویسه‌ای را که برایتان فرستاده‌اند وارد کنید.';

  @override
  String get teamJoinCodeLabel => 'کد دعوت';

  @override
  String get teamJoinAction => 'پیوستن';

  @override
  String get teamJoinDone => 'به تیم پیوستید.';

  @override
  String get teamErrorOffline =>
      'این کار به اینترنت نیاز دارد. وقتی آنلاین شدید دوباره تلاش کنید.';

  @override
  String get teamErrorInvalidCode =>
      'کد نامعتبر است، منقضی شده یا قبلاً استفاده شده.';

  @override
  String get teamErrorAlreadyMember => 'شما از قبل عضو این تیم هستید.';

  @override
  String get teamErrorForbidden => 'اجازه این کار را ندارید.';

  @override
  String get teamErrorOwnerLocked =>
      'نقش مالک تغییر نمی‌کند و مالک حذف نمی‌شود.';

  @override
  String get teamErrorUnknown => 'انجام نشد. کمی بعد دوباره تلاش کنید.';

  @override
  String get teamRemoveAction => 'حذف از تیم';

  @override
  String get teamRemoveTitle => 'از تیم حذف شود؟';

  @override
  String teamRemoveMessage(String name) {
    return '$name دسترسی به سوابق این کسب‌وکار را از دست می‌دهد.';
  }

  @override
  String get teamRemoveConfirm => 'حذف';

  @override
  String teamRemoved(String name) {
    return '$name از تیم حذف شد.';
  }

  @override
  String teamRoleChanged(String name, String role) {
    return '$name اکنون $role است.';
  }

  @override
  String get teamActivityTitle => 'فعالیت‌های اخیر';

  @override
  String get teamActivityEmpty => 'هنوز فعالیتی نیست.';

  @override
  String get teamActivitySelf => 'شما';

  @override
  String teamActivityInspection(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count بازدید ثبت کرد',
      one: '1 بازدید ثبت کرد',
    );
    return '$_temp0';
  }

  @override
  String teamActivityTreatment(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count کندو را درمان کرد',
      one: '1 کندو را درمان کرد',
    );
    return '$_temp0';
  }

  @override
  String teamActivityFeeding(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count کندو را تغذیه کرد',
      one: '1 کندو را تغذیه کرد',
    );
    return '$_temp0';
  }

  @override
  String teamActivityHarvest(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count برداشت ثبت کرد',
      one: '1 برداشت ثبت کرد',
    );
    return '$_temp0';
  }

  @override
  String teamActivityMiteCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count شمارش واروآ ثبت کرد',
      one: '1 شمارش واروآ ثبت کرد',
    );
    return '$_temp0';
  }

  @override
  String teamActivityTask(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count کار افزود',
      one: '1 کار افزود',
    );
    return '$_temp0';
  }

  @override
  String get teamActivityJustNow => 'همین حالا';

  @override
  String teamActivityMinutesAgo(int count) {
    return '$count دقیقه پیش';
  }

  @override
  String teamActivityHoursAgo(int count) {
    return '$count ساعت پیش';
  }

  @override
  String get teamActivityYesterday => 'دیروز';

  @override
  String teamActivityDaysAgo(int count) {
    return '$count روز پیش';
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
    return '$who $what$where، $when';
  }

  @override
  String get settingsPush => 'اعلان کارها';

  @override
  String get settingsPushHint =>
      'وقتی کاری به شما واگذار شد اعلان بگیرید. برای باز کردن کار، آن را لمس کنید.';

  @override
  String get documentsTitle => 'بایگانی مدارک';

  @override
  String get documentsAdd => 'افزودن مدرک';

  @override
  String documentsSummaryOffline(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count مدرک',
    );
    return '$_temp0 · همه بدون اینترنت باز می‌شوند';
  }

  @override
  String documentsSummaryMissing(int count, int missing) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count مدرک',
    );
    String _temp1 = intl.Intl.pluralLogic(
      missing,
      locale: localeName,
      other: '$missing فایل',
    );
    return '$_temp0 · $_temp1 هنوز روی این گوشی نیست';
  }

  @override
  String get documentsRegionNoteTr =>
      'نوع مدارک به کشور بستگی دارد. بیرون از ترکیه نوع مدارک را خودتان می‌سازید.';

  @override
  String get documentsRegionNoteOther =>
      'نوع مدارک را شما تعیین می‌کنید؛ نوع‌هایی که وارد می‌کنید دفعه بعد پیشنهاد می‌شوند.';

  @override
  String get documentsRoadCheck => 'بازرسی جاده · نمایش مدارک';

  @override
  String get documentsEmptyTitle => 'هنوز مدرکی نیست';

  @override
  String get documentsEmptyMessage =>
      'عکس یا PDF مجوزها و گواهی‌هایتان را اضافه کنید. بدون اینترنت باز می‌شوند و پیش از انقضا یادآوری می‌گیرید.';

  @override
  String get documentsLoadError => 'باز کردن مدارک ممکن نشد.';

  @override
  String get documentFileKindPhoto => 'عکس';

  @override
  String get documentFileKindPdf => 'PDF';

  @override
  String get documentTypeHealthReport => 'گواهی بهداشتی';

  @override
  String get documentTypeTransportPermit => 'مجوز حمل';

  @override
  String get documentTypeMigratoryCertificate => 'گواهی زنبوردار کوچ‌رو';

  @override
  String get documentTypeBusinessRegistration => 'گواهی ثبت واحد';

  @override
  String get documentTypeLandPermit => 'مجوز زمین';

  @override
  String get documentTypeAnalysisReport => 'گزارش آزمایش';

  @override
  String get documentExpiryNone => 'بدون انقضا';

  @override
  String get documentExpiryExpired => 'منقضی';

  @override
  String get documentExpiryToday => 'امروز تمام می‌شود';

  @override
  String documentExpiryDays(int days) {
    String _temp0 = intl.Intl.pluralLogic(
      days,
      locale: localeName,
      other: '$days روز',
    );
    return '$_temp0';
  }

  @override
  String documentExpiryMonths(int months) {
    String _temp0 = intl.Intl.pluralLogic(
      months,
      locale: localeName,
      other: '$months ماه',
    );
    return '$_temp0';
  }

  @override
  String documentExpiresOn(String date) {
    return 'معتبر تا $date';
  }

  @override
  String get documentFormNewTitle => 'افزودن مدرک';

  @override
  String get documentFormEditTitle => 'ویرایش مدرک';

  @override
  String get documentFormType => 'نوع مدرک';

  @override
  String get documentFormCustomTypeHint => 'مثلاً بیمه‌نامه';

  @override
  String get documentFormName => 'نام';

  @override
  String get documentFormNameHint => 'مثلاً گواهی بهداشتی 2026';

  @override
  String get documentFormDescription => 'توضیح';

  @override
  String get documentFormDescriptionHint => 'مثلاً اداره شهرستان · 152 کندو';

  @override
  String get documentFormExpiry => 'معتبر تا';

  @override
  String get documentFormNoExpiry => 'بدون انقضا';

  @override
  String get documentFormPickDate => 'انتخاب تاریخ';

  @override
  String get documentFormExpiryHelper =>
      '30، 7 و 1 روز پیش از انقضا یادآوری می‌گیرید.';

  @override
  String get documentFormFile => 'فایل';

  @override
  String get documentFormTakePhoto => 'گرفتن عکس';

  @override
  String get documentFormPickImage => 'از گالری';

  @override
  String get documentFormPickPdf => 'انتخاب PDF';

  @override
  String get documentFormNoFile =>
      'از مدرک عکس بگیرید یا PDF آن را انتخاب کنید.';

  @override
  String documentFileSizeKb(String size) {
    return '$size کیلوبایت';
  }

  @override
  String documentFileSizeMb(String size) {
    return '$size مگابایت';
  }

  @override
  String get documentFileTooLarge =>
      'فایل بزرگ‌تر از 20 مگابایت است؛ فایل کوچک‌تری انتخاب کنید.';

  @override
  String get documentFileFailed => 'گرفتن فایل ممکن نشد، دوباره تلاش کنید.';

  @override
  String get documentFilePermissionDenied =>
      'اجازه داده نشد. برای افزودن مدرک، دسترسی به دوربین یا فایل‌ها را در تنظیمات برای این برنامه مجاز کنید.';

  @override
  String get documentFormSave => 'ذخیره';

  @override
  String get documentFormDelete => 'حذف مدرک';

  @override
  String get documentSaved => 'مدرک ذخیره شد';

  @override
  String get documentReminderDenied =>
      'مدرک ذخیره شد. بدون اجازه اعلان، یادآور انقضا به صدا درنمی‌آید.';

  @override
  String get documentDeleteTitle => 'این مدرک حذف شود؟';

  @override
  String get documentDeleteMessage =>
      'مدرک و فایل آن از همه گوشی‌ها حذف می‌شوند.';

  @override
  String get documentDeleteConfirm => 'حذف';

  @override
  String get documentDeleted => 'مدرک حذف شد';

  @override
  String get documentNotFound => 'مدرک پیدا نشد؛ ممکن است حذف شده باشد.';

  @override
  String get documentEdit => 'ویرایش';

  @override
  String get documentFileMissing =>
      'فایل هنوز روی این گوشی نیست. وقتی آنلاین شوید دریافت می‌شود.';

  @override
  String get documentPdfFailed => 'باز کردن PDF ممکن نشد.';

  @override
  String documentPdfPage(int page, int count) {
    return 'صفحه $page از $count';
  }

  @override
  String get roadCheckTitle => 'بازرسی جاده';

  @override
  String roadCheckPosition(int index, int count) {
    return '$index / $count';
  }

  @override
  String get roadCheckSwipeHint => 'برای مدرک بعدی به کنار بکشید';

  @override
  String get roadCheckPrevious => 'مدرک قبلی';

  @override
  String get roadCheckNext => 'مدرک بعدی';

  @override
  String documentReminderBody(int days, String date) {
    String _temp0 = intl.Intl.pluralLogic(
      days,
      locale: localeName,
      other: '$days روز',
    );
    return '$_temp0 دیگر منقضی می‌شود · $date';
  }

  @override
  String get syncTableDocuments => 'مدرک';

  @override
  String get migrationsTitle => 'برنامه‌های کوچ';

  @override
  String get migrationsAdd => 'برنامه جدید';

  @override
  String get migrationsEmptyTitle => 'هنوز برنامه کوچی نیست';

  @override
  String get migrationsEmptyMessage =>
      'مسیر سال را برنامه‌ریزی کنید: تاریخ‌ها، تعداد کندو و زنبورستان مقصد هر ایستگاه.';

  @override
  String get migrationsLoadError => 'باز کردن برنامه‌های کوچ ممکن نشد';

  @override
  String migrationStopCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count ایستگاه',
      one: '1 ایستگاه',
      zero: 'بدون ایستگاه',
    );
    return '$_temp0';
  }

  @override
  String migrationTitle(String name, String year) {
    return '$name $year';
  }

  @override
  String get migrationNotFound => 'برنامه کوچ پیدا نشد';

  @override
  String get migrationDocuments => 'مدارک';

  @override
  String get migrationEdit => 'ویرایش برنامه';

  @override
  String get migrationAddStop => 'افزودن ایستگاه';

  @override
  String get migrationNoStopsTitle => 'هنوز ایستگاهی نیست';

  @override
  String get migrationNoStopsMessage =>
      'ایستگاه‌های مسیر را به ترتیب اضافه کنید: منبع گل، مکان، تاریخ‌ها و تعداد کندو.';

  @override
  String migrationNextMoveIn(int days) {
    String _temp0 = intl.Intl.pluralLogic(
      days,
      locale: localeName,
      other: '$days روز دیگر',
      one: '1 روز دیگر',
      zero: 'امروز',
    );
    return 'کوچ بعدی · $_temp0';
  }

  @override
  String migrationNextMoveLate(int days) {
    String _temp0 = intl.Intl.pluralLogic(
      days,
      locale: localeName,
      other: '$days روز تأخیر',
      one: '1 روز تأخیر',
    );
    return 'کوچ بعدی · $_temp0';
  }

  @override
  String migrationRoute(String from, String to) {
    return '$from ← $to';
  }

  @override
  String migrationDocReady(String document) {
    return '$document آماده است';
  }

  @override
  String migrationDocDays(String document, int days) {
    String _temp0 = intl.Intl.pluralLogic(
      days,
      locale: localeName,
      other: '$days روز',
      one: '1 روز',
      zero: 'امروز منقضی می‌شود',
    );
    return '$document $_temp0';
  }

  @override
  String migrationDocBeforeMove(String document) {
    return '$document پیش از کوچ منقضی می‌شود';
  }

  @override
  String migrationDocExpired(String document) {
    return '$document منقضی شده';
  }

  @override
  String migrationDocMissing(String document) {
    return '$document موجود نیست';
  }

  @override
  String get migrationStopPast => 'گذشته';

  @override
  String get migrationStopCurrent => 'اکنون اینجا';

  @override
  String get migrationStopPlanned => 'برنامه‌ریزی‌شده';

  @override
  String get migrationStopHere => 'اینجا هستید';

  @override
  String migrationStopDates(String start, String end) {
    return '$start–$end';
  }

  @override
  String migrationYield(String year, String kg) {
    return '$year: $kg کیلوگرم/کندو';
  }

  @override
  String migrationYields(String values) {
    return 'محصول گذشته · $values';
  }

  @override
  String get migrationNoYield => 'برداشت قبلی در این زنبورستان نیست';

  @override
  String get migrationFormNewTitle => 'برنامه کوچ جدید';

  @override
  String get migrationFormEditTitle => 'ویرایش برنامه کوچ';

  @override
  String get migrationFormYear => 'سال';

  @override
  String get migrationFormName => 'نام';

  @override
  String get migrationFormDefaultName => 'برنامه کوچ';

  @override
  String get migrationFormSave => 'ذخیره';

  @override
  String get migrationFormDelete => 'حذف برنامه';

  @override
  String get migrationDeleteTitle => 'برنامه کوچ حذف شود؟';

  @override
  String get migrationDeleteMessage => 'برنامه و همه ایستگاه‌هایش حذف می‌شوند.';

  @override
  String get migrationDeleteConfirm => 'حذف';

  @override
  String get migrationSaved => 'برنامه ذخیره شد';

  @override
  String get migrationDeleted => 'برنامه حذف شد';

  @override
  String get stopFormNewTitle => 'ایستگاه جدید';

  @override
  String get stopFormEditTitle => 'ویرایش ایستگاه';

  @override
  String get stopFormName => 'منبع گل';

  @override
  String get stopFormNameHint => 'مثلاً مرکبات، گون';

  @override
  String get stopFormPlace => 'مکان';

  @override
  String get stopFormPlaceHint => 'مثلاً مازندران';

  @override
  String get stopFormStart => 'شروع برنامه‌ریزی‌شده';

  @override
  String get stopFormEnd => 'پایان برنامه‌ریزی‌شده';

  @override
  String get stopFormApiary => 'زنبورستان مقصد';

  @override
  String get stopFormChooseApiary => 'انتخاب زنبورستان مقصد';

  @override
  String get stopFormNone => 'هیچ';

  @override
  String get stopFormHiveCount => 'کندوها';

  @override
  String get stopFormPosition => 'ترتیب در مسیر';

  @override
  String get stopFormStatus => 'وضعیت';

  @override
  String get stopFormDelete => 'حذف ایستگاه';

  @override
  String get stopDeleteTitle => 'ایستگاه حذف شود؟';

  @override
  String get stopDeleteMessage => 'ایستگاه از برنامه حذف می‌شود.';

  @override
  String get stopSaved => 'ایستگاه ذخیره شد';

  @override
  String get stopDeleted => 'ایستگاه حذف شد';

  @override
  String get syncTableMigrations => 'برنامه کوچ';

  @override
  String get syncTableMigrationStops => 'ایستگاه کوچ';

  @override
  String get moveStart => 'شروع کوچ';

  @override
  String moveTitle(String route) {
    return 'کوچ · $route';
  }

  @override
  String get moveNone => 'کوچ پیش رویی نیست';

  @override
  String get moreMigratory => 'کوچ‌رو';

  @override
  String get syncTableTransports => 'کوچ';

  @override
  String get syncTableTransportItems => 'کندوی جابه‌جاشده';

  @override
  String get moveStepCheck => 'بررسی';

  @override
  String get moveStepLoad => 'بارگیری';

  @override
  String get moveStepUnload => 'تخلیه';

  @override
  String moveStepDone(String step) {
    return '$step، انجام شد';
  }

  @override
  String get moveNoDestinationTitle => 'ایستگاه زنبورستان ندارد';

  @override
  String get moveNoDestinationMessage =>
      'برای ایستگاه یک زنبورستان مقصد انتخاب کنید تا پس از تخلیه موقعیت کندوها به‌روز شود.';

  @override
  String get moveEditStop => 'ویرایش ایستگاه';

  @override
  String get moveFrom => 'از';

  @override
  String get moveTo => 'به';

  @override
  String moveSourceHives(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count کندوی فعال',
      one: '1 کندوی فعال',
      zero: 'کندوی فعالی نیست',
    );
    return '$_temp0';
  }

  @override
  String get moveChecklist => 'فهرست بررسی بارگیری';

  @override
  String get moveCheckEntrances => 'دریچه‌ها بسته';

  @override
  String get moveCheckVentilation => 'تهویه باز';

  @override
  String get moveCheckStraps => 'تسمه‌ها محکم';

  @override
  String get moveCheckWater => 'آب آماده';

  @override
  String get moveVehicles => 'خودروها';

  @override
  String moveVehicleDefault(int number) {
    return 'کامیون $number';
  }

  @override
  String get moveAddVehicle => 'افزودن خودرو';

  @override
  String moveRemoveVehicle(String vehicle) {
    return 'حذف $vehicle';
  }

  @override
  String get moveVehicleName => 'نام خودرو';

  @override
  String get moveVehicleExists => 'خودرویی با این نام هست';

  @override
  String get moveStartLoading => 'شروع بارگیری';

  @override
  String get moveChecklistHint =>
      'برای شروع بارگیری همه موارد فهرست را تیک بزنید.';

  @override
  String moveVehicleCount(String vehicle, int count) {
    return '$vehicle · $count';
  }

  @override
  String get moveLoaded => 'بارگیری‌شده';

  @override
  String get moveUnloaded => 'تخلیه‌شده';

  @override
  String moveCountTotal(int total) {
    return '/ $total';
  }

  @override
  String moveCountLabel(int count, int total) {
    return '$count از $total کندو';
  }

  @override
  String moveLastScanned(String number) {
    return 'آخرین اسکن: $number';
  }

  @override
  String moveNotScanned(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count کندو هنوز اسکن نشده‌اند',
      one: '1 کندو هنوز اسکن نشده',
    );
    return '$_temp0';
  }

  @override
  String get moveAllScanned => 'همه اسکن شدند';

  @override
  String get moveShowList => 'دیدن فهرست';

  @override
  String get moveMissingTitle => 'کندوهای اسکن‌نشده';

  @override
  String get moveLoadingHint =>
      'هنگام تخلیه در مقصد دوباره اسکن می‌کنید؛ اگر کندویی کم باشد خبرتان می‌کنم. موقعیت کندوها پس از تخلیه به‌روز می‌شود.';

  @override
  String moveUnloadingHint(String destination) {
    return 'هر کندو را هنگام تخلیه دوباره اسکن کنید. وقتی تمام شد، کندوهای تخلیه‌شده به $destination منتقل می‌شوند.';
  }

  @override
  String get moveEnterNumber => 'وارد کردن شماره';

  @override
  String get moveHiveNumber => 'شماره کندو';

  @override
  String moveNumberNotFound(String number) {
    return 'کندویی با شماره $number نیست';
  }

  @override
  String get moveScanStart => 'شروع اسکن';

  @override
  String get moveScanContinue => 'ادامه اسکن';

  @override
  String get moveToUnloading => 'رفتن به تخلیه';

  @override
  String moveToUnloadingTitle(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count کندو اسکن نشده',
      one: '1 کندو اسکن نشده',
    );
    return '$_temp0';
  }

  @override
  String get moveToUnloadingMessage =>
      'کندوهای اسکن‌نشده جزو این کوچ نیستند و سر جایشان می‌مانند.';

  @override
  String get moveFinish => 'پایان کوچ';

  @override
  String moveFinishTitle(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count کندو تخلیه نشده',
      one: '1 کندو تخلیه نشده',
    );
    return '$_temp0';
  }

  @override
  String moveFinishMessage(String source) {
    return 'کندوهای تخلیه‌نشده موقعیتشان را در $source نگه می‌دارند. فهرست کسری روی کوچ می‌ماند.';
  }

  @override
  String get moveFinishConfirm => 'پایان';

  @override
  String get moveDoneTitle => 'کوچ تمام شد';

  @override
  String moveDoneSummary(int loaded, int unloaded) {
    return 'بارگیری $loaded · تخلیه $unloaded';
  }

  @override
  String moveDoneMoved(int count, String destination) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count کندو به $destination رفتند.',
      one: '1 کندو به $destination رفت.',
      zero: 'کندویی جابه‌جا نشد.',
    );
    return '$_temp0';
  }

  @override
  String get moveDoneMissing => 'کندوهای تخلیه‌نشده';

  @override
  String moveScanLoaded(String number, String vehicle) {
    return '$number بارگیری شد · $vehicle';
  }

  @override
  String moveScanLoadedOther(String number) {
    return '$number بارگیری شد؛ این کندو در این زنبورستان نبود';
  }

  @override
  String moveScanAlreadyLoaded(String number) {
    return '$number از قبل بارگیری شده';
  }

  @override
  String moveScanUnloaded(String number) {
    return '$number تخلیه شد';
  }

  @override
  String moveScanAlreadyUnloaded(String number) {
    return '$number از قبل تخلیه شده';
  }

  @override
  String moveScanNotLoaded(String number) {
    return '$number در این کوچ بارگیری نشده بود';
  }

  @override
  String get moveScanUnknown => 'برچسب ناشناخته';

  @override
  String get moveScanDone => 'تمام';

  @override
  String get inventoryTitle => 'لوازم و انبار';

  @override
  String get inventoryAdd => 'افزودن قلم';

  @override
  String get inventoryEmptyTitle => 'هنوز قلمی در انبار نیست';

  @override
  String get inventoryEmptyMessage =>
      'لوازمی مانند شکر، موم آج‌دار و شیشه را اضافه کنید. اقلام زیر حداقل علامت می‌خورند.';

  @override
  String get inventoryCategoryEmpty => 'در این دسته قلمی نیست';

  @override
  String get inventoryLoadError => 'باز کردن انبار ممکن نشد.';

  @override
  String get inventoryNotFound => 'قلم پیدا نشد';

  @override
  String get inventoryCategoryConsumable => 'مصرفی';

  @override
  String get inventoryCategoryEquipment => 'تجهیزات';

  @override
  String get inventoryCategoryComb => 'شان';

  @override
  String get inventoryUnitKg => 'کیلوگرم';

  @override
  String get inventoryUnitLiter => 'لیتر';

  @override
  String get inventoryUnitPiece => 'عدد';

  @override
  String get inventoryUnitRoll => 'رول';

  @override
  String get inventoryUnitPack => 'بسته';

  @override
  String get inventoryUnitNameKg => 'کیلوگرم';

  @override
  String get inventoryUnitNameLiter => 'لیتر';

  @override
  String get inventoryUnitNamePiece => 'عدد';

  @override
  String get inventoryUnitNameRoll => 'رول';

  @override
  String get inventoryUnitNamePack => 'بسته';

  @override
  String inventoryQuantity(String quantity, String unit) {
    return '$quantity $unit';
  }

  @override
  String inventoryBelowThreshold(String threshold) {
    return 'زیر حداقل · دست‌کم $threshold';
  }

  @override
  String get inventoryMoveIn => 'ورود';

  @override
  String get inventoryMoveOut => 'خروج';

  @override
  String get inventoryMoveCount => 'شمارش';

  @override
  String get inventoryMoveAdjustment => 'اصلاح';

  @override
  String inventoryInStock(String quantity) {
    return 'موجودی: $quantity';
  }

  @override
  String inventoryAmountLabel(String unit) {
    return 'مقدار ($unit)';
  }

  @override
  String inventoryCountedLabel(String unit) {
    return 'مقدار شمرده‌شده ($unit)';
  }

  @override
  String get inventoryAmountInvalid => 'مقدار معتبری وارد کنید';

  @override
  String get inventoryAmountWhole => 'برای این واحد عدد صحیح وارد کنید';

  @override
  String get inventorySaveIn => 'افزودن به انبار';

  @override
  String get inventorySaveOut => 'کسر از انبار';

  @override
  String get inventorySaveCount => 'اصلاح موجودی';

  @override
  String inventoryMovedIn(String quantity) {
    return '$quantity اضافه شد';
  }

  @override
  String inventoryMovedOut(String quantity) {
    return '$quantity کسر شد';
  }

  @override
  String inventoryAdjusted(String quantity) {
    return 'موجودی اکنون $quantity';
  }

  @override
  String inventoryUnchanged(String quantity) {
    return 'موجودی از قبل $quantity است';
  }

  @override
  String get inventoryDetails => 'جزئیات و تاریخچه';

  @override
  String get inventoryHistory => 'تاریخچه';

  @override
  String get inventoryHistoryEmpty => 'هنوز گردشی نیست';

  @override
  String inventoryThreshold(String threshold) {
    return 'حداقل: دست‌کم $threshold';
  }

  @override
  String get inventoryNoThreshold => 'بدون حداقل';

  @override
  String get inventoryQuickMove => 'افزودن / کسر';

  @override
  String get inventoryEdit => 'ویرایش قلم';

  @override
  String get inventoryFormNewTitle => 'قلم جدید';

  @override
  String get inventoryFormEditTitle => 'ویرایش قلم';

  @override
  String get inventoryFormName => 'نام';

  @override
  String get inventoryFormCategory => 'دسته';

  @override
  String get inventoryFormUnit => 'واحد';

  @override
  String get inventoryFormLocation => 'محل نگهداری';

  @override
  String get inventoryFormLocationHint => 'انبار، کامیون، دفتر… اختیاری.';

  @override
  String get inventoryFormThreshold => 'حداقل';

  @override
  String get inventoryFormThresholdHint =>
      'وقتی موجودی از این کمتر شود هشدار می‌گیرید. اختیاری.';

  @override
  String get inventoryFormThresholdInvalid => 'حداقل معتبری وارد کنید';

  @override
  String get inventoryFormSave => 'ذخیره';

  @override
  String get inventoryFormDelete => 'حذف قلم';

  @override
  String get inventoryDeleteTitle => 'این قلم حذف شود؟';

  @override
  String get inventoryDeleteMessage =>
      'قلم و موجودی آن از فهرست بیرون می‌روند.';

  @override
  String get inventoryDeleteConfirm => 'حذف';

  @override
  String get inventorySaved => 'قلم ذخیره شد';

  @override
  String get inventoryDeleted => 'قلم حذف شد';

  @override
  String get syncTableInventoryItems => 'قلم انبار';

  @override
  String get syncTableInventoryMoves => 'گردش انبار';

  @override
  String inventoryIncrease(String quantity) {
    return '+$quantity';
  }

  @override
  String inventoryFormThresholdUnit(String unit) {
    return 'حداقل ($unit)';
  }

  @override
  String get stockUseTitle => 'کسر از انبار';

  @override
  String get stockUseNone => 'کسر نشود';

  @override
  String stockUseValue(String item, String quantity) {
    return '$item · −$quantity';
  }

  @override
  String get stockUseChoose => 'از کدام قلم کسر شود؟';

  @override
  String get taskFormTreatment => 'درمان برنامه‌ریزی‌شده';

  @override
  String get taskFormTreatmentUnknown => 'دارو در فهرست نیست';

  @override
  String get taskFormTreatmentNeedsApiary =>
      'برای درمان برنامه‌ریزی‌شده زنبورستانی انتخاب کنید';

  @override
  String taskTreatmentPlanTitle(String drug) {
    return 'درمان · $drug';
  }

  @override
  String get shoppingTitle => 'فهرست خرید';

  @override
  String shoppingCardTitle(int count) {
    return 'فهرست خرید · $count';
  }

  @override
  String get shoppingEmptyTitle => 'چیزی برای خرید نیست';

  @override
  String get shoppingEmptyMessage =>
      'اقلام زیر حداقل و نیاز درمان‌های برنامه‌ریزی‌شده اینجا نمایش داده می‌شوند.';

  @override
  String get shoppingShare => 'اشتراک‌گذاری';

  @override
  String get shoppingLoadError => 'باز کردن فهرست خرید ممکن نشد';

  @override
  String shoppingReasonThreshold(String stock, String threshold) {
    return '$stock موجود · حداقل $threshold';
  }

  @override
  String shoppingReasonPlanned(String quantity) {
    return 'درمان‌های برنامه‌ریزی‌شده $quantity';
  }

  @override
  String get shoppingReasonNoItem => 'درمان برنامه‌ریزی‌شده · قلم انبار ندارد';

  @override
  String shoppingShareLine(String name, String quantity) {
    return '• $name: $quantity';
  }

  @override
  String get moreRearing => 'پرورش ملکه';

  @override
  String get rearingTitle => 'پرورش ملکه';

  @override
  String rearingBatchName(int number) {
    return 'سری $number';
  }

  @override
  String rearingBatchTitle(int number) {
    return 'پرورش ملکه · سری $number';
  }

  @override
  String get rearingAdd => 'افزودن سری';

  @override
  String get rearingEmptyTitle => 'هنوز سری‌ای نیست';

  @override
  String get rearingEmptyMessage =>
      'روز پیوند لارو را وارد کنید؛ برنامه از پذیرش تا بررسی تخم‌ریزی و یادآورهایش برایتان ساخته می‌شود.';

  @override
  String get rearingLoadError => 'بارگیری سری‌ها ممکن نشد';

  @override
  String get rearingNotFound => 'سری پیدا نشد';

  @override
  String rearingListGrafted(String date) {
    return 'پیوند $date';
  }

  @override
  String get rearingEdit => 'ویرایش سری';

  @override
  String get rearingGraftedLabel => 'پیوندشده';

  @override
  String get rearingAcceptedLabel => 'پذیرفته‌شده';

  @override
  String get rearingNucsLabel => 'هسته‌ها';

  @override
  String get rearingNotCounted => 'شمرده نشده';

  @override
  String rearingAcceptedPercent(int percent) {
    return '$percent%';
  }

  @override
  String rearingMotherLine(String mother, String date) {
    return 'مادر: $mother · پیوند $date';
  }

  @override
  String rearingMotherUnknownLine(String date) {
    return 'مادر نامشخص · پیوند $date';
  }

  @override
  String rearingDay(int day) {
    return 'روز $day';
  }

  @override
  String get rearingToday => 'امروز';

  @override
  String get rearingStepGraft => 'پیوند لارو';

  @override
  String get rearingStepAcceptance => 'بررسی پذیرش';

  @override
  String get rearingStepCapped => 'سلول‌ها سرپوشیده';

  @override
  String get rearingStepDistribution => 'پخش سلول‌ها';

  @override
  String get rearingStepEmergence => 'خروج ملکه‌ها';

  @override
  String get rearingStepLayingCheck => 'بررسی تخم‌ریزی';

  @override
  String rearingStepGraftDetail(int count) {
    return '$count لارو';
  }

  @override
  String rearingStepAcceptanceDetail(int count) {
    return '$count سلول پذیرفته شد';
  }

  @override
  String get rearingStepAcceptanceTodo => 'سلول‌های پذیرفته‌شده را بشمارید';

  @override
  String get rearingStepCappedDetail => 'مزاحم نشوید';

  @override
  String rearingStepDistributionDetail(int count) {
    return 'پیش از خروج، به $count هسته';
  }

  @override
  String get rearingStepDistributionTodo => 'پیش از خروج، به هسته‌ها';

  @override
  String get rearingStepEmergenceDetail => 'هسته‌ها را بررسی کنید';

  @override
  String get rearingStepLayingCheckDetail => 'موفقیت جفت‌گیری را علامت بزنید';

  @override
  String get rearingStepDone => 'انجام شد';

  @override
  String get rearingStepCurrent => 'بعدی';

  @override
  String get rearingStepUpcoming => 'پیش رو';

  @override
  String get rearingDistribute => 'پخش سلول‌ها در هسته‌ها';

  @override
  String get rearingDistributeApiary => 'زنبورستان';

  @override
  String get rearingDistributeCount => 'هسته‌ها';

  @override
  String rearingDistributePlan(int reused, int created) {
    return 'هسته‌های خالی دوباره: $reused · هسته‌های جدید: $created';
  }

  @override
  String get rearingDistributeSave => 'پخش';

  @override
  String get rearingDistributeNoApiary => 'ابتدا زنبورستانی اضافه کنید';

  @override
  String rearingDistributed(int count) {
    return 'در $count هسته پخش شد';
  }

  @override
  String get rearingNucsSection => 'هسته‌های جفت‌گیری';

  @override
  String rearingNucTitle(String number) {
    return 'هسته $number';
  }

  @override
  String get matingNucStatusEmpty => 'خالی';

  @override
  String get matingNucStatusCell => 'سلول';

  @override
  String get matingNucStatusVirgin => 'ملکه باکره';

  @override
  String get matingNucStatusLaying => 'در حال تخم‌ریزی';

  @override
  String get matingNucStatusFailed => 'ناموفق';

  @override
  String get matingNucStatusGiven => 'به کندو داده شد';

  @override
  String get rearingNucGive => 'دادن به کندو';

  @override
  String get rearingNucChooseHive => 'کدام کندو؟';

  @override
  String get rearingNucNoHives => 'کندوی فعالی نیست';

  @override
  String get rearingFormNewTitle => 'سری جدید';

  @override
  String get rearingFormEditTitle => 'ویرایش سری';

  @override
  String get rearingFormGraftedOn => 'روز پیوند';

  @override
  String get rearingFormGraftedCount => 'لاروهای پیوندشده';

  @override
  String get rearingFormAcceptedCount => 'سلول‌های پذیرفته‌شده';

  @override
  String get rearingFormAcceptedClear => 'هنوز شمرده نشده';

  @override
  String get rearingFormScheduleHint =>
      'پذیرش، سرپوش، پخش، خروج و بررسی تخم‌ریزی به‌صورت کار با یادآور اضافه می‌شوند.';

  @override
  String get rearingFormSave => 'ذخیره';

  @override
  String get rearingFormDelete => 'حذف سری';

  @override
  String get rearingDeleteTitle => 'سری حذف شود؟';

  @override
  String get rearingDeleteMessage =>
      'کارهای آن هم حذف می‌شوند. هسته‌ها و ملکه‌های داده‌شده می‌مانند.';

  @override
  String get rearingDeleteConfirm => 'حذف';

  @override
  String get rearingDeleted => 'سری حذف شد';

  @override
  String get rearingSaved => 'سری ذخیره شد';

  @override
  String get taskSourceQueenRearing => 'پرورش ملکه';

  @override
  String get syncTableQueenRearingBatches => 'سری پرورش ملکه';

  @override
  String get syncTableMatingNucs => 'هسته جفت‌گیری';

  @override
  String get lotsTitle => 'برداشت و بچ‌ها';

  @override
  String get lotsEmptyTitle => 'هنوز بچی نیست';

  @override
  String get lotsEmptyMessage =>
      'پس از ذخیره برداشت، آن را به یک بچ اضافه کنید؛ بچ‌ها اینجا فهرست می‌شوند.';

  @override
  String get lotsLoadError => 'بارگیری بچ‌ها ممکن نشد';

  @override
  String get lotsInStock => 'موجود';

  @override
  String get lotsPerHive => 'برای هر کندو';

  @override
  String lotNumber(String number) {
    return 'بچ $number';
  }

  @override
  String lotHoneyTitle(String kind) {
    return 'عسل $kind';
  }

  @override
  String get lotStatusOpen => 'باز';

  @override
  String get lotStatusClosed => 'بسته';

  @override
  String get lotWithdrawalBadge => 'در دوره انتظار';

  @override
  String lotMoistureValue(String value) {
    return 'رطوبت $value%';
  }

  @override
  String get lotAnalyzed => 'آزمایش‌شده ✓';

  @override
  String get lotAnalysisPending => 'آزمایش در انتظار';

  @override
  String lotStockValue(String weight) {
    return 'موجودی $weight';
  }

  @override
  String get lotNotFound => 'بچ پیدا نشد';

  @override
  String get lotEdit => 'ویرایش بچ';

  @override
  String lotWithdrawalTitle(String hives) {
    return '$hives در دوره انتظار برداشت شد.';
  }

  @override
  String get lotWithdrawalMessage =>
      'این بچ ممکن است بقایای دارو داشته باشد؛ پیش از فروش آزمایش کنید.';

  @override
  String get lotStock => 'موجودی';

  @override
  String get lotHarvested => 'برداشت‌شده';

  @override
  String get lotSold => 'فروخته‌شده';

  @override
  String get lotInStock => 'موجود';

  @override
  String get lotSell => 'ثبت فروش';

  @override
  String get lotAnalyses => 'آزمایش‌ها';

  @override
  String get lotAnalysesEmpty => 'هنوز آزمایشی نیست';

  @override
  String get lotAddAnalysis => 'افزودن آزمایش';

  @override
  String get lotHarvests => 'برداشت‌ها';

  @override
  String get lotHarvestsEmpty => 'برداشتی در این بچ نیست';

  @override
  String get lotTreatments => 'آخرین درمان کندوها';

  @override
  String get lotTreatmentsEmpty => 'برای کندوهای این بچ درمانی ثبت نشده';

  @override
  String lotTreatmentTitle(String hive, String product) {
    return 'کندو $hive · $product';
  }

  @override
  String lotTreatmentDetail(String date, String end) {
    return '$date · پایان انتظار $end';
  }

  @override
  String get lotPublicPage => 'صفحه عمومی';

  @override
  String get lotPublish => 'انتشار';

  @override
  String get lotPublishHint =>
      'هر کس QR را اسکن کند صفحه بچ را می‌بیند. تلفن، نشانی و موقعیت هرگز نمایش داده نمی‌شوند.';

  @override
  String get lotPublishOwnerOnly => 'فقط مالک کسب‌وکار می‌تواند منتشر کند.';

  @override
  String get lotPublished => 'منتشرشده';

  @override
  String get lotNotPublished => 'منتشرنشده';

  @override
  String get lotPublicFields => 'نمایش در صفحه';

  @override
  String get lotPublicProducer => 'نام کسب‌وکار و تعداد کندو';

  @override
  String get lotPublicOrigin => 'منشأ و ماه برداشت';

  @override
  String get lotPublicLab => 'مقادیر آزمایش';

  @override
  String get lotPublicReport => 'گزارش آزمایش';

  @override
  String get lotJarLabels => 'برچسب شیشه (QR)';

  @override
  String get lotJarLabelsHint =>
      '24 برچسب در هر صفحه A4 (70 × 37 میلی‌متر)؛ با مقیاس 100% چاپ کنید.';

  @override
  String lotJarLabelsDocumentName(String number) {
    return 'برچسب‌های شیشه - $number';
  }

  @override
  String get lotSales => 'فروش‌ها';

  @override
  String get lotSalesEmpty => 'هنوز فروشی ثبت نشده';

  @override
  String lotSaleValue(String weight) {
    return '−$weight';
  }

  @override
  String lotSaleAmount(String unit) {
    return 'عسل فروخته‌شده ($unit)';
  }

  @override
  String lotSaleTooMuch(String weight) {
    return 'فقط $weight موجود است';
  }

  @override
  String get lotSaleSave => 'کسر از موجودی';

  @override
  String lotSaleSaved(String weight) {
    return 'فروش $weight ثبت شد';
  }

  @override
  String get lotOrigin => 'منشأ';

  @override
  String get lotOriginHint => 'مثلاً کاج کوهستان';

  @override
  String get lotMoisture => 'رطوبت %';

  @override
  String get lotMoistureHelper => 'عدد رفرکتومتر؛ اختیاری';

  @override
  String get lotMoistureInvalid => 'مقداری بین 10 و 30 وارد کنید، مثلاً 17.2';

  @override
  String lotEditTitle(String lot) {
    return 'ویرایش $lot';
  }

  @override
  String get lotStatus => 'وضعیت';

  @override
  String get lotStatusHelper => 'بچ‌های بسته برداشت جدید نمی‌پذیرند';

  @override
  String get lotSave => 'ذخیره';

  @override
  String get lotDelete => 'حذف بچ';

  @override
  String lotDeleteTitle(String lot) {
    return '$lot حذف شود؟';
  }

  @override
  String get lotDeleteMessage =>
      'آزمایش‌ها و فروش‌ها هم حذف می‌شوند؛ برداشت‌ها می‌مانند.';

  @override
  String get lotDeleted => 'بچ حذف شد';

  @override
  String labTitle(String lot) {
    return 'آزمایش · $lot';
  }

  @override
  String get labDate => 'تاریخ آزمایش';

  @override
  String get labHmf => 'HMF (میلی‌گرم/کیلوگرم)';

  @override
  String get labDiastase => 'عدد دیاستاز';

  @override
  String get labProline => 'پرولین (میلی‌گرم/کیلوگرم)';

  @override
  String labHmfValue(String value) {
    return 'HMF $value';
  }

  @override
  String labDiastaseValue(String value) {
    return 'دیاستاز $value';
  }

  @override
  String labProlineValue(String value) {
    return 'پرولین $value';
  }

  @override
  String labValueInvalid(String min, String max) {
    return 'مقداری بین $min و $max وارد کنید';
  }

  @override
  String get labResidue => 'باقیمانده';

  @override
  String get labResidueNone => 'بدون باقیمانده';

  @override
  String get labResidueDetected => 'باقیمانده یافت شد';

  @override
  String get labReport => 'گزارش';

  @override
  String get labReportNone => 'بدون گزارش';

  @override
  String get labReportEmpty => 'گزارش آزمایشی در بایگانی مدارک نیست';

  @override
  String get labReportAdd => 'افزودن گزارش به بایگانی مدارک';

  @override
  String get labSave => 'ذخیره آزمایش';

  @override
  String get labSaved => 'آزمایش ذخیره شد';

  @override
  String get harvestLotTitle => 'افزودن به بچ';

  @override
  String harvestLotSaved(String weight, String kind) {
    return 'برداشت ذخیره شد: $weight $kind';
  }

  @override
  String get harvestLotIntro =>
      'وقتی عسل وارد بچ می‌شود، تاریخ آخرین درمان کندوها به آن پیوند می‌خورد.';

  @override
  String get harvestLotNew => 'بچ جدید';

  @override
  String harvestLotNewHint(String kind) {
    return '$kind · شماره خودکار داده می‌شود';
  }

  @override
  String get harvestLotCreate => 'ساخت بچ';

  @override
  String get harvestLotAdd => 'افزودن به بچ';

  @override
  String get harvestLotSkip => 'فعلاً رد شوید';

  @override
  String harvestLotCreated(String lot) {
    return '$lot ساخته شد';
  }

  @override
  String harvestLotAdded(String lot) {
    return 'برداشت به $lot اضافه شد';
  }

  @override
  String get harvestLotGone => 'برداشت واگرد شد';

  @override
  String get harvestLotBack => 'بازگشت به زنبورستان';

  @override
  String get syncTableLots => 'بچ';

  @override
  String get syncTableLotHarvests => 'برداشت بچ';

  @override
  String get syncTableLotTreatments => 'درمان بچ';

  @override
  String get syncTableLabResults => 'نتیجه آزمایش';

  @override
  String get syncTableLotSales => 'فروش بچ';

  @override
  String get harvestLotGoneMessage =>
      'برداشت به بچی اضافه نشد. می‌توانید آن را دوباره از زنبورستان ثبت کنید.';

  @override
  String get financeTitle => 'امور مالی';

  @override
  String financeYearTitle(String year) {
    return 'امور مالی · $year';
  }

  @override
  String get financeSeasonNet => 'خالص فصل';

  @override
  String get financeIncome => 'درآمد';

  @override
  String get financeExpense => 'هزینه';

  @override
  String get financeCostPerHive => 'هزینه/کندو';

  @override
  String get financeRecent => 'ثبت‌های اخیر';

  @override
  String get financeEmptyTitle => 'هنوز ثبتی نیست';

  @override
  String get financeEmptyMessage =>
      'درآمد و هزینه را با دکمه‌های پایین ثبت کنید؛ خالص فصل اینجا حساب می‌شود.';

  @override
  String get financeLoadError => 'بارگیری ثبت‌ها ممکن نشد';

  @override
  String get financeAddIncome => '+ درآمد';

  @override
  String get financeAddExpense => '− هزینه';

  @override
  String financePlus(String amount) {
    return '+$amount';
  }

  @override
  String financeMinus(String amount) {
    return '−$amount';
  }

  @override
  String get financeReceiptAttached => 'رسید پیوست شد';

  @override
  String financeTransportRoute(String from, String to) {
    return '$from ← $to';
  }

  @override
  String get financeFormIncomeTitle => 'افزودن درآمد';

  @override
  String get financeFormExpenseTitle => 'افزودن هزینه';

  @override
  String financeFormAmount(String currency) {
    return 'مبلغ ($currency)';
  }

  @override
  String get financeFormAmountInvalid =>
      'مبلغی بیش از 0 وارد کنید، مثلاً 17500 یا 17.50';

  @override
  String get financeFormCategory => 'دسته';

  @override
  String get financeFormDate => 'تاریخ';

  @override
  String get financeFormDescription => 'توضیح';

  @override
  String get financeFormDescriptionHint => 'مثلاً شکر 500 کیلوگرم';

  @override
  String get financeFormReceipt => 'رسید / فاکتور';

  @override
  String get financeFormNoReceipt => 'بدون رسید';

  @override
  String get financeFormReceiptAdded => 'عکس رسید اضافه شد';

  @override
  String get financeFormTakePhoto => 'گرفتن عکس';

  @override
  String get financeFormPickImage => 'از گالری';

  @override
  String get financeFormRemoveReceipt => 'حذف رسید';

  @override
  String get financeFormPhotoDenied =>
      'اجازه داده نشد. برای افزودن رسید، دسترسی به دوربین یا عکس‌ها را در تنظیمات برای این برنامه مجاز کنید.';

  @override
  String get financeFormPhotoFailed => 'گرفتن عکس ممکن نشد، دوباره تلاش کنید.';

  @override
  String get financeFormLinks => 'سابقه مرتبط';

  @override
  String get financeFormApiary => 'زنبورستان';

  @override
  String get financeFormLot => 'بچ';

  @override
  String get financeFormTransport => 'کوچ';

  @override
  String get financeFormNone => 'هیچ';

  @override
  String get financeFormChooseApiary => 'انتخاب زنبورستان';

  @override
  String get financeFormChooseLot => 'انتخاب بچ';

  @override
  String get financeFormChooseTransport => 'انتخاب کوچ';

  @override
  String get financeFormNoLots => 'هنوز بچی نیست';

  @override
  String get financeFormNoTransports => 'هنوز کوچی نیست';

  @override
  String financeFormSaleAmount(String unit) {
    return 'عسل فروخته‌شده ($unit)';
  }

  @override
  String get financeFormSaleHelper =>
      'از موجودی بچ کسر می‌شود؛ برای حفظ موجودی خالی بگذارید';

  @override
  String get financeFormSave => 'ذخیره';

  @override
  String get financeIncomeSaved => 'درآمد ذخیره شد';

  @override
  String get financeExpenseSaved => 'هزینه ذخیره شد';

  @override
  String get financeNotFound => 'ثبت پیدا نشد';

  @override
  String get financeReceiptPending => 'رسید هنوز به این گوشی نرسیده';

  @override
  String get financeDelete => 'حذف ثبت';

  @override
  String get financeDeleteTitle => 'این ثبت حذف شود؟';

  @override
  String get financeDeleteMessage =>
      'اگر به فروش یک بچ مرتبط باشد، آن فروش هم حذف می‌شود و موجودی برمی‌گردد.';

  @override
  String get financeDeleteConfirm => 'حذف';

  @override
  String get financeDeleted => 'ثبت حذف شد';

  @override
  String get financeCategoryFeeding => 'تغذیه';

  @override
  String get financeCategoryTreatment => 'دارو';

  @override
  String get financeCategoryEquipment => 'تجهیزات';

  @override
  String get financeCategoryFuelTransport => 'سوخت / حمل';

  @override
  String get financeCategoryLandRent => 'اجاره زمین';

  @override
  String get financeCategoryLabor => 'دستمزد';

  @override
  String get financeCategoryLabAnalysis => 'آزمایش';

  @override
  String get financeCategoryHoney => 'عسل';

  @override
  String get financeCategoryPollen => 'گرده';

  @override
  String get financeCategoryPropolis => 'بره‌موم';

  @override
  String get financeCategoryWax => 'موم';

  @override
  String get financeCategoryNucs => 'هسته';

  @override
  String get financeCategoryQueens => 'ملکه';

  @override
  String get financeCategoryOther => 'دیگر';

  @override
  String get syncTableTransactions => 'درآمد/هزینه';

  @override
  String get customersTitle => 'دفتر مشتریان';

  @override
  String get customersAdd => 'افزودن مشتری';

  @override
  String get customersEmptyTitle => 'هنوز مشتری‌ای نیست';

  @override
  String get customersEmptyMessage =>
      'مشتری‌ها را اضافه کنید تا سفارش‌ها و بدهی‌هایشان را پیگیری کنید.';

  @override
  String customerReceivableValue(String amount) {
    return '$amount بدهکار';
  }

  @override
  String get customerNoReceivable => 'بدهی ندارد';

  @override
  String get customerNotFound => 'مشتری پیدا نشد';

  @override
  String get customerEdit => 'ویرایش مشتری';

  @override
  String get customerAddSale => 'افزودن فروش';

  @override
  String get customerOrders => 'سفارش‌ها';

  @override
  String get customerNoOrders => 'هنوز فروشی به این مشتری نیست.';

  @override
  String get customerPaid => 'پرداخت‌شده';

  @override
  String customerRemaining(String amount) {
    return '$amount مانده';
  }

  @override
  String get customerPaidAmount => 'پرداخت‌شده تاکنون';

  @override
  String get customerMarkPaid => 'علامت پرداخت‌شده';

  @override
  String get customerMarkedPaid => 'پرداخت‌شده علامت خورد';

  @override
  String get customerAddPayment => 'ثبت پرداخت';

  @override
  String get customerSendWhatsApp => 'ارسال با واتساپ';

  @override
  String get customerWhatsAppNoPhone =>
      'تلفن ندارد؛ مخاطب را در واتساپ انتخاب کنید';

  @override
  String get customerWhatsAppFailed => 'باز کردن واتساپ ممکن نشد';

  @override
  String get customerOpenTransaction => 'باز کردن ثبت';

  @override
  String customerWhatsAppGreeting(String name) {
    return 'سلام $name،';
  }

  @override
  String get customerWhatsAppIntro => 'خلاصه سفارش شما:';

  @override
  String customerWhatsAppAmount(String amount) {
    return 'مجموع: $amount';
  }

  @override
  String customerWhatsAppPaid(String amount) {
    return 'پرداخت‌شده: $amount';
  }

  @override
  String customerWhatsAppRemaining(String amount) {
    return 'مانده: $amount';
  }

  @override
  String get customerWhatsAppPaidInFull => 'کامل پرداخت شد، سپاس.';

  @override
  String customerWhatsAppAddress(String address) {
    return 'نشانی ارسال: $address';
  }

  @override
  String get customerFormNewTitle => 'مشتری جدید';

  @override
  String get customerFormEditTitle => 'ویرایش مشتری';

  @override
  String get customerFormName => 'نام';

  @override
  String get customerFormPhone => 'تلفن';

  @override
  String get customerFormPhoneHelper => 'برای واتساپ، مثلاً +98 912 345 6789';

  @override
  String get customerFormAddress => 'نشانی ارسال';

  @override
  String get customerFormNotes => 'یادداشت';

  @override
  String get customerFormSave => 'ذخیره';

  @override
  String get customerSaved => 'مشتری ذخیره شد';

  @override
  String get customerDelete => 'حذف مشتری';

  @override
  String get customerDeleteTitle => 'مشتری حذف شود؟';

  @override
  String get customerDeleteMessage => 'فروش‌هایش در درآمدهای شما می‌مانند.';

  @override
  String get customerDeleteConfirm => 'حذف';

  @override
  String get customerDeleted => 'مشتری حذف شد';

  @override
  String get customerPaymentSave => 'ذخیره پرداخت';

  @override
  String get customerPaymentSaved => 'پرداخت ذخیره شد';

  @override
  String customerPaymentTooMuch(String amount) {
    return 'فقط $amount مانده است.';
  }

  @override
  String get financeFormCustomer => 'مشتری';

  @override
  String get financeFormChooseCustomer => 'انتخاب مشتری';

  @override
  String get financeFormNoCustomers => 'هنوز مشتری‌ای نیست';

  @override
  String get financeFormPaidNow => 'پرداخت‌شده اکنون';

  @override
  String get financeFormPaidNowHelper => 'اگر کل مبلغ بدهی است خالی بگذارید.';

  @override
  String get financeFormPaidTooMuch => 'نمی‌تواند بیش از مبلغ باشد.';

  @override
  String get financeProfitTitle => 'سود به تفکیک زنبورستان';

  @override
  String get financeProfitUnknownApiary => 'زنبورستان حذف‌شده';

  @override
  String financeReceivables(String amount, int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count مشتری',
      one: '1 مشتری',
    );
    return '$amount طلب · $_temp0';
  }

  @override
  String get syncTableCustomers => 'مشتری';

  @override
  String get syncTableCustomerPayments => 'پرداخت';

  @override
  String get customerUnpaid => 'پرداخت‌نشده';

  @override
  String customerPartiallyPaid(String paid, String remaining) {
    return '$paid پرداخت‌شده، $remaining مانده';
  }

  @override
  String get taskAksUpdateTitle => 'به‌روزرسانی AKS را فراموش نکنید';

  @override
  String get taskSourceAks => 'AKS';

  @override
  String get syncTableRefSupportPeriods => 'دوره حمایت';

  @override
  String get subsidiesTitle => 'حمایت‌ها';

  @override
  String get subsidiesCheckTitle => 'پیش از درخواست';

  @override
  String get subsidiesActiveHives => 'کندوهای فعال در برنامه';

  @override
  String get subsidiesDeclaredHives => 'اعلام‌شده در AKS';

  @override
  String get subsidiesNotDeclared => 'وارد نشده';

  @override
  String get subsidiesCheckNotDeclared =>
      'تعداد کندویی را که در AKS اعلام کرده‌اید وارد کنید؛ پیش از درخواست با برنامه مقایسه می‌شود.';

  @override
  String subsidiesCheckDiffers(String active, String declared) {
    return 'برنامه $active کندوی فعال دارد اما در AKS $declared اعلام شده. پیش از درخواست سابقه AKS را به‌روز کنید.';
  }

  @override
  String get subsidiesCheckMatches =>
      'اعداد یکسان‌اند: برنامه و AKS همخوانی دارند.';

  @override
  String get subsidiesEditDeclared => 'وارد کردن تعداد اعلام‌شده';

  @override
  String get subsidiesDeclaredOwnerOnly =>
      'فقط مالک می‌تواند تعداد اعلام‌شده را وارد کند.';

  @override
  String get subsidiesPeriodsTitle => 'دوره‌های درخواست';

  @override
  String get subsidiesEmptyTitle => 'هنوز دوره حمایتی نیست';

  @override
  String get subsidiesEmptyMessage =>
      'دوره‌های درخواست پس از اعلام اینجا نمایش داده می‌شوند؛ وقتی دوره‌ای باز شود اعلان می‌گیرید.';

  @override
  String get subsidiesPhaseOpen => 'باز';

  @override
  String get subsidiesPhaseUpcoming => 'به‌زودی';

  @override
  String get subsidiesPhaseClosed => 'بسته';

  @override
  String subsidiesPeriodDates(String start, String end) {
    return '$start – $end';
  }

  @override
  String get subsidiesOpenSource => 'باز کردن اطلاعیه رسمی';

  @override
  String get subsidiesOpenSourceFailed => 'باز کردن پیوند ممکن نشد';

  @override
  String get aksCountTitle => 'تعداد کندو در AKS';

  @override
  String get aksCountLabel => 'تعداد کندوی اعلام‌شده در AKS';

  @override
  String get aksCountHelper => 'برای رد شدن از مقایسه خالی بگذارید.';

  @override
  String get aksCountInvalid => 'عددی بین 0 و 100,000 وارد کنید';

  @override
  String get aksCountSave => 'ذخیره';

  @override
  String get aksCountSaved => 'تعداد کندوی AKS ذخیره شد';

  @override
  String get aksCountNoOrganization =>
      'اطلاعات کسب‌وکار هنوز با این گوشی همگام نشده؛ منتظر همگام‌سازی بمانید.';

  @override
  String get knowledgeTitle => 'پایگاه دانش';

  @override
  String get knowledgeSearchHint => 'ذخیره زمستانی، واروآ…';

  @override
  String knowledgeMonthLabel(String month, String place) {
    return '$month · $place';
  }

  @override
  String get knowledgePlaceTurkey => 'ترکیه';

  @override
  String get knowledgePlaceNorthern => 'نیمکره شمالی';

  @override
  String get knowledgePlaceSouthern => 'نیمکره جنوبی';

  @override
  String get knowledgeMonthTitle => 'کارهای این ماه';

  @override
  String get knowledgeDiagnosisTitle => 'دستیار تشخیص';

  @override
  String get knowledgeDiagnosisSubtitle =>
      'نشانه‌ای انتخاب کنید، علت‌های احتمالی را ببینید';

  @override
  String get knowledgeAtlasTitle => 'اطلس بیماری‌ها و آفات';

  @override
  String knowledgeTopicCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count موضوع',
      one: '1 موضوع',
    );
    return '$_temp0';
  }

  @override
  String get knowledgeGuidesTitle => 'راهنماهای فنی';

  @override
  String get knowledgeGuidesSubtitle =>
      'تقسیم، معرفی ملکه، ادغام، زمستان‌گذرانی';

  @override
  String get knowledgeCalculatorsTitle => 'ماشین‌حساب‌ها';

  @override
  String get knowledgeCalculatorsSubtitle =>
      'شربت، دوز دارو، تقویم ملکه، محصول';

  @override
  String get knowledgeRegulationsTitle => 'خلاصه مقررات';

  @override
  String get knowledgeRegulationsSubtitle =>
      'آیین‌نامه، زنبورداری کوچ‌رو، دستورالعمل عسل';

  @override
  String get knowledgeTrBadge => 'TR';

  @override
  String get knowledgeFirstYearTitle => 'سال اول من';

  @override
  String get knowledgeFirstYearSubtitle => 'گام‌به‌گام برای تازه‌کارها';

  @override
  String get knowledgeCalendarTitle => 'تقویم فصلی';

  @override
  String get knowledgeOffline => 'همه محتوا بدون اینترنت باز می‌شود';

  @override
  String get knowledgeNoResultsTitle => 'نتیجه‌ای نیست';

  @override
  String get knowledgeNoResultsMessage => 'واژه دیگری را امتحان کنید.';

  @override
  String get knowledgeCategoryEmptyTitle => 'هنوز مقاله‌ای نیست';

  @override
  String get knowledgeCategoryEmptyMessage =>
      'محتوای این بخش با یک به‌روزرسانی می‌آید.';

  @override
  String get knowledgeArticleNotFound => 'مقاله پیدا نشد';

  @override
  String get knowledgeLoadError => 'باز کردن پایگاه دانش ممکن نشد';

  @override
  String get knowledgeLinkFailed => 'باز کردن پیوند ممکن نشد';

  @override
  String get diagnosisSymptoms => 'نشانه‌هایی که می‌بینید';

  @override
  String get diagnosisSymptomsHelper => 'می‌توانید چندتا انتخاب کنید.';

  @override
  String get diagnosisResults => 'بیماری‌های احتمالی';

  @override
  String get diagnosisPickHint =>
      'نشانه‌ای انتخاب کنید تا بیماری‌های احتمالی اینجا نمایش داده شوند.';

  @override
  String get diagnosisNoMatch =>
      'هیچ بیماری‌ای با نشانه‌های انتخاب‌شده جور نیست.';

  @override
  String diagnosisMatched(int matched, int total) {
    return 'نشانه‌های منطبق: $matched/$total';
  }

  @override
  String get diagnosisNotifiable => 'گزارش‌دادنی';

  @override
  String get diagnosisDisclaimer =>
      'این یک ارزیابی اولیه است؛ تشخیص نهایی را دامپزشک یا آزمایشگاه می‌دهد.';

  @override
  String get diagnosisLoadError => 'باز کردن جدول تشخیص ممکن نشد';

  @override
  String get diagnosisNotFound => 'بیماری پیدا نشد';

  @override
  String get diagnosisNotifiableTitle => 'بیماری گزارش‌دادنی.';

  @override
  String get diagnosisNotifiableMessage =>
      'ظن را به مرجع مربوط گزارش دهید؛ تجهیزات، قاب‌ها و عسل این کندو را با کندوهای دیگر به اشتراک نگذارید.';

  @override
  String get diagnosisAdvice => 'چه باید کرد';

  @override
  String get diagnosisAuthority => 'مرجع';

  @override
  String diagnosisCall(String phone) {
    return 'تماس با $phone';
  }

  @override
  String get diagnosisCallFailed => 'شروع تماس ممکن نشد';

  @override
  String get diagnosisQuarantine => 'قرنطینه یک کندو';

  @override
  String get quarantinePickTitle => 'کندو برای قرنطینه';

  @override
  String get quarantineSearchHint => 'شماره کندو';

  @override
  String get quarantineNoHivesTitle => 'کندویی نیست';

  @override
  String get quarantineNoHivesMessage => 'کندوی فعالی برای قرنطینه نیست.';

  @override
  String quarantineDone(String number) {
    return 'کندوی $number قرنطینه شد';
  }

  @override
  String get hiveQuarantined => 'در قرنطینه';

  @override
  String hiveQuarantineDisease(String disease) {
    return 'مشکوک: $disease';
  }

  @override
  String hiveQuarantineSince(String date) {
    return 'از $date';
  }

  @override
  String get hiveQuarantineWarning =>
      'تجهیزات، قاب‌ها و عسل آن را با کندوهای دیگر به اشتراک نگذارید.';

  @override
  String get hiveQuarantineEnd => 'پایان قرنطینه';

  @override
  String hiveQuarantineEnded(String number) {
    return 'کندوی $number از قرنطینه خارج شد';
  }

  @override
  String get calculatorSyrup => 'شربت';

  @override
  String get calculatorSyrupSubtitle => 'شکر و آب لازم';

  @override
  String get calculatorDose => 'دوز درمان';

  @override
  String get calculatorDoseSubtitle => 'مجموع برای تعداد کندوهای شما';

  @override
  String get calculatorQueen => 'تقویم ملکه';

  @override
  String get calculatorQueenSubtitle => 'روز هر مرحله از روز پیوند';

  @override
  String get calculatorYield => 'محصول';

  @override
  String get calculatorYieldSubtitle => 'عسل هر کندو';

  @override
  String get calculatorOffline =>
      'محاسبه‌ها بدون اینترنت کار می‌کنند و چیزی ذخیره نمی‌کنند.';

  @override
  String get calculatorNotFound => 'ماشین‌حساب پیدا نشد';

  @override
  String get calculatorHives => 'تعداد کندو';

  @override
  String get calculatorSyrupKind => 'نوع شربت';

  @override
  String get calculatorFillHint => 'تعداد کندو و مقدار را وارد کنید.';

  @override
  String get calculatorDosePerHive => 'دوز هر کندو';

  @override
  String get calculatorDoseUnit => 'واحد';

  @override
  String get calculatorTotal => 'مجموع';

  @override
  String calculatorDoseTotal(String unit, String total) {
    String _temp0 = intl.Intl.selectLogic(unit, {
      'strip': '$total نوار',
      'ml': '$total میلی‌لیتر',
      'g': '$total گرم',
      'other': '$total دوز',
    });
    return '$_temp0';
  }

  @override
  String calculatorDoseCount(int count, String amount) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count کندو × $amount',
      one: '1 کندو × $amount',
    );
    return '$_temp0';
  }

  @override
  String calculatorYieldTotal(String unit) {
    return 'کل عسل ($unit)';
  }

  @override
  String get calculatorYieldPerHive => 'برای هر کندو';

  @override
  String calculatorYieldValue(String amount, String unit) {
    return '$amount $unit';
  }

  @override
  String get calculatorQueenSteps => 'مراحل';

  @override
  String get hiveLossWintering => 'زمستان‌گذرانی';

  @override
  String get hiveLossQueenless => 'بی‌ملکگی';

  @override
  String get hiveLossVarroa => 'واروآ';

  @override
  String get hiveLossDisease => 'بیماری';

  @override
  String get hiveLossStarvation => 'گرسنگی';

  @override
  String get hiveLossRobbing => 'دزدی';

  @override
  String get hiveLossPredator => 'خرس / جانور';

  @override
  String get hiveLossPoisoning => 'مسمومیت';

  @override
  String get hiveLossOther => 'دیگر';

  @override
  String get hiveLossUnspecified => 'مشخص نشده';

  @override
  String hiveLossReasonTitle(String number) {
    return 'چرا کندوی $number از دست رفت؟';
  }

  @override
  String get hiveLossSkip => 'رد شدن بدون دلیل';

  @override
  String get hiveFormLossReason => 'علت از دست رفتن';

  @override
  String get hiveFormLossReasonHelper =>
      'در گزارش فصل به کار می‌رود؛ می‌تواند خالی بماند.';

  @override
  String get seasonReportTile => 'گزارش فصل';

  @override
  String seasonTitle(String year) {
    return 'فصل $year';
  }

  @override
  String get seasonPdf => 'PDF';

  @override
  String get seasonExportCsv => 'خروجی اکسل (CSV)';

  @override
  String get seasonExportError => 'ساخت فایل ممکن نشد. دوباره تلاش کنید.';

  @override
  String get seasonLoadError => 'بارگیری گزارش فصل ممکن نشد.';

  @override
  String get seasonHives => 'کندوها';

  @override
  String seasonHiveChange(int start, int end) {
    return '$start ← $end';
  }

  @override
  String seasonNetGain(int count) {
    return '+$count خالص';
  }

  @override
  String seasonNetLoss(int count) {
    return '−$count خالص';
  }

  @override
  String get seasonNetSame => 'بدون تغییر';

  @override
  String get seasonWinterLoss => 'تلفات زمستان';

  @override
  String get seasonWinterNotStarted => 'زمستان شروع نشده';

  @override
  String seasonPreviousWinter(String year) {
    return 'تلفات زمستان $year';
  }

  @override
  String seasonPreviousWinterRate(String year, String rate) {
    return '$year: $rate';
  }

  @override
  String get seasonHoney => 'کل عسل';

  @override
  String get seasonNewQueens => 'ملکه‌های جدید';

  @override
  String seasonOwnReared(int count) {
    return 'پرورش خودی $count';
  }

  @override
  String get seasonLossesTitle => 'تلفات و علت‌ها';

  @override
  String get seasonNoLosses => 'در این فصل کندویی از دست نرفت.';

  @override
  String seasonHiveCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count کندو',
      one: '1 کندو',
    );
    return '$_temp0';
  }

  @override
  String get seasonByTreatment => 'تلفات زمستان · بر اساس روش درمان';

  @override
  String get seasonByApiary => 'تلفات زمستان · بر اساس زنبورستان';

  @override
  String get seasonByQueenLine => 'تلفات زمستان · بر اساس لاین ملکه';

  @override
  String get seasonTabTreatment => 'درمان';

  @override
  String get seasonTabApiary => 'زنبورستان';

  @override
  String get seasonTabQueenLine => 'لاین ملکه';

  @override
  String get seasonNoWinterData => 'در سوابق شما هنوز کندویی وارد زمستان نشده.';

  @override
  String get seasonFewData => 'داده کم';

  @override
  String get seasonMisleadingNote =>
      'از سوابق خودتان؛ با کندوهای کم ممکن است گمراه‌کننده باشد.';

  @override
  String get seasonUntreated => 'درمان‌نشده';

  @override
  String get seasonMethodSeparator => ' +';

  @override
  String get seasonQueenLineUnknown => 'لاین نامشخص';

  @override
  String get seasonFinanceTitle => 'هزینه و سود';

  @override
  String get seasonProfit => 'سود';

  @override
  String get seasonPdfFigure => 'شاخص';

  @override
  String get seasonPdfValue => 'مقدار';

  @override
  String seasonPdfHiveChange(int start, int end, String net) {
    return '$start ← $end ($net)';
  }

  @override
  String seasonPdfNewQueens(int count, int own) {
    return '$count (پرورش خودی $own)';
  }

  @override
  String seasonPdfWinterLoss(String rate, int lost, int hives) {
    return '$rate ($lost از $hives کندو)';
  }

  @override
  String get seasonPdfReason => 'علت';

  @override
  String get seasonPdfHives => 'کندوها';

  @override
  String get seasonPdfLost => 'از دست رفته';

  @override
  String get seasonPdfRate => 'تلفات';

  @override
  String get seasonPdfGroup => 'گروه';

  @override
  String get seasonPdfTotal => 'مجموع';

  @override
  String get seasonCsvHive => 'کندو';

  @override
  String get seasonCsvApiary => 'زنبورستان';

  @override
  String get seasonCsvStartStatus => 'وضعیت آغاز فصل';

  @override
  String get seasonCsvEndStatus => 'وضعیت پایان فصل';

  @override
  String get seasonCsvLossDate => 'تاریخ از دست رفتن';

  @override
  String get seasonCsvLossReason => 'علت از دست رفتن';

  @override
  String get seasonCsvInWinter => 'وارد زمستان شد';

  @override
  String get seasonCsvLostInWinter => 'در زمستان از دست رفت';

  @override
  String get seasonCsvWinterApiary => 'زنبورستان زمستانی';

  @override
  String get seasonCsvTreatment => 'درمان پیش از زمستان';

  @override
  String get seasonCsvQueenLine => 'لاین ملکه';

  @override
  String get seasonCsvAddedInSeason => 'اضافه‌شده در این فصل';

  @override
  String get seasonCsvYes => 'بله';

  @override
  String get seasonCsvNo => 'خیر';

  @override
  String get offlineMapsTitle => 'نقشه‌های آفلاین';

  @override
  String get offlineMapsIntro =>
      'اطراف زنبورستان‌ها را دریافت کنید؛ نقشه حتی بدون آنتن هم باز می‌شود.';

  @override
  String offlineMapsMegabytes(String size) {
    return '$size مگابایت';
  }

  @override
  String offlineMapsApproxSize(String size) {
    return '≈ $size';
  }

  @override
  String offlineMapsDownloaded(String size) {
    return 'دریافت‌شده · $size';
  }

  @override
  String offlineMapsDownloadingWifi(String received, String total) {
    return 'در حال دریافت با Wi‑Fi · $received / $total';
  }

  @override
  String offlineMapsDownloading(String received, String total) {
    return 'در حال دریافت · $received / $total';
  }

  @override
  String offlineMapsDownload(String name) {
    return 'دریافت $name';
  }

  @override
  String get offlineMapsCancel => 'توقف دریافت';

  @override
  String offlineMapsDelete(String name) {
    return 'حذف $name';
  }

  @override
  String offlineMapsDeleteTitle(String name) {
    return '$name حذف شود؟';
  }

  @override
  String get offlineMapsDeleteMessage =>
      'بدون اینترنت، نقشه اطراف این زنبورستان باز نمی‌شود. هر وقت خواستید می‌توانید دوباره دریافت کنید.';

  @override
  String get offlineMapsDeleteConfirm => 'حذف';

  @override
  String get offlineMapsWifiOnly => 'دریافت فقط با Wi‑Fi';

  @override
  String get offlineMapsWifiOnlyHint =>
      'چند مگابایت برای هر زنبورستان؛ از داده همراه استفاده نمی‌شود.';

  @override
  String offlineMapsStop(String name) {
    return 'ایستگاه $name';
  }

  @override
  String offlineMapsDone(String name) {
    return 'اطراف $name دریافت شد';
  }

  @override
  String offlineMapsFailed(String name) {
    return 'دریافت اطراف $name ممکن نشد. اتصال را بررسی کنید و دوباره تلاش کنید.';
  }

  @override
  String get offlineMapsNeedsWifi =>
      'به Wi‑Fi وصل شوید یا «دریافت فقط با Wi‑Fi» را خاموش کنید.';

  @override
  String get offlineMapsAttribution =>
      'داده‌های نقشه © OpenStreetMap contributors · OpenFreeMap';

  @override
  String get settingsOfflineMaps => 'نقشه‌های آفلاین';

  @override
  String settingsOfflineMapsValue(int count, String size) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count زنبورستان · $size',
      one: '1 زنبورستان · $size',
      zero: 'هیچ',
    );
    return '$_temp0';
  }

  @override
  String get offlineMapsCoverage =>
      'هر زنبورستان 6 کیلومتر اطراف را با جزئیات و 40 کیلومتر را به‌صورت کلی می‌گیرد.';

  @override
  String offlineMapsDownloadedOn(String date) {
    return 'دریافت: $date';
  }

  @override
  String get offlineMapsToDownload => 'زنبورستان‌های دریافتی';

  @override
  String get offlineMapsMoved => 'زنبورستان جابه‌جا شده، دوباره دریافت کنید';

  @override
  String get offlineMapsNoApiaries =>
      'زنبورستانی با موقعیت نیست. به یک زنبورستان موقعیت بدهید تا اینجا نمایش داده شود.';

  @override
  String get offlineMapsAllDownloaded =>
      'همه زنبورستان‌های دارای موقعیت دریافت شده‌اند.';

  @override
  String get syncReminderTitle => 'سوابق شما هنوز پشتیبان‌گیری نشده';

  @override
  String syncReminderBody(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other:
          '$count سابقه 3 روز است به سرور نرسیده‌اند. وقتی آنلاین شدید برنامه را باز کنید.',
      one: '1 سابقه 3 روز است به سرور نرسیده. وقتی آنلاین شدید برنامه را باز کنید.',
    );
    return '$_temp0';
  }

  @override
  String get syncOverdueTitle => 'بیش از 3 روز بدون پشتیبان';

  @override
  String syncOverdueMessage(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other:
          '$count سابقه فقط روی این گوشی هستند. اگر گوشی گم شود، آن‌ها هم از بین می‌روند. به اینترنت وصل شوید و همگام کنید.',
      one: '1 سابقه فقط روی این گوشی است. اگر گوشی گم شود، آن هم از بین می‌رود. به اینترنت وصل شوید و همگام کنید.',
    );
    return '$_temp0';
  }

  @override
  String syncDaysAgo(int days) {
    String _temp0 = intl.Intl.pluralLogic(
      days,
      locale: localeName,
      other: '$days روز پیش',
      one: 'دیروز',
      zero: 'امروز',
    );
    return '$_temp0';
  }

  @override
  String syncLastSyncedAgo(String ago, String when) {
    return 'آخرین همگام‌سازی $ago · $when';
  }

  @override
  String syncPendingTitle(int count) {
    return 'در انتظار ارسال · $count';
  }

  @override
  String settingsSignOutPendingMessage(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other:
          '$count سابقه هنوز به سرور فرستاده نشده و فقط روی این گوشی هستند. اگر خارج شوید، فرستاده نمی‌شوند. ابتدا به اینترنت وصل شوید و همگام کنید.',
      one: '1 سابقه هنوز به سرور فرستاده نشده و فقط روی این گوشی است. اگر خارج شوید، فرستاده نمی‌شود. ابتدا به اینترنت وصل شوید و همگام کنید.',
    );
    return '$_temp0';
  }

  @override
  String get settingsSignOutAnyway => 'با این حال خارج شوید';

  @override
  String get settingsExport => 'خروجی داده‌ها';

  @override
  String get settingsExportValue => 'Excel';

  @override
  String get settingsExportHint =>
      'همه سوابق شما در یک فایل اکسل؛ هر جا خواستید به اشتراک بگذارید یا ذخیره کنید.';

  @override
  String get exportPreparing => 'در حال آماده‌سازی…';

  @override
  String get exportFailed => 'آماده‌سازی فایل ممکن نشد. دوباره تلاش کنید.';

  @override
  String exportFileName(String date) {
    return 'Mobil Arıcı $date';
  }

  @override
  String get exportYes => 'بله';

  @override
  String get exportNo => 'خیر';

  @override
  String get exportSheetApiaries => 'زنبورستان‌ها';

  @override
  String get exportSheetHives => 'کندوها';

  @override
  String get exportSheetQueens => 'ملکه‌ها';

  @override
  String get exportSheetInspections => 'بازدیدها';

  @override
  String get exportSheetFeedings => 'تغذیه‌ها';

  @override
  String get exportSheetTreatments => 'درمان‌ها';

  @override
  String get exportSheetMiteCounts => 'شمارش‌های واروآ';

  @override
  String get exportSheetHarvests => 'برداشت‌ها';

  @override
  String get exportSheetTasks => 'کارها';

  @override
  String get exportSheetInventory => 'انبار';

  @override
  String get exportSheetFinance => 'درآمد و هزینه';

  @override
  String get exportColName => 'نام';

  @override
  String get exportColLatitude => 'عرض جغرافیایی';

  @override
  String get exportColLongitude => 'طول جغرافیایی';

  @override
  String get exportColAltitude => 'ارتفاع (متر)';

  @override
  String get exportColWaterSource => 'منبع آب';

  @override
  String get exportColVehicleDistance => 'فاصله تا خودرو (متر)';

  @override
  String get exportColRoadNotes => 'یادداشت‌های راه';

  @override
  String get exportColNotes => 'یادداشت‌ها';

  @override
  String get exportColActiveHives => 'کندوهای فعال';

  @override
  String get exportColCreated => 'افزوده‌شده';

  @override
  String get exportColApiary => 'زنبورستان';

  @override
  String get exportColHive => 'کندو';

  @override
  String get exportColType => 'نوع';

  @override
  String get exportColStatus => 'وضعیت';

  @override
  String get exportColBoxes => 'طبقه‌ها';

  @override
  String get exportColFrames => 'قاب‌ها';

  @override
  String get exportColSource => 'منشأ';

  @override
  String get exportColMarking => 'نشانه‌گذاری';

  @override
  String get exportColTag => 'کد برچسب';

  @override
  String get exportColQuarantine => 'قرنطینه';

  @override
  String get exportColQueen => 'ملکه';

  @override
  String get exportColYear => 'سال';

  @override
  String get exportColColor => 'رنگ علامت';

  @override
  String get exportColBreed => 'نژاد';

  @override
  String get exportColLine => 'لاین';

  @override
  String get exportColWingClipped => 'بال چیده‌شده';

  @override
  String get exportColDate => 'تاریخ';

  @override
  String get exportColQueenState => 'ملکه';

  @override
  String get exportColBeeFrames => 'قاب‌های زنبور';

  @override
  String get exportColBroodFrames => 'قاب‌های نوزاد';

  @override
  String get exportColHoneyFrames => 'قاب‌های عسل';

  @override
  String get exportColTemperament => 'رفتار';

  @override
  String get exportColSwarmSigns => 'نشانه‌های بچه‌دهی';

  @override
  String get exportColQueenCells => 'شان ملکه';

  @override
  String get exportColDisease => 'مشکوک به بیماری';

  @override
  String get exportColActions => 'انجام‌شده';

  @override
  String get exportColAmount => 'مقدار';

  @override
  String get exportColUnit => 'واحد';

  @override
  String get exportColProduct => 'فراورده';

  @override
  String get exportColActiveIngredient => 'ماده مؤثر';

  @override
  String get exportColDose => 'دوز';

  @override
  String get exportColWithdrawal => 'انتظار (روز)';

  @override
  String get exportColBatch => 'شماره سری';

  @override
  String get exportColPlannedRemoval => 'برداشتن برنامه‌ریزی‌شده';

  @override
  String get exportColMethod => 'روش';

  @override
  String get exportColMites => 'کنه‌ها';

  @override
  String get exportColSampleBees => 'زنبورهای نمونه';

  @override
  String get exportColDays => 'روزها';

  @override
  String get exportColResult => 'نتیجه';

  @override
  String get exportColHoneyKind => 'عسل';

  @override
  String get exportColUnitCount => 'تعداد';

  @override
  String get exportColNetKg => 'خالص (کیلوگرم)';

  @override
  String get exportColHiveCount => 'کندوها';

  @override
  String get exportColDue => 'موعد';

  @override
  String get exportColTitle => 'عنوان';

  @override
  String get exportColCompleted => 'انجام‌شده';

  @override
  String get exportColCategory => 'دسته';

  @override
  String get exportColPlace => 'مکان';

  @override
  String get exportColStock => 'موجودی';

  @override
  String get exportColThreshold => 'هشدار زیر';

  @override
  String get exportColCurrency => 'ارز';

  @override
  String get exportColDescription => 'توضیح';

  @override
  String get businessTitle => 'کسب‌وکار';

  @override
  String get businessEdit => 'ویرایش';

  @override
  String get businessEditTitle => 'ویرایش کسب‌وکار';

  @override
  String get businessCancel => 'لغو';

  @override
  String get businessSave => 'ذخیره';

  @override
  String get businessSaveError =>
      'ذخیره ممکن نشد؛ کسب‌وکار هنوز روی این گوشی نیست.';

  @override
  String get businessMissingTitle => 'اطلاعات کسب‌وکار نیست';

  @override
  String get businessMissingMessage =>
      'وقتی کسب‌وکار به این گوشی برسد اینجا نمایش داده می‌شود.';

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
  String get businessRegionTr => 'نمایه TR';

  @override
  String get businessRegionOther => 'نمایه عمومی';

  @override
  String get businessPendingSync => 'هنوز همگام نشده';

  @override
  String businessCountHives(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'کندو',
    );
    return '$_temp0';
  }

  @override
  String businessCountApiaries(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'زنبورستان',
    );
    return '$_temp0';
  }

  @override
  String businessCountInspections(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'بازدید',
    );
    return '$_temp0';
  }

  @override
  String get businessSectionBusiness => 'کسب‌وکار';

  @override
  String get businessSectionAccount => 'حساب';

  @override
  String get businessType => 'نوع';

  @override
  String get businessTypeMigratory => 'کوچ‌رو';

  @override
  String get businessTypeStationary => 'ثابت';

  @override
  String get businessTypeHelp =>
      'در حالت ثابت برنامه‌های کوچ و جابه‌جایی‌ها پنهان می‌شوند؛ سوابق حذف نمی‌شوند.';

  @override
  String get businessCurrency => 'ارز';

  @override
  String get businessCurrencySearch => 'جستجوی کد یا کشور';

  @override
  String get businessCurrencyNoMatch => 'هیچ ارزی با جستجوی شما جور نیست.';

  @override
  String get businessCurrencyNote =>
      'سوابق گذشته تبدیل نمی‌شوند؛ ارز جدید فقط برای سوابق از این به بعد است.';

  @override
  String businessTeamTitle(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'تیم · $count نفر',
      one: 'تیم · 1 نفر',
    );
    return '$_temp0';
  }

  @override
  String get businessTeamSolo => 'هنوز عضوی در تیم نیست';

  @override
  String businessRoleCountOwner(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count مالک',
      one: '1 مالک',
    );
    return '$_temp0';
  }

  @override
  String businessRoleCountPartner(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count شریک',
      one: '1 شریک',
    );
    return '$_temp0';
  }

  @override
  String businessRoleCountWorker(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count کارگر',
      one: '1 کارگر',
    );
    return '$_temp0';
  }

  @override
  String businessRoleCountViewer(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count مشاور',
      one: '1 مشاور',
    );
    return '$_temp0';
  }

  @override
  String get businessEmail => 'ایمیل ورود';

  @override
  String get businessEmailSoon => 'تغییر ایمیل به‌زودی می‌آید.';

  @override
  String get businessFirstRecord => 'نخستین سابقه';

  @override
  String businessFirstRecordValue(String date, int season) {
    return '$date · فصل $season';
  }

  @override
  String get businessSettingsShortcut => 'زبان، واحدها، پوسته و داده‌ها';

  @override
  String get businessNameLabel => 'نام کسب‌وکار';

  @override
  String get businessAvatarLabel => 'آواتار';

  @override
  String get businessAvatarHelp =>
      'بدون نشان‌واره، حروف اول نام شما با رنگی که انتخاب می‌کنید نمایش داده می‌شود.';

  @override
  String get businessAvatarPine => 'کاج';

  @override
  String get businessAvatarHoney => 'عسل';

  @override
  String get businessAvatarSky => 'آسمان';

  @override
  String get businessAvatarSlate => 'سنگ لوح';

  @override
  String get businessLogoUpload => 'بارگذاری نشان‌واره';

  @override
  String get businessLogoRemove => 'حذف نشان‌واره';

  @override
  String get businessDiscardTitle => 'تغییرات کنار گذاشته شود؟';

  @override
  String get businessDiscardMessage => 'تغییرات ذخیره‌نشده از دست می‌روند.';

  @override
  String get businessDiscardAction => 'کنار گذاشتن';

  @override
  String get businessTypeConfirmTitle => 'به حالت ثابت تغییر کند؟';

  @override
  String businessTypeConfirmMessage(int plans, int stops) {
    String _temp0 = intl.Intl.pluralLogic(
      plans,
      locale: localeName,
      other: '$plans برنامه کوچ',
      one: '1 برنامه کوچ',
    );
    String _temp1 = intl.Intl.pluralLogic(
      stops,
      locale: localeName,
      other: '$stops ایستگاه',
      one: '1 ایستگاه',
    );
    return '$_temp0 و $_temp1 پنهان می‌شوند. سوابق حذف نمی‌شوند؛ می‌توانید برگردانید.';
  }

  @override
  String get businessTypeConfirmAction => 'تغییر';

  @override
  String get businessReadOnly =>
      'فقط مالک و شریک‌ها می‌توانند اطلاعات کسب‌وکار را تغییر دهند.';

  @override
  String get financeOtherCurrencies => 'ارزهای دیگر';

  @override
  String financeOtherCurrencyLine(String currency, String amount) {
    return '$currency · خالص $amount';
  }

  @override
  String get migratoryHiddenTitle => 'بخش کوچ خاموش است';

  @override
  String get migratoryHiddenMessage =>
      'کسب‌وکار شما ثابت است. برنامه‌های کوچ و جابه‌جایی‌ها حذف نمی‌شوند؛ اگر به کوچ‌رو تغییر دهید برمی‌گردند.';

  @override
  String get onboardingMigratoryTitle => 'کندوهایتان را کوچ می‌دهید؟';

  @override
  String get onboardingMigratoryMessage =>
      'اگر نه، برنامه‌های کوچ و جابه‌جایی‌ها پنهان می‌شوند؛ هر وقت خواستید در نمایه کسب‌وکار تغییر دهید.';

  @override
  String get onboardingMigratoryYes => 'بله';

  @override
  String get onboardingMigratoryNo => 'نه، ثابت';

  @override
  String get settingsDeleteAccount => 'حذف حساب من';

  @override
  String get settingsDeleteAccountOffline =>
      'حذف حساب به اتصال اینترنت نیاز دارد؛ وقتی آنلاین شدید دوباره تلاش کنید.';

  @override
  String get deletionTitle => 'حذف حساب من';

  @override
  String deletionStepCounter(int current, int total) {
    return 'مرحله $current از $total';
  }

  @override
  String get deletionContinue => 'ادامه';

  @override
  String get deletionSoloTitle => 'حساب و کسب‌وکار شما حذف می‌شوند';

  @override
  String deletionSoloMessage(String organization) {
    return 'شما تنها فرد در $organization هستید. حذف حسابتان کسب‌وکار و همه سوابق آن را هم حذف می‌کند.';
  }

  @override
  String get deletionCountsLabel => 'سوابقی که حذف می‌شوند';

  @override
  String get deletionCountHives => 'کندوها';

  @override
  String get deletionCountApiaries => 'زنبورستان‌ها';

  @override
  String get deletionCountInspections => 'بازدیدها';

  @override
  String get deletionCountHarvests => 'برداشت‌ها';

  @override
  String get deletionCountDocuments => 'مدارک';

  @override
  String get deletionCountPhotos => 'عکس‌ها';

  @override
  String get deletionLotWarningTitle => 'کدهای QR از کار می‌افتند.';

  @override
  String deletionLotWarningMessage(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other:
          '$count صفحه عمومی بچ حذف می‌شوند و کدهای QR روی شیشه‌هایتان از کار می‌افتند.',
      one: '1 صفحه عمومی بچ حذف می‌شود و کدهای QR روی شیشه‌هایتان از کار می‌افتند.',
    );
    return '$_temp0';
  }

  @override
  String get deletionTeamTitle => 'تیم دارید: سرنوشت کسب‌وکار را انتخاب کنید';

  @override
  String deletionTeamMessage(int count, String organization) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'مالک $organization هستید و $count نفر دیگر در تیم هستند.',
      one: 'مالک $organization هستید و 1 نفر دیگر در تیم است.',
    );
    return '$_temp0';
  }

  @override
  String get deletionChoiceTransfer => 'واگذاری مالکیت و ترک';

  @override
  String get deletionChoiceTransferHint =>
      'کسب‌وکار و سوابقش می‌مانند. شریکی که انتخاب می‌کنید مالک می‌شود؛ فقط حساب شما حذف می‌شود.';

  @override
  String get deletionChoiceDelete => 'حذف کسب‌وکار و همه سوابق';

  @override
  String deletionChoiceDeleteHint(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count نفر دیگر تیم هم دسترسی‌شان را از دست می‌دهند.',
      one: 'فرد دیگر تیم هم دسترسی‌اش را از دست می‌دهد.',
    );
    return '$_temp0';
  }

  @override
  String get deletionTransferPick => 'مالک جدید';

  @override
  String get deletionTransferNoPartner =>
      'برای واگذاری، کسی در تیم باید شریک باشد. در صفحه تیم عضوی را شریک کنید یا کسب‌وکار را حذف کنید.';

  @override
  String get deletionPartnerFallbackName => 'شریک';

  @override
  String get deletionMemberTitle => 'فقط حساب شما حذف می‌شود';

  @override
  String deletionMemberMessage(String organization) {
    return '$organization و سوابقش حذف نمی‌شوند. سوابقی که وارد کرده‌اید در کسب‌وکار می‌مانند؛ نام شما از تیم برداشته می‌شود.';
  }

  @override
  String get deletionUnknownMessage =>
      'عضویت شما هنوز به این گوشی نرسیده. پس از همگام‌سازی دوباره تلاش کنید.';

  @override
  String get deletionGraceNote =>
      'حذف پس از 7 روز قطعی می‌شود؛ تا آن زمان می‌توانید وارد شوید و نظرتان را عوض کنید.';

  @override
  String get deletionBackupTitle => 'ابتدا داده‌هایتان را ذخیره کنید';

  @override
  String get deletionBackupMessage =>
      'سوابق حذف‌شده بازیابی نمی‌شوند. پیشنهاد می‌کنیم اول یک نسخه ذخیره کنید.';

  @override
  String get deletionBackupReports => 'گزارش‌های PDF';

  @override
  String get deletionBackupReportsHint =>
      'گزارش‌های آماده را به‌صورت PDF دریافت کنید.';

  @override
  String get deletionBackupJson => 'همه سوابق';

  @override
  String get deletionBackupJsonValue => 'JSON';

  @override
  String get deletionBackupJsonHint =>
      'همه سوابق شما در یک فایل؛ هر جا خواستید ذخیره کنید.';

  @override
  String get deletionBackupSaved => 'ذخیره شد';

  @override
  String get deletionBackupDownload => 'دریافت سوابق من';

  @override
  String get deletionBackupSkip => 'رد شدن';

  @override
  String deletionBackupFileName(String date) {
    return 'mobil-arici-records-$date';
  }

  @override
  String get deletionVerifyTitle => 'تأیید کنید که خودتان هستید';

  @override
  String get deletionVerifyButton => 'بررسی کد';

  @override
  String get deletionConfirmTitle => 'تأیید نهایی';

  @override
  String get deletionConfirmIntro => 'اگر تأیید کنید:';

  @override
  String deletionConsequenceAccount(String date) {
    return 'حساب شما در $date برای همیشه حذف می‌شود.';
  }

  @override
  String deletionConsequenceOrganization(String organization) {
    return '$organization و همه سوابقش هم حذف می‌شوند.';
  }

  @override
  String deletionConsequenceTransfer(String name, String organization) {
    return '$name مالک جدید $organization می‌شود.';
  }

  @override
  String get deletionConsequenceRecordsStay => 'سوابق کسب‌وکار حذف نمی‌شوند.';

  @override
  String deletionConsequenceLots(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count صفحه بچ بسته می‌شوند؛ کدهای QR آن‌ها از کار می‌افتند.',
      one: '1 صفحه بچ بسته می‌شود؛ کدهای QR آن از کار می‌افتند.',
    );
    return '$_temp0';
  }

  @override
  String get deletionConsequenceSignOut =>
      'از حساب خارج می‌شوید و داده‌های این گوشی پاک می‌شوند.';

  @override
  String get deletionConsequenceCancel =>
      'اگر پیش از آن وارد شوید، می‌توانید حذف را لغو کنید.';

  @override
  String deletionConfirmTypeName(String organization) {
    return 'برای تأیید، نام کسب‌وکار را بنویسید: $organization';
  }

  @override
  String deletionConfirmTypeKeyword(String keyword) {
    return 'برای تأیید، $keyword را بنویسید';
  }

  @override
  String get deletionKeyword => 'حذف';

  @override
  String get deletionConfirmButton => 'حذف حساب من';

  @override
  String get deletionConfirmButtonWithOrganization => 'حذف حساب و کسب‌وکار من';

  @override
  String get deletionSubmitting => 'در حال ارسال…';

  @override
  String get deletionFailureNetwork =>
      'دسترسی به سرور ممکن نشد. اتصال را بررسی کنید و دوباره تلاش کنید.';

  @override
  String get deletionFailureOwnerMustTransfer =>
      'شما مالک کسب‌وکار دیگری با تیم هم هستید. ابتدا مالکیت آن را واگذار کنید.';

  @override
  String get deletionFailureInvalidTransfer =>
      'فردی که انتخاب کردید دیگر شریک نیست. شریک دیگری انتخاب کنید.';

  @override
  String get deletionFailureRateLimited =>
      'تلاش‌ها در زمان کوتاه بیش از حد است. فردا دوباره تلاش کنید.';

  @override
  String get deletionFailureForbidden =>
      'نشست شما تمام شده. دوباره وارد شوید و تلاش کنید.';

  @override
  String get deletionFailureCodeRequired =>
      'تأیید شما منقضی شده. کد جدیدی بگیرید و دوباره تأیید کنید.';

  @override
  String get deletionFailureUnknown =>
      'ارسال درخواست ممکن نشد. کمی بعد دوباره تلاش کنید.';

  @override
  String get deletionDoneTitle => 'درخواست شما را دریافت کردیم';

  @override
  String deletionDoneDate(String date) {
    return 'حساب شما در $date برای همیشه حذف می‌شود.';
  }

  @override
  String get deletionDoneCancelHint =>
      'اگر نظرتان عوض شد، پیش از آن تاریخ وارد شوید تا حذف لغو شود.';

  @override
  String get deletionDoneEmail => 'جزئیات را به ایمیلتان هم فرستادیم.';

  @override
  String get deletionDoneClearing => 'در حال پاک کردن داده‌های این گوشی…';

  @override
  String get deletionDoneSignedOut =>
      'از حساب خارج شدید و داده‌های این گوشی پاک شد.';

  @override
  String get deletionDoneAction => 'تمام';

  @override
  String get deletionPendingTitle => 'حساب شما به‌زودی حذف می‌شود';

  @override
  String deletionPendingMessage(String date) {
    return 'حساب شما در $date حذف می‌شود. اگر ادامه دهید، حذف لغو می‌شود.';
  }

  @override
  String get deletionPendingContinue => 'ادامه و نگه داشتن حساب';

  @override
  String get deletionPendingSignOut => 'خروج و حفظ حذف';

  @override
  String get deletionPendingCancelled => 'حذف لغو شد. خوش برگشتید!';

  @override
  String get deletionPendingCancelFailed =>
      'لغو حذف ممکن نشد. اتصال را بررسی کنید و دوباره تلاش کنید.';

  @override
  String teamMemberLeaving(String date) {
    return 'در حال حذف حساب · $date';
  }

  @override
  String get teamErrorMemberLeaving =>
      'این فرد در حال حذف حسابش است؛ در دوره انتظار نقش او تغییر نمی‌کند و حذف نمی‌شود.';

  @override
  String get teamErrorTooManyAttempts =>
      'تعداد تلاش‌ها برای کد بیش از حد است. یک دقیقه صبر کنید و دوباره تلاش کنید.';
}
