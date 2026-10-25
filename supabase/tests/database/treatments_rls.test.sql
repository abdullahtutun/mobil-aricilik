-- ref_drugs, drugs ve treatments: referans liste herkese açık ve salt
-- okunur; işletmenin ilaçları ve uygulamaları başka işletmeye görünmez ve
-- yazılamaz; worker yazar, viewer yalnız okur; işletmeler arası bağ
-- reddedilir; uygulamanın ilacı tam bir listeden gelir; sync_push ilacı
-- durum, uygulamayı olay kaydı olarak şema sürümü 5 ile yazar.
begin;
create extension if not exists pgtap with schema extensions;
select plan(22);

-- Kullanıcılar: 3333 A'da worker, 5555 A'da viewer, 9999 B'nin owner'ı.
insert into auth.users (id, email) values
  ('33333333-3333-3333-3333-333333333333', 'worker@test.local'),
  ('55555555-5555-5555-5555-555555555555', 'viewer@test.local'),
  ('99999999-9999-9999-9999-999999999999', 'other@test.local');

-- aaaa: A işletmesi. eeee: B işletmesi.
insert into public.organizations (id, name, country_code, currency, created_by) values
  ('aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaaa', 'Petek Arıcılık', 'TR', 'TRY',
   '33333333-3333-3333-3333-333333333333'),
  ('eeeeeeee-eeee-eeee-eeee-eeeeeeeeeeee', 'Başka İşletme', 'DE', 'EUR',
   '99999999-9999-9999-9999-999999999999');

insert into public.memberships (id, org_id, user_id, role) values
  ('c0000000-0000-0000-0000-000000000003', 'aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaaa',
   '33333333-3333-3333-3333-333333333333', 'worker'),
  ('c0000000-0000-0000-0000-000000000005', 'aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaaa',
   '55555555-5555-5555-5555-555555555555', 'viewer'),
  ('c0000000-0000-0000-0000-000000000009', 'eeeeeeee-eeee-eeee-eeee-eeeeeeeeeeee',
   '99999999-9999-9999-9999-999999999999', 'owner');

-- Önek a1/e1 arılık, a3/e3 kovan, ad/ed işletme ilacı, a9/e9 uygulama.
insert into public.apiaries (id, org_id, name) values
  ('a1000000-0000-0000-0000-000000000001', 'aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaaa', 'Yayla'),
  ('e1000000-0000-0000-0000-000000000001', 'eeeeeeee-eeee-eeee-eeee-eeeeeeeeeeee', 'Ova');

insert into public.hives (id, org_id, number, type, apiary_id) values
  ('a3000000-0000-0000-0000-000000000001', 'aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaaa',
   '101', 'langstroth', 'a1000000-0000-0000-0000-000000000001'),
  ('e3000000-0000-0000-0000-000000000001', 'eeeeeeee-eeee-eeee-eeee-eeeeeeeeeeee',
   '101', 'dadant', 'e1000000-0000-0000-0000-000000000001');

insert into public.drugs (id, org_id, name, active_ingredient, dose_unit, withdrawal_days) values
  ('ad000000-0000-0000-0000-000000000001', 'aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaaa',
   'Kendi timol jelim', 'thymol', 'g', 0),
  ('ed000000-0000-0000-0000-000000000001', 'eeeeeeee-eeee-eeee-eeee-eeeeeeeeeeee',
   'Oxalsäure', 'oxalic_acid', 'ml', null);

insert into public.treatments (id, org_id, hive_id, apiary_id, drug_id, product_name,
                               active_ingredient, dose, dose_unit, started_at, withdrawal_days) values
  ('a9000000-0000-0000-0000-000000000001', 'aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaaa',
   'a3000000-0000-0000-0000-000000000001', 'a1000000-0000-0000-0000-000000000001',
   'ad000000-0000-0000-0000-000000000001', 'Kendi timol jelim', 'thymol', 25, 'g', now(), 0),
  ('e9000000-0000-0000-0000-000000000001', 'eeeeeeee-eeee-eeee-eeee-eeeeeeeeeeee',
   'e3000000-0000-0000-0000-000000000001', 'e1000000-0000-0000-0000-000000000001',
   'ed000000-0000-0000-0000-000000000001', 'Oxalsäure', 'oxalic_acid', 5, 'ml', now(), 0);

set local role authenticated;

