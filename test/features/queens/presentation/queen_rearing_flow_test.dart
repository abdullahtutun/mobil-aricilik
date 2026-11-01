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
import 'package:mobil_arici/features/organization/domain/membership_role.dart';
import 'package:mobil_arici/features/queens/data/queen_rearing_repository.dart';
import 'package:mobil_arici/features/queens/data/queen_repository.dart';
import 'package:mobil_arici/features/queens/domain/queen.dart';
import 'package:mobil_arici/features/queens/domain/queen_rearing.dart';
import 'package:mobil_arici/features/tasks/data/task_repository.dart';
import 'package:mobil_arici/features/tasks/domain/task.dart';

import '../../../helpers/fake_auth_service.dart';
import '../../../helpers/fake_organization_service.dart';
import '../../../helpers/fake_reminder_notifications.dart';
import '../../../helpers/fake_team_service.dart';
import '../../../helpers/test_database.dart';

final String _orgId = testOrganization.id;

Finder _button(String label) => find.widgetWithText(BigButton, label);

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

void main() {
  late AppDatabase db;
  late QueenRearingRepository repository;
  late FakeReminderNotifications reminders;
  final today = DateUtils.dateOnly(DateTime.now());
  DateTime inDays(int days) =>
      DateTime(today.year, today.month, today.day + days);

  setUp(() {
    db = openTestDatabase();
    repository = QueenRearingRepository(db);
    reminders = FakeReminderNotifications();
  });

  Future<ProviderContainer> open(
    WidgetTester tester, {
    String location = AppRoutes.rearing,
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

  void tallView(WidgetTester tester) {
    tester.view
      ..physicalSize = const Size(800, 2400)
      ..devicePixelRatio = 1;
    addTearDown(tester.view.reset);
  }

  /// Çam arılığı ve içinde 2025 mavi analı Kovan 104 (anne ana) ile anasız
  /// Kovan 7.
  Future<({Apiary apiary, Queen mother, Hive hive7})> seedYard() async {
    final apiary = await ApiaryRepository(db)
        .create(orgId: _orgId, name: 'Çam');
    final mother = await QueenRepository(db)
        .create(orgId: _orgId, year: 2025, markColor: QueenMarkColor.blue);
    final hives = HiveRepository(db);
    await hives.create(
      orgId: _orgId,
      number: '104',
      type: HiveType.langstroth,
      apiaryId: apiary.id,
      queenId: mother.id,
    );
    final hive7 = await hives.create(
      orgId: _orgId,
      number: '7',
      type: HiveType.langstroth,
      apiaryId: apiary.id,
    );
    return (apiary: apiary, mother: mother, hive7: hive7);
  }

  /// 10 gün önce aktarılmış 40 larvalık seri, 34 kabul; G1 ve G5 görevleri
  /// tamamlanmış.
  Future<QueenRearingBatch> seedBatch({String? motherQueenId}) async {
    final batch = await repository.create(
      orgId: _orgId,
      graftedOn: inDays(-10),
      graftedCount: 40,
      acceptedCount: 34,
      motherQueenId: motherQueenId,
      assignedTo: testUser.id,
    );
    final tasks = TaskRepository(db);
    for (final task in await tasks.findBySource(
      TaskSource.queenRearing,
      batch.id,
    )) {
      if (task.sourceStep! <= 5) {
        await tasks.setCompleted(task, completed: true);
      }
    }
    return batch;
  }

  testWidgets("Daha fazla'dan açılır; seri eklenir, beş takvim görevi ve "
      'hatırlatması kurulur', (tester) async {
    tallView(tester);
    final yard = await seedYard();
    await open(tester, location: AppRoutes.more);

    await _tap(tester, find.text('Queen rearing'));
    expect(find.text('No batches yet'), findsOneWidget);
    await _tap(tester, _button('Add batch'));

    expect(find.text('New batch'), findsOneWidget);
    expect(find.text('40'), findsOneWidget);
    await _tap(tester, find.text('Mother queen'));
    await _tap(tester, find.text('Hive 104 · 2025 · Blue'));
    await _tap(tester, _button('Save'));

    final batch = (await db.select(db.queenRearingBatches).get()).single;
    expect(batch.number, 1);
    expect(batch.motherQueenId, yard.mother.id);
    expect(batch.graftedOn, today);
    expect(batch.graftedCount, 40);
    expect(batch.acceptedCount, isNull);
    final tasks = await TaskRepository(db)
        .findBySource(TaskSource.queenRearing, batch.id);
    expect(tasks.map((task) => task.sourceStep), [1, 5, 10, 12, 24]);
    expect(tasks.map((task) => task.assignedTo).toSet(), {testUser.id});

    // Takvim açılır: aktarma bitti, kabul kontrolü sıradaki.
    expect(find.text('Queen rearing · Batch 1'), findsOneWidget);
    expect(find.text('Larva grafting'), findsOneWidget);
    expect(find.text('Count the accepted cells'), findsOneWidget);
    expect(find.text('Not counted'), findsOneWidget);
    expect(_button('Distribute cells to nucs'), findsOneWidget);

    // Hatırlatmalar kendiliğinden kurulur; başlık adımın adı.
    expect(reminders.permissionRequests, greaterThan(0));
    expect(
      reminders.scheduled.values.map((reminder) => reminder.title).toSet(),
      {
        'Acceptance check',
        'Cells capped',
        'Distribute cells',
        'Queen emergence',
        'Laying check',
      },
    );
  });

  testWidgets('takvim: sayılar, anne ana, bitti / bugün / ileride adımlar', (
    tester,
  ) async {
    tallView(tester);
    final yard = await seedYard();
    final batch = await seedBatch(motherQueenId: yard.mother.id);
    await open(tester, location: AppRoutes.rearingBatch(batch.id));

    expect(find.text('Queen rearing · Batch 1'), findsOneWidget);
    expect(find.text('40'), findsOneWidget);
    expect(find.text('34'), findsOneWidget);
    expect(find.text('85%'), findsOneWidget);
    expect(find.textContaining('Mother: Hive 104 · 2025 · Blue'), findsOne);
    expect(find.text('40 larvae'), findsOneWidget);
    expect(find.text('34 cells accepted'), findsOneWidget);
    expect(find.text("Don't disturb"), findsOneWidget);
    expect(find.text('Before emergence, to 34 nucs'), findsOneWidget);
    expect(find.text('Today'), findsOneWidget);
    for (final day in ['D0', 'D1', 'D5', 'D10', 'D12', 'D24']) {
      expect(find.text(day), findsOneWidget);
    }
    // Durum ekran okuyucuda kelimeyle.
    final semantics = tester.ensureSemantics();
    expect(
      find.bySemanticsLabel(RegExp('Distribute cells.*next', dotAll: true)),
      findsOne,
    );
    expect(
      find.bySemanticsLabel(RegExp('Queen emergence.*upcoming', dotAll: true)),
      findsOne,
    );
    expect(
      find.bySemanticsLabel(RegExp('Cells capped.*done', dotAll: true)),
      findsOne,
    );
    semantics.dispose();
  });

  testWidgets('memeler kutulara dağıtılır; boş kutu yeniden kullanılır', (
    tester,
  ) async {
    tallView(tester);
    final yard = await seedYard();
    // Arılıkta önceki seriden boşaltılmış bir kutu var.
    await db
        .into(db.matingNucs)
        .insert(
          MatingNuc(
            id: 'nuc-old',
            orgId: _orgId,
            number: '1',
            apiaryId: yard.apiary.id,
            createdAt: DateTime.utc(2026),
            updatedAt: DateTime.utc(2026),
          ).toInsertable(),
        );
    final batch = await seedBatch();
    await open(tester, location: AppRoutes.rearingBatch(batch.id));

    await _tap(tester, _button('Distribute cells to nucs'));
    expect(find.text('Çam'), findsOneWidget);
    expect(find.text('Empty nucs reused: 1 · New nucs: 33'), findsOneWidget);
    await _tap(tester, _button('Distribute'));

    expect(find.text('Distributed to 34 nucs'), findsOneWidget);
    final nucs = await db.select(db.matingNucs).get();
    expect(nucs, hasLength(34));
    expect(nucs.map((nuc) => (nuc.status, nuc.rearingBatchId)).toSet(), {
      (MatingNucStatus.cell, batch.id),
    });
    expect(_button('Distribute cells to nucs'), findsNothing);
    expect(find.text('MATING NUCS'), findsOneWidget);
    expect(find.widgetWithText(StatusBadge, 'Cell'), findsWidgets);
  });

  testWidgets('kutunun içi değişir; yumurtlayan ana kovana verilir, geri '
      'alınır', (tester) async {
    tallView(tester);
    final yard = await seedYard();
    final batch = await seedBatch(motherQueenId: yard.mother.id);
    final nuc = (await repository.nucs.distribute(
      batch: batch,
      apiaryId: yard.apiary.id,
      count: 1,
    )).single;
    await open(tester, location: AppRoutes.rearingBatch(batch.id));

    await _tap(tester, find.text('Nuc 1'));
    expect(find.text('Give to a hive'), findsNothing);
    await _tap(tester, find.text('Laying'));
    expect((await repository.nucs.findById(nuc.id))!.status, isNot(nuc.status));
    expect(
      tester
          .widget<StatusBadge>(find.widgetWithText(StatusBadge, 'Laying'))
          .status,
      AppStatus.good,
    );

    await _tap(tester, find.text('Nuc 1'));
    await _tap(tester, find.text('Give to a hive'));
    expect(find.text('Which hive?'), findsOneWidget);
    await _tap(tester, find.text('Hive 7'));

    expect(find.text('Hive 7 has a new queen'), findsOneWidget);
    final hive = (await HiveRepository(db).findById(yard.hive7.id))!;
    final queen = (await QueenRepository(db).findById(hive.queenId!))!;
    expect(queen.motherQueenId, yard.mother.id);
    expect(queen.source, QueenSource.ownRearing);
    expect(queen.matingStatus, QueenMatingStatus.mated);
    expect(find.widgetWithText(StatusBadge, 'Given to a hive'), findsOneWidget);

    await tester.tap(find.text('Undo'));
    await tester.pumpAndSettle();
    expect((await HiveRepository(db).findById(yard.hive7.id))!.queenId, isNull);
    expect(find.widgetWithText(StatusBadge, 'Laying'), findsOneWidget);
  });

  testWidgets('düzenlemede kabul sayılır; silme görevleri de siler', (
    tester,
  ) async {
    tallView(tester);
    final batch = await repository.create(
      orgId: _orgId,
      graftedOn: today,
      graftedCount: 3,
      assignedTo: testUser.id,
    );
    await open(tester, location: AppRoutes.rearingBatch(batch.id));

    await _tap(tester, find.byTooltip('Edit batch'));
    expect(find.text('Edit batch'), findsOneWidget);
    await _tap(tester, find.byTooltip('Increase').at(1));
    await _tap(tester, find.byTooltip('Increase').at(1));
    await _tap(tester, _button('Save'));
    expect(find.text('Batch saved'), findsOneWidget);
    expect((await repository.findById(batch.id))!.acceptedCount, 2);
    expect(find.text('67%'), findsOneWidget);

    await _tap(tester, find.byTooltip('Edit batch'));
    await _tap(tester, _button('Delete batch'));
    await _tap(tester, find.text('Delete'));
    expect(find.text('Batch deleted'), findsOneWidget);
    expect(find.text('No batches yet'), findsOneWidget);
    expect(
      await TaskRepository(db).findBySource(TaskSource.queenRearing, batch.id),
      isEmpty,
    );
  });

  testWidgets('görev listesinde adımın adı ve "queen rearing" bağlamı', (
    tester,
  ) async {
    await repository.create(
      orgId: _orgId,
      graftedOn: inDays(-1),
      graftedCount: 40,
      assignedTo: testUser.id,
    );
    await open(tester, location: AppRoutes.tasks);

    expect(find.text('Acceptance check'), findsOneWidget);
    expect(find.textContaining('queen rearing'), findsWidgets);
  });

  testWidgets('viewer seri ekleyemez, düzenleyemez, dağıtamaz', (tester) async {
    tallView(tester);
    await addMember(db, userId: testUser.id, role: MembershipRole.viewer);
    final yard = await seedYard();
    final batch = await seedBatch();
    await repository.nucs.distribute(
      batch: batch,
      apiaryId: yard.apiary.id,
      count: 1,
    );
    await open(tester);

    expect(find.byTooltip('Add batch'), findsNothing);
    await _tap(tester, find.text('Batch 1'));
    expect(find.byTooltip('Edit batch'), findsNothing);
    expect(_button('Distribute cells to nucs'), findsNothing);
    await tester.tap(find.text('Nuc 1'));
    await tester.pumpAndSettle();
    expect(find.text('Laying'), findsNothing);
  });

  testWidgets('Türkçe metinler', (tester) async {
    tallView(tester);
    final yard = await seedYard();
    final batch = await seedBatch(motherQueenId: yard.mother.id);
    final container = await open(
      tester,
      location: AppRoutes.rearingBatch(batch.id),
    );
    container.read(languageProvider.notifier).language = AppLanguage.turkish;
    await tester.pumpAndSettle();

    expect(find.text('Ana yetiştirme · Seri 1'), findsOneWidget);
    expect(find.text('AKTARILAN'), findsOneWidget);
    expect(find.text('%85'), findsOneWidget);
    expect(find.textContaining('Anne ana: Kovan 104 · 2025 · Mavi'), findsOne);
    expect(find.text('Kabul kontrolü'), findsOneWidget);
    expect(find.text('34 meme kabul edildi'), findsOneWidget);
    expect(find.text('Memeleri dağıt'), findsOneWidget);
    expect(find.text('Çıkıştan önce, 34 kutuya'), findsOneWidget);
    expect(find.text('Bugün'), findsOneWidget);
    expect(find.text('G24'), findsOneWidget);
    expect(_button('Memeleri kutulara dağıt'), findsOneWidget);
  });

  testWidgets('360dp ekranda 1.5x yazı ve eldivenle taşmaz', (tester) async {
    tester.view
      ..physicalSize = const Size(360, 640)
      ..devicePixelRatio = 1;
    tester.platformDispatcher.textScaleFactorTestValue = 1.5;
    addTearDown(tester.view.reset);
    addTearDown(tester.platformDispatcher.clearTextScaleFactorTestValue);
    final yard = await seedYard();
    final batch = await seedBatch(motherQueenId: yard.mother.id);
    await repository.nucs.distribute(
      batch: batch,
      apiaryId: yard.apiary.id,
      count: 2,
    );

    final container = await open(
      tester,
      location: AppRoutes.rearingBatch(batch.id),
    );
    container.read(appearanceProvider.notifier).setGloveMode(enabled: true);
    await tester.pumpAndSettle();
    expect(tester.takeException(), isNull);

    await tester.scrollUntilVisible(
      find.text('Nuc 2'),
      200,
      scrollable: find.byType(Scrollable).first,
    );
    await tester.pumpAndSettle();
    expect(tester.takeException(), isNull);

    await _tap(tester, find.byTooltip('Edit batch'));
    await tester.scrollUntilVisible(
      _button('Delete batch'),
      200,
      scrollable: find.byType(Scrollable).first,
    );
    await tester.pumpAndSettle();
    expect(tester.takeException(), isNull);
  });
}
