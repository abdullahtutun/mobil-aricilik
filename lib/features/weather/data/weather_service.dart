import 'package:mobil_arici/features/weather/domain/weather_bundle.dart';

/// Hava paketi alınamadı (ağ yok, sunucu ya da WeatherAPI hatası). Telefonda
/// saklanan paket gösterilmeye devam eder.
class WeatherServiceException implements Exception {
  const new(this.cause);

  final Object cause;

  @override
  String toString() => 'WeatherServiceException($cause)';
}

/// Arılıkların hava paketi. Ağa giden çağrı; ekranlar buna
/// provider üzerinden ulaşır, sonucu repository saklar.
abstract interface class WeatherService {
  /// Kullanıcının sunucudaki konumlu arılıkları için güncel paket. Hata
  /// [WeatherServiceException] olarak gelir.
  Future<WeatherBundle> fetchBundle();
}
