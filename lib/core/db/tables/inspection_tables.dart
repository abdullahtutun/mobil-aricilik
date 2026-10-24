import 'dart:convert';

import 'package:drift/drift.dart';
import 'package:mobil_arici/core/db/converters.dart';
import 'package:mobil_arici/core/db/tables/sync_columns.dart';
import 'package:mobil_arici/features/inspections/domain/inspection.dart';
import 'package:mobil_arici/features/inspections/domain/inspection_draft.dart';

/// `public.inspections` aynası; olay tablosu. Sunucudaki `data jsonb`
/// burada JSON metni.
@UseRowClass(Inspection, generateInsertable: true)
@TableIndex(name: 'inspections_org_id_idx', columns: {#orgId})
@TableIndex(name: 'inspections_hive_id_idx', columns: {#hiveId})
class Inspections extends Table with SyncColumns, OrgColumns {
  TextColumn get hiveId => text()();
  TextColumn get apiaryId => text()();
  DateTimeColumn get inspectedAt => dateTime()();
  TextColumn get queenState =>
      text().nullable().map(const ServerEnumConverter(QueenState.values))();
  IntColumn get beeFrames => integer().nullable()();
  IntColumn get broodFrames => integer().nullable()();
  IntColumn get honeyFrames => integer().nullable()();
  TextColumn get temperament =>
      text().nullable().map(const ServerEnumConverter(Temperament.values))();
  BoolColumn get swarmSigns => boolean().nullable()();
  TextColumn get queenCells =>
      text().nullable().map(const ServerEnumConverter(QueenCells.values))();
  BoolColumn get diseaseSuspected => boolean().nullable()();
  TextColumn get data =>
      text().map(const JsonMapConverter()).withDefault(const Constant('{}'))();
}

// Aşağıdaki iki tablo yalnız bu telefonda: sunucuda aynası yok, outbox'a
// yazılmaz ve senkronla çekilmez.

/// Yarım kalan hızlı muayene; kovan başına bir taslak. Formdaki her
/// değişiklikte yazılır, muayene kaydedilince silinir.
@DataClassName('InspectionDraftRow')
class InspectionDrafts extends Table {
  TextColumn get hiveId => text()();
  TextColumn get orgId => text()();
  TextColumn get draft => text().map(const InspectionDraftConverter())();
  DateTimeColumn get updatedAt => dateTime()();

  @override
  Set<Column<Object>> get primaryKey => {hiveId};
}

/// Kaydettikten sonra seçilen "X gün sonra hatırlat". Görev modülü
/// gelene kadar yalnız değer saklanır; görevler gelince göreve çevrilecek.
@DataClassName('InspectionReminder')
class InspectionReminders extends Table {
  TextColumn get inspectionId => text()();
  TextColumn get orgId => text()();
  TextColumn get hiveId => text()();
  IntColumn get days => integer()();
  DateTimeColumn get remindAt => dateTime()();
  DateTimeColumn get createdAt => dateTime()();

  @override
  Set<Column<Object>> get primaryKey => {inspectionId};
}

/// Taslağı JSON metni olarak tutar. `jsonEncode` iç içe modeli de
/// (`values`) kendi `toJson`'ıyla yazar.
class InspectionDraftConverter extends TypeConverter<InspectionDraft, String> {
  const new();

  @override
  InspectionDraft fromSql(String fromDb) =>
      InspectionDraft.fromJson(jsonDecode(fromDb) as Map<String, Object?>);

  @override
  String toSql(InspectionDraft value) => jsonEncode(value.toJson());
}
