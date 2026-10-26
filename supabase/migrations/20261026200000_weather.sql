-- Hava durumu: weather-bundle Edge Function'ının arılık konumları ve
-- Open-Meteo önbelleği. Senkronlanmaz; istemci paketi yerelde saklar.

-- ---------------------------------------------------------------------------
-- Önbellek
-- ---------------------------------------------------------------------------

-- 0,01°'lik hücre (~1 km) başına Open-Meteo'dan alınan son tahmin. Hücre
-- "enlem,boylam" iki ondalıkla ("37.11,28.39"); yakın arılıklar ve aynı
-- yeri soran işletmeler tek kaydı paylaşır. Yalnız Edge Function
-- (service_role) okur ve yazar; uygulama rolleri hiç erişemez.
create table public.weather_cache (
  cell text primary key check (cell ~ '^-?\d{1,2}\.\d{2},-?\d{1,3}\.\d{2}$'),
  forecast jsonb not null,
  fetched_at timestamptz not null default now()
);

alter table public.weather_cache enable row level security;

revoke all on table public.weather_cache from anon, authenticated;

-- ---------------------------------------------------------------------------
-- Arılık konumları
-- ---------------------------------------------------------------------------

-- Çağıranın görebildiği (RLS), silinmemiş ve konumu olan arılıklar.
create function public.weather_locations()
returns table (apiary_id uuid, latitude double precision, longitude double precision)
language sql
stable
security invoker
set search_path = ''
as $$
  select
    a.id,
    extensions.st_y(a.location::extensions.geometry),
    extensions.st_x(a.location::extensions.geometry)
  from public.apiaries a
  where a.deleted_at is null
    and a.location is not null
$$;

revoke all on function public.weather_locations() from public, anon;
grant execute on function public.weather_locations() to authenticated;
