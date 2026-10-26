import 'package:mobil_arici/features/weather/domain/weather_bundle.dart';

/// Kovan açmaya uygunluk: yeşil, sarı, kırmızı.
enum HiveOpening { suitable, caution, unsuitable }

/// Uygunluğu düşüren hava etkeni.
enum WeatherConcern { rain, wind, cold }

/// `concern` uygunluğu belirleyen etken; [HiveOpening.suitable]'da null.
typedef HiveOpeningAdvice = ({HiveOpening level, WeatherConcern? concern});

/// Bu sıcaklığın altında kovan açılmaz; yavru üşür.
const coldLimitC = 12.0;

/// Kovan bu sıcaklıktan itibaren rahat açılır.
const warmEnoughC = 16.0;

/// Bu rüzgarda ve üstünde kovan açılmaz.
const windLimitKmh = 30.0;

/// Rüzgar bunun altındaysa sorun yok.
const calmEnoughKmh = 20.0;

/// Saatlik bu yağış ve üstü yağıyor sayılır.
const rainLimitMm = 0.5;

/// Bu yağış olasılığında ve üstünde kovan açılmaz.
const rainLikelyPercent = 60.0;

/// Yağış olasılığı bunun altındaysa sorun yok.
const rainUnlikelyPercent = 30.0;

/// Bir saatin havasına göre kovan açmaya uygunluk. Kırmızı: sıcaklık
/// [coldLimitC]'nin altında, rüzgar [windLimitKmh] ya da üstü, ya da yağış
/// var ([rainLimitMm] mm/saat ya da olasılık [rainLikelyPercent]). Yeşil:
/// en az [warmEnoughC], rüzgar [calmEnoughKmh]'nin altında, yağış yok ve
/// olasılık [rainUnlikelyPercent]'nin altında. Arası sarı. Olasılık
/// bilinmiyorsa yalnız yağış miktarına bakılır. Birden çok etken varsa en
/// kötü düzeyi veren, eşitlikte yağış, rüzgar, soğuk sırasıyla.
HiveOpeningAdvice hiveOpeningAdvice({
  required double temperatureC,
  required double windKmh,
  required double precipitationMm,
  double? precipitationProbability,
}) {
  final probability = precipitationProbability ?? 0;
  final rain =
      precipitationMm >= rainLimitMm || probability >= rainLikelyPercent
      ? HiveOpening.unsuitable
      : precipitationMm > 0 || probability >= rainUnlikelyPercent
      ? HiveOpening.caution
      : HiveOpening.suitable;
  final wind = windKmh >= windLimitKmh
      ? HiveOpening.unsuitable
      : windKmh >= calmEnoughKmh
      ? HiveOpening.caution
      : HiveOpening.suitable;
  final cold = temperatureC < coldLimitC
      ? HiveOpening.unsuitable
      : temperatureC < warmEnoughC
      ? HiveOpening.caution
      : HiveOpening.suitable;

  var advice = (level: HiveOpening.suitable, concern: null as WeatherConcern?);
  for (final (concern, level) in [
    (WeatherConcern.rain, rain),
    (WeatherConcern.wind, wind),
    (WeatherConcern.cold, cold),
  ]) {
    if (level.index > advice.level.index) {
      advice = (level: level, concern: concern);
    }
  }
  return advice;
}

/// [forecast]'ta [at] anının içinde olduğu saat; tahmin aralığı dışındaysa
/// null.
HourlyWeather? forecastHourAt(Forecast forecast, DateTime at) {
  final seconds = at.millisecondsSinceEpoch ~/ 1000;
  final hourly = forecast.hourly;
  for (final (i, start) in hourly.time.indexed) {
    if (start <= seconds && seconds < start + Duration.secondsPerHour) {
      return (
        temperatureC: hourly.temperatureC.elementAtOrNull(i),
        windKmh: hourly.windKmh.elementAtOrNull(i),
        precipitationMm: hourly.precipitationMm.elementAtOrNull(i),
        precipitationProbability: hourly.precipitationProbability
            .elementAtOrNull(i),
        weatherCode: hourly.weatherCode.elementAtOrNull(i),
      );
    }
  }
  return null;
}

/// Saatin tahmininden uygunluk; sıcaklık, rüzgar ya da yağış eksikse null.
HiveOpeningAdvice? hourOpeningAdvice(HourlyWeather hour) {
  if (hour case (
    temperatureC: final temperature?,
    windKmh: final wind?,
    precipitationMm: final precipitation?,
    :final precipitationProbability,
    weatherCode: _,
  )) {
    return hiveOpeningAdvice(
      temperatureC: temperature,
      windKmh: wind,
      precipitationMm: precipitation,
      precipitationProbability: precipitationProbability,
    );
  }
  return null;
}

/// Sunucu tahmini ~1 saat önbellekte tutar; daha sık sormak yeni veri
/// getirmez.
const weatherRefreshInterval = Duration(hours: 1);

/// Pakette olmayan bir arılık için en erken yeniden sorma aralığı. Yeni
/// arılık sunucuya senkronla ulaşır; o zamana kadar her açılışta sormamak
/// için.
const weatherMissingRetryInterval = Duration(minutes: 10);

/// Paket yenilenmeli mi: konumlu arılık ([locatedApiaryIds]) yoksa hayır.
/// Varsa paket hiç yoksa, [weatherRefreshInterval]'den eskiyse ya da konumlu
/// bir arılık pakette yoksa ve paket [weatherMissingRetryInterval]'den
/// eskiyse evet.
bool weatherNeedsRefresh({
  required WeatherBundle? bundle,
  required DateTime now,
  required Set<String> locatedApiaryIds,
}) {
  if (locatedApiaryIds.isEmpty) return false;
  if (bundle == null) return true;
  final age = now.difference(bundle.generatedAt);
  if (age >= weatherRefreshInterval) return true;
  final covered = {for (final f in bundle.forecasts) f.apiaryId};
  return age >= weatherMissingRetryInterval &&
      !covered.containsAll(locatedApiaryIds);
}
