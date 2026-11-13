-- sync_push muayeneyi olay kaydı olarak yazar: şema sürümü 2 kabul edilir,
-- aynı kayıt iki kez gelse de tek satır kalır, eklenen muayene sonradan
-- değişmez, silme bir kez işlenir.
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

select plan(8);

insert into auth.users (id, email) values
  ('33333333-3333-3333-3333-333333333333', 'worker@test.local'),
  ('55555555-5555-5555-5555-555555555555', 'viewer@test.local');

insert into public.organizations (id, name, country_code, currency, created_by) values
  ('aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaaa', 'Petek Arıcılık', 'TR', 'TRY',
   '33333333-3333-3333-3333-333333333333');

insert into public.memberships (id, org_id, user_id, role) values
  ('c0000000-0000-0000-0000-000000000003', 'aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaaa',
   '33333333-3333-3333-3333-333333333333', 'worker'),
  ('c0000000-0000-0000-0000-000000000005', 'aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaaa',
   '55555555-5555-5555-5555-555555555555', 'viewer');

insert into public.apiaries (id, org_id, name) values
  ('a1000000-0000-0000-0000-000000000001', 'aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaaa', 'Yayla');

insert into public.hives (id, org_id, number, type, apiary_id) values
  ('a3000000-0000-0000-0000-000000000001', 'aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaaa',
   '101', 'langstroth', 'a1000000-0000-0000-0000-000000000001');

set local role authenticated;
set local request.jwt.claims = '{"sub": "33333333-3333-3333-3333-333333333333"}';

-- İstemcinin outbox payload'u: Inspection.toJson, data bir JSON nesnesi.
create temp table inspection as
select $${
  "id": "a5000000-0000-0000-0000-000000000001",
  "org_id": "aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaaa",
  "hive_id": "a3000000-0000-0000-0000-000000000001",
  "apiary_id": "a1000000-0000-0000-0000-000000000001",
  "inspected_at": "2026-10-24T09:00:00.000Z",
  "queen_state": "seen", "bee_frames": 8, "brood_frames": 5,
  "honey_frames": 2, "temperament": "calm", "swarm_signs": false,
  "queen_cells": "none", "disease_suspected": false,
  "data": {"actions": ["super_added"]},
  "created_at": "2026-10-24T09:00:00.000Z",
  "updated_at": "2026-10-24T09:00:00.000Z",
  "created_by": null, "deleted_at": null}$$::jsonb as payload;

create function pg_temp.push(operation text, patch jsonb)
returns text
language sql
as $$
  select coalesce(r ->> 'applied', r ->> 'reason')
  from inspection,
    jsonb_array_elements(
      public.sync_push(
        jsonb_build_array(jsonb_build_object(
          'id', 1, 'table', 'inspections', 'operation', operation,
          'payload', payload || patch)),
        now(), 2
      ) -> 'results'
    ) as r
$$;

select is(pg_temp.push('upsert', '{}'), 'true', 'şema sürümü 2 ile muayene yazılır');

select results_eq(
  $$select bee_frames, queen_state::text, data -> 'actions' ->> 0, created_by
    from public.inspections where id = 'a5000000-0000-0000-0000-000000000001'$$,
  $$values (8::smallint, 'seen', 'super_added',
            '33333333-3333-3333-3333-333333333333'::uuid)$$,
  'kolonlar, data nesnesi ve ekleyen kullanıcı yazılır'
);

select is(pg_temp.push('upsert', '{}'), 'false', 'aynı kayıt ikinci kez yazılmaz');

select is(
  pg_temp.push('upsert', '{"bee_frames": 3, "updated_at": "2026-10-24T10:00:00.000Z"}'),
  'false',
  'eklenmiş muayene daha yeni updated_at ile de değişmez'
);

select results_eq(
  $$select bee_frames from public.inspections
    where id = 'a5000000-0000-0000-0000-000000000001'$$,
  $$values (8::smallint)$$,
  'çerçeve sayısı ilk yazılan değerde kalır'
);

select is(
  pg_temp.push('delete', '{"deleted_at": "2026-10-24T10:00:00.000Z", "updated_at": "2026-10-24T10:00:00.000Z"}'),
  'true',
  'silme işlenir'
);

select is(
  pg_temp.push('upsert', '{}'),
  'false',
  'eski paket silinen muayeneyi geri getirmez'
);

set local request.jwt.claims = '{"sub": "55555555-5555-5555-5555-555555555555"}';

select is(
  pg_temp.push('upsert', '{"id": "a5000000-0000-0000-0000-000000000002"}'),
  'forbidden',
  'viewer muayene gönderemez'
);

select * from finish();
rollback;
