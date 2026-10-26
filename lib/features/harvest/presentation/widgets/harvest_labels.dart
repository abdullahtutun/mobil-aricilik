import 'package:mobil_arici/core/l10n/generated/app_localizations.dart';
import 'package:mobil_arici/features/harvest/domain/harvest.dart';

extension HoneyKindLabel on HoneyKind {
  String label(AppLocalizations l10n) => switch (this) {
    HoneyKind.pine => l10n.honeyKindPine,
    HoneyKind.flower => l10n.honeyKindFlower,
    HoneyKind.chestnut => l10n.honeyKindChestnut,
    HoneyKind.citrus => l10n.honeyKindCitrus,
    HoneyKind.other => l10n.honeyKindOther,
  };
}

extension HarvestUnitLabel on HarvestUnit {
  String label(AppLocalizations l10n) => switch (this) {
    HarvestUnit.superBox => l10n.harvestUnitSuper,
    HarvestUnit.frame => l10n.harvestUnitFrame,
  };

  /// Sayacın adı: "Alınan kat" / "Alınan çerçeve".
  String takenLabel(AppLocalizations l10n) => switch (this) {
    HarvestUnit.superBox => l10n.harvestTakenSupers,
    HarvestUnit.frame => l10n.harvestTakenFrames,
  };
}
