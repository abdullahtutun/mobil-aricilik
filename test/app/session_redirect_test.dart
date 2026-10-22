import 'package:flutter_test/flutter_test.dart';
import 'package:mobil_arici/app/routes.dart';
import 'package:mobil_arici/app/session_redirect.dart';

String? _redirect(SessionStage stage, String location) =>
    sessionRedirect(stage: stage, location: Uri.parse(location));

void main() {
  group('sessionStageOf', () {
    test('giriş yoksa işletmeye bakılmaz', () {
      expect(
        sessionStageOf(signedIn: false, hasOrganization: true),
        SessionStage.signedOut,
      );
    });

    test('girişli kullanıcı işletmesine göre ayrılır', () {
      expect(
        sessionStageOf(signedIn: true, hasOrganization: false),
        SessionStage.needsOrganization,
      );
      expect(
        sessionStageOf(signedIn: true, hasOrganization: true),
        SessionStage.ready,
      );
    });
  });

  group('sessionRedirect', () {
    test('giriş yapılmamışsa her konum giriş ekranına gider', () {
      for (final path in [
        AppRoutes.today,
        AppRoutes.settings,
        AppRoutes.scan,
        AppRoutes.onboarding,
        '/hives/42',
        '/sign-inx',
      ]) {
        expect(
          _redirect(SessionStage.signedOut, path),
          AppRoutes.signIn,
          reason: path,
        );
      }
    });

    test('giriş yapılmamışken giriş ekranlarında kalınır', () {
      expect(_redirect(SessionStage.signedOut, AppRoutes.signIn), isNull);
      expect(_redirect(SessionStage.signedOut, AppRoutes.signInCode), isNull);
    });

    test("işletme yoksa giriş ekranları ve Bugün onboarding'e gider", () {
      for (final path in [
        AppRoutes.signIn,
        AppRoutes.signInCode,
        AppRoutes.today,
      ]) {
        expect(
          _redirect(SessionStage.needsOrganization, path),
          AppRoutes.onboarding,
          reason: path,
        );
      }
    });

    test('işletme yoksa başka konum onboarding sonrasına saklanır', () {
      expect(
        _redirect(SessionStage.needsOrganization, '/hives/42?tab=notes'),
        '/onboarding?from=%2Fhives%2F42%3Ftab%3Dnotes',
      );
    });

    test('işletme yoksa onboarding açık kalır', () {
      expect(
        _redirect(SessionStage.needsOrganization, AppRoutes.onboarding),
        isNull,
      );
      expect(
        _redirect(SessionStage.needsOrganization, '/onboarding?from=%2Ftasks'),
        isNull,
      );
    });

    test("her şey hazırsa giriş ekranları ve onboarding Bugün'e gider", () {
      for (final path in [
        AppRoutes.signIn,
        AppRoutes.signInCode,
        AppRoutes.onboarding,
      ]) {
        expect(
          _redirect(SessionStage.ready, path),
          AppRoutes.today,
          reason: path,
        );
      }
    });

    test('her şey hazırsa saklanan konuma dönülür', () {
      expect(
        _redirect(
          SessionStage.ready,
          '/onboarding?from=%2Fhives%2F42%3Ftab%3Dnotes',
        ),
        '/hives/42?tab=notes',
      );
    });

    test('saklanan konum uygulama dışını gösteriyorsa Bugün açılır', () {
      for (final from in ['https://example.com', '//example.com/x', 'tasks']) {
        expect(
          _redirect(
            SessionStage.ready,
            Uri(
              path: AppRoutes.onboarding,
              queryParameters: {onboardingFromParameter: from},
            ).toString(),
          ),
          AppRoutes.today,
          reason: from,
        );
      }
    });

    test('her şey hazırsa diğer konumlara dokunulmaz', () {
      expect(_redirect(SessionStage.ready, AppRoutes.settings), isNull);
      expect(_redirect(SessionStage.ready, '/hives/42'), isNull);
    });
  });
}
