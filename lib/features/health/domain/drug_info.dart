import 'package:freezed_annotation/freezed_annotation.dart';

part 'drug_info.freezed.dart';
part 'drug_info.g.dart';

/// Referans ilacın Bakanlık onaylı ürün bilgisi
/// (`assets/drugs/ilaclar.json`). Metinler kaynağındaki gibi Türkçe;
/// [refDrugId] ile `ref_drugs` satırına bağlı.
@freezed
abstract class DrugInfo with _$DrugInfo {
  const factory({
    required String refDrugId,
    @JsonKey(name: 'ilac_adi') required String name,
    @JsonKey(name: 'etken_madde') required String activeIngredient,
    @JsonKey(name: 'endikasyonlar') required String indications,

    /// Kullanım ve sıklık; anahtarlar ürüne göre değişir
    /// ([drugUsageItems] sıralar).
    @JsonKey(name: 'kullanimi_ve_sikligi') required Map<String, String> usage,
    @JsonKey(name: 'uygulandigi_donem') required DrugInfoPeriods periods,
    @JsonKey(name: 'kalinti_bilgisi_ikas') required DrugInfoResidue residue,
  }) = _DrugInfo;

  factory fromJson(Map<String, Object?> json) => _$DrugInfoFromJson(json);
}

/// Uygun ve kullanılmaması gereken dönemler.
@freezed
abstract class DrugInfoPeriods with _$DrugInfoPeriods {
  const factory({
    @JsonKey(name: 'uygun_donemler') @Default([]) List<String> suitable,
    @JsonKey(name: 'kullanilmamasi_gereken_donemler')
    @Default([])
    List<String> avoid,
  }) = _DrugInfoPeriods;

  factory fromJson(Map<String, Object?> json) =>
      _$DrugInfoPeriodsFromJson(json);
}

/// Kalıntı bilgisi: arınma süresi ve uyarılar.
@freezed
abstract class DrugInfoResidue with _$DrugInfoResidue {
  const factory({
    @JsonKey(name: 'arinma_suresi') required String withdrawal,
    @JsonKey(name: 'uyarilar') String? warnings,
  }) = _DrugInfoResidue;

  factory fromJson(Map<String, Object?> json) =>
      _$DrugInfoResidueFromJson(json);
}

/// Kullanım bilgisinin türü; ekranda başlığı buna göre yazılır.
enum DrugUsageKind {
  method('uygulama_sekli'),
  methodAndDose('uygulama_sekli_ve_dozaj'),
  diagnosis('teshis_amaciyla'),
  treatmentDose('tedavi_dozu'),
  dose('dozaj'),
  frequency('sikligi'),
  duration('uygulama_suresi'),

  /// Tanınmayan anahtar; listenin sonunda.
  other('');

  new(this.key);

  /// JSON'daki anahtar.
  final String key;
}

/// [usage] satırları [DrugUsageKind] sırasıyla; tanınmayan anahtarlar
/// [DrugUsageKind.other] olarak sonda, boş metinler atlanır.
List<(DrugUsageKind, String)> drugUsageItems(Map<String, String> usage) {
  final known = {
    for (final kind in DrugUsageKind.values)
      if (kind != DrugUsageKind.other) kind.key: kind,
  };
  return [
    for (final kind in DrugUsageKind.values)
      if (kind != DrugUsageKind.other && (usage[kind.key]?.trim() ?? '') != '')
        (kind, usage[kind.key]!.trim()),
    for (final MapEntry(:key, :value) in usage.entries)
      if (!known.containsKey(key) && value.trim().isNotEmpty)
        (DrugUsageKind.other, value.trim()),
  ];
}

/// Ürün bilgileri, `ref_drug_id`'ye göre. Aynı kimlik iki kez geçerse
/// ilki kalır.
Map<String, DrugInfo> parseDrugInfos(List<Object?> json) {
  final infos = <String, DrugInfo>{};
  for (final item in json) {
    final info = DrugInfo.fromJson(item! as Map<String, Object?>);
    infos.putIfAbsent(info.refDrugId, () => info);
  }
  return infos;
}
