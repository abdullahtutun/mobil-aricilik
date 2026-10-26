import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mobil_arici/app/app.dart';
import 'package:mobil_arici/app/router.dart';
import 'package:mobil_arici/app/routes.dart';
import 'package:mobil_arici/app/shell/app_navigation_bar.dart';
import 'package:mobil_arici/app/shell/more_screen.dart';
import 'package:mobil_arici/app/shell/quick_record_sheet.dart';
import 'package:mobil_arici/app/shell/scan_screen.dart';
import 'package:mobil_arici/core/design_system/design_system.dart';
import 'package:mobil_arici/features/apiaries/presentation/apiaries_screen.dart';
import 'package:mobil_arici/features/settings/presentation/settings_screen.dart';
import 'package:mobil_arici/features/tasks/presentation/tasks_screen.dart';
import 'package:mobil_arici/features/today/domain/today_rules.dart';
import 'package:mobil_arici/features/today/presentation/attention_screen.dart';
import 'package:mobil_arici/features/today/presentation/today_screen.dart';

import '../../helpers/fake_auth_service.dart';

Future<ProviderContainer> _pumpApp(WidgetTester tester) async {
  final container = ProviderContainer.test(overrides: signedIn());
  await tester.pumpWidget(
    UncontrolledProviderScope(container: container, child: const App()),
  );
  await tester.pumpAndSettle();
  return container;
}

