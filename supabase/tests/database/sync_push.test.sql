-- sync_push: aynı paket iki kez zararsız, eski updated_at yazmaz, başka
-- işletmeye yazma reddedilir, silme durum ve olay kayıtlarına işlenir.
begin;
create extension if not exists pgtap with schema extensions;
select plan(27);

-- Kullanıcılar: 1111 A'nın owner'ı, 3333 A'da worker, 5555 A'da viewer,
-- 9999 B'nin owner'ı.
insert into auth.users (id, email) values
  ('11111111-1111-1111-1111-111111111111', 'owner@test.local'),
  ('33333333-3333-3333-3333-333333333333', 'worker@test.local'),
  ('55555555-5555-5555-5555-555555555555', 'viewer@test.local'),
  ('99999999-9999-9999-9999-999999999999', 'other@test.local');

-- aaaa: A işletmesi. eeee: B işletmesi.
insert into public.organizations (id, name, country_code, currency, created_by, updated_at) values
  ('aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaaa', 'Petek Arıcılık', 'TR', 'TRY',
   '11111111-1111-1111-1111-111111111111', '2026-10-01 00:00Z'),
  ('eeeeeeee-eeee-eeee-eeee-eeeeeeeeeeee', 'Başka İşletme', 'TR', 'TRY',
   '99999999-9999-9999-9999-999999999999', '2026-10-01 00:00Z');

insert into public.memberships (id, org_id, user_id, role) values
  ('c0000000-0000-0000-0000-000000000001', 'aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaaa',
   '11111111-1111-1111-1111-111111111111', 'owner'),
  ('c0000000-0000-0000-0000-000000000003', 'aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaaa',
   '33333333-3333-3333-3333-333333333333', 'worker'),
  ('c0000000-0000-0000-0000-000000000005', 'aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaaa',
   '55555555-5555-5555-5555-555555555555', 'viewer'),
  ('c0000000-0000-0000-0000-000000000009', 'eeeeeeee-eeee-eeee-eeee-eeeeeeeeeeee',
   '99999999-9999-9999-9999-999999999999', 'owner');

-- B'nin arılığı ve kovanı.
insert into public.apiaries (id, org_id, name) values
  ('e1000000-0000-0000-0000-000000000001', 'eeeeeeee-eeee-eeee-eeee-eeeeeeeeeeee', 'Ova');

insert into public.hives (id, org_id, number, type, apiary_id, updated_at) values
  ('e3000000-0000-0000-0000-000000000001', 'eeeeeeee-eeee-eeee-eeee-eeeeeeeeeeee',
   '201', 'dadant', 'e1000000-0000-0000-0000-000000000001', '2026-10-01 00:00Z');

set local role authenticated;

-- A'nın worker'ı
set local request.jwt.claims = '{"sub": "33333333-3333-3333-3333-333333333333"}';

-- Yeni arılık, kovan ve kovanın ilk arılık kaydı; outbox'taki gibi
-- oluşturulma sırasıyla. Kovanın created_by'ı başkası adına sahte.
create temp table packet as
select $$[
  {"id": 1, "table": "apiaries", "operation": "upsert", "payload": {
    "id": "a1000000-0000-0000-0000-000000000001",
    "org_id": "aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaaa",
    "name": "Yayla",
    "created_at": "2026-10-23T08:00:00.000Z",
    "updated_at": "2026-10-23T08:00:00.000Z",
    "latitude": 40.98, "longitude": 40.52, "altitude_m": null,
    "landowner_name": null, "landowner_phone": null, "land_tenure": null,
    "water_source": null, "vehicle_distance_m": null, "road_notes": null,
    "notes": null, "created_by": null, "deleted_at": null}},
  {"id": 2, "table": "hives", "operation": "upsert", "payload": {
    "id": "a3000000-0000-0000-0000-000000000001",
    "org_id": "aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaaa",
    "number": "101", "type": "langstroth",
    "apiary_id": "a1000000-0000-0000-0000-000000000001",
    "created_at": "2026-10-23T08:00:00.000Z",
    "updated_at": "2026-10-23T08:00:00.000Z",
    "status": "active", "tag_code": null, "queen_id": null, "box_count": 1,
    "frame_count": null, "source": null, "marking": null,
    "created_by": "99999999-9999-9999-9999-999999999999", "deleted_at": null}},
  {"id": 3, "table": "hive_location_history", "operation": "upsert", "payload": {
    "id": "a4000000-0000-0000-0000-000000000001",
    "org_id": "aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaaa",
    "hive_id": "a3000000-0000-0000-0000-000000000001",
    "apiary_id": "a1000000-0000-0000-0000-000000000001",
    "moved_at": "2026-10-23T08:00:00.000Z",
    "created_at": "2026-10-23T08:00:00.000Z",
    "updated_at": "2026-10-23T08:00:00.000Z",
    "created_by": null, "deleted_at": null}}
]$$::jsonb as changes;

