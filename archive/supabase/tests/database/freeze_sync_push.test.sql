-- sync_push dondu (P10.1, 20261118120000_freeze_sync_push): her şema sürümü
-- PT426 alır, hiçbir şey yazılmaz; okuma ve yetkiler değişmez.
begin;
create extension if not exists pgtap with schema extensions;
select plan(7);

insert into auth.users (id, email) values
  ('11111111-1111-1111-1111-111111111111', 'owner@test.local');

insert into public.organizations (id, name, country_code, currency, created_by, updated_at) values
  ('aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaaa', 'Petek Arıcılık', 'TR', 'TRY',
   '11111111-1111-1111-1111-111111111111', '2026-10-01 00:00Z');

insert into public.memberships (id, org_id, user_id, role) values
  ('c0000000-0000-0000-0000-000000000001', 'aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaaa',
   '11111111-1111-1111-1111-111111111111', 'owner');

-- Bir gönderimin sonucu: 'ok' ya da hata kodu.
create function public.freeze_test_push(version integer, changes jsonb)
returns text
language plpgsql
set search_path = ''
as $$
begin
  perform public.sync_push(changes, now(), version);
  return 'ok';
exception when others then
  return sqlstate;
end;
$$;
grant execute on function public.freeze_test_push(integer, jsonb) to authenticated;

create temp table packet as
select $$[
  {"id": 1, "table": "apiaries", "operation": "upsert", "payload": {
    "id": "a1000000-0000-0000-0000-000000000001",
    "org_id": "aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaaa",
    "name": "Yayla",
    "created_at": "2026-11-13T08:00:00.000Z",
    "updated_at": "2026-11-13T08:00:00.000Z",
    "latitude": null, "longitude": null, "altitude_m": null,
    "land_tenure": null, "water_source": null, "vehicle_distance_m": null,
    "road_notes": null, "notes": null, "created_by": null, "deleted_at": null}}
]$$::jsonb as changes;
grant select on packet to authenticated;

set local role authenticated;
set local request.jwt.claims = '{"sub": "11111111-1111-1111-1111-111111111111"}';

select is(
  array(select public.freeze_test_push(v, '[]') from generate_series(0, 40) v),
  array_fill('PT426'::text, array[41]),
  '0–40 arasındaki her şema sürümü PT426 alır (boş paket)'
);

select is(
  array(select public.freeze_test_push(v, (select changes from packet)) from generate_series(1, 26) v),
  array_fill('PT426'::text, array[26]),
  'dondurmadan önce desteklenen 1–26 dolu pakette de PT426 alır'
);

select throws_ok(
  $$select public.sync_push('[]', now(), null)$$,
  'PT426',
  null,
  'şema sürümü verilmezse PT426'
);

select throws_ok(
  $$select public.sync_push((select changes from packet), now(), 26)$$,
  'PT426',
  'Desteklenmeyen şema sürümü: 26',
  'güncel Drift sürümü (26) reddedilir'
);

select is(
  (select count(*) from public.apiaries where org_id = 'aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaaa'),
  0::bigint,
  'reddedilen gönderimler hiçbir şey yazmaz'
);

select is(
  (select count(*) from public.organizations where id = 'aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaaa'),
  1::bigint,
  'okuma sürer: üye kendi işletmesini görür'
);

-- Giriş yapmamış: yetki değişmedi, fonksiyona hiç giremez.
set local role anon;

select throws_ok(
  $$select public.sync_push('[]', now(), 26)$$,
  '42501',
  null,
  'anon sync_push çağıramaz'
);

select * from finish();
rollback;
