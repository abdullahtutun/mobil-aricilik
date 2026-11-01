-- lots, lot_harvests, lot_treatments, lab_results ve lot_sales RLS ve
-- tutarlılık: başka işletmenin lotu ve bağlı kayıtları görünmez ve
-- yazılamaz; worker yazar, viewer yalnız okur; işletmeler arası bağ
-- reddedilir; bir hasat bir lotta; analizde en az bir sonuç; sync_push lotu
-- durum, diğerlerini olay kaydı olarak şema sürümü 17 ile yazar.
begin;
create extension if not exists pgtap with schema extensions;
select plan(20);

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

-- Önek a1/e1 arılık, a3/e3 kovan, a9/e9 uygulama, a7/e7 hasat, ab/eb lot,
-- ac/ec lot hasadı, ad lot ilaçlaması, a8 belge, af analiz, a0 satış.
insert into public.apiaries (id, org_id, name) values
  ('a1000000-0000-0000-0000-000000000001', 'aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaaa', 'Kızılçam'),
  ('e1000000-0000-0000-0000-000000000001', 'eeeeeeee-eeee-eeee-eeee-eeeeeeeeeeee', 'Ova');

insert into public.hives (id, org_id, number, type, apiary_id) values
  ('a3000000-0000-0000-0000-000000000001', 'aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaaa',
   '101', 'langstroth', 'a1000000-0000-0000-0000-000000000001'),
  ('e3000000-0000-0000-0000-000000000001', 'eeeeeeee-eeee-eeee-eeee-eeeeeeeeeeee',
   '101', 'dadant', 'e1000000-0000-0000-0000-000000000001');

insert into public.treatments (id, org_id, hive_id, apiary_id, ref_drug_id, product_name,
                               active_ingredient, dose, dose_unit, started_at, withdrawal_days) values
  ('a9000000-0000-0000-0000-000000000001', 'aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaaa',
   'a3000000-0000-0000-0000-000000000001', 'a1000000-0000-0000-0000-000000000001',
   (select id from public.ref_drugs order by id limit 1), 'Amitraz şerit', 'amitraz',
   2, 'strip', now() - interval '60 days', 14),
  ('e9000000-0000-0000-0000-000000000001', 'eeeeeeee-eeee-eeee-eeee-eeeeeeeeeeee',
   'e3000000-0000-0000-0000-000000000001', 'e1000000-0000-0000-0000-000000000001',
   (select id from public.ref_drugs order by id limit 1), 'Amitraz şerit', 'amitraz',
   2, 'strip', now() - interval '60 days', 14);

insert into public.harvests (id, org_id, apiary_id, harvested_at, honey_kind, unit, unit_count, net_kg) values
  ('a7000000-0000-0000-0000-000000000001', 'aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaaa',
   'a1000000-0000-0000-0000-000000000001', now(), 'pine', 'super', 24, 574),
  ('a7000000-0000-0000-0000-000000000002', 'aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaaa',
   'a1000000-0000-0000-0000-000000000001', now(), 'pine', 'super', 4, 80),
  ('e7000000-0000-0000-0000-000000000001', 'eeeeeeee-eeee-eeee-eeee-eeeeeeeeeeee',
   'e1000000-0000-0000-0000-000000000001', now(), 'flower', 'frame', 10, 20.5);

insert into public.lots (id, org_id, year, seq, honey_kind, origin, moisture) values
  ('ab000000-0000-0000-0000-000000000001', 'aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaaa',
   2026, 7, 'pine', 'Kızılçam', 17.2),
  ('eb000000-0000-0000-0000-000000000001', 'eeeeeeee-eeee-eeee-eeee-eeeeeeeeeeee',
   2026, 1, 'flower', null, null);

insert into public.lot_harvests (id, org_id, lot_id, harvest_id) values
  ('ac000000-0000-0000-0000-000000000001', 'aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaaa',
   'ab000000-0000-0000-0000-000000000001', 'a7000000-0000-0000-0000-000000000001'),
  ('ec000000-0000-0000-0000-000000000001', 'eeeeeeee-eeee-eeee-eeee-eeeeeeeeeeee',
   'eb000000-0000-0000-0000-000000000001', 'e7000000-0000-0000-0000-000000000001');