-- Paketin [packet_index]. kaydının patch ile değiştirilmiş hâli.
create function pg_temp.changed(outbox_id int, packet_index int, operation text, patch jsonb)
returns jsonb
language sql
as $$
  select jsonb_build_object(
    'id', outbox_id,
    'table', changes -> packet_index ->> 'table',
    'operation', operation,
    'payload', (changes -> packet_index -> 'payload') || patch
  )
  from packet
$$;

-- Yanıttaki sonuçlar sırasıyla: ok satırda applied, rejected satırda reason.
create function pg_temp.outcomes(response jsonb)
returns table (id int, status text, detail text)
language sql
as $$
  select (r ->> 'id')::int, r ->> 'status', coalesce(r ->> 'applied', r ->> 'reason')
  from jsonb_array_elements(response -> 'results') with ordinality as e (r, n)
  order by n
$$;

-- Şema sürümü

select throws_ok(
  $$select public.sync_push('[]', now(), 2)$$,
  'PT426',
  null,
  'desteklenmeyen şema sürümü reddedilir'
);

select throws_ok(
  $$select public.sync_push('[]', now(), null)$$,
  'PT426',
  null,
  'şema sürümü verilmezse reddedilir'
);

-- Aynı paket iki kez

create temp table first_push as
select public.sync_push((select changes from packet), now(), 1) as response;

select results_eq(
  'select * from pg_temp.outcomes((select response from first_push))',
  $$values (1, 'ok', 'true'), (2, 'ok', 'true'), (3, 'ok', 'true')$$,
  'ilk gönderim üç satırı da yazar ve sonuçları paketin sırasıyla döner'
);

select results_eq(
  $$select extensions.st_astext(location::extensions.geometry) from public.apiaries
    where id = 'a1000000-0000-0000-0000-000000000001'$$,
  $$values ('POINT(40.52 40.98)')$$,
  'enlem ve boylam arılığın konum noktasına çevrilir'
);

select results_eq(
  $$select created_by from public.hives
    where id = 'a3000000-0000-0000-0000-000000000001'$$,
  $$values ('33333333-3333-3333-3333-333333333333'::uuid)$$,
  'created_by çağırandır; istemcinin gönderdiği değer yok sayılır'
);

create temp table seq_after_first as
select server_seq from public.apiaries where id = 'a1000000-0000-0000-0000-000000000001'
union all
select server_seq from public.hives where id = 'a3000000-0000-0000-0000-000000000001'
union all
select server_seq from public.hive_location_history
where id = 'a4000000-0000-0000-0000-000000000001';

create temp table second_push as
select public.sync_push((select changes from packet), now(), 1) as response;

select results_eq(
  'select * from pg_temp.outcomes((select response from second_push))',
  $$values (1, 'ok', 'false'), (2, 'ok', 'false'), (3, 'ok', 'false')$$,
  'aynı paket ikinci kez gelince ok döner ama yazmaz'
);

select results_eq(
  $$select server_seq from public.apiaries where id = 'a1000000-0000-0000-0000-000000000001'
    union all
    select server_seq from public.hives where id = 'a3000000-0000-0000-0000-000000000001'
    union all
    select server_seq from public.hive_location_history
    where id = 'a4000000-0000-0000-0000-000000000001'$$,
  'select server_seq from seq_after_first',
  'ikinci gönderim satırlara dokunmaz, server_seq ilerlemez'
);

select results_eq(
  $$select
      (select count(*) from public.apiaries),
      (select count(*) from public.hives),
      (select count(*) from public.hive_location_history)$$,
  $$values (1::bigint, 1::bigint, 1::bigint)$$,
  'ikinci gönderim yeni satır açmaz'
);

-- Eski updated_at

select results_eq(
  $$select * from pg_temp.outcomes(public.sync_push(
      jsonb_build_array(pg_temp.changed(4, 1, 'upsert',
        '{"number": "999", "updated_at": "2026-10-23T07:00:00Z"}')),
      now(), 1))$$,
  $$values (4, 'ok', 'false')$$,
  'eski updated_at ok döner ama yazmaz'
);

select results_eq(
  $$select number from public.hives where id = 'a3000000-0000-0000-0000-000000000001'$$,
  $$values ('101')$$,
  'eski yazma kovanı değiştirmez'
);

