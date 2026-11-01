import 'package:drift/drift.dart';
import 'package:mobil_arici/core/db/converters.dart';
import 'package:mobil_arici/core/db/tables/sync_columns.dart';
import 'package:mobil_arici/features/queens/domain/queen_rearing.dart';

/// `public.queen_rearing_batches` aynası; durum tablosu.
@UseRowClass(QueenRearingBatch, generateInsertable: true)
@TableIndex(name: 'queen_rearing_batches_org_id_idx', columns: {#orgId})
@TableIndex(
  name: 'queen_rearing_batches_mother_queen_id_idx',
  columns: {#motherQueenId},
)
class QueenRearingBatches extends Table with SyncColumns, OrgColumns {
  IntColumn get number => integer()();
  TextColumn get motherQueenId => text().nullable()();
  TextColumn get graftedOn => text().map(const DateOnlyConverter())();
  IntColumn get graftedCount => integer()();
  IntColumn get acceptedCount => integer().nullable()();
}

/// `public.mating_nucs` aynası; durum tablosu.
@UseRowClass(MatingNuc, generateInsertable: true)
@TableIndex(name: 'mating_nucs_org_id_idx', columns: {#orgId})
@TableIndex(name: 'mating_nucs_apiary_id_idx', columns: {#apiaryId})
@TableIndex(
  name: 'mating_nucs_rearing_batch_id_idx',
  columns: {#rearingBatchId},
)
@TableIndex(name: 'mating_nucs_queen_id_idx', columns: {#queenId})
class MatingNucs extends Table with SyncColumns, OrgColumns {
  TextColumn get number => text()();
  TextColumn get apiaryId => text()();
  TextColumn get rearingBatchId => text().nullable()();
  TextColumn get status =>
      text().map(const ServerEnumConverter(MatingNucStatus.values))();
  TextColumn get queenId => text().nullable()();
}
