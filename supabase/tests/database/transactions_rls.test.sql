-- transactions RLS ve tutarlılık: finans yalnız owner ve partner'a açık;
-- worker ve viewer görmez ve yazamaz; başka işletmenin hareketi görünmez ve
-- yazılamaz; işletmeler arası bağ reddedilir; kategori türe uyar; satış
-- bağı gelirde ve lotla; fiş kaydın klasöründe; receipts bucket'ı yalnız
-- owner/partner'a; sync_push hareketi olay kaydı olarak şema sürümü 19 ile
-- yazar.
begin;
create extension if not exists pgtap with schema extensions;
select plan(21);

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

-- Önek a1/e1 arılık, ab/eb lot, a0 lot satışı, f1/f9 hareket.
insert into public.apiaries (id, org_id, name) values
  ('a1000000-0000-0000-0000-000000000001', 'aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaaa', 'Kızılçam'),
  ('e1000000-0000-0000-0000-000000000001', 'eeeeeeee-eeee-eeee-eeee-eeeeeeeeeeee', 'Ova');

insert into public.lots (id, org_id, year, seq, honey_kind) values
  ('ab000000-0000-0000-0000-000000000001', 'aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaaa', 2026, 7, 'pine'),
  ('eb000000-0000-0000-0000-000000000001', 'eeeeeeee-eeee-eeee-eeee-eeeeeeeeeeee', 2026, 1, 'flower');

insert into public.lot_sales (id, org_id, lot_id, sold_on, kg) values
  ('a0000000-0000-0000-0000-000000000001', 'aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaaa',
   'ab000000-0000-0000-0000-000000000001', '2026-10-15', 160);

insert into public.transactions (id, org_id, kind, category, amount, currency, occurred_on, description) values
  ('f1000000-0000-0000-0000-000000000001', 'aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaaa',
   'expense', 'feeding', 17500, 'TRY', '2026-10-01', 'Şeker 500 kg'),
  ('f9000000-0000-0000-0000-000000000001', 'eeeeeeee-eeee-eeee-eeee-eeeeeeeeeeee',
   'income', 'honey', 900, 'TRY', '2026-10-01', null);

insert into storage.objects (bucket_id, name) values
  ('receipts', 'aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaaa/f1000000-0000-0000-0000-000000000001/d0000000-0000-0000-0000-000000000001.jpg');

select results_eq(
  $$select public, file_size_limit, allowed_mime_types from storage.buckets where id = 'receipts'$$,
  $$values (false, 10485760::bigint, array['image/jpeg'])$$,
  'receipts bucket özel, 10 MB sınırlı, yalnız JPEG'
);

select is_empty(
  $$select policyname from pg_policies
    where schemaname = 'storage' and tablename = 'objects'
      and cmd in ('UPDATE', 'DELETE', 'ALL')
      and coalesce(qual, '') || coalesce(with_check, '') like '%receipts%'$$,
  'fiş dosyaları için güncelleme ya da silme politikası yok'
);

set local role authenticated;

-- B'nin owner'ı
set local request.jwt.claims = '{"sub": "99999999-9999-9999-9999-999999999999"}';

select results_eq(
  'select id from public.transactions',
  $$values ('f9000000-0000-0000-0000-000000000001'::uuid)$$,
  'başka işletmenin hareketini göremez, yalnız kendisininkini görür'
);

select throws_ok(
  $$insert into public.transactions (id, org_id, kind, category, amount, currency, occurred_on)
    values ('f9000000-0000-0000-0000-000000000002', 'aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaaa',
            'expense', 'labor', 100, 'TRY', '2026-10-01')$$,
  '42501',
  null,
  'başka işletmeye hareket ekleyemez'
);

select is_empty(
  $$update public.transactions set amount = 1
    where id = 'f1000000-0000-0000-0000-000000000001' returning id$$,
  'başka işletmenin hareketini güncelleyemez'
);

select throws_ok(
  $$insert into public.transactions (id, org_id, kind, category, amount, currency, occurred_on, lot_id)
    values ('f9000000-0000-0000-0000-000000000003', 'eeeeeeee-eeee-eeee-eeee-eeeeeeeeeeee',
            'income', 'honey', 100, 'TRY', '2026-10-01', 'ab000000-0000-0000-0000-000000000001')$$,
  '23503',
  null,
  'başka işletmenin lotuna hareket bağlayamaz'
);

select throws_ok(
  $$insert into public.transactions (id, org_id, kind, category, amount, currency, occurred_on, apiary_id)
    values ('f9000000-0000-0000-0000-000000000004', 'eeeeeeee-eeee-eeee-eeee-eeeeeeeeeeee',
            'expense', 'land_rent', 100, 'TRY', '2026-10-01', 'a1000000-0000-0000-0000-000000000001')$$,
  '23503',
  null,
  'başka işletmenin arılığına hareket bağlayamaz'
);

select is_empty(
  $$select name from storage.objects where bucket_id = 'receipts'$$,
  'başka işletmenin fiş dosyasını göremez'
);

-- A'nın partner'ı
set local request.jwt.claims = '{"sub": "22222222-2222-2222-2222-222222222222"}';

select lives_ok(
  $$insert into public.transactions (id, org_id, kind, category, amount, currency, occurred_on,
                                     description, lot_id, lot_sale_id, apiary_id, receipt_path)
    values ('f1000000-0000-0000-0000-000000000002', 'aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaaa',
            'income', 'honey', 56000, 'TRY', '2026-10-15', 'Toptancıya çam balı',
            'ab000000-0000-0000-0000-000000000001', 'a0000000-0000-0000-0000-000000000001',
            'a1000000-0000-0000-0000-000000000001',
            'aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaaa/f1000000-0000-0000-0000-000000000002/d0000000-0000-0000-0000-000000000002.jpg')$$,
  'partner lot satışına bağlı, fişli gelir ekler'
);

