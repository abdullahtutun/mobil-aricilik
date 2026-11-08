-- İşletme profili: işletme türü, avatar rengi, logo yolu, eski sürümlerin
-- gönderdiği üye adı (artık yok sayılır), logo bucket'ı ve sync_push v24.
begin;
create extension if not exists pgtap with schema extensions;
select plan(16);

-- Kullanıcılar: 1111 owner, 2222 partner, 3333 worker, 5555 viewer,
-- 9999 başka işletmenin owner'ı.
insert into auth.users (id, email) values
  ('11111111-1111-1111-1111-111111111111', 'owner@test.local'),
  ('22222222-2222-2222-2222-222222222222', 'partner@test.local'),
  ('33333333-3333-3333-3333-333333333333', 'worker@test.local'),
  ('55555555-5555-5555-5555-555555555555', 'viewer@test.local'),
  ('99999999-9999-9999-9999-999999999999', 'other@test.local');

insert into public.organizations (id, name, country_code, currency, created_by, updated_at) values
  ('aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaaa', 'Petek Arıcılık', 'TR', 'TRY',
   '11111111-1111-1111-1111-111111111111', '2026-10-01 00:00Z'),
  ('eeeeeeee-eeee-eeee-eeee-eeeeeeeeeeee', 'Başka İşletme', 'TR', 'TRY',
   '99999999-9999-9999-9999-999999999999', '2026-10-01 00:00Z');

insert into public.memberships (id, org_id, user_id, role, updated_at) values
  ('c0000000-0000-0000-0000-000000000001', 'aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaaa',
   '11111111-1111-1111-1111-111111111111', 'owner', '2026-10-01 00:00Z'),
  ('c0000000-0000-0000-0000-000000000002', 'aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaaa',
   '22222222-2222-2222-2222-222222222222', 'partner', '2026-10-01 00:00Z'),
  ('c0000000-0000-0000-0000-000000000003', 'aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaaa',
   '33333333-3333-3333-3333-333333333333', 'worker', '2026-10-01 00:00Z'),
  ('c0000000-0000-0000-0000-000000000005', 'aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaaa',
   '55555555-5555-5555-5555-555555555555', 'viewer', '2026-10-01 00:00Z'),
  ('c0000000-0000-0000-0000-000000000009', 'eeeeeeee-eeee-eeee-eeee-eeeeeeeeeeee',
   '99999999-9999-9999-9999-999999999999', 'owner', '2026-10-01 00:00Z');

select is(
  (select operation_type::text from public.organizations
   where id = 'aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaaa'),
  'migratory',
  'var olan işletme gezginci kalır'
);

select throws_ok(
  $$update public.organizations
    set logo_path = 'eeeeeeee-eeee-eeee-eeee-eeeeeeeeeeee/f0000000-0000-0000-0000-000000000001.jpg'
    where id = 'aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaaa'$$,
  '23514',
  null,
  'logo yolu başka işletmenin klasöründe olamaz'
);

set local role authenticated;

-- Kurulum: sabit işletme
set local request.jwt.claims = '{"sub": "99999999-9999-9999-9999-999999999999"}';

select is(
  (select operation_type::text from public.create_organization(
    'bbbbbbbb-bbbb-bbbb-bbbb-bbbbbbbbbbbb', 'Sabit Arıcılık', 'TR', 'TRY',
    'up_to_10', 'stationary')),
  'stationary',
  'create_organization işletme türünü yazar'
);

select is(
  (select operation_type::text from public.create_organization(
    'b2222222-bbbb-bbbb-bbbb-bbbbbbbbbbbb', 'Varsayılan', 'TR', 'TRY')),
  'migratory',
  'tür verilmezse gezginci'
);

-- Partner işletmeyi sync_push ile günceller
set local request.jwt.claims = '{"sub": "22222222-2222-2222-2222-222222222222"}';

create temp table org_payload as select $${
  "id": "aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaaa",
  "name": "Petek Arıcılık Ltd.", "country_code": "TR", "currency": "EUR",
  "tr_registration_no": null, "tr_aks_no": null, "hive_count_range": null,
  "tr_aks_hive_count": null, "operation_type": "stationary",
  "avatar_color": "honey",
  "logo_path": "aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaaa/f0000000-0000-0000-0000-000000000001.jpg",
  "created_at": "2026-10-01T00:00:00Z", "updated_at": "2026-11-05T10:00:00Z",
  "created_by": null, "deleted_at": null}$$::jsonb as payload;
grant select on org_payload to authenticated;

select is(
  public.sync_push(
    jsonb_build_array(jsonb_build_object('id', 1, 'table', 'organizations',
      'operation', 'upsert', 'payload', (select payload from org_payload))),
    now(), 24
  ) -> 'results' -> 0 ->> 'status',
  'ok',
  'partner işletmeyi sync_push ile günceller'
);

