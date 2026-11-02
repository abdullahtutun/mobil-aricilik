-- hive_status_events RLS ve tutarlılık: başka işletmenin olayı görünmez ve
-- yazılamaz; worker yazar, viewer yalnız okur; işletmeler arası bağ
-- reddedilir; durum değişmeli ve kayıp nedeni yalnız söndü/kayboldu'da;
-- sync_push olayı şema sürümü 23 ile olay kaydı olarak yazar.
begin;
create extension if not exists pgtap with schema extensions;
select plan(12);

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

-- Önek a1/e1 arılık, a3/e3 kovan, a5/e5 durum olayı.
insert into public.apiaries (id, org_id, name) values
  ('a1000000-0000-0000-0000-000000000001', 'aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaaa', 'Yayla'),
  ('e1000000-0000-0000-0000-000000000001', 'eeeeeeee-eeee-eeee-eeee-eeeeeeeeeeee', 'Ova');

insert into public.hives (id, org_id, number, type, apiary_id) values
  ('a3000000-0000-0000-0000-000000000001', 'aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaaa',
   '101', 'langstroth', 'a1000000-0000-0000-0000-000000000001'),
  ('e3000000-0000-0000-0000-000000000001', 'eeeeeeee-eeee-eeee-eeee-eeeeeeeeeeee',
   '101', 'dadant', 'e1000000-0000-0000-0000-000000000001');

insert into public.hive_status_events
  (id, org_id, hive_id, apiary_id, from_status, to_status, changed_at, loss_reason) values
  ('a5000000-0000-0000-0000-000000000001', 'aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaaa',
   'a3000000-0000-0000-0000-000000000001', 'a1000000-0000-0000-0000-000000000001',
   'active', 'dead', now(), 'wintering'),
  ('e5000000-0000-0000-0000-000000000001', 'eeeeeeee-eeee-eeee-eeee-eeeeeeeeeeee',
   'e3000000-0000-0000-0000-000000000001', 'e1000000-0000-0000-0000-000000000001',
   'active', 'sold', now(), null);

set local role authenticated;

-- B'nin owner'ı
set local request.jwt.claims = '{"sub": "99999999-9999-9999-9999-999999999999"}';

select results_eq(
  'select id from public.hive_status_events',
  $$values ('e5000000-0000-0000-0000-000000000001'::uuid)$$,
  'başka işletmenin olayını göremez, yalnız kendisininkini görür'
);

select throws_ok(
  $$insert into public.hive_status_events
      (id, org_id, hive_id, apiary_id, from_status, to_status, changed_at)
    values ('e5000000-0000-0000-0000-000000000002', 'aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaaa',
            'a3000000-0000-0000-0000-000000000001', 'a1000000-0000-0000-0000-000000000001',
            'dead', 'active', now())$$,
  '42501',
  null,
  'başka işletmeye olay ekleyemez'
);

select is_empty(
  $$update public.hive_status_events set deleted_at = now()
    where id = 'a5000000-0000-0000-0000-000000000001' returning id$$,
  'başka işletmenin olayını silemez'
);

select throws_ok(
  $$insert into public.hive_status_events
      (id, org_id, hive_id, apiary_id, from_status, to_status, changed_at)
    values ('e5000000-0000-0000-0000-000000000003', 'eeeeeeee-eeee-eeee-eeee-eeeeeeeeeeee',
            'a3000000-0000-0000-0000-000000000001', 'e1000000-0000-0000-0000-000000000001',
            'active', 'dead', now())$$,
  '23503',
  null,
  'kendi olayını başka işletmenin kovanına bağlayamaz'
);

select throws_ok(
  $$insert into public.hive_status_events
      (id, org_id, hive_id, apiary_id, from_status, to_status, changed_at)
    values ('e5000000-0000-0000-0000-000000000004', 'eeeeeeee-eeee-eeee-eeee-eeeeeeeeeeee',
            'e3000000-0000-0000-0000-000000000001', 'a1000000-0000-0000-0000-000000000001',
            'active', 'dead', now())$$,
  '23503',
  null,
  'kendi olayını başka işletmenin arılığına bağlayamaz'
);

-- A'nın worker'ı
set local request.jwt.claims = '{"sub": "33333333-3333-3333-3333-333333333333"}';

