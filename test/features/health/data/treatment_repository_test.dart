import 'package:drift/drift.dart' show Value;
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mobil_arici/core/db/app_database.dart';
import 'package:mobil_arici/features/health/data/drug_repository.dart';
import 'package:mobil_arici/features/health/data/treatment_repository.dart';
import 'package:mobil_arici/features/health/domain/drug.dart';
import 'package:mobil_arici/features/health/domain/treatment.dart';
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
  late TreatmentRepository repository;
  late HiveRepository hives;

  setUp(() {
    db = openTestDatabase();
    clock = TestClock();
    repository = TreatmentRepository(db, clock: clock.call);
    hives = HiveRepository(db, clock: clock.call);
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

  TreatmentPlan plan({
    DrugChoice drug = _refDrug,
    double dose = 2,
    DateTime? startedAt,
    DateTime? plannedRemovalAt,
    int withdrawalDays = 0,
    String? batchNo = ' 24-118 ',
  }) => TreatmentPlan(
    drug: drug,
    dose: dose,
    startedAt: startedAt ?? DateTime.utc(2026, 10, 24, 9),
    plannedRemovalAt: plannedRemovalAt ?? DateTime.utc(2026, 12, 5, 9),
    withdrawalDays: withdrawalDays,
    batchNo: batchNo,
  );

  /// Kovanların yazdığı outbox kayıtları dışındakiler.
  Future<List<OutboxEntry>> treatmentOutbox() async => [
    for (final entry in await readOutbox(db))
      if (entry.recordTable == 'treatments') entry,
  ];

  group('tek kovan', () {
    test('kovanın şimdiki arılığında yazar; outbox payload’u sunucunun '
        'kolonlarıyla, parti no kırpılır', () async {
      final hive = await createHive('104');

      final treatment = await repository.addToHive(hive, plan());

      expect(await repository.findById(treatment.id), treatment);
      final entry = (await treatmentOutbox()).single;
      expect(entry.operation, OutboxOperation.upsert);
      expect(entry.recordId, treatment.id);
      expect(entry.payload, {
        'id': treatment.id,
        'org_id': 'org-1',
        'hive_id': hive.id,
        'apiary_id': 'apiary-1',
        'product_name': 'Amitraz şerit',
        'active_ingredient': 'amitraz',
        'dose': 2.0,
        'dose_unit': 'strip',
        'started_at': '2026-10-24T09:00:00.000Z',
        'withdrawal_days': 0,
        'created_at': '2026-10-22T09:00:00.000Z',
        'updated_at': '2026-10-22T09:00:00.000Z',
        'ref_drug_id': 'ref-drug-1',
        'drug_id': null,
        'batch_no': '24-118',
        'planned_removal_at': '2026-12-05T09:00:00.000Z',
        'created_by': null,
        'deleted_at': null,
      });
    });

    test('işletmenin ilacıyla: drug_id dolu, ref_drug_id boş; boş parti no '
        'yazılmaz', () async {
      final hive = await createHive('104');
      final drug = await DrugRepository(db, clock: clock.call).add(
        orgId: 'org-1',
        name: 'Timol jel',
        activeIngredient: DrugActiveIngredient.thymol,
        doseUnit: DrugDoseUnit.g,
      );

      final treatment = await repository.addToHive(
        hive,
        plan(
          drug: DrugChoice(
            drugId: drug.id,
            name: drug.name,
            activeIngredient: drug.activeIngredient,
            doseUnit: drug.doseUnit,
          ),
          batchNo: '  ',
        ),
      );

      expect(treatment.drugId, drug.id);
      expect(treatment.refDrugId, isNull);
      expect(treatment.doseUnit, DrugDoseUnit.g);
      expect(treatment.batchNo, isNull);
    });

    test('geçersiz değerlerde hiçbir şey yazmaz', () async {
      final hive = await createHive('104');
      final invalid = [
        plan(dose: 0),
        plan(dose: -1),
        plan(withdrawalDays: -1),
        plan(withdrawalDays: 366),
        plan(plannedRemovalAt: DateTime.utc(2026, 10)),
        plan(
          drug: const DrugChoice(
            name: 'Listesiz',
            activeIngredient: DrugActiveIngredient.other,
            doseUnit: DrugDoseUnit.dose,
          ),
        ),
        plan(drug: _refDrug.copyWith(drugId: 'drug-1')),
        plan(drug: _refDrug.copyWith(name: ' ')),
      ];
      for (final value in invalid) {
        expect(() => repository.addToHive(hive, value), throwsArgumentError);
      }

      expect(await db.select(db.treatments).get(), isEmpty);
      expect(await treatmentOutbox(), isEmpty);
    });

    test('çıkarma başlangıçla aynı anda olabilir', () async {
      final hive = await createHive('104');
      final at = DateTime.utc(2026, 10, 24, 9);

      final treatment = await repository.addToHive(
        hive,
        plan(startedAt: at, plannedRemovalAt: at),
      );

      expect(treatment.plannedRemovalAt, at);
    });

    test('outbox yazılamazsa uygulama yazılmaz', () async {
      final hive = await createHive('104');
      await db.customStatement(
        'CREATE TRIGGER outbox_fails BEFORE INSERT ON outbox '
        "BEGIN SELECT RAISE(ABORT, 'outbox kapalı'); END",
      );

      await expectLater(
        repository.addToHive(hive, plan()),
        throwsA(isA<SqliteException>()),
      );

      expect(await db.select(db.treatments).get(), isEmpty);
    });
  });

  group('arılığın tümü', () {
    test('arılıktaki her aktif kovana numara sırasıyla yazar; aktif '
        'olmayan, silinmiş ve başka arılıktaki kovana yazmaz', () async {
      final first = await createHive('101');
      final second = await createHive('102');
      await createHive('103', status: HiveStatus.dead);
      await createHive('201', apiaryId: 'apiary-2');
      final deleted = await createHive('104');
      await hives.delete(deleted.id);

      final treatments = await repository.addToApiary('apiary-1', plan());

      expect([for (final t in treatments) t.hiveId], [first.id, second.id]);
      expect({for (final t in treatments) t.apiaryId}, {'apiary-1'});
      expect({for (final t in treatments) t.batchNo}, {'24-118'});
      expect(await db.select(db.treatments).get(), hasLength(2));
      expect(await treatmentOutbox(), hasLength(2));
    });

    test('aktif kovan yoksa bir şey yazmaz', () async {
      await createHive('103', status: HiveStatus.sold);

      expect(await repository.addToApiary('apiary-1', plan()), isEmpty);
      expect(await treatmentOutbox(), isEmpty);
    });

    test('bir kovanın yazması başarısızsa hiçbiri yazılmaz', () async {
      await createHive('101');
      final second = await createHive('102');
      await db.customStatement(
        'CREATE TRIGGER treatment_fails BEFORE INSERT ON treatments '
        "WHEN NEW.hive_id = '${second.id}' "
        "BEGIN SELECT RAISE(ABORT, 'kapalı'); END",
      );

      await expectLater(
        repository.addToApiary('apiary-1', plan()),
        throwsA(isA<SqliteException>()),
      );

      expect(await db.select(db.treatments).get(), isEmpty);
      expect(await treatmentOutbox(), isEmpty);
    });

    test('geri al hepsini tek seferde yumuşak siler', () async {
      await createHive('101');
      await createHive('102');
      final treatments = await repository.addToApiary('apiary-1', plan());
      clock.advance(const Duration(seconds: 5));

      await repository.deleteAll(treatments);

      for (final treatment in treatments) {
        expect(await repository.findById(treatment.id), isNull);
      }
      final rows = await db.select(db.treatments).get();
      expect({for (final row in rows) row.deletedAt}, {clock.current});
      expect(
        [for (final e in await treatmentOutbox()) e.operation],
        [
          OutboxOperation.upsert,
          OutboxOperation.upsert,
          OutboxOperation.delete,
          OutboxOperation.delete,
        ],
      );
    });
  });

  test('kovanın uygulamaları en son başlayan önce; başka kovanınki ve '
      'silinen yok; akış güncellenir', () async {
    final hive = await createHive('104');
    final other = await createHive('105');
    final updates = repository.watchByHive(hive.id);
    expect(await updates.first, isEmpty);

    final older = await repository.addToHive(
      hive,
      plan(startedAt: DateTime.utc(2026, 9)),
    );
    final newer = await repository.addToHive(hive, plan());
    await repository.addToHive(other, plan());
    final deleted = await repository.addToHive(hive, plan());
    await repository.delete(deleted.id);

    expect(await updates.first, [newer, older]);
    expect(
      await repository.findByHive(hive.id),
      unorderedEquals([newer, older]),
    );
  });

  group('işletmenin ilaçları', () {
    late DrugRepository drugs;

    setUp(() => drugs = DrugRepository(db, clock: clock.call));

    test('ilacı kırpılmış adla yazar; outbox payload’u sunucunun '
        'kolonlarıyla', () async {
      final drug = await drugs.add(
        orgId: 'org-1',
        name: '  Timol jel ',
        activeIngredient: DrugActiveIngredient.thymol,
        doseUnit: DrugDoseUnit.g,
        withdrawalDays: 14,
      );

      expect(drug.name, 'Timol jel');
      final entry = (await readOutbox(db)).single;
      expect(entry.recordTable, 'drugs');
      expect(entry.payload, {
        'id': drug.id,
        'org_id': 'org-1',
        'name': 'Timol jel',
        'active_ingredient': 'thymol',
        'dose_unit': 'g',
        'created_at': '2026-10-22T09:00:00.000Z',
        'updated_at': '2026-10-22T09:00:00.000Z',
        'withdrawal_days': 14,
        'license_no': null,
        'created_by': null,
        'deleted_at': null,
      });
    });

    test('boş ad ya da aralık dışı bekleme süresi yazılmaz', () async {
      for (final (name, days) in [('  ', null), ('A', -1), ('A', 366)]) {
        expect(
          () => drugs.add(
            orgId: 'org-1',
            name: name,
            activeIngredient: DrugActiveIngredient.other,
            doseUnit: DrugDoseUnit.dose,
            withdrawalDays: days,
          ),
          throwsArgumentError,
        );
      }

      expect(await db.select(db.drugs).get(), isEmpty);
      expect(await readOutbox(db), isEmpty);
    });

    test('yalnız işletmenin silinmemiş ilaçları görünür', () async {
      Future<Drug> add(String orgId) => drugs.add(
        orgId: orgId,
        name: 'İlaç',
        activeIngredient: DrugActiveIngredient.other,
        doseUnit: DrugDoseUnit.dose,
      );
      final mine = await add('org-1');
      await add('org-2');
      final deleted = await add('org-1');
      await drugs.delete(deleted.id);

      expect(await drugs.watchAll('org-1').first, [mine]);
    });
  });

  test('referans listesi yalnız silinmemiş satırları verir', () async {
    RefDrugsCompanion row(String id, {DateTime? deletedAt}) =>
        RefDrugsCompanion.insert(
          id: id,
          countryCode: 'GLOBAL',
          nameTr: 'Amitraz',
          nameEn: 'Amitraz',
          activeIngredient: DrugActiveIngredient.amitraz,
          doseUnit: DrugDoseUnit.strip,
          createdAt: DateTime.utc(2026),
          updatedAt: DateTime.utc(2026),
          deletedAt: Value(deletedAt),
        );
    await db.into(db.refDrugs).insert(row('ref-1'));
    await db
        .into(db.refDrugs)
        .insert(row('ref-2', deletedAt: DateTime.utc(2026, 2)));

    final drugs = await RefDrugRepository(db).watchAll().first;

    expect([for (final drug in drugs) drug.id], ['ref-1']);
  });
}
