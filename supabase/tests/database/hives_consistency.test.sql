-- Kovan tablolarında veri tutarlılığı: bağlanan kayıtlar aynı işletmede olur,
-- etiket kodu işletmede tekildir, konum PostGIS noktasıdır.
begin;
create extension if not exists pgtap with schema extensions;
select plan(18);

-- 1111 A'nın owner'ı ve B'de worker: RLS iki işletmede de yazmasına izin
-- verir, işletmeler arası bağı yalnız kısıtlar durdurur. 9999 B'nin owner'ı.
insert into auth.users (id, email) values
  ('11111111-1111-1111-1111-111111111111', 'owner@test.local'),
  ('99999999-9999-9999-9999-999999999999', 'other@test.local');

insert into public.organizations (id, name, country_code, currency, created_by) values
  ('aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaaa', 'Petek Arıcılık', 'TR', 'TRY',
   '11111111-1111-1111-1111-111111111111'),
  ('eeeeeeee-eeee-eeee-eeee-eeeeeeeeeeee', 'Başka İşletme', 'TR', 'TRY',
   '99999999-9999-9999-9999-999999999999');

insert into public.memberships (id, org_id, user_id, role)
values (
  'c0000000-0000-0000-0000-000000000001', 'eeeeeeee-eeee-eeee-eeee-eeeeeeeeeeee',
  '11111111-1111-1111-1111-111111111111', 'worker'
);

-- Önek a1/e1 arılık, a2/e2 ana, a3 kovan, a4 geçmiş.
insert into public.apiaries (id, org_id, name, location) values
  ('a1000000-0000-0000-0000-000000000001', 'aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaaa',
   'Yayla', 'POINT(40.52 40.98)'),
  ('e1000000-0000-0000-0000-000000000001', 'eeeeeeee-eeee-eeee-eeee-eeeeeeeeeeee',
   'Ova', null);

insert into public.queens (id, org_id) values
  ('a2000000-0000-0000-0000-000000000001', 'aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaaa'),
  ('e2000000-0000-0000-0000-000000000001', 'eeeeeeee-eeee-eeee-eeee-eeeeeeeeeeee');

insert into public.hives (id, org_id, number, tag_code, type, apiary_id) values
  ('a3000000-0000-0000-0000-000000000001', 'aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaaa',
   '101', 'TAG-1', 'langstroth', 'a1000000-0000-0000-0000-000000000001');

insert into public.hive_location_history (id, org_id, hive_id, apiary_id, moved_at) values
  ('a4000000-0000-0000-0000-000000000001', 'aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaaa',
   'a3000000-0000-0000-0000-000000000001', 'a1000000-0000-0000-0000-000000000001',
   '2026-04-01 08:00+03');

set local role authenticated;
set local request.jwt.claims = '{"sub": "11111111-1111-1111-1111-111111111111"}';

-- Kovan → arılık ve ana

select lives_ok(
  $$insert into public.hives (id, org_id, number, type, apiary_id, queen_id)
    values ('a3000000-0000-0000-0000-000000000002', 'aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaaa',
            '102', 'langstroth', 'a1000000-0000-0000-0000-000000000001',
            'a2000000-0000-0000-0000-000000000001')$$,
  'kovan kendi işletmesinin arılığına ve anasına bağlanır'
);

select throws_ok(
  $$insert into public.hives (id, org_id, number, type, apiary_id)
    values ('a3000000-0000-0000-0000-000000000003', 'aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaaa',
            '103', 'langstroth', 'e1000000-0000-0000-0000-000000000001')$$,
  '23503',
  null,
  'kovan başka işletmenin arılığına bağlanamaz'
);

select throws_ok(
  $$insert into public.hives (id, org_id, number, type, apiary_id, queen_id)
    values ('a3000000-0000-0000-0000-000000000003', 'aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaaa',
            '103', 'langstroth', 'a1000000-0000-0000-0000-000000000001',
            'e2000000-0000-0000-0000-000000000001')$$,
  '23503',
  null,
  'kovana başka işletmenin anası verilemez'
);

select throws_ok(
  $$update public.hives set apiary_id = 'e1000000-0000-0000-0000-000000000001'
    where id = 'a3000000-0000-0000-0000-000000000001'$$,
  '23503',
  null,
  'kovan başka işletmenin arılığına taşınamaz'
);

select throws_ok(
  $$update public.hives set queen_id = 'e2000000-0000-0000-0000-000000000001'
    where id = 'a3000000-0000-0000-0000-000000000001'$$,
  '23503',
  null,
  'kovanın anası başka işletmenin anasıyla değiştirilemez'
);

select throws_ok(
  $$update public.hives set org_id = 'eeeeeeee-eeee-eeee-eeee-eeeeeeeeeeee'
    where id = 'a3000000-0000-0000-0000-000000000001'$$,
  '23503',
  null,
  'kovan, arılığı A''da kalırken B işletmesine geçirilemez'
);

