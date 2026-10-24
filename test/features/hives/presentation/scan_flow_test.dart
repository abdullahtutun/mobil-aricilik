import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mobil_arici/app/app.dart';
import 'package:mobil_arici/app/router.dart';
import 'package:mobil_arici/app/routes.dart';
import 'package:mobil_arici/app/shell/app_navigation_bar.dart';
import 'package:mobil_arici/app/shell/scan_screen.dart';
import 'package:mobil_arici/core/db/app_database.dart';
import 'package:mobil_arici/core/design_system/design_system.dart';
import 'package:mobil_arici/core/l10n/app_language.dart';
import 'package:mobil_arici/core/l10n/generated/app_localizations.dart';
import 'package:mobil_arici/core/l10n/language_provider.dart';
import 'package:mobil_arici/core/services/code_scanner.dart';
import 'package:mobil_arici/features/apiaries/data/apiary_repository.dart';
import 'package:mobil_arici/features/apiaries/domain/apiary.dart';
import 'package:mobil_arici/features/apiaries/presentation/apiary_detail_screen.dart';
import 'package:mobil_arici/features/hives/data/hive_repository.dart';
import 'package:mobil_arici/features/hives/domain/hive.dart';
import 'package:mobil_arici/features/hives/domain/hive_label_code.dart';
import 'package:mobil_arici/features/hives/presentation/assign_label_screen.dart';
import 'package:mobil_arici/features/hives/presentation/hive_card_screen.dart';
import 'package:mobil_arici/features/hives/presentation/hive_link_screen.dart';
import 'package:mobil_arici/features/inspections/presentation/inspection_sheet.dart';

import '../../../helpers/fake_auth_service.dart';
import '../../../helpers/fake_code_scanner.dart';
import '../../../helpers/fake_organization_service.dart';
import '../../../helpers/test_database.dart';

final String _orgId = testOrganization.id;
const _missingId = '0199a3b2-7c1e-7d40-8a5b-000000000999';

