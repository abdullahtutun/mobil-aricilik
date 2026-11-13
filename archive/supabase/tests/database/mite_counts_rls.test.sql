-- mite_counts RLS ve tutarlılık: başka işletmenin ölçümü görünmez ve
-- yazılamaz; worker yazar, viewer yalnız okur; işletmeler arası bağ
-- reddedilir; yönteme göre örnek arı ya da gün zorunlu; sync_push ölçümü
-- şema sürümü 4 ile olay kaydı olarak yazar.
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

select plan(14);

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

-- Önek a1/e1 arılık, a3/e3 kovan, a8/e8 varroa ölçümü.
insert into public.apiaries (id, org_id, name) values
  ('a1000000-0000-0000-0000-000000000001', 'aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaaa', 'Yayla'),
  ('e1000000-0000-0000-0000-000000000001', 'eeeeeeee-eeee-eeee-eeee-eeeeeeeeeeee', 'Ova');

insert into public.hives (id, org_id, number, type, apiary_id) values
  ('a3000000-0000-0000-0000-000000000001', 'aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaaa',
   '101', 'langstroth', 'a1000000-0000-0000-0000-000000000001'),
  ('e3000000-0000-0000-0000-000000000001', 'eeeeeeee-eeee-eeee-eeee-eeeeeeeeeeee',
   '101', 'dadant', 'e1000000-0000-0000-0000-000000000001');

insert into public.mite_counts (id, org_id, hive_id, apiary_id, counted_at, method, mites, sample_bees) values
  ('a8000000-0000-0000-0000-000000000001', 'aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaaa',
   'a3000000-0000-0000-0000-000000000001', 'a1000000-0000-0000-0000-000000000001',
   now(), 'sugar_roll', 9, 300),
  ('e8000000-0000-0000-0000-000000000001', 'eeeeeeee-eeee-eeee-eeee-eeeeeeeeeeee',
   'e3000000-0000-0000-0000-000000000001', 'e1000000-0000-0000-0000-000000000001',
   now(), 'alcohol_wash', 4, 300);

set local role authenticated;

-- B'nin owner'ı
set local request.jwt.claims = '{"sub": "99999999-9999-9999-9999-999999999999"}';

select results_eq(
  'select id from public.mite_counts',
  $$values ('e8000000-0000-0000-0000-000000000001'::uuid)$$,
  'başka işletmenin ölçümünü göremez, yalnız kendisininkini görür'
);

select throws_ok(
  $$insert into public.mite_counts (id, org_id, hive_id, apiary_id, counted_at, method, mites, sample_bees)
    values ('e8000000-0000-0000-0000-000000000002', 'aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaaa',
            'a3000000-0000-0000-0000-000000000001', 'a1000000-0000-0000-0000-000000000001',
            now(), 'sugar_roll', 1, 300)$$,
  '42501',
  null,
  'başka işletmeye ölçüm ekleyemez'
);

select is_empty(
  $$update public.mite_counts set deleted_at = now()
    where id = 'a8000000-0000-0000-0000-000000000001' returning id$$,
  'başka işletmenin ölçümünü silemez'
);

select throws_ok(
  $$insert into public.mite_counts (id, org_id, hive_id, apiary_id, counted_at, method, mites, sample_bees)
    values ('e8000000-0000-0000-0000-000000000003', 'eeeeeeee-eeee-eeee-eeee-eeeeeeeeeeee',
            'a3000000-0000-0000-0000-000000000001', 'e1000000-0000-0000-0000-000000000001',
            now(), 'sugar_roll', 1, 300)$$,
  '23503',
  null,
  'kendi ölçümünü başka işletmenin kovanına bağlayamaz'
);

select throws_ok(
  $$insert into public.mite_counts (id, org_id, hive_id, apiary_id, counted_at, method, mites, sample_bees)
    values ('e8000000-0000-0000-0000-000000000004', 'eeeeeeee-eeee-eeee-eeee-eeeeeeeeeeee',
            'e3000000-0000-0000-0000-000000000001', 'a1000000-0000-0000-0000-000000000001',
            now(), 'sugar_roll', 1, 300)$$,
  '23503',
  null,
  'kendi ölçümünü başka işletmenin arılığına bağlayamaz'
);

-- A'nın worker'ı
set local request.jwt.claims = '{"sub": "33333333-3333-3333-3333-333333333333"}';

select lives_ok(
  $$insert into public.mite_counts (id, org_id, hive_id, apiary_id, counted_at, method, mites, sample_bees)
    values ('a8000000-0000-0000-0000-000000000002', 'aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaaa',
            'a3000000-0000-0000-0000-000000000001', 'a1000000-0000-0000-0000-000000000001',
            now(), 'alcohol_wash', 6, 300)$$,
  'worker alkol yıkaması ekler'
);

