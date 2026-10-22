import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mobil_arici/app/app.dart';
import 'package:mobil_arici/app/shell/app_navigation_bar.dart';
import 'package:mobil_arici/core/design_system/design_system.dart';
import 'package:mobil_arici/core/l10n/app_language.dart';
import 'package:mobil_arici/core/l10n/language_provider.dart';
import 'package:mobil_arici/core/region/region_config.dart';
import 'package:mobil_arici/core/region/region_provider.dart';
import 'package:mobil_arici/features/auth/presentation/auth_providers.dart';
import 'package:mobil_arici/features/auth/presentation/sign_in_email_screen.dart';
import 'package:mobil_arici/features/onboarding/presentation/onboarding_screen.dart';
import 'package:mobil_arici/features/onboarding/presentation/widgets/country_step.dart';
import 'package:mobil_arici/features/onboarding/presentation/widgets/hive_count_step.dart';
import 'package:mobil_arici/features/onboarding/presentation/widgets/name_step.dart';
import 'package:mobil_arici/features/organization/domain/organization.dart';
import 'package:mobil_arici/features/organization/domain/organization_failure.dart';
import 'package:mobil_arici/features/today/presentation/today_screen.dart';

import '../../../helpers/fake_auth_service.dart';
import '../../../helpers/fake_organization_service.dart';

/// Giriş yapmış ama işletmesi olmayan kullanıcıyla uygulamayı açar.
Future<ProviderContainer> _pumpApp(
  WidgetTester tester, {
  FakeOrganizationService? service,
  FakeAuthService? auth,
}) async {
  final container = ProviderContainer.test(
    overrides: [
      authServiceProvider.overrideWithValue(
        auth ?? FakeAuthService(user: testUser),
      ),
      ...organizationOverrides(service: service ?? FakeOrganizationService()),
    ],
  );
  await tester.pumpWidget(
    UncontrolledProviderScope(container: container, child: const App()),
  );
  await tester.pumpAndSettle();
  return container;
}

void _setDeviceLocales(WidgetTester tester, List<Locale> locales) {
  tester.platformDispatcher.localesTestValue = locales;
  addTearDown(tester.platformDispatcher.clearLocalesTestValue);
}

BigButton _button(WidgetTester tester, String label) =>
    tester.widget<BigButton>(find.widgetWithText(BigButton, label));

Future<void> _tap(WidgetTester tester, Finder finder) async {
  await tester.ensureVisible(finder);
  await tester.pumpAndSettle();
  await tester.tap(finder);
  await tester.pumpAndSettle();
}

Future<void> _continue(WidgetTester tester) =>
    _tap(tester, find.widgetWithText(BigButton, 'Continue'));

ListTile _countryTile(WidgetTester tester, String name) => tester.widget(
  find.ancestor(of: find.text(name), matching: find.byType(ListTile)),
);

Finder _inCountryStep(Finder finder) =>
    find.descendant(of: find.byType(CountryStep), matching: finder);

