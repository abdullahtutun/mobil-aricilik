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
import 'package:mobil_arici/features/apiaries/data/apiary_repository.dart';
import 'package:mobil_arici/features/apiaries/domain/apiary.dart';
import 'package:mobil_arici/features/hives/data/hive_repository.dart';
import 'package:mobil_arici/features/hives/domain/hive.dart';
import 'package:mobil_arici/features/organization/domain/membership_role.dart';
import 'package:mobil_arici/features/tasks/data/task_repository.dart';
import 'package:mobil_arici/features/tasks/domain/task.dart';
import 'package:mobil_arici/features/tasks/domain/task_rules.dart';
import 'package:mobil_arici/features/tasks/presentation/task_form_screen.dart';
import 'package:mobil_arici/features/tasks/presentation/tasks_screen.dart';

import '../../../helpers/fake_auth_service.dart';
import '../../../helpers/fake_organization_service.dart';
import '../../../helpers/fake_reminder_notifications.dart';
import '../../../helpers/test_database.dart';

final String _orgId = testOrganization.id;
const _workerId = 'worker-user';

Future<ProviderContainer> _open(
  WidgetTester tester, {
  required AppDatabase db,
  String location = AppRoutes.tasks,
  FakeReminderNotifications? reminders,
}) async {
  final container = ProviderContainer.test(
    overrides: signedIn(db: db, reminders: reminders),
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

Finder _button(String label) => find.widgetWithText(BigButton, label);

/// Formdaki seçim chip'i; aynı metin alt gezinmede de olabilir.
Finder _chip(String label) => find.descendant(
  of: find.byWidgetPredicate((w) => w is ChoiceChipGroup),
  matching: find.text(label),
);

/// Görünüm sekmesi.
Finder _tab(String label) => find.descendant(
  of: find.byWidgetPredicate((w) => w is SegmentedTabs),
  matching: find.text(label),
);

/// Alttan açılan seçim sayfasındaki seçenek.
Finder _inSheet(String label) =>
    find.descendant(of: find.byType(BottomSheet), matching: find.text(label));

/// [title]'lı satırın tamamlama kutusu.
Finder _checkbox(String title) => find.descendant(
  of: find.ancestor(of: find.text(title), matching: find.byType(InkWell)).first,
  matching: find.byType(Checkbox),
);

/// Yerel takvimde bugünden [days] gün sonra, [hour]'da.
DateTime _day(int days, {int hour = 9}) {
  final now = DateTime.now();
  return DateTime(now.year, now.month, now.day + days, hour);
}

void main() {
  late AppDatabase db;
  late TaskRepository tasks;
  late Apiary yayla;
  late Apiary kizilcam;
  late Hive hive;

  setUpAll(initializeDateFormatting);

  setUp(() async {
    db = openTestDatabase();
    tasks = TaskRepository(db);
    final apiaries = ApiaryRepository(db);
    yayla = await apiaries.create(orgId: _orgId, name: 'Yayla');
    kizilcam = await apiaries.create(orgId: _orgId, name: 'Kızılçam');
    hive = await HiveRepository(db).create(
      orgId: _orgId,
      number: '103',
      type: HiveType.langstroth,
      apiaryId: kizilcam.id,
    );
    final at = DateTime.utc(2026, 10, 20);
    for (final (id, userId, role) in [
      ('m1', testUser.id, MembershipRole.owner),
      ('m2', _workerId, MembershipRole.worker),
    ]) {
      await db
          .into(db.memberships)
          .insert(
            MembershipsCompanion.insert(
              id: id,
              orgId: _orgId,
              userId: userId,
              role: role,
              createdAt: at,
              updatedAt: at,
            ),
          );
    }
  });

  Future<List<Task>> liveTasks() async => [
    for (final task in await db.select(db.tasks).get())
      if (task.deletedAt == null) task,
  ];

  Future<void> seed() async {
    await tasks.create(
      orgId: _orgId,
      title: 'Yayla arılığını ziyaret et',
      dueAt: _day(-5),
      apiaryId: yayla.id,
      assignedTo: testUser.id,
    );
    await tasks.create(
      orgId: _orgId,
      title: 'Kovan 103’e ana ver',
      dueAt: _day(0, hour: 0),
      apiaryId: kizilcam.id,
      hiveId: hive.id,
      assignedTo: _workerId,
    );
    await tasks.addTreatmentRemoval(
      orgId: _orgId,
      groupId: 'group-1',
      apiaryId: kizilcam.id,
      dueAt: _day(1),
    );
    await tasks.create(
      orgId: _orgId,
      title: 'Bal kavanozu al',
      dueAt: _day(10),
    );
  }

  testWidgets('boşken boş durum ve görev ekle', (tester) async {
    await _open(tester, db: db);

    expect(find.text('No tasks yet'), findsOneWidget);
    await _tap(tester, _button('Add task'));
    expect(find.byType(TaskFormScreen), findsOneWidget);
    expect(find.text('New task'), findsOneWidget);
  });

  testWidgets('Bugün: önce gecikmiş, sonra bugün; Bu hafta: gün şeridi ve '
      'günler; Arılığa göre: tarih sınırı yok', (tester) async {
    await seed();
    await _open(tester, db: db);

    expect(find.text('OVERDUE · 1'), findsOneWidget);
    expect(find.text('Yayla arılığını ziyaret et'), findsOneWidget);
    expect(find.text('Yayla · 5 days overdue'), findsOneWidget);
    expect(find.text('TODAY · 1'), findsOneWidget);
    expect(find.text('Kovan 103’e ana ver'), findsOneWidget);
    expect(find.text('Kızılçam · Hive 103'), findsOneWidget);
    // Kendime atanan "Me", işçiye atanan rolünün baş harfi; ekran okuyucu
    // kimin olduğunu okur.
    expect(find.text('Me'), findsOneWidget);
    expect(find.text('W'), findsOneWidget);
    Finder semantics(String label) => find.byWidgetPredicate(
      (w) => w is Semantics && w.properties.label == label,
    );
    expect(semantics('Assigned to Me'), findsOneWidget);
    expect(semantics('Assigned to Worker'), findsOneWidget);
    expect(find.text('Remove strips'), findsNothing);

    await _tap(tester, _tab('This week'));
    await tester.scrollUntilVisible(
      find.text('TOMORROW · 1'),
      200,
      scrollable: find.byType(Scrollable).first,
    );
    expect(find.text('TOMORROW · 1'), findsOneWidget);
    await tester.scrollUntilVisible(
      find.text('Remove strips'),
      200,
      scrollable: find.byType(Scrollable).first,
    );
    expect(find.text('Remove strips'), findsOneWidget);
    expect(find.text('Kızılçam · treatment'), findsOneWidget);
    expect(find.text('Bal kavanozu al'), findsNothing);
    // Gün şeridinde bugün ve yarın görevli; diğer beş gün boş.
    final strip = [
      for (final e
          in find
              .byWidgetPredicate(
                (w) =>
                    w is Semantics && (w.properties.label ?? '').contains(', '),
                skipOffstage: false,
              )
              .evaluate())
        (e.widget as Semantics).properties.label!,
    ];
    expect(strip, hasLength(taskWeekDays));
    expect(strip.where((l) => l.endsWith(', 1 task')), hasLength(2));
    expect(strip.where((l) => l.endsWith(', no tasks')), hasLength(5));

    await tester.scrollUntilVisible(
      _tab('By apiary'),
      -200,
      scrollable: find.byType(Scrollable).first,
    );
    await _tap(tester, _tab('By apiary'));
    expect(find.text('KIZILÇAM · 2'), findsOneWidget);
    expect(find.text('YAYLA · 1'), findsOneWidget);
    expect(find.text('NO APIARY · 1'), findsOneWidget);
    await tester.scrollUntilVisible(find.text('Bal kavanozu al'), 200);
    expect(find.text('Bal kavanozu al'), findsOneWidget);
  });

  testWidgets('kutu görevi tamamlar ve listeden düşürür; Geri al yeniden '
      'açar', (tester) async {
    await seed();
    await _open(tester, db: db);

    await _tap(tester, _checkbox('Yayla arılığını ziyaret et'));

    expect(find.text('Task completed'), findsOneWidget);
    expect(find.text('Yayla arılığını ziyaret et'), findsNothing);
    final done = (await liveTasks()).firstWhere(
      (t) => t.title == 'Yayla arılığını ziyaret et',
    );
    expect(done.completedAt, isNotNull);

    await _tap(tester, find.text('Undo'));
    expect(find.text('Yayla arılığını ziyaret et'), findsOneWidget);
    expect((await tasks.findById(done.id))!.completedAt, isNull);
  });

  testWidgets('yeni görev: başlık, yarın, arılık, kovan ve atanan; '
      'kaydedince listede', (tester) async {
    final reminders = FakeReminderNotifications();
    await _open(
      tester,
      db: db,
      location: AppRoutes.taskNew,
      reminders: reminders,
    );

    expect(tester.widget<BigButton>(_button('Save')).onPressed, isNull);
    // Yeni görev önce kendime.
    expect(
      tester
          .widget<ChoiceChipGroup<String?>>(
            find.byType(ChoiceChipGroup<String?>),
          )
          .selected,
      {testUser.id},
    );
    await tester.enterText(find.byType(TextField), 'Varroa sayımı');
    FocusManager.instance.primaryFocus?.unfocus();
    await tester.pumpAndSettle();
    await tester.pumpAndSettle();
    await _tap(tester, _chip('Tomorrow'));
    await _tap(tester, find.text('Apiary'));
    await _tap(tester, _inSheet('Kızılçam'));
    await _tap(tester, find.text('Hive'));
    await _tap(tester, _inSheet('Hive 103'));
    await _tap(tester, _chip('Worker'));
    await _tap(tester, _button('Save'));

    expect(find.byType(TasksScreen), findsOneWidget);
    expect(find.text('Task saved'), findsOneWidget);
    final task = (await liveTasks()).single;
    expect(task.title, 'Varroa sayımı');
    expect(task.apiaryId, kizilcam.id);
    expect(task.hiveId, hive.id);
    expect(task.assignedTo, _workerId);
    final due = task.dueAt.toLocal();
    expect(DateTime(due.year, due.month, due.day), _day(1, hour: 0));
    expect((await readOutbox(db)).last.recordTable, 'tasks');
    // Başkasına atandı; bu telefonda bildirim izni sorulmaz.
    expect(reminders.permissionRequests, 0);

    await _tap(tester, _tab('This week'));
    expect(find.text('Varroa sayımı'), findsOneWidget);
  });

  testWidgets('düzenleme: değişiklik yazılır; Tamamlandı listeden düşürür; '
      'sil onay ister', (tester) async {
    await seed();
    await _open(tester, db: db);

    await _tap(tester, find.text('Kovan 103’e ana ver'));
    expect(find.text('Edit task'), findsOneWidget);
    expect(find.text('Kovan 103’e ana ver'), findsOneWidget);
    await tester.enterText(
      find.byType(TextField),
      'Kovan 103’e ana ver (yeni)',
    );
    FocusManager.instance.primaryFocus?.unfocus();
    await tester.pumpAndSettle();
    await _tap(tester, _chip('Unassigned'));
    await _tap(tester, find.text('Done'));
    await _tap(tester, _button('Save'));

    final edited = (await liveTasks()).firstWhere((t) => t.hiveId == hive.id);
    expect(edited.title, 'Kovan 103’e ana ver (yeni)');
    expect(edited.assignedTo, isNull);
    expect(edited.completedAt, isNotNull);
    expect(find.text('Kovan 103’e ana ver (yeni)'), findsNothing);

    await _tap(tester, find.text('Yayla arılığını ziyaret et'));
    await _tap(tester, _button('Delete task'));
    expect(find.text('Delete this task?'), findsOneWidget);
    await _tap(tester, find.text('Delete'));
    expect(find.text('Task deleted'), findsOneWidget);
    expect(find.text('Yayla arılığını ziyaret et'), findsNothing);
    expect([
      for (final t in await liveTasks()) t.title,
    ], isNot(contains('Yayla arılığını ziyaret et')));
  });

  testWidgets('otomatik görevin başlığı, arılığı ve kovanı değişmez; günü '
      'değişir', (tester) async {
    final task = await tasks.addTreatmentRemoval(
      orgId: _orgId,
      groupId: 'group-1',
      apiaryId: kizilcam.id,
      hiveId: hive.id,
      dueAt: _day(1),
    );
    await _open(tester, db: db, location: AppRoutes.taskEdit(task.id));

    expect(find.text('Hive 103 · remove strips'), findsOneWidget);
    expect(find.byType(TextField), findsNothing);
    final apiaryRow = tester.widget<ListRow>(
      find.widgetWithText(ListRow, 'Apiary'),
    );
    expect(apiaryRow.value, 'Kızılçam');
    expect(apiaryRow.onTap, isNull);

    await _tap(tester, _chip('Today'));
    await _tap(tester, _button('Save'));

    final saved = (await tasks.findById(task.id))!;
    expect(saved.source, TaskSource.treatment);
    expect(saved.hiveId, hive.id);
    final due = saved.dueAt.toLocal();
    expect(DateTime(due.year, due.month, due.day), _day(0, hour: 0));
  });

  testWidgets('tam zamanlı alarm izni yoksa nedeni bir kez anlatılır; '
      'onaylanınca ayar açılır', (tester) async {
    final reminders = FakeReminderNotifications()..exact = false;
    await _open(
      tester,
      db: db,
      location: AppRoutes.taskNew,
      reminders: reminders,
    );

    await tester.enterText(find.byType(TextField), 'Ziyaret');
    FocusManager.instance.primaryFocus?.unfocus();
    await tester.pumpAndSettle();
    await _tap(tester, _chip('Tomorrow'));
    await _tap(tester, _button('Save'));

    expect(reminders.permissionRequests, 1);
    expect(find.text('Ring reminders right on time?'), findsOneWidget);
    await _tap(tester, find.text('Open setting'));
    expect(reminders.exactRequests, 1);
    expect(find.byType(TasksScreen), findsOneWidget);

    // İkinci kayıtta sorulmaz. Önceki bildirim Kaydet'in üstünden kalksın.
    reminders.exact = false;
    await tester.pump(const Duration(seconds: 5));
    await tester.pumpAndSettle();
    await _tap(tester, find.byTooltip('Add task'));
    await tester.enterText(find.byType(TextField), 'Şeker al');
    FocusManager.instance.primaryFocus?.unfocus();
    await tester.pumpAndSettle();
    await _tap(tester, _chip('Tomorrow'));
    await _tap(tester, _button('Save'));
    expect(find.text('Ring reminders right on time?'), findsNothing);
    expect(reminders.exactRequests, 1);
  });

  testWidgets('bildirim izni verilmezse görev yine kaydedilir, nedeni '
      'söylenir', (tester) async {
    final reminders = FakeReminderNotifications()
      ..permitted = false
      ..grantOnRequest = false;
    await _open(
      tester,
      db: db,
      location: AppRoutes.taskNew,
      reminders: reminders,
    );

    await tester.enterText(find.byType(TextField), 'Ziyaret');
    FocusManager.instance.primaryFocus?.unfocus();
    await tester.pumpAndSettle();
    await _tap(tester, _chip('Tomorrow'));
    await _tap(tester, _button('Save'));

    expect(await liveTasks(), hasLength(1));
    expect(
      find.text("Notifications are off; the reminder won't ring."),
      findsOneWidget,
    );
  });

  testWidgets('Ayarlar: tam saatinde çalma kapalıysa dokununca istenir', (
    tester,
  ) async {
    final reminders = FakeReminderNotifications()..exact = false;
    await _open(
      tester,
      db: db,
      location: AppRoutes.settings,
      reminders: reminders,
    );

    await tester.scrollUntilVisible(find.text('Ring right on time'), 200);
    expect(find.text('Off · may be a few minutes late'), findsOneWidget);
    await _tap(tester, find.text('Ring right on time'));

    expect(reminders.exactRequests, 1);
    expect(find.text('On'), findsOneWidget);
  });

  testWidgets('Türkçe metinler', (tester) async {
    await seed();
    final container = await _open(tester, db: db);
    container.read(languageProvider.notifier).language = AppLanguage.turkish;
    await tester.pumpAndSettle();

    expect(find.text('Görevler'), findsWidgets);
    expect(_tab('Bugün'), findsOneWidget);
    expect(_tab('Bu hafta'), findsOneWidget);
    expect(_tab('Arılığa göre'), findsOneWidget);
    expect(find.text('GECİKMİŞ · 1'), findsOneWidget);
    expect(find.text('Yayla · 5 gün gecikti'), findsOneWidget);
    expect(find.text('BUGÜN · 1'), findsOneWidget);
    expect(find.text('Kızılçam · Kovan 103'), findsOneWidget);
    expect(find.text('Ben'), findsOneWidget);
    expect(find.text('İ'), findsOneWidget);

    await _tap(tester, _tab('Bu hafta'));
    await tester.scrollUntilVisible(
      find.text('YARIN · 1'),
      200,
      scrollable: find.byType(Scrollable).first,
    );
    expect(find.text('YARIN · 1'), findsOneWidget);
    await tester.scrollUntilVisible(
      find.text('Şeritleri çıkar'),
      200,
      scrollable: find.byType(Scrollable).first,
    );
    expect(find.text('Şeritleri çıkar'), findsOneWidget);
    expect(find.text('Kızılçam · ilaç'), findsOneWidget);

    await tester.scrollUntilVisible(
      _tab('Arılığa göre'),
      -200,
      scrollable: find.byType(Scrollable).first,
    );
    await _tap(tester, _tab('Arılığa göre'));
    await tester.scrollUntilVisible(find.text('ARILIKSIZ · 1'), 200);
    expect(find.text('ARILIKSIZ · 1'), findsOneWidget);

    await tester.scrollUntilVisible(find.text('Şeritleri çıkar'), -200);
    await _tap(tester, find.text('Şeritleri çıkar'));
    expect(find.text('Görevi düzenle'), findsOneWidget);
    expect(find.text('Son tarih'), findsOneWidget);
    expect(find.text('Atanan'), findsOneWidget);
    expect(find.text('Atanmamış'), findsOneWidget);
    expect(find.text('İşçi'), findsOneWidget);
    expect(find.text('Tamamlandı'), findsOneWidget);
  });

  testWidgets('360dp ekranda 1.5x yazı ve eldivenle liste, şerit ve form '
      'taşmaz', (tester) async {
    tester.view
      ..physicalSize = const Size(360, 640)
      ..devicePixelRatio = 1;
    tester.platformDispatcher.textScaleFactorTestValue = 1.5;
    addTearDown(tester.view.reset);
    addTearDown(tester.platformDispatcher.clearTextScaleFactorTestValue);
    await seed();

    final container = await _open(tester, db: db);
    container.read(appearanceProvider.notifier).setGloveMode(enabled: true);
    container.read(languageProvider.notifier).language = AppLanguage.turkish;
    await tester.pumpAndSettle();
    expect(tester.takeException(), isNull);

    await _tap(tester, _tab('Bu hafta'));
    expect(tester.takeException(), isNull);
    await _tap(tester, _tab('Arılığa göre'));
    expect(tester.takeException(), isNull);

    await _tap(tester, find.text('Kovan 103’e ana ver'));
    expect(tester.takeException(), isNull);
    await tester.scrollUntilVisible(
      find.text('Tamamlandı'),
      200,
      scrollable: find
          .descendant(
            of: find.byType(TaskFormScreen),
            matching: find.byType(Scrollable),
          )
          .first,
    );
    expect(tester.takeException(), isNull);
  });
}
