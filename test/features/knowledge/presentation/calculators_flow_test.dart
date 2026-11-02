import 'package:clock/clock.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:mobil_arici/app/app.dart';
import 'package:mobil_arici/app/router.dart';
import 'package:mobil_arici/app/routes.dart';
import 'package:mobil_arici/core/db/app_database.dart';
import 'package:mobil_arici/core/design_system/design_system.dart';
import 'package:mobil_arici/core/l10n/app_language.dart';
import 'package:mobil_arici/core/l10n/language_provider.dart';
import 'package:mobil_arici/core/region/region_config.dart';
import 'package:mobil_arici/core/region/region_provider.dart';
import 'package:mobil_arici/features/apiaries/data/apiary_repository.dart';
import 'package:mobil_arici/features/hives/data/hive_repository.dart';
import 'package:mobil_arici/features/hives/domain/hive.dart';
import 'package:mobil_arici/features/knowledge/domain/calculator_rules.dart';
import 'package:mobil_arici/features/knowledge/presentation/calculator_screen.dart';
import 'package:mobil_arici/features/knowledge/presentation/calculators_screen.dart';

import '../../../helpers/fake_auth_service.dart';
import '../../../helpers/fake_organization_service.dart';
import '../../../helpers/test_database.dart';

final _may = Clock.fixed(DateTime(2026, 5, 20, 9));

Future<ProviderContainer> _open(
  WidgetTester tester, {
  required AppDatabase db,
  required String location,
  RegionConfig? region,
}) async {
  final container = ProviderContainer.test(
    overrides: [
      ...signedIn(db: db),
      if (region != null) regionConfigProvider.overrideWithValue(region),
    ],
  );
  await tester.pumpWidget(
    UncontrolledProviderScope(container: container, child: const App()),
  );
  await tester.pumpAndSettle();
  container.read(routerProvider).go(location);
  await tester.pumpAndSettle();
  return container;
}

Future<void> _tap(WidgetTester tester, Finder finder) async {
  await tester.ensureVisible(finder);
  await tester.pumpAndSettle();
  await tester.tap(finder);
  await tester.pumpAndSettle();
}

Future<void> _go(ProviderContainer container, WidgetTester tester, String to) {
  container.read(routerProvider).go(to);
  return tester.pumpAndSettle();
}

/// [label] adlı satır alanının metin kutusu.
Finder _field(String label) => find.descendant(
  of: find.widgetWithText(InlineField, label),
  matching: find.byType(TextField),
);

String? _text(WidgetTester tester, Finder field) =>
    tester.widget<TextField>(field).controller?.text;

