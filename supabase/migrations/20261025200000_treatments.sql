-- İlaçlama kayıt defteri (ozellikler.md "İlaçlama kayıt defteri").
--
-- ref_drugs: referans ilaç listesi; ülke koduna (ya da GLOBAL) göre
-- etiketli, TR/EN adlı, salt okunur. Her girişli kullanıcı okur, kimse
-- yazamaz; liste migration'la güncellenir. Ekran TR listesini yalnız TR
-- bölge profilinde gösterir; diğer bölgelerde etken madde bazlı GLOBAL
-- liste görünür.
--
-- drugs: işletmenin kendi eklediği ilaçlar; durum kaydı (son yazan
-- kazanır).
--
-- treatments: kovana ilaç uygulaması; olay kaydı (yalnız eklenir, yanlış
-- kayıt silinir). Ürünün adı ve etken maddesi uygulama anındaki hâliyle
-- kopyalanır; listedeki ilaç sonra değişse de kayıt aynı kalır. Bekleme
-- süresi kilidi (bal katı, hasat) istemcide hesaplanır: planlanan
-- çıkarma (yoksa başlangıç) günü + bekleme günü.
--
-- sync_push ilaçları durum, uygulamaları olay kaydı olarak yazar ve Drift
-- şema sürümü 5'i kabul eder.

-- ---------------------------------------------------------------------------
-- Enum'lar
-- ---------------------------------------------------------------------------

create type public.drug_active_ingredient as enum (
  'amitraz', 'oxalic_acid', 'formic_acid', 'thymol', 'flumethrin',
  'tau_fluvalinate', 'coumaphos', 'lactic_acid', 'other'
);

create type public.drug_dose_unit as enum ('strip', 'ml', 'g', 'dose');

-- ---------------------------------------------------------------------------
-- ref_drugs: referans liste (salt okunur)
-- ---------------------------------------------------------------------------
-- org_id yok. created_by standart kolonlar istemcideki aynayla aynı olsun
-- diye var; listedeki satırlarda hep boş.

create table public.ref_drugs (
  id uuid primary key,
  -- İki harfli ülke kodu ya da her bölgede görünen GLOBAL.
  country_code text not null
    check (country_code = 'GLOBAL' or country_code ~ '^[A-Z]{2}$'),
  name_tr text not null check (length(name_tr) between 1 and 120),
  name_en text not null check (length(name_en) between 1 and 120),
  active_ingredient public.drug_active_ingredient not null,
  dose_unit public.drug_dose_unit not null,
  -- Etiketteki bal bekleme süresi; bilinmiyorsa boş, kullanıcı girer.
  withdrawal_days smallint check (withdrawal_days between 0 and 365),
  license_no text check (length(license_no) between 1 and 60),
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now(),
  created_by uuid references auth.users (id) on delete set null,
  deleted_at timestamptz,
  server_seq bigint not null
);

create index ref_drugs_server_seq_idx on public.ref_drugs (server_seq);

create trigger set_server_seq
before insert or update on public.ref_drugs
for each row execute function private.set_server_seq();

alter table public.ref_drugs enable row level security;

-- Silinen satırlar da görünür; çekme silmeyi telefona böyle taşır.
create policy "Girişli kullanıcılar referans ilaçları görür"
on public.ref_drugs for select
to authenticated
using (true);

-- Örnek satırlar. Gerçek TR listesi (ürün adları, ruhsat numaraları,
-- bekleme süreleri) kullanıcıdan gelecek; o zamana kadar bekleme süresi
-- boş, kullanıcı etiketten girer. GLOBAL satırlar etken madde bazlı.
insert into public.ref_drugs (id, country_code, name_tr, name_en, active_ingredient, dose_unit) values
  ('01900000-0000-7000-8000-000000000001', 'GLOBAL', 'Amitraz', 'Amitraz', 'amitraz', 'strip'),
  ('01900000-0000-7000-8000-000000000002', 'GLOBAL', 'Oksalik asit', 'Oxalic acid', 'oxalic_acid', 'ml'),
  ('01900000-0000-7000-8000-000000000003', 'GLOBAL', 'Formik asit', 'Formic acid', 'formic_acid', 'ml'),
  ('01900000-0000-7000-8000-000000000004', 'GLOBAL', 'Timol', 'Thymol', 'thymol', 'g'),
  ('01900000-0000-7000-8000-000000000005', 'GLOBAL', 'Flumetrin', 'Flumethrin', 'flumethrin', 'strip'),
  ('01900000-0000-7000-8000-000000000006', 'GLOBAL', 'Tau-fluvalinat', 'Tau-fluvalinate', 'tau_fluvalinate', 'strip'),
  ('01900000-0000-7000-8000-000000000007', 'GLOBAL', 'Kumafos', 'Coumaphos', 'coumaphos', 'strip'),
  ('01900000-0000-7000-8000-000000000008', 'GLOBAL', 'Laktik asit', 'Lactic acid', 'lactic_acid', 'ml'),
  ('01900000-0000-7000-8000-000000000101', 'TR', 'Amitraz şerit', 'Amitraz strip', 'amitraz', 'strip'),
  ('01900000-0000-7000-8000-000000000102', 'TR', 'Oksalik asit damlatma', 'Oxalic acid trickling', 'oxalic_acid', 'ml');

