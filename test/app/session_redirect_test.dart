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

    test('bekleyen silme talebi işletmeden önce sorulur', () {
      expect(
        sessionStageOf(
          signedIn: true,
          hasOrganization: true,
          deletionPending: true,
        ),
        SessionStage.deletionPending,
      );
      expect(
        sessionStageOf(
          signedIn: false,
          hasOrganization: true,
          deletionPending: true,
        ),
        SessionStage.signedOut,
      );
    });

    test('bekleyen silmede her konum silme kararına gider', () {
      expect(
        _redirect(SessionStage.deletionPending, AppRoutes.today),
        AppRoutes.deletionPending,
      );
      expect(
        _redirect(SessionStage.deletionPending, AppRoutes.deletionPending),
        isNull,
      );
      // Karar verilince (talep iptal) kapı geçilir, Bugün açılır.
      expect(
        _redirect(SessionStage.ready, AppRoutes.deletionPending),
        AppRoutes.today,
      );
    });

    test('silme bitiş ekranı oturum kapanınca da açık kalır', () {
      expect(
        _redirect(SessionStage.signedOut, AppRoutes.accountDeleted),
        isNull,
      );
      expect(_redirect(SessionStage.ready, AppRoutes.accountDeleted), isNull);
      expect(
        _redirect(SessionStage.signedOut, AppRoutes.deleteAccount),
        AppRoutes.signIn,
      );
    });

    test('kurulum yalnız işletme varken sürer', () {
      expect(
        sessionStageOf(signedIn: true, hasOrganization: true, settingUp: true),
        SessionStage.settingUp,
      );
      expect(
        sessionStageOf(signedIn: true, hasOrganization: false, settingUp: true),
        SessionStage.needsOrganization,
      );
      expect(
        sessionStageOf(signedIn: false, hasOrganization: true, settingUp: true),
        SessionStage.signedOut,
      );
    });

    test('ilk arılık adımında yalnız harita seçici açılabilir', () {
      expect(
        sessionRedirect(
          stage: SessionStage.settingUp,
          location: Uri.parse(
            AppRoutes.locationPickerAt(latitude: 39.5, longitude: 38.5),
          ),
        ),
        isNull,
      );
      expect(
        sessionRedirect(
          stage: SessionStage.settingUp,
          location: Uri.parse(AppRoutes.apiaries),
        ),
        startsWith(AppRoutes.onboardingApiary),
      );
      expect(
        sessionRedirect(
          stage: SessionStage.needsOrganization,
          location: Uri.parse(AppRoutes.locationPicker),
        ),
        startsWith(AppRoutes.onboarding),
      );
    });

    test('ilk tam çekme bitmeden sekmeler açılmaz; kurulum önce gelir', () {
      expect(
        sessionStageOf(
          signedIn: true,
          hasOrganization: true,
          fullPullDone: false,
        ),
        SessionStage.initialSync,
      );
      expect(
        sessionStageOf(
          signedIn: true,
          hasOrganization: true,
          settingUp: true,
          fullPullDone: false,
        ),
        SessionStage.settingUp,
      );
      expect(
        sessionStageOf(
          signedIn: true,
          hasOrganization: false,
          fullPullDone: false,
        ),
        SessionStage.needsOrganization,
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

    test('işletme yoksa ilk arılık adımı onboarding başına döner', () {
      expect(
        _redirect(SessionStage.needsOrganization, AppRoutes.onboardingApiary),
        AppRoutes.onboarding,
      );
      expect(
        _redirect(
          SessionStage.needsOrganization,
          '/onboarding/apiary?from=%2Ftasks',
        ),
        '/onboarding?from=%2Ftasks',
      );
    });

    test('işletme yeni kurulduysa ilk arılık adımı açılır, konum taşınır', () {
      expect(
        _redirect(SessionStage.settingUp, AppRoutes.onboarding),
        AppRoutes.onboardingApiary,
      );
      expect(
        _redirect(SessionStage.settingUp, '/onboarding?from=%2Ftasks'),
        '/onboarding/apiary?from=%2Ftasks',
      );
      expect(
        _redirect(SessionStage.settingUp, AppRoutes.onboardingApiary),
        isNull,
      );
      expect(
        _redirect(SessionStage.settingUp, '/onboarding/apiary?from=%2Ftasks'),
        isNull,
      );
    });

    test('kurulum sürerken gelen konum sonrasına saklanır', () {
      expect(
        _redirect(SessionStage.settingUp, '/hives/42'),
        '/onboarding/apiary?from=%2Fhives%2F42',
      );
      for (final path in [AppRoutes.today, AppRoutes.signIn]) {
        expect(
          _redirect(SessionStage.settingUp, path),
          AppRoutes.onboardingApiary,
          reason: path,
        );
      }
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

    test('ilk çekme sürerken her konum ilk çekme ekranına gider, konum '
        'saklanır', () {
      for (final path in [
        AppRoutes.today,
        AppRoutes.signIn,
        AppRoutes.onboarding,
        AppRoutes.onboardingApiary,
      ]) {
        expect(
          _redirect(SessionStage.initialSync, path),
          AppRoutes.initialSync,
          reason: path,
        );
      }
      expect(
        _redirect(SessionStage.initialSync, '/hives/42'),
        '/initial-sync?from=%2Fhives%2F42',
      );
      expect(
        _redirect(SessionStage.initialSync, '/onboarding/apiary?from=%2Ftasks'),
        '/initial-sync?from=%2Ftasks',
      );
    });

    test('ilk çekme sürerken ilk çekme ekranı açık kalır', () {
      expect(
        _redirect(SessionStage.initialSync, AppRoutes.initialSync),
        isNull,
      );
      expect(
        _redirect(SessionStage.initialSync, '/initial-sync?from=%2Ftasks'),
        isNull,
      );
    });

    test('ilk çekme bitince saklanan konuma ya da Bugün’e dönülür', () {
      expect(
        _redirect(SessionStage.ready, '/initial-sync?from=%2Fhives%2F42'),
        '/hives/42',
      );
      expect(
        _redirect(SessionStage.ready, AppRoutes.initialSync),
        AppRoutes.today,
      );
      expect(
        _redirect(
          SessionStage.needsOrganization,
          '/initial-sync?from=%2Ftasks',
        ),
        '/onboarding?from=%2Ftasks',
      );
    });

    test("her şey hazırsa giriş ekranları ve onboarding Bugün'e gider", () {
      for (final path in [
        AppRoutes.signIn,
        AppRoutes.signInCode,
        AppRoutes.onboarding,
        AppRoutes.onboardingApiary,
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
      expect(
        _redirect(SessionStage.ready, '/onboarding/apiary?from=%2Ftasks'),
        '/tasks',
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
