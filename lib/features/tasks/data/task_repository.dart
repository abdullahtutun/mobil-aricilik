import 'package:drift/drift.dart';
import 'package:mobil_arici/core/db/app_database.dart';
import 'package:mobil_arici/core/db/base_repository.dart';
import 'package:mobil_arici/core/utils/uuid.dart';
import 'package:mobil_arici/features/hives/domain/hive.dart';
import 'package:mobil_arici/features/inspections/domain/inspection.dart';
import 'package:mobil_arici/features/inspections/domain/inspection_rules.dart';
import 'package:mobil_arici/features/queens/domain/queen_rearing_rules.dart';
import 'package:mobil_arici/features/tasks/domain/task.dart';
import 'package:mobil_arici/features/tasks/domain/task_rules.dart';

/// Görevler; durum kaydı, son yazan kazanır. Otomatik görevler kaynak
/// kayıtla (muayene, ilaç uygulaması) aynı transaction'da yazılır ve
/// kaynağın Geri al'ı onları da siler.
class TaskRepository extends BaseRepository<$TasksTable, Task> {
  new(super.db, {super.clock});

  @override
  $TasksTable get table => db.tasks;

  @override
  Insertable<Task> toInsertable(Task record) => record.toInsertable();

  /// İşletmenin açık görevleri bağlı arılığın adı ve kovanın numarasıyla,
  /// son tarih sırasıyla. Görev, arılık ya da kovan değişince yeniden
  /// yayar. Silinmiş arılığın ya da kovanın adı gösterilmez.
  Stream<List<TaskView>> watchOpen(String orgId) {
    final apiaries = db.apiaries;
    final hives = db.hives;
    final query =
        db.select(table).join([
            leftOuterJoin(
              apiaries,
              apiaries.id.equalsExp(table.apiaryId) &
                  apiaries.deletedAt.isNull(),
            ),
            leftOuterJoin(
              hives,
              hives.id.equalsExp(table.hiveId) & hives.deletedAt.isNull(),
            ),
          ])
          ..where(
            table.orgId.equals(orgId) &
                table.deletedAt.isNull() &
                table.completedAt.isNull(),
          )
          ..orderBy([
            OrderingTerm.asc(table.dueAt),
            OrderingTerm.asc(table.id),
          ]);
    return query.watch().map(
      (rows) => [
        for (final row in rows)
          (
            task: row.readTable(table),
            apiaryName: row.readTableOrNull(apiaries)?.name,
            hiveNumber: row.readTableOrNull(hives)?.number,
          ),
      ],
    );
  }

  /// İşletmenin açık planlı ilaçlama görevleri ve uygulanacak kovan
  /// sayısı: kovana bağlı görevde 1, değilse arılıktaki aktif kovanlar.
  /// Görev ya da kovanlar değişince yeniden yayar.
  Stream<List<({Task task, int hives})>> watchOpenPlannedTreatments(
    String orgId,
  ) {
    final hives = db.hives;
    final count = hives.id.count();
    final query =
        db.select(table).join([
            leftOuterJoin(
              hives,
              hives.apiaryId.equalsExp(table.apiaryId) &
                  hives.deletedAt.isNull() &
                  hives.status.equalsValue(HiveStatus.active),
              useColumns: false,
            ),
          ])
          ..addColumns([count])
          ..where(
            table.orgId.equals(orgId) &
                table.deletedAt.isNull() &
                table.completedAt.isNull() &
                table.dose.isNotNull(),
          )
          ..groupBy([table.id])
          ..orderBy([
            OrderingTerm.asc(table.dueAt),
            OrderingTerm.asc(table.id),
          ]);
    return query.watch().map(
      (rows) => [
        for (final row in rows)
          if (row.readTable(table) case final task)
            (task: task, hives: task.hiveId != null ? 1 : row.read(count) ?? 0),
      ],
    );
  }

