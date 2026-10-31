-- transports ve transport_items RLS ve tutarlılık: başka işletmenin
-- taşıması ve taşınan kovanı görünmez ve yazılamaz; worker yazar, viewer
-- yalnız okur; işletmeler arası bağ (arılık, durak, taşıma, kovan)
-- reddedilir; kaynak ve hedef aynı arılık olamaz; araçlar JSON dizisi;
-- sync_push iki tabloyu şema sürümü 13 ile durum kaydı olarak yazar.
begin;
create extension if not exists pgtap with schema extensions;
select plan(18);

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

-- Önek a1/e1 arılık, a3/e3 kovan, a6 göç planı, a7 durak, a8/e8 taşıma,
-- a9/e9 taşınan kovan.
insert into public.apiaries (id, org_id, name) values
  ('a1000000-0000-0000-0000-000000000001', 'aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaaa', 'Çam'),
  ('a1000000-0000-0000-0000-000000000002', 'aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaaa', 'Kışlak'),
  ('e1000000-0000-0000-0000-000000000001', 'eeeeeeee-eeee-eeee-eeee-eeeeeeeeeeee', 'Ova'),
  ('e1000000-0000-0000-0000-000000000002', 'eeeeeeee-eeee-eeee-eeee-eeeeeeeeeeee', 'Yayla');

insert into public.hives (id, org_id, number, type, apiary_id) values
  ('a3000000-0000-0000-0000-000000000001', 'aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaaa',
   '101', 'langstroth', 'a1000000-0000-0000-0000-000000000001'),
  ('a3000000-0000-0000-0000-000000000002', 'aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaaa',
   '102', 'langstroth', 'a1000000-0000-0000-0000-000000000001'),
  ('e3000000-0000-0000-0000-000000000001', 'eeeeeeee-eeee-eeee-eeee-eeeeeeeeeeee',
   '101', 'dadant', 'e1000000-0000-0000-0000-000000000001');

insert into public.migrations (id, org_id, year, name) values
  ('a6000000-0000-0000-0000-000000000001', 'aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaaa', 2026, 'Göç planı');

insert into public.migration_stops (id, org_id, migration_id, position, name,
                                    planned_start_on, planned_end_on, apiary_id) values
  ('a7000000-0000-0000-0000-000000000001', 'aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaaa',
   'a6000000-0000-0000-0000-000000000001', 1, 'Kışlak',
   '2026-11-16', '2027-02-28', 'a1000000-0000-0000-0000-000000000002');

insert into public.transports (id, org_id, migration_stop_id, source_apiary_id,
                               destination_apiary_id, vehicles) values
  ('a8000000-0000-0000-0000-000000000001', 'aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaaa',
   'a7000000-0000-0000-0000-000000000001', 'a1000000-0000-0000-0000-000000000001',
   'a1000000-0000-0000-0000-000000000002', '["Kamyon 1"]'),
  ('e8000000-0000-0000-0000-000000000001', 'eeeeeeee-eeee-eeee-eeee-eeeeeeeeeeee',
   null, 'e1000000-0000-0000-0000-000000000001',
   'e1000000-0000-0000-0000-000000000002', '["Truck"]');

insert into public.transport_items (id, org_id, transport_id, hive_id, vehicle, loaded_at) values
  ('a9000000-0000-0000-0000-000000000001', 'aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaaa',
   'a8000000-0000-0000-0000-000000000001', 'a3000000-0000-0000-0000-000000000001',
   'Kamyon 1', '2026-11-15T18:00:00Z'),
  ('e9000000-0000-0000-0000-000000000001', 'eeeeeeee-eeee-eeee-eeee-eeeeeeeeeeee',
   'e8000000-0000-0000-0000-000000000001', 'e3000000-0000-0000-0000-000000000001',
   'Truck', '2026-11-15T18:00:00Z');

select throws_ok(
  $$insert into public.transports (id, org_id, source_apiary_id, destination_apiary_id)
    values ('a8000000-0000-0000-0000-000000000002', 'aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaaa',
            'a1000000-0000-0000-0000-000000000001', 'a1000000-0000-0000-0000-000000000001')$$,
  '23514',
  null,
  'kaynak ve hedef aynı arılık olamaz'
);

