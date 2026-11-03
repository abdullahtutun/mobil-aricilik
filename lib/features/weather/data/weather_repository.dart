import 'package:mobil_arici/core/db/app_database.dart';
import 'package:mobil_arici/core/db/local_settings_repository.dart';
import 'package:mobil_arici/features/weather/domain/weather_bundle.dart';

/// Son alınan hava paketi; yalnız bu telefonda (`local_settings`), outbox'a
/// yazılmaz ve senkronlanmaz. Çevrimdışıyken ekranlar bunu gösterir.
class WeatherRepository {
  new(AppDatabase db) : _settings = LocalSettingsRepository(db);

  final LocalSettingsRepository _settings;

  static const bundleKey = 'weather_bundle';

  /// Saklanan paket; yoksa ya da okunamıyorsa null.
  Stream<WeatherBundle?> watchBundle() =>
      _settings.watchJson(bundleKey, WeatherBundle.fromJson);

  Future<WeatherBundle?> readBundle() =>
      _settings.readJson(bundleKey, WeatherBundle.fromJson);

  /// Önceki paketin yerine yazar.
  Future<void> saveBundle(WeatherBundle bundle) =>
      _settings.writeJson(bundleKey, bundle.toJson());
}
