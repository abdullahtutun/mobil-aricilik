import 'dart:convert';

import 'package:clock/clock.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mobil_arici/core/db/app_database.dart';
import 'package:mobil_arici/features/organization/presentation/organization_providers.dart';
import 'package:mobil_arici/features/plans/data/plan_repository.dart';
import 'package:mobil_arici/features/plans/data/plan_service.dart';
import 'package:mobil_arici/features/plans/domain/plan_status.dart';
import 'package:mobil_arici/features/plans/presentation/plan_providers.dart';

import '../../../helpers/fake_auth_service.dart';
import '../../../helpers/fake_organization_service.dart';
import '../../../helpers/fake_plans.dart';
import '../../../helpers/fake_pocketbase_api.dart';
import '../../../helpers/fake_pocketbase_files.dart';
import '../../../helpers/test_database.dart';

void main() {
  group('PocketBasePlanService', () {
    late FakePocketBaseApi server;
    late PocketBasePlanService service;

    setUp(() {
      server = FakePocketBaseApi();
      service = PocketBasePlanService(server.client());
    });

    test('POST /api/app/plan {org_id}, token ile; yanıt okunur', () async {
      server.handler = (_) => fakePocketBaseJson({
        'plans_enabled': true,
        'plan': 'free',
        'expires_at': '',
        'hive_limit': 30,
        'team': false,
        'forecast_days': 3,
      });
      final status = await service.fetch('org-1');
      expect(status, freePlanStatus);
      final request = server.requests.single;
      expect(request.method, 'POST');
      expect(request.url.path, PocketBasePlanService.path);
      expect(FakePocketBaseApi.body(request), {'org_id': 'org-1'});
      expect(request.headers['Authorization'], isNotEmpty);
    });

    test('hata, bağlantı yokluğu, bozuk yanıt: PlanServiceException', () async {
      for (final handler in [
        (_) => fakePocketBaseAppError(403, 'forbidden'),
        (_) => fakePocketBaseAppError(500, 'server'),
        (_) => fakePocketBaseJson(['liste']),
        (_) => throw Exception('bağlantı yok'),
      ]) {
        server.handler = handler;
        await expectLater(
          service.fetch('org-1'),
          throwsA(isA<PlanServiceException>()),
        );
      }
    });
  });

  group('PlanRepository ve PlanRefresher', () {
    late AppDatabase db;
    late FakePlanService plans;
    late ProviderContainer container;
    var now = DateTime.utc(2026, 11, 21, 12);

    setUp(() async {
      db = openTestDatabase();
      plans = FakePlanService();
      now = DateTime.utc(2026, 11, 21, 12);
      container = ProviderContainer.test(
        overrides: signedIn(db: db, plans: plans),
      );
      await container.read(currentOrganizationProvider.future);
    });

    Future<T> at<T>(Future<T> Function() run) =>
        withClock(Clock.fixed(now), run);

    Future<StoredPlanStatus?> saved() =>
        PlanRepository(db).readStatus(testOrganization.id);

    test('alınan durum işletme başına saklanır; tazeyken sorulmaz', () async {
      plans.status = freePlanStatus;
      final refresher = container.read(planRefresherProvider);
      await at(refresher.refreshIfStale);
      expect(plans.requests, [testOrganization.id]);
      expect((await saved())!.status, freePlanStatus);
      expect((await saved())!.fetchedAt, now);

      await at(refresher.refreshIfStale);
      expect(plans.requests, hasLength(1));

      // 6 saat sonra yeniden sorulur; "şimdi" her zaman sorar.
      now = now.add(const Duration(hours: 6));
      await at(refresher.refreshIfStale);
      expect(plans.requests, hasLength(2));
      expect(await at(refresher.refreshNow), isTrue);
      expect(plans.requests, hasLength(3));
    });

    test('çevrimdışıyken saklanan kalır; ekran onu uygular', () async {
      plans.status = freePlanStatus;
      final refresher = container.read(planRefresherProvider);
      await at(refresher.refreshNow);
      plans.fail = true;
      expect(await at(refresher.refreshNow), isFalse);
      expect((await saved())!.status, freePlanStatus);

      container.listen(storedPlanProvider, (_, _) {});
      await container.read(storedPlanProvider.future);
      expect(container.read(currentPlanProvider).hiveLimit, 30);
      expect(container.read(plansEnabledProvider), isTrue);
    });

    test('hiç alınmamışken her şey açık', () async {
      plans.fail = true;
      await at(container.read(planRefresherProvider).refreshNow);
      container.listen(storedPlanProvider, (_, _) {});
      await container.read(storedPlanProvider.future);
      expect(container.read(currentPlanProvider), PlanStatus.unlimited);
      expect(container.read(plansEnabledProvider), isFalse);
    });

    test('bozuk saklanan değer yok sayılır', () async {
      await PlanRepository(db).saveStatus(
        testOrganization.id,
        StoredPlanStatus(status: freePlanStatus, fetchedAt: now),
      );
      expect(await saved(), isNotNull);
      await db
          .into(db.localSettings)
          .insertOnConflictUpdate(
            LocalSettingsCompanion.insert(
              key: PlanRepository.statusKey(testOrganization.id),
              value: jsonEncode({'status': 'bozuk'}),
            ),
          );
      expect(await saved(), isNull);
    });

    test('beta notu kapatılınca kapalı kalır', () async {
      final repository = PlanRepository(db);
      expect(await repository.watchBetaNoticeDismissed().first, isFalse);
      await repository.dismissBetaNotice();
      expect(await repository.watchBetaNoticeDismissed().first, isTrue);
    });
  });
}