-- B'nin owner'ı
set local request.jwt.claims = '{"sub": "99999999-9999-9999-9999-999999999999"}';

select ok(
  (select count(*) from public.ref_drugs where country_code = 'GLOBAL') > 0
    and (select count(*) from public.ref_drugs where country_code = 'TR') > 0,
  'girişli kullanıcı referans listenin GLOBAL ve TR satırlarını görür'
);

select throws_ok(
  $$insert into public.ref_drugs (id, country_code, name_tr, name_en, active_ingredient, dose_unit)
    values ('01900000-0000-7000-8000-0000000000ff', 'GLOBAL', 'Sahte', 'Fake', 'other', 'dose')$$,
  '42501',
  null,
  'referans listeye kimse ekleyemez'
);

select is_empty(
  $$update public.ref_drugs set withdrawal_days = 0 returning id$$,
  'referans listeyi kimse güncelleyemez'
);

select results_eq(
  'select id from public.drugs',
  $$values ('ed000000-0000-0000-0000-000000000001'::uuid)$$,
  'başka işletmenin ilaçlarını göremez, yalnız kendisininkini görür'
);

select results_eq(
  'select id from public.treatments',
  $$values ('e9000000-0000-0000-0000-000000000001'::uuid)$$,
  'başka işletmenin uygulamalarını göremez, yalnız kendisininkini görür'
);

select throws_ok(
  $$insert into public.drugs (id, org_id, name, active_ingredient, dose_unit)
    values ('ed000000-0000-0000-0000-000000000002', 'aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaaa',
            'Sızma', 'other', 'dose')$$,
  '42501',
  null,
  'başka işletmeye ilaç ekleyemez'
);

select throws_ok(
  $$insert into public.treatments (id, org_id, hive_id, apiary_id, ref_drug_id, product_name,
                                   active_ingredient, dose, dose_unit, started_at, withdrawal_days)
    values ('e9000000-0000-0000-0000-000000000002', 'aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaaa',
            'a3000000-0000-0000-0000-000000000001', 'a1000000-0000-0000-0000-000000000001',
            '01900000-0000-7000-8000-000000000001', 'Amitraz', 'amitraz', 2, 'strip', now(), 0)$$,
  '42501',
  null,
  'başka işletmeye uygulama ekleyemez'
);

select is_empty(
  $$update public.treatments set deleted_at = now()
    where id = 'a9000000-0000-0000-0000-000000000001' returning id$$,
  'başka işletmenin uygulamasını silemez'
);

select throws_ok(
  $$insert into public.treatments (id, org_id, hive_id, apiary_id, ref_drug_id, product_name,
                                   active_ingredient, dose, dose_unit, started_at, withdrawal_days)
    values ('e9000000-0000-0000-0000-000000000003', 'eeeeeeee-eeee-eeee-eeee-eeeeeeeeeeee',
            'a3000000-0000-0000-0000-000000000001', 'e1000000-0000-0000-0000-000000000001',
            '01900000-0000-7000-8000-000000000001', 'Amitraz', 'amitraz', 2, 'strip', now(), 0)$$,
  '23503',
  null,
  'kendi uygulamasını başka işletmenin kovanına bağlayamaz'
);

select throws_ok(
  $$insert into public.treatments (id, org_id, hive_id, apiary_id, drug_id, product_name,
                                   active_ingredient, dose, dose_unit, started_at, withdrawal_days)
    values ('e9000000-0000-0000-0000-000000000004', 'eeeeeeee-eeee-eeee-eeee-eeeeeeeeeeee',
            'e3000000-0000-0000-0000-000000000001', 'e1000000-0000-0000-0000-000000000001',
            'ad000000-0000-0000-0000-000000000001', 'Kendi timol jelim', 'thymol', 25, 'g', now(), 0)$$,
  '23503',
  null,
  'kendi uygulamasını başka işletmenin ilacına bağlayamaz'
);

-- A'nın worker'ı
set local request.jwt.claims = '{"sub": "33333333-3333-3333-3333-333333333333"}';

select lives_ok(
  $$insert into public.treatments (id, org_id, hive_id, apiary_id, ref_drug_id, product_name,
                                   active_ingredient, batch_no, dose, dose_unit, started_at,
                                   planned_removal_at, withdrawal_days)
    values ('a9000000-0000-0000-0000-000000000002', 'aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaaa',
            'a3000000-0000-0000-0000-000000000001', 'a1000000-0000-0000-0000-000000000001',
            '01900000-0000-7000-8000-000000000101', 'Amitraz şerit', 'amitraz', '24-118',
            2, 'strip', '2026-10-24', '2026-12-05', 0)$$,
  'worker referans listeden ilaçla uygulama ekler'
);

