import 'package:drift/drift.dart';
import 'package:mobil_arici/core/db/app_database.dart';
import 'package:mobil_arici/core/db/base_repository.dart';
import 'package:mobil_arici/core/utils/uuid.dart';
import 'package:mobil_arici/features/inspections/data/inspection_draft_repository.dart';
import 'package:mobil_arici/features/inspections/data/inspection_reminder_repository.dart';
import 'package:mobil_arici/features/inspections/domain/inspection.dart';
import 'package:mobil_arici/features/inspections/domain/inspection_draft.dart';

/// Muayeneler; olay kaydı: yalnız eklenir, güncelleme yok, yanlış kayıt
/// silinir. Kaydetme kovanın taslağını, geri alma hatırlatmayı ve taslağı
/// aynı transaction'da yazar.
class InspectionRepository
    extends BaseRepository<$InspectionsTable, Inspection> {
  new(super.db, {super.clock});

  late final _drafts = InspectionDraftRepository(db, clock: clock);
  late final _reminders = InspectionReminderRepository(db, clock: clock);

  @override
  $InspectionsTable get table => db.inspections;

  @override
  Insertable<Inspection> toInsertable(Inspection record) =>
      record.toInsertable();

  /// Kovanın en son muayenesi; yoksa null. Aynı anda yapılanlardan kimliği
  /// (UUIDv7) büyük olan.
  Future<Inspection?> latestByHive(String hiveId) =>
      (selectWhere((t) => t.hiveId.equals(hiveId))
            ..orderBy([
              (t) => OrderingTerm.desc(t.inspectedAt),
              (t) => OrderingTerm.desc(t.id),
            ])
            ..limit(1))
          .getSingleOrNull();

  /// Kovanın şimdi [apiaryId] arılığında yapılan muayenesini [values] ile
  /// yazar ve kovanın taslağını siler; ikisi tek transaction'da.
  Future<Inspection> add({
    required String orgId,
    required String hiveId,
    required String apiaryId,
    required InspectionValues values,
  }) => db.transaction(() async {
    final at = now();
    final inspection = await insertRecord(
      Inspection(
        id: generateId(),
        orgId: orgId,
        hiveId: hiveId,
        apiaryId: apiaryId,
        inspectedAt: at,
        queenState: values.queenState,
        beeFrames: values.beeFrames,
        broodFrames: values.broodFrames,
        honeyFrames: values.honeyFrames,
        temperament: values.temperament,
        swarmSigns: values.swarmSigns,
        queenCells: values.queenCells,
        diseaseSuspected: values.diseaseSuspected,
        data: inspectionData(values.actions),
        createdAt: at,
        updatedAt: at,
      ),
    );
    await _drafts.discard(hiveId);
    return inspection;
  });

  /// Kaydı geri alır: muayene silinir, hatırlatması kalkar ve [draft]
  /// kovanın taslağı olarak geri yazılır; form kaldığı yerden açılır.
  /// Hepsi tek transaction'da.
  Future<void> undoAdd(Inspection inspection, InspectionDraft draft) =>
      db.transaction(() async {
        await delete(inspection.id);
        await _reminders.clear(inspection.id);
        await _drafts.save(
          orgId: inspection.orgId,
          hiveId: inspection.hiveId,
          draft: draft,
        );
      });
}
