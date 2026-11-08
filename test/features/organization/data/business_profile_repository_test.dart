import 'package:drift/drift.dart' show Value;
import 'package:flutter_test/flutter_test.dart';
import 'package:mobil_arici/core/db/app_database.dart';
import 'package:mobil_arici/core/sync/sync_repository.dart';
import 'package:mobil_arici/features/apiaries/data/apiary_repository.dart';
import 'package:mobil_arici/features/finance/data/transaction_repository.dart';
import 'package:mobil_arici/features/finance/domain/finance_transaction.dart';
import 'package:mobil_arici/features/organization/data/membership_repository.dart';
import 'package:mobil_arici/features/organization/data/organization_repository.dart';
import 'package:mobil_arici/features/organization/domain/business_profile.dart';
import 'package:mobil_arici/features/organization/domain/membership_role.dart';
import 'package:mobil_arici/features/organization/domain/organization.dart';

import '../../../helpers/business_seed.dart';
import '../../../helpers/fake_organization_service.dart';
import '../../../helpers/fake_team_service.dart';
import '../../../helpers/test_database.dart';

final String _org = testOrganization.id;

BusinessProfileChange _change({
  String name = 'Yılmaz Arıcılık',
  OrgAvatarColor? avatarColor,
  String? logoPath,
  OperationType operationType = OperationType.migratory,
  String currency = 'TRY',
}) => (
  name: name,
  avatarColor: avatarColor,
  logoPath: logoPath,
  operationType: operationType,
  currency: currency,
);

