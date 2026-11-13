-- Lot yayımı: yayım kolonlarını yalnız owner değiştirir (başkasının ve
-- eski uygulamanın yazmasında korunur); lot_public_page yalnız yayımdaki
-- lotu, yalnız seçilen alanlarla ve kişisel veri olmadan döner; yalnız
-- service_role çağırır; public-lots bucket'ı özel; sync_push sürüm 18.
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

select plan(20);

-- 1111 A'nın owner'ı, 3333 A'da worker.
insert into auth.users (id, email) values
  ('11111111-1111-1111-1111-111111111111', 'owner@test.local'),
  ('33333333-3333-3333-3333-333333333333', 'worker@test.local');

insert into public.organizations (id, name, country_code, currency, tr_registration_no, tr_aks_no, created_by) values
  ('aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaaa', 'Yılmaz Arıcılık', 'TR', 'TRY', 'TR-123', 'AKS-9',
   '11111111-1111-1111-1111-111111111111');

insert into public.memberships (id, org_id, user_id, role) values
  ('c0000000-0000-0000-0000-000000000001', 'aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaaa',
   '11111111-1111-1111-1111-111111111111', 'owner'),
  ('c0000000-0000-0000-0000-000000000003', 'aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaaa',
   '33333333-3333-3333-3333-333333333333', 'worker');

insert into public.apiaries (id, org_id, name, location) values
  ('a1000000-0000-0000-0000-000000000001', 'aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaaa', 'Kızılçam',
   'SRID=4326;POINT(28.4 37.1)');

-- İki aktif, bir sönmüş, bir silinmiş kovan: aktif kovan sayısı 2.
insert into public.hives (id, org_id, number, type, apiary_id, status, deleted_at) values
  ('a3000000-0000-0000-0000-000000000001', 'aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaaa',
   '1', 'langstroth', 'a1000000-0000-0000-0000-000000000001', 'active', null),
  ('a3000000-0000-0000-0000-000000000002', 'aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaaa',
   '2', 'langstroth', 'a1000000-0000-0000-0000-000000000001', 'active', null),
  ('a3000000-0000-0000-0000-000000000003', 'aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaaa',
   '3', 'langstroth', 'a1000000-0000-0000-0000-000000000001', 'dead', null),
  ('a3000000-0000-0000-0000-000000000004', 'aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaaa',
   '4', 'langstroth', 'a1000000-0000-0000-0000-000000000001', 'active', now());

insert into public.harvests (id, org_id, apiary_id, harvested_at, honey_kind, unit, unit_count, net_kg) values
  ('a7000000-0000-0000-0000-000000000001', 'aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaaa',
   'a1000000-0000-0000-0000-000000000001', '2026-09-12 08:00+00', 'pine', 'super', 24, 574),
  ('a7000000-0000-0000-0000-000000000002', 'aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaaa',
   'a1000000-0000-0000-0000-000000000001', '2026-10-02 08:00+00', 'pine', 'super', 4, 80);

-- ab01 yayımda, ab02 yayımda değil.
insert into public.lots (id, org_id, year, seq, honey_kind, origin, moisture, published) values
  ('ab000000-0000-0000-0000-000000000001', 'aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaaa',
   2026, 7, 'pine', 'Ula, Muğla', 17.2, true),
  ('ab000000-0000-0000-0000-000000000002', 'aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaaa',
   2026, 8, 'pine', null, null, false);

insert into public.lot_harvests (id, org_id, lot_id, harvest_id) values
  ('ac000000-0000-0000-0000-000000000001', 'aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaaa',
   'ab000000-0000-0000-0000-000000000001', 'a7000000-0000-0000-0000-000000000002'),
  ('ac000000-0000-0000-0000-000000000002', 'aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaaa',
   'ab000000-0000-0000-0000-000000000001', 'a7000000-0000-0000-0000-000000000001');

insert into public.documents (id, org_id, type, name, file_kind, storage_path, byte_size) values
  ('a8000000-0000-0000-0000-000000000001', 'aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaaa',
   'analysis_report', 'Analiz raporu', 'pdf',
   'aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaaa/a8000000-0000-0000-0000-000000000001/f0000000-0000-0000-0000-000000000001.pdf',
   1000);