insert into public.documents (id, org_id, type, name, file_kind, storage_path, byte_size) values
  ('a8000000-0000-0000-0000-000000000001', 'aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaaa',
   'analysis_report', 'Analiz raporu', 'pdf',
   'aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaaa/a8000000-0000-0000-0000-000000000001/f0000000-0000-0000-0000-000000000001.pdf',
   1000);

set local role authenticated;

-- B'nin owner'ı
set local request.jwt.claims = '{"sub": "99999999-9999-9999-9999-999999999999"}';

select results_eq(
  'select id from public.lots',
  $$values ('eb000000-0000-0000-0000-000000000001'::uuid)$$,
  'başka işletmenin lotunu göremez, yalnız kendisininkini görür'
);

select results_eq(
  'select id from public.lot_harvests',
  $$values ('ec000000-0000-0000-0000-000000000001'::uuid)$$,
  'başka işletmenin lot hasadını göremez'
);

select throws_ok(
  $$insert into public.lots (id, org_id, year, seq, honey_kind)
    values ('eb000000-0000-0000-0000-000000000002', 'aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaaa',
            2026, 2, 'pine')$$,
  '42501',
  null,
  'başka işletmeye lot ekleyemez'
);

select is_empty(
  $$update public.lots set status = 'closed'
    where id = 'ab000000-0000-0000-0000-000000000001' returning id$$,
  'başka işletmenin lotunu güncelleyemez'
);

select throws_ok(
  $$insert into public.lot_harvests (id, org_id, lot_id, harvest_id)
    values ('ec000000-0000-0000-0000-000000000002', 'eeeeeeee-eeee-eeee-eeee-eeeeeeeeeeee',
            'eb000000-0000-0000-0000-000000000001', 'a7000000-0000-0000-0000-000000000002')$$,
  '23503',
  null,
  'kendi lotuna başka işletmenin hasadını bağlayamaz'
);

select throws_ok(
  $$insert into public.lab_results (id, org_id, lot_id, tested_on, hmf)
    values ('ef000000-0000-0000-0000-000000000001', 'eeeeeeee-eeee-eeee-eeee-eeeeeeeeeeee',
            'ab000000-0000-0000-0000-000000000001', '2026-10-01', 12)$$,
  '23503',
  null,
  'başka işletmenin lotuna analiz bağlayamaz'
);

select throws_ok(
  $$insert into public.lab_results (id, org_id, lot_id, tested_on, hmf, document_id)
    values ('ef000000-0000-0000-0000-000000000001', 'eeeeeeee-eeee-eeee-eeee-eeeeeeeeeeee',
            'eb000000-0000-0000-0000-000000000001', '2026-10-01', 12,
            'a8000000-0000-0000-0000-000000000001')$$,
  '23503',
  null,
  'analize başka işletmenin belgesini bağlayamaz'
);

-- A'nın worker'ı
set local request.jwt.claims = '{"sub": "33333333-3333-3333-3333-333333333333"}';

select lives_ok(
  $$insert into public.lot_treatments (id, org_id, lot_id, harvest_id, hive_id, treatment_id,
                                       treated_at, withdrawal_ends_on, withdrawal_violation)
    values ('ad000000-0000-0000-0000-000000000001', 'aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaaa',
            'ab000000-0000-0000-0000-000000000001', 'a7000000-0000-0000-0000-000000000001',
            'a3000000-0000-0000-0000-000000000001', 'a9000000-0000-0000-0000-000000000001',
            now() - interval '60 days', current_date - 46, false)$$,
  'worker lota kovanın son ilaçlamasını bağlar'
);

