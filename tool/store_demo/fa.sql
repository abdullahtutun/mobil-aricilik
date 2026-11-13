-- Mağaza ekran görüntüleri: yerel demo işletmeyi Farsçaya çevirir. YALNIZ
-- YEREL DB'de, `seed demo`'dan hemen sonra
-- (`tool/store_screenshots.py --lang fa` kendisi çalıştırır). Para birimi
-- IRR, tutarlar yaklaşık riyal karşılığı (1 USD ≈ 1.000.000 IRR).

-- SQLite (PocketBase'in `pb_data/data.db`'si); tek transaction.

begin;

update organizations
set name = 'زنبورستان نمونه', currency = 'IRR', updated_at = strftime('%Y-%m-%dT%H:%M:%f', 'now') || '000Z'
where id = '01900000-0000-7000-8000-00000000de00';

with v (name_tr, name_fa, water_fa, notes_fa) as (values
  ('Yayla Arılığı', 'زنبورستان کوهستان', 'جوی آب، ۲۰۰ متر',
   'مرداد برای عسل کاج به کوهستان آوردیم.'),
  ('Kestane Arılığı', 'زنبورستان شاه‌بلوط', 'چشمه', ''),
  ('Köy Arılığı', 'زنبورستان روستا', 'منبع آب',
   'محل زمستان‌گذرانی؛ ملکه‌پروری اینجاست.')
)
update apiaries as a
set name = v.name_fa, water_source = v.water_fa, notes = v.notes_fa,
    updated_at = strftime('%Y-%m-%dT%H:%M:%f', 'now') || '000Z'
from v
where a.org_id = '01900000-0000-7000-8000-00000000de00' and a.name = v.name_tr;

update queens
set breed = case breed when 'Kafkas' then 'قفقازی'
                       when 'Anadolu' then 'آناتولی' else breed end,
    updated_at = strftime('%Y-%m-%dT%H:%M:%f', 'now') || '000Z'
where org_id = '01900000-0000-7000-8000-00000000de00';

with v (tr, fa) as (values
  ('Kışlık şurup kontrolü', 'بررسی شربت زمستانی'),
  ('5 numaralı kovanda ana arı kontrolü', 'بررسی ملکهٔ کندوی ۵'),
  ('Şeritleri çıkar', 'برداشتن نوارها'),
  ('Kovan altlıklarını temizle', 'تمیز کردن کف کندوها')
)
update tasks as t
set title = v.fa, updated_at = strftime('%Y-%m-%dT%H:%M:%f', 'now') || '000Z'
from v
where t.org_id = '01900000-0000-7000-8000-00000000de00' and t.title = v.tr;

with v (tr, fa, irr) as (values
  ('Çam balı, 162 kg', 'عسل کاج، ۱۶۲ کیلو', 1220000000),
  ('Kestane balı, 96 kg', 'عسل شاه‌بلوط، ۹۶ کیلو', 840000000),
  ('Şeker, 200 kg', 'شکر، ۲۰۰ کیلو', 155000000),
  ('Bayvarol, 2 kutu', 'بایوارول، ۲ جعبه', 36000000),
  ('Yaylaya nakliye', 'حمل به کوهستان', 245000000),
  ('Kestane arılığı yer kirası', 'اجارهٔ زمین زنبورستان شاه‌بلوط', 125000000)
)
update transactions as x
set description = v.fa, amount = v.irr, currency = 'IRR', updated_at = strftime('%Y-%m-%dT%H:%M:%f', 'now') || '000Z'
from v
where x.org_id = '01900000-0000-7000-8000-00000000de00' and x.description = v.tr;

commit;
