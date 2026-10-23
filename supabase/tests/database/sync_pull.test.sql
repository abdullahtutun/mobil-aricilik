-- sync_pull: sayfalama ve geriye bakma payı, silinen satırın gelmesi,
-- başka işletmenin satırının gelmemesi.
begin;
create extension if not exists pgtap with schema extensions;
select plan(13);

-- Kullanıcılar: 1111 A'nın owner'ı, 9999 B'nin owner'ı.
insert into auth.users (id, email) values
  ('11111111-1111-1111-1111-111111111111', 'owner@test.local'),
  ('99999999-9999-9999-9999-999999999999', 'other@test.local');

-- aaaa: A işletmesi. eeee: B işletmesi.
insert into public.organizations (id, name, country_code, currency, created_by) values
  ('aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaaa', 'Petek Arıcılık', 'TR', 'TRY',
   '11111111-1111-1111-1111-111111111111'),
  ('eeeeeeee-eeee-eeee-eeee-eeeeeeeeeeee', 'Başka İşletme', 'TR', 'TRY',
   '99999999-9999-9999-9999-999999999999');

insert into public.memberships (id, org_id, user_id, role) values
  ('c0000000-0000-0000-0000-000000000001', 'aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaaa',
   '11111111-1111-1111-1111-111111111111', 'owner'),
  ('c0000000-0000-0000-0000-000000000009', 'eeeeeeee-eeee-eeee-eeee-eeeeeeeeeeee',
   '99999999-9999-9999-9999-999999999999', 'owner');

-- server_seq ekleme sırasıyla artar; B'nin arılıkları A'nınkilerin arasında.
insert into public.apiaries (id, org_id, name, location) values
  ('a1000000-0000-0000-0000-000000000001', 'aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaaa',
   'A1', 'SRID=4326;POINT(40.52 40.98)'),
  ('e1000000-0000-0000-0000-000000000001', 'eeeeeeee-eeee-eeee-eeee-eeeeeeeeeeee',
   'B1', null),
  ('a1000000-0000-0000-0000-000000000002', 'aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaaa',
   'A2', null),
  ('a1000000-0000-0000-0000-000000000003', 'aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaaa',
   'A3', null),
  ('e1000000-0000-0000-0000-000000000002', 'eeeeeeee-eeee-eeee-eeee-eeeeeeeeeeee',
   'B2', null),
  ('a1000000-0000-0000-0000-000000000004', 'aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaaa',
   'A4', null);

-- Ardından 1000 numara daha dağıtılmış gibi: bu satırlar geriye bakma
-- payının (1000) altında kalır, oturmuş sayılır.
do $$
begin
  perform setval('private.sync_seq', (select last_value from private.sync_seq) + 1000);
end;
$$;

set local role authenticated;

-- A'nın owner'ı
set local request.jwt.claims = '{"sub": "11111111-1111-1111-1111-111111111111"}';

-- A'nın arılığının şu anki server_seq'i.
create function pg_temp.seq_of(apiary_name text)
returns bigint
language sql
as $$
  select server_seq from public.apiaries where name = apiary_name
$$;

-- Yanıttaki satırların adları, yanıttaki sırayla.
create function pg_temp.names(response jsonb)
returns text[]
language sql
as $$
  select coalesce(array_agg(r ->> 'name' order by n), '{}')
  from jsonb_array_elements(response -> 'rows') with ordinality as e (r, n)
$$;

-- Sayfalama

create temp table page1 as
select public.sync_pull('apiaries', 0, 2) as response;

select results_eq(
  $$select r ->> 'name', (r ->> 'latitude')::float8, (r ->> 'longitude')::float8,
           r ? 'location'
    from page1, jsonb_array_elements(response -> 'rows') with ordinality as e (r, n)
    order by n$$,
  $$values ('A1', 40.98::float8, 40.52::float8, false), ('A2', null, null, false)$$,
  'ilk sayfa A''nın ilk iki satırı; aradaki B satırı sayılmaz, konum enlem ve boylam olur'
);

select is(
  (select response - 'rows' from page1),
  jsonb_build_object('next_seq', pg_temp.seq_of('A2'), 'has_more', true),
  'dolu sayfa son satırın server_seq''ini ve has_more döner'
);

create temp table page2 as
select public.sync_pull('apiaries', (select (response ->> 'next_seq')::bigint from page1), 2)
  as response;

select is(
  (select pg_temp.names(response) from page2),
  array['A3', 'A4'],
  'ikinci sayfa imleçten sonraki satırlarla devam eder'
);

