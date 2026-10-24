import 'package:mobil_arici/features/hives/domain/hive.dart';
import 'package:mobil_arici/features/inspections/domain/inspection.dart';
import 'package:mobil_arici/features/inspections/domain/inspection_draft.dart';

/// Çerçeve sayısının üst sınırı; sunucudaki CHECK ile aynı.
const maxInspectionFrames = 100;

/// Kaydettikten sonra sunulan "X gün sonra hatırlat" seçenekleri.
const inspectionReminderDays = [3, 7, 14];

/// Yalnız aktif kovan muayene edilir; sönen, birleşen, satılan ve kaybolan
/// kovanın kartında muayene yok.
bool canInspect(Hive hive) => hive.status == HiveStatus.active;

extension InspectionFieldValues on InspectionValues {
  Object? valueOf(InspectionField field) => switch (field) {
    InspectionField.queenState => queenState,
    InspectionField.beeFrames => beeFrames,
    InspectionField.broodFrames => broodFrames,
    InspectionField.honeyFrames => honeyFrames,
    InspectionField.temperament => temperament,
    InspectionField.swarmSigns => swarmSigns,
    InspectionField.queenCells => queenCells,
    InspectionField.diseaseSuspected => diseaseSuspected,
  };
}

/// Yeni muayenenin başlangıç hâli: önceki muayenenin değerleri öneri olarak
/// (soluk) gelir, yapılan işlemler boş başlar. Önceki muayene yoksa form
/// boştur.
InspectionDraft prefilledDraft(Inspection? previous) {
  if (previous == null) return const InspectionDraft();
  final values = previous.values.copyWith(actions: const {});
  return InspectionDraft(
    values: values,
    suggested: {
      for (final field in InspectionField.values)
        if (values.valueOf(field) != null) field,
    },
  );
}

extension InspectionDraftChanges on InspectionDraft {
  /// [values] yazılır. [field] dokunulan alandır: değeri değişse de aynı
  /// kalsa da (öneri onaylandı) artık öneri değil.
  InspectionDraft change(InspectionField? field, InspectionValues values) =>
      copyWith(values: values, suggested: {...suggested}..remove(field));

  bool isSuggested(InspectionField field) => suggested.contains(field);
}

/// Hatırlatma zamanı: muayeneden [days] gün sonra, aynı saatte. Gün yerel
/// takvimde sayılır; yaz saati geçişinde saat kaymaz.
DateTime reminderAt(DateTime inspectedAt, int days) {
  final local = inspectedAt.toLocal();
  return DateTime(
    local.year,
    local.month,
    local.day + days,
    local.hour,
    local.minute,
  ).toUtc();
}
