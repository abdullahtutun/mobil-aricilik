import 'package:mobil_arici/app/routes.dart';

/// Oturuma göre yönlendirme: giriş yapılmamışsa her konum giriş ekranına,
/// giriş yapılmışsa giriş ekranları Bugün'e gider. Değişiklik yoksa null.
String? authRedirect({required bool signedIn, required String path}) {
  final onSignIn =
      path == AppRoutes.signIn || path.startsWith('${AppRoutes.signIn}/');
  if (!signedIn && !onSignIn) return AppRoutes.signIn;
  if (signedIn && onSignIn) return AppRoutes.today;
  return null;
}
