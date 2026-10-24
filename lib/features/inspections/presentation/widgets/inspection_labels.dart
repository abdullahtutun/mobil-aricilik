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

/// Muayenenin girilen alanları, her biri bir satır ("Ana arı: Görüldü");
/// bakılmayan (boş) alan yazılmaz.
List<String> inspectionSummary(AppLocalizations l10n, InspectionValues values) {
  String field(String label, String value) => l10n.timelineField(label, value);
  String answer({required bool yes}) =>
      yes ? l10n.inspectionAnswerYes : l10n.inspectionAnswerNo;
  final frames = [
    if (values.beeFrames case final count?) l10n.timelineBeeFrames(count),
    if (values.broodFrames case final count?) l10n.timelineBroodFrames(count),
    if (values.honeyFrames case final count?) l10n.timelineHoneyFrames(count),
  ];
  final actions = [
    for (final action in InspectionAction.values)
      if (values.actions.contains(action)) action.label(l10n),
  ];

  return [
    if (values.queenState case final state?)
      field(l10n.inspectionQueen, state.label(l10n)),
    if (frames.isNotEmpty)
      field(l10n.inspectionFrames, frames.join(l10n.listSeparator)),
    if (values.temperament case final temperament?)
      field(l10n.inspectionTemperament, temperament.label(l10n)),
    if (values.swarmSigns case final swarmSigns?)
      field(l10n.inspectionSwarmSigns, answer(yes: swarmSigns)),
    if (values.queenCells case final queenCells?)
      field(l10n.inspectionQueenCells, queenCells.label(l10n)),
    if (values.diseaseSuspected case final suspected?)
      field(l10n.inspectionDisease, answer(yes: suspected)),
    if (actions.isNotEmpty)
      field(l10n.timelineActions, actions.join(l10n.listSeparator)),
  ];
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
