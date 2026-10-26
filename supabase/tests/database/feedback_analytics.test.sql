-- feedback ve analytics_events: üye (viewer da) kendi işletmesi adına görüş
-- bildirir, başka işletme adına ya da başka kullanıcı adına bildiremez;
-- kimse geri okuyamaz; aynı kimliğin ikinci gönderimi yok sayılır. Analitik
-- olayı oturumlu herkes ekler, kimse okuyamaz, oturumsuz eklenemez. Ekran
-- görüntüsü yalnız üyesi olunan işletmenin yoluna yüklenir.
begin;
create extension if not exists pgtap with schema extensions;
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

select results_eq(
  $$select public, file_size_limit, allowed_mime_types from storage.buckets where id = 'feedback'$$,
  $$values (false, 5242880::bigint, array['image/jpeg'])$$,
  'feedback bucket özel, 5 MB ve yalnız JPEG'
);

set local role authenticated;

-- A'nın worker'ı
set local request.jwt.claims = '{"sub": "33333333-3333-3333-3333-333333333333"}';

select lives_ok(
  $$insert into public.feedback (id, org_id, kind, message, screenshot_path, device_info)
    values ('f0000000-0000-0000-0000-000000000001', 'aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaaa',
            'bug', 'Tur modunda liste açılmıyor',
            'aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaaa/f0000000-0000-0000-0000-000000000001.jpg',
            '{"app_version": "1.0.0+1", "os": "android"}')$$,
  'worker kendi işletmesi adına ekran görüntülü görüş bildirir'
);

select throws_ok(
  $$insert into public.feedback (id, org_id, kind, message)
    values ('f0000000-0000-0000-0000-000000000001', 'aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaaa',
            'bug', 'Tur modunda liste açılmıyor')$$,
  '23505',
  null,
  'aynı görüşün ikinci gönderimi çakışma alır (istemci gönderildi sayar)'
);

select is_empty(
  'select id from public.feedback',
  'gönderdiği görüşü geri okuyamaz'
);

select throws_ok(
  $$insert into public.feedback (id, org_id, kind, message)
    values ('f0000000-0000-0000-0000-000000000002', 'eeeeeeee-eeee-eeee-eeee-eeeeeeeeeeee',
            'suggestion', 'Başka işletme adına')$$,
  '42501',
  null,
  'başka işletme adına görüş bildiremez'
);

select throws_ok(
  $$insert into public.feedback (id, org_id, kind, message, created_by)
    values ('f0000000-0000-0000-0000-000000000003', 'aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaaa',
            'thanks', 'Başkası adına', '55555555-5555-5555-5555-555555555555')$$,
  '42501',
  null,
  'başka kullanıcı adına görüş bildiremez'
);

select throws_ok(
  $$insert into public.feedback (id, org_id, kind, message)
    values ('f0000000-0000-0000-0000-000000000004', 'aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaaa',
            'bug', '   ')$$,
  '23514',
  null,
  'boş mesaj reddedilir'
);

select throws_ok(
  $$insert into public.feedback (id, org_id, kind, message, screenshot_path)
    values ('f0000000-0000-0000-0000-000000000005', 'aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaaa',
            'bug', 'Yanlış yol',
            'eeeeeeee-eeee-eeee-eeee-eeeeeeeeeeee/f0000000-0000-0000-0000-000000000005.jpg')$$,
  '23514',
  null,
  'ekran görüntüsü yolu işletme ve görüş kimliğinden başka olamaz'
);

select lives_ok(
  $$insert into storage.objects (bucket_id, name)
    values ('feedback', 'aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaaa/f0000000-0000-0000-0000-000000000001.jpg')$$,
  'üye kendi işletmesinin yoluna ekran görüntüsü yükler'
);

select throws_ok(
  $$insert into storage.objects (bucket_id, name)
    values ('feedback', 'eeeeeeee-eeee-eeee-eeee-eeeeeeeeeeee/f0000000-0000-0000-0000-000000000006.jpg')$$,
  '42501',
  null,
  'başka işletmenin yoluna ekran görüntüsü yükleyemez'
);

select is_empty(
  $$select name from storage.objects where bucket_id = 'feedback'$$,
  'yüklediği ekran görüntüsünü okuyamaz'
);

select lives_ok(
  $$insert into public.analytics_events (id, install_id, name, props, occurred_at, app_version, platform)
    values ('d0000000-0000-0000-0000-000000000001', 'b0000000-0000-0000-0000-000000000001',
            'inspection_saved', '{"duration_s": 95}', now(), '1.0.0+1', 'android')$$,
  'oturumlu kullanıcı kullanım olayı ekler'
);

select throws_ok(
  $$insert into public.analytics_events (id, install_id, name, occurred_at)
    values ('d0000000-0000-0000-0000-000000000001', 'b0000000-0000-0000-0000-000000000001',
            'inspection_saved', now())$$,
  '23505',
  null,
  'aynı olayın ikinci gönderimi çakışma alır (istemci gönderildi sayar)'
);

select is_empty(
  'select id from public.analytics_events',
  'kullanım olaylarını okuyamaz'
);

select throws_ok(
  $$insert into public.analytics_events (id, install_id, name, occurred_at)
    values ('d0000000-0000-0000-0000-000000000002', 'b0000000-0000-0000-0000-000000000001',
            'Serbest metin!', now())$$,
  '23514',
  null,
  'olay adı küçük harf ve alt çizgi olmalı'
);

-- Salt görüntüleyen
set local request.jwt.claims = '{"sub": "55555555-5555-5555-5555-555555555555"}';

select lives_ok(
  $$insert into public.feedback (id, org_id, kind, message)
    values ('f0000000-0000-0000-0000-000000000007', 'aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaaa',
            'missing_feature', 'Ekip modülü')$$,
  'viewer da görüş bildirir'
);

reset role;
set local role anon;
set local request.jwt.claims = '{"role": "anon"}';

select throws_ok(
  $$insert into public.analytics_events (id, install_id, name, occurred_at)
    values ('d0000000-0000-0000-0000-000000000003', 'b0000000-0000-0000-0000-000000000001',
            'scan_finished', now())$$,
  '42501',
  null,
  'oturumsuz kullanım olayı eklenemez'
);

reset role;

select results_eq(
  'select kind::text, created_by from public.feedback order by id',
  $$values ('bug', '33333333-3333-3333-3333-333333333333'::uuid),
           ('missing_feature', '55555555-5555-5555-5555-555555555555'::uuid)$$,
  'görüşler gönderenin kimliğiyle yazıldı'
);

select * from finish();
rollback;
