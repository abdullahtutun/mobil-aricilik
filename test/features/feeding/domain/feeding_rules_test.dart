import 'package:flutter_test/flutter_test.dart';
import 'package:mobil_arici/core/region/region_config.dart';
import 'package:mobil_arici/core/utils/units.dart';
import 'package:mobil_arici/features/feeding/domain/feeding.dart';
import 'package:mobil_arici/features/feeding/domain/feeding_rules.dart';
import 'package:mobil_arici/features/hives/domain/hive.dart';
import 'package:mobil_arici/features/inspections/domain/inspection.dart';

Inspection _inspection(
  String id, {
  required DateTime at,
  String hiveId = 'hive-1',
  Set<InspectionAction> actions = const {},
  DateTime? deletedAt,
}) => Inspection(
  id: id,
  orgId: 'org-1',
  hiveId: hiveId,
  apiaryId: 'apiary-1',
  inspectedAt: at,
  createdAt: at,
  updatedAt: at,
  deletedAt: deletedAt,
  data: inspectionData(actions),
);

Hive _hive(String id, String number) => Hive(
  id: id,
  orgId: 'org-1',
  number: number,
  type: HiveType.langstroth,
  apiaryId: 'apiary-1',
  createdAt: DateTime.utc(2026),
  updatedAt: DateTime.utc(2026),
);

