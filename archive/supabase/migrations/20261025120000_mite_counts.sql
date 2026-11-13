-- Varroa ölçümleri (ozellikler.md "Varroa yönetimi"). Olay kaydı: yalnız
-- eklenir, yanlış kayıt silinir.
--
-- Pudra şekeri ve alkol yıkamada örnek arı sayısı ile bulunan akar
-- sayılır; bulaşıklık yüzdesi istemcide hesaplanır, saklanmaz. Alt tablada
-- (yapışkan tabla) örnek arı yoktur: tablanın kaç gün kaldığı ve
-- dökülen akar yazılır, sonuç günlük akar dökümüdür.
--
-- sync_push ölçümü olay kaydı olarak yazar ve Drift şema sürümü 4'ü kabul
-- eder (yerel DB'ye varroa ölçümleri geldi).

-- ---------------------------------------------------------------------------
-- Tablo
-- ---------------------------------------------------------------------------

create type public.mite_count_method as enum ('sugar_roll', 'alcohol_wash', 'sticky_board');

create table public.mite_counts (
  id uuid primary key,
  org_id uuid not null references public.organizations (id) on delete cascade,
  hive_id uuid not null,
  -- Ölçümün yapıldığı arılık; kovan sonra taşınsa da değişmez.
  apiary_id uuid not null,
  counted_at timestamptz not null,
  method public.mite_count_method not null,
  -- Bulunan (alt tablada dökülen) akar.
  mites integer not null check (mites between 0 and 100000),
  -- Yıkanan arı; yalnız pudra şekeri ve alkol yıkamada.
  sample_bees smallint check (sample_bees between 1 and 5000),
  -- Tablanın kovanda kaldığı gün; yalnız alt tablada.
  days smallint check (days between 1 and 60),
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now(),
  created_by uuid default auth.uid() references auth.users (id) on delete set null,
  deleted_at timestamptz,
  server_seq bigint not null,
  unique (id, org_id),
  foreign key (hive_id, org_id) references public.hives (id, org_id),
  foreign key (apiary_id, org_id) references public.apiaries (id, org_id),
  -- Alt tablada gün, diğer yöntemlerde örnek arı dolu; öbürü boş.
  check ((method = 'sticky_board') = (days is not null)),
  check ((method = 'sticky_board') = (sample_bees is null))
);

create index mite_counts_org_id_idx on public.mite_counts (org_id);
create index mite_counts_hive_id_idx on public.mite_counts (hive_id);
create index mite_counts_apiary_id_idx on public.mite_counts (apiary_id);
create index mite_counts_server_seq_idx on public.mite_counts (server_seq);

create trigger set_server_seq
before insert or update on public.mite_counts
for each row execute function private.set_server_seq();

-- ---------------------------------------------------------------------------
-- RLS
-- ---------------------------------------------------------------------------
-- Üyeler okur; owner, partner ve worker ekler ve günceller; viewer yalnız
-- okur. Silme politikası yok: silme deleted_at ile yapılan bir güncellemedir.

alter table public.mite_counts enable row level security;

create policy "Üyeler varroa ölçümlerini görür"
on public.mite_counts for select
to authenticated
using (private.is_member(org_id));

create policy "Yazabilen üyeler varroa ölçümü ekler"
on public.mite_counts for insert
to authenticated
with check (private.has_role(org_id, '{owner,partner,worker}'));

create policy "Yazabilen üyeler varroa ölçümlerini günceller"
on public.mite_counts for update
to authenticated
using (private.has_role(org_id, '{owner,partner,worker}'))
with check (private.has_role(org_id, '{owner,partner,worker}'));

-- ---------------------------------------------------------------------------
-- sync_push: varroa ölçümü olay kaydı, şema sürümü 4
-- ---------------------------------------------------------------------------
-- İki fonksiyon da create or replace ile yenilenir; yetkiler korunur.

create or replace function private.sync_push_change(
  record_table text,
  operation text,
  payload jsonb
)
returns boolean
language plpgsql
security invoker
set search_path = ''
as $$
declare
  -- state: son yazan kazanır. event: yalnız eklenir, silinmesi bir kez
  -- işaretlenir. organization: yalnız güncellenir, create_organization ile
  -- kurulur.
  kind constant text := case record_table
    when 'apiaries' then 'state'
    when 'queens' then 'state'
    when 'hives' then 'state'
    when 'hive_location_history' then 'event'
    when 'inspections' then 'event'
    when 'media' then 'event'
    when 'mite_counts' then 'event'
    when 'organizations' then 'organization'
  end;
  row_data jsonb := payload;
  latitude_type text;
  longitude_type text;
  latitude double precision;
  longitude double precision;
  set_columns text;
  excluded_columns text;
  written integer;
  server_updated_at timestamptz;
begin
  if record_table is null
     or operation is null
     or operation not in ('upsert', 'delete')
     or jsonb_typeof(payload) is distinct from 'object'
     or payload ->> 'id' is null
     or payload ->> 'updated_at' is null then
    raise exception 'Kayıt tablo, işlem ve id ile updated_at taşıyan satır içermeli'
      using errcode = '22023';
  end if;
  if kind is null then
    raise exception 'Senkronla yazılamayan tablo: %', record_table
      using errcode = '0A000';
  end if;
  if operation = 'delete' and payload ->> 'deleted_at' is null then
    raise exception 'Silme deleted_at taşımalı' using errcode = '22023';
  end if;

  -- Arılığın konumu yerelde enlem + boylam, sunucuda tek nokta. Bozuk değer
  -- PostGIS'te iç hata (XX000) verdiği için önceden denetlenir.
  if record_table = 'apiaries' then
    latitude_type := coalesce(jsonb_typeof(payload -> 'latitude'), 'null');
    longitude_type := coalesce(jsonb_typeof(payload -> 'longitude'), 'null');
    if latitude_type = 'null' and longitude_type = 'null' then
      row_data := row_data || '{"location": null}';
    elsif latitude_type = 'number' and longitude_type = 'number' then
      latitude := (payload ->> 'latitude')::double precision;
      longitude := (payload ->> 'longitude')::double precision;
      if latitude not between -90 and 90 or longitude not between -180 and 180 then
        raise exception 'Konum aralık dışında' using errcode = '22023';
      end if;
      row_data := row_data || jsonb_build_object(
        'location', format('SRID=4326;POINT(%s %s)', longitude, latitude)
      );
    else
      raise exception 'Enlem ve boylam birlikte dolu ya da birlikte boş olmalı'
        using errcode = '22023';
    end if;
  end if;

  -- Satırı ekleyen her zaman çağırandır; istemcinin gönderdiği değer yok
  -- sayılır. Güncellemede created_by değişmez.
  row_data := row_data || jsonb_build_object('created_by', (select auth.uid()));

  -- Postgres çakışan satırın RLS denetimini ON CONFLICT koşulu doğruysa
  -- yapar. Başka işletmenin satırına (RLS'e göre görünmeyen) eski
  -- updated_at'le yazma bu yüzden sessizce "ok" dönerdi. Görünmeyen satırda
  -- koşul doğru olur ve güncellemeyi RLS reddeder.
  if kind = 'event' then
    execute format(
      'insert into public.%1$I as t
       select * from pg_catalog.jsonb_populate_record(null::public.%1$I, $1)
       on conflict (id) do update
         set deleted_at = excluded.deleted_at, updated_at = excluded.updated_at
         where not exists (select from public.%1$I v where v.id = t.id)
           or (t.deleted_at is null and excluded.deleted_at is not null)',
      record_table
    ) using row_data;
    get diagnostics written = row_count;
    return written > 0;
  end if;

  -- Güncellenen kolonlar: kimlik, işletme, ekleme bilgisi ve server_seq
  -- dışındaki her kolon. Tabloya eklenen yeni kolon kendiliğinden katılır.
  select
    string_agg(format('%I', a.attname), ', ' order by a.attnum),
    string_agg(format('excluded.%I', a.attname), ', ' order by a.attnum)
  into set_columns, excluded_columns
  from pg_catalog.pg_attribute a
  where a.attrelid = format('public.%I', record_table)::regclass
    and a.attnum > 0
    and not a.attisdropped
    and a.attname not in ('id', 'org_id', 'created_at', 'created_by', 'server_seq');

  if kind = 'state' then
    execute format(
      'insert into public.%1$I as t
       select * from pg_catalog.jsonb_populate_record(null::public.%1$I, $1)
       on conflict (id) do update set (%2$s) = row (%3$s)
         where not exists (select from public.%1$I v where v.id = t.id)
           or excluded.updated_at > t.updated_at',
      record_table, set_columns, excluded_columns
    ) using row_data;
    get diagnostics written = row_count;
    return written > 0;
  end if;

  execute format(
    'update public.organizations as t
     set (%1$s) = (
       select %1$s
       from pg_catalog.jsonb_populate_record(null::public.organizations, $1)
     )
     where t.id = ($1 ->> ''id'')::uuid
       and t.updated_at < ($1 ->> ''updated_at'')::timestamptz',
    set_columns
  ) using row_data;
  get diagnostics written = row_count;
  if written > 0 then
    return true;
  end if;

  -- RLS'in izin vermediği güncelleme hata atmaz, yalnız satır yazılmaz.
  select o.updated_at into server_updated_at
  from public.organizations o
  where o.id = (row_data ->> 'id')::uuid;
  if not found then
    raise exception 'İşletme yok ya da üyesi değilsin; işletme create_organization ile kurulur'
      using errcode = '42501';
  end if;
  if server_updated_at < (row_data ->> 'updated_at')::timestamptz then
    raise exception 'İşletmeyi yalnız owner günceller' using errcode = '42501';
  end if;
  return false;
end;
$$;

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
  supported_versions constant integer[] := array[1, 2, 3, 4];
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
