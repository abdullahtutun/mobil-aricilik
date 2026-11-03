// WeatherAPI.com isteği ve yanıtın uygulamaya giden biçimi. Ağ ve
// veritabanı yok; index.ts kullanır. Birimler metrik (°C, km/s, mm, %);
// uygulama kullanıcının birimine çevirir.

/// Varsayılan gün sayısı; `WEATHERAPI_DAYS` secret'ıyla değişir.
export const defaultForecastDays = 7;

/// WeatherAPI'nin `forecast.json`'da kabul ettiği en çok gün.
const maxForecastDays = 14;

/// İstenen gün sayısı: `WEATHERAPI_DAYS` (1–14), yoksa ya da geçersizse
/// [defaultForecastDays]. WeatherAPI planın izin verdiğinden fazlasını
/// istemeyi hata saymaz, planın sınırı kadar gün döner (Free 3, Starter 7,
/// Pro+ ve üstü 14); uygulama gelen gün sayısını olduğu gibi gösterir.
export function forecastDays(value: string | undefined): number {
  const days = Number.parseInt(value ?? "", 10);
  if (!Number.isFinite(days) || days < 1) return defaultForecastDays;
  return Math.min(days, maxForecastDays);
}

/// Önbellekteki tahminin biçimi. Biçim değişince artar; eski biçimdeki
/// satır yokmuş gibi yeniden alınır, istemciye hiç gitmez.
export const forecastFormat = 2;

/// Konumun 0,01°'lik (~1 km) hücresi: "37.11,28.39". Önbellek anahtarı ve
/// WeatherAPI'ye giden koordinat (`q=enlem,boylam`); yakın arılıklar tek
/// isteği paylaşır.
export function cellOf(latitude: number, longitude: number): string {
  return `${latitude.toFixed(2)},${longitude.toFixed(2)}`;
}

/// Hücrenin tahmini. Anahtar adreste; adres loglanmaz.
export function forecastUrl(cell: string, key: string, days: number): string {
  const params = new URLSearchParams({
    key,
    q: cell,
    days: `${days}`,
    aqi: "no",
    alerts: "no",
  });
  return `https://api.weatherapi.com/v1/forecast.json?${params}`;
}

/// Uygulamaya giden tahmin. Durum kodları WeatherAPI'nin `condition.code`
/// değeri, çevrilmeden; simgeye uygulamadaki tek tablo çevirir.
export type Forecast = {
  format: number;
  /// WeatherAPI'nin yer adı (genelde ilçe) ve bölgesi (il); başlıkta.
  place: string | null;
  region: string | null;
  timezone: string;
  utc_offset_seconds: number;
  current: {
    time: number;
    temperature_c: number | null;
    feels_like_c: number | null;
    humidity: number | null;
    wind_kmh: number | null;
    precipitation_mm: number | null;
    condition_code: number | null;
  };
  hourly: {
    time: number[];
    temperature_c: (number | null)[];
    wind_kmh: (number | null)[];
    precipitation_mm: (number | null)[];
    precipitation_probability: (number | null)[];
    condition_code: (number | null)[];
  };
  daily: {
    time: number[];
    condition_code: (number | null)[];
    temperature_max_c: (number | null)[];
    temperature_min_c: (number | null)[];
    precipitation_mm: (number | null)[];
    precipitation_probability_max: (number | null)[];
    wind_max_kmh: (number | null)[];
  };
};

// deno-lint-ignore no-explicit-any
type Json = any;

const num = (value: Json): number | null =>
  typeof value === "number" ? value : null;

/// Yağmur ve kar olasılığının büyüğü.
const chance = (rain: Json, snow: Json): number | null => {
  const values = [num(rain), num(snow)].filter((v) => v !== null) as number[];
  return values.length === 0 ? null : Math.max(...values);
};

/// WeatherAPI `forecast.json` yanıtını uygulamanın biçimine çevirir. Saatler
/// Unix saniyesi; günler arılığın saat dilimindeki gece yarısı (WeatherAPI
/// günü UTC gece yarısıyla verir, yerel saatten çıkan farkla kaydırılır).
export function parseForecast(body: Json): Forecast {
  const location = body.location;
  // "2026-10-26 15:09" yerel saat; UTC sayıp gerçek anla farkı alınır.
  const localAsUtc = Date.parse(`${location.localtime.replace(" ", "T")}:00Z`) /
    1000;
  const quarter = 15 * 60;
  const offset = Math.round((localAsUtc - location.localtime_epoch) / quarter) *
    quarter;
  const days: Json[] = body.forecast.forecastday;
  const hours: Json[] = days.flatMap((day) => day.hour);
  const current = body.current ?? {};

  return {
    format: forecastFormat,
    place: typeof location.name === "string" ? location.name : null,
    region: typeof location.region === "string" ? location.region : null,
    timezone: location.tz_id,
    utc_offset_seconds: offset,
    current: {
      time: num(current.last_updated_epoch) ?? location.localtime_epoch,
      temperature_c: num(current.temp_c),
      feels_like_c: num(current.feelslike_c),
      humidity: num(current.humidity),
      wind_kmh: num(current.wind_kph),
      precipitation_mm: num(current.precip_mm),
      condition_code: num(current.condition?.code),
    },
    hourly: {
      time: hours.map((h) => h.time_epoch),
      temperature_c: hours.map((h) => num(h.temp_c)),
      wind_kmh: hours.map((h) => num(h.wind_kph)),
      precipitation_mm: hours.map((h) => num(h.precip_mm)),
      precipitation_probability: hours.map((h) =>
        chance(h.chance_of_rain, h.chance_of_snow)
      ),
      condition_code: hours.map((h) => num(h.condition?.code)),
    },
    daily: {
      time: days.map((d) => d.date_epoch - offset),
      condition_code: days.map((d) => num(d.day.condition?.code)),
      temperature_max_c: days.map((d) => num(d.day.maxtemp_c)),
      temperature_min_c: days.map((d) => num(d.day.mintemp_c)),
      precipitation_mm: days.map((d) => num(d.day.totalprecip_mm)),
      precipitation_probability_max: days.map((d) =>
        chance(d.day.daily_chance_of_rain, d.day.daily_chance_of_snow)
      ),
      wind_max_kmh: days.map((d) => num(d.day.maxwind_kph)),
    },
  };
}
