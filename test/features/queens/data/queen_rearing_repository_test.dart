import 'package:flutter_test/flutter_test.dart';
import 'package:mobil_arici/core/db/app_database.dart';
import 'package:mobil_arici/features/hives/data/hive_repository.dart';
import 'package:mobil_arici/features/hives/domain/hive.dart';
import 'package:mobil_arici/features/queens/data/queen_rearing_repository.dart';
import 'package:mobil_arici/features/queens/data/queen_repository.dart';
import 'package:mobil_arici/features/queens/domain/queen.dart';
import 'package:mobil_arici/features/queens/domain/queen_rearing.dart';
import 'package:mobil_arici/features/queens/domain/queen_rearing_rules.dart';
import 'package:mobil_arici/features/tasks/data/task_repository.dart';
import 'package:mobil_arici/features/tasks/domain/task.dart';

import '../../../helpers/test_database.dart';

void main() {
  late AppDatabase db;
  late TestClock clock;
  late QueenRearingRepository repository;
  late MatingNucRepository nucs;
  late TaskRepository tasks;
  late QueenRepository queens;
  late HiveRepository hives;

  setUp(() {
    db = openTestDatabase();
    clock = TestClock();
    repository = QueenRearingRepository(db, clock: clock.call);
    nucs = repository.nucs;
    tasks = TaskRepository(db, clock: clock.call);
    queens = QueenRepository(db, clock: clock.call);
    hives = HiveRepository(db, clock: clock.call);
  });

  Future<QueenRearingBatch> createBatch({
    String? motherQueenId,
    int graftedCount = 40,
    int? acceptedCount,
    DateTime? graftedOn,
    String? assignedTo,
  }) => repository.create(
    orgId: 'org-1',
    graftedOn: graftedOn ?? DateTime(2026, 5, 12),
    graftedCount: graftedCount,
    motherQueenId: motherQueenId,
    acceptedCount: acceptedCount,
    assignedTo: assignedTo,
  );

  Future<void> breakOutbox() => db.customStatement(
    'CREATE TRIGGER outbox_fails BEFORE INSERT ON outbox '
    "BEGIN SELECT RAISE(ABORT, 'outbox kapalı'); END",
  );

  group('seri', () {
    test('seriyi ve beş takvim görevini yazar; outbox payload’u sunucunun '
        'kolonlarıyla, gün saatsiz', () async {
      final batch = await createBatch(
        motherQueenId: 'queen-1',
        acceptedCount: 34,
        graftedOn: DateTime(2026, 5, 12, 14, 30),
        assignedTo: 'user-1',
      );

      final outbox = await readOutbox(db);
      expect(outbox.map((e) => e.recordTable), [
        'queen_rearing_batches',
        ...List.filled(5, 'tasks'),
      ]);
      expect(outbox.first.payload, {
        'id': batch.id,
        'org_id': 'org-1',
        'number': 1,
        'mother_queen_id': 'queen-1',
        'grafted_on': '2026-05-12',
        'grafted_count': 40,
        'accepted_count': 34,
        'created_at': '2026-10-22T09:00:00.000Z',
        'updated_at': '2026-10-22T09:00:00.000Z',
        'created_by': null,
        'deleted_at': null,
      });

      final steps = await tasks.findBySource(TaskSource.queenRearing, batch.id);
      expect(steps.map((task) => task.sourceStep), [1, 5, 10, 12, 24]);
      expect(
        steps.map((task) => task.dueAt.toLocal()),
        [13, 17, 22, 24, 36].map((day) => DateTime(2026, 5, day, 9)),
      );
      expect(steps.map((task) => task.assignedTo).toSet(), {'user-1'});
      expect(steps.map((task) => task.title).toSet(), {null});
      expect(outbox[1].payload['source'], 'queen_rearing');
      expect(outbox[1].payload['source_step'], 1);
    });

    test('numara işletmedeki en büyüğün bir fazlası; '
        'silinen sayılır', () async {
      final first = await createBatch();
      final second = await createBatch();
      await repository.remove(second.id);
      final third = await createBatch();
      final other = await repository.create(
        orgId: 'org-2',
        graftedOn: DateTime(2026, 5, 12),
        graftedCount: 10,
      );

      expect([first.number, second.number, third.number], [1, 2, 3]);
      expect(other.number, 1);
    });

    test('kabul aktarılandan fazlaysa ArgumentError, bir şey '
        'yazılmaz', () async {
      await expectLater(
        createBatch(graftedCount: 10, acceptedCount: 11),
        throwsArgumentError,
      );
      await expectLater(createBatch(graftedCount: 0), throwsArgumentError);
      expect(await readOutbox(db), isEmpty);
      expect(await db.select(db.tasks).get(), isEmpty);
    });

    test('outbox yazılamazsa seri ve görevler de yazılmaz', () async {
      await breakOutbox();
      await expectLater(createBatch(), throwsA(anything));
      expect(await db.select(db.queenRearingBatches).get(), isEmpty);
      expect(await db.select(db.tasks).get(), isEmpty);
    });

    test('aktarma günü değişince görevler yeni takvime kayar; tamamlanan '
        'görev tamamlanmış kalır', () async {
      final batch = await createBatch();
      final steps = await tasks.findBySource(TaskSource.queenRearing, batch.id);
      await tasks.setCompleted(steps.first, completed: true);

      await repository.update(batch.copyWith(graftedOn: DateTime(2026, 5, 14)));

      final moved = await tasks.findBySource(TaskSource.queenRearing, batch.id);
      expect(
        moved.map((task) => task.dueAt.toLocal()),
        [15, 19, 24, 26, 38].map((day) => DateTime(2026, 5, day, 9)),
      );
      expect(moved.first.completedAt, isNotNull);
    });

    test('yalnız sayılar değişince görevler yazılmaz', () async {
      final batch = await createBatch();
      final before = (await readOutbox(db)).length;

      await repository.update(batch.copyWith(acceptedCount: 30));

      final outbox = await readOutbox(db);
      expect(outbox.length, before + 1);
      expect(outbox.last.recordTable, 'queen_rearing_batches');
      expect(outbox.last.payload['accepted_count'], 30);
    });

    test('silme seriyi ve görevlerini yumuşak siler', () async {
      final batch = await createBatch();
      await repository.remove(batch.id);

      expect(await repository.findById(batch.id), isNull);
      expect(
        await tasks.findBySource(TaskSource.queenRearing, batch.id),
        isEmpty,
      );
      final deleted = await db.select(db.queenRearingBatches).getSingle();
      expect(deleted.deletedAt, isNotNull);
    });

    test('watchByOrg son aktarılanı önce yayar ve değişince '
        'güncellenir', () async {
      final older = await createBatch(graftedOn: DateTime(2026, 5));
      final stream = repository.watchByOrg('org-1');
      expect((await stream.first).map((b) => b.id), [older.id]);

      final newer = await createBatch(graftedOn: DateTime(2026, 6));
      expect((await stream.first).map((b) => b.id), [newer.id, older.id]);
    });
  });

  group('kutular', () {
    test('dağıtma boş kutuları kullanır, kalan için yeni kutu açar; hepsi '
        'meme ve seriye bağlı', () async {
      final first = await createBatch();
      final old = await nucs.distribute(
        batch: first,
        apiaryId: 'apiary-1',
        count: 3,
      );
      await nucs.setStatus(old[0], MatingNucStatus.failed);
      await nucs.setStatus(old[2], MatingNucStatus.empty);

      final second = await createBatch();
      final distributed = await nucs.distribute(
        batch: second,
        apiaryId: 'apiary-1',
        count: 4,
      );

      expect(distributed.map((nuc) => nuc.number), ['1', '3', '4', '5']);
      expect(distributed.map((nuc) => nuc.id).take(2), [old[0].id, old[2].id]);
      expect(
        distributed.map((nuc) => (nuc.status, nuc.rearingBatchId)).toSet(),
        {(MatingNucStatus.cell, second.id)},
      );
      expect(await nucs.findById(old[1].id), old[1]);
    });

    test('kutu payload’u sunucunun kolonlarıyla', () async {
      final batch = await createBatch();
      final nuc = (await nucs.distribute(
        batch: batch,
        apiaryId: 'apiary-1',
        count: 1,
      )).single;

      final outbox = await readOutbox(db);
      expect(outbox.last.recordTable, 'mating_nucs');
      expect(outbox.last.payload, {
        'id': nuc.id,
        'org_id': 'org-1',
        'number': '1',
        'apiary_id': 'apiary-1',
        'rearing_batch_id': batch.id,
        'status': 'cell',
        'queen_id': null,
        'created_at': '2026-10-22T09:00:00.000Z',
        'updated_at': '2026-10-22T09:00:00.000Z',
        'created_by': null,
        'deleted_at': null,
      });
    });

    test('"kovana verildi" elle yazılamaz; sayı 1’den küçükse '
        'dağıtılmaz', () async {
      final batch = await createBatch();
      final nuc = (await nucs.distribute(
        batch: batch,
        apiaryId: 'apiary-1',
        count: 1,
      )).single;

      expect(
        () => nucs.setStatus(nuc, MatingNucStatus.given),
        throwsArgumentError,
      );
      expect(
        () => nucs.distribute(batch: batch, apiaryId: 'apiary-1', count: 0),
        throwsArgumentError,
      );
    });

    test('yumurtlayan ana kovana verilir: anne ana, kendi üretimi, '
        'çiftleşmiş, aktarma yılının rengi; kutu verilmiş olur', () async {
      final mother = await queens.create(orgId: 'org-1', year: 2025);
      final batch = await createBatch(motherQueenId: mother.id);
      final nuc = (await nucs.distribute(
        batch: batch,
        apiaryId: 'apiary-1',
        count: 1,
      )).single;
      await nucs.setStatus(nuc, MatingNucStatus.laying);
      final oldQueen = await queens.create(orgId: 'org-1');
      final hive = await hives.create(
        orgId: 'org-1',
        number: '104',
        type: HiveType.langstroth,
        apiaryId: 'apiary-2',
        queenId: oldQueen.id,
      );

      final given = await nucs.giveQueen(nuc.id, hive.id);

      final queen = given.given.queen;
      expect(queen.motherQueenId, mother.id);
      expect(queen.source, QueenSource.ownRearing);
      expect(queen.matingStatus, QueenMatingStatus.mated);
      expect(queen.year, 2026);
      expect(queen.markColor, QueenMarkColor.white);
      expect((await hives.findById(hive.id))!.queenId, queen.id);
      expect(given.given.previousQueenId, oldQueen.id);
      final saved = (await nucs.findById(nuc.id))!;
      expect(saved.status, MatingNucStatus.given);
      expect(saved.queenId, queen.id);
    });

    test('yumurtlamayan kutudan ana verilemez; bir şey yazılmaz', () async {
      final batch = await createBatch();
      final nuc = (await nucs.distribute(
        batch: batch,
        apiaryId: 'apiary-1',
        count: 1,
      )).single;
      final hive = await hives.create(
        orgId: 'org-1',
        number: '104',
        type: HiveType.langstroth,
        apiaryId: 'apiary-2',
      );
      final before = (await readOutbox(db)).length;

      await expectLater(nucs.giveQueen(nuc.id, hive.id), throwsStateError);
      expect((await readOutbox(db)).length, before);
      expect(await db.select(db.queens).get(), isEmpty);
    });

    test('kovan yoksa ana yazılmaz, kutu yumurtluyor kalır', () async {
      final batch = await createBatch();
      final nuc = (await nucs.distribute(
        batch: batch,
        apiaryId: 'apiary-1',
        count: 1,
      )).single;
      await nucs.setStatus(nuc, MatingNucStatus.laying);

      await expectLater(nucs.giveQueen(nuc.id, 'hive-x'), throwsStateError);
      expect(await db.select(db.queens).get(), isEmpty);
      expect((await nucs.findById(nuc.id))!.status, MatingNucStatus.laying);
    });

    test('geri al: kovan eski anasına döner, ana silinir, kutu yeniden '
        'yumurtluyor', () async {
      final batch = await createBatch();
      final nuc = (await nucs.distribute(
        batch: batch,
        apiaryId: 'apiary-1',
        count: 1,
      )).single;
      await nucs.setStatus(nuc, MatingNucStatus.laying);
      final hive = await hives.create(
        orgId: 'org-1',
        number: '104',
        type: HiveType.langstroth,
        apiaryId: 'apiary-2',
      );
      final given = await nucs.giveQueen(nuc.id, hive.id);

      expect(await nucs.undoGiveQueen(given), isTrue);

      expect((await hives.findById(hive.id))!.queenId, isNull);
      expect(await queens.findById(given.given.queen.id), isNull);
      final saved = (await nucs.findById(nuc.id))!;
      expect(saved.status, MatingNucStatus.laying);
      expect(saved.queenId, isNull);
    });

    test('watchByBatch serinin kutularını yayar', () async {
      final batch = await createBatch();
      final stream = nucs.watchByBatch(batch.id);
      expect(await stream.first, isEmpty);

      await nucs.distribute(batch: batch, apiaryId: 'apiary-1', count: 2);
      expect((await stream.first).length, 2);
    });
  });

  test('takvim adımının görev zamanı kuralla aynı', () async {
    final batch = await createBatch();
    final step = (await tasks.findBySource(
      TaskSource.queenRearing,
      batch.id,
    )).firstWhere((task) => task.sourceStep == 10);
    expect(
      step.dueAt,
      rearingStepDueAt(batch.graftedOn, RearingStep.distribution),
    );
  });
}
