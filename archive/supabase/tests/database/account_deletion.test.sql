-- Hesap ve işletme silme: talep, iptal, kalıcı silme, silme kaydı, RLS.
--
-- 1111 A'nın owner'ı (ekipli), 2222 A'nın partner'ı, 3333 A'nın worker'ı,
-- 4444 B'nin tek kişilik owner'ı, 9999 hiçbir işletmede değil.
begin;
create extension if not exists pgtap with schema extensions;
select plan(61);

insert into auth.users (id, email) values
  ('11111111-1111-1111-1111-111111111111', 'owner@test.local'),
  ('22222222-2222-2222-2222-222222222222', 'partner@test.local'),
  ('33333333-3333-3333-3333-333333333333', 'worker@test.local'),
  ('44444444-4444-4444-4444-444444444444', 'solo@test.local'),
  ('99999999-9999-9999-9999-999999999999', 'outsider@test.local');

insert into public.organizations (id, name, country_code, currency, created_by) values
  ('aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaaa', 'Ekipli', 'TR', 'TRY',
   '11111111-1111-1111-1111-111111111111'),
  ('bbbbbbbb-bbbb-bbbb-bbbb-bbbbbbbbbbbb', 'Tek Kişilik', 'TR', 'TRY',
   '44444444-4444-4444-4444-444444444444');

insert into public.memberships (id, org_id, user_id, role) values
  ('c0000000-0000-0000-0000-000000000001', 'aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaaa',
   '11111111-1111-1111-1111-111111111111', 'owner'),
  ('c0000000-0000-0000-0000-000000000004', 'bbbbbbbb-bbbb-bbbb-bbbb-bbbbbbbbbbbb',
   '44444444-4444-4444-4444-444444444444', 'owner'),
  ('c0000000-0000-0000-0000-000000000002', 'aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaaa',
   '22222222-2222-2222-2222-222222222222', 'partner'),
  ('c0000000-0000-0000-0000-000000000003', 'aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaaa',
   '33333333-3333-3333-3333-333333333333', 'worker');

-- A: worker'ın girdiği kayıtlar.
insert into public.apiaries (id, org_id, name, created_by) values
  ('a1000000-0000-0000-0000-000000000001', 'aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaaa',
   'Yayla', '33333333-3333-3333-3333-333333333333');
insert into public.hives (id, org_id, number, type, apiary_id, created_by) values
  ('a2000000-0000-0000-0000-000000000001', 'aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaaa',
   '1', 'langstroth', 'a1000000-0000-0000-0000-000000000001',
   '33333333-3333-3333-3333-333333333333');
insert into public.inspections (id, org_id, hive_id, apiary_id, inspected_at, created_by) values
  ('a3000000-0000-0000-0000-000000000001', 'aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaaa',
   'a2000000-0000-0000-0000-000000000001', 'a1000000-0000-0000-0000-000000000001',
   now(), '33333333-3333-3333-3333-333333333333');

-- B: tek kişilik işletmenin her türden kaydı.
insert into public.apiaries (id, org_id, name, created_by) values
  ('b1000000-0000-0000-0000-000000000001', 'bbbbbbbb-bbbb-bbbb-bbbb-bbbbbbbbbbbb',
   'Ova', '44444444-4444-4444-4444-444444444444');
insert into public.hives (id, org_id, number, type, apiary_id) values
  ('b2000000-0000-0000-0000-000000000001', 'bbbbbbbb-bbbb-bbbb-bbbb-bbbbbbbbbbbb',
   '1', 'langstroth', 'b1000000-0000-0000-0000-000000000001'),
  ('b2000000-0000-0000-0000-000000000002', 'bbbbbbbb-bbbb-bbbb-bbbb-bbbbbbbbbbbb',
   '2', 'langstroth', 'b1000000-0000-0000-0000-000000000001');
