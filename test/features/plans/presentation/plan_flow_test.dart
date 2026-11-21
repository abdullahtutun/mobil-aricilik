import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mobil_arici/app/app.dart';
import 'package:mobil_arici/app/router.dart';
import 'package:mobil_arici/app/routes.dart';
import 'package:mobil_arici/core/db/app_database.dart';
import 'package:mobil_arici/core/design_system/design_system.dart';
import 'package:mobil_arici/core/l10n/app_language.dart';
import 'package:mobil_arici/core/l10n/language_provider.dart';
import 'package:mobil_arici/features/apiaries/data/apiary_repository.dart';
import 'package:mobil_arici/features/hives/data/hive_repository.dart';
import 'package:mobil_arici/features/hives/domain/hive.dart';
import 'package:mobil_arici/features/organization/domain/membership_role.dart';
import 'package:mobil_arici/features/plans/data/plan_repository.dart';
import 'package:mobil_arici/features/plans/data/purchase_service.dart';
import 'package:mobil_arici/features/plans/domain/plan_status.dart';
import 'package:mobil_arici/features/team/presentation/team_providers.dart';

import '../../../helpers/fake_auth_service.dart';
import '../../../helpers/fake_organization_service.dart';
import '../../../helpers/fake_plans.dart';
import '../../../helpers/fake_team_service.dart';
import '../../../helpers/test_database.dart';

const PlanOffer _yearly = (
  id: r'$rc_annual',
  priceLabel: '₺299,99',
  yearly: true,
);
const PlanOffer _monthly = (
  id: r'$rc_monthly',
  priceLabel: '₺39,99',
  yearly: false,
);

/// Uygulamayı Türkçe açar ve [location]'a gider. Kullanıcı [role]
/// rolünde; sunucu [status] planını döner (verilmezse çevrimdışı).
Future<ProviderContainer> _open(
  WidgetTester tester, {
  required AppDatabase db,
  required String location,
  PlanStatus? status,
  FakePlanService? plans,
  FakePurchaseService? purchases,
  MembershipRole role = MembershipRole.owner,
}) async {
  await addMember(db, userId: testUser.id, role: role);
  final container = ProviderContainer.test(
    overrides: [
      ...signedIn(
        db: db,
        plans: plans ?? FakePlanService(status: status),
        purchases: purchases,
      ),
      teamServiceProvider.overrideWithValue(FakeTeamService(db: db)),
    ],
  );
  container.read(languageProvider.notifier).language = AppLanguage.turkish;
  await tester.pumpWidget(
    UncontrolledProviderScope(container: container, child: const App()),
  );
  await tester.pumpAndSettle();
  container.read(routerProvider).go(location);
  await tester.pumpAndSettle();
  return container;
}

/// Planı telefona önceden yazar (sunucudan alınmış gibi).
Future<void> _storePlan(AppDatabase db, PlanStatus status) => PlanRepository(db)
    .saveStatus(
      testOrganization.id,
      StoredPlanStatus(status: status, fetchedAt: DateTime.now()),
    );

/// Tembel listede henüz kurulmamış öğeye kaydırır.
Future<void> _scrollTo(WidgetTester tester, Finder finder) async {
  if (finder.evaluate().isEmpty) {
    await tester.scrollUntilVisible(
      finder,
      200,
      scrollable: find.byType(Scrollable).last,
    );
  }
  await tester.ensureVisible(finder);
}

Future<void> _tap(WidgetTester tester, Finder finder) async {
  await _scrollTo(tester, finder);
  await tester.pumpAndSettle();
  await tester.tap(finder);
  await tester.pumpAndSettle();
}

/// [count] aktif kovanlı bir arılık; kimliğini döner.
Future<String> _apiaryWithHives(AppDatabase db, int count) async {
  final apiary = await ApiaryRepository(db)
      .create(orgId: testOrganization.id, name: 'Yayla');
  if (count > 0) {
    await HiveRepository(db).createMany(
      orgId: testOrganization.id,
      apiaryId: apiary.id,
      numbers: [for (var n = 1; n <= count; n++) '$n'],
      type: HiveType.langstroth,
    );
  }
  return apiary.id;
}

bool _enabled(WidgetTester tester, String label) =>
    tester.widget<BigButton>(find.widgetWithText(BigButton, label)).onPressed !=
    null;