select results_eq(
  $$select * from pg_temp.outcomes(public.sync_push(
      jsonb_build_array(pg_temp.changed(5, 1, 'upsert',
        '{"number": "102", "updated_at": "2026-10-23T09:00:00Z"}')),
      now(), 1))$$,
  $$values (5, 'ok', 'true')$$,
  'daha yeni updated_at yazar'
);

select results_eq(
  $$select number, updated_at from public.hives
    where id = 'a3000000-0000-0000-0000-000000000001'$$,
  $$values ('102', '2026-10-23 09:00Z'::timestamptz)$$,
  'yeni yazma kovanı ve updated_at''i günceller'
);

-- Yetkisiz işletme

-- 6: B'ye arılık. 7: B'nin kovanı, B adına. 8: B'nin kovanı, A adına ve
-- sunucudakinden eski updated_at ile. 9: A'ya geçerli yeni kovan.
select results_eq(
  $$select * from pg_temp.outcomes(public.sync_push(
      jsonb_build_array(
        pg_temp.changed(6, 0, 'upsert',
          '{"id": "a1000000-0000-0000-0000-000000000002",
            "org_id": "eeeeeeee-eeee-eeee-eeee-eeeeeeeeeeee"}'),
        pg_temp.changed(7, 1, 'upsert',
          '{"id": "e3000000-0000-0000-0000-000000000001",
            "org_id": "eeeeeeee-eeee-eeee-eeee-eeeeeeeeeeee",
            "apiary_id": "e1000000-0000-0000-0000-000000000001",
            "updated_at": "2026-10-23T09:00:00Z"}'),
        pg_temp.changed(8, 1, 'upsert',
          '{"id": "e3000000-0000-0000-0000-000000000001",
            "updated_at": "2026-01-01T00:00:00Z"}'),
        pg_temp.changed(9, 1, 'upsert',
          '{"id": "a3000000-0000-0000-0000-000000000002", "number": "103"}')),
      now(), 1))$$,
  $$values (6, 'rejected', 'forbidden'), (7, 'rejected', 'forbidden'),
           (8, 'rejected', 'forbidden'), (9, 'ok', 'true')$$,
  'başka işletmeye yazma reddedilir, paketin geri kalanı yazılır'
);

-- A'nın viewer'ı
set local request.jwt.claims = '{"sub": "55555555-5555-5555-5555-555555555555"}';

select results_eq(
  $$select * from pg_temp.outcomes(public.sync_push(
      jsonb_build_array(pg_temp.changed(10, 1, 'upsert',
        '{"number": "viewer", "updated_at": "2026-10-23T11:00:00Z"}')),
      now(), 1))$$,
  $$values (10, 'rejected', 'forbidden')$$,
  'viewer yazamaz'
);

-- B'nin owner'ı
set local request.jwt.claims = '{"sub": "99999999-9999-9999-9999-999999999999"}';

select results_eq(
  'select id, number, updated_at from public.hives',
  $$values ('e3000000-0000-0000-0000-000000000001'::uuid, '201',
            '2026-10-01 00:00Z'::timestamptz)$$,
  'B''nin kovanı değişmedi'
);

select results_eq(
  'select id from public.apiaries',
  $$values ('e1000000-0000-0000-0000-000000000001'::uuid)$$,
  'B''ye arılık eklenmedi'
);

-- İşletme: yalnız owner günceller, sync_push işletme açmaz.

-- A'nın worker'ı
set local request.jwt.claims = '{"sub": "33333333-3333-3333-3333-333333333333"}';

create temp table organization_change as
select $${
  "table": "organizations", "operation": "upsert", "payload": {
    "id": "aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaaa",
    "name": "Petek Arıcılık Ltd.", "country_code": "TR", "currency": "TRY",
    "tr_registration_no": null, "tr_aks_no": null, "hive_count_range": null,
    "created_at": "2026-10-01T00:00:00Z", "updated_at": "2026-10-23T08:00:00Z",
    "created_by": null, "deleted_at": null}
}$$::jsonb as change;

select results_eq(
  $$select * from pg_temp.outcomes(public.sync_push(
      jsonb_build_array((select change from organization_change) || '{"id": 11}'),
      now(), 1))$$,
  $$values (11, 'rejected', 'forbidden')$$,
  'worker işletmeyi güncelleyemez'
);

-- A'nın owner'ı
set local request.jwt.claims = '{"sub": "11111111-1111-1111-1111-111111111111"}';