select throws_ok(
  $$insert into public.transports (id, org_id, source_apiary_id, destination_apiary_id, vehicles)
    values ('a8000000-0000-0000-0000-000000000003', 'aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaaa',
            'a1000000-0000-0000-0000-000000000001', 'a1000000-0000-0000-0000-000000000002',
            '{"name": "Kamyon 1"}')$$,
  '23514',
  null,
  'araçlar JSON dizisi olmalı'
);

set local role authenticated;

-- B'nin owner'ı
set local request.jwt.claims = '{"sub": "99999999-9999-9999-9999-999999999999"}';

select results_eq(
  'select id from public.transports',
  $$values ('e8000000-0000-0000-0000-000000000001'::uuid)$$,
  'başka işletmenin taşımasını göremez, yalnız kendisininkini görür'
);

select results_eq(
  'select id from public.transport_items',
  $$values ('e9000000-0000-0000-0000-000000000001'::uuid)$$,
  'başka işletmenin taşınan kovanını göremez, yalnız kendisininkini görür'
);

select throws_ok(
  $$insert into public.transports (id, org_id, source_apiary_id, destination_apiary_id)
    values ('e8000000-0000-0000-0000-000000000002', 'aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaaa',
            'a1000000-0000-0000-0000-000000000001', 'a1000000-0000-0000-0000-000000000002')$$,
  '42501',
  null,
  'başka işletmeye taşıma ekleyemez'
);

select is_empty(
  $$update public.transport_items set unloaded_at = now()
    where id = 'a9000000-0000-0000-0000-000000000001' returning id$$,
  'başka işletmenin taşınan kovanını güncelleyemez'
);

select throws_ok(
  $$insert into public.transports (id, org_id, source_apiary_id, destination_apiary_id)
    values ('e8000000-0000-0000-0000-000000000003', 'eeeeeeee-eeee-eeee-eeee-eeeeeeeeeeee',
            'e1000000-0000-0000-0000-000000000001', 'a1000000-0000-0000-0000-000000000002')$$,
  '23503',
  null,
  'kendi taşımasını başka işletmenin arılığına bağlayamaz'
);

select throws_ok(
  $$insert into public.transports (id, org_id, migration_stop_id, source_apiary_id,
                                   destination_apiary_id)
    values ('e8000000-0000-0000-0000-000000000004', 'eeeeeeee-eeee-eeee-eeee-eeeeeeeeeeee',
            'a7000000-0000-0000-0000-000000000001', 'e1000000-0000-0000-0000-000000000001',
            'e1000000-0000-0000-0000-000000000002')$$,
  '23503',
  null,
  'kendi taşımasını başka işletmenin göç durağına bağlayamaz'
);

select throws_ok(
  $$insert into public.transport_items (id, org_id, transport_id, hive_id, vehicle, loaded_at)
    values ('e9000000-0000-0000-0000-000000000002', 'eeeeeeee-eeee-eeee-eeee-eeeeeeeeeeee',
            'a8000000-0000-0000-0000-000000000001', 'e3000000-0000-0000-0000-000000000001',
            'Truck', now())$$,
  '23503',
  null,
  'kendi kovanını başka işletmenin taşımasına bağlayamaz'
);

select throws_ok(
  $$insert into public.transport_items (id, org_id, transport_id, hive_id, vehicle, loaded_at)
    values ('e9000000-0000-0000-0000-000000000003', 'eeeeeeee-eeee-eeee-eeee-eeeeeeeeeeee',
            'e8000000-0000-0000-0000-000000000001', 'a3000000-0000-0000-0000-000000000002',
            'Truck', now())$$,
  '23503',
  null,
  'kendi taşımasına başka işletmenin kovanını bağlayamaz'
);

-- A'nın worker'ı
set local request.jwt.claims = '{"sub": "33333333-3333-3333-3333-333333333333"}';

select lives_ok(
  $$insert into public.transport_items (id, org_id, transport_id, hive_id, vehicle, loaded_at)
    values ('a9000000-0000-0000-0000-000000000002', 'aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaaa',
            'a8000000-0000-0000-0000-000000000001', 'a3000000-0000-0000-0000-000000000002',
            'Kamyon 1', '2026-11-15T18:05:00Z')$$,
  'worker kovanı taşımaya yükler'
);

select isnt_empty(
  $$update public.transport_items set unloaded_at = '2026-11-16T06:00:00Z'
    where id = 'a9000000-0000-0000-0000-000000000001' returning id$$,
  'worker kovanı indirir'
);

select results_eq(
  $$select status::text from public.transports
    where id = 'a8000000-0000-0000-0000-000000000001'$$,
  $$values ('loading')$$,
  'yeni taşımanın durumu yükleme'
);

