-- feedings RLS ve tutarlılık: başka işletmenin beslemesi görünmez ve
-- yazılamaz; worker yazar, viewer yalnız okur; işletmeler arası bağ
-- reddedilir; miktar pozitif ve sınırlı; sync_push beslemeyi şema sürümü 7
-- ile olay kaydı olarak yazar.
begin;
create extension if not exists pgtap with schema extensions;
select plan(13);

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

-- Önek a1/e1 arılık, a3/e3 kovan, af/ef besleme, b0 besleme grubu.
insert into public.apiaries (id, org_id, name) values
  ('a1000000-0000-0000-0000-000000000001', 'aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaaa', 'Yayla'),
  ('e1000000-0000-0000-0000-000000000001', 'eeeeeeee-eeee-eeee-eeee-eeeeeeeeeeee', 'Ova');

insert into public.hives (id, org_id, number, type, apiary_id) values
  ('a3000000-0000-0000-0000-000000000001', 'aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaaa',
   '101', 'langstroth', 'a1000000-0000-0000-0000-000000000001'),
  ('e3000000-0000-0000-0000-000000000001', 'eeeeeeee-eeee-eeee-eeee-eeeeeeeeeeee',
   '101', 'dadant', 'e1000000-0000-0000-0000-000000000001');

insert into public.feedings (id, org_id, hive_id, apiary_id, feeding_group_id, fed_at, kind, amount) values
  ('af000000-0000-0000-0000-000000000001', 'aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaaa',
   'a3000000-0000-0000-0000-000000000001', 'a1000000-0000-0000-0000-000000000001',
   'b0000000-0000-0000-0000-000000000001', now(), 'syrup_2_1', 3),
  ('ef000000-0000-0000-0000-000000000001', 'eeeeeeee-eeee-eeee-eeee-eeeeeeeeeeee',
   'e3000000-0000-0000-0000-000000000001', 'e1000000-0000-0000-0000-000000000001',
   'b0000000-0000-0000-0000-000000000002', now(), 'bee_cake', 1);

set local role authenticated;

-- B'nin owner'ı
set local request.jwt.claims = '{"sub": "99999999-9999-9999-9999-999999999999"}';

select results_eq(
  'select id from public.feedings',
  $$values ('ef000000-0000-0000-0000-000000000001'::uuid)$$,
  'başka işletmenin beslemesini göremez, yalnız kendisininkini görür'
);

select throws_ok(
  $$insert into public.feedings (id, org_id, hive_id, apiary_id, feeding_group_id, fed_at, kind, amount)
    values ('ef000000-0000-0000-0000-000000000002', 'aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaaa',
            'a3000000-0000-0000-0000-000000000001', 'a1000000-0000-0000-0000-000000000001',
            'b0000000-0000-0000-0000-000000000003', now(), 'syrup_1_1', 2)$$,
  '42501',
  null,
  'başka işletmeye besleme ekleyemez'
);

select is_empty(
  $$update public.feedings set deleted_at = now()
    where id = 'af000000-0000-0000-0000-000000000001' returning id$$,
  'başka işletmenin beslemesini silemez'
);

select throws_ok(
  $$insert into public.feedings (id, org_id, hive_id, apiary_id, feeding_group_id, fed_at, kind, amount)
    values ('ef000000-0000-0000-0000-000000000003', 'eeeeeeee-eeee-eeee-eeee-eeeeeeeeeeee',
            'a3000000-0000-0000-0000-000000000001', 'e1000000-0000-0000-0000-000000000001',
            'b0000000-0000-0000-0000-000000000003', now(), 'syrup_1_1', 2)$$,
  '23503',
  null,
  'kendi beslemesini başka işletmenin kovanına bağlayamaz'
);

select throws_ok(
  $$insert into public.feedings (id, org_id, hive_id, apiary_id, feeding_group_id, fed_at, kind, amount)
    values ('ef000000-0000-0000-0000-000000000004', 'eeeeeeee-eeee-eeee-eeee-eeeeeeeeeeee',
            'e3000000-0000-0000-0000-000000000001', 'a1000000-0000-0000-0000-000000000001',
            'b0000000-0000-0000-0000-000000000003', now(), 'syrup_1_1', 2)$$,
  '23503',
  null,
  'kendi beslemesini başka işletmenin arılığına bağlayamaz'
);

-- A'nın worker'ı
set local request.jwt.claims = '{"sub": "33333333-3333-3333-3333-333333333333"}';

select lives_ok(
  $$insert into public.feedings (id, org_id, hive_id, apiary_id, feeding_group_id, fed_at, kind, amount)
    values ('af000000-0000-0000-0000-000000000002', 'aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaaa',
            'a3000000-0000-0000-0000-000000000001', 'a1000000-0000-0000-0000-000000000001',
            'b0000000-0000-0000-0000-000000000004', now(), 'pollen_substitute', 0.5)$$,
  'worker polen ikamesi ekler'
);

