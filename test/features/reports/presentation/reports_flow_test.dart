import 'package:drift/drift.dart' show Value;
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
import 'package:mobil_arici/core/region/region_config.dart';
import 'package:mobil_arici/core/region/region_provider.dart';
import 'package:mobil_arici/features/apiaries/data/apiary_repository.dart';
import 'package:mobil_arici/features/apiaries/domain/apiary.dart';
import 'package:mobil_arici/features/health/data/treatment_repository.dart';
import 'package:mobil_arici/features/health/domain/drug.dart';
import 'package:mobil_arici/features/health/domain/treatment.dart';
import 'package:mobil_arici/features/hives/data/hive_repository.dart';
import 'package:mobil_arici/features/hives/domain/hive.dart';
import 'package:mobil_arici/features/reports/presentation/reports_screen.dart';

import '../../../helpers/fake_auth_service.dart';
import '../../../helpers/fake_organization_service.dart';
import '../../../helpers/fake_print_service.dart';
import '../../../helpers/test_database.dart';

final String _orgId = testOrganization.id;

Future<ProviderContainer> _open(
  WidgetTester tester, {
  required AppDatabase db,
  required FakePrintService printer,
  String location = AppRoutes.reports,
  RegionConfig? region,
}) async {
  final container = ProviderContainer.test(
    overrides: [
      ...signedIn(db: db, printer: printer),
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
  // Kaydırılan listede henüz kurulmamış olabilir.
  if (finder.evaluate().isEmpty) {
    await tester.scrollUntilVisible(
      finder,
      200,
      scrollable: find.byType(Scrollable).first,
    );
  }
  await tester.ensureVisible(finder);
  await tester.pumpAndSettle();
  await tester.tap(finder);
  await tester.pumpAndSettle();
}

/// PDF yazı tiplerini paketten okur ve gerçek zamanda üretilir; sahte
/// zamanda beklenmez.
Future<void> _tapAndBuild(
  WidgetTester tester,
  Finder finder,
  FakePrintService printer,
) async {
  await tester.ensureVisible(finder);
  await tester.pumpAndSettle();
  final before = printer.printed.length + printer.shared.length;
  await tester.runAsync(() async {
    await tester.tap(finder);
    for (
      var i = 0;
      i < 100 && printer.printed.length + printer.shared.length == before;
      i++
    ) {
      await Future<void>.delayed(const Duration(milliseconds: 50));
      await tester.pump();
    }
  });
  await tester.pumpAndSettle();
}

Finder _button(String label) => find.widgetWithText(BigButton, label);

Finder _field(String label) => find.descendant(
  of: find.byWidgetPredicate((w) => w is LabeledField && w.label == label),
  matching: find.byType(TextField),
);

/// Formun tamamı ve önizleme bir ekrana sığsın.
void _tall(WidgetTester tester) {
  tester.view
    ..physicalSize = const Size(800, 2400)
    ..devicePixelRatio = 1;
  addTearDown(tester.view.reset);
}

String _text(WidgetTester tester, String label) =>
    tester.widget<TextField>(_field(label)).controller!.text;

void main() {
  late AppDatabase db;
  late FakePrintService printer;
  late Apiary yayla;
  late Hive hive;

  setUp(() async {
    db = openTestDatabase();
    printer = FakePrintService();
    yayla = await ApiaryRepository(db).create(orgId: _orgId, name: 'Yayla');
    hive = await HiveRepository(db).create(
      orgId: _orgId,
      number: '104',
      type: HiveType.langstroth,
      apiaryId: yayla.id,
    );
  });

  Future<void> treat() => TreatmentRepository(db).addToHive(
    hive,
    TreatmentPlan(
      drug: const DrugChoice(
        refDrugId: 'ref-amitraz',
        name: 'Amitraz strip',
        activeIngredient: DrugActiveIngredient.amitraz,
        doseUnit: DrugDoseUnit.strip,
      ),
      dose: 2,
      startedAt: DateTime.now().toUtc(),
      withdrawalDays: 14,
      batchNo: '24-118',
    ),
  );

  Future<void> organizationRow() {
    final at = DateTime.utc(2026);
    return db
        .into(db.organizations)
        .insert(
          OrganizationsCompanion.insert(
            id: _orgId,
            name: testOrganization.name,
            countryCode: 'TR',
            currency: 'TRY',
            createdAt: at,
            updatedAt: at,
            trRegistrationNo: const Value('TR-48-0001'),
            trAksNo: const Value('12345'),
          ),
        );
  }

  testWidgets("Daha fazla'dan açılır; TR başlık numaraları işletmeden dolar, "
      'defter yazdırılır', (tester) async {
    _tall(tester);
    await organizationRow();
    await treat();
    await _open(tester, db: db, printer: printer, location: AppRoutes.more);

    await _tap(tester, find.text('Reports'));

    expect(find.byType(ReportsScreen), findsOneWidget);
    expect(_text(tester, 'Holding registration no.'), 'TR-48-0001');
    expect(_text(tester, 'AKS no.'), '12345');
    expect(find.text('Registration number'), findsNothing);
    expect(find.text('1 treatment'), findsOneWidget);

    await _tapAndBuild(tester, _button('Create PDF'), printer);

    final printed = printer.printed.single;
    expect(printed.name, startsWith('Treatment Register '));
    expect(String.fromCharCodes(printed.bytes.take(5)), '%PDF-');
    expect(find.text("Couldn't create the PDF. Try again."), findsNothing);
  });

  testWidgets('diğer bölgede serbest kayıt numarası; AKS alanı yok', (
    tester,
  ) async {
    _tall(tester);
    await organizationRow();
    await _open(
      tester,
      db: db,
      printer: printer,
      region: resolveRegionConfig('DE'),
    );

    expect(find.text('Registration number'), findsOneWidget);
    expect(_text(tester, 'Registration number'), isEmpty);
    expect(find.text('AKS no.'), findsNothing);
    expect(find.text('Holding registration no.'), findsNothing);

    await tester.enterText(_field('Registration number'), 'DE-0915');
    await _tapAndBuild(tester, _button('Share'), printer);
    expect(printer.shared.single.filename, endsWith('.pdf'));
  });

  testWidgets('kovan geçmişi: arılık seçilince kovanlar çıkar; tek kovan '
      'paylaşılır', (tester) async {
    _tall(tester);
    await treat();
    await _open(tester, db: db, printer: printer);

    await _tap(tester, find.text('Hive history'));
    await _tap(tester, find.text('Yayla'));
    expect(find.text('All hives'), findsOneWidget);
    await _tap(tester, find.text('104'));
    // Treatment + arılığa eklenme.
    expect(find.text('1 hive · 2 records'), findsOneWidget);

    await _tapAndBuild(tester, _button('Share'), printer);

    expect(printer.shared.single.filename, startsWith('Hive History '));
    expect(printer.shared.single.filename, endsWith('.pdf'));
  });

  testWidgets('dönemde kayıt yoksa söyler', (tester) async {
    _tall(tester);
    await _open(tester, db: db, printer: printer);

    expect(find.text('No records in this period.'), findsWidgets);
  });

  testWidgets('Türkçe metinler; PDF dili ayrı seçilir', (tester) async {
    _tall(tester);
    await treat();
    final container = await _open(tester, db: db, printer: printer);
    container.read(languageProvider.notifier).language = AppLanguage.turkish;
    await tester.pumpAndSettle();

    expect(find.text('Raporlar'), findsOneWidget);
    expect(find.text('İlaç kayıt defteri'), findsOneWidget);
    expect(find.text('Tüm arılıklar'), findsOneWidget);
    expect(find.text('İşletme tescil no'), findsOneWidget);
    expect(find.text('1 uygulama'), findsOneWidget);

    await _tap(tester, find.text('English'));
    expect(find.text('1 treatment'), findsOneWidget);
    await _tapAndBuild(tester, _button('PDF oluştur'), printer);

    expect(printer.printed.single.name, startsWith('Treatment Register '));
  });

  testWidgets('360dp ekranda 1.5x yazı ve eldivenle taşmaz', (tester) async {
    tester.view
      ..physicalSize = const Size(360, 640)
      ..devicePixelRatio = 1;
    tester.platformDispatcher.textScaleFactorTestValue = 1.5;
    addTearDown(tester.view.reset);
    addTearDown(tester.platformDispatcher.clearTextScaleFactorTestValue);
    await treat();

    final container = await _open(tester, db: db, printer: printer);
    container.read(appearanceProvider.notifier).setGloveMode(enabled: true);
    await tester.pumpAndSettle();
    expect(tester.takeException(), isNull);

    await _tap(tester, find.text('Hive history'));
    await _tap(tester, find.text('Yayla'));
    await _tap(tester, find.text('104'));
    // Formun sonundaki önizlemeye kadar.
    await tester.scrollUntilVisible(
      find.text('1 hive · 2 records'),
      200,
      scrollable: find.byType(Scrollable).first,
    );
    await tester.pumpAndSettle();
    expect(tester.takeException(), isNull);
  });
}
