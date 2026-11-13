-- Mağaza ekran görüntüleri: yerel demo işletmeyi Rusçaya çevirir. YALNIZ
-- YEREL DB'de, `seed demo`'dan hemen sonra
-- (`tool/store_screenshots.py --lang ru` kendisi çalıştırır). Para birimi
-- RUB, tutarlar yaklaşık ruble karşılığı (1 TRY ≈ 2,2 RUB).

-- SQLite (PocketBase'in `pb_data/data.db`'si); tek transaction.

begin;

update organizations
set name = 'Демо пасека', currency = 'RUB', updated_at = strftime('%Y-%m-%dT%H:%M:%f', 'now') || '000Z'
where id = '01900000-0000-7000-8000-00000000de00';

with v (name_tr, name_ru, water_ru, notes_ru) as (values
  ('Yayla Arılığı', 'Горная пасека', 'Ручей, 200 м',
   'Привезли в августе к сезону соснового мёда.'),
  ('Kestane Arılığı', 'Каштановая пасека', 'Родник', ''),
  ('Köy Arılığı', 'Деревенская пасека', 'Бак с водой',
   'Зимовник; здесь выводим маток.')
)
update apiaries as a
set name = v.name_ru, water_source = v.water_ru, notes = v.notes_ru,
    updated_at = strftime('%Y-%m-%dT%H:%M:%f', 'now') || '000Z'
from v
where a.org_id = '01900000-0000-7000-8000-00000000de00' and a.name = v.name_tr;

update queens
set breed = case breed when 'Kafkas' then 'Кавказская'
                       when 'Anadolu' then 'Анатолийская' else breed end,
    updated_at = strftime('%Y-%m-%dT%H:%M:%f', 'now') || '000Z'
where org_id = '01900000-0000-7000-8000-00000000de00';

with v (tr, ru) as (values
  ('Kışlık şurup kontrolü', 'Проверить зимний сироп'),
  ('5 numaralı kovanda ana arı kontrolü', 'Проверить матку в улье 5'),
  ('Şeritleri çıkar', 'Снять полоски'),
  ('Kovan altlıklarını temizle', 'Почистить донья ульев')
)
update tasks as t
set title = v.ru, updated_at = strftime('%Y-%m-%dT%H:%M:%f', 'now') || '000Z'
from v
where t.org_id = '01900000-0000-7000-8000-00000000de00' and t.title = v.tr;

with v (tr, ru, rub) as (values
  ('Çam balı, 162 kg', 'Сосновый мёд, 162 кг', 107000),
  ('Kestane balı, 96 kg', 'Каштановый мёд, 96 кг', 74000),
  ('Şeker, 200 kg', 'Сахар, 200 кг', 13600),
  ('Bayvarol, 2 kutu', 'Байварол, 2 упаковки', 3200),
  ('Yaylaya nakliye', 'Перевозка на горную точку', 21500),
  ('Kestane arılığı yer kirası', 'Аренда точки, Каштановая пасека', 11000)
)
update transactions as x
set description = v.ru, amount = v.rub, currency = 'RUB', updated_at = strftime('%Y-%m-%dT%H:%M:%f', 'now') || '000Z'
from v
where x.org_id = '01900000-0000-7000-8000-00000000de00' and x.description = v.tr;

commit;
