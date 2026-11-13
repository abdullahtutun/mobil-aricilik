-- inspections RLS ve tutarlılık: başka işletmenin muayenesi görünmez;
-- worker yazar, viewer yalnız okur; işletmeler arası bağ ve bozuk değer
-- reddedilir.
begin;
create extension if not exists pgtap with schema extensions;
select plan(14);

-- Kullanıcılar: 1111 A'nın owner'ı, 3333 A'da worker, 5555 A'da viewer,
-- 9999 B'nin owner'ı.
insert into auth.users (id, email) values
  ('11111111-1111-1111-1111-111111111111', 'owner@test.local'),
  ('33333333-3333-3333-3333-333333333333', 'worker@test.local'),
  ('55555555-5555-5555-5555-555555555555', 'viewer@test.local'),
  ('99999999-9999-9999-9999-999999999999', 'other@test.local');

-- aaaa: A işletmesi. eeee: B işletmesi.
insert into public.organizations (id, name, country_code, currency, created_by) values
  ('aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaaa', 'Petek Arıcılık', 'TR', 'TRY',
   '11111111-1111-1111-1111-111111111111'),
  ('eeeeeeee-eeee-eeee-eeee-eeeeeeeeeeee', 'Başka İşletme', 'TR', 'TRY',
   '99999999-9999-9999-9999-999999999999');

insert into public.memberships (id, org_id, user_id, role) values
  ('c0000000-0000-0000-0000-000000000001', 'aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaaa',
   '11111111-1111-1111-1111-111111111111', 'owner'),
  ('c0000000-0000-0000-0000-000000000009', 'eeeeeeee-eeee-eeee-eeee-eeeeeeeeeeee',
   '99999999-9999-9999-9999-999999999999', 'owner'),
  ('c0000000-0000-0000-0000-000000000003', 'aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaaa',
   '33333333-3333-3333-3333-333333333333', 'worker'),
  ('c0000000-0000-0000-0000-000000000005', 'aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaaa',
   '55555555-5555-5555-5555-555555555555', 'viewer');

-- Her işletmede birer arılık, kovan ve muayene.
-- Önek a1/e1 arılık, a3/e3 kovan, a5/e5 muayene.
insert into public.apiaries (id, org_id, name) values
  ('a1000000-0000-0000-0000-000000000001', 'aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaaa', 'Yayla'),
  ('e1000000-0000-0000-0000-000000000001', 'eeeeeeee-eeee-eeee-eeee-eeeeeeeeeeee', 'Ova');

insert into public.hives (id, org_id, number, type, apiary_id) values
  ('a3000000-0000-0000-0000-000000000001', 'aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaaa',
   '101', 'langstroth', 'a1000000-0000-0000-0000-000000000001'),
  ('e3000000-0000-0000-0000-000000000001', 'eeeeeeee-eeee-eeee-eeee-eeeeeeeeeeee',
   '101', 'dadant', 'e1000000-0000-0000-0000-000000000001');

insert into public.inspections (id, org_id, hive_id, apiary_id, inspected_at, queen_state, bee_frames) values
  ('a5000000-0000-0000-0000-000000000001', 'aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaaa',
   'a3000000-0000-0000-0000-000000000001', 'a1000000-0000-0000-0000-000000000001',
   '2026-10-20 10:00+03', 'seen', 8),
  ('e5000000-0000-0000-0000-000000000001', 'eeeeeeee-eeee-eeee-eeee-eeeeeeeeeeee',
   'e3000000-0000-0000-0000-000000000001', 'e1000000-0000-0000-0000-000000000001',
   '2026-10-20 10:00+03', 'eggs', 6);

set local role authenticated;

-- B'nin owner'ı
set local request.jwt.claims = '{"sub": "99999999-9999-9999-9999-999999999999"}';

select results_eq(
  'select id from public.inspections',
  $$values ('e5000000-0000-0000-0000-000000000001'::uuid)$$,
  'başka işletmenin muayenesini göremez, yalnız kendi muayenesini görür'
);

select is_empty(
  $$update public.inspections set bee_frames = 1
    where id = 'a5000000-0000-0000-0000-000000000001'
    returning id$$,
  'başka işletmenin muayenesini güncelleyemez'
);

select throws_ok(
  $$insert into public.inspections (id, org_id, hive_id, apiary_id, inspected_at)
    values ('e5000000-0000-0000-0000-000000000002', 'aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaaa',
            'a3000000-0000-0000-0000-000000000001', 'a1000000-0000-0000-0000-000000000001',
            now())$$,
  '42501',
  null,
  'başka işletmeye muayene ekleyemez'
);

