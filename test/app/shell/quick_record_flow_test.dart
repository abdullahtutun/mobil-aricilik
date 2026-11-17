import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mobil_arici/app/app.dart';
import 'package:mobil_arici/app/router.dart';
import 'package:mobil_arici/app/routes.dart';
import 'package:mobil_arici/app/shell/app_navigation_bar.dart';
import 'package:mobil_arici/app/shell/quick_record_sheet.dart';
import 'package:mobil_arici/app/shell/scan_screen.dart';
import 'package:mobil_arici/core/db/app_database.dart';
import 'package:mobil_arici/core/design_system/design_system.dart';
import 'package:mobil_arici/features/apiaries/data/apiary_repository.dart';
import 'package:mobil_arici/features/feeding/presentation/feeding_form_screen.dart';
import 'package:mobil_arici/features/harvest/presentation/harvest_form_screen.dart';
import 'package:mobil_arici/features/hives/data/hive_repository.dart';
import 'package:mobil_arici/features/hives/domain/hive.dart';
import 'package:mobil_arici/features/hives/presentation/hive_card_screen.dart';
import 'package:mobil_arici/features/inspections/presentation/inspection_sheet.dart';

import '../../helpers/fake_auth_service.dart';
import '../../helpers/fake_organization_service.dart';
import '../../helpers/test_database.dart';

