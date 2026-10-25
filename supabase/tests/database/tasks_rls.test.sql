-- tasks RLS ve tutarlılık: başka işletmenin görevi görünmez ve yazılamaz;
-- worker yazar ve tamamlar, viewer yalnız okur; işletmeler arası bağ
-- reddedilir; kovana bağlı görev arılığını taşır; elle açılan görevin
-- başlığı var, otomatik görevin kaynağı var; atanan kullanıcı silinince
-- görev atanmamış kalır; sync_push görevi şema sürümü 8 ile durum kaydı
-- olarak yazar.
begin;
create extension if not exists pgtap with schema extensions;
select plan(16);

-- Kullanıcılar: 3333 A'da worker, 4444 A'da partner, 5555 A'da viewer,
-- 9999 B'nin owner'ı.
insert into auth.users (id, email) values
  ('33333333-3333-3333-3333-333333333333', 'worker@test.local'),
  ('44444444-4444-4444-4444-444444444444', 'partner@test.local'),
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
  ('c0000000-0000-0000-0000-000000000004', 'aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaaa',
   '44444444-4444-4444-4444-444444444444', 'partner'),
  ('c0000000-0000-0000-0000-000000000005', 'aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaaa',
   '55555555-5555-5555-5555-555555555555', 'viewer'),
  ('c0000000-0000-0000-0000-000000000009', 'eeeeeeee-eeee-eeee-eeee-eeeeeeeeeeee',
   '99999999-9999-9999-9999-999999999999', 'owner');

-- Önek a1/e1 arılık, a3/e3 kovan, a7/e7 görev, b0 kaynak kayıt.
insert into public.apiaries (id, org_id, name) values
  ('a1000000-0000-0000-0000-000000000001', 'aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaaa', 'Yayla'),
  ('e1000000-0000-0000-0000-000000000001', 'eeeeeeee-eeee-eeee-eeee-eeeeeeeeeeee', 'Ova');

insert into public.hives (id, org_id, number, type, apiary_id) values
  ('a3000000-0000-0000-0000-000000000001', 'aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaaa',
   '101', 'langstroth', 'a1000000-0000-0000-0000-000000000001'),
  ('e3000000-0000-0000-0000-000000000001', 'eeeeeeee-eeee-eeee-eeee-eeeeeeeeeeee',
   '101', 'dadant', 'e1000000-0000-0000-0000-000000000001');

insert into public.tasks (id, org_id, title, due_at, apiary_id, assigned_to) values
  ('a7000000-0000-0000-0000-000000000001', 'aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaaa',
   'Yayla arılığını ziyaret et', now(), 'a1000000-0000-0000-0000-000000000001',
   '44444444-4444-4444-4444-444444444444'),
  ('e7000000-0000-0000-0000-000000000001', 'eeeeeeee-eeee-eeee-eeee-eeeeeeeeeeee',
   'Ova arılığına şeker götür', now(), null, null);

set local role authenticated;

-- B'nin owner'ı
set local request.jwt.claims = '{"sub": "99999999-9999-9999-9999-999999999999"}';

select results_eq(
  'select id from public.tasks',
  $$values ('e7000000-0000-0000-0000-000000000001'::uuid)$$,
  'başka işletmenin görevini göremez, yalnız kendisininkini görür'
);

select throws_ok(
  $$insert into public.tasks (id, org_id, title, due_at)
    values ('e7000000-0000-0000-0000-000000000002', 'aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaaa',
            'Sızma', now())$$,
  '42501',
  null,
  'başka işletmeye görev ekleyemez'
);

select is_empty(
  $$update public.tasks set completed_at = now()
    where id = 'a7000000-0000-0000-0000-000000000001' returning id$$,
  'başka işletmenin görevini tamamlayamaz'
);

select throws_ok(
  $$insert into public.tasks (id, org_id, title, due_at, apiary_id)
    values ('e7000000-0000-0000-0000-000000000003', 'eeeeeeee-eeee-eeee-eeee-eeeeeeeeeeee',
            'Ziyaret', now(), 'a1000000-0000-0000-0000-000000000001')$$,
  '23503',
  null,
  'kendi görevini başka işletmenin arılığına bağlayamaz'
);

select throws_ok(
  $$insert into public.tasks (id, org_id, title, due_at, apiary_id, hive_id)
    values ('e7000000-0000-0000-0000-000000000004', 'eeeeeeee-eeee-eeee-eeee-eeeeeeeeeeee',
            'Ana ver', now(), 'e1000000-0000-0000-0000-000000000001',
            'a3000000-0000-0000-0000-000000000001')$$,
  '23503',
  null,
  'kendi görevini başka işletmenin kovanına bağlayamaz'
);

-- A'nın worker'ı
set local request.jwt.claims = '{"sub": "33333333-3333-3333-3333-333333333333"}';

select lives_ok(
  $$insert into public.tasks (id, org_id, title, due_at, apiary_id, hive_id, assigned_to)
    values ('a7000000-0000-0000-0000-000000000002', 'aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaaa',
            'Kovan 101''e ana ver', now(), 'a1000000-0000-0000-0000-000000000001',
            'a3000000-0000-0000-0000-000000000001', '33333333-3333-3333-3333-333333333333')$$,
  'worker kovana bağlı görev ekler ve kendine atar'
);