-- Yumuşak silinmiş kovan sayılmaz.
update public.hives set deleted_at = now()
where id = 'b2000000-0000-0000-0000-000000000002';
insert into public.inspections (id, org_id, hive_id, apiary_id, inspected_at) values
  ('b3000000-0000-0000-0000-000000000001', 'bbbbbbbb-bbbb-bbbb-bbbb-bbbbbbbbbbbb',
   'b2000000-0000-0000-0000-000000000001', 'b1000000-0000-0000-0000-000000000001', now());
insert into public.harvests (id, org_id, apiary_id, harvested_at, honey_kind, unit, unit_count, net_kg) values
  ('b4000000-0000-0000-0000-000000000001', 'bbbbbbbb-bbbb-bbbb-bbbb-bbbbbbbbbbbb',
   'b1000000-0000-0000-0000-000000000001', now(), 'pine', 'super', 2, 20);
insert into public.documents (id, org_id, type, name, file_kind, storage_path, byte_size) values
  ('b5000000-0000-0000-0000-000000000001', 'bbbbbbbb-bbbb-bbbb-bbbb-bbbbbbbbbbbb',
   'health_report', 'Rapor', 'pdf',
   'bbbbbbbb-bbbb-bbbb-bbbb-bbbbbbbbbbbb/b5000000-0000-0000-0000-000000000001/b5100000-0000-0000-0000-000000000001.pdf',
   100);
insert into public.media (id, org_id, hive_id, kind, storage_path, captured_at, byte_size) values
  ('b6000000-0000-0000-0000-000000000001', 'bbbbbbbb-bbbb-bbbb-bbbb-bbbbbbbbbbbb',
   'b2000000-0000-0000-0000-000000000001', 'photo',
   'bbbbbbbb-bbbb-bbbb-bbbb-bbbbbbbbbbbb/b2000000-0000-0000-0000-000000000001/b6000000-0000-0000-0000-000000000001.jpg',
   now(), 100);
insert into public.lots (id, org_id, year, seq, honey_kind, published) values
  ('b7000000-0000-0000-0000-000000000001', 'bbbbbbbb-bbbb-bbbb-bbbb-bbbbbbbbbbbb',
   2026, 1, 'pine', true);

insert into storage.objects (bucket_id, name) values
  ('media', 'bbbbbbbb-bbbb-bbbb-bbbb-bbbbbbbbbbbb/b2000000-0000-0000-0000-000000000001/b6000000-0000-0000-0000-000000000001.jpg'),
  ('public-lots', 'b7000000-0000-0000-0000-000000000001/b5000000-0000-0000-0000-000000000001.pdf'),
  ('media', 'aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaaa/a2000000-0000-0000-0000-000000000001/x.jpg');

insert into public.device_tokens (user_id, token, platform) values
  ('33333333-3333-3333-3333-333333333333', 'token-worker', 'android'),
  ('44444444-4444-4444-4444-444444444444', 'token-solo', 'ios');

insert into public.invites (org_id, code, role, created_by) values
  ('aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaaa', 'AAAAAA', 'worker', '22222222-2222-2222-2222-222222222222'),
  ('bbbbbbbb-bbbb-bbbb-bbbb-bbbbbbbbbbbb', 'BBBBBB', 'worker', '44444444-4444-4444-4444-444444444444');

-- Bir işletmeye bağlı (org_id taşıyan) tüm tablolardaki satır sayısı.
create function pg_temp.org_rows(target uuid)
returns bigint
language plpgsql
as $$
declare
  t record;
  n bigint;
  total bigint := 0;
begin
  for t in
    select c.table_name
    from information_schema.columns c
    join information_schema.tables tb using (table_schema, table_name)
    where c.table_schema = 'public' and c.column_name = 'org_id'
      and tb.table_type = 'BASE TABLE' and c.table_name <> 'deletion_requests'
  loop
    execute format('select count(*) from public.%I where org_id = $1', t.table_name)
      into n using target;
    total := total + n;
  end loop;
  return total;
end;
$$;

-- ---------------------------------------------------------------------------
-- İstemci silme fonksiyonlarını çağıramaz, talep yazamaz
-- ---------------------------------------------------------------------------

set local role anon;
select throws_ok(
  $$select public.account_deletion_request('33333333-3333-3333-3333-333333333333', null)$$,
  '42501', null, 'anonim çağrı silme talebi açamaz'
);

