// weather-bundle: Çağıranın arılıkları için 7 günlük Open-Meteo tahmini tek
// pakette. Konumlar kullanıcının JWT'siyle (RLS) `weather_locations`'tan
// gelir; istemci koordinat göndermez. Tahmin 0,01°'lik hücre başına
// `weather_cache`'te ~1 saat tutulur. Open-Meteo'ya ulaşılamazsa eski
// önbellek döner; hiç verisi olmayan hücre kalırsa 502 ve istemci kendi
// sakladığı paketi göstermeye devam eder.
//
// Yanıt: { generated_at, forecasts: [{ apiary_id, cell, fetched_at,
// forecast }] }. Uygulama "Weather data by Open-Meteo.com" atfını gösterir.

import { createClient } from "npm:@supabase/supabase-js@2";
import { cellOf, type Forecast, forecastUrl, parseForecasts } from "./open_meteo.ts";

const cacheTtlMs = 60 * 60 * 1000;
const cellsPerRequest = 50;

type CacheRow = { cell: string; forecast: Forecast; fetched_at: string };

function json(body: unknown, status = 200): Response {
  return new Response(JSON.stringify(body), {
    status,
    headers: { "Content-Type": "application/json" },
  });
}

async function fetchForecasts(cells: string[]): Promise<CacheRow[]> {
  const rows: CacheRow[] = [];
  for (let i = 0; i < cells.length; i += cellsPerRequest) {
    const chunk = cells.slice(i, i + cellsPerRequest);
    const response = await fetch(forecastUrl(chunk), {
      signal: AbortSignal.timeout(10_000),
    });
    if (!response.ok) {
      throw new Error(`Open-Meteo ${response.status}: ${await response.text()}`);
    }
    const fetchedAt = new Date().toISOString();
    parseForecasts(await response.json(), chunk.length).forEach((forecast, j) =>
      rows.push({ cell: chunk[j], forecast, fetched_at: fetchedAt })
    );
  }
  return rows;
}

Deno.serve(async (request) => {
  const authorization = request.headers.get("Authorization");
  if (!authorization) return json({ error: "unauthorized" }, 401);

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
    for (const row of (cached ?? []) as CacheRow[]) byCell.set(row.cell, row);
  }

  const now = Date.now();
  const stale = cells.filter((cell) => {
    const row = byCell.get(cell);
    return !row || now - Date.parse(row.fetched_at) > cacheTtlMs;
  });

  if (stale.length > 0) {
    try {
      const fresh = await fetchForecasts(stale);
      for (const row of fresh) byCell.set(row.cell, row);
      const { error: upsertError } = await admin
        .from("weather_cache")
        .upsert(fresh, { onConflict: "cell" });
      if (upsertError) console.error(upsertError);
    } catch (error) {
      console.error(error);
      // Eski önbellek de yoksa paket eksik kalırdı; istemci elindekini korur.
      if (stale.some((cell) => !byCell.has(cell))) {
        return json({ error: "upstream" }, 502);
      }
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