select throws_ok(
  $$update public.apiaries set org_id = 'eeeeeeee-eeee-eeee-eeee-eeeeeeeeeeee'
    where id = 'a1000000-0000-0000-0000-000000000001'$$,
  '23503',
  null,
  'kovanı olan arılık başka işletmeye geçirilemez'
);

-- Ana → anne ana

select throws_ok(
  $$insert into public.queens (id, org_id, mother_queen_id)
    values ('a2000000-0000-0000-0000-000000000002', 'aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaaa',
            'e2000000-0000-0000-0000-000000000001')$$,
  '23503',
  null,
  'ananın annesi başka işletmeden olamaz'
);

select throws_ok(
  $$update public.queens set mother_queen_id = id
    where id = 'a2000000-0000-0000-0000-000000000001'$$,
  '23514',
  null,
  'ana kendi annesi olamaz'
);

-- Geçmiş → kovan ve arılık

select throws_ok(
  $$insert into public.hive_location_history (id, org_id, hive_id, apiary_id, moved_at)
    values ('a4000000-0000-0000-0000-000000000002', 'aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaaa',
            'a3000000-0000-0000-0000-000000000001', 'e1000000-0000-0000-0000-000000000001',
            now())$$,
  '23503',
  null,
  'geçmiş kaydı başka işletmenin arılığını gösteremez'
);

select throws_ok(
  $$insert into public.hive_location_history (id, org_id, hive_id, apiary_id, moved_at)
    values ('a4000000-0000-0000-0000-000000000002', 'eeeeeeee-eeee-eeee-eeee-eeeeeeeeeeee',
            'a3000000-0000-0000-0000-000000000001', 'e1000000-0000-0000-0000-000000000001',
            now())$$,
  '23503',
  null,
  'geçmiş kaydı başka işletmenin kovanını gösteremez'
);

-- Etiket kodu

select throws_ok(
  $$insert into public.hives (id, org_id, number, tag_code, type, apiary_id)
    values ('a3000000-0000-0000-0000-000000000003', 'aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaaa',
            '103', 'TAG-1', 'langstroth', 'a1000000-0000-0000-0000-000000000001')$$,
  '23505',
  null,
  'aynı etiket kodu işletmede iki kovanda olamaz'
);

select lives_ok(
  $$insert into public.hives (id, org_id, number, tag_code, type, apiary_id)
    values ('e3000000-0000-0000-0000-000000000001', 'eeeeeeee-eeee-eeee-eeee-eeeeeeeeeeee',
            '101', 'TAG-1', 'langstroth', 'e1000000-0000-0000-0000-000000000001')$$,
  'başka işletme aynı etiket kodunu kullanabilir'
);

update public.hives set deleted_at = now()
where id = 'a3000000-0000-0000-0000-000000000001';

select lives_ok(
  $$insert into public.hives (id, org_id, number, tag_code, type, apiary_id)
    values ('a3000000-0000-0000-0000-000000000003', 'aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaaa',
            '103', 'TAG-1', 'langstroth', 'a1000000-0000-0000-0000-000000000001')$$,
  'silinen kovanın etiket kodu yeni kovanda kullanılabilir'
);

-- Konum

select results_eq(
  $$select extensions.st_astext(location) from public.apiaries
    where id = 'a1000000-0000-0000-0000-000000000001'$$,
  $$values ('POINT(40.52 40.98)')$$,
  'arılık konumu PostGIS noktası olarak saklanır'
);

select throws_ok(
  $$insert into public.apiaries (id, org_id, name, location)
    values ('a1000000-0000-0000-0000-000000000002', 'aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaaa',
            'Alan', 'POLYGON((40 40, 41 40, 41 41, 40 40))')$$,
  '22023',
  null,
  'arılık konumu nokta dışında bir geometri olamaz'
);

-- Yalnız B üyesi

set local request.jwt.claims = '{"sub": "99999999-9999-9999-9999-999999999999"}';

select throws_ok(
  $$insert into public.hives (id, org_id, number, type, apiary_id)
    values ('e3000000-0000-0000-0000-000000000002', 'eeeeeeee-eeee-eeee-eeee-eeeeeeeeeeee',
            '102', 'langstroth', 'a1000000-0000-0000-0000-000000000001')$$,
  '23503',
  null,
  'A''nın arılık id''sini bilen B üyesi kovanını ona bağlayamaz'
);

select throws_ok(
  $$insert into public.hives (id, org_id, number, type, apiary_id, queen_id)
    values ('e3000000-0000-0000-0000-000000000002', 'eeeeeeee-eeee-eeee-eeee-eeeeeeeeeeee',
            '102', 'langstroth', 'e1000000-0000-0000-0000-000000000001',
            'a2000000-0000-0000-0000-000000000001')$$,
  '23503',
  null,
  'A''nın ana id''sini bilen B üyesi onu kovanına veremez'
);

select * from finish();
rollback;
