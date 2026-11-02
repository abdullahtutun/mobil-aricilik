import 'package:drift/drift.dart' hide isNotNull, isNull;
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
import 'package:mobil_arici/features/organization/domain/membership_role.dart';
import 'package:mobil_arici/features/subsidies/domain/support_period.dart';
import 'package:mobil_arici/features/subsidies/presentation/aks_hive_count_form_screen.dart';
import 'package:mobil_arici/features/subsidies/presentation/subsidies_screen.dart';
import 'package:mobil_arici/features/tasks/data/task_repository.dart';

import '../../../helpers/fake_auth_service.dart';
import '../../../helpers/fake_organization_service.dart';
import '../../../helpers/fake_team_service.dart';
import '../../../helpers/fake_url_launcher.dart';
import '../../../helpers/test_database.dart';

final String _orgId = testOrganization.id;

Future<ProviderContainer> _open(
  WidgetTester tester, {
  required AppDatabase db,
  required String location,
  FakeUrlLauncher? urlLauncher,
  RegionConfig? region,
}) async {
  final container = ProviderContainer.test(
    overrides: [
      ...signedIn(db: db, urlLauncher: urlLauncher),
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

void main() {
  late AppDatabase db;
  final today = DateTime.now();
  final day = DateTime(today.year, today.month, today.day);

  setUpAll(initializeDateFormatting);

  Future<void> organizationRow() => db
      .into(db.organizations)
      .insert(
        OrganizationsCompanion.insert(
          id: _orgId,
          name: testOrganization.name,
          countryCode: 'TR',
          currency: 'TRY',
          createdAt: DateTime.utc(2026),
          updatedAt: DateTime.utc(2026),
        ),
      );

  Future<void> declare(int count) =>
      (db.update(db.organizations)..where((t) => t.id.equals(_orgId))).write(
        OrganizationsCompanion(trAksHiveCount: Value(count)),
      );

  Future<void> period(
    String name, {
    required int startsIn,
    required int endsIn,
    String? description,
    String? sourceUrl,
  }) => db
      .into(db.refSupportPeriods)
      .insert(
        SupportPeriod(
          id: name,
          name: name,
          applicationStartsOn: day.add(Duration(days: startsIn)),
          applicationEndsOn: day.add(Duration(days: endsIn)),
          description: description,
          sourceUrl: sourceUrl,
          createdAt: DateTime.utc(2026),
          updatedAt: DateTime.utc(2026),
        ).toInsertable(),
      );

  setUp(() async {
    db = openTestDatabase();
    await addMember(db, userId: testUser.id, role: MembershipRole.owner);
    await organizationRow();
    final apiary = await ApiaryRepository(db)
        .create(orgId: _orgId, name: 'Kızılçam');
    await HiveRepository(db).createMany(
      orgId: _orgId,
      apiaryId: apiary.id,
      numbers: ['1', '2', '3'],
      type: HiveType.langstroth,
    );
  });

  testWidgets("TR'de Daha fazla'dan açılır; dönemler açık, yaklaşan, biten "
      'sırasıyla; resmî duyuru açılır', (tester) async {
    tester.view
      ..physicalSize = const Size(800, 2400)
      ..devicePixelRatio = 1;
    addTearDown(tester.view.reset);
    await period('Biten destek', startsIn: -60, endsIn: -30);
    await period('Gelecek destek', startsIn: 20, endsIn: 50);
    await period(
      'Kovan desteği',
      startsIn: -5,
      endsIn: 10,
      description: 'Kayıtlı arıcılara kovan başı destek.',
      sourceUrl: 'https://www.tarimorman.gov.tr/',
    );
    final launcher = FakeUrlLauncher();
    await _open(
      tester,
      db: db,
      location: AppRoutes.more,
      urlLauncher: launcher,
    );

    await _tap(tester, find.text('Subsidies'));
    expect(find.byType(SubsidiesScreen), findsOneWidget);

    const names = ['Kovan desteği', 'Gelecek destek', 'Biten destek'];
    expect(
      tester
          .widgetList<Text>(
            find.descendant(
              of: find.byType(SubsidiesScreen),
              matching: find.byType(Text),
            ),
          )
          .map((text) => text.data)
          .where(names.contains),
      names,
    );
    for (final (status, label) in [
      (AppStatus.good, 'Open'),
      (AppStatus.info, 'Upcoming'),
      (AppStatus.critical, 'Closed'),
    ]) {
      final badge = tester.widget<StatusBadge>(
        find.widgetWithText(StatusBadge, label),
      );
      expect(badge.status, status, reason: label);
    }
    expect(find.text('Kayıtlı arıcılara kovan başı destek.'), findsOneWidget);
    await _tap(tester, _button('Open official notice'));
    expect(launcher.opened, [Uri.parse('https://www.tarimorman.gov.tr/')]);

    launcher.available = false;
    await _tap(tester, _button('Open official notice'));
    expect(find.text("Couldn't open the link"), findsOneWidget);
  });

  testWidgets('dönem yokken boş durum; beyan girilmemişse bilgi verir', (
    tester,
  ) async {
    await _open(tester, db: db, location: AppRoutes.subsidies);

    expect(find.text('No support periods yet'), findsOneWidget);
    expect(find.text('Not entered'), findsOneWidget);
    expect(
      find.text(
        'Enter the hive count you declared in AKS; it is compared with the '
        'app before you apply.',
      ),
      findsOneWidget,
    );
    final message = tester.widget<StatusMessage>(find.byType(StatusMessage));
    expect(message.status, AppStatus.info);
  });

  testWidgets('beyan farklıysa uyarır; owner sayıyı düzeltince tutar', (
    tester,
  ) async {
    await declare(5);
    await _open(tester, db: db, location: AppRoutes.subsidies);

    final warning = tester.widget<StatusMessage>(find.byType(StatusMessage));
    expect(warning.status, AppStatus.warning);
    expect(
      warning.message,
      'The app has 3 active hives but 5 are declared in AKS. Update your AKS '
      'record before you apply.',
    );

    await _tap(tester, _button('Enter declared count'));
    expect(find.byType(AksHiveCountFormScreen), findsOneWidget);
    final field = find.byType(TextField);
    expect(tester.widget<TextField>(field).controller!.text, '5');

    await tester.enterText(field, '100001');
    await _tap(tester, _button('Save'));
    expect(find.text('Enter a number between 0 and 100,000'), findsOneWidget);

    await tester.enterText(field, '3');
    await _tap(tester, _button('Save'));
    expect(find.byType(SubsidiesScreen), findsOneWidget);
    expect(find.text('AKS hive count saved'), findsOneWidget);
    expect(
      tester.widget<StatusMessage>(find.byType(StatusMessage)).status,
      AppStatus.good,
    );
    expect(find.text('Counts match: the app and AKS agree.'), findsOneWidget);

    final row = await db.select(db.organizations).getSingle();
    expect(row.trAksHiveCount, 3);
    final outbox = await readOutbox(db);
    expect(outbox.last.recordTable, 'organizations');
    expect(outbox.last.payload['tr_aks_hive_count'], 3);

    // Boş bırakınca beyan silinir.
    await _tap(tester, _button('Enter declared count'));
    await tester.enterText(find.byType(TextField), '');
    await _tap(tester, _button('Save'));
    expect(find.text('Not entered'), findsOneWidget);
  });

  testWidgets('işletme satırı inmemişse kaydedilemez, uyarı çıkar', (
    tester,
  ) async {
    await db.delete(db.organizations).go();
    final before = (await readOutbox(db)).length;
    await _open(tester, db: db, location: AppRoutes.aksHiveCount);

    await tester.enterText(find.byType(TextField), '3');
    await _tap(tester, _button('Save'));
    expect(
      find.text(
        "Business details haven't synced to this phone yet; wait for sync.",
      ),
      findsOneWidget,
    );
    expect(find.byType(AksHiveCountFormScreen), findsOneWidget);
    expect(await readOutbox(db), hasLength(before));
  });

  testWidgets('owner olmayan beyanı değiştiremez', (tester) async {
    await (db.update(db.memberships)
          ..where((t) => t.userId.equals(testUser.id)))
        .write(const MembershipsCompanion(role: Value(MembershipRole.worker)));
    await _open(tester, db: db, location: AppRoutes.subsidies);

    expect(_button('Enter declared count'), findsNothing);
    expect(
      find.text('Only the owner can enter the declared count.'),
      findsOneWidget,
    );
  });

  testWidgets("diğer bölgede Daha fazla'da Destekler yok", (tester) async {
    await _open(
      tester,
      db: db,
      location: AppRoutes.more,
      region: resolveRegionConfig('DE'),
    );

    expect(find.text('Finance'), findsOneWidget);
    expect(find.text('Subsidies'), findsNothing);
  });

  testWidgets('AKS görevi görev listesinde kendi başlığıyla görünür', (
    tester,
  ) async {
    // Görev ertesi güne açılır; Bugün sekmesinde görünsün diye bugüne çekilir.
    final tasks = TaskRepository(db);
    final task = await tasks.remindAksUpdate(_orgId);
    await tasks.update(task.copyWith(dueAt: DateTime.now()));
    final container = await _open(tester, db: db, location: AppRoutes.tasks);

    expect(find.text("Don't forget to update AKS"), findsOneWidget);
    container.read(languageProvider.notifier).language = AppLanguage.turkish;
    await tester.pumpAndSettle();
    expect(find.text("AKS'de güncellemeyi unutma"), findsOneWidget);
  });

  testWidgets('Türkçe metinler', (tester) async {
    await declare(5);
    await period(
      'Kovan desteği',
      startsIn: 0,
      endsIn: 10,
      sourceUrl: 'https://www.tarimorman.gov.tr/',
    );
    final container = await _open(tester, db: db, location: AppRoutes.more);
    container.read(languageProvider.notifier).language = AppLanguage.turkish;
    await tester.pumpAndSettle();
    expect(find.text('Destekler'), findsOneWidget);

    container.read(routerProvider).go(AppRoutes.subsidies);
    await tester.pumpAndSettle();
    const differs =
        "Uygulamada 3 aktif kovan var, AKS'de 5 beyan edilmiş. Başvurmadan "
        'önce AKS kaydını güncelle.';
    for (final text in [
      'Destekler',
      'BAŞVURU ÖNCESİ KONTROL',
      'UYGULAMADA AKTİF KOVAN',
      "AKS'DE BEYAN EDİLEN",
      differs,
      'Beyan edilen sayıyı gir',
      'BAŞVURU DÖNEMLERİ',
      'Başvuru açık',
      'Resmî duyuruyu aç',
    ]) {
      expect(find.text(text), findsOneWidget, reason: text);
    }

    container.read(routerProvider).go(AppRoutes.aksHiveCount);
    await tester.pumpAndSettle();
    for (final text in [
      'AKS kovan sayısı',
      "AKS'de beyan ettiğin kovan sayısı",
      'Boş bırakırsan kontrol yapılmaz.',
      'Kaydet',
    ]) {
      expect(find.text(text), findsOneWidget, reason: text);
    }
  });

  testWidgets('360dp ekranda 1.5x yazı ve eldivenle taşmaz', (tester) async {
    tester.view
      ..physicalSize = const Size(360, 640)
      ..devicePixelRatio = 1;
    tester.platformDispatcher.textScaleFactorTestValue = 1.5;
    addTearDown(tester.view.reset);
    addTearDown(tester.platformDispatcher.clearTextScaleFactorTestValue);

    await declare(12345);
    await period(
      'Arıcılık yetiştiriciliği kovan başı destekleme ödemesi başvurusu',
      startsIn: -3,
      endsIn: 400,
      description: 'Uzun açıklama ' * 20,
      sourceUrl: 'https://www.tarimorman.gov.tr/',
    );
    final container = await _open(tester, db: db, location: AppRoutes.more);
    container.read(appearanceProvider.notifier).setGloveMode(enabled: true);
    container.read(languageProvider.notifier).language = AppLanguage.turkish;
    await tester.pumpAndSettle();
    expect(tester.takeException(), isNull);

    for (final location in [AppRoutes.subsidies, AppRoutes.aksHiveCount]) {
      container.read(routerProvider).go(location);
      await tester.pumpAndSettle();
      expect(tester.takeException(), isNull, reason: location);
    }
  });
}
