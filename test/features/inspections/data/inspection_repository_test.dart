import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mobil_arici/core/db/app_database.dart';
import 'package:mobil_arici/features/health/domain/withdrawal.dart';
import 'package:mobil_arici/features/hives/data/hive_repository.dart';
import 'package:mobil_arici/features/hives/domain/hive.dart';
import 'package:mobil_arici/features/inspections/data/inspection_draft_repository.dart';
import 'package:mobil_arici/features/inspections/data/inspection_repository.dart';
import 'package:mobil_arici/features/inspections/domain/inspection.dart';
import 'package:mobil_arici/features/inspections/domain/inspection_draft.dart';
import 'package:mobil_arici/features/media/data/media_repository.dart';
import 'package:mobil_arici/features/media/domain/media_item.dart';
import 'package:mobil_arici/features/tasks/data/task_repository.dart';
import 'package:mobil_arici/features/tasks/domain/task.dart';

import '../../../helpers/test_database.dart';

const _values = InspectionValues(
  queenState: QueenState.eggs,
  beeFrames: 8,
  broodFrames: 5,
  honeyFrames: 0,
  temperament: Temperament.calm,
  swarmSigns: false,
  queenCells: QueenCells.none,
  diseaseSuspected: false,
  actions: {InspectionAction.fed, InspectionAction.superAdded},
);

const _draft = InspectionDraft(
  values: _values,
  suggested: {InspectionField.honeyFrames},
);

