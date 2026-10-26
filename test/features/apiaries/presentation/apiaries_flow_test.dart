import 'dart:async';

import 'package:clock/clock.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/misc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mobil_arici/app/app.dart';
import 'package:mobil_arici/app/router.dart';
import 'package:mobil_arici/app/routes.dart';
import 'package:mobil_arici/app/shell/app_navigation_bar.dart';
import 'package:mobil_arici/core/db/app_database.dart';
import 'package:mobil_arici/core/design_system/design_system.dart';
import 'package:mobil_arici/core/l10n/app_language.dart';
import 'package:mobil_arici/core/l10n/language_provider.dart';
import 'package:mobil_arici/core/services/location_service.dart';
import 'package:mobil_arici/core/services/location_service_provider.dart';
import 'package:mobil_arici/features/apiaries/data/apiary_repository.dart';
import 'package:mobil_arici/features/apiaries/domain/apiary.dart';
import 'package:mobil_arici/features/apiaries/domain/apiary_summary.dart';
import 'package:mobil_arici/features/apiaries/presentation/apiaries_screen.dart';
import 'package:mobil_arici/features/apiaries/presentation/apiary_detail_screen.dart';
import 'package:mobil_arici/features/apiaries/presentation/apiary_form_screen.dart';
import 'package:mobil_arici/features/apiaries/presentation/apiary_providers.dart';
import 'package:mobil_arici/features/hives/data/hive_repository.dart';
import 'package:mobil_arici/features/hives/domain/hive.dart';

import '../../../helpers/fake_auth_service.dart';
import '../../../helpers/fake_location_service.dart';
import '../../../helpers/fake_organization_service.dart';
import '../../../helpers/test_database.dart';

final String _orgId = testOrganization.id;

/// İşletmesi olan kullanıcıyla uygulamayı açar ve Arılıklar sekmesine geçer.
Future<ProviderContainer> _openApiaries(
  WidgetTester tester, {
  required AppDatabase db,
  FakeLocationService? location,
  List<Override> overrides = const [],
}) async {
  final container = ProviderContainer.test(
    overrides: [
      ...signedIn(db: db),
      locationServiceProvider.overrideWithValue(
        location ?? FakeLocationService(),
      ),
      ...overrides,
    ],
  );
  await tester.pumpWidget(
    UncontrolledProviderScope(container: container, child: const App()),
  );
  await tester.pumpAndSettle();
  await _tap(
    tester,
    find.descendant(
      of: find.byType(AppNavigationBar),
      matching: find.text('Apiaries'),
    ),
  );
  return container;
}

Future<void> _tap(WidgetTester tester, Finder finder) async {
  await tester.ensureVisible(finder);
  await tester.pumpAndSettle();
  await tester.tap(finder);
  await tester.pumpAndSettle();
}

/// Adı [label] olan alanın metin kutusu (ad alanın üstünde yazar).
Finder _field(String label) => find.descendant(
  of: find.ancestor(of: find.text(label), matching: find.byType(LabeledField)),
  matching: find.byType(TextField),
);

Future<void> _enter(WidgetTester tester, String label, String text) async {
  await tester.enterText(_field(label), text);
  await tester.pump();
}

BigButton _button(WidgetTester tester, String label) =>
    tester.widget<BigButton>(find.widgetWithText(BigButton, label));

