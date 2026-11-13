-- Kişi adları uygulamadan kalkıyor: arılığın arazi sahibi (ad, telefon) ve
-- üyenin kendi adı (memberships.full_name). Kolonlar silinir; işletme adı
-- kalır. Şema sürümü 26.
--
-- - Eski sürümlerin arılık payload'undaki landowner_* anahtarlarını
--   jsonb_populate_record yok sayar; eski uygulama yazmaya devam eder.
-- - Eski sürümler üyenin adını hâlâ gönderebilir: set_own_member_name artık
--   hiçbir şey yazmaz, kaydı "uygulanmadı" (false) olarak döner.
-- - Ekip üyeleri e-postayla gösterilir.

-- ---------------------------------------------------------------------------
-- Kolonlar
-- ---------------------------------------------------------------------------

alter table public.apiaries drop column landowner_name;
alter table public.apiaries drop column landowner_phone;

alter table public.memberships drop constraint memberships_full_name_check;
alter table public.memberships drop column full_name;

-- ---------------------------------------------------------------------------
-- Üyenin adı: eski sürümlerin gönderdiği ad yok sayılır
-- ---------------------------------------------------------------------------
-- Belge: 20261112120000_business_profile.sql. Çağıran yine yalnız kendi
-- etkin üyeliği için gönderebilir; satır değişmez.

create or replace function private.set_own_member_name(payload jsonb)
returns boolean
language plpgsql
security definer
set search_path = ''
as $$
declare
  caller uuid := (select auth.uid());
begin
  if caller is null then
    raise exception 'Giriş yapılmamış' using errcode = '42501';
  end if;
  if not exists (
    select from public.memberships m
    where m.id = (payload ->> 'id')::uuid
      and m.user_id = caller
      and m.deleted_at is null
  ) then
    raise exception 'Yalnız kendi üyeliğinin adını değiştirebilirsin'
      using errcode = '42501';
  end if;
  return false;
end;
$$;

-- ---------------------------------------------------------------------------
-- Hesap silme: üyelik yumuşak silinir (ad kolonu artık yok)
-- ---------------------------------------------------------------------------
-- Belge: 20261113120000_account_deletion.sql. Fark: full_name yok.

create or replace function private.retire_deleted_user_memberships()
returns trigger
language plpgsql
security definer
set search_path = ''
as $$
begin
  update public.memberships
  set deleted_at = now(),
      updated_at = greatest(updated_at, now())
  where user_id = old.id
    and deleted_at is null;
  return old;
end;
$$;

create or replace function public.account_deletion_purge_records(p_request_id uuid)
returns jsonb
language plpgsql
security definer
set search_path = ''
as $$
declare
  request public.deletion_requests;
  prefixes jsonb;
begin
  select * into request
  from public.deletion_requests d
  where d.id = p_request_id
  for update;
  if not found then
    raise exception 'Silme talebi yok' using errcode = 'P0002';
  end if;
  if request.status = 'tamamlandi' then
    return jsonb_build_object('status', request.status, 'user_id', null, 'kind', request.kind);
  end if;
  if request.status <> 'bekliyor' or request.scheduled_for > now() then
    raise exception 'Talep iptal edilmiş ya da silme zamanı gelmemiş'
      using errcode = '55000';
  end if;

  if request.storage_prefixes is null then
    select coalesce(jsonb_agg(p), '[]'::jsonb) into prefixes
    from (
      -- Silinecek işletmelerin klasörleri.
      select jsonb_build_object('bucket', b.bucket, 'prefix', o.id::text || '/') as p
      from unnest(request.delete_org_ids) as o (id)
      cross join (values ('media'), ('documents'), ('receipts'), ('feedback'),
                         ('org-logos')) as b (bucket)
      union all
      -- Yayımlanan analiz raporlarının kopyaları lot kimliği altında.
      select jsonb_build_object('bucket', 'public-lots', 'prefix', l.id::text || '/')
      from public.lots l
      where l.org_id = any (request.delete_org_ids)
      union all
      -- Kalan işletmelerde kullanıcının görüş ekran görüntüleri.
      select jsonb_build_object('bucket', 'feedback', 'prefix', f.screenshot_path)
      from public.feedback f
      where f.created_by = request.user_id
        and f.screenshot_path is not null
        and not f.org_id = any (request.delete_org_ids)
    ) s;

    update public.deletion_requests
    set storage_prefixes = prefixes, purge_started_at = now()
    where id = request.id;
  end if;

  delete from public.organizations where id = any (request.delete_org_ids);

  if request.user_id is not null then
    update public.memberships
    set deleted_at = now(),
        updated_at = greatest(updated_at, now())
    where user_id = request.user_id
      and deleted_at is null;

    delete from public.feedback where created_by = request.user_id;
    delete from public.device_tokens where user_id = request.user_id;
    update public.invites
    set expires_at = now()
    where created_by = request.user_id and used_at is null and expires_at > now();
  end if;

  return jsonb_build_object('status', 'bekliyor', 'user_id', request.user_id, 'kind', request.kind);
end;
$$;

-- ---------------------------------------------------------------------------
-- sync_push: şema sürümü 26. Gövde 20261115120000_deletion_code_and_leaving_member
-- ile aynı; yalnız sürüm listesi.
-- ---------------------------------------------------------------------------

CREATE OR REPLACE FUNCTION public.sync_push(changes jsonb, client_time timestamp with time zone, schema_version integer)
 RETURNS jsonb
 LANGUAGE plpgsql
 SET search_path TO ''
AS $function$
declare
  supported_versions constant integer[] := array[1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26];
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