select throws_ok(
  $$insert into public.lot_treatments (id, org_id, lot_id, harvest_id, hive_id, treatment_id,
                                       treated_at, withdrawal_ends_on, withdrawal_violation)
    values ('ad000000-0000-0000-0000-000000000002', 'aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaaa',
            'ab000000-0000-0000-0000-000000000001', 'a7000000-0000-0000-0000-000000000001',
            'a3000000-0000-0000-0000-000000000001', 'e9000000-0000-0000-0000-000000000001',
            now(), current_date, false)$$,
  '23503',
  null,
  'lota başka işletmenin ilaçlamasını bağlayamaz'
);

select lives_ok(
  $$insert into public.lab_results (id, org_id, lot_id, tested_on, hmf, diastase, proline,
                                    moisture, residue, document_id)
    values ('af000000-0000-0000-0000-000000000001', 'aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaaa',
            'ab000000-0000-0000-0000-000000000001', '2026-10-01', 12.4, 18.2, 420,
            17.1, 'none', 'a8000000-0000-0000-0000-000000000001')$$,
  'worker raporlu analiz ekler'
);

select throws_ok(
  $$insert into public.lab_results (id, org_id, lot_id, tested_on)
    values ('af000000-0000-0000-0000-000000000002', 'aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaaa',
            'ab000000-0000-0000-0000-000000000001', '2026-10-01')$$,
  '23514',
  null,
  'analizde en az bir sonuç olmalı'
);

select throws_ok(
  $$insert into public.lots (id, org_id, year, seq, honey_kind, moisture)
    values ('ab000000-0000-0000-0000-000000000002', 'aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaaa',
            2026, 8, 'pine', 35)$$,
  '23514',
  null,
  'nem 10 ile 30 arasında'
);

select throws_ok(
  $$insert into public.lot_harvests (id, org_id, lot_id, harvest_id)
    values ('ac000000-0000-0000-0000-000000000002', 'aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaaa',
            'ab000000-0000-0000-0000-000000000001', 'a7000000-0000-0000-0000-000000000001')$$,
  '23505',
  null,
  'bir hasat bir lotta bir kez'
);

select lives_ok(
  $$insert into public.lot_sales (id, org_id, lot_id, sold_on, kg)
    values ('a0000000-0000-0000-0000-000000000001', 'aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaaa',
            'ab000000-0000-0000-0000-000000000001', '2026-10-15', 164)$$,
  'worker lottan satış düşer'
);

select throws_ok(
  $$insert into public.lot_sales (id, org_id, lot_id, sold_on, kg)
    values ('a0000000-0000-0000-0000-000000000002', 'aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaaa',
            'ab000000-0000-0000-0000-000000000001', '2026-10-15', 0)$$,
  '23514',
  null,
  'satış sıfır olamaz'
);

select results_eq(
  $$select r ->> 'status', r ->> 'applied'
    from jsonb_array_elements(public.sync_push(
      $j$[{"id": 1, "table": "lots", "operation": "upsert", "payload": {
        "id": "ab000000-0000-0000-0000-000000000003",
        "org_id": "aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaaa",
        "year": 2026, "seq": 8, "honey_kind": "pine", "origin": "Kızılçam",
        "moisture": null, "status": "open",
        "created_at": "2026-11-02T09:00:00.000Z",
        "updated_at": "2026-11-02T09:00:00.000Z",
        "created_by": null, "deleted_at": null}},
      {"id": 2, "table": "lot_harvests", "operation": "upsert", "payload": {
        "id": "ac000000-0000-0000-0000-000000000003",
        "org_id": "aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaaa",
        "lot_id": "ab000000-0000-0000-0000-000000000003",
        "harvest_id": "a7000000-0000-0000-0000-000000000002",
        "created_at": "2026-11-02T09:00:00.000Z",
        "updated_at": "2026-11-02T09:00:00.000Z",
        "created_by": null, "deleted_at": null}},
      {"id": 3, "table": "lots", "operation": "upsert", "payload": {
        "id": "ab000000-0000-0000-0000-000000000003",
        "org_id": "aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaaa",
        "year": 2026, "seq": 8, "honey_kind": "pine", "origin": "Eski",
        "moisture": null, "status": "closed",
        "created_at": "2026-11-02T09:00:00.000Z",
        "updated_at": "2026-11-02T08:00:00.000Z",
        "created_by": null, "deleted_at": null}},
      {"id": 4, "table": "lot_sales", "operation": "upsert", "payload": {
        "id": "a0000000-0000-0000-0000-000000000003",
        "org_id": "aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaaa",
        "lot_id": "ab000000-0000-0000-0000-000000000003",
        "sold_on": "2026-11-02", "kg": 20,
        "created_at": "2026-11-02T09:01:00.000Z",
        "updated_at": "2026-11-02T09:01:00.000Z",
        "created_by": null, "deleted_at": null}}]$j$::jsonb,
      now(), 17) -> 'results') r$$,
  $$values ('ok', 'true'), ('ok', 'true'), ('ok', 'false'), ('ok', 'true')$$,
  'sync_push lotu, lot hasadını ve satışı şema sürümü 17 ile yazar; lotun eski yazması kaybeder'
);

