import 'package:drift/drift.dart' show Value;
import 'package:mobil_arici/core/db/app_database.dart';
import 'package:mobil_arici/features/apiaries/data/apiary_repository.dart';
import 'package:mobil_arici/features/hives/data/hive_repository.dart';
import 'package:mobil_arici/features/hives/domain/hive.dart';
import 'package:mobil_arici/features/inspections/data/inspection_repository.dart';
import 'package:mobil_arici/features/inspections/domain/inspection.dart';
import 'package:mobil_arici/features/migration/data/migration_repository.dart';
import 'package:mobil_arici/features/migration/domain/migration.dart';
import 'package:mobil_arici/features/organization/domain/organization.dart';

import 'fake_organization_service.dart';

/// İşletmenin yerel satırı (senkronla inmiş gibi); kimlik
/// [testOrganization]'ınki.
Future<void> insertOrganizationRow(
  AppDatabase db, {
  OperationType operationType = OperationType.migratory,
  String currency = 'TRY',
  String name = 'Yılmaz Arıcılık',
  DateTime? createdAt,
}) => db
    .into(db.organizations)
    .insert(
      OrganizationsCompanion.insert(
        id: testOrganization.id,
        name: name,
        countryCode: 'TR',
        currency: currency,
        createdAt: createdAt ?? DateTime.utc(2024, 3, 10),
        updatedAt: DateTime.utc(2026, 11),
        operationType: Value(operationType),
        createdBy: const Value('user-1'),
        serverSeq: const Value(3),
      ),
    );

/// [plans] göç planı, her birinde [stopsPerPlan] durak; ayrıca silinmiş bir
/// plan (durağıyla) ve silinmiş bir durak: bunlar sayılmamalı.
Future<void> seedMigrations(
  AppDatabase db, {
  int plans = 2,
  int stopsPerPlan = 2,
}) async {
  final repository = MigrationRepository(db);
  final orgId = testOrganization.id;
  MigrationStopPlan stop(int position) => (
    position: position,
    name: 'Durak $position',
    place: null,
    plannedStartOn: DateTime(2026, 4, position),
    plannedEndOn: DateTime(2026, 4, position + 1),
    apiaryId: null,
    hiveCount: null,
    status: MigrationStopStatus.planned,
  );
  for (var i = 1; i <= plans; i++) {
    final migration = await repository.create(
      orgId: orgId,
      year: 2026,
      name: 'Yayla $i',
    );
    for (var s = 1; s <= stopsPerPlan; s++) {
      await repository.stops.create(
        orgId: orgId,
        migrationId: migration.id,
        plan: stop(s),
      );
    }
  }
  final deletedPlan = await repository.create(
    orgId: orgId,
    year: 2025,
    name: 'Eski plan',
  );
  await repository.stops.create(
    orgId: orgId,
    migrationId: deletedPlan.id,
    plan: stop(1),
  );
  await repository.remove(deletedPlan.id);
  // Akış değil tek sorgu: widget testinin sahte zamanında akış beklemez.
  final kept =
      await (db.select(db.migrations)
            ..where((t) => t.deletedAt.isNull())
            ..limit(1))
          .getSingle();
  final extra = await repository.stops.create(
    orgId: orgId,
    migrationId: kept.id,
    plan: stop(9),
  );
  await repository.stops.delete(extra.id);
}

/// Sayaç kontrolü için: 2 arılık (biri silinmiş başka bir arılık daha), 3
/// aktif kovan + 1 sönmüş + 1 silinmiş, 4 muayene + 1 silinmiş.
Future<void> seedCountedRecords(AppDatabase db) async {
  final orgId = testOrganization.id;
  final apiaries = ApiaryRepository(db);
  final hives = HiveRepository(db);
  final inspections = InspectionRepository(db);
  final a = await apiaries.create(orgId: orgId, name: 'Ova');
  await apiaries.create(orgId: orgId, name: 'Yayla');
  final gone = await apiaries.create(orgId: orgId, name: 'Kapandı');
  await apiaries.delete(gone.id);
  final created = <Hive>[];
  for (final number in ['1', '2', '3']) {
    created.add(
      await hives.create(
        orgId: orgId,
        number: number,
        type: HiveType.langstroth,
        apiaryId: a.id,
      ),
    );
  }
  await hives.create(
    orgId: orgId,
    number: '4',
    type: HiveType.langstroth,
    apiaryId: a.id,
    status: HiveStatus.dead,
  );
  final deleted = await hives.create(
    orgId: orgId,
    number: '5',
    type: HiveType.langstroth,
    apiaryId: a.id,
  );
  await hives.delete(deleted.id);
  for (var i = 0; i < 5; i++) {
    final inspection = await inspections.add(
      orgId: orgId,
      hiveId: created[i % 3].id,
      apiaryId: a.id,
      values: const InspectionValues(beeFrames: 6),
    );
    if (i == 4) await inspections.delete(inspection.id);
  }
}
