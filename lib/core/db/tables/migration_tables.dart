import 'package:drift/drift.dart';
import 'package:mobil_arici/core/db/converters.dart';
import 'package:mobil_arici/core/db/tables/sync_columns.dart';
import 'package:mobil_arici/features/migration/domain/migration.dart';

/// `public.migrations` aynası; durum tablosu.
@UseRowClass(Migration, generateInsertable: true)
@TableIndex(name: 'migrations_org_id_idx', columns: {#orgId})
class Migrations extends Table with SyncColumns, OrgColumns {
  IntColumn get year => integer()();
  TextColumn get name => text()();
}

/// `public.migration_stops` aynası; durum tablosu.
@UseRowClass(MigrationStop, generateInsertable: true)
@TableIndex(name: 'migration_stops_org_id_idx', columns: {#orgId})
@TableIndex(name: 'migration_stops_migration_id_idx', columns: {#migrationId})
@TableIndex(name: 'migration_stops_apiary_id_idx', columns: {#apiaryId})
class MigrationStops extends Table with SyncColumns, OrgColumns {
  TextColumn get migrationId => text()();
  IntColumn get position => integer()();
  TextColumn get name => text()();
  TextColumn get place => text().nullable()();
  TextColumn get plannedStartOn => text().map(const DateOnlyConverter())();
  TextColumn get plannedEndOn => text().map(const DateOnlyConverter())();
  TextColumn get apiaryId => text().nullable()();
  IntColumn get hiveCount => integer().nullable()();
  TextColumn get status =>
      text().map(const ServerEnumConverter(MigrationStopStatus.values))();
}
