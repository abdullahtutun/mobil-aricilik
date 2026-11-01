import 'package:drift/drift.dart';
import 'package:mobil_arici/core/db/app_database.steps.dart';
import 'package:mobil_arici/core/db/converters.dart';
import 'package:mobil_arici/core/db/tables/document_tables.dart';
import 'package:mobil_arici/core/db/tables/feeding_tables.dart';
import 'package:mobil_arici/core/db/tables/harvest_tables.dart';
import 'package:mobil_arici/core/db/tables/health_tables.dart';
import 'package:mobil_arici/core/db/tables/hive_tables.dart';
import 'package:mobil_arici/core/db/tables/inspection_tables.dart';
import 'package:mobil_arici/core/db/tables/inventory_tables.dart';
import 'package:mobil_arici/core/db/tables/media_tables.dart';
import 'package:mobil_arici/core/db/tables/migration_tables.dart';
import 'package:mobil_arici/core/db/tables/organization_tables.dart';
import 'package:mobil_arici/core/db/tables/queen_rearing_tables.dart';
import 'package:mobil_arici/core/db/tables/sync_tables.dart';
import 'package:mobil_arici/core/db/tables/task_tables.dart';
import 'package:mobil_arici/core/db/tables/telemetry_tables.dart';
import 'package:mobil_arici/features/apiaries/domain/apiary.dart';
import 'package:mobil_arici/features/documents/domain/document.dart';
import 'package:mobil_arici/features/feedback/domain/feedback.dart';
import 'package:mobil_arici/features/feeding/domain/feeding.dart';
import 'package:mobil_arici/features/harvest/domain/harvest.dart';
import 'package:mobil_arici/features/health/domain/drug.dart';
import 'package:mobil_arici/features/health/domain/mite_count.dart';
import 'package:mobil_arici/features/health/domain/treatment.dart';
import 'package:mobil_arici/features/health/domain/withdrawal.dart';
import 'package:mobil_arici/features/hives/domain/hive.dart';
import 'package:mobil_arici/features/hives/domain/hive_location_entry.dart';
import 'package:mobil_arici/features/inspections/domain/inspection.dart';
import 'package:mobil_arici/features/inspections/domain/inspection_draft.dart';
import 'package:mobil_arici/features/inventory/domain/inventory.dart';
import 'package:mobil_arici/features/media/domain/media_item.dart';
import 'package:mobil_arici/features/migration/domain/migration.dart';
import 'package:mobil_arici/features/migration/domain/transport.dart';
import 'package:mobil_arici/features/organization/domain/membership_role.dart';
import 'package:mobil_arici/features/organization/domain/organization.dart';
import 'package:mobil_arici/features/queens/domain/queen.dart';
import 'package:mobil_arici/features/queens/domain/queen_rearing.dart';
import 'package:mobil_arici/features/tasks/domain/task.dart';

export 'tables/media_tables.dart' show MediaUploadStatus;
export 'tables/sync_tables.dart' show OutboxOperation, fullPullMarker;

part 'app_database.g.dart';

/// Yerel veritabanı. Her okuma ve yazma buraya gider; ekran ağı beklemez.
/// Senkronlanan tablolar (`server_seq` kolonu olanlar) `supabase/migrations`
/// şemasının aynası; diğerleri yalnız bu telefonda.
///
/// Şema değişince [schemaVersion] artar, `dart run drift_dev
/// make-migrations` dökümü ve testi üretir, adım [migration]'a yazılır.
/// Yeni sürüm `sync_push`'un kabul ettiği sürümlere de eklenmeli.
@DriftDatabase(
  tables: [
    Organizations,
    Memberships,
    Apiaries,
    Queens,
    Hives,
    HiveLocationHistory,
    Inspections,
    InspectionDrafts,
    Media,
    MediaUploads,
    MiteCounts,
    RefDrugs,
    Drugs,
    Treatments,
    Feedings,
    Tasks,
    Harvests,
    HarvestHives,
    Documents,
    DocumentUploads,
    Migrations,
    MigrationStops,
    Transports,
    TransportItems,
    InventoryItems,
    InventoryMoves,
    QueenRearingBatches,
    MatingNucs,
    LocalSettings,
    FeedbackQueue,
    AnalyticsQueue,
    Outbox,
    SyncState,
  ],
)
class AppDatabase extends _$AppDatabase {
  new(super.e);

  @override
  int get schemaVersion => 16;

