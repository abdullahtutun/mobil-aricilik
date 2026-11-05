-- Hesap silme: uygulama içi akış için sunucu değişiklikleri.
--
-- 1. Giriş artık talebi kendiliğinden iptal etmez. Bekleme süresinde giriş
--    yapan kullanıcıya uygulama önce "Hesabın silinmek üzere. Devam edersen
--    silme iptal olur." der; onaylarsa `account-delete` `cancel` çağrılır,
--    vazgeçerse oturum kapanır ve talep sürer. Uygulama bekleyen talebi
--    `account_deletion_pending` ile (Edge Function `status`) sorar.
-- 2. Sahipliği devret ve ayrıl: `account_deletion_request`'e `p_transfer_to`
--    eklenir. Owner, işletmenin bir ortağını (partner) yeni owner yapar,
--    kendisi partner olur; aynı işlemde yalnız hesabının silme talebi
--    yazılır. Devir yalnız ortağa yapılır; uygun değilse DL422.

-- ---------------------------------------------------------------------------
-- 1. Giriş talebi iptal etmez
-- ---------------------------------------------------------------------------

drop trigger cancel_deletion_on_sign_in on auth.sessions;
drop function private.cancel_deletion_on_sign_in();

-- Kullanıcının bekleyen talebi; yoksa null. Kalıcı silme başladıysa da
-- döner (iptal edilemez, `cancel` false döner).
create function public.account_deletion_pending(p_user_id uuid)
returns jsonb
language sql
stable
security definer
set search_path = ''
as $$
  select private.deletion_request_json(d)
  from public.deletion_requests d
  where d.user_id = p_user_id and d.status = 'bekliyor';
$$;

revoke all on function public.account_deletion_pending(uuid) from public, anon, authenticated;
grant execute on function public.account_deletion_pending(uuid) to service_role;

-- ---------------------------------------------------------------------------
-- 2. Talep: sahiplik devriyle
-- ---------------------------------------------------------------------------
-- Hatalar: 22023 geçersiz girdi, 42501 işletmenin owner'ı değil, DL409
-- owner + ekip (detail: işletme kimlikleri, virgülle), DL422 devir hedefi
-- uygun değil (işletmenin etkin ortağı değil ya da kendisinin bekleyen
-- silme talebi var), DL429 hız sınırı. Bekleyen talep varsa yenisi
-- yazılmaz, o döner (already_pending); devir de yapılmaz.

drop function public.account_deletion_request(uuid, text, uuid, boolean, text);

create function public.account_deletion_request(
  p_user_id uuid,
  p_email text,
  p_org_id uuid default null,
  p_delete_organization boolean default false,
  p_channel text default 'uygulama',
  p_transfer_to uuid default null
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
  if p_transfer_to is not null and (
       p_org_id is null
       or coalesce(p_delete_organization, false)
       or p_transfer_to = p_user_id
     ) then
    raise exception 'Geçersiz sahiplik devri' using errcode = '22023';
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

  -- Sahiplik devri: talep yazılmadan önce; aşağıdaki owner denetimi devirden
  -- sonraki rolleri görür. Talep reddedilirse devir de geri alınır.
  if p_transfer_to is not null then
    if not exists (
      select 1 from public.memberships m
      where m.org_id = p_org_id and m.user_id = p_user_id
        and m.deleted_at is null and m.role = 'owner'
    ) then
      raise exception 'Sahipliği yalnız owner devredebilir' using errcode = '42501';
    end if;
    if not exists (
      select 1 from public.memberships m
      where m.org_id = p_org_id and m.user_id = p_transfer_to
        and m.deleted_at is null and m.role = 'partner'
    ) or exists (
      select 1 from public.deletion_requests d
      where d.user_id = p_transfer_to and d.status = 'bekliyor'
    ) then
      raise exception 'Sahiplik yalnız işletmenin etkin bir ortağına devredilir'
        using errcode = 'DL422';
    end if;

    update public.memberships
    set role = 'owner', updated_at = greatest(updated_at, now())
    where org_id = p_org_id and user_id = p_transfer_to and deleted_at is null;
    update public.memberships
    set role = 'partner', updated_at = greatest(updated_at, now())
    where org_id = p_org_id and user_id = p_user_id and deleted_at is null;
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

revoke all on function public.account_deletion_request(uuid, text, uuid, boolean, text, uuid) from public, anon, authenticated;
grant execute on function public.account_deletion_request(uuid, text, uuid, boolean, text, uuid) to service_role;