void main() {
  late AppDatabase db;
  late TestClock clock;
  late OrganizationRepository organizations;

  setUp(() {
    db = openTestDatabase();
    clock = TestClock(DateTime.utc(2026, 11, 5, 10));
    organizations = OrganizationRepository(db, clock: clock.call);
  });

  Future<void> breakOutbox() => db.customStatement(
    'CREATE TRIGGER outbox_fails BEFORE INSERT ON outbox '
    "BEGIN SELECT RAISE(ABORT, 'outbox kapalı'); END",
  );

  group('updateProfile', () {
    test('alanları yazar; outbox satırın tamamını yeni kolonlarla taşır, '
        'yeni logo yükleme kuyruğuna girer', () async {
      await insertOrganizationRow(db);
      final logo = logoStoragePath(orgId: _org, id: 'logo-1');

      final written = await organizations.updateProfile(
        _org,
        _change(
          name: '  Petek Ltd. ',
          avatarColor: OrgAvatarColor.honey,
          logoPath: logo,
          operationType: OperationType.stationary,
          currency: 'EUR',
        ),
      );

      expect(written, isTrue);
      final row = await db.select(db.organizations).getSingle();
      expect(row.name, 'Petek Ltd.');
      expect(row.currency, 'EUR');
      expect(row.operationType, OperationType.stationary);
      expect(row.avatarColor, OrgAvatarColor.honey);
      expect(row.logoPath, logo);
      expect(row.updatedAt, clock.current);
      final outbox = (await readOutbox(db)).single;
      expect(outbox.recordTable, 'organizations');
      expect(outbox.operation, OutboxOperation.upsert);
      expect(outbox.payload, containsPair('operation_type', 'stationary'));
      expect(outbox.payload, containsPair('avatar_color', 'honey'));
      expect(outbox.payload, containsPair('logo_path', logo));
      expect(outbox.payload, containsPair('currency', 'EUR'));
      expect(outbox.payload, containsPair('tr_aks_no', null));
      expect(outbox.payload.containsKey('server_seq'), isFalse);
      final upload = (await db.select(db.logoUploads).get()).single;
      expect(upload.storagePath, logo);
      expect(upload.uploadStatus, MediaUploadStatus.pending);
    });

    test('logo değişmezse kuyruğa yeniden girmez', () async {
      await insertOrganizationRow(db);
      final logo = logoStoragePath(orgId: _org, id: 'logo-1');
      await organizations.updateProfile(_org, _change(logoPath: logo));
      await db
          .update(db.logoUploads)
          .write(
            const LogoUploadsCompanion(
              uploadStatus: Value(MediaUploadStatus.uploaded),
            ),
          );

      await organizations.updateProfile(_org, _change(logoPath: logo));

      final upload = (await db.select(db.logoUploads).get()).single;
      expect(upload.uploadStatus, MediaUploadStatus.uploaded);
    });

    test('outbox yazılamazsa satır da değişmez', () async {
      await insertOrganizationRow(db);
      await breakOutbox();

      await expectLater(
        organizations.updateProfile(_org, _change(name: 'Yeni ad')),
        throwsA(anything),
      );

      final row = await db.select(db.organizations).getSingle();
      expect(row.name, 'Yılmaz Arıcılık');
      expect(await db.select(db.logoUploads).get(), isEmpty);
    });

    test('satır yoksa false; boş ad ArgumentError', () async {
      expect(await organizations.updateProfile(_org, _change()), isFalse);
      await insertOrganizationRow(db);
      expect(
        () => organizations.updateProfile(_org, _change(name: '  ')),
        throwsArgumentError,
      );
      expect(await readOutbox(db), isEmpty);
    });
  });

  group('işletme türü', () {
    test('gezginci → sabit → gezginci: göç kayıtları silinmez', () async {
      await insertOrganizationRow(db);
      await seedMigrations(db);
      final before = await organizations.countMigratoryRecords(_org);

      await organizations.setOperationType(_org, OperationType.stationary);
      final row = await db.select(db.organizations).getSingle();
      expect(row.operationType, OperationType.stationary);
      expect(await organizations.countMigratoryRecords(_org), before);

      await organizations.setOperationType(_org, OperationType.migratory);
      expect(await organizations.countMigratoryRecords(_org), before);
      final payloads = [for (final e in await readOutbox(db)) e.payload];
      expect(
        payloads
            .where((p) => p.containsKey('operation_type'))
            .map((p) => p['operation_type']),
        ['stationary', 'migratory'],
      );
    });

    test('gizlenecek kayıt sayısı silinmiş plan ve durakları saymaz', () async {
      await insertOrganizationRow(db);
      await seedMigrations(db, stopsPerPlan: 3);

      expect(await organizations.countMigratoryRecords(_org), (
        plans: 2,
        stops: 6,
      ));
    });
  });

  test('para birimi değişince geçmiş hareketler kendi para birimini korur; '
      'yeni hareket yenisiyle yazılır', () async {
    await insertOrganizationRow(db);
    final transactions = TransactionRepository(db);
    final old = await transactions.create(
      orgId: _org,
      kind: TransactionKind.expense,
      category: TransactionCategory.equipment,
      amount: 1500,
      currency: 'TRY',
      occurredOn: DateTime(2026, 4, 2),
    );

    await organizations.updateProfile(_org, _change(currency: 'EUR'));
    final fresh = await transactions.create(
      orgId: _org,
      kind: TransactionKind.income,
      category: TransactionCategory.other,
      amount: 80,
      currency: (await db.select(db.organizations).getSingle()).currency,
      occurredOn: DateTime(2026, 11, 5),
    );

    final rows = {
      for (final t in await db.select(db.transactions).get()) t.id: t,
    };
    expect(rows[old.id]!.currency, 'TRY');
    expect(rows[old.id]!.amount, 1500);
    expect(rows[old.id]!.updatedAt, old.updatedAt);
    expect(rows[fresh.id]!.currency, 'EUR');
  });

  group('sayaçlar', () {
    test('aktif kovan, arılık ve muayene sayısı kayıtlardan; silinmiş ve '
        'aktif olmayan sayılmaz', () async {
      await seedCountedRecords(db);

      expect(await organizations.watchCounts(_org).first, (
        hives: 3,
        apiaries: 2,
        inspections: 4,
      ));
    });

    test('yeni kayıt gelince yeniden yayar; başka işletme sayılmaz', () async {
      final counts = <BusinessCounts>[];
      final sub = organizations.watchCounts(_org).listen(counts.add);
      addTearDown(sub.cancel);
      await pumpEventQueue();

      final apiaries = ApiaryRepository(db);
      await apiaries.create(orgId: _org, name: 'Ova');
      await apiaries.create(orgId: 'other-org', name: 'Başka');
      await pumpEventQueue();

      expect(counts.first, (hives: 0, apiaries: 0, inspections: 0));
      expect(counts.last, (hives: 0, apiaries: 1, inspections: 0));
    });
  });

  test('üyelikler: uygulama yazmaz, profiller adsız gelir', () async {
    await addMember(db, userId: 'user-1', role: MembershipRole.worker);
    final row = await db.select(db.memberships).getSingle();
    expect(await MembershipRepository(db).watchProfiles(_org).first, [
      (
        membershipId: row.id,
        userId: 'user-1',
        role: MembershipRole.worker,
        deletionScheduledFor: null,
      ),
    ]);
    expect(await readOutbox(db), isEmpty);
  });

  test(
    'eşitlenecek: outbox bekleyen kaydı bulur, gönderilince düşer',
    () async {
      await insertOrganizationRow(db);
      final sync = SyncRepository(db);
      final pending = <bool>[];
      final sub = sync
          .watchAnyPending([('organizations', _org)])
          .listen(pending.add);
      addTearDown(sub.cancel);
      await pumpEventQueue();

      await organizations.updateProfile(_org, _change(name: 'Yeni'));
      await pumpEventQueue();
      await db.delete(db.outbox).go();
      await pumpEventQueue();

      expect(pending, [false, true, false]);
    },
  );
}
