import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mobil_arici/app/app.dart';
import 'package:mobil_arici/app/router.dart';
import 'package:mobil_arici/app/routes.dart';
import 'package:mobil_arici/core/db/app_database.dart';
import 'package:mobil_arici/core/db/local_settings_repository.dart';
import 'package:mobil_arici/core/design_system/design_system.dart';
import 'package:mobil_arici/core/l10n/app_language.dart';
import 'package:mobil_arici/core/l10n/language_provider.dart';
import 'package:mobil_arici/features/apiaries/data/apiary_repository.dart';
import 'package:mobil_arici/features/apiaries/domain/apiary.dart';
import 'package:mobil_arici/features/health/data/mite_count_repository.dart';
import 'package:mobil_arici/features/health/domain/mite_count.dart';
import 'package:mobil_arici/features/health/presentation/varroa_form_screen.dart';
import 'package:mobil_arici/features/health/presentation/widgets/varroa_chart.dart';
import 'package:mobil_arici/features/hives/data/hive_repository.dart';
import 'package:mobil_arici/features/hives/domain/hive.dart';
import 'package:mobil_arici/features/hives/presentation/hive_card_screen.dart';

import '../../../helpers/fake_auth_service.dart';
import '../../../helpers/fake_organization_service.dart';
import '../../../helpers/test_database.dart';

final String _orgId = testOrganization.id;

Future<ProviderContainer> _open(
  WidgetTester tester, {
  required AppDatabase db,
  required String location,
}) async {
  final container = ProviderContainer.test(overrides: signedIn(db: db));
  await tester.pumpWidget(
    UncontrolledProviderScope(container: container, child: const App()),
  );
  await tester.pumpAndSettle();
  container.read(routerProvider).go(location);
  await tester.pumpAndSettle();
  return container;
}

Future<void> _tap(WidgetTester tester, Finder finder) async {
  // Uzun kovan kartında henüz kurulmamış olabilir.
  if (finder.evaluate().isEmpty) await tester.scrollUntilVisible(finder, 200);
  await tester.ensureVisible(finder);
  await tester.pumpAndSettle();
  await tester.tap(finder);
  await tester.pumpAndSettle();
}

/// Adı [label] olan sayacın [tooltip] butonuna [times] kez dokunur.
Future<void> _step(
  WidgetTester tester,
  String label,
  String tooltip, {
  int times = 1,
}) async {
  final button = find.descendant(
    of: find.widgetWithText(BigStepper, label),
    matching: find.byTooltip(tooltip),
  );
  await tester.ensureVisible(button);
  await tester.pumpAndSettle();
  for (var i = 0; i < times; i++) {
    await tester.tap(button);
    await tester.pump();
  }
  await tester.pumpAndSettle();
}

BigStepper _stepper(WidgetTester tester, String label) =>
    tester.widget<BigStepper>(find.widgetWithText(BigStepper, label));

/// Açık seçim sayfasındaki [text]; sayfa generic, `byType` tam tipi arar.
Finder _inSheet(String text) => find.descendant(
  of: find.byWidgetPredicate((widget) => widget is OptionSheet),
  matching: find.text(text),
);

/// Kovan kartındaki varroa karosu.
Finder _varroaTile() =>
    find.ancestor(of: find.text('VARROA'), matching: find.byType(SummaryTile));

