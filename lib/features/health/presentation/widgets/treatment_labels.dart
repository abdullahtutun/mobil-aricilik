import 'package:mobil_arici/core/l10n/generated/app_localizations.dart';
import 'package:mobil_arici/core/utils/app_format.dart';
import 'package:mobil_arici/features/health/domain/drug.dart';
import 'package:mobil_arici/features/health/domain/treatment.dart';
import 'package:mobil_arici/features/health/domain/withdrawal.dart';

extension DrugActiveIngredientLabel on DrugActiveIngredient {
  String label(AppLocalizations l10n) => switch (this) {
    DrugActiveIngredient.amitraz => l10n.drugIngredientAmitraz,
    DrugActiveIngredient.oxalicAcid => l10n.drugIngredientOxalicAcid,
    DrugActiveIngredient.formicAcid => l10n.drugIngredientFormicAcid,
    DrugActiveIngredient.thymol => l10n.drugIngredientThymol,
    DrugActiveIngredient.flumethrin => l10n.drugIngredientFlumethrin,
    DrugActiveIngredient.tauFluvalinate => l10n.drugIngredientTauFluvalinate,
    DrugActiveIngredient.coumaphos => l10n.drugIngredientCoumaphos,
    DrugActiveIngredient.lacticAcid => l10n.drugIngredientLacticAcid,
    DrugActiveIngredient.other => l10n.drugIngredientOther,
  };
}

extension DrugDoseUnitLabel on DrugDoseUnit {
  String label(AppLocalizations l10n) => switch (this) {
    DrugDoseUnit.strip => l10n.drugUnitStrip,
    DrugDoseUnit.ml => l10n.drugUnitMl,
    DrugDoseUnit.g => l10n.drugUnitG,
    DrugDoseUnit.dose => l10n.drugUnitDose,
  };
}

extension WithdrawalOverrideReasonLabel on WithdrawalOverrideReason {
  String label(AppLocalizations l10n) => switch (this) {
    WithdrawalOverrideReason.removedEarly => l10n.withdrawalReasonRemovedEarly,
    WithdrawalOverrideReason.notForSale => l10n.withdrawalReasonNotForSale,
  };

  /// Hasatta: kat değil bal satılmayacak.
  String harvestLabel(AppLocalizations l10n) => switch (this) {
    WithdrawalOverrideReason.removedEarly => l10n.withdrawalReasonRemovedEarly,
    WithdrawalOverrideReason.notForSale =>
      l10n.withdrawalReasonNotForSaleHarvest,
  };
}

/// İlacın ikincil satırı: "Etken madde: Amitraz · ruhsat 123" ya da
/// "… · işletmenin ilacı".
String drugChoiceHint(AppLocalizations l10n, DrugChoice drug) => [
  l10n.treatmentDrugIngredient(drug.activeIngredient.label(l10n)),
  if (drug.licenseNo case final number?) l10n.treatmentDrugLicense(number),
  if (drug.drugId != null) l10n.treatmentDrugCustom,
].join(l10n.titleSeparator);

/// Tünel satırı: "Parti 24-118 · 2 şerit · çıkarma 5 Ara · 14 gün
/// bekleme"; boş alanlar yazılmaz.
String treatmentSummary(
  AppLocalizations l10n,
  AppFormat format,
  Treatment treatment,
) => [
  if (treatment.batchNo case final batch?) l10n.timelineTreatmentBatch(batch),
  l10n.treatmentDoseValue(
    format.number(treatment.dose),
    treatment.doseUnit.label(l10n),
  ),
  if (treatment.plannedRemovalAt case final removal?)
    l10n.timelineTreatmentRemoval(format.dayMonth(removal.toLocal())),
  if (treatment.withdrawalDays > 0)
    l10n.timelineTreatmentWithdrawal(treatment.withdrawalDays),
].join(l10n.titleSeparator);
