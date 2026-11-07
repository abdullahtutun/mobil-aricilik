import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mobil_arici/app/app.dart';
import 'package:mobil_arici/app/router.dart';
import 'package:mobil_arici/app/routes.dart';
import 'package:mobil_arici/app/shell/more_screen.dart';
import 'package:mobil_arici/core/design_system/design_system.dart';
import 'package:mobil_arici/core/l10n/app_language.dart';
import 'package:mobil_arici/core/l10n/language_provider.dart';
import 'package:mobil_arici/features/auth/presentation/sign_in_email_screen.dart';
import 'package:mobil_arici/features/settings/presentation/settings_screen.dart';

import '../../helpers/fake_auth_service.dart';

Future<ProviderContainer> _pumpSettings(
  WidgetTester tester, {
  FakeAuthService? auth,
}) async {
  final container = ProviderContainer.test(overrides: signedIn(auth: auth));
  await tester.pumpWidget(
    UncontrolledProviderScope(container: container, child: const App()),
  );
  container.read(routerProvider).go(AppRoutes.settings);
  await tester.pumpAndSettle();
  return container;
}

Finder _inSettings(Finder finder) =>
    find.descendant(of: find.byType(SettingsScreen), matching: finder);

Future<void> _tapInSettings(WidgetTester tester, String text) async {
  final target = _inSettings(find.text(text));
  await tester.ensureVisible(target);
  await tester.pumpAndSettle();
  await tester.tap(target);
  await tester.pumpAndSettle();
}

/// Dil satırına dokunur, açılan sayfadan [language]'i seçer.
Future<void> _chooseLanguage(
  WidgetTester tester, {
  required String row,
  required String language,
}) async {
  await _tapInSettings(tester, row);
  await tester.tap(
    find.descendant(
      of: find.byType(OptionSheet<AppLanguage>),
      matching: find.text(language),
    ),
  );
  await tester.pumpAndSettle();
}

