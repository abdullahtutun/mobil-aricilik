import 'package:flutter_test/flutter_test.dart';
import 'package:mobil_arici/core/region/region_config.dart';
import 'package:mobil_arici/features/harvest/domain/harvest.dart';
import 'package:mobil_arici/features/health/domain/drug.dart';
import 'package:mobil_arici/features/health/domain/treatment.dart';
import 'package:mobil_arici/features/hives/domain/hive.dart';
import 'package:mobil_arici/features/hives/domain/hive_location_entry.dart';
import 'package:mobil_arici/features/hives/domain/hive_status_event.dart';
import 'package:mobil_arici/features/queens/domain/queen.dart';
import 'package:mobil_arici/features/reports/domain/season_rules.dart';

const _org = 'org';
final _old = DateTime(2024);

Hive _hive(
  String id, {
  HiveStatus status = HiveStatus.active,
  String apiaryId = 'a1',
  String? queenId,
  DateTime? createdAt,
}) => Hive(
  id: id,
  orgId: _org,
  number: id,
  type: HiveType.langstroth,
  apiaryId: apiaryId,
  status: status,
  queenId: queenId,
  createdAt: (createdAt ?? _old).toUtc(),
  updatedAt: (createdAt ?? _old).toUtc(),
);

HiveStatusEvent _event(
  String hiveId,
  DateTime at, {
  HiveStatus from = HiveStatus.active,
  HiveStatus to = HiveStatus.dead,
  HiveLossReason? reason,
  String apiaryId = 'a1',
}) => HiveStatusEvent(
  id: '$hiveId-${at.toIso8601String()}',
  orgId: _org,
  hiveId: hiveId,
  apiaryId: apiaryId,
  fromStatus: from,
  toStatus: to,
  changedAt: at.toUtc(),
  lossReason: reason,
  createdAt: at.toUtc(),
  updatedAt: at.toUtc(),
);

Treatment _treatment(
  String hiveId,
  DateTime at, {
  DrugActiveIngredient ingredient = DrugActiveIngredient.amitraz,
}) => Treatment(
  id: '$hiveId-${ingredient.value}-${at.toIso8601String()}',
  orgId: _org,
  hiveId: hiveId,
  apiaryId: 'a1',
  productName: ingredient.value,
  activeIngredient: ingredient,
  dose: 2,
  doseUnit: DrugDoseUnit.strip,
  startedAt: at.toUtc(),
  withdrawalDays: 0,
  createdAt: at.toUtc(),
  updatedAt: at.toUtc(),
);

Queen _queen(
  String id, {
  int? year,
  String? line,
  QueenSource? source,
  DateTime? createdAt,
}) => Queen(
  id: id,
  orgId: _org,
  year: year,
  breedLine: line,
  source: source,
  createdAt: (createdAt ?? _old).toUtc(),
  updatedAt: (createdAt ?? _old).toUtc(),
);

Harvest _harvest(DateTime at, double kg) => Harvest(
  id: 'harvest-${at.toIso8601String()}',
  orgId: _org,
  apiaryId: 'a1',
  harvestedAt: at.toUtc(),
  honeyKind: HoneyKind.values.first,
  unit: HarvestUnit.values.first,
  unitCount: 1,
  netKg: kg,
  createdAt: at.toUtc(),
  updatedAt: at.toUtc(),
);

HiveLocationEntry _move(String hiveId, String apiaryId, DateTime at) =>
    HiveLocationEntry(
      id: '$hiveId-$apiaryId',
      orgId: _org,
      hiveId: hiveId,
      apiaryId: apiaryId,
      movedAt: at.toUtc(),
      createdAt: at.toUtc(),
      updatedAt: at.toUtc(),
    );

SeasonRecords _records({
  List<Hive> hives = const [],
  List<HiveStatusEvent> events = const [],
  List<HiveLocationEntry> locations = const [],
  List<Queen> queens = const [],
  List<Harvest> harvests = const [],
  List<Treatment> treatments = const [],
}) => (
  hives: hives,
  events: events,
  locations: locations,
  queens: queens,
  harvests: harvests,
  treatments: treatments,
);

SeasonReport _report(
  SeasonRecords records, {
  DateTime? now,
  Hemisphere hemisphere = Hemisphere.northern,
}) => seasonReport(
  records,
  year: 2026,
  hemisphere: hemisphere,
  now: now ?? DateTime(2026, 11, 2),
);

