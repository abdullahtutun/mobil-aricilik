import 'package:drift/drift.dart';
import 'package:mobil_arici/core/db/converters.dart';
import 'package:mobil_arici/core/db/tables/sync_columns.dart';
import 'package:mobil_arici/features/health/domain/mite_count.dart';

/// `public.mite_counts` aynası; olay tablosu.
@UseRowClass(MiteCount, generateInsertable: true)
@TableIndex(name: 'mite_counts_org_id_idx', columns: {#orgId})
@TableIndex(name: 'mite_counts_hive_id_idx', columns: {#hiveId})
@TableIndex(name: 'mite_counts_apiary_id_idx', columns: {#apiaryId})
class MiteCounts extends Table with SyncColumns, OrgColumns {
  TextColumn get hiveId => text()();
  TextColumn get apiaryId => text()();
  DateTimeColumn get countedAt => dateTime()();
  TextColumn get method =>
      text().map(const ServerEnumConverter(MiteCountMethod.values))();
  IntColumn get mites => integer()();
  IntColumn get sampleBees => integer().nullable()();
  IntColumn get days => integer().nullable()();
}
