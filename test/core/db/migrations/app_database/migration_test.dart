import 'package:drift/drift.dart';
import 'package:drift_dev/api/migrations_native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mobil_arici/core/db/app_database.dart';

import 'generated/schema.dart';
import 'generated/schema_v1.dart' as v1;
import 'generated/schema_v2.dart' as v2;

// Dökümler ve `generated/` `dart run drift_dev make-migrations` ile üretilir;
// her yeni sürümde bu testlere yeni sürümün veri testi eklenir.
void main() {
  driftRuntimeOptions.dontWarnAboutMultipleDatabases = true;
  late SchemaVerifier verifier;

  setUpAll(() => verifier = SchemaVerifier(GeneratedHelper()));

  // Boş DB'de: migration sonrası şema, hedef sürümün dökümüyle aynı.
  const versions = GeneratedHelper.versions;
  for (final (i, from) in versions.indexed) {
    for (final to in versions.skip(i + 1)) {
      test('v$from → v$to şemayı o sürümün dökümüyle aynı kurar', () async {
        final schema = await verifier.schemaAt(from);
        final db = AppDatabase(schema.newConnection());
        await verifier.migrateAndValidate(db, to);
        await db.close();
      });
    }
  }

  test('v1 → v2 kovanları, bekleyen outbox kayıtlarını ve imleçleri korur; '
      'muayene tabloları boş gelir', () async {
    const hive = v1.HivesData(
      id: 'hive-1',
      createdAt: '2026-10-22T09:00:00.000Z',
      updatedAt: '2026-10-22T09:00:00.000Z',
      orgId: 'org-1',
      number: '101',
      type: 'langstroth',
      status: 'active',
      apiaryId: 'apiary-1',
      boxCount: 1,
    );
    const pending = v1.OutboxData(
      id: 1,
      recordTable: 'hives',
      recordId: 'hive-1',
      operation: 'upsert',
      payload: '{"id":"hive-1"}',
      createdAt: '2026-10-22T09:00:00.000Z',
      attempts: 2,
      lastError: 'forbidden: RLS',
    );
    const cursor = v1.SyncStateData(recordTable: 'hives', lastPulledSeq: 42);

    await verifier.testWithDataIntegrity(
      oldVersion: 1,
      newVersion: 2,
      createOld: v1.DatabaseAtV1.new,
      createNew: v2.DatabaseAtV2.new,
      openTestedDatabase: AppDatabase.new,
      createItems: (batch, oldDb) {
        batch
          ..insert(oldDb.hives, hive)
          ..insert(oldDb.outbox, pending)
          ..insert(oldDb.syncState, cursor);
      },
      validateItems: (newDb) async {
        Future<List<Map<String, dynamic>>> rows(
          ResultSetImplementation<HasResultSet, DataClass> table,
        ) async => [
          for (final row in await newDb.select(table).get()) row.toJson(),
        ];

        expect(await rows(newDb.hives), [hive.toJson()]);
        expect(await rows(newDb.outbox), [pending.toJson()]);
        expect(await rows(newDb.syncState), [cursor.toJson()]);
        expect(await rows(newDb.inspections), isEmpty);
        expect(await rows(newDb.inspectionDrafts), isEmpty);
        expect(await rows(newDb.inspectionReminders), isEmpty);
      },
    );
  });
}
