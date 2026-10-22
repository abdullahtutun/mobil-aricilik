-- memberships RLS: üyeler görür, yalnız owner ekler ve değiştirir.
begin;
create extension if not exists pgtap with schema extensions;
select plan(10);

-- Kullanıcılar: 1111 owner, 3333 worker, 4444 yeni üye, 9999 üye değil.
insert into auth.users (id, email) values
  ('11111111-1111-1111-1111-111111111111', 'owner@test.local'),
  ('33333333-3333-3333-3333-333333333333', 'worker@test.local'),
  ('44444444-4444-4444-4444-444444444444', 'new@test.local'),
  ('99999999-9999-9999-9999-999999999999', 'outsider@test.local');

-- aaaa: 1111'in işletmesi. eeee: 9999'un işletmesi.
insert into public.organizations (id, name, country_code, currency, created_by) values
  ('aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaaa', 'Petek Arıcılık', 'TR', 'TRY',
   '11111111-1111-1111-1111-111111111111'),
  ('eeeeeeee-eeee-eeee-eeee-eeeeeeeeeeee', 'Başka İşletme', 'TR', 'TRY',
   '99999999-9999-9999-9999-999999999999');

insert into public.memberships (id, org_id, user_id, role) values
  ('c0000000-0000-0000-0000-000000000001', 'aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaaa',
   '11111111-1111-1111-1111-111111111111', 'owner'),
  ('c0000000-0000-0000-0000-000000000003', 'aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaaa',
   '33333333-3333-3333-3333-333333333333', 'worker'),
  ('c0000000-0000-0000-0000-000000000009', 'eeeeeeee-eeee-eeee-eeee-eeeeeeeeeeee',
   '99999999-9999-9999-9999-999999999999', 'owner');

set local role authenticated;

-- Üye olmayan
set local request.jwt.claims = '{"sub": "99999999-9999-9999-9999-999999999999"}';

select is_empty(
  $$select id from public.memberships
    where org_id = 'aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaaa'$$,
  'üye olmayan işletmenin üyeliklerini göremez'
);

-- Worker
set local request.jwt.claims = '{"sub": "33333333-3333-3333-3333-333333333333"}';

select results_eq(
  'select user_id, role from public.memberships order by user_id',
  $$values
    ('11111111-1111-1111-1111-111111111111'::uuid, 'owner'::public.membership_role),
    ('33333333-3333-3333-3333-333333333333'::uuid, 'worker'::public.membership_role)$$,
  'worker işletmedeki tüm üyelikleri görür'
);

select throws_ok(
  $$insert into public.memberships (id, org_id, user_id, role)
    values ('c0000000-0000-0000-0000-000000000004', 'aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaaa',
            '44444444-4444-4444-4444-444444444444', 'viewer')$$,
  '42501',
  null,
  'worker üye ekleyemez'
);

select is_empty(
  $$update public.memberships set role = 'owner' where user_id = auth.uid() returning id$$,
  'worker kendi rolünü yükseltemez'
);

-- Owner
set local request.jwt.claims = '{"sub": "11111111-1111-1111-1111-111111111111"}';

select lives_ok(
  $$insert into public.memberships (id, org_id, user_id, role)
    values ('c0000000-0000-0000-0000-000000000004', 'aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaaa',
            '44444444-4444-4444-4444-444444444444', 'viewer')$$,
  'owner üye ekler'
);

select throws_ok(
  $$insert into public.memberships (id, org_id, user_id, role)
    values ('c0000000-0000-0000-0000-000000000005', 'eeeeeeee-eeee-eeee-eeee-eeeeeeeeeeee',
            '11111111-1111-1111-1111-111111111111', 'owner')$$,
  '42501',
  null,
  'owner başka işletmeye üye ekleyemez'
);

select results_eq(
  $$update public.memberships set deleted_at = now()
    where user_id = '33333333-3333-3333-3333-333333333333'
    returning user_id$$,
  $$values ('33333333-3333-3333-3333-333333333333'::uuid)$$,
  'owner üyeyi deleted_at ile çıkarır'
);

select is_empty(
  'delete from public.memberships returning id',
  'üyelik satırı silinemez'
);

-- Çıkarılan worker
set local request.jwt.claims = '{"sub": "33333333-3333-3333-3333-333333333333"}';

select is_empty(
  'select id from public.organizations',
  'çıkarılan üye işletmeyi göremez'
);

select results_eq(
  'select user_id, deleted_at is not null from public.memberships',
  $$values ('33333333-3333-3333-3333-333333333333'::uuid, true)$$,
  'çıkarılan üye yalnız kendi silinmiş üyeliğini görür'
);

select * from finish();
rollback;
