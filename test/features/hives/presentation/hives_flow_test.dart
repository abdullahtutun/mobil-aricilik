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
import 'package:mobil_arici/features/hives/data/hive_location_repository.dart';
import 'package:mobil_arici/features/hives/data/hive_repository.dart';
import 'package:mobil_arici/features/hives/domain/hive.dart';
import 'package:mobil_arici/features/hives/presentation/bulk_hive_form_screen.dart';
import 'package:mobil_arici/features/hives/presentation/hive_card_screen.dart';
import 'package:mobil_arici/features/hives/presentation/hive_form_screen.dart';

import '../../../helpers/fake_auth_service.dart';
import '../../../helpers/fake_organization_service.dart';
import '../../../helpers/test_database.dart';

final String _orgId = testOrganization.id;

/// İşletmesi olan kullanıcıyla uygulamayı açar ve [location]'a gider.
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
  await tester.ensureVisible(finder);
  await tester.pumpAndSettle();
  await tester.tap(finder);
  await tester.pumpAndSettle();
}

Future<void> _enter(WidgetTester tester, String label, String text) async {
  await tester.enterText(find.widgetWithText(TextField, label), text);
  await tester.pump();
}

BigButton _button(WidgetTester tester, String label) =>
    tester.widget<BigButton>(find.widgetWithText(BigButton, label));

