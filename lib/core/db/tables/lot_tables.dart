import 'package:drift/drift.dart';
import 'package:mobil_arici/core/db/converters.dart';
import 'package:mobil_arici/core/db/tables/sync_columns.dart';
import 'package:mobil_arici/features/harvest/domain/harvest.dart';
import 'package:mobil_arici/features/harvest/domain/lot.dart';

/// `public.lots` aynası; durum tablosu. Sunucudaki `numeric` nem burada
/// gerçek sayı.
@UseRowClass(Lot, generateInsertable: true)
@TableIndex(name: 'lots_org_id_idx', columns: {#orgId})
class Lots extends Table with SyncColumns, OrgColumns {
  IntColumn get year => integer()();
  IntColumn get seq => integer()();
  TextColumn get honeyKind =>
      text().map(const ServerEnumConverter(HoneyKind.values))();
  TextColumn get origin => text().nullable()();
  RealColumn get moisture => real().nullable()();
  TextColumn get status =>
      text().map(const ServerEnumConverter(LotStatus.values))();
  BoolColumn get published => boolean().withDefault(const Constant(false))();
  BoolColumn get publicProducer =>
      boolean().withDefault(const Constant(true))();
  BoolColumn get publicOrigin => boolean().withDefault(const Constant(true))();
  BoolColumn get publicLab => boolean().withDefault(const Constant(true))();
  BoolColumn get publicReport => boolean().withDefault(const Constant(true))();
}

/// `public.lot_harvests` aynası; olay tablosu.
@UseRowClass(LotHarvest, generateInsertable: true)
@TableIndex(name: 'lot_harvests_org_id_idx', columns: {#orgId})
@TableIndex(name: 'lot_harvests_lot_id_idx', columns: {#lotId})
@TableIndex(name: 'lot_harvests_harvest_id_idx', columns: {#harvestId})
class LotHarvests extends Table with SyncColumns, OrgColumns {
  TextColumn get lotId => text()();
  TextColumn get harvestId => text()();
}

/// `public.lot_treatments` aynası; olay tablosu.
@UseRowClass(LotTreatment, generateInsertable: true)
@TableIndex(name: 'lot_treatments_org_id_idx', columns: {#orgId})
@TableIndex(name: 'lot_treatments_lot_id_idx', columns: {#lotId})
@TableIndex(name: 'lot_treatments_harvest_id_idx', columns: {#harvestId})
@TableIndex(name: 'lot_treatments_hive_id_idx', columns: {#hiveId})
@TableIndex(name: 'lot_treatments_treatment_id_idx', columns: {#treatmentId})
class LotTreatments extends Table with SyncColumns, OrgColumns {
  TextColumn get lotId => text()();
  TextColumn get harvestId => text()();
  TextColumn get hiveId => text()();
  TextColumn get treatmentId => text()();
  DateTimeColumn get treatedAt => dateTime()();
  TextColumn get withdrawalEndsOn => text().map(const DateOnlyConverter())();
  BoolColumn get withdrawalViolation => boolean()();
}

/// `public.lab_results` aynası; olay tablosu.
@UseRowClass(LabResult, generateInsertable: true)
@TableIndex(name: 'lab_results_org_id_idx', columns: {#orgId})
@TableIndex(name: 'lab_results_lot_id_idx', columns: {#lotId})
@TableIndex(name: 'lab_results_document_id_idx', columns: {#documentId})
class LabResults extends Table with SyncColumns, OrgColumns {
  TextColumn get lotId => text()();
  TextColumn get testedOn => text().map(const DateOnlyConverter())();
  RealColumn get hmf => real().nullable()();
  RealColumn get diastase => real().nullable()();
  RealColumn get proline => real().nullable()();
  RealColumn get moisture => real().nullable()();
  TextColumn get residue =>
      text().nullable().map(const ServerEnumConverter(ResidueResult.values))();
  TextColumn get documentId => text().nullable()();
}

/// `public.lot_sales` aynası; olay tablosu.
@UseRowClass(LotSale, generateInsertable: true)
@TableIndex(name: 'lot_sales_org_id_idx', columns: {#orgId})
@TableIndex(name: 'lot_sales_lot_id_idx', columns: {#lotId})
class LotSales extends Table with SyncColumns, OrgColumns {
  TextColumn get lotId => text()();
  TextColumn get soldOn => text().map(const DateOnlyConverter())();
  RealColumn get kg => real()();
}
