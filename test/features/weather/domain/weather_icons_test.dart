import 'package:flutter_test/flutter_test.dart';
import 'package:mobil_arici/features/weather/domain/weather_icons.dart';

void main() {
  group('weatherIconFor', () {
    test('tasarımdaki gruplar', () {
      expect(weatherIconFor(1000), WeatherIcon.sunny);
      expect(weatherIconFor(1003), WeatherIcon.partlyCloudy);
      expect(weatherIconFor(1006), WeatherIcon.cloudy);
      expect(weatherIconFor(1009), WeatherIcon.cloudy);
      for (final code in [1063, 1153, 1183, 1195, 1201, 1240, 1246]) {
        expect(weatherIconFor(code), WeatherIcon.rainy, reason: '$code');
      }
      for (final code in [1030, 1066, 1087, 1135, 1204, 1213, 1237, 1276]) {
        expect(weatherIconFor(code), WeatherIcon.other, reason: '$code');
      }
    });

    test('bilinmeyen ya da boş kod bulutlu', () {
      expect(weatherIconFor(9999), WeatherIcon.cloudy);
      expect(weatherIconFor(0), WeatherIcon.cloudy);
      expect(weatherIconFor(null), WeatherIcon.cloudy);
      expect(
        weatherIconFor(null, windKmh: 30, windLimitKmh: 25),
        WeatherIcon.windy,
      );
    });

    test('rüzgar eşiğe ulaşınca kuru gökyüzü rüzgarlı olur', () {
      expect(
        weatherIconFor(1000, windKmh: 24.9, windLimitKmh: 25),
        WeatherIcon.sunny,
      );
      for (final code in [1000, 1003, 1006]) {
        expect(
          weatherIconFor(code, windKmh: 25, windLimitKmh: 25),
          WeatherIcon.windy,
        );
      }
    });

    test('yağmur ve diğer simgeler rüzgarda kalır', () {
      expect(
        weatherIconFor(1183, windKmh: 40, windLimitKmh: 25),
        WeatherIcon.rainy,
      );
      expect(
        weatherIconFor(1213, windKmh: 40, windLimitKmh: 25),
        WeatherIcon.other,
      );
    });

    test("WeatherAPI'nin bütün kodları tabloda", () {
      // https://www.weatherapi.com/docs/weather_conditions.json
      const codes = [
        1000, 1003, 1006, 1009, 1030, 1063, 1066, 1069, 1072, 1087, 1114, //
        1117, 1135, 1147, 1150, 1153, 1168, 1171, 1180, 1183, 1186, 1189,
        1192, 1195, 1198, 1201, 1204, 1207, 1210, 1213, 1216, 1219, 1222,
        1225, 1237, 1240, 1243, 1246, 1249, 1252, 1255, 1258, 1261, 1264,
        1273, 1276, 1279, 1282,
      ];
      expect(weatherIconByCode.keys.toSet(), codes.toSet());
    });
  });
}
