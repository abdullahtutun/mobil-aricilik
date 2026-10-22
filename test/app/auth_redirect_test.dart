import 'package:flutter_test/flutter_test.dart';
import 'package:mobil_arici/app/auth_redirect.dart';
import 'package:mobil_arici/app/routes.dart';

void main() {
  group('authRedirect', () {
    test('giriş yapılmamışsa her konum giriş ekranına gider', () {
      for (final path in [
        AppRoutes.today,
        AppRoutes.settings,
        AppRoutes.scan,
        '/hives/42',
        '/sign-inx',
      ]) {
        expect(
          authRedirect(signedIn: false, path: path),
          AppRoutes.signIn,
          reason: path,
        );
      }
    });

    test('giriş yapılmamışken giriş ekranlarında kalınır', () {
      expect(authRedirect(signedIn: false, path: AppRoutes.signIn), isNull);
      expect(authRedirect(signedIn: false, path: AppRoutes.signInCode), isNull);
    });

    test("giriş yapılmışsa giriş ekranları Bugün'e gider", () {
      expect(
        authRedirect(signedIn: true, path: AppRoutes.signIn),
        AppRoutes.today,
      );
      expect(
        authRedirect(signedIn: true, path: AppRoutes.signInCode),
        AppRoutes.today,
      );
    });

    test('giriş yapılmışsa diğer konumlara dokunulmaz', () {
      expect(authRedirect(signedIn: true, path: AppRoutes.settings), isNull);
      expect(authRedirect(signedIn: true, path: '/hives/42'), isNull);
    });
  });
}