/// Uygulamayı açar; titreşimler [haptics]'e yazılır.
Future<ProviderContainer> _open(
  WidgetTester tester, {
  required AppDatabase db,
  required FakeCodeScanner scanner,
  List<String>? haptics,
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
  return container;
}

/// Ortadaki Okut butonu.
Future<void> _openScan(WidgetTester tester) async {
  await tester.tap(
    find.descendant(
      of: find.byType(AppNavigationBar),
      matching: find.text('Scan'),
    ),
  );
  await tester.pumpAndSettle();
  expect(find.byType(ScanScreen), findsOneWidget);
}

Future<void> _scan(
  WidgetTester tester,
  FakeCodeScanner scanner,
  String code,
) async {
  scanner.scan(code);
  await tester.pumpAndSettle();
}

Future<void> _tap(WidgetTester tester, Finder finder) async {
  await tester.ensureVisible(finder);
  await tester.pumpAndSettle();
  await tester.tap(finder);
  await tester.pumpAndSettle();
}

/// Telefonun geri tuşu.
Future<void> _systemBack(WidgetTester tester) async {
  await tester.binding.handlePopRoute();
  await tester.pumpAndSettle();
}

/// Platformdan gelen derin linki taklit eder (Android/iOS tam URI verir).
Future<void> _openDeepLink(WidgetTester tester, String link) async {
  unawaited(
    tester.binding.defaultBinaryMessenger.handlePlatformMessage(
      SystemChannels.navigation.name,
      SystemChannels.navigation.codec.encodeMethodCall(
        MethodCall('pushRouteInformation', {'location': link, 'state': null}),
      ),
      (_) {},
    ),
  );
  await tester.pumpAndSettle();
}

void main() {
  late AppDatabase db;
  late HiveRepository hives;
  late FakeCodeScanner scanner;
  late List<String> haptics;
  late Apiary yayla;

  setUp(() async {
    db = openTestDatabase();
    hives = HiveRepository(db);
    scanner = FakeCodeScanner();
    haptics = [];
    yayla = await ApiaryRepository(db).create(orgId: _orgId, name: 'Yayla');
  });

  Future<Hive> createHive(
    String number, {
    String? apiaryId,
    HiveStatus status = HiveStatus.active,
    String? tagCode,
  }) => hives.create(
    orgId: _orgId,
    number: number,
    type: HiveType.langstroth,
    apiaryId: apiaryId ?? yayla.id,
    status: status,
    tagCode: tagCode,
  );

  group('Okut', () {
    testWidgets('kovan etiketi okutulunca titreşir, kovan kartı ve üstünde '
        'muayene açılır; geri tuşu önce muayeneyi kapatır, sonra arılığa '
        'döner', (tester) async {
      final hive = await createHive('101');
      await _open(tester, db: db, scanner: scanner, haptics: haptics);
      await _openScan(tester);
      expect(scanner.isOpen, isTrue);
      expect(
        find.text('Fit the code on the hive label inside the frame.'),
        findsOneWidget,
      );

      await _scan(tester, scanner, hiveLabelCode(hive.id));

      expect(find.byType(ScanScreen), findsNothing);
      expect(find.byType(HiveCardScreen), findsOneWidget);
      expect(find.byType(InspectionSheet), findsOneWidget);
      expect(find.text('Inspect hive 101'), findsOneWidget);
      expect(haptics, ['HapticFeedbackType.heavyImpact']);
      expect(scanner.isOpen, isFalse);

      await _systemBack(tester);
      expect(find.byType(InspectionSheet), findsNothing);
      expect(find.text('101'), findsOneWidget);

      await tester.pageBack();
      await tester.pumpAndSettle();
      expect(find.byType(ApiaryDetailScreen), findsOneWidget);
    });

    testWidgets('kamera aynı kodu art arda verince kart bir kez açılır', (
      tester,
    ) async {
      final hive = await createHive('101');
      await _open(tester, db: db, scanner: scanner, haptics: haptics);
      await _openScan(tester);

      scanner
        ..scan(hiveLabelCode(hive.id))
        ..scan(hiveLabelCode(hive.id))
        ..scan(hiveLabelCode(hive.id));
      await tester.pumpAndSettle();

      expect(find.byType(HiveCardScreen), findsOneWidget);
      expect(find.byType(InspectionSheet), findsOneWidget);
      expect(haptics, hasLength(1));
      await _systemBack(tester);
      await tester.pageBack();
      await tester.pumpAndSettle();
      expect(find.byType(ApiaryDetailScreen), findsOneWidget);
    });

    testWidgets('atanmış etiket kodu ve aktif olmayan kovan da açılır; '
        'aktif olmayan kovanda muayene açılmaz', (tester) async {
      final ova = await ApiaryRepository(db).create(orgId: _orgId, name: 'Ova');
      await createHive(
        '7',
        apiaryId: ova.id,
        status: HiveStatus.dead,
        tagCode: 'NFC-0042',
      );
      await _open(tester, db: db, scanner: scanner, haptics: haptics);
      await _openScan(tester);

      await _scan(tester, scanner, '  NFC-0042\n');

      expect(find.byType(HiveCardScreen), findsOneWidget);
      expect(find.text('7'), findsOneWidget);
      expect(find.text('Ova'), findsOneWidget);
      expect(find.widgetWithText(StatusBadge, 'Dead'), findsOneWidget);
      expect(find.byType(InspectionSheet), findsNothing);
      expect(find.text('Start inspection'), findsNothing);
      expect(haptics, hasLength(1));
    });

    testWidgets('tanınmayan kod: kamera kapanır, nedeni yazar, titreşmez; '
        'yeniden okut kamerayı açar', (tester) async {
      await createHive('101');
      await _open(tester, db: db, scanner: scanner, haptics: haptics);
      await _openScan(tester);

      await _scan(tester, scanner, '4006381333931');

      expect(find.byType(ScanScreen), findsOneWidget);
      expect(scanner.isOpen, isFalse);
      expect(find.text("This code isn't linked to a hive"), findsOneWidget);
      expect(find.text('Code: 4006381333931'), findsOneWidget);
      expect(
        find.widgetWithText(BigButton, 'Assign to a hive'),
        findsOneWidget,
      );
      expect(haptics, isEmpty);

      await _tap(tester, find.widgetWithText(BigButton, 'Scan again'));
      expect(scanner.isOpen, isTrue);
      expect(find.text("This code isn't linked to a hive"), findsNothing);
    });

    testWidgets('kovanı bu telefonda olmayan kendi etiketimiz ayrı anlatılır', (
      tester,
    ) async {
      final removed = await createHive('101');
      await hives.delete(removed.id);
      await _open(tester, db: db, scanner: scanner, haptics: haptics);

      for (final id in [removed.id, _missingId]) {
        await _openScan(tester);
        await _scan(tester, scanner, hiveLabelCode(id));

        expect(find.text("This label's hive wasn't found"), findsOneWidget);
        expect(haptics, isEmpty);
        await tester.pageBack();
        await tester.pumpAndSettle();
      }
    });
  });

  group('Etiketi kovana atama', () {
    testWidgets('tanınmayan etiket aranan kovana atanır; sonra okutunca o '
        'kovan açılır', (tester) async {
      final ova = await ApiaryRepository(db).create(orgId: _orgId, name: 'Ova');
      await createHive('101');
      await createHive('10');
      final seven = await createHive('7', apiaryId: ova.id);
      await _open(tester, db: db, scanner: scanner, haptics: haptics);
      await _openScan(tester);
      await _scan(tester, scanner, ' TAG-X ');

      await _tap(tester, find.widgetWithText(BigButton, 'Assign to a hive'));

      expect(find.byType(AssignLabelScreen), findsOneWidget);
      // Arılıklar ad sırasıyla, kovanlar sayı sırasıyla.
      final order = [
        for (final text in ['Ova', 'Hive 7', 'Yayla', 'Hive 10', 'Hive 101'])
          tester.getTopLeft(find.text(text)).dy,
      ];
      expect(order, [...order]..sort());

      await tester.enterText(find.byType(TextField), '7');
      await tester.pumpAndSettle();
      expect(find.text('Hive 101'), findsNothing);
      expect(find.text('Yayla'), findsNothing);

      await _tap(tester, find.text('Hive 7'));

      expect(find.byType(HiveCardScreen), findsOneWidget);
      expect(find.text('Label assigned: hive 7'), findsOneWidget);
      expect((await hives.findById(seven.id))!.tagCode, 'TAG-X');

      await _openScan(tester);
      await _scan(tester, scanner, 'TAG-X');
      expect(find.byType(HiveCardScreen), findsOneWidget);
      expect(find.text('Ova'), findsOneWidget);
      expect(haptics, hasLength(1));
    });

    testWidgets('geri tuşu tanınmayan kod ekranına döner', (tester) async {
      await createHive('101');
      await _open(tester, db: db, scanner: scanner);
      await _openScan(tester);
      await _scan(tester, scanner, 'TAG-X');
      await _tap(tester, find.widgetWithText(BigButton, 'Assign to a hive'));

      await tester.pageBack();
      await tester.pumpAndSettle();

      expect(find.text("This code isn't linked to a hive"), findsOneWidget);
    });

    testWidgets('başka etiketi olan kovan için önce sorulur', (tester) async {
      final hive = await createHive('101', tagCode: 'OLD');
      await _open(tester, db: db, scanner: scanner);
      await _openScan(tester);
      await _scan(tester, scanner, 'NEW');
      await _tap(tester, find.widgetWithText(BigButton, 'Assign to a hive'));
      expect(find.text('Has another label'), findsOneWidget);

      await _tap(tester, find.text('Hive 101'));
      expect(find.text('Replace the label of hive 101?'), findsOneWidget);
      await _tap(tester, find.text('Cancel'));

      expect(find.byType(AssignLabelScreen), findsOneWidget);
      expect((await hives.findById(hive.id))!.tagCode, 'OLD');

      await _tap(tester, find.text('Hive 101'));
      await _tap(tester, find.text('Yes, replace'));

      expect(find.byType(HiveCardScreen), findsOneWidget);
      expect((await hives.findById(hive.id))!.tagCode, 'NEW');
    });

    testWidgets('kovan yoksa ne yapılacağı yazar', (tester) async {
      final container = await _open(tester, db: db, scanner: scanner);
      container.read(routerProvider).go(AppRoutes.labelAssign('TAG-X'));
      await tester.pumpAndSettle();

      expect(
        find.text('No hives yet. Add hives from the Apiaries tab first.'),
        findsOneWidget,
      );
      expect(find.byType(TextField), findsNothing);
    });
  });

  group('Derin link', () {
    testWidgets('mobilarici://h/<kimlik> kovan kartını ve muayeneyi açar; '
        'geri arılığa', (tester) async {
      final hive = await createHive('101');
      await _open(tester, db: db, scanner: scanner);

      await _openDeepLink(tester, hiveLabelCode(hive.id));

      expect(find.byType(HiveCardScreen), findsOneWidget);
      expect(find.byType(InspectionSheet), findsOneWidget);
      expect(find.text('101'), findsOneWidget);
      await _systemBack(tester);
      await tester.pageBack();
      await tester.pumpAndSettle();
      expect(find.byType(ApiaryDetailScreen), findsOneWidget);
    });

    testWidgets('kovanı olmayan link etiketi atamayı sunar', (tester) async {
      await createHive('101');
      await _open(tester, db: db, scanner: scanner);

      await _openDeepLink(tester, hiveLabelCode(_missingId));

      expect(find.byType(HiveLinkScreen), findsOneWidget);
      expect(find.text("This label's hive wasn't found"), findsOneWidget);
      expect(find.widgetWithText(BigButton, 'Scan again'), findsNothing);

      await _tap(tester, find.widgetWithText(BigButton, 'Assign to a hive'));
      await _tap(tester, find.text('Hive 101'));

      expect(find.byType(HiveCardScreen), findsOneWidget);
      final assigned = (await db.select(db.hives).get()).single;
      expect(assigned.tagCode, hiveLabelCode(_missingId));
    });

    testWidgets('soğuk açılışta gelen etiket linki kartı açar', (tester) async {
      final hive = await createHive('101');
      tester.binding.platformDispatcher.defaultRouteNameTestValue =
          hiveLabelCode(hive.id);
      addTearDown(
        tester.binding.platformDispatcher.clearDefaultRouteNameTestValue,
      );

      await _open(tester, db: db, scanner: scanner);

      expect(find.byType(HiveCardScreen), findsOneWidget);
    });
  });

  group('Kamera hatası', () {
    testWidgets('nedeni anlaşılır yazar', (tester) async {
      for (final (failure, message) in [
        (
          CameraFailure.permissionDenied,
          "Camera permission wasn't given. To scan labels, allow the camera "
              'for this app in Settings.',
        ),
        (CameraFailure.unsupported, 'This device has no camera that can scan.'),
        (CameraFailure.unknown, 'Close this screen and try again.'),
      ]) {
        await tester.pumpWidget(
          MaterialApp(
            theme: AppTheme.light(const AppearanceSettings()),
            localizationsDelegates: AppLocalizations.localizationsDelegates,
            supportedLocales: AppLocalizations.supportedLocales,
            home: Scaffold(body: CameraFailureView(failure)),
          ),
        );

        expect(find.text("Couldn't open the camera"), findsOneWidget);
        expect(find.text(message), findsOneWidget);
      }
    });
  });

  testWidgets('Türkçe metinler', (tester) async {
    final hive = await createHive('101', tagCode: 'OLD');
    final container = await _open(tester, db: db, scanner: scanner);
    container.read(languageProvider.notifier).language = AppLanguage.turkish;
    await tester.pumpAndSettle();

    await tester.tap(
      find.descendant(
        of: find.byType(AppNavigationBar),
        matching: find.text('Okut'),
      ),
    );
    await tester.pumpAndSettle();
    expect(find.text('Kovan etiketindeki kodu çerçeveye getir.'), findsOne);

    await _scan(tester, scanner, 'X-1');
    expect(find.text('Bu kod bir kovana bağlı değil'), findsOneWidget);
    expect(find.text('Kod: X-1'), findsOneWidget);
    expect(find.text('Yeniden okut'), findsOneWidget);
    await _tap(tester, find.text('Bir kovana ata'));
    expect(find.text('Etiketi kovana ata'), findsOneWidget);
    expect(find.text('Başka etiketi var'), findsOneWidget);
    await _tap(tester, find.text('Kovan 101'));
    expect(find.text('Kovan 101 için etiket değişsin mi?'), findsOneWidget);
    await _tap(tester, find.text('Evet, değiştir'));
    expect(find.text('Etiket atandı: Kovan 101'), findsOneWidget);
    expect((await hives.findById(hive.id))!.tagCode, 'X-1');

    container.read(routerProvider).go(AppRoutes.hiveLink(_missingId));
    await tester.pumpAndSettle();
    expect(find.text('Bu etiketin kovanı bulunamadı'), findsOneWidget);
    // Kapanan kabuğun Drift akışları sıfır süreli zamanlayıcı bırakır.
    await tester.pump(Duration.zero);
  });

  testWidgets('360dp ekranda 1.5x yazı ve eldivenle taşmaz', (tester) async {
    tester.view
      ..physicalSize = const Size(360, 640)
      ..devicePixelRatio = 1;
    tester.platformDispatcher.textScaleFactorTestValue = 1.5;
    addTearDown(tester.view.reset);
    addTearDown(tester.platformDispatcher.clearTextScaleFactorTestValue);
    await createHive('A-123456', tagCode: 'OLD', status: HiveStatus.lost);
    final container = await _open(tester, db: db, scanner: scanner);

    for (final glove in [false, true]) {
      container.read(appearanceProvider.notifier).setGloveMode(enabled: glove);
      await _openScan(tester);
      expect(tester.takeException(), isNull);
      await _scan(tester, scanner, 'mobilarici://h/$_missingId');
      expect(tester.takeException(), isNull);
      await _tap(tester, find.widgetWithText(BigButton, 'Scan again'));

      await _scan(tester, scanner, 'X' * 200);
      expect(tester.takeException(), isNull);
      await _tap(tester, find.widgetWithText(BigButton, 'Assign to a hive'));
      expect(tester.takeException(), isNull);

      container.read(routerProvider).go(AppRoutes.today);
      await tester.pumpAndSettle();
    }
  });
}