  /// Elle görev açar. Kovan verilirse arılığı da verilmeli. Planlı
  /// ilaçlamada ilaç ([refDrugId] ya da [drugId]) ve kovan başı [dose]
  /// birlikte verilir, arılık zorunlu. Başlık boşsa ya da çok uzunsa ya da
  /// ilaç alanları tutarsızsa [ArgumentError] atar ve bir şey yazmaz.
  Future<Task> create({
    required String orgId,
    required String title,
    required DateTime dueAt,
    String? apiaryId,
    String? hiveId,
    String? assignedTo,
    String? refDrugId,
    String? drugId,
    double? dose,
  }) {
    final at = now();
    return insertRecord(
      _checked(
        Task(
          id: generateId(),
          orgId: orgId,
          title: title.trim(),
          dueAt: dueAt.toUtc(),
          apiaryId: apiaryId,
          hiveId: hiveId,
          assignedTo: assignedTo,
          refDrugId: refDrugId,
          drugId: drugId,
          dose: dose,
          createdAt: at,
          updatedAt: at,
        ),
      ),
    );
  }

  /// Elle açılan görevleri [create] gibi yazar; hepsi tek transaction'da,
  /// biri geçersizse ([ArgumentError]) hiçbiri yazılmaz.
  Future<List<Task>> createMany(
    String orgId,
    List<
      ({
        String title,
        DateTime dueAt,
        String? apiaryId,
        String? hiveId,
        String? assignedTo,
      })
    >
    tasks,
  ) => db.transaction(() async {
    final created = <Task>[];
    for (final task in tasks) {
      created.add(
        await create(
          orgId: orgId,
          title: task.title,
          dueAt: task.dueAt,
          apiaryId: task.apiaryId,
          hiveId: task.hiveId,
          assignedTo: task.assignedTo,
        ),
      );
    }
    return created;
  });

  /// [source] kaynaklı ve kaynağı [sourceIds] içinde olan (silinmemiş)
  /// görevler, son tarih sırasıyla; arılık turunun özetinde turda açılan
  /// "tekrar bak" görevleri.
  Stream<List<Task>> watchBySources(
    TaskSource source,
    Iterable<String> sourceIds,
  ) => watchWhere(
    (t) => t.source.equalsValue(source) & t.sourceId.isIn(sourceIds),
    orderBy: [(t) => OrderingTerm.asc(t.dueAt), (t) => OrderingTerm.asc(t.id)],
  );

  /// Görevin alanlarını yazar (son yazan kazanır). Görev yoksa ya da
  /// silinmişse [StateError]; değerler geçersizse [ArgumentError].
  Future<Task> update(Task task) => updateRecord(
    _checked(
      task.copyWith(title: task.title?.trim(), dueAt: task.dueAt.toUtc()),
    ),
  );

  /// Görevi tamamlar ya da ([completed] false) yeniden açar.
  Future<Task> setCompleted(Task task, {required bool completed}) =>
      updateRecord(task.copyWith(completedAt: completed ? now() : null));

  /// Muayeneden [days] gün sonra "tekrar bak" görevi ([reminderAt]);
  /// muayenenin önceki görevi varsa yalnız son tarihi değişir. Görev
  /// [assignedTo]'ya atanır.
  Future<Task> remindAfterInspection(
    Inspection inspection,
    int days, {
    String? assignedTo,
  }) => db.transaction(() async {
    final dueAt = reminderAt(inspection.inspectedAt, days);
    final existing = await _bySource(TaskSource.inspection, inspection.id);
    if (existing.firstOrNull case final task?) {
      return await updateRecord(task.copyWith(dueAt: dueAt));
    }
    final at = now();
    return await insertRecord(
      Task(
        id: generateId(),
        orgId: inspection.orgId,
        dueAt: dueAt,
        apiaryId: inspection.apiaryId,
        hiveId: inspection.hiveId,
        assignedTo: assignedTo,
        source: TaskSource.inspection,
        sourceId: inspection.id,
        createdAt: at,
        updatedAt: at,
      ),
    );
  });