void main() {
  group('Onboarding', () {
    testWidgets('işletmesi olmayan kullanıcı onboarding ile açılır', (
      tester,
    ) async {
      await _pumpApp(tester);

      expect(find.byType(OnboardingScreen), findsOneWidget);
      expect(find.byType(AppNavigationBar), findsNothing);
      expect(find.text('Step 1 of 4'), findsOneWidget);
      expect(find.text('Which language should we use?'), findsOneWidget);
    });

    testWidgets('dört adım tamamlanınca işletme kurulur, Bugün açılır', (
      tester,
    ) async {
      final service = FakeOrganizationService();
      final container = await _pumpApp(tester, service: service);

      // Dil: cihaz dili seçili gelir.
      await _continue(tester);

      // Ülke: aranıp seçilir.
      expect(find.text('Step 2 of 4'), findsOneWidget);
      await tester.enterText(_inCountryStep(find.byType(TextField)), 'germ');
      await tester.pumpAndSettle();
      await _tap(tester, find.text('Germany'));
      expect(_countryTile(tester, 'Germany').selected, isTrue);
      await _continue(tester);

      // Ad: yazılmadan geçilmez.
      expect(find.text('Step 3 of 4'), findsOneWidget);
      expect(_button(tester, 'Continue').onPressed, isNull);
      await tester.enterText(
        find.descendant(
          of: find.byType(NameStep),
          matching: find.byType(TextField),
        ),
        '  Golden Comb  ',
      );
      await tester.pump();
      await _continue(tester);

      // Kovan sayısı: seçilmeden kurulmaz.
      expect(find.text('Step 4 of 4'), findsOneWidget);
      expect(_button(tester, 'Set up business').onPressed, isNull);
      await _tap(tester, find.text('11–50'));
      await _tap(tester, find.text('Set up business'));

      final created = service.created.single;
      expect(
        created,
        Organization(
          id: created.id,
          name: 'Golden Comb',
          countryCode: 'DE',
          currency: 'EUR',
          hiveCountRange: HiveCountRange.upTo50,
        ),
      );
      expect(created.id, matches(RegExp('^[0-9a-f-]{14}7')));
      expect(find.byType(TodayScreen), findsOneWidget);
      expect(find.byType(AppNavigationBar), findsOneWidget);

      final region = container.read(regionConfigProvider);
      expect(region.countryCode, 'DE');
      expect(region.profile, RegionProfile.other);
    });

    testWidgets('dil seçimi hemen uygulanır', (tester) async {
      final container = await _pumpApp(tester);

      await _tap(tester, find.text('Türkçe'));

      expect(container.read(languageProvider), AppLanguage.turkish);
      expect(find.text('Hangi dili kullanalım?'), findsOneWidget);
      expect(find.text('Adım 1/4'), findsOneWidget);

      await _tap(tester, find.text('Devam'));
      expect(find.text('İşletmen hangi ülkede?'), findsOneWidget);
    });

    testWidgets('cihaz dilinin ülkesi önerilir ve seçili gelir', (
      tester,
    ) async {
      _setDeviceLocales(tester, const [Locale('tr', 'TR')]);
      await _pumpApp(tester);

      await _tap(tester, find.text('Devam'));

      expect(_inCountryStep(find.text('Cihazına göre önerilen')), findsOne);
      expect(_countryTile(tester, 'Türkiye').selected, isTrue);
      expect(_inCountryStep(find.text('TRY')), findsOneWidget);
      expect(_button(tester, 'Devam').onPressed, isNotNull);
    });

    testWidgets('ülke önerilemezse seçilene kadar geçilmez', (tester) async {
      _setDeviceLocales(tester, const [Locale('en')]);
      await _pumpApp(tester);

      await _continue(tester);

      expect(
        _inCountryStep(find.text('Suggested for your device')),
        findsNothing,
      );
      expect(_button(tester, 'Continue').onPressed, isNull);

      await _tap(tester, find.text('Afghanistan'));

      expect(_button(tester, 'Continue').onPressed, isNotNull);
    });

    testWidgets('aramaya uyan ülke yoksa söylenir', (tester) async {
      await _pumpApp(tester);
      await _continue(tester);

      await tester.enterText(_inCountryStep(find.byType(TextField)), 'xyz');
      await tester.pumpAndSettle();

      expect(find.text('No country matches your search.'), findsOneWidget);
      expect(_inCountryStep(find.byType(ListTile)), findsNothing);
    });

    testWidgets('geri dönülünce önceki adım açılır, yazılan ad korunur', (
      tester,
    ) async {
      await _pumpApp(tester);
      await _continue(tester);
      await _continue(tester);
      await tester.enterText(find.byType(TextField), 'Golden Comb');
      await _continue(tester);
      expect(find.byType(HiveCountStep), findsOneWidget);

      await tester.pageBack();
      await tester.pumpAndSettle();
      expect(find.byType(NameStep), findsOneWidget);
      expect(find.text('Golden Comb'), findsOneWidget);

      // Android geri tuşu da önceki adıma döner.
      await tester.binding.handlePopRoute();
      await tester.pumpAndSettle();
      expect(find.byType(CountryStep), findsOneWidget);
      expect(find.byType(OnboardingScreen), findsOneWidget);
    });

    testWidgets('kovan aralığı chip ile seçilir, yeniden dokununca kalkar', (
      tester,
    ) async {
      await _pumpApp(tester);
      await _continue(tester);
      await _continue(tester);
      await tester.enterText(find.byType(TextField), 'Golden Comb');
      await _continue(tester);

      for (final label in [
        'None yet',
        '1–10',
        '11–50',
        '51–200',
        'More than 200',
      ]) {
        expect(find.text(label), findsOneWidget, reason: label);
      }

      await _tap(tester, find.text('More than 200'));
      expect(_button(tester, 'Set up business').onPressed, isNotNull);

      await _tap(tester, find.text('More than 200'));
      expect(_button(tester, 'Set up business').onPressed, isNull);
    });

    testWidgets('kurulamazsa hata gösterilir; yeniden deneme aynı kimlikle', (
      tester,
    ) async {
      final service = FakeOrganizationService()
        ..createFailure = OrganizationFailure.network;
      await _pumpApp(tester, service: service);
      await _continue(tester);
      await _continue(tester);
      await tester.enterText(find.byType(TextField), 'Golden Comb');
      await _continue(tester);
      await _tap(tester, find.text('None yet'));

      await _tap(tester, find.text('Set up business'));

      expect(
        find.text("Couldn't connect. Check your internet and try again."),
        findsOneWidget,
      );
      expect(find.byIcon(AppStatus.critical.icon), findsOneWidget);
      expect(find.byType(HiveCountStep), findsOneWidget);

      service.createFailure = null;
      await _tap(tester, find.text('Set up business'));

      expect(service.created, hasLength(2));
      expect(service.created.last.id, service.created.first.id);
      expect(find.byType(TodayScreen), findsOneWidget);
    });

    testWidgets('işletme alınamazsa akış açılmaz; yeniden denenir', (
      tester,
    ) async {
      final service = FakeOrganizationService(
        serverOrganization: testOrganization,
      )..fetchFailure = OrganizationFailure.network;
      await _pumpApp(tester, service: service);

      expect(find.text("Couldn't load your business"), findsOneWidget);
      expect(find.text('Step 1 of 4'), findsNothing);

      service.fetchFailure = null;
      await _tap(tester, find.text('Try again'));

      expect(service.fetchCount, 2);
      expect(find.byType(TodayScreen), findsOneWidget);
    });

    testWidgets('onboarding’den çıkış yapılabilir', (tester) async {
      final auth = FakeAuthService(user: testUser);
      await _pumpApp(tester, auth: auth);

      await _tap(tester, find.byTooltip('Sign out'));

      expect(auth.signOutCount, 1);
      expect(find.byType(SignInEmailScreen), findsOneWidget);
    });

    testWidgets('360dp ekranda 1.5x yazıyla adımlar taşmaz', (tester) async {
      tester.view
        ..physicalSize = const Size(360, 640)
        ..devicePixelRatio = 1;
      tester.platformDispatcher.textScaleFactorTestValue = 1.5;
      addTearDown(tester.view.reset);
      addTearDown(tester.platformDispatcher.clearTextScaleFactorTestValue);

      await _pumpApp(tester);
      await _continue(tester);
      await _continue(tester);
      await tester.enterText(find.byType(TextField), 'Golden Comb');
      await _continue(tester);
      // Büyük yazıda soru ekranı doldurur; chip'lere kaydırılarak ulaşılır.
      await tester.scrollUntilVisible(
        find.text('More than 200'),
        200,
        scrollable: find.descendant(
          of: find.byType(HiveCountStep),
          matching: find.byType(Scrollable),
        ),
      );
      await _tap(tester, find.text('More than 200'));

      expect(tester.takeException(), isNull);
      expect(_button(tester, 'Set up business').onPressed, isNotNull);
    });
  });
}
