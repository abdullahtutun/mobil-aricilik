import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mobil_arici/core/db/app_database.dart';
import 'package:mobil_arici/features/harvest/data/harvest_repository.dart';
import 'package:mobil_arici/features/harvest/domain/harvest.dart';
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
  late HarvestRepository repository;
  late HiveRepository hives;
  late Hive first;
  late Hive second;

  setUp(() async {
    db = openTestDatabase();
    clock = TestClock();
    repository = HarvestRepository(db, clock: clock.call);
    hives = HiveRepository(db, clock: clock.call);
    Future<Hive> create(String number) => hives.create(
      orgId: 'org-1',
      number: number,
      type: HiveType.langstroth,
      apiaryId: 'apiary-1',
    );
    first = await create('101');
    second = await create('104');
  });

  /// [hive]'a 24 Ekim'de başlayan, 5 Aralık'ta çıkarılacak şerit; kilit
  /// 5 Aralık'a kadar.
  Future<Treatment> treat(Hive hive) =>
      TreatmentRepository(db, clock: clock.call).addToHive(
        hive,
        TreatmentPlan(
          drug: _refDrug,
          dose: 2,
          startedAt: DateTime.utc(2026, 10, 24, 9),
          plannedRemovalAt: DateTime.utc(2026, 12, 5, 9),
          withdrawalDays: 0,
        ),
      );

  HarvestPlan plan({
    DateTime? harvestedAt,
    int unitCount = 24,
    double netKg = 574.5,
  }) => (
    apiaryId: 'apiary-1',
    harvestedAt: harvestedAt ?? DateTime.utc(2026, 10, 26, 9),
    honeyKind: HoneyKind.pine,
    unit: HarvestUnit.superBox,
    unitCount: unitCount,
    netKg: netKg,
  );

  Future<List<OutboxEntry>> harvestOutbox() async => [
    for (final entry in await readOutbox(db))
      if (entry.recordTable.startsWith('harvest')) entry,
  ];

  Future<List<HarvestHive>> liveHarvestHives() async => [
    for (final row in await db.select(db.harvestHives).get())
      if (row.deletedAt == null) row,
  ];

  test("hasadı ve kovanlarını yazar; outbox payload'u sunucunun "
      'kolonlarıyla, önce hasat sonra kovanlar', () async {
    final record = await repository.add(
      orgId: 'org-1',
      plan: plan(),
      hiveIds: [first.id, second.id],
    );

    expect(await repository.findById(record.harvest.id), record.harvest);
    expect(await repository.findHives(record.harvest.id), record.hives);
    final outbox = await harvestOutbox();
    expect(
      [for (final e in outbox) e.recordTable],
      ['harvests', 'harvest_hives', 'harvest_hives'],
    );
    expect(outbox.first.payload, {
      'id': record.harvest.id,
      'org_id': 'org-1',
      'apiary_id': 'apiary-1',
      'harvested_at': '2026-10-26T09:00:00.000Z',
      'honey_kind': 'pine',
      'unit': 'super',
      'unit_count': 24,
      'net_kg': 574.5,
      'created_at': '2026-10-22T09:00:00.000Z',
      'updated_at': '2026-10-22T09:00:00.000Z',
      'created_by': null,
      'deleted_at': null,
    });
    expect(outbox[1].payload, {
      'id': record.hives.first.id,
      'org_id': 'org-1',
      'harvest_id': record.harvest.id,
      'hive_id': first.id,
      'withdrawal_treatment_id': null,
      'withdrawal_override_reason': null,
      'created_at': '2026-10-22T09:00:00.000Z',
      'updated_at': '2026-10-22T09:00:00.000Z',
      'created_by': null,
      'deleted_at': null,
    });
  });

  group('bekleme süresi kilidi', () {
    test('gerekçesiz kilitli kovan varsa hiçbir şey yazmaz', () async {
      await treat(second);

      await expectLater(
        repository.add(
          orgId: 'org-1',
          plan: plan(),
          hiveIds: [first.id, second.id],
        ),
        throwsA(
          isA<HarvestLockedException>().having((e) => e.hiveIds, 'hiveIds', {
            second.id,
          }),
        ),
      );

      expect(await db.select(db.harvests).get(), isEmpty);
      expect(await db.select(db.harvestHives).get(), isEmpty);
      expect(await harvestOutbox(), isEmpty);
    });

    test('kilitli kovan gerekçesiyle yazılır; kilitsiz kovanın gerekçesi '
        'yazılmaz', () async {
      final treatment = await treat(second);
      const reason = WithdrawalOverrideReason.notForSale;

      final record = await repository.add(
        orgId: 'org-1',
        plan: plan(),
        hiveIds: [first.id, second.id],
        overrides: {
          first.id: const WithdrawalOverride(
            treatmentId: 'yok',
            reason: WithdrawalOverrideReason.removedEarly,
          ),
          second.id: WithdrawalOverride(
            treatmentId: treatment.id,
            reason: reason,
          ),
        },
      );

      final [unlocked, locked] = record.hives;
      expect(unlocked.withdrawalOverride, isNull);
      expect(
        locked.withdrawalOverride,
        WithdrawalOverride(treatmentId: treatment.id, reason: reason),
      );
      expect((await harvestOutbox()).last.payload, {
        ...locked.toJson(),
        'withdrawal_treatment_id': treatment.id,
        'withdrawal_override_reason': 'not_for_sale',
      });
    });

    test('kilit hasat gününe göre: uygulamadan önceki günün hasadı '
        'kilitlenmez', () async {
      await treat(second);

      final record = await repository.add(
        orgId: 'org-1',
        plan: plan(harvestedAt: DateTime(2026, 10, 23, 12)),
        hiveIds: [second.id],
      );

      expect(record.hives.single.withdrawalOverride, isNull);
    });

    test('silinmiş uygulama kilitlemez', () async {
      final treatment = await treat(second);
      await TreatmentRepository(db).delete(treatment.id);

      final record = await repository.add(
        orgId: 'org-1',
        plan: plan(),
        hiveIds: [second.id],
      );

      expect(record.hives.single.hiveId, second.id);
    });
  });

  test('kovansız, tekrar eden kovanlı ya da sınır dışı miktarlı hasat '
      'hiçbir şey yazmaz', () async {
    for (final (hiveIds, harvest) in [
      (<String>[], plan()),
      ([first.id, first.id], plan()),
      ([first.id], plan(unitCount: 0)),
      ([first.id], plan(unitCount: 1001)),
      ([first.id], plan(netKg: 0)),
      ([first.id], plan(netKg: 100000.5)),
    ]) {
      expect(
        () => repository.add(orgId: 'org-1', plan: harvest, hiveIds: hiveIds),
        throwsArgumentError,
      );
    }

    expect(await db.select(db.harvests).get(), isEmpty);
    expect(await harvestOutbox(), isEmpty);
  });

  test('outbox yazılamazsa hasat ve kovanları yazılmaz', () async {
    // Hasat satırı yazıldıktan sonra kovanınki düşsün: hepsi ya da hiçbiri.
    await db.customStatement(
      'CREATE TRIGGER outbox_fails BEFORE INSERT ON outbox '
      "WHEN NEW.record_table = 'harvest_hives' "
      "BEGIN SELECT RAISE(ABORT, 'outbox kapalı'); END",
    );

    await expectLater(
      repository.add(orgId: 'org-1', plan: plan(), hiveIds: [first.id]),
      throwsA(isA<SqliteException>()),
    );

    expect(await db.select(db.harvests).get(), isEmpty);
    expect(await db.select(db.harvestHives).get(), isEmpty);
  });

  test('deleteHarvest hasadı ve kovanlarını yumuşak siler; silmeler '
      "outbox'a gider", () async {
    final record = await repository.add(
      orgId: 'org-1',
      plan: plan(),
      hiveIds: [first.id, second.id],
    );
    clock.advance(const Duration(minutes: 1));

    await repository.deleteHarvest(record.harvest.id);

    expect(await repository.findById(record.harvest.id), isNull);
    expect(await liveHarvestHives(), isEmpty);
    final deletes = [
      for (final entry in await harvestOutbox())
        if (entry.operation == OutboxOperation.delete) entry.recordTable,
    ];
    expect(deletes, ['harvest_hives', 'harvest_hives', 'harvests']);
    final row = await db.select(db.harvests).getSingle();
    expect(row.deletedAt, DateTime.utc(2026, 10, 22, 9, 1));
  });
}
