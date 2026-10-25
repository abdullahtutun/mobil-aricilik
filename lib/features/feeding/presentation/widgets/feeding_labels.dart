import 'package:mobil_arici/core/l10n/generated/app_localizations.dart';
import 'package:mobil_arici/core/utils/units.dart';
import 'package:mobil_arici/features/feeding/domain/feeding.dart';

extension FeedingKindLabel on FeedingKind {
  String label(AppLocalizations l10n) => switch (this) {
    FeedingKind.syrup1to1 => l10n.feedingKindSyrup1to1,
    FeedingKind.syrup2to1 => l10n.feedingKindSyrup2to1,
    FeedingKind.beeCake => l10n.feedingKindBeeCake,
    FeedingKind.pollenSubstitute => l10n.feedingKindPollenSubstitute,
  };
}

extension VolumeUnitLabel on VolumeUnit {
  String label(AppLocalizations l10n) => switch (this) {
    VolumeUnit.liter => l10n.unitLiter,
    VolumeUnit.gallon => l10n.unitGallon,
  };
}

extension MassUnitLabel on MassUnit {
  String label(AppLocalizations l10n) => switch (this) {
    MassUnit.kilogram => l10n.unitKilogram,
    MassUnit.pound => l10n.unitPound,
  };
}
