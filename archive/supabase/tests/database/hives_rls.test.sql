-- apiaries, queens, hives, hive_location_history RLS: başka işletmenin
-- kaydı görünmez; worker yazar, viewer yalnız okur.
begin;
create extension if not exists pgtap with schema extensions;
select plan(21);

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

-- Her işletmede birer arılık, ana, kovan ve geçmiş kaydı.
-- Önek a1/e1 arılık, a2/e2 ana, a3/e3 kovan, a4/e4 geçmiş.
insert into public.apiaries (id, org_id, name, location) values
  ('a1000000-0000-0000-0000-000000000001', 'aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaaa',
   'Yayla', 'POINT(40.52 40.98)'),
  ('e1000000-0000-0000-0000-000000000001', 'eeeeeeee-eeee-eeee-eeee-eeeeeeeeeeee',
   'Ova', 'POINT(27.14 38.42)');

insert into public.queens (id, org_id, year, mark_color) values
  ('a2000000-0000-0000-0000-000000000001', 'aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaaa',
   2026, 'white'),
  ('e2000000-0000-0000-0000-000000000001', 'eeeeeeee-eeee-eeee-eeee-eeeeeeeeeeee',
   2025, 'blue');

insert into public.hives (id, org_id, number, type, apiary_id, queen_id) values
  ('a3000000-0000-0000-0000-000000000001', 'aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaaa',
   '101', 'langstroth', 'a1000000-0000-0000-0000-000000000001',
   'a2000000-0000-0000-0000-000000000001'),
  ('e3000000-0000-0000-0000-000000000001', 'eeeeeeee-eeee-eeee-eeee-eeeeeeeeeeee',
   '101', 'dadant', 'e1000000-0000-0000-0000-000000000001',
   'e2000000-0000-0000-0000-000000000001');

insert into public.hive_location_history (id, org_id, hive_id, apiary_id, moved_at) values
  ('a4000000-0000-0000-0000-000000000001', 'aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaaa',
   'a3000000-0000-0000-0000-000000000001', 'a1000000-0000-0000-0000-000000000001',
   '2026-04-01 08:00+03'),
  ('e4000000-0000-0000-0000-000000000001', 'eeeeeeee-eeee-eeee-eeee-eeeeeeeeeeee',
   'e3000000-0000-0000-0000-000000000001', 'e1000000-0000-0000-0000-000000000001',
   '2026-04-01 08:00+03');

set local role authenticated;

-- B'nin owner'ı
set local request.jwt.claims = '{"sub": "99999999-9999-9999-9999-999999999999"}';

select results_eq(
  'select id from public.hives',
  $$values ('e3000000-0000-0000-0000-000000000001'::uuid)$$,
  'başka işletmenin kovanını göremez, yalnız kendi kovanını görür'
);

select is_empty(
  $$select id from public.apiaries
    where org_id = 'aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaaa'$$,
  'başka işletmenin arılığını göremez'
);

select is_empty(
  $$select id from public.queens
    where org_id = 'aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaaa'$$,
  'başka işletmenin anasını göremez'
);

select is_empty(
  $$select id from public.hive_location_history
    where org_id = 'aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaaa'$$,
  'başka işletmenin kovan geçmişini göremez'
);

select is_empty(
  $$update public.hives set number = '999'
    where id = 'a3000000-0000-0000-0000-000000000001'
    returning id$$,
  'başka işletmenin kovanını güncelleyemez'
);

select throws_ok(
  $$insert into public.hives (id, org_id, number, type, apiary_id)
    values ('e3000000-0000-0000-0000-000000000002', 'aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaaa',
            '102', 'langstroth', 'a1000000-0000-0000-0000-000000000001')$$,
  '42501',
  null,
  'başka işletmeye kovan ekleyemez'
);

-- A'nın worker'ı
set local request.jwt.claims = '{"sub": "33333333-3333-3333-3333-333333333333"}';

select results_eq(
  'select id from public.hives',
  $$values ('a3000000-0000-0000-0000-000000000001'::uuid)$$,
  'worker yalnız kendi işletmesinin kovanını görür'
);

select lives_ok(
  $$insert into public.hives (id, org_id, number, type, apiary_id)
    values ('a3000000-0000-0000-0000-000000000002', 'aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaaa',
            '102', 'langstroth', 'a1000000-0000-0000-0000-000000000001')$$,
  'worker kovan ekler'
);

select results_eq(
  $$update public.hives set status = 'dead'
    where id = 'a3000000-0000-0000-0000-000000000002'
    returning status$$,
  $$values ('dead'::public.hive_status)$$,
  'worker kovanı günceller'
);

-- A'nın viewer'ı
set local request.jwt.claims = '{"sub": "55555555-5555-5555-5555-555555555555"}';

select results_eq(
  'select id from public.hives order by id',
  $$values ('a3000000-0000-0000-0000-000000000001'::uuid),
           ('a3000000-0000-0000-0000-000000000002'::uuid)$$,
  'viewer işletmesinin kovanlarını görür'
);

select throws_ok(
  $$insert into public.apiaries (id, org_id, name)
    values ('a1000000-0000-0000-0000-000000000005', 'aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaaa',
            'Viewer arılığı')$$,
  '42501',
  null,
  'viewer arılık ekleyemez'
);

select throws_ok(
  $$insert into public.queens (id, org_id)
    values ('a2000000-0000-0000-0000-000000000005', 'aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaaa')$$,
  '42501',
  null,
  'viewer ana arı ekleyemez'
);

select throws_ok(
  $$insert into public.hives (id, org_id, number, type, apiary_id)
    values ('a3000000-0000-0000-0000-000000000005', 'aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaaa',
            '105', 'langstroth', 'a1000000-0000-0000-0000-000000000001')$$,
  '42501',
  null,
  'viewer kovan ekleyemez'
);

select throws_ok(
  $$insert into public.hive_location_history (id, org_id, hive_id, apiary_id, moved_at)
    values ('a4000000-0000-0000-0000-000000000005', 'aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaaa',
            'a3000000-0000-0000-0000-000000000001', 'a1000000-0000-0000-0000-000000000001',
            now())$$,
  '42501',
  null,
  'viewer kovan geçmişi ekleyemez'
);

select is_empty(
  $$update public.apiaries set name = 'Viewer adı' returning id$$,
  'viewer arılığı güncelleyemez'
);

select is_empty(
  $$update public.queens set mark_color = 'red' returning id$$,
  'viewer anayı güncelleyemez'
);

select is_empty(
  $$update public.hives set deleted_at = now() returning id$$,
  'viewer kovanı güncelleyemez ve silinmiş olarak işaretleyemez'
);

select is_empty(
  $$update public.hive_location_history set moved_at = now() returning id$$,
  'viewer kovan geçmişini güncelleyemez'
);

-- A'nın owner'ı
set local request.jwt.claims = '{"sub": "11111111-1111-1111-1111-111111111111"}';

select is_empty(
  'delete from public.hives returning id',
  'owner da kovan satırını silemez; silme deleted_at ile yapılır'
);

select results_eq(
  'select id from public.hives where deleted_at is null order by id',
  $$values ('a3000000-0000-0000-0000-000000000001'::uuid),
           ('a3000000-0000-0000-0000-000000000002'::uuid)$$,
  'viewer''ın güncelleme ve silme denemeleri kovanlara dokunmadı'
);

-- Giriş yapmamış
set local role anon;

select is_empty(
  'select id from public.hives',
  'anon hiçbir kovanı göremez'
);

select * from finish();
rollback;
