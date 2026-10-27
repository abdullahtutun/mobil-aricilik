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
import 'package:mobil_arici/features/documents/data/document_repository.dart';
import 'package:mobil_arici/features/documents/domain/document.dart';
import 'package:mobil_arici/features/harvest/domain/harvest.dart';
import 'package:mobil_arici/features/hives/data/hive_repository.dart';
import 'package:mobil_arici/features/hives/domain/hive.dart';
import 'package:mobil_arici/features/migration/data/migration_repository.dart';
import 'package:mobil_arici/features/migration/domain/migration.dart';
import 'package:mobil_arici/features/organization/domain/membership_role.dart';

import '../../../helpers/fake_auth_service.dart';
import '../../../helpers/fake_organization_service.dart';
import '../../../helpers/fake_team_service.dart';
import '../../../helpers/test_database.dart';

final String _orgId = testOrganization.id;

Finder _button(String label) => find.widgetWithText(BigButton, label);

Finder _field(String label) => find.descendant(
  of: find.byWidgetPredicate((w) => w is LabeledField && w.label == label),
  matching: find.byType(TextField),
);

/// Kovan sayısı alanı (InlineField).
Finder get _hiveCount => find.descendant(
  of: find.byWidgetPredicate((w) => w is InlineField && w.label == 'Hives'),
  matching: find.byType(TextField),
);

