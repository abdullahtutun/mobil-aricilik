import 'package:flutter_test/flutter_test.dart';
import 'package:mobil_arici/core/db/app_database.dart';
import 'package:mobil_arici/features/harvest/domain/harvest.dart';
import 'package:mobil_arici/features/migration/data/migration_repository.dart';
import 'package:mobil_arici/features/migration/domain/migration.dart';

import '../../../helpers/test_database.dart';

void main() {
  late AppDatabase db;
  late TestClock clock;
  late MigrationRepository repository;
  late MigrationStopRepository stops;

  setUp(() {
    db = openTestDatabase();
    clock = TestClock();
    repository = MigrationRepository(db, clock: clock.call);
    stops = repository.stops;
  });

  MigrationStopPlan plan({
    int position = 1,
    String name = 'Çam',
    String? place = 'Ula, Muğla',
    DateTime? start,
    DateTime? end,
    String? apiaryId,
    int? hiveCount = 152,
    MigrationStopStatus status = MigrationStopStatus.planned,
  }) => (
    position: position,
    name: name,
    place: place,
    plannedStartOn: start ?? DateTime(2026, 8),
    plannedEndOn: end ?? DateTime(2026, 11, 15),
    apiaryId: apiaryId,
    hiveCount: hiveCount,
    status: status,
  );

  Future<Migration> createMigration({int year = 2026}) =>
      repository.create(orgId: 'org-1', year: year, name: 'Göç planı');

  Future<MigrationStop> createStop(
    String migrationId,
    MigrationStopPlan plan,
  ) => stops.create(orgId: 'org-1', migrationId: migrationId, plan: plan);

  Future<void> breakOutbox() => db.customStatement(
    'CREATE TRIGGER outbox_fails BEFORE INSERT ON outbox '
    "BEGIN SELECT RAISE(ABORT, 'outbox kapalı'); END",
  );

  test('planı ve durağı yazar; outbox payload’u sunucunun kolonlarıyla, '
      'metinler kırpılır, günler saatsiz', () async {
    final migration = await repository.create(
      orgId: 'org-1',
      year: 2026,
      name: '  Göç planı ',
    );
    final stop = await createStop(
      migration.id,
      plan(
        name: ' Çam ',
        place: '  ',
        start: DateTime(2026, 8, 1, 14, 30),
        apiaryId: 'apiary-1',
      ),
    );

    final outbox = await readOutbox(db);
    expect(outbox.map((e) => e.recordTable), ['migrations', 'migration_stops']);
    expect(outbox.first.payload, {
      'id': migration.id,
      'org_id': 'org-1',
      'year': 2026,
      'name': 'Göç planı',
      'created_at': '2026-10-22T09:00:00.000Z',
      'updated_at': '2026-10-22T09:00:00.000Z',
      'created_by': null,
      'deleted_at': null,
    });
    expect(outbox.last.payload, {
      'id': stop.id,
      'org_id': 'org-1',
      'migration_id': migration.id,
      'position': 1,
      'name': 'Çam',
      'planned_start_on': '2026-08-01',
      'planned_end_on': '2026-11-15',
      'status': 'planned',
      'place': null,
      'apiary_id': 'apiary-1',
      'hive_count': 152,
      'created_at': '2026-10-22T09:00:00.000Z',
      'updated_at': '2026-10-22T09:00:00.000Z',
      'created_by': null,
      'deleted_at': null,
    });
  });

  test('geçersiz değerler ArgumentError atar ve bir şey yazmaz', () async {
    await expectLater(
      repository.create(orgId: 'org-1', year: 2026, name: '  '),
      throwsArgumentError,
    );
    await expectLater(
      repository.create(orgId: 'org-1', year: 1999, name: 'Plan'),
      throwsArgumentError,
    );
    final migration = await createMigration();
    for (final invalid in [
      plan(name: ' '),
      plan(position: 0),
      plan(hiveCount: -1),
      plan(start: DateTime(2026, 9), end: DateTime(2026, 8)),
    ]) {
      await expectLater(createStop(migration.id, invalid), throwsArgumentError);
    }
    expect(await db.select(db.migrationStops).get(), isEmpty);
    expect(await readOutbox(db), hasLength(1));
  });

  test('outbox yazılamazsa tablo da değişmez', () async {
    final migration = await createMigration();
    await breakOutbox();

    await expectLater(createStop(migration.id, plan()), throwsA(anything));
    await expectLater(createMigration(), throwsA(anything));

    expect(await db.select(db.migrationStops).get(), isEmpty);
    expect(await db.select(db.migrations).get(), hasLength(1));
  });

  test('bir durak şu an yapılınca aynı plandaki önceki şu an durak geçmiş '
      'olur; başka plan değişmez', () async {
    final migration = await createMigration();
    final other = await createMigration(year: 2027);
    final cam = await createStop(
      migration.id,
      plan(status: MigrationStopStatus.current),
    );
    final elsewhere = await createStop(
      other.id,
      plan(status: MigrationStopStatus.current),
    );
    final kislak = await createStop(
      migration.id,
      plan(position: 2, name: 'Kışlak'),
    );
    clock.advance(const Duration(hours: 1));

    await stops.update(
      kislak,
      plan(position: 2, name: 'Kışlak', status: MigrationStopStatus.current),
    );

    expect((await stops.findById(cam.id))!.status, MigrationStopStatus.past);
    expect(
      (await stops.findById(kislak.id))!.status,
      MigrationStopStatus.current,
    );
    expect(
      (await stops.findById(elsewhere.id))!.status,
      MigrationStopStatus.current,
    );
    final updates = (await readOutbox(db)).skip(5);
    expect(updates.map((e) => (e.recordId, e.payload['status'])), [
      (cam.id, 'past'),
      (kislak.id, 'current'),
    ]);
  });

  test('durakları rota sırasıyla izler; ekleme, düzenleme ve silmede yeniden '
      'yayar; sonraki sıra en büyük sıradan bir fazla', () async {
    final migration = await createMigration();
    expect(await stops.nextPosition(migration.id), 1);
    final emitted = <List<String>>[];
    final subscription = stops
        .watchByMigration(migration.id)
        .listen((list) => emitted.add([for (final s in list) s.name]));
    addTearDown(subscription.cancel);

    final kislak = await createStop(
      migration.id,
      plan(position: 5, name: 'Kışlak'),
    );
    await createStop(migration.id, plan(position: 2, name: 'Yayla'));
    expect(await stops.nextPosition(migration.id), 6);
    await stops.update(kislak, plan(name: 'Kışlak'));
    await stops.delete(kislak.id);
    await pumpEventQueue();

    expect(emitted, [
      <String>[],
      ['Kışlak'],
      ['Yayla', 'Kışlak'],
      ['Kışlak', 'Yayla'],
      ['Yayla'],
    ]);
    expect(await stops.nextPosition(migration.id), 3);
  });

  test(
    'planı silmek duraklarını da tek transaction’da yumuşak siler',
    () async {
      final migration = await createMigration();
      final stop = await createStop(migration.id, plan());

      await repository.remove(migration.id);

      expect(await repository.findById(migration.id), isNull);
      expect(await stops.findById(stop.id), isNull);
      final deletes = (await readOutbox(db))
          .where((e) => e.operation == OutboxOperation.delete);
      expect(deletes.map((e) => e.recordId), [stop.id, migration.id]);
    },
  );

  test(
    'arılıkların hasatları silinmemiş hasat kovanı sayısıyla gelir',
    () async {
      final at = DateTime.utc(2025, 7);
      Future<void> harvest(
        String id,
        String apiaryId,
        List<String> hives,
      ) async {
        await db
            .into(db.harvests)
            .insert(
              Harvest(
                id: id,
                orgId: 'org-1',
                apiaryId: apiaryId,
                harvestedAt: at,
                honeyKind: HoneyKind.pine,
                unit: HarvestUnit.superBox,
                unitCount: 4,
                netKg: 52,
                createdAt: at,
                updatedAt: at,
              ).toInsertable(),
            );
        for (final hive in hives) {
          await db
              .into(db.harvestHives)
              .insert(
                HarvestHive(
                  id: '$id-$hive',
                  orgId: 'org-1',
                  harvestId: id,
                  hiveId: hive,
                  createdAt: at,
                  updatedAt: at,
                  deletedAt: hive == 'deleted' ? at : null,
                ).toInsertable(),
              );
        }
      }

      await harvest('h1', 'cam', ['a', 'b', 'deleted']);
      await harvest('h2', 'yayla', ['c']);

      final entries = await repository.watchApiaryHarvests({'cam'}).first;
      expect(entries, [
        (apiaryId: 'cam', harvestedAt: at, netKg: 52.0, hiveCount: 2),
      ]);
      expect(await repository.watchApiaryHarvests({}).first, isEmpty);
    },
  );
}
