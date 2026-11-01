import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mobil_arici/core/db/app_database.dart';
import 'package:mobil_arici/features/apiaries/data/apiary_repository.dart';
import 'package:mobil_arici/features/hives/data/hive_repository.dart';
import 'package:mobil_arici/features/hives/domain/hive.dart';
import 'package:mobil_arici/features/inspections/data/inspection_repository.dart';
import 'package:mobil_arici/features/inspections/domain/inspection.dart';
import 'package:mobil_arici/features/inspections/domain/inspection_rules.dart';
import 'package:mobil_arici/features/tasks/data/task_repository.dart';
import 'package:mobil_arici/features/tasks/domain/task.dart';
import 'package:mobil_arici/features/tasks/domain/task_rules.dart';

import '../../../helpers/test_database.dart';

void main() {
  late AppDatabase db;
  late TestClock clock;
  late TaskRepository repository;

  setUp(() {
    db = openTestDatabase();
    clock = TestClock();
    repository = TaskRepository(db, clock: clock.call);
  });

  Future<Task> create({
    String title = 'Yayla arılığını ziyaret et',
    DateTime? dueAt,
    String orgId = 'org-1',
    String? apiaryId,
    String? hiveId,
    String? assignedTo,
  }) => repository.create(
    orgId: orgId,
    title: title,
    dueAt: dueAt ?? DateTime.utc(2026, 10, 24, 9),
    apiaryId: apiaryId,
    hiveId: hiveId,
    assignedTo: assignedTo,
  );

  Future<void> breakOutbox() => db.customStatement(
    'CREATE TRIGGER outbox_fails BEFORE INSERT ON outbox '
    "BEGIN SELECT RAISE(ABORT, 'outbox kapalı'); END",
  );

  group('elle görev', () {
    test('yazar; outbox payload’u sunucunun kolonlarıyla, başlık kırpılır, '
        'zaman UTC', () async {
      final task = await create(
        title: '  Kovan 103’e ana ver ',
        dueAt: DateTime.utc(2026, 10, 24, 9),
        apiaryId: 'apiary-1',
        hiveId: 'hive-1',
        assignedTo: 'user-1',
      );

      expect(await repository.findById(task.id), task);
      final entry = (await readOutbox(db)).single;
      expect(entry.operation, OutboxOperation.upsert);
      expect(entry.payload, {
        'id': task.id,
        'org_id': 'org-1',
        'due_at': '2026-10-24T09:00:00.000Z',
        'created_at': '2026-10-22T09:00:00.000Z',
        'updated_at': '2026-10-22T09:00:00.000Z',
        'source': 'manual',
        'title': 'Kovan 103’e ana ver',
        'apiary_id': 'apiary-1',
        'hive_id': 'hive-1',
        'assigned_to': 'user-1',
        'completed_at': null,
        'source_id': null,
        'ref_drug_id': null,
        'drug_id': null,
        'dose': null,
        'created_by': null,
        'deleted_at': null,
      });
    });

    test('boş ya da çok uzun başlık, arılıksız kovan yazılmaz', () async {
      expect(() => create(title: '   '), throwsArgumentError);
      expect(
        () => create(title: 'a' * (maxTaskTitleLength + 1)),
        throwsArgumentError,
      );
      expect(() => create(hiveId: 'hive-1'), throwsArgumentError);

      expect(await db.select(db.tasks).get(), isEmpty);
      expect(await readOutbox(db), isEmpty);
    });

    test('outbox yazılamazsa görev yazılmaz', () async {
      await breakOutbox();

      await expectLater(create(), throwsA(isA<SqliteException>()));

      expect(await db.select(db.tasks).get(), isEmpty);
    });

    test('güncelleme alanları yazar, updated_at ilerler, kimlik ve kaynak '
        'değişmez', () async {
      final task = await create();
      clock.advance(const Duration(minutes: 1));

      final updated = await repository.update(
        task.copyWith(
          title: ' Ova ',
          dueAt: DateTime.utc(2026, 10, 25, 10),
          assignedTo: 'user-2',
        ),
      );

      expect(updated.title, 'Ova');
      expect(updated.dueAt, DateTime.utc(2026, 10, 25, 10));
      expect(updated.assignedTo, 'user-2');
      expect(updated.updatedAt, clock.current);
      expect(updated.createdAt, task.createdAt);
      expect(updated.source, TaskSource.manual);
      expect((await readOutbox(db)).last.payload['title'], 'Ova');
    });

    test('tamamlanır ve yeniden açılır', () async {
      final task = await create();
      clock.advance(const Duration(minutes: 1));

      final done = await repository.setCompleted(task, completed: true);
      expect(done.completedAt, clock.current);

      final reopened = await repository.setCompleted(done, completed: false);
      expect(reopened.completedAt, isNull);
      expect(
        [for (final e in await readOutbox(db)) e.payload['completed_at']],
        [null, '2026-10-22T09:01:00.000Z', null],
      );
    });

    test('silme yumuşak; silinen görev bulunmaz ve güncellenemez', () async {
      final task = await create();

      await repository.delete(task.id);

      expect(await repository.findById(task.id), isNull);
      expect((await db.select(db.tasks).getSingle()).deletedAt, isNotNull);
      expect((await readOutbox(db)).last.operation, OutboxOperation.delete);
      await expectLater(repository.update(task), throwsStateError);
    });
  });

  group('açık görevler', () {
    test('işletmenin açık görevleri son tarih sırasıyla, arılık adı ve '
        'kovan numarasıyla; tamamlanan, silinen ve başka işletmeninki '
        'yok', () async {
      final apiary = await ApiaryRepository(
        db,
        clock: clock.call,
      ).create(orgId: 'org-1', name: 'Kızılçam');
      final hive = await HiveRepository(db, clock: clock.call).create(
        orgId: 'org-1',
        number: '103',
        type: HiveType.langstroth,
        apiaryId: apiary.id,
      );
      final later = await create(
        title: 'Kovan 103’e ana ver',
        dueAt: DateTime.utc(2026, 10, 26),
        apiaryId: apiary.id,
        hiveId: hive.id,
      );
      final sooner = await create(
        title: 'Şeker al',
        dueAt: DateTime.utc(2026, 10, 23),
      );
      final done = await create(title: 'Bitti');
      await repository.setCompleted(done, completed: true);
      final deleted = await create(title: 'Silindi');
      await repository.delete(deleted.id);
      await create(title: 'Başkası', orgId: 'org-2');

      final views = await repository.watchOpen('org-1').first;

      expect([for (final v in views) v.task.id], [sooner.id, later.id]);
      expect(views.last.apiaryName, 'Kızılçam');
      expect(views.last.hiveNumber, '103');
      expect(views.first.apiaryName, isNull);
    });

    test('silinmiş arılığın adı gösterilmez; görev kalır', () async {
      final apiaries = ApiaryRepository(db, clock: clock.call);
      final apiary = await apiaries.create(orgId: 'org-1', name: 'Ova');
      await create(apiaryId: apiary.id);
      await apiaries.delete(apiary.id);

      final views = await repository.watchOpen('org-1').first;
      expect(views.single.apiaryName, isNull);
    });

    test('tamamlanan görev akıştan düşer; senkronla gelen görev '
        'akışa girer', () async {
      final task = await create();
      final stream = repository.watchOpen('org-1');
      final emissions = <List<String>>[];
      final subscription = stream.listen(
        (views) => emissions.add([for (final v in views) v.task.id]),
      );
      addTearDown(subscription.cancel);
      await pumpEventQueue();

      await repository.setCompleted(task, completed: true);
      await pumpEventQueue();
      // Senkron satırı doğrudan tabloya yazar.
      await db
          .into(db.tasks)
          .insert(
            Task(
              id: 'pulled',
              orgId: 'org-1',
              title: 'Ekipten',
              dueAt: DateTime.utc(2026, 10, 25),
              createdAt: clock.current,
              updatedAt: clock.current,
              serverSeq: 7,
            ).toInsertable(),
          );
      await pumpEventQueue();

      expect(emissions, [
        [task.id],
        <String>[],
        ['pulled'],
      ]);
    });
  });

  group('muayeneden "tekrar bak"', () {
    late Inspection inspection;

    setUp(() async {
      inspection = await InspectionRepository(db, clock: clock.call).add(
        orgId: 'org-1',
        hiveId: 'hive-1',
        apiaryId: 'apiary-1',
        values: const InspectionValues(beeFrames: 6),
      );
    });

    test('muayeneden X gün sonra aynı saatte, kovana ve arılığa bağlı, '
        'başlıksız görev', () async {
      final task = await repository.remindAfterInspection(
        inspection,
        7,
        assignedTo: 'user-1',
      );

      expect(task.source, TaskSource.inspection);
      expect(task.sourceId, inspection.id);
      expect(task.title, isNull);
      expect(task.hiveId, 'hive-1');
      expect(task.apiaryId, 'apiary-1');
      expect(task.assignedTo, 'user-1');
      expect(task.dueAt, reminderAt(inspection.inspectedAt, 7));
    });

    test('yeniden seçilince aynı görevin günü değişir', () async {
      final first = await repository.remindAfterInspection(inspection, 3);
      clock.advance(const Duration(seconds: 2));

      final second = await repository.remindAfterInspection(inspection, 14);

      expect(second.id, first.id);
      expect(second.dueAt, reminderAt(inspection.inspectedAt, 14));
      expect(
        await repository.findBySource(TaskSource.inspection, inspection.id),
        [second],
      );
    });

    test('kaldırılınca görev silinir; başka muayenenin görevi kalır', () async {
      await repository.remindAfterInspection(inspection, 7);
      final other = await create();

      await repository.deleteBySource(TaskSource.inspection, inspection.id);

      expect(
        await repository.findBySource(TaskSource.inspection, inspection.id),
        isEmpty,
      );
      expect(await repository.findById(other.id), isNotNull);
    });
  });

  group('arılık turu', () {
    test('createMany hepsini tek transaction’da yazar', () async {
      final tasks = await repository.createMany('org-1', [
        (
          title: 'Ana ver: 103',
          dueAt: DateTime.utc(2026, 10, 23, 9),
          apiaryId: 'apiary-1',
          hiveId: 'hive-3',
          assignedTo: 'user-1',
        ),
        (
          title: 'Atlanan kovanlara bak: 104, 110',
          dueAt: DateTime.utc(2026, 10, 23, 9),
          apiaryId: 'apiary-1',
          hiveId: null,
          assignedTo: 'user-1',
        ),
      ]);

      expect(
        [for (final t in tasks) t.title],
        ['Ana ver: 103', 'Atlanan kovanlara bak: 104, 110'],
      );
      expect(
        [for (final t in tasks) t.source],
        [TaskSource.manual, TaskSource.manual],
      );
      expect(await readOutbox(db), hasLength(2));
    });

    test('createMany: biri geçersizse hiçbiri yazılmaz', () async {
      await expectLater(
        repository.createMany('org-1', [
          (
            title: 'Ana ver: 103',
            dueAt: DateTime.utc(2026, 10, 23, 9),
            apiaryId: 'apiary-1',
            hiveId: null,
            assignedTo: null,
          ),
          (
            title: '  ',
            dueAt: DateTime.utc(2026, 10, 23, 9),
            apiaryId: 'apiary-1',
            hiveId: null,
            assignedTo: null,
          ),
        ]),
        throwsArgumentError,
      );

      expect(await db.select(db.tasks).get(), isEmpty);
      expect(await readOutbox(db), isEmpty);
    });

    test('watchBySources yalnız verilen kaynakların silinmemiş görevlerini '
        'son tarih sırasıyla verir', () async {
      final inspections = InspectionRepository(db, clock: clock.call);
      Future<Inspection> inspect(String hiveId) => inspections.add(
        orgId: 'org-1',
        hiveId: hiveId,
        apiaryId: 'apiary-1',
        values: const InspectionValues(beeFrames: 6),
      );
      final a = await inspect('hive-1');
      final b = await inspect('hive-2');
      final c = await inspect('hive-3');
      final late = await repository.remindAfterInspection(a, 14);
      final soon = await repository.remindAfterInspection(b, 3);
      await repository.remindAfterInspection(c, 7);
      final deleted = await repository.remindAfterInspection(
        await inspect('hive-4'),
        7,
      );
      await repository.delete(deleted.id);

      final tasks = await repository.watchBySources(TaskSource.inspection, [
        a.id,
        b.id,
        deleted.sourceId!,
      ]).first;

      expect([for (final t in tasks) t.id], [soon.id, late.id]);
    });
  });

  group('planlı ilaçlama', () {
    late HiveRepository hives;

    setUp(() => hives = HiveRepository(db, clock: clock.call));

    Future<Hive> hive(
      String number, {
      String apiaryId = 'apiary-1',
      HiveStatus status = HiveStatus.active,
    }) => hives.create(
      orgId: 'org-1',
      number: number,
      type: HiveType.langstroth,
      apiaryId: apiaryId,
      status: status,
    );

    test("ilaç ve doz yazılır; outbox payload'unda", () async {
      final task = await repository.create(
        orgId: 'org-1',
        title: 'İlaçlama · Amitraz',
        dueAt: DateTime.utc(2026, 11, 5, 9),
        apiaryId: 'apiary-1',
        refDrugId: 'ref-drug-1',
        dose: 2,
      );

      expect(task.isPlannedTreatment, isTrue);
      expect(task.plannedDrugKey, 'ref-drug-1');
      final payload = (await readOutbox(db)).single.payload;
      expect(payload['ref_drug_id'], 'ref-drug-1');
      expect(payload['drug_id'], isNull);
      expect(payload['dose'], 2.0);
    });

    test('tutarsız ilaç alanlarında hiçbir şey yazmaz', () async {
      final invalid =
          <({String? apiaryId, String? ref, String? drug, double? dose})>[
            (apiaryId: 'apiary-1', ref: 'ref-drug-1', drug: null, dose: null),
            (apiaryId: 'apiary-1', ref: null, drug: null, dose: 2),
            (apiaryId: 'apiary-1', ref: 'ref-drug-1', drug: 'drug-1', dose: 2),
            (apiaryId: 'apiary-1', ref: 'ref-drug-1', drug: null, dose: 0),
            (apiaryId: 'apiary-1', ref: 'ref-drug-1', drug: null, dose: 10001),
            (apiaryId: null, ref: 'ref-drug-1', drug: null, dose: 2),
          ];
      for (final values in invalid) {
        expect(
          () => repository.create(
            orgId: 'org-1',
            title: 'İlaçlama',
            dueAt: DateTime.utc(2026, 11, 5, 9),
            apiaryId: values.apiaryId,
            refDrugId: values.ref,
            drugId: values.drug,
            dose: values.dose,
          ),
          throwsArgumentError,
          reason: '$values',
        );
      }

      expect(await db.select(db.tasks).get(), isEmpty);
    });

    test('açık planlı görevler kovan sayısıyla: arılıkta aktif kovanlar, '
        'kovana bağlıda 1; ilaçsız, tamamlanmış ve silinmiş görev '
        'yok', () async {
      final first = await hive('101');
      await hive('102');
      await hive('103', status: HiveStatus.dead);
      await hive('201', apiaryId: 'apiary-2');
      Future<Task> plan({String? hiveId, String apiaryId = 'apiary-1'}) =>
          repository.create(
            orgId: 'org-1',
            title: 'İlaçlama',
            dueAt: DateTime.utc(2026, 11, 5, 9),
            apiaryId: apiaryId,
            hiveId: hiveId,
            refDrugId: 'ref-drug-1',
            dose: 2,
          );
      final apiary = await plan();
      final single = await plan(hiveId: first.id);
      final empty = await plan(apiaryId: 'apiary-3');
      await create(apiaryId: 'apiary-1');
      await repository.setCompleted(await plan(), completed: true);
      await repository.delete((await plan()).id);
      await create(orgId: 'org-2');

      final planned = await repository
          .watchOpenPlannedTreatments('org-1')
          .first;

      expect(
        {for (final p in planned) p.task.id: p.hives},
        {apiary.id: 2, single.id: 1, empty.id: 0},
      );
    });
  });
}
