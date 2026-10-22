import 'package:mobil_arici/app/routes.dart';

/// Oturumun hangi aşamada olduğu; yönlendirme buna göre yapılır.
enum SessionStage {
  /// Giriş yapılmamış.
  signedOut,

  /// Giriş yapılmış ama işletme yok ya da henüz bilinmiyor (yükleniyor,
  /// çevrimdışı ilk açılış).
  needsOrganization,

  /// İşletme onboarding'de yeni kuruldu; ilk arılık adımı sürüyor.
  settingUp,

  /// Giriş yapılmış ve işletme belli.
  ready,
}

SessionStage sessionStageOf({
  required bool signedIn,
  required bool hasOrganization,
  bool settingUp = false,
}) {
  if (!signedIn) return SessionStage.signedOut;
  if (!hasOrganization) return SessionStage.needsOrganization;
  return settingUp ? SessionStage.settingUp : SessionStage.ready;
}

/// Onboarding'e yönlendirilirken asıl açılmak istenen konum.
const onboardingFromParameter = 'from';

/// Oturuma göre yönlendirme: giriş yapılmamışsa her konum giriş ekranına,
/// işletme yoksa onboarding'e, işletme yeni kurulduysa ilk arılık adımına
/// gider. Her şey hazırsa giriş ekranları Bugün'e, onboarding asıl açılmak
/// istenen konuma gider (işletme cihazdan okunurken gelen derin link
/// kaybolmasın). Değişiklik yoksa null.
String? sessionRedirect({required SessionStage stage, required Uri location}) {
  final path = location.path;
  final onSignIn = _isUnder(AppRoutes.signIn, path);
  final onOnboarding = _isUnder(AppRoutes.onboarding, path);
  switch (stage) {
    case SessionStage.signedOut:
      return onSignIn ? null : AppRoutes.signIn;
    case SessionStage.needsOrganization:
      return _onboardingStep(AppRoutes.onboarding, location);
    case SessionStage.settingUp:
      return _onboardingStep(AppRoutes.onboardingApiary, location);
    case SessionStage.ready:
      if (onOnboarding) return _returnLocation(location) ?? AppRoutes.today;
      return onSignIn ? AppRoutes.today : null;
  }
}

/// Onboarding'in [step] adımına götürür; zaten oradaysa null. Başka bir
/// onboarding adımından gelinirse saklanan konum taşınır. Giriş ekranları
/// ve Bugün saklanmaz, onboarding bitince zaten Bugün açılır.
String? _onboardingStep(String step, Uri location) {
  final path = location.path;
  if (path == step) return null;
  final String? from;
  if (_isUnder(AppRoutes.onboarding, path)) {
    from = location.queryParameters[onboardingFromParameter];
  } else if (_isUnder(AppRoutes.signIn, path) || path == AppRoutes.today) {
    from = null;
  } else {
    from = location.toString();
  }
  if (from == null) return step;
  return Uri(
    path: step,
    queryParameters: {onboardingFromParameter: from},
  ).toString();
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