void main() {
  late AppDatabase db;

  setUp(() => db = openTestDatabase());

  Future<ProviderContainer> open(WidgetTester tester) async {
    final container = ProviderContainer.test(overrides: signedIn(db: db));
    await tester.pumpWidget(
      UncontrolledProviderScope(container: container, child: const App()),
    );
    await tester.pumpAndSettle();
    return container;
  }

  /// [name] arılığı ve içinde [numbers] numaralı aktif kovanlar.
  Future<String> seedApiary(String name, List<String> numbers) async {
    final apiary = await ApiaryRepository(db)
        .create(orgId: testOrganization.id, name: name);
    for (final number in numbers) {
      await HiveRepository(db).create(
        orgId: testOrganization.id,
        apiaryId: apiary.id,
        number: number,
        type: HiveType.langstroth,
      );
    }
    return apiary.id;
  }

  Finder scanButton() => find.descendant(
    of: find.byType(AppNavigationBar),
    matching: find.byWidgetPredicate(
      (widget) => widget is Icon && widget.semanticLabel == 'Scan',
    ),
  );

  Future<void> tapText(WidgetTester tester, String text) async {
    final target = find.text(text).last;
    await tester.ensureVisible(target);
    await tester.pumpAndSettle();
    await tester.tap(target);
    await tester.pumpAndSettle();
  }

  Future<void> openMenu(WidgetTester tester) async {
    await tester.longPress(scanButton());
    await tester.pumpAndSettle();
    expect(find.byType(QuickRecordSheet), findsOneWidget);
  }

  testWidgets('besleme: arılık, sonra kovan seçilir; besleme formu açılır', (
    tester,
  ) async {
    await seedApiary('Yayla', ['2', '10']);
    await seedApiary('Ova', ['1']);
    await open(tester);

    await openMenu(tester);
    await tapText(tester, 'Feeding');
    expect(find.text('Choose apiary'), findsOneWidget);
    await tapText(tester, 'Yayla');

    expect(find.text('Choose hive'), findsOneWidget);
    expect(find.text('Whole apiary · 2'), findsOneWidget);
    // Numara sırasıyla: 2, 10.
    expect(
      tester.getTopLeft(find.text('Hive 2')).dy,
      lessThan(tester.getTopLeft(find.text('Hive 10')).dy),
    );
    await tapText(tester, 'Hive 10');

    expect(find.byType(FeedingFormScreen), findsOneWidget);
    expect(
      tester
          .widget<FeedingFormScreen>(find.byType(FeedingFormScreen))
          .wholeApiary,
      isFalse,
    );
  });

  testWidgets('arılığın tümü seçilirse form arılık kapsamında açılır', (
    tester,
  ) async {
    await seedApiary('Yayla', ['1', '2']);
    await open(tester);

    await openMenu(tester);
    await tapText(tester, 'Feeding');
    // Tek arılık: arılık sorulmaz.
    expect(find.text('Choose apiary'), findsNothing);
    await tapText(tester, 'Whole apiary · 2');

    expect(
      tester
          .widget<FeedingFormScreen>(find.byType(FeedingFormScreen))
          .wholeApiary,
      isTrue,
    );
  });

  testWidgets('muayene kovanın muayenesini, not kovan kartını, hasat '
      'arılığın hasadını açar', (tester) async {
    await seedApiary('Yayla', ['7']);
    final container = await open(tester);
    Future<void> backToToday() async {
      container.read(routerProvider).go(AppRoutes.today);
      await tester.pumpAndSettle();
    }

    await openMenu(tester);
    await tapText(tester, 'Inspection');
    await tapText(tester, 'Hive 7');
    expect(find.byType(InspectionSheet), findsOneWidget);

    await backToToday();
    await openMenu(tester);
    await tapText(tester, 'Note');
    await tapText(tester, 'Hive 7');
    expect(find.byType(HiveCardScreen), findsOneWidget);
    expect(find.byType(InspectionSheet), findsNothing);

    await backToToday();
    await openMenu(tester);
    await tapText(tester, 'Harvest');
    expect(find.byType(HarvestFormScreen), findsOneWidget);
  });

  testWidgets('arılık yoksa ya da arılıkta aktif kovan yoksa nedeni '
      'söylenir', (tester) async {
    await open(tester);

    await openMenu(tester);
    await tapText(tester, 'Treatment');
    expect(find.text('Add an apiary first to record.'), findsOneWidget);

    await seedApiary('Boş', []);
    await tester.pumpAndSettle();
    await openMenu(tester);
    await tapText(tester, 'Treatment');
    expect(find.text('This apiary has no active hives.'), findsOneWidget);
  });

  testWidgets('yukarı kaydırmak da menüyü açar', (tester) async {
    await open(tester);

    await tester.fling(scanButton(), const Offset(0, -80), 800);
    await tester.pumpAndSettle();

    expect(find.byType(QuickRecordSheet), findsOneWidget);
    expect(find.byType(ScanScreen), findsNothing);
  });

  testWidgets('eldivenle: Okut ekranındaki büyük butondan uzun basmadan '
      'açılır; 360dp ve 1.5x yazıda taşmaz', (tester) async {
    tester.view
      ..physicalSize = const Size(360, 640)
      ..devicePixelRatio = 1;
    tester.platformDispatcher
      ..localesTestValue = const [Locale('tr')]
      ..textScaleFactorTestValue = 1.5;
    addTearDown(tester.view.reset);
    addTearDown(tester.platformDispatcher.clearAllTestValues);
    await seedApiary('Yayla', ['3']);
    final container = await open(tester);
    container.read(appearanceProvider.notifier).setGloveMode(enabled: true);
    await tester.pumpAndSettle();

    await tester.tap(
      find.descendant(
        of: find.byType(AppNavigationBar),
        matching: find.byWidgetPredicate(
          (widget) => widget is Icon && widget.semanticLabel == 'Okut',
        ),
      ),
    );
    await tester.pumpAndSettle();
    expect(find.byType(ScanScreen), findsOneWidget);

    final button = find.widgetWithText(BigButton, 'Hızlı kayıt');
    await tester.ensureVisible(button);
    await tester.pumpAndSettle();
    expect(
      tester.getSize(button).height,
      greaterThanOrEqualTo(AppTouchTargets.glove.button),
    );
    await tester.tap(button);
    await tester.pumpAndSettle();
    expect(find.byType(QuickRecordSheet), findsOneWidget);
    expect(tester.takeException(), isNull);

    await tapText(tester, 'Muayene');
    await tapText(tester, 'Kovan 3');
    expect(find.byType(InspectionSheet), findsOneWidget);
    expect(tester.takeException(), isNull);
  });
}
