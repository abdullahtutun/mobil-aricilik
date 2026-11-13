-- Mağaza ekran görüntüleri: yerel demo işletmeyi Ukraynacaya çevirir. YALNIZ
-- YEREL DB'de, `seed demo`'dan hemen sonra
-- (`tool/store_screenshots.py --lang uk` kendisi çalıştırır). Para birimi
-- UAH, tutarlar yaklaşık hryvnia karşılığı (1 USD ≈ 41 UAH).

-- SQLite (PocketBase'in `pb_data/data.db`'si); tek transaction.

begin;

update organizations
set name = 'Демо пасіка', currency = 'UAH', updated_at = strftime('%Y-%m-%dT%H:%M:%f', 'now') || '000Z'
where id = '01900000-0000-7000-8000-00000000de00';

with v (name_tr, name_uk, water_uk, notes_uk) as (values
  ('Yayla Arılığı', 'Гірська пасіка', 'Струмок, 200 м',
   'Привезли в серпні на сосновий мед.'),
  ('Kestane Arılığı', 'Каштанова пасіка', 'Джерело', ''),
  ('Köy Arılığı', 'Сільська пасіка', 'Бак з водою',
   'Зимівник; тут виводимо маток.')
)
update apiaries as a
set name = v.name_uk, water_source = v.water_uk, notes = v.notes_uk,
    updated_at = strftime('%Y-%m-%dT%H:%M:%f', 'now') || '000Z'
from v
where a.org_id = '01900000-0000-7000-8000-00000000de00' and a.name = v.name_tr;

update queens
set breed = case breed when 'Kafkas' then 'Кавказька'
                       when 'Anadolu' then 'Анатолійська' else breed end,
    updated_at = strftime('%Y-%m-%dT%H:%M:%f', 'now') || '000Z'
where org_id = '01900000-0000-7000-8000-00000000de00';

with v (tr, uk) as (values
  ('Kışlık şurup kontrolü', 'Перевірити зимовий сироп'),
  ('5 numaralı kovanda ana arı kontrolü', 'Перевірити матку у вулику 5'),
  ('Şeritleri çıkar', 'Зняти смужки'),
  ('Kovan altlıklarını temizle', 'Почистити дна вуликів')
)
update tasks as t
set title = v.uk, updated_at = strftime('%Y-%m-%dT%H:%M:%f', 'now') || '000Z'
from v
where t.org_id = '01900000-0000-7000-8000-00000000de00' and t.title = v.tr;

with v (tr, uk, uah) as (values
  ('Çam balı, 162 kg', 'Сосновий мед, 162 кг', 50000),
  ('Kestane balı, 96 kg', 'Каштановий мед, 96 кг', 34500),
  ('Şeker, 200 kg', 'Цукор, 200 кг', 6400),
  ('Bayvarol, 2 kutu', 'Байварол, 2 упаковки', 1500),
  ('Yaylaya nakliye', 'Перевезення в гори', 10000),
  ('Kestane arılığı yer kirası', 'Оренда точки, Каштанова пасіка', 5100)
)
update transactions as x
set description = v.uk, amount = v.uah, currency = 'UAH', updated_at = strftime('%Y-%m-%dT%H:%M:%f', 'now') || '000Z'
from v
where x.org_id = '01900000-0000-7000-8000-00000000de00' and x.description = v.tr;

commit;