select lives_ok(
  $$insert into public.drugs (id, org_id, name, active_ingredient, dose_unit, withdrawal_days)
    values ('ad000000-0000-0000-0000-000000000002', 'aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaaa',
            'Formik şerit', 'formic_acid', 'strip', 7)$$,
  'worker ilaç ekler'
);

select throws_ok(
  $$insert into public.treatments (id, org_id, hive_id, apiary_id, ref_drug_id, drug_id, product_name,
                                   active_ingredient, dose, dose_unit, started_at, withdrawal_days)
    values ('a9000000-0000-0000-0000-000000000003', 'aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaaa',
            'a3000000-0000-0000-0000-000000000001', 'a1000000-0000-0000-0000-000000000001',
            '01900000-0000-7000-8000-000000000001', 'ad000000-0000-0000-0000-000000000001',
            'Amitraz', 'amitraz', 2, 'strip', now(), 0)$$,
  '23514',
  null,
  'uygulamanın ilacı iki listeden birden gelemez'
);

select throws_ok(
  $$insert into public.treatments (id, org_id, hive_id, apiary_id, product_name,
                                   active_ingredient, dose, dose_unit, started_at, withdrawal_days)
    values ('a9000000-0000-0000-0000-000000000004', 'aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaaa',
            'a3000000-0000-0000-0000-000000000001', 'a1000000-0000-0000-0000-000000000001',
            'Amitraz', 'amitraz', 2, 'strip', now(), 0)$$,
  '23514',
  null,
  'uygulamanın ilacı boş olamaz'
);

select throws_ok(
  $$insert into public.treatments (id, org_id, hive_id, apiary_id, ref_drug_id, product_name,
                                   active_ingredient, dose, dose_unit, started_at,
                                   planned_removal_at, withdrawal_days)
    values ('a9000000-0000-0000-0000-000000000005', 'aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaaa',
            'a3000000-0000-0000-0000-000000000001', 'a1000000-0000-0000-0000-000000000001',
            '01900000-0000-7000-8000-000000000001', 'Amitraz', 'amitraz', 2, 'strip',
            '2026-10-24', '2026-10-01', 0)$$,
  '23514',
  null,
  'planlanan çıkarma başlangıçtan önce olamaz'
);

select throws_ok(
  $$insert into public.treatments (id, org_id, hive_id, apiary_id, ref_drug_id, product_name,
                                   active_ingredient, dose, dose_unit, started_at, withdrawal_days)
    values ('a9000000-0000-0000-0000-000000000006', 'aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaaa',
            'a3000000-0000-0000-0000-000000000001', 'a1000000-0000-0000-0000-000000000001',
            '01900000-0000-7000-8000-000000000001', 'Amitraz', 'amitraz', 0, 'strip', now(), 0)$$,
  '23514',
  null,
  'doz sıfır olamaz'
);

select throws_ok(
  $$insert into public.treatments (id, org_id, hive_id, apiary_id, ref_drug_id, product_name,
                                   active_ingredient, dose, dose_unit, started_at, withdrawal_days)
    values ('a9000000-0000-0000-0000-000000000007', 'aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaaa',
            'a3000000-0000-0000-0000-000000000001', 'a1000000-0000-0000-0000-000000000001',
            '01900000-0000-7000-8000-000000000001', 'Amitraz', 'amitraz', 2, 'strip', now(), -1)$$,
  '23514',
  null,
  'bekleme süresi negatif olamaz'
);