  /// İlaç şeridini çıkarma görevi; [groupId] uygulama grubu. Tek kovanlık
  /// uygulamada [hiveId] dolu, arılığın tümünde boş.
  Future<Task> addTreatmentRemoval({
    required String orgId,
    required String groupId,
    required String apiaryId,
    required DateTime dueAt,
    String? hiveId,
    String? assignedTo,
  }) {
    final at = now();
    return insertRecord(
      Task(
        id: generateId(),
        orgId: orgId,
        dueAt: dueAt.toUtc(),
        apiaryId: apiaryId,
        hiveId: hiveId,
        assignedTo: assignedTo,
        source: TaskSource.treatment,
        sourceId: groupId,
        createdAt: at,
        updatedAt: at,
      ),
    );
  }

  /// Ana yetiştirme serisinin ([batchId]) takvim görevleri: aktarma
  /// dışındaki her adım için adım günü [rearingTaskHour]'da bir görev
  /// ([rearingStepDueAt]). Görevler [assignedTo]'ya atanır; hepsi tek
  /// transaction'da.
  Future<List<Task>> addQueenRearingSteps({
    required String orgId,
    required String batchId,
    required DateTime graftedOn,
    String? assignedTo,
  }) => db.transaction(() async {
    final at = now();
    return [
      for (final step in rearingTaskSteps)
        await insertRecord(
          Task(
            id: generateId(),
            orgId: orgId,
            dueAt: rearingStepDueAt(graftedOn, step),
            assignedTo: assignedTo,
            source: TaskSource.queenRearing,
            sourceId: batchId,
            sourceStep: step.day,
            createdAt: at,
            updatedAt: at,
          ),
        ),
    ];
  });

  /// Aktarma günü değişince serinin ([batchId]) görevlerinin günü yeni
  /// takvime çekilir; günü zaten tutan görev yazılmaz.
  Future<void> rescheduleQueenRearing(String batchId, DateTime graftedOn) =>
      db.transaction(() async {
        for (final task in await _bySource(TaskSource.queenRearing, batchId)) {
          final step = RearingStep.ofDay(task.sourceStep);
          if (step == null) continue;
          final dueAt = rearingStepDueAt(graftedOn, step);
          if (task.dueAt.isAtSameMomentAs(dueAt)) continue;
          await updateRecord(task.copyWith(dueAt: dueAt));
        }
      });

  /// [source] kaydının ([sourceId]) görevlerini siler (kaynağın Geri al'ı,
  /// hatırlatmanın kaldırılması).
  Future<void> deleteBySource(TaskSource source, String sourceId) =>
      db.transaction(() async {
        for (final task in await _bySource(source, sourceId)) {
          await delete(task.id);
        }
      });

  /// [source] kaydının ([sourceId]) silinmemiş görevleri.
  Future<List<Task>> findBySource(TaskSource source, String sourceId) =>
      _bySource(source, sourceId);

  Future<List<Task>> _bySource(TaskSource source, String sourceId) =>
      selectWhere(
        (t) => t.source.equalsValue(source) & t.sourceId.equals(sourceId),
      ).get();

  /// Sunucunun kısıtları: elle açılan görevin başlığı dolu ve
  /// [maxTaskTitleLength]'i geçmez; kovana bağlı görev arılığını taşır;
  /// ilaç ve doz birlikte, en çok bir ilaç, ilaçlı görev elle açılmış ve
  /// arılığa bağlı ([checkTaskPlan]).
  static Task _checked(Task task) {
    final title = task.title;
    if (task.source == TaskSource.manual &&
        (title == null || title.isEmpty || title.length > maxTaskTitleLength)) {
      throw ArgumentError.value(title, 'title');
    }
    if (task.hiveId != null && task.apiaryId == null) {
      throw ArgumentError.value(task.apiaryId, 'apiaryId');
    }
    checkTaskPlan(task);
    return task;
  }
}
