-- queen_rearing_batches ve mating_nucs RLS ve tutarlılık: başka işletmenin
-- serisi ve kutusu görünmez ve yazılamaz; worker yazar, viewer yalnız
-- okur; işletmeler arası bağ (anne ana, arılık, seri) 23503 alır; kabul
-- aktarılandan fazla olamaz; kovana verilen kutu ananın kaydını taşır;
-- ana yetiştirme görevi takvim gününü taşır; sync_push iki tabloyu şema
-- sürümü 16 ile durum kaydı olarak yazar.
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

select plan(18);

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

-- Önek a1/e1 arılık, a2/e2 ana, a3/e3 seri, a4/e4 kutu, a5 görev.
insert into public.apiaries (id, org_id, name) values
  ('a1000000-0000-0000-0000-000000000001', 'aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaaa', 'Çam'),
  ('e1000000-0000-0000-0000-000000000001', 'eeeeeeee-eeee-eeee-eeee-eeeeeeeeeeee', 'Ova');

insert into public.queens (id, org_id, year, mark_color) values
  ('a2000000-0000-0000-0000-000000000001', 'aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaaa', 2025, 'blue'),
  ('a2000000-0000-0000-0000-000000000002', 'aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaaa', 2026, 'white'),
  ('e2000000-0000-0000-0000-000000000001', 'eeeeeeee-eeee-eeee-eeee-eeeeeeeeeeee', 2024, 'green');

insert into public.queen_rearing_batches (id, org_id, number, mother_queen_id, grafted_on,
                                          grafted_count, accepted_count) values
  ('a3000000-0000-0000-0000-000000000001', 'aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaaa', 3,
   'a2000000-0000-0000-0000-000000000001', '2026-05-12', 40, 34),
  ('e3000000-0000-0000-0000-000000000001', 'eeeeeeee-eeee-eeee-eeee-eeeeeeeeeeee', 1,
   'e2000000-0000-0000-0000-000000000001', '2026-05-01', 20, null);

insert into public.mating_nucs (id, org_id, number, apiary_id, rearing_batch_id, status) values
  ('a4000000-0000-0000-0000-000000000001', 'aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaaa', '1',
   'a1000000-0000-0000-0000-000000000001', 'a3000000-0000-0000-0000-000000000001', 'cell'),
  ('e4000000-0000-0000-0000-000000000001', 'eeeeeeee-eeee-eeee-eeee-eeeeeeeeeeee', '1',
   'e1000000-0000-0000-0000-000000000001', null, 'empty');

select throws_ok(
  $$insert into public.queen_rearing_batches (id, org_id, number, grafted_on, grafted_count, accepted_count)
    values ('a3000000-0000-0000-0000-000000000002', 'aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaaa',
            4, '2026-05-20', 10, 11)$$,
  '23514',
  null,
  'kabul edilen aktarılandan fazla olamaz'
);

select throws_ok(
  $$insert into public.mating_nucs (id, org_id, number, apiary_id, status)
    values ('a4000000-0000-0000-0000-000000000002', 'aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaaa',
            '2', 'a1000000-0000-0000-0000-000000000001', 'cell')$$,
  '23514',
  null,
  'memeli kutu bir seriye bağlıdır'
);

select throws_ok(
  $$insert into public.mating_nucs (id, org_id, number, apiary_id, rearing_batch_id, status)
    values ('a4000000-0000-0000-0000-000000000003', 'aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaaa',
            '3', 'a1000000-0000-0000-0000-000000000001',
            'a3000000-0000-0000-0000-000000000001', 'given')$$,
  '23514',
  null,
  'kovana verilen kutu ananın kaydını taşır'
);

select throws_ok(
  $$insert into public.tasks (id, org_id, due_at, source, source_id)
    values ('a5000000-0000-0000-0000-000000000001', 'aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaaa',
            now(), 'queen_rearing', 'a3000000-0000-0000-0000-000000000001')$$,
  '23514',
  null,
  'ana yetiştirme görevi takvim gününü taşır'
);

select throws_ok(
  $$insert into public.tasks (id, org_id, title, due_at, source_step)
    values ('a5000000-0000-0000-0000-000000000002', 'aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaaa',
            'Elle', now(), 5)$$,
  '23514',
  null,
  'takvim günü yalnız ana yetiştirme görevinde'
);

set local role authenticated;

-- B'nin owner'ı
set local request.jwt.claims = '{"sub": "99999999-9999-9999-9999-999999999999"}';

select results_eq(
  'select id from public.queen_rearing_batches',
  $$values ('e3000000-0000-0000-0000-000000000001'::uuid)$$,
  'başka işletmenin serisini göremez, yalnız kendisininkini görür'
);

select results_eq(
  'select id from public.mating_nucs',
  $$values ('e4000000-0000-0000-0000-000000000001'::uuid)$$,
  'başka işletmenin kutusunu göremez, yalnız kendisininkini görür'
);

select throws_ok(
  $$insert into public.queen_rearing_batches (id, org_id, number, grafted_on, grafted_count)
    values ('e3000000-0000-0000-0000-000000000002', 'aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaaa',
            9, '2026-05-20', 10)$$,
  '42501',
  null,
  'başka işletmeye seri ekleyemez'
);