select throws_ok(
  $$insert into public.feedings (id, org_id, hive_id, apiary_id, feeding_group_id, fed_at, kind, amount)
    values ('af000000-0000-0000-0000-000000000003', 'aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaaa',
            'a3000000-0000-0000-0000-000000000001', 'a1000000-0000-0000-0000-000000000001',
            'b0000000-0000-0000-0000-000000000004', now(), 'syrup_1_1', 0)$$,
  '23514',
  null,
  'miktar sıfır olamaz'
);

select throws_ok(
  $$insert into public.feedings (id, org_id, hive_id, apiary_id, feeding_group_id, fed_at, kind, amount)
    values ('af000000-0000-0000-0000-000000000004', 'aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaaa',
            'a3000000-0000-0000-0000-000000000001', 'a1000000-0000-0000-0000-000000000001',
            'b0000000-0000-0000-0000-000000000004', now(), 'syrup_1_1', 101)$$,
  '23514',
  null,
  'kovan başına miktar 100''ü geçemez'
);

select throws_ok(
  $$insert into public.feedings (id, org_id, hive_id, apiary_id, feeding_group_id, fed_at, kind, amount)
    values ('af000000-0000-0000-0000-000000000005', 'aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaaa',
            'a3000000-0000-0000-0000-000000000001', 'a1000000-0000-0000-0000-000000000001',
            null, now(), 'syrup_1_1', 2)$$,
  '23502',
  null,
  'besleme grubu zorunlu'
);

select results_eq(
  $$select r ->> 'status', r ->> 'applied'
    from jsonb_array_elements(public.sync_push(
      $j$[{"id": 1, "table": "feedings", "operation": "upsert", "payload": {
        "id": "af000000-0000-0000-0000-000000000006",
        "org_id": "aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaaa",
        "hive_id": "a3000000-0000-0000-0000-000000000001",
        "apiary_id": "a1000000-0000-0000-0000-000000000001",
        "feeding_group_id": "b0000000-0000-0000-0000-000000000005",
        "fed_at": "2026-10-26T09:00:00.000Z", "kind": "syrup_2_1",
        "amount": 3.785,
        "created_at": "2026-10-26T09:00:00.000Z",
        "updated_at": "2026-10-26T09:00:00.000Z",
        "created_by": null, "deleted_at": null}}]$j$::jsonb,
      now(), 7) -> 'results') r$$,
  $$values ('ok', 'true')$$,
  'sync_push beslemeyi şema sürümü 7 ile yazar'
);

select results_eq(
  $$select r ->> 'status', r ->> 'applied'
    from jsonb_array_elements(public.sync_push(
      $j$[{"id": 1, "table": "feedings", "operation": "delete", "payload": {
        "id": "af000000-0000-0000-0000-000000000006",
        "org_id": "aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaaa",
        "hive_id": "a3000000-0000-0000-0000-000000000001",
        "apiary_id": "a1000000-0000-0000-0000-000000000001",
        "feeding_group_id": "b0000000-0000-0000-0000-000000000005",
        "fed_at": "2026-10-26T09:00:00.000Z", "kind": "syrup_2_1",
        "amount": 1,
        "created_at": "2026-10-26T09:00:00.000Z",
        "updated_at": "2026-10-26T09:05:00.000Z",
        "created_by": null, "deleted_at": "2026-10-26T09:05:00.000Z"}}]$j$::jsonb,
      now(), 7) -> 'results') r$$,
  $$values ('ok', 'true')$$,
  'sync_push beslemenin silinmesini işler'
);

select results_eq(
  $$select amount, deleted_at is not null from public.feedings
    where id = 'af000000-0000-0000-0000-000000000006'$$,
  $$values (3.785::numeric, true)$$,
  'olay kaydı: silme yalnız deleted_at yazar, diğer alanlar değişmez'
);

-- A'nın viewer'ı
set local request.jwt.claims = '{"sub": "55555555-5555-5555-5555-555555555555"}';

select throws_ok(
  $$insert into public.feedings (id, org_id, hive_id, apiary_id, feeding_group_id, fed_at, kind, amount)
    values ('af000000-0000-0000-0000-000000000007', 'aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaaa',
            'a3000000-0000-0000-0000-000000000001', 'a1000000-0000-0000-0000-000000000001',
            'b0000000-0000-0000-0000-000000000006', now(), 'syrup_1_1', 2)$$,
  '42501',
  null,
  'viewer besleme ekleyemez, ama işletmenin beslemelerini görür'
);

select * from finish();
rollback;
