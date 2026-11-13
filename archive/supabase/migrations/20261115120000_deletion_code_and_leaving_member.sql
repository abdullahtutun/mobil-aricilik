-- Hesap silme: kendi doğrulama kodumuz ve silinmek üzere olan üye.
--
-- 1. Silme kodu. Uygulamadaki kimlik doğrulama artık giriş OTP'si değil:
--    `account-delete` `send_code` 6 haneli kod üretir (`account_deletion_send_code`)
--    ve "hesap silme kodun" e-postasıyla yollar; kod özetiyle 10 dakika
--    saklanır. `verify_code` en çok 5 denemeyle doğrular; `request` yalnız son
--    15 dakikada doğrulanmış kodla kabul edilir ve kodu tüketir. Böylece
--    doğrulama sunucuda da zorunlu; yeni oturum açılmaz.
-- 2. memberships.deletion_scheduled_for: üyenin bekleyen silme talebinin
--    tarihi. Talep yazılınca dolar, iptal edilince boşalır (deletion_requests
--    tetikleyicisi); senkronla diğer cihazlara iner. Ekip ekranı bu üyenin
--    rolünü değiştirmeyi ve çıkarmayı kapatır; `invite` de 409 member_leaving
--    ile reddeder. Şema sürümü 25.

-- ---------------------------------------------------------------------------
-- 1. Silme kodu
-- ---------------------------------------------------------------------------

create table private.deletion_codes (
  user_id uuid primary key references auth.users (id) on delete cascade,
  code_hash text not null,
  expires_at timestamptz not null,
  attempts integer not null default 0,
  verified_at timestamptz,
  sent_at timestamptz not null default now(),
  -- Saatlik gönderim sınırı için.
  window_started_at timestamptz not null default now(),
  sent_in_window integer not null default 1
);

alter table private.deletion_codes enable row level security;
revoke all on private.deletion_codes from public, anon, authenticated;

-- Kodun tek yönlü özeti; kullanıcıya bağlı, düz kod saklanmaz.
create function private.deletion_code_hash(p_user_id uuid, p_code text)
returns text
language sql
immutable
set search_path = ''
as $$
  select private.deletion_hash(p_user_id::text || ':' || p_code);
$$;

revoke all on function private.deletion_code_hash(uuid, text) from public;

-- Yeni kod üretir ve düz hâlini döner (yalnız Edge Function e-postaya
-- yazar). Önceki kod geçersiz olur. 60 sn'den sık ya da saatte 5'ten çok
-- istenirse DL429.
create function public.account_deletion_send_code(p_user_id uuid)
returns text
language plpgsql
volatile
security definer
set search_path = ''
as $$
declare
  existing private.deletion_codes;
  code text;
begin
  if p_user_id is null then
    raise exception 'Geçersiz kullanıcı' using errcode = '22023';
  end if;
  select * into existing from private.deletion_codes where user_id = p_user_id for update;
  if found then
    if existing.sent_at > now() - interval '60 seconds'
       or (existing.window_started_at > now() - interval '1 hour'
           and existing.sent_in_window >= 5) then
      raise exception 'Kısa sürede çok fazla kod' using errcode = 'DL429';
    end if;
  end if;

  code := lpad(
    ((('x' || encode(extensions.gen_random_bytes(4), 'hex'))::bit(32)::bigint) % 1000000)::text,
    6, '0'
  );

  insert into private.deletion_codes (user_id, code_hash, expires_at)
  values (p_user_id, private.deletion_code_hash(p_user_id, code), now() + interval '10 minutes')
  on conflict (user_id) do update
  set code_hash = excluded.code_hash,
      expires_at = excluded.expires_at,
      attempts = 0,
      verified_at = null,
      sent_at = now(),
      window_started_at = case
        when private.deletion_codes.window_started_at > now() - interval '1 hour'
          then private.deletion_codes.window_started_at
        else now()
      end,
      sent_in_window = case
        when private.deletion_codes.window_started_at > now() - interval '1 hour'
          then private.deletion_codes.sent_in_window + 1
        else 1
      end;
  return code;
end;
$$;