  @override
  MigrationStrategy get migration => MigrationStrategy(
    onUpgrade: stepByStep(
      // Muayeneler; taslak ve hatırlatma yalnız bu telefonda.
      from1To2: (m, schema) async {
        await m.createTable(schema.inspections);
        await m.create(schema.inspectionsOrgIdIdx);
        await m.create(schema.inspectionsHiveIdIdx);
        await m.createTable(schema.inspectionDrafts);
        await m.createTable(schema.inspectionReminders);
      },
      // Medya; yükleme kuyruğu ve yerel ayarlar yalnız bu telefonda.
      from2To3: (m, schema) async {
        await m.createTable(schema.media);
        await m.create(schema.mediaOrgIdIdx);
        await m.create(schema.mediaHiveIdIdx);
        await m.createTable(schema.mediaUploads);
        await m.createTable(schema.localSettings);
      },
      // Varroa ölçümleri.
      from3To4: (m, schema) async {
        await m.createTable(schema.miteCounts);
        await m.create(schema.miteCountsOrgIdIdx);
        await m.create(schema.miteCountsHiveIdIdx);
        await m.create(schema.miteCountsApiaryIdIdx);
      },
      // İlaçlama: referans liste, işletmenin ilaçları ve uygulamalar.
      from4To5: (m, schema) async {
        await m.createTable(schema.refDrugs);
        await m.createTable(schema.drugs);
        await m.create(schema.drugsOrgIdIdx);
        await m.createTable(schema.treatments);
        await m.create(schema.treatmentsOrgIdIdx);
        await m.create(schema.treatmentsHiveIdIdx);
        await m.create(schema.treatmentsApiaryIdIdx);
      },
      // Uygulama grupları ve reçete fotoğrafı.
      from5To6: (m, schema) async {
        await m.addColumn(schema.treatments, schema.treatments.applicationId);
        await m.create(schema.treatmentsApplicationIdIdx);
        await m.addColumn(schema.media, schema.media.treatmentId);
      },
      // Besleme kayıtları.
      from6To7: (m, schema) async {
        await m.createTable(schema.feedings);
        await m.create(schema.feedingsOrgIdIdx);
        await m.create(schema.feedingsHiveIdIdx);
        await m.create(schema.feedingsApiaryIdIdx);
        await m.create(schema.feedingsFeedingGroupIdIdx);
      },
      // Görevler. Muayenenin yalnız bu telefondaki "X gün sonra" seçimi
      // artık görev; eski tablo kalkar (seçimler bildirim kurmuyordu).
      from7To8: (m, schema) async {
        await m.createTable(schema.tasks);
        await m.create(schema.tasksOrgIdIdx);
        await m.create(schema.tasksApiaryIdIdx);
        await m.create(schema.tasksSourceIdIdx);
        await m.deleteTable('inspection_reminders');
      },
      // Hasatlar ve hasada alınan kovanlar.
      from8To9: (m, schema) async {
        await m.createTable(schema.harvests);
        await m.create(schema.harvestsOrgIdIdx);
        await m.create(schema.harvestsApiaryIdIdx);
        await m.createTable(schema.harvestHives);
        await m.create(schema.harvestHivesOrgIdIdx);
        await m.create(schema.harvestHivesHarvestIdIdx);
        await m.create(schema.harvestHivesHiveIdIdx);
      },
      // Görüş ve kullanım olayı kuyrukları; yalnız bu telefonda.
      from9To10: (m, schema) async {
        await m.createTable(schema.feedbackQueue);
        await m.createTable(schema.analyticsQueue);
      },
      // Belge kasası; dosya yükleme kuyruğu yalnız bu telefonda.
      from10To11: (m, schema) async {
        await m.createTable(schema.documents);
        await m.create(schema.documentsOrgIdIdx);
        await m.createTable(schema.documentUploads);
      },
      // Göç planları ve durakları.
      from11To12: (m, schema) async {
        await m.createTable(schema.migrations);
        await m.create(schema.migrationsOrgIdIdx);
        await m.createTable(schema.migrationStops);
        await m.create(schema.migrationStopsOrgIdIdx);
        await m.create(schema.migrationStopsMigrationIdIdx);
        await m.create(schema.migrationStopsApiaryIdIdx);
      },
      // Taşımalar ve taşınan kovanlar.
      from12To13: (m, schema) async {
        await m.createTable(schema.transports);
        await m.create(schema.transportsOrgIdIdx);
        await m.create(schema.transportsMigrationStopIdIdx);
        await m.createTable(schema.transportItems);
        await m.create(schema.transportItemsOrgIdIdx);
        await m.create(schema.transportItemsTransportIdIdx);
        await m.create(schema.transportItemsHiveIdIdx);
      },
      // Stok kalemleri ve hareketleri.
      from13To14: (m, schema) async {
        await m.createTable(schema.inventoryItems);
        await m.create(schema.inventoryItemsOrgIdIdx);
        await m.createTable(schema.inventoryMoves);
        await m.create(schema.inventoryMovesOrgIdIdx);
        await m.create(schema.inventoryMovesItemIdIdx);
      },
      // Planlı ilaçlama görevi: görevin ilacı ve kovan başı dozu.
      from14To15: (m, schema) async {
        await m.addColumn(schema.tasks, schema.tasks.refDrugId);
        await m.addColumn(schema.tasks, schema.tasks.drugId);
        await m.addColumn(schema.tasks, schema.tasks.dose);
        await m.create(schema.tasksRefDrugIdIdx);
        await m.create(schema.tasksDrugIdIdx);
      },
      // Ana yetiştirme serileri, çiftleşme kutuları ve görevin takvim günü.
      from15To16: (m, schema) async {
        await m.addColumn(schema.tasks, schema.tasks.sourceStep);
        await m.createTable(schema.queenRearingBatches);
        await m.create(schema.queenRearingBatchesOrgIdIdx);
        await m.create(schema.queenRearingBatchesMotherQueenIdIdx);
        await m.createTable(schema.matingNucs);
        await m.create(schema.matingNucsOrgIdIdx);
        await m.create(schema.matingNucsApiaryIdIdx);
        await m.create(schema.matingNucsRearingBatchIdIdx);
        await m.create(schema.matingNucsQueenIdIdx);
      },
    ),
  );
}
