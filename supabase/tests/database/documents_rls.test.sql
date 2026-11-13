-- documents RLS ve tutarlılık: başka işletmenin belgesi ve dosyası
-- görünmez ve yazılamaz; worker belge ekler, günceller ve dosya yükler;
-- viewer yalnız okur; kullanıcı tanımlı türün adı var, hazır türde yok;
-- dosya yolu belgenin kendi klasöründe; bucket özel, 20 MB, JPEG ve PDF;
-- sync_push belgeyi şema sürümü 11 ile durum kaydı olarak yazar.
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

-- Kullanıcılar: 3333 A'da worker, 5555 A'da viewer, 9999 B'nin owner'ı.
insert into auth.users (id, email) values
  ('33333333-3333-3333-3333-333333333333', 'worker@test.local'),
  ('55555555-5555-5555-5555-555555555555', 'viewer@test.local'),
  ('99999999-9999-9999-9999-999999999999', 'other@test.local');

-- aaaa: A işletmesi. eeee: B işletmesi.
insert into public.organizations (id, name, country_code, currency, created_by) values
  ('aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaaa', 'Petek Arıcılık', 'TR', 'TRY',
   '33333333-3333-3333-3333-333333333333'),
  ('eeeeeeee-eeee-eeee-eeee-eeeeeeeeeeee', 'Other Apiaries', 'DE', 'EUR',
   '99999999-9999-9999-9999-999999999999');

insert into public.memberships (id, org_id, user_id, role) values
  ('c0000000-0000-0000-0000-000000000003', 'aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaaa',
   '33333333-3333-3333-3333-333333333333', 'worker'),
  ('c0000000-0000-0000-0000-000000000005', 'aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaaa',
   '55555555-5555-5555-5555-555555555555', 'viewer'),
  ('c0000000-0000-0000-0000-000000000009', 'eeeeeeee-eeee-eeee-eeee-eeeeeeeeeeee',
   '99999999-9999-9999-9999-999999999999', 'owner');

-- Önek a8/e8 belge, f0 dosya.
insert into public.documents (id, org_id, type, name, expires_on, file_kind, storage_path, byte_size) values
  ('a8000000-0000-0000-0000-000000000001', 'aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaaa',
   'health_report', 'Sağlık raporu', '2026-11-01', 'pdf',
   'aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaaa/a8000000-0000-0000-0000-000000000001/f0000000-0000-0000-0000-000000000001.pdf',
   1000);

insert into public.documents (id, org_id, type, custom_type_name, name, file_kind, storage_path, byte_size) values
  ('e8000000-0000-0000-0000-000000000001', 'eeeeeeee-eeee-eeee-eeee-eeeeeeeeeeee',
   'custom', 'Insurance', 'Hive insurance', 'photo',
   'eeeeeeee-eeee-eeee-eeee-eeeeeeeeeeee/e8000000-0000-0000-0000-000000000001/f0000000-0000-0000-0000-000000000002.jpg',
   1000);

-- Her işletmenin bucket'ta birer dosyası.
insert into storage.objects (bucket_id, name) values
  ('documents', 'aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaaa/a8000000-0000-0000-0000-000000000001/f0000000-0000-0000-0000-000000000001.pdf'),
  ('documents', 'eeeeeeee-eeee-eeee-eeee-eeeeeeeeeeee/e8000000-0000-0000-0000-000000000001/f0000000-0000-0000-0000-000000000002.jpg');

select results_eq(
  $$select public, file_size_limit, allowed_mime_types from storage.buckets where id = 'documents'$$,
  $$values (false, 20971520::bigint, array['image/jpeg', 'application/pdf'])$$,
  'documents bucket özel, 20 MB sınırlı, yalnız JPEG ve PDF'
);

select is_empty(
  $$select policyname from pg_policies
    where schemaname = 'storage' and tablename = 'objects'
      and cmd in ('UPDATE', 'DELETE', 'ALL')
      and coalesce(qual, '') || coalesce(with_check, '') like '%documents%'$$,
  'belge dosyaları için güncelleme ya da silme politikası yok'
);

