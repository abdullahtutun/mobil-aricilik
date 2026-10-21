-- Şema v1: işletmeler, üyelikler, senkron imleci ve RLS yardımcıları.
--
-- Senkronlanan her tabloda standart alanlar: id (istemcide UUIDv7),
-- created_at, updated_at (istemciden gelir, son yazan kazanır), created_by,
-- deleted_at (yumuşak silme) ve server_seq (çekme imleci).

-- API'ye açılmayan şema: güvenlik tanımlı yardımcılar ve sequence burada.
create schema private;
grant usage on schema private to authenticated;

-- ---------------------------------------------------------------------------
-- Senkron imleci
-- ---------------------------------------------------------------------------

-- Tüm tablolar için tek, global sıra. İstemci `server_seq > imleç` ile çeker.
create sequence private.sync_seq as bigint;

-- Her insert/update'te satıra yeni server_seq verir; istemcinin gönderdiği
-- değer yok sayılır. server_seq kolonu olan her tabloya bağlanabilir.
create function private.set_server_seq()
returns trigger
language plpgsql
security definer
set search_path = ''
as $$
begin
  new.server_seq := nextval('private.sync_seq');
  return new;
end;
$$;

-- ---------------------------------------------------------------------------
-- Tablolar
-- ---------------------------------------------------------------------------

create type public.membership_role as enum ('owner', 'partner', 'worker', 'viewer');

create table public.organizations (
  id uuid primary key,
  name text not null,
  -- ISO 3166-1 alpha-2, büyük harf (RegionConfig ile aynı kural).
  country_code text not null check (country_code ~ '^[A-Z]{2}$'),
  -- ISO 4217.
  currency text not null check (currency ~ '^[A-Z]{3}$'),
  -- Yalnız TR profilinde kullanılır: işletme tescil no ve AKS no.
  tr_registration_no text,
  tr_aks_no text,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now(),
  created_by uuid default auth.uid() references auth.users (id) on delete set null,
  deleted_at timestamptz,
  server_seq bigint not null
);

create table public.memberships (
  id uuid primary key,
  org_id uuid not null references public.organizations (id) on delete cascade,
  user_id uuid not null references auth.users (id) on delete cascade,
  role public.membership_role not null,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now(),
  created_by uuid default auth.uid() references auth.users (id) on delete set null,
  deleted_at timestamptz,
  server_seq bigint not null
);

-- Kullanıcı bir işletmede tek etkin üyelik taşır; çıkarılan üye yeni bir
-- satırla yeniden eklenebilir.
create unique index memberships_org_id_user_id_key
  on public.memberships (org_id, user_id)
  where deleted_at is null;
create index memberships_user_id_idx on public.memberships (user_id);

create index organizations_server_seq_idx on public.organizations (server_seq);
create index memberships_server_seq_idx on public.memberships (server_seq);

create trigger set_server_seq
before insert or update on public.organizations
for each row execute function private.set_server_seq();

create trigger set_server_seq
before insert or update on public.memberships
for each row execute function private.set_server_seq();

-- İşletmeyi oluşturan kullanıcı o işletmenin owner'ı olur. Kimliği sunucu
-- ürettiği için bu satırın id'si UUIDv4'tür.
create function private.add_owner_membership()
returns trigger
language plpgsql
security definer
set search_path = ''
as $$
begin
  if new.created_by is not null then
    insert into public.memberships (id, org_id, user_id, role, created_by)
    values (gen_random_uuid(), new.id, new.created_by, 'owner', new.created_by);
  end if;
  return null;
end;
$$;

create trigger add_owner_membership
after insert on public.organizations
for each row execute function private.add_owner_membership();

-- ---------------------------------------------------------------------------
-- RLS yardımcıları
-- ---------------------------------------------------------------------------

-- Güvenlik tanımlı: memberships politikası bu fonksiyonları çağırdığında
-- RLS kendini yeniden tetiklemez. Çıkarılmış (deleted_at dolu) üyelik sayılmaz.
create function private.is_member(org_id uuid)
returns boolean
language sql
stable
security definer
set search_path = ''
as $$
  select exists (
    select 1
    from public.memberships m
    where m.org_id = is_member.org_id
      and m.user_id = (select auth.uid())
      and m.deleted_at is null
  );
$$;

create function private.has_role(org_id uuid, roles public.membership_role[])
returns boolean
language sql
stable
security definer
set search_path = ''
as $$
  select exists (
    select 1
    from public.memberships m
    where m.org_id = has_role.org_id
      and m.user_id = (select auth.uid())
      and m.deleted_at is null
      and m.role = any (has_role.roles)
  );
$$;

revoke all on all functions in schema private from public;
grant execute on function private.is_member(uuid) to authenticated;
grant execute on function private.has_role(uuid, public.membership_role[]) to authenticated;

-- ---------------------------------------------------------------------------
-- RLS
-- ---------------------------------------------------------------------------
-- Silme politikası yok: silme deleted_at ile yapılan bir güncellemedir.

alter table public.organizations enable row level security;
alter table public.memberships enable row level security;

create policy "Üyeler işletmeyi görür"
on public.organizations for select
to authenticated
using (private.is_member(id));

-- Owner üyeliği add_owner_membership trigger'ı satır eklendikten sonra
-- yazdığı için aynı ifadede RETURNING ya da upsert seçme politikasına takılır.
create policy "Kullanıcı kendi adına işletme oluşturur"
on public.organizations for insert
to authenticated
with check (created_by = (select auth.uid()));

create policy "Owner işletmeyi günceller"
on public.organizations for update
to authenticated
using (private.has_role(id, '{owner}'))
with check (private.has_role(id, '{owner}'));

-- Kullanıcı çıkarıldığı üyeliği de görür; cihazı böylece işletmeden
-- çıkarıldığını öğrenir.
create policy "Üyeler işletmenin üyeliklerini görür"
on public.memberships for select
to authenticated
using (user_id = (select auth.uid()) or private.is_member(org_id));

create policy "Owner üye ekler"
on public.memberships for insert
to authenticated
with check (private.has_role(org_id, '{owner}'));

create policy "Owner üyelikleri günceller"
on public.memberships for update
to authenticated
using (private.has_role(org_id, '{owner}'))
with check (private.has_role(org_id, '{owner}'));
