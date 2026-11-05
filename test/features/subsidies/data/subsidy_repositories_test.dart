import 'package:drift/drift.dart' hide isNotNull, isNull;
import 'package:flutter_test/flutter_test.dart';
import 'package:mobil_arici/core/db/app_database.dart';
import 'package:mobil_arici/features/organization/data/organization_repository.dart';
import 'package:mobil_arici/features/organization/domain/organization.dart';
import 'package:mobil_arici/features/subsidies/data/support_period_repository.dart';
import 'package:mobil_arici/features/subsidies/domain/support_period.dart';

import '../../../helpers/test_database.dart';

const _org = 'org-1';

void main() {
  late AppDatabase db;
  late TestClock clock;

  setUp(() {
    db = openTestDatabase();
    clock = TestClock(DateTime.utc(2026, 11, 5, 9));
  });

  group('OrganizationRepository', () {
    late OrganizationRepository organizations;

    Future<void> insertOrganization() => db
        .into(db.organizations)
        .insert(
          OrganizationsCompanion.insert(
            id: _org,
            name: 'Petek Arıcılık',
            countryCode: 'TR',
            currency: 'TRY',
            createdAt: DateTime.utc(2026),
            updatedAt: DateTime.utc(2026),
            trAksNo: const Value('12345'),
            hiveCountRange: const Value(HiveCountRange.upTo50),
            createdBy: const Value('user-1'),
            serverSeq: const Value(7),
          ),
        );

    setUp(() => organizations = OrganizationRepository(db, clock: clock.call));

    test('beyan edilen sayıyı yazar; outbox satırın tamamını sunucu kolon '
        'adlarıyla taşır', () async {
      await insertOrganization();
      expect(await organizations.setAksHiveCount(_org, 120), isTrue);

      final row = await db.select(db.organizations).getSingle();
      expect(row.trAksHiveCount, 120);
      expect(row.updatedAt, clock.current);
      final entry = (await readOutbox(db)).single;
      expect(entry.recordTable, 'organizations');
      expect(entry.recordId, _org);
      expect(entry.operation, OutboxOperation.upsert);
      expect(entry.payload, {
        'id': _org,
        'name': 'Petek Arıcılık',
        'country_code': 'TR',
        'currency': 'TRY',
        'tr_registration_no': null,
        'tr_aks_no': '12345',
        'hive_count_range': 'up_to_50',
        'tr_aks_hive_count': 120,
        'operation_type': 'migratory',
        'avatar_color': null,
        'logo_path': null,
        'created_at': '2026-01-01T00:00:00.000Z',
        'updated_at': '2026-11-05T09:00:00.000Z',
        'created_by': 'user-1',
        'deleted_at': null,
      });
    });

    test('null sayıyı siler', () async {
      await insertOrganization();
      await organizations.setAksHiveCount(_org, 120);
      await organizations.setAksHiveCount(_org, null);
      expect(
        (await db.select(db.organizations).getSingle()).trAksHiveCount,
        isNull,
      );
      expect((await readOutbox(db)).last.payload['tr_aks_hive_count'], isNull);
    });

    test('işletme satırı yoksa bir şey yazmaz ve false döner', () async {
      expect(await organizations.setAksHiveCount(_org, 5), isFalse);
      expect(await readOutbox(db), isEmpty);
    });

    test('aralık dışı sayı ArgumentError', () async {
      await insertOrganization();
      expect(
        () => organizations.setAksHiveCount(_org, -1),
        throwsArgumentError,
      );
      expect(
        () => organizations.setAksHiveCount(_org, 100001),
        throwsArgumentError,
      );
      expect(await readOutbox(db), isEmpty);
    });

    test('outbox yazılamazsa satır da değişmez', () async {
      await insertOrganization();
      await db.customStatement(
        'CREATE TRIGGER block_outbox BEFORE INSERT ON outbox '
        "BEGIN SELECT RAISE(ABORT, 'engellendi'); END",
      );
      await expectLater(
        organizations.setAksHiveCount(_org, 120),
        throwsA(isA<Exception>()),
      );
      expect(
        (await db.select(db.organizations).getSingle()).trAksHiveCount,
        isNull,
      );
    });

    test('watchAksHiveCount satır yokken null, yazınca sayıyı yayar', () async {
      final stream = organizations.watchAksHiveCount(_org);
      expect(await stream.first, isNull);
      await insertOrganization();
      await organizations.setAksHiveCount(_org, 42);
      expect(await stream.first, 42);
    });
  });

  test('SupportPeriodRepository.watchAll silinenleri göstermez, başlangıca '
      'göre sıralar', () async {
    Future<void> insert(String id, DateTime starts, {DateTime? deletedAt}) => db
        .into(db.refSupportPeriods)
        .insert(
          SupportPeriod(
            id: id,
            name: id,
            applicationStartsOn: starts,
            applicationEndsOn: starts.add(const Duration(days: 30)),
            createdAt: DateTime.utc(2026),
            updatedAt: DateTime.utc(2026),
            deletedAt: deletedAt,
          ).toInsertable(),
        );
    await insert('mart', DateTime(2027, 3));
    await insert('ocak', DateTime(2027));
    await insert('silinmiş', DateTime(2027, 2), deletedAt: DateTime.utc(2026));

    final periods = await SupportPeriodRepository(db).watchAll().first;
    expect(periods.map((period) => period.id), ['ocak', 'mart']);
    expect(periods.first.toJson()['application_starts_on'], '2027-01-01');
  });
}