select results_eq(
  $$select name, currency, operation_type::text, avatar_color::text
    from public.organizations where id = 'aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaaa'$$,
  $$values ('Petek Arıcılık Ltd.', 'EUR', 'stationary', 'honey')$$,
  'işletmenin yeni alanları yazıldı'
);

-- Worker ve viewer güncelleyemez
set local request.jwt.claims = '{"sub": "33333333-3333-3333-3333-333333333333"}';

select is(
  public.sync_push(
    jsonb_build_array(jsonb_build_object('id', 1, 'table', 'organizations',
      'operation', 'upsert', 'payload', (select payload from org_payload)
        || '{"operation_type": "migratory", "updated_at": "2026-11-06T00:00:00Z"}')),
    now(), 24
  ) -> 'results' -> 0 ->> 'reason',
  'forbidden',
  'worker işletmeyi güncelleyemez'
);

set local request.jwt.claims = '{"sub": "55555555-5555-5555-5555-555555555555"}';

select is_empty(
  $$update public.organizations set operation_type = 'migratory' returning id$$,
  'viewer işletmeyi güncelleyemez'
);

-- Eski sürüm üyenin adını gönderir: kayıt kabul edilir ama uygulanmaz
-- (20261116120000_drop_personal_names).
set local request.jwt.claims = '{"sub": "33333333-3333-3333-3333-333333333333"}';

select is(
  public.sync_push(
    $$[{"id": 1, "table": "memberships", "operation": "upsert", "payload": {
      "id": "c0000000-0000-0000-0000-000000000003",
      "org_id": "aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaaa",
      "user_id": "33333333-3333-3333-3333-333333333333",
      "role": "owner", "full_name": "  Mehmet Kaya ",
      "created_at": "2026-10-01T00:00:00Z", "updated_at": "2026-11-05T10:00:00Z",
      "created_by": null, "deleted_at": null}}]$$::jsonb,
    now(), 24
  ) -> 'results' -> 0,
  '{"id": 1, "status": "ok", "applied": false}'::jsonb,
  'eski sürümün gönderdiği ad yok sayılır'
);

select results_eq(
  $$select role::text, updated_at from public.memberships
    where id = 'c0000000-0000-0000-0000-000000000003'$$,
  $$values ('worker', '2026-10-01 00:00Z'::timestamptz)$$,
  'üyelik değişmez, payload''daki rol yok sayılır'
);

select is(
  public.sync_push(
    $$[{"id": 1, "table": "memberships", "operation": "upsert", "payload": {
      "id": "c0000000-0000-0000-0000-000000000001",
      "full_name": "Sahte", "updated_at": "2026-11-05T10:00:00Z"}}]$$::jsonb,
    now(), 24
  ) -> 'results' -> 0 ->> 'reason',
  'forbidden',
  'başkasının adı yazılamaz'
);

select is(
  public.sync_push(
    $$[{"id": 1, "table": "memberships", "operation": "delete", "payload": {
      "id": "c0000000-0000-0000-0000-000000000003",
      "updated_at": "2026-11-05T11:00:00Z",
      "deleted_at": "2026-11-05T11:00:00Z"}}]$$::jsonb,
    now(), 24
  ) -> 'results' -> 0 ->> 'reason',
  'unsupported',
  'üyelik senkronla silinmez'
);

select is_empty(
  $$update public.memberships set role = 'owner'
    where id = 'c0000000-0000-0000-0000-000000000003' returning id$$,
  'worker rolünü doğrudan değiştiremez'
);

-- Logo bucket'ı
set local request.jwt.claims = '{"sub": "33333333-3333-3333-3333-333333333333"}';

select throws_ok(
  $$insert into storage.objects (bucket_id, name, owner_id)
    values ('org-logos',
      'aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaaa/f0000000-0000-0000-0000-000000000002.jpg',
      '33333333-3333-3333-3333-333333333333')$$,
  '42501',
  null,
  'worker logo yükleyemez'
);

set local request.jwt.claims = '{"sub": "22222222-2222-2222-2222-222222222222"}';

select lives_ok(
  $$insert into storage.objects (bucket_id, name, owner_id)
    values ('org-logos',
      'aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaaa/f0000000-0000-0000-0000-000000000001.jpg',
      '22222222-2222-2222-2222-222222222222')$$,
  'partner logo yükler'
);

set local request.jwt.claims = '{"sub": "99999999-9999-9999-9999-999999999999"}';

select is_empty(
  $$select name from storage.objects where bucket_id = 'org-logos'$$,
  'başka işletme logoyu göremez'
);

select * from finish();
rollback;
