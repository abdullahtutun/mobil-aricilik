-- organizations RLS: üye olmayan göremez, owner dışında kimse güncelleyemez.
begin;
create extension if not exists pgtap with schema extensions;
select plan(9);

-- Kullanıcılar: 1111 owner, 2222 partner, 3333 worker, 9999 üye değil.
insert into auth.users (id, email) values
  ('11111111-1111-1111-1111-111111111111', 'owner@test.local'),
  ('22222222-2222-2222-2222-222222222222', 'partner@test.local'),
  ('33333333-3333-3333-3333-333333333333', 'worker@test.local'),
  ('99999999-9999-9999-9999-999999999999', 'outsider@test.local');

insert into public.organizations (id, name, country_code, currency, created_by)
values (
  'aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaaa', 'Petek Arıcılık', 'TR', 'TRY',
  '11111111-1111-1111-1111-111111111111'
);

insert into public.memberships (id, org_id, user_id, role) values
  ('c0000000-0000-0000-0000-000000000001', 'aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaaa',
   '11111111-1111-1111-1111-111111111111', 'owner'),
  ('c0000000-0000-0000-0000-000000000002', 'aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaaa',
   '22222222-2222-2222-2222-222222222222', 'partner'),
  ('c0000000-0000-0000-0000-000000000003', 'aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaaa',
   '33333333-3333-3333-3333-333333333333', 'worker');

set local role authenticated;

-- Üye olmayan
set local request.jwt.claims = '{"sub": "99999999-9999-9999-9999-999999999999"}';

select is_empty(
  'select id from public.organizations',
  'üye olmayan işletmeyi göremez'
);

select is_empty(
  $$update public.organizations set name = 'Ele geçirildi' returning id$$,
  'üye olmayan işletmeyi güncelleyemez'
);

-- Worker
set local request.jwt.claims = '{"sub": "33333333-3333-3333-3333-333333333333"}';

select results_eq(
  'select id from public.organizations',
  $$values ('aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaaa'::uuid)$$,
  'worker üyesi olduğu işletmeyi görür'
);

select is_empty(
  $$update public.organizations set name = 'Worker adı' returning id$$,
  'worker işletmeyi güncelleyemez'
);

select throws_ok(
  $$insert into public.organizations (id, name, country_code, currency, created_by)
    values ('bbbbbbbb-bbbb-bbbb-bbbb-bbbbbbbbbbbb', 'Sahte', 'TR', 'TRY',
            '33333333-3333-3333-3333-333333333333')$$,
  '42501',
  null,
  'işletme doğrudan eklenemez, yalnız create_organization ile'
);

-- Partner
set local request.jwt.claims = '{"sub": "22222222-2222-2222-2222-222222222222"}';

select is_empty(
  $$update public.organizations set name = 'Partner adı' returning id$$,
  'partner işletmeyi güncelleyemez'
);

-- Owner
set local request.jwt.claims = '{"sub": "11111111-1111-1111-1111-111111111111"}';

select results_eq(
  $$update public.organizations set name = 'Petek Arıcılık Ltd.', tr_aks_no = 'AKS-1'
    returning name, tr_aks_no$$,
  $$values ('Petek Arıcılık Ltd.', 'AKS-1')$$,
  'owner işletmeyi günceller'
);

select is_empty(
  'delete from public.organizations returning id',
  'owner da satırı silemez; silme deleted_at ile yapılır'
);

-- Giriş yapmamış
set local role anon;

select is_empty(
  'select id from public.organizations',
  'anon hiçbir işletmeyi göremez'
);

select * from finish();
rollback;
