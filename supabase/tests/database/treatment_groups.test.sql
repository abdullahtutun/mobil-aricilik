-- Uygulama grupları ve reçete fotoğrafı: sync_push grubu ve uygulamaya
-- bağlı fotoğrafı şema sürümü 6 ile yazar; fotoğraf başka işletmenin
-- uygulamasına bağlanamaz; bir medya hem muayeneye hem uygulamaya bağlı
-- olamaz; eski sürümün grupsuz kaydı kabul edilir.
begin;
create extension if not exists pgtap with schema extensions;
select plan(6);

insert into auth.users (id, email) values
  ('33333333-3333-3333-3333-333333333333', 'worker@test.local'),
  ('99999999-9999-9999-9999-999999999999', 'other@test.local');

insert into public.organizations (id, name, country_code, currency, created_by) values
  ('aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaaa', 'Petek Arıcılık', 'TR', 'TRY',
   '33333333-3333-3333-3333-333333333333'),
  ('eeeeeeee-eeee-eeee-eeee-eeeeeeeeeeee', 'Başka İşletme', 'TR', 'TRY',
   '99999999-9999-9999-9999-999999999999');

insert into public.memberships (id, org_id, user_id, role) values
  ('c0000000-0000-0000-0000-000000000003', 'aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaaa',
   '33333333-3333-3333-3333-333333333333', 'worker'),
  ('c0000000-0000-0000-0000-000000000009', 'eeeeeeee-eeee-eeee-eeee-eeeeeeeeeeee',
   '99999999-9999-9999-9999-999999999999', 'owner');

-- Önek a1/e1 arılık, a3/e3 kovan, a5 muayene, a9/e9 uygulama, a6 medya.
insert into public.apiaries (id, org_id, name) values
  ('a1000000-0000-0000-0000-000000000001', 'aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaaa', 'Yayla'),
  ('e1000000-0000-0000-0000-000000000001', 'eeeeeeee-eeee-eeee-eeee-eeeeeeeeeeee', 'Ova');

insert into public.hives (id, org_id, number, type, apiary_id) values
  ('a3000000-0000-0000-0000-000000000001', 'aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaaa',
   '101', 'langstroth', 'a1000000-0000-0000-0000-000000000001'),
  ('e3000000-0000-0000-0000-000000000001', 'eeeeeeee-eeee-eeee-eeee-eeeeeeeeeeee',
   '101', 'dadant', 'e1000000-0000-0000-0000-000000000001');

insert into public.inspections (id, org_id, hive_id, apiary_id, inspected_at) values
  ('a5000000-0000-0000-0000-000000000001', 'aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaaa',
   'a3000000-0000-0000-0000-000000000001', 'a1000000-0000-0000-0000-000000000001', now());

insert into public.treatments (id, org_id, hive_id, apiary_id, ref_drug_id, product_name,
                               active_ingredient, dose, dose_unit, started_at, withdrawal_days,
                               application_id) values
  ('a9000000-0000-0000-0000-000000000001', 'aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaaa',
   'a3000000-0000-0000-0000-000000000001', 'a1000000-0000-0000-0000-000000000001',
   '01900000-0000-7000-8000-000000000001', 'Amitraz', 'amitraz', 2, 'strip', now(), 0,
   'a7000000-0000-0000-0000-000000000001'),
  ('e9000000-0000-0000-0000-000000000001', 'eeeeeeee-eeee-eeee-eeee-eeeeeeeeeeee',
   'e3000000-0000-0000-0000-000000000001', 'e1000000-0000-0000-0000-000000000001',
   '01900000-0000-7000-8000-000000000001', 'Amitraz', 'amitraz', 2, 'strip', now(), 0,
   null);

set local role authenticated;
set local request.jwt.claims = '{"sub": "33333333-3333-3333-3333-333333333333"}';