void main() {
  late AppDatabase db;
  late HiveRepository hives;
  late HiveLocationRepository locations;
  late Apiary yayla;

  setUp(() async {
    db = openTestDatabase();
    hives = HiveRepository(db);
    locations = HiveLocationRepository(db);
    yayla = await ApiaryRepository(db).create(orgId: _orgId, name: 'Yayla');
  });

  Future<Hive> createHive(
    String number, {
    HiveStatus status = HiveStatus.active,
    HiveSource? source,
    String? apiaryId,
  }) => hives.create(
    orgId: _orgId,
    number: number,
    type: HiveType.langstroth,
    apiaryId: apiaryId ?? yayla.id,
    status: status,
    source: source,
  );

  Future<List<Hive>> savedHives() => db.select(db.hives).get();

  group('Arılıkta kovanlar', () {
    testWidgets("boş arılıkta toplu oluşturma: 20 kovan, 101'den", (
      tester,
    ) async {
      await _open(tester, db: db, location: AppRoutes.apiary(yayla.id));
      expect(find.text('No hives yet'), findsOneWidget);
      expect(find.byType(FloatingActionButton), findsNothing);

      await _tap(tester, find.widgetWithText(BigButton, 'Add hives'));
      expect(find.text('One hive'), findsOneWidget);
      await _tap(tester, find.text('Many at once'));

      expect(find.byType(BulkHiveFormScreen), findsOneWidget);
      expect(_button(tester, 'Create hives').onPressed, isNull);
      await _enter(tester, 'How many hives', '20');
      await _enter(tester, 'First number', '101');
      expect(
        find.text('20 hives will be created: 101 to 120.'),
        findsOneWidget,
      );
      await _tap(tester, find.text('Local'));
      await _tap(tester, find.text('Swarm'));
      await _tap(tester, find.text('Create hives'));

      expect(find.byType(ApiaryDetailScreen), findsOneWidget);
      expect(find.text('20 hives created'), findsOneWidget);
      expect(find.byType(HiveTile), findsNWidgets(20));
      // Üstteki aktif kovan sayısı.
      expect(find.text('20'), findsOneWidget);
      expect(
        find.widgetWithText(FloatingActionButton, 'Add hives'),
        findsOneWidget,
      );
      final first = tester.getTopLeft(find.text('101'));
      final second = tester.getTopLeft(find.text('102'));
      final last = tester.getTopLeft(find.text('120'));
      expect(second.dy, first.dy);
      expect(second.dx, greaterThan(first.dx));
      expect(last.dy, greaterThan(first.dy));

      final saved = await savedHives();
      expect(saved, hasLength(20));
      expect(saved.every((h) => h.type == HiveType.local), isTrue);
      expect(saved.every((h) => h.source == HiveSource.swarm), isTrue);
      expect(await db.select(db.hiveLocationHistory).get(), hasLength(20));
    });

    testWidgets('500 üstü kovan istenince uyarılır, kaydedilmez', (
      tester,
    ) async {
      await _open(tester, db: db, location: AppRoutes.hivesBulk(yayla.id));

      await _enter(tester, 'How many hives', '501');
      await _enter(tester, 'First number', '1');

      expect(find.text('At most 500 at once'), findsOneWidget);
      expect(_button(tester, 'Create hives').onPressed, isNull);
    });

    testWidgets('tek kovan eklenir, kartı açılır; geri arılığa döner', (
      tester,
    ) async {
      await createHive('101');
      await _open(tester, db: db, location: AppRoutes.apiary(yayla.id));

      await _tap(
        tester,
        find.widgetWithText(FloatingActionButton, 'Add hives'),
      );
      await _tap(tester, find.text('One hive'));

      expect(find.byType(HiveFormScreen), findsOneWidget);
      expect(find.text('New hive'), findsOneWidget);
      expect(_button(tester, 'Save').onPressed, isNull);
      await _enter(tester, 'Hive number', ' 7 ');
      await _tap(tester, find.text('Dadant'));
      await _tap(tester, find.text('Split'));
      await _tap(tester, find.text('Save'));

      expect(find.byType(HiveCardScreen), findsOneWidget);
      expect(find.text('7'), findsOneWidget);
      expect(find.text('Yayla'), findsOneWidget);
      expect(find.text('Active'), findsOneWidget);
      expect(find.text('Queen'), findsOneWidget);
      expect(
        find.text('No queen recorded yet. Queen cards are coming soon.'),
        findsOneWidget,
      );

      await tester.pageBack();
      await tester.pumpAndSettle();
      expect(find.byType(ApiaryDetailScreen), findsOneWidget);
      expect(find.byType(HiveTile), findsNWidgets(2));
      final saved = (await savedHives()).firstWhere((h) => h.number == '7');
      expect(saved.type, HiveType.dadant);
      expect(saved.source, HiveSource.split);
    });

    testWidgets('ızgara ve liste; numaralar sayı sırasıyla, aktif olmayanlar '
        'ayrı', (tester) async {
      await createHive('10');
      await createHive('9', source: HiveSource.swarm);
      await createHive('101');
      await createHive('5', status: HiveStatus.dead);
      await createHive('6', status: HiveStatus.sold);
      await _open(tester, db: db, location: AppRoutes.apiary(yayla.id));

      // Üstte yalnız aktifler sayılır.
      expect(find.text('3'), findsOneWidget);
      expect(find.byType(HiveTile), findsNWidgets(5));
      final x = [
        for (final n in ['9', '10', '101']) tester.getTopLeft(find.text(n)).dx,
      ];
      expect(x, [...x]..sort());
      expect(find.text('Not active (2)'), findsOneWidget);
      expect(
        tester.getTopLeft(find.text('5')).dy,
        greaterThan(tester.getTopLeft(find.text('Not active (2)')).dy),
      );
      // Karoda durum ikonla, kelimesi ekran okuyucuda.
      final deadTile = tester.widget<HiveTile>(
        find.ancestor(of: find.text('5'), matching: find.byType(HiveTile)),
      );
      expect(deadTile.alertStatus, AppStatus.critical);
      expect(deadTile.alertLabel, 'Dead');
      expect(
        tester.getSemantics(find.byTooltip('Grid view')),
        isSemantics(isSelected: true, isButton: true),
      );

      await _tap(tester, find.byTooltip('List view'));

      expect(find.byType(HiveTile), findsNothing);
      expect(find.text('Langstroth · Swarm'), findsOneWidget);
      expect(find.text('Langstroth'), findsNWidgets(4));
      expect(find.widgetWithText(StatusBadge, 'Dead'), findsOneWidget);
      expect(find.widgetWithText(StatusBadge, 'Sold'), findsOneWidget);
      expect(
        tester.getSemantics(find.byTooltip('List view')),
        isSemantics(isSelected: true, isButton: true),
      );

      await _tap(tester, find.text('9'));
      expect(find.byType(HiveCardScreen), findsOneWidget);
      await tester.pageBack();
      await tester.pumpAndSettle();
      // Seçim kalır.
      expect(find.byType(HiveTile), findsNothing);
    });
  });

  group('Kovan kartı', () {
    testWidgets('başka arılığa taşınır, geçmişe yazılır; geri alınır', (
      tester,
    ) async {
      final ova = await ApiaryRepository(db).create(orgId: _orgId, name: 'Ova');
      final hive = await createHive('101');
      await _open(tester, db: db, location: AppRoutes.hive(yayla.id, hive.id));
      expect(find.text('Yayla'), findsOneWidget);

      await _tap(tester, find.text('Move to another apiary'));
      expect(find.text('Move hive 101 to'), findsOneWidget);
      // Bulunduğu arılık listede yok.
      expect(find.text('Yayla'), findsOneWidget);
      await _tap(tester, find.text('Ova'));

      expect(find.text('Hive 101 moved to Ova'), findsOneWidget);
      expect(find.text('Ova'), findsOneWidget);
      expect((await hives.findById(hive.id))!.apiaryId, ova.id);
      expect(
        (await db.select(db.hiveLocationHistory).get()).map((e) => e.apiaryId),
        [yayla.id, ova.id],
      );

      await _tap(tester, find.text('Undo'));

      expect(find.text('Yayla'), findsOneWidget);
      expect((await hives.findById(hive.id))!.apiaryId, yayla.id);
      final live = await tester.runAsync(
        () => locations.watchByHive(hive.id).first,
      );
      expect(live!.map((e) => e.apiaryId), [yayla.id]);
    });

    testWidgets('taşınacak başka arılık yoksa söylenir', (tester) async {
      final hive = await createHive('101');
      await _open(tester, db: db, location: AppRoutes.hive(yayla.id, hive.id));

      await _tap(tester, find.text('Move to another apiary'));

      expect(
        find.text(
          "There's no other apiary to move it to. "
          'Add one from the Apiaries tab first.',
        ),
        findsOneWidget,
      );
    });

    testWidgets('söndü onay ister; vazgeçilirse yazılmaz', (tester) async {
      final hive = await createHive('101');
      await _open(tester, db: db, location: AppRoutes.hive(yayla.id, hive.id));

      await _tap(tester, find.text('Change status'));
      expect(find.text('New status for hive 101'), findsOneWidget);
      expect(find.text('Active'), findsOneWidget); // yalnız rozet
      await _tap(tester, find.text('Dead'));

      expect(find.text('Record hive 101 as dead?'), findsOneWidget);
      expect(
        find.text(
          "It will no longer count among the apiary's active hives. "
          'You can make it active again later.',
        ),
        findsOneWidget,
      );
      await _tap(tester, find.text('Cancel'));
      expect((await hives.findById(hive.id))!.status, HiveStatus.active);
      expect(find.widgetWithText(StatusBadge, 'Active'), findsOneWidget);

      await _tap(tester, find.text('Change status'));
      await _tap(tester, find.text('Dead'));
      await _tap(tester, find.text('Yes, record'));

      expect((await hives.findById(hive.id))!.status, HiveStatus.dead);
      expect(find.widgetWithText(StatusBadge, 'Dead'), findsOneWidget);
      // Onaylanan kayıtta geri al yok.
      expect(find.text('Undo'), findsNothing);
    });

    testWidgets('birleşti, satıldı ve kayboldu da onay ister', (tester) async {
      final hive = await createHive('101');
      await _open(tester, db: db, location: AppRoutes.hive(yayla.id, hive.id));

      for (final (label, question) in [
        ('Merged', 'Record hive 101 as merged?'),
        ('Sold', 'Record hive 101 as sold?'),
        ('Lost', 'Record hive 101 as lost?'),
      ]) {
        await _tap(tester, find.text('Change status'));
        await _tap(tester, find.text(label));
        expect(find.text(question), findsOneWidget);
        await _tap(tester, find.text('Cancel'));
      }
      expect((await hives.findById(hive.id))!.status, HiveStatus.active);
    });

    testWidgets('yeniden aktif yapmak onay istemez; 6 sn geri alınabilir', (
      tester,
    ) async {
      final hive = await createHive('101', status: HiveStatus.lost);
      await _open(tester, db: db, location: AppRoutes.hive(yayla.id, hive.id));
      expect(find.widgetWithText(StatusBadge, 'Lost'), findsOneWidget);

      await _tap(tester, find.text('Change status'));
      await _tap(tester, find.text('Active'));

      expect(find.byType(AlertDialog), findsNothing);
      expect(find.text('Hive 101: Active'), findsOneWidget);
      expect((await hives.findById(hive.id))!.status, HiveStatus.active);

      await _tap(tester, find.text('Undo'));
      expect((await hives.findById(hive.id))!.status, HiveStatus.lost);
      expect(find.widgetWithText(StatusBadge, 'Lost'), findsOneWidget);

      // Aktif olmayandan başka bir aktif olmayana: onay yok, geri al var.
      await _tap(tester, find.text('Change status'));
      await _tap(tester, find.text('Sold'));
      expect(find.byType(AlertDialog), findsNothing);
      expect(find.text('Hive 101: Sold'), findsOneWidget);

      // Geri al bildirimi süre dolunca kendiliğinden kapanır.
      await tester.pump(undoSnackBarDuration + const Duration(seconds: 1));
      await tester.pumpAndSettle();
      expect(find.text('Undo'), findsNothing);
    });

    testWidgets('düzenlemede durumu satıldı yapmak onay ister', (tester) async {
      final hive = await createHive('101');
      await _open(tester, db: db, location: AppRoutes.hive(yayla.id, hive.id));

      await _tap(tester, find.byTooltip('Edit'));
      expect(find.text('Edit hive'), findsOneWidget);
      expect(
        tester
            .widget<TextField>(find.widgetWithText(TextField, 'Hive number'))
            .controller
            ?.text,
        '101',
      );
      await _enter(tester, 'Hive number', '102');
      await _tap(tester, find.text('Sold'));
      await _tap(tester, find.text('Save'));

      expect(find.text('Record hive 102 as sold?'), findsOneWidget);
      await _tap(tester, find.text('Yes, record'));

      expect(find.byType(HiveCardScreen), findsOneWidget);
      expect(find.text('102'), findsOneWidget);
      expect(find.widgetWithText(StatusBadge, 'Sold'), findsOneWidget);
      final saved = (await hives.findById(hive.id))!;
      expect(saved.number, '102');
      expect(saved.status, HiveStatus.sold);
    });

    testWidgets('olmayan kovan ve arılık için bulunamadı', (tester) async {
      final container = await _open(
        tester,
        db: db,
        location: AppRoutes.hive(yayla.id, 'yok'),
      );
      expect(find.text('Hive not found'), findsOneWidget);
      expect(find.byTooltip('Edit'), findsNothing);

      final router = container.read(routerProvider)
        ..go(AppRoutes.hiveEdit(yayla.id, 'yok'));
      await tester.pumpAndSettle();
      expect(find.text('Hive not found'), findsOneWidget);
      expect(find.widgetWithText(BigButton, 'Save'), findsNothing);

      router.go(AppRoutes.hiveNew('yok'));
      await tester.pumpAndSettle();
      expect(find.text('Apiary not found'), findsOneWidget);

      router.go(AppRoutes.hivesBulk('yok'));
      await tester.pumpAndSettle();
      expect(find.text('Apiary not found'), findsOneWidget);
    });
  });

  testWidgets('Türkçe metinler', (tester) async {
    final hive = await createHive('101');
    final container = await _open(
      tester,
      db: db,
      location: AppRoutes.apiary(yayla.id),
    );
    container.read(languageProvider.notifier).language = AppLanguage.turkish;
    await tester.pumpAndSettle();

    expect(find.text('Kovanlar'), findsOneWidget);
    expect(find.widgetWithText(FloatingActionButton, 'Kovan ekle'), findsOne);
    expect(find.byTooltip('Izgara görünümü'), findsOneWidget);
    await _tap(tester, find.byTooltip('Liste görünümü'));
    expect(find.text('Langstroth'), findsOneWidget);

    container.read(routerProvider).go(AppRoutes.hive(yayla.id, hive.id));
    await tester.pumpAndSettle();
    expect(find.text('Aktif'), findsOneWidget);
    expect(find.text('Ana arı'), findsOneWidget);
    await _tap(tester, find.text('Durumu değiştir'));
    await _tap(tester, find.text('Söndü'));
    expect(find.text('Kovan 101 söndü olarak kaydedilsin mi?'), findsOneWidget);
    await _tap(tester, find.text('Evet, kaydet'));
    expect(find.text('Söndü'), findsOneWidget);

    container.read(routerProvider).go(AppRoutes.hivesBulk(yayla.id));
    await tester.pumpAndSettle();
    await _enter(tester, 'Kaç kovan', '20');
    await _enter(tester, 'İlk numara', '101');
    expect(find.text('101–120 arası 20 kovan oluşturulacak.'), findsOneWidget);
  });

  testWidgets('360dp ekranda 1.5x yazı ve eldivenle taşmaz', (tester) async {
    tester.view
      ..physicalSize = const Size(360, 640)
      ..devicePixelRatio = 1;
    tester.platformDispatcher.textScaleFactorTestValue = 1.5;
    addTearDown(tester.view.reset);
    addTearDown(tester.platformDispatcher.clearTextScaleFactorTestValue);
    await hives.createMany(
      orgId: _orgId,
      apiaryId: yayla.id,
      numbers: [for (var n = 101; n <= 120; n++) '$n'],
      type: HiveType.langstroth,
      source: HiveSource.package,
    );
    final long = await createHive('A-123456', status: HiveStatus.merged);

    final container = await _open(
      tester,
      db: db,
      location: AppRoutes.apiary(yayla.id),
    );
    final tiles = find.byType(HiveTile);

    /// İlk satırdaki karo sayısı.
    int columns() => tiles
        .evaluate()
        .where(
          (e) =>
              tester.getTopLeft(find.byWidget(e.widget)).dy ==
              tester.getTopLeft(tiles.first).dy,
        )
        .length;
    expect(tester.takeException(), isNull);
    expect(columns(), 3);

    container.read(appearanceProvider.notifier).setGloveMode(enabled: true);
    await tester.pumpAndSettle();
    expect(tester.takeException(), isNull);
    // Eldivende boşluklar büyür, karolar daralmaz.
    expect(columns(), 2);

    await _tap(tester, find.byTooltip('List view'));
    expect(tester.takeException(), isNull);

    final router = container.read(routerProvider)
      ..go(AppRoutes.hive(yayla.id, long.id));
    await tester.pumpAndSettle();
    expect(tester.takeException(), isNull);
    await tester.scrollUntilVisible(
      find.text('Change status'),
      200,
      scrollable: find
          .descendant(
            of: find.byType(HiveCardScreen),
            matching: find.byType(Scrollable),
          )
          .first,
    );
    await _tap(tester, find.text('Change status'));
    expect(tester.takeException(), isNull);
    await tester.tapAt(const Offset(180, 20));
    await tester.pumpAndSettle();

    router.go(AppRoutes.hiveEdit(yayla.id, long.id));
    await tester.pumpAndSettle();
    expect(tester.takeException(), isNull);

    router.go(AppRoutes.hivesBulk(yayla.id));
    await tester.pumpAndSettle();
    await _enter(tester, 'How many hives', '20');
    await _enter(tester, 'First number', '101');
    expect(tester.takeException(), isNull);
  });
}
