import 'package:drift/drift.dart';
import 'package:mobil_arici/core/db/app_database.dart';
import 'package:mobil_arici/core/db/base_repository.dart';
import 'package:mobil_arici/core/utils/uuid.dart';
import 'package:mobil_arici/features/health/domain/treatment.dart';
import 'package:mobil_arici/features/health/domain/withdrawal_rules.dart';
import 'package:mobil_arici/features/hives/domain/hive.dart';
import 'package:mobil_arici/features/media/data/media_repository.dart';
import 'package:mobil_arici/features/media/domain/media_item.dart';
import 'package:mobil_arici/features/tasks/data/task_repository.dart';
import 'package:mobil_arici/features/tasks/domain/task.dart';
import 'package:mobil_arici/features/tasks/domain/task_rules.dart';

/// İlaç uygulamaları; olay kaydı: yalnız eklenir, güncelleme yok, yanlış
/// kayıt silinir (Geri al da silmedir). Bir kayıtta yazılan uygulamalar
/// ortak `application_id` taşır; toplu uygulama hepsini ya da hiçbirini
/// yazar. Reçete fotoğrafı ve şeridi çıkarma görevi aynı transaction'da
/// yazılır; fotoğraf formun açıldığı kovanın uygulamasına bağlanır.
class TreatmentRepository extends BaseRepository<$TreatmentsTable, Treatment> {
  new(super.db, {super.clock});

  late final _media = MediaRepository(db, clock: clock);
  late final _tasks = TaskRepository(db, clock: clock);

  @override
  $TreatmentsTable get table => db.treatments;

  @override
  Insertable<Treatment> toInsertable(Treatment record) => record.toInsertable();

  /// Kovanın uygulamaları, en son başlayan önce. Aynı anda başlayanlardan
  /// kimliği (UUIDv7) büyük olan önce.
  Stream<List<Treatment>> watchByHive(String hiveId) => watchWhere(
    (t) => t.hiveId.equals(hiveId),
    orderBy: [
      (t) => OrderingTerm.desc(t.startedAt),
      (t) => OrderingTerm.desc(t.id),
    ],
  );

  /// [apiaryId] arılığında yapılan uygulamalar, en son başlayan önce.
  Stream<List<Treatment>> watchByApiary(String apiaryId) => watchWhere(
    (t) => t.apiaryId.equals(apiaryId),
    orderBy: [
      (t) => OrderingTerm.desc(t.startedAt),
      (t) => OrderingTerm.desc(t.id),
    ],
  );

  /// Kovanın uygulama gruplarının reçete fotoğrafları, grup kimliğine
  /// (`groupId`) göre, çekilme sırasıyla. Toplu uygulamada foto başka
  /// kovanın uygulamasına bağlı olsa da gruptaki her kovanda görünür.
  Stream<Map<String, List<MediaItem>>> watchPrescriptionsByHive(String hiveId) {
    final media = db.media;
    final own = db.alias(table, 'own');
    final group = coalesce<String>([table.applicationId, table.id]);
    final hiveGroups = db.selectOnly(own)
      ..addColumns([
        coalesce<String>([own.applicationId, own.id]),
      ])
      ..where(own.hiveId.equals(hiveId) & own.deletedAt.isNull());
    final query =
        db.select(media).join([
            innerJoin(table, table.id.equalsExp(media.treatmentId)),
          ])
          ..addColumns([group])
          ..where(
            media.deletedAt.isNull() &
                table.deletedAt.isNull() &
                group.isInQuery(hiveGroups),
          )
          ..orderBy([
            OrderingTerm.asc(media.capturedAt),
            OrderingTerm.asc(media.id),
          ]);
    return query.watch().map((rows) {
      final byGroup = <String, List<MediaItem>>{};
      for (final row in rows) {
        (byGroup[row.read<String>(group)!] ??= []).add(row.readTable(media));
      }
      return byGroup;
    });
  }

  /// Kovanın uygulamaları; okuma anında (ör. kilit denetimi).
  Future<List<Treatment>> findByHive(String hiveId) =>
      selectWhere((t) => t.hiveId.equals(hiveId)).get();

  /// [plan]'ı [hive]'a, kovanın şimdiki arılığında yazar; [prescription]
  /// verilirse reçete fotoğrafı olarak uygulamaya bağlanır. Planlanan
  /// çıkarma varsa kovana çıkarma görevi açılır ve [assignedTo]'ya atanır.
  Future<Treatment> addToHive(
    Hive hive,
    TreatmentPlan plan, {
    MediaCapture? prescription,
    String? assignedTo,
  }) async => (await _addAll(
    [hive],
    plan,
    prescription: prescription,
    assignedTo: assignedTo,
    removalHiveId: hive.id,
  )).single;

