-- Destekler (ozellikler.md: TR'ye özel modüller; uygulamada
-- RegionFeatures.subsidies arkasında).
--
-- ref_support_periods: destek başvuru dönemleri; salt okunur referans
-- liste (ref_drugs gibi). Yalnız TR için; içeriği yönetici
-- `supabase/admin/ref_support_periods.sql` ile SQL editöründen girer
-- (service role / postgres RLS'e takılmaz). Her girişli kullanıcı okur,
-- istemci yazamaz; sync_push'ta eşlemesi yok (`unsupported`).
--
-- organizations.tr_aks_hive_count: işletmenin AKS'de beyan ettiği kovan
-- sayısı. Başvuru öncesi kontrol bunu uygulamadaki aktif kovan sayısıyla
-- karşılaştırır. Owner girer, senkronla taşınır; her bölgede şemada durur.
--
-- task_source'a aks_update eklenir: kovan sayısı ya da arılık konumu
-- değişince istemcinin açtığı "AKS'de güncellemeyi unutma" görevi
-- (source_id işletme). Eski uygulama (≤ 20) bu değeri taşıyan bir görev
-- indiğinde, güncellenene kadar görevleri çekemez (queen_rearing'deki
-- karar).
--
-- Dönem açılınca push: pg_cron her gün 06:00 UTC'de (09:00 TR)
-- private.notify_support_periods()'u çalıştırır. Başlamış ve bitmemiş,
-- daha önce bildirilmemiş her dönem için `notify` Edge Function'ı pg_net
-- ile çağrılır; alıcılar TR işletmelerinin owner ve partner üyeleri.
-- Adres ve gizli anahtar görev bildirimiyle aynı Vault kayıtları
-- (`notify_url`, `notify_secret`); yoksa hiçbir şey yapılmaz ve dönem
-- bildirilmemiş kalır, kurulunca ilk turda gider.
--
-- sync_push Drift şema sürümü 21'i kabul eder.

create table public.ref_support_periods (
  id uuid primary key,
  -- Destek adı, ör. "Arıcılık desteği (kovan başı)".
  name text not null check (char_length(btrim(name)) between 1 and 200),
  -- Başvuru dönemi; iki gün de dahil.
  application_starts_on date not null,
  application_ends_on date not null,
  description text check (char_length(btrim(description)) between 1 and 2000),
  -- Resmî duyurunun adresi.
  source_url text check (source_url ~ '^https?://' and char_length(source_url) <= 1000),
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now(),
  created_by uuid references auth.users (id) on delete set null,
  deleted_at timestamptz,
  server_seq bigint not null,
  check (application_ends_on >= application_starts_on)
);

create index ref_support_periods_server_seq_idx
  on public.ref_support_periods (server_seq);

create trigger set_server_seq
before insert or update on public.ref_support_periods
for each row execute function private.set_server_seq();

alter table public.ref_support_periods enable row level security;

-- Silinen satırlar da görünür; çekme silmeyi telefona böyle taşır.
create policy "Girişli kullanıcılar destek dönemlerini görür"
on public.ref_support_periods for select
to authenticated
using (true);

alter table public.organizations
  add column tr_aks_hive_count integer
    check (tr_aks_hive_count between 0 and 100000);

alter type public.task_source add value 'aks_update';

-- ---------------------------------------------------------------------------
-- Dönem açılınca push
-- ---------------------------------------------------------------------------

-- Bildirilen dönemler; dönem bir kez bildirilir. Senkronlanmaz.
create table private.support_period_notifications (
  period_id uuid primary key
    references public.ref_support_periods (id) on delete cascade,
  notified_at timestamptz not null default now()
);

-- Destek bildirimi alacak kullanıcılar: TR işletmelerinin etkin owner ve
-- partner üyeleri, tekil.
create function private.support_period_recipients()
returns setof uuid
language sql
stable
security definer
set search_path = ''
as $$
  select distinct m.user_id
  from public.memberships m
  join public.organizations o on o.id = m.org_id
  where o.country_code = 'TR'
    and o.deleted_at is null
    and m.deleted_at is null
    and m.role in ('owner', 'partner');
$$;

-- Bugün (Türkiye saatiyle) başvurusu açık ve henüz bildirilmemiş
-- dönemleri `notify`'a gönderir; gönderilen dönem sayısını döner. Vault
-- kaydı yoksa ya da alıcı yoksa bir şey yapmaz (dönem bildirilmemiş
-- kalır). Gövde görev bildirimiyle aynı biçimde.
create function private.notify_support_periods()
returns integer
language plpgsql
security definer
set search_path = ''
as $$
declare
  today constant date := (now() at time zone 'Europe/Istanbul')::date;
  webhook_url text;
  webhook_secret text;
  recipients uuid[];
  period public.ref_support_periods;
  sent integer := 0;
begin
  select decrypted_secret into webhook_url
  from vault.decrypted_secrets where name = 'notify_url';
  select decrypted_secret into webhook_secret
  from vault.decrypted_secrets where name = 'notify_secret';
  if webhook_url is null or webhook_secret is null then
    return 0;
  end if;

  select coalesce(array_agg(r), '{}') into recipients
  from private.support_period_recipients() r;
  if cardinality(recipients) = 0 then
    return 0;
  end if;

  for period in
    select p.*
    from public.ref_support_periods p
    where p.deleted_at is null
      and p.application_starts_on <= today
      and p.application_ends_on >= today
      and not exists (
        select from private.support_period_notifications n
        where n.period_id = p.id
      )
    order by p.application_starts_on, p.id
  loop
    perform net.http_post(
      url := webhook_url,
      headers := jsonb_build_object(
        'Content-Type', 'application/json',
        'x-webhook-secret', webhook_secret
      ),
      body := jsonb_build_object(
        'type', 'OPENED',
        'table', 'ref_support_periods',
        'schema', 'public',
        'record', jsonb_build_object(
          'id', period.id,
          'name', period.name,
          'application_starts_on', period.application_starts_on,
          'application_ends_on', period.application_ends_on
        ),
        'old_record', null,
        'recipients', to_jsonb(recipients)
      )
    );
    insert into private.support_period_notifications (period_id)
    values (period.id);
    sent := sent + 1;
  end loop;
  return sent;
end;
$$;

revoke all on function private.support_period_recipients() from public;
revoke all on function private.notify_support_periods() from public;

create extension if not exists pg_cron;

select cron.schedule(
  'notify-support-periods',
  '0 6 * * *',
  'select private.notify_support_periods()'
);

-- ---------------------------------------------------------------------------
-- sync_push: şema sürümü 21
-- ---------------------------------------------------------------------------
-- Belge: 20261023164500_sync_push.sql. Tek fark desteklenen şema sürümleri.
-- ref_support_periods sync_push_change eşlemesinde yok: istemci yazarsa
-- `unsupported` alır. organizations.tr_aks_hive_count işletme
-- güncellemesine kendiliğinden katılır.
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
  supported_versions constant integer[] := array[1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20, 21];
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
