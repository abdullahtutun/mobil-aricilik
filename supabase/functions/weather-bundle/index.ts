// weather-bundle: Çağıranın arılıkları için WeatherAPI.com tahmini (şimdiki
// durum, saatlik ve günlük; `WEATHERAPI_DAYS` gün, varsayılan 7, plan
// daha azına izin veriyorsa o kadar) tek pakette. Konumlar
// kullanıcının JWT'siyle (RLS) `weather_locations`'tan gelir; istemci
// koordinat göndermez. Tahmin 0,01°'lik hücre başına `weather_cache`'te ~1
// saat tutulur. Bir hücre alınamazsa eski önbelleği döner; hiç verisi
// olmayan hücre kalırsa 502 ve istemci kendi sakladığı paketi göstermeye
// devam eder. Anahtar `WEATHERAPI_KEY` secret'ında.
//
// Yanıt: { generated_at, forecasts: [{ apiary_id, cell, fetched_at,
// forecast }] }. Uygulama "Powered by WeatherAPI.com" atfını gösterir.

import { createClient } from "npm:@supabase/supabase-js@2";
import {
  cellOf,
  type Forecast,
  forecastDays,
  forecastFormat,
  forecastUrl,
  parseForecast,
} from "./weather_api.ts";

const cacheTtlMs = 60 * 60 * 1000;

/// WeatherAPI'ye aynı anda giden en çok istek; ücretsiz planda toplu istek
/// yok, her hücre ayrı çağrı.
const parallelRequests = 5;

type CacheRow = { cell: string; forecast: Forecast; fetched_at: string };

function json(body: unknown, status = 200): Response {
  return new Response(JSON.stringify(body), {
    status,
    headers: { "Content-Type": "application/json" },
  });
}

/// Hücre başına bir istek. Alınamayan hücre loglanır ve sonuçta yer almaz.
async function fetchForecasts(
  cells: string[],
  key: string,
  days: number,
): Promise<CacheRow[]> {
  const rows: CacheRow[] = [];
  const queue = [...cells];
  async function worker() {
    for (let cell = queue.shift(); cell; cell = queue.shift()) {
      try {
        const response = await fetch(forecastUrl(cell, key, days), {
          signal: AbortSignal.timeout(10_000),
        });
        // Adres anahtarı taşır; yalnız durum ve gövde loglanır.
        if (!response.ok) {
          throw new Error(
            `WeatherAPI ${response.status}: ${await response.text()}`,
          );
        }
        rows.push({
          cell,
          forecast: parseForecast(await response.json()),
          fetched_at: new Date().toISOString(),
        });
      } catch (error) {
        console.error(cell, error);
      }
    }
  }
  await Promise.all(
    Array.from({ length: Math.min(parallelRequests, cells.length) }, worker),
  );
  return rows;
}

Deno.serve(async (request) => {
  const authorization = request.headers.get("Authorization");
  if (!authorization) return json({ error: "unauthorized" }, 401);

  const key = Deno.env.get("WEATHERAPI_KEY");
  if (!key) {
    console.error("WEATHERAPI_KEY tanımlı değil");
    return json({ error: "config" }, 500);
  }

  const url = Deno.env.get("SUPABASE_URL")!;
  const user = createClient(url, Deno.env.get("SUPABASE_ANON_KEY")!, {
    global: { headers: { Authorization: authorization } },
    auth: { persistSession: false },
  });
  const admin = createClient(url, Deno.env.get("SUPABASE_SERVICE_ROLE_KEY")!, {
    auth: { persistSession: false },
  });

  const { data: locations, error: locationError } = await user.rpc(
    "weather_locations",
  );
  if (locationError) {
    console.error(locationError);
    return json({ error: "locations" }, 401);
  }

  const apiaries = (locations as {
    apiary_id: string;
    latitude: number;
    longitude: number;
  }[]).map((row) => ({
    apiary_id: row.apiary_id,
    cell: cellOf(row.latitude, row.longitude),
  }));
  const cells = [...new Set(apiaries.map((a) => a.cell))];

  const byCell = new Map<string, CacheRow>();
  if (cells.length > 0) {
    const { data: cached, error: cacheError } = await admin
      .from("weather_cache")
      .select("cell, forecast, fetched_at")
      .in("cell", cells);
    if (cacheError) console.error(cacheError);
    // Eski biçimdeki satır yokmuş gibi yeniden alınır; alınamazsa da
    // istemciye eski biçim gitmez.
    for (const row of (cached ?? []) as CacheRow[]) {
      if (row.forecast?.format === forecastFormat) byCell.set(row.cell, row);
    }
  }

  const now = Date.now();
  const stale = cells.filter((cell) => {
    const row = byCell.get(cell);
    return !row || now - Date.parse(row.fetched_at) > cacheTtlMs;
  });

  if (stale.length > 0) {
    const fresh = await fetchForecasts(
      stale,
      key,
      forecastDays(Deno.env.get("WEATHERAPI_DAYS")),
    );
    for (const row of fresh) byCell.set(row.cell, row);
    if (fresh.length > 0) {
      const { error: upsertError } = await admin
        .from("weather_cache")
        .upsert(fresh, { onConflict: "cell" });
      if (upsertError) console.error(upsertError);
    }
    // Eski önbellek de yoksa paket eksik kalırdı; istemci elindekini korur.
    if (stale.some((cell) => !byCell.has(cell))) {
      return json({ error: "upstream" }, 502);
    }
  }

  return json({
    generated_at: new Date(now).toISOString(),
    forecasts: apiaries.map(({ apiary_id, cell }) => {
      const row = byCell.get(cell)!;
      return {
        apiary_id,
        cell,
        fetched_at: row.fetched_at,
        forecast: row.forecast,
      };
    }),
  });
});
