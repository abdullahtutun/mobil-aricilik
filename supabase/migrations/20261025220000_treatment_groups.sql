-- İlaç uygulama grupları ve reçete fotoğrafı.
--
-- treatments.application_id: aynı anda birçok kovana yazılan uygulamanın
-- (arılığın tümü) ortak kimliği; tek kovanda da dolu. Şema sürümü 5'ten
-- gelen kayıtta boş; istemci o kaydı kendi grubu sayar.
--
-- media.treatment_id: reçete / fatura fotoğrafı. Toplu uygulamada foto bir
-- kez çekilir ve formun açıldığı kovanın uygulamasına bağlanır; gruptaki
-- diğer kovanlar onu application_id üzerinden gösterir. Bir medya ya
-- muayeneye ya uygulamaya bağlıdır, ikisine birden değil.
--
-- sync_push Drift şema sürümü 6'yı kabul eder.

alter table public.treatments add column application_id uuid;

create index treatments_application_id_idx on public.treatments (application_id);

alter table public.media add column treatment_id uuid;

alter table public.media
  add constraint media_treatment_fkey
  foreign key (treatment_id, org_id) references public.treatments (id, org_id);

alter table public.media
  add constraint media_single_owner_check
  check (inspection_id is null or treatment_id is null);

create index media_treatment_id_idx on public.media (treatment_id);

-- ---------------------------------------------------------------------------
-- sync_push: şema sürümü 6
-- ---------------------------------------------------------------------------
-- Tablo eşlemesi (sync_push_change) değişmedi.

-- Belge: 20261023164500_sync_push.sql. Tek fark desteklenen şema sürümleri.
create or replace function public.sync_push(
  changes jsonb,
  client_time timestamptz,
  schema_version integer
)
returns jsonb
language plpgsql
security invoker
set search_path = ''
as $$
declare
  supported_versions constant integer[] := array[1, 2, 3, 4, 5, 6];
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
$$;
