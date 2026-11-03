import 'package:mobil_arici/core/db/app_database.dart';
import 'package:mobil_arici/core/db/local_settings_repository.dart';
import 'package:mobil_arici/features/inspections/domain/apiary_tour.dart';

/// Süren arılık turu; yalnız bu telefonda (`local_settings`), outbox'a
/// yazılmaz ve senkronlanmaz. Aynı anda tek tur var.
class TourRepository {
  new(AppDatabase db) : _settings = LocalSettingsRepository(db);

  final LocalSettingsRepository _settings;

  static const tourKey = 'apiary_tour';

  /// Süren tur; yoksa ya da okunamıyorsa null.
  Stream<ApiaryTour?> watchTour() =>
      _settings.watchJson(tourKey, ApiaryTour.fromJson);

  Future<ApiaryTour?> readTour() =>
      _settings.readJson(tourKey, ApiaryTour.fromJson);

  /// Önceki turun yerine yazar.
  Future<void> saveTour(ApiaryTour tour) =>
      _settings.writeJson(tourKey, tour.toJson());

  Future<void> clearTour() => _settings.removeValue(tourKey);
}