void main() {
  group('pencereler', () {
    test('sezon takvim yılı', () {
      expect(seasonWindow(2026), (from: DateTime(2026), to: DateTime(2027)));
    });

    test('Kuzey kışı önceki Kasım ile Mart sonu; mücadele Ağustos–Ekim', () {
      final winter = winterWindow(2026, Hemisphere.northern);
      expect(winter, (from: DateTime(2025, 11), to: DateTime(2026, 4)));
      expect(preWinterTreatmentWindow(winter), (
        from: DateTime(2025, 8),
        to: DateTime(2025, 11),
      ));
    });

    test('Güney kışı 6 ay kayar: Mayıs ile Eylül sonu', () {
      final winter = winterWindow(2026, Hemisphere.southern);
      expect(winter, (from: DateTime(2026, 5), to: DateTime(2026, 10)));
      expect(preWinterTreatmentWindow(winter), (
        from: DateTime(2026, 2),
        to: DateTime(2026, 5),
      ));
    });
  });

  group('statusAt', () {
    test('kovan henüz yoksa null', () {
      final hive = _hive('h1', createdAt: DateTime(2026, 6));
      expect(statusAt(hive, const [], DateTime(2026)), isNull);
    });

    test('olaydan önce eski, sonra yeni durum; olay yoksa bugünkü durum', () {
      final hive = _hive('h1', status: HiveStatus.dead);
      final events = [_event('h1', DateTime(2026, 2, 10))];
      expect(statusAt(hive, events, DateTime(2026)), HiveStatus.active);
      expect(statusAt(hive, events, DateTime(2026, 3)), HiveStatus.dead);
      expect(statusAt(hive, const [], DateTime(2026)), HiveStatus.dead);
    });

    test('olaylar sırasız gelse de son olay geçerli', () {
      final hive = _hive('h1');
      final events = [
        _event(
          'h1',
          DateTime(2026, 5),
          from: HiveStatus.dead,
          to: HiveStatus.active,
        ),
        _event('h1', DateTime(2026, 2)),
      ];
      expect(statusAt(hive, events, DateTime(2026, 3)), HiveStatus.dead);
      expect(statusAt(hive, events, DateTime(2026, 6)), HiveStatus.active);
    });
  });

  test('apiaryAt: o andan önceki son taşıma, yoksa bugünkü arılık', () {
    final hive = _hive('h1', apiaryId: 'a3');
    final moves = [
      _move('h1', 'a1', DateTime(2025)),
      _move('h1', 'a2', DateTime(2025, 9)),
      _move('h1', 'a3', DateTime(2026, 5)),
    ];
    expect(apiaryAt(hive, moves, DateTime(2025, 11)), 'a2');
    expect(apiaryAt(hive, const [], DateTime(2025, 11)), 'a3');
  });

  group('seasonReport', () {
    test('kovan sayısı sezon başı ve bugün; sezonda eklenen ve kaybedilen', () {
      final report = _report(
        _records(
          hives: [
            _hive('h1'),
            _hive('h2', status: HiveStatus.dead),
            _hive('h3', createdAt: DateTime(2026, 5)),
            _hive('h4', createdAt: DateTime(2026, 6)),
          ],
          events: [
            _event('h2', DateTime(2026, 2), reason: HiveLossReason.varroa),
          ],
        ),
      );
      expect(report.hivesAtStart, 2);
      expect(report.hivesAtEnd, 3);
      expect(report.netChange, 1);
    });

    test('kayıplar nedene göre, çok olan önce; belirtilmemiş en sonda; '
        'satılan ve birleşen kayıp değil', () {
      final report = _report(
        _records(
          hives: [for (var i = 1; i <= 6; i++) _hive('h$i')],
          events: [
            _event(
              'h1',
              DateTime(2026, 1, 5),
              reason: HiveLossReason.wintering,
            ),
            _event(
              'h2',
              DateTime(2026, 2, 5),
              reason: HiveLossReason.wintering,
            ),
            _event('h3', DateTime(2026, 3, 5)),
            _event(
              'h4',
              DateTime(2026, 4, 5),
              reason: HiveLossReason.predator,
              to: HiveStatus.lost,
            ),
            _event('h5', DateTime(2026, 5, 5), to: HiveStatus.sold),
            // Önceki sezonun kaybı sayılmaz.
            _event('h6', DateTime(2025, 12, 5), reason: HiveLossReason.varroa),
          ],
        ),
      );
      expect(report.losses, [
        (reason: HiveLossReason.wintering, count: 2),
        (reason: HiveLossReason.predator, count: 1),
        (reason: null, count: 1),
      ]);
      expect(report.lossTotal, 4);
    });

    test('toplam bal sezonun hasatları; yeni analar doğum yılından, yoksa '
        'eklendiği yıldan', () {
      final report = _report(
        _records(
          harvests: [
            _harvest(DateTime(2026, 7), 120.5),
            _harvest(DateTime(2026, 9), 80),
            _harvest(DateTime(2025, 9), 999),
          ],
          queens: [
            _queen('q1', year: 2026, source: QueenSource.ownRearing),
            _queen('q2', year: 2026, source: QueenSource.purchased),
            _queen(
              'q3',
              createdAt: DateTime(2026, 4),
              source: QueenSource.ownRearing,
            ),
            _queen('q4', year: 2025, createdAt: DateTime(2026, 4)),
          ],
        ),
      );
      expect(report.honeyKg, 200.5);
      expect(report.newQueens, 3);
      expect(report.ownRearedQueens, 2);
    });

    test('kış kaybı: kışa aktif girenlerden kışta kaybedilenler; önceki kış '
        'de hesaplanır', () {
      final report = _report(
        _records(
          hives: [
            _hive('h1'),
            _hive('h2'),
            _hive('h3'),
            _hive('h4'),
            // Kıştan sonra eklendi; kışa girmedi.
            _hive('h5', createdAt: DateTime(2026, 5)),
          ],
          events: [
            _event(
              'h1',
              DateTime(2026, 1, 10),
              reason: HiveLossReason.wintering,
            ),
            // Kıştan sonra kayıp: kış kaybı değil.
            _event('h2', DateTime(2026, 6)),
            // Önceki kış (2024-25).
            _event('h3', DateTime(2025, 2), reason: HiveLossReason.varroa),
            _event(
              'h3',
              DateTime(2025, 4),
              from: HiveStatus.dead,
              to: HiveStatus.active,
            ),
          ],
        ),
      );
      expect(report.winter, (hives: 4, lost: 1));
      expect(report.winter!.rate, 0.25);
      expect(report.previousWinter, (hives: 4, lost: 1));
    });

    test('kış başlamadıysa kış kaybı yok', () {
      final report = _report(
        _records(hives: [_hive('h1')]),
        now: DateTime(2026, 3),
        hemisphere: Hemisphere.southern,
      );
      expect(report.winter, isNull);
      expect(report.byTreatment, isEmpty);
    });

    test('mücadele yöntemi, arılık ve ana hattına göre; düşük kayıp önce, '
        'az kovanlı grup işaretli', () {
      final hives = [
        for (var i = 1; i <= 12; i++)
          _hive('o$i', apiaryId: 'yayla', queenId: 'q-car'),
        for (var i = 1; i <= 3; i++) _hive('a$i', apiaryId: 'ova'),
      ];
      final report = _report(
        _records(
          hives: hives,
          // Ova kovanları kışın başında yaylaya taşınmıştı.
          locations: [
            for (var i = 1; i <= 3; i++)
              _move('a$i', 'yayla', DateTime(2025, 10)),
          ],
          queens: [_queen('q-car', line: ' Kafkas ')],
          treatments: [
            for (var i = 1; i <= 12; i++) ...[
              _treatment('o$i', DateTime(2025, 8, 20)),
              _treatment(
                'o$i',
                DateTime(2025, 10, 20),
                ingredient: DrugActiveIngredient.oxalicAcid,
              ),
            ],
            for (var i = 1; i <= 3; i++) _treatment('a$i', DateTime(2025, 9)),
            // Kıştan sonraki ilaç yöntemi değiştirmez.
            _treatment(
              'a1',
              DateTime(2026, 4),
              ingredient: DrugActiveIngredient.oxalicAcid,
            ),
          ],
          events: [
            _event('o1', DateTime(2026, 1, 5)),
            _event('a1', DateTime(2026, 1, 5)),
            _event('a2', DateTime(2026, 2, 5)),
          ],
        ),
      );

      expect(report.byTreatment.map((group) => group.key), [
        {DrugActiveIngredient.amitraz, DrugActiveIngredient.oxalicAcid},
        {DrugActiveIngredient.amitraz},
      ]);
      expect(report.byTreatment.map((group) => group.loss), [
        (hives: 12, lost: 1),
        (hives: 3, lost: 2),
      ]);
      expect(report.byApiary, [(key: 'yayla', loss: (hives: 15, lost: 3))]);
      expect(report.byQueenLine, [
        (key: 'Kafkas', loss: (hives: 12, lost: 1)),
        (key: null, loss: (hives: 3, lost: 2)),
      ]);
      expect(report.byTreatment.first.loss.isSmall, isFalse);
      expect(report.byTreatment.last.loss.isSmall, isTrue);
      expect(report.hasSmallGroups, isTrue);
    });

    test('kovan satırları: sezon başı/sonu durumu, kayıp ve kış bilgisi', () {
      final report = _report(
        _records(
          hives: [
            _hive('h1', status: HiveStatus.dead),
            _hive('h2', createdAt: DateTime(2026, 5)),
            _hive('h3', createdAt: DateTime(2027)),
          ],
          events: [
            _event(
              'h1',
              DateTime(2026, 1, 5),
              reason: HiveLossReason.queenless,
            ),
          ],
          treatments: [_treatment('h1', DateTime(2025, 9))],
        ),
      );
      expect(report.hiveRows.map((row) => row.hive.id), ['h1', 'h2']);
      final h1 = report.hiveRows.first;
      expect(h1.startStatus, HiveStatus.active);
      expect(h1.endStatus, HiveStatus.dead);
      expect(h1.loss?.lossReason, HiveLossReason.queenless);
      expect(h1.inWinter, isTrue);
      expect(h1.lostInWinter, isTrue);
      expect(h1.method, {DrugActiveIngredient.amitraz});
      final h2 = report.hiveRows.last;
      expect(h2.startStatus, isNull);
      expect(h2.inWinter, isFalse);
    });
  });
}
