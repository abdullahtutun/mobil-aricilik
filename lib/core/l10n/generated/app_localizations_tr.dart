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
  String get apiariesViewList => 'Liste';

  @override
  String get apiariesViewMap => 'Harita';

  @override
  String get apiariesMapOfflineTitle => 'Harita açılamadı';

  @override
  String get apiariesMapOfflineMessage =>
      'Harita için internet gerekiyor. Arılıklarınız aşağıda.';

  @override
  String get apiariesMapNoLocation =>
      'Henüz konumu olan arılık yok. Arılığı düzenleyip konumu GPS\'ten alın ya da haritada seçin.';

  @override
  String get apiariesMapAttribution =>
      '© OpenFreeMap © OpenMapTiles © OpenStreetMap katkıcıları';

  @override
  String apiaryMapPinLabel(String name, String hives) {
    return '$name, $hives';
  }

  @override
  String apiaryMapPinAttention(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count kovan dikkat istiyor',
    );
    return '$_temp0';
  }

  @override
  String get apiaryMapDirections => 'Yol tarifi';

  @override
  String get apiaryMapShow => 'Göster';

  @override
  String get apiaryMapDirectionsFailed => 'Harita uygulaması açılamadı.';

  @override
  String get apiaryMapDirectionsChooseApp => 'Yol tarifi için uygulama seç';

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
  String get apiaryDelete => 'Arılığı sil';

  @override
  String get apiaryDeleteTitle => 'Arılık silinsin mi?';

  @override
  String get apiaryDeleteMessage => 'Arılık bütün telefonlardan kalkar.';

  @override
  String apiaryDeleteWithHivesMessage(int count) {
    return 'Bu arılıkta $count kovan var. Arılık, kovanlarıyla birlikte bütün telefonlardan kalkar.';
  }

  @override
  String get apiaryDeleted => 'Arılık silindi';

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
      'Konum yok. Arılıktaysan GPS\'ten al, internet gerekmez; değilsen haritada seç.';

  @override
  String get apiaryFormLocationTake => 'Konumu GPS\'ten al';

  @override
  String get apiaryFormLocationRetake => 'Konumu yeniden al';

  @override
  String get apiaryFormLocationClear => 'Konumu kaldır';

  @override
  String get apiaryFormLocationPickOnMap => 'Haritada seç';

  @override
  String get locationPickerTitle => 'Haritada konum seç';

  @override
  String get locationPickerSearchHint => 'İl, ilçe ya da köy ara';

  @override
  String get locationPickerSearch => 'Ara';

  @override
  String get locationPickerHint =>
      'Haritayı kaydırıp iğneyi arılığın yerine getir.';

  @override
  String get locationPickerPinLabel => 'Seçilen konum';

  @override
  String get locationPickerConfirm => 'Bu konumu seç';

  @override
  String get locationPickerNoResults => 'Sonuç bulunamadı. Başka bir ad dene.';

  @override
  String get locationPickerSearchOffline =>
      'Arama yapılamadı. Arama için internet gerekiyor.';

  @override
  String get locationPickerMapOfflineMessage =>
      'Harita için internet gerekiyor. Arılıktaysan konumu GPS\'ten alabilirsin.';

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
  String get hiveDelete => 'Kovanı sil';

  @override
  String hiveDeleteTitle(String number) {
    return '$number numaralı kovan silinsin mi?';
  }

  @override
  String get hiveDeleteMessage =>
      'Kovan ve kayıtları bütün telefonlardan kalkar.';

  @override
  String hiveDeleted(String number) {
    return '$number numaralı kovan silindi';
  }

  @override
  String hiveCardApiary(String name) {
    return 'Arılık: $name';
  }

  @override
  String get hiveQueenTitle => 'Ana arı';

  @override
  String hiveQueenStripTitle(String queen) {
    return 'Ana arı · $queen';
  }

  @override
  String hiveStrengthBadge(String level, int strength) {
    return '$level · $strength/5';
  }

  @override
  String get hiveStrengthWeak => 'Zayıf';

  @override
  String get hiveStrengthMedium => 'Orta';

  @override
  String get hiveStrengthStrong => 'Güçlü';

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
  String settingsVersion(String version) {
    return 'Sürüm $version';
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
  String get actionDelete => 'Sil';

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
  String get syncTableHiveStatusEvents => 'Kovan durum değişikliği';

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
  String apiaryDetailSubtitlePlace(String hives, String visit, String place) {
    return '$hives · $visit · $place';
  }

  @override
  String get apiaryBulkFeed => 'Toplu besleme';

  @override
  String get apiaryBulkTreat => 'Toplu ilaçlama';

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
  String get moreSectionApiary => 'Arılık';

  @override
  String get moreSectionBusiness => 'İşletme';

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
  String get drugInfoOpen => 'İlaç bilgisi';

  @override
  String get drugInfoSourceTitle => 'Kaynak: T.C. Tarım ve Orman Bakanlığı';

  @override
  String get drugInfoSourceMessage =>
      'Bu bilgiler Bakanlık onaylı ürün bilgilerinden alınmıştır. Uygulamadan önce ürün etiketini okuyun; emin değilseniz veteriner hekime danışın.';

  @override
  String get drugInfoActiveIngredient => 'Etken madde';

  @override
  String get drugInfoIndications => 'Ne için kullanılır';

  @override
  String get drugInfoUsage => 'Kullanım ve sıklık';

  @override
  String get drugInfoUsageMethod => 'Uygulama şekli';

  @override
  String get drugInfoUsageMethodAndDose => 'Uygulama şekli ve doz';

  @override
  String get drugInfoUsageDiagnosis => 'Teşhis için';

  @override
  String get drugInfoUsageDose => 'Doz';

  @override
  String get drugInfoUsageFrequency => 'Sıklık';

  @override
  String get drugInfoUsageDuration => 'Uygulama süresi';

  @override
  String get drugInfoUsageOther => 'Not';

  @override
  String get drugInfoSuitablePeriods => 'Uygun dönemler';

  @override
  String get drugInfoAvoidPeriods => 'Kullanılmaması gereken dönemler';

  @override
  String get drugInfoWithdrawal => 'Arınma süresi';

  @override
  String get drugInfoWarnings => 'Uyarılar';

  @override
  String get drugInfoClose => 'Kapat';

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
  String weatherTemperature(String value) {
    return '$value°';
  }

  @override
  String weatherForecastAsOf(String time) {
    return 'Tahmin $time itibarıyla';
  }

  @override
  String get weatherNoLocationTitle => 'Konum yok';

  @override
  String get weatherNoLocationAction => 'Hava için konum ekle';

  @override
  String get weatherPendingHint => 'Bağlantı gelince gelir';

  @override
  String weatherWind(String speed) {
    return 'Rüzgar $speed';
  }

  @override
  String weatherSpeed(String value, String unit) {
    return '$value $unit';
  }

  @override
  String get unitKmh => 'km/s';

  @override
  String get unitMph => 'mph';

  @override
  String weatherPercent(String value) {
    return '%$value';
  }

  @override
  String weatherTemperatureRange(String max, String min) {
    return '$max / $min';
  }

  @override
  String get hiveOpeningRain => 'Yağmur';

  @override
  String get hiveOpeningWind => 'Rüzgarlı';

  @override
  String get hiveOpeningCold => 'Soğuk';

  @override
  String get hiveOpeningDaySuitable => 'Açılır';

  @override
  String get weatherConditionSunny => 'Güneşli';

  @override
  String get weatherConditionPartlyCloudy => 'Parçalı bulutlu';

  @override
  String get weatherConditionCloudy => 'Bulutlu';

  @override
  String get weatherConditionRainy => 'Yağmurlu';

  @override
  String get weatherConditionWindy => 'Rüzgarlı';

  @override
  String get weatherConditionOther => 'Kar, sis ya da fırtına';

  @override
  String get weatherConditionFog => 'Sisli';

  @override
  String get weatherConditionThunder => 'Gök gürültülü';

  @override
  String get weatherConditionSleet => 'Karla karışık yağmur';

  @override
  String get weatherConditionSnow => 'Karlı';

  @override
  String weatherFeelsLike(String condition, String value) {
    return '$condition · hissedilen $value';
  }

  @override
  String get weatherWindLabel => 'Rüzgar';

  @override
  String get weatherHumidityLabel => 'Nem';

  @override
  String get weatherPrecipitationLabel => 'Yağış';

  @override
  String get weatherScreenTitle => 'Arılık havası';

  @override
  String weatherScreenSubtitle(String place, String days) {
    return '$place · $days günlük hava';
  }

  @override
  String weatherScreenSubtitleNoPlace(String days) {
    return '$days günlük hava';
  }

  @override
  String weatherUpdatedAt(String time) {
    return 'Güncelleme $time';
  }

  @override
  String get weatherNow => 'Şimdi';

  @override
  String get weatherToday => 'Bugün';

  @override
  String get weatherColumnDay => 'Gün';

  @override
  String get weatherColumnTemperature => 'Sıcaklık';

  @override
  String get weatherColumnPrecipitation => 'Yağış';

  @override
  String get weatherColumnHive => 'Kovan';

  @override
  String get weatherTodaySuitable => 'Bugün kovan açmaya uygun';

  @override
  String get weatherTodayRain => 'Bugün yağmur var; kovan açmaya uygun değil';

  @override
  String get weatherTodayWind => 'Bugün rüzgarlı; kovan açmaya uygun değil';

  @override
  String get weatherTodayCold => 'Bugün soğuk; kovan açmaya uygun değil';

  @override
  String weatherDayRange(String from, String to) {
    return '$from–$to';
  }

  @override
  String weatherPlanRain(String days) {
    return '$days yağmur.';
  }

  @override
  String weatherPlanWind(String days) {
    return '$days rüzgarlı.';
  }

  @override
  String weatherPlanMove(String weekday) {
    String _temp0 = intl.Intl.selectLogic(weekday, {
      'monday': 'Muayeneleri Pazartesi\'ye al.',
      'tuesday': 'Muayeneleri Salı\'ya al.',
      'wednesday': 'Muayeneleri Çarşamba\'ya al.',
      'thursday': 'Muayeneleri Perşembe\'ye al.',
      'friday': 'Muayeneleri Cuma\'ya al.',
      'saturday': 'Muayeneleri Cumartesi\'ye al.',
      'other': 'Muayeneleri Pazar\'a al.',
    });
    return '$_temp0';
  }

  @override
  String get weatherPlanAction => 'Planla';

  @override
  String weatherPlanTaskTitle(String apiary) {
    return '$apiary muayenesi';
  }

  @override
  String weatherThresholdsHint(
    String temperature,
    String wind,
    String precipitation,
  ) {
    return 'Kovan açılır: $temperature üstü, rüzgar $wind altı, yağış $precipitation altı. Eşikleri Ayarlar\'dan değiştirebilirsin.';
  }

  @override
  String get weatherEmptyTitle => 'Hava bilgisi yok';

  @override
  String get weatherEmptyMessage =>
      'Bu arılığın tahmini henüz alınmadı. İnternete bağlanınca yenile.';

  @override
  String get weatherNoLocationMessage =>
      'Arılığın konumu yok. Tahmin için arılığa konum ekle.';

  @override
  String get weatherRefresh => 'Yenile';

  @override
  String get weatherRefreshFailed =>
      'Tahmin alınamadı. İnternet bağlantını kontrol et.';

  @override
  String get weatherApiaryNotFound => 'Arılık bulunamadı';

  @override
  String get weatherAttributionPrefix => 'Powered by ';

  @override
  String get weatherAttributionLink => 'WeatherAPI.com';

  @override
  String get settingsHiveOpening => 'Kovan açma eşikleri';

  @override
  String get settingsHiveOpeningTemperature => 'Sıcaklık';

  @override
  String settingsHiveOpeningTemperatureValue(String value) {
    return '$value üstü';
  }

  @override
  String get settingsHiveOpeningWind => 'Rüzgar';

  @override
  String get settingsHiveOpeningPrecipitation => 'Yağış olasılığı';

  @override
  String settingsHiveOpeningBelow(String value) {
    return '$value altı';
  }

  @override
  String get settingsHiveOpeningHint =>
      'Hava ekranı ve Bugün kartları bu eşiklere göre \"Açılır\" der. Yalnız bu telefonda saklanır.';

  @override
  String get hiveOpeningSuitable => 'Kovan açılır';

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
  String get todayTasksTitle => 'Bugün';

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
  String todayTasksApiaryCount(String apiary, int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count görev',
    );
    return '$apiary · $_temp0';
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

  @override
  String get apiaryTourStart => 'Tur başlat';

  @override
  String get apiaryTourResume => 'Tura devam et';

  @override
  String get tourReplaceTitle => 'Süren tur bitsin mi?';

  @override
  String tourReplaceMessage(String apiary) {
    return '$apiary turu sürüyor. Yeni tur başlarsa o turun ilerlemesi silinir; muayeneler kayıtlı kalır.';
  }

  @override
  String get tourReplaceConfirm => 'Yeni tur başlat';

  @override
  String tourTitle(String apiary) {
    return '$apiary turu';
  }

  @override
  String get tourFinish => 'Turu bitir';

  @override
  String tourProgress(int done, int total) {
    return '$done / $total';
  }

  @override
  String tourProgressLabel(int done, int total) {
    return '$total kovandan $done tanesi bitti';
  }

  @override
  String tourMinutes(int minutes) {
    return '$minutes dk';
  }

  @override
  String tourHoursMinutes(int hours, int minutes) {
    return '$hours sa $minutes dk';
  }

  @override
  String tourElapsedLabel(String duration) {
    return 'Geçen süre: $duration';
  }

  @override
  String get tourNext => 'Sıradaki';

  @override
  String tourPreviousVisit(String date) {
    return 'Geçen sefer · $date';
  }

  @override
  String get tourQueue => 'Sıra';

  @override
  String tourSkippedCount(int count) {
    return '$count atlandı';
  }

  @override
  String get tourStateDone => 'Bitti';

  @override
  String get tourStateSkipped => 'Atlandı';

  @override
  String get tourStatePending => 'Bekliyor';

  @override
  String get tourStateNext => 'Sıradaki';

  @override
  String tourHiveSemantics(String number, String state) {
    return 'Kovan $number, $state';
  }

  @override
  String get tourSkip => 'Atla';

  @override
  String tourInspect(String number) {
    return 'Muayene et · $number';
  }

  @override
  String get tourAllDone => 'Bütün kovanlara bakıldı.';

  @override
  String get tourSunSuggestion =>
      'Güneşte ekran daha net okunsun diye güneş modu önerilir.';

  @override
  String get tourSunOn => 'Güneş modunu aç';

  @override
  String get tourSunMode => 'Güneş modu';

  @override
  String get tourFinishTitle => 'Tur bitsin mi?';

  @override
  String tourFinishMessage(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count kovana bakılmadı; özette atlanmış sayılır.',
      one: '1 kovana bakılmadı; özette atlanmış sayılır.',
    );
    return '$_temp0';
  }

  @override
  String get tourNotFound => 'Bu arılıkta süren tur yok.';

  @override
  String get tourCompleteTitle => 'Tur tamamlandı';

  @override
  String tourInspectedCount(int count) {
    return '$count kovan muayene';
  }

  @override
  String get tourHealthy => 'Güçlü / orta';

  @override
  String get tourTasksTitle => 'Oluşan görevler';

  @override
  String tourTaskRequeen(String numbers) {
    return 'Ana ver: $numbers';
  }

  @override
  String tourTaskFeedWeak(String numbers) {
    return '1:1 şurup ver: $numbers';
  }

  @override
  String tourTaskSwarmCheck(String numbers) {
    return 'Oğul kontrolü: $numbers';
  }

  @override
  String tourTaskRevisit(String numbers) {
    return 'Atlanan kovanlara bak: $numbers';
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
      other: '$days gün sonra',
      one: 'yarın',
      zero: 'bugün',
    );
    return '$_temp0';
  }

  @override
  String tourSaveTasks(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Görevleri kaydet',
      zero: 'Kapat',
    );
    return '$_temp0';
  }

  @override
  String tourTasksSaved(int count) {
    return '$count görev kaydedildi';
  }

  @override
  String get tourNoTasks => 'Önerilecek görev yok.';

  @override
  String get reportsTitle => 'Raporlar';

  @override
  String get reportTreatmentRegister => 'İlaç kayıt defteri';

  @override
  String get reportTreatmentRegisterHint => 'Denetim için';

  @override
  String get reportHiveHistory => 'Kovan geçmişi';

  @override
  String get reportHiveHistoryHint => 'Tek kovan ya da arılık';

  @override
  String get reportFrom => 'Başlangıç';

  @override
  String get reportTo => 'Bitiş';

  @override
  String get reportApiary => 'Arılık';

  @override
  String get reportAllApiaries => 'Tüm arılıklar';

  @override
  String get reportHive => 'Kovan';

  @override
  String get reportAllHives => 'Tüm kovanlar';

  @override
  String get reportLanguage => 'PDF dili';

  @override
  String get reportLanguageTurkish => 'Türkçe';

  @override
  String get reportLanguageEnglish => 'English';

  @override
  String get reportRegistrationNo => 'İşletme tescil no';

  @override
  String get reportAksNo => 'AKS no';

  @override
  String get reportRecordNo => 'Kayıt numarası';

  @override
  String get reportNumbersHelper =>
      'Yalnız PDF\'in başlığına basılır, kaydedilmez.';

  @override
  String get reportShare => 'Paylaş';

  @override
  String get reportCreate => 'PDF oluştur';

  @override
  String get reportPreparing => 'PDF hazırlanıyor…';

  @override
  String get reportError => 'PDF oluşturulamadı. Yeniden dene.';

  @override
  String get reportLoadError => 'Kayıtlar okunamadı.';

  @override
  String get reportEmpty => 'Bu dönemde kayıt yok.';

  @override
  String reportTreatmentCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count uygulama',
    );
    return '$_temp0';
  }

  @override
  String reportHiveCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count kovan',
    );
    return '$_temp0';
  }

  @override
  String reportRecordCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count kayıt',
    );
    return '$_temp0';
  }

  @override
  String get reportNoValue => '—';

  @override
  String get pdfTreatmentRegisterTitle => 'İlaç Kayıt Defteri';

  @override
  String get pdfHiveHistoryTitle => 'Kovan Geçmişi';

  @override
  String pdfRegistrationNo(String number) {
    return 'İşletme tescil no $number';
  }

  @override
  String pdfAksNo(String number) {
    return 'AKS no $number';
  }

  @override
  String pdfRecordNo(String number) {
    return 'Kayıt no $number';
  }

  @override
  String pdfPeriod(String from, String to) {
    return 'Dönem: $from – $to';
  }

  @override
  String pdfApiary(String name) {
    return 'Arılık: $name';
  }

  @override
  String pdfCreated(String date) {
    return 'Oluşturulma $date';
  }

  @override
  String pdfPage(int page, int pages) {
    return 'Sayfa $page / $pages';
  }

  @override
  String get pdfColumnDate => 'Tarih';

  @override
  String get pdfColumnApiary => 'Arılık';

  @override
  String get pdfColumnProduct => 'Ürün / parti';

  @override
  String get pdfColumnHives => 'Kovan';

  @override
  String get pdfColumnDose => 'Kovan başına doz';

  @override
  String get pdfColumnRemoval => 'Çıkarma';

  @override
  String get pdfColumnWithdrawalEnd => 'Bekleme bitişi';

  @override
  String get pdfColumnEvent => 'Kayıt';

  @override
  String get pdfColumnDetails => 'Ayrıntı';

  @override
  String get pdfEventFeeding => 'Besleme';

  @override
  String get pdfEventVarroa => 'Varroa ölçümü';

  @override
  String get pdfEventHarvest => 'Hasat';

  @override
  String pdfHarvestTotal(String amount) {
    return 'Hasadın tümü: $amount';
  }

  @override
  String pdfDocumentName(String title, String from, String to) {
    return '$title $from–$to';
  }

  @override
  String get moreFeedback => 'Görüş bildir';

  @override
  String get feedbackTitle => 'Görüş bildir';

  @override
  String get feedbackIntro =>
      'Uygulamayı arıcılar için birlikte geliştiriyoruz. Her mesajı okuyoruz.';

  @override
  String get feedbackKindLabel => 'Ne hakkında?';

  @override
  String get feedbackKindBug => 'Hata';

  @override
  String get feedbackKindSuggestion => 'Öneri';

  @override
  String get feedbackKindMissingFeature => 'Eksik özellik';

  @override
  String get feedbackKindThanks => 'Teşekkür';

  @override
  String get feedbackMessageLabel => 'Mesajın';

  @override
  String get feedbackMessageHint => 'Ne oldu, ne bekliyordun?';

  @override
  String get feedbackAddScreenshot => 'Ekran görüntüsü ekle';

  @override
  String get feedbackScreenshotAttached => 'Ekran görüntüsü eklendi';

  @override
  String get feedbackRemoveScreenshot => 'Kaldır';

  @override
  String get feedbackScreenshotDenied =>
      'Fotoğraflara erişim izni verilmedi. Ekran görüntüsü eklemek için Ayarlar\'dan izin ver.';

  @override
  String get feedbackIncludeDeviceInfo => 'Cihaz ve sürüm bilgisini ekle';

  @override
  String get feedbackOfflineHint =>
      'İnternet yoksa mesaj sıraya alınır, bağlanınca gider.';

  @override
  String get feedbackSend => 'Gönder';

  @override
  String get feedbackQueued =>
      'Teşekkürler! Mesajın gönderilmek üzere sıraya alındı.';

  @override
  String get settingsAnalytics => 'Kullanım verisi paylaş';

  @override
  String get settingsAnalyticsHint =>
      'Muayene süresi, okutma sonucu ve senkron gecikmesi gibi sayılar; adın, kovanların ve konumun gönderilmez.';

  @override
  String get teamTitle => 'Ekip';

  @override
  String get teamRoleOwner => 'Sahip';

  @override
  String get teamRolePartner => 'Ortak';

  @override
  String get teamRoleWorker => 'İşçi';

  @override
  String get teamRoleViewer => 'Danışman';

  @override
  String get teamRoleViewerSubtitle => 'Sadece okuma';

  @override
  String get teamRoleHintPartner => 'Ortak kayıt girer ve finansı görür.';

  @override
  String get teamRoleHintWorker => 'İşçi kayıt girer, finansı göremez.';

  @override
  String get teamRoleHintViewer => 'Danışman yalnız okur, kayıt giremez.';

  @override
  String teamMemberSelf(String name) {
    return '$name (sen)';
  }

  @override
  String get teamMemberUnknown => 'Ekip üyesi';

  @override
  String get teamMembersEmpty => 'Üyeler eşitleme bitince görünür.';

  @override
  String get teamInviteTitle => 'Ekibe davet et';

  @override
  String get teamInviteHint => 'Kodu söyle ya da gönder. 48 saat geçerli.';

  @override
  String get teamInviteGenerate => 'Kod üret';

  @override
  String get teamInviteCopy => 'Kopyala';

  @override
  String get teamInviteCopied => 'Kod kopyalandı.';

  @override
  String teamInviteCodeSemantics(String code) {
    return 'Davet kodu $code';
  }

  @override
  String get teamHaveCode => 'Koda sahibim';

  @override
  String get teamJoinTitle => 'Koda katıl';

  @override
  String get teamJoinHint => 'Sana gönderilen 6 haneli kodu gir.';

  @override
  String get teamJoinCodeLabel => 'Davet kodu';

  @override
  String get teamJoinAction => 'Katıl';

  @override
  String get teamJoinDone => 'Ekibe katıldın.';

  @override
  String get teamErrorOffline =>
      'Bu işlem için internet gerekir. Bağlanınca yeniden dene.';

  @override
  String get teamErrorInvalidCode =>
      'Kod geçersiz, süresi dolmuş ya da kullanılmış.';

  @override
  String get teamErrorAlreadyMember => 'Zaten bu ekibin üyesisin.';

  @override
  String get teamErrorForbidden => 'Bu işlem için yetkin yok.';

  @override
  String get teamErrorOwnerLocked =>
      'Sahibin rolü değiştirilemez, sahip ekipten çıkarılamaz.';

  @override
  String get teamErrorUnknown => 'İşlem yapılamadı. Biraz sonra yeniden dene.';

  @override
  String get teamRemoveAction => 'Ekipten çıkar';

  @override
  String get teamRemoveTitle => 'Ekipten çıkarılsın mı?';

  @override
  String teamRemoveMessage(String name) {
    return '$name bu işletmenin kayıtlarına erişemez.';
  }

  @override
  String get teamRemoveConfirm => 'Çıkar';

  @override
  String teamRemoved(String name) {
    return '$name ekipten çıkarıldı.';
  }

  @override
  String teamRoleChanged(String name, String role) {
    return '$name artık $role.';
  }

  @override
  String get teamActivityTitle => 'Son işlemler';

  @override
  String get teamActivityEmpty => 'Henüz işlem yok.';

  @override
  String get teamActivitySelf => 'Sen';

  @override
  String teamActivityInspection(int count) {
    return '$count muayene girdi';
  }

  @override
  String teamActivityTreatment(int count) {
    return '$count kovana ilaç uyguladı';
  }

  @override
  String teamActivityFeeding(int count) {
    return '$count kovanı besledi';
  }

  @override
  String teamActivityHarvest(int count) {
    return '$count hasat kaydetti';
  }

  @override
  String teamActivityMiteCount(int count) {
    return '$count varroa ölçümü girdi';
  }

  @override
  String teamActivityTask(int count) {
    return '$count görev ekledi';
  }

  @override
  String get teamActivityJustNow => 'şimdi';

  @override
  String teamActivityMinutesAgo(int count) {
    return '$count dk önce';
  }

  @override
  String teamActivityHoursAgo(int count) {
    return '$count sa önce';
  }

  @override
  String get teamActivityYesterday => 'dün';

  @override
  String teamActivityDaysAgo(int count) {
    return '$count gün önce';
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
  String get settingsPush => 'Görev bildirimleri';

  @override
  String get settingsPushHint =>
      'Sana bir görev atandığında bildirim gelir. Dokununca görev açılır.';

  @override
  String get documentsTitle => 'Belge kasası';

  @override
  String get documentsAdd => 'Belge ekle';

  @override
  String documentsSummaryOffline(int count) {
    return '$count belge · hepsi internetsiz açılır';
  }

  @override
  String documentsSummaryMissing(int count, int missing) {
    return '$count belge · $missing dosya henüz bu telefonda değil';
  }

  @override
  String get documentsRegionNoteTr =>
      'Belge türleri ülkeye göre gelir. Türkiye dışında kendi belge türlerini oluşturursun.';

  @override
  String get documentsRegionNoteOther =>
      'Belge türlerini sen belirlersin; yazdığın türler sonraki belgelerde önerilir.';

  @override
  String get documentsRoadCheck => 'Yol kontrolü · belgeleri göster';

  @override
  String get documentsEmptyTitle => 'Henüz belge yok';

  @override
  String get documentsEmptyMessage =>
      'Sağlık raporu, nakil evrakı gibi belgelerin fotoğrafını ya da PDF\'ini ekle. İnternetsiz açılır, süresi dolmadan hatırlatılır.';

  @override
  String get documentsLoadError => 'Belgeler açılamadı.';

  @override
  String get documentFileKindPhoto => 'FOTO';

  @override
  String get documentFileKindPdf => 'PDF';

  @override
  String get documentTypeHealthReport => 'Sağlık raporu';

  @override
  String get documentTypeTransportPermit => 'Nakil evrakı';

  @override
  String get documentTypeMigratoryCertificate => 'Gezginci arıcı belgesi';

  @override
  String get documentTypeBusinessRegistration => 'İşletme tescil belgesi';

  @override
  String get documentTypeLandPermit => 'Arazi izni';

  @override
  String get documentTypeAnalysisReport => 'Analiz raporu';

  @override
  String get documentExpiryNone => 'Süresiz';

  @override
  String get documentExpiryExpired => 'Süresi doldu';

  @override
  String get documentExpiryToday => 'Bugün bitiyor';

  @override
  String documentExpiryDays(int days) {
    return '$days gün';
  }

  @override
  String documentExpiryMonths(int months) {
    return '$months ay';
  }

  @override
  String documentExpiresOn(String date) {
    return 'Son geçerlilik: $date';
  }

  @override
  String get documentFormNewTitle => 'Belge ekle';

  @override
  String get documentFormEditTitle => 'Belgeyi düzenle';

  @override
  String get documentFormType => 'Belge türü';

  @override
  String get documentFormCustomTypeHint => 'Örn. Sigorta poliçesi';

  @override
  String get documentFormName => 'Ad';

  @override
  String get documentFormNameHint => 'Örn. Sağlık raporu 2026';

  @override
  String get documentFormDescription => 'Açıklama';

  @override
  String get documentFormDescriptionHint => 'Örn. Ula İlçe Tarım · 152 kovan';

  @override
  String get documentFormExpiry => 'Geçerlilik tarihi';

  @override
  String get documentFormNoExpiry => 'Süresiz';

  @override
  String get documentFormPickDate => 'Tarih seç';

  @override
  String get documentFormExpiryHelper =>
      'Süre dolumundan 30, 7 ve 1 gün önce hatırlatılır.';

  @override
  String get documentFormFile => 'Dosya';

  @override
  String get documentFormTakePhoto => 'Fotoğraf çek';

  @override
  String get documentFormPickImage => 'Galeriden';

  @override
  String get documentFormPickPdf => 'PDF seç';

  @override
  String get documentFormNoFile =>
      'Belgenin fotoğrafını çek ya da PDF\'ini seç.';

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
      'Dosya 20 MB\'tan büyük; daha küçük bir dosya seç.';

  @override
  String get documentFileFailed => 'Dosya alınamadı, yeniden dene.';

  @override
  String get documentFilePermissionDenied =>
      'İzin verilmedi. Belge eklemek için Ayarlar\'dan bu uygulamaya kamera ya da dosya izni ver.';

  @override
  String get documentFormSave => 'Kaydet';

  @override
  String get documentFormDelete => 'Belgeyi sil';

  @override
  String get documentSaved => 'Belge kaydedildi';

  @override
  String get documentReminderDenied =>
      'Belge kaydedildi. Bildirim izni olmadığı için süre dolumu hatırlatması çalmayacak.';

  @override
  String get documentDeleteTitle => 'Belge silinsin mi?';

  @override
  String get documentDeleteMessage =>
      'Belge ve dosyası bütün telefonlardan kalkar.';

  @override
  String get documentDeleteConfirm => 'Sil';

  @override
  String get documentDeleted => 'Belge silindi';

  @override
  String get documentNotFound => 'Belge bulunamadı; silinmiş olabilir.';

  @override
  String get documentEdit => 'Düzenle';

  @override
  String get documentFileMissing =>
      'Dosya bu telefonda henüz yok. İnternet gelince indirilir.';

  @override
  String get documentPdfFailed => 'PDF açılamadı.';

  @override
  String documentPdfPage(int page, int count) {
    return 'Sayfa $page / $count';
  }

  @override
  String get roadCheckTitle => 'Yol kontrolü';

  @override
  String roadCheckPosition(int index, int count) {
    return '$index / $count';
  }

  @override
  String get roadCheckSwipeHint => 'Diğer belge için yana kaydır';

  @override
  String get roadCheckPrevious => 'Önceki belge';

  @override
  String get roadCheckNext => 'Sonraki belge';

  @override
  String documentReminderBody(int days, String date) {
    return '$days gün sonra süresi doluyor · $date';
  }

  @override
  String get syncTableDocuments => 'Belge';

  @override
  String get migrationsTitle => 'Göç planları';

  @override
  String get migrationsAdd => 'Yeni plan';

  @override
  String get migrationsEmptyTitle => 'Henüz göç planı yok';

  @override
  String get migrationsEmptyMessage =>
      'Yılın rotasını planla: her durağın tarihleri, kovan sayısı ve hedef arılığı.';

  @override
  String get migrationsLoadError => 'Göç planları açılamadı';

  @override
  String migrationStopCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count durak',
      zero: 'Durak yok',
    );
    return '$_temp0';
  }

  @override
  String migrationTitle(String name, String year) {
    return '$name $year';
  }

  @override
  String get migrationNotFound => 'Göç planı bulunamadı';

  @override
  String get migrationDocuments => 'Evrak';

  @override
  String get migrationEdit => 'Planı düzenle';

  @override
  String get migrationAddStop => 'Durak ekle';

  @override
  String get migrationNoStopsTitle => 'Henüz durak yok';

  @override
  String get migrationNoStopsMessage =>
      'Rotanın duraklarını sırayla ekle: kaynak, yer, tarihler ve kovan sayısı.';

  @override
  String migrationNextMoveIn(int days) {
    String _temp0 = intl.Intl.pluralLogic(
      days,
      locale: localeName,
      other: '$days gün',
      zero: 'bugün',
    );
    return 'Sıradaki taşıma · $_temp0';
  }

  @override
  String migrationNextMoveLate(int days) {
    return 'Sıradaki taşıma · $days gün gecikti';
  }

  @override
  String migrationRoute(String from, String to) {
    return '$from → $to';
  }

  @override
  String migrationDocReady(String document) {
    return '$document hazır';
  }

  @override
  String migrationDocDays(String document, int days) {
    String _temp0 = intl.Intl.pluralLogic(
      days,
      locale: localeName,
      other: '$days gün',
      zero: 'bugün bitiyor',
    );
    return '$document $_temp0';
  }

  @override
  String migrationDocBeforeMove(String document) {
    return '$document taşımadan önce bitiyor';
  }

  @override
  String migrationDocExpired(String document) {
    return '$document süresi doldu';
  }

  @override
  String migrationDocMissing(String document) {
    return '$document yok';
  }

  @override
  String get migrationStopPast => 'Geçmiş';

  @override
  String get migrationStopCurrent => 'Şu an';

  @override
  String get migrationStopPlanned => 'Plan';

  @override
  String get migrationStopHere => 'Şu an burada';

  @override
  String migrationStopDates(String start, String end) {
    return '$start–$end';
  }

  @override
  String migrationYield(String year, String kg) {
    return '$year: $kg kg/kovan';
  }

  @override
  String migrationYields(String values) {
    return 'Geçmiş verim · $values';
  }

  @override
  String get migrationNoYield => 'Bu arılıkta geçmiş hasat yok';

  @override
  String get migrationFormNewTitle => 'Yeni göç planı';

  @override
  String get migrationFormEditTitle => 'Göç planını düzenle';

  @override
  String get migrationFormYear => 'Yıl';

  @override
  String get migrationFormName => 'Ad';

  @override
  String get migrationFormDefaultName => 'Göç planı';

  @override
  String get migrationFormSave => 'Kaydet';

  @override
  String get migrationFormDelete => 'Planı sil';

  @override
  String get migrationDeleteTitle => 'Göç planı silinsin mi?';

  @override
  String get migrationDeleteMessage => 'Plan ve bütün durakları silinecek.';

  @override
  String get migrationDeleteConfirm => 'Sil';

  @override
  String get migrationSaved => 'Plan kaydedildi';

  @override
  String get migrationDeleted => 'Plan silindi';

  @override
  String get stopFormNewTitle => 'Yeni durak';

  @override
  String get stopFormEditTitle => 'Durağı düzenle';

  @override
  String get stopFormName => 'Kaynak';

  @override
  String get stopFormNameHint => 'ör. Narenciye, Çam';

  @override
  String get stopFormPlace => 'Yer';

  @override
  String get stopFormPlaceHint => 'ör. Erdemli, Mersin';

  @override
  String get stopFormStart => 'Planlanan başlangıç';

  @override
  String get stopFormEnd => 'Planlanan bitiş';

  @override
  String get stopFormApiary => 'Hedef arılık';

  @override
  String get stopFormChooseApiary => 'Hedef arılığı seç';

  @override
  String get stopFormNone => 'Yok';

  @override
  String get stopFormHiveCount => 'Kovan sayısı';

  @override
  String get stopFormPosition => 'Rotadaki sıra';

  @override
  String get stopFormStatus => 'Durum';

  @override
  String get stopFormDelete => 'Durağı sil';

  @override
  String get stopDeleteTitle => 'Durak silinsin mi?';

  @override
  String get stopDeleteMessage => 'Durak plandan kaldırılacak.';

  @override
  String get stopSaved => 'Durak kaydedildi';

  @override
  String get stopDeleted => 'Durak silindi';

  @override
  String get syncTableMigrations => 'Göç planı';

  @override
  String get syncTableMigrationStops => 'Göç durağı';

  @override
  String get moveStart => 'Taşıma başlat';

  @override
  String moveTitle(String route) {
    return 'Taşıma · $route';
  }

  @override
  String get moveNone => 'Sıradaki taşıma yok';

  @override
  String get moreMigratory => 'Gezginci';

  @override
  String get syncTableTransports => 'Taşıma';

  @override
  String get syncTableTransportItems => 'Taşınan kovan';

  @override
  String get moveStepCheck => 'Kontrol';

  @override
  String get moveStepLoad => 'Yükleme';

  @override
  String get moveStepUnload => 'İndirme';

  @override
  String moveStepDone(String step) {
    return '$step, tamam';
  }

  @override
  String get moveNoDestinationTitle => 'Durağın arılığı yok';

  @override
  String get moveNoDestinationMessage =>
      'Kovanların konumu indirince güncellensin diye durağa bir hedef arılık seç.';

  @override
  String get moveEditStop => 'Durağı düzenle';

  @override
  String get moveFrom => 'Nereden';

  @override
  String get moveTo => 'Nereye';

  @override
  String moveSourceHives(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count aktif kovan',
      zero: 'Aktif kovan yok',
    );
    return '$_temp0';
  }

  @override
  String get moveChecklist => 'Yükleme kontrol listesi';

  @override
  String get moveCheckEntrances => 'Uçuş delikleri kapalı';

  @override
  String get moveCheckVentilation => 'Havalandırma açık';

  @override
  String get moveCheckStraps => 'Kayışlar sıkı';

  @override
  String get moveCheckWater => 'Su hazır';

  @override
  String get moveVehicles => 'Araçlar';

  @override
  String moveVehicleDefault(int number) {
    return 'Kamyon $number';
  }

  @override
  String get moveAddVehicle => 'Araç ekle';

  @override
  String moveRemoveVehicle(String vehicle) {
    return '$vehicle aracını çıkar';
  }

  @override
  String get moveVehicleName => 'Araç adı';

  @override
  String get moveVehicleExists => 'Bu adda araç var';

  @override
  String get moveStartLoading => 'Yüklemeye başla';

  @override
  String get moveChecklistHint =>
      'Yüklemeye geçmek için listedeki her şeyi işaretle.';

  @override
  String moveVehicleCount(String vehicle, int count) {
    return '$vehicle · $count';
  }

  @override
  String get moveLoaded => 'Yüklenen';

  @override
  String get moveUnloaded => 'İndirilen';

  @override
  String moveCountTotal(int total) {
    return '/ $total';
  }

  @override
  String moveCountLabel(int count, int total) {
    return '$count / $total kovan';
  }

  @override
  String moveLastScanned(String number) {
    return 'Son okunan: $number';
  }

  @override
  String moveNotScanned(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count kovan henüz okunmadı',
      one: '1 kovan henüz okunmadı',
    );
    return '$_temp0';
  }

  @override
  String get moveAllScanned => 'Hepsi okundu';

  @override
  String get moveShowList => 'Listeyi gör';

  @override
  String get moveMissingTitle => 'Okunmayan kovanlar';

  @override
  String get moveLoadingHint =>
      'Hedefte indirirken tekrar okutacaksın; eksik kovan kalırsa uyarırım. Kovanların konumu indirince güncellenir.';

  @override
  String moveUnloadingHint(String destination) {
    return 'İndirirken her kovanı tekrar okut. Bitirince indirilen kovanlar $destination arılığına taşınır.';
  }

  @override
  String get moveEnterNumber => 'Numara gir';

  @override
  String get moveHiveNumber => 'Kovan numarası';

  @override
  String moveNumberNotFound(String number) {
    return '$number numaralı kovan yok';
  }

  @override
  String get moveScanStart => 'Okutmaya başla';

  @override
  String get moveScanContinue => 'Okutmaya devam';

  @override
  String get moveToUnloading => 'İndirmeye geç';

  @override
  String moveToUnloadingTitle(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count kovan okunmadı',
      one: '1 kovan okunmadı',
    );
    return '$_temp0';
  }

  @override
  String get moveToUnloadingMessage =>
      'Okunmayan kovanlar bu taşımaya girmez ve yerinde kalır.';

  @override
  String get moveFinish => 'Taşımayı bitir';

  @override
  String moveFinishTitle(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count kovan indirilmedi',
      one: '1 kovan indirilmedi',
    );
    return '$_temp0';
  }

  @override
  String moveFinishMessage(String source) {
    return 'İndirilmeyen kovanların konumu değişmez, $source arılığında kalır. Eksik listesi taşımada görünür.';
  }

  @override
  String get moveFinishConfirm => 'Bitir';

  @override
  String get moveDoneTitle => 'Taşıma bitti';

  @override
  String moveDoneSummary(int loaded, int unloaded) {
    return 'Yüklenen $loaded · İndirilen $unloaded';
  }

  @override
  String moveDoneMoved(int count, String destination) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count kovan $destination arılığına taşındı.',
      zero: 'Taşınan kovan yok.',
    );
    return '$_temp0';
  }

  @override
  String get moveDoneMissing => 'İndirilmeyen kovanlar';

  @override
  String moveScanLoaded(String number, String vehicle) {
    return '$number yüklendi · $vehicle';
  }

  @override
  String moveScanLoadedOther(String number) {
    return '$number yüklendi; kovan bu arılıkta değildi';
  }

  @override
  String moveScanAlreadyLoaded(String number) {
    return '$number zaten yüklü';
  }

  @override
  String moveScanUnloaded(String number) {
    return '$number indirildi';
  }

  @override
  String moveScanAlreadyUnloaded(String number) {
    return '$number zaten indirildi';
  }

  @override
  String moveScanNotLoaded(String number) {
    return '$number bu taşımada yüklenmedi';
  }

  @override
  String get moveScanUnknown => 'Tanınmayan etiket';

  @override
  String get moveScanDone => 'Bitti';

  @override
  String get inventoryTitle => 'Malzeme ve stok';

  @override
  String get inventoryAdd => 'Kalem ekle';

  @override
  String get inventoryEmptyTitle => 'Henüz stok kalemi yok';

  @override
  String get inventoryEmptyMessage =>
      'Şeker, temel petek, kavanoz gibi malzemeleri ekle. Eşiğin altına düşen kalem kırmızıyla işaretlenir.';

  @override
  String get inventoryCategoryEmpty => 'Bu kategoride kalem yok';

  @override
  String get inventoryLoadError => 'Stok açılamadı.';

  @override
  String get inventoryNotFound => 'Kalem bulunamadı';

  @override
  String get inventoryCategoryConsumable => 'Sarf';

  @override
  String get inventoryCategoryEquipment => 'Ekipman';

  @override
  String get inventoryCategoryComb => 'Petek';

  @override
  String get inventoryUnitKg => 'kg';

  @override
  String get inventoryUnitLiter => 'L';

  @override
  String get inventoryUnitPiece => 'ad';

  @override
  String get inventoryUnitRoll => 'rulo';

  @override
  String get inventoryUnitPack => 'paket';

  @override
  String get inventoryUnitNameKg => 'Kilogram';

  @override
  String get inventoryUnitNameLiter => 'Litre';

  @override
  String get inventoryUnitNamePiece => 'Adet';

  @override
  String get inventoryUnitNameRoll => 'Rulo';

  @override
  String get inventoryUnitNamePack => 'Paket';

  @override
  String inventoryQuantity(String quantity, String unit) {
    return '$quantity $unit';
  }

  @override
  String inventoryBelowThreshold(String threshold) {
    return 'Eşiğin altında · en az $threshold';
  }

  @override
  String get inventoryMoveIn => 'Giriş';

  @override
  String get inventoryMoveOut => 'Çıkış';

  @override
  String get inventoryMoveCount => 'Sayım';

  @override
  String get inventoryMoveAdjustment => 'Düzeltme';

  @override
  String inventoryInStock(String quantity) {
    return 'Stokta $quantity';
  }

  @override
  String inventoryAmountLabel(String unit) {
    return 'Miktar ($unit)';
  }

  @override
  String inventoryCountedLabel(String unit) {
    return 'Sayılan miktar ($unit)';
  }

  @override
  String get inventoryAmountInvalid => 'Geçerli bir miktar yaz';

  @override
  String get inventoryAmountWhole => 'Bu birimde tam sayı yaz';

  @override
  String get inventorySaveIn => 'Giriş yap';

  @override
  String get inventorySaveOut => 'Çıkış yap';

  @override
  String get inventorySaveCount => 'Stoğu düzelt';

  @override
  String inventoryMovedIn(String quantity) {
    return '$quantity giriş yazıldı';
  }

  @override
  String inventoryMovedOut(String quantity) {
    return '$quantity çıkış yazıldı';
  }

  @override
  String inventoryAdjusted(String quantity) {
    return 'Stok $quantity oldu';
  }

  @override
  String inventoryUnchanged(String quantity) {
    return 'Stok zaten $quantity';
  }

  @override
  String get inventoryDetails => 'Ayrıntılar ve hareketler';

  @override
  String get inventoryHistory => 'Hareketler';

  @override
  String get inventoryHistoryEmpty => 'Henüz hareket yok';

  @override
  String inventoryThreshold(String threshold) {
    return 'Eşik: en az $threshold';
  }

  @override
  String get inventoryNoThreshold => 'Eşik yok';

  @override
  String get inventoryQuickMove => 'Giriş / çıkış';

  @override
  String get inventoryEdit => 'Kalemi düzenle';

  @override
  String get inventoryFormNewTitle => 'Yeni kalem';

  @override
  String get inventoryFormEditTitle => 'Kalemi düzenle';

  @override
  String get inventoryFormName => 'Ad';

  @override
  String get inventoryFormCategory => 'Kategori';

  @override
  String get inventoryFormUnit => 'Birim';

  @override
  String get inventoryFormLocation => 'Konum';

  @override
  String get inventoryFormLocationHint =>
      'Depo, kamyonet, ofis… Boş bırakılabilir.';

  @override
  String get inventoryFormThreshold => 'Eşik';

  @override
  String get inventoryFormThresholdHint =>
      'Stok bunun altına düşünce uyarılır. Boş bırakılabilir.';

  @override
  String get inventoryFormThresholdInvalid => 'Geçerli bir eşik yaz';

  @override
  String get inventoryFormSave => 'Kaydet';

  @override
  String get inventoryFormDelete => 'Kalemi sil';

  @override
  String get inventoryDeleteTitle => 'Kalem silinsin mi?';

  @override
  String get inventoryDeleteMessage => 'Kalem ve stoğu listeden kalkar.';

  @override
  String get inventoryDeleteConfirm => 'Sil';

  @override
  String get inventorySaved => 'Kalem kaydedildi';

  @override
  String get inventoryDeleted => 'Kalem silindi';

  @override
  String get syncTableInventoryItems => 'Stok kalemi';

  @override
  String get syncTableInventoryMoves => 'Stok hareketi';

  @override
  String inventoryIncrease(String quantity) {
    return '+$quantity';
  }

  @override
  String inventoryFormThresholdUnit(String unit) {
    return 'Eşik ($unit)';
  }

  @override
  String get stockUseTitle => 'Stoktan düş';

  @override
  String get stockUseNone => 'Düşme';

  @override
  String stockUseValue(String item, String quantity) {
    return '$item · −$quantity';
  }

  @override
  String get stockUseChoose => 'Hangi kalemden düşülsün?';

  @override
  String get taskFormTreatment => 'İlaçlama planı';

  @override
  String get taskFormTreatmentUnknown => 'Listede olmayan ilaç';

  @override
  String get taskFormTreatmentNeedsApiary => 'İlaçlama planı için arılık seç';

  @override
  String taskTreatmentPlanTitle(String drug) {
    return 'İlaçlama · $drug';
  }

  @override
  String get shoppingTitle => 'Alışveriş listesi';

  @override
  String shoppingCardTitle(int count) {
    return 'Alışveriş listesi · $count';
  }

  @override
  String get shoppingEmptyTitle => 'Alınacak bir şey yok';

  @override
  String get shoppingEmptyMessage =>
      'Eşiğin altına düşen kalemler ve planlı ilaçlamaların ihtiyacı burada görünür.';

  @override
  String get shoppingShare => 'Paylaş';

  @override
  String get shoppingLoadError => 'Alışveriş listesi açılamadı';

  @override
  String shoppingReasonThreshold(String stock, String threshold) {
    return 'Stokta $stock · en az $threshold';
  }

  @override
  String shoppingReasonPlanned(String quantity) {
    return 'Planlı ilaçlama $quantity';
  }

  @override
  String get shoppingReasonNoItem => 'Planlı ilaçlama · stok kalemi yok';

  @override
  String shoppingShareLine(String name, String quantity) {
    return '• $name: $quantity';
  }

  @override
  String get moreRearing => 'Ana yetiştirme';

  @override
  String get rearingTitle => 'Ana yetiştirme';

  @override
  String rearingBatchName(int number) {
    return 'Seri $number';
  }

  @override
  String rearingBatchTitle(int number) {
    return 'Ana yetiştirme · Seri $number';
  }

  @override
  String get rearingAdd => 'Seri ekle';

  @override
  String get rearingEmptyTitle => 'Henüz seri yok';

  @override
  String get rearingEmptyMessage =>
      'Larva aktarma gününü girin; kabulden yumurtlama kontrolüne kadar takvim ve hatırlatmalar kendiliğinden kurulur.';

  @override
  String get rearingLoadError => 'Seriler açılamadı';

  @override
  String get rearingNotFound => 'Seri bulunamadı';

  @override
  String rearingListGrafted(String date) {
    return 'aktarma $date';
  }

  @override
  String get rearingEdit => 'Seriyi düzenle';

  @override
  String get rearingGraftedLabel => 'Aktarılan';

  @override
  String get rearingAcceptedLabel => 'Kabul';

  @override
  String get rearingNucsLabel => 'Kutu';

  @override
  String get rearingNotCounted => 'Sayılmadı';

  @override
  String rearingAcceptedPercent(int percent) {
    return '%$percent';
  }

  @override
  String rearingMotherLine(String mother, String date) {
    return 'Anne ana: $mother · aktarma $date';
  }

  @override
  String rearingMotherUnknownLine(String date) {
    return 'Anne ana bilinmiyor · aktarma $date';
  }

  @override
  String rearingDay(int day) {
    return 'G$day';
  }

  @override
  String get rearingToday => 'Bugün';

  @override
  String get rearingStepGraft => 'Larva aktarma';

  @override
  String get rearingStepAcceptance => 'Kabul kontrolü';

  @override
  String get rearingStepCapped => 'Memeler kapandı';

  @override
  String get rearingStepDistribution => 'Memeleri dağıt';

  @override
  String get rearingStepEmergence => 'Ana çıkışı';

  @override
  String get rearingStepLayingCheck => 'Yumurtlama kontrolü';

  @override
  String rearingStepGraftDetail(int count) {
    return '$count larva';
  }

  @override
  String rearingStepAcceptanceDetail(int count) {
    return '$count meme kabul edildi';
  }

  @override
  String get rearingStepAcceptanceTodo => 'Kabul edilen memeleri say';

  @override
  String get rearingStepCappedDetail => 'Rahatsız etme';

  @override
  String rearingStepDistributionDetail(int count) {
    return 'Çıkıştan önce, $count kutuya';
  }

  @override
  String get rearingStepDistributionTodo => 'Çıkıştan önce, kutulara';

  @override
  String get rearingStepEmergenceDetail => 'Kutularda kontrol et';

  @override
  String get rearingStepLayingCheckDetail => 'Çiftleşme başarısını işaretle';

  @override
  String get rearingStepDone => 'bitti';

  @override
  String get rearingStepCurrent => 'sıradaki';

  @override
  String get rearingStepUpcoming => 'ileride';

  @override
  String get rearingDistribute => 'Memeleri kutulara dağıt';

  @override
  String get rearingDistributeApiary => 'Arılık';

  @override
  String get rearingDistributeCount => 'Kutu sayısı';

  @override
  String rearingDistributePlan(int reused, int created) {
    return 'Boş kutu: $reused · Yeni kutu: $created';
  }

  @override
  String get rearingDistributeSave => 'Dağıt';

  @override
  String get rearingDistributeNoApiary => 'Önce bir arılık ekleyin';

  @override
  String rearingDistributed(int count) {
    return '$count kutuya dağıtıldı';
  }

  @override
  String get rearingNucsSection => 'Çiftleşme kutuları';

  @override
  String rearingNucTitle(String number) {
    return 'Kutu $number';
  }

  @override
  String get matingNucStatusEmpty => 'Boş';

  @override
  String get matingNucStatusCell => 'Meme var';

  @override
  String get matingNucStatusVirgin => 'Ana çıktı';

  @override
  String get matingNucStatusLaying => 'Yumurtluyor';

  @override
  String get matingNucStatusFailed => 'Başarısız';

  @override
  String get matingNucStatusGiven => 'Kovana verildi';

  @override
  String get rearingNucGive => 'Kovana ver';

  @override
  String get rearingNucChooseHive => 'Hangi kovana?';

  @override
  String get rearingNucNoHives => 'Aktif kovan yok';

  @override
  String get rearingFormNewTitle => 'Yeni seri';

  @override
  String get rearingFormEditTitle => 'Seriyi düzenle';

  @override
  String get rearingFormGraftedOn => 'Aktarma günü';

  @override
  String get rearingFormGraftedCount => 'Aktarılan larva';

  @override
  String get rearingFormAcceptedCount => 'Kabul edilen meme';

  @override
  String get rearingFormAcceptedClear => 'Henüz sayılmadı';

  @override
  String get rearingFormScheduleHint =>
      'Kabul, kapanma, dağıtım, çıkış ve yumurtlama kontrolü hatırlatmalı görev olarak açılır.';

  @override
  String get rearingFormSave => 'Kaydet';

  @override
  String get rearingFormDelete => 'Seriyi sil';

  @override
  String get rearingDeleteTitle => 'Seri silinsin mi?';

  @override
  String get rearingDeleteMessage =>
      'Takvim görevleri de silinir. Kutular ve verilen analar kalır.';

  @override
  String get rearingDeleteConfirm => 'Sil';

  @override
  String get rearingDeleted => 'Seri silindi';

  @override
  String get rearingSaved => 'Seri kaydedildi';

  @override
  String get taskSourceQueenRearing => 'ana yetiştirme';

  @override
  String get syncTableQueenRearingBatches => 'Ana yetiştirme serisi';

  @override
  String get syncTableMatingNucs => 'Çiftleşme kutusu';

  @override
  String get lotsTitle => 'Hasat ve lotlar';

  @override
  String get lotsEmptyTitle => 'Henüz lot yok';

  @override
  String get lotsEmptyMessage =>
      'Hasadı kaydettikten sonra lota ekleyin; lotlar burada listelenir.';

  @override
  String get lotsLoadError => 'Lotlar yüklenemedi';

  @override
  String get lotsInStock => 'Stokta';

  @override
  String get lotsPerHive => 'Kovan başı';

  @override
  String lotNumber(String number) {
    return 'Lot $number';
  }

  @override
  String lotHoneyTitle(String kind) {
    return '$kind balı';
  }

  @override
  String get lotStatusOpen => 'Açık';

  @override
  String get lotStatusClosed => 'Kapalı';

  @override
  String get lotWithdrawalBadge => 'Bekleme süresinde';

  @override
  String lotMoistureValue(String value) {
    return 'Nem %$value';
  }

  @override
  String get lotAnalyzed => 'Analiz ✓';

  @override
  String get lotAnalysisPending => 'Analiz bekliyor';

  @override
  String lotStockValue(String weight) {
    return 'Stok $weight';
  }

  @override
  String get lotNotFound => 'Lot bulunamadı';

  @override
  String get lotEdit => 'Lotu düzenle';

  @override
  String lotWithdrawalTitle(String hives) {
    return '$hives bekleme süresinde hasat edildi.';
  }

  @override
  String get lotWithdrawalMessage =>
      'Bu lotun balında ilaç kalıntısı olabilir; satıştan önce analiz yaptırın.';

  @override
  String get lotStock => 'Stok';

  @override
  String get lotHarvested => 'Hasat';

  @override
  String get lotSold => 'Satılan';

  @override
  String get lotInStock => 'Stokta';

  @override
  String get lotSell => 'Satış düş';

  @override
  String get lotAnalyses => 'Analizler';

  @override
  String get lotAnalysesEmpty => 'Henüz analiz yok';

  @override
  String get lotAddAnalysis => 'Analiz ekle';

  @override
  String get lotHarvests => 'Hasatlar';

  @override
  String get lotHarvestsEmpty => 'Bu lotta hasat yok';

  @override
  String get lotTreatments => 'Kovanların son ilaçlaması';

  @override
  String get lotTreatmentsEmpty => 'Bu lotun kovanlarında ilaçlama kaydı yok';

  @override
  String lotTreatmentTitle(String hive, String product) {
    return 'Kovan $hive · $product';
  }

  @override
  String lotTreatmentDetail(String date, String end) {
    return '$date · bekleme $end günü bitiyor';
  }

  @override
  String get lotPublicPage => 'Herkese açık sayfa';

  @override
  String get lotPublish => 'Yayımla';

  @override
  String get lotPublishHint =>
      'QR\'ı okutan herkes lotun sayfasını görür. Telefon, adres ve konum hiç görünmez.';

  @override
  String get lotPublishOwnerOnly => 'Yalnız işletme sahibi yayımlayabilir.';

  @override
  String get lotPublished => 'Yayımda';

  @override
  String get lotNotPublished => 'Yayımda değil';

  @override
  String get lotPublicFields => 'Sayfada görünenler';

  @override
  String get lotPublicProducer => 'İşletme adı ve kovan sayısı';

  @override
  String get lotPublicOrigin => 'Yöre ve hasat ayı';

  @override
  String get lotPublicLab => 'Analiz değerleri';

  @override
  String get lotPublicReport => 'Analiz raporu';

  @override
  String get lotJarLabels => 'Kavanoz etiketi (QR)';

  @override
  String get lotJarLabelsHint =>
      'A4 sayfaya 24 etiket (70 × 37 mm); yazdırırken ölçeği %100 seç.';

  @override
  String lotJarLabelsDocumentName(String number) {
    return 'Kavanoz etiketi - $number';
  }

  @override
  String get lotSales => 'Satışlar';

  @override
  String get lotSalesEmpty => 'Henüz satış düşülmedi';

  @override
  String lotSaleValue(String weight) {
    return '−$weight';
  }

  @override
  String lotSaleAmount(String unit) {
    return 'Satılan bal ($unit)';
  }

  @override
  String lotSaleTooMuch(String weight) {
    return 'Stokta en çok $weight var';
  }

  @override
  String get lotSaleSave => 'Stoktan düş';

  @override
  String lotSaleSaved(String weight) {
    return '$weight satış düşüldü';
  }

  @override
  String get lotOrigin => 'Yöre';

  @override
  String get lotOriginHint => 'Ör. Kızılçam';

  @override
  String get lotMoisture => 'Nem %';

  @override
  String get lotMoistureHelper => 'Refraktömetre değeri; boş bırakılabilir';

  @override
  String get lotMoistureInvalid =>
      '10 ile 30 arasında, 17,2 gibi bir değer yaz';

  @override
  String lotEditTitle(String lot) {
    return '$lot düzenle';
  }

  @override
  String get lotStatus => 'Durum';

  @override
  String get lotStatusHelper => 'Kapalı lota yeni hasat eklenmez';

  @override
  String get lotSave => 'Kaydet';

  @override
  String get lotDelete => 'Lotu sil';

  @override
  String lotDeleteTitle(String lot) {
    return '$lot silinsin mi?';
  }

  @override
  String get lotDeleteMessage =>
      'Analizler ve satışlar da silinir; hasatlar kalır.';

  @override
  String get lotDeleted => 'Lot silindi';

  @override
  String labTitle(String lot) {
    return 'Analiz · $lot';
  }

  @override
  String get labDate => 'Analiz günü';

  @override
  String get labHmf => 'HMF (mg/kg)';

  @override
  String get labDiastase => 'Diastaz sayısı';

  @override
  String get labProline => 'Prolin (mg/kg)';

  @override
  String labHmfValue(String value) {
    return 'HMF $value';
  }

  @override
  String labDiastaseValue(String value) {
    return 'Diastaz $value';
  }

  @override
  String labProlineValue(String value) {
    return 'Prolin $value';
  }

  @override
  String labValueInvalid(String min, String max) {
    return '$min ile $max arasında bir değer yaz';
  }

  @override
  String get labResidue => 'Kalıntı';

  @override
  String get labResidueNone => 'Kalıntı yok';

  @override
  String get labResidueDetected => 'Kalıntı var';

  @override
  String get labReport => 'Rapor';

  @override
  String get labReportNone => 'Rapor yok';

  @override
  String get labReportEmpty => 'Belge kasasında analiz raporu yok';

  @override
  String get labReportAdd => 'Belge kasasına rapor ekle';

  @override
  String get labSave => 'Analizi kaydet';

  @override
  String get labSaved => 'Analiz kaydedildi';

  @override
  String get harvestLotTitle => 'Lota ekle';

  @override
  String harvestLotSaved(String weight, String kind) {
    return 'Hasat kaydedildi: $weight $kind';
  }

  @override
  String get harvestLotIntro =>
      'Bal bir lota girince kovanların son ilaçlama tarihleri lota bağlanır.';

  @override
  String get harvestLotNew => 'Yeni lot';

  @override
  String harvestLotNewHint(String kind) {
    return '$kind · numara kendiliğinden verilir';
  }

  @override
  String get harvestLotCreate => 'Lot oluştur';

  @override
  String get harvestLotAdd => 'Lota ekle';

  @override
  String get harvestLotSkip => 'Şimdilik geç';

  @override
  String harvestLotCreated(String lot) {
    return '$lot oluşturuldu';
  }

  @override
  String harvestLotAdded(String lot) {
    return 'Hasat $lot lotuna eklendi';
  }

  @override
  String get harvestLotGone => 'Hasat geri alındı';

  @override
  String get harvestLotBack => 'Arılığa dön';

  @override
  String get syncTableLots => 'Lot';

  @override
  String get syncTableLotHarvests => 'Lot hasadı';

  @override
  String get syncTableLotTreatments => 'Lot ilaçlaması';

  @override
  String get syncTableLabResults => 'Analiz';

  @override
  String get syncTableLotSales => 'Lot satışı';

  @override
  String get harvestLotGoneMessage =>
      'Hasat lota eklenmedi. Arılıktan yeniden kaydedebilirsiniz.';

  @override
  String get financeTitle => 'Finans';

  @override
  String financeYearTitle(String year) {
    return 'Finans · $year';
  }

  @override
  String get financeSeasonNet => 'Sezon net';

  @override
  String get financeIncome => 'Gelir';

  @override
  String get financeExpense => 'Gider';

  @override
  String get financeCostPerHive => 'Maliyet/kovan';

  @override
  String get financeRecent => 'Son hareketler';

  @override
  String get financeEmptyTitle => 'Henüz hareket yok';

  @override
  String get financeEmptyMessage =>
      'Gelir ve giderleri aşağıdaki butonlarla kaydedin; sezon neti burada hesaplanır.';

  @override
  String get financeLoadError => 'Hareketler yüklenemedi';

  @override
  String get financeAddIncome => '+ Gelir';

  @override
  String get financeAddExpense => '− Gider';

  @override
  String financePlus(String amount) {
    return '+$amount';
  }

  @override
  String financeMinus(String amount) {
    return '−$amount';
  }

  @override
  String get financeReceiptAttached => 'fiş eklendi';

  @override
  String financeTransportRoute(String from, String to) {
    return '$from → $to';
  }

  @override
  String get financeFormIncomeTitle => 'Gelir ekle';

  @override
  String get financeFormExpenseTitle => 'Gider ekle';

  @override
  String financeFormAmount(String currency) {
    return 'Tutar ($currency)';
  }

  @override
  String get financeFormAmountInvalid =>
      '0\'dan büyük, 17.500 ya da 17,50 gibi bir tutar yaz';

  @override
  String get financeFormCategory => 'Kategori';

  @override
  String get financeFormDate => 'Tarih';

  @override
  String get financeFormDescription => 'Açıklama';

  @override
  String get financeFormDescriptionHint => 'Ör. Şeker 500 kg';

  @override
  String get financeFormReceipt => 'Fiş / fatura';

  @override
  String get financeFormNoReceipt => 'Fiş eklenmedi';

  @override
  String get financeFormReceiptAdded => 'Fiş fotoğrafı eklendi';

  @override
  String get financeFormTakePhoto => 'Fotoğraf çek';

  @override
  String get financeFormPickImage => 'Galeriden seç';

  @override
  String get financeFormRemoveReceipt => 'Fişi kaldır';

  @override
  String get financeFormPhotoDenied =>
      'İzin verilmedi. Fiş eklemek için Ayarlar\'dan bu uygulamaya kamera ya da fotoğraf izni ver.';

  @override
  String get financeFormPhotoFailed => 'Fotoğraf alınamadı, yeniden dene.';

  @override
  String get financeFormLinks => 'Bağlı kayıt';

  @override
  String get financeFormApiary => 'Arılık';

  @override
  String get financeFormLot => 'Lot';

  @override
  String get financeFormTransport => 'Taşıma';

  @override
  String get financeFormNone => 'Yok';

  @override
  String get financeFormChooseApiary => 'Arılık seç';

  @override
  String get financeFormChooseLot => 'Lot seç';

  @override
  String get financeFormChooseTransport => 'Taşıma seç';

  @override
  String get financeFormNoLots => 'Henüz lot yok';

  @override
  String get financeFormNoTransports => 'Henüz taşıma yok';

  @override
  String financeFormSaleAmount(String unit) {
    return 'Satılan bal ($unit)';
  }

  @override
  String get financeFormSaleHelper =>
      'Lotun stoğundan düşülür; boş bırakılırsa stok değişmez';

  @override
  String get financeFormSave => 'Kaydet';

  @override
  String get financeIncomeSaved => 'Gelir kaydedildi';

  @override
  String get financeExpenseSaved => 'Gider kaydedildi';

  @override
  String get financeNotFound => 'Hareket bulunamadı';

  @override
  String get financeReceiptPending => 'Fiş bu telefona henüz inmedi';

  @override
  String get financeDelete => 'Hareketi sil';

  @override
  String get financeDeleteTitle => 'Hareket silinsin mi?';

  @override
  String get financeDeleteMessage =>
      'Lot satışına bağlıysa satış da silinir ve stok geri gelir.';

  @override
  String get financeDeleteConfirm => 'Sil';

  @override
  String get financeDeleted => 'Hareket silindi';

  @override
  String get financeCategoryFeeding => 'Besleme';

  @override
  String get financeCategoryTreatment => 'İlaç';

  @override
  String get financeCategoryEquipment => 'Ekipman';

  @override
  String get financeCategoryFuelTransport => 'Yakıt / nakliye';

  @override
  String get financeCategoryLandRent => 'Arazi kirası';

  @override
  String get financeCategoryLabor => 'İşçilik';

  @override
  String get financeCategoryLabAnalysis => 'Analiz';

  @override
  String get financeCategoryHoney => 'Bal';

  @override
  String get financeCategoryPollen => 'Polen';

  @override
  String get financeCategoryPropolis => 'Propolis';

  @override
  String get financeCategoryWax => 'Mum';

  @override
  String get financeCategoryNucs => 'Oğulcuk';

  @override
  String get financeCategoryQueens => 'Ana arı';

  @override
  String get financeCategoryOther => 'Diğer';

  @override
  String get syncTableTransactions => 'Gelir-gider';

  @override
  String get customersTitle => 'Müşteri defteri';

  @override
  String get customersAdd => 'Müşteri ekle';

  @override
  String get customersEmptyTitle => 'Henüz müşteri yok';

  @override
  String get customersEmptyMessage =>
      'Satışlarını ve alacağını izlemek için müşteri ekle.';

  @override
  String customerReceivableValue(String amount) {
    return '$amount alacak';
  }

  @override
  String get customerNoReceivable => 'Alacak yok';

  @override
  String get customerNotFound => 'Müşteri bulunamadı';

  @override
  String get customerEdit => 'Müşteriyi düzenle';

  @override
  String get customerAddSale => 'Satış ekle';

  @override
  String get customerOrders => 'Siparişler';

  @override
  String get customerNoOrders => 'Bu müşteriye henüz satış yok.';

  @override
  String get customerPaid => 'Ödendi';

  @override
  String customerRemaining(String amount) {
    return 'Kalan $amount';
  }

  @override
  String get customerPaidAmount => 'Ödenen';

  @override
  String get customerMarkPaid => 'Ödendi olarak işaretle';

  @override
  String get customerMarkedPaid => 'Ödendi olarak işaretlendi';

  @override
  String get customerAddPayment => 'Tahsilat ekle';

  @override
  String get customerSendWhatsApp => 'WhatsApp ile gönder';

  @override
  String get customerWhatsAppNoPhone =>
      'Telefon yok; kişiyi WhatsApp\'ta seçersin';

  @override
  String get customerWhatsAppFailed => 'WhatsApp açılamadı';

  @override
  String get customerOpenTransaction => 'Hareketi aç';

  @override
  String customerWhatsAppGreeting(String name) {
    return 'Merhaba $name,';
  }

  @override
  String get customerWhatsAppIntro => 'Sipariş özetiniz:';

  @override
  String customerWhatsAppAmount(String amount) {
    return 'Tutar: $amount';
  }

  @override
  String customerWhatsAppPaid(String amount) {
    return 'Ödenen: $amount';
  }

  @override
  String customerWhatsAppRemaining(String amount) {
    return 'Kalan: $amount';
  }

  @override
  String get customerWhatsAppPaidInFull => 'Ödemeniz tamamlandı, teşekkürler.';

  @override
  String customerWhatsAppAddress(String address) {
    return 'Kargo adresi: $address';
  }

  @override
  String get customerFormNewTitle => 'Yeni müşteri';

  @override
  String get customerFormEditTitle => 'Müşteriyi düzenle';

  @override
  String get customerFormName => 'Ad';

  @override
  String get customerFormPhone => 'Telefon';

  @override
  String get customerFormPhoneHelper => 'WhatsApp için; ör. 0532 123 45 67';

  @override
  String get customerFormAddress => 'Kargo adresi';

  @override
  String get customerFormNotes => 'Not';

  @override
  String get customerFormSave => 'Kaydet';

  @override
  String get customerSaved => 'Müşteri kaydedildi';

  @override
  String get customerDelete => 'Müşteriyi sil';

  @override
  String get customerDeleteTitle => 'Müşteri silinsin mi?';

  @override
  String get customerDeleteMessage => 'Satışları finans hareketlerinde kalır.';

  @override
  String get customerDeleteConfirm => 'Sil';

  @override
  String get customerDeleted => 'Müşteri silindi';

  @override
  String get customerPaymentSave => 'Tahsilatı kaydet';

  @override
  String get customerPaymentSaved => 'Tahsilat kaydedildi';

  @override
  String customerPaymentTooMuch(String amount) {
    return 'Kalan $amount; daha fazlası yazılamaz.';
  }

  @override
  String get financeFormCustomer => 'Müşteri';

  @override
  String get financeFormChooseCustomer => 'Müşteri seç';

  @override
  String get financeFormNoCustomers => 'Henüz müşteri yok';

  @override
  String get financeFormPaidNow => 'Peşin alınan';

  @override
  String get financeFormPaidNowHelper => 'Boş bırakırsan tamamı alacak olur.';

  @override
  String get financeFormPaidTooMuch => 'Peşin alınan tutardan fazla olamaz.';

  @override
  String get financeProfitTitle => 'Konaklama kârlılığı';

  @override
  String get financeProfitUnknownApiary => 'Silinmiş arılık';

  @override
  String financeReceivables(String amount, int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count müşteri',
      one: '1 müşteri',
    );
    return '$amount alacak · $_temp0';
  }

  @override
  String get syncTableCustomers => 'Müşteri';

  @override
  String get syncTableCustomerPayments => 'Tahsilat';

  @override
  String get customerUnpaid => 'Ödenmedi';

  @override
  String customerPartiallyPaid(String paid, String remaining) {
    return '$paid ödendi, $remaining kalan';
  }

  @override
  String get taskAksUpdateTitle => 'AKS\'de güncellemeyi unutma';

  @override
  String get taskSourceAks => 'AKS';

  @override
  String get syncTableRefSupportPeriods => 'Destek dönemi';

  @override
  String get subsidiesTitle => 'Destekler';

  @override
  String get subsidiesCheckTitle => 'Başvuru öncesi kontrol';

  @override
  String get subsidiesActiveHives => 'Uygulamada aktif kovan';

  @override
  String get subsidiesDeclaredHives => 'AKS\'de beyan edilen';

  @override
  String get subsidiesNotDeclared => 'Girilmedi';

  @override
  String get subsidiesCheckNotDeclared =>
      'AKS\'de beyan ettiğin kovan sayısını gir; başvurmadan önce uygulamadaki sayıyla karşılaştırılır.';

  @override
  String subsidiesCheckDiffers(String active, String declared) {
    return 'Uygulamada $active aktif kovan var, AKS\'de $declared beyan edilmiş. Başvurmadan önce AKS kaydını güncelle.';
  }

  @override
  String get subsidiesCheckMatches => 'Sayılar tutuyor: uygulama ile AKS aynı.';

  @override
  String get subsidiesEditDeclared => 'Beyan edilen sayıyı gir';

  @override
  String get subsidiesDeclaredOwnerOnly =>
      'Beyan edilen sayıyı yalnız işletme sahibi girebilir.';

  @override
  String get subsidiesPeriodsTitle => 'Başvuru dönemleri';

  @override
  String get subsidiesEmptyTitle => 'Henüz destek dönemi yok';

  @override
  String get subsidiesEmptyMessage =>
      'Başvuru dönemleri duyuruldukça burada görünür; dönem açılınca bildirim gelir.';

  @override
  String get subsidiesPhaseOpen => 'Başvuru açık';

  @override
  String get subsidiesPhaseUpcoming => 'Yakında';

  @override
  String get subsidiesPhaseClosed => 'Bitti';

  @override
  String subsidiesPeriodDates(String start, String end) {
    return '$start – $end';
  }

  @override
  String get subsidiesOpenSource => 'Resmî duyuruyu aç';

  @override
  String get subsidiesOpenSourceFailed => 'Bağlantı açılamadı';

  @override
  String get aksCountTitle => 'AKS kovan sayısı';

  @override
  String get aksCountLabel => 'AKS\'de beyan ettiğin kovan sayısı';

  @override
  String get aksCountHelper => 'Boş bırakırsan kontrol yapılmaz.';

  @override
  String get aksCountInvalid => '0 ile 100.000 arasında bir sayı yaz';

  @override
  String get aksCountSave => 'Kaydet';

  @override
  String get aksCountSaved => 'AKS kovan sayısı kaydedildi';

  @override
  String get aksCountNoOrganization =>
      'İşletme bilgisi henüz bu telefona inmedi; senkronu bekle.';

  @override
  String get knowledgeTitle => 'Bilgi bankası';

  @override
  String get knowledgeSearchHint => 'Kışlık stok, varroa…';

  @override
  String knowledgeMonthLabel(String month, String place) {
    return '$month · $place';
  }

  @override
  String get knowledgePlaceTurkey => 'Türkiye';

  @override
  String get knowledgePlaceNorthern => 'Kuzey yarımküre';

  @override
  String get knowledgePlaceSouthern => 'Güney yarımküre';

  @override
  String get knowledgeMonthTitle => 'Bu ay yapılacaklar';

  @override
  String get knowledgeDiagnosisTitle => 'Teşhis yardımcısı';

  @override
  String get knowledgeDiagnosisSubtitle => 'Belirtiyi seç, olası nedenleri gör';

  @override
  String get knowledgeAtlasTitle => 'Hastalık ve zararlı atlası';

  @override
  String knowledgeTopicCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count konu',
    );
    return '$_temp0';
  }

  @override
  String get knowledgeGuidesTitle => 'Teknik rehberler';

  @override
  String get knowledgeGuidesSubtitle =>
      'Bölme, ana verme, birleştirme, kışlatma';

  @override
  String get knowledgeCalculatorsTitle => 'Hesaplayıcılar';

  @override
  String get knowledgeCalculatorsSubtitle =>
      'Şurup, ilaç dozu, ana takvimi, verim';

  @override
  String get knowledgeRegulationsTitle => 'Mevzuat özetleri';

  @override
  String get knowledgeRegulationsSubtitle =>
      'Yönetmelik, gezginci, bal tebliği';

  @override
  String get knowledgeTrBadge => 'TR';

  @override
  String get knowledgeFirstYearTitle => 'İlk yılım';

  @override
  String get knowledgeFirstYearSubtitle => 'Yeni başlayanlar için adım adım';

  @override
  String get knowledgeCalendarTitle => 'Mevsim takvimi';

  @override
  String get knowledgeOffline => 'Tüm içerik internetsiz açılır';

  @override
  String get knowledgeNoResultsTitle => 'Sonuç yok';

  @override
  String get knowledgeNoResultsMessage => 'Başka bir kelimeyle ara.';

  @override
  String get knowledgeCategoryEmptyTitle => 'Henüz makale yok';

  @override
  String get knowledgeCategoryEmptyMessage =>
      'Bu bölümün içeriği güncellemeyle gelecek.';

  @override
  String get knowledgeArticleNotFound => 'Makale bulunamadı';

  @override
  String get knowledgeLoadError => 'Bilgi bankası açılamadı';

  @override
  String get knowledgeLinkFailed => 'Bağlantı açılamadı';

  @override
  String get diagnosisSymptoms => 'Gördüğün belirtiler';

  @override
  String get diagnosisSymptomsHelper => 'Birden çok seçebilirsin.';

  @override
  String get diagnosisResults => 'Olası hastalıklar';

  @override
  String get diagnosisPickHint =>
      'Belirti seçince olası hastalıklar burada görünür.';

  @override
  String get diagnosisNoMatch => 'Seçilen belirtilere uyan hastalık yok.';

  @override
  String diagnosisMatched(int matched, int total) {
    return 'Eşleşen belirti: $matched/$total';
  }

  @override
  String get diagnosisNotifiable => 'İhbarı mecburi';

  @override
  String get diagnosisDisclaimer =>
      'Bu bir ön değerlendirmedir; kesin teşhisi veteriner ya da laboratuvar koyar.';

  @override
  String get diagnosisLoadError => 'Teşhis tablosu açılamadı';

  @override
  String get diagnosisNotFound => 'Hastalık bulunamadı';

  @override
  String get diagnosisNotifiableTitle => 'İhbarı mecburi hastalık.';

  @override
  String get diagnosisNotifiableMessage =>
      'Şüpheyi yetkili kuruma bildir; kovanın ekipmanını, çerçevelerini ve balını başka kovanlarla paylaşma.';

  @override
  String get diagnosisAdvice => 'Ne yapmalı';

  @override
  String get diagnosisAuthority => 'Yetkili kurum';

  @override
  String diagnosisCall(String phone) {
    return 'Ara: $phone';
  }

  @override
  String get diagnosisCallFailed => 'Arama açılamadı';

  @override
  String get diagnosisQuarantine => 'Kovanı karantinaya al';

  @override
  String get quarantinePickTitle => 'Karantinaya alınacak kovan';

  @override
  String get quarantineSearchHint => 'Kovan numarası';

  @override
  String get quarantineNoHivesTitle => 'Kovan yok';

  @override
  String get quarantineNoHivesMessage =>
      'Karantinaya alınacak aktif kovan bulunamadı.';

  @override
  String quarantineDone(String number) {
    return 'Kovan $number karantinada';
  }

  @override
  String get hiveQuarantined => 'Karantinada';

  @override
  String hiveQuarantineDisease(String disease) {
    return 'Şüphe: $disease';
  }

  @override
  String hiveQuarantineSince(String date) {
    return '$date tarihinden beri';
  }

  @override
  String get hiveQuarantineWarning =>
      'Ekipmanını, çerçevelerini ve balını başka kovanlarla paylaşma.';

  @override
  String get hiveQuarantineEnd => 'Karantinadan çıkar';

  @override
  String hiveQuarantineEnded(String number) {
    return 'Kovan $number karantinadan çıktı';
  }

  @override
  String get calculatorSyrup => 'Şurup';

  @override
  String get calculatorSyrupSubtitle => 'Şeker ve su miktarı';

  @override
  String get calculatorDose => 'İlaç dozu';

  @override
  String get calculatorDoseSubtitle => 'Kovan sayısına göre toplam';

  @override
  String get calculatorQueen => 'Ana takvimi';

  @override
  String get calculatorQueenSubtitle => 'Aktarma gününden adımların günleri';

  @override
  String get calculatorYield => 'Verim';

  @override
  String get calculatorYieldSubtitle => 'Kovan başına bal';

  @override
  String get calculatorOffline => 'Hesaplar internetsiz çalışır, kayıt yazmaz.';

  @override
  String get calculatorNotFound => 'Hesaplayıcı bulunamadı';

  @override
  String get calculatorHives => 'Kovan sayısı';

  @override
  String get calculatorSyrupKind => 'Şurup türü';

  @override
  String get calculatorFillHint => 'Kovan sayısını ve miktarı yaz.';

  @override
  String get calculatorDosePerHive => 'Kovan başına doz';

  @override
  String get calculatorDoseUnit => 'Birim';

  @override
  String get calculatorTotal => 'Toplam';

  @override
  String calculatorDoseTotal(String unit, String total) {
    String _temp0 = intl.Intl.selectLogic(unit, {
      'strip': '$total şerit',
      'ml': '$total ml',
      'g': '$total g',
      'other': '$total doz',
    });
    return '$_temp0';
  }

  @override
  String calculatorDoseCount(int count, String amount) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count kovan × $amount',
    );
    return '$_temp0';
  }

  @override
  String calculatorYieldTotal(String unit) {
    return 'Toplam bal ($unit)';
  }

  @override
  String get calculatorYieldPerHive => 'Kovan başına';

  @override
  String calculatorYieldValue(String amount, String unit) {
    return '$amount $unit';
  }

  @override
  String get calculatorQueenSteps => 'Adımlar';

  @override
  String get hiveLossWintering => 'Kışlama';

  @override
  String get hiveLossQueenless => 'Anasızlık';

  @override
  String get hiveLossVarroa => 'Varroa';

  @override
  String get hiveLossDisease => 'Hastalık';

  @override
  String get hiveLossStarvation => 'Açlık';

  @override
  String get hiveLossRobbing => 'Yağma';

  @override
  String get hiveLossPredator => 'Ayı / hayvan';

  @override
  String get hiveLossPoisoning => 'Zehirlenme';

  @override
  String get hiveLossOther => 'Diğer';

  @override
  String get hiveLossUnspecified => 'Belirtilmemiş';

  @override
  String hiveLossReasonTitle(String number) {
    return '$number numaralı kovan neden kaybedildi?';
  }

  @override
  String get hiveLossSkip => 'Belirtmeden geç';

  @override
  String get hiveFormLossReason => 'Kayıp nedeni';

  @override
  String get hiveFormLossReasonHelper =>
      'Sezon raporunda kullanılır; boş bırakılabilir.';

  @override
  String get seasonReportTile => 'Sezon raporu';

  @override
  String seasonTitle(String year) {
    return 'Sezon $year';
  }

  @override
  String get seasonPdf => 'PDF';

  @override
  String get seasonExportCsv => 'Excel\'e aktar (CSV)';

  @override
  String get seasonExportError => 'Dosya oluşturulamadı. Yeniden dene.';

  @override
  String get seasonLoadError => 'Sezon raporu yüklenemedi.';

  @override
  String get seasonHives => 'Kovan';

  @override
  String seasonHiveChange(int start, int end) {
    return '$start → $end';
  }

  @override
  String seasonNetGain(int count) {
    return '+$count net';
  }

  @override
  String seasonNetLoss(int count) {
    return '−$count net';
  }

  @override
  String get seasonNetSame => 'Değişmedi';

  @override
  String get seasonWinterLoss => 'Kış kaybı';

  @override
  String get seasonWinterNotStarted => 'Kış henüz başlamadı';

  @override
  String seasonPreviousWinter(String year) {
    return '$year kış kaybı';
  }

  @override
  String seasonPreviousWinterRate(String year, String rate) {
    return '$year: $rate';
  }

  @override
  String get seasonHoney => 'Toplam bal';

  @override
  String get seasonNewQueens => 'Yeni ana';

  @override
  String seasonOwnReared(int count) {
    return 'kendi üretim $count';
  }

  @override
  String get seasonLossesTitle => 'Kayıplar ve nedenleri';

  @override
  String get seasonNoLosses => 'Bu sezon kovan kaybı yok.';

  @override
  String seasonHiveCount(int count) {
    return '$count kovan';
  }

  @override
  String get seasonByTreatment => 'Kış kaybı · mücadele yöntemine göre';

  @override
  String get seasonByApiary => 'Kış kaybı · arılığa göre';

  @override
  String get seasonByQueenLine => 'Kış kaybı · ana hattına göre';

  @override
  String get seasonTabTreatment => 'Mücadele';

  @override
  String get seasonTabApiary => 'Arılık';

  @override
  String get seasonTabQueenLine => 'Ana hattı';

  @override
  String get seasonNoWinterData => 'Kayıtlarında henüz kışa giren kovan yok.';

  @override
  String get seasonFewData => 'az veri';

  @override
  String get seasonMisleadingNote =>
      'Kendi kayıtlarından; az kovanda yanıltıcı olabilir.';

  @override
  String get seasonUntreated => 'İlaçlanmadı';

  @override
  String get seasonMethodSeparator => ' + ';

  @override
  String get seasonQueenLineUnknown => 'Hattı bilinmiyor';

  @override
  String get seasonFinanceTitle => 'Maliyet ve kâr';

  @override
  String get seasonProfit => 'Kâr';

  @override
  String get seasonPdfFigure => 'Gösterge';

  @override
  String get seasonPdfValue => 'Değer';

  @override
  String seasonPdfHiveChange(int start, int end, String net) {
    return '$start → $end ($net)';
  }

  @override
  String seasonPdfNewQueens(int count, int own) {
    return '$count (kendi üretim $own)';
  }

  @override
  String seasonPdfWinterLoss(String rate, int lost, int hives) {
    return '$rate ($hives kovandan $lost)';
  }

  @override
  String get seasonPdfReason => 'Neden';

  @override
  String get seasonPdfHives => 'Kovan';

  @override
  String get seasonPdfLost => 'Kayıp';

  @override
  String get seasonPdfRate => 'Oran';

  @override
  String get seasonPdfGroup => 'Grup';

  @override
  String get seasonPdfTotal => 'Toplam';

  @override
  String get seasonCsvHive => 'Kovan';

  @override
  String get seasonCsvApiary => 'Arılık';

  @override
  String get seasonCsvStartStatus => 'Sezon başı durum';

  @override
  String get seasonCsvEndStatus => 'Sezon sonu durum';

  @override
  String get seasonCsvLossDate => 'Kayıp günü';

  @override
  String get seasonCsvLossReason => 'Kayıp nedeni';

  @override
  String get seasonCsvInWinter => 'Kışa girdi';

  @override
  String get seasonCsvLostInWinter => 'Kışta kaybedildi';

  @override
  String get seasonCsvWinterApiary => 'Kış arılığı';

  @override
  String get seasonCsvTreatment => 'Kış öncesi mücadele';

  @override
  String get seasonCsvQueenLine => 'Ana hattı';

  @override
  String get seasonCsvAddedInSeason => 'Sezonda eklendi';

  @override
  String get seasonCsvYes => 'Evet';

  @override
  String get seasonCsvNo => 'Hayır';

  @override
  String get offlineMapsTitle => 'Offline haritalar';

  @override
  String get offlineMapsIntro =>
      'Arılıklarının çevresini indir; çekmeyen yerde de harita açılır.';

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
    return 'İndirildi · $size';
  }

  @override
  String offlineMapsDownloadingWifi(String received, String total) {
    return 'Wi‑Fi ile indiriliyor · $received / $total';
  }

  @override
  String offlineMapsDownloading(String received, String total) {
    return 'İndiriliyor · $received / $total';
  }

  @override
  String offlineMapsDownload(String name) {
    return '$name indir';
  }

  @override
  String get offlineMapsCancel => 'İndirmeyi durdur';

  @override
  String offlineMapsDelete(String name) {
    return '$name sil';
  }

  @override
  String offlineMapsDeleteTitle(String name) {
    return '$name silinsin mi?';
  }

  @override
  String get offlineMapsDeleteMessage =>
      'İnternet yokken bu arılığın çevresinin haritası açılmaz. İstediğinde yeniden indirebilirsin.';

  @override
  String get offlineMapsDeleteConfirm => 'Sil';

  @override
  String get offlineMapsWifiOnly => 'Sadece Wi‑Fi\'da indir';

  @override
  String get offlineMapsWifiOnlyHint =>
      'Her arılık birkaç MB; mobil veri harcanmaz.';

  @override
  String offlineMapsStop(String name) {
    return '$name durağı';
  }

  @override
  String offlineMapsDone(String name) {
    return '$name çevresi indirildi';
  }

  @override
  String offlineMapsFailed(String name) {
    return '$name çevresi indirilemedi. Bağlantını kontrol edip yeniden dene.';
  }

  @override
  String get offlineMapsNeedsWifi =>
      'Wi‑Fi\'a bağlan ya da \"Sadece Wi‑Fi\'da indir\"i kapat.';

  @override
  String get offlineMapsAttribution =>
      'Harita verisi © OpenStreetMap katkıcıları · OpenFreeMap';

  @override
  String get settingsOfflineMaps => 'Offline haritalar';

  @override
  String settingsOfflineMapsValue(int count, String size) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count arılık · $size',
      zero: 'Yok',
    );
    return '$_temp0';
  }

  @override
  String get offlineMapsCoverage =>
      'Her arılığın 6 km çevresi ayrıntılı, 40 km çevresi genel görünümle iner.';

  @override
  String offlineMapsDownloadedOn(String date) {
    return 'indirildi: $date';
  }

  @override
  String get offlineMapsToDownload => 'İndirilecek arılıklar';

  @override
  String get offlineMapsMoved => 'Arılık taşındı, yeniden indir';

  @override
  String get offlineMapsNoApiaries =>
      'Konumu kayıtlı arılık yok. Arılığa konum ekleyince burada çıkar.';

  @override
  String get offlineMapsAllDownloaded =>
      'Konumlu bütün arılıkların çevresi indirildi.';

  @override
  String get syncReminderTitle => 'Kayıtların henüz yedeklenmedi';

  @override
  String syncReminderBody(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other:
          '$count kayıt 3 gündür sunucuya gönderilemedi. İnternete bağlanınca uygulamayı aç.',
    );
    return '$_temp0';
  }

  @override
  String get syncOverdueTitle => '3 günden uzun süredir yedeklenmedi';

  @override
  String syncOverdueMessage(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other:
          '$count kayıt yalnız bu telefonda. Telefon kaybolursa bunlar da kaybolur. İnternete bağlanıp eşitle.',
    );
    return '$_temp0';
  }

  @override
  String syncDaysAgo(int days) {
    String _temp0 = intl.Intl.pluralLogic(
      days,
      locale: localeName,
      other: '$days gün önce',
      one: 'dün',
      zero: 'bugün',
    );
    return '$_temp0';
  }

  @override
  String syncLastSyncedAgo(String ago, String when) {
    return 'Son eşitleme $ago · $when';
  }

  @override
  String syncPendingTitle(int count) {
    return 'Gönderilmeyi bekleyen · $count';
  }

  @override
  String settingsSignOutPendingMessage(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other:
          '$count kayıt henüz sunucuya gönderilmedi ve yalnız bu telefonda. Çıkış yaparsan gönderilmezler. Önce internete bağlanıp eşitle.',
    );
    return '$_temp0';
  }

  @override
  String get settingsSignOutAnyway => 'Yine de çıkış yap';

  @override
  String get settingsExport => 'Verileri dışa aktar';

  @override
  String get settingsExportValue => 'Excel';

  @override
  String get settingsExportHint =>
      'Tüm kayıtların tek Excel dosyasında; istediğin yere gönder ya da kaydet.';

  @override
  String get exportPreparing => 'Hazırlanıyor…';

  @override
  String get exportFailed => 'Dosya hazırlanamadı. Yeniden dene.';

  @override
  String exportFileName(String date) {
    return 'Mobil Arıcı $date';
  }

  @override
  String get exportYes => 'Evet';

  @override
  String get exportNo => 'Hayır';

  @override
  String get exportSheetApiaries => 'Arılıklar';

  @override
  String get exportSheetHives => 'Kovanlar';

  @override
  String get exportSheetQueens => 'Ana arılar';

  @override
  String get exportSheetInspections => 'Muayeneler';

  @override
  String get exportSheetFeedings => 'Beslemeler';

  @override
  String get exportSheetTreatments => 'İlaçlamalar';

  @override
  String get exportSheetMiteCounts => 'Varroa ölçümleri';

  @override
  String get exportSheetHarvests => 'Hasatlar';

  @override
  String get exportSheetTasks => 'Görevler';

  @override
  String get exportSheetInventory => 'Stok';

  @override
  String get exportSheetFinance => 'Gelir ve gider';

  @override
  String get exportColName => 'Ad';

  @override
  String get exportColLatitude => 'Enlem';

  @override
  String get exportColLongitude => 'Boylam';

  @override
  String get exportColAltitude => 'Rakım (m)';

  @override
  String get exportColLandowner => 'Arazi sahibi';

  @override
  String get exportColLandownerPhone => 'Arazi sahibinin telefonu';

  @override
  String get exportColWaterSource => 'Su kaynağı';

  @override
  String get exportColVehicleDistance => 'Araca uzaklık (m)';

  @override
  String get exportColRoadNotes => 'Yol notu';

  @override
  String get exportColNotes => 'Not';

  @override
  String get exportColActiveHives => 'Aktif kovan';

  @override
  String get exportColCreated => 'Eklenme';

  @override
  String get exportColApiary => 'Arılık';

  @override
  String get exportColHive => 'Kovan';

  @override
  String get exportColType => 'Tür';

  @override
  String get exportColStatus => 'Durum';

  @override
  String get exportColBoxes => 'Kutu sayısı';

  @override
  String get exportColFrames => 'Çerçeve sayısı';

  @override
  String get exportColSource => 'Kaynak';

  @override
  String get exportColMarking => 'İşaret';

  @override
  String get exportColTag => 'Etiket kodu';

  @override
  String get exportColQuarantine => 'Karantina';

  @override
  String get exportColQueen => 'Ana arı';

  @override
  String get exportColYear => 'Yıl';

  @override
  String get exportColColor => 'İşaret rengi';

  @override
  String get exportColBreed => 'Irk';

  @override
  String get exportColLine => 'Hat';

  @override
  String get exportColWingClipped => 'Kanat kesik';

  @override
  String get exportColDate => 'Tarih';

  @override
  String get exportColQueenState => 'Ana durumu';

  @override
  String get exportColBeeFrames => 'Arılı çerçeve';

  @override
  String get exportColBroodFrames => 'Yavrulu çerçeve';

  @override
  String get exportColHoneyFrames => 'Ballı çerçeve';

  @override
  String get exportColTemperament => 'Huy';

  @override
  String get exportColSwarmSigns => 'Oğul belirtisi';

  @override
  String get exportColQueenCells => 'Ana memesi';

  @override
  String get exportColDisease => 'Hastalık şüphesi';

  @override
  String get exportColActions => 'Yapılanlar';

  @override
  String get exportColAmount => 'Miktar';

  @override
  String get exportColUnit => 'Birim';

  @override
  String get exportColProduct => 'Ürün';

  @override
  String get exportColActiveIngredient => 'Etken madde';

  @override
  String get exportColDose => 'Doz';

  @override
  String get exportColWithdrawal => 'Bekleme süresi (gün)';

  @override
  String get exportColBatch => 'Parti no';

  @override
  String get exportColPlannedRemoval => 'Planlanan çıkarma';

  @override
  String get exportColMethod => 'Yöntem';

  @override
  String get exportColMites => 'Akar';

  @override
  String get exportColSampleBees => 'Örnek arı';

  @override
  String get exportColDays => 'Gün';

  @override
  String get exportColResult => 'Sonuç';

  @override
  String get exportColHoneyKind => 'Bal türü';

  @override
  String get exportColUnitCount => 'Adet';

  @override
  String get exportColNetKg => 'Net (kg)';

  @override
  String get exportColHiveCount => 'Kovan sayısı';

  @override
  String get exportColDue => 'Son tarih';

  @override
  String get exportColTitle => 'Başlık';

  @override
  String get exportColCompleted => 'Tamamlandı';

  @override
  String get exportColCategory => 'Kategori';

  @override
  String get exportColPlace => 'Yer';

  @override
  String get exportColStock => 'Mevcut';

  @override
  String get exportColThreshold => 'Uyarı eşiği';

  @override
  String get exportColCurrency => 'Para birimi';

  @override
  String get exportColDescription => 'Açıklama';

  @override
  String get businessTitle => 'İşletme';

  @override
  String get businessEdit => 'Düzenle';

  @override
  String get businessEditTitle => 'İşletmeyi düzenle';

  @override
  String get businessCancel => 'İptal';

  @override
  String get businessSave => 'Kaydet';

  @override
  String get businessSaveError =>
      'Kaydedilemedi; işletme bu telefonda henüz yok.';

  @override
  String get businessMissingTitle => 'İşletme bilgisi yok';

  @override
  String get businessMissingMessage =>
      'İşletme bu telefona indiğinde burada görünür.';

  @override
  String businessPersonRole(String person, String role) {
    return '$person · $role';
  }

  @override
  String get businessDetailSeparator => ' · ';

  @override
  String businessRegionBadge(String country, String profile) {
    return '$country · $profile';
  }

  @override
  String get businessRegionTr => 'TR profili';

  @override
  String get businessRegionOther => 'Genel profil';

  @override
  String get businessPendingSync => 'Eşitlenecek';

  @override
  String businessCountHives(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'kovan',
    );
    return '$_temp0';
  }

  @override
  String businessCountApiaries(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'arılık',
    );
    return '$_temp0';
  }

  @override
  String businessCountInspections(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'muayene',
    );
    return '$_temp0';
  }

  @override
  String get businessSectionBusiness => 'İşletme';

  @override
  String get businessSectionAccount => 'Hesap';

  @override
  String get businessType => 'Tür';

  @override
  String get businessTypeMigratory => 'Gezginci';

  @override
  String get businessTypeStationary => 'Sabit';

  @override
  String get businessTypeHelp =>
      'Sabitte göç planı ve taşıma gizlenir; kayıtlar silinmez.';

  @override
  String get businessCurrency => 'Para birimi';

  @override
  String businessCurrencyValue(String symbol, String code) {
    return '$symbol $code';
  }

  @override
  String get businessCurrencyNote =>
      'Geçmiş kayıtlar dönüştürülmez; yeni para birimi yalnız bundan sonraki kayıtlara uygulanır.';

  @override
  String businessTeamTitle(int count) {
    return 'Ekip · $count kişi';
  }

  @override
  String get businessTeamSolo => 'Henüz ekip üyesi yok';

  @override
  String businessRoleCountOwner(int count) {
    return '$count sahip';
  }

  @override
  String businessRoleCountPartner(int count) {
    return '$count ortak';
  }

  @override
  String businessRoleCountWorker(int count) {
    return '$count işçi';
  }

  @override
  String businessRoleCountViewer(int count) {
    return '$count danışman';
  }

  @override
  String get businessEmail => 'Giriş e-postası';

  @override
  String get businessEmailSoon => 'E-postayı değiştirme yakında gelecek.';

  @override
  String get businessFirstRecord => 'İlk kayıt';

  @override
  String businessFirstRecordValue(String date, int season) {
    return '$date · $season. sezon';
  }

  @override
  String get businessSettingsShortcut => 'Dil, birim, tema ve veri ayarları';

  @override
  String get businessNameLabel => 'İşletme adı';

  @override
  String get businessFullNameLabel => 'Ad soyad';

  @override
  String get businessFullNameHelp => 'Ekipte bu adla görünürsün.';

  @override
  String get businessAvatarLabel => 'Avatar';

  @override
  String get businessAvatarHelp =>
      'Logo yoksa baş harfler seçtiğin renkte görünür.';

  @override
  String get businessAvatarPine => 'Çam';

  @override
  String get businessAvatarHoney => 'Bal';

  @override
  String get businessAvatarSky => 'Gök';

  @override
  String get businessAvatarSlate => 'Arduvaz';

  @override
  String get businessLogoUpload => 'Logo yükle';

  @override
  String get businessLogoRemove => 'Logoyu kaldır';

  @override
  String get businessDiscardTitle => 'Değişiklikler atılsın mı?';

  @override
  String get businessDiscardMessage =>
      'Kaydetmediğin değişiklikler kaybolacak.';

  @override
  String get businessDiscardAction => 'At';

  @override
  String get businessTypeConfirmTitle => 'Sabit işletmeye geçilsin mi?';

  @override
  String businessTypeConfirmMessage(int plans, int stops) {
    return '$plans göç planı ve $stops durak kaydı gizlenecek. Kayıtlar silinmez, geri alabilirsin.';
  }

  @override
  String get businessTypeConfirmAction => 'Sabite geç';

  @override
  String get businessReadOnly =>
      'İşletme bilgilerini yalnız sahip ve ortak değiştirebilir.';

  @override
  String get financeOtherCurrencies => 'Diğer para birimleri';

  @override
  String financeOtherCurrencyLine(String currency, String amount) {
    return '$currency · net $amount';
  }

  @override
  String get migratoryHiddenTitle => 'Gezginci modülü kapalı';

  @override
  String get migratoryHiddenMessage =>
      'İşletme türü sabit. Göç planların ve taşımaların silinmedi; türü Gezginci yaparsan geri gelir.';

  @override
  String get onboardingMigratoryTitle => 'Gezginci arıcılık yapıyor musun?';

  @override
  String get onboardingMigratoryMessage =>
      'Sabitse göç planı ve taşıma gizlenir; İşletme profilinden değiştirebilirsin.';

  @override
  String get onboardingMigratoryYes => 'Evet';

  @override
  String get onboardingMigratoryNo => 'Hayır, sabit';

  @override
  String get settingsDeleteAccount => 'Hesabımı sil';

  @override
  String get settingsDeleteAccountOffline =>
      'Hesabı silmek için internet gerekiyor; bağlanınca yeniden dene.';

  @override
  String get deletionTitle => 'Hesabımı sil';

  @override
  String deletionStepCounter(int current, int total) {
    return 'Adım $current/$total';
  }

  @override
  String get deletionContinue => 'Devam';

  @override
  String get deletionSoloTitle => 'Hesabın ve işletmen silinecek';

  @override
  String deletionSoloMessage(String organization) {
    return '$organization işletmesinde tek kişi sensin. Hesabınla birlikte işletme ve tüm kayıtları da silinir.';
  }

  @override
  String get deletionCountsLabel => 'Silinecek kayıtlar';

  @override
  String get deletionCountHives => 'Kovan';

  @override
  String get deletionCountApiaries => 'Arılık';

  @override
  String get deletionCountInspections => 'Muayene';

  @override
  String get deletionCountHarvests => 'Hasat';

  @override
  String get deletionCountDocuments => 'Belge';

  @override
  String get deletionCountPhotos => 'Fotoğraf';

  @override
  String get deletionLotWarningTitle => 'QR kodları çalışmayacak.';

  @override
  String deletionLotWarningMessage(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other:
          '$count herkese açık lot sayfası silinecek, kavanozlardaki QR kodları çalışmayacak.',
    );
    return '$_temp0';
  }

  @override
  String get deletionTeamTitle => 'Ekibin var: işletme için bir seçim yap';

  @override
  String deletionTeamMessage(int count, String organization) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other:
          '$organization işletmesinin sahibisin; ekipte $count kişi daha var.',
    );
    return '$_temp0';
  }

  @override
  String get deletionChoiceTransfer => 'Sahipliği devret ve ayrıl';

  @override
  String get deletionChoiceTransferHint =>
      'İşletme ve kayıtları kalır. Seçtiğin ortak yeni sahip olur; yalnız senin hesabın silinir.';

  @override
  String get deletionChoiceDelete => 'İşletmeyi ve tüm kayıtları sil';

  @override
  String deletionChoiceDeleteHint(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Ekipteki $count kişi de işletmeye erişemez.',
    );
    return '$_temp0';
  }

  @override
  String get deletionTransferPick => 'Yeni sahip';

  @override
  String get deletionTransferNoPartner =>
      'Devretmek için ekipte bir ortak olmalı. Ekip ekranından bir üyeyi ortak yapabilir ya da işletmeyi silebilirsin.';

  @override
  String get deletionPartnerFallbackName => 'Ortak';

  @override
  String get deletionMemberTitle => 'Yalnız hesabın silinecek';

  @override
  String deletionMemberMessage(String organization) {
    return '$organization işletmesi ve kayıtları silinmez. Girdiğin kayıtlar işletmede kalır; adın ekip listesinden kaldırılır.';
  }

  @override
  String get deletionUnknownMessage =>
      'Üyelik bilgin bu telefona henüz inmedi. Eşitleme bitince yeniden dene.';

  @override
  String get deletionGraceNote =>
      'Silme 7 gün sonra kesinleşir; bu sürede giriş yapıp vazgeçebilirsin.';

  @override
  String get deletionBackupTitle => 'Önce verini al';

  @override
  String get deletionBackupMessage =>
      'Silinen kayıtlar geri getirilemez. Silmeden önce bir kopyasını almanı öneririz.';

  @override
  String get deletionBackupReports => 'PDF raporları';

  @override
  String get deletionBackupReportsHint => 'Hazır raporları PDF olarak indir.';

  @override
  String get deletionBackupJson => 'Tüm kayıtlar';

  @override
  String get deletionBackupJsonValue => 'JSON';

  @override
  String get deletionBackupJsonHint =>
      'Bütün kayıtların tek dosyada; istediğin yere kaydet.';

  @override
  String get deletionBackupSaved => 'Kaydedildi';

  @override
  String get deletionBackupDownload => 'Kayıtlarımı indir';

  @override
  String get deletionBackupSkip => 'Atla';

  @override
  String deletionBackupFileName(String date) {
    return 'mobil-arici-kayitlar-$date';
  }

  @override
  String get deletionVerifyTitle => 'Kimliğini doğrula';

  @override
  String get deletionVerifyButton => 'Kodu doğrula';

  @override
  String get deletionConfirmTitle => 'Son onay';

  @override
  String get deletionConfirmIntro => 'Onaylarsan:';

  @override
  String deletionConsequenceAccount(String date) {
    return 'Hesabın $date tarihinde kalıcı olarak silinir.';
  }

  @override
  String deletionConsequenceOrganization(String organization) {
    return '$organization işletmesi ve tüm kayıtları da silinir.';
  }

  @override
  String deletionConsequenceTransfer(String name, String organization) {
    return '$name, $organization işletmesinin yeni sahibi olur.';
  }

  @override
  String get deletionConsequenceRecordsStay => 'İşletmenin kayıtları silinmez.';

  @override
  String deletionConsequenceLots(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count lot sayfası kapanır; QR kodları çalışmaz.',
    );
    return '$_temp0';
  }

  @override
  String get deletionConsequenceSignOut =>
      'Oturumun kapanır ve bu telefondaki veriler silinir.';

  @override
  String get deletionConsequenceCancel =>
      'Bu tarihe kadar giriş yaparsan silmeyi iptal edebilirsin.';

  @override
  String deletionConfirmTypeName(String organization) {
    return 'Onaylamak için işletmenin adını yaz: $organization';
  }

  @override
  String deletionConfirmTypeKeyword(String keyword) {
    return 'Onaylamak için $keyword yaz';
  }

  @override
  String get deletionKeyword => 'SİL';

  @override
  String get deletionConfirmButton => 'Hesabımı sil';

  @override
  String get deletionConfirmButtonWithOrganization =>
      'Hesabımı ve işletmemi sil';

  @override
  String get deletionSubmitting => 'Gönderiliyor…';

  @override
  String get deletionFailureNetwork =>
      'Sunucuya ulaşılamadı. Bağlantını kontrol edip yeniden dene.';

  @override
  String get deletionFailureOwnerMustTransfer =>
      'Ekipli başka bir işletmenin de sahibisin. Önce oradaki sahipliği devret.';

  @override
  String get deletionFailureInvalidTransfer =>
      'Seçtiğin kişi artık ortak değil. Başka bir ortak seç.';

  @override
  String get deletionFailureRateLimited =>
      'Kısa sürede çok fazla deneme oldu. Yarın yeniden dene.';

  @override
  String get deletionFailureForbidden =>
      'Oturumun kapanmış. Yeniden giriş yapıp dene.';

  @override
  String get deletionFailureCodeRequired =>
      'Doğrulamanın süresi doldu. Yeni kod alıp yeniden doğrula.';

  @override
  String get deletionFailureUnknown =>
      'Talep gönderilemedi. Biraz sonra yeniden dene.';

  @override
  String get deletionDoneTitle => 'Silme talebin alındı';

  @override
  String deletionDoneDate(String date) {
    return 'Hesabın $date tarihinde kalıcı olarak silinecek.';
  }

  @override
  String get deletionDoneCancelHint =>
      'Fikrini değiştirirsen bu tarihe kadar giriş yap; silme iptal olur.';

  @override
  String get deletionDoneEmail => 'Ayrıntıları e-postana da gönderdik.';

  @override
  String get deletionDoneClearing => 'Bu telefondaki veriler siliniyor…';

  @override
  String get deletionDoneSignedOut =>
      'Oturumun kapatıldı ve bu telefondaki verilerin silindi.';

  @override
  String get deletionDoneAction => 'Tamam';

  @override
  String get deletionPendingTitle => 'Hesabın silinmek üzere';

  @override
  String deletionPendingMessage(String date) {
    return 'Hesabın $date tarihinde silinecek. Devam edersen silme iptal olur.';
  }

  @override
  String get deletionPendingContinue => 'Devam et, hesabımı koru';

  @override
  String get deletionPendingSignOut => 'Çıkış yap, silme sürsün';

  @override
  String get deletionPendingCancelled =>
      'Silme iptal edildi. Tekrar hoş geldin!';

  @override
  String get deletionPendingCancelFailed =>
      'Silme iptal edilemedi. Bağlantını kontrol edip yeniden dene.';

  @override
  String teamMemberLeaving(String date) {
    return 'Hesabını siliyor · $date';
  }

  @override
  String get teamErrorMemberLeaving =>
      'Bu kişi hesabını siliyor; bekleme süresinde rolü değiştirilemez ve ekipten çıkarılamaz.';
}