/// Alt gezinmedeki bir öğe: sekmenin etiketi ya da Okut'un ikonu (adı
/// yalnız ekran okuyucuda).
Finder _navItem(String label) => find.descendant(
  of: find.byType(AppNavigationBar),
  matching: find.byWidgetPredicate(
    (widget) =>
        (widget is Text && widget.data == label) ||
        (widget is Icon && widget.semanticLabel == label),
  ),
);

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
  group('Sekmeler', () {
    testWidgets('her sekme kendi boş durumunu gösterir', (tester) async {
      await _pumpApp(tester);

      expect(find.byType(TodayScreen), findsOneWidget);
      expect(find.byType(EmptyState), findsOneWidget);

      for (final (label, screen) in [
        ('Apiaries', ApiariesScreen),
        ('Tasks', TasksScreen),
        ('More', MoreScreen),
        ('Today', TodayScreen),
      ]) {
        await tester.tap(_navItem(label));
        await tester.pumpAndSettle();

        expect(find.byType(screen), findsOneWidget, reason: label);
        // Daha fazla'da boş durum yok; modül karoları var.
        expect(
          find.descendant(
            of: find.byType(screen),
            matching: find.byType(EmptyState),
          ),
          screen == MoreScreen ? findsNothing : findsOneWidget,
          reason: label,
        );
      }
    });

    testWidgets('seçili sekme ekran okuyucuya seçili bildirilir', (
      tester,
    ) async {
      final handle = tester.ensureSemantics();
      await _pumpApp(tester);

      expect(
        tester.getSemantics(_navItem('Today')),
        isSemantics(label: 'Today', isButton: true, isSelected: true),
      );
      expect(
        tester.getSemantics(_navItem('Tasks')),
        isSemantics(label: 'Tasks', isButton: true, isSelected: false),
      );
      handle.dispose();
    });

    testWidgets('sekme değişince yığın korunur, yeniden dokunmak başa döner', (
      tester,
    ) async {
      final container = await _pumpApp(tester);

      // Dikkat listesi Bugün sekmesinin içinde, alt gezinme görünür.
      container
          .read(routerProvider)
          .go(AppRoutes.attention(AttentionKind.weak));
      await tester.pumpAndSettle();
      expect(find.byType(AttentionScreen), findsOneWidget);

      await tester.tap(_navItem('More'));
      await tester.pumpAndSettle();
      expect(find.byType(AttentionScreen), findsNothing);

      await tester.tap(_navItem('Today'));
      await tester.pumpAndSettle();
      expect(find.byType(AttentionScreen), findsOneWidget);

      await tester.tap(_navItem('Today'));
      await tester.pumpAndSettle();
      expect(find.byType(AttentionScreen), findsNothing);
      expect(find.byType(TodayScreen), findsOneWidget);
    });

    testWidgets('dokunma hedefleri saha ölçüsünde, eldivende büyür', (
      tester,
    ) async {
      final container = await _pumpApp(tester);

      for (final (gloveMode, targets) in [
        (false, AppTouchTargets.standard),
        (true, AppTouchTargets.glove),
      ]) {
        container
            .read(appearanceProvider.notifier)
            .setGloveMode(enabled: gloveMode);
        await tester.pumpAndSettle();

        final scan = tester.getSize(
          find.ancestor(of: _navItem('Scan'), matching: find.byType(InkWell)),
        );
        expect(scan.height, greaterThanOrEqualTo(targets.fieldLarge));
        expect(scan.width, greaterThanOrEqualTo(targets.fieldLarge));

        final tab = tester.getSize(
          find.ancestor(of: _navItem('Tasks'), matching: find.byType(InkWell)),
        );
        expect(tab.height, greaterThanOrEqualTo(targets.field));
      }
    });
  });

  testWidgets('dar ekranda 1.5x yazı ve eldivenle taşma olmaz', (tester) async {
    tester.view
      ..physicalSize = const Size(360, 640)
      ..devicePixelRatio = 1;
    addTearDown(tester.view.reset);
    tester.platformDispatcher
      ..localesTestValue = const [Locale('tr')]
      ..textScaleFactorTestValue = 1.5;
    addTearDown(tester.platformDispatcher.clearAllTestValues);

    final container = await _pumpApp(tester);
    container.read(appearanceProvider.notifier).setGloveMode(enabled: true);
    await tester.pumpAndSettle();

    for (final label in ['Arılıklar', 'Görevler', 'Daha fazla', 'Bugün']) {
      await tester.tap(_navItem(label));
      await tester.pumpAndSettle();
      expect(tester.takeException(), isNull, reason: label);
    }
    await tester.longPress(_navItem('Okut'));
    await tester.pumpAndSettle();
    expect(tester.takeException(), isNull);
  });

  group('Okut butonu', () {
    testWidgets('dokununca Okut ekranı alt gezinmenin üstünde açılır', (
      tester,
    ) async {
      await _pumpApp(tester);
      await tester.tap(_navItem('Tasks'));
      await tester.pumpAndSettle();

      await tester.tap(_navItem('Scan'));
      await tester.pumpAndSettle();

      expect(find.byType(ScanScreen), findsOneWidget);
      expect(
        find.text('Fit the code on the hive label inside the frame.'),
        findsOneWidget,
      );
      expect(find.byType(AppNavigationBar).hitTestable(), findsNothing);

      await tester.tap(find.byTooltip('Close'));
      await tester.pumpAndSettle();

      expect(find.byType(ScanScreen), findsNothing);
      expect(find.byType(TasksScreen), findsOneWidget);
    });

    testWidgets('basılı tutunca hızlı kayıt menüsü açılır', (tester) async {
      await _pumpApp(tester);

      await tester.longPress(_navItem('Scan'));
      await tester.pumpAndSettle();

      expect(find.byType(ScanScreen), findsNothing);
      expect(find.byType(QuickRecordSheet), findsOneWidget);
      expect(find.text('Quick record'), findsOneWidget);
      for (final label in [
        'Inspection',
        'Feeding',
        'Treatment',
        'Harvest',
        'Note',
        'Expense',
      ]) {
        expect(find.text(label), findsOneWidget, reason: label);
      }
    });

    testWidgets('menüden seçince menü kapanır, yakında bildirimi çıkar', (
      tester,
    ) async {
      final container = await _pumpApp(tester);
      // Menü kök navigator'da; alttaki sekme yığını kapanmamalı.
      container
          .read(routerProvider)
          .go(AppRoutes.attention(AttentionKind.weak));
      await tester.pumpAndSettle();

      await tester.longPress(_navItem('Scan'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Feeding'));
      await tester.pumpAndSettle();

      expect(find.byType(QuickRecordSheet), findsNothing);
      expect(find.text('This record type is coming soon.'), findsOneWidget);
      expect(find.byType(AttentionScreen), findsOneWidget);
    });

    testWidgets('ekran okuyucu dokunma ve basılı tutma eylemlerini okur', (
      tester,
    ) async {
      final handle = tester.ensureSemantics();
      await _pumpApp(tester);

      expect(
        tester.getSemantics(_navItem('Scan')),
        isSemantics(
          label: 'Scan',
          isButton: true,
          hasTapAction: true,
          hasLongPressAction: true,
          onLongPressHint: 'open the quick record menu',
        ),
      );
      handle.dispose();
    });
  });

  group('Derin link', () {
    testWidgets('mobilarici:// linki aynı yollu ekranı açar', (tester) async {
      await _pumpApp(tester);

      await _openDeepLink(tester, 'mobilarici://more/settings');

      expect(find.byType(SettingsScreen), findsOneWidget);
      // Ayarlar tam ekran (docs/design); geri tuşu Daha fazla'ya döner.
      expect(find.byType(AppNavigationBar), findsNothing);
      await tester.pageBack();
      await tester.pumpAndSettle();
      expect(find.byType(MoreScreen), findsOneWidget);
    });

    testWidgets('hedefi olmayan link Bugün sekmesine düşer', (tester) async {
      await _pumpApp(tester);
      await tester.tap(_navItem('Tasks'));
      await tester.pumpAndSettle();

      await _openDeepLink(tester, 'mobilarici://hives/42');

      expect(find.byType(TodayScreen), findsOneWidget);
      expect(find.byType(ErrorWidget), findsNothing);
    });

    testWidgets('uygulama derin linkle açılırsa o ekranla başlar', (
      tester,
    ) async {
      tester.platformDispatcher.defaultRouteNameTestValue =
          'mobilarici://tasks';
      addTearDown(tester.platformDispatcher.clearDefaultRouteNameTestValue);

      await _pumpApp(tester);

      expect(find.byType(TasksScreen), findsOneWidget);
    });

    testWidgets('uygulama içi konumlar değişmeden açılır', (tester) async {
      final container = await _pumpApp(tester);

      container.read(routerProvider).go(AppRoutes.apiaries);
      await tester.pumpAndSettle();

      expect(find.byType(ApiariesScreen), findsOneWidget);
    });
  });
}
