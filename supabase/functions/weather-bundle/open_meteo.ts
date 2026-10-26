// Open-Meteo isteği ve yanıtın uygulamaya giden biçimi. Ağ ve veritabanı
// yok; index.ts kullanır.

export const forecastDays = 7;

const hourlyVariables = [
  "temperature_2m",
  "wind_speed_10m",
  "precipitation",
  "precipitation_probability",
  "weather_code",
];

const dailyVariables = [
  "weather_code",
  "temperature_2m_max",
  "temperature_2m_min",
  "precipitation_sum",
  "precipitation_probability_max",
  "wind_speed_10m_max",
];

/// Konumun 0,01°'lik (~1 km) hücresi: "37.11,28.39". Önbellek anahtarı ve
/// Open-Meteo'ya giden koordinat; yakın arılıklar tek isteği paylaşır.
export function cellOf(latitude: number, longitude: number): string {
  return `${latitude.toFixed(2)},${longitude.toFixed(2)}`;
}

/// Hücrelerin tek istekte tahmini. Saatler Unix saniyesi; günler arılığın
/// kendi saat diliminde.
export function forecastUrl(cells: string[]): string {
  const coordinates = cells.map((cell) => cell.split(","));
  const params = new URLSearchParams({
    latitude: coordinates.map(([latitude]) => latitude).join(","),
    longitude: coordinates.map(([, longitude]) => longitude).join(","),
    hourly: hourlyVariables.join(","),
    daily: dailyVariables.join(","),
    forecast_days: `${forecastDays}`,
    timezone: "auto",
    timeformat: "unixtime",
    wind_speed_unit: "kmh",
    precipitation_unit: "mm",
    temperature_unit: "celsius",
  });
  return `https://api.open-meteo.com/v1/forecast?${params}`;
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
    weather_code: (number | null)[];
  };
  daily: {
    time: number[];
    weather_code: (number | null)[];
    temperature_max_c: (number | null)[];
    temperature_min_c: (number | null)[];
    precipitation_mm: (number | null)[];
    precipitation_probability_max: (number | null)[];
    wind_max_kmh: (number | null)[];
  };
};

// deno-lint-ignore no-explicit-any
type Json = any;

/// Open-Meteo yanıtını istek sırasındaki hücrelerin tahminlerine çevirir.
/// Tek konumda yanıt nesne, birden çokta dizi gelir.
export function parseForecasts(body: Json, count: number): Forecast[] {
  const items: Json[] = Array.isArray(body) ? body : [body];
  if (items.length !== count) {
    throw new Error(`Open-Meteo ${count} yerine ${items.length} konum döndü`);
  }
  return items.map((item) => ({
    timezone: item.timezone,
    utc_offset_seconds: item.utc_offset_seconds,
    hourly: {
      time: item.hourly.time,
      temperature_c: item.hourly.temperature_2m,
      wind_kmh: item.hourly.wind_speed_10m,
      precipitation_mm: item.hourly.precipitation,
      precipitation_probability: item.hourly.precipitation_probability,
      weather_code: item.hourly.weather_code,
    },
    daily: {
      time: item.daily.time,
      weather_code: item.daily.weather_code,
      temperature_max_c: item.daily.temperature_2m_max,
      temperature_min_c: item.daily.temperature_2m_min,
      precipitation_mm: item.daily.precipitation_sum,
      precipitation_probability_max: item.daily.precipitation_probability_max,
      wind_max_kmh: item.daily.wind_speed_10m_max,
    },
  }));
}
