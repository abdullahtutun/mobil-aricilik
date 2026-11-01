import 'package:flutter_test/flutter_test.dart';
import 'package:mobil_arici/core/db/app_database.dart';
import 'package:mobil_arici/features/harvest/data/harvest_repository.dart';
import 'package:mobil_arici/features/harvest/data/lot_repository.dart';
import 'package:mobil_arici/features/harvest/domain/harvest.dart';
import 'package:mobil_arici/features/harvest/domain/lot.dart';
import 'package:mobil_arici/features/health/data/treatment_repository.dart';
import 'package:mobil_arici/features/health/domain/drug.dart';
import 'package:mobil_arici/features/health/domain/treatment.dart';
import 'package:mobil_arici/features/health/domain/withdrawal.dart';
import 'package:mobil_arici/features/hives/data/hive_repository.dart';
import 'package:mobil_arici/features/hives/domain/hive.dart';

import '../../../helpers/test_database.dart';

const _refDrug = DrugChoice(
  refDrugId: 'ref-drug-1',
  name: 'Amitraz şerit',
  activeIngredient: DrugActiveIngredient.amitraz,
  doseUnit: DrugDoseUnit.strip,
);

void main() {
  late AppDatabase db;
  late TestClock clock;
  late LotRepository lots;
  late HarvestRepository harvests;
  late Hive first;
  late Hive second;

  setUp(() async {
    db = openTestDatabase();
    clock = TestClock(DateTime.utc(2026, 10, 26, 9));
    lots = LotRepository(db, clock: clock.call);
    harvests = HarvestRepository(db, clock: clock.call);
    final hives = HiveRepository(db, clock: clock.call);
    Future<Hive> create(String number) => hives.create(
      orgId: 'org-1',
      number: number,
      type: HiveType.langstroth,
      apiaryId: 'apiary-1',
    );
    first = await create('101');
    second = await create('104');
  });

  /// [hive]'a [startedAt]'te başlayan, [removalAt]'te çıkarılacak şerit.
  Future<Treatment> treat(Hive hive, DateTime startedAt, DateTime removalAt) =>
      TreatmentRepository(db, clock: clock.call).addToHive(
        hive,
        TreatmentPlan(
          drug: _refDrug,
          dose: 2,
          startedAt: startedAt,
          plannedRemovalAt: removalAt,
          withdrawalDays: 0,
        ),
      );

  Future<Harvest> harvest({
    double netKg = 574,
    DateTime? at,
    List<Hive>? hives,
    Map<String, WithdrawalOverride> overrides = const {},
  }) async => (await harvests.add(
    orgId: 'org-1',
    plan: (
      apiaryId: 'apiary-1',
      harvestedAt: at ?? DateTime.utc(2026, 10, 26, 9),
      honeyKind: HoneyKind.pine,
      unit: HarvestUnit.superBox,
      unitCount: 24,
      netKg: netKg,
    ),
    hiveIds: [
      for (final hive in hives ?? [first, second]) hive.id,
    ],
    overrides: overrides,
  )).harvest;

  Future<List<OutboxEntry>> lotOutbox() async => [
    for (final entry in await readOutbox(db))
      if (entry.recordTable.startsWith('lot') ||
          entry.recordTable == 'lab_results')
        entry,
  ];

  Future<LotSummary> summary(String id) async =>
      (await lots.watchSummary(id).first)!;

  test('yeni lot hasadın yılında sıradaki numarayı ve bal türünü alır; '
      "lot, lot hasadı ve ilaçlama kopyası outbox'a sunucunun kolonlarıyla "
      'gider', () async {
    await treat(
      first,
      DateTime.utc(2026, 8, 1, 9),
      DateTime.utc(2026, 9, 1, 9),
    );
    final h1 = await harvest();
    final lot1 = await lots.createWithHarvest(
      h1,
      origin: '  Kızılçam ',
      moisture: 17.2,
    );
    final h2 = await harvest(netKg: 80);
    final lot2 = await lots.createWithHarvest(h2);

    expect((lot1.year, lot1.seq, lot2.seq), (2026, 1, 2));
    expect(lot1.honeyKind, HoneyKind.pine);
    expect(lot1.origin, 'Kızılçam');
    expect(lot1.status, LotStatus.open);

    final outbox = await lotOutbox();
    expect(outbox.map((e) => e.recordTable).take(3), [
      'lots',
      'lot_harvests',
      'lot_treatments',
    ]);
    expect(outbox.first.payload, {
      'id': lot1.id,
      'org_id': 'org-1',
      'year': 2026,
      'seq': 1,
      'honey_kind': 'pine',
      'status': 'open',
      'origin': 'Kızılçam',
      'moisture': 17.2,
      'created_at': '2026-10-26T09:00:00.000Z',
      'updated_at': '2026-10-26T09:00:00.000Z',
      'created_by': null,
      'deleted_at': null,
    });
    expect(outbox[2].payload['withdrawal_ends_on'], '2026-09-01');
    expect(outbox[2].payload['withdrawal_violation'], false);
    expect(outbox[2].payload.containsKey('server_seq'), isFalse);
  });

  test('son ilaçlamayı bağlar; hasat günü bekleme süresindeyse lot '
      'ihlal taşır, ilaçlanmamış kovan için kopya yok', () async {
    await treat(
      first,
      DateTime.utc(2026, 6, 1, 9),
      DateTime.utc(2026, 7, 1, 9),
    );
    final last = await treat(
      first,
      DateTime.utc(2026, 10, 1, 9),
      DateTime.utc(2026, 11, 10, 9),
    );
    // Hasattan sonra başlayan uygulama sayılmaz.
    await treat(
      second,
      DateTime.utc(2026, 10, 27, 9),
      DateTime.utc(2026, 11, 27, 9),
    );
    final h = await harvest(
      overrides: {
        first.id: WithdrawalOverride(
          treatmentId: last.id,
          reason: WithdrawalOverrideReason.notForSale,
        ),
      },
    );
    final lot = await lots.createWithHarvest(h);

    final links = await lots.watchTreatments(lot.id).first;
    expect(links, hasLength(1));
    expect(links.single.link.hiveId, first.id);
    expect(links.single.link.treatmentId, last.id);
    expect(links.single.link.withdrawalEndsOn, DateTime(2026, 11, 10));
    expect(links.single.link.withdrawalViolation, isTrue);
    expect(links.single.hiveNumber, '101');
    expect(links.single.productName, 'Amitraz şerit');
    expect((await summary(lot.id)).violation, isTrue);
  });

  test('özet: kilogram hasatların, stok satışlar düşülmüş, kovan sayısı '
      'farklı kovanlar; analiz ve satış akışı günceller', () async {
    final h1 = await harvest(hives: [first]);
    final lot = await lots.createWithHarvest(h1);
    final h2 = await harvest(netKg: 26.5, hives: [first, second]);
    final stream = lots.watchSummaries('org-1');
    final updates = expectLater(
      stream.map((rows) => rows.single.soldKg),
      emitsThrough(100.0),
    );
    await lots.attachHarvest(lot, h2);

    var s = await summary(lot.id);
    expect(
      (s.kg, s.soldKg, s.hiveCount, s.analyzed, s.violation),
      (600.5, 0.0, 2, false, false),
    );

    await lots.sales.add(lot, 100, soldOn: DateTime(2026, 10, 27));
    await lots.labResults.add(lot, (
      testedOn: DateTime(2026, 10, 28),
      hmf: 12.4,
      diastase: null,
      proline: null,
      moisture: null,
      residue: ResidueResult.none,
      documentId: null,
    ));
    await updates;
    s = await summary(lot.id);
    expect((s.soldKg, s.analyzed), (100.0, true));
  });

  test('kapalı lota ve başka lottaki hasada eklenmez; bir şey '
      'yazılmaz', () async {
    final h1 = await harvest();
    final lot = await lots.createWithHarvest(h1);
    final other = await lots.createWithHarvest(await harvest());
    final before = (await readOutbox(db)).length;

    await expectLater(
      lots.attachHarvest(other, h1),
      throwsA(isA<HarvestAlreadyInLotException>()),
    );
    final closed = await lots.update(lot.copyWith(status: LotStatus.closed));
    await expectLater(
      lots.attachHarvest(closed, await harvest()),
      throwsStateError,
    );
    // Yalnız lotun güncellemesi ve son hasat yazıldı.
    expect((await readOutbox(db)).length, before + 1 + 3);
    expect(await lots.watchOpen('org-1').first, [
      isA<Lot>().having((l) => l.id, 'id', other.id),
    ]);
  });

  test('outbox yazılamazsa lot da lot hasadı da yazılmaz', () async {
    final h = await harvest();
    await db.customStatement(
      'CREATE TRIGGER outbox_fails BEFORE INSERT ON outbox '
      "BEGIN SELECT RAISE(ABORT, 'outbox kapalı'); END",
    );
    await expectLater(lots.createWithHarvest(h), throwsA(anything));
    expect(await db.select(db.lots).get(), isEmpty);
    expect(await db.select(db.lotHarvests).get(), isEmpty);
  });

  test("hasadın Geri al'ı lot bağını ve ilaçlama kopyalarını siler; lot "
      'kalır', () async {
    await treat(
      first,
      DateTime.utc(2026, 8, 1, 9),
      DateTime.utc(2026, 9, 1, 9),
    );
    final h = await harvest();
    final lot = await lots.createWithHarvest(h);

    await harvests.deleteHarvest(h.id);

    expect(await lots.findById(lot.id), isNotNull);
    expect(await lots.findByHarvest(h.id), isNull);
    expect(await lots.watchTreatments(lot.id).first, isEmpty);
    expect((await summary(lot.id)).kg, 0);
  });

  test('lotu silmek bağlı kayıtları da yumuşak siler', () async {
    final h = await harvest();
    final lot = await lots.createWithHarvest(h);
    await lots.sales.add(lot, 10, soldOn: DateTime(2026, 10, 27));

    await lots.remove(lot.id);

    expect(await lots.watchSummaries('org-1').first, isEmpty);
    expect(await lots.findByHarvest(h.id), isNull);
    expect(await lots.sales.findByLot(lot.id), isEmpty);
    expect(await harvests.findById(h.id), isNotNull);
  });

  test('geçersiz değerler yazılmaz', () async {
    final lot = await lots.createWithHarvest(await harvest());
    expect(() => lots.update(lot.copyWith(moisture: 35)), throwsArgumentError);
    expect(
      () => lots.sales.add(lot, 0, soldOn: DateTime(2026, 10, 27)),
      throwsArgumentError,
    );
    expect(
      () => lots.labResults.add(lot, (
        testedOn: DateTime(2026, 10, 28),
        hmf: null,
        diastase: null,
        proline: null,
        moisture: null,
        residue: null,
        documentId: null,
      )),
      throwsArgumentError,
    );
  });
}
