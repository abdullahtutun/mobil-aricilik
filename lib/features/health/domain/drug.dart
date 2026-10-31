import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:mobil_arici/core/db/server_enum.dart';
import 'package:mobil_arici/core/db/synced_record.dart';

part 'drug.freezed.dart';
part 'drug.g.dart';

/// İlacın etken maddesi (`public.drug_active_ingredient`).
@JsonEnum(valueField: 'value')
enum DrugActiveIngredient implements ServerEnum {
  amitraz('amitraz'),
  oxalicAcid('oxalic_acid'),
  formicAcid('formic_acid'),
  thymol('thymol'),
  flumethrin('flumethrin'),
  tauFluvalinate('tau_fluvalinate'),
  coumaphos('coumaphos'),
  lacticAcid('lactic_acid'),
  other('other');

  new(this.value);

  @override
  final String value;
}

/// Doz birimi (`public.drug_dose_unit`); doz kovan başınadır.
@JsonEnum(valueField: 'value')
enum DrugDoseUnit implements ServerEnum {
  strip('strip'),
  ml('ml'),
  g('g'),
  dose('dose');

  new(this.value);

  @override
  final String value;
}

/// Her bölgede görünen referans ilaçların ülke kodu.
const globalCountryCode = 'GLOBAL';

/// Referans ilaç (`ref_drugs`): ülke koduna (ya da [globalCountryCode])
/// göre etiketli, TR/EN adlı. Salt okunur; yalnız senkronla iner.
@freezed
abstract class RefDrug with _$RefDrug implements SyncedRecord {
  const factory({
    required String id,
    required String countryCode,
    required String nameTr,
    required String nameEn,
    required DrugActiveIngredient activeIngredient,
    required DrugDoseUnit doseUnit,
    required DateTime createdAt,
    required DateTime updatedAt,

    /// Etiketteki bal bekleme süresi; bilinmiyorsa boş.
    int? withdrawalDays,
    String? licenseNo,
    String? createdBy,
    DateTime? deletedAt,
    @JsonKey(includeToJson: false) int? serverSeq,
  }) = _RefDrug;

  factory fromJson(Map<String, Object?> json) => _$RefDrugFromJson(json);
}

/// İşletmenin eklediği ilaç (`drugs`). Durum kaydı: son yazan kazanır.
@freezed
abstract class Drug with _$Drug implements SyncedRecord {
  const factory({
    required String id,
    required String orgId,
    required String name,
    required DrugActiveIngredient activeIngredient,
    required DrugDoseUnit doseUnit,
    required DateTime createdAt,
    required DateTime updatedAt,
    int? withdrawalDays,
    String? licenseNo,
    String? createdBy,
    DateTime? deletedAt,
    @JsonKey(includeToJson: false) int? serverSeq,
  }) = _Drug;

  factory fromJson(Map<String, Object?> json) => _$DrugFromJson(json);
}

/// Formda seçilebilen ilaç: referans listeden (`refDrugId`) ya da
/// işletmenin listesinden (`drugId`). Ad seçildiği dilde.
@freezed
abstract class DrugChoice with _$DrugChoice {
  const factory({
    required String name,
    required DrugActiveIngredient activeIngredient,
    required DrugDoseUnit doseUnit,
    String? refDrugId,
    String? drugId,
    int? withdrawalDays,
    String? licenseNo,

    /// Ürün bilgisindeki kovan başı doz; seçilince forma yazılır.
    int? defaultDose,

    /// Ürün bilgisindeki kovanda kalma süresi (gün); planlanan çıkarma
    /// buna göre önerilir.
    int? treatmentDays,
  }) = _DrugChoice;
}
