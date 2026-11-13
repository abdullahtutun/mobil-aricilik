-- migrations ve migration_stops RLS ve tutarlılık: başka işletmenin göç
-- planı ve durağı görünmez ve yazılamaz; worker yazar, viewer yalnız okur;
-- işletmeler arası bağ (plan, hedef arılık) reddedilir; bitiş başlangıçtan
-- önce olamaz; sync_push iki tabloyu şema sürümü 12 ile durum kaydı olarak
-- yazar.
begin;
create extension if not exists pgtap with schema extensions;

-- sync_push P10.1'de dondu (20261118120000_freeze_sync_push). Bu dosya
-- dondurmadan önceki davranışı denetler; sürüm listesi yalnız bu
-- transaction'da geri gelir, sonda rollback ile yine boşalır.
do $$
begin
  execute replace(
    pg_get_functiondef('public.sync_push(jsonb, timestamptz, integer)'::regprocedure),
    'array[]::integer[]',
    'array[1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26]'
  );
end
$$;

select plan(16);

-- Kullanıcılar: 3333 A'da worker, 5555 A'da viewer, 9999 B'nin owner'ı.
insert into auth.users (id, email) values
  ('33333333-3333-3333-3333-333333333333', 'worker@test.local'),
  ('55555555-5555-5555-5555-555555555555', 'viewer@test.local'),
  ('99999999-9999-9999-9999-999999999999', 'other@test.local');

-- aaaa: A işletmesi. eeee: B işletmesi.
insert into public.organizations (id, name, country_code, currency, created_by) values
  ('aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaaa', 'Petek Arıcılık', 'TR', 'TRY',
   '33333333-3333-3333-3333-333333333333'),
  ('eeeeeeee-eeee-eeee-eeee-eeeeeeeeeeee', 'Başka İşletme', 'TR', 'TRY',
   '99999999-9999-9999-9999-999999999999');

insert into public.memberships (id, org_id, user_id, role) values
  ('c0000000-0000-0000-0000-000000000003', 'aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaaa',
   '33333333-3333-3333-3333-333333333333', 'worker'),
  ('c0000000-0000-0000-0000-000000000005', 'aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaaa',
   '55555555-5555-5555-5555-555555555555', 'viewer'),
  ('c0000000-0000-0000-0000-000000000009', 'eeeeeeee-eeee-eeee-eeee-eeeeeeeeeeee',
   '99999999-9999-9999-9999-999999999999', 'owner');

-- Önek a1/e1 arılık, a6/e6 göç planı, a7/e7 durak.
insert into public.apiaries (id, org_id, name) values
  ('a1000000-0000-0000-0000-000000000001', 'aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaaa', 'Çam'),
  ('e1000000-0000-0000-0000-000000000001', 'eeeeeeee-eeee-eeee-eeee-eeeeeeeeeeee', 'Ova');

insert into public.migrations (id, org_id, year, name) values
  ('a6000000-0000-0000-0000-000000000001', 'aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaaa', 2026, 'Göç planı'),
  ('e6000000-0000-0000-0000-000000000001', 'eeeeeeee-eeee-eeee-eeee-eeeeeeeeeeee', 2026, 'Route');

insert into public.migration_stops (id, org_id, migration_id, position, name, place,
                                    planned_start_on, planned_end_on, apiary_id, hive_count, status) values
  ('a7000000-0000-0000-0000-000000000001', 'aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaaa',
   'a6000000-0000-0000-0000-000000000001', 1, 'Çam', 'Ula, Muğla',
   '2026-08-01', '2026-11-15', 'a1000000-0000-0000-0000-000000000001', 152, 'current'),
  ('e7000000-0000-0000-0000-000000000001', 'eeeeeeee-eeee-eeee-eeee-eeeeeeeeeeee',
   'e6000000-0000-0000-0000-000000000001', 1, 'Ova', null,
   '2026-04-01', '2026-06-30', 'e1000000-0000-0000-0000-000000000001', 40, 'past');

