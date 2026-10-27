-- device_tokens RLS: kullanıcı yalnız kendi token'larını görür, istemci
-- yazamaz (kayıt Edge Function ile). Görev atama tetikleyicisi Vault
-- gizlisi yokken görev yazmasını bozmaz.
begin;
create extension if not exists pgtap with schema extensions;
select plan(6);

insert into auth.users (id, email) values
  ('11111111-1111-1111-1111-111111111111', 'owner@test.local'),
  ('33333333-3333-3333-3333-333333333333', 'worker@test.local');

insert into public.organizations (id, name, country_code, currency, created_by) values
  ('aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaaa', 'Petek Arıcılık', 'TR', 'TRY',
   '11111111-1111-1111-1111-111111111111');

insert into public.memberships (id, org_id, user_id, role) values
  ('c0000000-0000-0000-0000-000000000001', 'aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaaa',
   '11111111-1111-1111-1111-111111111111', 'owner'),
  ('c0000000-0000-0000-0000-000000000003', 'aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaaa',
   '33333333-3333-3333-3333-333333333333', 'worker');

insert into public.device_tokens (user_id, token, platform) values
  ('11111111-1111-1111-1111-111111111111', 'token-owner', 'android'),
  ('33333333-3333-3333-3333-333333333333', 'token-worker', 'ios');

set local role authenticated;
set local request.jwt.claims = '{"sub": "11111111-1111-1111-1111-111111111111"}';

select results_eq(
  $$select token from public.device_tokens$$,
  $$values ('token-owner')$$,
  'kullanıcı yalnız kendi token''ını görür'
);
select throws_ok(
  $$insert into public.device_tokens (user_id, token, platform)
    values ('11111111-1111-1111-1111-111111111111', 'token-yeni', 'android')$$,
  '42501', null, 'istemci token yazamaz'
);
select is_empty(
  $$update public.device_tokens set token = 'ele-gecirildi' returning 1$$,
  'istemci token güncelleyemez'
);
select is_empty(
  $$delete from public.device_tokens returning 1$$,
  'istemci token silemez'
);

-- Vault gizlisi yok: atama tetikleyicisi görev yazmasını bozmaz.
select lives_ok(
  $$insert into public.tasks (id, org_id, title, due_at, assigned_to)
    values ('d0000000-0000-0000-0000-000000000001',
            'aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaaa', 'Şurup ver', now(),
            '33333333-3333-3333-3333-333333333333')$$,
  'gizli yokken başkasına görev atanır'
);
select lives_ok(
  $$update public.tasks set assigned_to = '11111111-1111-1111-1111-111111111111'
    where id = 'd0000000-0000-0000-0000-000000000001'$$,
  'gizli yokken atanan değişir'
);

select * from finish();
rollback;
