import 'package:drift/drift.dart';
import 'package:drift_dev/api/migrations_native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mobil_arici/core/db/app_database.dart';

import 'generated/schema.dart';
import 'generated/schema_v1.dart' as v1;
import 'generated/schema_v2.dart' as v2;
import 'generated/schema_v3.dart' as v3;
import 'generated/schema_v4.dart' as v4;
import 'generated/schema_v5.dart' as v5;
import 'generated/schema_v6.dart' as v6;
import 'generated/schema_v7.dart' as v7;

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

  test("v2 → v3 muayeneleri, taslakları ve outbox'ı korur; medya, yükleme "
      'kuyruğu ve yerel ayarlar boş gelir', () async {
    const inspection = v2.InspectionsData(
      id: 'inspection-1',
      createdAt: '2026-10-24T09:00:00.000Z',
      updatedAt: '2026-10-24T09:00:00.000Z',
      orgId: 'org-1',
      hiveId: 'hive-1',
      apiaryId: 'apiary-1',
      inspectedAt: '2026-10-24T09:00:00.000Z',
      beeFrames: 7,
      data: '{"actions":["fed"]}',
    );
    const draft = v2.InspectionDraftsData(
      hiveId: 'hive-2',
      orgId: 'org-1',
      draft: '{"values":{"bee_frames":5},"suggested":[]}',
      updatedAt: '2026-10-24T09:00:00.000Z',
    );
    const pending = v2.OutboxData(
      id: 1,
      recordTable: 'inspections',
      recordId: 'inspection-1',
      operation: 'upsert',
      payload: '{"id":"inspection-1"}',
      createdAt: '2026-10-24T09:00:00.000Z',
      attempts: 0,
    );

    await verifier.testWithDataIntegrity(
      oldVersion: 2,
      newVersion: 3,
      createOld: v2.DatabaseAtV2.new,
      createNew: v3.DatabaseAtV3.new,
      openTestedDatabase: AppDatabase.new,
      createItems: (batch, oldDb) {
        batch
          ..insert(oldDb.inspections, inspection)
          ..insert(oldDb.inspectionDrafts, draft)
          ..insert(oldDb.outbox, pending);
      },
      validateItems: (newDb) async {
        Future<List<Map<String, dynamic>>> rows(
          ResultSetImplementation<HasResultSet, DataClass> table,
        ) async => [
          for (final row in await newDb.select(table).get()) row.toJson(),
        ];

        expect(await rows(newDb.inspections), [inspection.toJson()]);
        expect(await rows(newDb.inspectionDrafts), [draft.toJson()]);
        expect(await rows(newDb.outbox), [pending.toJson()]);
        expect(await rows(newDb.media), isEmpty);
        expect(await rows(newDb.mediaUploads), isEmpty);
        expect(await rows(newDb.localSettings), isEmpty);
      },
    );
  });
  test("v3 → v4 medyayı, yerel ayarları ve outbox'ı korur; varroa ölçümleri "
      'boş gelir', () async {
    const media = v3.MediaData(
      id: 'media-1',
      createdAt: '2026-10-25T09:00:00.000Z',
      updatedAt: '2026-10-25T09:00:00.000Z',
      orgId: 'org-1',
      hiveId: 'hive-1',
      kind: 'photo',
      storagePath: 'org-1/hive-1/media-1.jpg',
      capturedAt: '2026-10-25T09:00:00.000Z',
      byteSize: 1000,
    );
    const setting = v3.LocalSettingsData(key: 'media_wifi_only', value: 'true');
    const pending = v3.OutboxData(
      id: 1,
      recordTable: 'media',
      recordId: 'media-1',
      operation: 'upsert',
      payload: '{"id":"media-1"}',
      createdAt: '2026-10-25T09:00:00.000Z',
      attempts: 0,
    );

    await verifier.testWithDataIntegrity(
      oldVersion: 3,
      newVersion: 4,
      createOld: v3.DatabaseAtV3.new,
      createNew: v4.DatabaseAtV4.new,
      openTestedDatabase: AppDatabase.new,
      createItems: (batch, oldDb) {
        batch
          ..insert(oldDb.media, media)
          ..insert(oldDb.localSettings, setting)
          ..insert(oldDb.outbox, pending);
      },
      validateItems: (newDb) async {
        Future<List<Map<String, dynamic>>> rows(
          ResultSetImplementation<HasResultSet, DataClass> table,
        ) async => [
          for (final row in await newDb.select(table).get()) row.toJson(),
        ];

        expect(await rows(newDb.media), [media.toJson()]);
        expect(await rows(newDb.localSettings), [setting.toJson()]);
        expect(await rows(newDb.outbox), [pending.toJson()]);
        expect(await rows(newDb.miteCounts), isEmpty);
      },
    );
  });
  test("v4 → v5 varroa ölçümlerini ve outbox'ı korur; ilaç tabloları boş "
      'gelir', () async {
    const count = v4.MiteCountsData(
      id: 'count-1',
      createdAt: '2026-10-25T09:00:00.000Z',
      updatedAt: '2026-10-25T09:00:00.000Z',
      orgId: 'org-1',
      hiveId: 'hive-1',
      apiaryId: 'apiary-1',
      countedAt: '2026-10-25T09:00:00.000Z',
      method: 'sugar_roll',
      mites: 9,
      sampleBees: 300,
    );
    const pending = v4.OutboxData(
      id: 1,
      recordTable: 'mite_counts',
      recordId: 'count-1',
      operation: 'upsert',
      payload: '{"id":"count-1"}',
      createdAt: '2026-10-25T09:00:00.000Z',
      attempts: 0,
    );

    await verifier.testWithDataIntegrity(
      oldVersion: 4,
      newVersion: 5,
      createOld: v4.DatabaseAtV4.new,
      createNew: v5.DatabaseAtV5.new,
      openTestedDatabase: AppDatabase.new,
      createItems: (batch, oldDb) {
        batch
          ..insert(oldDb.miteCounts, count)
          ..insert(oldDb.outbox, pending);
      },
      validateItems: (newDb) async {
        Future<List<Map<String, dynamic>>> rows(
          ResultSetImplementation<HasResultSet, DataClass> table,
        ) async => [
          for (final row in await newDb.select(table).get()) row.toJson(),
        ];

        expect(await rows(newDb.miteCounts), [count.toJson()]);
        expect(await rows(newDb.outbox), [pending.toJson()]);
        expect(await rows(newDb.refDrugs), isEmpty);
        expect(await rows(newDb.drugs), isEmpty);
        expect(await rows(newDb.treatments), isEmpty);
      },
    );
  });
  test('v5 → v6 uygulamaları ve medyayı korur; grup ve reçete bağı boş '
      'gelir', () async {
    const treatment = v5.TreatmentsData(
      id: 'treatment-1',
      createdAt: '2026-10-25T09:00:00.000Z',
      updatedAt: '2026-10-25T09:00:00.000Z',
      orgId: 'org-1',
      hiveId: 'hive-1',
      apiaryId: 'apiary-1',
      refDrugId: 'ref-1',
      productName: 'Amitraz şerit',
      activeIngredient: 'amitraz',
      dose: 2,
      doseUnit: 'strip',
      startedAt: '2026-10-25T09:00:00.000Z',
      withdrawalDays: 0,
    );
    const media = v5.MediaData(
      id: 'media-1',
      createdAt: '2026-10-25T09:00:00.000Z',
      updatedAt: '2026-10-25T09:00:00.000Z',
      orgId: 'org-1',
      hiveId: 'hive-1',
      kind: 'photo',
      storagePath: 'org-1/hive-1/media-1.jpg',
      capturedAt: '2026-10-25T09:00:00.000Z',
      byteSize: 1000,
    );

    await verifier.testWithDataIntegrity(
      oldVersion: 5,
      newVersion: 6,
      createOld: v5.DatabaseAtV5.new,
      createNew: v6.DatabaseAtV6.new,
      openTestedDatabase: AppDatabase.new,
      createItems: (batch, oldDb) {
        batch
          ..insert(oldDb.treatments, treatment)
          ..insert(oldDb.media, media);
      },
      validateItems: (newDb) async {
        final treatments = await newDb.select(newDb.treatments).get();
        expect(treatments.single.toJson(), {
          ...treatment.toJson(),
          'applicationId': null,
        });
        final rows = await newDb.select(newDb.media).get();
        expect(rows.single.toJson(), {...media.toJson(), 'treatmentId': null});
      },
    );
  });

  test(
    "v6 → v7 uygulamaları ve outbox'ı korur; besleme tablosu boş gelir",
    () async {
      const treatment = v6.TreatmentsData(
        id: 'treatment-1',
        createdAt: '2026-10-25T09:00:00.000Z',
        updatedAt: '2026-10-25T09:00:00.000Z',
        orgId: 'org-1',
        hiveId: 'hive-1',
        apiaryId: 'apiary-1',
        refDrugId: 'ref-1',
        applicationId: 'application-1',
        productName: 'Amitraz şerit',
        activeIngredient: 'amitraz',
        dose: 2,
        doseUnit: 'strip',
        startedAt: '2026-10-25T09:00:00.000Z',
        withdrawalDays: 0,
      );

      await verifier.testWithDataIntegrity(
        oldVersion: 6,
        newVersion: 7,
        createOld: v6.DatabaseAtV6.new,
        createNew: v7.DatabaseAtV7.new,
        openTestedDatabase: AppDatabase.new,
        createItems: (batch, oldDb) {
          batch
            ..insert(oldDb.treatments, treatment)
            ..insert(
              oldDb.outbox,
              v6.OutboxCompanion.insert(
                recordTable: 'treatments',
                recordId: 'treatment-1',
                operation: 'upsert',
                payload: '{}',
                createdAt: '2026-10-25T09:00:00.000Z',
              ),
            );
        },
        validateItems: (newDb) async {
          final treatments = await newDb.select(newDb.treatments).get();
          expect(treatments.single.toJson(), treatment.toJson());
          final outbox = await newDb.select(newDb.outbox).get();
          expect(outbox.single.recordId, 'treatment-1');
          expect(await newDb.select(newDb.feedings).get(), isEmpty);
        },
      );
    },
  );
}
