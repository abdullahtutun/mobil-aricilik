-- P10.1 (K-11): Supabase'e yazma dondurulur. Backend PocketBase'e taşındı;
-- elde kalan eski derlemeler Supabase'e yazmasın diye sync_push'un
-- desteklenen şema sürümleri boşaltılır. Her çağrı PT426 (HTTP 426) alır ve
-- hiçbir şey yazmaz. Gövde 20261116120000_drop_personal_names ile aynı; tek
-- fark sürüm listesi. Tablolar, veri, RLS, auth, sync_pull ve diğer
-- fonksiyonlar değişmez; okuma sürer.
--
-- Geri alma (yeni bir migration olarak uygulanır; sürüm listesi 1–26 döner):
--
--   do $$
--   begin
--     execute replace(
--       pg_get_functiondef('public.sync_push(jsonb, timestamptz, integer)'::regprocedure),
--       'array[]::integer[]',
--       'array[1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26]'
--     );
--   end
--   $$;
--
-- (Ya da 20261116120000_drop_personal_names.sql'deki sync_push tanımı
-- olduğu gibi yeniden uygulanır.)

CREATE OR REPLACE FUNCTION public.sync_push(changes jsonb, client_time timestamp with time zone, schema_version integer)
 RETURNS jsonb
 LANGUAGE plpgsql
 SET search_path TO ''
AS $function$
declare
  supported_versions constant integer[] := array[]::integer[];
  -- İstemci saati sunucudan bundan fazla saparsa uyarı döner.
  max_clock_skew constant interval := interval '5 minutes';
  skew_seconds bigint;
  change jsonb;
  outcome jsonb;
  results jsonb := '[]'::jsonb;
begin
  if not coalesce(sync_push.schema_version = any (supported_versions), false) then
    raise exception 'Desteklenmeyen şema sürümü: %', sync_push.schema_version
      using errcode = 'PT426',
            detail = format('Desteklenen sürümler: %s', array_to_string(supported_versions, ', ')),
            hint = 'Uygulamayı güncelleyin';
  end if;
  if jsonb_typeof(sync_push.changes) is distinct from 'array' then
    raise exception 'changes bir dizi olmalı' using errcode = '22023';
  end if;
  if sync_push.client_time is null then
    raise exception 'client_time boş olamaz' using errcode = '22023';
  end if;

  for i in 0 .. jsonb_array_length(sync_push.changes) - 1 loop
    change := sync_push.changes -> i;
    begin
      outcome := jsonb_build_object(
        'id', change -> 'id',
        'status', 'ok',
        'applied', private.sync_push_change(
          change ->> 'table', change ->> 'operation', change -> 'payload'
        )
      );
    exception when others then
      -- Geçici hata: bütün paket geri alınır, istemci yeniden dener.
      if left(sqlstate, 2) in ('08', '40', '53', '57', '58') or sqlstate = '55P03' then
        raise;
      end if;
      outcome := jsonb_build_object(
        'id', change -> 'id',
        'status', 'rejected',
        'reason', case sqlstate
          when '42501' then 'forbidden'
          when '23505' then 'conflict'
          when '23503' then 'missing_reference'
          when '0A000' then 'unsupported'
          else 'invalid'
        end,
        'message', sqlerrm
      );
    end;
    results := results || jsonb_build_array(outcome);
  end loop;

  skew_seconds := round(extract(epoch from sync_push.client_time - now()));
  return jsonb_build_object(
    'results', results,
    'server_time', now(),
    'warning', case
      when abs(skew_seconds) > extract(epoch from max_clock_skew) then
        jsonb_build_object('code', 'clock_skew', 'skew_seconds', skew_seconds)
    end
  );
end;
$function$;