select is(
  (select response - 'rows' from page2),
  jsonb_build_object('next_seq', pg_temp.seq_of('A4'), 'has_more', false),
  'son sayfa tam dolsa da has_more false döner'
);

create temp table page3 as
select public.sync_pull('apiaries', (select (response ->> 'next_seq')::bigint from page2), 2)
  as response;

select is(
  (select response from page3),
  jsonb_build_object('rows', '[]'::jsonb, 'next_seq', pg_temp.seq_of('A4'), 'has_more', false),
  'yeni satır yoksa boş sayfa döner, imleç yerinde kalır'
);

-- Geriye bakma payı: T1 numarasını alır ama geç commit eder; T2 sonra
-- numara alır ve önce commit eder.

reset role;

insert into public.apiaries (id, org_id, name) values
  ('a1000000-0000-0000-0000-000000000005', 'aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaaa', 'A5');

-- T1'in numarası; satırı henüz görünmüyor.
create temp table t1_seq as
select nextval('private.sync_seq') as seq;

-- T2
insert into public.apiaries (id, org_id, name) values
  ('a1000000-0000-0000-0000-000000000006', 'aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaaa', 'A6');

set local role authenticated;

create temp table fresh1 as
select public.sync_pull('apiaries', (select (response ->> 'next_seq')::bigint from page3), 2)
  as response;

select is(
  (select pg_temp.names(response) from fresh1),
  array['A5', 'A6'],
  'taze satırlar hemen döner'
);

select cmp_ok(
  (select (response ->> 'next_seq')::bigint from fresh1),
  '<',
  pg_temp.seq_of('A5'),
  'imleç taze satırları ve aralarındaki T1 numarasını geçmez'
);

reset role;

-- T1 commit eder: satırı ayırdığı numarayla görünür. Trigger yeni numara
-- vereceği için bu satırda kapalı.
alter table public.apiaries disable trigger set_server_seq;
insert into public.apiaries (id, org_id, name, server_seq)
select 'a1000000-0000-0000-0000-000000000007', 'aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaaa', 'A7', seq
from t1_seq;
alter table public.apiaries enable trigger set_server_seq;

set local role authenticated;

-- İmleç taze bölgede; limit 1.
create temp table fresh2 as
select public.sync_pull('apiaries', (select (response ->> 'next_seq')::bigint from fresh1), 1)
  as response;

select is(
  (select pg_temp.names(response) from fresh2),
  array['A5', 'A7', 'A6'],
  'geç commit edilen T1 satırı kaçmaz, kendi sırasında gelir'
);

select is(
  (select response - 'rows' from fresh2),
  jsonb_build_object(
    'next_seq', (select (response ->> 'next_seq')::bigint from fresh1),
    'has_more', false),
  'taze bölge limite bakılmadan tek sayfada döner, döngü takılmaz'
);

-- Silinen satır

-- A2 ilk sayfada gelmişti; imleç onu çoktan geçti.
update public.apiaries
set deleted_at = '2026-10-23 10:00Z', updated_at = '2026-10-23 10:00Z'
where id = 'a1000000-0000-0000-0000-000000000002';

create temp table after_delete as
select public.sync_pull('apiaries', (select (response ->> 'next_seq')::bigint from fresh2), 10)
  as response;

select results_eq(
  $$select r ->> 'name', (r ->> 'deleted_at')::timestamptz
    from after_delete, jsonb_array_elements(response -> 'rows') with ordinality as e (r, n)
    order by n$$,
  $$values ('A5', null::timestamptz), ('A7', null), ('A6', null),
           ('A2', '2026-10-23 10:00Z')$$,
  'silinen satır deleted_at ile ve yeni server_seq''iyle sonda gelir'
);

-- Başka işletme

select is(
  pg_temp.names(public.sync_pull('apiaries', 0, 100)),
  array['A1', 'A3', 'A4', 'A5', 'A7', 'A6', 'A2'],
  'baştan çekme A''nın bütün satırlarını sırayla verir, B''ninkileri vermez'
);

select results_eq(
  $$select r ->> 'id'
    from jsonb_array_elements(public.sync_pull('organizations', 0, 100) -> 'rows') as e (r)$$,
  $$values ('aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaaa')$$,
  'işletmelerden yalnız üyesi olunan gelir'
);

-- B'nin owner'ı
set local request.jwt.claims = '{"sub": "99999999-9999-9999-9999-999999999999"}';

select is(
  pg_temp.names(public.sync_pull('apiaries', 0, 100)),
  array['B1', 'B2'],
  'B yalnız kendi arılıklarını alır'
);

select * from finish();
rollback;
