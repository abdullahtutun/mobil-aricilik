import 'package:drift/drift.dart';
import 'package:mobil_arici/core/db/converters.dart';
import 'package:mobil_arici/core/db/tables/sync_columns.dart';
import 'package:mobil_arici/features/feeding/domain/feeding.dart';

/// `public.feedings` aynası; olay tablosu. Sunucudaki `numeric` miktar
/// burada gerçek sayı.
@UseRowClass(Feeding, generateInsertable: true)
@TableIndex(name: 'feedings_org_id_idx', columns: {#orgId})
@TableIndex(name: 'feedings_hive_id_idx', columns: {#hiveId})
@TableIndex(name: 'feedings_apiary_id_idx', columns: {#apiaryId})
@TableIndex(name: 'feedings_feeding_group_id_idx', columns: {#feedingGroupId})
class Feedings extends Table with SyncColumns, OrgColumns {
  TextColumn get hiveId => text()();
  TextColumn get apiaryId => text()();
  TextColumn get feedingGroupId => text()();
  DateTimeColumn get fedAt => dateTime()();
  TextColumn get kind =>
      text().map(const ServerEnumConverter(FeedingKind.values))();
  RealColumn get amount => real()();
}
