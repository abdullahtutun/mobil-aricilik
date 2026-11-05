-- Hesap silme kodu ve silinmek üzere olan üye
-- (20261115120000_deletion_code_and_leaving_member).
--
-- 1111 A'nın owner'ı, 2222 A'nın partner'ı.
begin;
create extension if not exists pgtap with schema extensions;
select plan(20);

insert into auth.users (id, email) values
  ('11111111-1111-1111-1111-111111111111', 'owner@test.local'),
  ('22222222-2222-2222-2222-222222222222', 'partner@test.local');

insert into public.organizations (id, name, country_code, currency, created_by) values
  ('aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaaa', 'Ekipli', 'TR', 'TRY',
   '11111111-1111-1111-1111-111111111111');
insert into public.memberships (id, org_id, user_id, role) values
  ('c0000000-0000-0000-0000-000000000001', 'aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaaa',
   '11111111-1111-1111-1111-111111111111', 'owner'),
  ('c0000000-0000-0000-0000-000000000002', 'aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaaa',
   '22222222-2222-2222-2222-222222222222', 'partner');

-- ---------------------------------------------------------------------------
-- Kod
-- ---------------------------------------------------------------------------

set local role service_role;
create temp table code on commit drop as
select public.account_deletion_send_code('22222222-2222-2222-2222-222222222222') as c;

select matches((select c from code), '^[0-9]{6}$', 'kod 6 hanelidir');
reset role;
select ok(
  (select code_hash <> (select c from code) from private.deletion_codes
   where user_id = '22222222-2222-2222-2222-222222222222'),
  'kod düz saklanmaz'
);
set local role service_role;

select throws_ok(
  $$select public.account_deletion_send_code('22222222-2222-2222-2222-222222222222')$$,
  'DL429', null, '60 saniye dolmadan yeni kod istenemez'
);
select is(
  public.account_deletion_code_verified('22222222-2222-2222-2222-222222222222'),
  false, 'doğrulanmamış kodla talep açılamaz'
);
select is(
  public.account_deletion_verify_code('22222222-2222-2222-2222-222222222222', 'yanlis'),
  'invalid', 'yanlış kod reddedilir'
);
select is(
  public.account_deletion_verify_code('11111111-1111-1111-1111-111111111111', (select c from code)),
  'invalid', 'başkasının kodu geçmez'
);
select is(
  public.account_deletion_verify_code('22222222-2222-2222-2222-222222222222', (select c from code)),
  'ok', 'doğru kod doğrulanır'
);
select is(
  public.account_deletion_code_verified('22222222-2222-2222-2222-222222222222'),
  true, 'doğrulanmış kod 15 dakika geçerli'
);
select lives_ok(
  $$select public.account_deletion_consume_code('22222222-2222-2222-2222-222222222222')$$,
  'kod tüketilir'
);
select is(
  public.account_deletion_code_verified('22222222-2222-2222-2222-222222222222'),
  false, 'tüketilen kod yeniden kullanılamaz'
);

-- Süresi dolan ve 5 kez yanlış girilen kod.
reset role;
update private.deletion_codes set sent_at = now() - interval '2 minutes'
where user_id = '22222222-2222-2222-2222-222222222222';
set local role service_role;
create temp table code2 on commit drop as
select public.account_deletion_send_code('11111111-1111-1111-1111-111111111111') as c;
reset role;
update private.deletion_codes set expires_at = now() - interval '1 second'
where user_id = '11111111-1111-1111-1111-111111111111';
set local role service_role;
select is(
  public.account_deletion_verify_code('11111111-1111-1111-1111-111111111111', (select c from code2)),
  'expired', 'süresi dolan kod geçmez'
);
reset role;
update private.deletion_codes
set expires_at = now() + interval '5 minutes', attempts = 4
where user_id = '11111111-1111-1111-1111-111111111111';
set local role service_role;
select is(
  public.account_deletion_verify_code('11111111-1111-1111-1111-111111111111', 'yanlis'),
  'too_many', 'beşinci yanlış denemede kod kilitlenir'
);
select is(
  public.account_deletion_verify_code('11111111-1111-1111-1111-111111111111', (select c from code2)),
  'too_many', 'kilitli kod doğruyla da geçmez'
);

-- Saatte en çok 5 kod.
reset role;
update private.deletion_codes
set sent_at = now() - interval '2 minutes', sent_in_window = 5
where user_id = '11111111-1111-1111-1111-111111111111';
set local role service_role;
select throws_ok(
  $$select public.account_deletion_send_code('11111111-1111-1111-1111-111111111111')$$,
  'DL429', null, 'saatte 5 koddan fazlası istenemez'
);
reset role;

set local role authenticated;
select throws_ok(
  $$select public.account_deletion_send_code('11111111-1111-1111-1111-111111111111')$$,
  '42501', null, 'oturumlu kullanıcı kod fonksiyonunu doğrudan çağıramaz'
);
reset role;

-- ---------------------------------------------------------------------------
-- Silinmek üzere olan üye
-- ---------------------------------------------------------------------------

create temp table seq_before on commit drop as
select server_seq from public.memberships where user_id = '22222222-2222-2222-2222-222222222222';

set local role service_role;
create temp table partner_request on commit drop as
select public.account_deletion_request(
  '22222222-2222-2222-2222-222222222222', 'partner@test.local',
  'aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaaa', false, 'uygulama'
) as r;
reset role;

select is(
  (select deletion_scheduled_for from public.memberships
   where user_id = '22222222-2222-2222-2222-222222222222'),
  (select (r #>> '{request,scheduled_for}')::timestamptz from partner_request),
  'talepte üyeliğe silme tarihi yazılır'
);
select ok(
  (select m.server_seq > b.server_seq from public.memberships m, seq_before b
   where m.user_id = '22222222-2222-2222-2222-222222222222'),
  'işaret diğer cihazlara senkronla ulaşır'
);
select is(
  (select deletion_scheduled_for from public.memberships
   where user_id = '11111111-1111-1111-1111-111111111111'),
  null, 'diğer üyeler işaretlenmez'
);

set local role service_role;
select ok(
  public.account_deletion_cancel('22222222-2222-2222-2222-222222222222'),
  'talep iptal edilir'
);
reset role;
select is(
  (select deletion_scheduled_for from public.memberships
   where user_id = '22222222-2222-2222-2222-222222222222'),
  null, 'iptalde işaret kalkar'
);

select * from finish();
rollback;