  /// [plan]'ı [apiaryId] arılığındaki her aktif kovana tek transaction'da
  /// yazar ve kovan numarası sırasıyla döner. [prescription] verilirse
  /// [photoHiveId] kovanının (yoksa ilk kovanın) uygulamasına bağlanır.
  /// Planlanan çıkarma varsa arılığa tek çıkarma görevi açılır ve
  /// [assignedTo]'ya atanır. Aktif kovan yoksa bir şey yazmaz, boş döner.
  Future<List<Treatment>> addToApiary(
    String apiaryId,
    TreatmentPlan plan, {
    MediaCapture? prescription,
    String? photoHiveId,
    String? assignedTo,
  }) => db.transaction(() async {
    final hives =
        await (db.select(db.hives)
              ..where(
                (t) =>
                    t.apiaryId.equals(apiaryId) &
                    t.deletedAt.isNull() &
                    t.status.equalsValue(HiveStatus.active),
              )
              ..orderBy([(t) => OrderingTerm.asc(t.number)]))
            .get();
    return await _addAll(
      hives,
      plan,
      prescription: prescription,
      photoHiveId: photoHiveId,
      assignedTo: assignedTo,
    );
  });

  /// Geri al: [treatments]'ı, reçete fotoğraflarını ve çıkarma görevini
  /// tek transaction'da siler. Fotoğraf dosyası çağıranın.
  Future<void> deleteAll(Iterable<Treatment> treatments) =>
      db.transaction(() async {
        for (final treatment in treatments) {
          await delete(treatment.id);
        }
        await _media.removeByTreatments([for (final t in treatments) t.id]);
        for (final groupId in {for (final t in treatments) t.groupId}) {
          await _tasks.deleteBySource(TaskSource.treatment, groupId);
        }
      });

  /// Değerler sunucunun kısıtlarına uymazsa [ArgumentError] atar ve bir
  /// şey yazmaz.
  /// Çıkarma görevi [removalHiveId] kovanına (boşsa arılığa) bağlanır.
  Future<List<Treatment>> _addAll(
    List<Hive> hives,
    TreatmentPlan plan, {
    MediaCapture? prescription,
    String? photoHiveId,
    String? assignedTo,
    String? removalHiveId,
  }) {
    _check(plan);
    final drug = plan.drug;
    final batchNo = plan.batchNo?.trim();
    final applicationId = generateId();
    return db.transaction(() async {
      final at = now();
      final treatments = [
        for (final hive in hives)
          await insertRecord(
            Treatment(
              id: generateId(),
              orgId: hive.orgId,
              hiveId: hive.id,
              apiaryId: hive.apiaryId,
              refDrugId: drug.refDrugId,
              drugId: drug.drugId,
              applicationId: applicationId,
              productName: drug.name,
              activeIngredient: drug.activeIngredient,
              batchNo: batchNo == null || batchNo.isEmpty ? null : batchNo,
              dose: plan.dose,
              doseUnit: drug.doseUnit,
              startedAt: plan.startedAt.toUtc(),
              plannedRemovalAt: plan.plannedRemovalAt?.toUtc(),
              withdrawalDays: plan.withdrawalDays,
              createdAt: at,
              updatedAt: at,
            ),
          ),
      ];
      if (prescription != null && treatments.isNotEmpty) {
        final target = treatments.firstWhere(
          (t) => t.hiveId == photoHiveId,
          orElse: () => treatments.first,
        );
        await _media.add(
          orgId: target.orgId,
          hiveId: target.hiveId,
          treatmentId: target.id,
          capture: prescription,
        );
      }
      final removalDueAt = treatmentRemovalDueAt(
        plan.plannedRemovalAt,
        now: clock(),
      );
      if (removalDueAt != null && treatments.isNotEmpty) {
        final first = treatments.first;
        await _tasks.addTreatmentRemoval(
          orgId: first.orgId,
          groupId: applicationId,
          apiaryId: first.apiaryId,
          hiveId: removalHiveId,
          dueAt: removalDueAt,
          assignedTo: assignedTo,
        );
      }
      return treatments;
    });
  }

  static void _check(TreatmentPlan plan) {
    final drug = plan.drug;
    if ((drug.refDrugId == null) == (drug.drugId == null)) {
      throw ArgumentError.value(drug, 'drug', 'Tek bir listeden olmalı');
    }
    if (drug.name.trim().isEmpty) {
      throw ArgumentError.value(drug.name, 'drug.name');
    }
    if (!(plan.dose > 0)) throw ArgumentError.value(plan.dose, 'dose');
    if (plan.withdrawalDays < 0 || plan.withdrawalDays > maxWithdrawalDays) {
      throw ArgumentError.value(plan.withdrawalDays, 'withdrawalDays');
    }
    if (plan.plannedRemovalAt case final removal?
        when removal.isBefore(plan.startedAt)) {
      throw ArgumentError.value(removal, 'plannedRemovalAt');
    }
  }
}