-- Eski analiz raporlu, yeni analiz raporsuz: değerler yeniden, rapor
-- son raporlu analizden.
insert into public.lab_results (id, org_id, lot_id, tested_on, hmf, diastase, moisture, residue, document_id) values
  ('af000000-0000-0000-0000-000000000001', 'aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaaa',
   'ab000000-0000-0000-0000-000000000001', '2026-10-01', 30, 9, 18, 'detected',
   'a8000000-0000-0000-0000-000000000001'),
  ('af000000-0000-0000-0000-000000000002', 'aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaaa',
   'ab000000-0000-0000-0000-000000000001', '2026-10-20', 12.5, 14, 17.2, 'none', null);

select is(
  public.lot_public_page('ab000000-0000-0000-0000-000000000001'),
  jsonb_build_object(
    'number', '2026-07',
    'honey_kind', 'pine',
    'producer', jsonb_build_object('name', 'Yılmaz Arıcılık', 'hive_count', 2),
    'origin', 'Ula, Muğla',
    'harvest_month', '2026-09',
    'lab', jsonb_build_object(
      'tested_on', '2026-10-20', 'hmf', 12.5, 'diastase', 14.0,
      'moisture', 17.2, 'residue', 'none'
    ),
    'report', jsonb_build_object(
      'document_id', 'a8000000-0000-0000-0000-000000000001',
      'file_kind', 'pdf',
      'storage_path', 'aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaaa/a8000000-0000-0000-0000-000000000001/f0000000-0000-0000-0000-000000000001.pdf'
    )
  ),
  'yayımdaki lot: numara, bal türü, işletme ve aktif kovan, yöre ve ilk hasat ayı, son analiz, son rapor'
);

select ok(
  not (public.lot_public_page('ab000000-0000-0000-0000-000000000001')::text
       ~* 'TR-123|AKS-9|POINT|37\.1|28\.4|owner@|11111111|Kızılçam'),
  'tescil no, AKS no, konum, e-posta, kullanıcı ve arılık adı dönmez'
);

select is(
  public.lot_public_page('ab000000-0000-0000-0000-000000000002'),
  null,
  'yayımda olmayan lot null'
);

select is(
  public.lot_public_page('ab000000-0000-0000-0000-0000000000ff'),
  null,
  'olmayan lot null'
);

update public.lots
set public_producer = false, public_origin = false, public_lab = false, public_report = false
where id = 'ab000000-0000-0000-0000-000000000001';

select is(
  public.lot_public_page('ab000000-0000-0000-0000-000000000001'),
  '{"number": "2026-07", "honey_kind": "pine"}'::jsonb,
  'seçilmeyen alanlar dönmez'
);

update public.lots set deleted_at = now()
where id = 'ab000000-0000-0000-0000-000000000001';

select is(
  public.lot_public_page('ab000000-0000-0000-0000-000000000001'),
  null,
  'silinmiş lot null'
);

update public.lots
set deleted_at = null, public_producer = true, public_origin = true, public_lab = true, public_report = true
where id = 'ab000000-0000-0000-0000-000000000001';

select ok(
  not has_function_privilege('authenticated', 'public.lot_public_page(uuid)', 'execute')
  and not has_function_privilege('anon', 'public.lot_public_page(uuid)', 'execute')
  and has_function_privilege('service_role', 'public.lot_public_page(uuid)', 'execute'),
  'sayfa verisini yalnız service_role okur'
);

select is(
  (select public from storage.buckets where id = 'public-lots'),
  false,
  'public-lots bucket''ı özel'
);

set local role authenticated;

-- Worker
set local request.jwt.claims = '{"sub": "33333333-3333-3333-3333-333333333333"}';

update public.lots set published = false, public_lab = false, origin = 'Ula'
where id = 'ab000000-0000-0000-0000-000000000001';

select results_eq(
  $$select origin, published, public_lab from public.lots
    where id = 'ab000000-0000-0000-0000-000000000001'$$,
  $$values ('Ula'::text, true, true)$$,
  'worker lotu düzenler ama yayımı ve alanları değiştiremez'
);

insert into public.lots (id, org_id, year, seq, honey_kind, published)
values ('ab000000-0000-0000-0000-000000000003', 'aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaaa',
        2026, 9, 'pine', true);

select is(
  (select published from public.lots where id = 'ab000000-0000-0000-0000-000000000003'),
  false,
  'worker''ın eklediği lot yayımda değil'
);

