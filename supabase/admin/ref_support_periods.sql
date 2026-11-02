-- Destek başvuru dönemleri (public.ref_support_periods) yönetimi.
--
-- Supabase panelinde SQL Editor'e yapıştırıp çalıştırın (ya da
-- `psql "$DATABASE_URL" -f supabase/admin/ref_support_periods.sql`).
-- Migration değildir; istendiği kadar yeniden çalıştırılabilir. Dönemler
-- senkronla telefonlara iner, uygulamada TR profilinde Daha fazla >
-- Destekler'de görünür.
--
-- Kurallar:
-- - Her dönemin kimliği sabittir. Yeni dönemde sıradaki numarayı verin;
--   var olan dönemi düzeltmek için aynı kimlikle yeniden çalıştırın.
-- - Başvuru başlangıç ve bitiş günleri dahildir; bitiş başlangıçtan önce
--   olamaz. Tarih biçimi YYYY-AA-GG.
-- - Açıklama ve kaynak linki boş bırakılabilir (null). Link http(s) ile
--   başlamalı.
-- - Başlangıç günü geldiğinde (09:00 TR) TR işletmelerinin owner ve
--   partner üyelerine bir kez push gider. Başlangıcı geçmiş ama bitmemiş
--   bir dönem eklerseniz bildirim ertesi sabah gider.
-- - Dönemi kaldırmak için satırı silmeyin; en alttaki gibi deleted_at
--   doldurun (silme telefonlara böyle ulaşır).

insert into public.ref_support_periods as p (
  id,
  name,
  application_starts_on,
  application_ends_on,
  description,
  source_url
)
select v.id::uuid, v.name, v.starts_on::date, v.ends_on::date, v.description, v.source_url
from (values
  -- Örnek; kendi dönemlerinizi bu biçimde ekleyin (satırın başındaki --
  -- işaretlerini kaldırın, değerleri değiştirin). Satırlar virgülle
  -- ayrılır; en sondaki boş satır kalabilir, hiçbir şey yazmaz.
  -- ('01900000-0000-7000-8000-000000000301',
  --  'Destek adı',
  --  '2027-01-15',
  --  '2027-02-15',
  --  'Kimler başvurabilir, gereken belgeler, nereye başvurulur.',
  --  'https://www.tarimorman.gov.tr/'),
  (null, null, null, null, null, null)
) as v (id, name, starts_on, ends_on, description, source_url)
where v.id is not null
on conflict (id) do update set
  name = excluded.name,
  application_starts_on = excluded.application_starts_on,
  application_ends_on = excluded.application_ends_on,
  description = excluded.description,
  source_url = excluded.source_url,
  updated_at = now(),
  deleted_at = null;

-- Dönemi kaldırma:
-- update public.ref_support_periods
-- set deleted_at = now(), updated_at = now()
-- where id = '01900000-0000-7000-8000-000000000301';

-- Liste:
-- select id, name, application_starts_on, application_ends_on, deleted_at
-- from public.ref_support_periods
-- order by application_starts_on;
