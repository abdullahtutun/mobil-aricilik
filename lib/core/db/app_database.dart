import 'package:drift/drift.dart';
import 'package:mobil_arici/core/db/app_database.steps.dart';
import 'package:mobil_arici/core/db/converters.dart';
import 'package:mobil_arici/core/db/tables/hive_tables.dart';
import 'package:mobil_arici/core/db/tables/inspection_tables.dart';
import 'package:mobil_arici/core/db/tables/organization_tables.dart';
import 'package:mobil_arici/core/db/tables/sync_tables.dart';
import 'package:mobil_arici/features/apiaries/domain/apiary.dart';
import 'package:mobil_arici/features/hives/domain/hive.dart';
import 'package:mobil_arici/features/hives/domain/hive_location_entry.dart';
import 'package:mobil_arici/features/inspections/domain/inspection.dart';
import 'package:mobil_arici/features/inspections/domain/inspection_draft.dart';
import 'package:mobil_arici/features/organization/domain/membership_role.dart';
import 'package:mobil_arici/features/organization/domain/organization.dart';
import 'package:mobil_arici/features/queens/domain/queen.dart';

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
    InspectionReminders,
    Outbox,
    SyncState,
  ],
)
class AppDatabase extends _$AppDatabase {
  new(super.e);

  @override
  int get schemaVersion => 2;

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
    ),
  );
}