select throws_ok(
  $$insert into public.migration_stops (id, org_id, migration_id, position, name,
                                        planned_start_on, planned_end_on)
    values ('a7000000-0000-0000-0000-000000000002', 'aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaaa',
            'a6000000-0000-0000-0000-000000000001', 2, 'Kışlak', '2026-12-01', '2026-11-15')$$,
  '23514',
  null,
  'durağın bitişi başlangıcından önce olamaz'
);

set local role authenticated;

-- B'nin owner'ı
set local request.jwt.claims = '{"sub": "99999999-9999-9999-9999-999999999999"}';

select results_eq(
  'select id from public.migrations',
  $$values ('e6000000-0000-0000-0000-000000000001'::uuid)$$,
  'başka işletmenin göç planını göremez, yalnız kendisininkini görür'
);

select results_eq(
  'select id from public.migration_stops',
  $$values ('e7000000-0000-0000-0000-000000000001'::uuid)$$,
  'başka işletmenin durağını göremez, yalnız kendisininkini görür'
);

select throws_ok(
  $$insert into public.migrations (id, org_id, year, name)
    values ('e6000000-0000-0000-0000-000000000002', 'aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaaa', 2027, 'Sızma')$$,
  '42501',
  null,
  'başka işletmeye göç planı ekleyemez'
);

select is_empty(
  $$update public.migration_stops set hive_count = 1
    where id = 'a7000000-0000-0000-0000-000000000001' returning id$$,
  'başka işletmenin durağını güncelleyemez'
);

select throws_ok(
  $$insert into public.migration_stops (id, org_id, migration_id, position, name,
                                        planned_start_on, planned_end_on)
    values ('e7000000-0000-0000-0000-000000000002', 'eeeeeeee-eeee-eeee-eeee-eeeeeeeeeeee',
            'a6000000-0000-0000-0000-000000000001', 2, 'Sızma', '2026-12-01', '2026-12-31')$$,
  '23503',
  null,
  'kendi durağını başka işletmenin planına bağlayamaz'
);

select throws_ok(
  $$insert into public.migration_stops (id, org_id, migration_id, position, name,
                                        planned_start_on, planned_end_on, apiary_id)
    values ('e7000000-0000-0000-0000-000000000003', 'eeeeeeee-eeee-eeee-eeee-eeeeeeeeeeee',
            'e6000000-0000-0000-0000-000000000001', 2, 'Sızma', '2026-12-01', '2026-12-31',
            'a1000000-0000-0000-0000-000000000001')$$,
  '23503',
  null,
  'kendi durağını başka işletmenin arılığına bağlayamaz'
);

-- A'nın worker'ı
set local request.jwt.claims = '{"sub": "33333333-3333-3333-3333-333333333333"}';

select lives_ok(
  $$insert into public.migrations (id, org_id, year, name)
    values ('a6000000-0000-0000-0000-000000000002', 'aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaaa', 2027, 'Göç planı')$$,
  'worker göç planı ekler'
);

select lives_ok(
  $$insert into public.migration_stops (id, org_id, migration_id, position, name, place,
                                        planned_start_on, planned_end_on, hive_count)
    values ('a7000000-0000-0000-0000-000000000003', 'aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaaa',
            'a6000000-0000-0000-0000-000000000001', 2, 'Kışlak', 'Köyceğiz, Muğla',
            '2026-11-16', '2027-02-28', 152)$$,
  'worker hedef arılığı olmayan durak ekler; durum varsayılan olarak plan'
);

select results_eq(
  $$select status::text from public.migration_stops
    where id = 'a7000000-0000-0000-0000-000000000003'$$,
  $$values ('planned')$$,
  'yeni durağın durumu plan'
);

select isnt_empty(
  $$update public.migration_stops set status = 'past'
    where id = 'a7000000-0000-0000-0000-000000000001' returning id$$,
  'worker durağın durumunu günceller'
);