select is(
  public.sync_push(
    jsonb_build_array(jsonb_build_object(
      'id', 0, 'table', 'lots', 'operation', 'upsert',
      'payload', (select to_jsonb(l) - 'server_seq' from public.lots l
                  where l.id = 'ab000000-0000-0000-0000-000000000001')
        || jsonb_build_object('published', false, 'public_origin', false,
                              'updated_at', now() + interval '1 second')
    )),
    now(), 18
  ) -> 'results' -> 0 ->> 'status',
  'ok',
  'worker''ın sync_push ile lot yazması kabul edilir'
);

select results_eq(
  $$select published, public_origin from public.lots
    where id = 'ab000000-0000-0000-0000-000000000001'$$,
  $$values (true, true)$$,
  'worker sync_push ile de yayımı ve alanları değiştiremez'
);

select throws_ok(
  $$select public.lot_public_page('ab000000-0000-0000-0000-000000000001')$$,
  '42501',
  null,
  'oturumlu kullanıcı sayfa verisini doğrudan okuyamaz'
);

-- Owner
set local request.jwt.claims = '{"sub": "11111111-1111-1111-1111-111111111111"}';

update public.lots set published = false, public_report = false
where id = 'ab000000-0000-0000-0000-000000000001';

select results_eq(
  $$select published, public_report from public.lots
    where id = 'ab000000-0000-0000-0000-000000000001'$$,
  $$values (false, false)$$,
  'owner yayımdan kaldırır ve alan seçer'
);

-- sync_push ile owner yayımlar (sürüm 18).
select is(
  public.sync_push(
    jsonb_build_array(jsonb_build_object(
      'id', 1, 'table', 'lots', 'operation', 'upsert',
      'payload', (select to_jsonb(l) - 'server_seq' from public.lots l
                  where l.id = 'ab000000-0000-0000-0000-000000000001')
        || jsonb_build_object('published', true, 'updated_at', now() + interval '5 seconds')
    )),
    now(), 18
  ) -> 'results' -> 0 ->> 'status',
  'ok',
  'sync_push sürüm 18 ile lot yazar'
);

select is(
  (select published from public.lots where id = 'ab000000-0000-0000-0000-000000000001'),
  true,
  'owner sync_push ile yayımlar'
);

-- Eski uygulama (sürüm 17) yayım kolonlarını göndermez.
select is(
  public.sync_push(
    jsonb_build_array(jsonb_build_object(
      'id', 2, 'table', 'lots', 'operation', 'upsert',
      'payload', (select to_jsonb(l) - 'server_seq' - 'published' - 'public_producer'
                    - 'public_origin' - 'public_lab' - 'public_report'
                  from public.lots l
                  where l.id = 'ab000000-0000-0000-0000-000000000001')
        || jsonb_build_object('origin', 'Ula, Muğla', 'updated_at', now() + interval '10 seconds')
    )),
    now(), 17
  ) -> 'results' -> 0 ->> 'status',
  'ok',
  'eski uygulamanın lot yazması kabul edilir'
);

select results_eq(
  $$select origin, published, public_report from public.lots
    where id = 'ab000000-0000-0000-0000-000000000001'$$,
  $$values ('Ula, Muğla'::text, true, false)$$,
  'eski uygulamanın yazması yayımı ve alanları korur'
);

select is(
  public.sync_push(
    jsonb_build_array(jsonb_build_object(
      'id', 3, 'table', 'lots', 'operation', 'upsert',
      'payload', jsonb_build_object(
        'id', 'ab000000-0000-0000-0000-000000000004',
        'org_id', 'aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaaa',
        'year', 2026, 'seq', 10, 'honey_kind', 'pine', 'status', 'open',
        'created_at', now(), 'updated_at', now()
      )
    )),
    now(), 17
  ) -> 'results' -> 0 ->> 'status',
  'ok',
  'eski uygulama yayım kolonları olmadan yeni lot ekler'
);

select results_eq(
  $$select published, public_producer, public_origin, public_lab, public_report
    from public.lots where id = 'ab000000-0000-0000-0000-000000000004'$$,
  $$values (false, true, true, true, true)$$,
  'eski uygulamanın lotu yayımda değil, alanlar varsayılan'
);

select * from finish();
rollback;
