-- harvests ve harvest_hives RLS ve tutarlılık: başka işletmenin hasadı
-- görünmez ve yazılamaz; worker yazar, viewer yalnız okur; işletmeler arası
-- bağ reddedilir; miktarlar sınırlı; bekleme süresi gerekçesi uygulamayla
-- birlikte; kovan bir hasatta bir kez; sync_push iki tabloyu şema sürümü 9
-- ile olay kaydı olarak yazar.
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

select plan(19);

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

-- Önek a1/e1 arılık, a3/e3 kovan, a9/e9 uygulama, a7/e7 hasat, a8/e8 hasat
-- kovanı.
insert into public.apiaries (id, org_id, name) values
  ('a1000000-0000-0000-0000-000000000001', 'aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaaa', 'Yayla'),
  ('e1000000-0000-0000-0000-000000000001', 'eeeeeeee-eeee-eeee-eeee-eeeeeeeeeeee', 'Ova');

insert into public.hives (id, org_id, number, type, apiary_id) values
  ('a3000000-0000-0000-0000-000000000001', 'aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaaa',
   '101', 'langstroth', 'a1000000-0000-0000-0000-000000000001'),
  ('a3000000-0000-0000-0000-000000000002', 'aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaaa',
   '102', 'langstroth', 'a1000000-0000-0000-0000-000000000001'),
  ('e3000000-0000-0000-0000-000000000001', 'eeeeeeee-eeee-eeee-eeee-eeeeeeeeeeee',
   '101', 'dadant', 'e1000000-0000-0000-0000-000000000001'),
  ('e3000000-0000-0000-0000-000000000002', 'eeeeeeee-eeee-eeee-eeee-eeeeeeeeeeee',
   '102', 'dadant', 'e1000000-0000-0000-0000-000000000001');

insert into public.treatments (id, org_id, hive_id, apiary_id, ref_drug_id, product_name,
                               active_ingredient, dose, dose_unit, started_at, withdrawal_days) values
  ('a9000000-0000-0000-0000-000000000001', 'aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaaa',
   'a3000000-0000-0000-0000-000000000001', 'a1000000-0000-0000-0000-000000000001',
   (select id from public.ref_drugs order by id limit 1), 'Amitraz şerit', 'amitraz',
   2, 'strip', now(), 14),
  ('e9000000-0000-0000-0000-000000000001', 'eeeeeeee-eeee-eeee-eeee-eeeeeeeeeeee',
   'e3000000-0000-0000-0000-000000000001', 'e1000000-0000-0000-0000-000000000001',
   (select id from public.ref_drugs order by id limit 1), 'Amitraz şerit', 'amitraz',
   2, 'strip', now(), 14);

insert into public.harvests (id, org_id, apiary_id, harvested_at, honey_kind, unit, unit_count, net_kg) values
  ('a7000000-0000-0000-0000-000000000001', 'aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaaa',
   'a1000000-0000-0000-0000-000000000001', now(), 'pine', 'super', 24, 574),
  ('e7000000-0000-0000-0000-000000000001', 'eeeeeeee-eeee-eeee-eeee-eeeeeeeeeeee',
   'e1000000-0000-0000-0000-000000000001', now(), 'flower', 'frame', 10, 20.5);

insert into public.harvest_hives (id, org_id, harvest_id, hive_id) values
  ('a8000000-0000-0000-0000-000000000001', 'aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaaa',
   'a7000000-0000-0000-0000-000000000001', 'a3000000-0000-0000-0000-000000000002'),
  ('e8000000-0000-0000-0000-000000000001', 'eeeeeeee-eeee-eeee-eeee-eeeeeeeeeeee',
   'e7000000-0000-0000-0000-000000000001', 'e3000000-0000-0000-0000-000000000001');

set local role authenticated;

-- B'nin owner'ı
set local request.jwt.claims = '{"sub": "99999999-9999-9999-9999-999999999999"}';

select results_eq(
  'select id from public.harvests',
  $$values ('e7000000-0000-0000-0000-000000000001'::uuid)$$,
  'başka işletmenin hasadını göremez, yalnız kendisininkini görür'
);

select results_eq(
  'select id from public.harvest_hives',
  $$values ('e8000000-0000-0000-0000-000000000001'::uuid)$$,
  'başka işletmenin hasat kovanlarını göremez'
);

