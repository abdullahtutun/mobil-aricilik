import 'package:drift/drift.dart';
import 'package:mobil_arici/core/db/converters.dart';
import 'package:mobil_arici/core/db/tables/sync_columns.dart';
import 'package:mobil_arici/features/health/domain/drug.dart';
import 'package:mobil_arici/features/health/domain/mite_count.dart';
import 'package:mobil_arici/features/health/domain/treatment.dart';

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

/// `public.ref_drugs` aynası; salt okunur referans liste, yalnız senkronla
/// iner. İşletmeye ait değil, `org_id` yok.
@UseRowClass(RefDrug, generateInsertable: true)
class RefDrugs extends Table with SyncColumns {
  TextColumn get countryCode => text()();
  TextColumn get nameTr => text()();
  TextColumn get nameEn => text()();
  TextColumn get activeIngredient =>
      text().map(const ServerEnumConverter(DrugActiveIngredient.values))();
  TextColumn get doseUnit =>
      text().map(const ServerEnumConverter(DrugDoseUnit.values))();
  IntColumn get withdrawalDays => integer().nullable()();
  TextColumn get licenseNo => text().nullable()();
}

/// `public.drugs` aynası; işletmenin eklediği ilaçlar, durum tablosu.
@UseRowClass(Drug, generateInsertable: true)
@TableIndex(name: 'drugs_org_id_idx', columns: {#orgId})
class Drugs extends Table with SyncColumns, OrgColumns {
  TextColumn get name => text()();
  TextColumn get activeIngredient =>
      text().map(const ServerEnumConverter(DrugActiveIngredient.values))();
  TextColumn get doseUnit =>
      text().map(const ServerEnumConverter(DrugDoseUnit.values))();
  IntColumn get withdrawalDays => integer().nullable()();
  TextColumn get licenseNo => text().nullable()();
}

/// `public.treatments` aynası; olay tablosu. Sunucudaki `numeric` doz
/// burada gerçek sayı.
@UseRowClass(Treatment, generateInsertable: true)
@TableIndex(name: 'treatments_org_id_idx', columns: {#orgId})
@TableIndex(name: 'treatments_hive_id_idx', columns: {#hiveId})
@TableIndex(name: 'treatments_apiary_id_idx', columns: {#apiaryId})
@TableIndex(name: 'treatments_application_id_idx', columns: {#applicationId})
class Treatments extends Table with SyncColumns, OrgColumns {
  TextColumn get hiveId => text()();
  TextColumn get apiaryId => text()();
  TextColumn get refDrugId => text().nullable()();
  TextColumn get drugId => text().nullable()();
  TextColumn get applicationId => text().nullable()();
  TextColumn get productName => text()();
  TextColumn get activeIngredient =>
      text().map(const ServerEnumConverter(DrugActiveIngredient.values))();
  TextColumn get batchNo => text().nullable()();
  RealColumn get dose => real()();
  TextColumn get doseUnit =>
      text().map(const ServerEnumConverter(DrugDoseUnit.values))();
  DateTimeColumn get startedAt => dateTime()();
  DateTimeColumn get plannedRemovalAt => dateTime().nullable()();
  IntColumn get withdrawalDays => integer()();
}
