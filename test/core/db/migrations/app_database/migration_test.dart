import 'package:drift/drift.dart';
import 'package:drift_dev/api/migrations_native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mobil_arici/core/db/app_database.dart';

import 'generated/schema.dart';
import 'generated/schema_v1.dart' as v1;
import 'generated/schema_v10.dart' as v10;
import 'generated/schema_v11.dart' as v11;
import 'generated/schema_v12.dart' as v12;
import 'generated/schema_v13.dart' as v13;
import 'generated/schema_v14.dart' as v14;
import 'generated/schema_v15.dart' as v15;
import 'generated/schema_v16.dart' as v16;
import 'generated/schema_v17.dart' as v17;
import 'generated/schema_v18.dart' as v18;
import 'generated/schema_v19.dart' as v19;
import 'generated/schema_v2.dart' as v2;
import 'generated/schema_v20.dart' as v20;
import 'generated/schema_v21.dart' as v21;
import 'generated/schema_v22.dart' as v22;
import 'generated/schema_v23.dart' as v23;
import 'generated/schema_v3.dart' as v3;
import 'generated/schema_v4.dart' as v4;
import 'generated/schema_v5.dart' as v5;
import 'generated/schema_v6.dart' as v6;
import 'generated/schema_v7.dart' as v7;
import 'generated/schema_v8.dart' as v8;
import 'generated/schema_v9.dart' as v9;

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

  test("v7 → v8 beslemeleri ve outbox'ı korur; görev tablosu boş gelir, "
      'yalnız bu telefondaki muayene hatırlatmaları kalkar', () async {
    const feeding = v7.FeedingsData(
      id: 'feeding-1',
      createdAt: '2026-10-26T09:00:00.000Z',
      updatedAt: '2026-10-26T09:00:00.000Z',
      orgId: 'org-1',
      hiveId: 'hive-1',
      apiaryId: 'apiary-1',
      feedingGroupId: 'group-1',
      fedAt: '2026-10-26T09:00:00.000Z',
      kind: 'syrup_2_1',
      amount: 3,
    );

    await verifier.testWithDataIntegrity(
      oldVersion: 7,
      newVersion: 8,
      createOld: v7.DatabaseAtV7.new,
      createNew: v8.DatabaseAtV8.new,
      openTestedDatabase: AppDatabase.new,
      createItems: (batch, oldDb) {
        batch
          ..insert(oldDb.feedings, feeding)
          ..insert(
            oldDb.inspectionReminders,
            const v7.InspectionRemindersData(
              inspectionId: 'inspection-1',
              orgId: 'org-1',
              hiveId: 'hive-1',
              days: 7,
              remindAt: '2026-11-02T09:00:00.000Z',
              createdAt: '2026-10-26T09:00:00.000Z',
            ),
          )
          ..insert(
            oldDb.outbox,
            v7.OutboxCompanion.insert(
              recordTable: 'feedings',
              recordId: 'feeding-1',
              operation: 'upsert',
              payload: '{}',
              createdAt: '2026-10-26T09:00:00.000Z',
            ),
          );
      },
      validateItems: (newDb) async {
        final feedings = await newDb.select(newDb.feedings).get();
        expect(feedings.single.toJson(), feeding.toJson());
        final outbox = await newDb.select(newDb.outbox).get();
        expect(outbox.single.recordId, 'feeding-1');
        expect(await newDb.select(newDb.tasks).get(), isEmpty);
      },
    );
  });

  test(
    "v8 → v9 görevleri ve outbox'ı korur; hasat tabloları boş gelir",
    () async {
      const task = v8.TasksData(
        id: 'task-1',
        createdAt: '2026-10-26T09:00:00.000Z',
        updatedAt: '2026-10-26T09:00:00.000Z',
        orgId: 'org-1',
        title: 'Şerit çıkar',
        dueAt: '2026-11-05T09:00:00.000Z',
        source: 'manual',
      );

      await verifier.testWithDataIntegrity(
        oldVersion: 8,
        newVersion: 9,
        createOld: v8.DatabaseAtV8.new,
        createNew: v9.DatabaseAtV9.new,
        openTestedDatabase: AppDatabase.new,
        createItems: (batch, oldDb) {
          batch
            ..insert(oldDb.tasks, task)
            ..insert(
              oldDb.outbox,
              v8.OutboxCompanion.insert(
                recordTable: 'tasks',
                recordId: 'task-1',
                operation: 'upsert',
                payload: '{}',
                createdAt: '2026-10-26T09:00:00.000Z',
              ),
            );
        },
        validateItems: (newDb) async {
          final tasks = await newDb.select(newDb.tasks).get();
          expect(tasks.single.toJson(), task.toJson());
          final outbox = await newDb.select(newDb.outbox).get();
          expect(outbox.single.recordId, 'task-1');
          expect(await newDb.select(newDb.harvests).get(), isEmpty);
          expect(await newDb.select(newDb.harvestHives).get(), isEmpty);
        },
      );
    },
  );

  test('v9 → v10 hasatları ve yerel ayarları korur; görüş ve olay kuyrukları '
      'boş gelir', () async {
    const harvest = v9.HarvestsData(
      id: 'harvest-1',
      createdAt: '2026-10-26T09:00:00.000Z',
      updatedAt: '2026-10-26T09:00:00.000Z',
      orgId: 'org-1',
      apiaryId: 'apiary-1',
      harvestedAt: '2026-10-26T09:00:00.000Z',
      honeyKind: 'pine',
      unit: 'super',
      unitCount: 4,
      netKg: 52.5,
    );

    await verifier.testWithDataIntegrity(
      oldVersion: 9,
      newVersion: 10,
      createOld: v9.DatabaseAtV9.new,
      createNew: v10.DatabaseAtV10.new,
      openTestedDatabase: AppDatabase.new,
      createItems: (batch, oldDb) {
        batch
          ..insert(oldDb.harvests, harvest)
          ..insert(
            oldDb.localSettings,
            v9.LocalSettingsCompanion.insert(
              key: 'media_wifi_only',
              value: 'true',
            ),
          );
      },
      validateItems: (newDb) async {
        final harvests = await newDb.select(newDb.harvests).get();
        expect(harvests.single.toJson(), harvest.toJson());
        final settings = await newDb.select(newDb.localSettings).get();
        expect(settings.single.value, 'true');
        expect(await newDb.select(newDb.feedbackQueue).get(), isEmpty);
        expect(await newDb.select(newDb.analyticsQueue).get(), isEmpty);
      },
    );
  });

  test("v10 → v11 görüş kuyruğunu ve outbox'ı korur; belge tabloları boş "
      'gelir', () async {
    await verifier.testWithDataIntegrity(
      oldVersion: 10,
      newVersion: 11,
      createOld: v10.DatabaseAtV10.new,
      createNew: v11.DatabaseAtV11.new,
      openTestedDatabase: AppDatabase.new,
      createItems: (batch, oldDb) {
        batch
          ..insert(
            oldDb.feedbackQueue,
            v10.FeedbackQueueCompanion.insert(
              id: 'feedback-1',
              orgId: 'org-1',
              kind: 'bug',
              message: 'Harita açılmıyor',
              createdAt: '2026-10-27T09:00:00.000Z',
            ),
          )
          ..insert(
            oldDb.outbox,
            v10.OutboxCompanion.insert(
              recordTable: 'tasks',
              recordId: 'task-1',
              operation: 'upsert',
              payload: '{"id": "task-1"}',
              createdAt: '2026-10-27T09:00:00.000Z',
            ),
          );
      },
      validateItems: (newDb) async {
        final feedback = await newDb.select(newDb.feedbackQueue).get();
        expect(feedback.single.message, 'Harita açılmıyor');
        final outbox = await newDb.select(newDb.outbox).get();
        expect(outbox.single.recordId, 'task-1');
        expect(await newDb.select(newDb.documents).get(), isEmpty);
        expect(await newDb.select(newDb.documentUploads).get(), isEmpty);
      },
    );
  });

  test('v11 → v12 belgeleri korur; göç planı tabloları boş gelir', () async {
    await verifier.testWithDataIntegrity(
      oldVersion: 11,
      newVersion: 12,
      createOld: v11.DatabaseAtV11.new,
      createNew: v12.DatabaseAtV12.new,
      openTestedDatabase: AppDatabase.new,
      createItems: (batch, oldDb) {
        batch.insert(
          oldDb.documents,
          v11.DocumentsCompanion.insert(
            id: 'document-1',
            createdAt: '2026-10-27T09:00:00.000Z',
            updatedAt: '2026-10-27T09:00:00.000Z',
            orgId: 'org-1',
            type: 'health_report',
            name: 'Sağlık raporu',
            expiresOn: const Value('2026-11-01'),
            fileKind: 'pdf',
            storagePath: 'org-1/document-1/file-1.pdf',
            byteSize: 1000,
          ),
        );
      },
      validateItems: (newDb) async {
        final documents = await newDb.select(newDb.documents).get();
        expect(documents.single.expiresOn, '2026-11-01');
        expect(await newDb.select(newDb.migrations).get(), isEmpty);
        expect(await newDb.select(newDb.migrationStops).get(), isEmpty);
      },
    );
  });

  test('v12 → v13 göç duraklarını korur; taşıma tabloları boş gelir', () async {
    await verifier.testWithDataIntegrity(
      oldVersion: 12,
      newVersion: 13,
      createOld: v12.DatabaseAtV12.new,
      createNew: v13.DatabaseAtV13.new,
      openTestedDatabase: AppDatabase.new,
      createItems: (batch, oldDb) {
        batch.insert(
          oldDb.migrationStops,
          v12.MigrationStopsCompanion.insert(
            id: 'stop-1',
            createdAt: '2026-10-28T09:00:00.000Z',
            updatedAt: '2026-10-28T09:00:00.000Z',
            orgId: 'org-1',
            migrationId: 'migration-1',
            position: 1,
            name: 'Kışlak',
            plannedStartOn: '2026-11-16',
            plannedEndOn: '2027-02-28',
            status: 'planned',
          ),
        );
      },
      validateItems: (newDb) async {
        final stops = await newDb.select(newDb.migrationStops).get();
        expect(stops.single.name, 'Kışlak');
        expect(await newDb.select(newDb.transports).get(), isEmpty);
        expect(await newDb.select(newDb.transportItems).get(), isEmpty);
      },
    );
  });

  test('v13 → v14 taşımaları korur; stok tabloları boş gelir', () async {
    await verifier.testWithDataIntegrity(
      oldVersion: 13,
      newVersion: 14,
      createOld: v13.DatabaseAtV13.new,
      createNew: v14.DatabaseAtV14.new,
      openTestedDatabase: AppDatabase.new,
      createItems: (batch, oldDb) {
        batch.insert(
          oldDb.transports,
          v13.TransportsCompanion.insert(
            id: 'transport-1',
            createdAt: '2026-10-31T09:00:00.000Z',
            updatedAt: '2026-10-31T09:00:00.000Z',
            orgId: 'org-1',
            sourceApiaryId: 'apiary-1',
            destinationApiaryId: 'apiary-2',
            vehicles: const Value('["Kamyon 1"]'),
            status: 'loading',
          ),
        );
      },
      validateItems: (newDb) async {
        final transports = await newDb.select(newDb.transports).get();
        expect(transports.single.vehicles, '["Kamyon 1"]');
        expect(await newDb.select(newDb.inventoryItems).get(), isEmpty);
        expect(await newDb.select(newDb.inventoryMoves).get(), isEmpty);
      },
    );
  });

  test('v14 → v15 görevleri korur; ilaç ve doz boş gelir', () async {
    await verifier.testWithDataIntegrity(
      oldVersion: 14,
      newVersion: 15,
      createOld: v14.DatabaseAtV14.new,
      createNew: v15.DatabaseAtV15.new,
      openTestedDatabase: AppDatabase.new,
      createItems: (batch, oldDb) {
        batch.insert(
          oldDb.tasks,
          v14.TasksCompanion.insert(
            id: 'task-1',
            createdAt: '2026-11-01T09:00:00.000Z',
            updatedAt: '2026-11-01T09:00:00.000Z',
            orgId: 'org-1',
            title: const Value('Şeker al'),
            dueAt: '2026-11-02T09:00:00.000Z',
            source: 'manual',
          ),
        );
      },
      validateItems: (newDb) async {
        final task = (await newDb.select(newDb.tasks).get()).single;
        expect(task.title, 'Şeker al');
        expect(task.refDrugId, null);
        expect(task.drugId, null);
        expect(task.dose, null);
      },
    );
  });

  test('v15 → v16 görevleri korur; takvim günü boş, ana yetiştirme '
      'tabloları boş gelir', () async {
    await verifier.testWithDataIntegrity(
      oldVersion: 15,
      newVersion: 16,
      createOld: v15.DatabaseAtV15.new,
      createNew: v16.DatabaseAtV16.new,
      openTestedDatabase: AppDatabase.new,
      createItems: (batch, oldDb) {
        batch.insert(
          oldDb.tasks,
          v15.TasksCompanion.insert(
            id: 'task-1',
            createdAt: '2026-11-01T09:00:00.000Z',
            updatedAt: '2026-11-01T09:00:00.000Z',
            orgId: 'org-1',
            title: const Value('Şeker al'),
            dueAt: '2026-11-02T09:00:00.000Z',
            source: 'manual',
          ),
        );
      },
      validateItems: (newDb) async {
        final task = (await newDb.select(newDb.tasks).get()).single;
        expect(task.title, 'Şeker al');
        expect(task.sourceStep, null);
        expect(await newDb.select(newDb.queenRearingBatches).get(), isEmpty);
        expect(await newDb.select(newDb.matingNucs).get(), isEmpty);
      },
    );
  });

  test('v16 → v17 hasatları korur; lot tabloları boş gelir', () async {
    await verifier.testWithDataIntegrity(
      oldVersion: 16,
      newVersion: 17,
      createOld: v16.DatabaseAtV16.new,
      createNew: v17.DatabaseAtV17.new,
      openTestedDatabase: AppDatabase.new,
      createItems: (batch, oldDb) {
        batch.insert(
          oldDb.harvests,
          v16.HarvestsCompanion.insert(
            id: 'harvest-1',
            createdAt: '2026-11-01T09:00:00.000Z',
            updatedAt: '2026-11-01T09:00:00.000Z',
            orgId: 'org-1',
            apiaryId: 'apiary-1',
            harvestedAt: '2026-11-01T09:00:00.000Z',
            honeyKind: 'pine',
            unit: 'super',
            unitCount: 24,
            netKg: 574,
          ),
        );
      },
      validateItems: (newDb) async {
        final harvest = (await newDb.select(newDb.harvests).get()).single;
        expect(harvest.netKg, 574);
        expect(await newDb.select(newDb.lots).get(), isEmpty);
        expect(await newDb.select(newDb.lotHarvests).get(), isEmpty);
        expect(await newDb.select(newDb.lotTreatments).get(), isEmpty);
        expect(await newDb.select(newDb.labResults).get(), isEmpty);
        expect(await newDb.select(newDb.lotSales).get(), isEmpty);
      },
    );
  });

  test('v17 → v18 lotları korur; yayımda değil, alanlar açık', () async {
    await verifier.testWithDataIntegrity(
      oldVersion: 17,
      newVersion: 18,
      createOld: v17.DatabaseAtV17.new,
      createNew: v18.DatabaseAtV18.new,
      openTestedDatabase: AppDatabase.new,
      createItems: (batch, oldDb) {
        batch.insert(
          oldDb.lots,
          v17.LotsCompanion.insert(
            id: 'lot-1',
            createdAt: '2026-11-01T09:00:00.000Z',
            updatedAt: '2026-11-01T09:00:00.000Z',
            orgId: 'org-1',
            year: 2026,
            seq: 7,
            honeyKind: 'pine',
            status: 'open',
          ),
        );
      },
      validateItems: (newDb) async {
        final lot = (await newDb.select(newDb.lots).get()).single;
        expect(lot.seq, 7);
        // Dökümde boolean SQLite'taki gibi 0/1.
        expect(lot.published, 0);
        expect([
          lot.publicProducer,
          lot.publicOrigin,
          lot.publicLab,
          lot.publicReport,
        ], everyElement(1));
      },
    );
  });

  test('v18 → v19 lot satışlarını korur; finans tabloları boş gelir', () async {
    await verifier.testWithDataIntegrity(
      oldVersion: 18,
      newVersion: 19,
      createOld: v18.DatabaseAtV18.new,
      createNew: v19.DatabaseAtV19.new,
      openTestedDatabase: AppDatabase.new,
      createItems: (batch, oldDb) {
        batch.insert(
          oldDb.lotSales,
          v18.LotSalesCompanion.insert(
            id: 'sale-1',
            createdAt: '2026-11-01T09:00:00.000Z',
            updatedAt: '2026-11-01T09:00:00.000Z',
            orgId: 'org-1',
            lotId: 'lot-1',
            soldOn: '2026-11-01',
            kg: 160,
          ),
        );
      },
      validateItems: (newDb) async {
        final sale = (await newDb.select(newDb.lotSales).get()).single;
        expect(sale.kg, 160);
        expect(await newDb.select(newDb.transactions).get(), isEmpty);
        expect(await newDb.select(newDb.receiptUploads).get(), isEmpty);
      },
    );
  });

  test('v19 → v20 finans hareketlerini müşterisiz korur; müşteri tabloları '
      'boş gelir', () async {
    await verifier.testWithDataIntegrity(
      oldVersion: 19,
      newVersion: 20,
      createOld: v19.DatabaseAtV19.new,
      createNew: v20.DatabaseAtV20.new,
      openTestedDatabase: AppDatabase.new,
      createItems: (batch, oldDb) {
        batch.insert(
          oldDb.transactions,
          v19.TransactionsCompanion.insert(
            id: 'transaction-1',
            createdAt: '2026-11-02T09:00:00.000Z',
            updatedAt: '2026-11-02T09:00:00.000Z',
            orgId: 'org-1',
            kind: 'income',
            category: 'honey',
            amount: 56000,
            currency: 'TRY',
            occurredOn: '2026-11-02',
          ),
        );
      },
      validateItems: (newDb) async {
        final transaction =
            (await newDb.select(newDb.transactions).get()).single;
        expect(transaction.amount, 56000);
        expect(transaction.customerId, null);
        expect(await newDb.select(newDb.customers).get(), isEmpty);
        expect(await newDb.select(newDb.customerPayments).get(), isEmpty);
      },
    );
  });

  test('v20 → v21 işletmeyi AKS kovan sayısı boş olarak korur; destek '
      'dönemleri boş gelir', () async {
    await verifier.testWithDataIntegrity(
      oldVersion: 20,
      newVersion: 21,
      createOld: v20.DatabaseAtV20.new,
      createNew: v21.DatabaseAtV21.new,
      openTestedDatabase: AppDatabase.new,
      createItems: (batch, oldDb) {
        batch.insert(
          oldDb.organizations,
          v20.OrganizationsCompanion.insert(
            id: 'org-1',
            createdAt: '2026-11-04T09:00:00.000Z',
            updatedAt: '2026-11-04T09:00:00.000Z',
            name: 'Petek Arıcılık',
            countryCode: 'TR',
            currency: 'TRY',
            trAksNo: const Value('12345'),
          ),
        );
      },
      validateItems: (newDb) async {
        final organization =
            (await newDb.select(newDb.organizations).get()).single;
        expect(organization.trAksNo, '12345');
        expect(organization.trAksHiveCount, null);
        expect(await newDb.select(newDb.refSupportPeriods).get(), isEmpty);
      },
    );
  });
  test('v21 → v22 kovanları karantinasız korur', () async {
    await verifier.testWithDataIntegrity(
      oldVersion: 21,
      newVersion: 22,
      createOld: v21.DatabaseAtV21.new,
      createNew: v22.DatabaseAtV22.new,
      openTestedDatabase: AppDatabase.new,
      createItems: (batch, oldDb) {
        batch.insert(
          oldDb.hives,
          v21.HivesCompanion.insert(
            id: 'hive-1',
            createdAt: '2026-11-02T09:00:00.000Z',
            updatedAt: '2026-11-02T09:00:00.000Z',
            orgId: 'org-1',
            number: '101',
            type: 'langstroth',
            status: 'active',
            apiaryId: 'apiary-1',
          ),
        );
      },
      validateItems: (newDb) async {
        final hive = (await newDb.select(newDb.hives).get()).single;
        expect(hive.number, '101');
        expect(hive.quarantined, 0);
        expect(hive.quarantinedAt, null);
        expect(hive.quarantineDisease, null);
      },
    );
  });

  test('v22 → v23 kovanları korur; durum olayları boş gelir', () async {
    await verifier.testWithDataIntegrity(
      oldVersion: 22,
      newVersion: 23,
      createOld: v22.DatabaseAtV22.new,
      createNew: v23.DatabaseAtV23.new,
      openTestedDatabase: AppDatabase.new,
      createItems: (batch, oldDb) {
        batch.insert(
          oldDb.hives,
          v22.HivesCompanion.insert(
            id: 'hive-1',
            createdAt: '2026-11-08T09:00:00.000Z',
            updatedAt: '2026-11-08T09:00:00.000Z',
            orgId: 'org-1',
            number: '101',
            type: 'langstroth',
            status: 'dead',
            apiaryId: 'apiary-1',
          ),
        );
      },
      validateItems: (newDb) async {
        final hive = (await newDb.select(newDb.hives).get()).single;
        expect(hive.status, 'dead');
        expect(await newDb.select(newDb.hiveStatusEvents).get(), isEmpty);
      },
    );
  });
}