select throws_ok(
  $$insert into public.harvests (id, org_id, apiary_id, harvested_at, honey_kind, unit, unit_count, net_kg)
    values ('e7000000-0000-0000-0000-000000000002', 'aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaaa',
            'a1000000-0000-0000-0000-000000000001', now(), 'pine', 'super', 1, 10)$$,
  '42501',
  null,
  'başka işletmeye hasat ekleyemez'
);

select is_empty(
  $$update public.harvests set deleted_at = now()
    where id = 'a7000000-0000-0000-0000-000000000001' returning id$$,
  'başka işletmenin hasadını silemez'
);

select throws_ok(
  $$insert into public.harvests (id, org_id, apiary_id, harvested_at, honey_kind, unit, unit_count, net_kg)
    values ('e7000000-0000-0000-0000-000000000003', 'eeeeeeee-eeee-eeee-eeee-eeeeeeeeeeee',
            'a1000000-0000-0000-0000-000000000001', now(), 'pine', 'super', 1, 10)$$,
  '23503',
  null,
  'kendi hasadını başka işletmenin arılığına bağlayamaz'
);

select throws_ok(
  $$insert into public.harvest_hives (id, org_id, harvest_id, hive_id)
    values ('e8000000-0000-0000-0000-000000000002', 'eeeeeeee-eeee-eeee-eeee-eeeeeeeeeeee',
            'e7000000-0000-0000-0000-000000000001', 'a3000000-0000-0000-0000-000000000001')$$,
  '23503',
  null,
  'kendi hasadına başka işletmenin kovanını bağlayamaz'
);

select throws_ok(
  $$insert into public.harvest_hives (id, org_id, harvest_id, hive_id)
    values ('e8000000-0000-0000-0000-000000000003', 'eeeeeeee-eeee-eeee-eeee-eeeeeeeeeeee',
            'a7000000-0000-0000-0000-000000000001', 'e3000000-0000-0000-0000-000000000001')$$,
  '23503',
  null,
  'kendi kovanını başka işletmenin hasadına bağlayamaz'
);

select throws_ok(
  $$insert into public.harvest_hives (id, org_id, harvest_id, hive_id,
                                      withdrawal_treatment_id, withdrawal_override_reason)
    values ('e8000000-0000-0000-0000-000000000004', 'eeeeeeee-eeee-eeee-eeee-eeeeeeeeeeee',
            'e7000000-0000-0000-0000-000000000001', 'e3000000-0000-0000-0000-000000000002',
            'a9000000-0000-0000-0000-000000000001', 'not_for_sale')$$,
  '23503',
  null,
  'gerekçeyi başka işletmenin uygulamasına bağlayamaz'
);

-- A'nın worker'ı
set local request.jwt.claims = '{"sub": "33333333-3333-3333-3333-333333333333"}';

select lives_ok(
  $$insert into public.harvests (id, org_id, apiary_id, harvested_at, honey_kind, unit, unit_count, net_kg)
    values ('a7000000-0000-0000-0000-000000000002', 'aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaaa',
            'a1000000-0000-0000-0000-000000000001', now(), 'chestnut', 'frame', 9, 12.25)$$,
  'worker hasat ekler'
);

select lives_ok(
  $$insert into public.harvest_hives (id, org_id, harvest_id, hive_id,
                                      withdrawal_treatment_id, withdrawal_override_reason)
    values ('a8000000-0000-0000-0000-000000000002', 'aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaaa',
            'a7000000-0000-0000-0000-000000000002', 'a3000000-0000-0000-0000-000000000001',
            'a9000000-0000-0000-0000-000000000001', 'removed_early')$$,
  'worker bekleme süresindeki kovanı gerekçesiyle hasada ekler'
);

select throws_ok(
  $$insert into public.harvest_hives (id, org_id, harvest_id, hive_id, withdrawal_override_reason)
    values ('a8000000-0000-0000-0000-000000000003', 'aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaaa',
            'a7000000-0000-0000-0000-000000000002', 'a3000000-0000-0000-0000-000000000002',
            'not_for_sale')$$,
  '23514',
  null,
  'gerekçe uygulamasız yazılamaz'
);

select throws_ok(
  $$insert into public.harvest_hives (id, org_id, harvest_id, hive_id)
    values ('a8000000-0000-0000-0000-000000000004', 'aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaaa',
            'a7000000-0000-0000-0000-000000000002', 'a3000000-0000-0000-0000-000000000001')$$,
  '23505',
  null,
  'kovan aynı hasada iki kez eklenemez'
);

