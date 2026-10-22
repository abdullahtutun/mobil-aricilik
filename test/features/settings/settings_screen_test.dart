import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mobil_arici/app/app.dart';
import 'package:mobil_arici/app/router.dart';
import 'package:mobil_arici/app/routes.dart';
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

/// [section] başlıklı kartın içi; "Sistem" hem dilde hem temada var.
Finder _inSection(String section, Finder finder) => find.descendant(
  of: find.ancestor(of: find.text(section), matching: find.byType(SectionCard)),
  matching: finder,
);

Future<void> _tapInSettings(
  WidgetTester tester,
  String text, {
  String? section,
}) async {
  final target = section == null
      ? _inSettings(find.text(text))
      : _inSection(section, find.text(text));
  await tester.ensureVisible(target);
  await tester.pumpAndSettle();
  await tester.tap(target);
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
      await tester.tap(find.text('Settings'));
      await tester.pumpAndSettle();

      expect(find.byType(SettingsScreen), findsOneWidget);
    });

    testWidgets('dil seçimi arayüz dilini değiştirir', (tester) async {
      final container = await _pumpSettings(tester);

      await _tapInSettings(tester, 'Türkçe');

      expect(container.read(languageProvider), AppLanguage.turkish);
      expect(find.text('Ayarlar'), findsOneWidget);

      await _tapInSettings(tester, 'Sistem', section: 'Dil');

      expect(container.read(languageProvider), AppLanguage.system);
      expect(find.text('Settings'), findsOneWidget);
    });

    testWidgets('seçili chip yeniden dokunulunca seçim kalkmaz', (
      tester,
    ) async {
      final container = await _pumpSettings(tester);

      await _tapInSettings(tester, 'English');
      await _tapInSettings(tester, 'English');

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

    testWidgets('ülke seçimi yok; ülke işletmeden gelir', (tester) async {
      await _pumpSettings(tester);

      expect(_inSettings(find.text('Country')), findsNothing);
      expect(_inSettings(find.text('TR · TRY')), findsNothing);
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

      final email = _inSection(
        'Account',
        find.text('Signed in as ${testUser.email}'),
      );
      await tester.ensureVisible(email);
      expect(email, findsOneWidget);
    });

    testWidgets('çıkış onaylanınca oturum kapanır, giriş ekranı açılır', (
      tester,
    ) async {
      final auth = FakeAuthService(user: testUser);
      await _pumpSettings(tester, auth: auth);
      await scrollToAccount(tester);

      await _tapInSettings(tester, 'Sign out', section: 'Account');
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

      await _tapInSettings(tester, 'Sign out', section: 'Account');
      await tester.tap(find.text('Cancel'));
      await tester.pumpAndSettle();

      expect(auth.signOutCount, 0);
      expect(find.byType(SettingsScreen), findsOneWidget);
    });
  });
}
