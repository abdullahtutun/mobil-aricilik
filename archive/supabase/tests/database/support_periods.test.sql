-- ref_support_periods ve dönem bildirimi: girişli kullanıcı dönemleri
-- okur, istemci yazamaz, sync_push yazmayı reddeder; alıcılar TR
-- işletmelerinin etkin owner ve partner üyeleri; açık dönem bir kez
-- bildirilir, Vault kaydı yoksa hiçbir şey yapılmaz; günlük cron işi
-- kurulu; işletmenin AKS kovan sayısı owner tarafından sync_push ile
-- şema sürümü 21'de yazılır; aks_update görevi yazılır.
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

-- 1111 A'nın owner'ı, 2222 A'da partner, 3333 A'da worker, 5555 A'da
-- viewer, 6666 A'dan çıkarılmış partner, 9999 B'nin (DE) owner'ı.
insert into auth.users (id, email) values
  ('11111111-1111-1111-1111-111111111111', 'owner@test.local'),
  ('22222222-2222-2222-2222-222222222222', 'partner@test.local'),
  ('33333333-3333-3333-3333-333333333333', 'worker@test.local'),
  ('55555555-5555-5555-5555-555555555555', 'viewer@test.local'),
  ('66666666-6666-6666-6666-666666666666', 'removed@test.local'),
  ('99999999-9999-9999-9999-999999999999', 'other@test.local');

insert into public.organizations (id, name, country_code, currency, created_by, updated_at) values
  ('aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaaa', 'Petek Arıcılık', 'TR', 'TRY',
   '11111111-1111-1111-1111-111111111111', '2026-11-01T00:00:00Z'),
  ('eeeeeeee-eeee-eeee-eeee-eeeeeeeeeeee', 'Imkerei', 'DE', 'EUR',
   '99999999-9999-9999-9999-999999999999', '2026-11-01T00:00:00Z');

insert into public.memberships (id, org_id, user_id, role, deleted_at) values
  ('c0000000-0000-0000-0000-000000000001', 'aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaaa',
   '11111111-1111-1111-1111-111111111111', 'owner', null),
  ('c0000000-0000-0000-0000-000000000002', 'aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaaa',
   '22222222-2222-2222-2222-222222222222', 'partner', null),
  ('c0000000-0000-0000-0000-000000000003', 'aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaaa',
   '33333333-3333-3333-3333-333333333333', 'worker', null),
  ('c0000000-0000-0000-0000-000000000005', 'aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaaa',
   '55555555-5555-5555-5555-555555555555', 'viewer', null),
  ('c0000000-0000-0000-0000-000000000006', 'aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaaa',
   '66666666-6666-6666-6666-666666666666', 'partner', now()),
  ('c0000000-0000-0000-0000-000000000009', 'eeeeeeee-eeee-eeee-eeee-eeeeeeeeeeee',
   '99999999-9999-9999-9999-999999999999', 'owner', null);

-- 01: açık, 02: ileride, 03: bitmiş, 04: açık ama silinmiş.
insert into public.ref_support_periods (id, name, application_starts_on, application_ends_on, deleted_at) values
  ('d1000000-0000-0000-0000-000000000001', 'Açık destek',
   current_date - 1, current_date + 30, null),
  ('d1000000-0000-0000-0000-000000000002', 'Gelecek destek',
   current_date + 10, current_date + 40, null),
  ('d1000000-0000-0000-0000-000000000003', 'Bitmiş destek',
   current_date - 40, current_date - 10, null),
  ('d1000000-0000-0000-0000-000000000004', 'Silinmiş destek',
   current_date - 1, current_date + 30, now());

select throws_ok(
  $$insert into public.ref_support_periods (id, name, application_starts_on, application_ends_on)
    values ('d1000000-0000-0000-0000-000000000009', 'Ters', '2027-02-01', '2027-01-01')$$,
  '23514',
  null,
  'bitiş başlangıçtan önce olamaz'
);

select throws_ok(
  $$insert into public.ref_support_periods (id, name, application_starts_on, application_ends_on, source_url)
    values ('d1000000-0000-0000-0000-000000000009', 'Link', '2027-01-01', '2027-02-01', 'ftp://x')$$,
  '23514',
  null,
  'kaynak linki http(s) olmalı'
);

-- ---------------------------------------------------------------------------
-- Alıcılar ve bildirim (postgres olarak)
-- ---------------------------------------------------------------------------

select results_eq(
  'select r from private.support_period_recipients() r order by r',
  $$values ('11111111-1111-1111-1111-111111111111'::uuid),
           ('22222222-2222-2222-2222-222222222222'::uuid)$$,
  'alıcılar TR işletmelerinin etkin owner ve partner üyeleri'
);

select is(
  private.notify_support_periods(),
  0,
  'Vault kaydı yoksa hiçbir dönem bildirilmez'
);