select throws_ok(
  $$insert into public.transactions (id, org_id, kind, category, amount, currency, occurred_on)
    values ('f1000000-0000-0000-0000-000000000003', 'aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaaa',
            'income', 'feeding', 100, 'TRY', '2026-10-01')$$,
  '23514',
  null,
  'gider kategorisi gelirde kullanılamaz'
);

select throws_ok(
  $$insert into public.transactions (id, org_id, kind, category, amount, currency, occurred_on, lot_sale_id)
    values ('f1000000-0000-0000-0000-000000000003', 'aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaaa',
            'expense', 'other', 100, 'TRY', '2026-10-01', 'a0000000-0000-0000-0000-000000000001')$$,
  '23514',
  null,
  'satış bağı yalnız lotlu gelirde'
);

select throws_ok(
  $$insert into public.transactions (id, org_id, kind, category, amount, currency, occurred_on, receipt_path)
    values ('f1000000-0000-0000-0000-000000000003', 'aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaaa',
            'expense', 'other', 100, 'TRY', '2026-10-01',
            'aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaaa/f1000000-0000-0000-0000-000000000001/d0000000-0000-0000-0000-000000000003.jpg')$$,
  '23514',
  null,
  'fiş başka kaydın klasörüne yazılamaz'
);

select lives_ok(
  $$insert into storage.objects (bucket_id, name)
    values ('receipts', 'aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaaa/f1000000-0000-0000-0000-000000000002/d0000000-0000-0000-0000-000000000002.jpg')$$,
  'partner fiş dosyası yükler'
);

select results_eq(
  $$select r ->> 'status', r ->> 'applied'
    from jsonb_array_elements(public.sync_push(
      $j$[{"id": 1, "table": "transactions", "operation": "upsert", "payload": {
        "id": "f1000000-0000-0000-0000-000000000004",
        "org_id": "aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaaa",
        "kind": "expense", "category": "fuel_transport", "amount": 9800,
        "currency": "TRY", "occurred_on": "2026-10-20",
        "description": "Mazot", "receipt_path": null, "apiary_id": null,
        "lot_id": null, "transport_id": null, "lot_sale_id": null,
        "created_at": "2026-11-03T09:00:00.000Z",
        "updated_at": "2026-11-03T09:00:00.000Z",
        "created_by": null, "deleted_at": null}},
      {"id": 2, "table": "transactions", "operation": "delete", "payload": {
        "id": "f1000000-0000-0000-0000-000000000004",
        "org_id": "aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaaa",
        "kind": "expense", "category": "fuel_transport", "amount": 1,
        "currency": "TRY", "occurred_on": "2026-10-20",
        "description": "Mazot", "receipt_path": null, "apiary_id": null,
        "lot_id": null, "transport_id": null, "lot_sale_id": null,
        "created_at": "2026-11-03T09:00:00.000Z",
        "updated_at": "2026-11-03T09:05:00.000Z",
        "created_by": null, "deleted_at": "2026-11-03T09:05:00.000Z"}}]$j$::jsonb,
      now(), 19) -> 'results') r$$,
  $$values ('ok', 'true'), ('ok', 'true')$$,
  'sync_push hareketi şema sürümü 19 ile yazar ve silinmesini işler'
);

select results_eq(
  $$select amount, deleted_at is not null from public.transactions
    where id = 'f1000000-0000-0000-0000-000000000004'$$,
  $$values (9800::numeric, true)$$,
  'olay kaydı: silme yalnız deleted_at yazar, tutar değişmez'
);

-- A'nın worker'ı
set local request.jwt.claims = '{"sub": "33333333-3333-3333-3333-333333333333"}';

select is_empty(
  'select id from public.transactions',
  'worker finans hareketlerini göremez'
);

select throws_ok(
  $$insert into public.transactions (id, org_id, kind, category, amount, currency, occurred_on)
    values ('f1000000-0000-0000-0000-000000000005', 'aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaaa',
            'expense', 'equipment', 100, 'TRY', '2026-10-01')$$,
  '42501',
  null,
  'worker gider ekleyemez'
);

select results_eq(
  $$select r ->> 'status', r ->> 'reason'
    from jsonb_array_elements(public.sync_push(
      $j$[{"id": 1, "table": "transactions", "operation": "upsert", "payload": {
        "id": "f1000000-0000-0000-0000-000000000006",
        "org_id": "aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaaa",
        "kind": "expense", "category": "labor", "amount": 100,
        "currency": "TRY", "occurred_on": "2026-10-20",
        "description": null, "receipt_path": null, "apiary_id": null,
        "lot_id": null, "transport_id": null, "lot_sale_id": null,
        "created_at": "2026-11-03T09:00:00.000Z",
        "updated_at": "2026-11-03T09:00:00.000Z",
        "created_by": null, "deleted_at": null}}]$j$::jsonb,
      now(), 19) -> 'results') r$$,
  $$values ('rejected', 'forbidden')$$,
  'worker senkronla da hareket yazamaz'
);

select is_empty(
  $$select name from storage.objects where bucket_id = 'receipts'$$,
  'worker fiş dosyalarını göremez'
);

select throws_ok(
  $$insert into storage.objects (bucket_id, name)
    values ('receipts', 'aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaaa/f1000000-0000-0000-0000-000000000001/d0000000-0000-0000-0000-000000000009.jpg')$$,
  '42501',
  null,
  'worker fiş dosyası yükleyemez'
);

-- A'nın viewer'ı
set local request.jwt.claims = '{"sub": "55555555-5555-5555-5555-555555555555"}';

select is_empty(
  'select id from public.transactions',
  'viewer finans hareketlerini göremez'
);

select * from finish();
rollback;
