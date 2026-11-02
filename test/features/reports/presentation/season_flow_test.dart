import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:mobil_arici/app/app.dart';
import 'package:mobil_arici/app/router.dart';
import 'package:mobil_arici/app/routes.dart';
import 'package:mobil_arici/app/shell/more_screen.dart';
import 'package:mobil_arici/core/db/app_database.dart';
import 'package:mobil_arici/core/design_system/design_system.dart';
import 'package:mobil_arici/core/l10n/app_language.dart';
import 'package:mobil_arici/core/l10n/language_provider.dart';
import 'package:mobil_arici/features/apiaries/data/apiary_repository.dart';
import 'package:mobil_arici/features/finance/data/transaction_repository.dart';
import 'package:mobil_arici/features/finance/domain/finance_transaction.dart';
import 'package:mobil_arici/features/health/domain/drug.dart';
import 'package:mobil_arici/features/health/domain/treatment.dart';
import 'package:mobil_arici/features/hives/data/hive_repository.dart';
import 'package:mobil_arici/features/hives/domain/hive.dart';
import 'package:mobil_arici/features/hives/domain/hive_status_event.dart';
import 'package:mobil_arici/features/organization/domain/membership_role.dart';
import 'package:mobil_arici/features/reports/presentation/season_screen.dart';
import 'package:mobil_arici/features/reports/presentation/widgets/season_labels.dart';

import '../../../helpers/fake_auth_service.dart';
import '../../../helpers/fake_organization_service.dart';
import '../../../helpers/fake_print_service.dart';
import '../../../helpers/fake_share_service.dart';
import '../../../helpers/fake_team_service.dart';
import '../../../helpers/test_database.dart';

final String _orgId = testOrganization.id;
final int _year = DateTime.now().year;

