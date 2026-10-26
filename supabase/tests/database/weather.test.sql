-- Hava durumu: weather_locations yalnız üye olunan işletmenin silinmemiş ve
-- konumu olan arılıklarını verir; anon çağıramaz. weather_cache'e uygulama
-- rolleri erişemez, service_role yazar; hücre biçimi denetlenir.
begin;
create extension if not exists pgtap with schema extensions;
select plan(8);

insert into auth.users (id, email) values
  ('55555555-5555-5555-5555-555555555555', 'viewer@test.local'),
  ('99999999-9999-9999-9999-999999999999', 'other@test.local');

insert into public.organizations (id, name, country_code, currency, created_by) values
  ('aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaaa', 'Petek Arıcılık', 'TR', 'TRY',
   '55555555-5555-5555-5555-555555555555'),
  ('eeeeeeee-eeee-eeee-eeee-eeeeeeeeeeee', 'Başka İşletme', 'TR', 'TRY',
   '99999999-9999-9999-9999-999999999999');

insert into public.memberships (id, org_id, user_id, role) values
  ('c0000000-0000-0000-0000-000000000005', 'aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaaa',
   '55555555-5555-5555-5555-555555555555', 'viewer'),
  ('c0000000-0000-0000-0000-000000000009', 'eeeeeeee-eeee-eeee-eeee-eeeeeeeeeeee',
   '99999999-9999-9999-9999-999999999999', 'owner');

-- a1: konumlu, a2: konumsuz, a3: silinmiş, e1: başka işletme.
insert into public.apiaries (id, org_id, name, location, deleted_at) values
  ('a1000000-0000-0000-0000-000000000001', 'aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaaa',
   'Kızılçam', 'SRID=4326;POINT(28.388 37.105)', null),
  ('a1000000-0000-0000-0000-000000000002', 'aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaaa',
   'Yayla', null, null),
  ('a1000000-0000-0000-0000-000000000003', 'aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaaa',
   'Eski', 'SRID=4326;POINT(30 38)', now()),
  ('e1000000-0000-0000-0000-000000000001', 'eeeeeeee-eeee-eeee-eeee-eeeeeeeeeeee',
   'Ova', 'SRID=4326;POINT(32.86 39.93)', null);

set local role authenticated;
set local request.jwt.claims = '{"sub": "55555555-5555-5555-5555-555555555555"}';

select results_eq(
  'select apiary_id, latitude, longitude from public.weather_locations()',
  $$values ('a1000000-0000-0000-0000-000000000001'::uuid, 37.105::float8, 28.388::float8)$$,
  'viewer yalnız kendi işletmesinin silinmemiş, konumlu arılığını alır'
);

select throws_ok(
  'select * from public.weather_cache',
  '42501',
  null,
  'authenticated önbelleği okuyamaz'
);

select throws_ok(
  $$insert into public.weather_cache (cell, forecast) values ('37.11,28.39', '{}')$$,
  '42501',
  null,
  'authenticated önbelleğe yazamaz'
);

reset role;
set local role anon;
set local request.jwt.claims = '{}';

select throws_ok(
  'select * from public.weather_locations()',
  '42501',
  null,
  'anon arılık konumlarını alamaz'
);

select throws_ok(
  'select * from public.weather_cache',
  '42501',
  null,
  'anon önbelleği okuyamaz'
);

reset role;
set local role service_role;

select lives_ok(
  $$insert into public.weather_cache (cell, forecast) values ('-37.11,-128.39', '{}')
    on conflict (cell) do update set forecast = excluded.forecast, fetched_at = now()$$,
  'service_role önbelleğe yazar'
);

select is(
  (select count(*) from public.weather_cache where cell = '-37.11,-128.39'),
  1::bigint,
  'service_role önbelleği okur'
);

select throws_ok(
  $$insert into public.weather_cache (cell, forecast) values ('37.1,28.39', '{}')$$,
  '23514',
  null,
  'hücre iki ondalıklı enlem,boylam olmalı'
);

select * from finish();
rollback;
