-- Kovan karantinası: kolonlar ve tutarlılık; worker sync_push ile alır ve
-- kaldırır; eski uygulamanın (≤ 21) yazması karantinayı korur; sync_push
-- sürüm 22.
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

select plan(12);

insert into auth.users (id, email) values
  ('33333333-3333-3333-3333-333333333333', 'worker@test.local');

insert into public.organizations (id, name, country_code, currency) values
  ('aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaaa', 'Yılmaz Arıcılık', 'TR', 'TRY');

insert into public.memberships (id, org_id, user_id, role) values
  ('c0000000-0000-0000-0000-000000000003', 'aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaaa',
   '33333333-3333-3333-3333-333333333333', 'worker');

insert into public.apiaries (id, org_id, name) values
  ('a1000000-0000-0000-0000-000000000001', 'aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaaa', 'Kızılçam');

insert into public.hives (id, org_id, number, type, apiary_id) values
  ('a3000000-0000-0000-0000-000000000001', 'aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaaa',
   '101', 'langstroth', 'a1000000-0000-0000-0000-000000000001');

select results_eq(
  $$select quarantined, quarantined_at, quarantine_disease from public.hives
    where id = 'a3000000-0000-0000-0000-000000000001'$$,
  $$values (false, null::timestamptz, null::text)$$,
  'yeni kovan karantinada değil'
);

select throws_ok(
  $$update public.hives set quarantined = true
    where id = 'a3000000-0000-0000-0000-000000000001'$$,
  '23514',
  null,
  'karantinadaki kovanın başlangıç zamanı olmalı'
);

select throws_ok(
  $$update public.hives set quarantine_disease = 'american_foulbrood'
    where id = 'a3000000-0000-0000-0000-000000000001'$$,
  '23514',
  null,
  'karantinada olmayan kovanın hastalığı olmaz'
);

select throws_ok(
  $$update public.hives
    set quarantined = true, quarantined_at = now(), quarantine_disease = ' '
    where id = 'a3000000-0000-0000-0000-000000000001'$$,
  '23514',
  null,
  'hastalık kimliği boş olamaz'
);

set local role authenticated;
set local request.jwt.claims = '{"sub": "33333333-3333-3333-3333-333333333333"}';

select is(
  public.sync_push(
    jsonb_build_array(jsonb_build_object(
      'id', 0, 'table', 'hives', 'operation', 'upsert',
      'payload', (select to_jsonb(h) - 'server_seq' from public.hives h
                  where h.id = 'a3000000-0000-0000-0000-000000000001')
        || jsonb_build_object(
             'quarantined', true,
             'quarantined_at', '2026-11-02 09:00+00',
             'quarantine_disease', 'american_foulbrood',
             'updated_at', now() + interval '1 second')
    )),
    now(), 22
  ) -> 'results' -> 0 ->> 'status',
  'ok',
  'worker sync_push sürüm 22 ile kovanı karantinaya alır'
);

select results_eq(
  $$select quarantined, quarantined_at, quarantine_disease, status::text from public.hives
    where id = 'a3000000-0000-0000-0000-000000000001'$$,
  $$values (true, '2026-11-02 09:00+00'::timestamptz, 'american_foulbrood'::text, 'active'::text)$$,
  'karantinadaki kovan aktif kalır'
);

-- Eski uygulama (sürüm 21) karantina kolonlarını göndermez.
select is(
  public.sync_push(
    jsonb_build_array(jsonb_build_object(
      'id', 1, 'table', 'hives', 'operation', 'upsert',
      'payload', (select to_jsonb(h) - 'server_seq' - 'quarantined'
                    - 'quarantined_at' - 'quarantine_disease'
                  from public.hives h
                  where h.id = 'a3000000-0000-0000-0000-000000000001')
        || jsonb_build_object('marking', 'Mavi', 'updated_at', now() + interval '2 seconds')
    )),
    now(), 21
  ) -> 'results' -> 0 ->> 'status',
  'ok',
  'eski uygulamanın kovan yazması kabul edilir'
);

select results_eq(
  $$select marking, quarantined, quarantine_disease from public.hives
    where id = 'a3000000-0000-0000-0000-000000000001'$$,
  $$values ('Mavi'::text, true, 'american_foulbrood'::text)$$,
  'eski uygulamanın yazması karantinayı korur'
);

select is(
  public.sync_push(
    jsonb_build_array(jsonb_build_object(
      'id', 2, 'table', 'hives', 'operation', 'upsert',
      'payload', jsonb_build_object(
        'id', 'a3000000-0000-0000-0000-000000000002',
        'org_id', 'aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaaa',
        'number', '102', 'type', 'langstroth', 'status', 'active',
        'apiary_id', 'a1000000-0000-0000-0000-000000000001', 'box_count', 1,
        'created_at', now(), 'updated_at', now()
      )
    )),
    now(), 21
  ) -> 'results' -> 0 ->> 'status',
  'ok',
  'eski uygulama karantina kolonları olmadan yeni kovan ekler'
);

select is(
  (select quarantined from public.hives where id = 'a3000000-0000-0000-0000-000000000002'),
  false,
  'eski uygulamanın eklediği kovan karantinada değil'
);

select is(
  public.sync_push(
    jsonb_build_array(jsonb_build_object(
      'id', 3, 'table', 'hives', 'operation', 'upsert',
      'payload', (select to_jsonb(h) - 'server_seq' from public.hives h
                  where h.id = 'a3000000-0000-0000-0000-000000000001')
        || jsonb_build_object(
             'quarantined', false, 'quarantined_at', null, 'quarantine_disease', null,
             'updated_at', now() + interval '3 seconds')
    )),
    now(), 22
  ) -> 'results' -> 0 ->> 'status',
  'ok',
  'yeni uygulama karantinayı kaldırır'
);

select results_eq(
  $$select quarantined, quarantined_at, quarantine_disease from public.hives
    where id = 'a3000000-0000-0000-0000-000000000001'$$,
  $$values (false, null::timestamptz, null::text)$$,
  'karantinadan çıkan kovanın zamanı ve hastalığı boş'
);

select * from finish();
rollback;