String _hiveCountText(WidgetTester tester) =>
    tester.widget<TextField>(_hiveCount).controller!.text;

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
  late MigrationRepository repository;
  final today = DateUtils.dateOnly(DateTime.now());
  DateTime inDays(int days) =>
      DateTime(today.year, today.month, today.day + days);

  setUp(() {
    db = openTestDatabase();
    repository = MigrationRepository(db);
  });

  Future<ProviderContainer> open(
    WidgetTester tester, {
    String location = AppRoutes.migrations,
    RegionConfig? region,
  }) async {
    final container = ProviderContainer.test(
      overrides: [
        ...signedIn(db: db),
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

  /// Çam (şu an) → Kışlak (12 gün sonra) planı; Çam arılığının geçen yıl
  /// 2 kovandan 52 kg hasadı var, Kışlak arılığının hasadı yok.
  Future<Migration> seedPlan() async {
    final apiaries = ApiaryRepository(db);
    final cam = await apiaries.create(orgId: _orgId, name: 'Çam arılığı');
    final kislak = await apiaries.create(orgId: _orgId, name: 'Kışlak');
    final at = DateTime(today.year - 1, 8, 20);
    await db
        .into(db.harvests)
        .insert(
          Harvest(
            id: 'harvest-1',
            orgId: _orgId,
            apiaryId: cam.id,
            harvestedAt: at,
            honeyKind: HoneyKind.pine,
            unit: HarvestUnit.superBox,
            unitCount: 4,
            netKg: 52,
            createdAt: at,
            updatedAt: at,
          ).toInsertable(),
        );
    for (final hive in ['hive-1', 'hive-2']) {
      await db
          .into(db.harvestHives)
          .insert(
            HarvestHive(
              id: 'harvest-$hive',
              orgId: _orgId,
              harvestId: 'harvest-1',
              hiveId: hive,
              createdAt: at,
              updatedAt: at,
            ).toInsertable(),
          );
    }

    final migration = await repository.create(
      orgId: _orgId,
      year: today.year,
      name: 'Göç planı',
    );
    Future<void> stop(
      int position,
      String name,
      String place,
      MigrationStopStatus status, {
      required int startDays,
      String? apiaryId,
    }) => repository.stops.create(
      orgId: _orgId,
      migrationId: migration.id,
      plan: (
        position: position,
        name: name,
        place: place,
        plannedStartOn: inDays(startDays),
        plannedEndOn: inDays(startDays + 60),
        apiaryId: apiaryId,
        hiveCount: 152,
        status: status,
      ),
    );
    await stop(
      1,
      'Yayla',
      'Kale, Denizli',
      MigrationStopStatus.past,
      startDays: -120,
    );
    await stop(
      2,
      'Çam',
      'Ula, Muğla',
      MigrationStopStatus.current,
      startDays: -60,
      apiaryId: cam.id,
    );
    await stop(
      3,
      'Kışlak',
      'Köyceğiz, Muğla',
      MigrationStopStatus.planned,
      startDays: 12,
      apiaryId: kislak.id,
    );
    return migration;
  }

  Future<void> seedDocuments() async {
    final documents = DocumentRepository(db);
    Future<void> add(DocumentType type, String name, DateTime? expiresOn) =>
        documents.create(
          orgId: _orgId,
          type: type,
          name: name,
          expiresOn: expiresOn,
          file: (
            fileId: 'file-$name',
            kind: DocumentFileKind.photo,
            byteSize: 1,
          ),
        );
    await add(DocumentType.transportPermit, 'Nakil', inDays(200));
    await add(DocumentType.healthReport, 'Sağlık', inDays(5));
  }

  testWidgets("Daha fazla'dan açılır; plan, durak ve hedef arılık eklenir", (
    tester,
  ) async {
    final apiary = await ApiaryRepository(db)
        .create(orgId: _orgId, name: 'Çam arılığı');
    await HiveRepository(db).createMany(
      orgId: _orgId,
      apiaryId: apiary.id,
      numbers: ['1', '2', '3'],
      type: HiveType.langstroth,
    );
    await open(tester, location: AppRoutes.more);

    await _tap(tester, find.text('Migration plans'));
    expect(find.text('No migration plan yet'), findsOneWidget);
    await _tap(tester, _button('New plan'));

    expect(
      tester.widget<TextField>(_field('Name')).controller!.text,
      'Migration plan',
    );
    expect(find.text('${today.year}'), findsOneWidget);
    await _tap(tester, _button('Save'));

    expect(find.text('Migration plan ${today.year}'), findsOneWidget);
    expect(find.text('No stops yet'), findsOneWidget);
    await _tap(tester, _button('Add stop'));

    expect(tester.widget<BigButton>(_button('Save')).onPressed, isNull);
    await tester.enterText(_field('Source'), 'Pine');
    await tester.enterText(_field('Place'), 'Ula, Muğla');
    // Arılık yokken kovan sayısı elle girilir.
    expect(_hiveCountText(tester), isEmpty);
    await tester.enterText(_hiveCount, '40');
    // Arılık seçilince arılığın aktif kovan sayısıyla dolar, düzenlenebilir.
    await _tap(tester, find.text('Target apiary'));
    await _tap(tester, find.text('Çam arılığı'));
    expect(_hiveCountText(tester), '3');
    await tester.enterText(_hiveCount, '5');
    await _tap(tester, find.text('Here now'));
    await _tap(tester, _button('Save'));

    final stop = (await db.select(db.migrationStops).get()).single;
    expect(stop.name, 'Pine');
    expect(stop.place, 'Ula, Muğla');
    expect(stop.apiaryId, apiary.id);
    expect(stop.hiveCount, 5);
    expect(stop.status, MigrationStopStatus.current);
    expect(stop.position, 1);

    // Zaman çizelgesine döner; planlı durak yokken taşıma başlatılamaz.
    expect(find.text('Pine'), findsOneWidget);
    expect(find.text('Ula, Muğla · 5 hives'), findsOneWidget);
    expect(find.text("You're here"), findsOneWidget);
    expect(find.text('No past harvest at this apiary'), findsOneWidget);
    expect(tester.widget<BigButton>(_button('Start move')).onPressed, isNull);

    // Arılıksız durağın kovan sayısı elle; yeri yoksa kartta adı yazar.
    // "Durak kaydedildi" bildirimi alttaki butonları örtüyor; kapanması
    // beklenir.
    await tester.pump(const Duration(seconds: 10));
    await tester.pumpAndSettle();
    await _tap(tester, _button('Add stop'));
    expect(find.text('2'), findsOneWidget);
    await tester.enterText(_field('Source'), 'Winter yard');
    await tester.enterText(_hiveCount, '148');
    await _tap(tester, _button('Save'));
    final winter = (await db.select(db.migrationStops).get()).firstWhere(
      (s) => s.name == 'Winter yard',
    );
    expect(winter.hiveCount, 148);
    expect(winter.apiaryId, isNull);
    expect(find.text('Pine → Winter yard'), findsOneWidget);
    expect(find.text('Ula → Winter yard · 148 hives'), findsOneWidget);
  });

  testWidgets('zaman çizelgesi: sıradaki taşıma kartı, TR belgeleri renk + '
      'kelimeyle, durakların geçmiş yıl verimi', (tester) async {
    tester.view
      ..physicalSize = const Size(800, 2400)
      ..devicePixelRatio = 1;
    addTearDown(tester.view.reset);
    final migration = await seedPlan();
    await seedDocuments();
    await open(tester, location: AppRoutes.migration(migration.id));

    expect(find.text('Göç planı ${today.year}'), findsOneWidget);
    expect(find.text('NEXT MOVE · 12 DAYS'), findsOneWidget);
    expect(find.text('Çam → Kışlak'), findsOneWidget);
    expect(find.text('Ula → Köyceğiz · 152 hives'), findsOneWidget);
    expect(
      find.widgetWithText(StatusBadge, 'Transport permit ready'),
      findsOneWidget,
    );
    final health = tester.widget<StatusBadge>(
      find.widgetWithText(StatusBadge, 'Health report 5 days'),
    );
    expect(health.status, AppStatus.critical);
    expect(
      tester
          .widget<StatusBadge>(
            find.widgetWithText(
              StatusBadge,
              'Migratory beekeeper certificate missing',
            ),
          )
          .status,
      AppStatus.warning,
    );

    expect(find.text('Yayla'), findsOneWidget);
    expect(find.text('Kale, Denizli · 152 hives'), findsOneWidget);
    expect(find.text("You're here"), findsOneWidget);
    expect(
      find.text('Past yield · ${today.year - 1}: 26 kg/hive'),
      findsOneWidget,
    );
    expect(find.text('No past harvest at this apiary'), findsOneWidget);

    // Evrak belge kasasını açar, geri tuşu plana döner.
    await _tap(tester, find.text('Documents'));
    expect(find.text('Document vault'), findsOneWidget);
    await _tap(tester, find.byTooltip('Back'));
    expect(find.text('Çam → Kışlak'), findsOneWidget);

    // Taşıma başlat sıradaki taşımayı açar.
    await _tap(tester, _button('Start move'));
    expect(find.text('Move · Çam → Kışlak'), findsOneWidget);
    expect(find.text('Loading is coming soon'), findsOneWidget);
    await _tap(tester, find.byTooltip('Back'));
    expect(find.text('Çam → Kışlak'), findsOneWidget);
  });

  testWidgets('diğer bölgede kartta belge durumu yok', (tester) async {
    final migration = await seedPlan();
    await seedDocuments();
    await open(
      tester,
      location: AppRoutes.migration(migration.id),
      region: resolveRegionConfig('DE'),
    );

    expect(find.text('Çam → Kışlak'), findsOneWidget);
    expect(find.byType(StatusBadge), findsOneWidget);
    expect(find.text("You're here"), findsOneWidget);
  });

  testWidgets('durak düzenlenir: şu an yapılınca önceki geçmiş olur ve kart '
      'kalkar; durak silinir', (tester) async {
    tester.view
      ..physicalSize = const Size(800, 2400)
      ..devicePixelRatio = 1;
    addTearDown(tester.view.reset);
    final migration = await seedPlan();
    await open(tester, location: AppRoutes.migration(migration.id));

    await _tap(tester, find.text('Kışlak'));
    expect(find.text('Edit stop'), findsOneWidget);
    await _tap(tester, find.text('Here now'));
    await _tap(tester, _button('Save'));

    final stops = await repository.stops.findByMigration(migration.id);
    final byName = {for (final s in stops) s.name: s.status};
    expect(byName, {
      'Yayla': MigrationStopStatus.past,
      'Çam': MigrationStopStatus.past,
      'Kışlak': MigrationStopStatus.current,
    });
    expect(find.textContaining('NEXT MOVE'), findsNothing);
    expect(tester.widget<BigButton>(_button('Start move')).onPressed, isNull);

    await _tap(tester, find.text('Yayla'));
    await _tap(tester, _button('Delete stop'));
    await _tap(tester, find.text('Delete'));
    expect(find.text('Yayla'), findsNothing);
    expect(await repository.stops.findByMigration(migration.id), hasLength(2));
  });

  testWidgets('viewer plan ve durak ekleyemez, düzenleyemez', (tester) async {
    await addMember(db, userId: testUser.id, role: MembershipRole.viewer);
    final migration = await seedPlan();
    await open(tester);

    expect(find.byTooltip('New plan'), findsNothing);
    await _tap(tester, find.text('Göç planı ${today.year}'));
    expect(find.text('Çam → Kışlak'), findsOneWidget);
    expect(find.byTooltip('Edit plan'), findsNothing);
    expect(_button('Add stop'), findsNothing);
    expect(_button('Start move'), findsNothing);
    await tester.tap(find.text('Kışlak'));
    await tester.pumpAndSettle();
    expect(find.text('Edit stop'), findsNothing);
    expect(migration.id, isNotEmpty);
  });

  testWidgets('Türkçe metinler', (tester) async {
    tester.view
      ..physicalSize = const Size(800, 2400)
      ..devicePixelRatio = 1;
    addTearDown(tester.view.reset);
    final migration = await seedPlan();
    await seedDocuments();
    final container = await open(
      tester,
      location: AppRoutes.migration(migration.id),
    );
    container.read(languageProvider.notifier).language = AppLanguage.turkish;
    await tester.pumpAndSettle();

    expect(find.text('SIRADAKİ TAŞIMA · 12 GÜN'), findsOneWidget);
    expect(find.text('Ula → Köyceğiz · 152 kovan'), findsOneWidget);
    expect(find.text('Nakil evrakı hazır'), findsOneWidget);
    expect(find.text('Sağlık raporu 5 gün'), findsOneWidget);
    expect(find.text('Gezginci arıcı belgesi yok'), findsOneWidget);
    expect(find.text('Şu an burada'), findsOneWidget);
    expect(
      find.text('Geçmiş verim · ${today.year - 1}: 26 kg/kovan'),
      findsOneWidget,
    );
    expect(find.text('Evrak'), findsOneWidget);
    expect(_button('Durak ekle'), findsOneWidget);
    expect(_button('Taşıma başlat'), findsOneWidget);

    await _tap(tester, _button('Durak ekle'));
    expect(find.text('Yeni durak'), findsOneWidget);
    expect(find.text('Hedef arılık'), findsOneWidget);
    expect(find.text('Plan'), findsOneWidget);
  });

  testWidgets('360dp ekranda 1.5x yazı ve eldivenle taşmaz', (tester) async {
    tester.view
      ..physicalSize = const Size(360, 640)
      ..devicePixelRatio = 1;
    tester.platformDispatcher.textScaleFactorTestValue = 1.5;
    addTearDown(tester.view.reset);
    addTearDown(tester.platformDispatcher.clearTextScaleFactorTestValue);
    final migration = await seedPlan();
    await seedDocuments();

    final container = await open(
      tester,
      location: AppRoutes.migration(migration.id),
    );
    container.read(appearanceProvider.notifier).setGloveMode(enabled: true);
    await tester.pumpAndSettle();
    expect(tester.takeException(), isNull);

    await _tap(tester, find.text('Kışlak'));
    await tester.scrollUntilVisible(
      _button('Delete stop'),
      200,
      scrollable: find.byType(Scrollable).first,
    );
    await tester.pumpAndSettle();
    expect(tester.takeException(), isNull);
  });
}
