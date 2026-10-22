-- İşletme oluşturma tek RPC'de: işletme ve owner üyeliği aynı işlemde
-- yazılır. İstemci işletmeyi artık doğrudan ekleyemez.

-- Onboarding'deki "Kaç kovanın var?" cevabı. Yalnız tercihtir, kovan
-- oluşturmaz; kovan bazlı ya da grup bazlı takip önerisi buna göre yapılır.
create type public.hive_count_range as enum (
  'none', 'up_to_10', 'up_to_50', 'up_to_200', 'over_200'
);

alter table public.organizations
  add column hive_count_range public.hive_count_range;

-- Owner üyeliğini artık create_organization yazıyor. Trigger satır
-- eklendikten sonra çalıştığı için istemcinin RETURNING'li insert'ü seçme
-- politikasına takılıyordu.
drop trigger add_owner_membership on public.organizations;
drop function private.add_owner_membership();
drop policy "Kullanıcı kendi adına işletme oluşturur" on public.organizations;

-- İşletmeyi çağıranın adına oluşturur ve onu owner yapar; işletme satırını
-- döner. Kimlik istemcide üretilir (UUIDv7): aynı id ile yeniden çağrı
-- (ör. yanıtı kaybolan istek) yeni kayıt açmaz, mevcut işletmeyi döner.
create function public.create_organization(
  id uuid,
  name text,
  country_code text,
  currency text,
  hive_count_range public.hive_count_range default null
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
    id, name, country_code, currency, hive_count_range, created_by
  )
  values (
    create_organization.id,
    btrim(create_organization.name),
    create_organization.country_code,
    create_organization.currency,
    create_organization.hive_count_range,
    caller
  )
  returning * into org;

  -- Kimliği sunucu ürettiği için UUIDv4; Postgres 17'de uuidv7() yok.
  insert into public.memberships (id, org_id, user_id, role, created_by)
  values (gen_random_uuid(), org.id, caller, 'owner', caller);

  return org;
end;
$$;

-- Supabase yeni fonksiyonları varsayılan olarak anon'a da açar.
revoke all on function public.create_organization(
  uuid, text, text, text, public.hive_count_range
) from public, anon;
grant execute on function public.create_organization(
  uuid, text, text, text, public.hive_count_range
) to authenticated;
