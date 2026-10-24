-- media RLS, tutarlılık ve Storage: başka işletmenin medyası ve dosyası
-- görünmez; worker yazar ve yükler, viewer yalnız okur; işletmeler arası
-- bağ, kimlikten türemeyen yol ve biçimsiz dosya yolu reddedilir;
-- sync_push medyayı şema sürümü 3 ile olay kaydı olarak yazar.
begin;
create extension if not exists pgtap with schema extensions;
select plan(21);

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

-- Önek a1/e1 arılık, a3/e3 kovan, a5/e5 muayene, a7/e7 medya.
insert into public.apiaries (id, org_id, name) values
  ('a1000000-0000-0000-0000-000000000001', 'aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaaa', 'Yayla'),
  ('e1000000-0000-0000-0000-000000000001', 'eeeeeeee-eeee-eeee-eeee-eeeeeeeeeeee', 'Ova');

insert into public.hives (id, org_id, number, type, apiary_id) values
  ('a3000000-0000-0000-0000-000000000001', 'aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaaa',
   '101', 'langstroth', 'a1000000-0000-0000-0000-000000000001'),
  ('e3000000-0000-0000-0000-000000000001', 'eeeeeeee-eeee-eeee-eeee-eeeeeeeeeeee',
   '101', 'dadant', 'e1000000-0000-0000-0000-000000000001');

insert into public.inspections (id, org_id, hive_id, apiary_id, inspected_at) values
  ('a5000000-0000-0000-0000-000000000001', 'aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaaa',
   'a3000000-0000-0000-0000-000000000001', 'a1000000-0000-0000-0000-000000000001', now()),
  ('e5000000-0000-0000-0000-000000000001', 'eeeeeeee-eeee-eeee-eeee-eeeeeeeeeeee',
   'e3000000-0000-0000-0000-000000000001', 'e1000000-0000-0000-0000-000000000001', now());

insert into public.media (id, org_id, hive_id, kind, storage_path, captured_at, byte_size) values
  ('a7000000-0000-0000-0000-000000000001', 'aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaaa',
   'a3000000-0000-0000-0000-000000000001', 'photo',
   'aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaaa/a3000000-0000-0000-0000-000000000001/a7000000-0000-0000-0000-000000000001.jpg',
   now(), 1000),
  ('e7000000-0000-0000-0000-000000000001', 'eeeeeeee-eeee-eeee-eeee-eeeeeeeeeeee',
   'e3000000-0000-0000-0000-000000000001', 'photo',
   'eeeeeeee-eeee-eeee-eeee-eeeeeeeeeeee/e3000000-0000-0000-0000-000000000001/e7000000-0000-0000-0000-000000000001.jpg',
   now(), 1000);

-- Her işletmenin bucket'ta birer dosyası.
insert into storage.objects (bucket_id, name) values
  ('media', 'aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaaa/a3000000-0000-0000-0000-000000000001/a7000000-0000-0000-0000-000000000001.jpg'),
  ('media', 'eeeeeeee-eeee-eeee-eeee-eeeeeeeeeeee/e3000000-0000-0000-0000-000000000001/e7000000-0000-0000-0000-000000000001.jpg');

select results_eq(
  $$select public, file_size_limit, allowed_mime_types from storage.buckets where id = 'media'$$,
  $$values (false, 10485760::bigint, array['image/jpeg', 'audio/mp4'])$$,
  'media bucket özel, 10 MB sınırlı, yalnız JPEG ve AAC (m4a)'
);

select is_empty(
  $$select policyname from pg_policies
    where schemaname = 'storage' and tablename = 'objects'
      and cmd in ('UPDATE', 'DELETE', 'ALL')
      and coalesce(qual, '') || coalesce(with_check, '') like '%media%'$$,
  'media dosyaları için güncelleme ya da silme politikası yok'
);

set local role authenticated;

-- B'nin owner'ı
set local request.jwt.claims = '{"sub": "99999999-9999-9999-9999-999999999999"}';

select results_eq(
  'select id from public.media',
  $$values ('e7000000-0000-0000-0000-000000000001'::uuid)$$,
  'başka işletmenin medyasını göremez, yalnız kendisininkini görür'
);

select results_eq(
  $$select name from storage.objects where bucket_id = 'media'$$,
  $$values ('eeeeeeee-eeee-eeee-eeee-eeeeeeeeeeee/e3000000-0000-0000-0000-000000000001/e7000000-0000-0000-0000-000000000001.jpg'::text)$$,
  'başka işletmenin dosyasını göremez (indiremez)'
);

