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
      'Arılık, kovanlarını bulundukları yere göre toplar; ilkini ekleyerek başla.';

  @override
  String get apiariesAdd => 'Arılık ekle';

  @override
  String get apiariesAddFirst => 'İlk arılığını ekle';

  @override
  String get apiariesLoadError => 'Arılıklar okunamadı.';

  @override
  String apiaryHiveCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count kovan',
      zero: 'Kovan yok',
    );
    return '$_temp0';
  }

  @override
  String apiaryLastVisit(String date) {
    return 'Son ziyaret $date';
  }

  @override
  String get apiaryNoVisit => 'Henüz ziyaret yok';

  @override
  String apiaryListSubtitle(String hives, String visit) {
    return '$hives · $visit';
  }

  @override
  String get apiaryActiveHives => 'Aktif kovan';

  @override
  String get apiaryLastVisitLabel => 'Son ziyaret';

  @override
  String get apiaryVisitNone => 'Henüz yok';

  @override
  String get apiaryEdit => 'Düzenle';

  @override
  String get apiaryNotFoundTitle => 'Arılık bulunamadı';

  @override
  String get apiaryNotFoundMessage =>
      'Silinmiş ya da bu cihaza henüz gelmemiş olabilir.';

  @override
  String get apiaryFormNewTitle => 'Yeni arılık';

  @override
  String get apiaryFormEditTitle => 'Arılığı düzenle';

  @override
  String get apiaryFormName => 'Arılık adı';

  @override
  String get apiaryFormNameHint => 'Örn. Yayla';

  @override
  String get apiaryFormLocation => 'Konum';

  @override
  String get apiaryFormLocationNone =>
      'Konum yok. Arılıktaysan GPS\'ten al; internet gerekmez.';

  @override
  String get apiaryFormLocationTake => 'Konumu GPS\'ten al';

  @override
  String get apiaryFormLocationRetake => 'Konumu yeniden al';

  @override
  String get apiaryFormLocationClear => 'Konumu kaldır';

  @override
  String get apiaryFormLocating =>
      'Konum alınıyor… Açık alanda daha çabuk bulunur.';

  @override
  String apiaryFormLocationAccuracy(int meters) {
    return 'Doğruluk ±$meters m';
  }

  @override
  String get apiaryFormLocationErrorServiceDisabled =>
      'Cihazın konum servisi kapalı. Açıp yeniden dene.';

  @override
  String get apiaryFormLocationErrorPermissionDenied =>
      'Konum izni verilmedi. Konumu almak için izin ver.';

  @override
  String get apiaryFormLocationErrorPermissionDeniedForever =>
      'Konum izni kapalı. Ayarlardan bu uygulamaya konum izni ver.';

  @override
  String get apiaryFormLocationErrorTimeout =>
      'Konum bulunamadı. Açık alanda yeniden dene.';

  @override
  String get apiaryFormLocationErrorUnknown => 'Konum alınamadı. Yeniden dene.';

  @override
  String get apiaryFormOpenSettings => 'Ayarları aç';

  @override
  String get apiaryFormLandownerName => 'Arazi sahibinin adı';

  @override
  String get apiaryFormLandownerPhone => 'Arazi sahibinin telefonu';

  @override
  String get apiaryFormNotes => 'Notlar';

  @override
  String get apiaryFormSave => 'Kaydet';

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
  String get signInTitle => 'Giriş yap';

  @override
  String get signInEmailMessage =>
      'E-posta adresini yaz, sana 6 haneli bir kod gönderelim. Şifre yok.';

  @override
  String get signInEmailLabel => 'E-posta';

  @override
  String get signInSendCode => 'Kod gönder';

  @override
  String get signInSending => 'Gönderiliyor…';

  @override
  String get signInCodeTitle => 'Kodu gir';

  @override
  String signInCodeMessage(String email) {
    return '$email adresine 6 haneli bir kod gönderdik.';
  }

  @override
  String get signInCodeFieldLabel => '6 haneli kod';

  @override
  String get signInVerify => 'Giriş yap';

  @override
  String get signInVerifying => 'Kontrol ediliyor…';

  @override
  String get signInResend => 'Kodu tekrar gönder';

  @override
  String signInResendIn(int seconds) {
    return 'Kodu tekrar gönder ($seconds sn)';
  }

  @override
  String get signInCodeResent => 'Yeni kod yolda.';

  @override
  String get authErrorNetwork =>
      'Bağlantı kurulamadı. İnternetini kontrol edip yeniden dene.';

  @override
  String get authErrorInvalidEmail => 'Geçerli bir e-posta adresi yaz.';

  @override
  String get authErrorInvalidCode =>
      'Kod yanlış ya da süresi dolmuş. Yeniden dene ya da yeni kod iste.';

  @override
  String get authErrorTooManyRequests =>
      'Çok sık denendi. Biraz bekleyip yeniden dene.';

  @override
  String get authErrorUnknown => 'Bir sorun çıktı. Yeniden dene.';

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
  String get settingsColorMode => 'Tema';

  @override
  String get settingsColorModeLight => 'Açık';

  @override
  String get settingsColorModeDark => 'Koyu';

  @override
  String get settingsColorModeSun => 'Güneş';

  @override
  String get settingsAccount => 'Hesap';

  @override
  String settingsSignedInAs(String email) {
    return '$email ile giriş yapıldı';
  }

  @override
  String get settingsSignOut => 'Çıkış yap';

  @override
  String get settingsSignOutConfirmTitle => 'Çıkış yapılsın mı?';

  @override
  String get settingsSignOutConfirmMessage =>
      'Yeniden girmek için e-postana yeni bir kod gelmesi gerekir; bunun için internet lazım.';

  @override
  String get actionCancel => 'Vazgeç';

  @override
  String get actionRetry => 'Yeniden dene';

  @override
  String onboardingStepCounter(int current, int total) {
    return 'Adım $current/$total';
  }

  @override
  String get onboardingContinue => 'Devam';

  @override
  String get onboardingFinish => 'İşletmeyi kur';

  @override
  String get onboardingFinishing => 'Kuruluyor…';

  @override
  String get onboardingLanguageTitle => 'Hangi dili kullanalım?';

  @override
  String get onboardingLanguageMessage =>
      'Dili sonra Ayarlar\'dan değiştirebilirsin.';

  @override
  String get onboardingCountryTitle => 'İşletmen hangi ülkede?';

  @override
  String get onboardingCountryMessage =>
      'Ülke; para birimini, ölçü birimlerini ve bölgeye özel modülleri belirler.';

  @override
  String get onboardingCountrySearch => 'Ülke ara';

  @override
  String get onboardingCountrySuggested => 'Cihazına göre önerilen';

  @override
  String get onboardingCountryAll => 'Tüm ülkeler';

  @override
  String get onboardingCountryNoMatch => 'Aramana uyan ülke yok.';

  @override
  String get onboardingNameTitle => 'İşletmenin adı ne?';

  @override
  String get onboardingNameMessage =>
      'Kayıtlarında ve raporlarında bu ad görünür.';

  @override
  String get onboardingNameLabel => 'İşletme adı';

  @override
  String get onboardingNameHint => 'Örn. Petek Arıcılık';

  @override
  String get onboardingHiveCountTitle => 'Kaç kovanın var?';

  @override
  String get onboardingHiveCountMessage =>
      'Yaklaşık sayı yeter; takibi buna göre önereceğiz. Kovanları sonra eklersin.';

  @override
  String get hiveCountRangeNone => 'Henüz yok';

  @override
  String get hiveCountRangeUpTo10 => '1–10';

  @override
  String get hiveCountRangeUpTo50 => '11–50';

  @override
  String get hiveCountRangeUpTo200 => '51–200';

  @override
  String get hiveCountRangeOver200 => '200\'den fazla';

  @override
  String get onboardingApiaryTitle => 'İlk arılığını ekle';

  @override
  String get onboardingApiaryMessage =>
      'Arılık, kovanlarının durduğu yer. Kaydetmek için internet gerekmez.';

  @override
  String get onboardingApiarySave => 'Arılığı kaydet';

  @override
  String get onboardingApiarySkip => 'Şimdilik atla';

  @override
  String get onboardingLoading => 'İşletme bilgisi yükleniyor';

  @override
  String get onboardingLoadErrorTitle => 'İşletme bilgisi alınamadı';

  @override
  String get onboardingErrorNetwork =>
      'Bağlantı kurulamadı. İnternetini kontrol edip yeniden dene.';

  @override
  String get onboardingErrorUnknown => 'Bir sorun çıktı. Yeniden dene.';

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
