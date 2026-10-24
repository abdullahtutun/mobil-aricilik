import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mobil_arici/core/db/app_database.dart';
import 'package:mobil_arici/features/inspections/data/inspection_draft_repository.dart';
import 'package:mobil_arici/features/inspections/data/inspection_reminder_repository.dart';
import 'package:mobil_arici/features/inspections/data/inspection_repository.dart';
import 'package:mobil_arici/features/inspections/domain/inspection.dart';
import 'package:mobil_arici/features/inspections/domain/inspection_draft.dart';
import 'package:mobil_arici/features/inspections/domain/inspection_rules.dart';

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
  late InspectionReminderRepository reminders;

  setUp(() {
    db = openTestDatabase();
    clock = TestClock();
    repository = InspectionRepository(db, clock: clock.call);
    drafts = InspectionDraftRepository(db, clock: clock.call);
    reminders = InspectionReminderRepository(db, clock: clock.call);
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
    test('muayeneyi siler, hatırlatmayı kaldırır, taslağı geri '
        'yazar', () async {
      final inspection = await add();
      await reminders.set(inspection, 7);

      await repository.undoAdd(inspection, _draft);

      expect(await repository.findById(inspection.id), isNull);
      expect(await reminders.findByInspection(inspection.id), isNull);
      expect(await drafts.find('hive-1'), _draft);
      expect(
        [for (final entry in await readOutbox(db)) entry.operation],
        [OutboxOperation.upsert, OutboxOperation.delete],
      );
    });

    test('silme outbox’a yazılamazsa hiçbiri değişmez', () async {
      final inspection = await add();
      await reminders.set(inspection, 7);
      await breakInsert('outbox');

      await expectLater(
        repository.undoAdd(inspection, _draft),
        throwsA(isA<SqliteException>()),
      );

      expect(await repository.findById(inspection.id), isNotNull);
      expect(await reminders.findByInspection(inspection.id), isNotNull);
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

  group('hatırlatma', () {
    test('gün sayısını ve zamanını saklar; yenisi eskisinin yerini alır, '
        'kaldırılır', () async {
      final inspection = await add();

      await reminders.set(inspection, 3);
      final reminder = await reminders.set(inspection, 7);

      expect(reminder.days, 7);
      expect(reminder.hiveId, 'hive-1');
      expect(reminder.orgId, 'org-1');
      expect(reminder.remindAt, reminderAt(inspection.inspectedAt, 7));
      expect(await db.select(db.inspectionReminders).get(), [reminder]);

      await reminders.clear(inspection.id);
      expect(await reminders.findByInspection(inspection.id), isNull);
      // Yalnız muayenenin kendisi gönderilir.
      expect(await readOutbox(db), hasLength(1));
    });
  });
}