void main() {
  late AppDatabase db;

  setUpAll(initializeDateFormatting);

  setUp(() async {
    db = openTestDatabase();
    final apiary = await ApiaryRepository(db)
        .create(orgId: testOrganization.id, name: 'Kızılçam');
    await HiveRepository(db).createMany(
      orgId: testOrganization.id,
      apiaryId: apiary.id,
      numbers: ['1', '2', '3'],
      type: HiveType.langstroth,
    );
  });

  void tall(WidgetTester tester) {
    tester.view
      ..physicalSize = const Size(800, 2400)
      ..devicePixelRatio = 1;
    addTearDown(tester.view.reset);
  }

  testWidgets('liste dört hesaplayıcıyı açar; tanınmayan hesaplayıcı boş '
      'durum', (tester) async {
    tall(tester);
    final container = await _open(
      tester,
      db: db,
      location: AppRoutes.calculators,
    );

    expect(find.byType(CalculatorsScreen), findsOneWidget);
    for (final text in [
      'Syrup',
      'Treatment dose',
      'Queen calendar',
      'Yield',
      'Calculations work offline and save nothing.',
    ]) {
      expect(find.text(text), findsOneWidget, reason: text);
    }
    await _tap(tester, find.text('Treatment dose'));
    expect(find.byType(CalculatorScreen), findsOneWidget);
    expect(find.text('Dose per hive'), findsOneWidget);

    await _go(container, tester, '/more/knowledge/calculators/yok');
    expect(find.text('Calculator not found'), findsOneWidget);
  });

  testWidgets('şurup: kovan sayısı aktif kovanlarla dolu; tür ve sayı '
      'değişince şeker ve su güncellenir', (tester) async {
    tall(tester);
    await _open(
      tester,
      db: db,
      location: AppRoutes.calculator(Calculator.syrup),
    );

    expect(_text(tester, _field('Number of hives')), '3');
    expect(find.text('3 hives × 3 L'), findsOneWidget);
    expect(find.text('9 L syrup'), findsOneWidget);
    // 2:1, 9 L ≈ 12 kg: 8 kg şeker, 4 L su.
    expect(find.text('≈ 8 kg'), findsOneWidget);
    expect(find.text('≈ 4 L'), findsOneWidget);

    await tester.enterText(_field('Number of hives'), '60');
    await tester.pumpAndSettle();
    expect(find.text('180 L syrup'), findsOneWidget);
    expect(find.text('≈ 160 kg'), findsOneWidget);

    await _tap(tester, find.text('Syrup 1:1 · stimulative'));
    // 1:1, 180 L ≈ 221 kg: yarısı şeker, yarısı su.
    expect(find.text('≈ 111 kg'), findsOneWidget);
    expect(find.text('≈ 111 L'), findsOneWidget);

    await tester.enterText(_field('Number of hives'), '');
    await tester.pumpAndSettle();
    expect(find.text('Enter the hive count and amount.'), findsOneWidget);
  });

  testWidgets('ilaç dozu: kovan × doz, birim seçilir', (tester) async {
    tall(tester);
    await _open(
      tester,
      db: db,
      location: AppRoutes.calculator(Calculator.dose),
    );

    expect(find.text('Enter the hive count and amount.'), findsOneWidget);
    await tester.enterText(_field('Number of hives'), '60');
    await tester.enterText(_field('Dose per hive'), '2');
    await tester.pumpAndSettle();
    expect(find.text('120 strips'), findsOneWidget);
    expect(find.text('60 hives × 2 strip'), findsOneWidget);

    await _tap(tester, find.text('ml'));
    await tester.enterText(_field('Dose per hive'), '2,5');
    await tester.pumpAndSettle();
    expect(find.text('150 ml'), findsOneWidget);
  });

  testWidgets('ana takvimi: aktarma gününden adımların günleri', (
    tester,
  ) async {
    tall(tester);
    await withClock(_may, () async {
      await _open(
        tester,
        db: db,
        location: AppRoutes.calculator(Calculator.queen),
      );

      expect(find.text('May 20, 2026'), findsNWidgets(2));
      expect(find.text('D10'), findsOneWidget);
      expect(find.text('Distribute cells'), findsOneWidget);
      expect(find.text('May 30, 2026'), findsOneWidget);
      expect(find.text('Jun 13, 2026'), findsOneWidget);
    });
  });

  testWidgets('verim: toplam ÷ kovan, bölgenin biriminde', (tester) async {
    tall(tester);
    await _open(
      tester,
      db: db,
      location: AppRoutes.calculator(Calculator.yield_),
    );

    await tester.enterText(_field('Total honey (kg)'), '1500');
    await tester.pumpAndSettle();
    expect(find.text('500 kg'), findsOneWidget);

    await tester.enterText(_field('Number of hives'), '60');
    await tester.pumpAndSettle();
    expect(find.text('25 kg'), findsOneWidget);
  });

  testWidgets('ABD profilinde verim pound ile', (tester) async {
    tall(tester);
    await _open(
      tester,
      db: db,
      location: AppRoutes.calculator(Calculator.yield_),
      region: resolveRegionConfig('US'),
    );

    await tester.enterText(_field('Total honey (lb)'), '300');
    await tester.pumpAndSettle();
    expect(find.text('100 lb'), findsOneWidget);
  });

  testWidgets('Türkçe metinler', (tester) async {
    tall(tester);
    final container = await _open(
      tester,
      db: db,
      location: AppRoutes.calculators,
    );
    container.read(languageProvider.notifier).language = AppLanguage.turkish;
    await tester.pumpAndSettle();

    expect(find.text('Hesaplayıcılar'), findsOneWidget);
    expect(find.text('İlaç dozu'), findsOneWidget);
    await _go(container, tester, AppRoutes.calculator(Calculator.dose));
    expect(find.text('Kovan sayısını ve miktarı yaz.'), findsOneWidget);
    await tester.enterText(_field('Kovan başına doz'), '1');
    await tester.pumpAndSettle();
    expect(find.text('3 şerit'), findsOneWidget);
    expect(find.text('3 kovan × 1 şerit'), findsOneWidget);
  });

  testWidgets('360dp ekranda 1.5x yazı ve eldivenle taşmaz', (tester) async {
    tester.view
      ..physicalSize = const Size(360, 640)
      ..devicePixelRatio = 1;
    tester.platformDispatcher.textScaleFactorTestValue = 1.5;
    addTearDown(tester.view.reset);
    addTearDown(tester.platformDispatcher.clearTextScaleFactorTestValue);

    final container = await _open(tester, db: db, location: AppRoutes.more);
    container.read(appearanceProvider.notifier).setGloveMode(enabled: true);
    container.read(languageProvider.notifier).language = AppLanguage.turkish;
    await tester.pumpAndSettle();

    for (final location in [
      AppRoutes.calculators,
      for (final calculator in Calculator.values)
        AppRoutes.calculator(calculator),
    ]) {
      await _go(container, tester, location);
      expect(tester.takeException(), isNull, reason: location);
    }
  });
}