select results_eq(
  $$select * from pg_temp.outcomes(public.sync_push(
      jsonb_build_array(
        (select change from organization_change) || '{"id": 12}',
        jsonb_set(
          (select change from organization_change) || '{"id": 13}',
          '{payload,id}', '"dddddddd-dddd-dddd-dddd-dddddddddddd"')),
      now(), 1))$$,
  $$values (12, 'ok', 'true'), (13, 'rejected', 'forbidden')$$,
  'owner işletmeyi günceller; yeni işletme açılamaz'
);

-- Silme

-- A'nın worker'ı
set local request.jwt.claims = '{"sub": "33333333-3333-3333-3333-333333333333"}';

select results_eq(
  $$select * from pg_temp.outcomes(public.sync_push(
      jsonb_build_array(
        pg_temp.changed(14, 1, 'delete',
          '{"number": "102", "updated_at": "2026-10-23T10:00:00Z",
            "deleted_at": "2026-10-23T10:00:00Z"}'),
        pg_temp.changed(15, 2, 'delete',
          '{"updated_at": "2026-10-23T10:00:00Z",
            "deleted_at": "2026-10-23T10:00:00Z"}')),
      now(), 1))$$,
  $$values (14, 'ok', 'true'), (15, 'ok', 'true')$$,
  'kovan (durum) ve arılık kaydı (olay) silinir'
);

select results_eq(
  $$select
      (select deleted_at from public.hives
       where id = 'a3000000-0000-0000-0000-000000000001'),
      (select deleted_at from public.hive_location_history
       where id = 'a4000000-0000-0000-0000-000000000001')$$,
  $$values ('2026-10-23 10:00Z'::timestamptz, '2026-10-23 10:00Z'::timestamptz)$$,
  'silme deleted_at''i yazar, satır yerinde kalır'
);

select results_eq(
  $$select * from pg_temp.outcomes(public.sync_push(
      (select changes from packet), now(), 1))$$,
  $$values (1, 'ok', 'false'), (2, 'ok', 'false'), (3, 'ok', 'false')$$,
  'silmeden önceki paket yeniden gelince yazmaz'
);

select results_eq(
  $$select
      (select deleted_at from public.hives
       where id = 'a3000000-0000-0000-0000-000000000001'),
      (select deleted_at from public.hive_location_history
       where id = 'a4000000-0000-0000-0000-000000000001')$$,
  $$values ('2026-10-23 10:00Z'::timestamptz, '2026-10-23 10:00Z'::timestamptz)$$,
  'silinen kovan ve arılık kaydı silinmiş kalır'
);

select results_eq(
  $$select * from pg_temp.outcomes(public.sync_push(
      jsonb_build_array(pg_temp.changed(16, 2, 'delete', '{"deleted_at": null}')),
      now(), 1))$$,
  $$values (16, 'rejected', 'invalid')$$,
  'deleted_at taşımayan silme reddedilir'
);

-- Diğer redler

-- 17: kendini owner yapmaya çalışan üyelik. 18: bilinmeyen kovan tipi.
-- 19: boylamsız konum.
select results_eq(
  $$select * from pg_temp.outcomes(public.sync_push(
      jsonb_build_array(
        jsonb_build_object('id', 17, 'table', 'memberships', 'operation', 'upsert',
          'payload', jsonb_build_object(
            'id', 'c0000000-0000-0000-0000-000000000003',
            'org_id', 'aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaaa',
            'user_id', '33333333-3333-3333-3333-333333333333',
            'role', 'owner', 'updated_at', '2026-10-23T12:00:00Z')),
        pg_temp.changed(18, 1, 'upsert',
          '{"id": "a3000000-0000-0000-0000-000000000003", "type": "kare"}'),
        pg_temp.changed(19, 0, 'upsert',
          '{"longitude": null, "updated_at": "2026-10-23T12:00:00Z"}')),
      now(), 1))$$,
  $$values (17, 'rejected', 'unsupported'), (18, 'rejected', 'invalid'),
           (19, 'rejected', 'invalid')$$,
  'senkronla yazılamayan tablo ve bozuk veri reddedilir'
);

-- Saat sapması

select is(
  public.sync_push('[]', now() - interval '1 hour', 1) -> 'warning',
  '{"code": "clock_skew", "skew_seconds": -3600}'::jsonb,
  'bir saatlik sapma uyarı döner'
);

select is(
  public.sync_push('[]', now() + interval '4 minutes', 1) -> 'warning',
  'null'::jsonb,
  '5 dakikanın altındaki sapma uyarı döndürmez'
);

-- Giriş yapmamış
set local role anon;

select throws_ok(
  $$select public.sync_push('[]', now(), 1)$$,
  '42501',
  null,
  'anon sync_push çağıramaz'
);

select * from finish();
rollback;
