import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:mobil_arici/features/inspections/domain/inspection.dart';

part 'inspection_draft.freezed.dart';
part 'inspection_draft.g.dart';

/// Önceki muayeneden doldurulabilen alanlar. Yapılan işlemler her
/// muayenede boş başlar, burada yok.
enum InspectionField {
  queenState,
  beeFrames,
  broodFrames,
  honeyFrames,
  temperament,
  swarmSigns,
  queenCells,
  diseaseSuspected,
}

/// Hızlı muayene formunun hâli; her değişiklikte taslak olarak yerelde
/// saklanır, uygulama kapansa da kaldığı yerden açılır.
@freezed
abstract class InspectionDraft with _$InspectionDraft {
  const factory({
    @Default(InspectionValues()) InspectionValues values,

    /// Değeri önceki muayeneden gelen ve bu muayenede dokunulmamış alanlar;
    /// soluk gösterilir. Dokunulmasa da değerleriyle kaydedilir.
    @Default(<InspectionField>{}) Set<InspectionField> suggested,
  }) = _InspectionDraft;

  factory fromJson(Map<String, Object?> json) =>
      _$InspectionDraftFromJson(json);
}
