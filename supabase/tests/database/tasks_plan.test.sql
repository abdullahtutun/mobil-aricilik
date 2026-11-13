-- Planlı ilaçlama görevi: worker referans ya da işletmenin ilacıyla görev
-- açar; başka işletmenin ilacı 23503 alır; ilaç ve doz birlikte, en çok
-- bir ilaç; ilaçlı görev elle açılır ve arılığa bağlıdır; sync_push
-- ilaçlı görevi şema sürümü 15 ile yazar.
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

select plan(10);

insert into auth.users (id, email) values
  ('33333333-3333-3333-3333-333333333333', 'worker@test.local'),
  ('99999999-9999-9999-9999-999999999999', 'other@test.local');

insert into public.organizations (id, name, country_code, currency, created_by) values
  ('aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaaa', 'Petek Arıcılık', 'TR', 'TRY',
   '33333333-3333-3333-3333-333333333333'),
  ('eeeeeeee-eeee-eeee-eeee-eeeeeeeeeeee', 'Başka İşletme', 'TR', 'TRY',
   '99999999-9999-9999-9999-999999999999');

insert into public.memberships (id, org_id, user_id, role) values
  ('c0000000-0000-0000-0000-000000000003', 'aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaaa',
   '33333333-3333-3333-3333-333333333333', 'worker'),
  ('c0000000-0000-0000-0000-000000000009', 'eeeeeeee-eeee-eeee-eeee-eeeeeeeeeeee',
   '99999999-9999-9999-9999-999999999999', 'owner');

-- Önek a1 arılık, ad/ed işletmenin ilacı, a7 görev. Referans ilaç
-- 0190…0001 (Amitraz, şerit) migration'dan gelir.
insert into public.apiaries (id, org_id, name) values
  ('a1000000-0000-0000-0000-000000000001', 'aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaaa', 'Yayla');

insert into public.drugs (id, org_id, name, active_ingredient, dose_unit) values
  ('ad000000-0000-0000-0000-000000000001', 'aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaaa',
   'Kendi timol jelim', 'thymol', 'g'),
  ('ed000000-0000-0000-0000-000000000001', 'eeeeeeee-eeee-eeee-eeee-eeeeeeeeeeee',
   'Oxalsäure', 'oxalic_acid', 'ml');

set local role authenticated;
set local request.jwt.claims = '{"sub": "33333333-3333-3333-3333-333333333333"}';

select lives_ok(
  $$insert into public.tasks (id, org_id, title, due_at, apiary_id, ref_drug_id, dose)
    values ('a7000000-0000-0000-0000-000000000001', 'aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaaa',
            'İlaçlama · Amitraz', now(), 'a1000000-0000-0000-0000-000000000001',
            '01900000-0000-7000-8000-000000000001', 2)$$,
  'worker referans ilaçla planlı ilaçlama görevi açar'
);

select lives_ok(
  $$insert into public.tasks (id, org_id, title, due_at, apiary_id, drug_id, dose)
    values ('a7000000-0000-0000-0000-000000000002', 'aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaaa',
            'İlaçlama · timol', now(), 'a1000000-0000-0000-0000-000000000001',
            'ad000000-0000-0000-0000-000000000001', 50)$$,
  'worker işletmenin ilacıyla planlı ilaçlama görevi açar'
);

select throws_ok(
  $$insert into public.tasks (id, org_id, title, due_at, apiary_id, drug_id, dose)
    values ('a7000000-0000-0000-0000-000000000003', 'aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaaa',
            'Sızma', now(), 'a1000000-0000-0000-0000-000000000001',
            'ed000000-0000-0000-0000-000000000001', 5)$$,
  '23503',
  null,
  'başka işletmenin ilacına bağlanamaz'
);

select throws_ok(
  $$insert into public.tasks (id, org_id, title, due_at, apiary_id, ref_drug_id)
    values ('a7000000-0000-0000-0000-000000000004', 'aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaaa',
            'Dozsuz', now(), 'a1000000-0000-0000-0000-000000000001',
            '01900000-0000-7000-8000-000000000001')$$,
  '23514',
  null,
  'ilaçlı görev doz taşır'
);

select throws_ok(
  $$insert into public.tasks (id, org_id, title, due_at, apiary_id, dose)
    values ('a7000000-0000-0000-0000-000000000005', 'aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaaa',
            'İlaçsız doz', now(), 'a1000000-0000-0000-0000-000000000001', 2)$$,
  '23514',
  null,
  'doz ilaçsız yazılamaz'
);

select throws_ok(
  $$insert into public.tasks (id, org_id, title, due_at, apiary_id, ref_drug_id, drug_id, dose)
    values ('a7000000-0000-0000-0000-000000000006', 'aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaaa',
            'İki ilaç', now(), 'a1000000-0000-0000-0000-000000000001',
            '01900000-0000-7000-8000-000000000001', 'ad000000-0000-0000-0000-000000000001', 2)$$,
  '23514',
  null,
  'görev en çok bir ilaç taşır'
);

select throws_ok(
  $$insert into public.tasks (id, org_id, title, due_at, ref_drug_id, dose)
    values ('a7000000-0000-0000-0000-000000000007', 'aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaaa',
            'Arılıksız', now(), '01900000-0000-7000-8000-000000000001', 2)$$,
  '23514',
  null,
  'ilaçlı görev arılığa bağlıdır'
);

select throws_ok(
  $$insert into public.tasks (id, org_id, due_at, apiary_id, source, source_id, ref_drug_id, dose)
    values ('a7000000-0000-0000-0000-000000000008', 'aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaaa',
            now(), 'a1000000-0000-0000-0000-000000000001', 'treatment',
            'b0000000-0000-0000-0000-000000000001',
            '01900000-0000-7000-8000-000000000001', 2)$$,
  '23514',
  null,
  'otomatik görev ilaç taşımaz'
);

select results_eq(
  $$select r ->> 'status', r ->> 'applied'
    from jsonb_array_elements(public.sync_push(
      $j$[{"id": 1, "table": "tasks", "operation": "upsert", "payload": {
        "id": "a7000000-0000-0000-0000-000000000009",
        "org_id": "aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaaa",
        "title": "İlaçlama · Amitraz", "due_at": "2026-11-05T09:00:00.000Z",
        "apiary_id": "a1000000-0000-0000-0000-000000000001", "hive_id": null,
        "assigned_to": null, "completed_at": null,
        "source": "manual", "source_id": null,
        "ref_drug_id": "01900000-0000-7000-8000-000000000001",
        "drug_id": null, "dose": 2,
        "created_at": "2026-11-01T09:00:00.000Z",
        "updated_at": "2026-11-01T09:00:00.000Z",
        "created_by": null, "deleted_at": null}}]$j$::jsonb,
      now(), 15) -> 'results') r$$,
  $$values ('ok', 'true')$$,
  'sync_push ilaçlı görevi şema sürümü 15 ile yazar'
);

select results_eq(
  $$select ref_drug_id, dose from public.tasks
    where id = 'a7000000-0000-0000-0000-000000000009'$$,
  $$values ('01900000-0000-7000-8000-000000000001'::uuid, 2::numeric)$$,
  'ilaç ve doz senkronla yazılır'
);

select * from finish();
rollback;
