import 'package:mobil_arici/core/l10n/generated/app_localizations.dart';
import 'package:mobil_arici/features/inspections/domain/inspection.dart';

extension QueenStateLabel on QueenState {
  String label(AppLocalizations l10n) => switch (this) {
    QueenState.seen => l10n.queenStateSeen,
    QueenState.eggs => l10n.queenStateEggs,
    QueenState.none => l10n.queenStateNone,
  };
}

extension TemperamentLabel on Temperament {
  String label(AppLocalizations l10n) => switch (this) {
    Temperament.calm => l10n.temperamentCalm,
    Temperament.nervous => l10n.temperamentNervous,
  };
}

extension QueenCellsLabel on QueenCells {
  String label(AppLocalizations l10n) => switch (this) {
    QueenCells.none => l10n.queenCellsNone,
    QueenCells.swarm => l10n.queenCellsSwarm,
    QueenCells.supersedure => l10n.queenCellsSupersedure,
    QueenCells.emergency => l10n.queenCellsEmergency,
  };
}

extension InspectionActionLabel on InspectionAction {
  String label(AppLocalizations l10n) => switch (this) {
    InspectionAction.superAdded => l10n.inspectionActionSuperAdded,
    InspectionAction.superRemoved => l10n.inspectionActionSuperRemoved,
    InspectionAction.framesAdded => l10n.inspectionActionFramesAdded,
    InspectionAction.foundationAdded => l10n.inspectionActionFoundationAdded,
    InspectionAction.fed => l10n.inspectionActionFed,
    InspectionAction.excluderFitted => l10n.inspectionActionExcluderFitted,
    InspectionAction.entranceReduced => l10n.inspectionActionEntranceReduced,
    InspectionAction.pollenTrapFitted => l10n.inspectionActionPollenTrapFitted,
  };
}