select throws_ok(
  $$insert into public.media (id, org_id, hive_id, kind, storage_path, captured_at, byte_size)
    values ('e7000000-0000-0000-0000-000000000002', 'aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaaa',
            'a3000000-0000-0000-0000-000000000001', 'photo',
            'aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaaa/a3000000-0000-0000-0000-000000000001/e7000000-0000-0000-0000-000000000002.jpg',
            now(), 1000)$$,
  '42501',
  null,
  'başka işletmeye medya ekleyemez'
);

select throws_ok(
  $$insert into storage.objects (bucket_id, name)
    values ('media', 'aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaaa/a3000000-0000-0000-0000-000000000001/e7000000-0000-0000-0000-000000000002.jpg')$$,
  '42501',
  null,
  'başka işletmenin klasörüne dosya yükleyemez'
);

select throws_ok(
  $$insert into public.media (id, org_id, hive_id, kind, storage_path, captured_at, byte_size)
    values ('e7000000-0000-0000-0000-000000000003', 'eeeeeeee-eeee-eeee-eeee-eeeeeeeeeeee',
            'a3000000-0000-0000-0000-000000000001', 'photo',
            'eeeeeeee-eeee-eeee-eeee-eeeeeeeeeeee/a3000000-0000-0000-0000-000000000001/e7000000-0000-0000-0000-000000000003.jpg',
            now(), 1000)$$,
  '23503',
  null,
  'kendi medyasını başka işletmenin kovanına bağlayamaz'
);

select throws_ok(
  $$insert into public.media (id, org_id, hive_id, inspection_id, kind, storage_path, captured_at, byte_size)
    values ('e7000000-0000-0000-0000-000000000004', 'eeeeeeee-eeee-eeee-eeee-eeeeeeeeeeee',
            'e3000000-0000-0000-0000-000000000001', 'a5000000-0000-0000-0000-000000000001', 'photo',
            'eeeeeeee-eeee-eeee-eeee-eeeeeeeeeeee/e3000000-0000-0000-0000-000000000001/e7000000-0000-0000-0000-000000000004.jpg',
            now(), 1000)$$,
  '23503',
  null,
  'kendi medyasını başka işletmenin muayenesine bağlayamaz'
);

-- A'nın worker'ı
set local request.jwt.claims = '{"sub": "33333333-3333-3333-3333-333333333333"}';

select lives_ok(
  $$insert into public.media (id, org_id, hive_id, inspection_id, kind, storage_path, captured_at, byte_size)
    values ('a7000000-0000-0000-0000-000000000002', 'aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaaa',
            'a3000000-0000-0000-0000-000000000001', 'a5000000-0000-0000-0000-000000000001', 'photo',
            'aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaaa/a3000000-0000-0000-0000-000000000001/a7000000-0000-0000-0000-000000000002.jpg',
            now(), 250000)$$,
  'worker muayeneye bağlı foto ekler'
);

select lives_ok(
  $$insert into public.media (id, org_id, hive_id, kind, storage_path, captured_at, byte_size, duration_ms)
    values ('a7000000-0000-0000-0000-000000000003', 'aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaaa',
            'a3000000-0000-0000-0000-000000000001', 'audio',
            'aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaaa/a3000000-0000-0000-0000-000000000001/a7000000-0000-0000-0000-000000000003.m4a',
            now(), 48000, 12000)$$,
  'worker kovana sesli not ekler'
);

select throws_ok(
  $$insert into public.media (id, org_id, hive_id, kind, storage_path, captured_at, byte_size)
    values ('a7000000-0000-0000-0000-000000000004', 'aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaaa',
            'a3000000-0000-0000-0000-000000000001', 'photo',
            'eeeeeeee-eeee-eeee-eeee-eeeeeeeeeeee/e3000000-0000-0000-0000-000000000001/e7000000-0000-0000-0000-000000000001.jpg',
            now(), 1000)$$,
  '23514',
  null,
  'yol kimlikten türemeli; başka işletmenin dosyasını gösteremez'
);

select throws_ok(
  $$insert into public.media (id, org_id, hive_id, kind, storage_path, captured_at, byte_size)
    values ('a7000000-0000-0000-0000-000000000005', 'aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaaa',
            'a3000000-0000-0000-0000-000000000001', 'audio',
            'aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaaa/a3000000-0000-0000-0000-000000000001/a7000000-0000-0000-0000-000000000005.jpg',
            now(), 1000)$$,
  '23514',
  null,
  'sesli notun uzantısı m4a olmalı'
);

