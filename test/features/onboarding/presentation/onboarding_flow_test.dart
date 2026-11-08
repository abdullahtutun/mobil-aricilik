import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/misc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mobil_arici/app/app.dart';
import 'package:mobil_arici/app/shell/app_navigation_bar.dart';
import 'package:mobil_arici/core/db/app_database.dart';
import 'package:mobil_arici/core/db/app_database_provider.dart';
import 'package:mobil_arici/core/design_system/design_system.dart';
import 'package:mobil_arici/core/l10n/app_language.dart';
import 'package:mobil_arici/core/l10n/language_provider.dart';
import 'package:mobil_arici/core/region/region_config.dart';
import 'package:mobil_arici/core/region/region_provider.dart';
import 'package:mobil_arici/core/services/location_service_provider.dart';
import 'package:mobil_arici/features/apiaries/data/apiary_repository.dart';
import 'package:mobil_arici/features/auth/presentation/auth_providers.dart';
import 'package:mobil_arici/features/auth/presentation/sign_in_email_screen.dart';
import 'package:mobil_arici/features/onboarding/presentation/first_apiary_screen.dart';
import 'package:mobil_arici/features/onboarding/presentation/onboarding_screen.dart';
import 'package:mobil_arici/features/onboarding/presentation/widgets/business_step.dart';
import 'package:mobil_arici/features/onboarding/presentation/widgets/country_picker.dart';
import 'package:mobil_arici/features/onboarding/presentation/widgets/language_country_step.dart';
import 'package:mobil_arici/features/organization/domain/organization.dart';
import 'package:mobil_arici/features/organization/domain/organization_failure.dart';
import 'package:mobil_arici/features/team/domain/team_failure.dart';
import 'package:mobil_arici/features/team/presentation/team_providers.dart';
import 'package:mobil_arici/features/today/presentation/today_screen.dart';
import 'package:mobil_arici/features/weather/presentation/weather_providers.dart';

import '../../../helpers/fake_auth_service.dart';
import '../../../helpers/fake_location_service.dart';
import '../../../helpers/fake_organization_service.dart';
import '../../../helpers/fake_sync_service.dart';
import '../../../helpers/fake_team_service.dart';
import '../../../helpers/fake_weather_service.dart';
import '../../../helpers/test_database.dart';

