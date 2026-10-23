/// Rota yolları. Geliştirici rotaları yalnızca dev flavor'da kayıtlıdır.
abstract final class AppRoutes {
  // Alt gezinmedeki sekmeler; her biri kendi gezinme yığınını tutar.
  static const today = '/';
  static const apiaries = '/apiaries';
  static const tasks = '/tasks';
  static const more = '/more';

  static const apiaryNew = '/apiaries/new';
  static String apiary(String id) => '/apiaries/$id';
  static String apiaryEdit(String id) => '/apiaries/$id/edit';

  /// Kovan rotaları arılığın altında: geri tuşu arılığa döner. Kovan
  /// başka arılığa taşınsa da kart yoldaki arılığa değil kovana bakar.
  static String hiveNew(String apiaryId) => '/apiaries/$apiaryId/hives/new';
  static String hivesBulk(String apiaryId) => '/apiaries/$apiaryId/hives/bulk';
  static String hive(String apiaryId, String hiveId) =>
      '/apiaries/$apiaryId/hives/$hiveId';
  static String hiveEdit(String apiaryId, String hiveId) =>
      '/apiaries/$apiaryId/hives/$hiveId/edit';

  /// Arılıktaki kovanların etiketlerini seçip yazdırma.
  static String hiveLabels(String apiaryId) => '/apiaries/$apiaryId/labels';

  /// Kovan etiketinin derin linki (`mobilarici://h/<kimlik>`). Kovan varsa
  /// kartına yönlenir, yoksa etiketi atamayı sunar.
  static String hiveLink(String hiveId) => '/h/$hiveId';

  /// Tanınmayan etiketi bir kovana atama; sekmelerin üstünde açılır.
  static const labelAssignPath = '/labels/assign';
  static const labelCodeParameter = 'code';
  static String labelAssign(String code) => Uri(
    path: labelAssignPath,
    queryParameters: {labelCodeParameter: code},
  ).toString();

  static const settings = '/more/settings';

  /// Ortadaki butonun açtığı tam ekran; sekmelerin üstünde açılır.
  static const scan = '/scan';

  /// Üst bardaki senkron ikonunun açtığı ayrıntı; sekmelerin üstünde açılır.
  static const sync = '/sync';

  /// İlk girişte tam çekme; bitene kadar sekmeler açılmaz.
  static const initialSync = '/initial-sync';

  /// Giriş yapılmamışken açılabilen tek rotalar.
  static const signIn = '/sign-in';
  static const signInCode = '/sign-in/code';

  /// İşletmesi olmayan kullanıcının açabildiği tek rota.
  static const onboarding = '/onboarding';

  /// İşletme kurulduktan sonraki son onboarding adımı. Onboarding'in alt
  /// rotası değil: geri tuşu işletme adımlarına dönmesin.
  static const onboardingApiary = '/onboarding/apiary';

  static const developerMenu = '/dev';
  static const componentGallery = '/dev/components';
}
