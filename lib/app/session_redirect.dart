import 'package:mobil_arici/app/routes.dart';

/// Oturumun hangi aşamada olduğu; yönlendirme buna göre yapılır.
enum SessionStage {
  /// Giriş yapılmamış.
  signedOut,

  /// Giriş yapılmış ama işletme yok ya da henüz bilinmiyor (yükleniyor,
  /// çevrimdışı ilk açılış).
  needsOrganization,

  /// Giriş yapılmış ve işletme belli.
  ready,
}

SessionStage sessionStageOf({
  required bool signedIn,
  required bool hasOrganization,
}) {
  if (!signedIn) return SessionStage.signedOut;
  return hasOrganization ? SessionStage.ready : SessionStage.needsOrganization;
}

/// Onboarding'e yönlendirilirken asıl açılmak istenen konum.
const onboardingFromParameter = 'from';

/// Oturuma göre yönlendirme: giriş yapılmamışsa her konum giriş ekranına,
/// işletme yoksa onboarding'e gider. Her şey hazırsa giriş ekranları
/// Bugün'e, onboarding asıl açılmak istenen konuma gider (işletme cihazdan
/// okunurken gelen derin link kaybolmasın). Değişiklik yoksa null.
String? sessionRedirect({required SessionStage stage, required Uri location}) {
  final path = location.path;
  final onSignIn = _isUnder(AppRoutes.signIn, path);
  final onOnboarding = _isUnder(AppRoutes.onboarding, path);
  switch (stage) {
    case SessionStage.signedOut:
      return onSignIn ? null : AppRoutes.signIn;
    case SessionStage.needsOrganization:
      if (onOnboarding) return null;
      if (onSignIn || path == AppRoutes.today) return AppRoutes.onboarding;
      return Uri(
        path: AppRoutes.onboarding,
        queryParameters: {onboardingFromParameter: location.toString()},
      ).toString();
    case SessionStage.ready:
      if (onOnboarding) return _returnLocation(location) ?? AppRoutes.today;
      return onSignIn ? AppRoutes.today : null;
  }
}

/// Yalnız uygulama içi konuma dönülür; başka şemaya ya da hosta gidilmez.
String? _returnLocation(Uri onboarding) {
  final from = onboarding.queryParameters[onboardingFromParameter];
  if (from == null || !from.startsWith('/') || from.startsWith('//')) {
    return null;
  }
  return from;
}

bool _isUnder(String route, String path) =>
    path == route || path.startsWith('$route/');
