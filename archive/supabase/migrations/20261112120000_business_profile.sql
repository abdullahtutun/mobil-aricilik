-- İşletme profili: işletme türü (gezginci / sabit), avatar rengi, logo;
-- üyenin adı soyadı; owner ve partner işletmeyi günceller.
--
-- - organizations.operation_type: tek kaynak. 'stationary' iken istemci
--   gezginci modüllerini (göç planı, taşıma) gizler; kayıtlar silinmez.
--   Var olan işletmeler 'migratory' kalır, hiçbir şey kaybolmaz.
-- - organizations.avatar_color: logo yokken baş harflerin zemini.
-- - organizations.logo_path: `org-logos` bucket'ındaki yol
--   (`org_id/uuid.jpg`); dosya istemcinin medya kuyruğundan yüklenir.
-- - memberships.full_name: üye kendi adını yazar (sync_push, aşağıda); rol
--   ve diğer kolonlar yine yalnız owner'ın.
-- - Para birimi değişince geçmiş kayıtlar dönüştürülmez: her finans
--   hareketi kendi `currency`'sini zaten taşıyor.

-- ---------------------------------------------------------------------------
-- Kolonlar
-- ---------------------------------------------------------------------------

create type public.operation_type as enum ('migratory', 'stationary');

create type public.org_avatar_color as enum ('pine', 'honey', 'sky', 'slate');

alter table public.organizations
  add column operation_type public.operation_type not null default 'migratory';

alter table public.organizations
  add column avatar_color public.org_avatar_color;

alter table public.organizations
  add column logo_path text;

alter table public.organizations
  add constraint organizations_logo_path_check check (
    logo_path is null
    or logo_path ~ ('^' || id::text || '/[0-9a-f-]{36}\.jpg$')
  );

alter table public.memberships
  add column full_name text;

alter table public.memberships
  add constraint memberships_full_name_check check (
    full_name is null or char_length(full_name) between 1 and 80
  );

-- ---------------------------------------------------------------------------
-- RLS: owner ve partner işletmeyi günceller
-- ---------------------------------------------------------------------------

drop policy "Owner işletmeyi günceller" on public.organizations;

create policy "Owner ve partner işletmeyi günceller"
on public.organizations for update
to authenticated
using (private.has_role(id, '{owner,partner}'))
with check (private.has_role(id, '{owner,partner}'));

-- ---------------------------------------------------------------------------
-- create_organization: kurulumdaki "Gezginci arıcılık yapıyor musun?"
-- ---------------------------------------------------------------------------
-- Belge: 20261022190700_create_organization.sql. Fark: operation_type.

drop function public.create_organization(
  uuid, text, text, text, public.hive_count_range
);

create function public.create_organization(
  id uuid,
  name text,
  country_code text,
  currency text,
  hive_count_range public.hive_count_range default null,
  operation_type public.operation_type default 'migratory'
)
returns public.organizations
language plpgsql
security definer
set search_path = ''
as $$
declare
  caller uuid := (select auth.uid());
  org public.organizations;
begin
  if caller is null then
    raise exception 'Giriş yapılmamış' using errcode = '42501';
  end if;

  select * into org
  from public.organizations o
  where o.id = create_organization.id;
  if found then
    if org.created_by is distinct from caller then
      raise exception 'Bu kimlik başka bir işletmenin' using errcode = '23505';
    end if;
    return org;
  end if;

  if btrim(create_organization.name) = '' then
    raise exception 'İşletme adı boş olamaz' using errcode = '22023';
  end if;

  insert into public.organizations (
    id, name, country_code, currency, hive_count_range, operation_type,
    created_by
  )
  values (
    create_organization.id,
    btrim(create_organization.name),
    create_organization.country_code,
    create_organization.currency,
    create_organization.hive_count_range,
    coalesce(create_organization.operation_type, 'migratory'),
    caller
  )
  returning * into org;

  -- Kimliği sunucu ürettiği için UUIDv4; Postgres 17'de uuidv7() yok.
  insert into public.memberships (id, org_id, user_id, role, created_by)
  values (gen_random_uuid(), org.id, caller, 'owner', caller);

  return org;
end;
$$;

revoke all on function public.create_organization(
  uuid, text, text, text, public.hive_count_range, public.operation_type
) from public, anon;
grant execute on function public.create_organization(
  uuid, text, text, text, public.hive_count_range, public.operation_type
) to authenticated;