select throws_ok(
  $$insert into public.inspections (id, org_id, hive_id, apiary_id, inspected_at)
    values ('e5000000-0000-0000-0000-000000000003', 'eeeeeeee-eeee-eeee-eeee-eeeeeeeeeeee',
            'a3000000-0000-0000-0000-000000000001', 'e1000000-0000-0000-0000-000000000001',
            now())$$,
  '23503',
  null,
  'kendi muayenesini başka işletmenin kovanına bağlayamaz'
);

select throws_ok(
  $$insert into public.inspections (id, org_id, hive_id, apiary_id, inspected_at)
    values ('e5000000-0000-0000-0000-000000000004', 'eeeeeeee-eeee-eeee-eeee-eeeeeeeeeeee',
            'e3000000-0000-0000-0000-000000000001', 'a1000000-0000-0000-0000-000000000001',
            now())$$,
  '23503',
  null,
  'kendi muayenesini başka işletmenin arılığına bağlayamaz'
);

-- A'nın worker'ı
set local request.jwt.claims = '{"sub": "33333333-3333-3333-3333-333333333333"}';

select lives_ok(
  $$insert into public.inspections (
      id, org_id, hive_id, apiary_id, inspected_at, queen_state, bee_frames,
      brood_frames, honey_frames, temperament, swarm_signs, queen_cells,
      disease_suspected, data)
    values ('a5000000-0000-0000-0000-000000000002', 'aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaaa',
            'a3000000-0000-0000-0000-000000000001', 'a1000000-0000-0000-0000-000000000001',
            now(), 'none', 7, 4, 2, 'nervous', true, 'emergency', false,
            '{"actions": ["super_added", "fed"]}')$$,
  'worker bütün alanlarıyla muayene ekler'
);

select results_eq(
  $$select bee_frames, data -> 'actions' ->> 1 from public.inspections
    where id = 'a5000000-0000-0000-0000-000000000002'$$,
  $$values (7::smallint, 'fed')$$,
  'çerçeve sayısı ve data içindeki işlemler yazılır'
);

select lives_ok(
  $$insert into public.inspections (id, org_id, hive_id, apiary_id, inspected_at)
    values ('a5000000-0000-0000-0000-000000000003', 'aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaaa',
            'a3000000-0000-0000-0000-000000000001', 'a1000000-0000-0000-0000-000000000001',
            now())$$,
  'hiçbir alanı dolu olmayan muayene (yalnız ziyaret) eklenir'
);

select throws_ok(
  $$insert into public.inspections (id, org_id, hive_id, apiary_id, inspected_at, brood_frames)
    values ('a5000000-0000-0000-0000-000000000004', 'aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaaa',
            'a3000000-0000-0000-0000-000000000001', 'a1000000-0000-0000-0000-000000000001',
            now(), -1)$$,
  '23514',
  null,
  'negatif çerçeve sayısı reddedilir'
);

select throws_ok(
  $$insert into public.inspections (id, org_id, hive_id, apiary_id, inspected_at, data)
    values ('a5000000-0000-0000-0000-000000000005', 'aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaaa',
            'a3000000-0000-0000-0000-000000000001', 'a1000000-0000-0000-0000-000000000001',
            now(), '["fed"]')$$,
  '23514',
  null,
  'data nesne olmalı'
);

select throws_ok(
  $$insert into public.inspections (id, org_id, hive_id, apiary_id, inspected_at, queen_state)
    values ('a5000000-0000-0000-0000-000000000006', 'aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaaa',
            'a3000000-0000-0000-0000-000000000001', 'a1000000-0000-0000-0000-000000000001',
            now(), 'maybe')$$,
  '22P02',
  null,
  'tanınmayan ana arı durumu reddedilir'
);

-- A'nın viewer'ı
set local request.jwt.claims = '{"sub": "55555555-5555-5555-5555-555555555555"}';

select results_eq(
  'select count(*) from public.inspections',
  $$values (3::bigint)$$,
  'viewer işletmesinin muayenelerini görür'
);

select throws_ok(
  $$insert into public.inspections (id, org_id, hive_id, apiary_id, inspected_at)
    values ('a5000000-0000-0000-0000-000000000007', 'aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaaa',
            'a3000000-0000-0000-0000-000000000001', 'a1000000-0000-0000-0000-000000000001',
            now())$$,
  '42501',
  null,
  'viewer muayene ekleyemez'
);

select is_empty(
  $$update public.inspections set deleted_at = now() returning id$$,
  'viewer muayeneyi güncelleyemez ve silinmiş olarak işaretleyemez'
);

select * from finish();
rollback;
