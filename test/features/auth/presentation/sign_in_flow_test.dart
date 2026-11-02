import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mobil_arici/app/app.dart';
import 'package:mobil_arici/app/router.dart';
import 'package:mobil_arici/app/routes.dart';
import 'package:mobil_arici/app/shell/app_navigation_bar.dart';
import 'package:mobil_arici/core/db/app_database_provider.dart';
import 'package:mobil_arici/core/design_system/design_system.dart';
import 'package:mobil_arici/features/auth/domain/auth_failure.dart';
import 'package:mobil_arici/features/auth/presentation/auth_providers.dart';
import 'package:mobil_arici/features/auth/presentation/sign_in_code_screen.dart';
import 'package:mobil_arici/features/auth/presentation/sign_in_controller.dart';
import 'package:mobil_arici/features/auth/presentation/sign_in_email_screen.dart';
import 'package:mobil_arici/features/onboarding/presentation/onboarding_screen.dart';
import 'package:mobil_arici/features/today/presentation/today_screen.dart';

import '../../../helpers/fake_auth_service.dart';
import '../../../helpers/fake_organization_service.dart';
import '../../../helpers/fake_sync_service.dart';
import '../../../helpers/test_database.dart';

/// Varsayılan olarak kullanıcının sunucuda işletmesi var.
Future<ProviderContainer> _pumpApp(
  WidgetTester tester,
  FakeAuthService auth, {
  FakeOrganizationService? organizations,
}) async {
  final container = ProviderContainer.test(
    overrides: [
      authServiceProvider.overrideWithValue(auth),
      ...organizationOverrides(service: organizations),
      // Bugün'ün üst barındaki senkron ikonu yerel DB'yi okur.
      appDatabaseProvider.overrideWithValue(openTestDatabase()),
      ...syncOverrides(),
    ],
  );
  await tester.pumpWidget(
    UncontrolledProviderScope(container: container, child: const App()),
  );
  await tester.pumpAndSettle();
  return container;
}

Finder _field(Type screen) =>
    find.descendant(of: find.byType(screen), matching: find.byType(TextField));

BigButton _button(WidgetTester tester, String label) =>
    tester.widget<BigButton>(find.widgetWithText(BigButton, label));

/// Tekrar gönder gibi metin butonları.
TextButton _textButton(WidgetTester tester, String label) =>
    tester.widget<TextButton>(find.widgetWithText(TextButton, label));

/// E-postayı yazıp kodu ister; geçiş bitince kod ekranındadır. Sayaç
/// çalıştığı için pumpAndSettle kullanılmaz, o 60 saniyeyi bitirirdi.
Future<void> _requestCode(WidgetTester tester, String email) async {
  await tester.enterText(_field(SignInEmailScreen), email);
  await tester.tap(find.text('Send code'));
  await tester.pump();
  await tester.pump(const Duration(seconds: 1));
}

/// Uygulamayı ve container'ı kapatır; sayaç zamanlayıcısı test bitmeden
/// iptal olur. (Uygulamada ProviderScope hiç kapanmaz; denetleyiciyi giriş
/// ekranlarından çıkılması atar.)
Future<void> _closeApp(WidgetTester tester) async {
  final container = ProviderScope.containerOf(
    tester.element(find.byType(Scaffold).first),
  );
  await tester.pumpWidget(const SizedBox.shrink());
  container.dispose();
}