select results_eq(
  $$select r ->> 'status', r ->> 'applied'
    from jsonb_array_elements(public.sync_push(
      $j$[{"id": 1, "table": "treatments", "operation": "upsert", "payload": {
        "id": "a9000000-0000-0000-0000-000000000002",
        "org_id": "aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaaa",
        "hive_id": "a3000000-0000-0000-0000-000000000001",
        "apiary_id": "a1000000-0000-0000-0000-000000000001",
        "ref_drug_id": "01900000-0000-7000-8000-000000000001", "drug_id": null,
        "application_id": "a7000000-0000-0000-0000-000000000002",
        "product_name": "Amitraz", "active_ingredient": "amitraz",
        "batch_no": null, "dose": 2, "dose_unit": "strip",
        "started_at": "2026-10-25T09:00:00.000Z", "planned_removal_at": null,
        "withdrawal_days": 0,
        "created_at": "2026-10-25T09:00:00.000Z",
        "updated_at": "2026-10-25T09:00:00.000Z",
        "created_by": null, "deleted_at": null}},
       {"id": 2, "table": "media", "operation": "upsert", "payload": {
        "id": "a6000000-0000-0000-0000-000000000001",
        "org_id": "aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaaa",
        "hive_id": "a3000000-0000-0000-0000-000000000001",
        "inspection_id": null,
        "treatment_id": "a9000000-0000-0000-0000-000000000002",
        "kind": "photo",
        "storage_path": "aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaaa/a3000000-0000-0000-0000-000000000001/a6000000-0000-0000-0000-000000000001.jpg",
        "captured_at": "2026-10-25T09:00:00.000Z", "byte_size": 1000,
        "duration_ms": null,
        "created_at": "2026-10-25T09:00:00.000Z",
        "updated_at": "2026-10-25T09:00:00.000Z",
        "created_by": null, "deleted_at": null}}]$j$::jsonb,
      now(), 6) -> 'results') r$$,
  $$values ('ok', 'true'), ('ok', 'true')$$,
  'sync_push grubu ve uygulamaya bağlı fotoğrafı şema sürümü 6 ile yazar'
);

select results_eq(
  $$select application_id from public.treatments
    where id = 'a9000000-0000-0000-0000-000000000002'$$,
  $$values ('a7000000-0000-0000-0000-000000000002'::uuid)$$,
  'grup kimliği saklanır'
);

select results_eq(
  $$select r ->> 'status'
    from jsonb_array_elements(public.sync_push(
      $j$[{"id": 1, "table": "treatments", "operation": "upsert", "payload": {
        "id": "a9000000-0000-0000-0000-000000000003",
        "org_id": "aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaaa",
        "hive_id": "a3000000-0000-0000-0000-000000000001",
        "apiary_id": "a1000000-0000-0000-0000-000000000001",
        "ref_drug_id": "01900000-0000-7000-8000-000000000001", "drug_id": null,
        "product_name": "Amitraz", "active_ingredient": "amitraz",
        "batch_no": null, "dose": 2, "dose_unit": "strip",
        "started_at": "2026-10-25T09:00:00.000Z", "planned_removal_at": null,
        "withdrawal_days": 0,
        "created_at": "2026-10-25T09:00:00.000Z",
        "updated_at": "2026-10-25T09:00:00.000Z",
        "created_by": null, "deleted_at": null}}]$j$::jsonb,
      now(), 5) -> 'results') r$$,
  $$values ('ok')$$,
  'şema sürümü 5 grupsuz kaydı hâlâ yazabilir'
);

select throws_ok(
  $$insert into public.media (id, org_id, hive_id, treatment_id, kind, storage_path, captured_at, byte_size)
    values ('a6000000-0000-0000-0000-000000000002', 'aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaaa',
            'a3000000-0000-0000-0000-000000000001', 'e9000000-0000-0000-0000-000000000001',
            'photo',
            'aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaaa/a3000000-0000-0000-0000-000000000001/a6000000-0000-0000-0000-000000000002.jpg',
            now(), 1000)$$,
  '23503',
  null,
  'fotoğraf başka işletmenin uygulamasına bağlanamaz'
);

select throws_ok(
  $$insert into public.media (id, org_id, hive_id, inspection_id, treatment_id, kind, storage_path, captured_at, byte_size)
    values ('a6000000-0000-0000-0000-000000000003', 'aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaaa',
            'a3000000-0000-0000-0000-000000000001', 'a5000000-0000-0000-0000-000000000001',
            'a9000000-0000-0000-0000-000000000001', 'photo',
            'aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaaa/a3000000-0000-0000-0000-000000000001/a6000000-0000-0000-0000-000000000003.jpg',
            now(), 1000)$$,
  '23514',
  null,
  'bir medya hem muayeneye hem uygulamaya bağlı olamaz'
);

select lives_ok(
  $$insert into public.media (id, org_id, hive_id, treatment_id, kind, storage_path, captured_at, byte_size)
    values ('a6000000-0000-0000-0000-000000000004', 'aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaaa',
            'a3000000-0000-0000-0000-000000000001', 'a9000000-0000-0000-0000-000000000001',
            'photo',
            'aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaaa/a3000000-0000-0000-0000-000000000001/a6000000-0000-0000-0000-000000000004.jpg',
            now(), 1000)$$,
  'worker kendi uygulamasına reçete fotoğrafı ekler'
);

select * from finish();
rollback;
