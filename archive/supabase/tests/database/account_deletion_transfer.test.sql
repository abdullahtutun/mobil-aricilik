-- Hesap silme: sahipliği ortağa devredip ayrılma ve bekleyen talebi sorma
-- (20261114120000_account_deletion_app_flow).
--
-- 1111 A'nın owner'ı, 2222 A'nın partner'ı, 3333 A'nın worker'ı, 5555 A'nın
-- ikinci partner'ı (kendi silme talebi bekliyor), 9999 A'da değil.
begin;
create extension if not exists pgtap with schema extensions;
select plan(15);

insert into auth.users (id, email) values
  ('11111111-1111-1111-1111-111111111111', 'owner@test.local'),
  ('22222222-2222-2222-2222-222222222222', 'partner@test.local'),
  ('33333333-3333-3333-3333-333333333333', 'worker@test.local'),
  ('55555555-5555-5555-5555-555555555555', 'leaving@test.local'),
  ('99999999-9999-9999-9999-999999999999', 'outsider@test.local');

insert into public.organizations (id, name, country_code, currency, created_by) values
  ('aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaaa', 'Ekipli', 'TR', 'TRY',
   '11111111-1111-1111-1111-111111111111');

insert into public.memberships (id, org_id, user_id, role) values
  ('c0000000-0000-0000-0000-000000000001', 'aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaaa',
   '11111111-1111-1111-1111-111111111111', 'owner'),
  ('c0000000-0000-0000-0000-000000000002', 'aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaaa',
   '22222222-2222-2222-2222-222222222222', 'partner'),
  ('c0000000-0000-0000-0000-000000000003', 'aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaaa',
   '33333333-3333-3333-3333-333333333333', 'worker'),
  ('c0000000-0000-0000-0000-000000000005', 'aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaaa',
   '55555555-5555-5555-5555-555555555555', 'partner');

insert into public.apiaries (id, org_id, name) values
  ('a1000000-0000-0000-0000-000000000001', 'aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaaa', 'Yayla');

create temp table seq_before on commit drop as
select user_id, server_seq from public.memberships;

set local role service_role;

-- 5555'in kendi silme talebi bekliyor: devir hedefi olamaz.
select lives_ok(
  $$select public.account_deletion_request(
    '55555555-5555-5555-5555-555555555555', 'leaving@test.local',
    'aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaaa', false, 'uygulama')$$,
  'ikinci ortak kendi hesabını silmek ister'
);

select is(
  public.account_deletion_pending('11111111-1111-1111-1111-111111111111'),
  null, 'bekleyen talebi yoksa null'
);

-- Uygun olmayan hedefler.
select throws_ok(
  $$select public.account_deletion_request(
    '11111111-1111-1111-1111-111111111111', 'owner@test.local',
    'aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaaa', false, 'uygulama',
    '33333333-3333-3333-3333-333333333333')$$,
  'DL422', null, 'worker''a devredilmez (yalnız ortağa)'
);
select throws_ok(
  $$select public.account_deletion_request(
    '11111111-1111-1111-1111-111111111111', 'owner@test.local',
    'aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaaa', false, 'uygulama',
    '99999999-9999-9999-9999-999999999999')$$,
  'DL422', null, 'işletmede olmayana devredilmez'
);
select throws_ok(
  $$select public.account_deletion_request(
    '11111111-1111-1111-1111-111111111111', 'owner@test.local',
    'aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaaa', false, 'uygulama',
    '55555555-5555-5555-5555-555555555555')$$,
  'DL422', null, 'kendi silme talebi bekleyen ortağa devredilmez'
);
select throws_ok(
  $$select public.account_deletion_request(
    '11111111-1111-1111-1111-111111111111', 'owner@test.local',
    'aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaaa', true, 'uygulama',
    '22222222-2222-2222-2222-222222222222')$$,
  '22023', null, 'devir ile işletmeyi silmek birlikte seçilemez'
);
select throws_ok(
  $$select public.account_deletion_request(
    '22222222-2222-2222-2222-222222222222', 'partner@test.local',
    'aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaaa', false, 'uygulama',
    '55555555-5555-5555-5555-555555555555')$$,
  '42501', null, 'owner olmayan sahipliği devredemez'
);

reset role;
select is(
  (select role::text from public.memberships where user_id = '11111111-1111-1111-1111-111111111111'),
  'owner', 'reddedilen devirde roller değişmez'
);
set local role service_role;

-- Ortağa devir.
create temp table transfer on commit drop as
select public.account_deletion_request(
  '11111111-1111-1111-1111-111111111111', 'owner@test.local',
  'aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaaa', false, 'uygulama',
  '22222222-2222-2222-2222-222222222222'
) as r;

select is((select r #>> '{request,kind}' from transfer), 'hesap', 'devirde yalnız hesap silinir');
select is(
  (select r -> 'counts' ->> 'hives' from transfer), '0',
  'devirde silinecek işletme kaydı yok'
);

reset role;
select results_eq(
  $$select user_id::text, role::text from public.memberships
    where deleted_at is null order by user_id$$,
  $$values ('11111111-1111-1111-1111-111111111111', 'partner'),
           ('22222222-2222-2222-2222-222222222222', 'owner'),
           ('33333333-3333-3333-3333-333333333333', 'worker'),
           ('55555555-5555-5555-5555-555555555555', 'partner')$$,
  'ortak owner olur, eski owner partner olur'
);
select ok(
  (select bool_and(m.server_seq > b.server_seq)
   from public.memberships m join seq_before b using (user_id)
   where m.user_id in ('11111111-1111-1111-1111-111111111111',
                       '22222222-2222-2222-2222-222222222222')),
  'rol değişikliği diğer cihazlara senkronla ulaşır'
);
select ok(
  exists (select 1 from public.organizations where id = 'aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaaa'),
  'işletme kalır'
);

set local role service_role;
select is(
  public.account_deletion_pending('11111111-1111-1111-1111-111111111111') ->> 'kind',
  'hesap', 'bekleyen talep sorulabilir'
);
reset role;

-- İstemci fonksiyonu doğrudan çağıramaz.
set local role authenticated;
select throws_ok(
  $$select public.account_deletion_pending('11111111-1111-1111-1111-111111111111')$$,
  '42501', null, 'oturumlu kullanıcı bekleyen talep fonksiyonunu çağıramaz'
);
reset role;

select * from finish();
rollback;
