-- Planlı ilaçlama görevi (ozellikler.md §10 alışveriş listesi): elle
-- açılan görev isteğe bağlı olarak bir ilaç ve kovan başı doz taşır.
-- Alışveriş listesi açık görevlerin ihtiyacını (doz × arılıktaki aktif
-- kovan; kovana bağlıysa tek kovan) stoktan düşerek hesaplar.
--
-- tasks.ref_drug_id / drug_id: planlanan ilaç; referans listeden ya da
-- işletmenin listesinden, en çok biri. dose kovan başı doz, birimi ilacın;
-- ilaçla birlikte dolu ya da boş. İlaçlı görev elle açılır ve arılığa
-- bağlıdır. Yeni bir task_source değeri yerine kolon eklendi: eski
-- uygulama ilaçlı görevi başlığıyla sıradan bir görev olarak görür ve
-- çekmesi kırılmaz.
--
-- sync_push görevi yine durum kaydı olarak yazar ve Drift şema sürümü
-- 15'i kabul eder.

alter table public.tasks add column ref_drug_id uuid references public.ref_drugs (id);
alter table public.tasks add column drug_id uuid;
alter table public.tasks add column dose numeric(8, 2) check (dose > 0 and dose <= 10000);

alter table public.tasks
  add constraint tasks_drug_id_org_id_fkey
    foreign key (drug_id, org_id) references public.drugs (id, org_id),
  add constraint tasks_one_drug_check
    check (num_nonnulls(ref_drug_id, drug_id) <= 1),
  -- Doz ilaçla birlikte dolu ya da boş.
  add constraint tasks_drug_dose_check
    check ((dose is null) = (ref_drug_id is null and drug_id is null)),
  -- İlaçlı görev elle açılır ve arılığa bağlıdır.
  add constraint tasks_drug_manual_apiary_check
    check (dose is null or (source = 'manual' and apiary_id is not null));

create index tasks_ref_drug_id_idx on public.tasks (ref_drug_id);
create index tasks_drug_id_idx on public.tasks (drug_id);

-- ---------------------------------------------------------------------------
-- sync_push: şema sürümü 15
-- ---------------------------------------------------------------------------
-- sync_push_change değişmedi: durum kaydının yeni kolonları kendiliğinden
-- yazılır.

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
  supported_versions constant integer[] := array[1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15];
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