select results_eq(
  $$select r ->> 'status', r ->> 'applied'
    from jsonb_array_elements(public.sync_push(
      $j$[{"id": 1, "table": "drugs", "operation": "upsert", "payload": {
        "id": "ad000000-0000-0000-0000-000000000003",
        "org_id": "aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaaa",
        "name": "Laktik sprey", "active_ingredient": "lactic_acid",
        "dose_unit": "ml", "withdrawal_days": null, "license_no": null,
        "created_at": "2026-10-25T09:00:00.000Z",
        "updated_at": "2026-10-25T09:00:00.000Z",
        "created_by": null, "deleted_at": null}},
       {"id": 2, "table": "treatments", "operation": "upsert", "payload": {
        "id": "a9000000-0000-0000-0000-000000000008",
        "org_id": "aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaaa",
        "hive_id": "a3000000-0000-0000-0000-000000000001",
        "apiary_id": "a1000000-0000-0000-0000-000000000001",
        "ref_drug_id": null, "drug_id": "ad000000-0000-0000-0000-000000000003",
        "product_name": "Laktik sprey", "active_ingredient": "lactic_acid",
        "batch_no": "L-7", "dose": 8.5, "dose_unit": "ml",
        "started_at": "2026-10-25T09:00:00.000Z", "planned_removal_at": null,
        "withdrawal_days": 0,
        "created_at": "2026-10-25T09:00:00.000Z",
        "updated_at": "2026-10-25T09:00:00.000Z",
        "created_by": null, "deleted_at": null}}]$j$::jsonb,
      now(), 5) -> 'results') r$$,
  $$values ('ok', 'true'), ('ok', 'true')$$,
  'sync_push ilacı ve ona bağlı uygulamayı şema sürümü 5 ile yazar'
);

select results_eq(
  $$select r ->> 'status', r ->> 'applied'
    from jsonb_array_elements(public.sync_push(
      $j$[{"id": 1, "table": "treatments", "operation": "delete", "payload": {
        "id": "a9000000-0000-0000-0000-000000000008",
        "org_id": "aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaaa",
        "hive_id": "a3000000-0000-0000-0000-000000000001",
        "apiary_id": "a1000000-0000-0000-0000-000000000001",
        "ref_drug_id": null, "drug_id": "ad000000-0000-0000-0000-000000000003",
        "product_name": "Değişti", "active_ingredient": "lactic_acid",
        "batch_no": "L-7", "dose": 1, "dose_unit": "ml",
        "started_at": "2026-10-25T09:00:00.000Z", "planned_removal_at": null,
        "withdrawal_days": 0,
        "created_at": "2026-10-25T09:00:00.000Z",
        "updated_at": "2026-10-25T09:05:00.000Z",
        "created_by": null, "deleted_at": "2026-10-25T09:05:00.000Z"}}]$j$::jsonb,
      now(), 5) -> 'results') r$$,
  $$values ('ok', 'true')$$,
  'sync_push uygulamanın silinmesini işler'
);

select results_eq(
  $$select product_name, dose, deleted_at is not null from public.treatments
    where id = 'a9000000-0000-0000-0000-000000000008'$$,
  $$values ('Laktik sprey'::text, 8.5::numeric(8, 2), true)$$,
  'olay kaydı: silme yalnız deleted_at yazar, diğer alanlar değişmez'
);

select results_eq(
  $$select r ->> 'status', r ->> 'reason'
    from jsonb_array_elements(public.sync_push(
      $j$[{"id": 1, "table": "ref_drugs", "operation": "upsert", "payload": {
        "id": "01900000-0000-7000-8000-000000000001",
        "country_code": "GLOBAL", "name_tr": "Sahte", "name_en": "Fake",
        "active_ingredient": "amitraz", "dose_unit": "strip",
        "withdrawal_days": 0, "license_no": null,
        "created_at": "2026-10-25T09:00:00.000Z",
        "updated_at": "2099-01-01T00:00:00.000Z",
        "created_by": null, "deleted_at": null}}]$j$::jsonb,
      now(), 5) -> 'results') r$$,
  $$values ('rejected', 'unsupported')$$,
  'sync_push referans listeye yazmaz'
);

-- A'nın viewer'ı
set local request.jwt.claims = '{"sub": "55555555-5555-5555-5555-555555555555"}';

select throws_ok(
  $$insert into public.treatments (id, org_id, hive_id, apiary_id, ref_drug_id, product_name,
                                   active_ingredient, dose, dose_unit, started_at, withdrawal_days)
    values ('a9000000-0000-0000-0000-000000000009', 'aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaaa',
            'a3000000-0000-0000-0000-000000000001', 'a1000000-0000-0000-0000-000000000001',
            '01900000-0000-7000-8000-000000000001', 'Amitraz', 'amitraz', 2, 'strip', now(), 0)$$,
  '42501',
  null,
  'viewer uygulama ekleyemez, ama işletmenin uygulamalarını görür'
);

select * from finish();
rollback;