-- 'ok' | 'invalid' | 'expired' | 'too_many'. Yanlış her deneme sayılır;
-- 5 yanlıştan sonra kod kullanılamaz, yenisi istenmeli.
create function public.account_deletion_verify_code(p_user_id uuid, p_code text)
returns text
language plpgsql
volatile
security definer
set search_path = ''
as $$
declare
  row private.deletion_codes;
begin
  select * into row from private.deletion_codes where user_id = p_user_id for update;
  if not found then
    return 'invalid';
  end if;
  if row.attempts >= 5 then
    return 'too_many';
  end if;
  if row.expires_at <= now() then
    return 'expired';
  end if;
  if row.code_hash <> private.deletion_code_hash(p_user_id, coalesce(p_code, '')) then
    update private.deletion_codes set attempts = attempts + 1 where user_id = p_user_id;
    return case when row.attempts + 1 >= 5 then 'too_many' else 'invalid' end;
  end if;
  update private.deletion_codes set verified_at = now() where user_id = p_user_id;
  return 'ok';
end;
$$;

-- Son 15 dakikada doğrulanmış kod var mı.
create function public.account_deletion_code_verified(p_user_id uuid)
returns boolean
language sql
stable
security definer
set search_path = ''
as $$
  select exists (
    select 1 from private.deletion_codes
    where user_id = p_user_id
      and verified_at is not null
      and verified_at > now() - interval '15 minutes'
  );
$$;

-- Talep açılınca kod bir daha kullanılamaz.
create function public.account_deletion_consume_code(p_user_id uuid)
returns void
language sql
volatile
security definer
set search_path = ''
as $$
  delete from private.deletion_codes where user_id = p_user_id;
$$;

revoke all on function public.account_deletion_send_code(uuid) from public, anon, authenticated;
revoke all on function public.account_deletion_verify_code(uuid, text) from public, anon, authenticated;
revoke all on function public.account_deletion_code_verified(uuid) from public, anon, authenticated;
revoke all on function public.account_deletion_consume_code(uuid) from public, anon, authenticated;
grant execute on function public.account_deletion_send_code(uuid) to service_role;
grant execute on function public.account_deletion_verify_code(uuid, text) to service_role;
grant execute on function public.account_deletion_code_verified(uuid) to service_role;
grant execute on function public.account_deletion_consume_code(uuid) to service_role;

-- ---------------------------------------------------------------------------
-- 2. Silinmek üzere olan üye
-- ---------------------------------------------------------------------------

alter table public.memberships
  add column deletion_scheduled_for timestamptz;

-- Bekleyen talep: kullanıcının etkin üyeliklerine tarih yazılır; talep
-- iptal ya da tamamlanınca (üyelik zaten yumuşak silinir) boşalır.
-- updated_at ilerler, server_seq tetikleyicisi diğer cihazlara indirir.
create function private.sync_member_deletion_schedule()
returns trigger
language plpgsql
security definer
set search_path = ''
as $$
declare
  scheduled timestamptz := case when new.status = 'bekliyor' then new.scheduled_for end;
begin
  if new.user_id is null then
    return null;
  end if;
  if tg_op = 'UPDATE' and new.status is not distinct from old.status then
    return null;
  end if;
  update public.memberships
  set deletion_scheduled_for = scheduled,
      updated_at = greatest(updated_at, now())
  where user_id = new.user_id
    and deleted_at is null
    and deletion_scheduled_for is distinct from scheduled;
  return null;
end;
$$;

revoke all on function private.sync_member_deletion_schedule() from public;

create trigger sync_member_deletion_schedule
after insert or update of status on public.deletion_requests
for each row execute function private.sync_member_deletion_schedule();

-- ---------------------------------------------------------------------------
-- sync_push: şema sürümü 25 (memberships.deletion_scheduled_for). Gövde
-- 20261112120000_business_profile'daki ile aynı; yalnız sürüm listesi.
-- Üyenin kendi satırından yalnız ad yazılır; yeni kolon yok sayılır.
-- ---------------------------------------------------------------------------

CREATE OR REPLACE FUNCTION public.sync_push(changes jsonb, client_time timestamp with time zone, schema_version integer)
 RETURNS jsonb
 LANGUAGE plpgsql
 SET search_path TO ''
AS $function$
declare
  supported_versions constant integer[] := array[1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25];
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
