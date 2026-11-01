import 'package:mobil_arici/core/design_system/design_system.dart';
import 'package:mobil_arici/core/l10n/generated/app_localizations.dart';
import 'package:mobil_arici/features/queens/domain/queen_rearing.dart';
import 'package:mobil_arici/features/queens/domain/queen_rearing_rules.dart';

/// Adımın adı ("Kabul kontrolü"); otomatik görevin başlığı da bu.
String rearingStepTitle(AppLocalizations l10n, RearingStep step) =>
    switch (step) {
      RearingStep.graft => l10n.rearingStepGraft,
      RearingStep.acceptance => l10n.rearingStepAcceptance,
      RearingStep.capped => l10n.rearingStepCapped,
      RearingStep.distribution => l10n.rearingStepDistribution,
      RearingStep.emergence => l10n.rearingStepEmergence,
      RearingStep.layingCheck => l10n.rearingStepLayingCheck,
    };

/// Adımın altındaki satır: aktarmada larva sayısı, kabulde kabul edilen
/// meme, dağıtımda kutu sayısı ([nucCount], kutu yoksa kabul edilen),
/// diğerlerinde yapılacak iş.
String rearingStepDetail(
  AppLocalizations l10n,
  RearingStep step,
  QueenRearingBatch batch, {
  required int nucCount,
}) => switch (step) {
  RearingStep.graft => l10n.rearingStepGraftDetail(batch.graftedCount),
  RearingStep.acceptance => switch (batch.acceptedCount) {
    final accepted? => l10n.rearingStepAcceptanceDetail(accepted),
    null => l10n.rearingStepAcceptanceTodo,
  },
  RearingStep.capped => l10n.rearingStepCappedDetail,
  RearingStep.distribution => switch (nucCount > 0
      ? nucCount
      : batch.acceptedCount) {
    final count? when count > 0 => l10n.rearingStepDistributionDetail(count),
    _ => l10n.rearingStepDistributionTodo,
  },
  RearingStep.emergence => l10n.rearingStepEmergenceDetail,
  RearingStep.layingCheck => l10n.rearingStepLayingCheckDetail,
};

/// Adımın durumu ekran okuyucuda kelimeyle.
String rearingStepStateLabel(AppLocalizations l10n, RearingStepState state) =>
    switch (state) {
      RearingStepState.done => l10n.rearingStepDone,
      RearingStepState.current => l10n.rearingStepCurrent,
      RearingStepState.upcoming => l10n.rearingStepUpcoming,
    };

extension MatingNucStatusLabel on MatingNucStatus {
  String label(AppLocalizations l10n) => switch (this) {
    MatingNucStatus.empty => l10n.matingNucStatusEmpty,
    MatingNucStatus.cell => l10n.matingNucStatusCell,
    MatingNucStatus.virgin => l10n.matingNucStatusVirgin,
    MatingNucStatus.laying => l10n.matingNucStatusLaying,
    MatingNucStatus.failed => l10n.matingNucStatusFailed,
    MatingNucStatus.given => l10n.matingNucStatusGiven,
  };

  /// Rozetin durumu: yumurtlayan ve verilen iyi, başarısız kritik,
  /// beklenenler bilgi.
  AppStatus get badge => switch (this) {
    MatingNucStatus.laying || MatingNucStatus.given => AppStatus.good,
    MatingNucStatus.failed => AppStatus.critical,
    MatingNucStatus.empty ||
    MatingNucStatus.cell ||
    MatingNucStatus.virgin => AppStatus.info,
  };
}
