import 'package:mobil_arici/core/services/pocketbase_app_api.dart';
import 'package:mobil_arici/features/weather/data/weather_service.dart';
import 'package:mobil_arici/features/weather/domain/weather_bundle.dart';
import 'package:pocketbase/pocketbase.dart';

/// [WeatherService]'in PocketBase uygulaması: `POST /api/app/weather`
/// (`server/internal/weather`, `weather-bundle` Edge Function'ının
/// karşılığı; yanıt aynı biçimde). Anahtar sunucuda yoksa 503 `config`,
/// sağlayıcıya ulaşılamazsa 502 `upstream`; ikisi de saklanan paketi
/// gösterdiren [WeatherServiceException].
class PocketBaseWeatherService implements WeatherService {
  const new(this._client, {this.timeout = requestTimeout});

  final PocketBase _client;

  /// Tek isteğin süre sınırı; testler kısaltır.
  final Duration timeout;

  static const path = '/api/app/weather';

  /// Sunucu hücre başına 10 sn bekler, aynı anda 5 hücre; uzun tutulur.
  static const requestTimeout = Duration(seconds: 60);

  @override
  Future<WeatherBundle> fetchBundle() async {
    try {
      final response = await sendPocketBaseAppRequest(
        _client,
        path,
        timeout: timeout,
      );
      return WeatherBundle.fromJson(response! as Map<String, Object?>);
    } on Object catch (error) {
      // Durum kodlu hata, bağlantı hatası, zaman aşımı ya da beklenmeyen
      // yanıt biçimi.
      throw WeatherServiceException(error);
    }
  }
}