void main() {
  late AppDatabase db;
  late TestClock clock;
  late InspectionRepository repository;
  late InspectionDraftRepository drafts;
  late TaskRepository tasks;

  setUp(() {
    db = openTestDatabase();
    clock = TestClock();
    repository = InspectionRepository(db, clock: clock.call);
    drafts = InspectionDraftRepository(db, clock: clock.call);
    tasks = TaskRepository(db, clock: clock.call);
  });

  Future<Inspection> add({String hiveId = 'hive-1'}) => repository.add(
    orgId: 'org-1',
    hiveId: hiveId,
    apiaryId: 'apiary-1',
    values: _values,
  );

  Future<void> breakInsert(String table) => db.customStatement(
    'CREATE TRIGGER ${table}_fails BEFORE INSERT ON $table '
    "BEGIN SELECT RAISE(ABORT, '$table kapalı'); END",
  );

  group('kaydetme', () {
    test('muayeneyi şimdi yapılmış olarak yazar; outbox payload’u sunucunun '
        'kolonlarıyla, data bir nesne', () async {
      final inspection = await add();

      expect(inspection.inspectedAt, clock.current);
      expect(inspection.values, _values);
      final entry = (await readOutbox(db)).single;
      expect(entry.recordTable, 'inspections');
      expect(entry.recordId, inspection.id);
      expect(entry.operation, OutboxOperation.upsert);
      expect(entry.payload, {
        'id': inspection.id,
        'org_id': 'org-1',
        'hive_id': 'hive-1',
        'apiary_id': 'apiary-1',
        'inspected_at': '2026-10-22T09:00:00.000Z',
        'queen_state': 'eggs',
        'bee_frames': 8,
        'brood_frames': 5,
        'honey_frames': 0,
        'temperament': 'calm',
        'swarm_signs': false,
        'queen_cells': 'none',
        'disease_suspected': false,
        'data': {
          'actions': ['super_added', 'fed'],
        },
        'created_at': '2026-10-22T09:00:00.000Z',
        'updated_at': '2026-10-22T09:00:00.000Z',
        'created_by': null,
        'deleted_at': null,
      });
    });

    test('bekleme süresi geçildiyse gerekçe muayenenin data’sıyla '
        'outbox’a gider', () async {
      const override = WithdrawalOverride(
        treatmentId: 'treatment-1',
        reason: WithdrawalOverrideReason.notForSale,
      );

      final inspection = await repository.add(
        orgId: 'org-1',
        hiveId: 'hive-1',
        apiaryId: 'apiary-1',
        values: _values,
        withdrawalOverride: override,
      );

      expect(inspection.withdrawalOverride, override);
      expect(
        (await readOutbox(db)).single.payload['data'],
        containsPair('withdrawal_override', {
          'treatment_id': 'treatment-1',
          'reason': 'not_for_sale',
        }),
      );
    });

    test('bakılmayan alanlar boş kalır', () async {
      final inspection = await repository.add(
        orgId: 'org-1',
        hiveId: 'hive-1',
        apiaryId: 'apiary-1',
        values: const InspectionValues(),
      );

      expect(await repository.findById(inspection.id), inspection);
      expect(inspection.values, const InspectionValues());
      expect(inspection.data, isEmpty);
    });

    test('kovanın taslağını aynı transaction’da siler', () async {
      await drafts.save(orgId: 'org-1', hiveId: 'hive-1', draft: _draft);
      await drafts.save(orgId: 'org-1', hiveId: 'hive-2', draft: _draft);

      await add();

      expect(await drafts.find('hive-1'), isNull);
      expect(await drafts.find('hive-2'), _draft);
    });

    test('outbox yazılamazsa muayene yazılmaz, taslak kalır', () async {
      await drafts.save(orgId: 'org-1', hiveId: 'hive-1', draft: _draft);
      await breakInsert('outbox');

      await expectLater(add(), throwsA(isA<SqliteException>()));

      expect(await db.select(db.inspections).get(), isEmpty);
      expect(await drafts.find('hive-1'), _draft);
    });
  });

  group('son muayene', () {
    test('kovanın en yeni silinmemiş muayenesi; başka kovanınki '
        'değil', () async {
      expect(await repository.latestByHive('hive-1'), isNull);

      final first = await add();
      clock.advance(const Duration(days: 7));
      final second = await add();
      clock.advance(const Duration(days: 1));
      await add(hiveId: 'hive-2');

      expect(await repository.latestByHive('hive-1'), second);

      await repository.delete(second.id);
      expect(await repository.latestByHive('hive-1'), first);
    });

    test('aynı anda yapılanlardan kimliği büyük olan', () async {
      final first = await add();
      final second = await add();

      expect(second.id.compareTo(first.id), greaterThan(0));
      expect(await repository.latestByHive('hive-1'), second);
    });
  });

  group('kovanın muayeneleri', () {
    test('en yeni önce; silinen ve başka kovanınki yok', () async {
      final first = await add();
      clock.advance(const Duration(days: 3));
      final second = await add();
      clock.advance(const Duration(days: 3));
      final deleted = await add();
      await add(hiveId: 'hive-2');
      await repository.delete(deleted.id);

      expect(await repository.watchByHive('hive-1').first, [second, first]);
      expect(await repository.watchByHive('yok').first, isEmpty);
    });

    test('yeni muayene ve silme akışa düşer', () async {
      final ids = repository
          .watchByHive('hive-1')
          .map((list) => [for (final i in list) i.id]);
      final first = await add();
      clock.advance(const Duration(days: 1));
      final expectation = expectLater(
        ids,
        emitsInOrder([
          [first.id],
          [isNotNull, first.id],
          [first.id],
        ]),
      );
      await pumpEventQueue();
      final second = await add();
      await pumpEventQueue();
      await repository.delete(second.id);

      await expectation;
    });
  });

  group('arılığın son muayeneleri', () {
    late HiveRepository hives;

    setUp(() => hives = HiveRepository(db, clock: clock.call));

    Future<Hive> createHive(String number, {String apiaryId = 'yayla'}) =>
        hives.create(
          orgId: 'org-1',
          number: number,
          type: HiveType.langstroth,
          apiaryId: apiaryId,
        );

    Future<Inspection> inspect(Hive hive, {int beeFrames = 5}) =>
        repository.add(
          orgId: 'org-1',
          hiveId: hive.id,
          apiaryId: hive.apiaryId,
          values: InspectionValues(beeFrames: beeFrames),
        );

    test('arılıktaki her kovanın en yeni muayenesi; muayenesiz ve başka '
        'arılıktaki kovan yok', () async {
      final a = await createHive('1');
      final b = await createHive('2');
      await createHive('3');
      final other = await createHive('4', apiaryId: 'ova');
      await inspect(a, beeFrames: 3);
      await inspect(b);
      clock.advance(const Duration(days: 7));
      final aLatest = await inspect(a, beeFrames: 8);
      await inspect(other);

      final latest = await repository.watchLatestByApiary('yayla').first;

      expect(latest.keys, unorderedEquals([a.id, b.id]));
      expect(latest[a.id], aLatest);
      expect(latest[a.id], await repository.latestByHive(a.id));
      expect(latest[b.id], await repository.latestByHive(b.id));
      expect(await repository.watchLatestByApiary('boş').first, isEmpty);
    });

    test('en yeni muayene silinince bir öncekine döner; hepsi silinince '
        'kovan çıkar', () async {
      final hive = await createHive('1');
      final first = await inspect(hive);
      clock.advance(const Duration(days: 1));
      final second = await inspect(hive);

      await repository.delete(second.id);
      expect(await repository.watchLatestByApiary('yayla').first, {
        hive.id: first,
      });

      await repository.delete(first.id);
      expect(await repository.watchLatestByApiary('yayla').first, isEmpty);
    });

    test('aynı anda yapılanlardan kimliği büyük olan; latestByHive ile '
        'aynı', () async {
      final hive = await createHive('1');
      await inspect(hive);
      final second = await inspect(hive);

      expect(await repository.watchLatestByApiary('yayla').first, {
        hive.id: second,
      });
      expect(await repository.latestByHive(hive.id), second);
    });

    test('muayene kovanın şimdiki arılığına sayılır: taşınan kovan eski '
        'arılıktan çıkar, yenisine girer; silinen kovan yok', () async {
      final moved = await createHive('1');
      final deleted = await createHive('2');
      final inspection = await inspect(moved);
      await inspect(deleted);
      await hives.delete(deleted.id);

      expect(await repository.watchLatestByApiary('yayla').first, {
        moved.id: inspection,
      });

      await hives.move(moved.id, apiaryId: 'ova');

      expect(await repository.watchLatestByApiary('yayla').first, isEmpty);
      expect(await repository.watchLatestByApiary('ova').first, {
        moved.id: inspection,
      });
    });

    test('akış kovan taşınınca da yeniden yayar (kovan tablosunu da '
        'izler)', () async {
      final hive = await createHive('1');
      final keys = repository
          .watchLatestByApiary('ova')
          .map((latest) => latest.keys.toList());
      // Taşıma muayene tablosuna yazmaz; son değer yalnız kovan tablosundaki
      // değişiklikten gelebilir.
      final expectation = expectLater(
        keys,
        emitsInOrder([
          isEmpty,
          emitsThrough([hive.id]),
        ]),
      );
      await pumpEventQueue();
      await inspect(hive);
      await pumpEventQueue();
      await hives.move(hive.id, apiaryId: 'ova');

      await expectation;
    });

    test('işletmenin son muayeneleri: her arılıktan, başka işletme ve '
        'silinen kovan yok', () async {
      final yayla = await createHive('1');
      final ova = await createHive('2', apiaryId: 'ova');
      final deleted = await createHive('3');
      final foreign = await hives.create(
        orgId: 'org-2',
        number: '9',
        type: HiveType.langstroth,
        apiaryId: 'başka',
      );
      await inspect(yayla, beeFrames: 3);
      clock.advance(const Duration(days: 1));
      final yaylaLatest = await inspect(yayla);
      final ovaLatest = await inspect(ova);
      await inspect(deleted);
      await hives.delete(deleted.id);
      await repository.add(
        orgId: 'org-2',
        hiveId: foreign.id,
        apiaryId: foreign.apiaryId,
        values: const InspectionValues(beeFrames: 5),
      );

      expect(await repository.watchLatestByOrg('org-1').first, {
        yayla.id: yaylaLatest,
        ova.id: ovaLatest,
      });
    });
  });

  test('silme yumuşak; outbox’a silme olarak gider', () async {
    final inspection = await add();
    clock.advance(const Duration(minutes: 1));

    await repository.delete(inspection.id);

    expect(await repository.findById(inspection.id), isNull);
    final row = await db.select(db.inspections).getSingle();
    expect(row.deletedAt, clock.current);
    final entry = (await readOutbox(db)).last;
    expect(entry.operation, OutboxOperation.delete);
    expect(entry.payload['deleted_at'], '2026-10-22T09:01:00.000Z');
  });

  group('geri alma', () {
    test('muayeneyi ve "tekrar bak" görevini siler, taslağı geri '
        'yazar', () async {
      final inspection = await add();
      await tasks.remindAfterInspection(inspection, 7);

      await repository.undoAdd(inspection, _draft);

      expect(await repository.findById(inspection.id), isNull);
      expect(
        await tasks.findBySource(TaskSource.inspection, inspection.id),
        isEmpty,
      );
      expect(await drafts.find('hive-1'), _draft);
      expect(
        [
          for (final entry in await readOutbox(db))
            (entry.recordTable, entry.operation),
        ],
        [
          ('inspections', OutboxOperation.upsert),
          ('tasks', OutboxOperation.upsert),
          ('inspections', OutboxOperation.delete),
          ('tasks', OutboxOperation.delete),
        ],
      );
    });

    test('silme outbox’a yazılamazsa hiçbiri değişmez', () async {
      final inspection = await add();
      await tasks.remindAfterInspection(inspection, 7);
      await breakInsert('outbox');

      await expectLater(
        repository.undoAdd(inspection, _draft),
        throwsA(isA<SqliteException>()),
      );

      expect(await repository.findById(inspection.id), isNotNull);
      expect(
        await tasks.findBySource(TaskSource.inspection, inspection.id),
        hasLength(1),
      );
      expect(await drafts.find('hive-1'), isNull);
    });
  });

  group('taslak', () {
    test('kovan başına tek taslak; yenisi eskisinin yerini alır', () async {
      await drafts.save(orgId: 'org-1', hiveId: 'hive-1', draft: _draft);
      const newer = InspectionDraft(values: InspectionValues(beeFrames: 3));
      clock.advance(const Duration(minutes: 1));
      await drafts.save(orgId: 'org-1', hiveId: 'hive-1', draft: newer);

      expect(await drafts.find('hive-1'), newer);
      final row = await db.select(db.inspectionDrafts).getSingle();
      expect(row.updatedAt, clock.current);
      expect(row.orgId, 'org-1');
    });

    test('silinir; yalnız bu telefonda, outbox’a yazılmaz', () async {
      await drafts.save(orgId: 'org-1', hiveId: 'hive-1', draft: _draft);
      await drafts.discard('hive-1');
      await drafts.discard('hive-1');

      expect(await drafts.find('hive-1'), isNull);
      expect(await readOutbox(db), isEmpty);
    });
  });

  group('medya', () {
    final photo = MediaCapture(
      fileName: 'p.jpg',
      kind: MediaKind.photo,
      capturedAt: DateTime.utc(2026, 10, 22, 8, 58),
      byteSize: 300000,
    );
    final voice = MediaCapture(
      fileName: 'v.m4a',
      kind: MediaKind.audio,
      capturedAt: DateTime.utc(2026, 10, 22, 8, 59),
      byteSize: 40000,
      durationMs: 9000,
    );

    test('muayenede çekilenler muayeneye bağlı yazılır; outbox’ta muayene '
        'medyadan önce', () async {
      final inspection = await repository.add(
        orgId: 'org-1',
        hiveId: 'hive-1',
        apiaryId: 'apiary-1',
        values: _values,
        media: [photo, voice],
      );

      final media = await MediaRepository(db).watchByHive('hive-1').first;
      expect(media.map((m) => m.inspectionId), [inspection.id, inspection.id]);
      expect(media.map((m) => m.kind), [MediaKind.photo, MediaKind.audio]);
      expect((await readOutbox(db)).map((e) => e.recordTable), [
        'inspections',
        'media',
        'media',
      ]);
      expect(await db.select(db.mediaUploads).get(), hasLength(2));
    });

    test('medya yazılamazsa muayene de yazılmaz, taslak kalır', () async {
      await drafts.save(orgId: 'org-1', hiveId: 'hive-1', draft: _draft);
      await breakInsert('media_uploads');

      await expectLater(
        repository.add(
          orgId: 'org-1',
          hiveId: 'hive-1',
          apiaryId: 'apiary-1',
          values: _values,
          media: [photo],
        ),
        throwsA(isA<Exception>()),
      );
      expect(await db.select(db.inspections).get(), isEmpty);
      expect(await db.select(db.media).get(), isEmpty);
      expect(await drafts.find('hive-1'), isNotNull);
    });

    test('geri alma medyayı da siler ve yüklemesini kaldırır; taslak '
        'çekimleriyle döner', () async {
      final draft = _draft.copyWith(media: [photo]);
      final inspection = await repository.add(
        orgId: 'org-1',
        hiveId: 'hive-1',
        apiaryId: 'apiary-1',
        values: _values,
        media: draft.media,
      );

      await repository.undoAdd(inspection, draft);

      expect(await MediaRepository(db).watchByHive('hive-1').first, isEmpty);
      expect(await db.select(db.mediaUploads).get(), isEmpty);
      expect((await drafts.find('hive-1'))!.media, [photo]);
    });
  });
}
