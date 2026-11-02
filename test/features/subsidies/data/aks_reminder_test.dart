import 'package:drift/drift.dart' hide isNotNull, isNull;
import 'package:flutter_test/flutter_test.dart';
import 'package:mobil_arici/core/db/app_database.dart';
import 'package:mobil_arici/features/apiaries/data/apiary_repository.dart';
import 'package:mobil_arici/features/apiaries/domain/apiary.dart';
import 'package:mobil_arici/features/hives/data/hive_repository.dart';
import 'package:mobil_arici/features/hives/domain/hive.dart';
import 'package:mobil_arici/features/migration/data/transport_repository.dart';
import 'package:mobil_arici/features/subsidies/domain/subsidy_rules.dart';
import 'package:mobil_arici/features/tasks/data/task_repository.dart';
import 'package:mobil_arici/features/tasks/domain/task.dart';

import '../../../helpers/test_database.dart';

const _org = 'org-1';

void main() {
  late AppDatabase db;
  late TestClock clock;
  late TaskRepository tasks;
  late HiveRepository hives;
  late ApiaryRepository apiaries;
  late Apiary kizilcam;
  late Apiary yayla;

  /// İşletmenin silinmemiş AKS görevleri.
  Future<List<Task>> aksTasks() =>
      (db.select(db.tasks)..where(
            (t) =>
                t.source.equalsValue(TaskSource.aksUpdate) &
                t.deletedAt.isNull(),
          ))
          .get();

  setUp(() async {
    db = openTestDatabase();
    clock = TestClock(DateTime.utc(2026, 11, 5, 9));
    tasks = TaskRepository(db, clock: clock.call);
    hives = HiveRepository(db, clock: clock.call, aksReminders: true);
    apiaries = ApiaryRepository(db, clock: clock.call, aksReminders: true);
    final plain = ApiaryRepository(db, clock: clock.call);
    kizilcam = await plain.create(
      orgId: _org,
      name: 'Kızılçam',
      latitude: 37.1,
      longitude: 28.4,
    );
    yayla = await plain.create(orgId: _org, name: 'Yayla');
  });

  Future<Hive> plainHive({HiveStatus status = HiveStatus.active}) =>
      HiveRepository(db, clock: clock.call).create(
        orgId: _org,
        number: '1',
        type: HiveType.langstroth,
        apiaryId: kizilcam.id,
        status: status,
      );

  group('TaskRepository.remindAksUpdate', () {
    test('işletmeye ertesi gün 09:00 için atanmamış görev açar ve '
        "outbox'a yazar", () async {
      final task = await tasks.remindAksUpdate(_org);
      expect(task.source, TaskSource.aksUpdate);
      expect(task.sourceId, _org);
      expect(task.title, isNull);
      expect(task.assignedTo, isNull);
      expect(task.dueAt, aksTaskDueAt(clock.current));

      final outbox = await readOutbox(db);
      expect(outbox.last.recordTable, 'tasks');
      expect(outbox.last.payload['source'], 'aks_update');
      expect(outbox.last.payload['source_id'], _org);
    });

    test('açık görev varken yenisi açılmaz; tamamlanınca ya da silinince '
        'yenisi açılır', () async {
      final first = await tasks.remindAksUpdate(_org);
      expect((await tasks.remindAksUpdate(_org)).id, first.id);
      expect(await aksTasks(), hasLength(1));

      await tasks.setCompleted(first, completed: true);
      final second = await tasks.remindAksUpdate(_org);
      expect(second.id, isNot(first.id));

      await tasks.delete(second.id);
      final third = await tasks.remindAksUpdate(_org);
      expect({first.id, second.id}, isNot(contains(third.id)));
    });

    test('başka işletmenin açık görevi sayılmaz', () async {
      await tasks.remindAksUpdate('org-2');
      await tasks.remindAksUpdate(_org);
      expect(await aksTasks(), hasLength(2));
    });
  });

  group('HiveRepository', () {
    test("aktif kovan oluşturma görevi kovanla aynı transaction'da açar; "
        'toplu oluşturma tek görev açar', () async {
      await hives.create(
        orgId: _org,
        number: '1',
        type: HiveType.langstroth,
        apiaryId: kizilcam.id,
      );
      await hives.createMany(
        orgId: _org,
        apiaryId: kizilcam.id,
        numbers: ['2', '3', '4'],
        type: HiveType.langstroth,
      );
      expect(await aksTasks(), hasLength(1));
    });

    test('aktif olmayan kovan oluşturmak görev açmaz', () async {
      await hives.create(
        orgId: _org,
        number: '1',
        type: HiveType.langstroth,
        apiaryId: kizilcam.id,
        status: HiveStatus.dead,
      );
      expect(await aksTasks(), isEmpty);
    });

    test('aktiflikten çıkan ya da giren durum görev açar; aktif olmayan '
        'durumlar arası geçiş açmaz', () async {
      final hive = await plainHive();
      await hives.setStatus(hive.id, HiveStatus.dead);
      expect(await aksTasks(), hasLength(1));

      await tasks.setCompleted((await aksTasks()).single, completed: true);
      await hives.setStatus(hive.id, HiveStatus.sold);
      expect(
        (await aksTasks()).where((task) => task.completedAt == null),
        isEmpty,
      );

      await hives.setStatus(hive.id, HiveStatus.active);
      expect(
        (await aksTasks()).where((task) => task.completedAt == null),
        hasLength(1),
      );
    });

    test('düzenlemede durum ya da arılık değişirse görev açar, başka alan '
        'değişirse açmaz', () async {
      final hive = await plainHive();
      await hives.update(hive.copyWith(boxCount: 3));
      expect(await aksTasks(), isEmpty);

      await hives.update(hive.copyWith(apiaryId: yayla.id));
      expect(await aksTasks(), hasLength(1));
    });

    test('aktif kovanın taşınması görev açar, ölü kovanınki açmaz', () async {
      final dead = await plainHive(status: HiveStatus.dead);
      await hives.move(dead.id, apiaryId: yayla.id);
      expect(await aksTasks(), isEmpty);

      final active = await plainHive();
      await hives.move(active.id, apiaryId: yayla.id);
      expect(await aksTasks(), hasLength(1));
    });

    test('aksReminders kapalıyken (TR dışı) görev açılmaz', () async {
      final other = HiveRepository(db, clock: clock.call);
      final hive = await other.create(
        orgId: _org,
        number: '1',
        type: HiveType.langstroth,
        apiaryId: kizilcam.id,
      );
      await other.setStatus(hive.id, HiveStatus.dead);
      await other.move(hive.id, apiaryId: yayla.id);
      expect(await aksTasks(), isEmpty);
    });

    test('görev yazılamazsa kovan da yazılmaz', () async {
      await db.customStatement(
        'CREATE TRIGGER block_tasks BEFORE INSERT ON tasks '
        "BEGIN SELECT RAISE(ABORT, 'engellendi'); END",
      );
      await expectLater(
        hives.create(
          orgId: _org,
          number: '9',
          type: HiveType.langstroth,
          apiaryId: kizilcam.id,
        ),
        throwsA(isA<Exception>()),
      );
      expect(await db.select(db.hives).get(), isEmpty);
    });

    test('watchActiveCount yalnız silinmemiş aktif kovanları sayar', () async {
      final counts = hives.watchActiveCount(_org);
      await plainHive();
      final dead = await plainHive();
      await hives.setStatus(dead.id, HiveStatus.dead);
      final removed = await plainHive();
      await hives.delete(removed.id);
      expect(await counts.first, 1);
    });
  });

  group('ApiaryRepository.update', () {
    test('konum değişirse görev açar; başka alan değişirse açmaz', () async {
      await apiaries.update(kizilcam.copyWith(notes: 'Yol bozuk'));
      expect(await aksTasks(), isEmpty);

      await apiaries.update(kizilcam.copyWith(latitude: 37.2));
      expect(await aksTasks(), hasLength(1));
    });

    test('konumsuz arılığa konum eklemek görev açar', () async {
      await apiaries.update(yayla.copyWith(latitude: 40.5, longitude: 39.1));
      expect(await aksTasks(), hasLength(1));
    });

    test('aksReminders kapalıyken açmaz', () async {
      await ApiaryRepository(
        db,
        clock: clock.call,
      ).update(kizilcam.copyWith(latitude: 37.2));
      expect(await aksTasks(), isEmpty);
    });
  });

  test('taşıma indirilip bitince görev açılır', () async {
    final hive = await plainHive();
    final transports = TransportRepository(
      db,
      clock: clock.call,
      aksReminders: true,
    );
    final transport = await transports.start(
      orgId: _org,
      sourceApiaryId: kizilcam.id,
      destinationApiaryId: yayla.id,
      vehicles: ['Kamyon 1'],
    );
    await transports.load(transport.id, hiveId: hive.id, vehicle: 'Kamyon 1');
    await transports.startUnloading(transport.id);
    await transports.unload(transport.id, hiveId: hive.id);
    expect(await aksTasks(), isEmpty);

    expect(await transports.complete(transport.id), 1);
    expect(await aksTasks(), hasLength(1));
  });
}
