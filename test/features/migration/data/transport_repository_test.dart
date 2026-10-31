import 'package:flutter_test/flutter_test.dart';
import 'package:mobil_arici/core/db/app_database.dart';
import 'package:mobil_arici/features/hives/data/hive_location_repository.dart';
import 'package:mobil_arici/features/hives/data/hive_repository.dart';
import 'package:mobil_arici/features/hives/domain/hive.dart';
import 'package:mobil_arici/features/migration/data/migration_repository.dart';
import 'package:mobil_arici/features/migration/data/transport_repository.dart';
import 'package:mobil_arici/features/migration/domain/migration.dart';
import 'package:mobil_arici/features/migration/domain/transport.dart';
import 'package:mobil_arici/features/migration/domain/transport_rules.dart';

import '../../../helpers/test_database.dart';

void main() {
  late AppDatabase db;
  late TestClock clock;
  late TransportRepository repository;
  late HiveRepository hives;

  setUp(() {
    db = openTestDatabase();
    clock = TestClock();
    repository = TransportRepository(db, clock: clock.call);
    hives = HiveRepository(db, clock: clock.call);
  });

  Future<Hive> hive(String number, {String apiaryId = 'cam'}) => hives.create(
    orgId: 'org-1',
    number: number,
    type: HiveType.langstroth,
    apiaryId: apiaryId,
  );

  Future<Transport> start({List<String> vehicles = const ['Kamyon 1']}) =>
      repository.start(
        orgId: 'org-1',
        migrationStopId: 'stop-1',
        sourceApiaryId: 'cam',
        destinationApiaryId: 'kislak',
        vehicles: vehicles,
      );

  Future<void> breakOutbox() => db.customStatement(
    'CREATE TRIGGER outbox_fails BEFORE INSERT ON outbox '
    "BEGIN SELECT RAISE(ABORT, 'outbox kapalı'); END",
  );

  test('taşımayı yükleme adımında yazar; outbox payload’u sunucunun '
      'kolonlarıyla, araçlar dizi', () async {
    final transport = await start(vehicles: [' Kamyon 1 ', 'Kamyon 2']);

    expect(transport.status, TransportStatus.loading);
    final outbox = await readOutbox(db);
    expect(outbox.single.recordTable, 'transports');
    expect(outbox.single.payload, {
      'id': transport.id,
      'org_id': 'org-1',
      'source_apiary_id': 'cam',
      'destination_apiary_id': 'kislak',
      'vehicles': ['Kamyon 1', 'Kamyon 2'],
      'status': 'loading',
      'migration_stop_id': 'stop-1',
      'completed_at': null,
      'created_at': '2026-10-22T09:00:00.000Z',
      'updated_at': '2026-10-22T09:00:00.000Z',
      'created_by': null,
      'deleted_at': null,
    });
    expect((await repository.findById(transport.id))!.vehicles, [
      'Kamyon 1',
      'Kamyon 2',
    ]);
  });

  test('geçersiz taşıma yazılmaz', () async {
    Future<Transport> startWith({
      String destination = 'kislak',
      List<String> vehicles = const ['Kamyon 1'],
    }) => repository.start(
      orgId: 'org-1',
      sourceApiaryId: 'cam',
      destinationApiaryId: destination,
      vehicles: vehicles,
    );

    expect(() => startWith(destination: 'cam'), throwsArgumentError);
    expect(() => startWith(vehicles: []), throwsArgumentError);
    expect(() => startWith(vehicles: ['  ']), throwsArgumentError);
    expect(() => startWith(vehicles: ['K' * 61]), throwsArgumentError);
    expect(
      () => startWith(vehicles: ['Kamyon 1', ' Kamyon 1']),
      throwsArgumentError,
    );
    expect(await readOutbox(db), isEmpty);
  });

  test('araç ekler; aynı ad ya da boş ad reddedilir', () async {
    final transport = await start();

    final updated = await repository.addVehicle(transport.id, ' Kamyon 2 ');

    expect(updated.vehicles, ['Kamyon 1', 'Kamyon 2']);
    expect(
      () => repository.addVehicle(transport.id, 'Kamyon 2'),
      throwsArgumentError,
    );
    expect(() => repository.addVehicle(transport.id, ''), throwsArgumentError);
  });

  test('kovanı araca yükler; ikinci okutma yazmaz, başka arılıktaki kovan '
      'uyarıyla yüklenir', () async {
    final transport = await start(vehicles: ['Kamyon 1', 'Kamyon 2']);
    final h101 = await hive('101');
    final stray = await hive('7', apiaryId: 'baska');
    final before = (await readOutbox(db)).length;

    clock.advance(const Duration(minutes: 1));
    expect(
      await repository.load(transport.id, hiveId: h101.id, vehicle: 'Kamyon 2'),
      LoadResult.loaded,
    );
    expect(
      await repository.load(transport.id, hiveId: h101.id, vehicle: 'Kamyon 1'),
      LoadResult.alreadyLoaded,
    );
    expect(
      await repository.load(
        transport.id,
        hiveId: stray.id,
        vehicle: 'Kamyon 1',
      ),
      LoadResult.loadedFromOtherApiary,
    );

    final items = await repository.items.findByTransport(transport.id);
    expect(items, hasLength(2));
    final item = items.firstWhere((i) => i.hiveId == h101.id);
    expect(item.vehicle, 'Kamyon 2');
    expect(item.loadedAt, DateTime.utc(2026, 10, 22, 9, 1));
    expect(item.unloadedAt, isNull);
    final outbox = await readOutbox(db);
    expect(outbox, hasLength(before + 2));
    expect(outbox[before].recordTable, 'transport_items');
    expect(outbox[before].payload, {
      'id': item.id,
      'org_id': 'org-1',
      'transport_id': transport.id,
      'hive_id': h101.id,
      'vehicle': 'Kamyon 2',
      'loaded_at': '2026-10-22T09:01:00.000Z',
      'unloaded_at': null,
      'created_at': '2026-10-22T09:01:00.000Z',
      'updated_at': '2026-10-22T09:01:00.000Z',
      'created_by': null,
      'deleted_at': null,
    });
  });

  test('yükleme: bilinmeyen araç, olmayan kovan ve yanlış adım '
      'reddedilir', () async {
    final transport = await start();
    final h101 = await hive('101');

    expect(
      () => repository.load(transport.id, hiveId: h101.id, vehicle: 'Römork'),
      throwsStateError,
    );
    expect(
      () => repository.load(transport.id, hiveId: 'yok', vehicle: 'Kamyon 1'),
      throwsStateError,
    );
    await repository.startUnloading(transport.id);
    expect(
      () => repository.load(transport.id, hiveId: h101.id, vehicle: 'Kamyon 1'),
      throwsStateError,
    );
    expect(await repository.items.findByTransport(transport.id), isEmpty);
  });

  test('outbox yazılamazsa kovan yüklenmez', () async {
    final transport = await start();
    final h101 = await hive('101');
    await breakOutbox();

    await expectLater(
      repository.load(transport.id, hiveId: h101.id, vehicle: 'Kamyon 1'),
      throwsA(anything),
    );

    expect(await repository.items.findByTransport(transport.id), isEmpty);
  });

  test('indirme: okutulan kovan indirilir; yüklenmemiş ya da ikinci kez '
      'okutulan kovan yazmaz', () async {
    final transport = await start();
    final h101 = await hive('101');
    final h102 = await hive('102');
    await repository.load(transport.id, hiveId: h101.id, vehicle: 'Kamyon 1');

    expect(
      () => repository.unload(transport.id, hiveId: h101.id),
      throwsStateError,
      reason: 'yükleme adımında indirilemez',
    );
    await repository.startUnloading(transport.id);
    clock.advance(const Duration(hours: 6));

    expect(
      await repository.unload(transport.id, hiveId: h101.id),
      UnloadResult.unloaded,
    );
    expect(
      await repository.unload(transport.id, hiveId: h101.id),
      UnloadResult.alreadyUnloaded,
    );
    expect(
      await repository.unload(transport.id, hiveId: h102.id),
      UnloadResult.notLoaded,
    );
    final item = await repository.items.findByHive(transport.id, h101.id);
    expect(item!.unloadedAt, DateTime.utc(2026, 10, 22, 15));
    expect((await readOutbox(db)).last.payload['unloaded_at'], isNotNull);
  });

  test('bitirince indirilen kovanlar hedefe taşınır ve geçmişe indirildiği '
      'anla yazılır; indirilmeyen kovan yerinde kalır', () async {
    final transport = await start();
    final h101 = await hive('101');
    final h102 = await hive('102');
    await repository.load(transport.id, hiveId: h101.id, vehicle: 'Kamyon 1');
    await repository.load(transport.id, hiveId: h102.id, vehicle: 'Kamyon 1');
    await repository.startUnloading(transport.id);
    clock.advance(const Duration(hours: 6));
    await repository.unload(transport.id, hiveId: h101.id);
    clock.advance(const Duration(minutes: 30));

    expect(await repository.complete(transport.id), 1);

    expect((await hives.findById(h101.id))!.apiaryId, 'kislak');
    expect((await hives.findById(h102.id))!.apiaryId, 'cam');
    final history = await HiveLocationRepository(db).watchByHive(h101.id).first;
    expect(history.map((e) => e.apiaryId), containsAll(['cam', 'kislak']));
    expect(
      history.firstWhere((e) => e.apiaryId == 'kislak').movedAt,
      DateTime.utc(2026, 10, 22, 15),
    );
    final done = (await repository.findById(transport.id))!;
    expect(done.status, TransportStatus.completed);
    expect(done.completedAt, DateTime.utc(2026, 10, 22, 15, 30));
    expect(() => repository.complete(transport.id), throwsStateError);
  });

  test('bitirince taşımanın durağı şu an olur, kovan sayısı indirilen '
      'sayı; plandaki önceki şu an durak geçmiş olur', () async {
    final migrations = MigrationRepository(db, clock: clock.call);
    final migration = await migrations.create(
      orgId: 'org-1',
      year: 2026,
      name: 'Göç planı',
    );
    Future<MigrationStop> stop(
      int position,
      String name,
      MigrationStopStatus status,
    ) => migrations.stops.create(
      orgId: 'org-1',
      migrationId: migration.id,
      plan: (
        position: position,
        name: name,
        place: null,
        plannedStartOn: DateTime(2026, position * 3),
        plannedEndOn: DateTime(2026, position * 3, 20),
        apiaryId: null,
        hiveCount: 152,
        status: status,
      ),
    );
    final cam = await stop(1, 'Çam', MigrationStopStatus.current);
    final kislak = await stop(2, 'Kışlak', MigrationStopStatus.planned);
    final transport = await repository.start(
      orgId: 'org-1',
      migrationStopId: kislak.id,
      sourceApiaryId: 'cam',
      destinationApiaryId: 'kislak',
      vehicles: ['Kamyon 1'],
    );
    final h101 = await hive('101');
    final h102 = await hive('102');
    await repository.load(transport.id, hiveId: h101.id, vehicle: 'Kamyon 1');
    await repository.load(transport.id, hiveId: h102.id, vehicle: 'Kamyon 1');
    await repository.startUnloading(transport.id);
    await repository.unload(transport.id, hiveId: h101.id);

    await repository.complete(transport.id);

    final arrived = (await migrations.stops.findById(kislak.id))!;
    expect(arrived.status, MigrationStopStatus.current);
    expect(arrived.hiveCount, 1);
    expect(arrived.name, 'Kışlak');
    expect(
      (await migrations.stops.findById(cam.id))!.status,
      MigrationStopStatus.past,
    );
    final tables = (await readOutbox(db)).map((e) => e.recordTable).toList();
    expect(tables.where((t) => t == 'migration_stops'), hasLength(4));
  });

  test('durağı silinmiş taşıma yine biter', () async {
    final transport = await start();
    await repository.startUnloading(transport.id);

    expect(await repository.complete(transport.id), 0);
    expect(
      (await repository.findById(transport.id))!.status,
      TransportStatus.completed,
    );
  });

  test('outbox yazılamazsa bitirme hiçbir kovanı taşımaz', () async {
    final transport = await start();
    final h101 = await hive('101');
    await repository.load(transport.id, hiveId: h101.id, vehicle: 'Kamyon 1');
    await repository.startUnloading(transport.id);
    await repository.unload(transport.id, hiveId: h101.id);
    await breakOutbox();

    await expectLater(repository.complete(transport.id), throwsA(anything));

    expect((await hives.findById(h101.id))!.apiaryId, 'cam');
    expect(
      (await repository.findById(transport.id))!.status,
      TransportStatus.unloading,
    );
  });

  test('durağın en son taşımasını ve kovanlarını Stream olarak '
      'yayar', () async {
    final latest = repository.watchLatestForStop('stop-1');
    expect(await latest.first, isNull);

    await start();
    clock.advance(const Duration(minutes: 1));
    final second = await start();
    expect((await latest.first)!.id, second.id);

    final h101 = await hive('101');
    final items = repository.items.watchByTransport(second.id);
    expect(await items.first, isEmpty);
    await repository.load(second.id, hiveId: h101.id, vehicle: 'Kamyon 1');
    expect((await items.first).single.hiveId, h101.id);

    await repository.delete(second.id);
    expect((await latest.first)!.id, isNot(second.id));
  });
}
