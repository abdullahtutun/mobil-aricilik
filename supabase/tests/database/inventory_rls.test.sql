-- inventory_items ve inventory_moves RLS ve tutarlılık: başka işletmenin
-- kalemi ve hareketi görünmez ve yazılamaz; worker yazar, viewer yalnız
-- okur; hareket başka işletmenin kalemine bağlanamaz; hareketin işareti
-- türüne uyar; bağlı kayıt iki alanıyla birlikte; sync_push kalemi durum,
-- hareketi olay kaydı olarak şema sürümü 14 ile yazar.
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

select plan(17);

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

-- Önek a5/e5 kalem, a6/e6 hareket.
insert into public.inventory_items (id, org_id, name, category, unit, place, threshold) values
  ('a5000000-0000-0000-0000-000000000001', 'aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaaa',
   'Temel petek', 'consumable', 'piece', 'depo', 100),
  ('e5000000-0000-0000-0000-000000000001', 'eeeeeeee-eeee-eeee-eeee-eeeeeeeeeeee',
   'Şeker', 'consumable', 'kg', null, null);

insert into public.inventory_moves (id, org_id, item_id, kind, quantity, moved_at) values
  ('a6000000-0000-0000-0000-000000000001', 'aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaaa',
   'a5000000-0000-0000-0000-000000000001', 'in', 50, now()),
  ('e6000000-0000-0000-0000-000000000001', 'eeeeeeee-eeee-eeee-eeee-eeeeeeeeeeee',
   'e5000000-0000-0000-0000-000000000001', 'in', 150, now());

set local role authenticated;

-- B'nin owner'ı
set local request.jwt.claims = '{"sub": "99999999-9999-9999-9999-999999999999"}';

select results_eq(
  'select id from public.inventory_items',
  $$values ('e5000000-0000-0000-0000-000000000001'::uuid)$$,
  'başka işletmenin kalemini göremez, yalnız kendisininkini görür'
);

select results_eq(
  'select id from public.inventory_moves',
  $$values ('e6000000-0000-0000-0000-000000000001'::uuid)$$,
  'başka işletmenin hareketini göremez'
);

select throws_ok(
  $$insert into public.inventory_items (id, org_id, name, category, unit)
    values ('e5000000-0000-0000-0000-000000000002', 'aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaaa',
            'Kavanoz', 'consumable', 'piece')$$,
  '42501',
  null,
  'başka işletmeye kalem ekleyemez'
);

select is_empty(
  $$update public.inventory_items set name = 'Değişti'
    where id = 'a5000000-0000-0000-0000-000000000001' returning id$$,
  'başka işletmenin kalemini güncelleyemez'
);

select throws_ok(
  $$insert into public.inventory_moves (id, org_id, item_id, kind, quantity, moved_at)
    values ('e6000000-0000-0000-0000-000000000002', 'eeeeeeee-eeee-eeee-eeee-eeeeeeeeeeee',
            'a5000000-0000-0000-0000-000000000001', 'out', -5, now())$$,
  '23503',
  null,
  'kendi hareketini başka işletmenin kalemine bağlayamaz'
);

-- A'nın worker'ı
set local request.jwt.claims = '{"sub": "33333333-3333-3333-3333-333333333333"}';

select lives_ok(
  $$insert into public.inventory_items (id, org_id, name, category, unit)
    values ('a5000000-0000-0000-0000-000000000002', 'aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaaa',
            'Körük', 'equipment', 'piece')$$,
  'worker eşiksiz ve yeri yazılmamış kalem ekler'
);

select lives_ok(
  $$insert into public.inventory_moves (id, org_id, item_id, kind, quantity, moved_at, linked_table, linked_id)
    values ('a6000000-0000-0000-0000-000000000002', 'aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaaa',
            'a5000000-0000-0000-0000-000000000001', 'out', -12.5, now(),
            'feedings', 'b0000000-0000-0000-0000-000000000001')$$,
  'worker bağlı kayıtlı çıkış ekler'
);

select throws_ok(
  $$insert into public.inventory_moves (id, org_id, item_id, kind, quantity, moved_at)
    values ('a6000000-0000-0000-0000-000000000003', 'aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaaa',
            'a5000000-0000-0000-0000-000000000001', 'out', 5, now())$$,
  '23514',
  null,
  'çıkış negatif olmalı'
);

select throws_ok(
  $$insert into public.inventory_moves (id, org_id, item_id, kind, quantity, moved_at)
    values ('a6000000-0000-0000-0000-000000000003', 'aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaaa',
            'a5000000-0000-0000-0000-000000000001', 'adjustment', 0, now())$$,
  '23514',
  null,
  'düzeltme sıfır olamaz'
);

