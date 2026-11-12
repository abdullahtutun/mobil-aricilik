import 'package:flutter_test/flutter_test.dart';
import 'package:mobil_arici/features/harvest/domain/harvest.dart';
import 'package:mobil_arici/features/harvest/domain/lot.dart';
import 'package:mobil_arici/features/harvest/domain/lot_rules.dart';
import 'package:mobil_arici/features/health/domain/drug.dart';
import 'package:mobil_arici/features/health/domain/treatment.dart';

Treatment _treatment(
  String id,
  String hiveId,
  DateTime startedAt, {
  DateTime? removalAt,
  int withdrawalDays = 0,
  DateTime? deletedAt,
}) => Treatment(
  id: id,
  orgId: 'org-1',
  hiveId: hiveId,
  apiaryId: 'apiary-1',
  refDrugId: 'ref-1',
  productName: 'Amitraz şerit',
  activeIngredient: DrugActiveIngredient.amitraz,
  dose: 2,
  doseUnit: DrugDoseUnit.strip,
  startedAt: startedAt,
  plannedRemovalAt: removalAt,
  withdrawalDays: withdrawalDays,
  createdAt: startedAt,
  updatedAt: startedAt,
  deletedAt: deletedAt,
);

LotSummary _summary({
  int year = 2026,
  double kg = 100,
  double soldKg = 0,
  int hiveCount = 4,
}) => (
  lot: Lot(
    id: 'lot-$year-$kg',
    orgId: 'org-1',
    year: year,
    seq: 1,
    honeyKind: HoneyKind.pine,
    createdAt: DateTime.utc(2026),
    updatedAt: DateTime.utc(2026),
  ),
  kg: kg,
  soldKg: soldKg,
  hiveCount: hiveCount,
  analyzed: false,
  violation: false,
);

void main() {
  test('lot numarası yıl ve en az iki haneli sıra', () {
    expect(formatLotNumber(2026, 7), '2026-07');
    expect(formatLotNumber(2026, 123), '2026-123');
  });

  test('lot sayfası kök adres + lot kimliği; sondaki / tekrar etmez', () {
    const id = '0199a3b2-7c1e-7d40-8a5b-000000000001';
    expect(
      lotPageUrl('https://arici-api.tutunsoft.com/l', id),
      'https://arici-api.tutunsoft.com/l/$id',
    );
    expect(
      lotPageUrl('https://mobilaricilik.app/lot/', id),
      'https://mobilaricilik.app/lot/$id',
    );
  });

  group('resolveLotPageBaseUrl', () {
    test("PocketBase'de sunucunun /l yolu; sondaki / tekrar etmez", () {
      expect(
        resolveLotPageBaseUrl(
          pocketbase: true,
          pocketbaseUrl: 'https://arici-api-dev.tutunsoft.com',
        ),
        'https://arici-api-dev.tutunsoft.com/l',
      );
      expect(
        resolveLotPageBaseUrl(
          pocketbase: true,
          pocketbaseUrl: 'http://127.0.0.1:8090/',
        ),
        'http://127.0.0.1:8090/l',
      );
    });

    test("Supabase'de adres verilmezse null (bölüm gizli)", () {
      expect(
        resolveLotPageBaseUrl(
          pocketbase: false,
          pocketbaseUrl: 'https://arici-api.tutunsoft.com',
        ),
        isNull,
      );
    });

    test("LOT_PAGE_BASE_URL iki backend'de de ezer", () {
      for (final pocketbase in [true, false]) {
        expect(
          resolveLotPageBaseUrl(
            pocketbase: pocketbase,
            pocketbaseUrl: 'https://arici-api.tutunsoft.com',
            define: ' https://lot.example.com ',
          ),
          'https://lot.example.com',
        );
      }
    });

    test('testler dart-define vermeden çalışır', () {
      expect(lotPageBaseUrlDefine, isEmpty);
    });
  });

  test('sıradaki numara yılın en büyüğünden bir fazla; lot yoksa 1', () {
    expect(nextLotSeq([]), 1);
    expect(nextLotSeq([3, 1, 7]), 8);
  });

  test('nem virgül ya da noktayla, 10 ile 30 arasında, bir ondalık', () {
    expect(parseLotMoisture('17,2'), 17.2);
    expect(parseLotMoisture(' 16.9 '), 16.9);
    expect(parseLotMoisture('9,9'), isNull);
    expect(parseLotMoisture('30,1'), isNull);
    expect(parseLotMoisture('17,25'), isNull);
    expect(parseLotMoisture(''), isNull);
    expect(parseLotDecimal('420', min: 0, max: 10000), 420);
  });

  test('stok kilogramdan satışlar düşülür', () {
    expect(lotStock(_summary(kg: 574, soldKg: 164)), 410);
  });

  group('son ilaçlama', () {
    final harvestedAt = DateTime(2026, 10, 26, 12);

    test('hasat gününe kadar başlayan en son uygulama; bitiş en geç biten; '
        'ilaçlanmamış ve silinmiş sayılmaz', () {
      final links = lotTreatmentLinks(
        harvestedAt: harvestedAt,
        hiveIds: ['h1', 'h2', 'h3'],
        treatments: [
          // Uzun bekleme süreli eski uygulama bitişi belirler.
          _treatment(
            'old',
            'h1',
            DateTime(2026, 8),
            removalAt: DateTime(2026, 9),
            withdrawalDays: 60,
          ),
          _treatment('last', 'h1', DateTime(2026, 9, 10), withdrawalDays: 7),
          _treatment('later', 'h1', DateTime(2026, 10, 27)),
          _treatment(
            'gone',
            'h2',
            DateTime(2026, 10),
            deletedAt: DateTime(2026, 10, 2),
          ),
        ],
      );
      expect(links, hasLength(1));
      expect(links.single.hiveId, 'h1');
      expect(links.single.treatment.id, 'last');
      expect(links.single.withdrawalEndsOn, DateTime(2026, 10, 31));
      expect(links.single.violation, isTrue);
    });

    test('bekleme süresi hasat günü biterse ihlal değil', () {
      final links = lotTreatmentLinks(
        harvestedAt: harvestedAt,
        hiveIds: ['h1'],
        treatments: [
          _treatment('t', 'h1', DateTime(2026, 10, 12), withdrawalDays: 14),
        ],
      );
      expect(links.single.withdrawalEndsOn, DateTime(2026, 10, 26));
      expect(links.single.violation, isFalse);
    });
  });

  test('özet: yılın kilogramı, eksi olmayan stok ve yılın kovan başı', () {
    final overview = lotOverview([
      _summary(kg: 574, soldKg: 164, hiveCount: 22),
      _summary(kg: 234, soldKg: 240, hiveCount: 10),
      _summary(year: 2025, kg: 300),
    ], 2026);
    expect(overview.yearKg, 808);
    expect(overview.stockKg, 410 + 300);
    expect(overview.perHive, closeTo(808 / 32, 0.001));
    expect(lotOverview([], 2026).perHive, isNull);
  });
}