select throws_ok(
  $$insert into public.harvests (id, org_id, apiary_id, harvested_at, honey_kind, unit, unit_count, net_kg)
    values ('a7000000-0000-0000-0000-000000000003', 'aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaaa',
            'a1000000-0000-0000-0000-000000000001', now(), 'pine', 'super', 1, 0)$$,
  '23514',
  null,
  'süzülen bal sıfır olamaz'
);

select throws_ok(
  $$insert into public.harvests (id, org_id, apiary_id, harvested_at, honey_kind, unit, unit_count, net_kg)
    values ('a7000000-0000-0000-0000-000000000004', 'aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaaa',
            'a1000000-0000-0000-0000-000000000001', now(), 'pine', 'super', 0, 10)$$,
  '23514',
  null,
  'kat ya da çerçeve sayısı en az 1'
);

select results_eq(
  $$select r ->> 'status', r ->> 'applied'
    from jsonb_array_elements(public.sync_push(
      $j$[{"id": 1, "table": "harvests", "operation": "upsert", "payload": {
        "id": "a7000000-0000-0000-0000-000000000005",
        "org_id": "aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaaa",
        "apiary_id": "a1000000-0000-0000-0000-000000000001",
        "harvested_at": "2026-10-26T09:00:00.000Z", "honey_kind": "citrus",
        "unit": "super", "unit_count": 3, "net_kg": 45.359,
        "created_at": "2026-10-26T09:00:00.000Z",
        "updated_at": "2026-10-26T09:00:00.000Z",
        "created_by": null, "deleted_at": null}},
       {"id": 2, "table": "harvest_hives", "operation": "upsert", "payload": {
        "id": "a8000000-0000-0000-0000-000000000005",
        "org_id": "aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaaa",
        "harvest_id": "a7000000-0000-0000-0000-000000000005",
        "hive_id": "a3000000-0000-0000-0000-000000000002",
        "withdrawal_treatment_id": null, "withdrawal_override_reason": null,
        "created_at": "2026-10-26T09:00:00.000Z",
        "updated_at": "2026-10-26T09:00:00.000Z",
        "created_by": null, "deleted_at": null}}]$j$::jsonb,
      now(), 9) -> 'results') r$$,
  $$values ('ok', 'true'), ('ok', 'true')$$,
  'sync_push hasadı ve kovanını şema sürümü 9 ile yazar'
);

select results_eq(
  $$select r ->> 'status', r ->> 'applied'
    from jsonb_array_elements(public.sync_push(
      $j$[{"id": 1, "table": "harvests", "operation": "delete", "payload": {
        "id": "a7000000-0000-0000-0000-000000000005",
        "org_id": "aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaaa",
        "apiary_id": "a1000000-0000-0000-0000-000000000001",
        "harvested_at": "2026-10-26T09:00:00.000Z", "honey_kind": "pine",
        "unit": "super", "unit_count": 1, "net_kg": 1,
        "created_at": "2026-10-26T09:00:00.000Z",
        "updated_at": "2026-10-26T09:05:00.000Z",
        "created_by": null, "deleted_at": "2026-10-26T09:05:00.000Z"}}]$j$::jsonb,
      now(), 9) -> 'results') r$$,
  $$values ('ok', 'true')$$,
  'sync_push hasadın silinmesini işler'
);

select results_eq(
  $$select honey_kind::text, net_kg, deleted_at is not null from public.harvests
    where id = 'a7000000-0000-0000-0000-000000000005'$$,
  $$values ('citrus', 45.359::numeric, true)$$,
  'olay kaydı: silme yalnız deleted_at yazar, diğer alanlar değişmez'
);

-- A'nın viewer'ı
set local request.jwt.claims = '{"sub": "55555555-5555-5555-5555-555555555555"}';

select throws_ok(
  $$insert into public.harvests (id, org_id, apiary_id, harvested_at, honey_kind, unit, unit_count, net_kg)
    values ('a7000000-0000-0000-0000-000000000006', 'aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaaa',
            'a1000000-0000-0000-0000-000000000001', now(), 'pine', 'super', 1, 10)$$,
  '42501',
  null,
  'viewer hasat ekleyemez'
);

select throws_ok(
  $$insert into public.harvest_hives (id, org_id, harvest_id, hive_id)
    values ('a8000000-0000-0000-0000-000000000006', 'aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaaa',
            'a7000000-0000-0000-0000-000000000001', 'a3000000-0000-0000-0000-000000000001')$$,
  '42501',
  null,
  'viewer hasada kovan ekleyemez, ama işletmenin hasatlarını görür'
);

select * from finish();
rollback;
