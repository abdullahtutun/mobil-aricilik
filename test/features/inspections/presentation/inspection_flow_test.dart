import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mobil_arici/app/app.dart';
import 'package:mobil_arici/app/router.dart';
import 'package:mobil_arici/app/routes.dart';
import 'package:mobil_arici/app/shell/app_navigation_bar.dart';
import 'package:mobil_arici/core/db/app_database.dart';
import 'package:mobil_arici/core/design_system/design_system.dart';
import 'package:mobil_arici/core/l10n/app_language.dart';
import 'package:mobil_arici/core/l10n/language_provider.dart';
import 'package:mobil_arici/features/apiaries/data/apiary_repository.dart';
import 'package:mobil_arici/features/apiaries/domain/apiary.dart';
import 'package:mobil_arici/features/hives/data/hive_repository.dart';
import 'package:mobil_arici/features/hives/domain/hive.dart';
import 'package:mobil_arici/features/hives/domain/hive_label_code.dart';
import 'package:mobil_arici/features/hives/presentation/hive_card_screen.dart';
import 'package:mobil_arici/features/inspections/data/inspection_draft_repository.dart';
import 'package:mobil_arici/features/inspections/data/inspection_repository.dart';
import 'package:mobil_arici/features/inspections/domain/inspection.dart';
import 'package:mobil_arici/features/inspections/domain/inspection_draft.dart';
import 'package:mobil_arici/features/inspections/domain/inspection_rules.dart';
import 'package:mobil_arici/features/inspections/presentation/inspection_sheet.dart';
import 'package:mobil_arici/features/tasks/data/task_repository.dart';
import 'package:mobil_arici/features/tasks/domain/task.dart';

import '../../../helpers/fake_auth_service.dart';
import '../../../helpers/fake_code_scanner.dart';
import '../../../helpers/fake_organization_service.dart';
import '../../../helpers/test_database.dart';

final String _orgId = testOrganization.id;

/// Önceki muayene: 22 Eki 2026.
const _previous = InspectionValues(
  queenState: QueenState.seen,
  beeFrames: 8,
  broodFrames: 5,
  honeyFrames: 2,
  temperament: Temperament.calm,
  swarmSigns: false,
  queenCells: QueenCells.none,
  diseaseSuspected: false,
  actions: {InspectionAction.fed},
);

