import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mobil_aricilik/app/app.dart';
import 'package:mobil_aricilik/core/design_system/design_system.dart';
import 'package:mobil_aricilik/core/l10n/app_language.dart';
import 'package:mobil_aricilik/core/l10n/language_provider.dart';
import 'package:mobil_aricilik/features/today/presentation/today_screen.dart';

void main() {
  group('App', () {
    testWidgets('açılışta Bugün sekmesi açılır', (tester) async {
      await tester.pumpWidget(const ProviderScope(child: App()));
      await tester.pumpAndSettle();

      expect(find.byType(TodayScreen), findsOneWidget);
      expect(find.text('Nothing for today'), findsOneWidget);
    });

    testWidgets('Türkçe yerelde sekmeler Türkçe', (tester) async {
      tester.platformDispatcher.localesTestValue = const [Locale('tr')];
      addTearDown(tester.platformDispatcher.clearLocalesTestValue);

      await tester.pumpWidget(const ProviderScope(child: App()));
      await tester.pumpAndSettle();

      for (final label in ['Arılıklar', 'Okut', 'Görevler', 'Daha fazla']) {
        expect(find.text(label), findsOneWidget);
      }
      // Bugün hem sekme etiketi hem ekran başlığı.
      expect(find.text('Bugün'), findsNWidgets(2));
    });

    testWidgets('pencere başlığı uygulama adı', (tester) async {
      await tester.pumpWidget(const ProviderScope(child: App()));
      await tester.pumpAndSettle();

      final title = tester.widget<Title>(find.byType(Title));
      expect(title.title, 'Mobil Arıcı');
    });

    testWidgets('desteklenmeyen cihaz dilinde İngilizce açılır', (
      tester,
    ) async {
      tester.platformDispatcher.localesTestValue = const [Locale('de', 'DE')];
      addTearDown(tester.platformDispatcher.clearLocalesTestValue);

      await tester.pumpWidget(const ProviderScope(child: App()));
      await tester.pumpAndSettle();

      expect(
        Localizations.localeOf(tester.element(find.byType(TodayScreen))),
        const Locale('en'),
      );
    });

    testWidgets('seçilen dil cihaz dilinin önüne geçer', (tester) async {
      tester.platformDispatcher.localesTestValue = const [Locale('en', 'US')];
      addTearDown(tester.platformDispatcher.clearLocalesTestValue);

      final container = ProviderContainer.test();
      await tester.pumpWidget(
        UncontrolledProviderScope(container: container, child: const App()),
      );
      await tester.pumpAndSettle();

      Locale locale() =>
          Localizations.localeOf(tester.element(find.byType(TodayScreen)));

      expect(locale(), const Locale('en'));

      container.read(languageProvider.notifier).language = AppLanguage.turkish;
      await tester.pumpAndSettle();

      expect(locale(), const Locale('tr'));

      container.read(languageProvider.notifier).language = AppLanguage.system;
      await tester.pumpAndSettle();

      expect(locale(), const Locale('en'));
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