select throws_ok(
  $$insert into public.media (id, org_id, hive_id, kind, storage_path, captured_at, byte_size, duration_ms)
    values ('a7000000-0000-0000-0000-000000000006', 'aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaaa',
            'a3000000-0000-0000-0000-000000000001', 'photo',
            'aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaaa/a3000000-0000-0000-0000-000000000001/a7000000-0000-0000-0000-000000000006.jpg',
            now(), 1000, 5000)$$,
  '23514',
  null,
  'fotoğrafın süresi olmaz'
);

select lives_ok(
  $$insert into storage.objects (bucket_id, name)
    values ('media', 'aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaaa/a3000000-0000-0000-0000-000000000001/a7000000-0000-0000-0000-000000000002.jpg')$$,
  'worker kendi işletmesinin klasörüne yükler'
);

select throws_ok(
  $$insert into storage.objects (bucket_id, name)
    values ('media', 'aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaaa/notlar.txt')$$,
  '42501',
  null,
  'biçimsiz yola yükleyemez'
);

select is_empty(
  $$update storage.objects set name = name || '.bak'
    where bucket_id = 'media' returning name$$,
  'yüklenen dosya değiştirilemez'
);


select results_eq(
  $$select r ->> 'status', r ->> 'applied'
    from jsonb_array_elements(public.sync_push(
      $j$[{"id": 1, "table": "media", "operation": "upsert", "payload": {
        "id": "a7000000-0000-0000-0000-000000000007",
        "org_id": "aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaaa",
        "hive_id": "a3000000-0000-0000-0000-000000000001",
        "inspection_id": null, "kind": "audio",
        "storage_path": "aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaaa/a3000000-0000-0000-0000-000000000001/a7000000-0000-0000-0000-000000000007.m4a",
        "captured_at": "2026-10-24T09:00:00.000Z", "byte_size": 48000,
        "duration_ms": 12000,
        "created_at": "2026-10-24T09:00:00.000Z",
        "updated_at": "2026-10-24T09:00:00.000Z",
        "created_by": null, "deleted_at": null}}]$j$::jsonb,
      now(), 3) -> 'results') r$$,
  $$values ('ok', 'true')$$,
  'sync_push medyayı şema sürümü 3 ile yazar'
);

select results_eq(
  $$select r ->> 'status', r ->> 'applied'
    from jsonb_array_elements(public.sync_push(
      $j$[{"id": 1, "table": "media", "operation": "delete", "payload": {
        "id": "a7000000-0000-0000-0000-000000000007",
        "org_id": "aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaaa",
        "hive_id": "a3000000-0000-0000-0000-000000000001",
        "inspection_id": null, "kind": "audio",
        "storage_path": "aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaaa/a3000000-0000-0000-0000-000000000001/a7000000-0000-0000-0000-000000000007.m4a",
        "captured_at": "2026-10-24T09:00:00.000Z", "byte_size": 1,
        "duration_ms": 1,
        "created_at": "2026-10-24T09:00:00.000Z",
        "updated_at": "2026-10-24T09:05:00.000Z",
        "created_by": null, "deleted_at": "2026-10-24T09:05:00.000Z"}}]$j$::jsonb,
      now(), 3) -> 'results') r$$,
  $$values ('ok', 'true')$$,
  'sync_push medyanın silinmesini işler'
);

select results_eq(
  $$select byte_size, duration_ms, deleted_at is not null from public.media
    where id = 'a7000000-0000-0000-0000-000000000007'$$,
  $$values (48000, 12000, true)$$,
  'olay kaydı: silme yalnız deleted_at yazar, diğer alanlar değişmez'
);

-- A'nın viewer'ı
set local request.jwt.claims = '{"sub": "55555555-5555-5555-5555-555555555555"}';

select throws_ok(
  $$insert into public.media (id, org_id, hive_id, kind, storage_path, captured_at, byte_size)
    values ('a7000000-0000-0000-0000-000000000008', 'aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaaa',
            'a3000000-0000-0000-0000-000000000001', 'photo',
            'aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaaa/a3000000-0000-0000-0000-000000000001/a7000000-0000-0000-0000-000000000008.jpg',
            now(), 1000)$$,
  '42501',
  null,
  'viewer medya ekleyemez'
);

select throws_ok(
  $$insert into storage.objects (bucket_id, name)
    values ('media', 'aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaaa/a3000000-0000-0000-0000-000000000001/a7000000-0000-0000-0000-000000000008.jpg')$$,
  '42501',
  null,
  'viewer dosya yükleyemez, ama işletmenin dosyalarını görür'
);

select * from finish();
rollback;
