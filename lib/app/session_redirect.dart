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

  /// İşletme belli ama bu cihazda ilk tam çekme bitmedi ya da henüz
  /// bilinmiyor (yerel DB okunuyor).
  initialSync,

  /// Giriş yapılmış, işletme belli ve kayıtlar bu cihazda.
  ready,
}

SessionStage sessionStageOf({
  required bool signedIn,
  required bool hasOrganization,
  bool settingUp = false,
  bool fullPullDone = true,
}) {
  if (!signedIn) return SessionStage.signedOut;
  if (!hasOrganization) return SessionStage.needsOrganization;
  if (settingUp) return SessionStage.settingUp;
  return fullPullDone ? SessionStage.ready : SessionStage.initialSync;
}

/// Onboarding'e ya da ilk çekmeye yönlendirilirken asıl açılmak istenen
/// konum.
const onboardingFromParameter = 'from';

/// Oturuma göre yönlendirme: giriş yapılmamışsa her konum giriş ekranına,
/// işletme yoksa onboarding'e, işletme yeni kurulduysa ilk arılık adımına,
/// kayıtlar henüz inmediyse ilk çekme ekranına gider. Her şey hazırsa giriş
/// ekranları Bugün'e, onboarding ve ilk çekme asıl açılmak istenen konuma
/// gider (işletme cihazdan okunurken gelen derin link kaybolmasın).
/// Değişiklik yoksa null.
String? sessionRedirect({required SessionStage stage, required Uri location}) {
  final path = location.path;
  final onSignIn = _isUnder(AppRoutes.signIn, path);
  switch (stage) {
    case SessionStage.signedOut:
      return onSignIn ? null : AppRoutes.signIn;
    case SessionStage.needsOrganization:
      return _gateStep(AppRoutes.onboarding, location);
    case SessionStage.settingUp:
      // İlk arılığın konumu haritada seçilebilsin.
      if (path == AppRoutes.locationPicker) return null;
      return _gateStep(AppRoutes.onboardingApiary, location);
    case SessionStage.initialSync:
      return _gateStep(AppRoutes.initialSync, location);
    case SessionStage.ready:
      if (_isGate(path)) return _returnLocation(location) ?? AppRoutes.today;
      return onSignIn ? AppRoutes.today : null;
  }
}

/// Kapı ekranlarından [step]'e götürür; zaten oradaysa null. Başka bir kapı
/// ekranından gelinirse saklanan konum taşınır. Giriş ekranları ve Bugün
/// saklanmaz, kapı geçilince zaten Bugün açılır.
String? _gateStep(String step, Uri location) {
  final path = location.path;
  if (path == step) return null;
  final String? from;
  if (_isGate(path)) {
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
String? _returnLocation(Uri gate) {
  final from = gate.queryParameters[onboardingFromParameter];
  if (from == null || !from.startsWith('/') || from.startsWith('//')) {
    return null;
  }
  return from;
}

/// Onboarding adımları ve ilk çekme: oturum hazır olana kadar tutulan
/// ekranlar.
bool _isGate(String path) =>
    _isUnder(AppRoutes.onboarding, path) || path == AppRoutes.initialSync;

bool _isUnder(String route, String path) =>
    path == route || path.startsWith('$route/');
