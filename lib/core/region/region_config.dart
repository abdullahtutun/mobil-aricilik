import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:mobil_aricilik/core/region/country_currencies.dart';
import 'package:mobil_aricilik/core/utils/units.dart';

part 'region_config.freezed.dart';

/// TR profilini açan tek ülke kodu.
const turkeyCountryCode = 'TR';

/// Bölge profili. Türkiye'ye özel modüller yalnızca `tr` profilinde açılır;
/// ileride ülke ülke genişletilebilir.
enum RegionProfile { tr, other }

/// Yarımküre. Mevsim şablonları Güney'de yaklaşık 6 ay kayar.
enum Hemisphere {
  northern,
  southern;

  /// Ekvator (0°) Kuzey sayılır. Enlem -90 ile 90 arasında değilse
  /// [ArgumentError] atar.
  static Hemisphere fromLatitude(double latitude) {
    checkLatitude(latitude);
    return latitude < 0 ? southern : northern;
  }
}

/// Türkiye'ye özel modüllerin bayrakları. Kapalı modülün verisi silinmez;
/// ülke sonradan değişirse kayıtlar yeniden görünür.
@freezed
abstract class RegionFeatures with _$RegionFeatures {
  const factory({
    /// AKS, işletme tescil no ve birlik üyeliği. Kapalıyken yerine serbest
    /// "kayıt numarası" alanı gelir.
    @Default(false) bool aks,

    /// Arılı kovan desteği ve destek hatırlatıcıları.
    @Default(false) bool subsidies,

    /// TR mevzuat kütüphanesi.
    @Default(false) bool regulations,

    /// TR'de ruhsatlı ilaç listesi. Kapalıyken etken madde bazlı genel liste.
    @Default(false) bool trDrugList,

    /// TR bölgelerinin hazır flora takvimi. Kapalıyken takvim boş başlar.
    @Default(false) bool trFlora,

    /// TR gezginci belge türleri (nakil evrakı, sağlık raporu vb.). Kapalıyken
    /// belge türlerini kullanıcı tanımlar.
    @Default(false) bool trMigrationDocs,
  }) = _RegionFeatures;
}

/// Bölgenin varsayılan ölçü birimleri; boş hâli metrik.
@freezed
abstract class DefaultUnits with _$DefaultUnits {
  const factory({
    @Default(MassUnit.kilogram) MassUnit mass,
    @Default(TemperatureUnit.celsius) TemperatureUnit temperature,
    @Default(VolumeUnit.liter) VolumeUnit volume,
  }) = _DefaultUnits;
}

/// Bölgeye bağlı tüm kararlar. Ekranlar ülke kodunu doğrudan kontrol etmez;
/// bunu `regionConfigProvider` üzerinden okur ve `features` ile karar verir.
@freezed
abstract class RegionConfig with _$RegionConfig {
  const factory({
    /// ISO 3166-1 alpha-2, büyük harf. Referans verinin ülke etiketi için;
    /// ekran kararları bundan değil `features`'tan verilir.
    required String countryCode,
    required RegionProfile profile,
    required RegionFeatures features,

    /// ISO 4217 (ör. `TRY`).
    required String currencyCode,
    required DefaultUnits defaultUnits,
    required Hemisphere hemisphere,
  }) = _RegionConfig;
}

/// ABD ölçüleri (lb, °F, galon) varsayılan olan ülkeler.
const _usCustomaryCountries = {
  'US', 'PR', 'GU', 'VI', 'AS', 'MP', 'UM', // ABD ve bağlı bölgeleri
  'PW', 'FM', 'MH', // ABD ile serbest ortaklıktaki ada devletleri
  'LR', // Liberya
};

/// Kütle ve hacimde metrik, sıcaklıkta Fahrenheit kullanan ülkeler.
const _fahrenheitOnlyCountries = {'BS', 'BZ', 'KY'};

final _countryCodePattern = RegExp(r'^[A-Z]{2}$');

/// Ülke kodunu büyük harf ISO 3166-1 alpha-2 biçimine getirir (` tr ` →
/// `TR`). İki harf değilse [ArgumentError] atar. Biçimi doğru ama tabloda
/// olmayan kodlar kabul edilir.
String normalizeCountryCode(String countryCode) {
  final code = countryCode.trim().toUpperCase();
  if (!_countryCodePattern.hasMatch(code)) {
    throw ArgumentError.value(
      countryCode,
      'countryCode',
      'İki harfli ISO 3166-1 kodu olmalı (ör. TR)',
    );
  }
  return code;
}

/// Enlem -90 ile 90 arasında değilse (NaN dahil) [ArgumentError] atar.
void checkLatitude(double latitude) {
  if (!(latitude >= -90 && latitude <= 90)) {
    throw ArgumentError.value(
      latitude,
      'latitude',
      '-90 ile 90 arasında olmalı',
    );
  }
}

/// [countryCode]'dan bölge yapılandırmasını üretir.
///
/// Yarımküre [latitude]'dan çıkar; enlem bilinmiyorsa Kuzey. TR tamamen
/// Kuzey'de olduğundan TR profilinde enlem yarımküreyi değiştirmez. Ülke kodu
/// geçersizse ya da enlem -90 ile 90 arasında değilse [ArgumentError] atar.
RegionConfig resolveRegionConfig(String countryCode, {double? latitude}) {
  final code = normalizeCountryCode(countryCode);
  if (latitude != null) checkLatitude(latitude);

  final profile = code == turkeyCountryCode
      ? RegionProfile.tr
      : RegionProfile.other;

  return RegionConfig(
    countryCode: code,
    profile: profile,
    features: switch (profile) {
      RegionProfile.tr => const RegionFeatures(
        aks: true,
        subsidies: true,
        regulations: true,
        trDrugList: true,
        trFlora: true,
        trMigrationDocs: true,
      ),
      RegionProfile.other => const RegionFeatures(),
    },
    currencyCode: currencyCodeFor(code),
    defaultUnits: _defaultUnitsFor(code),
    hemisphere: profile == RegionProfile.tr || latitude == null
        ? Hemisphere.northern
        : Hemisphere.fromLatitude(latitude),
  );
}

DefaultUnits _defaultUnitsFor(String countryCode) {
  if (_usCustomaryCountries.contains(countryCode)) {
    return const DefaultUnits(
      mass: MassUnit.pound,
      temperature: TemperatureUnit.fahrenheit,
      volume: VolumeUnit.gallon,
    );
  }
  if (_fahrenheitOnlyCountries.contains(countryCode)) {
    return const DefaultUnits(temperature: TemperatureUnit.fahrenheit);
  }
  return const DefaultUnits();
}