void main() {
  group('beta notu', () {
    testWidgets('Bugün en altta; Anladım deyince kalkar, Ayarlar’da durur', (
      tester,
    ) async {
      final db = openTestDatabase();
      await _open(tester, db: db, location: AppRoutes.today);

      final title = find.text('Mobil Arıcı beta sürecinde');
      await tester.scrollUntilVisible(title, 200);
      expect(title, findsOneWidget);
      expect(
        find.textContaining('yıllık ücreti çok cüzi olacak Pro planına'),
        findsOneWidget,
      );
      expect(
        find.textContaining('neredeyse bütün özellikleri açık kalacak'),
        findsOneWidget,
      );
      expect(find.textContaining('indirimden yararlanır'), findsOneWidget);

      await _tap(tester, find.text('Anladım'));
      expect(title, findsNothing);

      // Ayarlar'da kapatılamaz biçimde durur.
      final container = ProviderScope.containerOf(
        tester.element(find.byType(Scaffold).first),
      );
      container.read(routerProvider).go(AppRoutes.settings);
      await tester.pumpAndSettle();
      await tester.scrollUntilVisible(title, 300);
      expect(title, findsOneWidget);
      expect(find.text('Anladım'), findsNothing);
    });
  });

  group('planlar kapalı (şimdiki durum)', () {
    testWidgets('sınır yok: Plan satırı yok, 30 kovandan sonra da eklenir', (
      tester,
    ) async {
      final db = openTestDatabase();
      final apiaryId = await _apiaryWithHives(db, 35);
      final plans = FakePlanService(status: PlanStatus.unlimited);
      await _open(tester, db: db, plans: plans, location: AppRoutes.settings);
      expect(plans.requests, [testOrganization.id]);
      expect(find.text('Ücretsiz plan'), findsNothing);

      final container = ProviderScope.containerOf(
        tester.element(find.byType(Scaffold).first),
      );
      container.read(routerProvider).go(AppRoutes.hiveNew(apiaryId));
      await tester.pumpAndSettle();
      expect(find.text('Ücretsiz planın kovan sınırı doldu'), findsNothing);
      await tester.enterText(find.byType(TextField).first, '99');
      await tester.pumpAndSettle();
      expect(_enabled(tester, 'Kaydet'), isTrue);
    });
  });

  group('ücretsiz plan (planlar açık)', () {
    testWidgets('kovan sınırı doluysa kart çıkar, Kaydet kapanır', (
      tester,
    ) async {
      final db = openTestDatabase();
      final apiaryId = await _apiaryWithHives(db, 30);
      await _storePlan(db, freePlanStatus);
      await _open(
        tester,
        db: db,
        status: freePlanStatus,
        purchases: FakePurchaseService(available: true, offers: [_yearly]),
        location: AppRoutes.hiveNew(apiaryId),
      );
      expect(find.text('Ücretsiz planın kovan sınırı doldu'), findsOneWidget);
      expect(find.textContaining('aktif kovan sınırı: 30'), findsOneWidget);
      await tester.enterText(find.byType(TextField).first, '99');
      await tester.pumpAndSettle();
      expect(_enabled(tester, 'Kaydet'), isFalse);

      // Pro'yu incele plan ekranını açar.
      await _tap(tester, find.text("Pro'yu incele"));
      expect(find.text('Pro ile gelenler'), findsOneWidget);
    });

    testWidgets('toplu: kalan haktan fazlası için uyarı, buton kapalı', (
      tester,
    ) async {
      final db = openTestDatabase();
      final apiaryId = await _apiaryWithHives(db, 25);
      await _storePlan(db, freePlanStatus);
      await _open(
        tester,
        db: db,
        status: freePlanStatus,
        location: AppRoutes.hivesBulk(apiaryId),
      );
      final fields = find.byType(TextField);
      await tester.enterText(fields.at(0), '6');
      await tester.enterText(fields.at(1), '101');
      await tester.pumpAndSettle();
      expect(
        find.text('Ücretsiz planda 5 kovan daha ekleyebilirsin.'),
        findsOneWidget,
      );
      expect(_enabled(tester, '6 kovan oluştur'), isFalse);

      await tester.enterText(fields.at(0), '5');
      await tester.pumpAndSettle();
      expect(
        find.text('Ücretsiz planda 5 kovan daha ekleyebilirsin.'),
        findsNothing,
      );
      expect(_enabled(tester, '5 kovan oluştur'), isTrue);
    });

    testWidgets('ekip: davet kartı yerine sınır kartı, üyeler kalır', (
      tester,
    ) async {
      final db = openTestDatabase();
      await addMember(db, userId: 'worker-1', role: MembershipRole.worker);
      await _storePlan(db, freePlanStatus);
      await _open(
        tester,
        db: db,
        status: freePlanStatus,
        location: AppRoutes.team,
      );
      expect(find.text("Ekip kullanımı Pro'da"), findsOneWidget);
      expect(find.text('Kod üret'), findsNothing);
      // Satın alma kurulu değilse buton yok.
      expect(find.text("Pro'yu incele"), findsNothing);
    });

    testWidgets('Ayarlar → Plan: sahibi yıllık paketi satın alır', (
      tester,
    ) async {
      final db = openTestDatabase();
      final purchases = FakePurchaseService(
        available: true,
        offers: [_yearly, _monthly],
      );
      final plans = FakePlanService(status: freePlanStatus);
      await _open(
        tester,
        db: db,
        plans: plans,
        purchases: purchases,
        location: AppRoutes.settings,
      );
      await _tap(tester, find.text('Ücretsiz plan'));
      expect(find.text('Sınırsız kovan'), findsOneWidget);
      expect(
        find.text('Ekip kullanımı: ortak, işçi ve izleyici'),
        findsOneWidget,
      );
      expect(find.text('7 günlük hava tahmini'), findsOneWidget);
      expect(
        find.text(
          'Uygulamanın diğer bütün özellikleri ücretsiz planda da açık.',
        ),
        findsOneWidget,
      );

      final requestsBefore = plans.requests.length;
      await _tap(tester, find.text('Yıllık ₺299,99'));
      expect(purchases.purchases, [
        (orgId: testOrganization.id, offerId: _yearly.id),
      ]);
      expect(
        find.text('Teşekkürler! Pro birkaç dakika içinde açılır.'),
        findsOneWidget,
      );
      // Satın almadan sonra plan sunucudan yeniden istenir.
      expect(plans.requests.length, greaterThan(requestsBefore));

      // Pro gelince paketler kalkar, bitiş tarihi yazar.
      plans.status = PlanStatus(
        plansEnabled: true,
        plan: PlanTier.pro,
        expiresAt: DateTime.utc(2027, 11, 21),
      );
      final container = ProviderScope.containerOf(
        tester.element(find.byType(Scaffold).first),
      );
      container.read(routerProvider).go(AppRoutes.settings);
      await tester.pumpAndSettle();
      unawaited(container.read(routerProvider).push(AppRoutes.plan));
      await tester.pumpAndSettle();
      expect(find.textContaining('tarihine kadar'), findsOneWidget);
      // Liste sonuna kadar kurulur: geri yükleme var, paket yok.
      await _scrollTo(tester, find.text('Satın alımlarımı geri yükle'));
      expect(find.text('Yıllık ₺299,99'), findsNothing);
    });

    testWidgets('vazgeçme sessiz; mağaza hatası söylenir', (tester) async {
      final db = openTestDatabase();
      final purchases = FakePurchaseService(available: true, offers: [_yearly])
        ..failure = PurchaseFailure.cancelled;
      await _open(
        tester,
        db: db,
        status: freePlanStatus,
        purchases: purchases,
        location: AppRoutes.plan,
      );
      await _tap(tester, find.text('Yıllık ₺299,99'));
      expect(find.byType(SnackBar), findsNothing);

      purchases.failure = PurchaseFailure.network;
      await _tap(tester, find.text('Yıllık ₺299,99'));
      expect(
        find.text('Mağazaya ulaşılamadı. İnternet bağlantını kontrol et.'),
        findsOneWidget,
      );
    });

    testWidgets('sahibi olmayan üye satın alamaz', (tester) async {
      final db = openTestDatabase();
      await _open(
        tester,
        db: db,
        status: freePlanStatus,
        role: MembershipRole.partner,
        purchases: FakePurchaseService(available: true, offers: [_yearly]),
        location: AppRoutes.plan,
      );
      final ownerOnly = find.text(
        "Aboneliği işletme sahibi başlatır; ekipteki herkes Pro'yu kullanır.",
      );
      await _scrollTo(tester, ownerOnly);
      expect(ownerOnly, findsOneWidget);
      expect(find.text('Yıllık ₺299,99'), findsNothing);
    });
  });

  testWidgets('360dp ekranda 1.5x yazı ve eldivenle taşmaz', (tester) async {
    tester.view
      ..physicalSize = const Size(360, 640)
      ..devicePixelRatio = 1;
    tester.platformDispatcher.textScaleFactorTestValue = 1.5;
    addTearDown(tester.view.reset);
    addTearDown(tester.platformDispatcher.clearTextScaleFactorTestValue);
    final db = openTestDatabase();
    final apiaryId = await _apiaryWithHives(db, 30);
    await _storePlan(db, freePlanStatus);
    final container = await _open(
      tester,
      db: db,
      status: freePlanStatus,
      purchases: FakePurchaseService(
        available: true,
        offers: [_yearly, _monthly],
      ),
      location: AppRoutes.today,
    );
    container.read(appearanceProvider.notifier).setGloveMode(enabled: true);
    await tester.pumpAndSettle();

    for (final location in [
      AppRoutes.today,
      AppRoutes.plan,
      AppRoutes.hiveNew(apiaryId),
      AppRoutes.hivesBulk(apiaryId),
      AppRoutes.team,
    ]) {
      container.read(routerProvider).go(location);
      await tester.pumpAndSettle();
      expect(tester.takeException(), isNull, reason: location);
    }
  });
}
