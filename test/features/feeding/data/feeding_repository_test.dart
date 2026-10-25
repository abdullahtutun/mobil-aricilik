import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mobil_arici/core/db/app_database.dart';
import 'package:mobil_arici/features/feeding/data/feeding_repository.dart';
import 'package:mobil_arici/features/feeding/domain/feeding.dart';
import 'package:mobil_arici/features/hives/data/hive_repository.dart';
import 'package:mobil_arici/features/hives/domain/hive.dart';
import 'package:mobil_arici/features/inspections/data/inspection_repository.dart';
import 'package:mobil_arici/features/inspections/domain/inspection.dart';

import '../../../helpers/test_database.dart';

void main() {
  late AppDatabase db;
  late TestClock clock;
  late FeedingRepository repository;
  late HiveRepository hives;
  late InspectionRepository inspections;

  setUp(() {
    db = openTestDatabase();
    clock = TestClock();
    repository = FeedingRepository(db, clock: clock.call);
    hives = HiveRepository(db, clock: clock.call);
    inspections = InspectionRepository(db, clock: clock.call);
  });

  Future<Hive> createHive(
    String number, {
    String apiaryId = 'apiary-1',
    HiveStatus status = HiveStatus.active,
  }) => hives.create(
    orgId: 'org-1',
    number: number,
    type: HiveType.langstroth,
    apiaryId: apiaryId,
    status: status,
  );

  /// [hive]'ın muayenesi; [actions] ile.
  Future<Inspection> inspect(Hive hive, Set<InspectionAction> actions) {
    clock.advance(const Duration(minutes: 1));
    return inspections.add(
      orgId: hive.orgId,
      hiveId: hive.id,
      apiaryId: hive.apiaryId,
      values: InspectionValues(actions: actions),
    );
  }

  FeedingPlan plan({
    FeedingKind kind = FeedingKind.syrup2to1,
    double amount = 3,
  }) => (kind: kind, amount: amount, fedAt: DateTime.utc(2026, 10, 26, 9));

  Future<List<OutboxEntry>> feedingOutbox() async => [
    for (final entry in await readOutbox(db))
      if (entry.recordTable == 'feedings') entry,
  ];

  group('tek kovan', () {
    test("kovanın şimdiki arılığında yazar; outbox payload'u sunucunun "
        'kolonlarıyla', () async {
      final hive = await createHive('104');

      final feeding = await repository.addToHive(hive, plan());

      expect(await repository.findById(feeding.id), feeding);
      final entry = (await feedingOutbox()).single;
      expect(entry.operation, OutboxOperation.upsert);
      expect(entry.payload, {
        'id': feeding.id,
        'org_id': 'org-1',
        'hive_id': hive.id,
        'apiary_id': 'apiary-1',
        'feeding_group_id': feeding.feedingGroupId,
        'fed_at': '2026-10-26T09:00:00.000Z',
        'kind': 'syrup_2_1',
        'amount': 3.0,
        'created_at': '2026-10-22T09:00:00.000Z',
        'updated_at': '2026-10-22T09:00:00.000Z',
        'created_by': null,
        'deleted_at': null,
      });
    });

    test('bal katı olan kovana da yazar (uyarı ekranın)', () async {
      final hive = await createHive('104');
      await inspect(hive, {InspectionAction.superAdded});

      final feeding = await repository.addToHive(hive, plan());

      expect(feeding.hiveId, hive.id);
    });

    test('geçersiz miktarda hiçbir şey yazmaz', () async {
      final hive = await createHive('104');
      for (final amount in [0.0, -1.0, 100.5, double.nan]) {
        expect(
          () => repository.addToHive(hive, plan(amount: amount)),
          throwsArgumentError,
        );
      }

      expect(await db.select(db.feedings).get(), isEmpty);
      expect(await feedingOutbox(), isEmpty);
    });

    test('outbox yazılamazsa besleme yazılmaz', () async {
      final hive = await createHive('104');
      await db.customStatement(
        'CREATE TRIGGER outbox_fails BEFORE INSERT ON outbox '
        "BEGIN SELECT RAISE(ABORT, 'outbox kapalı'); END",
      );

      await expectLater(
        repository.addToHive(hive, plan()),
        throwsA(isA<SqliteException>()),
      );

      expect(await db.select(db.feedings).get(), isEmpty);
    });
  });

  group('arılığın tümü', () {
    test('her aktif kovana numara sırasıyla, ortak grup kimliğiyle yazar; '
        'aktif olmayan, silinmiş ve başka arılıktaki kovana yazmaz', () async {
      final first = await createHive('101');
      final second = await createHive('102');
      await createHive('103', status: HiveStatus.dead);
      await createHive('201', apiaryId: 'apiary-2');
      final deleted = await createHive('104');
      await hives.delete(deleted.id);

      final feedings = await repository.addToApiary(
        'apiary-1',
        plan(kind: FeedingKind.beeCake, amount: 1),
      );

      expect([for (final f in feedings) f.hiveId], [first.id, second.id]);
      expect({for (final f in feedings) f.feedingGroupId}, hasLength(1));
      expect({for (final f in feedings) f.kind}, {FeedingKind.beeCake});
      expect(await feedingOutbox(), hasLength(2));
    });

    test('şurupta son kat işlemi "Kat verildi" olan kovanı atlar; kat '
        'alınmış ya da başka arılıkta kat verilmiş kovanı atlamaz', () async {
      final withSuper = await createHive('101');
      final removed = await createHive('102');
      final plain = await createHive('103');
      await inspect(withSuper, {InspectionAction.superAdded});
      await inspect(removed, {InspectionAction.superAdded});
      await inspect(removed, {InspectionAction.superRemoved});
      await inspect(plain, {InspectionAction.fed});

      final syrup = await repository.addToApiary('apiary-1', plan());

      expect([for (final f in syrup) f.hiveId], [removed.id, plain.id]);

      // Kek bala karışmaz; bal katlı kovan da beslenir.
      final cake = await repository.addToApiary(
        'apiary-1',
        plan(kind: FeedingKind.beeCake, amount: 1),
      );
      expect(cake, hasLength(3));
    });

    test('kat verilen kovan başka arılığa taşınınca o arılıkta da '
        'atlanır', () async {
      final hive = await createHive('101');
      await inspect(hive, {InspectionAction.superAdded});
      await hives.move(hive.id, apiaryId: 'apiary-2');

      expect(await repository.addToApiary('apiary-2', plan()), isEmpty);
      expect(await feedingOutbox(), isEmpty);
    });

    test('silinmiş muayenenin kat işlemi sayılmaz', () async {
      final hive = await createHive('101');
      final inspection = await inspect(hive, {InspectionAction.superAdded});
      await inspections.delete(inspection.id);

      expect(await repository.addToApiary('apiary-1', plan()), hasLength(1));
    });

    test('bir kovanın yazması başarısızsa hiçbiri yazılmaz', () async {
      await createHive('101');
      final second = await createHive('102');
      await db.customStatement(
        'CREATE TRIGGER feeding_fails BEFORE INSERT ON feedings '
        "WHEN NEW.hive_id = '${second.id}' "
        "BEGIN SELECT RAISE(ABORT, 'kapalı'); END",
      );

      await expectLater(
        repository.addToApiary('apiary-1', plan()),
        throwsA(isA<SqliteException>()),
      );

      expect(await db.select(db.feedings).get(), isEmpty);
      expect(await feedingOutbox(), isEmpty);
    });

    test('geri al hepsini tek seferde yumuşak siler', () async {
      await createHive('101');
      await createHive('102');
      final feedings = await repository.addToApiary('apiary-1', plan());
      clock.advance(const Duration(seconds: 5));

      await repository.deleteAll(feedings);

      for (final feeding in feedings) {
        expect(await repository.findById(feeding.id), isNull);
      }
      final rows = await db.select(db.feedings).get();
      expect({for (final row in rows) row.deletedAt}, {clock.current});
      expect(
        [for (final e in await feedingOutbox()) e.operation],
        [
          OutboxOperation.upsert,
          OutboxOperation.upsert,
          OutboxOperation.delete,
          OutboxOperation.delete,
        ],
      );
    });
  });

  test('bal katı akışı: kat verilince ve alınınca yeniden yayar', () async {
    final hive = await createHive('101');
    final stream = inspections.watchSuperChangesByApiary('apiary-1');
    final emitted = <int>[];
    final subscription = stream.listen((rows) => emitted.add(rows.length));
    await pumpEventQueue();

    await inspect(hive, {InspectionAction.superAdded});
    await pumpEventQueue();
    await inspect(hive, {InspectionAction.framesAdded});
    await pumpEventQueue();
    await inspect(hive, {InspectionAction.superRemoved});
    await pumpEventQueue();
    await subscription.cancel();

    // Kat işlemi olmayan muayene listeye girmez.
    expect(emitted.last, 2);
    expect(emitted.first, 0);
  });
}
