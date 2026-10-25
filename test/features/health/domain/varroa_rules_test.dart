import 'package:flutter_test/flutter_test.dart';
import 'package:mobil_arici/features/health/domain/mite_count.dart';
import 'package:mobil_arici/features/health/domain/varroa_rules.dart';

MiteCount _count(
  DateTime countedAt, {
  MiteCountMethod method = MiteCountMethod.sugarRoll,
  int mites = 9,
  int? sampleBees = 300,
  int? days,
}) => MiteCount(
  id: 'count-${countedAt.toIso8601String()}-$mites',
  orgId: 'org-1',
  hiveId: 'hive-1',
  apiaryId: 'apiary-1',
  countedAt: countedAt,
  method: method,
  mites: mites,
  sampleBees: sampleBees,
  days: days,
  createdAt: countedAt,
  updatedAt: countedAt,
);

void main() {
  group('miteLoad', () {
    test('pudra şekeri ve alkolde akar / örnek arı × 100', () {
      expect(miteLoad(MiteCountMethod.sugarRoll, mites: 9, sampleBees: 300), (
        value: 3.0,
        unit: MiteLoadUnit.percent,
      ));
      expect(miteLoad(MiteCountMethod.alcoholWash, mites: 0, sampleBees: 300), (
        value: 0.0,
        unit: MiteLoadUnit.percent,
      ));
      expect(
        miteLoad(MiteCountMethod.alcoholWash, mites: 5, sampleBees: 250)!.value,
        2.0,
      );
    });

    test('alt tablada akar / gün; örnek arıya bakmaz', () {
      expect(
        miteLoad(
          MiteCountMethod.stickyBoard,
          mites: 30,
          days: 3,
          sampleBees: 300,
        ),
        (value: 10.0, unit: MiteLoadUnit.perDay),
      );
    });

    test('payda yoksa ya da sıfırsa sonuç yok', () {
      expect(miteLoad(MiteCountMethod.sugarRoll, mites: 9), isNull);
      expect(
        miteLoad(MiteCountMethod.sugarRoll, mites: 9, sampleBees: 0),
        isNull,
      );
      expect(
        miteLoad(MiteCountMethod.stickyBoard, mites: 9, sampleBees: 300),
        isNull,
      );
      expect(miteLoad(MiteCountMethod.stickyBoard, mites: 9, days: 0), isNull);
    });

    test('kayıtlı ölçümün sonucu', () {
      final board = _count(
        DateTime.utc(2026, 10, 25),
        method: MiteCountMethod.stickyBoard,
        mites: 14,
        sampleBees: null,
        days: 7,
      );
      expect(miteLoadOf(board), (value: 2.0, unit: MiteLoadUnit.perDay));
    });
  });

  group('eşik', () {
    const thresholds = (percent: 3.0, perDay: 10.0);

    test('eşiğe eşit sonuç da uyarır; altı uyarmaz', () {
      expect(
        reachesThreshold((value: 3, unit: MiteLoadUnit.percent), thresholds),
        isTrue,
      );
      expect(
        reachesThreshold((value: 2.99, unit: MiteLoadUnit.percent), thresholds),
        isFalse,
      );
    });

    test('her birim kendi eşiğiyle karşılaştırılır', () {
      expect(
        reachesThreshold((value: 5, unit: MiteLoadUnit.percent), thresholds),
        isTrue,
      );
      expect(
        reachesThreshold((value: 5, unit: MiteLoadUnit.perDay), thresholds),
        isFalse,
      );
      expect(thresholdFor(MiteLoadUnit.perDay, thresholds), 10);
    });

    test('varsayılan %3 ve günde 10 akar; seçeneklerde var', () {
      expect(defaultVarroaThresholds, (percent: 3.0, perDay: 10.0));
      expect(
        percentThresholdOptions,
        contains(defaultVarroaThresholds.percent),
      );
      expect(perDayThresholdOptions, contains(defaultVarroaThresholds.perDay));
    });
  });

  group('arılık grafiği', () {
    test('aynı gündeki örnekli ölçümlerin ortalaması; günler eskisi '
        'önce', () {
      final bars = apiaryVarroaBars([
        _count(DateTime(2026, 10, 9, 10), mites: 3),
        _count(DateTime(2026, 10, 9, 11), method: MiteCountMethod.alcoholWash),
        _count(DateTime(2026, 10, 1, 10), mites: 6),
      ]);

      expect(bars, [
        (day: DateTime(2026, 10), percent: 2.0),
        (day: DateTime(2026, 10, 9), percent: 2.0),
      ]);
    });

    test('alt tabla sayımları katılmaz', () {
      final bars = apiaryVarroaBars([
        _count(
          DateTime(2026, 10, 9),
          method: MiteCountMethod.stickyBoard,
          sampleBees: null,
          days: 3,
        ),
      ]);

      expect(bars, isEmpty);
    });

    test('yalnız en son 6 gün', () {
      final bars = apiaryVarroaBars([
        for (var day = 1; day <= 8; day++) _count(DateTime(2026, 10, day)),
      ]);

      expect(bars.map((bar) => bar.day.day), [3, 4, 5, 6, 7, 8]);
    });
  });
}
