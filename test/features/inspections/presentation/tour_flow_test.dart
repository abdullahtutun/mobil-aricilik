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
import 'package:mobil_arici/features/apiaries/presentation/apiary_detail_screen.dart';
import 'package:mobil_arici/features/hives/data/hive_repository.dart';
import 'package:mobil_arici/features/hives/domain/hive.dart';
import 'package:mobil_arici/features/inspections/data/inspection_repository.dart';
import 'package:mobil_arici/features/inspections/data/tour_repository.dart';
import 'package:mobil_arici/features/inspections/domain/apiary_tour.dart';
import 'package:mobil_arici/features/inspections/domain/inspection.dart';
import 'package:mobil_arici/features/inspections/presentation/inspection_sheet.dart';
import 'package:mobil_arici/features/inspections/presentation/tour_screen.dart';
import 'package:mobil_arici/features/inspections/presentation/tour_summary_screen.dart';
import 'package:mobil_arici/features/tasks/data/task_repository.dart';
import 'package:mobil_arici/features/tasks/domain/task.dart';

import '../../../helpers/fake_auth_service.dart';
import '../../../helpers/fake_organization_service.dart';
import '../../../helpers/fake_screen_awake.dart';
import '../../../helpers/test_database.dart';

final String _orgId = testOrganization.id;

