/// Rota yolları. Geliştirici rotaları yalnızca dev flavor'da kayıtlıdır.
abstract final class AppRoutes {
  // Alt gezinmedeki sekmeler; her biri kendi gezinme yığınını tutar.
  static const today = '/';
  static const apiaries = '/apiaries';
  static const tasks = '/tasks';
  static const more = '/more';

  static const settings = '/more/settings';
  static const settingsCountry = '/more/settings/country';

  /// Ortadaki butonun açtığı tam ekran; sekmelerin üstünde açılır.
  static const scan = '/scan';

  /// Giriş yapılmamışken açılabilen tek rotalar.
  static const signIn = '/sign-in';
  static const signInCode = '/sign-in/code';

  static const developerMenu = '/dev';
  static const componentGallery = '/dev/components';
}