void main() {
  group('Giriş yönlendirmesi', () {
    testWidgets('giriş yapılmamışsa giriş ekranı açılır, sekmeler yok', (
      tester,
    ) async {
      await _pumpApp(tester, FakeAuthService());

      expect(find.byType(SignInEmailScreen), findsOneWidget);
      expect(find.byType(AppNavigationBar), findsNothing);
    });

    testWidgets('giriş yapılmamışken başka rotalar açılamaz', (tester) async {
      final container = await _pumpApp(tester, FakeAuthService());

      for (final route in [AppRoutes.settings, AppRoutes.scan]) {
        container.read(routerProvider).go(route);
        await tester.pumpAndSettle();
        expect(find.byType(SignInEmailScreen), findsOneWidget, reason: route);
      }
    });

    testWidgets('kod gönderilmeden kod ekranına gelinirse e-postaya dönülür', (
      tester,
    ) async {
      final container = await _pumpApp(tester, FakeAuthService());

      container.read(routerProvider).go(AppRoutes.signInCode);
      await tester.pumpAndSettle();

      expect(find.byType(SignInCodeScreen), findsNothing);
      expect(find.byType(SignInEmailScreen), findsOneWidget);
    });

    testWidgets('giriş yapılmışsa giriş ekranı yerine Bugün açılır', (
      tester,
    ) async {
      final container = await _pumpApp(tester, FakeAuthService(user: testUser));

      container.read(routerProvider).go(AppRoutes.signIn);
      await tester.pumpAndSettle();

      expect(find.byType(SignInEmailScreen), findsNothing);
      expect(find.byType(TodayScreen), findsOneWidget);
    });

    testWidgets('oturum sunucudan düşerse giriş ekranına geçilir', (
      tester,
    ) async {
      final auth = FakeAuthService(user: testUser);
      final container = await _pumpApp(tester, auth);
      container.read(routerProvider).go(AppRoutes.settings);
      await tester.pumpAndSettle();

      auth.emit(null);
      await tester.pumpAndSettle();

      expect(find.byType(SignInEmailScreen), findsOneWidget);
      expect(find.byType(AppNavigationBar), findsNothing);
    });
  });

  group('E-posta adımı', () {
    testWidgets('e-posta alanı odaksız açılır, klavye kendiliğinden açılmaz', (
      tester,
    ) async {
      await _pumpApp(tester, FakeAuthService());

      final field = tester.widget<EditableText>(
        find.descendant(
          of: _field(SignInEmailScreen),
          matching: find.byType(EditableText),
        ),
      );
      expect(field.focusNode.hasFocus, isFalse);
    });

    testWidgets('geçersiz e-postada kod istenmez, hata gösterilir', (
      tester,
    ) async {
      final auth = FakeAuthService();
      await _pumpApp(tester, auth);

      await _requestCode(tester, 'ari@');

      expect(auth.sentCodes, isEmpty);
      expect(find.byType(SignInEmailScreen), findsOneWidget);
      expect(find.text('Enter a valid email address.'), findsOneWidget);
      expect(find.byIcon(AppStatus.critical.icon), findsOneWidget);

      // Yazmaya başlayınca hata kalkar.
      await tester.enterText(_field(SignInEmailScreen), 'ari@example.com');
      await tester.pump();
      expect(find.text('Enter a valid email address.'), findsNothing);
    });

    testWidgets('ağ yoksa hata gösterilir, e-posta ekranında kalınır', (
      tester,
    ) async {
      final auth = FakeAuthService()..sendFailure = AuthFailure.network;
      await _pumpApp(tester, auth);

      await _requestCode(tester, 'ari@example.com');

      expect(auth.sentCodes, hasLength(1));
      expect(find.byType(SignInCodeScreen), findsNothing);
      expect(
        find.text("Couldn't connect. Check your internet and try again."),
        findsOneWidget,
      );
    });

    testWidgets('kod e-postası uygulamanın dilinde istenir', (tester) async {
      tester.platformDispatcher.localesTestValue = const [Locale('tr')];
      addTearDown(tester.platformDispatcher.clearLocalesTestValue);
      final auth = FakeAuthService();
      await _pumpApp(tester, auth);

      await tester.enterText(_field(SignInEmailScreen), ' Ari@Example.com ');
      await tester.tap(find.text('Kod gönder'));
      await tester.pump();

      expect(auth.sentCodes.single, (email: 'ari@example.com', locale: 'tr'));

      await _closeApp(tester);
    });
  });

  group('Kod adımı', () {
    testWidgets('Kodu yapıştır panodaki rakamları yazar ve doğrular', (
      tester,
    ) async {
      tester.binding.defaultBinaryMessenger.setMockMethodCallHandler(
        SystemChannels.platform,
        (call) async => call.method == 'Clipboard.getData'
            ? <String, Object?>{'text': 'Kodun: 482 913'}
            : null,
      );
      addTearDown(
        () => tester.binding.defaultBinaryMessenger.setMockMethodCallHandler(
          SystemChannels.platform,
          null,
        ),
      );
      final auth = FakeAuthService();
      await _pumpApp(tester, auth);
      await _requestCode(tester, 'ari@example.com');

      await tester.tap(find.text('Paste code'));
      await tester.pumpAndSettle();

      expect(auth.verifiedCodes.single.code, '482913');
      expect(find.byType(TodayScreen), findsOneWidget);
    });

    testWidgets('E-postayı değiştir e-posta adımına döner', (tester) async {
      final auth = FakeAuthService();
      await _pumpApp(tester, auth);
      await _requestCode(tester, 'ari@example.com');

      await tester.tap(find.text('Change email'));
      await tester.pumpAndSettle();

      expect(find.byType(SignInEmailScreen), findsOneWidget);
      expect(find.byType(SignInCodeScreen), findsNothing);
      await _closeApp(tester);
    });

    testWidgets('kod yazılınca kendiliğinden doğrulanır, Bugün açılır', (
      tester,
    ) async {
      final auth = FakeAuthService();
      final container = await _pumpApp(tester, auth);

      await _requestCode(tester, 'ari@example.com');

      expect(find.byType(SignInCodeScreen), findsOneWidget);
      expect(
        find.text('We sent a 6-digit code to ari@example.com.'),
        findsOneWidget,
      );
      final editable = tester.widget<EditableText>(
        find.descendant(
          of: _field(SignInCodeScreen),
          matching: find.byType(EditableText),
        ),
      );
      // Klavye kendiliğinden açılmaz.
      expect(editable.focusNode.hasFocus, isFalse);

      await tester.enterText(_field(SignInCodeScreen), '482913');
      await tester.pumpAndSettle();

      expect(auth.verifiedCodes.single, (
        email: 'ari@example.com',
        code: '482913',
        locale: 'en',
      ));
      expect(find.byType(TodayScreen), findsOneWidget);
      expect(find.byType(AppNavigationBar), findsOneWidget);
      // Giriş ekranları kapanınca akışın durumu ve sayacı da atılır.
      expect(container.exists(signInControllerProvider), isFalse);
    });

    testWidgets(
      "işletmesi olmayan kullanıcı girişten sonra onboarding'e geçer",
      (tester) async {
        await _pumpApp(
          tester,
          FakeAuthService(),
          organizations: FakeOrganizationService(),
        );
        await _requestCode(tester, 'ari@example.com');

        await tester.enterText(_field(SignInCodeScreen), '482913');
        await tester.pumpAndSettle();

        expect(find.byType(OnboardingScreen), findsOneWidget);
        expect(find.byType(TodayScreen), findsNothing);
        expect(find.byType(AppNavigationBar), findsNothing);
      },
    );

    testWidgets('yapıştırılan metindeki kod ayıklanır', (tester) async {
      final auth = FakeAuthService();
      await _pumpApp(tester, auth);
      await _requestCode(tester, 'ari@example.com');

      await tester.enterText(
        _field(SignInCodeScreen),
        'Your Mobil Arıcı code: 482913',
      );
      await tester.pumpAndSettle();

      expect(auth.verifiedCodes.single.code, '482913');
    });

    testWidgets('her hane kendi kutusunda görünür', (tester) async {
      await _pumpApp(tester, FakeAuthService());
      await _requestCode(tester, 'ari@example.com');

      await tester.enterText(_field(SignInCodeScreen), '482');
      await tester.pump();

      for (final digit in ['4', '8', '2']) {
        expect(find.text(digit), findsOneWidget, reason: digit);
      }
      expect(_button(tester, 'Sign in').onPressed, isNull);

      await _closeApp(tester);
    });

    testWidgets('yanlış kodda hata gösterilir, alan boşalır', (tester) async {
      final auth = FakeAuthService()..verifyFailure = AuthFailure.invalidCode;
      await _pumpApp(tester, auth);
      await _requestCode(tester, 'ari@example.com');

      await tester.enterText(_field(SignInCodeScreen), '000000');
      await tester.pump();

      expect(find.byType(SignInCodeScreen), findsOneWidget);
      expect(
        find.text(
          'The code is wrong or has expired. Try again or request a new code.',
        ),
        findsOneWidget,
      );
      final field = tester.widget<TextField>(_field(SignInCodeScreen));
      expect(field.controller!.text, isEmpty);
      expect(field.focusNode!.hasFocus, isTrue);

      await _closeApp(tester);
    });

    testWidgets('tekrar gönder sayaç bitince açılır', (tester) async {
      final auth = FakeAuthService();
      final container = await _pumpApp(tester, auth);
      await _requestCode(tester, 'ari@example.com');

      final seconds = container.read(signInControllerProvider).resendSeconds;
      expect(seconds, inInclusiveRange(1, 60));
      expect(_textButton(tester, 'Resend code ($seconds s)').onPressed, isNull);

      await tester.pump(const Duration(seconds: 1));
      expect(find.text('Resend code (${seconds - 1} s)'), findsOneWidget);

      await tester.pump(Duration(seconds: seconds - 1));
      expect(_textButton(tester, 'Resend code').onPressed, isNotNull);

      await tester.tap(find.text('Resend code'));
      await tester.pump();

      expect(auth.sentCodes, hasLength(2));
      expect(find.text('A new code is on its way.'), findsOneWidget);
      expect(find.text('Resend code (60 s)'), findsOneWidget);

      await _closeApp(tester);
    });

    testWidgets('geri dönülüp aynı adres girilirse yeni kod istenmez', (
      tester,
    ) async {
      final auth = FakeAuthService();
      await _pumpApp(tester, auth);
      await _requestCode(tester, 'ari@example.com');

      await tester.pageBack();
      await tester.pump();
      await tester.pump(const Duration(seconds: 1));
      expect(find.byType(SignInEmailScreen), findsOneWidget);

      await tester.tap(find.text('Send code'));
      await tester.pump();
      await tester.pump(const Duration(seconds: 1));

      expect(auth.sentCodes, hasLength(1));
      expect(find.byType(SignInCodeScreen), findsOneWidget);

      await _closeApp(tester);
    });
  });
}
