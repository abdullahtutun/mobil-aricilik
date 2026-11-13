-- knowledge bucket'ı: özel, yalnız JSON; girişli herkes (üyeliği olmasa da)
-- okur, anonim okuyamaz; istemci yazamaz, güncelleyemez, silemez.
begin;
create extension if not exists pgtap with schema extensions;
select plan(6);

insert into auth.users (id, email) values
  ('11111111-1111-1111-1111-111111111111', 'user@test.local');

insert into storage.objects (bucket_id, name) values
  ('knowledge', 'manifest.json'),
  ('knowledge', 'knowledge-v2.json');

select results_eq(
  $$select public, file_size_limit, allowed_mime_types from storage.buckets where id = 'knowledge'$$,
  $$values (false, 10485760::bigint, array['application/json'])$$,
  'knowledge bucket özel, 10 MB sınırlı, yalnız JSON'
);

select is_empty(
  $$select policyname from pg_policies
    where schemaname = 'storage' and tablename = 'objects'
      and cmd <> 'SELECT'
      and coalesce(qual, '') || coalesce(with_check, '') like '%knowledge%'$$,
  'bilgi bankası için ekleme, güncelleme ya da silme politikası yok'
);

set local role authenticated;
set local request.jwt.claims = '{"sub": "11111111-1111-1111-1111-111111111111"}';

select results_eq(
  $$select name from storage.objects where bucket_id = 'knowledge' order by name$$,
  $$values ('knowledge-v2.json'), ('manifest.json')$$,
  'üyeliği olmayan girişli kullanıcı paketleri okur'
);

select throws_ok(
  $$insert into storage.objects (bucket_id, name) values ('knowledge', 'manifest-x.json')$$,
  '42501',
  null,
  'girişli kullanıcı paket yükleyemez'
);

select is_empty(
  $$update storage.objects set name = 'x.json' where bucket_id = 'knowledge' returning name$$,
  'girişli kullanıcı paketi değiştiremez'
);

set local role anon;
set local request.jwt.claims = '{}';

select is_empty(
  $$select name from storage.objects where bucket_id = 'knowledge'$$,
  'anonim kullanıcı paketleri göremez'
);

select * from finish();
rollback;
