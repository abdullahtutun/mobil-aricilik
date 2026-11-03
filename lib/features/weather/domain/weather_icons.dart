/// Tasarımdaki hava simgeleri (docs/design "Arılık havası · 7 gün").
enum WeatherIcon { sunny, partlyCloudy, cloudy, rainy, windy, other }

/// WeatherAPI `condition.code` → simge; uygulamadaki tek tablo
/// (https://www.weatherapi.com/docs/weather_conditions.json). Rüzgarın kodu
/// yok: [WeatherIcon.windy]'yi `weatherIconFor` rüzgar eşiğinden verir.
/// Kar, sargı, buz, sis ve gök gürültüsü [WeatherIcon.other].
const weatherIconByCode = <int, WeatherIcon>{
  1000: WeatherIcon.sunny, // Güneşli / açık
  1003: WeatherIcon.partlyCloudy,
  1006: WeatherIcon.cloudy,
  1009: WeatherIcon.cloudy, // Kapalı
  1030: WeatherIcon.other, // Pus
  1063: WeatherIcon.rainy, // Yer yer yağmur
  1066: WeatherIcon.other, // Yer yer kar
  1069: WeatherIcon.other, // Yer yer sulu kar
  1072: WeatherIcon.rainy, // Yer yer dondurucu çisenti
  1087: WeatherIcon.other, // Gök gürültüsü
  1114: WeatherIcon.other, // Savrulan kar
  1117: WeatherIcon.other, // Tipi
  1135: WeatherIcon.other, // Sis
  1147: WeatherIcon.other, // Dondurucu sis
  1150: WeatherIcon.rainy,
  1153: WeatherIcon.rainy,
  1168: WeatherIcon.rainy,
  1171: WeatherIcon.rainy,
  1180: WeatherIcon.rainy,
  1183: WeatherIcon.rainy,
  1186: WeatherIcon.rainy,
  1189: WeatherIcon.rainy,
  1192: WeatherIcon.rainy,
  1195: WeatherIcon.rainy,
  1198: WeatherIcon.rainy,
  1201: WeatherIcon.rainy,
  1204: WeatherIcon.other, // Sulu kar
  1207: WeatherIcon.other,
  1210: WeatherIcon.other, // Kar
  1213: WeatherIcon.other,
  1216: WeatherIcon.other,
  1219: WeatherIcon.other,
  1222: WeatherIcon.other,
  1225: WeatherIcon.other,
  1237: WeatherIcon.other, // Buz taneleri
  1240: WeatherIcon.rainy, // Sağanak
  1243: WeatherIcon.rainy,
  1246: WeatherIcon.rainy,
  1249: WeatherIcon.other, // Sulu kar sağanağı
  1252: WeatherIcon.other,
  1255: WeatherIcon.other, // Kar sağanağı
  1258: WeatherIcon.other,
  1261: WeatherIcon.other,
  1264: WeatherIcon.other,
  1273: WeatherIcon.other, // Gök gürültülü yağmur
  1276: WeatherIcon.other,
  1279: WeatherIcon.other, // Gök gürültülü kar
  1282: WeatherIcon.other,
};

/// [code]'un simgesi; bilinmeyen ya da boş kod [WeatherIcon.cloudy].
/// Rüzgar [windLimitKmh]'ye ulaşırsa güneşli ya da bulutlu gökyüzü
/// [WeatherIcon.windy] olur; yağmur ve [WeatherIcon.other] kalır.
WeatherIcon weatherIconFor(int? code, {double? windKmh, double? windLimitKmh}) {
  final icon = weatherIconByCode[code] ?? WeatherIcon.cloudy;
  final windy =
      windKmh != null && windLimitKmh != null && windKmh >= windLimitKmh;
  return windy && _dry.contains(icon) ? WeatherIcon.windy : icon;
}

const _dry = <WeatherIcon>{
  WeatherIcon.sunny,
  WeatherIcon.partlyCloudy,
  WeatherIcon.cloudy,
};
