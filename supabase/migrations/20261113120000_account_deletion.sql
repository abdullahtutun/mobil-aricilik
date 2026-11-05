-- Hesap ve işletme silme (KVKK): sunucu tarafı.
--
-- Kim neyi siler:
-- - Üye (partner, worker, viewer): hesabı silinir; işletme ve kayıtları
--   kalır. Girdiği kayıtların `created_by`'ı auth kullanıcısı silinince
--   FK ile boşalır ("silinmiş kullanıcı"); üyeliği yumuşak silinir ve adı
--   (`full_name`) temizlenir.
-- - Owner + ekipte başka etkin üye: önce sahipliği devretmeli ya da
--   işletmeyi tümüyle silmeyi seçmeli (`delete_organization`). Seçmezse
--   talep DL409 ile reddedilir; işletme sahipsiz kalmaz.
-- - Tek kişilik işletmenin owner'ı: hesap silme işletmeyi ve tüm kayıtları
--   da siler (tür 'hesap_ve_isletme').
--
-- Akış: `account-delete` Edge Function'ı (service role) talebi
-- `account_deletion_request` ile yazar. Bekleme süresi
-- `private.account_deletion_grace()` (7 gün; KVKK'nın 30 günlük
-- penceresinin içinde). Bu sürede oturumlar kapalı, veriler durur; kullanıcı
-- yeniden giriş yaparsa (`auth.sessions`'a yeni satır) talep kendiliğinden
-- iptal olur. Süre dolunca pg_cron her saat Edge Function'ı çağırır;
-- fonksiyon sırayla kayıtları (`account_deletion_purge_records`), Storage
-- dosyalarını (`account_deletion_storage_objects` + Storage API) ve en son
-- auth kullanıcısını siler, sonra `account_deletion_complete` silme
-- kaydını yazar. Her adım tekrar çalıştırılabilir; yarıda kesilen silme
-- sonraki cron turunda kaldığı yerden tamamlanır.
--
-- Silme kaydı `private.deletion_log`: tarih, tür, kanal ve kullanıcı
-- kimliğinin SHA-256 özeti; ad, e-posta, telefon yok. En az üç yıl silinemez
-- (KVKK silme yönetmeliği).
--
-- Seçimli alanlar Postgres enum'u değil text + CHECK: tablo senkronlanmaz,
-- public enum'lar istemcideki aynayla birebir eşleşmek zorunda
-- (schema_mirror_test).

-- ---------------------------------------------------------------------------
-- Sabitler
-- ---------------------------------------------------------------------------

-- Talep ile kalıcı silme arası. Tek kaynak: Edge Function ve testler
-- planlanan zamanı bu fonksiyondan alır.
create function private.account_deletion_grace()
returns interval
language sql
immutable
set search_path = ''
as $$
  select interval '7 days';
$$;

-- Kullanıcı kimliğinin ya da e-postanın tek yönlü özeti (hex SHA-256).
create function private.deletion_hash(value text)
returns text
language sql
immutable
set search_path = ''
as $$
  select encode(extensions.digest(value, 'sha256'), 'hex');
$$;

-- ---------------------------------------------------------------------------
-- Üyelik: auth kullanıcısı silinince yumuşak silinir
-- ---------------------------------------------------------------------------
-- Önceden `memberships.user_id` auth.users'a `on delete cascade` bağlıydı:
-- kullanıcı silinince üyelik satırı kalıcı siliniyor ve bu, diğer
-- cihazlara senkronla ulaşmıyordu. FK kaldırılır; silinen kullanıcının
-- üyeliği `deleted_at` ve boş adla kalır (server_seq artar, cihazlar çeker).
-- Kalan `user_id` hiçbir hesaba bağlanmayan rastgele bir kimliktir.

alter table public.memberships drop constraint memberships_user_id_fkey;

create function private.retire_deleted_user_memberships()
returns trigger
language plpgsql
security definer
set search_path = ''
as $$
begin
  update public.memberships
  set deleted_at = coalesce(deleted_at, now()),
      full_name = null,
      updated_at = greatest(updated_at, now())
  where user_id = old.id
    and (deleted_at is null or full_name is not null);
  return old;
end;
$$;

revoke all on function private.retire_deleted_user_memberships() from public;

create trigger retire_deleted_user_memberships
before delete on auth.users
for each row execute function private.retire_deleted_user_memberships();

-- ---------------------------------------------------------------------------
-- Tablolar
-- ---------------------------------------------------------------------------

create table public.deletion_requests (
  id uuid primary key default gen_random_uuid(),
  -- Auth kullanıcısı kalıcı silinince boşalır.
  user_id uuid references auth.users (id) on delete set null,
  -- Talebin yapıldığı işletme (uygulamada açık olan); kayıt amaçlı.
  org_id uuid,
  kind text not null check (kind in ('hesap', 'hesap_ve_isletme')),
  requested_at timestamptz not null default now(),
  scheduled_for timestamptz not null,
  channel text not null check (channel in ('uygulama', 'web')),
  status text not null default 'bekliyor'
    check (status in ('bekliyor', 'iptal', 'tamamlandi')),
  -- Kalıcı silmede tümüyle silinecek işletmeler.
  delete_org_ids uuid[] not null default '{}',
  -- Silme kaydına ve hız sınırına giden özetler; e-posta saklanmaz.
  user_hash text not null,
  email_hash text,
  -- İlk kalıcı silme turunda yazılır: silinecek Storage önekleri
  -- ([{bucket, prefix}]). Kayıtlar silindikten sonra da (lot kimlikleri
  -- gibi) bilinsin diye saklanır.
  storage_prefixes jsonb,
  purge_started_at timestamptz,
  cancelled_at timestamptz,
  completed_at timestamptz,
  check (scheduled_for > requested_at),
  check ((status = 'iptal') = (cancelled_at is not null)),
  check ((status = 'tamamlandi') = (completed_at is not null)),
  check ((kind = 'hesap_ve_isletme') = (cardinality(delete_org_ids) > 0))
);

-- Kullanıcının bekleyen en çok bir talebi olur.
create unique index deletion_requests_pending_user_key
  on public.deletion_requests (user_id)
  where status = 'bekliyor';
create index deletion_requests_due_idx
  on public.deletion_requests (scheduled_for)
  where status = 'bekliyor';
create index deletion_requests_user_id_idx
  on public.deletion_requests (user_id, requested_at);
create index deletion_requests_email_hash_idx
  on public.deletion_requests (email_hash, requested_at);

alter table public.deletion_requests enable row level security;

-- Yazmalar yalnız service role'den (Edge Function); istemci doğrudan silme
-- ya da talep yazamaz.
revoke all on public.deletion_requests from anon, authenticated;
grant select on public.deletion_requests to authenticated;

create policy "Kullanıcı kendi silme talebini görür"
on public.deletion_requests for select
to authenticated
using (user_id = (select auth.uid()));

-- Silme kaydı: API'ye açılmayan şemada, yalnız sunucu yazar.
create table private.deletion_log (
  id bigint generated always as identity primary key,
  request_id uuid not null unique,
  user_hash text not null,
  kind text not null check (kind in ('hesap', 'hesap_ve_isletme')),
  channel text not null check (channel in ('uygulama', 'web')),
  requested_at timestamptz not null,
  completed_at timestamptz not null default now()
);

alter table private.deletion_log enable row level security;
revoke all on private.deletion_log from public, anon, authenticated;

-- Kayıt değiştirilemez; üç yıl dolmadan silinemez.
create function private.protect_deletion_log()
returns trigger
language plpgsql
set search_path = ''
as $$
begin
  if tg_op = 'UPDATE' then
    raise exception 'Silme kaydı değiştirilemez' using errcode = '42501';
  end if;
  if old.completed_at > now() - interval '3 years' then
    raise exception 'Silme kaydı üç yıl saklanır' using errcode = '42501';
  end if;
  return old;
end;
$$;

revoke all on function private.protect_deletion_log() from public;

create trigger protect_deletion_log
before update or delete on private.deletion_log
for each row execute function private.protect_deletion_log();

-- ---------------------------------------------------------------------------
-- Yardımcılar
-- ---------------------------------------------------------------------------

-- Silinecek işletmelerdeki kayıt sayıları ve yayımdaki lot sayfaları.
create function private.account_deletion_counts(org_ids uuid[])
returns jsonb
language sql
stable
security definer
set search_path = ''
as $$
  select jsonb_build_object(
    'hives', (select count(*) from public.hives
              where org_id = any (org_ids) and deleted_at is null),
    'apiaries', (select count(*) from public.apiaries
                 where org_id = any (org_ids) and deleted_at is null),
    'inspections', (select count(*) from public.inspections
                    where org_id = any (org_ids) and deleted_at is null),
    'harvests', (select count(*) from public.harvests
                 where org_id = any (org_ids) and deleted_at is null),
    'documents', (select count(*) from public.documents
                  where org_id = any (org_ids) and deleted_at is null),
    'photos', (select count(*) from public.media
               where org_id = any (org_ids) and deleted_at is null
                 and kind = 'photo'),
    'public_lot_pages', (select count(*) from public.lots
                         where org_id = any (org_ids) and deleted_at is null
                           and published)
  );
$$;

-- Talebin istemciye dönen yüzü (özetler ve iç alanlar yok).
create function private.deletion_request_json(r public.deletion_requests)
returns jsonb
language sql
stable
set search_path = ''
as $$
  select jsonb_build_object(
    'id', r.id,
    'org_id', r.org_id,
    'kind', r.kind,
    'channel', r.channel,
    'status', r.status,
    'requested_at', r.requested_at,
    'scheduled_for', r.scheduled_for,
    'delete_org_ids', to_jsonb(r.delete_org_ids)
  );
$$;

revoke all on function private.account_deletion_grace() from public;
revoke all on function private.deletion_hash(text) from public;
revoke all on function private.account_deletion_counts(uuid[]) from public;
revoke all on function private.deletion_request_json(public.deletion_requests) from public;

-- ---------------------------------------------------------------------------
-- Talep et
-- ---------------------------------------------------------------------------
-- Hatalar: 22023 geçersiz girdi, 42501 işletmenin owner'ı değil, DL409
-- owner + ekip (detail: işletme kimlikleri, virgülle), DL429 hız sınırı.
-- Bekleyen talep varsa yenisi yazılmaz, o döner (already_pending).
-- Aynı işlemde: kullanıcının bildirim token'ları silinir, kullanıcının ve
-- silinecek işletmelerin kullanılmamış davet kodları iptal olur.

create function public.account_deletion_request(
  p_user_id uuid,
  p_email text,
  p_org_id uuid default null,
  p_delete_organization boolean default false,
  p_channel text default 'uygulama'
)
returns jsonb
language plpgsql
security definer
set search_path = ''
as $$
declare
  -- Aynı kullanıcı ya da aynı e-posta için pencere başına en çok talep.
  max_requests constant integer := 3;
  rate_window constant interval := interval '24 hours';
  hashed_email text;
  existing public.deletion_requests;
  request public.deletion_requests;
  owned_ids uuid[];
  to_delete uuid[];
  blocked uuid[];
  recent integer;
begin
  if p_user_id is null or p_channel is null
     or p_channel not in ('uygulama', 'web') then
    raise exception 'Geçersiz silme talebi' using errcode = '22023';
  end if;
  hashed_email := case
    when nullif(btrim(p_email), '') is not null
      then private.deletion_hash(lower(btrim(p_email)))
  end;

  -- Aynı kullanıcının eşzamanlı iki talebi sırayla işlenir.
  perform pg_advisory_xact_lock(hashtextextended('account_deletion:' || p_user_id::text, 0));

  select * into existing
  from public.deletion_requests d
  where d.user_id = p_user_id and d.status = 'bekliyor';
  if found then
    return jsonb_build_object(
      'request', private.deletion_request_json(existing),
      'counts', private.account_deletion_counts(existing.delete_org_ids),
      'already_pending', true
    );
  end if;

  select count(*) into recent
  from public.deletion_requests d
  where d.requested_at > now() - rate_window
    and (d.user_id = p_user_id
         or (hashed_email is not null and d.email_hash = hashed_email));
  if recent >= max_requests then
    raise exception 'Kısa sürede çok fazla silme talebi' using errcode = 'DL429';
  end if;

  if p_org_id is not null and not exists (
    select 1 from public.memberships m
    where m.org_id = p_org_id and m.user_id = p_user_id and m.deleted_at is null
  ) then
    raise exception 'Bu işletmenin üyesi değilsin' using errcode = '42501';
  end if;

  -- Owner olunan işletmeler: tek kişilikse silinir; ekip varsa yalnız
  -- işletmeyi silmek seçildiyse silinir, yoksa talep reddedilir.
  select
    coalesce(array_agg(o.org_id), '{}'),
    coalesce(array_agg(o.org_id) filter (
      where o.others = 0
        or (coalesce(p_delete_organization, false) and o.org_id = p_org_id)
    ), '{}'),
    coalesce(array_agg(o.org_id) filter (
      where o.others > 0
        and not (coalesce(p_delete_organization, false) and o.org_id = p_org_id)
    ), '{}')
  into owned_ids, to_delete, blocked
  from (
    select m.org_id, (
      select count(*) from public.memberships x
      where x.org_id = m.org_id and x.deleted_at is null and x.user_id <> p_user_id
    ) as others
    from public.memberships m
    where m.user_id = p_user_id and m.deleted_at is null and m.role = 'owner'
  ) o;

  if coalesce(p_delete_organization, false)
     and (p_org_id is null or not p_org_id = any (owned_ids)) then
    raise exception 'İşletmeyi yalnız owner silebilir' using errcode = '42501';
  end if;
  if cardinality(blocked) > 0 then
    raise exception 'Owner olduğun işletmede ekip var: önce sahipliği devret ya da işletmeyi sil'
      using errcode = 'DL409', detail = array_to_string(blocked, ',');
  end if;

  insert into public.deletion_requests (
    user_id, org_id, kind, scheduled_for, channel, delete_org_ids,
    user_hash, email_hash
  )
  values (
    p_user_id,
    coalesce(p_org_id, to_delete[1]),
    case when cardinality(to_delete) > 0 then 'hesap_ve_isletme' else 'hesap' end,
    now() + private.account_deletion_grace(),
    p_channel,
    to_delete,
    private.deletion_hash(p_user_id::text),
    hashed_email
  )
  returning * into request;

  -- Bildirimler durur; giriş yapınca cihaz token'ı yeniden kaydeder.
  delete from public.device_tokens where user_id = p_user_id;

  -- Bekleyen davet kodları iptal olur.
  update public.invites
  set expires_at = now()
  where used_at is null
    and expires_at > now()
    and (created_by = p_user_id or org_id = any (to_delete));

  return jsonb_build_object(
    'request', private.deletion_request_json(request),
    'counts', private.account_deletion_counts(to_delete),
    'already_pending', false
  );
end;
$$;

-- ---------------------------------------------------------------------------
-- İptal et
-- ---------------------------------------------------------------------------
-- Kalıcı silme başladıysa iptal edilmez.

create function public.account_deletion_cancel(p_user_id uuid)
returns boolean
language plpgsql
security definer
set search_path = ''
as $$
begin
  update public.deletion_requests
  set status = 'iptal', cancelled_at = now()
  where user_id = p_user_id
    and status = 'bekliyor'
    and purge_started_at is null;
  return found;
end;
$$;

-- Giriş yapmak talebi iptal eder: talepte tüm oturumlar kapatıldığı için
-- yeni oturum yalnız yeni bir girişle açılır.
create function private.cancel_deletion_on_sign_in()
returns trigger
language plpgsql
security definer
set search_path = ''
as $$
begin
  update public.deletion_requests
  set status = 'iptal', cancelled_at = now()
  where user_id = new.user_id
    and status = 'bekliyor'
    and purge_started_at is null;
  return null;
end;
$$;

revoke all on function private.cancel_deletion_on_sign_in() from public;

create trigger cancel_deletion_on_sign_in
after insert on auth.sessions
for each row execute function private.cancel_deletion_on_sign_in();

-- ---------------------------------------------------------------------------
-- Kalıcı silme
-- ---------------------------------------------------------------------------

-- Süresi dolan, bekleyen talepler (eskiden yeniye). Yarıda kalanlar da
-- (purge_started_at dolu) hâlâ 'bekliyor' olduğu için yeniden döner.
create function public.account_deletion_due(p_limit integer default 20)
returns table (id uuid, user_id uuid)
language sql
stable
security definer
set search_path = ''
as $$
  select d.id, d.user_id
  from public.deletion_requests d
  where d.status = 'bekliyor' and d.scheduled_for <= now()
  order by d.scheduled_for
  limit greatest(p_limit, 1);
$$;

-- 1. adım: veritabanı kayıtları. Tekrar çalıştırılabilir.
-- - Silinecek işletmeler: organizations satırı silinir; işletmeye bağlı her
--   tablo `org_id ... on delete cascade` ile, kendi aralarındaki bileşik
--   FK'lar aynı ifadenin sonunda denetlendiği için bağımlılık sırasıyla
--   silinir.
-- - Kalan işletmelerde: üyelik yumuşak silinir, ad temizlenir.
-- - Kullanıcının görüş mesajları, bildirim token'ları silinir; davet
--   kodları iptal olur.
-- Dönüş: { status, user_id, kind }.
create function public.account_deletion_purge_records(p_request_id uuid)
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
    set deleted_at = coalesce(deleted_at, now()),
        full_name = null,
        updated_at = greatest(updated_at, now())
    where user_id = request.user_id
      and (deleted_at is null or full_name is not null);

    delete from public.feedback where created_by = request.user_id;
    delete from public.device_tokens where user_id = request.user_id;
    update public.invites
    set expires_at = now()
    where created_by = request.user_id and used_at is null and expires_at > now();
  end if;

  return jsonb_build_object('status', 'bekliyor', 'user_id', request.user_id, 'kind', request.kind);
end;
$$;

-- 2. adım: silinmeyi bekleyen Storage dosyaları. Edge Function bunları
-- Storage API ile siler ve liste boşalana kadar yeniden sorar.
create function public.account_deletion_storage_objects(
  p_request_id uuid,
  p_limit integer default 1000
)
returns table (bucket_id text, name text)
language sql
stable
security definer
set search_path = ''
as $$
  select o.bucket_id, o.name
  from public.deletion_requests d
  cross join lateral jsonb_to_recordset(coalesce(d.storage_prefixes, '[]'::jsonb))
    as p (bucket text, prefix text)
  join storage.objects o
    on o.bucket_id = p.bucket and starts_with(o.name, p.prefix)
  where d.id = p_request_id
  order by o.bucket_id, o.name
  limit greatest(p_limit, 1);
$$;

-- Son adım: auth kullanıcısı silindikten sonra silme kaydı yazılır ve talep
-- tamamlanır. Önceki adımlar bitmeden çağrılırsa hata verir (55000).
-- Tekrar çağrı false döner.
create function public.account_deletion_complete(p_request_id uuid)
returns boolean
language plpgsql
security definer
set search_path = ''
as $$
declare
  request public.deletion_requests;
begin
  select * into request
  from public.deletion_requests d
  where d.id = p_request_id
  for update;
  if not found then
    raise exception 'Silme talebi yok' using errcode = 'P0002';
  end if;
  if request.status = 'tamamlandi' then
    return false;
  end if;
  if request.status <> 'bekliyor' or request.purge_started_at is null then
    raise exception 'Kayıtlar silinmeden talep tamamlanamaz' using errcode = '55000';
  end if;
  if exists (select 1 from public.account_deletion_storage_objects(p_request_id, 1)) then
    raise exception 'Storage dosyaları silinmeden talep tamamlanamaz' using errcode = '55000';
  end if;
  if request.user_id is not null
     and exists (select 1 from auth.users u where u.id = request.user_id) then
    raise exception 'Auth kullanıcısı silinmeden talep tamamlanamaz' using errcode = '55000';
  end if;

  insert into private.deletion_log (request_id, user_hash, kind, channel, requested_at)
  values (request.id, request.user_hash, request.kind, request.channel, request.requested_at)
  on conflict (request_id) do nothing;

  update public.deletion_requests
  set status = 'tamamlandi', completed_at = now()
  where id = request.id;
  return true;
end;
$$;

-- Yalnız service role (Edge Function) çağırır.
revoke all on function public.account_deletion_request(uuid, text, uuid, boolean, text) from public, anon, authenticated;
revoke all on function public.account_deletion_cancel(uuid) from public, anon, authenticated;
revoke all on function public.account_deletion_due(integer) from public, anon, authenticated;
revoke all on function public.account_deletion_purge_records(uuid) from public, anon, authenticated;
revoke all on function public.account_deletion_storage_objects(uuid, integer) from public, anon, authenticated;
revoke all on function public.account_deletion_complete(uuid) from public, anon, authenticated;
grant execute on function public.account_deletion_request(uuid, text, uuid, boolean, text) to service_role;
grant execute on function public.account_deletion_cancel(uuid) to service_role;
grant execute on function public.account_deletion_due(integer) to service_role;
grant execute on function public.account_deletion_purge_records(uuid) to service_role;
grant execute on function public.account_deletion_storage_objects(uuid, integer) to service_role;
grant execute on function public.account_deletion_complete(uuid) to service_role;

-- ---------------------------------------------------------------------------
-- pg_cron: süresi dolanları her saat sil
-- ---------------------------------------------------------------------------
-- Storage ve auth silmesi API ister; cron `account-delete` fonksiyonunu
-- pg_net ile çağırır (feedback-mail ile aynı Vault düzeni, repoda yok):
--   select vault.create_secret('https://<ref>.supabase.co/functions/v1/account-delete', 'account_delete_url');
--   select vault.create_secret('<gizli anahtar>', 'account_delete_secret');
-- Gizli anahtar fonksiyonda ACCOUNT_DELETE_CRON_SECRET secret'ı olarak da
-- tanımlanır. Süresi dolan talep yoksa istek atılmaz.

create function private.account_deletion_cron()
returns boolean
language plpgsql
security definer
set search_path = ''
as $$
declare
  function_url text;
  cron_secret text;
begin
  if not exists (
    select 1 from public.deletion_requests d
    where d.status = 'bekliyor' and d.scheduled_for <= now()
  ) then
    return false;
  end if;

  select decrypted_secret into function_url
  from vault.decrypted_secrets where name = 'account_delete_url';
  select decrypted_secret into cron_secret
  from vault.decrypted_secrets where name = 'account_delete_secret';
  if function_url is null or cron_secret is null then
    return false;
  end if;

  perform net.http_post(
    url := function_url,
    headers := jsonb_build_object(
      'Content-Type', 'application/json',
      'x-cron-secret', cron_secret
    ),
    body := jsonb_build_object('action', 'purge_due'),
    timeout_milliseconds := 60000
  );
  return true;
end;
$$;

revoke all on function private.account_deletion_cron() from public;

select cron.schedule(
  'account-deletion-purge',
  '17 * * * *',
  'select private.account_deletion_cron()'
);
