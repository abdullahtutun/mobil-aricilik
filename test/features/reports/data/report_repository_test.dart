import 'package:drift/drift.dart' show Value;
import 'package:flutter_test/flutter_test.dart';
import 'package:mobil_arici/core/db/app_database.dart';
import 'package:mobil_arici/features/apiaries/data/apiary_repository.dart';
import 'package:mobil_arici/features/apiaries/domain/apiary.dart';
import 'package:mobil_arici/features/harvest/data/harvest_repository.dart';
import 'package:mobil_arici/features/harvest/domain/harvest.dart';
import 'package:mobil_arici/features/hives/data/hive_repository.dart';
import 'package:mobil_arici/features/hives/domain/hive.dart';
import 'package:mobil_arici/features/reports/data/report_repository.dart';

import '../../../helpers/test_database.dart';

const _orgId = 'org';

void main() {
  late AppDatabase db;
  late ReportRepository reports;
  late HiveRepository hives;
  late Apiary yayla;

  setUp(() async {
    db = openTestDatabase();
    reports = ReportRepository(db);
    hives = HiveRepository(db);
    yayla = await ApiaryRepository(db).create(orgId: _orgId, name: 'Yayla');
  });

  Future<Hive> createHive(String number) => hives.create(
    orgId: _orgId,
    number: number,
    type: HiveType.langstroth,
    apiaryId: yayla.id,
  );

  Future<HarvestRecord> harvest(List<String> hiveIds) =>
      HarvestRepository(db).add(
        orgId: _orgId,
        plan: (
          apiaryId: yayla.id,
          harvestedAt: DateTime.utc(2026, 7),
          honeyKind: HoneyKind.pine,
          unit: HarvestUnit.superBox,
          unitCount: 3,
          netKg: 26,
        ),
        hiveIds: hiveIds,
      );

  test('işletme satırı yokken numaralar boş; satır gelince dolar', () async {
    final first = await reports.watchRegistration(_orgId).first;
    expect(first.registrationNo, isNull);
    expect(first.aksNo, isNull);

    final at = DateTime.utc(2026);
    await db
        .into(db.organizations)
        .insert(
          OrganizationsCompanion.insert(
            id: _orgId,
            name: 'Petek Arıcılık',
            countryCode: 'TR',
            currency: 'TRY',
            createdAt: at,
            updatedAt: at,
            trRegistrationNo: const Value('TR-48-0001'),
            trAksNo: const Value('12345'),
          ),
        );

    final next = await reports.watchRegistration(_orgId).first;
    expect(next.registrationNo, 'TR-48-0001');
    expect(next.aksNo, '12345');
  });

  test('silinmiş kovan ve arılık da okunur; numarası raporda yazsın', () async {
    final hive = await createHive('104');
    await hives.delete(hive.id);
    await ApiaryRepository(db).delete(yayla.id);

    expect(
      [for (final hive in await reports.findHives(_orgId)) hive.id],
      [hive.id],
    );
    expect(await reports.findApiaryNames(_orgId), {yayla.id: 'Yayla'});
    expect(await reports.findHives('other'), isEmpty);
  });

  test('kovanın kayıtları: ilk arılık kaydı ve alındığı hasatlar', () async {
    final hive = await createHive('104');
    final other = await createHive('105');
    final taken = await harvest([hive.id, other.id]);
    await harvest([other.id]);
    final undone = await harvest([hive.id]);
    await HarvestRepository(db).deleteHarvest(undone.harvest.id);

    final records = await reports.findHiveRecords(hive.id);

    expect(
      [for (final harvest in records.harvests) harvest.id],
      [taken.harvest.id],
    );
    expect(records.locations.single.apiaryId, yayla.id);
    expect(records.inspections, isEmpty);
  });
}
