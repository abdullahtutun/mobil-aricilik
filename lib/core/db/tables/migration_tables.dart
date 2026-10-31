import 'package:drift/drift.dart';
import 'package:mobil_arici/core/db/converters.dart';
import 'package:mobil_arici/core/db/tables/sync_columns.dart';
import 'package:mobil_arici/features/migration/domain/migration.dart';
import 'package:mobil_arici/features/migration/domain/transport.dart';

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

/// `public.transports` aynası; durum tablosu. Sunucudaki `vehicles jsonb`
/// dizisi yerelde JSON metni.
@UseRowClass(Transport, generateInsertable: true)
@TableIndex(name: 'transports_org_id_idx', columns: {#orgId})
@TableIndex(
  name: 'transports_migration_stop_id_idx',
  columns: {#migrationStopId},
)
class Transports extends Table with SyncColumns, OrgColumns {
  TextColumn get migrationStopId => text().nullable()();
  TextColumn get sourceApiaryId => text()();
  TextColumn get destinationApiaryId => text()();
  TextColumn get vehicles => text()
      .map(const JsonStringListConverter())
      .withDefault(const Constant('[]'))();
  TextColumn get status =>
      text().map(const ServerEnumConverter(TransportStatus.values))();
  DateTimeColumn get completedAt => dateTime().nullable()();
}

/// `public.transport_items` aynası; durum tablosu.
@UseRowClass(TransportItem, generateInsertable: true)
@TableIndex(name: 'transport_items_org_id_idx', columns: {#orgId})
@TableIndex(name: 'transport_items_transport_id_idx', columns: {#transportId})
@TableIndex(name: 'transport_items_hive_id_idx', columns: {#hiveId})
class TransportItems extends Table with SyncColumns, OrgColumns {
  TextColumn get transportId => text()();
  TextColumn get hiveId => text()();
  TextColumn get vehicle => text()();
  DateTimeColumn get loadedAt => dateTime()();
  DateTimeColumn get unloadedAt => dateTime().nullable()();
}