void main() {
  late AppDatabase db;
  late ApiaryRepository apiaries;

  setUp(() {
    db = openTestDatabase();
    apiaries = ApiaryRepository(db);
  });

  group('Arılık listesi', () {
    testWidgets('boşken ilk arılık eklenir, detayı açılır', (tester) async {
      await _openApiaries(tester, db: db);

      expect(find.text('No apiaries yet'), findsOneWidget);
      expect(find.byTooltip('Add apiary'), findsNothing);
      await _tap(tester, find.text('Add your first apiary'));

      expect(find.byType(ApiaryFormScreen), findsOneWidget);
      expect(find.text('New apiary'), findsOneWidget);
      // Form tam ekran (docs/design "Arılık ekle"); alt gezinme yok.
      expect(find.byType(AppNavigationBar), findsNothing);
      expect(_button(tester, 'Save').onPressed, isNull);

      await _enter(tester, 'Apiary name', 'Yayla');
      await _tap(tester, find.text('Take location from GPS'));
      await _tap(tester, find.text('Save'));

      expect(find.byType(ApiaryDetailScreen), findsOneWidget);
      expect(find.text('Yayla'), findsOneWidget);
      expect(find.text('No hives · No visits yet'), findsOneWidget);

      // Geri: form değil liste.
      await tester.pageBack();
      await tester.pumpAndSettle();
      expect(find.byType(ApiariesScreen), findsOneWidget);
      expect(find.text('Yayla'), findsOneWidget);
      expect(find.text('No visits yet'), findsOneWidget);
      expect(find.text('0'), findsOneWidget);
      expect(find.byTooltip('Add apiary'), findsOne);

      final saved = await db.select(db.apiaries).get();
      expect(saved.single.orgId, _orgId);
      expect(saved.single.latitude, testFix.latitude);
    });

    testWidgets('Türkçe harf ve sayı sırasıyla, aktif kovan sayısıyla', (
      tester,
    ) async {
      final yayla = await apiaries.create(orgId: _orgId, name: 'Yayla');
      for (final name in ['Çamlık', 'Arılık 10', 'Cevizli', 'Arılık 2']) {
        await apiaries.create(orgId: _orgId, name: name);
      }
      await apiaries.create(orgId: 'başka-işletme', name: 'Başkası');
      final hives = HiveRepository(db);
      for (final status in [
        HiveStatus.active,
        HiveStatus.active,
        HiveStatus.dead,
      ]) {
        await hives.create(
          orgId: _orgId,
          number: '101',
          type: HiveType.langstroth,
          apiaryId: yayla.id,
          status: status,
        );
      }

      // Beş kart bir ekrana sığsın.
      tester.view
        ..physicalSize = const Size(800, 1600)
        ..devicePixelRatio = 1;
      addTearDown(tester.view.reset);
      await _openApiaries(tester, db: db);

      final names = ['Arılık 2', 'Arılık 10', 'Cevizli', 'Çamlık', 'Yayla'];
      final tops = [
        for (final name in names) tester.getTopLeft(find.text(name)).dy,
      ];
      expect(tops, [...tops]..sort());
      expect(find.text('Başkası'), findsNothing);
      expect(find.text('5 apiaries · 2 hives'), findsOneWidget);
      expect(find.text('2'), findsOneWidget);
      expect(find.text('0'), findsNWidgets(4));
    });

    testWidgets('kovan eklenince liste kendiliğinden güncellenir', (
      tester,
    ) async {
      final yayla = await apiaries.create(orgId: _orgId, name: 'Yayla');
      await _openApiaries(tester, db: db);
      expect(find.text('0'), findsOneWidget);

      await HiveRepository(db).create(
        orgId: _orgId,
        number: '101',
        type: HiveType.local,
        apiaryId: yayla.id,
      );
      await tester.pumpAndSettle();

      expect(find.text('1'), findsOneWidget);
      expect(find.text('1 apiary · 1 hive'), findsOneWidget);
    });

    testWidgets('son ziyaret yakınsa gün olarak yazılır', (tester) async {
      final apiary = Apiary(
        id: 'a1',
        orgId: _orgId,
        name: 'Yayla',
        createdAt: DateTime.utc(2026, 10),
        updatedAt: DateTime.utc(2026, 10),
      );
      final summary = ApiarySummary(
        apiary: apiary,
        activeHiveCount: 12,
        lastVisitAt: DateTime.utc(2026, 10, 21, 9),
      );
      await withClock(Clock.fixed(DateTime(2026, 10, 24, 10)), () async {
        final container = await _openApiaries(
          tester,
          db: db,
          overrides: [
            apiaryListProvider.overrideWith((ref) => Stream.value([summary])),
            apiarySummaryProvider(apiary.id)
                .overrideWith((ref) => Stream.value(summary)),
          ],
        );

        expect(find.text('Last visit 3 days ago'), findsOneWidget);
        expect(find.text('12'), findsOneWidget);

        container.read(routerProvider).go(AppRoutes.apiary(apiary.id));
        await tester.pumpAndSettle();
        expect(find.text('12 hives · Last visit 3 days ago'), findsOneWidget);
      });
    });

    testWidgets('Türkçe metinler', (tester) async {
      final yayla = await apiaries.create(orgId: _orgId, name: 'Yayla');
      final container = await _openApiaries(tester, db: db);
      container.read(languageProvider.notifier).language = AppLanguage.turkish;
      await tester.pumpAndSettle();

      expect(find.text('Arılıklar'), findsWidgets);
      expect(find.text('1 arılık · Kovan yok'), findsOneWidget);
      expect(find.text('Henüz ziyaret yok'), findsOneWidget);
      expect(find.text('kovan'), findsOneWidget);
      expect(find.byTooltip('Arılık ekle'), findsOne);

      container.read(routerProvider).go(AppRoutes.apiary(yayla.id));
      await tester.pumpAndSettle();
      expect(find.text('Kovan yok · Henüz ziyaret yok'), findsOneWidget);
      await _tap(tester, find.byIcon(Icons.more_vert_rounded));
      expect(find.text('Düzenle'), findsOneWidget);
    });
  });

  group('Arılık detayı ve düzenleme', () {
    testWidgets('detaydan düzenlenir; kaydedince detaya dönülür', (
      tester,
    ) async {
      final yayla = await apiaries.create(
        orgId: _orgId,
        name: 'Yayla',
        latitude: 40,
        longitude: 29,
        landownerName: 'Ahmet',
        waterSource: 'Çeşme',
      );
      await _openApiaries(tester, db: db);
      await _tap(tester, find.text('Yayla'));
      expect(find.byType(ApiaryDetailScreen), findsOneWidget);

      await _tap(tester, find.byIcon(Icons.more_vert_rounded));
      await _tap(tester, find.text('Edit'));

      expect(find.text('Edit apiary'), findsOneWidget);
      expect(find.text('40.00000, 29.00000'), findsOneWidget);
      // Kayıtlı konumun doğruluğu bilinmez.
      expect(find.textContaining('Accuracy'), findsNothing);
      expect(
        tester.widget<TextField>(_field("Landowner's name")).controller?.text,
        'Ahmet',
      );

      await _enter(tester, 'Apiary name', 'Yayla Üst');
      await _tap(tester, find.text('Remove location'));
      expect(find.textContaining('No location yet'), findsOneWidget);
      await _tap(tester, find.text('Save'));

      expect(find.byType(ApiaryDetailScreen), findsOneWidget);
      expect(find.text('Yayla Üst'), findsOneWidget);
      final saved = (await apiaries.findById(yayla.id))!;
      expect(saved.name, 'Yayla Üst');
      expect(saved.latitude, isNull);
      expect(saved.waterSource, 'Çeşme');

      await tester.pageBack();
      await tester.pumpAndSettle();
      expect(find.byType(ApiariesScreen), findsOneWidget);
      expect(find.text('Yayla Üst'), findsOneWidget);
    });

    testWidgets('olmayan arılık için bulunamadı gösterilir', (tester) async {
      final container = await _openApiaries(tester, db: db);
      final router = container.read(routerProvider)
        ..go(AppRoutes.apiary('yok'));
      await tester.pumpAndSettle();
      expect(find.text('Apiary not found'), findsOneWidget);
      expect(find.byTooltip('Edit'), findsNothing);

      router.go(AppRoutes.apiaryEdit('yok'));
      await tester.pumpAndSettle();
      expect(find.text('Apiary not found'), findsOneWidget);
      expect(find.widgetWithText(BigButton, 'Save'), findsNothing);
    });
  });

  group('Konum', () {
    testWidgets('ayardan çözülen hatada ayarlar açılır', (tester) async {
      final location = FakeLocationService()
        ..failure = LocationFailure.serviceDisabled;
      await _openApiaries(tester, db: db, location: location);
      await _tap(tester, find.text('Add your first apiary'));

      await _tap(tester, find.text('Take location from GPS'));

      expect(
        find.text(
          'Location is turned off on this device. Turn it on and try again.',
        ),
        findsOneWidget,
      );
      expect(find.byIcon(AppStatus.warning.icon), findsOneWidget);
      await _tap(tester, find.text('Open settings'));
      expect(location.openedSettings, [LocationFailure.serviceDisabled]);

      location.failure = LocationFailure.timeout;
      await _tap(tester, find.text('Take location from GPS'));
      expect(
        find.text("Couldn't find your location. Try again in the open."),
        findsOneWidget,
      );
      expect(find.text('Open settings'), findsNothing);
    });

    testWidgets('konum beklenirken kaydedilmez; vazgeçilebilir', (
      tester,
    ) async {
      final location = FakeLocationService()..gate = Completer();
      await _openApiaries(tester, db: db, location: location);
      await _tap(tester, find.text('Add your first apiary'));
      await _enter(tester, 'Apiary name', 'Yayla');

      await tester.tap(find.text('Take location from GPS'));
      // Bekleme göstergesi döner; pumpAndSettle bitmez.
      await tester.pump();

      expect(
        find.text("Getting your location… It's quicker in the open."),
        findsOneWidget,
      );
      expect(_button(tester, 'Save').onPressed, isNull);

      await tester.tap(find.text('Cancel'));
      await tester.pumpAndSettle();
      location.gate!.complete();
      await tester.pumpAndSettle();

      expect(find.textContaining('No location yet'), findsOneWidget);
      expect(_button(tester, 'Save').onPressed, isNotNull);
    });
  });

  testWidgets('360dp ekranda 1.5x yazı ve eldivenle taşmaz', (tester) async {
    tester.view
      ..physicalSize = const Size(360, 640)
      ..devicePixelRatio = 1;
    tester.platformDispatcher.textScaleFactorTestValue = 1.5;
    addTearDown(tester.view.reset);
    addTearDown(tester.platformDispatcher.clearTextScaleFactorTestValue);
    final yayla = await apiaries.create(
      orgId: _orgId,
      name: 'Yukarı Kocaçam Yaylası Kestane Arılığı',
    );

    final container = await _openApiaries(tester, db: db);
    container.read(appearanceProvider.notifier).setGloveMode(enabled: true);
    await tester.pumpAndSettle();
    expect(tester.takeException(), isNull);

    final router = container.read(routerProvider)
      ..go(AppRoutes.apiary(yayla.id));
    await tester.pumpAndSettle();
    expect(tester.takeException(), isNull);

    router.go(AppRoutes.apiaryEdit(yayla.id));
    await tester.pumpAndSettle();
    await tester.scrollUntilVisible(
      find.text('Take location from GPS'),
      200,
      scrollable: find
          .descendant(
            of: find.byType(ApiaryFormScreen),
            matching: find.byType(Scrollable),
          )
          .first,
    );
    await _tap(tester, find.text('Take location from GPS'));
    expect(tester.takeException(), isNull);
    expect(find.text('Remove location'), findsOneWidget);
  });
}