select lives_ok(
  $$insert into public.mite_counts (id, org_id, hive_id, apiary_id, counted_at, method, mites, days)
    values ('a8000000-0000-0000-0000-000000000003', 'aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaaa',
            'a3000000-0000-0000-0000-000000000001', 'a1000000-0000-0000-0000-000000000001',
            now(), 'sticky_board', 30, 3)$$,
  'worker alt tabla sayımı ekler'
);

select throws_ok(
  $$insert into public.mite_counts (id, org_id, hive_id, apiary_id, counted_at, method, mites)
    values ('a8000000-0000-0000-0000-000000000004', 'aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaaa',
            'a3000000-0000-0000-0000-000000000001', 'a1000000-0000-0000-0000-000000000001',
            now(), 'sugar_roll', 6)$$,
  '23514',
  null,
  'pudra şekerinde örnek arı sayısı zorunlu'
);

select throws_ok(
  $$insert into public.mite_counts (id, org_id, hive_id, apiary_id, counted_at, method, mites, sample_bees)
    values ('a8000000-0000-0000-0000-000000000005', 'aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaaa',
            'a3000000-0000-0000-0000-000000000001', 'a1000000-0000-0000-0000-000000000001',
            now(), 'sticky_board', 6, 300)$$,
  '23514',
  null,
  'alt tablada örnek arı olmaz, gün zorunlu'
);

select throws_ok(
  $$insert into public.mite_counts (id, org_id, hive_id, apiary_id, counted_at, method, mites, sample_bees)
    values ('a8000000-0000-0000-0000-000000000006', 'aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaaa',
            'a3000000-0000-0000-0000-000000000001', 'a1000000-0000-0000-0000-000000000001',
            now(), 'sugar_roll', -1, 300)$$,
  '23514',
  null,
  'akar sayısı negatif olamaz'
);

select results_eq(
  $$select r ->> 'status', r ->> 'applied'
    from jsonb_array_elements(public.sync_push(
      $j$[{"id": 1, "table": "mite_counts", "operation": "upsert", "payload": {
        "id": "a8000000-0000-0000-0000-000000000007",
        "org_id": "aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaaa",
        "hive_id": "a3000000-0000-0000-0000-000000000001",
        "apiary_id": "a1000000-0000-0000-0000-000000000001",
        "counted_at": "2026-10-25T09:00:00.000Z", "method": "sugar_roll",
        "mites": 9, "sample_bees": 300, "days": null,
        "created_at": "2026-10-25T09:00:00.000Z",
        "updated_at": "2026-10-25T09:00:00.000Z",
        "created_by": null, "deleted_at": null}}]$j$::jsonb,
      now(), 4) -> 'results') r$$,
  $$values ('ok', 'true')$$,
  'sync_push ölçümü şema sürümü 4 ile yazar'
);

select results_eq(
  $$select r ->> 'status', r ->> 'applied'
    from jsonb_array_elements(public.sync_push(
      $j$[{"id": 1, "table": "mite_counts", "operation": "delete", "payload": {
        "id": "a8000000-0000-0000-0000-000000000007",
        "org_id": "aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaaa",
        "hive_id": "a3000000-0000-0000-0000-000000000001",
        "apiary_id": "a1000000-0000-0000-0000-000000000001",
        "counted_at": "2026-10-25T09:00:00.000Z", "method": "sugar_roll",
        "mites": 1, "sample_bees": 300, "days": null,
        "created_at": "2026-10-25T09:00:00.000Z",
        "updated_at": "2026-10-25T09:05:00.000Z",
        "created_by": null, "deleted_at": "2026-10-25T09:05:00.000Z"}}]$j$::jsonb,
      now(), 4) -> 'results') r$$,
  $$values ('ok', 'true')$$,
  'sync_push ölçümün silinmesini işler'
);

select results_eq(
  $$select mites, deleted_at is not null from public.mite_counts
    where id = 'a8000000-0000-0000-0000-000000000007'$$,
  $$values (9, true)$$,
  'olay kaydı: silme yalnız deleted_at yazar, diğer alanlar değişmez'
);

-- A'nın viewer'ı
set local request.jwt.claims = '{"sub": "55555555-5555-5555-5555-555555555555"}';

select throws_ok(
  $$insert into public.mite_counts (id, org_id, hive_id, apiary_id, counted_at, method, mites, sample_bees)
    values ('a8000000-0000-0000-0000-000000000008', 'aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaaa',
            'a3000000-0000-0000-0000-000000000001', 'a1000000-0000-0000-0000-000000000001',
            now(), 'sugar_roll', 1, 300)$$,
  '42501',
  null,
  'viewer ölçüm ekleyemez, ama işletmenin ölçümlerini görür'
);

select * from finish();
rollback;