select lives_ok(
  $$insert into public.hive_status_events
      (id, org_id, hive_id, apiary_id, from_status, to_status, changed_at, loss_reason)
    values ('a5000000-0000-0000-0000-000000000002', 'aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaaa',
            'a3000000-0000-0000-0000-000000000001', 'a1000000-0000-0000-0000-000000000001',
            'active', 'lost', now(), 'predator')$$,
  'worker kayıp nedeniyle olay ekler'
);

select throws_ok(
  $$insert into public.hive_status_events
      (id, org_id, hive_id, apiary_id, from_status, to_status, changed_at)
    values ('a5000000-0000-0000-0000-000000000003', 'aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaaa',
            'a3000000-0000-0000-0000-000000000001', 'a1000000-0000-0000-0000-000000000001',
            'active', 'active', now())$$,
  '23514',
  null,
  'durum değişmeli'
);

select throws_ok(
  $$insert into public.hive_status_events
      (id, org_id, hive_id, apiary_id, from_status, to_status, changed_at, loss_reason)
    values ('a5000000-0000-0000-0000-000000000004', 'aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaaa',
            'a3000000-0000-0000-0000-000000000001', 'a1000000-0000-0000-0000-000000000001',
            'active', 'sold', now(), 'varroa')$$,
  '23514',
  null,
  'kayıp nedeni yalnız söndü ya da kayboldu''da'
);

select results_eq(
  $$select r ->> 'status', r ->> 'applied'
    from jsonb_array_elements(public.sync_push(
      $j$[{"id": 1, "table": "hive_status_events", "operation": "upsert", "payload": {
        "id": "a5000000-0000-0000-0000-000000000005",
        "org_id": "aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaaa",
        "hive_id": "a3000000-0000-0000-0000-000000000001",
        "apiary_id": "a1000000-0000-0000-0000-000000000001",
        "from_status": "active", "to_status": "dead",
        "changed_at": "2027-02-10T09:00:00.000Z", "loss_reason": "varroa",
        "created_at": "2027-02-10T09:00:00.000Z",
        "updated_at": "2027-02-10T09:00:00.000Z",
        "created_by": null, "deleted_at": null}}]$j$::jsonb,
      now(), 23) -> 'results') r$$,
  $$values ('ok', 'true')$$,
  'sync_push olayı şema sürümü 23 ile yazar'
);

select results_eq(
  $$select r ->> 'status', r ->> 'applied'
    from jsonb_array_elements(public.sync_push(
      $j$[{"id": 1, "table": "hive_status_events", "operation": "delete", "payload": {
        "id": "a5000000-0000-0000-0000-000000000005",
        "org_id": "aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaaa",
        "hive_id": "a3000000-0000-0000-0000-000000000001",
        "apiary_id": "a1000000-0000-0000-0000-000000000001",
        "from_status": "active", "to_status": "lost",
        "changed_at": "2027-02-10T09:00:00.000Z", "loss_reason": null,
        "created_at": "2027-02-10T09:00:00.000Z",
        "updated_at": "2027-02-10T09:05:00.000Z",
        "created_by": null, "deleted_at": "2027-02-10T09:05:00.000Z"}}]$j$::jsonb,
      now(), 23) -> 'results') r$$,
  $$values ('ok', 'true')$$,
  'sync_push olayın silinmesini işler'
);

select results_eq(
  $$select to_status::text, loss_reason::text, deleted_at is not null
    from public.hive_status_events
    where id = 'a5000000-0000-0000-0000-000000000005'$$,
  $$values ('dead', 'varroa', true)$$,
  'olay kaydı: silme yalnız deleted_at yazar, diğer alanlar değişmez'
);

-- A'nın viewer'ı
set local request.jwt.claims = '{"sub": "55555555-5555-5555-5555-555555555555"}';

select throws_ok(
  $$insert into public.hive_status_events
      (id, org_id, hive_id, apiary_id, from_status, to_status, changed_at)
    values ('a5000000-0000-0000-0000-000000000006', 'aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaaa',
            'a3000000-0000-0000-0000-000000000001', 'a1000000-0000-0000-0000-000000000001',
            'dead', 'active', now())$$,
  '42501',
  null,
  'viewer olay ekleyemez, ama işletmenin olaylarını görür'
);

select * from finish();
rollback;
