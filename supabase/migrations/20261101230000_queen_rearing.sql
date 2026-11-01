-- Ana arı yetiştirme (ozellikler.md §3 "Ana arı yetiştirme takvimi",
-- "Çiftleşme kutuları"): larva aktarma serileri ve çiftleşme kutuları.
-- İkisi de durum kaydı (son yazan kazanır).
--
-- queen_rearing_batches: bir larva aktarma serisi. number işletmenin
-- verdiği seri numarası ("Seri 3"); offline iki telefon aynı numarayı
-- verebileceği için tekil değil. mother_queen_id larvaların alındığı anne
-- ana; bilinmiyorsa boş. grafted_on aktarma günü; takvim (G1 kabul, G5
-- kapanma, G10 dağıtım, G12 çıkış, G24 yumurtlama kontrolü) istemcide bu
-- günden hesaplanır. grafted_count aktarılan larva, accepted_count kabul
-- edilen meme (G1'de sayılır; sayılmadıysa boş).
--
-- mating_nucs: bir arılıktaki çiftleşme kutusu. number kutunun numarası
-- ("1", "K-12"). status kutunun içi: boş, meme var, ana çıktı (bakire),
-- yumurtluyor (çiftleşti), başarısız, kovana verildi. rearing_batch_id
-- kutudaki memenin serisi; boş kutuda boş olabilir, diğer durumlarda dolu.
-- Kutu yeni seride yeniden kullanılınca seri değişir. queen_id kutudan
-- kovana verilen ananın kaydı; yalnız "kovana verildi"de dolu.
--
-- tasks: task_source'a queen_rearing eklenir (source_id seri). source_step
-- otomatik görevin takvim günü (1, 5, 10, 12, 24); yalnız ana yetiştirme
-- görevinde dolu. Yeni enum değeri aynı transaction'da kullanılamadığı
-- için kısıt değeri metin olarak karşılaştırır.
--
-- sync_push iki tabloyu durum kaydı olarak yazar ve Drift şema sürümü
-- 16'yı kabul eder.

create type public.mating_nuc_status as enum (
  'empty', 'cell', 'virgin', 'laying', 'failed', 'given'
);

alter type public.task_source add value 'queen_rearing';

alter table public.tasks
  add column source_step smallint check (source_step between 1 and 60);

alter table public.tasks
  add constraint tasks_queen_rearing_step_check
    check ((source::text = 'queen_rearing') = (source_step is not null));

create table public.queen_rearing_batches (
  id uuid primary key,
  org_id uuid not null references public.organizations (id) on delete cascade,
  number smallint not null check (number between 1 and 10000),
  mother_queen_id uuid,
  grafted_on date not null,
  grafted_count smallint not null check (grafted_count between 1 and 1000),
  accepted_count smallint check (accepted_count >= 0),
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now(),
  created_by uuid default auth.uid() references auth.users (id) on delete set null,
  deleted_at timestamptz,
  server_seq bigint not null,
  unique (id, org_id),
  foreign key (mother_queen_id, org_id) references public.queens (id, org_id),
  check (accepted_count <= grafted_count)
);

create index queen_rearing_batches_org_id_idx on public.queen_rearing_batches (org_id);
create index queen_rearing_batches_mother_queen_id_idx
  on public.queen_rearing_batches (mother_queen_id);
create index queen_rearing_batches_server_seq_idx
  on public.queen_rearing_batches (server_seq);

create trigger set_server_seq
before insert or update on public.queen_rearing_batches
for each row execute function private.set_server_seq();

create table public.mating_nucs (
  id uuid primary key,
  org_id uuid not null references public.organizations (id) on delete cascade,
  number text not null check (char_length(btrim(number)) between 1 and 20),
  apiary_id uuid not null,
  rearing_batch_id uuid,
  status public.mating_nuc_status not null default 'empty',
  queen_id uuid,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now(),
  created_by uuid default auth.uid() references auth.users (id) on delete set null,
  deleted_at timestamptz,
  server_seq bigint not null,
  unique (id, org_id),
  foreign key (apiary_id, org_id) references public.apiaries (id, org_id),
  foreign key (rearing_batch_id, org_id) references public.queen_rearing_batches (id, org_id),
  foreign key (queen_id, org_id) references public.queens (id, org_id),
  -- Boş olmayan kutu bir serinin memesini taşır.
  check (status = 'empty' or rearing_batch_id is not null),
  -- Kovana verilen ananın kaydı yalnız "kovana verildi"de.
  check ((status = 'given') = (queen_id is not null))
);

create index mating_nucs_org_id_idx on public.mating_nucs (org_id);
create index mating_nucs_apiary_id_idx on public.mating_nucs (apiary_id);
create index mating_nucs_rearing_batch_id_idx on public.mating_nucs (rearing_batch_id);
create index mating_nucs_queen_id_idx on public.mating_nucs (queen_id);
create index mating_nucs_server_seq_idx on public.mating_nucs (server_seq);

create trigger set_server_seq
before insert or update on public.mating_nucs
for each row execute function private.set_server_seq();

-- ---------------------------------------------------------------------------
-- RLS
-- ---------------------------------------------------------------------------
-- Üyeler okur; owner, partner ve worker ekler ve günceller; viewer yalnız
-- okur. Silme politikası yok: silme deleted_at ile yapılan bir güncellemedir.

alter table public.queen_rearing_batches enable row level security;

create policy "Üyeler ana yetiştirme serilerini görür"
on public.queen_rearing_batches for select
to authenticated
using (private.is_member(org_id));

create policy "Yazabilen üyeler ana yetiştirme serisi ekler"
on public.queen_rearing_batches for insert
to authenticated
with check (private.has_role(org_id, '{owner,partner,worker}'));

create policy "Yazabilen üyeler ana yetiştirme serilerini günceller"
on public.queen_rearing_batches for update
to authenticated
using (private.has_role(org_id, '{owner,partner,worker}'))
with check (private.has_role(org_id, '{owner,partner,worker}'));

alter table public.mating_nucs enable row level security;

create policy "Üyeler çiftleşme kutularını görür"
on public.mating_nucs for select
to authenticated
using (private.is_member(org_id));

create policy "Yazabilen üyeler çiftleşme kutusu ekler"
on public.mating_nucs for insert
to authenticated
with check (private.has_role(org_id, '{owner,partner,worker}'));

create policy "Yazabilen üyeler çiftleşme kutularını günceller"
on public.mating_nucs for update
to authenticated
using (private.has_role(org_id, '{owner,partner,worker}'))
with check (private.has_role(org_id, '{owner,partner,worker}'));

-- ---------------------------------------------------------------------------
-- sync_push: seri ve kutu durum kaydı; şema sürümü 16
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
    when 'drugs' then 'state'
    when 'treatments' then 'event'
    when 'feedings' then 'event'
    when 'tasks' then 'state'
    when 'harvests' then 'event'
    when 'harvest_hives' then 'event'
    when 'documents' then 'state'
    when 'migrations' then 'state'
    when 'migration_stops' then 'state'
    when 'transports' then 'state'
    when 'transport_items' then 'state'
    when 'inventory_items' then 'state'
    when 'inventory_moves' then 'event'
    when 'queen_rearing_batches' then 'state'
    when 'mating_nucs' then 'state'
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
  supported_versions constant integer[] := array[1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16];
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