-- ---------------------------------------------------------------------------
-- drugs: işletmenin eklediği ilaçlar (durum kaydı)
-- ---------------------------------------------------------------------------

create table public.drugs (
  id uuid primary key,
  org_id uuid not null references public.organizations (id) on delete cascade,
  name text not null check (length(name) between 1 and 120),
  active_ingredient public.drug_active_ingredient not null,
  dose_unit public.drug_dose_unit not null,
  withdrawal_days smallint check (withdrawal_days between 0 and 365),
  license_no text check (length(license_no) between 1 and 60),
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now(),
  created_by uuid default auth.uid() references auth.users (id) on delete set null,
  deleted_at timestamptz,
  server_seq bigint not null,
  unique (id, org_id)
);

create index drugs_org_id_idx on public.drugs (org_id);
create index drugs_server_seq_idx on public.drugs (server_seq);

create trigger set_server_seq
before insert or update on public.drugs
for each row execute function private.set_server_seq();

alter table public.drugs enable row level security;

create policy "Üyeler işletmenin ilaçlarını görür"
on public.drugs for select
to authenticated
using (private.is_member(org_id));

create policy "Yazabilen üyeler ilaç ekler"
on public.drugs for insert
to authenticated
with check (private.has_role(org_id, '{owner,partner,worker}'));

create policy "Yazabilen üyeler ilaçları günceller"
on public.drugs for update
to authenticated
using (private.has_role(org_id, '{owner,partner,worker}'))
with check (private.has_role(org_id, '{owner,partner,worker}'));

-- ---------------------------------------------------------------------------
-- treatments: ilaç uygulaması (olay kaydı)
-- ---------------------------------------------------------------------------

create table public.treatments (
  id uuid primary key,
  org_id uuid not null references public.organizations (id) on delete cascade,
  hive_id uuid not null,
  -- Uygulamanın yapıldığı arılık; kovan sonra taşınsa da değişmez.
  apiary_id uuid not null,
  -- İlaç ya referans listeden ya da işletmenin kendi listesinden.
  ref_drug_id uuid references public.ref_drugs (id),
  drug_id uuid,
  -- Uygulama anındaki ürün adı ve etken madde.
  product_name text not null check (length(product_name) between 1 and 120),
  active_ingredient public.drug_active_ingredient not null,
  batch_no text check (length(batch_no) between 1 and 60),
  -- Kovan başına doz.
  dose numeric(8, 2) not null check (dose > 0 and dose <= 10000),
  dose_unit public.drug_dose_unit not null,
  started_at timestamptz not null,
  -- Şeridin çıkarılacağı gün; tek seferlik uygulamada (damlatma) boş.
  planned_removal_at timestamptz check (planned_removal_at >= started_at),
  -- Çıkarmadan (yoksa başlangıçtan) sonra bal katı ve hasat için gün.
  withdrawal_days smallint not null check (withdrawal_days between 0 and 365),
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now(),
  created_by uuid default auth.uid() references auth.users (id) on delete set null,
  deleted_at timestamptz,
  server_seq bigint not null,
  unique (id, org_id),
  foreign key (hive_id, org_id) references public.hives (id, org_id),
  foreign key (apiary_id, org_id) references public.apiaries (id, org_id),
  foreign key (drug_id, org_id) references public.drugs (id, org_id),
  check (num_nonnulls(ref_drug_id, drug_id) = 1)
);

create index treatments_org_id_idx on public.treatments (org_id);
create index treatments_hive_id_idx on public.treatments (hive_id);
create index treatments_apiary_id_idx on public.treatments (apiary_id);
create index treatments_ref_drug_id_idx on public.treatments (ref_drug_id);
create index treatments_drug_id_idx on public.treatments (drug_id);
create index treatments_server_seq_idx on public.treatments (server_seq);

create trigger set_server_seq
before insert or update on public.treatments
for each row execute function private.set_server_seq();

alter table public.treatments enable row level security;

create policy "Üyeler ilaç uygulamalarını görür"
on public.treatments for select
to authenticated
using (private.is_member(org_id));

create policy "Yazabilen üyeler ilaç uygulaması ekler"
on public.treatments for insert
to authenticated
with check (private.has_role(org_id, '{owner,partner,worker}'));

create policy "Yazabilen üyeler ilaç uygulamalarını günceller"
on public.treatments for update
to authenticated
using (private.has_role(org_id, '{owner,partner,worker}'))
with check (private.has_role(org_id, '{owner,partner,worker}'));

-- ---------------------------------------------------------------------------
-- sync_push: ilaç durum, uygulama olay kaydı; şema sürümü 5
-- ---------------------------------------------------------------------------
-- İki fonksiyon da create or replace ile yenilenir; yetkiler korunur.
-- ref_drugs eşlemede yok: istemci yazarsa `unsupported` alır.

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
  supported_versions constant integer[] := array[1, 2, 3, 4, 5];
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
