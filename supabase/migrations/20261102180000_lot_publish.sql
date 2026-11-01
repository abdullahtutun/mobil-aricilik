-- Lotun herkese açık sayfası (ozellikler.md §6 "Parti (lot) oluşturma",
-- müşteri QR sayfası). Owner lotu yayımlar ve sayfada görünecek alanları
-- seçer; `lot-page` Edge Function'ı sayfayı lot kimliğiyle döner.
--
-- lots.published: lot yayımda mı. public_producer (işletme adı + aktif
-- kovan sayısı), public_origin (yöre + hasat ayı), public_lab (son analizin
-- değerleri), public_report (son analizin raporu): yayımda hangi alanlar
-- görünür. Bal türü ve lot numarası hep görünür. Kolonlar offline yazılır
-- ve lot satırıyla senkronlanır.
--
-- Yalnız owner değiştirir: başkasının yazmasında bu kolonlar sessizce
-- sunucudaki değerde kalır (yeni lotta yayım kapalı). Reddedilmez, çünkü
-- worker'ın eski kopyasıyla yaptığı sıradan lot düzenlemesi de bu
-- kolonları taşır. Kolonları bilmeyen eski uygulamanın (sürüm ≤ 17)
-- yazmasında boş gelen değerler de korunur.
--
-- public.lot_public_page(lot_id) sayfanın verisini döner; yalnız
-- service_role çağırır (Edge Function). Kişisel veri (telefon, adres,
-- konum, e-posta, kullanıcı) hiç seçilmez; seçilmeyen alan hiç dönmez.
--
-- public-lots bucket'ı: yayımlanan analiz raporunun kopyası
-- `<lot_id>/<document_id>.pdf|jpg` yolunda. Bucket özel; dosyayı yalnız
-- Edge Function yayım durumunu denetleyerek sunar, böylece yayımdan
-- kaldırılan lotun raporu da hemen erişilmez olur. Kopyayı fonksiyon
-- yazar ve siler; istemciye politika yok.
--
-- sync_push Drift şema sürümü 18'i kabul eder.

alter table public.lots add column published boolean not null default false;
alter table public.lots add column public_producer boolean not null default true;
alter table public.lots add column public_origin boolean not null default true;
alter table public.lots add column public_lab boolean not null default true;
alter table public.lots add column public_report boolean not null default true;

-- Owner olmayanın ve eski uygulamanın yazmasında yayım kolonları korunur.
-- auth.uid() boşsa (service role, migration) dokunulmaz.
--
-- sync_push upsert'ü önce eklemeyi dener: BEFORE INSERT çakışmadan önce
-- çalışır ve çakışmadaki güncelleme bu satırın değerlerini yazar. Bu
-- yüzden eklemede satır zaten varsa boş ya da yetkisiz değerler mevcut
-- satırdan alınır; yoksa varsayılandır.
create function private.guard_lot_publication()
returns trigger
language plpgsql
set search_path = ''
as $$
declare
  is_owner constant boolean :=
    (select auth.uid()) is null or private.has_role(new.org_id, '{owner}');
  prior record;
begin
  if tg_op = 'INSERT' then
    select l.published, l.public_producer, l.public_origin, l.public_lab, l.public_report
    into prior
    from public.lots l
    where l.id = new.id;
    if not found then
      new.published := is_owner and coalesce(new.published, false);
      new.public_producer := coalesce(new.public_producer, true);
      new.public_origin := coalesce(new.public_origin, true);
      new.public_lab := coalesce(new.public_lab, true);
      new.public_report := coalesce(new.public_report, true);
    elsif is_owner then
      new.published := coalesce(new.published, prior.published);
      new.public_producer := coalesce(new.public_producer, prior.public_producer);
      new.public_origin := coalesce(new.public_origin, prior.public_origin);
      new.public_lab := coalesce(new.public_lab, prior.public_lab);
      new.public_report := coalesce(new.public_report, prior.public_report);
    else
      new.published := prior.published;
      new.public_producer := prior.public_producer;
      new.public_origin := prior.public_origin;
      new.public_lab := prior.public_lab;
      new.public_report := prior.public_report;
    end if;
  elsif is_owner then
    new.published := coalesce(new.published, old.published);
    new.public_producer := coalesce(new.public_producer, old.public_producer);
    new.public_origin := coalesce(new.public_origin, old.public_origin);
    new.public_lab := coalesce(new.public_lab, old.public_lab);
    new.public_report := coalesce(new.public_report, old.public_report);
  else
    new.published := old.published;
    new.public_producer := old.public_producer;
    new.public_origin := old.public_origin;
    new.public_lab := old.public_lab;
    new.public_report := old.public_report;
  end if;
  return new;
end;
$$;

create trigger guard_lot_publication
before insert or update on public.lots
for each row execute function private.guard_lot_publication();

