import 'package:drift/drift.dart';
import 'package:mobil_arici/core/db/converters.dart';
import 'package:mobil_arici/core/db/tables/sync_columns.dart';
import 'package:mobil_arici/features/tasks/domain/task.dart';

/// `public.tasks` aynası; durum tablosu. Sunucudaki `numeric` doz burada
/// gerçek sayı.
@UseRowClass(Task, generateInsertable: true)
@TableIndex(name: 'tasks_org_id_idx', columns: {#orgId})
@TableIndex(name: 'tasks_apiary_id_idx', columns: {#apiaryId})
@TableIndex(name: 'tasks_source_id_idx', columns: {#sourceId})
@TableIndex(name: 'tasks_ref_drug_id_idx', columns: {#refDrugId})
@TableIndex(name: 'tasks_drug_id_idx', columns: {#drugId})
class Tasks extends Table with SyncColumns, OrgColumns {
  TextColumn get title => text().nullable()();
  DateTimeColumn get dueAt => dateTime()();
  TextColumn get apiaryId => text().nullable()();
  TextColumn get hiveId => text().nullable()();
  TextColumn get assignedTo => text().nullable()();
  DateTimeColumn get completedAt => dateTime().nullable()();
  TextColumn get source =>
      text().map(const ServerEnumConverter(TaskSource.values))();
  TextColumn get sourceId => text().nullable()();
  IntColumn get sourceStep => integer().nullable()();
  TextColumn get refDrugId => text().nullable()();
  TextColumn get drugId => text().nullable()();
  RealColumn get dose => real().nullable()();
}
