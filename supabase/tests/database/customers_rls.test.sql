-- customers ve customer_payments RLS ve tutarlılık: müşteri defteri yalnız
-- owner ve partner'a açık; worker ve viewer görmez ve yazamaz; başka
-- işletmenin müşterisi ve tahsilatı görünmez ve yazılamaz; işletmeler arası
-- bağ reddedilir; müşteri yalnız gelire bağlanır; tahsilat yalnız müşterili
-- satışa alınır; sync_push müşteriyi durum, tahsilatı olay kaydı olarak
-- şema sürümü 20 ile yazar.
begin;
create extension if not exists pgtap with schema extensions;
select plan(20);

-- Kullanıcılar: 2222 A'da partner, 3333 A'da worker, 5555 A'da viewer,
-- 9999 B'nin owner'ı.
insert into auth.users (id, email) values
  ('22222222-2222-2222-2222-222222222222', 'partner@test.local'),
  ('33333333-3333-3333-3333-333333333333', 'worker@test.local'),
  ('55555555-5555-5555-5555-555555555555', 'viewer@test.local'),
  ('99999999-9999-9999-9999-999999999999', 'other@test.local');

-- aaaa: A işletmesi. eeee: B işletmesi.
insert into public.organizations (id, name, country_code, currency, created_by) values
  ('aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaaa', 'Petek Arıcılık', 'TR', 'TRY',
   '22222222-2222-2222-2222-222222222222'),
  ('eeeeeeee-eeee-eeee-eeee-eeeeeeeeeeee', 'Başka İşletme', 'TR', 'TRY',
   '99999999-9999-9999-9999-999999999999');

insert into public.memberships (id, org_id, user_id, role) values
  ('c0000000-0000-0000-0000-000000000002', 'aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaaa',
   '22222222-2222-2222-2222-222222222222', 'partner'),
  ('c0000000-0000-0000-0000-000000000003', 'aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaaa',
   '33333333-3333-3333-3333-333333333333', 'worker'),
  ('c0000000-0000-0000-0000-000000000005', 'aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaaa',
   '55555555-5555-5555-5555-555555555555', 'viewer'),
  ('c0000000-0000-0000-0000-000000000009', 'eeeeeeee-eeee-eeee-eeee-eeeeeeeeeeee',
   '99999999-9999-9999-9999-999999999999', 'owner');

-- Önek c1/c9 müşteri, f1/f9 hareket, d1/d9 tahsilat.
insert into public.customers (id, org_id, name, phone) values
  ('c1000000-0000-0000-0000-000000000001', 'aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaaa',
   'Ayşe Hanım', '+90 532 000 00 00'),
  ('c9000000-0000-0000-0000-000000000001', 'eeeeeeee-eeee-eeee-eeee-eeeeeeeeeeee',
   'Mehmet Bey', null);

insert into public.transactions (id, org_id, kind, category, amount, currency, occurred_on, customer_id) values
  ('f1000000-0000-0000-0000-000000000001', 'aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaaa',
   'income', 'honey', 6000, 'TRY', '2026-10-01', 'c1000000-0000-0000-0000-000000000001'),
  ('f1000000-0000-0000-0000-000000000002', 'aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaaa',
   'income', 'honey', 900, 'TRY', '2026-10-01', null),
  ('f9000000-0000-0000-0000-000000000001', 'eeeeeeee-eeee-eeee-eeee-eeeeeeeeeeee',
   'income', 'honey', 900, 'TRY', '2026-10-01', 'c9000000-0000-0000-0000-000000000001');

insert into public.customer_payments (id, org_id, transaction_id, amount, paid_on) values
  ('d1000000-0000-0000-0000-000000000001', 'aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaaa',
   'f1000000-0000-0000-0000-000000000001', 2000, '2026-10-05'),
  ('d9000000-0000-0000-0000-000000000001', 'eeeeeeee-eeee-eeee-eeee-eeeeeeeeeeee',
   'f9000000-0000-0000-0000-000000000001', 100, '2026-10-05');

set local role authenticated;

-- B'nin owner'ı
set local request.jwt.claims = '{"sub": "99999999-9999-9999-9999-999999999999"}';

select results_eq(
  'select id from public.customers',
  $$values ('c9000000-0000-0000-0000-000000000001'::uuid)$$,
  'başka işletmenin müşterisini göremez, yalnız kendisininkini görür'
);

