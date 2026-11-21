import 'package:mobil_arici/core/db/app_database.dart';
import 'package:mobil_arici/core/db/local_settings_repository.dart';
import 'package:mobil_arici/features/plans/domain/plan_status.dart';

/// Sunucudan son alınan plan durumu, işletme başına; yalnız bu telefonda
/// (`local_settings`), outbox'a yazılmaz ve senkronlanmaz. Çevrimdışıyken
/// ekranlar bunu uygular. Beta notunun kapatıldığı da burada tutulur.
class PlanRepository {
  new(AppDatabase db) : _settings = LocalSettingsRepository(db);

  final LocalSettingsRepository _settings;

  static String statusKey(String orgId) => 'plan_status:$orgId';

  /// Bugün ekranındaki beta notu kapatıldı; Ayarlar'da yine görünür.
  static const betaNoticeDismissedKey = 'beta_notice_dismissed';

  /// Saklanan durum; yoksa ya da okunamıyorsa null.
  Stream<StoredPlanStatus?> watchStatus(String orgId) =>
      _settings.watchJson(statusKey(orgId), StoredPlanStatus.fromJson);

  Future<StoredPlanStatus?> readStatus(String orgId) =>
      _settings.readJson(statusKey(orgId), StoredPlanStatus.fromJson);

  /// Öncekinin yerine yazar.
  Future<void> saveStatus(String orgId, StoredPlanStatus status) =>
      _settings.writeJson(statusKey(orgId), status.toJson());

  Stream<bool> watchBetaNoticeDismissed() => _settings
      .watchValue(betaNoticeDismissedKey)
      .map((value) => value == 'true');

  Future<void> dismissBetaNotice() =>
      _settings.writeValue(betaNoticeDismissedKey, 'true');
}
