// ignore: unused_import
import 'package:intl/intl.dart' as intl;

import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Turkish (`tr`).
class AppLocalizationsTr extends AppLocalizations {
  AppLocalizationsTr([String locale = 'tr']) : super(locale);

  @override
  String get appTitle => 'Mobil Arıcı';

  @override
  String get listSeparator => ', ';

  @override
  String get stepperIncrease => 'Artır';

  @override
  String get stepperDecrease => 'Azalt';

  @override
  String hiveTileLabel(String number) {
    return 'Kovan $number';
  }

  @override
  String hiveTileStrength(int strength) {
    return 'Güç $strength/5';
  }

  @override
  String hiveTileQueenColor(String color) {
    String _temp0 = intl.Intl.selectLogic(color, {
      'white': 'beyaz',
      'yellow': 'sarı',
      'red': 'kırmızı',
      'green': 'yeşil',
      'blue': 'mavi',
      'other': 'bilinmiyor',
    });
    return 'Ana arı rengi $_temp0';
  }

  @override
  String get tabToday => 'Bugün';

  @override
  String get tabApiaries => 'Arılıklar';

  @override
  String get tabTasks => 'Görevler';

  @override
  String get tabMore => 'Daha fazla';

  @override
  String get todayEmptyTitle => 'Bugün için bir şey yok';

  @override
  String get todayEmptyMessage =>
      'Bugünkü görevler, dikkat isteyen kovanlar ve hava durumu burada toplanacak.';

  @override
  String get apiariesEmptyTitle => 'Henüz arılık yok';

  @override
  String get apiariesEmptyMessage =>
      'Arılık, kovanlarını bulundukları yere göre toplar; arılık ekleme yakında gelecek.';

  @override
  String get tasksEmptyTitle => 'Henüz görev yok';

  @override
  String get tasksEmptyMessage =>
      'Hatırlatıcıların ve yapılacakların tarih sırasıyla burada listelenecek.';

  @override
  String get moreEmptyTitle => 'Diğer modüller yolda';

  @override
  String get moreEmptyMessage =>
      'Ana arılar, hasat, stok, finans, belgeler ve bilgi bankası burada olacak.';

  @override
  String get scanTitle => 'Okut';

  @override
  String get scanLongPressHint => 'hızlı kayıt menüsünü aç';

  @override
  String get scanPlaceholderTitle => 'Kovanı okut';

  @override
  String get scanPlaceholderMessage =>
      'Kovandaki QR kodu ya da NFC etiketini okutunca kovan kartı açılacak; okutma yakında gelecek.';

  @override
  String get quickRecordTitle => 'Hızlı kayıt';

  @override
  String get quickRecordInspection => 'Muayene';

  @override
  String get quickRecordFeeding => 'Besleme';

  @override
  String get quickRecordTreatment => 'İlaçlama';

  @override
  String get quickRecordHarvest => 'Hasat';

  @override
  String get quickRecordNote => 'Not';

  @override
  String get quickRecordExpense => 'Gider';

  @override
  String get quickRecordComingSoon => 'Bu kayıt türü yakında gelecek.';

  @override
  String get settingsTitle => 'Ayarlar';

  @override
  String get settingsSystemDefault => 'Sistem';

  @override
  String get settingsLanguage => 'Dil';

  @override
  String get languageTurkish => 'Türkçe';

  @override
  String get languageEnglish => 'English';

  @override
  String get settingsCountry => 'Ülke';

  @override
  String get settingsCountryTemporaryNote =>
      'Şimdilik buradan seçiliyor; ileride işletme kaydından gelecek.';

  @override
  String settingsCountryOption(String countryCode, String currencyCode) {
    return '$countryCode · $currencyCode';
  }

  @override
  String get settingsCountryPickerTitle => 'Ülke seç';

  @override
  String get settingsColorMode => 'Tema';

  @override
  String get settingsColorModeLight => 'Açık';

  @override
  String get settingsColorModeDark => 'Koyu';

  @override
  String get settingsColorModeSun => 'Güneş';

  @override
  String get devMenuTitle => 'Geliştirici menüsü';

  @override
  String get componentGalleryTitle => 'Bileşen galerisi';

  @override
  String get componentGalleryDescription =>
      'Tasarım sistemi bileşenleri dört temada';

  @override
  String get galleryThemeLight => 'Açık';

  @override
  String get galleryThemeDark => 'Koyu';

  @override
  String get galleryThemeSun => 'Güneş';

  @override
  String get galleryThemeGlove => 'Eldiven';

  @override
  String get galleryBigButton => 'Büyük buton';

  @override
  String get galleryChoiceChipGroup => 'Seçim chip\'leri';

  @override
  String get galleryBigStepper => 'Büyük sayaç';

  @override
  String get galleryStatusBadge => 'Durum rozeti';

  @override
  String get galleryHiveTile => 'Kovan karosu';

  @override
  String get galleryEmptyState => 'Boş durum';

  @override
  String get gallerySectionCard => 'Bölüm kartı';

  @override
  String get gallerySampleStartInspection => 'Muayene başlat';

  @override
  String get gallerySampleAddPhoto => 'Foto ekle';

  @override
  String get gallerySampleSave => 'Kaydet';

  @override
  String get gallerySampleQueen => 'Ana arı';

  @override
  String get gallerySampleQueenSeen => 'Görüldü';

  @override
  String get gallerySampleEggs => 'Yumurta var';

  @override
  String get gallerySampleNone => 'Yok';

  @override
  String get gallerySampleActions => 'Yapılan işlem';

  @override
  String get gallerySampleSuperAdded => 'Kat verildi';

  @override
  String get gallerySampleFrameAdded => 'Çerçeve eklendi';

  @override
  String get gallerySampleFed => 'Besleme';

  @override
  String get gallerySampleBeeFrames => 'Arılı çerçeve';

  @override
  String get gallerySampleBroodFrames => 'Yavrulu çerçeve';

  @override
  String get gallerySampleStrong => 'Güçlü';

  @override
  String get gallerySampleWeak => 'Zayıf';

  @override
  String get gallerySampleQueenless => 'Anasız';

  @override
  String get gallerySampleTask => 'Görev';

  @override
  String get gallerySampleNoApiaries => 'Henüz arılık yok';

  @override
  String get gallerySampleNoApiariesMessage =>
      'Arılık, kovanlarını bulundukları yere göre toplar; ilkini ekleyerek başla.';

  @override
  String get gallerySampleAddApiary => 'İlk arılığını ekle';

  @override
  String get gallerySampleLastInspection => 'Son muayene';

  @override
  String get gallerySampleLastInspectionBody =>
      '3 gün önce · 7 arılı çerçeve · ana arı görüldü';

  @override
  String get gallerySampleUntitledCard =>
      'Başlıksız kart da olur; içerik doğrudan başlar.';
}