Future<ProviderContainer> _open(
  WidgetTester tester, {
  required AppDatabase db,
  required String location,
  FakePrintService? printer,
  FakeShareService? share,
}) async {
  final container = ProviderContainer.test(
    overrides: signedIn(db: db, printer: printer, share: share),
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

  setUpAll(initializeDateFormatting);

  setUp(() async {
    db = openTestDatabase();
    final apiaries = ApiaryRepository(db);
    final yayla = await apiaries.create(orgId: _orgId, name: 'Yayla');
    final ova = await apiaries.create(orgId: _orgId, name: 'Ova');

    // Kovanlar geçen yaz kuruldu; kışa aktif girdiler.
    final hives = HiveRepository(db, clock: () => DateTime(_year - 1, 6));
    final yaylaHives = await hives.createMany(
      orgId: _orgId,
      apiaryId: yayla.id,
      numbers: [for (var n = 101; n <= 112; n++) '$n'],
      type: HiveType.langstroth,
    );
    final ovaHives = await hives.createMany(
      orgId: _orgId,
      apiaryId: ova.id,
      numbers: ['201', '202', '203'],
      type: HiveType.langstroth,
    );

    // Yayla kovanları kıştan önce amitrazla ilaçlandı.
    final treatedAt = DateTime.utc(_year - 1, 9);
    for (final hive in yaylaHives) {
      await db
          .into(db.treatments)
          .insert(
            Treatment(
              id: 'treatment-${hive.id}',
              orgId: _orgId,
              hiveId: hive.id,
              apiaryId: yayla.id,
              productName: 'Amitraz şerit',
              activeIngredient: DrugActiveIngredient.amitraz,
              dose: 2,
              doseUnit: DrugDoseUnit.strip,
              startedAt: treatedAt,
              withdrawalDays: 0,
              createdAt: treatedAt,
              updatedAt: treatedAt,
            ).toInsertable(),
          );
    }

    // Kışta üç kayıp.
    await HiveRepository(db, clock: () => DateTime(_year, 1, 15)).setStatus(
      yaylaHives.first.id,
      HiveStatus.dead,
      lossReason: HiveLossReason.wintering,
    );
    final february = HiveRepository(db, clock: () => DateTime(_year, 2, 10));
    await february.setStatus(
      ovaHives[0].id,
      HiveStatus.dead,
      lossReason: HiveLossReason.varroa,
    );
    await february.setStatus(
      ovaHives[1].id,
      HiveStatus.lost,
      lossReason: HiveLossReason.predator,
    );
  });

  testWidgets('Daha fazla > Sezon raporu: karolar, kayıplar, kış kaybı '
      'karşılaştırması ve maliyet; PDF yazdırılır, CSV paylaşılır', (
    tester,
  ) async {
    await addMember(db, userId: testUser.id, role: MembershipRole.partner);
    await TransactionRepository(db).create(
      orgId: _orgId,
      kind: TransactionKind.expense,
      category: TransactionCategory.feeding,
      amount: 12000,
      currency: 'TRY',
      occurredOn: DateTime.now(),
    );
    final printer = FakePrintService();
    final share = FakeShareService();
    await _open(
      tester,
      db: db,
      location: AppRoutes.more,
      printer: printer,
      share: share,
    );

    await _tap(tester, find.text('Season report'));
    expect(find.byType(SeasonScreen), findsOneWidget);
    expect(find.text('Season $_year'), findsOneWidget);

    expect(find.text('15 → 12'), findsOneWidget);
    expect(find.text('−3 net'), findsOneWidget);
    expect(find.text('20%'), findsOneWidget);
    expect(find.text('Losses and causes'), findsOneWidget);
    expect(find.text('3 hives'), findsOneWidget);
    for (final reason in ['Wintering', 'Varroa', 'Bear / animal']) {
      expect(find.text(reason), findsOneWidget);
    }

    // Mücadele yöntemine göre: amitraz 1/12, ilaçlanmayan 2/3 (az veri).
    expect(find.text('Winter loss · by treatment method'), findsOneWidget);
    expect(find.text('Amitraz'), findsOneWidget);
    expect(find.text('8%'), findsOneWidget);
    expect(find.text('Not treated'), findsOneWidget);
    expect(find.text('67%'), findsOneWidget);
    expect(find.text('3 hives · few data'), findsOneWidget);
    expect(
      find.text('From your own records; may be misleading with few hives.'),
      findsOneWidget,
    );

    await _tap(tester, find.text('Apiary').last);
    expect(find.text('Winter loss · by apiary'), findsOneWidget);
    expect(find.text('Yayla'), findsOneWidget);
    expect(find.text('Ova'), findsOneWidget);

    await _tap(tester, find.text('Queen line').last);
    expect(find.text('Unknown line'), findsOneWidget);
    expect(find.text('15 hives'), findsOneWidget);

    await tester.scrollUntilVisible(
      find.text('Cost and profit'),
      200,
      scrollable: find.byType(Scrollable).first,
    );
    expect(find.text('Cost and profit'), findsOneWidget);

    await tester.tap(find.text('PDF'));
    await tester.pumpAndSettle();
    expect(printer.printed.single.name, 'Season $_year');

    await tester.tap(find.byTooltip('Export to Excel (CSV)'));
    await tester.pumpAndSettle();
    final file = share.files.single;
    expect(file.filename, 'Season $_year.csv');
    expect(file.mimeType, 'text/csv');
    final text = utf8.decode(file.bytes.skip(3).toList());
    expect(text, startsWith('Hive,Apiary,'));
    expect(text, contains('201,Ova,Active,Dead,'));
    expect(text, contains('Varroa'));
  });

  testWidgets('worker maliyet ve kârı görmez', (tester) async {
    await addMember(db, userId: testUser.id, role: MembershipRole.worker);
    await _open(tester, db: db, location: AppRoutes.season);

    await tester.drag(find.byType(Scrollable).first, const Offset(0, -2000));
    await tester.pumpAndSettle();
    expect(find.text('Cost and profit'), findsNothing);
    expect(find.text('Losses and causes'), findsOneWidget);
  });

  testWidgets('Türkçe metinler; CSV noktalı virgülle', (tester) async {
    final share = FakeShareService();
    final container = await _open(
      tester,
      db: db,
      location: AppRoutes.season,
      share: share,
    );
    container.read(languageProvider.notifier).language = AppLanguage.turkish;
    await tester.pumpAndSettle();

    expect(find.text('Sezon $_year'), findsOneWidget);
    expect(find.text('KOVAN'), findsOneWidget);
    expect(find.text('KIŞ KAYBI'), findsOneWidget);
    expect(find.text('Kayıplar ve nedenleri'), findsOneWidget);
    expect(find.text('Kışlama'), findsOneWidget);
    expect(find.text('Ayı / hayvan'), findsOneWidget);
    expect(find.text('Kış kaybı · mücadele yöntemine göre'), findsOneWidget);
    expect(find.text('İlaçlanmadı'), findsOneWidget);
    expect(find.text('3 kovan · az veri'), findsOneWidget);
    expect(
      find.text('Kendi kayıtlarından; az kovanda yanıltıcı olabilir.'),
      findsOneWidget,
    );

    await tester.tap(find.byTooltip("Excel'e aktar (CSV)"));
    await tester.pumpAndSettle();
    final text = utf8.decode(share.files.single.bytes.skip(3).toList());
    expect(text, startsWith('Kovan;Arılık;'));
    expect(text, contains('Ayı / hayvan'));
  });

  testWidgets('360dp ekranda 1.5x yazı ve eldivenle taşmaz', (tester) async {
    tester.view
      ..physicalSize = const Size(360, 640)
      ..devicePixelRatio = 1;
    tester.platformDispatcher.textScaleFactorTestValue = 1.5;
    addTearDown(tester.view.reset);
    addTearDown(tester.platformDispatcher.clearTextScaleFactorTestValue);
    await addMember(db, userId: testUser.id, role: MembershipRole.owner);

    final container = await _open(tester, db: db, location: AppRoutes.more);
    container.read(appearanceProvider.notifier).setGloveMode(enabled: true);
    container.read(languageProvider.notifier).language = AppLanguage.turkish;
    await tester.pumpAndSettle();
    await tester.scrollUntilVisible(
      find.text('Sezon raporu'),
      200,
      scrollable: find
          .descendant(
            of: find.byType(MoreScreen),
            matching: find.byType(Scrollable),
          )
          .first,
    );
    expect(tester.takeException(), isNull);

    container.read(routerProvider).go(AppRoutes.season);
    await tester.pumpAndSettle();
    expect(tester.takeException(), isNull);
    // Liste tembel; sekmeler ekrana gelince kurulur.
    await tester.scrollUntilVisible(
      find.byType(SegmentedTabs<WinterComparison>),
      200,
      scrollable: find.byType(Scrollable).first,
    );
    for (final tab in ['Arılık', 'Ana hattı']) {
      await _tap(tester, find.text(tab).last);
      expect(tester.takeException(), isNull);
    }
    await tester.drag(find.byType(Scrollable).first, const Offset(0, -3000));
    await tester.pumpAndSettle();
    expect(tester.takeException(), isNull);
  });
}
