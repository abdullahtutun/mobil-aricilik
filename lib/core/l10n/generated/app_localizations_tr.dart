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
  String get todayEmptyTitle => 'Arılığını ekleyerek başla';

  @override
  String get todayEmptyMessage =>
      'Üç adımda hazırsın: arılığını ekle, kovanlarını oluştur, ilk muayeneyi yap.';

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
  String get hiveSortWeakestFirst => 'Zayıflar önce';

  @override
  String get hivesEmptyTitle => 'Henüz kovan yok';

  @override
  String get hivesEmptyMessage =>
      'Bu arılıktaki kovanları ekle; hepsini tek seferde oluşturabilirsin.';

  @override
  String get hivesAdd => 'Kovan ekle';

  @override
  String get hivesAddOne => 'Tek kovan';

  @override
  String get hivesAddOneHint => 'Numarasını, tipini ve kaynağını gir';

  @override
  String get hivesAddBulk => 'Toplu oluştur';

  @override
  String get hivesAddBulkHint => 'Ör. 101\'den başlayarak 20 kovan';

  @override
  String hivesInactiveTitle(int count) {
    return 'Aktif olmayan ($count)';
  }

  @override
  String get hivesLoadError => 'Kovanlar okunamadı.';

  @override
  String hiveLabel(String number) {
    return 'Kovan $number';
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
  String get hiveTypeLocal => 'Yerel';

  @override
  String get hiveTypeOther => 'Diğer';

  @override
  String get hiveStatusActive => 'Aktif';

  @override
  String get hiveStatusDead => 'Söndü';

  @override
  String get hiveStatusMerged => 'Birleşti';

  @override
  String get hiveStatusSold => 'Satıldı';

  @override
  String get hiveStatusLost => 'Kayboldu';

  @override
  String get hiveSourceSwarm => 'Oğul';

  @override
  String get hiveSourceSplit => 'Bölme';

  @override
  String get hiveSourcePurchase => 'Satın alma';

  @override
  String get hiveSourcePackage => 'Paket arı';

  @override
  String get hiveFormNewTitle => 'Yeni kovan';

  @override
  String get hiveFormEditTitle => 'Kovanı düzenle';

  @override
  String get hiveFormNumber => 'Kovan numarası';

  @override
  String get hiveFormNumberHint => 'Ör. 101';

  @override
  String get hiveFormType => 'Kovan tipi';

  @override
  String get hiveFormStatus => 'Durum';

  @override
  String get hiveFormSource => 'Kaynak';

  @override
  String get hiveFormSave => 'Kaydet';

  @override
  String get hiveBulkTitle => 'Toplu kovan oluştur';

  @override
  String get hiveBulkCount => 'Kaç kovan';

  @override
  String get hiveBulkCountHint => 'Ör. 20';

  @override
  String hiveBulkCountTooMany(int max) {
    return 'Tek seferde en fazla $max';
  }

  @override
  String get hiveBulkStart => 'İlk numara';

  @override
  String get hiveBulkStartHint => 'Ör. 101';

  @override
  String hiveBulkPreview(int count, String first, String last) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$first–$last arası $count kovan oluşturulacak.',
      one: '$first numaralı kovan oluşturulacak.',
    );
    return '$_temp0';
  }

  @override
  String get hiveBulkSave => 'Kovanları oluştur';

  @override
  String hiveBulkCreated(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count kovan oluşturuldu',
    );
    return '$_temp0';
  }

  @override
  String get hiveNotFoundTitle => 'Kovan bulunamadı';

  @override
  String get hiveNotFoundMessage =>
      'Silinmiş ya da bu cihaza henüz gelmemiş olabilir.';

  @override
  String get hiveEdit => 'Düzenle';

  @override
  String hiveCardApiary(String name) {
    return 'Arılık: $name';
  }

  @override
  String get hiveQueenTitle => 'Ana arı';

  @override
  String get hiveStrengthNone => 'Henüz güç puanı yok';

  @override
  String get hiveTimelineTitle => 'Geçmiş';

  @override
  String get timelineInspection => 'Muayene';

  @override
  String get timelineAdded => 'Arılığa eklendi';

  @override
  String get timelineMoved => 'Taşındı';

  @override
  String timelineMoveRoute(String from, String to) {
    return '$from → $to';
  }

  @override
  String get timelineUnknownApiary => 'Bilinmeyen arılık';

  @override
  String timelineField(String label, String value) {
    return '$label: $value';
  }

  @override
  String timelineBeeFrames(int count) {
    return '$count arılı';
  }

  @override
  String timelineBroodFrames(int count) {
    return '$count yavrulu';
  }

  @override
  String timelineHoneyFrames(int count) {
    return '$count ballı';
  }

  @override
  String get timelineActions => 'Yapılanlar';

  @override
  String get hiveMove => 'Başka arılığa taşı';

  @override
  String hiveMoveTitle(String number) {
    return 'Kovan $number nereye taşınsın?';
  }

  @override
  String get hiveMoveNoOtherApiary =>
      'Taşınacak başka arılık yok. Önce Arılıklar sekmesinden bir arılık ekle.';

  @override
  String hiveMoved(String number, String apiary) {
    return 'Kovan $number taşındı: $apiary';
  }

  @override
  String get hiveChangeStatus => 'Durumu değiştir';

  @override
  String hiveStatusSheetTitle(String number) {
    return 'Kovan $number: yeni durum';
  }

  @override
  String hiveStatusConfirmTitle(String status, String number) {
    String _temp0 = intl.Intl.selectLogic(status, {
      'dead': 'Kovan $number söndü olarak kaydedilsin mi?',
      'merged': 'Kovan $number birleşti olarak kaydedilsin mi?',
      'sold': 'Kovan $number satıldı olarak kaydedilsin mi?',
      'other': 'Kovan $number kayboldu olarak kaydedilsin mi?',
    });
    return '$_temp0';
  }

  @override
  String get hiveStatusConfirmMessage =>
      'Arılığın aktif kovan sayısından düşer. Sonradan yeniden aktif yapabilirsin.';

  @override
  String get hiveStatusConfirm => 'Evet, kaydet';

  @override
  String hiveStatusChanged(String number, String status) {
    return 'Kovan $number: $status';
  }

  @override
  String get tasksEmptyTitle => 'Henüz görev yok';

  @override
  String get tasksEmptyMessage =>
      'Hatırlatıcıların ve yapılacakların tarih sırasıyla burada listelenecek.';

  @override
  String get moreEmptyTitle => 'Diğer modüller yolda';

  @override
  String get moreEmptyMessage =>
      'Hasat, stok, finans, belgeler ve bilgi bankası burada olacak.';

  @override
  String get scanTitle => 'Okut';

  @override
  String get scanLongPressHint => 'hızlı kayıt menüsünü aç';

  @override
  String get scanHint => 'Kovan etiketindeki kodu çerçeveye getir.';

  @override
  String get scanAgain => 'Yeniden okut';

  @override
  String get cameraErrorTitle => 'Kamera açılamadı';

  @override
  String get cameraErrorPermissionDenied =>
      'Kamera izni verilmedi. Etiket okutmak için Ayarlar\'dan bu uygulamaya kamera izni ver.';

  @override
  String get cameraErrorUnsupported =>
      'Bu cihazda okutmak için kullanılabilecek kamera yok.';

  @override
  String get cameraErrorUnknown => 'Bu ekranı kapatıp yeniden dene.';

  @override
  String get labelUnknownTitle => 'Bu kod bir kovana bağlı değil';

  @override
  String get labelUnknownMessage =>
      'Mobil Arıcı etiketi değil ya da henüz bir kovana atanmadı. Kovandaki etiketse bir kovana ata; sonra okutunca kovan kartı açılır.';

  @override
  String get labelUnknownOwnTitle => 'Bu etiketin kovanı bulunamadı';

  @override
  String get labelUnknownOwnMessage =>
      'Kovan silinmiş ya da henüz bu telefona gelmemiş olabilir. Etiketi başka bir kovana da atayabilirsin.';

  @override
  String labelCode(String code) {
    return 'Kod: $code';
  }

  @override
  String get labelAssign => 'Bir kovana ata';

  @override
  String get labelAssignTitle => 'Etiketi kovana ata';

  @override
  String get labelAssignMessage =>
      'Etiketin takılı olduğu kovanı seç. Sonra bu etiketi okutunca o kovanın kartı açılır.';

  @override
  String get labelAssignSearch => 'Kovan numarası';

  @override
  String get labelAssignNoMatch => 'Aramana uyan kovan yok.';

  @override
  String get labelAssignNoHives =>
      'Henüz kovan yok. Önce Arılıklar sekmesinden kovan ekle.';

  @override
  String get labelAssignHasOther => 'Başka etiketi var';

  @override
  String labelReplaceTitle(String number) {
    return 'Kovan $number için etiket değişsin mi?';
  }

  @override
  String get labelReplaceMessage =>
      'Bu kovanın başka bir etiketi var. Yeni etiket onun yerine geçer; eski etiket artık bu kovanı açmaz.';

  @override
  String get labelReplaceConfirm => 'Evet, değiştir';

  @override
  String labelAssigned(String number) {
    return 'Etiket atandı: Kovan $number';
  }

  @override
  String get hiveLabelsTitle => 'Etiket yazdır';

  @override
  String get hiveLabelsMessage =>
      'Etiketi basılacak kovanları seç. A4 sayfaya 24 etiket (70 × 37 mm) sığar; yazdırırken ölçeği %100 seç.';

  @override
  String get hiveLabelsNoHives => 'Bu arılıkta etiket basılacak kovan yok.';

  @override
  String get hiveLabelsSelectAll => 'Tümünü seç';

  @override
  String get hiveLabelsSelectNone => 'Hiçbirini seçme';

  @override
  String get hiveLabelsNoneSelected => 'Seçili kovan yok';

  @override
  String hiveLabelsCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count etiket',
    );
    return '$_temp0';
  }

  @override
  String hiveLabelsPages(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count sayfa',
    );
    return '$_temp0';
  }

  @override
  String hiveLabelsSummary(String labels, String pages) {
    return '$labels · $pages';
  }

  @override
  String get hiveLabelsPreparing => 'PDF hazırlanıyor…';

  @override
  String get hiveLabelsPrint => 'Yazdır';

  @override
  String get hiveLabelsShare => 'PDF paylaş';

  @override
  String hiveLabelsDocumentName(String apiary) {
    return 'Kovan etiketleri - $apiary';
  }

  @override
  String get hiveLabelsError => 'PDF hazırlanamadı. Yeniden dene.';

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
  String get signInSendCode => 'Kod gönder';

  @override
  String get signInSending => 'Gönderiliyor…';

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
  String get actionUndo => 'Geri al';

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
  String get onboardingCountrySearch => 'Ülke ara';

  @override
  String get onboardingCountrySuggested => 'Cihazına göre önerilen';

  @override
  String get onboardingCountryAll => 'Tüm ülkeler';

  @override
  String get onboardingCountryNoMatch => 'Aramana uyan ülke yok.';

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
  String get galleryStrengthDots => 'Güç noktaları';

  @override
  String get galleryTimelineTile => 'Zaman tüneli satırı';

  @override
  String get gallerySampleApiaryHill => 'Yayla';

  @override
  String get gallerySampleApiaryPlain => 'Ova';

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

  @override
  String get gallerySnackBar => 'Bildirim';

  @override
  String get galleryCriticalLockCard => 'Kritik kilit kartı';

  @override
  String get gallerySampleInspectionSaved => 'Muayene kaydedildi';

  @override
  String get gallerySampleWithdrawalTitle => 'Bekleme süresinde.';

  @override
  String get gallerySampleWithdrawalMessage =>
      'Bu kovana 12 gün daha bal katı verilmemeli.';

  @override
  String get syncStatusSynced => 'Eşitlendi';

  @override
  String syncStatusPending(int count) {
    return '$count bekliyor';
  }

  @override
  String get syncStatusError => 'Hata';

  @override
  String syncStatusSemantics(String status) {
    return 'Eşitleme: $status';
  }

  @override
  String get syncTitle => 'Eşitleme';

  @override
  String get syncSyncedMessage =>
      'Bu telefondaki tüm kayıtlar sunucuya ulaştı.';

  @override
  String syncPendingMessage(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count kayıt gönderilmeyi bekliyor.',
    );
    return '$_temp0';
  }

  @override
  String get syncProblemOffline =>
      'Sunucuya ulaşılamadı. İnternet gelince yeniden denenecek.';

  @override
  String get syncProblemFailed =>
      'Eşitleme tamamlanamadı. Biraz sonra yeniden dene.';

  @override
  String get syncProblemUpgrade =>
      'Bu sürüm artık eşitlenemiyor. Uygulamayı güncelle.';

  @override
  String syncLastSynced(String time) {
    return 'Son eşitleme $time';
  }

  @override
  String get syncNow => 'Şimdi eşitle';

  @override
  String get syncRunning => 'Eşitleniyor…';

  @override
  String syncRejectedTitle(int count) {
    return 'Gönderilemeyen kayıtlar ($count)';
  }

  @override
  String get syncRejectedMessage =>
      'Sunucu bu kayıtları kabul etmedi. Diğer kayıtlar eşitlenmeye devam ediyor.';

  @override
  String syncRejectedSubtitle(String reason, String date) {
    return '$reason · $date';
  }

  @override
  String get syncRejectionForbidden => 'Bu kaydı değiştirme yetkin yok';

  @override
  String get syncRejectionConflict =>
      'Başka bir kayıtla çakışıyor (ör. aynı etiket)';

  @override
  String get syncRejectionMissingReference => 'Bağlı olduğu kayıt sunucuda yok';

  @override
  String get syncRejectionUnsupported => 'Bu tür kayıt eşitlenmiyor';

  @override
  String get syncRejectionInvalid => 'Kayıttaki veri geçersiz';

  @override
  String get syncRejectionUnknown => 'Bilinmeyen neden';

  @override
  String get syncTableOrganizations => 'İşletme';

  @override
  String get syncTableMemberships => 'Üyelik';

  @override
  String get syncTableApiaries => 'Arılık';

  @override
  String get syncTableQueens => 'Ana arı';

  @override
  String get syncTableHives => 'Kovan';

  @override
  String get syncTableHiveLocationHistory => 'Kovan taşıma';

  @override
  String get initialSyncTitle => 'Kayıtların indiriliyor';

  @override
  String get initialSyncMessage =>
      'İşletmenin kayıtları bu telefona indiriliyor. Bu yalnız bir kez yapılır; sonra uygulama internetsiz de çalışır.';

  @override
  String initialSyncRows(int count) {
    final intl.NumberFormat countNumberFormat =
        intl.NumberFormat.decimalPattern(localeName);
    final String countString = countNumberFormat.format(count);

    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$countString kayıt indirildi',
    );
    return '$_temp0';
  }

  @override
  String get initialSyncFailedTitle => 'İndirme tamamlanamadı';

  @override
  String get suggestedValue => 'Önceki kayıttan';

  @override
  String get stepperNoValue => 'Girilmedi';

  @override
  String get hiveStartInspection => 'Muayene başlat';

  @override
  String inspectionTitle(String number) {
    return 'Kovan $number muayenesi';
  }

  @override
  String inspectionPrevious(String date) {
    return 'Önceki muayene $date';
  }

  @override
  String get inspectionFirst => 'İlk muayene';

  @override
  String get inspectionSuggestedLegend =>
      'Soluk değerler önceki muayeneden. Değişeni düzelt; diğerleri olduğu gibi kaydedilir.';

  @override
  String get inspectionDraftSaved => 'Bu telefonda taslak olarak saklanıyor';

  @override
  String get inspectionRestart => 'Baştan başla';

  @override
  String get inspectionQueen => 'Ana arı';

  @override
  String get queenStateSeen => 'Görüldü';

  @override
  String get queenStateEggs => 'Yumurta var';

  @override
  String get queenStateNone => 'Yok';

  @override
  String get inspectionFrames => 'Çerçeveler';

  @override
  String get inspectionBeeFrames => 'Arılı';

  @override
  String get inspectionBroodFrames => 'Yavrulu';

  @override
  String get inspectionHoneyFrames => 'Ballı';

  @override
  String get inspectionTemperament => 'Mizaç';

  @override
  String get temperamentCalm => 'Sakin';

  @override
  String get temperamentNervous => 'Sinirli';

  @override
  String get inspectionSwarmSigns => 'Oğul belirtisi';

  @override
  String get inspectionQueenCells => 'Ana arı memesi';

  @override
  String get queenCellsNone => 'Yok';

  @override
  String get queenCellsSwarm => 'Oğul';

  @override
  String get queenCellsSupersedure => 'Ana değiştirme';

  @override
  String get queenCellsEmergency => 'Acil';

  @override
  String get inspectionDisease => 'Hastalık şüphesi';

  @override
  String get inspectionAnswerNo => 'Yok';

  @override
  String get inspectionAnswerYes => 'Var';

  @override
  String get inspectionActions => 'Yapılan işlem';

  @override
  String get inspectionActionSuperAdded => 'Kat verildi';

  @override
  String get inspectionActionSuperRemoved => 'Kat alındı';

  @override
  String get inspectionActionFramesAdded => 'Çerçeve eklendi';

  @override
  String get inspectionActionFoundationAdded => 'Temel petek verildi';

  @override
  String get inspectionActionFed => 'Besleme yapıldı';

  @override
  String get inspectionActionExcluderFitted => 'Ana ızgarası takıldı';

  @override
  String get inspectionActionEntranceReduced => 'Giriş daraltıldı';

  @override
  String get inspectionActionPollenTrapFitted => 'Polen tuzağı takıldı';

  @override
  String get inspectionSave => 'Kaydet';

  @override
  String inspectionSaved(String number) {
    return 'Kovan $number muayenesi kaydedildi';
  }

  @override
  String get inspectionRemindPrompt => 'Tekrar bakmayı hatırlat';

  @override
  String inspectionRemindDays(int days) {
    String _temp0 = intl.Intl.pluralLogic(
      days,
      locale: localeName,
      other: '$days gün',
    );
    return '$_temp0';
  }

  @override
  String get inspectionLoadError => 'Muayene açılamadı';

  @override
  String get syncTableInspections => 'Muayene';

  @override
  String get signInTagline =>
      'Arılığın defteri, cebinde. İnternet olmasa da çalışır.';

  @override
  String get signInEmailLabelLong => 'E-posta adresin';

  @override
  String get signInEmailHelper =>
      'Şifre yok. Adresine 6 haneli bir kod göndereceğiz.';

  @override
  String get signInEmailHint => 'ornek@eposta.com';

  @override
  String get signInCodeHeading => 'E-postana gelen kodu gir';

  @override
  String get signInPasteCode => 'Kodu yapıştır';

  @override
  String get signInCodeSpamHint =>
      'Gelmediyse istenmeyen (spam) klasörüne bak. Bir kez girdikten sonra uygulama internetsiz de açılır.';

  @override
  String get signInChangeEmail => 'E-postayı değiştir';

  @override
  String get onboardingLanguageCountryTitle => 'Dil ve ülke';

  @override
  String get onboardingAppLanguage => 'Uygulama dili';

  @override
  String get onboardingDeviceLanguage => 'Cihaz dili';

  @override
  String get onboardingCountryLabel => 'Arıcılık yaptığın ülke';

  @override
  String get onboardingCountryChoose => 'Ülke seç';

  @override
  String onboardingRegionFeaturesTitle(String country) {
    return '$country için açılanlar';
  }

  @override
  String onboardingRegionDefaultsTitle(String country) {
    return '$country için ayarlar';
  }

  @override
  String get onboardingRegionDefaultsMessage =>
      'Birimler ve para birimi ülkene göre seçildi.';

  @override
  String get onboardingBusinessTitle => 'İşletmeni tanıyalım';

  @override
  String get regionFeatureAks => 'AKS ve işletme tescil bilgileri';

  @override
  String get regionFeatureSubsidies => 'arılı kovan desteği hatırlatıcıları';

  @override
  String get regionFeatureRegulations => 'mevzuat özetleri';

  @override
  String get regionFeatureTrDrugList => 'ruhsatlı ilaç listesi';

  @override
  String get regionFeatureTrFlora => 'Türkiye flora takvimi';

  @override
  String get regionFeatureTrMigrationDocs => 'gezginci belgeleri';

  @override
  String get unitKilogram => 'kg';

  @override
  String get unitPound => 'lb';

  @override
  String get unitCelsius => '°C';

  @override
  String get unitFahrenheit => '°F';

  @override
  String get hemisphereNorthern => 'Kuzey yarımküre';

  @override
  String get hemisphereSouthern => 'Güney yarımküre';

  @override
  String get relativeToday => 'bugün';

  @override
  String get relativeYesterday => 'dün';

  @override
  String relativeDaysAgo(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count gün önce',
    );
    return '$_temp0';
  }

  @override
  String apiariesCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count arılık',
    );
    return '$_temp0';
  }

  @override
  String apiariesSummary(String apiaries, String hives) {
    return '$apiaries · $hives';
  }

  @override
  String get apiaryHiveCountUnit => 'kovan';

  @override
  String get hiveLayoutGridShort => 'Izgara';

  @override
  String get hiveLayoutListShort => 'Liste';

  @override
  String apiaryDetailSubtitle(String hives, String visit) {
    return '$hives · $visit';
  }

  @override
  String get hiveCardKind => 'Kovan';

  @override
  String get hiveLastInspection => 'Son muayene';

  @override
  String get hiveLastInspectionNone => 'Henüz yok';

  @override
  String get hiveBulkPreviewTitle => 'Önizleme';

  @override
  String hiveBulkSaveCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count kovan oluştur',
    );
    return '$_temp0';
  }

  @override
  String get listEllipsis => '…';

  @override
  String get scanOfflineHint => 'İnternet gerekmez · okununca titrer';

  @override
  String get titleSeparator => ' · ';

  @override
  String get settingsGeneral => 'Genel';

  @override
  String get settingsGloveMode => 'Eldiven modu';

  @override
  String get settingsGloveModeHint =>
      'Bütün dokunma hedefleri bir kademe büyür.';

  @override
  String get settingsCountry => 'Ülke';

  @override
  String settingsCountryValue(String name, String code) {
    return '$name · $code';
  }

  @override
  String get moreSectionHelp => 'Yardım';

  @override
  String get galleryFormFields => 'Form alanları';

  @override
  String get galleryRadioCardGroup => 'Seçim kartları';

  @override
  String get gallerySegmentedTabs => 'Görünüm seçici';

  @override
  String get galleryListGroup => 'Gruplu liste';

  @override
  String get galleryNoteCard => 'Not kartı';

  @override
  String get gallerySummaryTile => 'Özet karosu';

  @override
  String get galleryActionTile => 'Eylem karoları';

  @override
  String get galleryAppLogo => 'Logo ve petek deseni';

  @override
  String get gallerySampleApiaryName => 'Arılık adı';

  @override
  String get gallerySampleFirstNumber => 'İlk numara';

  @override
  String get gallerySampleNoteHint =>
      'Şifre yok. Adresine 6 haneli bir kod göndereceğiz.';

  @override
  String get gallerySampleGrid => 'Izgara';

  @override
  String get gallerySampleList => 'Liste';

  @override
  String get gallerySampleMap => 'Harita';

  @override
  String get gallerySampleInspections => 'Muayene';

  @override
  String get gallerySampleNoteTitle => 'Türkiye için açılanlar';

  @override
  String get gallerySampleNoteMessage =>
      'AKS ve işletme tescil bilgileri, mevzuat özetleri ve ruhsatlı ilaç listesi.';

  @override
  String get gallerySampleLastInspectionValue => '3 gün önce';

  @override
  String get gallerySampleFrames => '8 arılı · 5 yavrulu';

  @override
  String get gallerySampleActiveTreatment => 'Aktif ilaç';

  @override
  String get gallerySampleDaysLeft => '12 gün kaldı';

  @override
  String get syncTableMedia => 'Foto ya da sesli not';

  @override
  String get mediaTakePhoto => 'Fotoğraf çek';

  @override
  String get mediaRecordVoice => 'Sesli not kaydet';

  @override
  String get mediaStopRecording => 'Kaydı bitir';

  @override
  String mediaRecording(String duration) {
    return 'Kaydediliyor · $duration';
  }

  @override
  String mediaPhotoAdded(String number) {
    return 'Kovan $number: fotoğraf eklendi';
  }

  @override
  String mediaVoiceAdded(String number) {
    return 'Kovan $number: sesli not eklendi';
  }

  @override
  String get mediaCameraDenied =>
      'Kamera izni yok. Telefonun ayarlarından izin verebilirsin.';

  @override
  String get mediaMicrophoneDenied =>
      'Mikrofon izni yok. Telefonun ayarlarından izin verebilirsin.';

  @override
  String get mediaCaptureFailed => 'Kaydedilemedi, yeniden dene.';

  @override
  String mediaPhotoCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count fotoğraf',
    );
    return '$_temp0';
  }

  @override
  String mediaVoiceCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count sesli not',
    );
    return '$_temp0';
  }

  @override
  String inspectionMediaAttached(String items) {
    return 'Muayeneyle kaydedilecek: $items';
  }

  @override
  String get timelinePhoto => 'Fotoğraf';

  @override
  String get timelineVoiceNote => 'Sesli not';

  @override
  String get mediaOpenPhoto => 'Fotoğrafı aç';

  @override
  String get mediaDownloadPhoto =>
      'Fotoğraf bu telefonda yok. İndirmek için dokun.';

  @override
  String mediaPlay(String duration) {
    return 'Dinle · $duration';
  }

  @override
  String get mediaStopPlaying => 'Durdur';

  @override
  String get mediaNotUploaded =>
      'Henüz yüklenmedi. Çeken telefon internete bağlanınca gelir.';

  @override
  String get mediaDownloadOffline =>
      'İndirilemedi. İnternet bağlantını kontrol et.';

  @override
  String get mediaDownloadFailed => 'İndirilemedi.';

  @override
  String get mediaNotFound => 'Fotoğraf bulunamadı';

  @override
  String get settingsData => 'Veri';

  @override
  String get settingsMediaWifiOnly => 'Fotoğrafları sadece Wi‑Fi\'da yükle';

  @override
  String get settingsMediaWifiOnlyHint =>
      'Foto ve sesli notlar mobil veri harcamaz.';

  @override
  String settingsPendingUploads(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count dosya yüklenmeyi bekliyor',
    );
    return '$_temp0';
  }

  @override
  String get hiveQueenNone => 'Kayıt yok';

  @override
  String get hiveQueenNoneHint => 'Ana vermek için dokunun';

  @override
  String queenMarkColorName(String color) {
    String _temp0 = intl.Intl.selectLogic(color, {
      'white': 'Beyaz',
      'yellow': 'Sarı',
      'red': 'Kırmızı',
      'green': 'Yeşil',
      'blue': 'Mavi',
      'other': 'Bilinmiyor',
    });
    return '$_temp0';
  }

  @override
  String get queenYearUnknown => 'Yılı bilinmiyor';

  @override
  String get queenUnmarked => 'İşaretsiz';

  @override
  String queenAge(int age) {
    String _temp0 = intl.Intl.pluralLogic(
      age,
      locale: localeName,
      other: '$age yaşında',
      zero: '1 yaşından küçük',
    );
    return '$_temp0';
  }

  @override
  String get queenSourceOwnRearing => 'Kendi üretimi';

  @override
  String get queenSourcePurchased => 'Satın alındı';

  @override
  String get queenSourceCertifiedBreeder => 'Sertifikalı damızlık';

  @override
  String get queenSource => 'Kaynak';

  @override
  String get queenMother => 'Anne ana';

  @override
  String get queenMotherUnknown => 'Bilinmiyor';

  @override
  String get queenBreed => 'Irk';

  @override
  String get queenBreedHint => 'Ör. Kafkas';

  @override
  String get queenBreedLine => 'Hat';

  @override
  String get queenBreedLineHint => 'Ör. Artvin';

  @override
  String get queenWing => 'Kanat';

  @override
  String get queenWingClipped => 'Kesik';

  @override
  String get queenWingIntact => 'Kesik değil';

  @override
  String get queenYear => 'Yıl';

  @override
  String get queenYearHelper => 'Doğum ya da alım yılı';

  @override
  String get queenMark => 'İşaret rengi';

  @override
  String queenMarkSuggestion(String year, String color) {
    return '$year rengi: $color';
  }

  @override
  String get queenUnknown => 'Girilmedi';

  @override
  String get queenEdit => 'Ana arıyı düzenle';

  @override
  String get queenReplace => 'Ana değiştir';

  @override
  String get queenGive => 'Ana ver';

  @override
  String get queenNoneTitle => 'Ana arı kaydı yok';

  @override
  String get queenNoneMessage =>
      'Kovana verdiğiniz anayı kaydedin; yılı, rengi ve soyu burada görünür.';

  @override
  String queenFormNewTitle(String number) {
    return 'Yeni ana · Kovan $number';
  }

  @override
  String get queenFormEditTitle => 'Ana arıyı düzenle';

  @override
  String get queenFormSave => 'Kaydet';

  @override
  String queenGiven(String number) {
    return 'Kovan $number yeni anasını aldı';
  }

  @override
  String get oldQueensTitle => 'Yaşlı analar';

  @override
  String oldQueensIntro(int age) {
    String _temp0 = intl.Intl.pluralLogic(
      age,
      locale: localeName,
      other:
          'Aktif kovanlarda $age yaşına girmiş analar. Değiştirmeyi planlayın.',
    );
    return '$_temp0';
  }

  @override
  String get oldQueensEmptyTitle => 'Yaşlı ana yok';

  @override
  String oldQueensEmptyMessage(int age) {
    String _temp0 = intl.Intl.pluralLogic(
      age,
      locale: localeName,
      other:
          'Aktif kovanlardaki analar $age yaşından genç ya da yılları girilmemiş.',
    );
    return '$_temp0';
  }

  @override
  String get syncTableMiteCounts => 'Varroa ölçümü';

  @override
  String get varroaMethodSugarRoll => 'Pudra şekeri';

  @override
  String get varroaMethodAlcoholWash => 'Alkol';

  @override
  String get varroaMethodStickyBoard => 'Alt tabla';

  @override
  String varroaFormTitle(String number) {
    return 'Varroa · Kovan $number';
  }

  @override
  String get varroaMethod => 'Yöntem';

  @override
  String get varroaSampleBees => 'Örnek arı';

  @override
  String get varroaBoardDays => 'Tablada gün';

  @override
  String get varroaMites => 'Sayılan akar';

  @override
  String get varroaBoardMites => 'Dökülen akar';

  @override
  String get varroaSave => 'Kaydet';

  @override
  String varroaSaved(String number) {
    return 'Kovan $number varroa ölçümü kaydedildi';
  }

  @override
  String varroaPercent(double value) {
    final intl.NumberFormat valueNumberFormat =
        intl.NumberFormat.decimalPatternDigits(
          locale: localeName,
          decimalDigits: 1,
        );
    final String valueString = valueNumberFormat.format(value);

    return '%$valueString';
  }

  @override
  String varroaPerDay(double value) {
    final intl.NumberFormat valueNumberFormat =
        intl.NumberFormat.decimalPatternDigits(
          locale: localeName,
          decimalDigits: 1,
        );
    final String valueString = valueNumberFormat.format(value);

    return 'Günde $valueString akar';
  }

  @override
  String get varroaInfestation => 'Bulaşıklık';

  @override
  String get varroaDailyDrop => 'Günlük döküm';

  @override
  String get varroaReached => 'Eşikte · mücadele planla';

  @override
  String get varroaBelow => 'Eşiğin altında';

  @override
  String varroaThresholdNote(String threshold) {
    return 'Eşik $threshold (Ayarlar\'dan).';
  }

  @override
  String get hiveVarroa => 'Varroa';

  @override
  String get hiveVarroaNone => 'Ölçüm yok';

  @override
  String get hiveVarroaReached => 'Eşiğe ulaştı';

  @override
  String get hiveVarroaCount => 'Varroa ölç';

  @override
  String varroaChartTitle(String apiary) {
    return '$apiary · son ölçümler';
  }

  @override
  String varroaChartThreshold(String threshold) {
    return 'eşik $threshold';
  }

  @override
  String get varroaChartEmpty =>
      'Henüz pudra şekeri ya da alkol ölçümü yok. Kovan kartından ekleyebilirsiniz.';

  @override
  String varroaChartBar(String day, String value) {
    return '$day: $value';
  }

  @override
  String varroaChartSemantics(String threshold, String bars) {
    return 'Gün başına ortalama bulaşıklık, eşik $threshold: $bars';
  }

  @override
  String get settingsVarroa => 'Varroa';

  @override
  String get settingsVarroaPercent => 'Bulaşıklık eşiği';

  @override
  String get settingsVarroaPerDay => 'Alt tabla eşiği';

  @override
  String get settingsVarroaHint =>
      'Ölçüm eşiğe ulaşınca uyarı çıkar. Yalnız bu telefonda saklanır.';

  @override
  String get syncTableRefDrugs => 'İlaç listesi';

  @override
  String get syncTableDrugs => 'İlaç';

  @override
  String get syncTableTreatments => 'İlaç uygulaması';

  @override
  String get syncTableFeedings => 'Besleme';

  @override
  String get drugIngredientAmitraz => 'Amitraz';

  @override
  String get drugIngredientOxalicAcid => 'Oksalik asit';

  @override
  String get drugIngredientFormicAcid => 'Formik asit';

  @override
  String get drugIngredientThymol => 'Timol';

  @override
  String get drugIngredientFlumethrin => 'Flumetrin';

  @override
  String get drugIngredientTauFluvalinate => 'Tau-fluvalinat';

  @override
  String get drugIngredientCoumaphos => 'Kumafos';

  @override
  String get drugIngredientLacticAcid => 'Laktik asit';

  @override
  String get drugIngredientOther => 'Diğer';

  @override
  String get drugUnitStrip => 'şerit';

  @override
  String get drugUnitMl => 'ml';

  @override
  String get drugUnitG => 'g';

  @override
  String get drugUnitDose => 'doz';

  @override
  String get hiveTreat => 'İlaç uygula';

  @override
  String get treatmentFormTitle => 'İlaç uygulaması';

  @override
  String treatmentScopeHive(String number) {
    return 'Kovan $number';
  }

  @override
  String treatmentScopeApiary(int count) {
    return 'Arılığın tümü · $count';
  }

  @override
  String get treatmentChooseDrug => 'İlaç seç';

  @override
  String get treatmentChangeDrug => 'Değiştir';

  @override
  String treatmentDrugIngredient(String ingredient) {
    return 'Etken madde: $ingredient';
  }

  @override
  String treatmentDrugLicense(String number) {
    return 'ruhsat $number';
  }

  @override
  String get treatmentDrugCustom => 'işletmenin ilacı';

  @override
  String get treatmentAddDrug => 'Yeni ilaç ekle';

  @override
  String get treatmentBatchNo => 'Parti no';

  @override
  String get treatmentStartedOn => 'Başlangıç';

  @override
  String treatmentDose(String unit) {
    return 'Doz / kovan ($unit)';
  }

  @override
  String treatmentDoseTotal(String total, String unit) {
    return 'Toplam $total $unit';
  }

  @override
  String get treatmentWithdrawalDays => 'Bekleme süresi (gün)';

  @override
  String get treatmentRemoval => 'Çıkarma';

  @override
  String get treatmentRemovalNone => 'Yok';

  @override
  String get treatmentRemovalChange =>
      'O sabah hatırlatılır; değiştirmek için dokun';

  @override
  String get treatmentRemovalSingle => 'Tek seferlik; tarih için dokun';

  @override
  String get treatmentRemovalClear => 'Çıkarma yok (tek seferlik)';

  @override
  String get treatmentNoSuper => 'Bal katı yok';

  @override
  String treatmentNoSuperUntil(String date) {
    return '$date tarihine kadar';
  }

  @override
  String treatmentNoSuperAfterRemoval(int days) {
    String _temp0 = intl.Intl.pluralLogic(
      days,
      locale: localeName,
      other: 'çıkarma + $days gün bekleme',
      zero: 'çıkarmadan sonra bekleme yok',
    );
    return '$_temp0';
  }

  @override
  String treatmentNoSuperAfterStart(int days) {
    String _temp0 = intl.Intl.pluralLogic(
      days,
      locale: localeName,
      other: 'uygulama + $days gün bekleme',
      zero: 'bekleme yok',
    );
    return '$_temp0';
  }

  @override
  String treatmentSave(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count kovana kaydet',
      one: 'Kaydet',
    );
    return '$_temp0';
  }

  @override
  String treatmentSaved(String number) {
    return 'Kovan $number için ilaç kaydedildi';
  }

  @override
  String treatmentSavedMany(int count) {
    return '$count kovana ilaç kaydedildi';
  }

  @override
  String get drugFormTitle => 'Yeni ilaç';

  @override
  String get drugName => 'Ad';

  @override
  String get drugActiveIngredient => 'Etken madde';

  @override
  String get drugDoseUnit => 'Doz birimi';

  @override
  String get drugWithdrawalDays => 'Etiketteki bekleme süresi (gün)';

  @override
  String get drugSave => 'İlacı ekle';

  @override
  String get withdrawalLockTitle => 'Bekleme süresinde.';

  @override
  String withdrawalLockMessage(String number, String product, String date) {
    return 'Kovan $number: $product uygulanıyor. $date tarihine kadar bal katı verilmemeli; bu süredeki bal ilaç kalıntısı taşıyabilir.';
  }

  @override
  String get withdrawalDaysLeft => 'Kalan';

  @override
  String withdrawalDays(int days) {
    return '$days gün';
  }

  @override
  String get withdrawalApplied => 'Uygulama';

  @override
  String get withdrawalReasonPrompt => 'Yine de kaydetmek için neden seç';

  @override
  String get withdrawalReasonRemovedEarly => 'İlaç erken çıkarıldı';

  @override
  String get withdrawalReasonNotForSale =>
      'Kat satılmayacak (kendi kullanım/yem)';

  @override
  String get withdrawalCancel => 'Vazgeç, kat verme';

  @override
  String get withdrawalProceed => 'Yine de kaydet';

  @override
  String inspectionWithdrawalOverride(String reason) {
    return 'Bekleme süresinde bal katı verildi: $reason';
  }

  @override
  String timelineTreatment(String product) {
    return 'İlaç · $product';
  }

  @override
  String timelineTreatmentBatch(String batch) {
    return 'Parti $batch';
  }

  @override
  String treatmentDoseValue(String dose, String unit) {
    return '$dose $unit';
  }

  @override
  String timelineTreatmentRemoval(String date) {
    return 'çıkarma $date';
  }

  @override
  String timelineTreatmentWithdrawal(int days) {
    return '$days gün bekleme';
  }

  @override
  String get hiveActiveTreatment => 'Aktif ilaç';

  @override
  String get hiveActiveTreatmentNone => 'Yok';

  @override
  String hiveActiveTreatmentLeft(int days) {
    return '$days gün kaldı';
  }

  @override
  String hiveActiveTreatmentDetail(String ingredient) {
    return '$ingredient · bal katı yok';
  }

  @override
  String get treatmentRotationTitle => 'Aynı etken madde.';

  @override
  String treatmentRotationMessage(int count, String ingredient) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other:
          'Bu arılıkta son $count uygulama da $ingredient. Direnç riskine karşı farklı etken madde düşün.',
    );
    return '$_temp0';
  }

  @override
  String get treatmentPrescriptionAdd => 'Reçete / fatura fotoğrafı ekle';

  @override
  String get treatmentPrescriptionAdded => 'Reçete fotoğrafı eklendi';

  @override
  String get treatmentPrescriptionRemove => 'Kaldır';

  @override
  String get reminderChannelName => 'Hatırlatmalar';

  @override
  String get treatmentReminderDenied =>
      'Bildirimler kapalı; çıkarma hatırlatıcısı kurulmadı.';

  @override
  String get hiveFeed => 'Besle';

  @override
  String get feedingFormTitle => 'Besleme';

  @override
  String feedingScopeHive(String number) {
    return 'Kovan $number';
  }

  @override
  String feedingScopeApiary(int count) {
    return 'Arılığın tümü · $count';
  }

  @override
  String get feedingKind => 'Tür';

  @override
  String get feedingKindSyrup1to1 => 'Şurup 1:1 · teşvik';

  @override
  String get feedingKindSyrup2to1 => 'Şurup 2:1 · kışlık';

  @override
  String get feedingKindBeeCake => 'Arı keki';

  @override
  String get feedingKindPollenSubstitute => 'Polen ikamesi';

  @override
  String feedingAmount(String unit) {
    return 'Kovan başına ($unit)';
  }

  @override
  String get feedingSuperHiveTitle => 'Bu kovanda bal katı var.';

  @override
  String get feedingSuperHiveMessage => 'Şurup bala karışabilir.';

  @override
  String feedingSuperSkippedTitle(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count kovanda bal katı var',
    );
    return '$_temp0';
  }

  @override
  String feedingSuperSkippedMessage(String numbers) {
    return '($numbers). Şurup bala karışmasın diye hariç tutuldu.';
  }

  @override
  String get feedingPrepare => 'Hazırlanacak';

  @override
  String feedingPrepareCount(int count, String amount, String unit) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count kovan × $amount $unit',
    );
    return '$_temp0';
  }

  @override
  String feedingTotalSyrup(String amount, String unit) {
    return '$amount $unit şurup';
  }

  @override
  String feedingTotalBeeCake(String amount, String unit) {
    return '$amount $unit arı keki';
  }

  @override
  String feedingTotalPollenSubstitute(String amount, String unit) {
    return '$amount $unit polen ikamesi';
  }

  @override
  String get feedingSugar => 'Şeker';

  @override
  String get feedingWater => 'Su';

  @override
  String feedingApprox(String amount, String unit) {
    return '≈ $amount $unit';
  }

  @override
  String feedingSave(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count kovana kaydet',
      one: 'Kaydet',
      zero: 'Beslenecek kovan yok',
    );
    return '$_temp0';
  }

  @override
  String feedingSaved(String number) {
    return 'Kovan $number için besleme kaydedildi';
  }

  @override
  String feedingSavedMany(int count) {
    return '$count kovana besleme kaydedildi';
  }

  @override
  String get unitLiter => 'L';

  @override
  String get unitGallon => 'gal';

  @override
  String get syncTableTasks => 'Görev';

  @override
  String get tasksTabToday => 'Bugün';

  @override
  String get tasksTabWeek => 'Bu hafta';

  @override
  String get tasksTabApiary => 'Arılığa göre';

  @override
  String get tasksAdd => 'Görev ekle';

  @override
  String tasksOverdue(int count) {
    return 'Gecikmiş · $count';
  }

  @override
  String tasksDayGroup(String day, int count) {
    return '$day · $count';
  }

  @override
  String get tasksToday => 'Bugün';

  @override
  String get tasksTomorrow => 'Yarın';

  @override
  String get tasksNoApiary => 'Arılıksız';

  @override
  String tasksApiaryGroup(String apiary, int count) {
    return '$apiary · $count';
  }

  @override
  String get tasksEmptyTodayTitle => 'Bugün yapılacak görev yok';

  @override
  String get tasksEmptyWeekTitle => 'Bu hafta görev yok';

  @override
  String get tasksEmptyAddHint => 'Yeni görevi sağ üstteki + ile ekle.';

  @override
  String get tasksLoadError => 'Görevler açılamadı.';

  @override
  String tasksWeekDaySemantics(String day, int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count görev',
      zero: 'görev yok',
    );
    return '$day, $_temp0';
  }

  @override
  String taskOverdueDays(int days) {
    String _temp0 = intl.Intl.pluralLogic(
      days,
      locale: localeName,
      other: '$days gün gecikti',
    );
    return '$_temp0';
  }

  @override
  String get taskSourceInspection => 'muayeneden';

  @override
  String get taskSourceTreatment => 'ilaç';

  @override
  String taskInspectionTitle(String number) {
    return 'Kovan $number · tekrar bak';
  }

  @override
  String get taskInspectionTitleNoHive => 'Tekrar bak';

  @override
  String taskTreatmentTitle(String number) {
    return 'Kovan $number · şerit çıkar';
  }

  @override
  String get taskTreatmentTitleApiary => 'Şeritleri çıkar';

  @override
  String get taskReminderBody => 'Görevin zamanı geldi.';

  @override
  String get taskAssigneeMe => 'Ben';

  @override
  String taskAssignedTo(String name) {
    return 'Atanan: $name';
  }

  @override
  String taskMemberNumbered(String role, int index) {
    return '$role $index';
  }

  @override
  String get roleOwner => 'Sahip';

  @override
  String get rolePartner => 'Ortak';

  @override
  String get roleWorker => 'İşçi';

  @override
  String get roleViewer => 'İzleyici';

  @override
  String taskCompleteAction(String title) {
    return 'Tamamla: $title';
  }

  @override
  String get taskCompleted => 'Görev tamamlandı';

  @override
  String get taskFormNewTitle => 'Yeni görev';

  @override
  String get taskFormEditTitle => 'Görevi düzenle';

  @override
  String get taskFormName => 'Görev';

  @override
  String get taskFormNameHint => 'Ör. Yayla arılığını ziyaret et';

  @override
  String get taskFormDue => 'Son tarih';

  @override
  String get taskFormPickDate => 'Başka gün';

  @override
  String get taskFormTime => 'Saat';

  @override
  String get taskFormApiary => 'Arılık';

  @override
  String get taskFormHive => 'Kovan';

  @override
  String get taskFormNone => 'Yok';

  @override
  String get taskFormChooseApiary => 'Arılık seç';

  @override
  String get taskFormChooseHive => 'Kovan seç';

  @override
  String get taskFormAssignee => 'Atanan';

  @override
  String get taskFormUnassigned => 'Atanmamış';

  @override
  String get taskFormCompleted => 'Tamamlandı';

  @override
  String get taskFormSave => 'Kaydet';

  @override
  String get taskFormDelete => 'Görevi sil';

  @override
  String get taskDeleteTitle => 'Görev silinsin mi?';

  @override
  String get taskDeleteMessage => 'Görev bütün telefonlardan kalkar.';

  @override
  String get taskDeleteConfirm => 'Sil';

  @override
  String get taskSaved => 'Görev kaydedildi';

  @override
  String get taskDeleted => 'Görev silindi';

  @override
  String get taskNotFound => 'Görev bulunamadı; silinmiş olabilir.';

  @override
  String get taskReminderDenied =>
      'Bildirimler kapalı; hatırlatıcı çalmayacak.';

  @override
  String get exactAlarmTitle => 'Hatırlatıcılar tam saatinde çalsın mı?';

  @override
  String get exactAlarmMessage =>
      'Android pil tasarrufu için bildirimleri birkaç dakika geciktirebilir. Açılan ayarda Mobil Arıcı\'ya izin verirsen görev hatırlatıcıları tam saatinde çalar. İnternet gerekmez.';

  @override
  String get exactAlarmConfirm => 'Ayarı aç';

  @override
  String get settingsReminders => 'Hatırlatıcılar';

  @override
  String get settingsExactAlarms => 'Tam saatinde çalsın';

  @override
  String get settingsExactAlarmsOn => 'Açık';

  @override
  String get settingsExactAlarmsOff => 'Kapalı · birkaç dakika gecikebilir';

  @override
  String get weatherAttribution => 'Powered by WeatherAPI.com';

  @override
  String weatherTemperature(String value) {
    return '$value°';
  }

  @override
  String weatherWind(String speed) {
    return 'Rüzgar $speed km/s';
  }

  @override
  String weatherForecastAsOf(String time) {
    return 'Tahmin $time itibarıyla';
  }

  @override
  String get hiveOpeningSuitable => 'Kovan açılır';

  @override
  String get hiveOpeningCautionRain => 'Yağış olası';

  @override
  String get hiveOpeningCautionWind => 'Rüzgarlı';

  @override
  String get hiveOpeningCautionCold => 'Serin';

  @override
  String get hiveOpeningUnsuitableRain => 'Yağışlı';

  @override
  String get hiveOpeningUnsuitableWind => 'Sert rüzgar';

  @override
  String get hiveOpeningUnsuitableCold => 'Çok soğuk';

  @override
  String get todayGreetingMorning => 'Günaydın';

  @override
  String get todayGreetingAfternoon => 'İyi günler';

  @override
  String get todayGreetingEvening => 'İyi akşamlar';

  @override
  String get todayAttentionTitle => 'Dikkat isteyenler';

  @override
  String todayAttentionHiveCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count kovan',
    );
    return '$_temp0';
  }

  @override
  String get todayAttentionNone => 'Dikkat isteyen kovan yok';

  @override
  String get todayTasksTitle => 'Bugünün görevleri';

  @override
  String todayTasksCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count görev',
    );
    return '$_temp0';
  }

  @override
  String todaySetupProgress(int done, int total) {
    return 'Kurulum $done/$total';
  }

  @override
  String get setupStepApiary => 'Arılığını ekle';

  @override
  String get setupStepHives => 'Kovanlarını oluştur';

  @override
  String get setupStepInspection => 'İlk muayeneyi yap';

  @override
  String setupStepDone(String step) {
    return '$step: tamamlandı';
  }

  @override
  String get attentionQueenless => 'Anasız';

  @override
  String get attentionWeak => 'Zayıf';

  @override
  String get attentionSwarming => 'Oğul eğilimli';

  @override
  String get attentionTreatmentRemoval => 'İlacı çıkarılacak';

  @override
  String get attentionQueenlessTitle => 'Anasız kovanlar';

  @override
  String get attentionWeakTitle => 'Zayıf kovanlar';

  @override
  String get attentionSwarmingTitle => 'Oğul eğilimli kovanlar';

  @override
  String get attentionTreatmentRemovalTitle => 'İlacı çıkarılacak kovanlar';

  @override
  String get attentionQueenlessIntro =>
      'Son muayenesinde ana arı ve yumurta görülmeyen aktif kovanlar.';

  @override
  String attentionWeakIntro(int max) {
    return 'Son muayenesine göre gücü $max/5 ya da altında olan aktif kovanlar.';
  }

  @override
  String get attentionSwarmingIntro =>
      'Son muayenesinde oğul belirtisi ya da oğul memesi görülen aktif kovanlar.';

  @override
  String get attentionTreatmentRemovalIntro =>
      'Şerit çıkarma günü gelmiş, görevi henüz tamamlanmamış kovanlar.';

  @override
  String get attentionEmpty => 'Bu grupta kovan yok.';

  @override
  String attentionLastInspection(String date) {
    return 'Son muayene: $date';
  }

  @override
  String attentionRemovalDue(String date) {
    return 'Çıkarma günü: $date';
  }

  @override
  String get syncTableHarvests => 'Hasat';

  @override
  String get syncTableHarvestHives => 'Hasat kovanı';

  @override
  String withdrawalLockHarvestMessage(
    String number,
    String product,
    String date,
  ) {
    return 'Kovan $number: $product uygulanıyor. $date tarihine kadar bu kovandan hasat yapılmamalı; bu süredeki bal ilaç kalıntısı taşıyabilir.';
  }

  @override
  String get withdrawalReasonNotForSaleHarvest =>
      'Bal satılmayacak (kendi kullanım/yem)';

  @override
  String get withdrawalHarvestCancel => 'Vazgeç, hasada alma';

  @override
  String get withdrawalHarvestProceed => 'Yine de hasada al';

  @override
  String get apiaryHarvest => 'Hasat';

  @override
  String harvestFormTitle(String apiary) {
    return 'Hasat · $apiary';
  }

  @override
  String harvestSelectedCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count kovan seçildi',
      zero: 'Kovan seçilmedi',
    );
    return '$_temp0';
  }

  @override
  String harvestSelectedHint(String numbers) {
    return '$numbers · değiştirmek için dokun, okutarak ekle';
  }

  @override
  String get harvestSelectedEmptyHint => 'Kovan seçmek için dokun ya da okut';

  @override
  String get harvestScan => 'Okut';

  @override
  String harvestLockedTitle(String numbers) {
    return '$numbers bekleme süresinde.';
  }

  @override
  String get harvestLockedMessage =>
      'Hasada alınmadı. Yine de almak için kovan listesinden seç.';

  @override
  String get harvestDate => 'Tarih';

  @override
  String get harvestToday => 'Bugün';

  @override
  String get harvestYesterday => 'Dün';

  @override
  String get harvestPickDate => 'Başka gün';

  @override
  String get harvestHoneyKind => 'Bal türü';

  @override
  String get honeyKindPine => 'Çam';

  @override
  String get honeyKindFlower => 'Çiçek';

  @override
  String get honeyKindChestnut => 'Kestane';

  @override
  String get honeyKindCitrus => 'Narenciye';

  @override
  String get honeyKindOther => 'Diğer';

  @override
  String get harvestUnit => 'Alınan birim';

  @override
  String get harvestUnitSuper => 'Kat';

  @override
  String get harvestUnitFrame => 'Çerçeve';

  @override
  String get harvestTakenSupers => 'Alınan kat';

  @override
  String get harvestTakenFrames => 'Alınan çerçeve';

  @override
  String harvestWeight(String unit) {
    return 'Süzülen bal ($unit)';
  }

  @override
  String get harvestWeightInvalid => '574 ya da 574,5 gibi bir ağırlık yaz';

  @override
  String harvestWeightTooLarge(String max, String unit) {
    return 'En çok $max $unit';
  }

  @override
  String get harvestPerHive => 'Kovan başına';

  @override
  String harvestWeightValue(String value, String unit) {
    return '$value $unit';
  }

  @override
  String harvestSave(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Hasadı kaydet',
      zero: 'Hasada alınacak kovan yok',
    );
    return '$_temp0';
  }

  @override
  String harvestSaved(int count) {
    return '$count kovanın hasadı kaydedildi';
  }

  @override
  String get harvestHivesTitle => 'Hasat kovanları';

  @override
  String get harvestSelectAll => 'Tümünü seç';

  @override
  String get harvestSelectNone => 'Hiçbiri';

  @override
  String harvestHiveLocked(int days) {
    return 'Bekleme süresinde · $days gün';
  }

  @override
  String harvestHiveOverridden(String reason) {
    return 'Yine de alındı: $reason';
  }

  @override
  String get harvestHivesDone => 'Tamam';

  @override
  String get harvestNoActiveHives => 'Bu arılıkta aktif kovan yok.';

  @override
  String get harvestScanTitle => 'Hasada okut';

  @override
  String harvestScanAdded(String number) {
    return 'Kovan $number eklendi';
  }

  @override
  String harvestScanAlready(String number) {
    return 'Kovan $number zaten seçili';
  }

  @override
  String harvestScanOtherApiary(String number) {
    return 'Kovan $number bu arılıkta değil';
  }

  @override
  String harvestScanInactive(String number) {
    return 'Kovan $number aktif değil';
  }

  @override
  String get harvestScanUnknown => 'Bu etiket bir kovana bağlı değil';

  @override
  String harvestScanDone(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Bitti · $count kovan',
      zero: 'Bitti',
    );
    return '$_temp0';
  }
}
