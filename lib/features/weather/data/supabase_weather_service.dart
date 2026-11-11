import 'package:mobil_arici/features/weather/data/weather_service.dart';
import 'package:mobil_arici/features/weather/domain/weather_bundle.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

/// [WeatherService]'in Supabase uygulaması: `weather-bundle` Edge
/// Function'ı.
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