select results_eq(
  $$select r ->> 'status', r ->> 'applied'
    from jsonb_array_elements(public.sync_push(
      $j$[{"id": 1, "table": "migrations", "operation": "upsert", "payload": {
        "id": "a6000000-0000-0000-0000-000000000003",
        "org_id": "aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaaa",
        "year": 2028, "name": "Göç planı",
        "created_at": "2026-10-28T09:00:00.000Z",
        "updated_at": "2026-10-28T09:00:00.000Z",
        "created_by": null, "deleted_at": null}},
      {"id": 2, "table": "migration_stops", "operation": "upsert", "payload": {
        "id": "a7000000-0000-0000-0000-000000000004",
        "org_id": "aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaaa",
        "migration_id": "a6000000-0000-0000-0000-000000000003",
        "position": 1, "name": "Narenciye", "place": "Erdemli, Mersin",
        "planned_start_on": "2028-03-01", "planned_end_on": "2028-04-30",
        "apiary_id": "a1000000-0000-0000-0000-000000000001", "hive_count": 140,
        "status": "planned",
        "created_at": "2026-10-28T09:00:00.000Z",
        "updated_at": "2026-10-28T09:00:00.000Z",
        "created_by": null, "deleted_at": null}},
      {"id": 3, "table": "migration_stops", "operation": "upsert", "payload": {
        "id": "a7000000-0000-0000-0000-000000000004",
        "org_id": "aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaaa",
        "migration_id": "a6000000-0000-0000-0000-000000000003",
        "position": 1, "name": "Narenciye", "place": "Erdemli, Mersin",
        "planned_start_on": "2028-03-01", "planned_end_on": "2028-04-30",
        "apiary_id": "a1000000-0000-0000-0000-000000000001", "hive_count": 150,
        "status": "current",
        "created_at": "2026-10-28T09:00:00.000Z",
        "updated_at": "2026-10-28T10:00:00.000Z",
        "created_by": null, "deleted_at": null}},
      {"id": 4, "table": "migration_stops", "operation": "upsert", "payload": {
        "id": "a7000000-0000-0000-0000-000000000004",
        "org_id": "aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaaa",
        "migration_id": "a6000000-0000-0000-0000-000000000003",
        "position": 1, "name": "Narenciye", "place": "Erdemli, Mersin",
        "planned_start_on": "2028-03-01", "planned_end_on": "2028-04-30",
        "apiary_id": "a1000000-0000-0000-0000-000000000001", "hive_count": 120,
        "status": "planned",
        "created_at": "2026-10-28T09:00:00.000Z",
        "updated_at": "2026-10-28T09:30:00.000Z",
        "created_by": null, "deleted_at": null}}]$j$::jsonb,
      now(), 12) -> 'results') r$$,
  $$values ('ok', 'true'), ('ok', 'true'), ('ok', 'true'), ('ok', 'false')$$,
  'sync_push planı ve durağı şema sürümü 12 ile durum kaydı olarak yazar; eski yazma kaybeder'
);

select results_eq(
  $$select hive_count, status::text from public.migration_stops
    where id = 'a7000000-0000-0000-0000-000000000004'$$,
  $$values (150, 'current')$$,
  'son yazan kazanır: durak eski yazmayla geri dönmez'
);

-- A'nın viewer'ı
set local request.jwt.claims = '{"sub": "55555555-5555-5555-5555-555555555555"}';

select throws_ok(
  $$insert into public.migrations (id, org_id, year, name)
    values ('a6000000-0000-0000-0000-000000000004', 'aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaaa', 2029, 'Göç planı')$$,
  '42501',
  null,
  'viewer göç planı ekleyemez'
);

select is_empty(
  $$update public.migration_stops set hive_count = 1
    where id = 'a7000000-0000-0000-0000-000000000001' returning id$$,
  'viewer durağı güncelleyemez'
);

select results_eq(
  $$select count(*) from public.migration_stops$$,
  $$values (3::bigint)$$,
  'viewer işletmenin duraklarını görür'
);

select * from finish();
rollback;
