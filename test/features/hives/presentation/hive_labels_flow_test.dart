import 'dart:convert';

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
import 'package:mobil_arici/features/apiaries/domain/apiary.dart';
import 'package:mobil_arici/features/hives/data/hive_repository.dart';
import 'package:mobil_arici/features/hives/domain/hive.dart';
import 'package:mobil_arici/features/hives/presentation/labels/hive_labels_screen.dart';

import '../../../helpers/fake_auth_service.dart';
import '../../../helpers/fake_organization_service.dart';
import '../../../helpers/fake_print_service.dart';
import '../../../helpers/test_database.dart';

final String _orgId = testOrganization.id;

Future<ProviderContainer> _open(
  WidgetTester tester, {
  required AppDatabase db,
  required FakePrintService printer,
  required String location,
}) async {
  final container = ProviderContainer.test(
    overrides: signedIn(db: db, printer: printer),
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

/// PDF yazı tiplerini paketten okur ve gerçek zamanda üretilir; sahte
/// zamanda beklenmez.
Future<void> _tapAndBuild(WidgetTester tester, Finder finder) async {
  await tester.ensureVisible(finder);
  await tester.pumpAndSettle();
  await tester.runAsync(() async {
    await tester.tap(finder);
    for (var i = 0; i < 100 && _busy(tester); i++) {
      await Future<void>.delayed(const Duration(milliseconds: 50));
      await tester.pump();
    }
  });
  await tester.pumpAndSettle();
}

bool _busy(WidgetTester tester) =>
    find.text('Preparing the PDF…').evaluate().isNotEmpty ||
    find.text('PDF hazırlanıyor…').evaluate().isNotEmpty ||
    // Dokunuş henüz işlenmediyse özet satırı değişmemiştir.
    tester.widgetList(find.byType(BigButton)).isEmpty;

bool _checked(WidgetTester tester, String label) => tester
    .widget<CheckboxListTile>(find.widgetWithText(CheckboxListTile, label))
    .value!;

BigButton _button(WidgetTester tester, String label) =>
    tester.widget<BigButton>(find.widgetWithText(BigButton, label));

BigButton _shareButton(WidgetTester tester) => _button(tester, 'Share PDF');

/// Kovan listesi önizlemenin altında; bir ekrana sığsın.
void _tall(WidgetTester tester) {
  tester.view
    ..physicalSize = const Size(800, 2000)
    ..devicePixelRatio = 1;
  addTearDown(tester.view.reset);
}

void main() {
  late AppDatabase db;
  late HiveRepository hives;
  late FakePrintService printer;
  late Apiary yayla;

  setUp(() async {
    db = openTestDatabase();
    hives = HiveRepository(db);
    printer = FakePrintService();
    yayla = await ApiaryRepository(db).create(orgId: _orgId, name: 'Yayla');
  });

  Future<Hive> createHive(
    String number, {
    HiveStatus status = HiveStatus.active,
  }) => hives.create(
    orgId: _orgId,
    number: number,
    type: HiveType.langstroth,
    apiaryId: yayla.id,
    status: status,
  );

  testWidgets('kovansız arılıkta etiket butonu yok', (tester) async {
    await _open(
      tester,
      db: db,
      printer: printer,
      location: AppRoutes.apiary(yayla.id),
    );

    expect(find.byTooltip('Print labels'), findsNothing);
  });

  testWidgets('arılıktan açılır; aktif kovanlar seçili gelir, yazdırılır', (
    tester,
  ) async {
    _tall(tester);
    await createHive('10');
    await createHive('9');
    await createHive('5', status: HiveStatus.dead);
    await _open(
      tester,
      db: db,
      printer: printer,
      location: AppRoutes.apiary(yayla.id),
    );

    await _tap(tester, find.byTooltip('Print labels'));

    expect(find.byType(HiveLabelsScreen), findsOneWidget);
    // Sayı sırasıyla.
    final order = [
      for (final text in ['Hive 5', 'Hive 9', 'Hive 10'])
        tester.getTopLeft(find.text(text)).dy,
    ];
    expect(order, [...order]..sort());
    expect(_checked(tester, 'Hive 9'), isTrue);
    expect(_checked(tester, 'Hive 10'), isTrue);
    expect(_checked(tester, 'Hive 5'), isFalse);
    expect(find.widgetWithText(StatusBadge, 'Dead'), findsOneWidget);
    expect(find.text('2 labels · 1 page'), findsOneWidget);

    await _tapAndBuild(tester, find.widgetWithText(BigButton, 'Print'));

    final printed = printer.printed.single;
    expect(printed.name, 'Hive labels - Yayla');
    expect(ascii.decode(printed.bytes.sublist(0, 5)), '%PDF-');
    expect(printer.shared, isEmpty);
    expect(find.text('2 labels · 1 page'), findsOneWidget);
    expect(_button(tester, 'Print').onPressed, isNotNull);
  });

  testWidgets('seçim değişir; hiç seçili yokken yazdırılamaz', (tester) async {
    _tall(tester);
    await createHive('101');
    await createHive('5', status: HiveStatus.sold);
    await _open(
      tester,
      db: db,
      printer: printer,
      location: AppRoutes.hiveLabels(yayla.id),
    );

    await _tap(tester, find.text('Hive 5'));
    expect(_checked(tester, 'Hive 5'), isTrue);
    expect(find.text('2 labels · 1 page'), findsOneWidget);

    await _tap(tester, find.text('Select none'));
    expect(_checked(tester, 'Hive 101'), isFalse);
    expect(find.text('No hives selected'), findsOneWidget);
    expect(_button(tester, 'Print').onPressed, isNull);
    expect(_shareButton(tester).onPressed, isNull);

    await _tap(tester, find.text('Hive 101'));
    expect(find.text('1 label · 1 page'), findsOneWidget);

    await _tap(tester, find.text('Select all'));
    expect(_checked(tester, 'Hive 5'), isTrue);
    expect(_checked(tester, 'Hive 101'), isTrue);
  });

  testWidgets('25 kovan iki sayfa tutar; PDF paylaşılır', (tester) async {
    await hives.createMany(
      orgId: _orgId,
      apiaryId: yayla.id,
      numbers: [for (var n = 101; n <= 125; n++) '$n'],
      type: HiveType.langstroth,
    );
    await _open(
      tester,
      db: db,
      printer: printer,
      location: AppRoutes.hiveLabels(yayla.id),
    );
    expect(find.text('25 labels · 2 pages'), findsOneWidget);

    await _tapAndBuild(tester, find.widgetWithText(BigButton, 'Share PDF'));

    expect(printer.shared.single.filename, 'Hive labels - Yayla.pdf');
    expect(printer.printed, isEmpty);
  });

  testWidgets('PDF çıkarılamazsa söylenir, yeniden denenebilir', (
    tester,
  ) async {
    await createHive('101');
    printer.failure = Exception('yazıcı yok');
    await _open(
      tester,
      db: db,
      printer: printer,
      location: AppRoutes.hiveLabels(yayla.id),
    );

    await _tapAndBuild(tester, find.widgetWithText(BigButton, 'Print'));

    expect(find.text("Couldn't prepare the PDF. Try again."), findsOneWidget);
    expect(_button(tester, 'Print').onPressed, isNotNull);
  });

  testWidgets('olmayan arılık', (tester) async {
    await _open(
      tester,
      db: db,
      printer: printer,
      location: AppRoutes.hiveLabels('yok'),
    );

    expect(find.text('Apiary not found'), findsOneWidget);
  });

  testWidgets('Türkçe metinler', (tester) async {
    _tall(tester);
    await createHive('101');
    await createHive('102');
    final container = await _open(
      tester,
      db: db,
      printer: printer,
      location: AppRoutes.apiary(yayla.id),
    );
    container.read(languageProvider.notifier).language = AppLanguage.turkish;
    await tester.pumpAndSettle();

    await _tap(tester, find.byTooltip('Etiket yazdır'));
    expect(find.text('Etiket yazdır'), findsOneWidget);
    expect(
      find.text(
        'Etiketi basılacak kovanları seç. A4 sayfaya 24 etiket (70 × 37 mm) '
        'sığar; yazdırırken ölçeği %100 seç.',
      ),
      findsOneWidget,
    );
    expect(find.text('Kovan 101'), findsOneWidget);
    expect(find.text('2 etiket · 1 sayfa'), findsOneWidget);
    await _tap(tester, find.text('Hiçbirini seçme'));
    expect(find.text('Seçili kovan yok'), findsOneWidget);
    await _tap(tester, find.text('Tümünü seç'));
    expect(find.widgetWithText(BigButton, 'PDF paylaş'), findsOneWidget);

    await _tapAndBuild(tester, find.widgetWithText(BigButton, 'Yazdır'));
    expect(printer.printed.single.name, 'Kovan etiketleri - Yayla');
  });

  testWidgets('360dp ekranda 1.5x yazı ve eldivenle taşmaz', (tester) async {
    tester.view
      ..physicalSize = const Size(360, 640)
      ..devicePixelRatio = 1;
    tester.platformDispatcher.textScaleFactorTestValue = 1.5;
    addTearDown(tester.view.reset);
    addTearDown(tester.platformDispatcher.clearTextScaleFactorTestValue);
    await createHive('A-123456', status: HiveStatus.merged);
    await createHive('101');
    final container = await _open(
      tester,
      db: db,
      printer: printer,
      location: AppRoutes.hiveLabels(yayla.id),
    );
    expect(tester.takeException(), isNull);

    container.read(appearanceProvider.notifier).setGloveMode(enabled: true);
    await tester.pumpAndSettle();
    expect(tester.takeException(), isNull);
    await tester.scrollUntilVisible(
      find.text('Hive A-123456'),
      100,
      scrollable: find
          .descendant(
            of: find.byType(HiveLabelsScreen),
            matching: find.byType(Scrollable),
          )
          .first,
    );
    await _tap(tester, find.text('Select all'));
    expect(tester.takeException(), isNull);
    expect(find.text('Hive A-123456'), findsOneWidget);
    expect(_checked(tester, 'Hive A-123456'), isTrue);
  });
}
