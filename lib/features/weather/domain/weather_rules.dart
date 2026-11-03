import 'package:mobil_arici/features/weather/domain/weather_bundle.dart';

/// Kovan açmaya uygunluk: uygun ya da uygunluğu bozan etken.
enum HiveOpening { suitable, rain, wind, cold }

/// Kovan açma eşikleri; bu telefonun ayarı. Sıcaklık `minTemperatureC`'nin
/// üstünde, rüzgar `maxWindKmh`'nin ve yağış olasılığı
/// `maxPrecipitationProbability`'nin altında olmalı.
typedef HiveOpeningThresholds = ({
  double minTemperatureC,
  double maxWindKmh,
  double maxPrecipitationProbability,
});

/// Ayar yapılmamışsa: 15 °C üstü, rüzgar 25 km/s altı, yağış %40 altı.
const HiveOpeningThresholds defaultHiveOpeningThresholds = (
  minTemperatureC: 15,
  maxWindKmh: 25,
  maxPrecipitationProbability: 40,
);

/// Ayarlarda seçilebilen eşikler (°C, km/s, %).
const minTemperatureOptions = <double>[10, 12, 14, 15, 16, 18, 20];
const maxWindOptions = <double>[15, 20, 25, 30, 35, 40];
const maxPrecipitationOptions = <double>[20, 30, 40, 50, 60, 70];

/// Saatlik bu yağış ve üstü yağıyor sayılır; olasılık düşük görünse de.
const rainLimitMm = 0.5;

/// [thresholds]'a göre kovan açmaya uygunluk. Yağış: olasılık eşikte ya da
/// üstünde, ya da yağış [precipitationMm] en az [rainLimitMm]. Rüzgar:
/// eşikte ya da üstünde. Soğuk: sıcaklık eşikte ya da altında. Bilinmeyen
/// yağış sorun sayılmaz. Birden çok etken varsa yağış, rüzgar, soğuk
/// sırasıyla ilki.
HiveOpening hiveOpening({
  required double temperatureC,
  required double windKmh,
  required HiveOpeningThresholds thresholds,
  double? precipitationProbability,
  double? precipitationMm,
}) {
  if ((precipitationProbability ?? 0) >=
          thresholds.maxPrecipitationProbability ||
      (precipitationMm ?? 0) >= rainLimitMm) {
    return HiveOpening.rain;
  }
  if (windKmh >= thresholds.maxWindKmh) return HiveOpening.wind;
  if (temperatureC <= thresholds.minTemperatureC) return HiveOpening.cold;
  return HiveOpening.suitable;
}

/// Saatin tahmininden uygunluk; sıcaklık ya da rüzgar eksikse null.
HiveOpening? hourOpening(HourlyWeather hour, HiveOpeningThresholds thresholds) {
  if (hour case (
    temperatureC: final temperature?,
    windKmh: final wind?,
    :final precipitationMm,
    :final precipitationProbability,
    time: _,
    conditionCode: _,
  )) {
    return hiveOpening(
      temperatureC: temperature,
      windKmh: wind,
      thresholds: thresholds,
      precipitationProbability: precipitationProbability,
      precipitationMm: precipitationMm,
    );
  }
  return null;
}

/// Günün tahmininden uygunluk (en yüksek sıcaklık, en sert rüzgar, en
/// yüksek yağış olasılığı); sıcaklık ya da rüzgar eksikse null.
HiveOpening? dayOpening(DailyWeather day, HiveOpeningThresholds thresholds) {
  if (day case (
    temperatureMaxC: final temperature?,
    windMaxKmh: final wind?,
    :final precipitationProbability,
    day: _,
    conditionCode: _,
    temperatureMinC: _,
  )) {
    return hiveOpening(
      temperatureC: temperature,
      windKmh: wind,
      thresholds: thresholds,
      precipitationProbability: precipitationProbability,
    );
  }
  return null;
}

/// [epochSeconds]'ın arılığın saat dilimindeki tarih ve saati (yalnız
/// alanlar; telefonun saat diliminden bağımsız).
DateTime forecastLocalTime(Forecast forecast, int epochSeconds) {
  final utc = DateTime.fromMillisecondsSinceEpoch(
    (epochSeconds + forecast.utcOffsetSeconds) * 1000,
    isUtc: true,
  );
  return DateTime(utc.year, utc.month, utc.day, utc.hour, utc.minute);
}