Future<ProviderContainer> _open(
  WidgetTester tester, {
  required AppDatabase db,
  required String location,
  FakeScreenAwake? screenAwake,
}) async {
  final container = ProviderContainer.test(
    overrides: signedIn(db: db, screenAwake: screenAwake),
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

String _location(ProviderContainer container) =>
    container.read(routerProvider).routerDelegate.currentConfiguration.uri.path;

Finder _button(String label) => find.widgetWithText(BigButton, label);

Finder _countTile(String label) => find.byWidgetPredicate(
  (widget) => widget is CountTile && widget.label == label,
);

void main() {
  late AppDatabase db;
  late TourRepository tours;
  late Apiary apiary;
  late List<Hive> hives;
  late FakeScreenAwake screenAwake;

  setUp(() async {
    db = openTestDatabase();
    tours = TourRepository(db);
    screenAwake = FakeScreenAwake();
    apiary = await ApiaryRepository(db).create(orgId: _orgId, name: 'Kızılçam');
    final repository = HiveRepository(db);
    hives = [
      for (final number in ['101', '102', '103', '104'])
        await repository.create(
          orgId: _orgId,
          number: number,
          type: HiveType.langstroth,
          apiaryId: apiary.id,
        ),
    ];
    // Sönmüş kovan tura alınmaz.
    await repository.setStatus(hives[3].id, HiveStatus.dead);
  });

  Future<ProviderContainer> open(WidgetTester tester, String location) =>
      _open(tester, db: db, location: location, screenAwake: screenAwake);

  Future<ProviderContainer> startTour(WidgetTester tester) async {
    final container = await open(tester, AppRoutes.apiary(apiary.id));
    await _tap(tester, _button('Start tour'));
    return container;
  }

  /// Turdaki muayeneyi değiştirmeden kaydeder.
  Future<void> save(WidgetTester tester) =>
      _tap(tester, find.widgetWithText(BigButton, 'Save'));

  /// [hive]'ın muayenesi; değerler soru işaretli bırakılabilir.
  Future<Inspection> inspect(Hive hive, InspectionValues values) =>
      InspectionRepository(db).add(
        orgId: _orgId,
        hiveId: hive.id,
        apiaryId: apiary.id,
        values: values,
      );

  testWidgets('Tur başlat: ilerleme, sıradaki ve sıra; ekran açık kalır, '
      'çıkınca kapanır; geri dönünce Tura devam et', (tester) async {
    final container = await startTour(tester);

    expect(find.byType(TourScreen), findsOneWidget);
    expect(_location(container), AppRoutes.apiaryTour(apiary.id));
    expect(find.text('Kızılçam tour'), findsOneWidget);
    expect(find.text('0 / 3'), findsOneWidget);
    expect(find.bySemanticsLabel('0 of 3 hives done'), findsOneWidget);
    expect(_button('Inspect 101'), findsOneWidget);
    expect(find.text('First inspection'), findsOneWidget);
    expect(find.bySemanticsLabel('Hive 101, Next'), findsOneWidget);
    expect(find.bySemanticsLabel('Hive 102, Waiting'), findsOneWidget);
    expect(find.bySemanticsLabel(RegExp('Hive 104')), findsNothing);
    expect(screenAwake.keptOn, isTrue);
    final tour = (await tours.readTour())!;
    expect(tour.apiaryId, apiary.id);
    expect(tour.hiveIds, [hives[0].id, hives[1].id, hives[2].id]);

    await _tap(tester, find.byTooltip('Back'));

    expect(find.byType(ApiaryDetailScreen), findsOneWidget);
    expect(screenAwake.keptOn, isFalse);
    expect(_button('Resume tour'), findsOneWidget);

    await _tap(tester, _button('Resume tour'));
    expect(find.byType(TourScreen), findsOneWidget);
    expect(await tours.readTour(), tour);
  });

  testWidgets('Kaydet turu ilerletir ve sıradakinin muayenesini açar; '
      'önceki kaydın Geri al’ı onun en üstünde; kovanı bekleyene döndürür', (
    tester,
  ) async {
    final container = await startTour(tester);

    await _tap(tester, _button('Inspect 101'));
    expect(find.byType(InspectionSheet), findsOneWidget);
    expect(find.bySemanticsLabel('Inspect hive 101'), findsOneWidget);

    await save(tester);

    expect(
      _location(container),
      AppRoutes.apiaryTourInspect(apiary.id, hives[1].id),
    );
    expect(find.bySemanticsLabel('Inspect hive 102'), findsOneWidget);
    expect(find.text('Hive 101 inspection saved'), findsOneWidget);
    var tour = (await tours.readTour())!;
    expect(tour.inspections.keys, [hives[0].id]);

    await _tap(tester, find.text('Undo'));

    tour = (await tours.readTour())!;
    expect(tour.inspections, isEmpty);
    expect(await InspectionRepository(db).latestByHive(hives[0].id), isNull);

    await _tap(tester, find.byTooltip('Close'));
    expect(find.byType(TourScreen), findsOneWidget);
    expect(_button('Inspect 101'), findsOneWidget);
    expect(find.text('0 / 3'), findsOneWidget);
  });

  testWidgets('Atla: atlanan sırada kalır, en sona gelir; hepsi bitince '
      'tura dönülür', (tester) async {
    final container = await startTour(tester);

    await _tap(tester, _button('Skip'));

    expect(_button('Inspect 102'), findsOneWidget);
    expect(find.text('1 skipped'), findsOneWidget);
    expect(find.bySemanticsLabel('Hive 101, Skipped'), findsOneWidget);

    await _tap(tester, _button('Inspect 102'));
    await save(tester);
    expect(
      _location(container),
      AppRoutes.apiaryTourInspect(apiary.id, hives[2].id),
    );
    await save(tester);
    // Bekleyen kalmadı: atlanan gelir.
    expect(
      _location(container),
      AppRoutes.apiaryTourInspect(apiary.id, hives[0].id),
    );
    await save(tester);

    expect(_location(container), AppRoutes.apiaryTour(apiary.id));
    expect(find.text('3 / 3'), findsOneWidget);
    expect(find.text('Every hive has been inspected.'), findsOneWidget);
    expect(find.text('Hive 101 inspection saved'), findsOneWidget);
    expect(find.bySemanticsLabel('Hive 101, Done'), findsOneWidget);
    expect(_button('Finish tour'), findsOneWidget);
  });

  testWidgets('Sıradan bir kovana dokununca onun muayenesi açılır; biten '
      'kovana dokunulmaz', (tester) async {
    await tours.saveTour(
      ApiaryTour(
        orgId: _orgId,
        apiaryId: apiary.id,
        startedAt: DateTime.now().toUtc(),
        hiveIds: [hives[0].id, hives[1].id, hives[2].id],
        inspections: {hives[0].id: 'x'},
      ),
    );
    final container = await open(tester, AppRoutes.apiaryTour(apiary.id));

    await _tap(tester, find.bySemanticsLabel('Hive 101, Done'));
    expect(_location(container), AppRoutes.apiaryTour(apiary.id));

    await _tap(tester, find.bySemanticsLabel('Hive 103, Waiting'));
    expect(
      _location(container),
      AppRoutes.apiaryTourInspect(apiary.id, hives[2].id),
    );
  });

  group('tur sonu', () {
    late Inspection queenless;
    late Inspection swarming;

    Future<void> seedTour() async {
      queenless = await inspect(
        hives[0],
        const InspectionValues(queenState: QueenState.none, beeFrames: 3),
      );
      swarming = await inspect(
        hives[1],
        const InspectionValues(beeFrames: 9, queenCells: QueenCells.swarm),
      );
      await TaskRepository(db).remindAfterInspection(queenless, 7);
      await tours.saveTour(
        ApiaryTour(
          orgId: _orgId,
          apiaryId: apiary.id,
          startedAt: DateTime.now().toUtc().subtract(
            const Duration(minutes: 38),
          ),
          hiveIds: [hives[0].id, hives[1].id, hives[2].id],
          inspections: {hives[0].id: queenless.id, hives[1].id: swarming.id},
        ),
      );
    }

    /// Açık turda "Turu bitir" ve onay.
    Future<void> finish(WidgetTester tester) async {
      await _tap(tester, find.widgetWithText(TextButton, 'Finish tour'));
      expect(find.text('Finish the tour?'), findsOneWidget);
      expect(
        find.text(
          "1 hive hasn't been inspected; the summary counts it as skipped.",
        ),
        findsOneWidget,
      );
      await _tap(
        tester,
        find.descendant(
          of: find.byType(AlertDialog),
          matching: find.text('Finish tour'),
        ),
      );
    }

    testWidgets('bakılmayan varsa onay; özet sayıları, önerilen ve turda '
        'açılan görevler; işaretliler kaydedilir, tur kapanır', (tester) async {
      await seedTour();
      final container = await open(tester, AppRoutes.apiaryTour(apiary.id));
      expect(find.text('2 / 3'), findsOneWidget);
      expect(find.bySemanticsLabel('Time elapsed: 38 min'), findsOneWidget);

      await finish(tester);

      expect(find.byType(TourSummaryScreen), findsOneWidget);
      expect(_location(container), AppRoutes.apiaryTourSummary(apiary.id));
      expect(find.text('Tour complete'), findsOneWidget);
      expect(
        find.text('Kızılçam · 2 hives inspected · 1 skipped · 38 min'),
        findsOneWidget,
      );
      CountTile tile(String label) =>
          tester.widget<CountTile>(_countTile(label));
      expect(tile('Queenless').count, 1);
      expect(tile('Queenless').status, AppStatus.critical);
      expect(tile('Weak').count, 1);
      expect(tile('Swarm signs').count, 1);
      expect(tile('Strong / fair').count, 0);
      expect(tile('Strong / fair').status, isNull);
      for (final text in [
        'Requeen: 101',
        'Feed 1:1 syrup: 101',
        'Swarm check: 102',
        'Check skipped hives: 103',
        'Hive 101 · check again',
      ]) {
        expect(find.text(text), findsOneWidget, reason: text);
      }
      expect(find.text('tomorrow'), findsNWidgets(2));
      expect(find.text('in 3 days'), findsOneWidget);
      expect(find.text('in 7 days'), findsNWidgets(2));

      await _tap(tester, find.text('Feed 1:1 syrup: 101'));
      await _tap(tester, _button('Save tasks'));

      expect(_location(container), AppRoutes.apiary(apiary.id));
      expect(find.text('3 tasks saved'), findsOneWidget);
      expect(await tours.readTour(), isNull);
      final tasks = await (db.select(
        db.tasks,
      )..where((t) => t.source.equalsValue(TaskSource.manual))).get();
      expect(
        {for (final t in tasks) t.title},
        {'Requeen: 101', 'Swarm check: 102', 'Check skipped hives: 103'},
      );
      for (final task in tasks) {
        expect(task.apiaryId, apiary.id);
        expect(task.assignedTo, testUser.id);
      }
      expect(
        tasks.firstWhere((t) => t.title == 'Requeen: 101').hiveId,
        hives[0].id,
      );
      expect(_button('Start tour'), findsOneWidget);
    });

    testWidgets('geri tuşu özetten görev yazmadan çıkar ve turu kapatır', (
      tester,
    ) async {
      await seedTour();
      await open(tester, AppRoutes.apiaryTour(apiary.id));
      await finish(tester);

      await _tap(tester, find.byTooltip('Back'));

      expect(find.byType(ApiaryDetailScreen), findsOneWidget);
      expect(await tours.readTour(), isNull);
      final manual = await (db.select(
        db.tasks,
      )..where((t) => t.source.equalsValue(TaskSource.manual))).get();
      expect(manual, isEmpty);
    });

    testWidgets('öneri yoksa buton Kapat', (tester) async {
      await tours.saveTour(
        ApiaryTour(
          orgId: _orgId,
          apiaryId: apiary.id,
          startedAt: DateTime.now().toUtc(),
          hiveIds: [hives[0].id],
          inspections: {
            hives[0].id: (await inspect(
              hives[0],
              const InspectionValues(beeFrames: 8),
            )).id,
          },
        ),
      );
      await open(tester, AppRoutes.apiaryTour(apiary.id));
      await _tap(tester, _button('Finish tour'));

      expect(find.text('No tasks to suggest.'), findsOneWidget);
      expect(tester.widget<CountTile>(_countTile('Strong / fair')).count, 1);
      await _tap(tester, _button('Close'));

      expect(find.byType(ApiaryDetailScreen), findsOneWidget);
      expect(await tours.readTour(), isNull);
    });
  });

  testWidgets('güneş modu önerilir; açılınca öneri kalkar, tur kapanınca '
      'eski moda döner', (tester) async {
    final container = await startTour(tester);

    expect(
      find.text('Sun mode makes the screen easier to read in bright light.'),
      findsOneWidget,
    );
    await _tap(tester, find.text('Turn on sun mode'));

    expect(container.read(appearanceProvider).colorMode, AppColorMode.sun);
    expect(find.text('Turn on sun mode'), findsNothing);
    final toggle = tester.widget<IconButton>(
      find.widgetWithIcon(IconButton, Icons.wb_sunny_rounded),
    );
    expect(toggle.isSelected, isTrue);

    await _tap(tester, find.widgetWithText(TextButton, 'Finish tour'));
    await _tap(
      tester,
      find.descendant(
        of: find.byType(AlertDialog),
        matching: find.text('Finish tour'),
      ),
    );
    await _tap(tester, _button('Save task'));

    expect(container.read(appearanceProvider).colorMode, AppColorMode.system);
  });

  testWidgets('başka arılığın turu sürerken onay ister; vazgeçilirse eski '
      'tur kalır', (tester) async {
    final other = await ApiaryRepository(db)
        .create(orgId: _orgId, name: 'Yayla');
    final running = ApiaryTour(
      orgId: _orgId,
      apiaryId: other.id,
      startedAt: DateTime.now().toUtc(),
      hiveIds: const [],
    );
    await tours.saveTour(running);
    await open(tester, AppRoutes.apiary(apiary.id));

    await _tap(tester, _button('Start tour'));
    expect(find.text('End the current tour?'), findsOneWidget);
    await _tap(tester, find.text('Cancel'));
    expect(await tours.readTour(), running);

    await _tap(tester, _button('Start tour'));
    await _tap(tester, find.text('Start new tour'));
    expect(find.byType(TourScreen), findsOneWidget);
    expect((await tours.readTour())!.apiaryId, apiary.id);
  });

  testWidgets('süren tur yoksa tur ekranı bunu söyler', (tester) async {
    await open(tester, AppRoutes.apiaryTour(apiary.id));

    expect(find.text("There's no tour running in this apiary."), findsOne);
  });

  testWidgets('Türkçe metinler', (tester) async {
    final container = await open(tester, AppRoutes.apiary(apiary.id));
    container.read(languageProvider.notifier).language = AppLanguage.turkish;
    await tester.pumpAndSettle();

    await _tap(tester, _button('Tur başlat'));

    for (final text in [
      'Kızılçam turu',
      'SIRADAKİ',
      'Sıra',
      'Bitti',
      'Atlandı',
      'Bekliyor',
      'Güneş modunu aç',
      'Turu bitir',
    ]) {
      expect(find.text(text), findsWidgets, reason: text);
    }
    expect(_button('Atla'), findsOneWidget);
    expect(_button('Muayene et · 101'), findsOneWidget);
    expect(find.bySemanticsLabel('3 kovandan 0 tanesi bitti'), findsOne);

    await _tap(tester, find.widgetWithText(TextButton, 'Turu bitir'));
    expect(find.text('Tur bitsin mi?'), findsOneWidget);
    await _tap(
      tester,
      find.descendant(
        of: find.byType(AlertDialog),
        matching: find.text('Turu bitir'),
      ),
    );

    for (final text in [
      'Tur tamamlandı',
      'Anasız',
      'Zayıf',
      'Oğul eğilimli',
      'Güçlü / orta',
      'Oluşan görevler',
      'Atlanan kovanlara bak: 101, 102, 103',
      'yarın',
    ]) {
      expect(find.text(text), findsOneWidget, reason: text);
    }
    expect(find.textContaining('0 kovan muayene · 3 atlandı'), findsOne);
    expect(_button('Görevleri kaydet'), findsOneWidget);
  });

  testWidgets('360dp ekranda 1.5x yazı ve eldivenle tur, muayene ve özet '
      'taşmaz', (tester) async {
    tester.view
      ..physicalSize = const Size(360, 640)
      ..devicePixelRatio = 1;
    tester.platformDispatcher.textScaleFactorTestValue = 1.5;
    addTearDown(tester.view.reset);
    addTearDown(tester.platformDispatcher.clearTextScaleFactorTestValue);

    final container = await open(tester, AppRoutes.apiary(apiary.id));
    container.read(appearanceProvider.notifier).setGloveMode(enabled: true);
    await tester.pumpAndSettle();

    await _tap(tester, _button('Start tour'));
    expect(tester.takeException(), isNull);

    await _tap(tester, _button('Skip'));
    expect(tester.takeException(), isNull);

    await _tap(tester, _button('Inspect 102'));
    await save(tester);
    expect(find.text('Hive 102 inspection saved'), findsOneWidget);
    expect(tester.takeException(), isNull);

    await _tap(tester, find.byTooltip('Close'));
    await _tap(tester, find.widgetWithText(TextButton, 'Finish tour'));
    await _tap(
      tester,
      find.descendant(
        of: find.byType(AlertDialog),
        matching: find.text('Finish tour'),
      ),
    );
    expect(find.byType(TourSummaryScreen), findsOneWidget);
    expect(tester.takeException(), isNull);
  });
}