select results_eq(
  'select id from public.customer_payments',
  $$values ('d9000000-0000-0000-0000-000000000001'::uuid)$$,
  'başka işletmenin tahsilatını göremez'
);

select throws_ok(
  $$insert into public.customers (id, org_id, name)
    values ('c9000000-0000-0000-0000-000000000002', 'aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaaa', 'X')$$,
  '42501',
  null,
  'başka işletmeye müşteri ekleyemez'
);

select is_empty(
  $$update public.customers set name = 'Y'
    where id = 'c1000000-0000-0000-0000-000000000001' returning id$$,
  'başka işletmenin müşterisini güncelleyemez'
);

select throws_ok(
  $$insert into public.transactions (id, org_id, kind, category, amount, currency, occurred_on, customer_id)
    values ('f9000000-0000-0000-0000-000000000002', 'eeeeeeee-eeee-eeee-eeee-eeeeeeeeeeee',
            'income', 'honey', 100, 'TRY', '2026-10-01', 'c1000000-0000-0000-0000-000000000001')$$,
  '23503',
  null,
  'başka işletmenin müşterisine satış bağlayamaz'
);

select throws_ok(
  $$insert into public.customer_payments (id, org_id, transaction_id, amount, paid_on)
    values ('d9000000-0000-0000-0000-000000000002', 'eeeeeeee-eeee-eeee-eeee-eeeeeeeeeeee',
            'f1000000-0000-0000-0000-000000000001', 100, '2026-10-05')$$,
  '23503',
  null,
  'başka işletmenin satışına tahsilat bağlayamaz'
);

-- A'nın partner'ı
set local request.jwt.claims = '{"sub": "22222222-2222-2222-2222-222222222222"}';

select results_eq(
  'select id from public.customers',
  $$values ('c1000000-0000-0000-0000-000000000001'::uuid)$$,
  'partner işletmenin müşterilerini görür'
);

select lives_ok(
  $$insert into public.customer_payments (id, org_id, transaction_id, amount, paid_on)
    values ('d1000000-0000-0000-0000-000000000002', 'aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaaa',
            'f1000000-0000-0000-0000-000000000001', 4000, '2026-10-10')$$,
  'partner müşterili satışa tahsilat ekler'
);

select throws_ok(
  $$insert into public.customer_payments (id, org_id, transaction_id, amount, paid_on)
    values ('d1000000-0000-0000-0000-000000000003', 'aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaaa',
            'f1000000-0000-0000-0000-000000000002', 100, '2026-10-10')$$,
  '23514',
  null,
  'müşterisiz satışa tahsilat alınamaz'
);

select throws_ok(
  $$insert into public.customer_payments (id, org_id, transaction_id, amount, paid_on)
    values ('d1000000-0000-0000-0000-000000000003', 'aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaaa',
            'f1000000-0000-0000-0000-000000000001', 0, '2026-10-10')$$,
  '23514',
  null,
  'tahsilat tutarı pozitif'
);

select throws_ok(
  $$insert into public.transactions (id, org_id, kind, category, amount, currency, occurred_on, customer_id)
    values ('f1000000-0000-0000-0000-000000000003', 'aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaaa',
            'expense', 'other', 100, 'TRY', '2026-10-01', 'c1000000-0000-0000-0000-000000000001')$$,
  '23514',
  null,
  'müşteri yalnız gelire bağlanır'
);

select throws_ok(
  $$insert into public.customers (id, org_id, name)
    values ('c1000000-0000-0000-0000-000000000002', 'aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaaa', '  ')$$,
  '23514',
  null,
  'müşterinin adı boş olamaz'
);

