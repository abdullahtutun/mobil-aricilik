import 'package:flutter_test/flutter_test.dart';
import 'package:mobil_arici/core/db/app_database.dart';
import 'package:mobil_arici/features/hives/data/hive_repository.dart';
import 'package:mobil_arici/features/hives/domain/hive.dart';

import '../../../helpers/test_database.dart';

void main() {
  late AppDatabase db;
  late HiveRepository repository;

  setUp(() {
    db = openTestDatabase();
    repository = HiveRepository(db, clock: TestClock().call);
  });

  Future<Hive> createHive(
    String number, {
    String apiaryId = 'apiary-1',
    String orgId = 'org-1',
  }) => repository.create(
    orgId: orgId,
    number: number,
    type: HiveType.langstroth,
    apiaryId: apiaryId,
  );

  test('varsayılanlar sunucuyla aynı: etkin, tek kat', () async {
    final hive = await createHive('101');

    expect(hive.status, HiveStatus.active);
    expect(hive.boxCount, 1);
    final payload = (await readOutbox(db)).single.payload;
    expect(payload, containsPair('status', 'active'));
    expect(payload, containsPair('box_count', 1));
    expect(payload, containsPair('type', 'langstroth'));
  });

  test('tüm alanlar yazılıp aynen okunur', () async {
    final hive = await repository.create(
      orgId: 'org-1',
      number: 'A-12',
      type: HiveType.dadant,
      apiaryId: 'apiary-1',
      status: HiveStatus.dead,
      tagCode: 'NFC-0042',
      queenId: 'queen-1',
      boxCount: 2,
      frameCount: 18,
      source: HiveSource.package,
      marking: 'Mavi kapak',
    );

    expect(await repository.findById(hive.id), hive);
    final raw = await db
        .customSelect('SELECT type, status, source FROM hives')
        .getSingle();
    expect(raw.data, {'type': 'dadant', 'status': 'dead', 'source': 'package'});
  });

  test('watchByApiary yalnız o arılığın silinmemiş kovanları', () async {
    final a = await createHive('102');
    final b = await createHive('101');
    final removed = await createHive('103');
    await createHive('201', apiaryId: 'apiary-2');
    await repository.delete(removed.id);

    expect(await repository.watchByApiary('apiary-1').first, [b, a]);
  });

  test('kovan başka arılığa geçince iki liste de güncellenir', () async {
    final hive = await createHive('101');
    final first = <List<Hive>>[];
    final second = <List<Hive>>[];
    final subscriptions = [
      repository.watchByApiary('apiary-1').listen(first.add),
      repository.watchByApiary('apiary-2').listen(second.add),
    ];
    addTearDown(() => Future.wait(subscriptions.map((s) => s.cancel())));
    await pumpEventQueue();

    final moved = await repository.update(hive.copyWith(apiaryId: 'apiary-2'));
    await pumpEventQueue();

    expect(first.last, isEmpty);
    expect(second.last, [moved]);
  });

  test('watchAll işletmeye göre süzer', () async {
    final hive = await createHive('101');
    await createHive('101', orgId: 'org-2');

    expect(await repository.watchAll('org-1').first, [hive]);
  });
}
