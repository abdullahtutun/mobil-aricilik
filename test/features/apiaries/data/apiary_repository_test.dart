import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mobil_arici/core/db/app_database.dart';
import 'package:mobil_arici/features/apiaries/data/apiary_repository.dart';
import 'package:mobil_arici/features/apiaries/domain/apiary.dart';
import 'package:mobil_arici/features/apiaries/domain/apiary_summary.dart';
import 'package:mobil_arici/features/hives/data/hive_repository.dart';
import 'package:mobil_arici/features/hives/domain/hive.dart';

import '../../../helpers/test_database.dart';

void main() {
  late AppDatabase db;
  late ApiaryRepository repository;

  setUp(() {
    db = openTestDatabase();
    repository = ApiaryRepository(db, clock: TestClock().call);
  });

  test('watchAll yalnız işletmenin silinmemiş arılıkları, ada göre', () async {
    final yayla = await repository.create(orgId: 'org-1', name: 'Yayla');
    final cam = await repository.create(orgId: 'org-1', name: 'Çamlık');
    final ova = await repository.create(orgId: 'org-1', name: 'Ova');
    await repository.create(orgId: 'org-2', name: 'Başkası');
    await repository.delete(ova.id);

    // Ada göre SQLite sırası; Türkçe sıralama ekranda yapılacak.
    expect(await repository.watchAll('org-1').first, [yayla, cam]);
  });

  test(
    'locatedUpdatedAt yalnız işletmenin silinmemiş, konumlu arılıkları',
    () async {
      final yayla = await repository.create(
        orgId: 'org-1',
        name: 'Yayla',
        latitude: 39.93,
        longitude: 32.86,
      );
      await repository.create(orgId: 'org-1', name: 'Konumsuz');
      final silinen = await repository.create(
        orgId: 'org-1',
        name: 'Silinen',
        latitude: 38,
        longitude: 30,
      );
      await repository.create(
        orgId: 'org-2',
        name: 'Başkası',
        latitude: 37,
        longitude: 28,
      );
      await repository.delete(silinen.id);

      expect(await repository.locatedUpdatedAt('org-1'), {
        yayla.id: yayla.updatedAt,
      });
    },
  );

  test('deleteWithHives arılığı ve bütün kovanlarını birlikte siler', () async {
    final hives = HiveRepository(db, clock: TestClock().call);
    final yayla = await repository.create(orgId: 'org-1', name: 'Yayla');
    final ova = await repository.create(orgId: 'org-1', name: 'Ova');
    Future<Hive> hive(String number, String apiaryId) => hives.create(
      orgId: 'org-1',
      number: number,
      type: HiveType.local,
      apiaryId: apiaryId,
    );
    final h1 = await hive('1', yayla.id);
    final h2 = await hive('2', yayla.id);
    final h3 = await hive('3', ova.id);
    await hives.setStatus(h2.id, HiveStatus.dead);
    final outboxBefore = (await readOutbox(db)).length;

    expect(await repository.deleteWithHives(yayla.id), 2);

    expect(await repository.findById(yayla.id), isNull);
    expect(await hives.findById(h1.id), isNull);
    expect(await hives.findById(h2.id), isNull);
    expect(await hives.findById(h3.id), isNotNull);
    expect(await repository.findById(ova.id), isNotNull);
    final added = (await readOutbox(db)).skip(outboxBefore);
    expect(
      [for (final e in added) (e.recordTable, e.recordId, e.operation)],
      unorderedEquals([
        ('hives', h1.id, OutboxOperation.delete),
        ('hives', h2.id, OutboxOperation.delete),
        ('apiaries', yayla.id, OutboxOperation.delete),
      ]),
    );

    // Silinmiş arılık yeniden silinmez.
    expect(await repository.deleteWithHives(yayla.id), 0);
    expect(await readOutbox(db), hasLength(outboxBefore + 3));
  });

  test('tüm alanlar yazılıp aynen okunur', () async {
    final created = await repository.create(
      orgId: 'org-1',
      name: 'Yayla',
      latitude: 40.123456,
      longitude: 29.654321,
      altitudeM: 1250,
      landownerName: 'Ahmet',
      landownerPhone: '+905551112233',
      landTenure: LandTenure.permitted,
      waterSource: 'Çeşme',
      vehicleDistanceM: 300,
      roadNotes: 'Son 2 km toprak',
      notes: 'Rüzgârlı',
    );

    expect(await repository.findById(created.id), created);
    final raw = await db
        .customSelect('SELECT land_tenure FROM apiaries')
        .getSingle();
    expect(raw.read<String>('land_tenure'), 'permitted');
  });

  test('konumun yalnız bir yarısı yazılamaz', () async {
    await expectLater(
      repository.create(orgId: 'org-1', name: 'Yayla', latitude: 40),
      throwsA(isA<SqliteException>()),
    );
    expect(await readOutbox(db), isEmpty);
  });

  group('özetler', () {
    late HiveRepository hives;

    setUp(() => hives = HiveRepository(db, clock: TestClock().call));

    Future<Hive> createHive(
      String apiaryId, {
      HiveStatus status = HiveStatus.active,
    }) => hives.create(
      orgId: 'org-1',
      number: '101',
      type: HiveType.langstroth,
      apiaryId: apiaryId,
      status: status,
    );

    test('yalnız aktif ve silinmemiş kovanlar sayılır', () async {
      final yayla = await repository.create(orgId: 'org-1', name: 'Yayla');
      final ova = await repository.create(orgId: 'org-1', name: 'Ova');
      await createHive(yayla.id);
      await createHive(yayla.id);
      for (final status in HiveStatus.values.skip(1)) {
        await createHive(yayla.id, status: status);
      }
      await hives.delete((await createHive(yayla.id)).id);

      expect(await repository.watchSummaries('org-1').first, [
        ApiarySummary(apiary: ova, activeHiveCount: 0),
        ApiarySummary(apiary: yayla, activeHiveCount: 2),
      ]);
      expect(
        await repository.watchSummary(yayla.id).first,
        ApiarySummary(apiary: yayla, activeHiveCount: 2),
      );
    });

    test('başka işletmenin ve silinmiş arılıklar listelenmez', () async {
      final yayla = await repository.create(orgId: 'org-1', name: 'Yayla');
      final ova = await repository.create(orgId: 'org-1', name: 'Ova');
      await repository.create(orgId: 'org-2', name: 'Başkası');
      await repository.delete(ova.id);

      expect(
        (await repository.watchSummaries('org-1').first).map((s) => s.apiary),
        [yayla],
      );
      expect(await repository.watchSummary(ova.id).first, isNull);
      expect(await repository.watchSummary('yok').first, isNull);
    });

    test(
      'kovan eklenince, durumu değişince ve taşınınca yeniden yayar',
      () async {
        final yayla = await repository.create(orgId: 'org-1', name: 'Yayla');
        final ova = await repository.create(orgId: 'org-1', name: 'Ova');
        final counts = repository
            .watchSummary(yayla.id)
            .map((summary) => summary?.activeHiveCount);
        final expectation = expectLater(counts, emitsInOrder([0, 1, 2, 1, 0]));

        await pumpEventQueue();
        final first = await createHive(yayla.id);
        await pumpEventQueue();
        final second = await createHive(yayla.id);
        await pumpEventQueue();
        await hives.update(first.copyWith(status: HiveStatus.dead));
        await pumpEventQueue();
        await hives.update(second.copyWith(apiaryId: ova.id));

        await expectation;
      },
    );
  });
}