/// Uygulamayı açar ve [location]'a gider; titreşimler [haptics]'e yazılır.
Future<ProviderContainer> _open(
  WidgetTester tester, {
  required AppDatabase db,
  required String location,
  List<String>? haptics,
  FakeCodeScanner? scanner,
}) async {
  tester.binding.defaultBinaryMessenger.setMockMethodCallHandler(
    SystemChannels.platform,
    (call) async {
      if (call.method == 'HapticFeedback.vibrate') {
        haptics?.add(call.arguments as String);
      }
      return null;
    },
  );
  addTearDown(
    () => tester.binding.defaultBinaryMessenger.setMockMethodCallHandler(
      SystemChannels.platform,
      null,
    ),
  );
  final container = ProviderContainer.test(
    overrides: signedIn(db: db, scanner: scanner),
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

/// Başlığı [title] olan bölüm: başlığın hemen üstündeki sütun.
Finder _section(String title) => find
    .ancestor(
      of: find.byWidgetPredicate(
        (widget) => widget is SectionLabel && widget.text == title,
      ),
      matching: find.byType(Column),
    )
    .first;

/// [section] bölümündeki [label] chip'i (ör. "Yok" birden çok bölümde var).
Finder _chip(String section, String label) =>
    find.descendant(of: _section(section), matching: find.text(label));

Finder _stepperButton(String label, String tooltip) => find.descendant(
  of: find.widgetWithText(BigStepper, label),
  matching: find.byTooltip(tooltip),
);

BigStepper _stepper(WidgetTester tester, String label) =>
    tester.widget<BigStepper>(find.widgetWithText(BigStepper, label));

ChoiceChipGroup<T> _choices<T>(WidgetTester tester, String section) =>
    tester.widget<ChoiceChipGroup<T>>(
      find.descendant(
        of: _section(section),
        matching: find.byType(ChoiceChipGroup<T>),
      ),
    );

String _location(ProviderContainer container) =>
    container.read(routerProvider).routerDelegate.currentConfiguration.uri.path;

void main() {
  late AppDatabase db;
  late TestClock clock;
  late InspectionRepository inspections;
  late Apiary yayla;
  late Hive hive;
  late List<String> haptics;

  setUp(() async {
    db = openTestDatabase();
    clock = TestClock();
    inspections = InspectionRepository(db, clock: clock.call);
    haptics = [];
    yayla = await ApiaryRepository(db).create(orgId: _orgId, name: 'Yayla');
    hive = await HiveRepository(db).create(
      orgId: _orgId,
      number: '101',
      type: HiveType.langstroth,
      apiaryId: yayla.id,
    );
  });

  Future<Inspection> inspectBefore() => inspections.add(
    orgId: _orgId,
    hiveId: hive.id,
    apiaryId: yayla.id,
    values: _previous,
  );

  Future<ProviderContainer> openCard(WidgetTester tester) =>
      _open(tester, db: db, location: AppRoutes.hive(yayla.id, hive.id));

  Future<void> startInspection(WidgetTester tester) async {
    await _tap(tester, find.widgetWithText(BigButton, 'Start inspection'));
    expect(find.byType(InspectionSheet), findsOneWidget);
  }

  Future<Inspection?> latest() => inspections.latestByHive(hive.id);

  group('Açma ve kapatma', () {
    testWidgets('Muayene başlat sayfayı kartın üstünde açar; klavye yok; '
        'Kapat karta döner', (tester) async {
      final container = await openCard(tester);

      await startInspection(tester);

      expect(find.byType(HiveCardScreen), findsOneWidget);
      expect(_location(container), AppRoutes.hiveInspect(yayla.id, hive.id));
      expect(find.bySemanticsLabel('Inspect hive 101'), findsOneWidget);
      expect(find.text('First inspection'), findsOneWidget);
      expect(find.byType(EditableText), findsNothing);
      expect(_stepper(tester, 'With bees').value, isNull);
      expect(_choices<QueenState>(tester, 'Queen').selected, isEmpty);

      await _tap(tester, find.byTooltip('Close'));

      expect(find.byType(InspectionSheet), findsNothing);
      expect(_location(container), AppRoutes.hive(yayla.id, hive.id));
      expect(find.widgetWithText(BigButton, 'Start inspection'), findsOne);
    });

    testWidgets('aktif olmayan kovanın kartında Muayene başlat yok', (
      tester,
    ) async {
      await HiveRepository(db).setStatus(hive.id, HiveStatus.sold);
      await openCard(tester);

      expect(find.byType(HiveCardScreen), findsOneWidget);
      expect(find.text('Start inspection'), findsNothing);
    });
  });

  testWidgets('ilk muayene chip ve sayaçlarla girilir; Kaydet titreşir, '
      'yazar, sayfayı kapatır; bildirimde Geri al ve hatırlatma var', (
    tester,
  ) async {
    await _open(
      tester,
      db: db,
      location: AppRoutes.hive(yayla.id, hive.id),
      haptics: haptics,
    );
    await startInspection(tester);

    await _tap(tester, _chip('Queen', 'Seen'));
    for (var i = 0; i < 3; i++) {
      await _tap(tester, _stepperButton('With bees', 'Increase'));
    }
    await _tap(tester, _stepperButton('With brood', 'Increase'));
    // Boş sayaçta − sıfır verir.
    await _tap(tester, _stepperButton('With honey', 'Decrease'));
    await _tap(tester, _chip('Temperament', 'Calm'));
    await _tap(tester, _chip('Swarm signs', 'Yes'));
    await _tap(tester, _chip('Queen cells', 'Swarm'));
    await _tap(tester, _chip('Disease suspected', 'No'));
    await _tap(tester, _chip('Done today', 'Super added'));
    await _tap(tester, _chip('Done today', 'Fed'));
    expect(_stepper(tester, 'With bees').value, 3);
    expect(_stepper(tester, 'With honey').value, 0);
    expect(haptics, isEmpty);

    await _tap(tester, find.widgetWithText(BigButton, 'Save'));

    expect(haptics, ['HapticFeedbackType.mediumImpact']);
    expect(find.byType(InspectionSheet), findsNothing);
    expect(find.byType(HiveCardScreen), findsOneWidget);
    expect(find.text('Hive 101 inspection saved'), findsOneWidget);
    expect(find.text('Undo'), findsOneWidget);
    expect(find.text('Remind in'), findsOneWidget);

    final saved = (await latest())!;
    expect(saved.apiaryId, yayla.id);
    expect(
      saved.values,
      const InspectionValues(
        queenState: QueenState.seen,
        beeFrames: 3,
        broodFrames: 1,
        honeyFrames: 0,
        temperament: Temperament.calm,
        swarmSigns: true,
        queenCells: QueenCells.swarm,
        diseaseSuspected: false,
        actions: {InspectionAction.superAdded, InspectionAction.fed},
      ),
    );
    expect(
      (await readOutbox(db)).where((e) => e.recordTable == 'inspections'),
      hasLength(1),
    );
    expect(await InspectionDraftRepository(db).find(hive.id), isNull);

    // "Tekrar bak" muayeneyi yapana atanan bir görev; gün değişince aynı
    // görevin günü değişir, seçim kalkınca görev silinir.
    final tasks = TaskRepository(db);
    Future<List<Task>> reminders() =>
        tasks.findBySource(TaskSource.inspection, saved.id);
    await tester.tap(find.text('7 days'));
    await tester.pumpAndSettle();
    final week = (await reminders()).single;
    expect(week.dueAt, reminderAt(saved.inspectedAt, 7));
    expect(week.hiveId, hive.id);
    expect(week.assignedTo, testUser.id);

    await tester.tap(find.text('14 days'));
    await tester.pumpAndSettle();
    expect(await reminders(), [
      isA<Task>()
          .having((t) => t.id, 'id', week.id)
          .having((t) => t.dueAt, 'dueAt', reminderAt(saved.inspectedAt, 14)),
    ]);

    await tester.tap(find.text('14 days'));
    await tester.pumpAndSettle();
    expect(await reminders(), isEmpty);

    // Bildirim 6 sn sonra kapanır; muayene kalır.
    await tester.pump(const Duration(seconds: 7));
    await tester.pumpAndSettle();
    expect(find.text('Hive 101 inspection saved'), findsNothing);
    expect(await latest(), saved);
  });

  group('Önceki muayene', () {
    testWidgets('değerleri soluk gelir, işlemler boş başlar; dokunulmayanlar '
        'aynen kaydedilir', (tester) async {
      await inspectBefore();
      await openCard(tester);
      await startInspection(tester);

      expect(find.text('Last inspection Oct 22, 2026'), findsOneWidget);
      expect(
        find.text(
          "Faded values are from the last inspection. Change what's "
          'different; the rest is saved as it is.',
        ),
        findsOneWidget,
      );
      final bees = _stepper(tester, 'With bees');
      expect((bees.value, bees.suggested), (8, true));
      expect(find.text('From the last record'), findsNWidgets(3));
      final queen = _choices<QueenState>(tester, 'Queen');
      expect(queen.selected, {QueenState.seen});
      expect(queen.suggested, isTrue);
      expect(_choices<bool>(tester, 'Swarm signs').selected, {false});
      expect(
        _choices<InspectionAction>(tester, 'Done today').selected,
        isEmpty,
      );

      await _tap(tester, _stepperButton('With bees', 'Increase'));

      final changed = _stepper(tester, 'With bees');
      expect((changed.value, changed.suggested), (9, false));
      expect(_stepper(tester, 'With brood').suggested, isTrue);
      expect(find.text('From the last record'), findsNWidgets(2));

      await _tap(tester, find.widgetWithText(BigButton, 'Save'));

      expect(
        (await latest())!.values,
        _previous.copyWith(beeFrames: 9, actions: const {}),
      );
    });

    testWidgets('öneriye dokunmak onaylar; yeniden dokunmak seçimi kaldırır', (
      tester,
    ) async {
      await inspectBefore();
      await openCard(tester);
      await startInspection(tester);

      await _tap(tester, _chip('Queen', 'Seen'));
      var queen = _choices<QueenState>(tester, 'Queen');
      expect(queen.selected, {QueenState.seen});
      expect(queen.suggested, isFalse);

      await _tap(tester, _chip('Queen', 'Seen'));
      queen = _choices<QueenState>(tester, 'Queen');
      expect(queen.selected, isEmpty);

      // Öneri başka bir seçimle de değişir.
      await _tap(tester, _chip('Temperament', 'Nervous'));
      final temperament = _choices<Temperament>(tester, 'Temperament');
      expect(temperament.selected, {Temperament.nervous});
      expect(temperament.suggested, isFalse);

      await _tap(tester, find.widgetWithText(BigButton, 'Save'));

      final saved = (await latest())!;
      expect(saved.queenState, isNull);
      expect(saved.temperament, Temperament.nervous);
    });
  });

  group('Taslak', () {
    testWidgets('her değişiklik saklanır; uygulama yeniden açılınca form '
        'kaldığı yerden gelir; Baştan başla önceki muayeneye döner', (
      tester,
    ) async {
      await inspectBefore();
      await openCard(tester);
      await startInspection(tester);
      expect(find.text('Kept as a draft on this phone'), findsNothing);

      await _tap(tester, _stepperButton('With bees', 'Increase'));
      await _tap(tester, _chip('Temperament', 'Nervous'));
      await _tap(tester, _chip('Done today', 'Super added'));

      expect(find.text('Kept as a draft on this phone'), findsOneWidget);
      final drafts = InspectionDraftRepository(db);
      final draft = (await drafts.find(hive.id))!;
      expect(
        draft.values,
        _previous.copyWith(
          beeFrames: 9,
          temperament: Temperament.nervous,
          actions: {InspectionAction.superAdded},
        ),
      );
      expect(draft.suggested, isNot(contains(InspectionField.beeFrames)));
      expect(draft.suggested, contains(InspectionField.broodFrames));

      // Uygulama kapanıp yeniden açılır: yeni durum, aynı yerel DB.
      await tester.pumpWidget(const SizedBox());
      await tester.pump(Duration.zero);
      await openCard(tester);
      await startInspection(tester);

      final bees = _stepper(tester, 'With bees');
      expect((bees.value, bees.suggested), (9, false));
      expect(_stepper(tester, 'With brood').suggested, isTrue);
      expect(_choices<Temperament>(tester, 'Temperament').selected, {
        Temperament.nervous,
      });
      expect(_choices<InspectionAction>(tester, 'Done today').selected, {
        InspectionAction.superAdded,
      });

      await _tap(tester, find.widgetWithText(TextButton, 'Start over'));

      final restarted = _stepper(tester, 'With bees');
      expect((restarted.value, restarted.suggested), (8, true));
      expect(
        _choices<InspectionAction>(tester, 'Done today').selected,
        isEmpty,
      );
      expect(find.text('Kept as a draft on this phone'), findsNothing);
      expect(await drafts.find(hive.id), isNull);
    });

    testWidgets('kapatılan sayfanın taslağı kalır; kaydedince silinir', (
      tester,
    ) async {
      await openCard(tester);
      await startInspection(tester);
      await _tap(tester, _chip('Queen', 'Eggs seen'));
      await _tap(tester, find.byTooltip('Close'));

      final drafts = InspectionDraftRepository(db);
      expect((await drafts.find(hive.id))!.values.queenState, QueenState.eggs);

      await startInspection(tester);
      expect(_choices<QueenState>(tester, 'Queen').selected, {QueenState.eggs});
      await _tap(tester, find.widgetWithText(BigButton, 'Save'));

      expect(await drafts.find(hive.id), isNull);
      expect((await latest())!.queenState, QueenState.eggs);
    });
  });

  testWidgets('Geri al muayeneyi ve hatırlatmayı siler, formu taslak olarak '
      'geri getirir', (tester) async {
    await openCard(tester);
    await startInspection(tester);
    await _tap(tester, _chip('Queen', 'Eggs seen'));
    await _tap(tester, _stepperButton('With bees', 'Increase'));
    await _tap(tester, find.widgetWithText(BigButton, 'Save'));
    final saved = (await latest())!;
    await tester.tap(find.text('7 days'));
    await tester.pumpAndSettle();

    await tester.tap(find.text('Undo'));
    await tester.pumpAndSettle();

    expect(await latest(), isNull);
    expect(
      await TaskRepository(db).findBySource(TaskSource.inspection, saved.id),
      isEmpty,
    );
    expect(
      (await InspectionDraftRepository(db).find(hive.id))!.values,
      const InspectionValues(queenState: QueenState.eggs, beeFrames: 1),
    );

    await startInspection(tester);
    expect(_choices<QueenState>(tester, 'Queen').selected, {QueenState.eggs});
    expect(_stepper(tester, 'With bees').value, 1);
  });

  testWidgets('20 saniye hedefi: okut → muayene → kaydet, önceki muayeneden '
      'sonra 5 dokunuş, klavye hiç açılmaz', (tester) async {
    await inspectBefore();
    final scanner = FakeCodeScanner();
    await _open(
      tester,
      db: db,
      location: AppRoutes.today,
      haptics: haptics,
      scanner: scanner,
    );
    await tester.tap(
      find.descendant(
        of: find.byType(AppNavigationBar),
        matching: find.byWidgetPredicate(
          (widget) => widget is Icon && widget.semanticLabel == 'Scan',
        ),
      ),
    );
    await tester.pumpAndSettle();
    scanner.scan(hiveLabelCode(hive.id));
    await tester.pumpAndSettle();
    expect(find.byType(InspectionSheet), findsOneWidget);

    var taps = 0;
    Future<void> touch(Finder finder) async {
      taps++;
      await _tap(tester, finder);
      expect(find.byType(EditableText), findsNothing);
    }

    await touch(_chip('Queen', 'Seen'));
    await touch(_stepperButton('With bees', 'Increase'));
    await touch(_stepperButton('With brood', 'Decrease'));
    await touch(_chip('Done today', 'Super added'));
    await touch(find.widgetWithText(BigButton, 'Save'));

    expect(taps, 5);
    expect(haptics, [
      'HapticFeedbackType.heavyImpact',
      'HapticFeedbackType.mediumImpact',
    ]);
    expect(
      (await latest())!.values,
      _previous.copyWith(
        beeFrames: 9,
        broodFrames: 4,
        actions: {InspectionAction.superAdded},
      ),
    );
  });

  testWidgets('Türkçe metinler', (tester) async {
    await inspectBefore();
    final container = await openCard(tester);
    container.read(languageProvider.notifier).language = AppLanguage.turkish;
    await tester.pumpAndSettle();

    await _tap(tester, find.widgetWithText(BigButton, 'Muayene başlat'));

    const legend =
        'Soluk değerler önceki muayeneden. Değişeni düzelt; diğerleri olduğu '
        'gibi kaydedilir.';

    expect(find.bySemanticsLabel('Kovan 101 muayenesi'), findsOneWidget);
    for (final text in [
      'Önceki muayene 22 Eki 2026',
      legend,
      'ANA ARI',
      'Görüldü',
      'Yumurta var',
      'ÇERÇEVELER',
      'Arılı',
      'Yavrulu',
      'Ballı',
      'MİZAÇ',
      'Sakin',
      'Sinirli',
      'OĞUL BELİRTİSİ',
      'ANA ARI MEMESİ',
      'Ana değiştirme',
      'Acil',
      'HASTALIK ŞÜPHESİ',
      'YAPILAN İŞLEM',
      'Kat verildi',
      'Ana ızgarası takıldı',
      'Polen tuzağı takıldı',
    ]) {
      await tester.ensureVisible(find.text(text).first);
      expect(find.text(text), findsWidgets, reason: text);
    }
    expect(find.text('Önceki kayıttan'), findsNWidgets(3));

    await _tap(tester, _chip('Mizaç', 'Sinirli'));
    expect(find.text('Bu telefonda taslak olarak saklanıyor'), findsOneWidget);
    expect(find.text('Baştan başla'), findsOneWidget);

    await _tap(tester, find.widgetWithText(BigButton, 'Kaydet'));

    expect(find.text('Kovan 101 muayenesi kaydedildi'), findsOneWidget);
    expect(find.text('Geri al'), findsOneWidget);
    expect(find.text('Tekrar bakmayı hatırlat'), findsOneWidget);
    expect(find.text('3 gün'), findsOneWidget);
    expect(find.text('7 gün'), findsOneWidget);
    expect(find.text('14 gün'), findsOneWidget);
  });

  testWidgets('360dp ekranda 1.5x yazı ve eldivenle taşmaz', (tester) async {
    tester.view
      ..physicalSize = const Size(360, 640)
      ..devicePixelRatio = 1;
    tester.platformDispatcher.textScaleFactorTestValue = 1.5;
    addTearDown(tester.view.reset);
    addTearDown(tester.platformDispatcher.clearTextScaleFactorTestValue);
    await inspectBefore();
    final container = await openCard(tester);

    for (final glove in [false, true]) {
      container.read(appearanceProvider.notifier).setGloveMode(enabled: glove);
      await tester.pumpAndSettle();

      await startInspection(tester);
      expect(tester.takeException(), isNull);
      await _tap(tester, _stepperButton('With bees', 'Increase'));
      for (final section in [
        'Queen cells',
        'Disease suspected',
        'Done today',
      ]) {
        await tester.ensureVisible(_section(section));
        await tester.pumpAndSettle();
        expect(tester.takeException(), isNull);
      }

      await _tap(tester, find.widgetWithText(BigButton, 'Save'));
      expect(find.text('7 days'), findsOneWidget);
      expect(tester.takeException(), isNull);
      // Bildirim ekrana sığar; Geri al ve chip'ler alt gezinmenin üstünde.
      final snackBar = tester.getRect(find.byType(SnackBar));
      expect(snackBar.top, greaterThanOrEqualTo(0));
      final navigation = tester.getRect(find.byType(AppNavigationBar));
      for (final text in ['Undo', '3 days', '7 days', '14 days']) {
        expect(
          tester.getRect(find.text(text)).bottom,
          lessThanOrEqualTo(navigation.top),
          reason: text,
        );
      }
      // Sayaçlar ve chip'ler eldivenle de en az saha hedefi kadar.
      expect(
        tester.getSize(find.widgetWithText(BigButton, 'Start inspection')),
        isA<Size>().having(
          (size) => size.height,
          'yükseklik',
          greaterThanOrEqualTo(glove ? 64 : 56),
        ),
      );

      await tester.tap(find.text('Undo'));
      await tester.pumpAndSettle();
    }
  });
}