select throws_ok(
  $$insert into public.documents (id, org_id, type, name, file_kind, storage_path, byte_size)
    values ('a8000000-0000-0000-0000-000000000002', 'aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaaa',
            'custom', 'Sigorta', 'photo',
            'aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaaa/a8000000-0000-0000-0000-000000000002/f0000000-0000-0000-0000-000000000003.jpg',
            1000)$$,
  '23514',
  null,
  'kullanıcı tanımlı türün adı olur'
);

select throws_ok(
  $$insert into public.documents (id, org_id, type, custom_type_name, name, file_kind, storage_path, byte_size)
    values ('a8000000-0000-0000-0000-000000000003', 'aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaaa',
            'land_permit', 'İzin', 'Arazi izni', 'photo',
            'aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaaa/a8000000-0000-0000-0000-000000000003/f0000000-0000-0000-0000-000000000004.jpg',
            1000)$$,
  '23514',
  null,
  'hazır türde kullanıcı tanımlı ad olmaz'
);

select throws_ok(
  $$insert into public.documents (id, org_id, type, name, file_kind, storage_path, byte_size)
    values ('a8000000-0000-0000-0000-000000000004', 'aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaaa',
            'land_permit', 'Arazi izni', 'photo',
            'aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaaa/a8000000-0000-0000-0000-000000000001/f0000000-0000-0000-0000-000000000005.jpg',
            1000)$$,
  '23514',
  null,
  'dosya yolu belgenin kendi klasöründe'
);

select throws_ok(
  $$insert into public.documents (id, org_id, type, name, file_kind, storage_path, byte_size)
    values ('a8000000-0000-0000-0000-000000000005', 'aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaaa',
            'land_permit', 'Arazi izni', 'pdf',
            'aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaaa/a8000000-0000-0000-0000-000000000005/f0000000-0000-0000-0000-000000000006.jpg',
            1000)$$,
  '23514',
  null,
  'dosyanın uzantısı türüyle aynı'
);

set local role authenticated;

-- B'nin owner'ı
set local request.jwt.claims = '{"sub": "99999999-9999-9999-9999-999999999999"}';

select results_eq(
  'select id from public.documents',
  $$values ('e8000000-0000-0000-0000-000000000001'::uuid)$$,
  'başka işletmenin belgesini göremez, yalnız kendisininkini görür'
);

select results_eq(
  $$select name from storage.objects where bucket_id = 'documents'$$,
  $$values ('eeeeeeee-eeee-eeee-eeee-eeeeeeeeeeee/e8000000-0000-0000-0000-000000000001/f0000000-0000-0000-0000-000000000002.jpg'::text)$$,
  'başka işletmenin belge dosyasını göremez (indiremez)'
);

select throws_ok(
  $$insert into public.documents (id, org_id, type, name, file_kind, storage_path, byte_size)
    values ('e8000000-0000-0000-0000-000000000002', 'aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaaa',
            'health_report', 'Sızma', 'pdf',
            'aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaaa/e8000000-0000-0000-0000-000000000002/f0000000-0000-0000-0000-000000000007.pdf',
            1000)$$,
  '42501',
  null,
  'başka işletmeye belge ekleyemez'
);

select is_empty(
  $$update public.documents set expires_on = '2030-01-01'
    where id = 'a8000000-0000-0000-0000-000000000001' returning id$$,
  'başka işletmenin belgesini güncelleyemez'
);

select throws_ok(
  $$insert into storage.objects (bucket_id, name)
    values ('documents', 'aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaaa/a8000000-0000-0000-0000-000000000001/f0000000-0000-0000-0000-000000000008.pdf')$$,
  '42501',
  null,
  'başka işletmenin klasörüne belge dosyası yükleyemez'
);

-- A'nın worker'ı
set local request.jwt.claims = '{"sub": "33333333-3333-3333-3333-333333333333"}';

select lives_ok(
  $$insert into public.documents (id, org_id, type, name, description, expires_on, file_kind, storage_path, byte_size)
    values ('a8000000-0000-0000-0000-000000000006', 'aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaaa',
            'transport_permit', 'Nakil evrakı', 'Ula → Köyceğiz', '2026-12-01', 'photo',
            'aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaaa/a8000000-0000-0000-0000-000000000006/f0000000-0000-0000-0000-000000000009.jpg',
            1000)$$,
  'worker belge ekler'
);

