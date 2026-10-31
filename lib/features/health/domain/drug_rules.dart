import 'package:mobil_arici/core/region/region_config.dart';
import 'package:mobil_arici/features/health/domain/drug.dart';
import 'package:mobil_arici/features/health/domain/drug_info.dart';

/// Referans ilacın [languageCode] dilindeki adıyla seçeneği; Türkçe
/// dışındaki dillerde İngilizce ad. [info] varsa doz ve kovanda kalma
/// süresi ondan gelir.
DrugChoice refDrugChoice(
  RefDrug drug, {
  required String languageCode,
  DrugInfo? info,
}) => DrugChoice(
  refDrugId: drug.id,
  name: languageCode == 'tr' ? drug.nameTr : drug.nameEn,
  activeIngredient: drug.activeIngredient,
  doseUnit: drug.doseUnit,
  withdrawalDays: drug.withdrawalDays,
  licenseNo: drug.licenseNo,
  defaultDose: info?.defaults?.dose,
  treatmentDays: info?.defaults?.treatmentDays,
);

/// İşletmenin eklediği ilacın seçeneği.
DrugChoice customDrugChoice(Drug drug) => DrugChoice(
  drugId: drug.id,
  name: drug.name,
  activeIngredient: drug.activeIngredient,
  doseUnit: drug.doseUnit,
  withdrawalDays: drug.withdrawalDays,
  licenseNo: drug.licenseNo,
);

/// Formdaki ilaç listesi: önce işletmenin eklediği ilaçlar, sonra
/// [trList] açıksa yalnız TR listesi (Bakanlık ürünleri), kapalıysa etken
/// madde bazlı GLOBAL liste; her grup kendi içinde ada göre. Başka ülkeye
/// etiketli referans ilaçlar (henüz bayrağı yok) ve silinmiş satırlar
/// görünmez. [infos] referans ilaçların ürün bilgisi.
List<DrugChoice> drugCatalog({
  required Iterable<RefDrug> refDrugs,
  required Iterable<Drug> drugs,
  required bool trList,
  required String languageCode,
  Map<String, DrugInfo> infos = const {},
}) {
  List<DrugChoice> sorted(Iterable<DrugChoice> choices) =>
      choices.toList()..sort((a, b) => a.name.compareTo(b.name));
  List<DrugChoice> reference(String countryCode) => sorted([
    for (final drug in refDrugs)
      if (drug.deletedAt == null && drug.countryCode == countryCode)
        refDrugChoice(drug, languageCode: languageCode, info: infos[drug.id]),
  ]);

  return [
    ...sorted([
      for (final drug in drugs)
        if (drug.deletedAt == null) customDrugChoice(drug),
    ]),
    ...reference(trList ? turkeyCountryCode : globalCountryCode),
  ];
}
