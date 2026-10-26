import 'package:mobil_arici/features/weather/domain/weather_bundle.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

/// Hava paketi alınamadı (ağ yok, sunucu ya da WeatherAPI hatası). Telefonda
/// saklanan paket gösterilmeye devam eder.
class WeatherServiceException implements Exception {
  const new(this.cause);

  final Object cause;

  @override
  String toString() => 'WeatherServiceException($cause)';
}

/// `weather-bundle` Edge Function'ı. Ağa giden çağrı; ekranlar buna
/// provider üzerinden ulaşır, sonucu repository saklar.
abstract interface class WeatherService {
  /// Kullanıcının sunucudaki konumlu arılıkları için güncel paket. Hata
  /// [WeatherServiceException] olarak gelir.
  Future<WeatherBundle> fetchBundle();
}

class SupabaseWeatherService implements WeatherService {
  const new(this._client);

  final SupabaseClient _client;

  @override
  Future<WeatherBundle> fetchBundle() async {
    try {
      final response = await _client.functions.invoke('weather-bundle');
      return WeatherBundle.fromJson(response.data as Map<String, Object?>);
    } on Object catch (error) {
      // FunctionException, bağlantı hatası, zaman aşımı ya da beklenmeyen
      // yanıt biçimi.
      throw WeatherServiceException(error);
    }
  }
}
