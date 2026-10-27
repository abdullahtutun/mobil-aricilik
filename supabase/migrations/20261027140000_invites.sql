-- Ekip daveti (ozellikler: Ekip). Owner ya da partner 6 haneli, 48 saat
-- geçerli bir kod üretir; kodu giren kullanıcı `invite` Edge Function'ı ile
-- işletmeye kodun rolüyle katılır (memberships'e satır eklenir).
--
-- invites senkronlanmaz (server_seq yok): yalnız Edge Function ve davet
-- üretenin kendisi kullanır. Kod harf ve rakamdan oluşur; 0/O ve 1/I/L gibi
-- karışanlar yok. Katılım (kodu kullanma) service role ile yapılır, bu
-- yüzden kullanıcı için güncelleme ve silme politikası yok.

create table public.invites (
  id uuid primary key default gen_random_uuid(),
  org_id uuid not null references public.organizations (id) on delete cascade,
  code text not null check (code ~ '^[ABCDEFGHJKMNPQRSTUVWXYZ23456789]{6}$'),
  -- Owner davetle verilmez; ilk owner işletmeyi kuran kullanıcıdır.
  role public.membership_role not null check (role <> 'owner'),
  created_at timestamptz not null default now(),
  created_by uuid not null default auth.uid() references auth.users (id) on delete cascade,
  expires_at timestamptz not null default now() + interval '48 hours',
  used_at timestamptz,
  used_by uuid references auth.users (id) on delete set null,
  check ((used_at is null) = (used_by is null))
);

-- Kod tüm işletmelerde tekil: kodu giren işletmeyi söylemez, kod bulur.
create unique index invites_code_key on public.invites (code);
create index invites_org_id_idx on public.invites (org_id);
create index invites_created_by_idx on public.invites (created_by);
create index invites_used_by_idx on public.invites (used_by);

alter table public.invites enable row level security;

create policy "Owner ve partner işletmenin davetlerini görür"
on public.invites for select
to authenticated
using (private.has_role(org_id, '{owner,partner}'));

create policy "Owner ve partner davet üretir"
on public.invites for insert
to authenticated
with check (
  private.has_role(org_id, '{owner,partner}')
  and created_by = (select auth.uid())
  and used_at is null
  and used_by is null
);