select isnt_empty(
  $$update public.tasks set completed_at = now()
    where id = 'a7000000-0000-0000-0000-000000000001' returning id$$,
  'worker başkasına atanmış görevi tamamlar'
);

select throws_ok(
  $$insert into public.tasks (id, org_id, title, due_at, hive_id)
    values ('a7000000-0000-0000-0000-000000000003', 'aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaaa',
            'Ana ver', now(), 'a3000000-0000-0000-0000-000000000001')$$,
  '23514',
  null,
  'kovana bağlı görev arılığını taşır'
);

select throws_ok(
  $$insert into public.tasks (id, org_id, due_at)
    values ('a7000000-0000-0000-0000-000000000004', 'aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaaa', now())$$,
  '23514',
  null,
  'elle açılan görevin başlığı olur'
);

select throws_ok(
  $$insert into public.tasks (id, org_id, title, due_at)
    values ('a7000000-0000-0000-0000-000000000005', 'aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaaa', '  ', now())$$,
  '23514',
  null,
  'başlık boş olamaz'
);

select throws_ok(
  $$insert into public.tasks (id, org_id, due_at, source)
    values ('a7000000-0000-0000-0000-000000000006', 'aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaaa',
            now(), 'inspection')$$,
  '23514',
  null,
  'otomatik görevin kaynağı olur'
);

select lives_ok(
  $$insert into public.tasks (id, org_id, due_at, apiary_id, hive_id, source, source_id)
    values ('a7000000-0000-0000-0000-000000000007', 'aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaaa',
            now() + interval '7 days', 'a1000000-0000-0000-0000-000000000001',
            'a3000000-0000-0000-0000-000000000001', 'inspection',
            'b0000000-0000-0000-0000-000000000001')$$,
  'muayeneden açılan görev başlıksız yazılır'
);

select results_eq(
  $$select r ->> 'status', r ->> 'applied'
    from jsonb_array_elements(public.sync_push(
      $j$[{"id": 1, "table": "tasks", "operation": "upsert", "payload": {
        "id": "a7000000-0000-0000-0000-000000000008",
        "org_id": "aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaaa",
        "title": null, "due_at": "2026-11-05T09:00:00.000Z",
        "apiary_id": "a1000000-0000-0000-0000-000000000001", "hive_id": null,
        "assigned_to": null, "completed_at": null,
        "source": "treatment", "source_id": "b0000000-0000-0000-0000-000000000002",
        "created_at": "2026-10-26T09:00:00.000Z",
        "updated_at": "2026-10-26T09:00:00.000Z",
        "created_by": null, "deleted_at": null}},
      {"id": 2, "table": "tasks", "operation": "upsert", "payload": {
        "id": "a7000000-0000-0000-0000-000000000008",
        "org_id": "aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaaa",
        "title": null, "due_at": "2026-11-05T09:00:00.000Z",
        "apiary_id": "a1000000-0000-0000-0000-000000000001", "hive_id": null,
        "assigned_to": null, "completed_at": "2026-11-05T10:00:00.000Z",
        "source": "treatment", "source_id": "b0000000-0000-0000-0000-000000000002",
        "created_at": "2026-10-26T09:00:00.000Z",
        "updated_at": "2026-11-05T10:00:00.000Z",
        "created_by": null, "deleted_at": null}},
      {"id": 3, "table": "tasks", "operation": "upsert", "payload": {
        "id": "a7000000-0000-0000-0000-000000000008",
        "org_id": "aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaaa",
        "title": null, "due_at": "2026-11-05T09:00:00.000Z",
        "apiary_id": "a1000000-0000-0000-0000-000000000001", "hive_id": null,
        "assigned_to": null, "completed_at": null,
        "source": "treatment", "source_id": "b0000000-0000-0000-0000-000000000002",
        "created_at": "2026-10-26T09:00:00.000Z",
        "updated_at": "2026-11-01T10:00:00.000Z",
        "created_by": null, "deleted_at": null}}]$j$::jsonb,
      now(), 8) -> 'results') r$$,
  $$values ('ok', 'true'), ('ok', 'true'), ('ok', 'false')$$,
  'sync_push görevi şema sürümü 8 ile durum kaydı olarak yazar; eski yazma kaybeder'
);

select results_eq(
  $$select completed_at from public.tasks
    where id = 'a7000000-0000-0000-0000-000000000008'$$,
  $$values ('2026-11-05T10:00:00.000Z'::timestamptz)$$,
  'son yazan kazanır: tamamlanma eski yazmayla geri alınmaz'
);

-- A'nın viewer'ı
set local request.jwt.claims = '{"sub": "55555555-5555-5555-5555-555555555555"}';

select throws_ok(
  $$insert into public.tasks (id, org_id, title, due_at)
    values ('a7000000-0000-0000-0000-000000000009', 'aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaaa',
            'Ziyaret', now())$$,
  '42501',
  null,
  'viewer görev ekleyemez, ama işletmenin görevlerini görür'
);

reset role;

delete from auth.users where id = '44444444-4444-4444-4444-444444444444';

select results_eq(
  $$select assigned_to from public.tasks
    where id = 'a7000000-0000-0000-0000-000000000001'$$,
  $$values (null::uuid)$$,
  'atanan kullanıcı silinince görev atanmamış kalır'
);

select * from finish();
rollback;