-- ---------------------------------------------------------------------------
-- Sayfanın verisi
-- ---------------------------------------------------------------------------
-- Lot yoksa, silinmişse, işletmesi silinmişse ya da yayımda değilse null.
-- Dönen nesne: number ("2026-07"), honey_kind ve seçilen alanlar:
--   producer { name, hive_count }      public_producer
--   origin, harvest_month (YYYY-MM)     public_origin (ikisi de boş olabilir)
--   lab { tested_on, hmf, diastase, proline, moisture, residue }
--                                       public_lab, son analiz
--   report { document_id, file_kind, storage_path }
--                                       public_report, son raporlu analiz
-- report.storage_path documents bucket'ındaki kaynak; fonksiyon kopyalar,
-- sayfada gösterilmez.
create function public.lot_public_page(lot_id uuid)
returns jsonb
language sql
stable
security definer
set search_path = ''
as $$
  select jsonb_strip_nulls(jsonb_build_object(
    'number', format('%s-%s', l.year, lpad(l.seq::text, 2, '0')),
    'honey_kind', l.honey_kind,
    'producer', case when l.public_producer then jsonb_build_object(
      'name', o.name,
      'hive_count', (
        select count(*) from public.hives h
        where h.org_id = l.org_id and h.status = 'active' and h.deleted_at is null
      )
    ) end,
    'origin', case when l.public_origin then l.origin end,
    'harvest_month', case when l.public_origin then (
      select to_char(min(h.harvested_at) at time zone 'UTC', 'YYYY-MM')
      from public.lot_harvests lh
      join public.harvests h on h.id = lh.harvest_id and h.deleted_at is null
      where lh.lot_id = l.id and lh.deleted_at is null
    ) end,
    'lab', case when l.public_lab then (
      select jsonb_build_object(
        'tested_on', r.tested_on,
        'hmf', r.hmf,
        'diastase', r.diastase,
        'proline', r.proline,
        'moisture', r.moisture,
        'residue', r.residue
      )
      from public.lab_results r
      where r.lot_id = l.id and r.deleted_at is null
      order by r.tested_on desc, r.created_at desc
      limit 1
    ) end,
    'report', case when l.public_report then (
      select jsonb_build_object(
        'document_id', d.id,
        'file_kind', d.file_kind,
        'storage_path', d.storage_path
      )
      from public.lab_results r
      join public.documents d on d.id = r.document_id and d.deleted_at is null
      where r.lot_id = l.id and r.deleted_at is null
      order by r.tested_on desc, r.created_at desc
      limit 1
    ) end
  ))
  from public.lots l
  join public.organizations o on o.id = l.org_id and o.deleted_at is null
  where l.id = lot_public_page.lot_id
    and l.deleted_at is null
    and l.published;
$$;

revoke all on function public.lot_public_page(uuid) from public, anon, authenticated;
grant execute on function public.lot_public_page(uuid) to service_role;

-- ---------------------------------------------------------------------------
-- Storage: public-lots bucket'ı
-- ---------------------------------------------------------------------------

insert into storage.buckets (id, name, public, file_size_limit, allowed_mime_types)
values ('public-lots', 'public-lots', false, 20971520, array['image/jpeg', 'application/pdf']);

-- ---------------------------------------------------------------------------
-- sync_push: şema sürümü 18
-- ---------------------------------------------------------------------------
-- Belge: 20261023164500_sync_push.sql. Tek fark desteklenen şema sürümleri.
create or replace function public.sync_push(
  changes jsonb,
  client_time timestamptz,
  schema_version integer
)
returns jsonb
language plpgsql
security invoker
set search_path = ''
as $$
declare
  supported_versions constant integer[] := array[1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18];
  -- İstemci saati sunucudan bundan fazla saparsa uyarı döner.
  max_clock_skew constant interval := interval '5 minutes';
  skew_seconds bigint;
  change jsonb;
  outcome jsonb;
  results jsonb := '[]'::jsonb;
begin
  if not coalesce(sync_push.schema_version = any (supported_versions), false) then
    raise exception 'Desteklenmeyen şema sürümü: %', sync_push.schema_version
      using errcode = 'PT426',
            detail = format('Desteklenen sürümler: %s', array_to_string(supported_versions, ', ')),
            hint = 'Uygulamayı güncelleyin';
  end if;
  if jsonb_typeof(sync_push.changes) is distinct from 'array' then
    raise exception 'changes bir dizi olmalı' using errcode = '22023';
  end if;
  if sync_push.client_time is null then
    raise exception 'client_time boş olamaz' using errcode = '22023';
  end if;

  for i in 0 .. jsonb_array_length(sync_push.changes) - 1 loop
    change := sync_push.changes -> i;
    begin
      outcome := jsonb_build_object(
        'id', change -> 'id',
        'status', 'ok',
        'applied', private.sync_push_change(
          change ->> 'table', change ->> 'operation', change -> 'payload'
        )
      );
    exception when others then
      -- Geçici hata: bütün paket geri alınır, istemci yeniden dener.
      if left(sqlstate, 2) in ('08', '40', '53', '57', '58') or sqlstate = '55P03' then
        raise;
      end if;
      outcome := jsonb_build_object(
        'id', change -> 'id',
        'status', 'rejected',
        'reason', case sqlstate
          when '42501' then 'forbidden'
          when '23505' then 'conflict'
          when '23503' then 'missing_reference'
          when '0A000' then 'unsupported'
          else 'invalid'
        end,
        'message', sqlerrm
      );
    end;
    results := results || jsonb_build_array(outcome);
  end loop;

  skew_seconds := round(extract(epoch from sync_push.client_time - now()));
  return jsonb_build_object(
    'results', results,
    'server_time', now(),
    'warning', case
      when abs(skew_seconds) > extract(epoch from max_clock_skew) then
        jsonb_build_object('code', 'clock_skew', 'skew_seconds', skew_seconds)
    end
  );
end;
$$;
