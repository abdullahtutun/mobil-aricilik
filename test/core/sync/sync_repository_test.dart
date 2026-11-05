import 'package:drift/drift.dart' show Value;
import 'package:flutter_test/flutter_test.dart';
import 'package:mobil_arici/core/db/app_database.dart';
import 'package:mobil_arici/core/sync/sync_repository.dart';
import 'package:mobil_arici/features/apiaries/data/apiary_repository.dart';
import 'package:mobil_arici/features/hives/data/hive_repository.dart';
import 'package:mobil_arici/features/hives/domain/hive.dart';

import '../../helpers/test_database.dart';

void main() {
  late AppDatabase db;
  late ApiaryRepository apiaries;
  late SyncRepository repository;

  setUp(() {
    db = openTestDatabase();
    apiaries = ApiaryRepository(
      db,
      clock: TestClock(DateTime.utc(2026, 10, 23, 9)).call,
    );
    repository = SyncRepository(db);
  });

  /// [entryId]'li outbox kaydını sunucu reddetmiş gibi işaretler.
  Future<void> reject(int entryId, String error) =>
      (db.update(db.outbox)..where((t) => t.id.equals(entryId))).write(
        OutboxCompanion(lastError: Value(error)),
      );

  test('bekleyen sayısı yazmalarla artar, reddedilenleri saymaz', () async {
    final counts = <int>[];
    final subscription = repository.watchPendingCount().listen(counts.add);
    addTearDown(subscription.cancel);
    await pumpEventQueue();

    final apiary = await apiaries.create(orgId: 'org-1', name: 'Yayla');
    await pumpEventQueue();
    await apiaries.delete(apiary.id);
    await pumpEventQueue();
    await reject(1, 'forbidden: RLS');
    await pumpEventQueue();

    expect(counts, [0, 1, 2, 1]);
  });

  test('bekleyenler tabloya göre sayılır, reddedilenler sayılmaz', () async {
    final apiary = await apiaries.create(orgId: 'org-1', name: 'Yayla');
    await apiaries.create(orgId: 'org-1', name: 'Ova');
    await HiveRepository(db).create(
      orgId: 'org-1',
      apiaryId: apiary.id,
      number: '1',
      type: HiveType.langstroth,
    );
    await reject(1, 'forbidden: RLS');

    expect(await repository.watchPendingByTable().first, {
      'apiaries': 1,
      'hives': 1,
      'hive_location_history': 1,
    });
  });

  test(
    'en eski bekleyen kaydın anı; reddedilen ve gönderilen sayılmaz',
    () async {
      expect(await repository.watchOldestPendingAt().first, isNull);

      final clock = TestClock(DateTime.utc(2026, 10, 20, 9));
      final repo = ApiaryRepository(db, clock: clock.call);
      await repo.create(orgId: 'org-1', name: 'Yayla');
      clock.advance(const Duration(days: 1));
      await repo.create(orgId: 'org-1', name: 'Ova');
      expect(
        await repository.watchOldestPendingAt().first,
        DateTime.utc(2026, 10, 20, 9),
      );

      await reject(1, 'invalid: bad');
      expect(
        await repository.watchOldestPendingAt().first,
        DateTime.utc(2026, 10, 21, 9),
      );

      await db.delete(db.outbox).go();
      expect(await repository.watchOldestPendingAt().first, isNull);
    },
  );

  test('reddedilen kayıtlar sırasıyla, tablo ve nedeniyle gelir', () async {
    final first = await apiaries.create(orgId: 'org-1', name: 'Yayla');
    final second = await apiaries.create(orgId: 'org-1', name: 'Ova');
    await reject(2, 'conflict: duplicate');
    await reject(1, 'invalid: bad');

    final rejected = await repository.watchRejected().first;

    expect(rejected.map((record) => record.recordId), [first.id, second.id]);
    expect(rejected.map((record) => record.table), everyElement('apiaries'));
    expect(rejected.map((record) => record.error), [
      'invalid: bad',
      'conflict: duplicate',
    ]);
    expect(rejected.first.createdAt, DateTime.utc(2026, 10, 23, 9));
  });

  test('ilk tam çekme işareti yazılınca bitti sayılır', () async {
    final done = <bool>[];
    final subscription = repository.watchFullPullDone().listen(done.add);
    addTearDown(subscription.cancel);
    await pumpEventQueue();

    // Tablo imleçleri işaret sayılmaz.
    await db
        .into(db.syncState)
        .insert(SyncStateCompanion.insert(recordTable: 'hives'));
    await db
        .into(db.syncState)
        .insert(SyncStateCompanion.insert(recordTable: fullPullMarker));
    await pumpEventQueue();

    expect(done.first, isFalse);
    expect(done.last, isTrue);
  });

  test('yerel yazma olayı yalnız outbox’a kayıt eklenince gelir', () async {
    var writes = 0;
    final subscription = repository.watchLocalWrites().listen((_) => writes++);
    addTearDown(subscription.cancel);

    await apiaries.create(orgId: 'org-1', name: 'Yayla');
    await pumpEventQueue();
    expect(writes, 1);

    // Senkronun kendi işaretleme ve silmeleri yerel yazma değil.
    await reject(1, 'invalid: bad');
    await db.delete(db.outbox).go();
    await pumpEventQueue();
    expect(writes, 1);
  });
}
