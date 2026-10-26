// WeatherAPI.com isteği ve yanıtın uygulamaya giden biçimi. Ağ ve
// veritabanı yok; index.ts kullanır.

/// İstenen gün sayısı. WeatherAPI planın izin verdiği kadarını döner
/// (ücretsiz plan 3, Starter ve üstü 7).
export const forecastDays = 7;

/// Konumun 0,01°'lik (~1 km) hücresi: "37.11,28.39". Önbellek anahtarı ve
/// WeatherAPI'ye giden koordinat; yakın arılıklar tek isteği paylaşır.
export function cellOf(latitude: number, longitude: number): string {
  return `${latitude.toFixed(2)},${longitude.toFixed(2)}`;
}

/// Hücrenin tahmini. Anahtar adreste; adres loglanmaz.
export function forecastUrl(cell: string, key: string): string {
  const params = new URLSearchParams({
    key,
    q: cell,
    days: `${forecastDays}`,
    aqi: "no",
    alerts: "no",
  });
  return `https://api.weatherapi.com/v1/forecast.json?${params}`;
}

/// Sağlayıcıdan bağımsız gökyüzü durumu; uygulama ikonu buna göre seçer.
export type Condition =
  | "clear"
  | "partly_cloudy"
  | "cloudy"
  | "fog"
  | "rain"
  | "snow"
  | "thunder";

/// WeatherAPI durum kodu (https://www.weatherapi.com/docs/weather_conditions.json)
/// → [Condition]. Bilinmeyen kod null.
export function conditionOf(code: number | null | undefined): Condition | null {
  switch (code) {
    case 1000:
      return "clear";
    case 1003:
      return "partly_cloudy";
    case 1006:
    case 1009:
      return "cloudy";
    case 1030:
    case 1135:
    case 1147:
      return "fog";
    case 1087:
    case 1273:
    case 1276:
    case 1279:
    case 1282:
      return "thunder";
    case 1066:
    case 1069:
    case 1114:
    case 1117:
    case 1204:
    case 1207:
    case 1210:
    case 1213:
    case 1216:
    case 1219:
    case 1222:
    case 1225:
    case 1237:
    case 1249:
    case 1252:
    case 1255:
    case 1258:
    case 1261:
    case 1264:
      return "snow";
    case 1063:
    case 1072:
    case 1150:
    case 1153:
    case 1168:
    case 1171:
    case 1180:
    case 1183:
    case 1186:
    case 1189:
    case 1192:
    case 1195:
    case 1198:
    case 1201:
    case 1240:
    case 1243:
    case 1246:
      return "rain";
    default:
      return null;
  }
}

export type Forecast = {
  timezone: string;
  utc_offset_seconds: number;
  hourly: {
    time: number[];
    temperature_c: (number | null)[];
    wind_kmh: (number | null)[];
    precipitation_mm: (number | null)[];
    precipitation_probability: (number | null)[];
    condition: (Condition | null)[];
  };
  daily: {
    time: number[];
    condition: (Condition | null)[];
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

  return {
    timezone: location.tz_id,
    utc_offset_seconds: offset,
    hourly: {
      time: hours.map((h) => h.time_epoch),
      temperature_c: hours.map((h) => num(h.temp_c)),
      wind_kmh: hours.map((h) => num(h.wind_kph)),
      precipitation_mm: hours.map((h) => num(h.precip_mm)),
      precipitation_probability: hours.map((h) =>
        chance(h.chance_of_rain, h.chance_of_snow)
      ),
      condition: hours.map((h) => conditionOf(h.condition?.code)),
    },
    daily: {
      time: days.map((d) => d.date_epoch - offset),
      condition: days.map((d) => conditionOf(d.day.condition?.code)),
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
