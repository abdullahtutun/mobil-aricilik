-- invites RLS: owner ve partner davet üretir ve görür; worker, viewer ve
-- başka işletmenin üyesi üretemez, göremez; kod biçimi ve rol kısıtı.
begin;
create extension if not exists pgtap with schema extensions;
select plan(11);

-- 1111 owner, 2222 partner, 3333 worker, 5555 viewer, 9999 başka işletme.
insert into auth.users (id, email) values
  ('11111111-1111-1111-1111-111111111111', 'owner@test.local'),
  ('22222222-2222-2222-2222-222222222222', 'partner@test.local'),
  ('33333333-3333-3333-3333-333333333333', 'worker@test.local'),
  ('55555555-5555-5555-5555-555555555555', 'viewer@test.local'),
  ('99999999-9999-9999-9999-999999999999', 'outsider@test.local');

insert into public.organizations (id, name, country_code, currency, created_by) values
  ('aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaaa', 'Petek Arıcılık', 'TR', 'TRY',
   '11111111-1111-1111-1111-111111111111'),
  ('eeeeeeee-eeee-eeee-eeee-eeeeeeeeeeee', 'Başka İşletme', 'TR', 'TRY',
   '99999999-9999-9999-9999-999999999999');

insert into public.memberships (id, org_id, user_id, role) values
  ('c0000000-0000-0000-0000-000000000001', 'aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaaa',
   '11111111-1111-1111-1111-111111111111', 'owner'),
  ('c0000000-0000-0000-0000-000000000002', 'aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaaa',
   '22222222-2222-2222-2222-222222222222', 'partner'),
  ('c0000000-0000-0000-0000-000000000003', 'aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaaa',
   '33333333-3333-3333-3333-333333333333', 'worker'),
  ('c0000000-0000-0000-0000-000000000005', 'aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaaa',
   '55555555-5555-5555-5555-555555555555', 'viewer');

set local role authenticated;

-- Owner
set local request.jwt.claims = '{"sub": "11111111-1111-1111-1111-111111111111"}';

select lives_ok(
  $$insert into public.invites (org_id, code, role)
    values ('aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaaa', 'AR7K2Q', 'worker')$$,
  'owner davet üretir'
);
select results_eq(
  $$select expires_at - created_at from public.invites where code = 'AR7K2Q'$$,
  $$values (interval '48 hours')$$,
  'davet 48 saat geçerli'
);
select throws_ok(
  $$insert into public.invites (org_id, code, role)
    values ('aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaaa', 'BCDEFG', 'owner')$$,
  '23514', null, 'owner rolüyle davet olmaz'
);
select throws_ok(
  $$insert into public.invites (org_id, code, role)
    values ('aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaaa', 'AR0K2Q', 'worker')$$,
  '23514', null, 'karışan karakterli kod reddedilir'
);
select throws_ok(
  $$insert into public.invites (org_id, code, role)
    values ('aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaaa', 'AR7K2Q', 'viewer')$$,
  '23505', null, 'aynı kod ikinci kez üretilemez'
);

-- Partner
set local request.jwt.claims = '{"sub": "22222222-2222-2222-2222-222222222222"}';

select lives_ok(
  $$insert into public.invites (org_id, code, role)
    values ('aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaaa', 'MN3PQ4', 'viewer')$$,
  'partner davet üretir'
);
select is(
  (select count(*)::int from public.invites), 2, 'partner işletmenin davetlerini görür'
);

-- Worker
set local request.jwt.claims = '{"sub": "33333333-3333-3333-3333-333333333333"}';

select throws_ok(
  $$insert into public.invites (org_id, code, role)
    values ('aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaaa', 'XY5Z67', 'worker')$$,
  '42501', null, 'worker davet üretemez'
);
select is_empty($$select id from public.invites$$, 'worker davetleri göremez');

-- Viewer
set local request.jwt.claims = '{"sub": "55555555-5555-5555-5555-555555555555"}';

select throws_ok(
  $$insert into public.invites (org_id, code, role)
    values ('aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaaa', 'XY5Z67', 'viewer')$$,
  '42501', null, 'viewer davet üretemez'
);

-- Başka işletmenin üyesi
set local request.jwt.claims = '{"sub": "99999999-9999-9999-9999-999999999999"}';

select throws_ok(
  $$insert into public.invites (org_id, code, role)
    values ('aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaaa', 'XY5Z67', 'worker')$$,
  '42501', null, 'başka işletmeye davet üretilemez'
);

select * from finish();
rollback;