/// Giriş yapmış ama işletmesi olmayan kullanıcıyla uygulamayı açar.
Future<ProviderContainer> _pumpApp(
  WidgetTester tester, {
  FakeOrganizationService? service,
  FakeAuthService? auth,
  AppDatabase? db,
  FakeLocationService? location,
  List<Override> overrides = const [],
}) async {
  final container = ProviderContainer.test(
    overrides: [
      authServiceProvider.overrideWithValue(
        auth ?? FakeAuthService(user: testUser),
      ),
      ...organizationOverrides(service: service ?? FakeOrganizationService()),
      appDatabaseProvider.overrideWithValue(db ?? openTestDatabase()),
      locationServiceProvider.overrideWithValue(
        location ?? FakeLocationService(),
      ),
      ...syncOverrides(),
      weatherServiceProvider.overrideWithValue(FakeWeatherService()),
      ...overrides,
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

/// Ülke alanına (seçili ülkenin adı ya da "Choose a country") dokunup
/// seçiciyi açar.
Future<void> _openCountryPicker(WidgetTester tester, String fieldText) => _tap(
  tester,
  find.descendant(
    of: find.byType(LanguageCountryStep),
    matching: find.text(fieldText),
  ),
);

Finder _inPicker(Finder finder) =>
    find.descendant(of: find.byType(CountryPicker), matching: finder);

Finder _nameField() => find.descendant(
  of: find.byType(BusinessStep),
  matching: find.byType(TextField),
);

/// Adı [label] olan alanın metin kutusu (ad alanın üstünde yazar).
Finder _field(String label) => find.descendant(
  of: find.ancestor(of: find.text(label), matching: find.byType(LabeledField)),
  matching: find.byType(TextField),
);

/// Dil ve ülke (önerilen), ad ve kovan aralığı adımlarını geçip işletmeyi
/// kurar.
Future<void> _setUpBusiness(WidgetTester tester) async {
  await _continue(tester);
  await tester.enterText(_nameField(), 'Golden Comb');
  await _tap(tester, find.text('None yet'));
  await _tap(tester, find.text('Set up business'));
}

void main() {
  group('Onboarding', () {
    testWidgets('işletmesi olmayan kullanıcı onboarding ile açılır', (
      tester,
    ) async {
      await _pumpApp(tester);

      expect(find.byType(OnboardingScreen), findsOneWidget);
      expect(find.byType(AppNavigationBar), findsNothing);
      expect(find.text('STEP 1 OF 3'), findsOneWidget);
      expect(find.text('Language and country'), findsOneWidget);
    });

    testWidgets('Koda sahibim: katılınca işletme kurmadan Bugün açılır', (
      tester,
    ) async {
      final org = FakeOrganizationService();
      final db = openTestDatabase();
      final team = FakeTeamService(db: db)
        ..onRedeem = () => org.serverOrganization = testOrganization;
      await _pumpApp(
        tester,
        service: org,
        db: db,
        overrides: [teamServiceProvider.overrideWithValue(team)],
      );

      await _tap(tester, find.text('I have a code'));
      await tester.enterText(
        find.descendant(
          of: find.byType(BottomSheet),
          matching: find.byType(TextField),
        ),
        'ar7-k2q',
      );
      await tester.pump();
      await _tap(tester, find.widgetWithText(BigButton, 'Join'));

      expect(team.redeemed, ['AR7K2Q']);
      expect(org.created, isEmpty);
      expect(find.byType(OnboardingScreen), findsNothing);
      expect(find.byType(AppNavigationBar), findsOneWidget);
    });

    testWidgets('Koda sahibim: geçersiz kodda onboarding açık kalır', (
      tester,
    ) async {
      final db = openTestDatabase();
      final team = FakeTeamService(db: db)..failure = TeamFailure.invalidCode;
      await _pumpApp(
        tester,
        db: db,
        overrides: [teamServiceProvider.overrideWithValue(team)],
      );

      await _tap(tester, find.text('I have a code'));
      await tester.enterText(
        find.descendant(
          of: find.byType(BottomSheet),
          matching: find.byType(TextField),
        ),
        'AR7K2Q',
      );
      await tester.pump();
      await _tap(tester, find.widgetWithText(BigButton, 'Join'));

      expect(
        find.text('The code is invalid, expired or already used.'),
        findsOneWidget,
      );
      expect(find.byType(OnboardingScreen), findsOneWidget);
    });

    testWidgets('Koda sahibim yalnız ilk adımda görünür', (tester) async {
      await _pumpApp(tester);
      expect(find.text('I have a code'), findsOneWidget);

      await _continue(tester);

      expect(find.text('I have a code'), findsNothing);
    });

    testWidgets('"Hayır, sabit" işletme türü olarak kurulumla gider', (
      tester,
    ) async {
      final service = FakeOrganizationService();
      await _pumpApp(tester, service: service);

      await _continue(tester);
      await tester.enterText(_nameField(), 'Golden Comb');
      await _tap(tester, find.text('None yet'));
      expect(find.text('DO YOU MOVE YOUR HIVES (MIGRATORY)?'), findsOneWidget);
      await _tap(tester, find.text('No, stationary'));
      await _tap(tester, find.text('Set up business'));

      expect(service.created.single.operationType, OperationType.stationary);
    });

    testWidgets('iki adım tamamlanınca işletme kurulur, ilk arılık açılır', (
      tester,
    ) async {
      final service = FakeOrganizationService();
      final container = await _pumpApp(tester, service: service);

      // Dil ve ülke: cihaz dili seçili, ülke seçiciden aranıp seçilir.
      await _openCountryPicker(tester, 'United States');
      await tester.enterText(_inPicker(find.byType(TextField)), 'germ');
      await tester.pumpAndSettle();
      await _tap(tester, _inPicker(find.text('Germany')));
      expect(find.byType(CountryPicker), findsNothing);
      expect(find.text('Settings for Germany'), findsOneWidget);
      expect(find.text('€ EUR'), findsOneWidget);
      await _continue(tester);

      // İşletme: ad ve kovan aralığı girilmeden kurulmaz.
      expect(find.text('STEP 2 OF 3'), findsOneWidget);
      expect(_button(tester, 'Set up business').onPressed, isNull);
      await tester.enterText(_nameField(), '  Golden Comb  ');
      await tester.pump();
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
          // Varsayılan: gezginci.
        ),
      );
      expect(created.id, matches(RegExp('^[0-9a-f-]{14}7')));
      expect(find.byType(FirstApiaryScreen), findsOneWidget);
      expect(find.text('STEP 3 OF 3'), findsOneWidget);
      expect(find.byType(AppNavigationBar), findsNothing);

      final region = container.read(regionConfigProvider);
      expect(region.countryCode, 'DE');
      expect(region.profile, RegionProfile.other);
    });

    testWidgets('dil seçimi hemen uygulanır', (tester) async {
      final container = await _pumpApp(tester);

      await _tap(tester, find.text('Türkçe'));

      expect(container.read(languageProvider), AppLanguage.turkish);
      expect(find.text('Dil ve ülke'), findsOneWidget);
      // Dokunulan kart başa kaydırıldı; sayaç ekranın üstünde kaldı.
      expect(find.text('ADIM 1/3', skipOffstage: false), findsOneWidget);

      await _tap(tester, find.text('Devam'));
      expect(find.text('İşletmeni tanıyalım'), findsOneWidget);
    });

    testWidgets('cihaz dilinin ülkesi önerilir; bölgenin getirdikleri yazar', (
      tester,
    ) async {
      _setDeviceLocales(tester, const [Locale('tr', 'TR')]);
      await _pumpApp(tester);

      expect(
        find.descendant(
          of: find.byType(RadioCardGroup<AppLanguage>),
          matching: find.text('Cihaz dili'),
        ),
        findsOneWidget,
      );
      expect(find.text('Türkiye için açılanlar'), findsOneWidget);
      expect(
        find.textContaining('AKS ve işletme tescil bilgileri'),
        findsOneWidget,
      );
      expect(find.text('₺ TRY'), findsOneWidget);
      expect(find.text('Kuzey yarımküre'), findsOneWidget);
      expect(_button(tester, 'Devam').onPressed, isNotNull);

      await _openCountryPicker(tester, 'Türkiye');
      expect(_inPicker(find.text('CİHAZINA GÖRE ÖNERİLEN')), findsOneWidget);
      expect(
        tester.getSemantics(
          find.ancestor(
            of: _inPicker(find.text('Türkiye')),
            matching: find.byType(OptionTile),
          ),
        ),
        isSemantics(isSelected: true, isButton: true, label: 'Türkiye\nTRY'),
      );
    });

    testWidgets('ülke önerilemezse seçilene kadar geçilmez', (tester) async {
      _setDeviceLocales(tester, const [Locale('en')]);
      await _pumpApp(tester);

      expect(_button(tester, 'Continue').onPressed, isNull);
      await _openCountryPicker(tester, 'Choose a country');
      expect(_inPicker(find.text('SUGGESTED FOR YOUR DEVICE')), findsNothing);

      await _tap(tester, _inPicker(find.text('Afghanistan')));

      expect(find.byType(CountryPicker), findsNothing);
      expect(_button(tester, 'Continue').onPressed, isNotNull);
    });

    testWidgets('aramaya uyan ülke yoksa söylenir', (tester) async {
      await _pumpApp(tester);
      await _openCountryPicker(tester, 'United States');

      await tester.enterText(_inPicker(find.byType(TextField)), 'xyz');
      await tester.pumpAndSettle();

      expect(find.text('No country matches your search.'), findsOneWidget);
      expect(_inPicker(find.byType(OptionTile)), findsNothing);
    });

    testWidgets('geri dönülünce önceki adım açılır, yazılan ad korunur', (
      tester,
    ) async {
      await _pumpApp(tester);
      await _continue(tester);
      await tester.enterText(_nameField(), 'Golden Comb');
      await tester.pump();

      await _tap(tester, find.text('Back'));
      expect(find.byType(LanguageCountryStep), findsOneWidget);
      expect(find.text('Back'), findsNothing);

      await _continue(tester);
      expect(find.text('Golden Comb'), findsOneWidget);

      // Android geri tuşu da önceki adıma döner.
      await tester.binding.handlePopRoute();
      await tester.pumpAndSettle();
      expect(find.byType(LanguageCountryStep), findsOneWidget);
      expect(find.byType(OnboardingScreen), findsOneWidget);
    });

    testWidgets('kovan aralığı chip ile seçilir, yeniden dokununca kalkar', (
      tester,
    ) async {
      await _pumpApp(tester);
      await _continue(tester);
      await tester.enterText(_nameField(), 'Golden Comb');

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
      await tester.enterText(_nameField(), 'Golden Comb');
      await _tap(tester, find.text('None yet'));

      await _tap(tester, find.text('Set up business'));

      expect(
        find.text("Couldn't connect. Check your internet and try again."),
        findsOneWidget,
      );
      expect(find.byIcon(AppStatus.critical.icon), findsOneWidget);
      expect(find.byType(BusinessStep), findsOneWidget);

      service.createFailure = null;
      await _tap(tester, find.text('Set up business'));

      expect(service.created, hasLength(2));
      expect(service.created.last.id, service.created.first.id);
      expect(find.byType(FirstApiaryScreen), findsOneWidget);
    });

    testWidgets('işletme alınamazsa akış açılmaz; yeniden denenir', (
      tester,
    ) async {
      final service = FakeOrganizationService(
        serverOrganization: testOrganization,
      )..fetchFailure = OrganizationFailure.network;
      await _pumpApp(tester, service: service);

      expect(find.text("Couldn't load your business"), findsOneWidget);
      expect(find.text('STEP 1 OF 3'), findsNothing);

      service.fetchFailure = null;
      await _tap(tester, find.text('Try again'));

      // İşletmesi zaten olan kullanıcıya ilk arılık sorulmaz.
      expect(service.fetchCount, 2);
      expect(find.byType(TodayScreen), findsOneWidget);
      expect(find.byType(FirstApiaryScreen), findsNothing);
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
      expect(tester.takeException(), isNull);
      await _continue(tester);
      await tester.enterText(_nameField(), 'Golden Comb');
      await _tap(tester, find.text('More than 200'));

      expect(tester.takeException(), isNull);
      expect(_button(tester, 'Set up business').onPressed, isNotNull);
    });
  });

  group('İlk arılık', () {
    testWidgets('kaydedilince arılık yerelde yazılır, Bugün açılır', (
      tester,
    ) async {
      final db = openTestDatabase();
      final service = FakeOrganizationService();
      await _pumpApp(tester, service: service, db: db);
      await _setUpBusiness(tester);

      // Ad yazılmadan kaydedilmez.
      expect(_button(tester, 'Save apiary').onPressed, isNull);
      await tester.enterText(_field('Apiary name'), '  Yayla  ');
      await tester.pump();
      await _tap(tester, find.text('Take location from GPS'));
      expect(find.text('40.12346, 29.65432'), findsOneWidget);
      expect(find.text('Accuracy ±8 m'), findsOneWidget);
      await _tap(tester, find.text('Save apiary'));

      expect(find.byType(TodayScreen), findsOneWidget);
      expect(find.byType(AppNavigationBar), findsOneWidget);
      final orgId = service.created.single.id;
      final apiaries = await tester.runAsync(
        () => ApiaryRepository(db).watchAll(orgId).first,
      );
      final apiary = apiaries!.single;
      expect(apiary.name, 'Yayla');
      expect(apiary.latitude, testFix.latitude);
      expect(apiary.longitude, testFix.longitude);
      expect(apiary.notes, isNull);
      expect(await readOutbox(db), hasLength(1));
    });

    testWidgets('atlanırsa arılık yazılmaz, Bugün açılır', (tester) async {
      final db = openTestDatabase();
      await _pumpApp(tester, db: db);
      await _setUpBusiness(tester);
      await tester.enterText(_field('Apiary name'), 'Yayla');

      await _tap(tester, find.text('Skip for now'));

      expect(find.byType(TodayScreen), findsOneWidget);
      expect(await db.select(db.apiaries).get(), isEmpty);
      expect(await readOutbox(db), isEmpty);
    });

    testWidgets('geri tuşu işletme adımlarına dönmez', (tester) async {
      await _pumpApp(tester);
      await _setUpBusiness(tester);

      await tester.binding.handlePopRoute();
      await tester.pumpAndSettle();

      expect(find.byType(FirstApiaryScreen), findsOneWidget);
      expect(find.byType(BusinessStep), findsNothing);
      expect(find.text('Back'), findsNothing);
    });

    testWidgets('360dp ekranda 1.5x yazı ve eldivenle taşmaz', (tester) async {
      final container = await _pumpApp(tester);
      await _setUpBusiness(tester);

      tester.view
        ..physicalSize = const Size(360, 640)
        ..devicePixelRatio = 1;
      tester.platformDispatcher.textScaleFactorTestValue = 1.5;
      addTearDown(tester.view.reset);
      addTearDown(tester.platformDispatcher.clearTextScaleFactorTestValue);
      container.read(appearanceProvider.notifier).setGloveMode(enabled: true);
      await tester.pumpAndSettle();

      await tester.scrollUntilVisible(
        find.text('Take location from GPS'),
        200,
        scrollable: find
            .descendant(
              of: find.byType(FirstApiaryScreen),
              matching: find.byType(Scrollable),
            )
            .first,
      );
      await _tap(tester, find.text('Take location from GPS'));

      expect(tester.takeException(), isNull);
      expect(find.text('Take location again'), findsOneWidget);
    });
  });
}