void main() {
  group('Ayarlar', () {
    testWidgets('Daha fazla sekmesinden açılır', (tester) async {
      await tester.pumpWidget(
        ProviderScope(overrides: signedIn(), child: const App()),
      );
      await tester.pumpAndSettle();

      await tester.tap(find.text('More'));
      await tester.pumpAndSettle();
      // Yardım bölümü ekranın altında; tembel liste kaydırınca kurar.
      await tester.scrollUntilVisible(
        find.text('Settings'),
        200,
        scrollable: find
            .descendant(
              of: find.byType(MoreScreen),
              matching: find.byType(Scrollable),
            )
            .first,
      );
      await tester.ensureVisible(find.text('Settings'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Settings'));
      await tester.pumpAndSettle();

      expect(find.byType(SettingsScreen), findsOneWidget);
      // PDF raporları Daha fazla'dan açılır; Ayarlar'da satırı yok.
      expect(
        _inSettings(find.text('PDF reports', skipOffstage: false)),
        findsNothing,
      );
    });

    testWidgets('dil satırı sayfa açar; seçim arayüz dilini değiştirir', (
      tester,
    ) async {
      final container = await _pumpSettings(tester);

      await _chooseLanguage(tester, row: 'Language', language: 'Türkçe');

      expect(container.read(languageProvider), AppLanguage.turkish);
      expect(find.text('Ayarlar'), findsOneWidget);
      expect(_inSettings(find.text('Türkçe')), findsOneWidget);

      await _chooseLanguage(tester, row: 'Dil', language: 'Sistem');

      expect(container.read(languageProvider), AppLanguage.system);
      expect(find.text('Settings'), findsOneWidget);
    });

    testWidgets('seçili dil sayfada işaretli; kapatılırsa değişmez', (
      tester,
    ) async {
      final container = await _pumpSettings(tester);
      await _chooseLanguage(tester, row: 'Language', language: 'English');

      await _tapInSettings(tester, 'Language');
      final sheet = find.byType(OptionSheet<AppLanguage>);
      expect(
        tester.getSemantics(
          find.descendant(of: sheet, matching: find.byType(OptionTile)).at(2),
        ),
        isSemantics(label: 'English', isSelected: true, isButton: true),
      );
      await tester.tapAt(Offset.zero);
      await tester.pumpAndSettle();

      expect(sheet, findsNothing);
      expect(container.read(languageProvider), AppLanguage.english);
    });

    testWidgets('tema seçimi görünüm modunu değiştirir', (tester) async {
      final container = await _pumpSettings(tester);
      AppColorMode colorMode() => container.read(appearanceProvider).colorMode;

      expect(colorMode(), AppColorMode.system);

      for (final (label, mode) in [
        ('Sun', AppColorMode.sun),
        ('Dark', AppColorMode.dark),
        ('Light', AppColorMode.light),
      ]) {
        await _tapInSettings(tester, label);
        expect(colorMode(), mode, reason: label);
      }

      await _tapInSettings(tester, 'Light');
      expect(colorMode(), AppColorMode.light);
    });

    testWidgets('eldiven modu anahtarla açılır ve kapanır', (tester) async {
      final container = await _pumpSettings(tester);
      bool glove() => container.read(appearanceProvider).gloveMode;

      await _tapInSettings(tester, 'Glove mode');
      expect(glove(), isTrue);

      await _tapInSettings(tester, 'Glove mode');
      expect(glove(), isFalse);
    });

    testWidgets('ülke işletmeden gelir; gösterilir ama seçilmez', (
      tester,
    ) async {
      await _pumpSettings(tester);

      final row = find.ancestor(
        of: _inSettings(find.text('Country')),
        matching: find.byType(ListRow),
      );
      expect(tester.widget<ListRow>(row).value, 'Türkiye · TR');
      expect(tester.widget<ListRow>(row).onTap, isNull);
    });
  });

  group('Hesap', () {
    // Hesap bölümü listenin sonunda; kaydırılmadan kurulmaz.
    Future<void> scrollToAccount(WidgetTester tester) =>
        tester.scrollUntilVisible(
          _inSettings(find.text('Sign out')),
          200,
          scrollable: _inSettings(find.byType(Scrollable)).first,
        );

    testWidgets('giriş yapılan e-posta görünür', (tester) async {
      await _pumpSettings(tester);
      await scrollToAccount(tester);

      final email = _inSettings(find.text('Signed in as ${testUser.email}'));
      await tester.ensureVisible(email);
      expect(email, findsOneWidget);
    });

    testWidgets('çıkış onaylanınca oturum kapanır, giriş ekranı açılır', (
      tester,
    ) async {
      final auth = FakeAuthService(user: testUser);
      await _pumpSettings(tester, auth: auth);
      await scrollToAccount(tester);

      await _tapInSettings(tester, 'Sign out');
      expect(find.text('Sign out?'), findsOneWidget);
      await tester.tap(
        find.descendant(
          of: find.byType(AlertDialog),
          matching: find.text('Sign out'),
        ),
      );
      await tester.pumpAndSettle();

      expect(auth.signOutCount, 1);
      expect(find.byType(SignInEmailScreen), findsOneWidget);
      expect(find.byType(SettingsScreen), findsNothing);
    });

    testWidgets('vazgeçilirse oturum açık kalır', (tester) async {
      final auth = FakeAuthService(user: testUser);
      await _pumpSettings(tester, auth: auth);
      await scrollToAccount(tester);

      await _tapInSettings(tester, 'Sign out');
      await tester.tap(find.text('Cancel'));
      await tester.pumpAndSettle();

      expect(auth.signOutCount, 0);
      expect(find.byType(SettingsScreen), findsOneWidget);
    });

    testWidgets('en altta uygulama sürümü yazar', (tester) async {
      await _pumpSettings(tester);
      final version = _inSettings(find.text('Version 1.0.0'));
      await tester.scrollUntilVisible(
        version,
        200,
        scrollable: _inSettings(find.byType(Scrollable)).first,
      );
      expect(version, findsOneWidget);
    });

    testWidgets('Türkçe sürüm metni', (tester) async {
      final container = await _pumpSettings(tester);
      container.read(languageProvider.notifier).language = AppLanguage.turkish;
      await tester.pumpAndSettle();
      final version = _inSettings(find.text('Sürüm 1.0.0'));
      await tester.scrollUntilVisible(
        version,
        200,
        scrollable: _inSettings(find.byType(Scrollable)).first,
      );
      expect(version, findsOneWidget);
    });

    testWidgets('sayfanın sonu telefonun alt tuşlarının üstünde biter; geri '
        'oku büyük', (tester) async {
      // Android'in alttaki geri / ana ekran tuşları: 48dp.
      const navBar = 48.0;
      tester.view.padding = FakeViewPadding(
        bottom: navBar * tester.view.devicePixelRatio,
      );
      addTearDown(tester.view.resetPadding);
      await _pumpSettings(tester);

      final version = _inSettings(find.text('Version 1.0.0'));
      await tester.scrollUntilVisible(
        version,
        200,
        scrollable: _inSettings(find.byType(Scrollable)).first,
      );
      // Liste sonuna kadar kaydırılınca son satır tuşların üstünde kalır.
      await tester.drag(
        _inSettings(find.byType(Scrollable)).first,
        const Offset(0, -2000),
      );
      await tester.pumpAndSettle();
      final screenHeight =
          tester.view.physicalSize.height / tester.view.devicePixelRatio;
      expect(
        tester.getRect(version).bottom,
        lessThanOrEqualTo(screenHeight - navBar),
      );
      expect(
        tester.getRect(find.byType(SettingsScreen)).bottom,
        screenHeight - navBar,
      );

      final back = tester.widget<Icon>(
        find.descendant(
          of: find.byType(BackButton),
          matching: find.byType(Icon),
        ),
      );
      expect(back.size, AppSizes.standard.navIcon);
      expect(AppSizes.standard.navIcon, greaterThan(AppSizes.standard.icon));
    });
  });
}