void main() {
  late AppDatabase db;
  late HiveRepository hives;
  late MiteCountRepository counts;
  late Apiary yayla;
  late Hive hive;

  setUp(() async {
    db = openTestDatabase();
    hives = HiveRepository(db);
    counts = MiteCountRepository(db);
    yayla = await ApiaryRepository(db).create(orgId: _orgId, name: 'Yayla');
    hive = await hives.create(
      orgId: _orgId,
      number: '101',
      type: HiveType.langstroth,
      apiaryId: yayla.id,
    );
  });

  Future<MiteCount> addCount({
    int mites = 9,
    MiteCountMethod method = MiteCountMethod.sugarRoll,
    DateTime? at,
  }) => MiteCountRepository(db, clock: () => at ?? DateTime.now()).add(
    orgId: _orgId,
    hiveId: hive.id,
    apiaryId: yayla.id,
    method: method,
    mites: mites,
    sampleBees: 300,
    days: 3,
  );

  group('Ölçüm formu', () {
    testWidgets('karttan açılır; akar girilene kadar Kaydet kapalı; yüzde '
        'canlı hesaplanır ve eşikte uyarır; kayıt karta yazılır, Geri al '
        'siler', (tester) async {
      await _open(tester, db: db, location: AppRoutes.hive(yayla.id, hive.id));
      expect(
        find.descendant(of: _varroaTile(), matching: find.text('No count yet')),
        findsOneWidget,
      );

      await _tap(tester, find.byIcon(Icons.more_vert_rounded));
      await _tap(tester, find.text('Count varroa'));
      expect(find.byType(VarroaFormScreen), findsOneWidget);
      expect(find.text('Varroa · Hive 101'), findsOneWidget);
      // Yarım bardak ≈ 300 arı; akar boş, Kaydet kapalı.
      expect(_stepper(tester, 'Sample bees').value, 300);
      expect(_stepper(tester, 'Mites counted').value, isNull);
      expect(
        tester
            .widget<BigButton>(find.widgetWithText(BigButton, 'Save'))
            .onPressed,
        isNull,
      );

      await _step(tester, 'Mites counted', 'Increase', times: 8);
      expect(find.text('2.7%'), findsOneWidget);
      expect(find.text('Below threshold'), findsOneWidget);
      expect(find.text('Threshold 3.0% (from Settings).'), findsOneWidget);

      await _step(tester, 'Mites counted', 'Increase');
      // 9 / 300 = %3: eşiğe eşit sonuç da uyarır.
      expect(find.text('3.0%'), findsOneWidget);
      expect(find.text('At threshold · plan treatment'), findsOneWidget);
      expect(
        find.descendant(
          of: find.byType(AppCard),
          matching: find.byIcon(AppStatus.warning.icon),
        ),
        findsOneWidget,
      );

      await _tap(tester, find.widgetWithText(BigButton, 'Save'));
      expect(find.byType(HiveCardScreen), findsOneWidget);
      expect(find.text('Varroa count saved for hive 101'), findsOneWidget);
      expect(
        find.descendant(of: _varroaTile(), matching: find.text('3.0%')),
        findsOneWidget,
      );
      expect(
        find.descendant(
          of: _varroaTile(),
          matching: find.text('Threshold reached · Sugar roll · today'),
        ),
        findsOneWidget,
      );
      expect(
        tester.widget<SummaryTile>(_varroaTile()).status,
        AppStatus.warning,
      );
      final saved = (await tester.runAsync(
        () => counts.watchByHive(hive.id).first,
      ))!.single;
      expect(saved.method, MiteCountMethod.sugarRoll);
      expect(saved.sampleBees, 300);
      expect(saved.mites, 9);
      expect(saved.apiaryId, yayla.id);

      await _tap(tester, find.text('Undo'));
      // Uzun kartta liste aşağıda kalmış olabilir; karo yukarıda.
      await tester.scrollUntilVisible(find.text('VARROA'), -200);
      expect(
        find.descendant(of: _varroaTile(), matching: find.text('No count yet')),
        findsOneWidget,
      );
      expect(await counts.findById(saved.id), isNull);
    });

    testWidgets('alt tablada gün ve dökülen akar sorulur; sonuç günlük '
        'döküm, kendi eşiğiyle', (tester) async {
      await _open(
        tester,
        db: db,
        location: AppRoutes.hiveVarroa(yayla.id, hive.id),
      );

      await _tap(tester, find.text('Sticky board'));
      expect(find.widgetWithText(BigStepper, 'Sample bees'), findsNothing);
      expect(_stepper(tester, 'Days on board').value, 3);
      await _step(tester, 'Days on board', 'Decrease', times: 2);
      await _step(tester, 'Mites dropped', 'Increase', times: 9);

      expect(find.text('DAILY DROP'), findsOneWidget);
      expect(find.text('9'), findsWidgets);
      expect(find.text('Below threshold'), findsOneWidget);
      expect(
        find.text('Threshold 10.0 mites/day (from Settings).'),
        findsOneWidget,
      );

      await _step(tester, 'Mites dropped', 'Increase');
      expect(find.text('At threshold · plan treatment'), findsOneWidget);

      await _tap(tester, find.widgetWithText(BigButton, 'Save'));
      final saved = (await tester.runAsync(
        () => counts.watchByHive(hive.id).first,
      ))!.single;
      expect(saved.method, MiteCountMethod.stickyBoard);
      expect(saved.days, 1);
      expect(saved.sampleBees, isNull);
      expect(saved.mites, 10);
      expect(
        find.descendant(
          of: _varroaTile(),
          matching: find.text('10.0 mites/day'),
        ),
        findsOneWidget,
      );
    });
  });

  testWidgets('kovan kartı en son ölçümü gösterir; eşiğin altındaysa '
      'uyarısız', (tester) async {
    await addCount(
      mites: 30,
      at: DateTime.now().subtract(const Duration(days: 9)),
    );
    await addCount(
      mites: 3,
      method: MiteCountMethod.alcoholWash,
      at: DateTime.now().subtract(const Duration(days: 1)),
    );
    await _open(tester, db: db, location: AppRoutes.hive(yayla.id, hive.id));

    expect(
      find.descendant(of: _varroaTile(), matching: find.text('1.0%')),
      findsOneWidget,
    );
    expect(
      find.descendant(
        of: _varroaTile(),
        matching: find.text('Alcohol wash · yesterday'),
      ),
      findsOneWidget,
    );
    expect(tester.widget<SummaryTile>(_varroaTile()).status, isNull);
  });

  testWidgets('aktif olmayan kovanda ölçüm butonu yok', (tester) async {
    final sold = await hives.create(
      orgId: _orgId,
      number: '102',
      type: HiveType.langstroth,
      apiaryId: yayla.id,
      status: HiveStatus.sold,
    );
    await _open(tester, db: db, location: AppRoutes.hive(yayla.id, sold.id));

    expect(find.widgetWithText(BigButton, 'Count varroa'), findsNothing);
    expect(_varroaTile(), findsOneWidget);
  });

  group('Arılık grafiği', () {
    testWidgets('ölçüm yoksa nasıl ekleneceğini söyler', (tester) async {
      await _open(tester, db: db, location: AppRoutes.apiary(yayla.id));

      final empty = find.text(
        'No sugar roll or alcohol wash counts yet. Add one from a hive card.',
      );
      await tester.scrollUntilVisible(
        empty,
        200,
        scrollable: find.byType(Scrollable).first,
      );
      expect(find.byType(BarChart), findsNothing);
    });

    testWidgets('gün başına ortalama çubuklar ve eşik; yeni ölçümle '
        'güncellenir', (tester) async {
      await addCount(
        mites: 3,
        at: DateTime.now().subtract(const Duration(days: 2)),
      );
      await addCount(
        method: MiteCountMethod.stickyBoard,
        at: DateTime.now().subtract(const Duration(days: 1)),
      );
      await _open(tester, db: db, location: AppRoutes.apiary(yayla.id));

      final chart = find.byType(VarroaBarChart);
      await tester.scrollUntilVisible(
        chart,
        200,
        scrollable: find.byType(Scrollable).first,
      );
      expect(find.text('Varroa · recent counts'), findsOneWidget);
      // Alt tabla günü çubuk değil.
      expect(tester.widget<VarroaBarChart>(chart).bars, hasLength(1));
      expect(tester.widget<VarroaBarChart>(chart).threshold, 3);

      await tester.runAsync(addCount);
      await tester.pumpAndSettle();
      final bars = tester.widget<VarroaBarChart>(chart).bars;
      expect(bars.map((bar) => bar.percent), [1, 3]);
      expect(
        find.bySemanticsLabel(
          RegExp(r'threshold 3\.0%: .*1\.0%, today: 3\.0% · Threshold reached'),
        ),
        findsOneWidget,
      );
    });
  });

  testWidgets('eşikler ayarlardan seçilir, bu telefona yazılır; kart ve form '
      'yeni eşiğe göre uyarır', (tester) async {
    await addCount(mites: 7);
    final container = await _open(tester, db: db, location: AppRoutes.settings);

    final percentRow = find.widgetWithText(ListRow, 'Infestation threshold');
    await tester.scrollUntilVisible(percentRow, 200);
    expect(
      find.descendant(of: percentRow, matching: find.text('3.0%')),
      findsOneWidget,
    );
    await _tap(tester, percentRow);
    await _tap(tester, _inSheet('2.0%'));
    expect(
      find.descendant(of: percentRow, matching: find.text('2.0%')),
      findsOneWidget,
    );

    final perDayRow = find.widgetWithText(ListRow, 'Sticky board threshold');
    await _tap(tester, perDayRow);
    await _tap(tester, _inSheet('20.0 mites/day'));
    expect(
      find.descendant(of: perDayRow, matching: find.text('20.0 mites/day')),
      findsOneWidget,
    );

    final settings = LocalSettingsRepository(db);
    expect(
      await tester.runAsync(() => settings.watchVarroaThresholds().first),
      (percent: 2.0, perDay: 20.0),
    );

    // 7 / 300 = %2,3: yeni eşikte uyarır.
    container.read(routerProvider).go(AppRoutes.hive(yayla.id, hive.id));
    await tester.pumpAndSettle();
    expect(tester.widget<SummaryTile>(_varroaTile()).status, AppStatus.warning);
  });

  testWidgets('Türkçe metinler', (tester) async {
    final container = await _open(
      tester,
      db: db,
      location: AppRoutes.hive(yayla.id, hive.id),
    );
    container.read(languageProvider.notifier).language = AppLanguage.turkish;
    await tester.pumpAndSettle();

    expect(find.text('Ölçüm yok'), findsOneWidget);
    await _tap(tester, find.byIcon(Icons.more_vert_rounded));
    await _tap(tester, find.text('Varroa ölç'));
    expect(find.text('Varroa · Kovan 101'), findsOneWidget);
    expect(find.text('YÖNTEM'), findsOneWidget);
    expect(find.text('Pudra şekeri'), findsOneWidget);
    expect(find.text('Alkol'), findsOneWidget);
    expect(find.text('Alt tabla'), findsOneWidget);
    expect(find.text('Yayla · son ölçümler'), findsOneWidget);
    await _step(tester, 'Sayılan akar', 'Artır', times: 9);
    expect(find.text('%3,0'), findsOneWidget);
    expect(find.text('BULAŞIKLIK'), findsOneWidget);
    expect(find.text('Eşikte · mücadele planla'), findsOneWidget);
    expect(find.text("Eşik %3,0 (Ayarlar'dan)."), findsOneWidget);

    await _tap(tester, find.text('Alt tabla'));
    expect(find.widgetWithText(BigStepper, 'Tablada gün'), findsOneWidget);
    expect(find.text('GÜNLÜK DÖKÜM'), findsOneWidget);

    await _tap(tester, find.widgetWithText(BigButton, 'Kaydet'));
    expect(find.text('Kovan 101 varroa ölçümü kaydedildi'), findsOneWidget);
    expect(find.text('Günde 3,0 akar'), findsOneWidget);

    container.read(routerProvider).go(AppRoutes.settings);
    await tester.pumpAndSettle();
    await tester.scrollUntilVisible(find.text('Bulaşıklık eşiği'), 200);
    expect(find.text('Alt tabla eşiği'), findsOneWidget);
    expect(find.text('Günde 10,0 akar'), findsOneWidget);
  });

  testWidgets('360dp ekranda 1.5x yazı ve eldivenle taşmaz', (tester) async {
    tester.view
      ..physicalSize = const Size(360, 640)
      ..devicePixelRatio = 1;
    tester.platformDispatcher.textScaleFactorTestValue = 1.5;
    addTearDown(tester.view.reset);
    addTearDown(tester.platformDispatcher.clearTextScaleFactorTestValue);
    await addCount(
      mites: 4,
      at: DateTime.now().subtract(const Duration(days: 20)),
    );
    await addCount(mites: 12, method: MiteCountMethod.stickyBoard);

    final container = await _open(
      tester,
      db: db,
      location: AppRoutes.hive(yayla.id, hive.id),
    );
    container.read(appearanceProvider.notifier).setGloveMode(enabled: true);
    await tester.pumpAndSettle();
    expect(tester.takeException(), isNull);

    final router = container.read(routerProvider)
      ..go(AppRoutes.hiveVarroa(yayla.id, hive.id));
    await tester.pumpAndSettle();
    await _step(tester, 'Mites counted', 'Increase', times: 12);
    expect(tester.takeException(), isNull);
    await tester.scrollUntilVisible(
      find.byType(VarroaBarChart),
      200,
      scrollable: find.byType(Scrollable).first,
    );
    expect(tester.takeException(), isNull);

    router.go(AppRoutes.apiary(yayla.id));
    await tester.pumpAndSettle();
    await tester.scrollUntilVisible(
      find.byType(VarroaBarChart),
      200,
      scrollable: find.byType(Scrollable).first,
    );
    expect(tester.takeException(), isNull);

    router.go(AppRoutes.settings);
    await tester.pumpAndSettle();
    await tester.scrollUntilVisible(find.text('Sticky board threshold'), 200);
    expect(tester.takeException(), isNull);
  });
}