-- ---------------------------------------------------------------------------
-- Üye kendi adını yazar
-- ---------------------------------------------------------------------------
-- Üyelik güncelleme politikası yalnız owner'ın; bu fonksiyon çağıranın kendi
-- etkin üyeliğinde yalnız full_name'i değiştirir. Ad yalnız sahibince
-- yazıldığı için updated_at karşılaştırması yok (rol değişikliği adı
-- ezmesin, ad da rolü ezmesin); updated_at ileri gider, server_seq artar.

create function private.set_own_member_name(payload jsonb)
returns boolean
language plpgsql
security definer
set search_path = ''
as $$
declare
  caller uuid := (select auth.uid());
  written integer;
begin
  if caller is null then
    raise exception 'Giriş yapılmamış' using errcode = '42501';
  end if;
  update public.memberships m
  set full_name = nullif(btrim(payload ->> 'full_name'), ''),
      updated_at = greatest(m.updated_at, (payload ->> 'updated_at')::timestamptz)
  where m.id = (payload ->> 'id')::uuid
    and m.user_id = caller
    and m.deleted_at is null;
  get diagnostics written = row_count;
  if written = 0 then
    raise exception 'Yalnız kendi üyeliğinin adını değiştirebilirsin'
      using errcode = '42501';
  end if;
  return true;
end;
$$;

revoke all on function private.set_own_member_name(jsonb) from public, anon;
grant execute on function private.set_own_member_name(jsonb) to authenticated;

-- ---------------------------------------------------------------------------
-- Storage: org-logos bucket'ı
-- ---------------------------------------------------------------------------
-- Özel bucket; yalnız JPEG, en çok 2 MB. Yol `org_id/uuid.jpg`. Üyeler
-- okur, owner ve partner yükler. Dosya bir kez yazılır; yeni logo yeni yol.

insert into storage.buckets (id, name, public, file_size_limit, allowed_mime_types)
values ('org-logos', 'org-logos', false, 2097152, array['image/jpeg']);

create function private.logo_object_org_id(object_name text)
returns uuid
language sql
immutable
set search_path = ''
as $$
  select case
    when object_name ~ '^[0-9a-f-]{36}/[0-9a-f-]{36}\.jpg$'
      then split_part(object_name, '/', 1)::uuid
  end;
$$;

grant execute on function private.logo_object_org_id(text) to authenticated;

create policy "Üyeler işletme logosunu okur"
on storage.objects for select
to authenticated
using (
  bucket_id = 'org-logos'
  and private.is_member(private.logo_object_org_id(name))
);

create policy "Owner ve partner işletme logosu yükler"
on storage.objects for insert
to authenticated
with check (
  bucket_id = 'org-logos'
  and private.has_role(private.logo_object_org_id(name), '{owner,partner}')
);

-- ---------------------------------------------------------------------------
-- sync_push: üyenin adı; şema sürümü 24
-- ---------------------------------------------------------------------------
-- Belge: 20261108120000_hive_status_events.sql. Fark: kind eşlemesinde
-- memberships ('own_membership', yalnız ad), işletme payload'unun eksik
-- kolonlarının sunucudaki satırdan tamamlanması, owner ve partner mesajı ve
-- desteklenen şema sürümleri.

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
  -- kurulur. own_membership: üye yalnız kendi adını yazar.
  kind constant text := case record_table
    when 'apiaries' then 'state'
    when 'queens' then 'state'
    when 'hives' then 'state'
    when 'hive_location_history' then 'event'
    when 'hive_status_events' then 'event'
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
    when 'lots' then 'state'
    when 'lot_harvests' then 'event'
    when 'lot_treatments' then 'event'
    when 'lab_results' then 'event'
    when 'lot_sales' then 'event'
    when 'transactions' then 'event'
    when 'customers' then 'state'
    when 'customer_payments' then 'event'
    when 'organizations' then 'organization'
    when 'memberships' then 'own_membership'
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
  existing_row jsonb;
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
  if kind = 'own_membership' then
    if operation <> 'upsert' then
      raise exception 'Üyelik senkronla silinmez' using errcode = '0A000';
    end if;
    return private.set_own_member_name(payload);
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

  -- Eski sürümün payload'unda sonradan eklenen kolonlar (operation_type,
  -- avatar_color, logo_path) yok; eksik kolon boşalmasın diye sunucudaki
  -- satırdan tamamlanır. Gönderilen kolonlar her zaman önce gelir.
  select to_jsonb(o) into existing_row
  from public.organizations o
  where o.id = (row_data ->> 'id')::uuid;
  if existing_row is not null then
    row_data := existing_row || row_data;
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
    raise exception 'İşletmeyi yalnız owner ve partner günceller' using errcode = '42501';
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
  supported_versions constant integer[] := array[1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20, 21, 22, 23, 24];
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
