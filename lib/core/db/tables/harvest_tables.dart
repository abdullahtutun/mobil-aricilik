import 'package:drift/drift.dart';
import 'package:mobil_arici/core/db/converters.dart';
import 'package:mobil_arici/core/db/tables/sync_columns.dart';
import 'package:mobil_arici/features/harvest/domain/harvest.dart';
import 'package:mobil_arici/features/health/domain/withdrawal.dart';

/// `public.harvests` aynası; olay tablosu. Sunucudaki `numeric` süzülen bal
/// burada gerçek sayı.
@UseRowClass(Harvest, generateInsertable: true)
@TableIndex(name: 'harvests_org_id_idx', columns: {#orgId})
@TableIndex(name: 'harvests_apiary_id_idx', columns: {#apiaryId})
class Harvests extends Table with SyncColumns, OrgColumns {
  TextColumn get apiaryId => text()();
  DateTimeColumn get harvestedAt => dateTime()();
  TextColumn get honeyKind =>
      text().map(const ServerEnumConverter(HoneyKind.values))();
  TextColumn get unit =>
      text().map(const ServerEnumConverter(HarvestUnit.values))();
  IntColumn get unitCount => integer()();
  RealColumn get netKg => real()();
}

/// `public.harvest_hives` aynası; olay tablosu.
@UseRowClass(HarvestHive, generateInsertable: true)
@TableIndex(name: 'harvest_hives_org_id_idx', columns: {#orgId})
@TableIndex(name: 'harvest_hives_harvest_id_idx', columns: {#harvestId})
@TableIndex(name: 'harvest_hives_hive_id_idx', columns: {#hiveId})
class HarvestHives extends Table with SyncColumns, OrgColumns {
  TextColumn get harvestId => text()();
  TextColumn get hiveId => text()();
  TextColumn get withdrawalTreatmentId => text().nullable()();
  TextColumn get withdrawalOverrideReason => text().nullable().map(
    const ServerEnumConverter(WithdrawalOverrideReason.values),
  )();
}