select is(
  (select count(*)::integer from private.support_period_notifications),
  0,
  'Vault kaydı yokken dönem bildirilmemiş kalır'
);

select vault.create_secret('http://127.0.0.1:9/notify', 'notify_url');
select vault.create_secret('test-secret', 'notify_secret');

select is(
  private.notify_support_periods(),
  1,
  'yalnız açık ve silinmemiş dönem bildirilir'
);

select results_eq(
  'select period_id from private.support_period_notifications',
  $$values ('d1000000-0000-0000-0000-000000000001'::uuid)$$,
  'bildirilen dönem kaydedilir'
);

select ok(
  exists (
    select from net.http_request_queue q
    where convert_from(q.body, 'utf8')::jsonb -> 'record' ->> 'id'
        = 'd1000000-0000-0000-0000-000000000001'
      and convert_from(q.body, 'utf8')::jsonb ->> 'table' = 'ref_support_periods'
      and jsonb_array_length(convert_from(q.body, 'utf8')::jsonb -> 'recipients') = 2
  ),
  'notify dönemi ve alıcıları taşıyan istekle çağrılır'
);

select is(
  private.notify_support_periods(),
  0,
  'dönem ikinci kez bildirilmez'
);

select ok(
  exists (
    select from cron.job
    where jobname = 'notify-support-periods'
      and schedule = '0 6 * * *'
      and command = 'select private.notify_support_periods()'
  ),
  'günlük cron işi kurulu'
);

-- ---------------------------------------------------------------------------
-- RLS ve sync_push
-- ---------------------------------------------------------------------------

set local role authenticated;
set local request.jwt.claims = '{"sub": "99999999-9999-9999-9999-999999999999"}';

select is(
  (select count(*)::integer from public.ref_support_periods),
  4,
  'girişli kullanıcı dönemleri (silinmişler dahil) görür'
);

select throws_ok(
  $$insert into public.ref_support_periods (id, name, application_starts_on, application_ends_on)
    values ('d1000000-0000-0000-0000-000000000009', 'X', '2027-01-01', '2027-02-01')$$,
  '42501',
  null,
  'istemci dönem ekleyemez'
);

update public.ref_support_periods set name = 'Değişti'
where id = 'd1000000-0000-0000-0000-000000000001';

select is(
  (select name from public.ref_support_periods
   where id = 'd1000000-0000-0000-0000-000000000001'),
  'Açık destek',
  'istemci dönemi güncelleyemez'
);

select is(
  public.sync_push(
    $$[{"id": 1, "table": "ref_support_periods", "operation": "upsert",
        "payload": {"id": "d1000000-0000-0000-0000-000000000009", "name": "X",
                    "application_starts_on": "2027-01-01",
                    "application_ends_on": "2027-02-01",
                    "updated_at": "2026-11-05T00:00:00Z"}}]$$::jsonb,
    now(), 21
  ) -> 'results' -> 0 ->> 'reason',
  'unsupported',
  'sync_push dönem yazmayı reddeder'
);

-- A'nın owner'ı
set local request.jwt.claims = '{"sub": "11111111-1111-1111-1111-111111111111"}';

select is(
  public.sync_push(
    $$[{"id": 1, "table": "organizations", "operation": "upsert",
        "payload": {"id": "aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaaa", "name": "Petek Arıcılık",
                    "country_code": "TR", "currency": "TRY",
                    "tr_aks_hive_count": 120,
                    "created_at": "2026-11-01T00:00:00Z",
                    "updated_at": "2026-11-05T00:00:00Z"}}]$$::jsonb,
    now(), 21
  ) -> 'results' -> 0 ->> 'status',
  'ok',
  'owner AKS kovan sayısını sync_push ile şema sürümü 21''de yazar'
);

select is(
  (select tr_aks_hive_count from public.organizations
   where id = 'aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaaa'),
  120,
  'AKS kovan sayısı yazıldı'
);

select throws_ok(
  $$update public.organizations set tr_aks_hive_count = -1
    where id = 'aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaaa'$$,
  '23514',
  null,
  'AKS kovan sayısı eksi olamaz'
);

-- A'nın worker'ı AKS görevini yazar.
set local request.jwt.claims = '{"sub": "33333333-3333-3333-3333-333333333333"}';

select is(
  public.sync_push(
    $$[{"id": 1, "table": "tasks", "operation": "upsert",
        "payload": {"id": "f1000000-0000-0000-0000-000000000001",
                    "org_id": "aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaaa",
                    "due_at": "2026-11-06T06:00:00Z", "source": "aks_update",
                    "source_id": "aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaaa",
                    "created_at": "2026-11-05T00:00:00Z",
                    "updated_at": "2026-11-05T00:00:00Z"}}]$$::jsonb,
    now(), 21
  ) -> 'results' -> 0 ->> 'status',
  'ok',
  'worker aks_update görevini yazar'
);

select * from finish();
rollback;
