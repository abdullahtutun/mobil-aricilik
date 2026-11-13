-- create_organization: işletmeyi ve owner üyeliğini birlikte yazar; aynı
-- kimlikle yeniden çağrı yeni kayıt açmaz.
begin;
create extension if not exists pgtap with schema extensions;
select plan(12);

-- Kullanıcılar: 1111 işletme kurar, 2222 başka bir kullanıcı.
insert into auth.users (id, email) values
  ('11111111-1111-1111-1111-111111111111', 'owner@test.local'),
  ('22222222-2222-2222-2222-222222222222', 'other@test.local');

-- Giriş yapmamış
set local role anon;

select throws_ok(
  $$select public.create_organization(
      'dddddddd-dddd-dddd-dddd-dddddddddddd', 'Sahte', 'TR', 'TRY')$$,
  '42501',
  null,
  'anon işletme oluşturamaz'
);

-- İşletme kuran kullanıcı
set local role authenticated;
set local request.jwt.claims = '{"sub": "11111111-1111-1111-1111-111111111111"}';

select results_eq(
  $$select name, country_code, currency, hive_count_range, created_by
    from public.create_organization(
      'dddddddd-dddd-dddd-dddd-dddddddddddd', '  Yeni İşletme ', 'DE', 'EUR',
      'up_to_50')$$,
  $$values ('Yeni İşletme', 'DE', 'EUR', 'up_to_50'::public.hive_count_range,
            '11111111-1111-1111-1111-111111111111'::uuid)$$,
  'işletmeyi çağıranın adına oluşturur, adı kırpar ve satırı döner'
);

select results_eq(
  $$select user_id, role from public.memberships
    where org_id = 'dddddddd-dddd-dddd-dddd-dddddddddddd'$$,
  $$values ('11111111-1111-1111-1111-111111111111'::uuid,
            'owner'::public.membership_role)$$,
  'oluşturan owner olur'
);

select results_eq(
  'select id from public.organizations',
  $$values ('dddddddd-dddd-dddd-dddd-dddddddddddd'::uuid)$$,
  'oluşturan işletmeyi hemen görür'
);

select cmp_ok(
  (select server_seq from public.organizations
   where id = 'dddddddd-dddd-dddd-dddd-dddddddddddd'),
  '>',
  0::bigint,
  'işletme server_seq alır'
);

select results_eq(
  $$select id, name from public.create_organization(
      'dddddddd-dddd-dddd-dddd-dddddddddddd', 'Başka ad', 'TR', 'TRY')$$,
  $$values ('dddddddd-dddd-dddd-dddd-dddddddddddd'::uuid, 'Yeni İşletme')$$,
  'aynı kimlikle yeniden çağrı mevcut işletmeyi döner'
);

select results_eq(
  $$select count(*) from public.memberships
    where org_id = 'dddddddd-dddd-dddd-dddd-dddddddddddd'$$,
  $$values (1::bigint)$$,
  'yeniden çağrı ikinci owner üyeliği açmaz'
);

select throws_ok(
  $$select public.create_organization(
      'eeeeeeee-eeee-eeee-eeee-eeeeeeeeeeee', '   ', 'TR', 'TRY')$$,
  '22023',
  null,
  'boş ad reddedilir'
);

select throws_ok(
  $$select public.create_organization(
      'eeeeeeee-eeee-eeee-eeee-eeeeeeeeeeee', 'Küçük harf', 'tr', 'TRY')$$,
  '23514',
  null,
  'ülke kodu büyük harf iki harf olmalı'
);

select results_eq(
  $$select hive_count_range from public.create_organization(
      'eeeeeeee-eeee-eeee-eeee-eeeeeeeeeeee', 'Kovansız', 'TR', 'TRY')$$,
  $$values (null::public.hive_count_range)$$,
  'kovan sayısı verilmeyebilir'
);

-- Başka kullanıcı
set local request.jwt.claims = '{"sub": "22222222-2222-2222-2222-222222222222"}';

select throws_ok(
  $$select public.create_organization(
      'dddddddd-dddd-dddd-dddd-dddddddddddd', 'Ele geçirildi', 'TR', 'TRY')$$,
  '23505',
  null,
  'başkasının işletme kimliğiyle çağrı reddedilir'
);

select is_empty(
  'select id from public.organizations',
  'başka kullanıcı bu işletmeleri görmez'
);

select * from finish();
rollback;