select is_empty(
  $$update public.mating_nucs set status = 'failed'
    where id = 'a4000000-0000-0000-0000-000000000001' returning id$$,
  'başka işletmenin kutusunu güncelleyemez'
);

select throws_ok(
  $$insert into public.queen_rearing_batches (id, org_id, number, mother_queen_id, grafted_on, grafted_count)
    values ('e3000000-0000-0000-0000-000000000003', 'eeeeeeee-eeee-eeee-eeee-eeeeeeeeeeee',
            2, 'a2000000-0000-0000-0000-000000000001', '2026-05-20', 10)$$,
  '23503',
  null,
  'başka işletmenin anasını anne ana yapamaz'
);

select throws_ok(
  $$insert into public.mating_nucs (id, org_id, number, apiary_id, rearing_batch_id, status)
    values ('e4000000-0000-0000-0000-000000000002', 'eeeeeeee-eeee-eeee-eeee-eeeeeeeeeeee',
            '2', 'e1000000-0000-0000-0000-000000000001',
            'a3000000-0000-0000-0000-000000000001', 'cell')$$,
  '23503',
  null,
  'başka işletmenin serisine kutu bağlayamaz'
);

select throws_ok(
  $$insert into public.mating_nucs (id, org_id, number, apiary_id)
    values ('e4000000-0000-0000-0000-000000000003', 'eeeeeeee-eeee-eeee-eeee-eeeeeeeeeeee',
            '3', 'a1000000-0000-0000-0000-000000000001')$$,
  '23503',
  null,
  'başka işletmenin arılığına kutu koyamaz'
);

-- A'nın viewer'ı
set local request.jwt.claims = '{"sub": "55555555-5555-5555-5555-555555555555"}';

select throws_ok(
  $$insert into public.queen_rearing_batches (id, org_id, number, grafted_on, grafted_count)
    values ('a3000000-0000-0000-0000-000000000003', 'aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaaa',
            5, '2026-05-20', 10)$$,
  '42501',
  null,
  'viewer seri ekleyemez'
);

select is_empty(
  $$update public.mating_nucs set status = 'failed'
    where id = 'a4000000-0000-0000-0000-000000000001' returning id$$,
  'viewer kutuyu güncelleyemez'
);

-- A'nın worker'ı
set local request.jwt.claims = '{"sub": "33333333-3333-3333-3333-333333333333"}';

select lives_ok(
  $$update public.mating_nucs
    set status = 'given', queen_id = 'a2000000-0000-0000-0000-000000000002'
    where id = 'a4000000-0000-0000-0000-000000000001'$$,
  'worker kutudan anayı kovana verir'
);

select lives_ok(
  $$insert into public.tasks (id, org_id, due_at, source, source_id, source_step)
    values ('a5000000-0000-0000-0000-000000000003', 'aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaaa',
            now(), 'queen_rearing', 'a3000000-0000-0000-0000-000000000001', 10)$$,
  'worker ana yetiştirme görevi açar'
);

select results_eq(
  $$select r ->> 'status', r ->> 'applied'
    from jsonb_array_elements(public.sync_push(
      $j$[{"id": 1, "table": "queen_rearing_batches", "operation": "upsert", "payload": {
        "id": "a3000000-0000-0000-0000-000000000004",
        "org_id": "aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaaa",
        "number": 4, "mother_queen_id": "a2000000-0000-0000-0000-000000000001",
        "grafted_on": "2026-06-01", "grafted_count": 30, "accepted_count": null,
        "created_at": "2026-06-01T09:00:00.000Z",
        "updated_at": "2026-06-01T09:00:00.000Z",
        "created_by": null, "deleted_at": null}},
      {"id": 2, "table": "mating_nucs", "operation": "upsert", "payload": {
        "id": "a4000000-0000-0000-0000-000000000004",
        "org_id": "aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaaa",
        "number": "2", "apiary_id": "a1000000-0000-0000-0000-000000000001",
        "rearing_batch_id": "a3000000-0000-0000-0000-000000000004",
        "status": "cell", "queen_id": null,
        "created_at": "2026-06-11T09:00:00.000Z",
        "updated_at": "2026-06-11T09:00:00.000Z",
        "created_by": null, "deleted_at": null}}]$j$::jsonb,
      now(), 16) -> 'results') r$$,
  $$values ('ok', 'true'), ('ok', 'true')$$,
  'sync_push seriyi ve kutuyu şema sürümü 16 ile yazar'
);

select results_eq(
  $$select r ->> 'status', r ->> 'applied'
    from jsonb_array_elements(public.sync_push(
      $j$[{"id": 1, "table": "mating_nucs", "operation": "upsert", "payload": {
        "id": "a4000000-0000-0000-0000-000000000004",
        "org_id": "aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaaa",
        "number": "2", "apiary_id": "a1000000-0000-0000-0000-000000000001",
        "rearing_batch_id": "a3000000-0000-0000-0000-000000000004",
        "status": "failed", "queen_id": null,
        "created_at": "2026-06-11T09:00:00.000Z",
        "updated_at": "2026-06-10T09:00:00.000Z",
        "created_by": null, "deleted_at": null}}]$j$::jsonb,
      now(), 16) -> 'results') r$$,
  $$values ('ok', 'false')$$,
  'kutu durum kaydı: eski updated_at yazılmaz'
);

select * from finish();
rollback;
