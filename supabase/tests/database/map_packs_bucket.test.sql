-- map-packs bucket'ı: public, yalnız MBTiles ve JSON; istemci (girişli ya
-- da anonim) yükleyemez, değiştiremez, silemez.
begin;
create extension if not exists pgtap with schema extensions;
select plan(5);

insert into auth.users (id, email) values
  ('11111111-1111-1111-1111-111111111111', 'user@test.local');

insert into storage.objects (bucket_id, name) values
  ('map-packs', 'catalog.json');

select results_eq(
  $$select public, file_size_limit, allowed_mime_types from storage.buckets where id = 'map-packs'$$,
  $$values (true, null::bigint, array['application/x-sqlite3', 'application/json'])$$,
  'map-packs bucket public, genel boyut sınırında, yalnız MBTiles ve JSON'
);

select is_empty(
  $$select policyname from pg_policies
    where schemaname = 'storage' and tablename = 'objects'
      and coalesce(qual, '') || coalesce(with_check, '') like '%map-packs%'$$,
  'map-packs için hiçbir politika yok (okuma public URL ile)'
);

set local role authenticated;
set local request.jwt.claims = '{"sub": "11111111-1111-1111-1111-111111111111"}';

select throws_ok(
  $$insert into storage.objects (bucket_id, name) values ('map-packs', 'v1/x.mbtiles')$$,
  '42501',
  null,
  'girişli kullanıcı paket yükleyemez'
);

select is_empty(
  $$update storage.objects set name = 'x.json' where bucket_id = 'map-packs' returning name$$,
  'girişli kullanıcı kataloğu değiştiremez'
);

set local role anon;
set local request.jwt.claims = '{}';

select throws_ok(
  $$insert into storage.objects (bucket_id, name) values ('map-packs', 'v1/y.mbtiles')$$,
  '42501',
  null,
  'anonim kullanıcı paket yükleyemez'
);

select * from finish();
rollback;