void main() {
  group('syrupRecipe', () {
    test('2:1: tasarımdaki 37 kovan × 3 L = 111 L; şeker ≈ 98 kg, su ≈ 49 L '
        '(ağırlıkça 2:1)', () {
      final recipe = syrupRecipe(FeedingKind.syrup2to1, 111)!;

      expect(recipe.sugarKg, closeTo(98.42, 0.01));
      expect(recipe.waterLiters, closeTo(49.21, 0.01));
      expect(recipe.sugarKg / recipe.waterLiters, closeTo(2, 1e-9));
      // Şeker + su şurubun kütlesi (yoğunluk 1,33 kg/L).
      expect(recipe.sugarKg + recipe.waterLiters, closeTo(111 * 1.33, 1e-9));
    });

    test('1:1: şeker ve su eşit; 10 L için 6,15 kg şeker, 6,15 L su', () {
      final recipe = syrupRecipe(FeedingKind.syrup1to1, 10)!;

      expect(recipe.sugarKg, closeTo(6.15, 1e-9));
      expect(recipe.waterLiters, closeTo(6.15, 1e-9));
    });

    test('miktarla doğru orantılı; sıfırda sıfır', () {
      final one = syrupRecipe(FeedingKind.syrup2to1, 1)!;
      final sixty = syrupRecipe(FeedingKind.syrup2to1, 60)!;

      expect(sixty.sugarKg, closeTo(one.sugarKg * 60, 1e-9));
      expect(syrupRecipe(FeedingKind.syrup1to1, 0)!.sugarKg, 0);
    });

    test('şurup olmayan türde hesap yok', () {
      expect(syrupRecipe(FeedingKind.beeCake, 10), isNull);
      expect(syrupRecipe(FeedingKind.pollenSubstitute, 10), isNull);
    });
  });

  group('storedFeedingAmount', () {
    const metric = DefaultUnits();
    const us = DefaultUnits(mass: MassUnit.pound, volume: VolumeUnit.gallon);

    test('metrikte değişmez: şurup litre, kek kilogram', () {
      expect(storedFeedingAmount(FeedingKind.syrup2to1, 3, metric), 3);
      expect(storedFeedingAmount(FeedingKind.beeCake, 2, metric), 2);
    });

    test('şurupta hacim birimi, kekte ve polende kütle birimi çevrilir; '
        'üç ondalık', () {
      expect(storedFeedingAmount(FeedingKind.syrup1to1, 1, us), 3.785);
      expect(storedFeedingAmount(FeedingKind.beeCake, 2, us), 0.907);
      expect(storedFeedingAmount(FeedingKind.pollenSubstitute, 1, us), 0.454);
    });

    test('formun üst sınırı galonda da sunucunun sınırının altında', () {
      expect(
        storedFeedingAmount(FeedingKind.syrup2to1, maxFeedingAmount, us),
        lessThanOrEqualTo(maxStoredFeedingAmount),
      );
    });
  });

  group('hasHoneySuper', () {
    final day = DateTime.utc(2026, 9);

    test('hiç kat işlemi yoksa yok', () {
      expect(hasHoneySuper(const []), isFalse);
      expect(
        hasHoneySuper([
          _inspection('1', at: day, actions: {InspectionAction.fed}),
        ]),
        isFalse,
      );
    });

    test('son kat işlemine göre: verildi → var, alındı → yok; sıra '
        'önemsiz', () {
      final added = _inspection(
        '1',
        at: day,
        actions: {InspectionAction.superAdded},
      );
      final removed = _inspection(
        '2',
        at: day.add(const Duration(days: 10)),
        actions: {InspectionAction.superRemoved},
      );
      final later = _inspection(
        '3',
        at: day.add(const Duration(days: 20)),
        actions: {InspectionAction.framesAdded},
      );

      expect(hasHoneySuper([added]), isTrue);
      expect(hasHoneySuper([removed, added]), isFalse);
      expect(hasHoneySuper([added, removed, later]), isFalse);
      // Kat işlemi olmayan sonraki muayene durumu değiştirmez.
      expect(hasHoneySuper([later, added]), isTrue);
    });

    test('silinmiş muayene sayılmaz', () {
      final added = _inspection(
        '1',
        at: day,
        actions: {InspectionAction.superAdded},
      );
      final removed = _inspection(
        '2',
        at: day.add(const Duration(days: 1)),
        actions: {InspectionAction.superRemoved},
        deletedAt: day.add(const Duration(days: 1)),
      );

      expect(hasHoneySuper([added, removed]), isTrue);
    });

    test('aynı anda yapılanlardan kimliği büyük olan; ikisi aynı muayenede '
        'ise kat var sayılır', () {
      final removed = _inspection(
        'b',
        at: day,
        actions: {InspectionAction.superRemoved},
      );
      final added = _inspection(
        'a',
        at: day,
        actions: {InspectionAction.superAdded},
      );

      expect(hasHoneySuper([added, removed]), isFalse);
      expect(
        hasHoneySuper([
          _inspection(
            'c',
            at: day,
            actions: {
              InspectionAction.superAdded,
              InspectionAction.superRemoved,
            },
          ),
        ]),
        isTrue,
      );
    });

    test('honeySuperHiveIds kovan kovan hesaplar', () {
      expect(
        honeySuperHiveIds([
          _inspection('1', at: day, actions: {InspectionAction.superAdded}),
          _inspection(
            '2',
            at: day,
            hiveId: 'hive-2',
            actions: {InspectionAction.superAdded},
          ),
          _inspection(
            '3',
            at: day.add(const Duration(days: 1)),
            hiveId: 'hive-2',
            actions: {InspectionAction.superRemoved},
          ),
        ]),
        {'hive-1'},
      );
    });
  });

  group('feedingTargets', () {
    final hives = [_hive('h1', '101'), _hive('h2', '102'), _hive('h3', '103')];

    test('şurupta bal katlı kovanlar dışarıda kalır; sıra korunur', () {
      for (final kind in [FeedingKind.syrup1to1, FeedingKind.syrup2to1]) {
        final targets = feedingTargets(hives, {'h1', 'h3'}, kind);

        expect([for (final h in targets.fed) h.number], ['102']);
        expect([for (final h in targets.skipped) h.number], ['101', '103']);
      }
    });

    test('kek ve polen ikamesinde hepsi beslenir', () {
      for (final kind in [FeedingKind.beeCake, FeedingKind.pollenSubstitute]) {
        final targets = feedingTargets(hives, {'h1'}, kind);

        expect(targets.fed, hives);
        expect(targets.skipped, isEmpty);
      }
    });
  });
}