select lives_ok(
  $$insert into storage.objects (bucket_id, name)
    values ('documents', 'aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaaa/a8000000-0000-0000-0000-000000000006/f0000000-0000-0000-0000-000000000009.jpg')$$,
  'worker belge dosyası yükler'
);

select isnt_empty(
  $$update public.documents set expires_on = '2027-11-01'
    where id = 'a8000000-0000-0000-0000-000000000001' returning id$$,
  'worker belgenin geçerlilik tarihini günceller'
);

select results_eq(
  $$select r ->> 'status', r ->> 'applied'
    from jsonb_array_elements(public.sync_push(
      $j$[{"id": 1, "table": "documents", "operation": "upsert", "payload": {
        "id": "a8000000-0000-0000-0000-000000000007",
        "org_id": "aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaaa",
        "type": "business_registration", "custom_type_name": null,
        "name": "İşletme tescil belgesi", "description": "TR-48",
        "expires_on": null, "file_kind": "pdf",
        "storage_path": "aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaaa/a8000000-0000-0000-0000-000000000007/f0000000-0000-0000-0000-000000000010.pdf",
        "byte_size": 2048,
        "created_at": "2026-10-27T09:00:00.000Z",
        "updated_at": "2026-10-27T09:00:00.000Z",
        "created_by": null, "deleted_at": null}},
      {"id": 2, "table": "documents", "operation": "upsert", "payload": {
        "id": "a8000000-0000-0000-0000-000000000007",
        "org_id": "aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaaa",
        "type": "business_registration", "custom_type_name": null,
        "name": "İşletme tescil belgesi", "description": "TR-48",
        "expires_on": "2031-05-01", "file_kind": "pdf",
        "storage_path": "aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaaa/a8000000-0000-0000-0000-000000000007/f0000000-0000-0000-0000-000000000010.pdf",
        "byte_size": 2048,
        "created_at": "2026-10-27T09:00:00.000Z",
        "updated_at": "2026-10-27T10:00:00.000Z",
        "created_by": null, "deleted_at": null}},
      {"id": 3, "table": "documents", "operation": "upsert", "payload": {
        "id": "a8000000-0000-0000-0000-000000000007",
        "org_id": "aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaaa",
        "type": "business_registration", "custom_type_name": null,
        "name": "İşletme tescil belgesi", "description": "TR-48",
        "expires_on": null, "file_kind": "pdf",
        "storage_path": "aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaaa/a8000000-0000-0000-0000-000000000007/f0000000-0000-0000-0000-000000000010.pdf",
        "byte_size": 2048,
        "created_at": "2026-10-27T09:00:00.000Z",
        "updated_at": "2026-10-27T09:30:00.000Z",
        "created_by": null, "deleted_at": null}}]$j$::jsonb,
      now(), 11) -> 'results') r$$,
  $$values ('ok', 'true'), ('ok', 'true'), ('ok', 'false')$$,
  'sync_push belgeyi şema sürümü 11 ile durum kaydı olarak yazar; eski yazma kaybeder'
);

select results_eq(
  $$select expires_on from public.documents
    where id = 'a8000000-0000-0000-0000-000000000007'$$,
  $$values ('2031-05-01'::date)$$,
  'son yazan kazanır: geçerlilik tarihi eski yazmayla silinmez'
);

-- A'nın viewer'ı
set local request.jwt.claims = '{"sub": "55555555-5555-5555-5555-555555555555"}';

select throws_ok(
  $$insert into public.documents (id, org_id, type, name, file_kind, storage_path, byte_size)
    values ('a8000000-0000-0000-0000-000000000008', 'aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaaa',
            'land_permit', 'Arazi izni', 'photo',
            'aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaaa/a8000000-0000-0000-0000-000000000008/f0000000-0000-0000-0000-000000000011.jpg',
            1000)$$,
  '42501',
  null,
  'viewer belge ekleyemez'
);

select results_eq(
  $$select count(*) from storage.objects where bucket_id = 'documents'$$,
  $$values (2::bigint)$$,
  'viewer işletmenin belge dosyalarını görür'
);

select * from finish();
rollback;
