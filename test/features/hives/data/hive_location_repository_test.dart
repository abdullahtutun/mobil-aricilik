import 'package:flutter_test/flutter_test.dart';
import 'package:mobil_arici/core/db/app_database.dart';
import 'package:mobil_arici/features/hives/data/hive_location_repository.dart';

import '../../../helpers/test_database.dart';

void main() {
  late AppDatabase db;
  late HiveLocationRepository repository;

  setUp(() {
    db = openTestDatabase();
    repository = HiveLocationRepository(db, clock: TestClock().call);
  });

  test('ekler; taşınma zamanı UTC saklanır ve gönderilir', () async {
    final movedAt = DateTime(2026, 5, 1, 6, 30);
    final entry = await repository.add(
      orgId: 'org-1',
      hiveId: 'hive-1',
      apiaryId: 'apiary-1',
      movedAt: movedAt,
    );

    expect(entry.movedAt.isUtc, isTrue);
    expect(entry.movedAt, movedAt.toUtc());
    expect(await repository.findById(entry.id), entry);

    final outbox = (await readOutbox(db)).single;
    expect(outbox.recordTable, 'hive_location_history');
    expect(outbox.operation, OutboxOperation.upsert);
    expect(
      outbox.payload,
      containsPair('moved_at', movedAt.toUtc().toIso8601String()),
    );
  });

  test('watchByHive yalnız o kovanın kayıtları, en yeni önce', () async {
    Future<void> add(String hiveId, String apiaryId, int month) =>
        repository.add(
          orgId: 'org-1',
          hiveId: hiveId,
          apiaryId: apiaryId,
          movedAt: DateTime.utc(2026, month),
        );

    await add('hive-1', 'yayla', 6);
    await add('hive-1', 'ova', 3);
    await add('hive-1', 'kıyı', 9);
    await add('hive-2', 'ova', 4);

    final history = await repository.watchByHive('hive-1').first;
    expect(history.map((e) => e.apiaryId), ['kıyı', 'yayla', 'ova']);
  });

  test('yanlış kayıt yumuşak silinir', () async {
    final entry = await repository.add(
      orgId: 'org-1',
      hiveId: 'hive-1',
      apiaryId: 'apiary-1',
      movedAt: DateTime.utc(2026, 5),
    );

    await repository.delete(entry.id);

    expect(await repository.watchByHive('hive-1').first, isEmpty);
    final outbox = await readOutbox(db);
    expect(outbox.last.operation, OutboxOperation.delete);
    expect(outbox.last.payload['deleted_at'], isNotNull);
  });
}