select results_eq(
  $$select r ->> 'status', r ->> 'applied'
    from jsonb_array_elements(public.sync_push(
      $j$[{"id": 1, "table": "lab_results", "operation": "upsert", "payload": {
        "id": "af000000-0000-0000-0000-000000000003",
        "org_id": "aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaaa",
        "lot_id": "ab000000-0000-0000-0000-000000000003",
        "tested_on": "2026-11-02", "hmf": null, "diastase": null,
        "proline": null, "moisture": null, "residue": "detected",
        "document_id": null,
        "created_at": "2026-11-02T09:02:00.000Z",
        "updated_at": "2026-11-02T09:02:00.000Z",
        "created_by": null, "deleted_at": null}},
      {"id": 2, "table": "lot_treatments", "operation": "upsert", "payload": {
        "id": "ad000000-0000-0000-0000-000000000003",
        "org_id": "aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaaa",
        "lot_id": "ab000000-0000-0000-0000-000000000003",
        "harvest_id": "a7000000-0000-0000-0000-000000000002",
        "hive_id": "a3000000-0000-0000-0000-000000000001",
        "treatment_id": "a9000000-0000-0000-0000-000000000001",
        "treated_at": "2026-09-01T09:00:00.000Z",
        "withdrawal_ends_on": "2026-11-20", "withdrawal_violation": true,
        "created_at": "2026-11-02T09:02:00.000Z",
        "updated_at": "2026-11-02T09:02:00.000Z",
        "created_by": null, "deleted_at": null}},
      {"id": 3, "table": "lot_sales", "operation": "delete", "payload": {
        "id": "a0000000-0000-0000-0000-000000000003",
        "org_id": "aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaaa",
        "lot_id": "ab000000-0000-0000-0000-000000000003",
        "sold_on": "2026-11-02", "kg": 1,
        "created_at": "2026-11-02T09:01:00.000Z",
        "updated_at": "2026-11-02T09:05:00.000Z",
        "created_by": null, "deleted_at": "2026-11-02T09:05:00.000Z"}}]$j$::jsonb,
      now(), 17) -> 'results') r$$,
  $$values ('ok', 'true'), ('ok', 'true'), ('ok', 'true')$$,
  'sync_push analizi ve lot ilaçlamasını yazar, satışın silinmesini işler'
);

select results_eq(
  $$select kg, deleted_at is not null from public.lot_sales
    where id = 'a0000000-0000-0000-0000-000000000003'$$,
  $$values (20::numeric, true)$$,
  'olay kaydı: silme yalnız deleted_at yazar, miktar değişmez'
);

-- A'nın viewer'ı
set local request.jwt.claims = '{"sub": "55555555-5555-5555-5555-555555555555"}';

select results_eq(
  $$select count(*)::int from public.lab_results$$,
  $$values (2)$$,
  'viewer işletmenin analizlerini görür'
);

select throws_ok(
  $$insert into public.lot_sales (id, org_id, lot_id, sold_on, kg)
    values ('a0000000-0000-0000-0000-000000000004', 'aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaaa',
            'ab000000-0000-0000-0000-000000000001', '2026-10-15', 5)$$,
  '42501',
  null,
  'viewer satış düşemez'
);

select * from finish();
rollback;
