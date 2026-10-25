import 'package:drift/drift.dart';
import 'package:mobil_arici/core/db/app_database.dart';
import 'package:mobil_arici/core/db/base_repository.dart';
import 'package:mobil_arici/core/utils/uuid.dart';
import 'package:mobil_arici/features/health/domain/withdrawal.dart';
import 'package:mobil_arici/features/inspections/data/inspection_draft_repository.dart';
import 'package:mobil_arici/features/inspections/data/inspection_reminder_repository.dart';
import 'package:mobil_arici/features/inspections/domain/inspection.dart';
import 'package:mobil_arici/features/inspections/domain/inspection_draft.dart';
import 'package:mobil_arici/features/media/data/media_repository.dart';
import 'package:mobil_arici/features/media/domain/media_item.dart';

/// Muayeneler; olay kaydı: yalnız eklenir, güncelleme yok, yanlış kayıt
/// silinir. Kaydetme muayenede çekilen medyayı ve kovanın taslağını, geri
/// alma medyayı, hatırlatmayı ve taslağı aynı transaction'da yazar.
class InspectionRepository
    extends BaseRepository<$InspectionsTable, Inspection> {
  new(super.db, {super.clock});

  late final _drafts = InspectionDraftRepository(db, clock: clock);
  late final _reminders = InspectionReminderRepository(db, clock: clock);
  late final _media = MediaRepository(db, clock: clock);

  @override
  $InspectionsTable get table => db.inspections;

  @override
  Insertable<Inspection> toInsertable(Inspection record) =>
      record.toInsertable();

  /// Kovanın en son muayenesi; yoksa null. Aynı anda yapılanlardan kimliği
  /// (UUIDv7) büyük olan.
  Future<Inspection?> latestByHive(String hiveId) =>
      (_byHive(hiveId)..limit(1)).getSingleOrNull();

  /// Kovanın muayeneleri, en yeni önce.
  Stream<List<Inspection>> watchByHive(String hiveId) =>
      _byHive(hiveId).watch();

  /// Şimdi [apiaryId] arılığındaki (silinmemiş) her kovanın en son
  /// muayenesi, kovan kimliğine göre; muayenesi olmayan kovan haritada
  /// yok. "En son" [latestByHive] ile aynı. Kovan arılığa taşınınca ya da
  /// arılıktan çıkınca da yeniden yayar.
  Stream<Map<String, Inspection>> watchLatestByApiary(String apiaryId) {
    final hives = db.hives;
    final hiveIds = db.selectOnly(hives)
      ..addColumns([hives.id])
      ..where(hives.apiaryId.equals(apiaryId) & hives.deletedAt.isNull());
    final later = db.alias(table, 'later');
    return selectWhere(
      (t) =>
          t.hiveId.isInQuery(hiveIds) &
          notExistsQuery(
            db.select(later)..where(
              (l) =>
                  l.hiveId.equalsExp(t.hiveId) &
                  l.deletedAt.isNull() &
                  (l.inspectedAt.isBiggerThan(t.inspectedAt) |
                      (l.inspectedAt.equalsExp(t.inspectedAt) &
                          l.id.isBiggerThan(t.id))),
            ),
          ),
    ).watch().map((latest) => {for (final row in latest) row.hiveId: row});
  }

  /// Şimdi [apiaryId] arılığındaki (silinmemiş) kovanların "Kat verildi"
  /// ya da "Kat alındı" içeren muayeneleri; bal katı olan kovanlar bundan
  /// hesaplanır (`honeySuperHiveIds`). Kovan arılığa taşınınca da yeniden
  /// yayar.
  Stream<List<Inspection>> watchSuperChangesByApiary(String apiaryId) =>
      _superChangesByApiary(apiaryId).watch();

  /// [watchSuperChangesByApiary]'nin okuma anındaki hâli (ör. toplu
  /// yazmanın transaction'ında).
  Future<List<Inspection>> findSuperChangesByApiary(String apiaryId) =>
      _superChangesByApiary(apiaryId).get();

  SimpleSelectStatement<$InspectionsTable, Inspection> _superChangesByApiary(
    String apiaryId,
  ) {
    final hives = db.hives;
    final hiveIds = db.selectOnly(hives)
      ..addColumns([hives.id])
      ..where(hives.apiaryId.equals(apiaryId) & hives.deletedAt.isNull());
    // `data` JSON metin; işlem adı tırnaklı arandığı için başka anahtarın
    // değerine takılmaz. Kesin süzme kuralda (`InspectionFields.actions`).
    return selectWhere(
      (t) =>
          t.hiveId.isInQuery(hiveIds) &
          (t.data.like('%"${InspectionAction.superAdded.value}"%') |
              t.data.like('%"${InspectionAction.superRemoved.value}"%')),
    );
  }

  SimpleSelectStatement<$InspectionsTable, Inspection> _byHive(String hiveId) =>
      selectWhere((t) => t.hiveId.equals(hiveId))..orderBy([
        (t) => OrderingTerm.desc(t.inspectedAt),
        (t) => OrderingTerm.desc(t.id),
      ]);

  /// Kovanın şimdi [apiaryId] arılığında yapılan muayenesini [values] ile
  /// yazar, muayenede çekilen [media]'yı ona bağlı medya olarak ekler ve
  /// kovanın taslağını siler; hepsi tek transaction'da. Bal katı bekleme
  /// süresine rağmen verildiyse [withdrawalOverride] muayeneyle saklanır.
  Future<Inspection> add({
    required String orgId,
    required String hiveId,
    required String apiaryId,
    required InspectionValues values,
    List<MediaCapture> media = const [],
    WithdrawalOverride? withdrawalOverride,
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
        data: inspectionData(
          values.actions,
          withdrawalOverride: withdrawalOverride,
        ),
        createdAt: at,
        updatedAt: at,
      ),
    );
    for (final capture in media) {
      await _media.add(
        orgId: orgId,
        hiveId: hiveId,
        inspectionId: inspection.id,
        capture: capture,
      );
    }
    await _drafts.discard(hiveId);
    return inspection;
  });

  /// Kaydı geri alır: muayene ve medyası silinir, hatırlatması kalkar ve
  /// [draft] kovanın taslağı olarak geri yazılır; form, çekimleriyle
  /// birlikte kaldığı yerden açılır. Hepsi tek transaction'da.
  Future<void> undoAdd(Inspection inspection, InspectionDraft draft) =>
      db.transaction(() async {
        await delete(inspection.id);
        await _media.removeByInspection(inspection.id);
        await _reminders.clear(inspection.id);
        await _drafts.save(
          orgId: inspection.orgId,
          hiveId: inspection.hiveId,
          draft: draft,
        );
      });
}