select results_eq(
  $$select r ->> 'status', r ->> 'applied'
    from jsonb_array_elements(public.sync_push(
      $j$[{"id": 1, "table": "customers", "operation": "upsert", "payload": {
        "id": "c1000000-0000-0000-0000-000000000003",
        "org_id": "aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaaa",
        "name": "Toptancı", "phone": null, "address": "Rize", "notes": null,
        "created_at": "2026-11-04T09:00:00.000Z",
        "updated_at": "2026-11-04T09:00:00.000Z",
        "created_by": null, "deleted_at": null}},
      {"id": 2, "table": "transactions", "operation": "upsert", "payload": {
        "id": "f1000000-0000-0000-0000-000000000004",
        "org_id": "aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaaa",
        "kind": "income", "category": "honey", "amount": 56000,
        "currency": "TRY", "occurred_on": "2026-10-20",
        "description": null, "receipt_path": null, "apiary_id": null,
        "lot_id": null, "transport_id": null, "lot_sale_id": null,
        "customer_id": "c1000000-0000-0000-0000-000000000003",
        "created_at": "2026-11-04T09:00:00.000Z",
        "updated_at": "2026-11-04T09:00:00.000Z",
        "created_by": null, "deleted_at": null}},
      {"id": 3, "table": "customer_payments", "operation": "upsert", "payload": {
        "id": "d1000000-0000-0000-0000-000000000004",
        "org_id": "aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaaa",
        "transaction_id": "f1000000-0000-0000-0000-000000000004",
        "amount": 20000, "paid_on": "2026-10-21",
        "created_at": "2026-11-04T09:00:00.000Z",
        "updated_at": "2026-11-04T09:00:00.000Z",
        "created_by": null, "deleted_at": null}},
      {"id": 4, "table": "customers", "operation": "upsert", "payload": {
        "id": "c1000000-0000-0000-0000-000000000003",
        "org_id": "aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaaa",
        "name": "Toptancı Ali", "phone": null, "address": "Rize", "notes": null,
        "created_at": "2026-11-04T09:00:00.000Z",
        "updated_at": "2026-11-04T09:01:00.000Z",
        "created_by": null, "deleted_at": null}}]$j$::jsonb,
      now(), 20) -> 'results') r$$,
  $$values ('ok', 'true'), ('ok', 'true'), ('ok', 'true'), ('ok', 'true')$$,
  'sync_push müşteri, müşterili satış ve tahsilatı şema sürümü 20 ile yazar'
);

select results_eq(
  $$select name from public.customers where id = 'c1000000-0000-0000-0000-000000000003'$$,
  $$values ('Toptancı Ali')$$,
  'müşteri durum kaydı: son yazan kazanır'
);

select results_eq(
  $$select r ->> 'status', r ->> 'applied'
    from jsonb_array_elements(public.sync_push(
      $j$[{"id": 1, "table": "customer_payments", "operation": "delete", "payload": {
        "id": "d1000000-0000-0000-0000-000000000004",
        "org_id": "aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaaa",
        "transaction_id": "f1000000-0000-0000-0000-000000000004",
        "amount": 1, "paid_on": "2026-10-21",
        "created_at": "2026-11-04T09:00:00.000Z",
        "updated_at": "2026-11-04T09:05:00.000Z",
        "created_by": null, "deleted_at": "2026-11-04T09:05:00.000Z"}}]$j$::jsonb,
      now(), 20) -> 'results') r$$,
  $$values ('ok', 'true')$$,
  'sync_push tahsilatın silinmesini işler'
);

select results_eq(
  $$select amount, deleted_at is not null from public.customer_payments
    where id = 'd1000000-0000-0000-0000-000000000004'$$,
  $$values (20000::numeric, true)$$,
  'tahsilat olay kaydı: silme yalnız deleted_at yazar, tutar değişmez'
);

-- A'nın worker'ı
set local request.jwt.claims = '{"sub": "33333333-3333-3333-3333-333333333333"}';

select is_empty(
  'select id from public.customers',
  'worker müşterileri göremez'
);

select is_empty(
  'select id from public.customer_payments',
  'worker tahsilatları göremez'
);

select results_eq(
  $$select r ->> 'status', r ->> 'reason'
    from jsonb_array_elements(public.sync_push(
      $j$[{"id": 1, "table": "customers", "operation": "upsert", "payload": {
        "id": "c1000000-0000-0000-0000-000000000005",
        "org_id": "aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaaa",
        "name": "X", "phone": null, "address": null, "notes": null,
        "created_at": "2026-11-04T09:00:00.000Z",
        "updated_at": "2026-11-04T09:00:00.000Z",
        "created_by": null, "deleted_at": null}}]$j$::jsonb,
      now(), 20) -> 'results') r$$,
  $$values ('rejected', 'forbidden')$$,
  'worker senkronla da müşteri yazamaz'
);

-- A'nın viewer'ı
set local request.jwt.claims = '{"sub": "55555555-5555-5555-5555-555555555555"}';

select is_empty(
  'select id from public.customers',
  'viewer müşterileri göremez'
);

select * from finish();
rollback;
