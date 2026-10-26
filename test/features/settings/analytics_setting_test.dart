import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mobil_arici/app/app.dart';
import 'package:mobil_arici/app/router.dart';
import 'package:mobil_arici/app/routes.dart';
import 'package:mobil_arici/core/analytics/analytics_repository.dart';
import 'package:mobil_arici/core/analytics/analytics_rules.dart';
import 'package:mobil_arici/core/db/app_database.dart';
import 'package:mobil_arici/core/db/local_settings_repository.dart';
import 'package:mobil_arici/core/l10n/app_language.dart';
import 'package:mobil_arici/core/l10n/language_provider.dart';
import 'package:mobil_arici/features/settings/presentation/settings_screen.dart';

import '../../helpers/fake_auth_service.dart';
import '../../helpers/test_database.dart';

void main() {
  late AppDatabase db;

  setUp(() => db = openTestDatabase());

  Future<ProviderContainer> open(WidgetTester tester) async {
    final container = ProviderContainer.test(overrides: signedIn(db: db));
    await tester.pumpWidget(
      UncontrolledProviderScope(container: container, child: const App()),
    );
    container.read(routerProvider).go(AppRoutes.settings);
    await tester.pumpAndSettle();
    return container;
  }

  Future<void> tapSwitch(WidgetTester tester, String title) async {
    final row = find.descendant(
      of: find.byType(SettingsScreen),
      matching: find.widgetWithText(SwitchListTile, title),
    );
    await tester.scrollUntilVisible(
      row,
      200,
      scrollable: find
          .descendant(
            of: find.byType(SettingsScreen),
            matching: find.byType(Scrollable),
          )
          .first,
    );
    await tester.tap(row);
    await tester.pumpAndSettle();
  }

  bool switchValue(WidgetTester tester, String title) => tester
      .widget<SwitchListTile>(find.widgetWithText(SwitchListTile, title))
      .value;

  testWidgets('"Kullanım verisi paylaş" açık gelir; kapatınca kuyruk silinir', (
    tester,
  ) async {
    await AnalyticsRepository(db).record(AnalyticsEvent.scanFinished);
    await open(tester);

    await tapSwitch(tester, 'Share usage data');
    expect(switchValue(tester, 'Share usage data'), isFalse);
    expect(await LocalSettingsRepository(db).analyticsEnabled(), isFalse);
    expect(await db.select(db.analyticsQueue).get(), isEmpty);

    await tapSwitch(tester, 'Share usage data');
    expect(switchValue(tester, 'Share usage data'), isTrue);
    expect(await LocalSettingsRepository(db).analyticsEnabled(), isTrue);
  });

  testWidgets('Türkçe metin', (tester) async {
    final container = await open(tester);
    container.read(languageProvider.notifier).language = AppLanguage.turkish;
    await tester.pumpAndSettle();

    await tapSwitch(tester, 'Kullanım verisi paylaş');
    expect(switchValue(tester, 'Kullanım verisi paylaş'), isFalse);
  });
}
