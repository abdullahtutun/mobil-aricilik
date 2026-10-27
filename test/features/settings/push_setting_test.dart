import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mobil_arici/app/app.dart';
import 'package:mobil_arici/app/router.dart';
import 'package:mobil_arici/app/routes.dart';
import 'package:mobil_arici/core/db/app_database.dart';
import 'package:mobil_arici/core/db/local_settings_repository.dart';
import 'package:mobil_arici/core/l10n/app_language.dart';
import 'package:mobil_arici/core/l10n/language_provider.dart';
import 'package:mobil_arici/features/settings/presentation/settings_screen.dart';

import '../../helpers/fake_auth_service.dart';
import '../../helpers/fake_push_service.dart';
import '../../helpers/test_database.dart';

void main() {
  late AppDatabase db;
  late FakePushService push;
  late FakeDeviceTokenService tokens;

  setUp(() {
    db = openTestDatabase();
    push = FakePushService();
    tokens = FakeDeviceTokenService();
  });

  Future<ProviderContainer> open(WidgetTester tester) async {
    final container = ProviderContainer.test(
      overrides: signedIn(db: db, push: push, deviceTokens: tokens),
    );
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
    await tester.ensureVisible(row);
    await tester.pumpAndSettle();
    await tester.tap(row);
    await tester.pumpAndSettle();
  }

  bool switchValue(WidgetTester tester, String title) => tester
      .widget<SwitchListTile>(find.widgetWithText(SwitchListTile, title))
      .value;

  testWidgets('"Task notifications" açık gelir; kapatınca token silinir', (
    tester,
  ) async {
    await open(tester);
    await tokens.register(token: 'token-1', platform: 'android');

    expect(switchValue(tester, 'Task notifications'), isTrue);

    await tapSwitch(tester, 'Task notifications');
    // Yerel DB yazması gerçek zaman ister.
    await tester.runAsync(pumpEventQueue);
    await tester.pumpAndSettle();
    expect(switchValue(tester, 'Task notifications'), isFalse);
    expect(await LocalSettingsRepository(db).pushEnabled(), isFalse);
    expect(tokens.registered, isEmpty);

    await tapSwitch(tester, 'Task notifications');
    await tester.runAsync(pumpEventQueue);
    await tester.pumpAndSettle();
    expect(switchValue(tester, 'Task notifications'), isTrue);
    expect(await LocalSettingsRepository(db).pushEnabled(), isTrue);
    expect(push.permissionRequests, greaterThan(0));
  });

  testWidgets('Türkçe metin', (tester) async {
    final container = await open(tester);
    container.read(languageProvider.notifier).language = AppLanguage.turkish;
    await tester.pumpAndSettle();

    await tapSwitch(tester, 'Görev bildirimleri');
    expect(switchValue(tester, 'Görev bildirimleri'), isFalse);
  });
}