select throws_ok(
  $$insert into public.inventory_moves (id, org_id, item_id, kind, quantity, moved_at, linked_table)
    values ('a6000000-0000-0000-0000-000000000003', 'aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaaa',
            'a5000000-0000-0000-0000-000000000001', 'in', 5, now(), 'feedings')$$,
  '23514',
  null,
  'bağlı kayıt tablo ve kimlikle birlikte'
);

select throws_ok(
  $$insert into public.inventory_items (id, org_id, name, category, unit, threshold)
    values ('a5000000-0000-0000-0000-000000000003', 'aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaaa',
            'Kavanoz', 'consumable', 'piece', 0)$$,
  '23514',
  null,
  'eşik sıfır olamaz (eşiksiz kalemde boş)'
);

select throws_ok(
  $$insert into public.inventory_items (id, org_id, name, category, unit)
    values ('a5000000-0000-0000-0000-000000000003', 'aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaaa',
            '  ', 'consumable', 'piece')$$,
  '23514',
  null,
  'ad boş olamaz'
);

select results_eq(
  $$select r ->> 'status', r ->> 'applied'
    from jsonb_array_elements(public.sync_push(
      $j$[{"id": 1, "table": "inventory_items", "operation": "upsert", "payload": {
        "id": "a5000000-0000-0000-0000-000000000004",
        "org_id": "aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaaa",
        "name": "Arı keki", "category": "consumable", "unit": "kg",
        "place": "kamyonet", "threshold": 20,
        "created_at": "2026-11-01T09:00:00.000Z",
        "updated_at": "2026-11-01T09:00:00.000Z",
        "created_by": null, "deleted_at": null}},
      {"id": 2, "table": "inventory_moves", "operation": "upsert", "payload": {
        "id": "a6000000-0000-0000-0000-000000000004",
        "org_id": "aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaaa",
        "item_id": "a5000000-0000-0000-0000-000000000004",
        "kind": "in", "quantity": 30,
        "moved_at": "2026-11-01T09:01:00.000Z",
        "linked_table": null, "linked_id": null,
        "created_at": "2026-11-01T09:01:00.000Z",
        "updated_at": "2026-11-01T09:01:00.000Z",
        "created_by": null, "deleted_at": null}},
      {"id": 3, "table": "inventory_items", "operation": "upsert", "payload": {
        "id": "a5000000-0000-0000-0000-000000000004",
        "org_id": "aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaaa",
        "name": "Eski ad", "category": "consumable", "unit": "kg",
        "place": null, "threshold": null,
        "created_at": "2026-11-01T09:00:00.000Z",
        "updated_at": "2026-11-01T08:00:00.000Z",
        "created_by": null, "deleted_at": null}}]$j$::jsonb,
      now(), 14) -> 'results') r$$,
  $$values ('ok', 'true'), ('ok', 'true'), ('ok', 'false')$$,
  'sync_push kalemi ve hareketi şema sürümü 14 ile yazar; kalemin eski yazması kaybeder'
);

select results_eq(
  $$select r ->> 'status', r ->> 'applied'
    from jsonb_array_elements(public.sync_push(
      $j$[{"id": 1, "table": "inventory_moves", "operation": "delete", "payload": {
        "id": "a6000000-0000-0000-0000-000000000004",
        "org_id": "aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaaa",
        "item_id": "a5000000-0000-0000-0000-000000000004",
        "kind": "in", "quantity": 1,
        "moved_at": "2026-11-01T09:01:00.000Z",
        "linked_table": null, "linked_id": null,
        "created_at": "2026-11-01T09:01:00.000Z",
        "updated_at": "2026-11-01T09:05:00.000Z",
        "created_by": null, "deleted_at": "2026-11-01T09:05:00.000Z"}}]$j$::jsonb,
      now(), 14) -> 'results') r$$,
  $$values ('ok', 'true')$$,
  'sync_push hareketin silinmesini işler'
);

select results_eq(
  $$select quantity, deleted_at is not null from public.inventory_moves
    where id = 'a6000000-0000-0000-0000-000000000004'$$,
  $$values (30::numeric, true)$$,
  'olay kaydı: silme yalnız deleted_at yazar, miktar değişmez'
);

select results_eq(
  $$select coalesce(sum(quantity), 0) from public.inventory_moves
    where item_id = 'a5000000-0000-0000-0000-000000000001' and deleted_at is null$$,
  $$values (37.5::numeric)$$,
  'stok hareketlerin toplamı: 50 giriş, 12,5 çıkış'
);

-- A'nın viewer'ı
set local request.jwt.claims = '{"sub": "55555555-5555-5555-5555-555555555555"}';

select throws_ok(
  $$insert into public.inventory_moves (id, org_id, item_id, kind, quantity, moved_at)
    values ('a6000000-0000-0000-0000-000000000005', 'aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaaa',
            'a5000000-0000-0000-0000-000000000001', 'in', 5, now())$$,
  '42501',
  null,
  'viewer hareket ekleyemez, ama işletmenin hareketlerini görür'
);

select * from finish();
rollback;