select results_eq(
  $$select r ->> 'status', r ->> 'applied'
    from jsonb_array_elements(public.sync_push(
      $j$[{"id": 1, "table": "transports", "operation": "upsert", "payload": {
        "id": "a8000000-0000-0000-0000-000000000004",
        "org_id": "aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaaa",
        "migration_stop_id": null,
        "source_apiary_id": "a1000000-0000-0000-0000-000000000002",
        "destination_apiary_id": "a1000000-0000-0000-0000-000000000001",
        "vehicles": ["Kamyon 1", "Kamyon 2"], "status": "loading",
        "completed_at": null,
        "created_at": "2026-10-31T09:00:00.000Z",
        "updated_at": "2026-10-31T09:00:00.000Z",
        "created_by": null, "deleted_at": null}},
      {"id": 2, "table": "transport_items", "operation": "upsert", "payload": {
        "id": "a9000000-0000-0000-0000-000000000004",
        "org_id": "aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaaa",
        "transport_id": "a8000000-0000-0000-0000-000000000004",
        "hive_id": "a3000000-0000-0000-0000-000000000001",
        "vehicle": "Kamyon 2",
        "loaded_at": "2026-10-31T09:05:00.000Z", "unloaded_at": null,
        "created_at": "2026-10-31T09:05:00.000Z",
        "updated_at": "2026-10-31T09:05:00.000Z",
        "created_by": null, "deleted_at": null}},
      {"id": 3, "table": "transport_items", "operation": "upsert", "payload": {
        "id": "a9000000-0000-0000-0000-000000000004",
        "org_id": "aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaaa",
        "transport_id": "a8000000-0000-0000-0000-000000000004",
        "hive_id": "a3000000-0000-0000-0000-000000000001",
        "vehicle": "Kamyon 2",
        "loaded_at": "2026-10-31T09:05:00.000Z",
        "unloaded_at": "2026-10-31T15:00:00.000Z",
        "created_at": "2026-10-31T09:05:00.000Z",
        "updated_at": "2026-10-31T15:00:00.000Z",
        "created_by": null, "deleted_at": null}},
      {"id": 4, "table": "transport_items", "operation": "upsert", "payload": {
        "id": "a9000000-0000-0000-0000-000000000004",
        "org_id": "aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaaa",
        "transport_id": "a8000000-0000-0000-0000-000000000004",
        "hive_id": "a3000000-0000-0000-0000-000000000001",
        "vehicle": "Kamyon 2",
        "loaded_at": "2026-10-31T09:05:00.000Z", "unloaded_at": null,
        "created_at": "2026-10-31T09:05:00.000Z",
        "updated_at": "2026-10-31T10:00:00.000Z",
        "created_by": null, "deleted_at": null}}]$j$::jsonb,
      now(), 13) -> 'results') r$$,
  $$values ('ok', 'true'), ('ok', 'true'), ('ok', 'true'), ('ok', 'false')$$,
  'sync_push taşımayı ve kovanı şema sürümü 13 ile durum kaydı olarak yazar; eski yazma kaybeder'
);

select results_eq(
  $$select vehicles from public.transports
    where id = 'a8000000-0000-0000-0000-000000000004'$$,
  $$values ('["Kamyon 1", "Kamyon 2"]'::jsonb)$$,
  'araçlar dizi olarak yazılır'
);

select isnt_empty(
  $$select from public.transport_items
    where id = 'a9000000-0000-0000-0000-000000000004' and unloaded_at is not null$$,
  'son yazan kazanır: indirilen kovan eski yazmayla geri dönmez'
);

-- A'nın viewer'ı
set local request.jwt.claims = '{"sub": "55555555-5555-5555-5555-555555555555"}';

select throws_ok(
  $$insert into public.transports (id, org_id, source_apiary_id, destination_apiary_id)
    values ('a8000000-0000-0000-0000-000000000005', 'aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaaa',
            'a1000000-0000-0000-0000-000000000001', 'a1000000-0000-0000-0000-000000000002')$$,
  '42501',
  null,
  'viewer taşıma ekleyemez'
);

select is_empty(
  $$update public.transport_items set unloaded_at = now()
    where id = 'a9000000-0000-0000-0000-000000000002' returning id$$,
  'viewer taşınan kovanı güncelleyemez'
);

select * from finish();
rollback;