HourlyWeather _hourAt(HourlySeries hourly, int i) => (
  time: hourly.time[i],
  temperatureC: hourly.temperatureC.elementAtOrNull(i),
  windKmh: hourly.windKmh.elementAtOrNull(i),
  precipitationMm: hourly.precipitationMm.elementAtOrNull(i),
  precipitationProbability: hourly.precipitationProbability.elementAtOrNull(i),
  conditionCode: hourly.conditionCode.elementAtOrNull(i),
);

/// [forecast]'ta [at] anının içinde olduğu saat; tahmin aralığı dışındaysa
/// null.
HourlyWeather? forecastHourAt(Forecast forecast, DateTime at) {
  final seconds = at.millisecondsSinceEpoch ~/ 1000;
  final hourly = forecast.hourly;
  for (final (i, start) in hourly.time.indexed) {
    if (start <= seconds && seconds < start + Duration.secondsPerHour) {
      return _hourAt(hourly, i);
    }
  }
  return null;
}

/// Saat şeridi: önce [now]'ın saati, sonra arılığın saatiyle [stepHours]'ın
/// katı olan saatler; en çok [count] sütun. [now] tahmin aralığı dışındaysa
/// boş.
List<HourlyWeather> hourlyStrip(
  Forecast forecast,
  DateTime now, {
  int count = 5,
  int stepHours = 3,
}) {
  final seconds = now.millisecondsSinceEpoch ~/ 1000;
  final hourly = forecast.hourly;
  final start = hourly.time.indexWhere(
    (t) => t <= seconds && seconds < t + Duration.secondsPerHour,
  );
  if (start < 0) return const [];
  return [
    _hourAt(hourly, start),
    for (var i = start + 1; i < hourly.time.length; i++)
      if (forecastLocalTime(forecast, hourly.time[i]).hour % stepHours == 0)
        _hourAt(hourly, i),
  ].take(count).toList();
}

/// Tahmindeki günler, gelen sayıda (plan 3 de verse 7 de); [now]'dan
/// önceki takvim günleri (eski paket) atlanır.
List<DailyWeather> forecastDays(Forecast forecast, DateTime now) {
  final daily = forecast.daily;
  final today = _dateOnly(
    forecastLocalTime(forecast, now.millisecondsSinceEpoch ~/ 1000),
  );
  return [
    for (final (i, time) in daily.time.indexed)
      if (_dateOnly(forecastLocalTime(forecast, time)) case final day
          when !day.isBefore(today))
        (
          day: day,
          conditionCode: daily.conditionCode.elementAtOrNull(i),
          temperatureMaxC: daily.temperatureMaxC.elementAtOrNull(i),
          temperatureMinC: daily.temperatureMinC.elementAtOrNull(i),
          precipitationProbability: daily.precipitationProbabilityMax
              .elementAtOrNull(i),
          windMaxKmh: daily.windMaxKmh.elementAtOrNull(i),
        ),
  ];
}

DateTime _dateOnly(DateTime value) =>
    DateTime(value.year, value.month, value.day);

/// "Planla" önerisi: `from`–`to` arası yağışlı (`concern` rain) ya da
/// rüzgarlı (wind); muayeneler `day`'e alınsın.
typedef InspectionPlan = ({
  DateTime from,
  DateTime to,
  HiveOpening concern,
  DateTime day,
});

/// [days]'teki ilk yağışlı ya da rüzgarlı günler dizisi (aynı türden ardışık
/// günler; tasarımdaki gibi "Salı–Çarşamba yağmur") ve ona en yakın uygun
/// gün: önce gelen ve sonra gelen aynı uzaklıktaysa önce gelen. Dizi ilk
/// günden başlıyorsa yağışlı günler atlanıp ilk uygun gün seçilir. Böyle bir
/// dizi ya da uygun gün yoksa null.
InspectionPlan? inspectionPlan(
  List<DailyWeather> days,
  HiveOpeningThresholds thresholds,
) {
  final openings = [for (final day in days) dayOpening(day, thresholds)];
  bool bad(HiveOpening? opening) =>
      opening == HiveOpening.rain || opening == HiveOpening.wind;

  final first = openings.indexWhere(bad);
  if (first < 0) return null;
  final concern = openings[first]!;
  var last = first;
  while (last + 1 < openings.length && openings[last + 1] == concern) {
    last++;
  }

  int? target;
  int? distance;
  for (final (i, opening) in openings.indexed) {
    if (opening != HiveOpening.suitable) continue;
    final d = i < first ? first - i : i - last;
    if (distance == null || d < distance) (target, distance) = (i, d);
  }
  if (target == null) return null;

  return (
    from: days[first].day,
    to: days[last].day,
    concern: concern,
    day: days[target].day,
  );
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
