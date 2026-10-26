import 'package:flutter_test/flutter_test.dart';
import 'package:mobil_arici/features/feeding/domain/feeding.dart';
import 'package:mobil_arici/features/harvest/domain/harvest.dart';
import 'package:mobil_arici/features/health/domain/drug.dart';
import 'package:mobil_arici/features/health/domain/mite_count.dart';
import 'package:mobil_arici/features/health/domain/treatment.dart';
import 'package:mobil_arici/features/hives/domain/hive.dart';
import 'package:mobil_arici/features/hives/domain/hive_location_entry.dart';
import 'package:mobil_arici/features/inspections/domain/inspection.dart';
import 'package:mobil_arici/features/reports/domain/report.dart';
import 'package:mobil_arici/features/reports/domain/report_rules.dart';

const _org = 'org';
final _created = DateTime.utc(2026);

/// 2026 yılının tamamı.
final ReportPeriod _year = (from: DateTime(2026), to: DateTime(2026, 12, 31));

Treatment _treatment(
  String id, {
  required DateTime startedAt,
  String hiveId = 'h1',
  String apiaryId = 'a1',
  String? applicationId,
  DateTime? deletedAt,
  DateTime? plannedRemovalAt,
  int withdrawalDays = 0,
}) => Treatment(
  id: id,
  orgId: _org,
  hiveId: hiveId,
  apiaryId: apiaryId,
  productName: 'Amitraz şerit',
  activeIngredient: DrugActiveIngredient.amitraz,
  dose: 2,
  doseUnit: DrugDoseUnit.strip,
  startedAt: startedAt,
  withdrawalDays: withdrawalDays,
  plannedRemovalAt: plannedRemovalAt,
  applicationId: applicationId,
  createdAt: _created,
  updatedAt: _created,
  deletedAt: deletedAt,
);

Hive _hive(
  String id,
  String number, {
  String apiaryId = 'a1',
  DateTime? deletedAt,
}) => Hive(
  id: id,
  orgId: _org,
  number: number,
  type: HiveType.langstroth,
  apiaryId: apiaryId,
  createdAt: _created,
  updatedAt: _created,
  deletedAt: deletedAt,
);

HiveRecords _records({
  List<Inspection> inspections = const [],
  List<Treatment> treatments = const [],
  List<Feeding> feedings = const [],
  List<MiteCount> miteCounts = const [],
  List<Harvest> harvests = const [],
  List<HiveLocationEntry> locations = const [],
}) => (
  inspections: inspections,
  treatments: treatments,
  feedings: feedings,
  miteCounts: miteCounts,
  harvests: harvests,
  locations: locations,
);

HiveLocationEntry _location(String id, String apiaryId, DateTime movedAt) =>
    HiveLocationEntry(
      id: id,
      orgId: _org,
      hiveId: 'h1',
      apiaryId: apiaryId,
      movedAt: movedAt,
      createdAt: _created,
      updatedAt: _created,
    );

