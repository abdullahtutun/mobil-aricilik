import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:mobil_arici/features/plans/domain/plan_rules.dart';
import 'package:mobil_arici/features/plans/domain/plan_status.dart';

void main() {
  final now = DateTime.utc(2026, 11, 21, 12);

  StoredPlanStatus stored(PlanStatus status, {DateTime? fetchedAt}) =>
      StoredPlanStatus(status: status, fetchedAt: fetchedAt ?? now);

  group('PlanStatus.fromJson', () {
    test('sunucunun ücretsiz yanıtı', () {
      final status = PlanStatus.fromJson({
        'plans_enabled': true,
        'plan': 'free',
        'expires_at': '',
        'hive_limit': 30,
        'team': false,
        'forecast_days': 3,
      });
      expect(
        status,
        const PlanStatus(
          plansEnabled: true,
          hiveLimit: 30,
          team: false,
          forecastDays: 3,
        ),
      );
    });

    test('Pro: sınırlar null, bitiş K-5 metni', () {
      final status = PlanStatus.fromJson({
        'plans_enabled': true,
        'plan': 'pro',
        'expires_at': '2027-11-21T12:00:00.000000Z',
        'hive_limit': null,
        'team': true,
        'forecast_days': null,
      });
      expect(status.plan, PlanTier.pro);
      expect(status.expiresAt, DateTime.utc(2027, 11, 21, 12));
      expect(status.hiveLimit, isNull);
      expect(status.forecastDays, isNull);
    });

    test('bilinmeyen plan ücretsiz sayılır; saklanan hâli geri okunur', () {
      expect(PlanStatus.fromJson({'plan': 'gold'}).plan, PlanTier.free);
      final original = stored(
        PlanStatus(
          plansEnabled: true,
          plan: PlanTier.pro,
          expiresAt: DateTime.utc(2027),
        ),
      );
      // Telefonda jsonEncode ile saklanır (PlanRepository).
      final json =
          jsonDecode(jsonEncode(original.toJson())) as Map<String, Object?>;
      expect(StoredPlanStatus.fromJson(json), original);
    });
  });

  group('effectivePlan', () {
    test('saklanan yoksa sınırsız', () {
      expect(effectivePlan(null, now), PlanStatus.unlimited);
      expect(PlanStatus.unlimited.hiveLimit, isNull);
      expect(PlanStatus.unlimited.team, isTrue);
    });

    test('planlar kapalıyken sunucunun söylediği', () {
      const off = PlanStatus(plan: PlanTier.pro);
      expect(effectivePlan(stored(off), now), off);
    });

    test('süresi geçmiş Pro ek süre boyunca Pro kalır, sonra ücretsiz', () {
      final pro = PlanStatus(
        plansEnabled: true,
        plan: PlanTier.pro,
        expiresAt: now.subtract(const Duration(days: 6)),
      );
      expect(effectivePlan(stored(pro), now), pro);
      final later = now.add(const Duration(days: 2));
      final dropped = effectivePlan(stored(pro), later);
      expect(dropped.plan, PlanTier.free);
      expect(dropped.hiveLimit, freeHiveLimit);
      expect(dropped.team, isFalse);
      expect(dropped.forecastDays, freeForecastDays);
      expect(dropped.expiresAt, isNull);
    });

    test('süresiz Pro düşmez', () {
      const lifetime = PlanStatus(plansEnabled: true, plan: PlanTier.pro);
      expect(
        effectivePlan(stored(lifetime), now.add(const Duration(days: 999))),
        lifetime,
      );
    });
  });

  test('planNeedsRefresh', () {
    expect(planNeedsRefresh(null, now), isTrue);
    expect(planNeedsRefresh(stored(PlanStatus.unlimited), now), isFalse);
    expect(
      planNeedsRefresh(
        stored(
          PlanStatus.unlimited,
          fetchedAt: now.subtract(planRefreshInterval),
        ),
        now,
      ),
      isTrue,
    );
    // Saat geri alınmışsa da yenilenir.
    expect(
      planNeedsRefresh(
        stored(
          PlanStatus.unlimited,
          fetchedAt: now.add(const Duration(hours: 1)),
        ),
        now,
      ),
      isTrue,
    );
  });

  test('remainingHiveSlots ve canAddHives', () {
    expect(remainingHiveSlots(hiveLimit: null, activeHives: 500), isNull);
    expect(remainingHiveSlots(hiveLimit: 30, activeHives: 18), 12);
    expect(remainingHiveSlots(hiveLimit: 30, activeHives: 30), 0);
    // Sınırın üstündeki kovanlar kalır; yalnız yenisi eklenemez.
    expect(remainingHiveSlots(hiveLimit: 30, activeHives: 45), 0);

    expect(canAddHives(remaining: null, adding: 200), isTrue);
    expect(canAddHives(remaining: 12, adding: 12), isTrue);
    expect(canAddHives(remaining: 12, adding: 13), isFalse);
    expect(canAddHives(remaining: 0, adding: 1), isFalse);
  });
}