set local role authenticated;
set local request.jwt.claims = '{"sub": "33333333-3333-3333-3333-333333333333"}';
select throws_ok(
  $$select public.account_deletion_request('33333333-3333-3333-3333-333333333333', null)$$,
  '42501', null, 'oturumlu kullanıcı da fonksiyonu doğrudan çağıramaz'
);
select throws_ok(
  $$select public.account_deletion_purge_records(gen_random_uuid())$$,
  '42501', null, 'kullanıcı kalıcı silmeyi doğrudan çağıramaz'
);
select throws_ok(
  $$insert into public.deletion_requests (user_id, kind, scheduled_for, channel, user_hash)
    values ('33333333-3333-3333-3333-333333333333', 'hesap', now() + interval '1 day', 'uygulama', 'x')$$,
  '42501', null, 'kullanıcı tabloya talep yazamaz'
);

-- ---------------------------------------------------------------------------
-- Üye: hesap silinir, işletme kalır
-- ---------------------------------------------------------------------------

reset role;
set local role service_role;

create temp table worker_request on commit drop as
select public.account_deletion_request(
  '33333333-3333-3333-3333-333333333333', 'worker@test.local',
  'aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaaa', false, 'uygulama'
) as r;

select is((select r #>> '{request,kind}' from worker_request), 'hesap', 'üyenin talebi yalnız hesap');
select is((select r #>> '{request,status}' from worker_request), 'bekliyor', 'talep bekliyor');
select is(
  (select (r #>> '{request,scheduled_for}')::timestamptz - (r #>> '{request,requested_at}')::timestamptz
   from worker_request),
  interval '7 days', 'kalıcı silme 7 gün sonra'
);
select is(
  (select r -> 'counts' from worker_request),
  '{"hives": 0, "photos": 0, "apiaries": 0, "harvests": 0, "documents": 0, "inspections": 0, "public_lot_pages": 0}'::jsonb,
  'üye silinince işletmeden hiçbir şey silinmez'
);
select is(
  (select public.account_deletion_request('33333333-3333-3333-3333-333333333333', 'worker@test.local') -> 'already_pending'),
  'true'::jsonb, 'bekleyen talep varken yenisi açılmaz'
);

reset role;
select is(
  (select count(*)::integer from public.device_tokens where user_id = '33333333-3333-3333-3333-333333333333'),
  0, 'talep anında bildirim token''ları silinir'
);

-- RLS: herkes yalnız kendi talebini görür.
set local role authenticated;
set local request.jwt.claims = '{"sub": "33333333-3333-3333-3333-333333333333"}';
select is((select count(*)::integer from public.deletion_requests), 1, 'kullanıcı kendi talebini görür');
select throws_ok(
  $$update public.deletion_requests set status = 'iptal', cancelled_at = now()$$,
  '42501', null, 'kullanıcı talebi doğrudan değiştiremez'
);
set local request.jwt.claims = '{"sub": "99999999-9999-9999-9999-999999999999"}';
select is((select count(*)::integer from public.deletion_requests), 0, 'başkasının talebi görünmez');
set local request.jwt.claims = '{"sub": "11111111-1111-1111-1111-111111111111"}';
select is((select count(*)::integer from public.deletion_requests), 0, 'aynı işletmenin owner''ı da üyenin talebini görmez');

-- ---------------------------------------------------------------------------
-- Owner + ekip: devir ya da işletmeyi silme şart
-- ---------------------------------------------------------------------------

reset role;
set local role service_role;

select throws_ok(
  $$select public.account_deletion_request('11111111-1111-1111-1111-111111111111', 'owner@test.local',
    'aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaaa', false, 'uygulama')$$,
  'DL409', null, 'devir yapılmadan ekipli işletmenin owner''ı hesabını silemez'
);
select throws_ok(
  $$select public.account_deletion_request('22222222-2222-2222-2222-222222222222', 'partner@test.local',
    'aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaaa', true, 'uygulama')$$,
  '42501', null, 'owner olmayan işletmeyi silmeyi seçemez'
);

-- İşletmeyi tümüyle silmeyi seçen owner: talep açılır, sonra iptal edilir.
select is(
  (select public.account_deletion_request('11111111-1111-1111-1111-111111111111', 'owner@test.local',
    'aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaaa', true, 'web') #>> '{request,kind}'),
  'hesap_ve_isletme', 'owner işletmeyi silmeyi seçerse ekip olsa da talep açılır'
);
select ok(
  public.account_deletion_cancel('11111111-1111-1111-1111-111111111111'),
  'talep iptal edilir'
);

-- Sahiplik ortağa devredilince eski owner üye gibi silinir.
reset role;
update public.memberships set role = 'owner'
where user_id = '22222222-2222-2222-2222-222222222222';
update public.memberships set role = 'partner'
where user_id = '11111111-1111-1111-1111-111111111111';
set local role service_role;

select is(
  (select public.account_deletion_request('11111111-1111-1111-1111-111111111111', 'owner@test.local',
    'aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaaa', false, 'uygulama') #>> '{request,kind}'),
  'hesap', 'devirden sonra eski owner''ın talebi açılır, işletme kalır'
);
select ok(public.account_deletion_cancel('11111111-1111-1111-1111-111111111111'), 'ikinci talep de iptal');

-- Hız sınırı: 24 saatte en çok 3 talep, kullanıcıya ve e-postaya göre.
select lives_ok(
  $$select public.account_deletion_request('11111111-1111-1111-1111-111111111111', 'owner@test.local')$$,
  'üçüncü talep açılır'
);
select ok(public.account_deletion_cancel('11111111-1111-1111-1111-111111111111'), 'üçüncü talep iptal');
select throws_ok(
  $$select public.account_deletion_request('11111111-1111-1111-1111-111111111111', 'owner@test.local')$$,
  'DL429', null, 'aynı kullanıcının dördüncü talebi reddedilir'
);
select throws_ok(
  $$select public.account_deletion_request('99999999-9999-9999-9999-999999999999', ' OWNER@test.local')$$,
  'DL429', null, 'aynı e-postayla başka hesaptan gelen talep de sınırlanır'
);
select ok(
  not public.account_deletion_cancel('99999999-9999-9999-9999-999999999999'),
  'bekleyen talep yoksa iptal false döner'
);

-- ---------------------------------------------------------------------------
-- Tek kişilik işletme: hesap silme işletmeyi de siler
-- ---------------------------------------------------------------------------

reset role;
insert into public.invites (org_id, code, role, created_by) values
  ('aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaaa', 'CCCCCC', 'worker', '22222222-2222-2222-2222-222222222222');
set local role service_role;

create temp table solo_request on commit drop as
select public.account_deletion_request(
  '44444444-4444-4444-4444-444444444444', 'solo@test.local', null, false, 'uygulama'
) as r;

select is((select r #>> '{request,kind}' from solo_request), 'hesap_ve_isletme', 'tek kişilikte işletme de silinir');
select is(
  (select r -> 'counts' from solo_request),
  '{"hives": 1, "photos": 1, "apiaries": 1, "harvests": 1, "documents": 1, "inspections": 1, "public_lot_pages": 1}'::jsonb,
  'yanıt silinecekleri ve yayımdaki lot sayfasını sayar'
);
select is(
  (select r #>> '{request,org_id}' from solo_request),
  'bbbbbbbb-bbbb-bbbb-bbbb-bbbbbbbbbbbb', 'işletme verilmezse silinecek işletme yazılır'
);

reset role;
select ok(
  (select expires_at <= now() from public.invites where code = 'BBBBBB'),
  'silinecek işletmenin bekleyen davet kodu iptal olur'
);
select ok(
  (select expires_at <= now() from public.invites where code = 'AAAAAA'),
  'işletmeyi silme seçilince ekibin davet kodları da iptal olmuştu'
);
select ok(
  (select expires_at > now() from public.invites where code = 'CCCCCC'),
  'başka işletmenin davet kodu etkilenmez'
);

-- ---------------------------------------------------------------------------
-- 7 gün içinde giriş talebi iptal etmez; kullanıcı onaylayınca iptal olur
-- (20261114120000_account_deletion_app_flow)
-- ---------------------------------------------------------------------------

insert into auth.sessions (id, user_id, created_at, updated_at)
values (gen_random_uuid(), '44444444-4444-4444-4444-444444444444', now(), now());
select is(
  (select status from public.deletion_requests where id = (select (r #>> '{request,id}')::uuid from solo_request)),
  'bekliyor', 'giriş talebi kendiliğinden iptal etmez; uygulama önce sorar'
);
set local role service_role;
select is(
  public.account_deletion_pending('44444444-4444-4444-4444-444444444444') ->> 'id',
  (select r #>> '{request,id}' from solo_request),
  'bekleyen talep sorulabilir'
);
select ok(
  public.account_deletion_cancel('44444444-4444-4444-4444-444444444444'),
  'kullanıcı devam etmeyi onaylayınca talep iptal olur'
);
reset role;
select is(
  (select status from public.deletion_requests where id = (select (r #>> '{request,id}')::uuid from solo_request)),
  'iptal', 'iptal edilen talep iptal durumunda'
);
select is(pg_temp.org_rows('bbbbbbbb-bbbb-bbbb-bbbb-bbbbbbbbbbbb') > 0, true, 'iptalde veriler durur');

-- Yeniden talep: bu kez süresi dolacak.
set local role service_role;
create temp table solo_request2 on commit drop as
select (public.account_deletion_request(
  '44444444-4444-4444-4444-444444444444', 'solo@test.local', null, false, 'uygulama'
) #>> '{request,id}')::uuid as id;

select is_empty(
  $$select * from public.account_deletion_due()$$,
  'süresi dolmayan talep silinmez'
);

-- ---------------------------------------------------------------------------
-- Cron: süresi dolanlar silinir
-- ---------------------------------------------------------------------------

reset role;
update public.deletion_requests
set requested_at = requested_at - interval '8 days',
    scheduled_for = scheduled_for - interval '8 days'
where status = 'bekliyor';

select is(
  (select schedule from cron.job where jobname = 'account-deletion-purge'),
  '17 * * * *', 'pg_cron her saat kalıcı silmeyi çalıştırır'
);

set local role service_role;
select set_eq(
  $$select id from public.account_deletion_due()$$,
  $$select id from public.deletion_requests where status = 'bekliyor'$$,
  'süresi dolan talepler silinmek üzere döner'
);
select is(
  (select count(*)::integer from public.account_deletion_due()),
  2, 'üyenin ve tek kişilik owner''ın talepleri'
);

-- Tek kişilik işletme: kayıtlar.
select is(
  public.account_deletion_purge_records((select id from solo_request2)) ->> 'status',
  'bekliyor', 'kayıtlar silinir, talep Storage ve auth adımını bekler'
);
select is(pg_temp.org_rows('bbbbbbbb-bbbb-bbbb-bbbb-bbbbbbbbbbbb'), 0::bigint, 'işletmeye bağlı hiçbir satır kalmaz');
select is((select count(*)::integer from public.organizations where id = 'bbbbbbbb-bbbb-bbbb-bbbb-bbbbbbbbbbbb'), 0, 'işletme silinir');
select ok(pg_temp.org_rows('aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaaa') > 0, 'başka işletme etkilenmez');
select set_eq(
  $$select bucket_id, name from public.account_deletion_storage_objects((select id from solo_request2))$$,
  $$values ('media', 'bbbbbbbb-bbbb-bbbb-bbbb-bbbbbbbbbbbb/b2000000-0000-0000-0000-000000000001/b6000000-0000-0000-0000-000000000001.jpg'),
           ('public-lots', 'b7000000-0000-0000-0000-000000000001/b5000000-0000-0000-0000-000000000001.pdf')$$,
  'işletmenin ve yayımlanan lotun dosyaları silinmek üzere listelenir'
);

-- Yarıda kesilme: Storage silinmeden tamamlanmaz; adımlar tekrar çalışır.
select throws_ok(
  $$select public.account_deletion_complete((select id from solo_request2))$$,
  '55000', null, 'Storage silinmeden talep tamamlanmaz'
);
select lives_ok(
  $$select public.account_deletion_purge_records((select id from solo_request2))$$,
  'kayıt adımı tekrar çalıştırılabilir'
);
select is(
  (select count(*)::integer from public.account_deletion_storage_objects((select id from solo_request2))),
  2, 'işletme silindikten sonra da lot dosyası bilinir'
);

reset role;
set local storage.allow_delete_query = 'true';
delete from storage.objects
where (bucket_id, name) in (
  select bucket_id, name from public.account_deletion_storage_objects((select id from solo_request2))
);
set local role service_role;

select throws_ok(
  $$select public.account_deletion_complete((select id from solo_request2))$$,
  '55000', null, 'auth kullanıcısı silinmeden talep tamamlanmaz'
);

reset role;
delete from auth.users where id = '44444444-4444-4444-4444-444444444444';
set local role service_role;

select ok(public.account_deletion_complete((select id from solo_request2)), 'auth silinince talep tamamlanır');
select ok(not public.account_deletion_complete((select id from solo_request2)), 'tamamlanan talep tekrar işlenmez');
select is(
  public.account_deletion_purge_records((select id from solo_request2)) ->> 'status',
  'tamamlandi', 'tamamlanan talepte kayıt adımı bir şey yapmaz'
);

reset role;
select results_eq(
  $$select user_hash, kind, channel from private.deletion_log
    where request_id = (select id from solo_request2)$$,
  $$values (encode(extensions.digest('44444444-4444-4444-4444-444444444444', 'sha256'), 'hex'),
            'hesap_ve_isletme', 'uygulama')$$,
  'silme kaydı özet, tür ve kanalla yazılır'
);
select is(
  (select user_id from public.deletion_requests where id = (select id from solo_request2)),
  null, 'talepteki kullanıcı kimliği auth silinince boşalır'
);
select throws_ok(
  $$delete from private.deletion_log$$,
  '42501', null, 'silme kaydı üç yıl dolmadan silinemez'
);
select throws_ok(
  $$update private.deletion_log set kind = 'hesap'$$,
  '42501', null, 'silme kaydı değiştirilemez'
);

-- Üye: kayıtlar kalır, kişisel bilgi temizlenir.
create temp table worker_seq on commit drop as
select server_seq from public.apiaries where id = 'a1000000-0000-0000-0000-000000000001';

set local role service_role;
select lives_ok(
  $$select public.account_deletion_purge_records(
    (select (r #>> '{request,id}')::uuid from worker_request))$$,
  'üyenin kayıt adımı çalışır'
);
reset role;

-- Silme başladıktan sonra giriş talebi iptal etmez (artık hiçbir zaman).
insert into auth.sessions (id, user_id, created_at, updated_at)
values (gen_random_uuid(), '33333333-3333-3333-3333-333333333333', now(), now());
select is(
  (select status from public.deletion_requests where id = (select (r #>> '{request,id}')::uuid from worker_request)),
  'bekliyor', 'kalıcı silme başladıktan sonra giriş talebi iptal etmez'
);

delete from auth.users where id = '33333333-3333-3333-3333-333333333333';

select results_eq(
  $$select deleted_at is not null from public.memberships
    where user_id = '33333333-3333-3333-3333-333333333333'$$,
  $$values (true)$$,
  'üyelik yumuşak silinmiş olarak kalır (cihazlar çeker)'
);
select results_eq(
  $$select count(*)::integer, count(created_by)::integer from public.apiaries
    where id = 'a1000000-0000-0000-0000-000000000001'$$,
  $$values (1, 0)$$,
  'üyenin girdiği arılık kalır, ekleyeni silinmiş kullanıcı olur'
);
select ok(
  (select a.server_seq > w.server_seq from public.apiaries a, worker_seq w
   where a.id = 'a1000000-0000-0000-0000-000000000001'),
  'ekleyenin silinmesi diğer cihazlara senkronla ulaşır'
);

select * from finish();
rollback;