void main() {
  group('defaultReportPeriod', () {
    test('bu yılın 1 Ocak gününden bugüne, yerel takvimde', () {
      final period = defaultReportPeriod(DateTime(2026, 10, 24, 17, 30));
      expect(period.from, DateTime(2026));
      expect(period.to, DateTime(2026, 10, 24));
    });
  });

  group('isInPeriod', () {
    final period = (from: DateTime(2026, 3), to: DateTime(2026, 3, 31));

    test('iki uç gün de dahil, günün saati önemsiz', () {
      expect(isInPeriod(DateTime(2026, 3), period), isTrue);
      expect(isInPeriod(DateTime(2026, 3, 31, 23, 59), period), isTrue);
      expect(isInPeriod(DateTime(2026, 2, 28, 23, 59), period), isFalse);
      expect(isInPeriod(DateTime(2026, 4), period), isFalse);
    });

    test('UTC zaman yerel güne çevrilir', () {
      final lastMinute = DateTime(2026, 3, 31, 23, 59).toUtc();
      expect(isInPeriod(lastMinute, period), isTrue);
    });
  });

  group('treatmentRegisterEntries', () {
    final numbers = {'h1': '10', 'h2': '9', 'h3': '101'};

    test('aynı gruptaki uygulamalar tek satır; kovanlar doğal sırayla', () {
      final day = DateTime.utc(2026, 8, 2, 9);
      final entries = treatmentRegisterEntries(
        [
          _treatment('t3', startedAt: day, hiveId: 'h3', applicationId: 'g'),
          _treatment('t1', startedAt: day, applicationId: 'g'),
          _treatment('t2', startedAt: day, hiveId: 'h2', applicationId: 'g'),
        ],
        period: _year,
        hiveNumbers: numbers,
      );

      final entry = entries.single;
      expect(entry.hiveCount, 3);
      expect(entry.hiveNumbers, ['9', '10', '101']);
      expect(entry.treatment.id, 't1');
    });

    test('grupsuz eski kayıt kendi satırı', () {
      final day = DateTime.utc(2026, 8, 2);
      final entries = treatmentRegisterEntries(
        [
          _treatment('t1', startedAt: day),
          _treatment('t2', startedAt: day, hiveId: 'h2'),
        ],
        period: _year,
        hiveNumbers: numbers,
      );
      expect(entries, hasLength(2));
    });

    test('dönem dışı, başka arılık ve silinmiş uygulama yazılmaz', () {
      final entries = treatmentRegisterEntries(
        [
          _treatment('t1', startedAt: DateTime.utc(2025, 12, 30)),
          _treatment('t2', startedAt: DateTime.utc(2026, 5), apiaryId: 'a2'),
          _treatment(
            't3',
            startedAt: DateTime.utc(2026, 5),
            deletedAt: DateTime.utc(2026, 5, 2),
          ),
          _treatment('t4', startedAt: DateTime.utc(2026, 5)),
        ],
        period: _year,
        apiaryId: 'a1',
        hiveNumbers: numbers,
      );
      expect([for (final entry in entries) entry.treatment.id], ['t4']);
    });

    test('en son başlayan önce; aynı anda başlayanlardan büyük kimlik', () {
      final entries = treatmentRegisterEntries(
        [
          _treatment('t1', startedAt: DateTime.utc(2026, 3, 11)),
          _treatment('t2', startedAt: DateTime.utc(2026, 10, 24)),
          _treatment('t3', startedAt: DateTime.utc(2026, 3, 11)),
        ],
        period: _year,
        hiveNumbers: numbers,
      );
      expect(
        [for (final entry in entries) entry.treatment.id],
        ['t2', 't3', 't1'],
      );
    });

    test('kovanı bilinmeyen uygulama sayılır, numarası yazılmaz', () {
      final day = DateTime.utc(2026, 8, 2);
      final entry = treatmentRegisterEntries(
        [
          _treatment('t1', startedAt: day, applicationId: 'g'),
          _treatment('t2', startedAt: day, hiveId: 'x', applicationId: 'g'),
        ],
        period: _year,
        hiveNumbers: numbers,
      ).single;
      expect(entry.hiveCount, 2);
      expect(entry.hiveNumbers, ['10']);
    });

    test('bekleme bitişi çıkarma gününden sayılır', () {
      final entry = treatmentRegisterEntries(
        [
          _treatment(
            't1',
            startedAt: DateTime(2026, 9, 1, 10),
            plannedRemovalAt: DateTime(2026, 10, 13, 10),
            withdrawalDays: 14,
          ),
        ],
        period: _year,
        hiveNumbers: numbers,
      ).single;
      expect(entry.withdrawalEnd, DateTime(2026, 10, 27));
    });
  });

  group('reportHives', () {
    final hives = [
      _hive('h1', '10'),
      _hive('h2', '9'),
      _hive('h3', '2', apiaryId: 'a2'),
      _hive('h4', '1', deletedAt: DateTime.utc(2026, 2)),
    ];

    test('arılıktaki silinmemiş kovanlar, numara sırasıyla', () {
      expect(
        [for (final hive in reportHives(hives, apiaryId: 'a1')) hive.id],
        ['h2', 'h1'],
      );
    });

    test('arılık yoksa bütün kovanlar', () {
      expect(
        [for (final hive in reportHives(hives)) hive.id],
        ['h3', 'h2', 'h1'],
      );
    });

    test('tek kovan seçildiyse yalnız o, arılığı başka olsa da', () {
      expect(
        [
          for (final hive in reportHives(hives, apiaryId: 'a1', hiveId: 'h3'))
            hive.id,
        ],
        ['h3'],
      );
      expect(reportHives(hives, hiveId: 'h4'), isEmpty);
    });
  });

  group('hiveHistoryItems', () {
    test('bütün kayıt türleri, en yeni önce; dönem dışı ve silinmiş yok', () {
      final items = hiveHistoryItems(
        _records(
          inspections: [
            Inspection(
              id: 'i1',
              orgId: _org,
              hiveId: 'h1',
              apiaryId: 'a1',
              inspectedAt: DateTime.utc(2026, 4, 2),
              createdAt: _created,
              updatedAt: _created,
            ),
            Inspection(
              id: 'i2',
              orgId: _org,
              hiveId: 'h1',
              apiaryId: 'a1',
              inspectedAt: DateTime.utc(2025, 4, 2),
              createdAt: _created,
              updatedAt: _created,
            ),
          ],
          treatments: [
            _treatment('t1', startedAt: DateTime.utc(2026, 9)),
            _treatment(
              't2',
              startedAt: DateTime.utc(2026, 9),
              deletedAt: DateTime.utc(2026, 9, 2),
            ),
          ],
          feedings: [
            Feeding(
              id: 'f1',
              orgId: _org,
              hiveId: 'h1',
              apiaryId: 'a1',
              feedingGroupId: 'f1',
              fedAt: DateTime.utc(2026, 10),
              kind: FeedingKind.syrup2to1,
              amount: 2,
              createdAt: _created,
              updatedAt: _created,
            ),
          ],
          miteCounts: [
            MiteCount(
              id: 'm1',
              orgId: _org,
              hiveId: 'h1',
              apiaryId: 'a1',
              countedAt: DateTime.utc(2026, 8),
              method: MiteCountMethod.sugarRoll,
              mites: 6,
              sampleBees: 300,
              createdAt: _created,
              updatedAt: _created,
            ),
          ],
          harvests: [
            Harvest(
              id: 'v1',
              orgId: _org,
              apiaryId: 'a1',
              harvestedAt: DateTime.utc(2026, 7),
              honeyKind: HoneyKind.pine,
              unit: HarvestUnit.superBox,
              unitCount: 3,
              netKg: 26,
              createdAt: _created,
              updatedAt: _created,
            ),
          ],
        ),
        period: _year,
      );

      expect(
        [for (final item in items) item.id],
        ['f1', 't1', 'm1', 'v1', 'i1'],
      );
      expect(items.first, isA<FeedingItem>());
      expect(items.last, isA<InspectionItem>());
    });

    test('taşımanın geldiği arılık dönemden önceki kayıttan bulunur', () {
      final items = hiveHistoryItems(
        _records(
          locations: [
            _location('l2', 'a2', DateTime.utc(2026, 5)),
            _location('l1', 'a1', DateTime.utc(2025, 6)),
          ],
        ),
        period: _year,
      );

      final move = items.single as LocationItem;
      expect(move.entry.apiaryId, 'a2');
      expect(move.fromApiaryId, 'a1');
    });

    test('ilk kayıt "eklendi"', () {
      final items = hiveHistoryItems(
        _records(locations: [_location('l1', 'a1', DateTime.utc(2026, 2))]),
        period: _year,
      );
      expect((items.single as LocationItem).fromApiaryId, isNull);
    });
  });
}
