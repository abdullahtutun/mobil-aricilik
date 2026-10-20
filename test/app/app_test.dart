import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mobil_aricilik/app/app.dart';
import 'package:mobil_aricilik/core/design_system/design_system.dart';
import 'package:mobil_aricilik/features/today/presentation/today_screen.dart';

void main() {
  group('App', () {
    testWidgets('açılışta uygulama adını gösterir', (tester) async {
      await tester.pumpWidget(const ProviderScope(child: App()));
      await tester.pumpAndSettle();

      expect(find.text('Mobil Arıcılık'), findsOneWidget);
    });

    testWidgets('Türkçe yerelde de uygulama adını gösterir', (tester) async {
      tester.platformDispatcher.localesTestValue = const [Locale('tr')];
      addTearDown(tester.platformDispatcher.clearLocalesTestValue);

      await tester.pumpWidget(const ProviderScope(child: App()));
      await tester.pumpAndSettle();

      expect(find.text('Mobil Arıcılık'), findsOneWidget);
    });

    testWidgets('görünüm seçimi değişince tema da değişir', (tester) async {
      final container = ProviderContainer.test();
      await tester.pumpWidget(
        UncontrolledProviderScope(container: container, child: const App()),
      );
      await tester.pumpAndSettle();

      AppColors colors() =>
          Theme.of(tester.element(find.byType(TodayScreen)))
              .extension<AppColors>()!;

      expect(colors(), same(AppColors.light));

      container
          .read(appearanceProvider.notifier)
          .setColorMode(AppColorMode.sun);
      await tester.pumpAndSettle();

      expect(colors(), same(AppColors.sun));
    });
  });
}
