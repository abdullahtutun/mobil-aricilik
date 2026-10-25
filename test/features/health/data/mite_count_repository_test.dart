import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mobil_arici/core/db/app_database.dart';
import 'package:mobil_arici/features/health/data/mite_count_repository.dart';
import 'package:mobil_arici/features/health/domain/mite_count.dart';

import '../../../helpers/test_database.dart';

void main() {
  late AppDatabase db;
  late TestClock clock;
  late MiteCountRepository repository;

  setUp(() {
    db = openTestDatabase();
    clock = TestClock();
    repository = MiteCountRepository(db, clock: clock.call);
  });

  Future<MiteCount> add({
    String hiveId = 'hive-1',
    String apiaryId = 'apiary-1',
    MiteCountMethod method = MiteCountMethod.sugarRoll,
    int mites = 9,
    int? sampleBees = 300,
    int? days,
  }) => repository.add(
    orgId: 'org-1',
    hiveId: hiveId,
    apiaryId: apiaryId,
    method: method,
    mites: mites,
    sampleBees: sampleBees,
    days: days,
  );

  group('kaydetme', () {
    test('ölçümü şimdi yapılmış olarak yazar; outbox payload’u sunucunun '
        'kolonlarıyla', () async {
      final count = await add();

      expect(count.countedAt, clock.current);
      expect(await repository.findById(count.id), count);
      final entry = (await readOutbox(db)).single;
      expect(entry.recordTable, 'mite_counts');
      expect(entry.recordId, count.id);
      expect(entry.operation, OutboxOperation.upsert);
      expect(entry.payload, {
        'id': count.id,
        'org_id': 'org-1',
        'hive_id': 'hive-1',
        'apiary_id': 'apiary-1',
        'counted_at': '2026-10-22T09:00:00.000Z',
        'method': 'sugar_roll',
        'mites': 9,
        'sample_bees': 300,
        'days': null,
        'created_at': '2026-10-22T09:00:00.000Z',
        'updated_at': '2026-10-22T09:00:00.000Z',
        'created_by': null,
        'deleted_at': null,
      });
    });

    test('alt tablada gün yazılır, örnek arı yok sayılır', () async {
      final count = await add(
        method: MiteCountMethod.stickyBoard,
        mites: 30,
        days: 3,
      );

      expect(count.days, 3);
      expect(count.sampleBees, isNull);
      expect((await readOutbox(db)).single.payload, containsPair('days', 3));
    });

    test('örnekli yöntemde gün yok sayılır', () async {
      final count = await add(method: MiteCountMethod.alcoholWash, days: 3);

      expect(count.days, isNull);
      expect(count.sampleBees, 300);
    });

    test('örnek arı, gün ya da akar eksik veya geçersizse bir şey '
        'yazmaz', () async {
      expect(() => add(sampleBees: null), throwsArgumentError);
      expect(() => add(sampleBees: 0), throwsArgumentError);
      expect(
        () => add(method: MiteCountMethod.stickyBoard),
        throwsArgumentError,
      );
      expect(() => add(mites: -1), throwsArgumentError);

      expect(await db.select(db.miteCounts).get(), isEmpty);
      expect(await readOutbox(db), isEmpty);
    });

    test('outbox yazılamazsa ölçüm yazılmaz', () async {
      await db.customStatement(
        'CREATE TRIGGER outbox_fails BEFORE INSERT ON outbox '
        "BEGIN SELECT RAISE(ABORT, 'outbox kapalı'); END",
      );

      await expectLater(add(), throwsA(isA<SqliteException>()));

      expect(await db.select(db.miteCounts).get(), isEmpty);
    });
  });

  test('silme yumuşak: satır kalır, okumalarda görünmez, outbox’a silme '
      'gider', () async {
    final count = await add();
    clock.advance(const Duration(seconds: 5));

    await repository.delete(count.id);

    expect(await repository.findById(count.id), isNull);
    final row = await db.select(db.miteCounts).getSingle();
    expect(row.deletedAt, clock.current);
    final outbox = await readOutbox(db);
    expect(outbox.map((e) => e.operation), [
      OutboxOperation.upsert,
      OutboxOperation.delete,
    ]);
  });

  test('kovanın ölçümleri en yeni önce; başka kovanınki ve silinen '
      'yok', () async {
    final first = await add();
    clock.advance(const Duration(days: 7));
    final second = await add(mites: 4);
    await add(hiveId: 'hive-2');
    final deleted = await add();
    await repository.delete(deleted.id);

    expect(await repository.watchByHive('hive-1').first, [second, first]);
  });

  test('arılığın ölçümleri eskisi önce; kovan başka arılıkta '
      'ölçülünce o arılıkta', () async {
    final first = await add();
    clock.advance(const Duration(days: 1));
    final second = await add(hiveId: 'hive-2');
    clock.advance(const Duration(days: 1));
    await add(apiaryId: 'apiary-2');

    expect(await repository.watchByApiary('apiary-1').first, [first, second]);
  });

  test('akış yeni ölçüm ve silmeyle güncellenir', () async {
    final updates = repository.watchByApiary('apiary-1');
    expect(await updates.first, isEmpty);

    final count = await add();
    expect(await updates.first, [count]);

    await repository.delete(count.id);
    expect(await updates.first, isEmpty);
  });
}
