import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:mobil_arici/core/db/server_enum.dart';
import 'package:mobil_arici/core/db/synced_record.dart';

part 'inspection.freezed.dart';
part 'inspection.g.dart';

/// Ana arı (`public.inspection_queen_state`): görüldü; görülmedi ama taze
/// yumurta var; ikisi de yok.
@JsonEnum(valueField: 'value')
enum QueenState implements ServerEnum {
  seen('seen'),
  eggs('eggs'),
  none('none');

  new(this.value);

  @override
  final String value;
}

/// Mizac (`public.inspection_temperament`).
@JsonEnum(valueField: 'value')
enum Temperament implements ServerEnum {
  calm('calm'),
  nervous('nervous');

  new(this.value);

  @override
  final String value;
}

/// Ana arı memesi (`public.inspection_queen_cells`): yok, oğul memesi,
/// sessiz ana değiştirme, acil meme.
@JsonEnum(valueField: 'value')
enum QueenCells implements ServerEnum {
  none('none'),
  swarm('swarm'),
  supersedure('supersedure'),
  emergency('emergency');

  new(this.value);

  @override
  final String value;
}

/// Muayenede yapılan işlem. Sunucuda enum değil, `data.actions` içinde bu
/// değerlerle durur.
@JsonEnum(valueField: 'value')
enum InspectionAction implements ServerEnum {
  superAdded('super_added'),
  superRemoved('super_removed'),
  framesAdded('frames_added'),
  foundationAdded('foundation_added'),
  fed('fed'),
  excluderFitted('excluder_fitted'),
  entranceReduced('entrance_reduced'),
  pollenTrapFitted('pollen_trap_fitted');

  new(this.value);

  @override
  final String value;
}

/// Muayenenin formdaki alanları; boş alan "bu muayenede bakılmadı".
@freezed
abstract class InspectionValues with _$InspectionValues {
  const factory({
    QueenState? queenState,

    /// Arılı, yavrulu ve ballı çerçeve sayıları.
    int? beeFrames,
    int? broodFrames,
    int? honeyFrames,
    Temperament? temperament,
    bool? swarmSigns,
    QueenCells? queenCells,
    bool? diseaseSuspected,
    @Default(<InspectionAction>{}) Set<InspectionAction> actions,
  }) = _InspectionValues;

  factory fromJson(Map<String, Object?> json) =>
      _$InspectionValuesFromJson(json);
}

/// Muayene (`inspections`). Olay kaydı: yalnız eklenir, yanlış kayıt
/// silinir.
@freezed
abstract class Inspection with _$Inspection implements SyncedRecord {
  const factory({
    required String id,
    required String orgId,
    required String hiveId,

    /// Muayenenin yapıldığı arılık; kovan sonra taşınsa da değişmez.
    required String apiaryId,
    required DateTime inspectedAt,
    required DateTime createdAt,
    required DateTime updatedAt,
    QueenState? queenState,
    int? beeFrames,
    int? broodFrames,
    int? honeyFrames,
    Temperament? temperament,
    bool? swarmSigns,
    QueenCells? queenCells,
    bool? diseaseSuspected,

    /// Esnek alanlar (`data jsonb`): şimdilik `actions`. Bu sürümün
    /// tanımadığı anahtarlar olduğu gibi korunur.
    @Default(<String, Object?>{}) Map<String, Object?> data,
    String? createdBy,
    DateTime? deletedAt,
    @JsonKey(includeToJson: false) int? serverSeq,
  }) = _Inspection;

  factory fromJson(Map<String, Object?> json) => _$InspectionFromJson(json);
}

extension InspectionFields on Inspection {
  /// `data.actions` içindeki işlemler; bu sürümün tanımadıkları atlanır.
  Set<InspectionAction> get actions => {
    if (data['actions'] case final List<Object?> values)
      for (final action in InspectionAction.values)
        if (values.contains(action.value)) action,
  };

  InspectionValues get values => InspectionValues(
    queenState: queenState,
    beeFrames: beeFrames,
    broodFrames: broodFrames,
    honeyFrames: honeyFrames,
    temperament: temperament,
    swarmSigns: swarmSigns,
    queenCells: queenCells,
    diseaseSuspected: diseaseSuspected,
    actions: actions,
  );
}

/// [actions]'ı `data` nesnesine yazar; işlem yoksa anahtar hiç olmaz.
/// [data]'daki diğer anahtarlar korunur.
Map<String, Object?> inspectionData(
  Set<InspectionAction> actions, {
  Map<String, Object?> data = const {},
}) => {
  for (final MapEntry(:key, :value) in data.entries)
    if (key != 'actions') key: value,
  if (actions.isNotEmpty)
    'actions': [
      for (final action in InspectionAction.values)
        if (actions.contains(action)) action.value,
    ],
};
